;-------------------------------------------------------------------------------
;***** STEP 1 - [LOAD FILES] ***************************************************
;-------------------------------------------------------------------------------
;Event of <Load File> button
PRO LoadFileButton, Event 

;check the status of the TOF or Q button:
;if Q   -> LoadFile_Q
;if TOF -> display interaction TOF base
FormatFileSelected = getButtonValidated(Event,'InputFileFormat')   

IF (FormatFileSelected EQ 0) THEN BEGIN ;TOF

;display the dMD and angle value base
    dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
    widget_control, dMDAngleBaseId, map=1

;check status of ok_load button
    CheckOpenButtonStatus, Event 

ENDIF ELSE BEGIN                ;Q

    LoadFile_Q, Event

ENDELSE
END

;###############################################################################
;*******************************************************************************

;This function load the file in the first step (first tab) when the
;input is in Q
PRO LoadFile_Q, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
 
;launch the program that open the dialog_pickfile
LongFileName = OpenFile(Event) 
file_error = 0
;CATCH, file_error

IF (file_error NE 0) THEN BEGIN

    CATCH,/cancel
;move Back the colorIndex slidebar
    MoveColorIndexBack,Event ;_Gui

ENDIF ELSE BEGIN
;continue only if a file has been selected

    IF (LongfileName NE '') then begin

;get only the file name (without path) of file
        ShortFileName = get_file_name_only(LongFileName)    
;MoveColorIndex to new position 
        MoveColorIndex,Event ;_Gui
;get the value of the angle (in degree)
        angleValue = getCurrentAngleValue(Event) ;_get
        (*global).angleValue = angleValue
        get_angle_value_and_do_conversion, Event, angleValue

;store flt0(x-axis), flt1(y-axis) and flt2(y_error-axis) of new files
        index = (*global).NbrFilesLoaded 
        SuccessStatus = StoreFlts(Event, LongFileName, index) ;_OpenFile

        IF (SuccessStatus) THEN BEGIN

;add all files to step1 and step3 droplist
            AddNewFileToDroplist, Event, ShortFileName, LongFileName ;_Gui
            display_info_about_selected_file, Event, LongFileName ;_Gui
            populateColorLabel, Event, LongFileName ;_Gui

;plot all loaded files
            PlotLoadedFiles, Event ;_Plot

        ENDIF
    ENDIF
ENDELSE

;Update GUi
StepsUpdateGui, Event ;_Gui

END

;###############################################################################
;*******************************************************************************

;
;This function load the file in the first step (first tab)
;
PRO LoadTOFFile, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;launch the program that open the OPEN IDL FILE window
;LongFileName=ReflSupportOpenFile_OPEN_FILE(Event) 
LongFileName=OpenFile(Event) ;_Load
file_error = 0
;CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/cancel
;move Back the colorIndex slidebar
    MoveColorIndexBack,Event    ;_Gui
ENDIF ELSE BEGIN
;continue only if a file has been selected
    if (LongfileName NE '') then begin
;get only the file name (without path) of file
        ShortFileName = get_file_name_only(LongFileName)    
;MoveColorIndex to new position 
        MoveColorIndex,Event ;_Gui
;get the value of the angle (in degree)
        angleValue = getCurrentAngleValue(Event) ;_get
        (*global).angleValue = angleValue
        get_angle_value_and_do_conversion, Event, angleValue
;store flt0, flt1 and flt2 of new files
        index = (*global).NbrFilesLoaded 
        SuccessStatus = Storeflts(Event, LongFileName, index) ;_OpenFile
        IF (SuccessStatus) THEN BEGIN
;add all files to step1 and step3 droplist
            AddNewFileToDroplist, Event, ShortFileName, LongFileName ;_Gui
            display_info_about_selected_file, Event, LongFileName
            populateColorLabel, Event, LongFileName
;plot all loaded files
            PlotLoadedFiles, Event
        ENDIF
    ENDIF
ENDELSE

END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^

;When OK is pressed in dMDAngle base (to load a input file)
PRO OkLoadButton, Event 
LoadTOFFile, Event       
END

;###############################################################################
;*******************************************************************************
;This procedure is triggers each time the clear file button in step 1
;is used
PRO CLEAR_FILE, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get the selected index of the list of file droplist
TextBoxIndex = getSelectedIndex(Event, 'list_of_files_droplist') ;_get
RemoveIndexFromArray, Event, TextBoxIndex ;_utility

;update GUI
ListOfFiles = (*(*global).list_of_files)
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

END

;###############################################################################
;* Events from the TOF BASE ****************************************************
;###############################################################################

;Cancel Load button
PRO CancelTOFLoadButton, Event 
id = widget_info(event.top, find_by_uname='dMD_angle_base')
widget_control, id, map=0
END

;*******************************************************************************

;*******************************************************************************

;*******************************************************************************











;;Cancel Load button
;PRO ReflSupportEventcb_CancelLoadButton, Event 
;  dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
;  widget_control, dMDAngleBaseId, map=0
;END














