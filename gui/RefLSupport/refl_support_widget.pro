;This function returns 1 if the first button is validated
;and 0 if it's the second
FUNCTION getButtonValidated, Event, uname
TOFid = widget_info(Event.top,find_by_uname=uname)
widget_control, TOFid, get_value=value
return, value
END


;This function returns 1 if the input can be turned into
;a float, and 0 if it can't
FUNCTION isValueFloat, textString
result = isNumeric(textString)
if (result EQ 0) then begin
    return, 0
endif else begin
    return, 1
endelse
END


;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = string
RETURN, string
END


;This function checks the Input File Format GUI
;and returns:
; - 0 if it's ok
; - 1 if data reduction is blank with TOF
; - 2 if angle is blank with TOF
; - 3 if data reduction value is wrong with TOF
; - 4 if angle value is wrong with TOF
FUNCTION InputParameterStatus, Event

isTOFselected = getButtonValidated(Event,'InputFileFormat')
if (isTOFselected EQ 0) then begin ;TOF is selected
  
    distanceTextFieldValue = $
      getTextFieldValue(Event,$
                        'ModeratorDetectorDistanceTextField')
    distanceTextFieldValue = strcompress(distanceTextFieldValue,/remove_all)
;distance text field is blank
    if (distanceTextFieldValue EQ '') then begin
        return, 1
    endif else begin
;distance text field can't be turned into a float
        if (isValueFloat(distanceTextFieldValue) NE 1) then begin
            return, 3
        endif
    endelse
    
    angleTextFieldValue = $
      getTextFieldValue(Event,$
                        'AngleTextField')
    angleTextFieldValue = strcompress(angleTextFieldValue,/remove_all)
;angle text field is blank
    if (angleTextFieldValue EQ '') then begin
        return, 2
    endif else begin
;angle text field can't be turned into a float
        if (isValueFloat(angleTextFieldValue) NE 1) then begin
            return, 4
        endif
    endelse
    return,0
endif else begin ;Q selected, so no need to check the GUI
    return,0
endelse
END



PRO ActivateButton, Event, uname, validate
unameId = widget_info(Event.top,find_by_uname=uname)
widget_control, unameId, sensitive=validate
END


PRO EnableStep1ClearFile, Event, validate
ClearFileId = widget_info(Event.top, find_by_uname='clear_button')
widget_control, ClearFileId, sensitive=validate
END


;this function enables the main base buttons
;refresh and reset all
PRO EnableMainBaseButtons, Event, validate
reset_all_button_id = widget_info(Event.top,find_by_uname='reset_all_button')
widget_control, reset_all_button_id, sensitive=validate
refresh_plot_button_id = widget_info(Event.top,find_by_uname='refresh_plot_button')
widget_control, refresh_plot_button_id, sensitive=validate
END


;This function refresh the list displays in all the droplist (step1-2 and 3)
PRO updateDropList, Event, ListOfFiles
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;update list of file in droplist of step1
list_of_files_droplist_id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, list_of_files_droplist_id, set_value=ListOfFiles
;update list of file in droplist of step2
base_file_droplist_id = widget_info(Event.top,find_by_uname='base_file_droplist')
widget_control, base_file_droplist_id, set_value=ListOfFiles
;update list of file in droplists of step3
step3_base_file_droplist_id = $
  widget_info(Event.top,find_by_uname='step3_base_file_droplist')
widget_control, step3_base_file_droplist_id, set_value=ListOfFiles
step3_work_on_file_droplist_id = widget_info(Event.top,$
                                             find_by_uname='step3_work_on_file_droplist')
widget_control, step3_work_on_file_droplist_id, set_value=ListOfFiles
END


;This function clears the contain of all the droplists
PRO ClearAllDropLists, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear off list of file in droplist of step1
list_of_files_droplist_id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, list_of_files_droplist_id, set_value=['']
;clear off list of file in droplist of step2
base_file_droplist_id = widget_info(Event.top,find_by_uname='base_file_droplist')
widget_control, base_file_droplist_id, set_value=['']
;clear off list of file in droplists of step3
step3_base_file_droplist_id = $
  widget_info(Event.top,find_by_uname='step3_base_file_droplist')
widget_control, step3_base_file_droplist_id, set_value=['']
step3_work_on_file_droplist_id = widget_info(Event.top,$
                                             find_by_uname='step3_work_on_file_droplist')
widget_control, step3_work_on_file_droplist_id, set_value=['']
END


;This function clears the contain of all the text boxes
PRO ClearAllTextBoxes, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear step2 
step2_q1_text_field_id = Widget_info(Event.top,find_by_uname='step2_q1_text_field')
Widget_control, step2_q1_text_field_id, set_value=''
step2_q2_text_field_id = Widget_info(Event.top,find_by_uname='step2_q2_text_field')
Widget_control, step2_q2_text_field_id, set_value=''
step2_SF_text_field_id = Widget_info(Event.top,find_by_uname='step2_sf_text_field')
Widget_control, step2_SF_text_field_id, set_value=''
;clear step3
step3_q1_text_field_id = Widget_info(Event.top,find_by_uname='step3_q1_text_field')
Widget_control, step3_q1_text_field_id, set_value=''
step3_q2_text_field_id = Widget_info(Event.top,find_by_uname='step3_q2_text_field')
Widget_control, step3_q2_text_field_id, set_value=''
step3_SF_text_field_id = Widget_info(Event.top,find_by_uname='step3_sf_text_field')
Widget_control, step3_SF_text_field_id, set_value=''
END


;This function removes the contain of the info file found in Step1
PRO ClearFileInfoStep1, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_Value=''
END


;clear main plot window
PRO ClearMainPlot, Event   
draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id
erase
END


;reset the position of the color slider
PRO ResetPositionOfSlider, Event 
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

defaultColorSliderPosition = (*global).ColorSliderDefaultValue
list_of_color_slider_id = widget_info(event.top,find_by_uname='list_of_color_slider')
widget_control, list_of_color_slider_id, set_value = defaultColorSliderPosition
END


PRO populateColorLabel, Event, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
SelectedIndex = getSelectedIndex(Event,'list_of_files_droplist')
ListShortFileName = (*(*global).list_of_files)
fileName = ListShortFileName[SelectedIndex]
fileName = '(-> ' + fileName + ')'
ColorLabelIndex = widget_info(Event.top,find_by_uname='ColorFileLabel')
widget_control, ColorLabelIndex, set_value=fileName
END


;this function activate (if validateMap=1) or desactive-hide(if validateMap=0)
;the RescaleBase
PRO ActivateRescaleBase, Event, validateMap
RescaleBaseId = widget_info(Event.top,find_by_uname='RescaleBase')
widget_control, RescaleBaseId, map=validateMap
END


;This function activates or not the CLEAR file button
PRO ActivateClearFileButton, Event, ValidateButton
ClearButtonId = widget_info(Event.top,find_by_uname='clear_button')
widget_control, ClearButtonId, sensitive=ValidateButton
END


;This function clear the contain of the color label 
PRO ClearColorLabel, Event
ColorFileLabelId = widget_info(Event.top,find_by_uname='ColorFileLabel')
widget_control, ColorFileLabelId, set_value=''
END


;This function enable the color slider
PRO ActivateColorSlider, Event, ValidateSlider
ColorSliderId = widget_info(Event.top, find_by_uname='list_of_color_slider')
widget_control, ColorSliderId, sensitive=ValidateSlider
END


;This function will check if the LOAD button can be validated or no
PRO checkLoadButtonStatus, Event

InputParameter = InputParameterStatus(Event)
CASE (InputParameter) of
    0: BEGIN ;yes two thumbs up
        ;validate Load button
    END
    1: BEGIN ;distance field is missing
        print, 'case is 1'
    END
    2: BEGIN ;angle field is missing
        print, 'case is 2'
    END
    3: BEGIN ;distance field is invalid (is not a number)
        print, 'case is 3'
    END
    4: BEGIN ;angle field is invalid
        print, 'case is 4'
    END
ENDCASE
END
