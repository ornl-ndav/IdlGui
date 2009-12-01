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

FUNCTION  addTableToBigTable, Event, new_reduce_tab1_table

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  nbr_row = (*global).reduce_input_table_nbr_row
  nbr_column = (*global).reduce_input_table_nbr_column
  new_table = STRARR(nbr_column,nbr_row)
  
  nbr_row_loaded = (SIZE(new_reduce_tab1_table))(2)
  
  IF ((SIZE(new_reduce_tab1_table))(0) EQ 1) THEN BEGIN
    new_table[*,0] = new_reduce_tab1_table[*]
  ENDIF ELSE BEGIN
    index = 0
    WHILE (index LT nbr_row_loaded) DO BEGIN
      new_table[*,index] = new_reduce_tab1_table[*,index]
      index++
    ENDWHILE
  ENDELSE
  RETURN, new_table
  
END

;------------------------------------------------------------------------------
;this function parse for the '-' and return the sequence of numbers
FUNCTION ParseForDash, element
  resultDash  = STRSPLIT(element,'-',/EXTRACT,COUNT=nbr_dash)
  IF (nbr_dash GT 1) THEN BEGIN    ;there is 1 '-'
  
    LeftElement  = FIX(resultDash[0])
    RightElement = FIX(resultDash[1])
    
    MinElement = MIN([LeftElement,RightElement], MAX = MaxElement)
    
    step     = 1
    element  = MinElement
    sz_array = (MaxElement - MinElement + 1)
    array    = STRARR(sz_array)
    
    index = 0
    WHILE (element LE MaxElement) DO BEGIN
      array[index] = STRCOMPRESS(element,/REMOVE_ALL)
      element += step
      index ++
    ENDWHILE
    RETURN, array
    
  ENDIF ELSE BEGIN                ;no '-' found
    RETURN, [element]
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION RemoveDuplicate, BigArray

  SortBigArray = BigArray(SORT(BigArray))
  UniqBigArray = SortBigArray[UNIQ(SortBigArray)]
  
  RETURN, UniqBigArray
END

;------------------------------------------------------------------------------
;Parse the cw_field (ex: 1,2,4-6,8,9 -> 1,2,4,5,6,8,9)
FUNCTION ParseTextField, TextField

  ;check if there is more than 1 run loaded
  resultComma = STRSPLIT(TextField,',',/EXTRACT,COUNT=nbr_comma)
  resultDash  = STRSPLIT(TextField,'-',/EXTRACT,COUNT=nbr_dash)
  ;no ',' and no '-' found
  IF (nbr_comma + nbr_dash EQ 2) THEN RETURN, STRCOMPRESS(TextField,/REMOVE_ALL)
  
  sz_comma = N_ELEMENTS(resultComma)
  BigArray = ['']
  IF (sz_comma GT 1) THEN BEGIN ;there is at least 1 ','
    FOR i=0,(sz_comma-1) DO BEGIN
      DashList = ParseForDash(resultComma[i])
      BigArray = [BigArray,DashList]
    ENDFOR
  ENDIF ELSE BEGIN ;no ',' found
    BigArray = [ParseForDash(resultComma[0])]
  ENDELSE
  
  ;Make sure we don't have any duplicate
  UniqBigArray = RemoveDuplicate(BigArray)
  
  ;remove '' element (first place) if it's here
  emptyElement   = STRMATCH(UniqBigArray,'')
  ResultArray    = WHERE(emptyElement EQ 0)
  NewResultArray = UniqBigArray[ResultArray]
  ;sort using numbers
  SortArray = NewResultArray[SORT(FIX(NewResultArray))]
  
  RETURN, SortArray
END

;------------------------------------------------------------------------------
;This function searches for the polarization state given as input in
;the nexus_file_name given and return 1 if it has been found, 0 otherwise.
FUNCTION stateFoundInThisNexus, nexus_file_name, selected_pola_state
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
  ENDIF ELSE BEGIN
    iNexus = OBJ_NEW('IDLgetMetadata', nexus_file_name, selected_pola_state)
    IF (OBJ_VALID(iNexus)) THEN BEGIN
      result = 1
      OBJ_DESTROY, iNexus
    ENDIF ELSE BEGIN
      result = 0
    ENDELSE
  ENDELSE
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION check_IF_pola_states_are_there, SOURCE    = source,$
    REFERENCE = reference
    
  sz = N_ELEMENTS(SOURCE)
  result = INTARR(sz)
  index = 0
  WHILE (index LT sz) DO BEGIN
    IF (WHERE(SOURCE[index] EQ REFERENCE) NE -1) THEN BEGIN
      result[index] = 1
    ENDIF
    index++
  ENDWHILE
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION retrieve_list_OF_polarization_state, Event, $
    nexus_file_name, $
    PolaList
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  LogText = '-> Retrieve list of polarization states for first NeXus file ' + $
    ' (' + STRCOMPRESS(nexus_file_name,/REMOVE_ALL) + ') ... ' + $
    PROCESSING
  IDLsendToGeek_addLogBookText, Event, LogText
  iPola = OBJ_NEW('IDLnexusUtilities',nexus_file_name)
  
  IF (OBJ_VALID(iPola) NE 1) THEN BEGIN ;obj not valid
    message = FAILED + '  (Format of file not supported by' + $
      ' this application).'
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, message
    RETURN, 0
  ENDIF
  
  ;display list of polarization states found
  IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
  pPolaList = iPola->getPolarization()
  PolaList = *pPolaList
  sz = N_ELEMENTS(PolaList)
  LogText = '--> Number of polarization states found: ' + $
    STRCOMPRESS(sz,/REMOVE_ALL) + ' ('
  index = 0
  WHILE (index LT sz) DO BEGIN
    IF (index NE 0) THEN LogText += ' , '
    LogText += PolaList[index]
    ++index
  ENDWHILE
  LogText += ')'
  IDLsendToGeek_addLogBookText, Event, LogText
  
  ;list of polarization states from global (reference)
  NexusListOfPola = (*global).nexus_list_OF_pola_state
  
  ;check which pola states are in the file
  LogText = '--> Checking the polarization states found in the file:'
  IDLsendToGeek_addLogBookText, Event, LogText
  pola_state_there = check_IF_pola_states_are_there(SOURCE = PolaList,$
    REFERENCE = NexusListOfPola)
  sz = N_ELEMENTS(NexusListOfPola)
  FOR i=0,(sz-1) DO BEGIN
    LogText= "     " + NexusListOfPola[i]
    IF (pola_state_there[i]) THEN BEGIN
      LogText += " -> FOUND"
    ENDIF ELSE BEGIN
      LogText += " -> NOT FOUND"
    ENDELSE
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDFOR
  
  ;enables the pola states that are there
  ;from pola base
  activate_widget, Event, 'reduce_tab1_pola_base_pola_1', pola_state_there[0]
  activate_widget, Event, 'reduce_tab1_pola_base_pola_2', pola_state_there[1]
  activate_widget, Event, 'reduce_tab1_pola_base_pola_3', pola_state_there[2]
  activate_widget, Event, 'reduce_tab1_pola_base_pola_4', pola_state_there[3]
  
  ;from reduce_tab1_base
  activate_widget, Event, 'reduce_tab1_pola_1', pola_state_there[0]
  activate_widget, Event, 'reduce_tab1_pola_2', pola_state_there[1]
  activate_widget, Event, 'reduce_tab1_pola_3', pola_state_there[2]
  activate_widget, Event, 'reduce_tab1_pola_4', pola_state_there[3]
  
  ;select the first state in the file as the default file
  IndexNoneZero = WHERE(pola_state_there EQ 1, nbr)
  list_OF_uname = ['reduce_tab1_pola_base_pola_1',$
    'reduce_tab1_pola_base_pola_2',$
    'reduce_tab1_pola_base_pola_3',$
    'reduce_tab1_pola_base_pola_4']
  IF (nbr GT 0) THEN BEGIN
    id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=list_OF_uname[IndexNoneZero[0]])
    WIDGET_CONTROL, id, /SET_BUTTON
    LogText = '--> Default Polarization State Selected: ' + $
      NexusListOfPola[IndexNoneZero[0]]
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDIF
  
  ;bring to life base that ask the user to select the polarization state
  MapBase, Event, 'reduce_tab1_polarization_base', 1
  activate_widget, Event, 'reduce_step1_tab_base', 0
  
  LogText = '-> <USERS> Waiting for Selection of Working Polarization ' + $
    'State from User.'
  IDLsendToGeek_addLogBookText, Event, LogText
  
  RETURN, 1
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;This function populates the big table and also retrieves the sangle value
;for the REF_M instrument
PRO AddNexusToReduceTab1Table, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  instrument = (*global).instrument
  IF (instrument EQ 'REF_M') THEN BEGIN
    reduce_tab1_working_pola_state = '/entry-Off_Off/'
  ENDIF ELSE BEGIN
    reduce_tab1_working_pola_state = '/entry/'
  ENDELSE
  reduce_tab1_table = (*(*global).reduce_tab1_table)
  run_sangle_table  = (*(*global).reduce_run_sangle_table)
  nexus_file_list   = (*(*global).reduce_tab1_nexus_file_list)
  
  sz = N_ELEMENTS(nexus_file_list)
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    ;retrieve RunNumber of nexus file name
    iNexus = OBJ_NEW('IDLgetMetadata', $
      nexus_file_list[index],$
      reduce_tab1_working_pola_state)
    IF (~OBJ_VALID(iNexus)) THEN BEGIN
      index ++
      CONTINUE
    ENDIF
    RunNumber = iNexus->getRunNumber()
    IF (instrument EQ 'REF_M') THEN BEGIN
      sangle_rad    = iNexus->getSangle()
      sangle_deg    = convert_to_deg(sangle_rad)
      sangle = STRCOMPRESS(sangle_rad,/REMOVE_ALL) + ' (' + $
      STRCOMPRESS(sangle_deg,/REMOVE_ALL) + ')'
    ENDIF
    OBJ_DESTROY, iNexus
    
    ;check if it's the first time we add NeXus files (file name is empty)
    IF (reduce_tab1_table[1,0] EQ '') THEN BEGIN
      reduce_tab1_table[0,0] = STRCOMPRESS(RunNumber,/REMOVE_ALL)
      reduce_tab1_table[1,0] = nexus_file_list[index]
      IF (instrument EQ 'REF_M') THEN BEGIN
        run_sangle_table[0,0] = STRCOMPRESS(RunNumber,/REMOVE_ALL)
        run_sangle_table[1,0] = sangle
      ENDIF
    ENDIF ELSE BEGIN
      sz1 = N_ELEMENTS(reduce_tab1_table)
      reduce_tab1_table = REFORM(reduce_tab1_table,sz1,/OVERWRITE)
      tmp_table = STRARR(2,1)
      tmp_table[0,0] = STRCOMPRESS(RunNumber,/REMOVE_ALL)
      tmp_table[1,0] = nexus_file_list[index]
      reduce_tab1_table = [reduce_tab1_table,tmp_table]
      IF (instrument EQ 'REF_M') THEN BEGIN
        sz1 = N_ELEMENTS(run_sangle_table)
        run_sangle_table = REFORM(run_sangle_table,sz1,/OVERWRITE)
        tmp_table = STRARR(2,1)
        tmp_table[0,0] = STRCOMPRESS(RunNumber,/REMOVE_ALL)
        tmp_table[1,0] = sangle
        run_sangle_table = [run_sangle_table,tmp_table]
      ENDIF
      
    ENDELSE
    
    index++
  ENDWHILE
  
  x = 2
  y = N_ELEMENTS(reduce_tab1_table)/2
  
  reduce_tab1_table = REFORM(reduce_tab1_table,x,y,/OVERWRITE)
  IF (instrument EQ 'REF_M') THEN BEGIN
    y = N_ELEMENTS(run_sangle_table)/2
    run_sangle_table = REFORM(run_sangle_table,x,y,/OVERWRITE)
  ENDIF
  
  sz = (SIZE(reduce_tab1_table))(2)
  IF (sz GT 1) THEN BEGIN
  
    ;check that there are no duplicates
    New_Reduce_tab1_table = $
      uniq_element_table(INPUT_TABLE = reduce_tab1_table,$
      COL = 0)
    new_table = addTableToBigTable(Event, new_reduce_tab1_table)
    
  ENDIF ELSE BEGIN
  
    new_table = addTableToBigTable(Event, reduce_tab1_table)
    
  ENDELSE
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_tab1_table_uname')
  WIDGET_CONTROL, id, SET_VALUE = new_table
  
  IF (instrument EQ 'REF_M') THEN BEGIN
    ;check that there is no duplicates of the sangle table as well
    sz = (SIZE(run_sangle_table))(2)
    IF (sz GT 1) THEN BEGIN
      new_run_sangle_table = $
        uniq_element_table(INPUT_TABLE = run_sangle_table,$
        COL = 0)
      run_sangle_table = new_run_sangle_table
    ENDIF
  ENDIF
  
  (*(*global).reduce_tab1_table) = new_table
  (*(*global).reduce_run_sangle_table) = run_sangle_table
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_tab_table_uname')
  WIDGET_CONTROL, id, SET_VALUE = run_sangle_table
  
END

;------------------------------------------------------------------------------
;This function is reached by the OK button of the polarization base
PRO update_polarization_states_widgets, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  list_OF_uname = ['reduce_tab1_pola_base_pola_1',$
    'reduce_tab1_pola_base_pola_2',$
    'reduce_tab1_pola_base_pola_3',$
    'reduce_tab1_pola_base_pola_4']
  sz = N_ELEMENTS(list_OF_uname)
  FOR i=0,(sz-1) DO BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=list_OF_uname[i])
    IF (WIDGET_INFO(id, /BUTTON_SET) EQ 1) THEN BREAK
  ENDFOR
  
  ;list of polarization states from global (reference)
  NexusListOfPola = (*global).nexus_list_OF_pola_state
  LogText = '--> Working Polarization State Selected by User: ' + $
    NexusListOfPola[i]
  IDLsendToGeek_addLogBookText, Event, LogText
  
  putTextFieldValue, Event, $
    'reduce_tab1_working_polarization_state_label',$
    STRCOMPRESS(NexusListOfPola[i],/REMOVE_ALL)
    
  ;save the polarization state selected
  (*global).reduce_tab1_working_pola_state = NexusListOfPola[i]
  
  list_OF_main_base_uname = ['reduce_tab1_pola_1',$
    'reduce_tab1_pola_2',$
    'reduce_tab1_pola_3',$
    'reduce_tab1_pola_4']
  activate_widget, Event, list_OF_main_base_uname[i], 0
  
  IDLsendToGeek_addLogBookText, Event, ''
  
END

;------------------------------------------------------------------------------
PRO reduce_tab1_browse_button, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  path  = (*global).browsing_path
  title = 'Select 1 or several NeXus file'
  default_extenstion = '.nxs'
  
  LogText = '> Browsing for NeXus file in Reduce/step1:'
  IDLsendToGeek_addLogBookText, Event, LogText
  
  nexus_file_list = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
    FILTER = ['*.nxs'],$
    GET_PATH = new_path,$
    /MULTIPLE_FILES,$
    /MUST_EXIST,$
    PATH = path,$
    TITLE = title)
    
  IF (nexus_file_list[0] NE '') THEN BEGIN
  
    (*(*global).reduce_tab1_nexus_file_list) = nexus_file_list
    
    IF (new_path NE path) THEN BEGIN
      (*global).browsing_path = new_path
      LogText = '-> New browsing_path is: ' + new_path
    ENDIF
    IDLsendToGeek_addLogBookText, Event, LogText
    display_message_about_files_browsed, Event, nexus_file_list
    
    ;      IF ((*global).reduce_tab1_working_pola_state EQ '') THEN BEGIN
    ;        ;get list of polarization state available and display list_of_pola base
    ;        nexus_file_name = nexus_file_list[0]
    ;        status = retrieve_list_OF_polarization_state(Event, $
    ;          nexus_file_name, $
    ;          list_OF_pola_state)
    ;        IF (status EQ 0) THEN RETURN
    
    ;update the table
    AddNexusToReduceTab1Table, Event
    
  ENDIF ELSE BEGIN
    LogText = '-> User canceled Browsing for NeXus file'
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO display_message_about_files_browsed, Event, nexus_file_list

  nbr_files = N_ELEMENTS(nexus_file_list)
  LogText = '-> Nbr Files Browsed: ' + STRCOMPRESS(nbr_files,/REMOVE_ALL)
  IDLsendToGeek_addLogBookText, Event, LogText
  
  LogText = '-> List of Files: '
  IDLsendToGeek_addLogBookText, Event, LogText
  
  index = 0
  WHILE (index LT nbr_files) DO BEGIN
    LogText = '    ' + nexus_file_list[index]
    IDLsendToGeek_addLogBookText, Event, LogText
    ++index
  ENDWHILE
  
END

;------------------------------------------------------------------------------
PRO check_reduce_step1_gui, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  reduce_tab1_table = (*(*global).reduce_tab1_table)
  IF (reduce_tab1_table[1] EQ '') THEN BEGIN
    sensitive_status = 0
  ENDIF ELSE BEGIN
    sensitive_status = 1
  ENDELSE
  
  uname_list = ['reduce_step1_remove_selection_button',$
    'reduce_step1_display_y_vs_tof_button',$
    'reduce_step1_display_y_vs_x_button']
  activate_widget_list, Event, uname_list, sensitive_status
  
END

;------------------------------------------------------------------------------
PRO select_full_line, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_tab1_table_uname')
  TableSelection = WIDGET_INFO(id, /TABLE_SELECT)
  RowSelected    = TableSelection[1]
  WIDGET_CONTROL, id, SET_TABLE_SELECT = [0,RowSelected,1,RowSelected]
  
END

;------------------------------------------------------------------------------
PRO reduce_tab1_run_cw_field, Event ;_reduce_step1

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  WIDGET_CONTROL, /HOURGLASS
  
  ;get text contain
  TextField = getTextFieldValue(Event,'reduce_tab1_run_cw_field')
  
  ;stop now if there is nothing to do
  IF (STRCOMPRESS(TextField,/REMOVE_ALL) EQ '') THEN BEGIN
    WIDGET_CONTROL, HOURGLASS = 0
    RETURN
  ENDIF
  
  ;display list of runs
  LogText = '> Run or List of Runs entered by user: ' + TextField
  IDLsendToGeek_addLogBookText, Event, LogText
  
  ;retrieve list of runs
  ListOfRuns = ParseTextField(TextField)
  
  ;list of runs after parsing
  LogText = '-> Run or List of Runs after Parsing: ' + STRJOIN(ListOfRuns,',')
  IDLsendToGeek_addLogBookText, Event, LogText
  
  ;    ;get proposal selected by user (from droplist)
  ;    proposalSelected = getComboListSelectedValue(Event, $
  ;      'reduce_tab1_list_of_proposal')
  ;    LogText = '-> Proposal Folder Selected: ' + proposalSelected
  ;    IDLsendToGeek_addLogBookText, Event, LogText
  
  ;get full nexus file name for the runs loaded
  LogText = '-> Retrieve List of Full NeXus File Names:'
  IDLsendToGeek_addLogBookText, Event, LogText
  nbr_runs = N_ELEMENTS(ListOfRuns)
  index    = 0
  nexus_file_list = STRARR(nbr_runs)
  WHILE (index LT nbr_runs) DO BEGIN
    full_nexus_name = findnexus(Event,$
      RUN_NUMBER = ListOfRuns[index],$
      INSTRUMENT = (*global).instrument,$
      ;        PROPOSAL   = proposalSelected,$
      isNexusExist)
    LogText = '-> Run #: ' + ListOfRuns[index]
    IF (isNexusExist) THEN BEGIN
      LogText += ' => ' + full_nexus_name
      nexus_file_list[index] = full_nexus_name
    ENDIF ELSE BEGIN
      LogText += ' => NeXus file not FOUND !'
    ENDELSE
    IDLsendToGeek_addLogBookText, Event, LogText
    index++
  ENDWHILE
  
  ;remove the runs not found by STRJOIN with ',' and STRPLIT with ','
  ;after removing blank spaces
  
  form1 = STRJOIN(nexus_file_list,',')
  form2 = STRCOMPRESS(form1,/REMOVE_ALL)
  nexus_file_list = STRSPLIT(form2,',',/EXTRACT)
  
  (*(*global).reduce_tab1_nexus_file_list) = nexus_file_list
  
  ;    IF ((*global).reduce_tab1_working_pola_state EQ '') THEN BEGIN
  ;      ;get list of polarization state available and display list_of_pola base
  ;      nexus_file_name = nexus_file_list[0]
  ;      status = retrieve_list_OF_polarization_state(Event, $
  ;        nexus_file_name, $
  ;        list_OF_pola_state)
  ;    ENDIF ELSE BEGIN
  ;
  ;update the table
  AddNexusToReduceTab1Table, Event
  ;
  ;    ENDELSE
  
  ;clear the cw_field
  putTextFieldValue, Event, 'reduce_tab1_run_cw_field', ''
  
  WIDGET_CONTROL, HOURGLASS = 0
  
END

;----------------------------------------------------------------------------
FUNCTION remove_row_selected_from_array, Event, TABLE=table, ROW=row

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  nbr_row = (*global).reduce_input_table_nbr_row
  nbr_column = (*global).reduce_input_table_nbr_column
  
  new_table = STRARR(nbr_column, nbr_row)
  
  index = 0
  for i=0,(nbr_row-1) do begin
    if (i NE (row)) THEN BEGIN
      new_table[*,index] = table[*,i]
      index++
    ENDIF
  ENDFOR
  RETURN, new_table
  
END

;----------------------------------------------------------------------------
FUNCTION remove_row_selected_from_array_general, Event, TABLE=table, ROW=row

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  sz = size(table)
  nbr_row = sz[2]
  nbr_column = sz[1]
  
  new_table = STRARR(nbr_column, nbr_row)
  index = 0
  for i=0,(nbr_row-1) do begin
    if (i NE (row)) THEN BEGIN
      new_table[*,index] = table[*,i]
      index++
    ENDIF
  ENDFOR
  RETURN, new_table
  
END

;--------------------------------------------------------------------------
PRO remove_selected_run, Event

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  row_selected = getTableRowSelected(Event,'reduce_tab1_table_uname')
  reduce_tab1_table = (*(*global).reduce_tab1_table)
  nbr_row = (SIZE(reduce_tab1_table))(2)
  
  new_table = remove_row_selected_from_array(Event, $
    TABLE=reduce_tab1_table, $
    ROW=row_selected)
  
  run_sangle_table = (*(*global).reduce_run_sangle_table)
  new_run_sangle_table = remove_row_selected_from_array_general(Event, $
  TABLE=run_sangle_table, $
  ROW=row_selected)
  (*(*global).reduce_run_sangle_table) = new_run_sangle_table  
    
  IF (new_table[0,0] EQ '') THEN BEGIN
    (*global).reduce_tab1_working_pola_state = ''
  ENDIF
  
  putTableValue, Event, new_table, 'reduce_tab1_table_uname'
  (*(*global).reduce_tab1_table) = new_table
  
  ;check if delete row can be disabled
  check_status_of_reduce_step1_buttons, Event
  
END



