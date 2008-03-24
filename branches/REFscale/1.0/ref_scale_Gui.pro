;-------------------------------------------------------------------------------
;***** GUI MANAGER FUNCTIONS ***************************************************
;-------------------------------------------------------------------------------
;this function activate (if validateMap=1) or desactive-hide(if validateMap=0)
;the RescaleBase
PRO ActivateRescaleBase, Event, validateMap
RescaleBaseId = widget_info(Event.top,find_by_uname='RescaleBase')
widget_control, RescaleBaseId, map=validateMap
END

;###############################################################################
;#FUNCTION - PROCEDURE #########################################################
;###############################################################################

;This function checks the Input File Format GUI
;and returns:
; 0  : distance ok and angle ok
; 1  : distance is empty and angle ok
; 2  : distance wrong and angle ok
; 10 : distance ok and angle empty
; 11 : distance empty and angle empty
; 12 : distance wrong and angle empty
; 20 : distance ok and angle wrong
; 21 : distance empty and angle wrong
; 22 : distance wrong and angle wrong
FUNCTION InputParameterStatus, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
 
isTOFselected = getButtonValidated(Event,'InputFileFormat') ;_get
Status = 0
IF (isTOFselected EQ 0) THEN BEGIN ;TOF is selected (else Q) 
    
    distanceTextFieldValue = $
      getTextFieldValue(Event,$
                        'ModeratorDetectorDistanceTextField') ;_get
    distanceTextFieldValue = strcompress(distanceTextFieldValue,/remove_all)
    
;distance text field is blank
    IF (distanceTextFieldValue EQ '') THEN BEGIN
        
        Status = 1

    ENDIF ELSE BEGIN
        
;distance text field can't be turned into a float
        IF (isValueFloat(distanceTextFieldValue) NE 1) THEN BEGIN ;_is

            Status = 2

        ENDIF 

    ENDELSE
    
    angleTextFieldValue = $
      getTextFieldValue(Event,$
                        'AngleTextField') ;_get
    angleTextFieldValue = strcompress(angleTextFieldValue,/remove_all)
    
;angle text field is blank
    IF (angleTextFieldValue EQ '') THEN BEGIN

        Status += 10

    ENDIF ELSE BEGIN
        
;angle text field can't be turned into a float
        IF (isValueFloat(angleTextFieldValue) NE 1) THEN BEGIN

            Status += 20

        ENDIF ELSE BEGIN        ;else save angleValue

            (*global).angleValue = float(angleTextFieldValue)

        ENDELSE

    ENDELSE

ENDIF  

RETURN,Status
END

;###############################################################################
;*******************************************************************************

;This function will check if the LOAD button can be validated or no
PRO CheckOpenButtonStatus, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

InputParameter = InputParameterStatus(Event)
activateErrorBase = 1
validateLoadButton = 0

CASE (InputParameter) OF

    0: BEGIN                    ; ok
        validateLoadButton = 1
        activateErrorBase = 0
    END
    1: BEGIN                    ;distance empty and angle ok
        text = 'Dist. is empty'
    END
    2: BEGIN                    ;distance wrong and angle ok
        text = 'Angle has wrong format'
    END
    10: BEGIN                   ;distance ok but angle empty
        text = 'Angle is empty'
    END
    11: BEGIN                   ;distance and angle are empty
        text = 'Dist. & angle are empty'
    END
    12: BEGIN                   ;distance wrong and angle empty
        text = 'Dist. is wrong & angle empty'
    END
    20: BEGIN                   ;distance ok and angle wrong
        text = 'Angle has wrong format'
    END
    21: BEGIN                   ;distance is empty and angle is wrong
        text = 'Dist. empty & wrong angle format'
    END
    22: BEGIN                   ;distance and angle are wrong
        text = 'Dist. & angle have wrong format'
    END
    ELSE:

ENDCASE

activateErrorMessageBaseFunction, Event, activateErrorBase
DisplayErrorMessage, Event, text
ActivateButton, Event, 'ok_load_button', validateLoadButton

END

;###############################################################################
;*******************************************************************************

;This function moves the color slider by the index given as an input
;parameter (>0 will move it to the right, <0 to move it to the left)
PRO MoveColorIndex_by_index, Event, index

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get current color Index selected
ColorIndex = getColorIndex(Event)
 
PreviousColorIndex = (*global).PreviousColorIndex
IF (ColorIndex EQ PreviouscolorIndex) THEN BEGIN
    
    ColorIndex = ColorIndex + index
    (*global).PreviousColorIndex = ColorIndex
    id = widget_info(Event.top,find_by_uname='list_of_color_slider')
    widget_control, id, set_value=ColorIndex
    
ENDIF
END

;*******************************************************************************

;This function moves the color index to the right position
PRO MoveColorIndex,Event

index = + 25
MoveColorIndex_by_index, Event, index ;_Gui

END

;*******************************************************************************

;This function moves back the color index when the loading process failed
PRO MoveColorIndexBack,Event

index = - 25
MoveColorIndex_by_index, Event, index ;_Gui
 
END

;###############################################################################
;*******************************************************************************

;This function refresh the list displays in all the droplist (step1-2 and 3)
PRO updateDropList, Event, ListOfFiles

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF (ListOfFiles[0] EQ '') THEN BEGIN
    ListOfFiles = ['                          ']
ENDIF

;update list of file in droplist of step1
id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, id, set_value=ListOfFiles

;update list of file in droplists of step3
id = widget_info(Event.top,find_by_uname='step3_work_on_file_droplist')
widget_control, id, set_value=ListOfFiles

END

;###############################################################################
;*******************************************************************************

PRO PopulateCELabelStep2, Event, CE_short_name
id = widget_info(Event.top,find_by_uname='short_ce_file_name')
widget_control, id, set_value=CE_short_name
END

;*******************************************************************************

PRO EnableStep1ClearFile, Event, validate
id = widget_info(Event.top, find_by_uname='clear_button')
widget_control, id, sensitive=validate
END

;*******************************************************************************

;This function sets the selected index of the 'uname' droplist
PRO SetSelectedIndex, Event, uname, index
id = widget_info(Event.top, find_by_uname=uname)
widget_control, id, set_droplist_select = index
END

;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
;This function automatically selects the last loaded file
PRO SelectLastLoadedFile, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
ListOfFiles = (*(*global).list_of_files)
NbrOfFiles  = getSizeOfArray(ListOfFiles)
SetSelectedIndex, Event, 'list_of_files_droplist', (NbrOfFiles-1) ;_gui
END

;*******************************************************************************

;this function enables the main base buttons (refresh and reset all)
PRO EnableMainBaseButtons, Event, validate
id = widget_info(Event.top,find_by_uname='reset_all_button')
widget_control, id, sensitive=validate
id = widget_info(Event.top,find_by_uname='refresh_plot_button')
widget_control, id, sensitive=validate
END

;*******************************************************************************

;This function activates or not the CLEAR file button
PRO ActivateClearFileButton, Event, ValidateButton
id = widget_info(Event.top,find_by_uname='clear_button')
widget_control, id, sensitive=ValidateButton
END

;*******************************************************************************

;This function enable the color slider
PRO ActivateColorSlider, Event, ValidateSlider
id = widget_info(Event.top, find_by_uname='list_of_color_slider')
widget_control, id, sensitive=ValidateSlider
END

;*******************************************************************************

PRO ActivatePrintFileButton, Event, validate
id = widget_info(Event.top, find_by_uname='print_button')
widget_control, id, sensitive=validate
END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^

;This function updates the GUI (droplist, buttons...)
PRO updateGUI, Event, ListOfFiles

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

updateDropList, Event, ListOfFiles ;_gui
ArraySize = getSizeOfArray(ListOfFiles)

IF (ArraySize EQ 0) THEN BEGIN

    validate = 0
    CE_short_name = 'No file selected'

ENDIF ELSE BEGIN

    validate = 1
    CE_short_name = (*global).short_CE_name

ENDELSE

PopulateCELabelStep2, Event, CE_short_name ;_gui
EnableStep1ClearFile, Event, validate ;_gui
SelectLastLoadedFile, Event     ;_gui
EnableMainBaseButtons, Event, validate ;_gui
ActivateClearFileButton, Event, validate ;_gui
ActivateColorSlider, Event, Validate ;_gui
ActivatePrintFileButton, Event, Validate ;_gui
END

;###############################################################################
;*******************************************************************************

;This functions populates the various droplist boxes.
;It also checks if the newly file loaded is not already 
;present in the list, in this case, it's not added
PRO AddNewFileToDroplist, Event, ShortFileName, LongFileName

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ListOfFiles        = (*(*global).list_of_files)
ListOfLongFileName = (*(*global).ListOfLongFileName)

;it's the first file loaded (CE file)
IF (isListOfFilesSize0(ListOfFiles) EQ 1) THEN BEGIN
    
    (*global).full_CE_name   = LongFileName
    (*global).short_CE_name  = ShortFileName
    (*global).NbrFilesLoaded = 1 ;we have now 1 file loaded
    
    ListOfFiles = [ShortFileName]
    ListOfLongFileName = [LongFileName]
    ActivateRescaleBase, Event, 1
      
                                ;save angle value
    angle_array    = (*(*global).angle_array)
    angle_array[0] = (*global).angleValue
    (*(*global).angle_array) = angle_array
      
;if's not the first file loaded
  ENDIF ELSE BEGIN

     ;is this file not already listed 
     IF(isFileAlreadyInList(ListOfFiles, ShortFileName) EQ 0) THEN BEGIN ;_is
;true newly file
         (*global).FirstTimePlotting = 0 ;next load won't be the first one anymore
        ListOfFiles        = [ListOfFiles,ShortFileName]
        ListOfLongFileName = [ListOfLongFileName,LongFileName]
 ;if a file is added, the Q1,Q2,SF... arrays are updated
        CreateArrays, Event ;_Arrays    
     
     ENDIF
  
  ENDELSE
  
  (*(*global).list_of_files) = ListOfFiles
  (*(*global).ListOfLongFileName) = ListOfLongFileName

;update GUI
  updateGUI,Event, ListOfFiles ;_gui
end

;###############################################################################
;*******************************************************************************

;This functions displays the first few lines of the newly loaded file
PRO display_info_about_selected_file, Event, LongFileName

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

no_file = 0
nbr_line = (*global).NbrInfoLineToDisplay
CATCH, no_file

IF (no_file NE 0) THEN BEGIN

    CATCH,/CANcEL
    plot_file_found = 0    

ENDIF ELSE BEGIN

    openr,u,LongFileName,/get
    fs = fstat(u)
;define an empty string variable to hold results from reading the file
    tmp = ''
    info_array = strarr(nbr_line)

    FOR i=0,(nbr_line-1) DO BEGIN
        readf,u,tmp
        info_array[i] = tmp
    ENDFOR

    close,u
    free_lun,u

ENDELSE

putArrayInTextField, Event, 'file_info', info_array ;_put

END

;###############################################################################
;*******************************************************************************

PRO populateColorLabel, Event, LongFileName

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

SelectedIndex = getSelectedIndex(Event,'list_of_files_droplist') ;_get
ListShortFileName = (*(*global).list_of_files)
fileName = ListShortFileName[SelectedIndex]
fileName = '(-> ' + fileName + ')'
ColorLabelIndex = widget_info(Event.top,find_by_uname='ColorFileLabel')
widget_control, ColorLabelIndex, set_value=fileName

END


;###############################################################################
;*******************************************************************************

;This function creates the default xmin/max and ymin/max values
;that will be used if one of the input is invalid
PRO CreateDefaultXYMinMax, Event,$
                           min_xaxis,$
                           max_xaxis,$
                           min_yaxis,$
                           max_yaxis

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

XYMinMax = (*(*global).XYMinMax)
XYMinMax = strarr(4)

XYMinMax[0] = min_xaxis
XYMinMax[1] = max_xaxis
XYMinMax[2] = min_yaxis
XYMinMax[3] = max_yaxis

(*(*global).XYMinMax) = XYMinMax
END

;###############################################################################
;*******************************************************************************

;this function clear the info text box
PRO clear_info_about_selected_file, Event
TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_value=''
END

;*******************************************************************************

;This function clear the contain of the color label 
PRO ClearColorLabel, Event
id = widget_info(Event.top,find_by_uname='ColorFileLabel')
widget_control, id, set_value=''
END

;*******************************************************************************

PRO displayAngleValue, Event, angleValue
;get angle value for that index
angleTextFieldId = widget_info(Event.top,find_by_uname='dMD_angle_info_label')
text = '(Angle: ' + strcompress(angleValue) + ' degrees)'
widget_control, angleTextFieldId, set_value=text
END

;*******************************************************************************

;droplist of files in step 1
PRO display_info_about_file, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get the long name of th selected file
LongFileName = getLongFileNameSelected(Event,'list_of_files_droplist') ;_get

  IF (LongFileName EQ '') THEN BEGIN

      clear_info_about_selected_file, Event ;_Gui
      ActivateClearFileButton, Event, 0 ;_Gui
      ClearColorLabel, Event ;_Gui
      ActivateColorSlider, Event, 0 ;_Gui

  ENDIF ELSE BEGIN

      display_info_about_selected_file, Event, LongFileName ;_Gui
      populateColorLabel, Event, LongFileName ;_Gui
      ActivateColorSlider,Event,1 ;_Gui
      angleValue = getAngleValue(Event) ;_get
      displayAngleValue, Event, angleValue ;_Gui

  ENDELSE
END

;###############################################################################
;*******************************************************************************

;This function assign to the current selected file the current
;selected color
PRO AssignColorToSelectedPlot, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

colorIndex  = getColorIndex(Event) ;_get
fileIndex   = getSelectedIndex(Event, 'list_of_files_droplist') ;_get
color_array = (*(*global).color_array)
color_array[fileIndex] = colorIndex
(*(*global).color_array) = color_array
END

;###############################################################################
;*******************************************************************************

;This procedure just put the given value in the text field
;specified by the uname after doing a strcompression of the 
;value
;PRO ReflSupportWidget_setValue, Event, uname, value
PRO GuiSetValue, Event, uname, value
TFid = widget_info(Event.top,find_by_uname=uname)
widget_control, TFid, set_value=strcompress(value,/remove_all)
END

;*******************************************************************************

;This function displays in the Qmin and Qmax text fields the 
;Qmin and Qmax of the CE file
PRO display_Q_values, Event, index, tab

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)

IF (tab EQ 2) THEN BEGIN

    GuiSetValue, Event, 'step2_q1_text_field', Qmin_array[index] ;_Gui
    GuiSetValue, Event, 'step2_q2_text_field', Qmax_array[index] ;_Gui

ENDIF 

END

;###############################################################################
;*******************************************************************************

;This function replot the SF, ri and delta_ri labels/draw of tab3
PRO refresh_draw_labels_tab3, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

images      = (*(*global).images_tab3)
unames      = (*(*global).unames_tab3)
images_xoff = (*(*global).images_tabs_xoff)
images_yoff = (*(*global).images_tabs_yoff)

image_size_array = size(images)
image_size = image_size_array[1]

FOR i=0,(image_size-1) DO BEGIN
    id = widget_info(Event.top,find_by_uname=unames[i])
    WIDGET_CONTROL, id, GET_VALUE=id_value
    wset, id_value
    image = read_bmp(images[i])
    tv, image,images_xoff[i],images_yoff[i],/true
ENDFOR

END

;###############################################################################
;*******************************************************************************

;This function will enable (editable) or not the text fields of tab3
PRO enableStep3Widgets,Event,sensitiveBoolean

widget_uname = ['Step3_automatic_rescale_button',$
                'Step3SFTextField']

uname_size = (size(widget_uname))(1)
FOR i=0,(uname_size-1) DO BEGIN
    id = widget_info(Event.top,find_by_uname=widget_uname[i])
    widget_control, id, editable = sensitiveBoolean
ENDFOR
END

;###############################################################################
;*******************************************************************************

;this function hide or not the base hidden base of the manual scaling
;mode of step 3
PRO HideBase, Event, uname, mapBoolean
widget_id = widget_info(Event.top,find_by_uname=uname)
widget_control, widget_id, map=mapBoolean
END

;###############################################################################
;*******************************************************************************

;This function activate or not the button given by uname
PRO ActivateButton, Event, uname, validate
unameId = widget_info(Event.top,find_by_uname=uname)
widget_control, unameId, sensitive=validate
END

;###############################################################################
;*******************************************************************************

PRO ReflSupportwidget_ClearCElabelStep2, Event
cd_label_id = widget_info(Event.top,find_by_uname='short_ce_file_name')
widget_control, cd_label_id, set_value='No File loaded'
END

;###############################################################################
;*******************************************************************************

;This function clears the contain of all the text boxes
PRO ClearAllTextBoxes, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear step2 
putValueInTextField,Event,'step2_q1_text_field','' ;_put
putValueInTextField,Event,'step2_q2_text_field','' ;_put
putValueInTextField,Event,'step2_sf_text_field','' ;_put
;clear step3
putValueInTextField,Event,'Step3SFTextField',''   ;_put
putValueInTextField,Event,'Step3ManualQMinTextField','' ;_put
putValueInTextField,Event,'Step3ManualQMaxTextField','' ;_put
putValueInLabel, Event, 'Step3ManualModeLowQFileName','' ;_put

END

;###############################################################################
;*******************************************************************************

;This function removes the contain of the info file found in Step1
PRO ClearFileInfoStep1, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_Value=''
END

;###############################################################################
;*******************************************************************************

;clear main plot window
PRO ClearMainPlot, Event   
draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id
erase
END

;###############################################################################
;*******************************************************************************

;reset the position of the color slider
PRO ResetPositionOfSlider, Event 
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

defaultColorSliderPosition = (*global).ColorSliderDefaultValue
list_of_color_slider_id = widget_info(event.top, $
                                      find_by_uname='list_of_color_slider')
widget_control, list_of_color_slider_id, set_value = defaultColorSliderPosition

(*global).PreviousColorIndex = defaultColorSliderPosition
END

;###############################################################################
;*******************************************************************************

;This function displays the error message in the error message label
PRO displayErrorMessage, Event, text
ErrorMessageLabelid = widget_info(Event.top,find_by_uname='ErrorMessageLabel')
widget_control, ErrorMessageLabelid, set_value=text
END

;###############################################################################
;*******************************************************************************

;this function map or not the ErrorBase
PRO activateErrorMessageBaseFunction, Event, activateErrorBase
ErrorMessageBaseId = widget_info(Event.top,find_by_uname='ErrorMessageBase')
widget_control, ErrorMessageBaseid, map = activateErrorBase
END

;###############################################################################
;*******************************************************************************

