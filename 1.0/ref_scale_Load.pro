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
    MoveColorIndexBack,Event

ENDIF ELSE BEGIN
;continue only if a file has been selected

    IF (LongfileName NE '') then begin

;get only the file name (without path) of file
        ShortFileName = get_file_name_only(LongFileName)    
;MoveColorIndex to new position 
        MoveColorIndex,Event
;get the value of the angle (in degree)
        angleValue = getCurrentAngleValue(Event)
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

END

;###############################################################################
;*******************************************************************************

;
;This function load the file in the first step (first tab)
;
PRO ReflSupportOpenFile_LoadFile, Event
 id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
 widget_control,id,get_uvalue=global
 
;launch the program that open the OPEN IDL FILE window
 LongFileName=ReflSupportOpenFile_OPEN_FILE(Event) 

file_error = 0
CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/cancel
;move Back the colorIndex slidebar
    ReflSupportOpenFile_MoveColorIndexBack,Event
ENDIF ELSE BEGIN
;continue only if a file has been selected
    if (LongfileName NE '') then begin
;get only the file name (without path) of file
        ShortFileName = get_file_name_only(LongFileName)    
;MoveColorIndex to new position 
        ReflSupportOpenFile_MoveColorIndex,Event
;get the value of the angle (in degree)
        angleValue = getCurrentAngleValue(Event)
        (*global).angleValue = angleValue
        get_angle_value_and_do_conversion, Event, angleValue
;store flt0, flt1 and flt2 of new files
        index = (*global).NbrFilesLoaded 
        SuccessStatus = ReflSupportOpenFile_Storeflts(Event, LongFileName, index)
        IF (SuccessStatus) THEN BEGIN
;add all files to step1 and step3 droplist
            ReflSupportOpenFile_AddNewFileToDroplist, Event, ShortFileName, LongFileName 
            display_info_about_selected_file, Event, LongFileName
            populateColorLabel, Event, LongFileName
;plot all loaded files
            ReflSupportOpenFile_PlotLoadedFiles, Event
        ENDIF
    ENDIF
ENDELSE

END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^

;When OK is pressed in dMDAngle base (to load a input file)
PRO OkLoadButton, Event 
     ReflSupportOpenFile_LoadFile, Event       
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

;plot all loaded files if listOfFiles is not empty
ListOfFilesSize = getSizeOfArray(ListOfFiles)
if (ListOfFilesSize EQ 1 AND $
    ListOfFiles[0] EQ '') then begin
    plot_loaded_file, Event, 'clear'
endif else begin
   plot_loaded_file, Event, 'all'
endelse

display_info_about_file, Event
angleValue = getAngleValue(Event)
displayAngleValue, Event, angleValue

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











;Cancel Load button
PRO ReflSupportEventcb_CancelLoadButton, Event 
  dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
  widget_control, dMDAngleBaseId, map=0
END




;clear file button in step 1
PRO CLEAR_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get the selected index of the load
;list droplist
TextBoxIndex = getSelectedIndex(Event, 'list_of_files_droplist')
RemoveIndexFromArray, Event, TextBoxIndex
;update GUI
ListOfFiles = (*(*global).list_of_files)
updateGUI, Event, ListOfFiles

;plot all loaded files if listOfFiles is not empty
ListOfFilesSize = getSizeOfArray(ListOfFiles)
if (ListOfFilesSize EQ 1 AND $
    ListOfFiles[0] EQ '') then begin
    plot_loaded_file, Event, 'clear'
endif else begin
   plot_loaded_file, Event, 'all'
endelse

display_info_about_file, Event
angleValue = getAngleValue(Event)
displayAngleValue, Event, angleValue

END




;reset full session
PRO RESET_ALL_BUTTON, Event
;reset all arrays
ResetArrays, Event            ;reset all arrays
ReinitializeColorArray, Event
ClearAllDropLists, Event      ;clear all droplists
ClearAllTextBoxes, Event      ;clear all textBoxes
ClearFileInfoStep1, Event     ;clear contain of info file (Step1)
ClearMainPlot, Event          ;clear main plot window
ResetPositionOfSlider, Event  ;reset color slider and previousColorIndex
ResetAllOtherParameters, Event
ResetRescaleBase,Event
ActivateRescaleBase, Event, 0
ActivateClearFileButton, Event, 0
ClearColorLabel, Event
ReflSupportWidget_ClearCElabelStep2, Event
ActivatePrintFileButton, Event, 0
;Reset nbr of files loaded
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
(*global).NbrFilesLoaded = 0
END


;reset X and Y axis rescalling
PRO ResetRescaleButton, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;repopulate Xmin, Xmax, Ymin and Ymax with first XYMinMax values
putXYMinMax, Event, (*(*global).XYMinMax)
DoPlot, Event
END


;TOF or Q buttons
PRO InputFileFormat, Event
;; ValidateButton = getButtonValidated(Event,'InputFileFormat')
;; if (ValidateButton EQ 0) then begin ;TOF
;;     Validate = 1
;; endif else begin ;Q
;;     Validate = 0
;; endelse
;; ModeratorDetectorDistanceBaseId = $
;;   widget_info(Event.top,find_by_uname='ModeratorDetectorDistanceBase')
;; widget_control, ModeratorDetectorDistanceBaseId, map=Validate
;; checkLoadButtonStatus, Event
END


PRO replot_main_plot, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
if (((*global).replot_me) EQ 1) then begin
    steps_tab, Event,1
    (*global).replot_me = 0
endif
end


PRO rescale_data_changed, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
(*global).replot_me = 1
END








