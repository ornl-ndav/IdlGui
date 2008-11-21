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

;------------------------------------------------------------------------------
;***** STEP 1 - [LOAD FILES] **************************************************
;------------------------------------------------------------------------------
;Event of <Load File> button
PRO LoadFileButton, Event 

;check the status of the TOF or Q button:
;if Q   -> LoadFile_Q
;if TOF -> display interaction TOF base
FormatFileSelected = getButtonValidated(Event,'InputFileFormat')   

IF (FormatFileSelected EQ 0) THEN BEGIN ;TOF
    LogBookMessage = '> Loading a TOF File :'
;Check if the log book is empty or not
    LogBookText = idl_send_to_geek_getLogBookText(Event)
    IF (LogBookText[0] EQ '') THEN BEGIN
        idl_send_to_geek_putLogBookText, Event, LogBookMessage
    ENDIF ELSE BEGIN
        idl_send_to_geek_addLogBookText, Event, LogBookMessage
    ENDELSE
;display the dMD and angle value base
    dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
    widget_control, dMDAngleBaseId, map=1
;check status of ok_load button
    CheckOpenButtonStatus, Event 
ENDIF ELSE BEGIN                ;Q
    LogBookMessage = '> Loading a Q File :'
;Check if the log book is empty or not
    LogBookText = idl_send_to_geek_getLogBookText(Event)
    IF (LogBookText[0] EQ '') THEN BEGIN
        idl_send_to_geek_putLogBookText, Event, LogBookMessage
    ENDIF ELSE BEGIN
        idl_send_to_geek_addLogBookText, Event, LogBookMessage
    ENDELSE
    LoadFile_Q, Event
ENDELSE
idl_send_to_geek_showLastLineLogBook, Event
;this function updates the output file name
update_output_file_name, Event ;_output
END

;##############################################################################
;******************************************************************************

;This function load the file in the first step (first tab) when the
;input is in Q
PRO LoadFile_Q, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
 
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;launch the program that open the dialog_pickfile
LongFileName = OpenFile(Event) 
file_error   = 0
;CATCH, file_error

IF (file_error NE 0) THEN BEGIN
    CATCH,/cancel
;move Back the colorIndex slidebar
    MoveColorIndexBack,Event ;_Gui
ENDIF ELSE BEGIN
;continue only if a file has been selected
    IF (LongfileName NE '') then begin
        idl_send_to_geek_addLogBookText, Event, '-> Long File Name  : ' + $
          LongFileName
;get only the file name (without path) of file
        ShortFileName = get_file_name_only(LongFileName)    
        idl_send_to_geek_addLogBookText, Event, '-> Short File Name : ' + $
          ShortFileName
;MoveColorIndex to new position 
        MoveColorIndex,Event ;_Gui
;store flt0(x-axis), flt1(y-axis) and flt2(y_error-axis) of new files
        index = (*global).NbrFilesLoaded 
        idl_send_to_geek_addLogBookText, Event, '-> Store data ... ' + $
          PROCESSING
        SuccessStatus = StoreFlts(Event, LongFileName, index) ;_OpenFile
        IF (SuccessStatus) THEN BEGIN
            idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
;add all files to step1 and step3 droplist
            AddNewFileToDroplist, Event, ShortFileName, LongFileName ;_Gui
            display_info_about_selected_file, Event, LongFileName ;_Gui
;retrieve angle value from First data nexus file listed
            SaveAngleValueFromNexus, Event, index ;_get
            populateColorLabel, Event, LongFileName ;_Gui
;plot all loaded files
            PlotLoadedFiles, Event ;_Plot
        ENDIF ELSE BEGIN
            idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
        ENDELSE
    ENDIF ELSE BEGIN ;no file has been selected
        idl_send_to_geek_addLogBookText, Event, '-> Operation Canceled ' + $
          '(no file loaded)'
    ENDELSE
ENDELSE
;Update GUi
StepsUpdateGui, Event ;_Gui
idl_send_to_geek_showLastLineLogBook, Event
END

;##############################################################################
;******************************************************************************

;
;This function load the file in the first step (first tab)
;
PRO LoadTOFFile, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;launch the program that open the OPEN IDL FILE window
;LongFileName=ReflSupportOpenFile_OPEN_FILE(Event) 
LongFileName=OpenFile(Event) ;_Load
file_error = 0
;CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/cancel
    idl_send_to_geek_addLogBookText, Event, '> Loading a TOF file .... FAILED '
;move Back the colorIndex slidebar
    MoveColorIndexBack,Event    ;_Gui
ENDIF ELSE BEGIN
;continue only if a file has been selected
    IF (LongfileName NE '') THEN BEGIN
        idl_send_to_geek_addLogBookText, Event, '-> Long File Name  : ' + $
          LongFileName
;get only the file name (without path) of file
        ShortFileName = get_file_name_only(LongFileName)    
        idl_send_to_geek_addLogBookText, Event, '-> Short File Name : ' + $
          ShortFileName
;MoveColorIndex to new position 
        MoveColorIndex,Event ;_Gui
;get the value of the angle (in degree)
        angleValue = getCurrentAngleValue(Event) ;_get
        (*global).angleValue = angleValue
        get_angle_value_and_do_conversion, Event, angleValue ;_math
;store flt0, flt1 and flt2 of new files
        index = (*global).NbrFilesLoaded 
        idl_send_to_geek_addLogBookText, Event, '-> Store data ... ' + $
          PROCESSING
        SuccessStatus = Storeflts(Event, LongFileName, index) ;_OpenFile
        IF (SuccessStatus) THEN BEGIN
            idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
;add all files to step1 and step3 droplist
            AddNewFileToDroplist, Event, ShortFileName, LongFileName ;_Gui
            display_info_about_selected_file, Event, LongFileName
            populateColorLabel, Event, LongFileName
;plot all loaded files
            PlotLoadedFiles, Event
        ENDIF ELSE BEGIN
            idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
        ENDELSE
    ENDIF
    idl_send_to_geek_addLogBookText, Event, '> Loading a TOF file .... DONE'
ENDELSE
idl_send_to_geek_showLastLineLogBook, Event
END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*

;When OK is pressed in dMDAngle base (to load a input file)
PRO OkLoadButton, Event 
LoadTOFFile, Event       
END

;##############################################################################
;******************************************************************************
;This procedure is triggers each time the clear file button in step 1
;is used
PRO CLEAR_FILE, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

;get the selected index of the list of file droplist
TextBoxIndex = getSelectedIndex(Event, 'list_of_files_droplist') ;_get
;get the list of files
ListOfFiles  = getValue(Event,'list_of_files_droplist')
;inform user of file that is going to be removed
idl_send_to_geek_addLogBookText, Event, '> Removing File : ' + $
  ListOfFiles[TextBoxIndex]

RemoveIndexFromArray, Event, TextBoxIndex ;_utility

;update GUI
ListOfFiles = (*(*global).list_of_files)
;give new list of Files
idl_send_to_geek_addLogBookText, Event, '> New List of Files : ' 
idl_send_to_geek_addLogBookText, Event, '-> ' + ListOfFiles

updateGUI, Event, ListOfFiles

IF (getNbrOfFiles(Event) GE 1) THEN BEGIN
    plot_loaded_file, Event, 'clear'
ENDIF ELSE BEGIN
    plot_loaded_file, Event, 'all'
    reset_all_button, Event ;_event
ENDELSE

display_info_about_file, Event
angleValue = getAngleValue(Event)
displayAngleValue, Event, angleValue

;Update GUi
StepsUpdateGui, Event ;_Gui
idl_send_to_geek_showLastLineLogBook, Event
END

;##############################################################################
;* Events from the TOF BASE ***************************************************
;##############################################################################

;Cancel Load button
PRO CancelTOFLoadButton, Event 
id = widget_info(event.top, find_by_uname='dMD_angle_base')
widget_control, id, map=0
END

;******************************************************************************

PRO procedure_ref_scale_load
END










