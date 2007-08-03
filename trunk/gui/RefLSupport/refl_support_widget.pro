;This function will enable or not the widgets of tab3
PRO ReflSupportWidget_enableStep3Widgets,Event,sensitiveBoolean
widget_uname = ['Step3_button',$
                'step3_q1_text_field',$
                'step3_q2_text_field',$
                'step3_sf_text_field',$
                'step3_R_text_field',$
                'step3_deltaR_label']
For i=0,5 do begin
    widget_id = widget_info(Event.top,find_by_uname=widget_uname[i])
    widget_control, widget_id, editable = sensitiveBoolean
endfor
END



;This function will disable the widgets of step3 if
;the first file (CE file) is selected 
PRO ReflSupportWidget_ManageStep3Tab, Event 
index = getSelectedIndex(Event,'step3_work_on_file_droplist')
if (index EQ 0) then begin
    ;disable all widgets of step3
    ReflSupportWidget_enableStep3Widgets,Event,0
endif else begin
    ;enable all widgets of step3
    ReflSupportWidget_enableStep3Widgets,Event,1
endelse
END



;This procedure just put the given value in the text field
;specified by the uname after doing a strcompression of the 
;value
PRO ReflSupportWidget_setValue, Event, uname, value
TFid = widget_info(Event.top,find_by_uname=uname)
widget_control, TFid, set_value=strcompress(value,/remove_all)
END



;This function displays in the Qmin and Qmax text fields the 
;Qmin and Qmax of the CE file
PRO ReflSupportWidget_display_Q_values, Event, index, tab

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)

if (tab EQ 2) then begin
    ReflSupportWidget_setValue, Event, 'step2_q1_text_field', Qmin_array[index]
    ReflSupportWidget_setValue, Event, 'step2_q2_text_field', Qmax_array[index]
endif else begin
    ReflSupportWidget_setValue, Event, 'step3_q1_text_field', Qmin_array[index]
    ReflSupportWidget_setValue, Event, 'step3_q2_text_field', Qmax_array[index]

endelse

END




PRO ReflSupportWidget_PopulateCELabelStep2, Event, CE_short_name
cd_label_id = widget_info(Event.top,find_by_uname='short_ce_file_name')
widget_control, cd_label_id, set_value=CE_short_name
END


PRO ReflSupportwidget_ClearCElabelStep2, Event
cd_label_id = widget_info(Event.top,find_by_uname='short_ce_file_name')
widget_control, cd_label_id, set_value='No File loaded'
END



;This function replot the SF, ri and delta_ri labels/draw of tab2
PRO ReflSupportWidget_refresh_draw_labels_tab2, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

images = (*(*global).images_tabs)
unames = (*(*global).unames_tab2)
images_xoff = (*(*global).images_tabs_xoff)
images_yoff = (*(*global).images_tabs_yoff)

image_size_array = size(images)
image_size = image_size_array[1]

for i=0,(image_size-1) do begin
    id = widget_info(Event.top,find_by_uname=unames[i])
    WIDGET_CONTROL, id, GET_VALUE=id_value
    wset, id_value
    image = read_bmp(images[i])
    tv, image,images_xoff[i],images_yoff[i],/true
endfor
END


;This function replot the SF, ri and delta_ri labels/draw of tab3
PRO refresh_draw_labels_tab3, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

images = (*(*global).images_tabs)
unames = (*(*global).unames_tab3)
images_xoff = (*(*global).images_tabs_xoff)
images_yoff = (*(*global).images_tabs_yoff)

image_size_array = size(images)
image_size = image_size_array[1]

for i=0,(image_size-1) do begin
    id = widget_info(Event.top,find_by_uname=unames[i])
    WIDGET_CONTROL, id, GET_VALUE=id_value
    wset, id_value
    image = read_bmp(images[i])
    tv, image,images_xoff[i],images_yoff[i],/true
endfor
END


;This function moves the color index to the right position
PRO MoveColorIndex,Event
 id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
 widget_control,id,get_uvalue=global
 ColorIndex = getColorIndex(Event)

 PreviousColorIndex = (*global).PreviousColorIndex
 if (ColorIndex EQ PreviouscolorIndex) Then begin
     ColorIndex += 25
     (*global).PreviousColorIndex = ColorIndex
     list_of_color_slider_id = widget_info(Event.top,find_by_uname='list_of_color_slider')
     widget_control, list_of_color_slider_id, set_value=ColorIndex
 endif 
END


;This function returns 1 if the input can be turned into
;a float, and 0 if it can't
FUNCTION isValueFloat, textString
  result = getNumeric(textString)
  if (result EQ '') then begin
     return, 0
  endif else begin
     return, 1
  endelse
END


;this function updates the text field by removing the un-wanted 
;characters and just keeping the digits
PRO updateTextField, Event, textString, uname
  TFid = widget_info(Event.top,find_by_uname=uname)
  TFupdated = getNumeric(textString)
  widget_control, TFid, set_value=strcompress(TFupdated)
END


;This function checks the Input File Format GUI
;and returns:
; - 0 if it's ok
; - 1 if data reduction is blank with TOF
; - 2 if angle is blank with TOF
; - 3 if data reduction value is wrong with TOF
; - 4 if angle value is wrong with TOF
FUNCTION InputParameterStatus, Event
 id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
 widget_control,id,get_uvalue=global
 
 isTOFselected = getButtonValidated(Event,'InputFileFormat')
 Status = 0
 if (isTOFselected EQ 0) then begin ;TOF is selected (else Q)
     
     distanceTextFieldValue = $
       getTextFieldValue(Event,$
                         'ModeratorDetectorDistanceTextField')
     distanceTextFieldValue = strcompress(distanceTextFieldValue,/remove_all)
     
;distance text field is blank
     if (distanceTextFieldValue EQ '') then begin
         Status = 1
     endif else begin
         
;distance text field can't be turned into a float
         if (isValueFloat(distanceTextFieldValue) NE 1) then begin
             Status = 2
         endif 
     endelse
     
     angleTextFieldValue = $
       getTextFieldValue(Event,$
                         'AngleTextField')
     angleTextFieldValue = strcompress(angleTextFieldValue,/remove_all)
     
;angle text field is blank
     if (angleTextFieldValue EQ '') then begin
         Status += 10
     endif else begin
         
;angle text field can't be turned into a float
         if (isValueFloat(angleTextFieldValue) NE 1) then begin
             Status += 20
         endif else begin       ;else save angleValue
             (*global).angleValue = float(angleTextFieldValue)
         endelse
     endelse
 endif  
 return,Status
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
PRO ReflSupportWidget_updateDropList, Event, ListOfFiles
 id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
 widget_control,id,get_uvalue=global

;update list of file in droplist of step1
 list_of_files_droplist_id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
 widget_control, list_of_files_droplist_id, set_value=ListOfFiles
;update list of file in droplists of step3
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
;clear off list of file in droplists of step3
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

 (*global).PreviousColorIndex = defaultColorSliderPosition
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


;This function displays the error message in the error message label
PRO displayErrorMessage, Event, text
 ErrorMessageLabelid = widget_info(Event.top,find_by_uname='ErrorMessageLabel')
 widget_control, ErrorMessageLabelid, set_value=text
END


;this function map or not the ErrorBase
PRO activateErrorMessageBaseFunction, Event, activateErrorBase
 ErrorMessageBaseId = widget_info(Event.top,find_by_uname='ErrorMessageBase')
 widget_control, ErrorMessageBaseid, map = activateErrorBase
END


;This function activate or not the button given by uname
PRO ActivateButton, Event, uname, validate
 unameId = widget_info(Event.top,find_by_uname=uname)
 widget_control, unameId, sensitive=validate
END


;This function will check if the LOAD button can be validated or no
PRO checkLoadButtonStatus, Event
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
        text = 'Dist. and angle are empty'
    END
    12: BEGIN                   ;distance wrong and angle empty
        text = 'Dist. is wrong and angle empty'
    END
    20: BEGIN                   ;distance ok and angle wrong
        text = 'Angle has wrong format'
    END
    21: BEGIN                   ;distance is empty and angle is wrong
        text = 'Dist. empty and wrong angle format'
    END
    22: BEGIN                   ;distance and angle are wrong
        text = 'Dist. and angle have wrong format'
    END
ENDCASE
activateErrorMessageBaseFunction, Event, activateErrorBase
DisplayErrorMessage, Event, text
ActivateButton, Event, 'load_button', validateLoadButton
END


PRO displayAngleValue, Event, angleValue
;get angle value for that index
 angleTextFieldId = widget_info(Event.top,find_by_uname='AngleTextField')
 widget_control, angleTextFieldId, set_value=strcompress(angleValue)
END
