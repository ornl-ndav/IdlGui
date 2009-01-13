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

;This function searches for the polarization state given as input in
;the nexus_file_name given and return 1 if it has been found, 0 otherwise.
FUNCTION stateFoundInThisNexus, nexus_file_name, selected_pola_state
no_error = 0
CATCH, no_error 
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    return, 0
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
;This function populates the big table
PRO AddNexusToReduceTab1Table, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

reduce_tab1_working_pola_state = (*global).reduce_tab1_working_pola_state
reduce_tab1_table = (*(*global).reduce_tab1_table)
nexus_file_list = (*(*global).reduce_tab1_nexus_file_list)

sz = N_ELEMENTS(nexus_file_list)
index = 0
WHILE (index LT sz) DO BEGIN

;retrieve RunNumber of nexus file name
    iNexus = OBJ_NEW('IDLgetMetadata', $
                     nexus_file_list[index],$
                     reduce_tab1_working_pola_state)
    RunNumber = iNexus->getRunNumber()
    OBJ_DESTROY, iNexus
    
;check if it's the first time we add NeXus files (file name is empty)
    IF (reduce_tab1_table[1,0] EQ '') THEN BEGIN
        reduce_tab1_table[0,0] = STRCOMPRESS(RunNumber,/REMOVE_ALL)
        reduce_tab1_table[1,0] = nexus_file_list[index]
        IF (stateFoundInThisNexus(nexus_file_list[index],$
                                  reduce_tab1_working_pola_state)) THEN BEGIN
            reduce_tab1_table[2,0] = 'Pola. State FOUND'
        ENDIF ELSE BEGIN
            reduce_tab1_table[2,0] = 'Pola. State MISSING!'
        ENDELSE
    ENDIF ELSE BEGIN
        sz1 = N_ELEMENTS(reduce_tab1_table)
        reduce_tab1_table = REFORM(reduce_tab1_table,sz1,/OVERWRITE)
        tmp_table = STRARR(3,1)
        tmp_table[0,0] = STRCOMPRESS(RunNumber,/REMOVE_ALL)
        tmp_table[1,0] = nexus_file_list[index]
        IF (stateFoundInThisNexus(nexus_file_list[index], $
                                  reduce_tab1_working_pola_state)) THEN BEGIN
            tmp_table[2,0] = 'Pola. State FOUND'
        ENDIF ELSE BEGIN
            tmp_table[2,0] = 'Pola. State MISSING!'
        ENDELSE
        reduce_tab1_table = [reduce_tab1_table,tmp_table]
    ENDELSE
        
    index++
ENDWHILE

x = 3
y = N_ELEMENTS(reduce_tab1_table)/3

reduce_tab1_table = REFORM(reduce_tab1_table,x,y,/OVERWRITE)

id = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_tab1_table_uname')
WIDGET_CONTROL, id, TABLE_YSIZE = y
WIDGET_CONTROL, id, SET_VALUE = reduce_tab1_table

(*(*global).reduce_tab1_table) = reduce_tab1_table

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

    IF ((*global).reduce_tab1_working_pola_state EQ '') THEN BEGIN
;get list of polarization state available and display list_of_pola base
        nexus_file_name = nexus_file_list[0]
        status = retrieve_list_OF_polarization_state(Event, $
                                                     nexus_file_name, $
                                                     list_OF_pola_state)
        IF (status EQ 0) THEN RETURN

    ENDIF ELSE BEGIN

;update the table
        AddNexusToReduceTab1Table, Event

    ENDELSE
    
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
