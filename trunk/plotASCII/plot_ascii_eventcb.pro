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

PRO plot_ascii_file, event_load=event_load, main_event=main_event

  load_ascii_file, event_load=event_load, main_event=main_event
  PlotAsciiData, event_load=event_load, main_event=main_event
  
END

;==============================================================================
;This method parse the 1 column string array into 3 columns string array
PRO ParseDataStringArray, global, DataStringArray, Xarray, Yarray, SigmaYarray
  Nbr = N_ELEMENTS(DataStringArray)
  j=0
  i=0
  WHILE (i LE Nbr-1) DO BEGIN
    CASE j OF
      0: BEGIN
        Xarray[j]      = DataStringArray[i++]
        Yarray[j]      = DataStringArray[i++]
        SigmaYarray[j] = DataStringArray[i++]
      END
      ELSE: BEGIN
        Xarray      = [Xarray,DataStringArray[i++]]
        Yarray      = [Yarray,DataStringArray[i++]]
        SigmaYarray = [SigmaYarray,DataStringArray[i++]]
      END
    ENDCASE
    j++
  ENDWHILE
  
  (*(*global).Xarray_untouched) = Xarray
  ;remove last element of each array
  sz = N_ELEMENTS(Xarray)
  Xarray = Xarray[0:sz-2]
  Yarray = Yarray[0:sz-2]
  SigmaYarray = SigmaYarray[0:sz-2]
END

;------------------------------------------------------------------------------
PRO CleanUpData, Xarray, Yarray, SigmaYarray
  ;remove -Inf, Inf and NaN
  RealMinIndex = WHERE(FINITE(Yarray),nbr)
  IF (nbr GT 0) THEN BEGIN
    Xarray = Xarray(RealMinIndex)
    Yarray = Yarray(RealMinIndex)
    SigmaYarray = SigmaYarray(RealMinIndex)
  ENDIF
END

;------------------------------------------------------------------------------
FUNCTION get_list_of_input_file, Event, event_load=event_load, $
    main_event=main_event
    
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  load_table = (*global).load_table
  nbr_row = (size(load_table))(2)
  
  index = 0
  ascii_file = STRCOMPRESS(load_table[1,index],/REMOVE_ALL)
  list_ascii_file = [ascii_file]
  index++
  ascii_file = STRCOMPRESS(load_table[1,index],/REMOVE_ALL)
  WHILE (ascii_file NE '') DO BEGIN
    list_ascii_file = [list_ascii_file,ascii_file]
    index++
    ascii_file = STRCOMPRESS(load_table[1,index],/REMOVE_ALL)
  ENDWHILE
  
  RETURN, list_ascii_file
  
END

;------------------------------------------------------------------------------
;Load data
PRO load_ascii_file, event_load=event_load, main_event=main_event

  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  list_ascii_files = get_list_of_input_file(Event, event_load=event_load, $
    main_event=main_event)
  nbr_ascii = N_ELEMENTS(list_ascii_files)
  
  pXarray = (*(*global).pXarray)
  pYarray = (*(*global).pYarray)
  pSigmaYArray = (*(*global).pSigmaYArray)
  
  pXaxis = (*(*global).pXaxis)
  pXaxis_units = (*(*global).pXaxis_units)
  pYaxis = (*(*global).pYaxis)
  pYaxis_units = (*(*global).pYaxis_units)
  
  index = 0
  WHILE (index LT nbr_ascii) DO BEGIN
  
    iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', list_ascii_files[index])
    IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
      sAscii = iAsciiFile->getData()
      local_pXaxis = sAscii.xaxis
      local_pXaxis_units = sAscii.xaxis_units
      local_pYaxis = sAscii.yaxis
      local_pYaxis_units = sAscii.yaxis_units
      
      DataStringArray = *(*sAscii.data)[0].data
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
        
        *pXarray[index] = Xarray
        *pYarray[index] = Yarray
        *pSigmaYarray[index] = SigmaYarray
        
      ENDIF
      
      *pXaxis[index] = local_pXaxis
      *pXaxis_units[index] = local_pXaxis_units
      *pYaxis[index] = local_pYaxis
      *pYaxis_units[index] = local_pYaxis_units
      
    ENDIF
    
    OBJ_DESTROY, iAsciiFile
    
    index++
  ENDWHILE
  
  (*(*global).pXarray) = pXarray
  (*(*global).pYarray) = pYarray
  (*(*global).pSigmaYArray) = pSigmaYArray
  
  (*(*global).pXaxis) = pXaxis
  (*(*global).pXaxis_units) = pXaxis_units
  (*(*global).pYaxis) = pYaxis
  (*(*global).pYaxis_units) = pYaxis_units
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
END

;==============================================================================
;Plot Data in widget_draw
PRO plotAsciiData, event_load=event_load, main_event=main_event

  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  main_base_id = (*global).main_base
  
  draw_id = WIDGET_INFO(main_base_id, FIND_BY_UNAME='main_draw')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  WSET,view_plot_id
  
  DEVICE, DECOMPOSED = 1
  loadct,5,/SILENT
  
  pXarray      = (*(*global).pXarray)
  pYarray      = (*(*global).pYarray)
  pSigmaYarray = (*(*global).pSigmaYarray)
  
  pXaxis = (*(*global).pXaxis)
  pXaxis_units = (*(*global).pXaxis_units)
  pYaxis = (*(*global).pYaxis)
  pYaxis_units = (*(*global).pYaxis_units)
  
  list_ascii_files = get_list_of_input_file(Event, event_load=event_load, $
    main_event=main_event)
  nbr_ascii = N_ELEMENTS(list_ascii_files)
  
  ascii_color = (*global).ascii_color
  
  load_table = (*global).load_table
  activate_file_column = load_table[0,*]
  
  index = 0
  first_file_plotted_index  = 0  ;plot xaxis, yaxis for first plot only
  WHILE (index LT nbr_ascii) DO BEGIN
  
    IF (activate_file_column[index] EQ 'X') THEN BEGIN
    
      Xarray = *pXarray[index]
      Yarray = *pYarray[index]
      sigmaYarray = *pSigmaYarray[index]
      
      IF (first_file_plotted_index EQ 0) THEN BEGIN
      
        xAxis = *pXaxis[index]
        xAxis_units = *pXaxis_units[index]
        yAxis = *pYaxis[index]
        yAxis_units = *pYaxis_units[index]
        xLabel = xaxis + ' (' + xaxis_units + ')'
        yLabel = yaxis + ' (' + yaxis_units + ')'
        
      ENDIF
      
      CASE (isYaxisLin(Event)) OF
        'lin': yaxis = 'lin'
        'log': yaxis = 'log'
        ELSE: yaxis = (*global).lin_log_yaxis
      ENDCASE
      
      color = ascii_color[index]
      
      IF (first_file_plotted_index EQ 0) THEN BEGIN
        IF (yaxis EQ 'lin') THEN BEGIN
          plot, Xarray, $
            Yarray, $
            color=FSC_COLOR(color), $
            PSYM=2, $
            XTITLE=xLabel, $
            YTITLE=yLabel
        ENDIF ELSE BEGIN
          plot, Xarray, $
            Yarray, $
            color=FSC_COLOR(color), $
            PSYM=2, $
            /YLOG, $
            XTITLE=xLabel, $
            YTITLE=yLabel
        ENDELSE
        first_file_plotted_index++
      ENDIF ELSE BEGIN
        IF (yaxis EQ 'lin') THEN BEGIN
          OPLOT, Xarray, $
            Yarray, $
            color=FSC_COLOR(color), $
            PSYM=2
        ENDIF ELSE BEGIN
          plot, Xarray, $
            Yarray, $
            color=FSC_COLOR(color), $
            PSYM=2 
;            /YLOG, $
        ENDELSE
      ENDELSE
      errplot, Xarray,Yarray-SigmaYarray,Yarray+SigmaYarray,$
        color=FSC_COLOR(color)
        
    ENDIF ;end of if plot activated
    index++
  ENDWHILE
  
  IF (first_file_plotted_index EQ 0) THEN BEGIN
  ERASE
  ENDIF
  
  DEVICE, DECOMPOSED = 0
  
END
