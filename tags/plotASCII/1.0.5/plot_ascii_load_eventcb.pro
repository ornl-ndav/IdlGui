;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================
PRO browse_button, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_load
  global = (*global_load).global
  
  path = (*global).path
  filter = [['*combined.txt','*.txt','*.dat']]
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_load_base_uname')
  title = 'Select ASCII file(s) to load'
  
  file_list = DIALOG_PICKFILE(/READ,$
    FILTER = filter,$
    PATH = path,$
    DIALOG_PARENT = widget_id, $
    GET_PATH = new_path, $
    /MULTIPLE_FILES, $
    /MUST_EXIST, $
    TITLE = title)
    
  IF (file_list[0] NE '') THEN BEGIN
    (*global).path = new_path
    
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/HOURGLASS
    
    nbr_file_loaded = N_ELEMENTS(file_list)
    FOR i=0,(nbr_file_loaded-1) DO BEGIN
      retrieve_data_of_new_file, file_list[i], $
        Event_load=event, $
        sData=sData, $
        type=type, $
        result=result
      if (result) then begin
        add_new_data_to_big_array, event_load=event, $
          sData=sData, $
          type=type
        get_initial_plot_range, event_load=event
        plotAsciiData, event_load=event
      endif else begin
      ;failed somewhere
      endelse
    ENDFOR
    
    WIDGET_CONTROL, HOURGLASS=0
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO add_new_data_to_big_array, event_load=event_load, $
    sData=sData, $
    type=type
    
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif
  
  WIDGET_CONTROL, event_load.top, GET_UVALUE=global_load
  global = (*global_load).global
  
  pXarray      = (*(*global).pXarray)
  pYarray      = (*(*global).pYarray)
  pSigmaYArray = (*(*global).pSigmaYArray)
  
  pXaxis       = (*(*global).pXaxis)
  pXaxis_units = (*(*global).pXaxis_units)
  pYaxis       = (*(*global).pYaxis)
  pYaxis_units = (*(*global).pYaxis_units)
  
  first_empty_index = getFirstEmptyXarrayIndex(event_load=event_load)
  
  load_table = getTableValue(event_load=event_load, $
    'plot_ascii_load_base_table')
    
  local_pXaxis       = sData.xaxis
  local_pXaxis_units = sData.xaxis_units
  local_pYaxis       = sData.yaxis
  local_pYaxis_units = sData.yaxis_units
  
  IF (type EQ 'single_ascii') THEN BEGIN
  
    DataStringArray = *(*sData.data)[0].data
    ;this method will creates a 3 columns array (x,y,sigma_y)
    Nbr = N_ELEMENTS(DataStringArray)
    IF (Nbr GT 1) THEN BEGIN
    
      Xarray      = STRARR(1)
      Yarray      = STRARR(1)
      SigmaYarray = STRARR(1)
      ParseDataStringArray, global, $
        DataStringArray,$
        Xarray,$
        Yarray,$
        SigmaYarray
      ;Remove all rows with NaN, -inf, +inf ...
      CleanUpData, Xarray, Yarray, SigmaYarray
      ;Change format of array (string -> float)
      Xarray      = FLOAT(Xarray)
      Yarray      = FLOAT(Yarray)
      SigmaYarray = FLOAT(SigmaYarray)
      
      *pXarray[first_empty_index]      = Xarray
      *pYarray[first_empty_index]      = Yarray
      *pSigmaYarray[first_empty_index] = SigmaYarray
      
      load_table[0,first_empty_index] = 'X'
      filename = FILE_BASENAME(sData.filename)
      load_table[1,first_empty_index] =  filename
      
    ENDIF
    
  ENDIF ELSE BEGIN ;REFscale ascii file format
  
    ;how many set of data we need to save
    ArrayTitle = sData.ArrayTitle
    if ((size(arrayTitle))[0] eq 2) then begin
      nbr_files = (size(ArrayTitle))(2)
    endif else begin
      nbr_files = 1
    endelse
    
    index = first_empty_index
    local_index = 0
    
    WHILE (index LT (nbr_files+first_empty_index)) DO BEGIN
    
      Xarray = *sData.pxaxis[local_index]
      Yarray = *sData.pyaxis[local_index]
      SigmaYarray = *sData.pSigmaYaxis[local_index]
      
      *pXarray[index] = Xarray
      *pYarray[index] = Yarray
      *pSigmaYarray[index] = SigmaYarray
      
      load_table[0,index] = 'X'
      local_file_name = sData.ArrayTitle[0,local_index]
      local_angle     = sData.ArrayTitle[1,local_index]
      filename = FILE_BASENAME(sData.filename)
      local_filename = get_local_filename(local_file_name)
      value = filename + ' (' + local_filename + ' -> ' + $
        local_angle + ' )'
      load_table[1,index] = value
      
      index++
      local_index++
      
    ENDWHILE
    
  ENDELSE
  
  *pXaxis[first_empty_index]       = local_pXaxis
  *pXaxis_units[first_empty_index] = local_pXaxis_units
  *pYaxis[first_empty_index]       = local_pYaxis
  *pYaxis_units[first_empty_index] = local_pYaxis_units
  
  (*(*global).pXaxis) = pXaxis
  (*(*global).pXaxis_units) = pXaxis_units
  (*(*global).pYaxis) = pYaxis
  (*(*global).pYaxis_units) = pYaxis_units
  
  (*(*global).pXarray) = pXarray
  (*(*global).pYarray) = pYarray
  (*(*global).pSigmaYArray) = pSigmaYarray
  
  putValueInTable, event_load, 'plot_ascii_load_base_table', load_table
  (*global).load_table = load_table
  
END

;------------------------------------------------------------------------------
PRO retrieve_data_of_new_file, new_file, $
    event_load=event_load, $
    main_event=main_event,  $
    sdata=sdata, $
    type=type, $
    result=result ;either single_ascii or REFscale
    
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  ;pXarray_new      = (*(*global).pXarray_new)
  ;pYarray_new      = (*(*global).pYarray_new)
  ;pSigmaYArray_new = (*(*global).pSigmaYArray_new)
  
  ;pXaxis_new       = (*(*global).pXaxis_new)
  ;pXaxis_units_new = (*(*global).pXaxis_units_new)
  ;pYaxis_new       = (*(*global).pYaxis_new)
  ;pYaxis_units_new = (*(*global).pYaxis_units_new)
  
  type = '' ;'single_ascii' or 'REFscale'
  ;try to create instance of single ascii file
  iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', new_file)
  IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
    error = 0
    sData = iAsciiFile->getData(error)
    
    ;help, sData, /structure
    ;// sData is a structure
    ;    FileName            string     ''
    ;    xaxis               string     ''
    ;    xaxis_units         string     ''
    ;    yaxis               string     ''
    ;    yaxis_units         string     ''
    ;    sigma_yaxis         string     ''
    ;    sigma_yaxis_units   string     ''
    ;    data                pointer
    ;help, *sData.data, /structure
    ;//   bank     string    ''
    ;     x        string    ''
    ;     y        string    ''
    ;     data     pointer
    
    IF (error NE 0) THEN BEGIN
      type = ''
    ENDIF ELSE BEGIN
      type = 'single_ascii'
    ENDELSE
    OBJ_DESTROY, iAsciiFile
    result = 1
  ENDIF else begin
    result = 0
    return
  endelse
  
  ;try multi ascii file if single ascii file failed
  IF (type EQ '') THEN BEGIN
    iAsciiFile = OBJ_NEW('IDL3columnsASCIIparserREFscale', new_file)
    IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
      type = 'REFscale'
      sData = iAsciiFile->getDataQuickly()
      
      ; help, sData, /structure
      ;// sData is a structure
      ;    ArrayTitle         string    Array[2,nbr_file]
      ;    xaxis              string    'scalar wavevector transfer'
      ;    xaxis_units        string    '1/Angstroms'
      ;    yaxis              string    'Intensity'
      ;    yaxis_units        string    'counts'
      ;    sigma_yaxis        string    'sigma'
      ;    sigma_yaxis_units  string    ''
      ;    pxaxis             pointer   array[nbr_file]
      ;    pyaxis             pointer   array[nbr_file]
      ;    pSigmaYaxis        pointer   array[nbr_file]
      ;//
      ; help, *sData.pxaxis[0]  ->   float    = Array[52]
      
      OBJ_DESTROY, iAsciiFile
      
    ENDIF
  ENDIF
  
END

;..............................................................................
PRO populate_load_table, Event, new_file_list
  WIDGET_CONTROL, Event.top, GET_UVALUE=global_load
  
  global = (*global_load).global
  ;ascii_file_list = (*global).ascii_file_list
  ;dim_y = N_ELEMENTS(ascii_file_list) ;50 for now
  load_table = (*global).load_table
  nbr_new_files = N_ELEMENTS(new_file_list)
  
  index = 0
  index_table = get_first_empty_table_index(load_table)
  IF (index_table EQ -1) THEN RETURN
  WHILE(index LT nbr_new_files) DO BEGIN
    file = new_file_list[index]
    IF (STRCOMPRESS(file,/REMOVE_ALL) EQ '') THEN BREAK
    load_table[0,index_table] = 'X'
    load_table[1,index_table] = file
    index++
    index_table++
  ENDWHILE
  (*global).load_table = load_table
  putValueInTable, Event, 'plot_ascii_load_base_table', load_table
END

;------------------------------------------------------------------------------
PRO select_full_row, Event

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_load_base_table')
  selection = WIDGET_INFO(id, /TABLE_SELECT)
  row_selected = selection[1]
  left_top_view = WIDGET_INFO(id, /TABLE_VIEW)
  
  WIDGET_CONTROL, id, SET_TABLE_SELECT=[0,row_selected, 1, row_selected]
  WIDGET_CONTROL, id, SET_TABLE_VIEW=left_top_view
  
END

;------------------------------------------------------------------------------
PRO trigger_status_column, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_load
  global = (*global_load).global
  
  load_table = getTableValue(event_load=event, $
    'plot_ascii_load_base_table')
    
  top_sel = Event.sel_top
  bottom_sel = Event.sel_bottom
  IF (top_sel EQ -1) THEN RETURN ;if click (not release), return
  IF (top_sel NE bottom_sel) THEN RETURN ;if user selected a region, return
  IF (load_table[1,top_sel] EQ '') THEN RETURN ;if no file at this line, return
  
  status_of_row = load_table[0,top_sel]
  IF (status_of_row EQ 'X') THEN BEGIN
    load_table[0,top_sel] = ''
  ENDIF ELSE BEGIN
    load_table[0,top_sel] = 'X'
  ENDELSE
  putValueInTable, Event, 'plot_ascii_load_base_table', load_table
  (*global).load_table = load_table
  
END

;------------------------------------------------------------------------------
PRO delete_plot_ascii_load_selected_row, Event

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_load_base_table')
  selection = WIDGET_INFO(id, /TABLE_SELECT)
  row_selected = selection[1]
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global_load
  global     = (*global_load).global
  load_table = (*global).load_table
  
  pXarray      = (*(*global).pXarray)
  pYarray      = (*(*global).pYarray)
  pSigmaYarray = (*(*global).pSigmaYArray)
  
  nbr_row = (size(load_table))(2)
  pXarray_new      = PTRARR(nbr_row,/AlLOCATE_HEAP)
  pYarray_new      = PTRARR(nbr_row,/AlLOCATE_HEAP)
  pSigmaYarray_new = PTRARR(nbr_row,/AlLOCATE_HEAP)
  
  new_load_table = STRARR(2,nbr_row)
  new_i = 0
  FOR i=0,(nbr_row-1) DO BEGIN
    IF (i NE row_selected) THEN BEGIN
      new_load_table[0,new_i] = load_table[0,i]
      new_load_table[1,new_i] = load_table[1,i]
      IF (load_table[1,i] EQ '') THEN BREAK
      value = *pXarray[i]
      *pXarray_new[new_i] = value
      *pYarray_new[new_i] = *pYarray[i]
      *pSigmaYarray_new[new_i] = *pSigmaYarray[i]
      new_i++
    ENDIF
  ENDFOR
  
  (*global).load_table = new_load_table
  putValueInTable, Event, 'plot_ascii_load_base_table', new_load_table
  
  (*(*global).pXarray)      = pXarray_new
  (*(*global).pYarray)      = pYarray_new
  (*(*global).pSigmaYArray) = pSigmaYarray_new
  
END