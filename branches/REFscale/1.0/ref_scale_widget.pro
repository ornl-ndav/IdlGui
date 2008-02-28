;This function will enable (editable) or not the text fields of tab3
PRO ReflSupportWidget_enableStep3Widgets,Event,sensitiveBoolean
widget_uname = ['Step3_automatic_rescale_button',$
                'Step3SFTextField']

uname_size = (size(widget_uname))(1)
For i=0,(uname_size-1) do begin
    widget_id = widget_info(Event.top,find_by_uname=widget_uname[i])
    widget_control, widget_id, editable = sensitiveBoolean
endfor
END


;this function enables or not all the widgets of the manual scaling of
;step3
PRO ReflSupportWidget_enableStep3ManualScalingWidgets, Event, sensitiveBoolean
widget_uname = ['Step3ManualQMinTextField',$
                'Step3ManualQMaxTextField',$
                'Step3SFTextField',$
                'Step3SFDraw']

uname_size = (size(widget_uname))(1)
For i=0,(uname_size-1) do begin
    widget_id = widget_info(Event.top,find_by_uname=widget_uname[i])
    widget_control, widget_id, sensitive = sensitiveBoolean
endfor
END


;this function hide or not the base hidden base of the manual scaling
;mode of step 3
PRO ReflSupportWidget_HideBase, Event, uname, mapBoolean
widget_id = widget_info(Event.top,find_by_uname=uname)
widget_control, widget_id, map=mapBoolean
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
PRO ReflSupportWidget_refresh_draw_labels_tab3, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

images = (*(*global).images_tab3)
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




;this function updates the text field by removing the un-wanted 
;characters and just keeping the digits
PRO updateTextField, Event, textString, uname
  TFid = widget_info(Event.top,find_by_uname=uname)
  TFupdated = getNumeric(textString)
  widget_control, TFid, set_value=strcompress(TFupdated)
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
 putValueInTextField,Event,'step2_q1_text_field',''
 putValueInTextField,Event,'step2_q2_text_field',''
 putValueInTextField,Event,'step2_sf_text_field',''
;clear step3
 putValueInTextField,Event,'Step3SFTextField',''
 putValueInTextField,Event,'Step3ManualQMinTextField',''
 putValueInTextField,Event,'Step3ManualQMaxTextField',''
 putValueInLabel, Event, 'Step3ManualModeLowQFileName',''

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








;This function clear the contain of the color label 
PRO ClearColorLabel, Event
 ColorFileLabelId = widget_info(Event.top,find_by_uname='ColorFileLabel')
 widget_control, ColorFileLabelId, set_value=''
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



;this function changes the format of the input variable 
;into a 3 digit precision float
Function ReflSupportMath_getndigits, Event, angleValue
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  angleDisplayPrecision = (*global).angleDisplayPrecision
   
  step1Variable = float(angleValue)*angleDisplayPrecision
  step2Variable = floor(step1Variable)
  step3Variable = float(step2Variable) / angleDisplayPrecision
  return, step3Variable
END



PRO displayAngleValue, Event, angleValue
;get angle value for that index
 angleTextFieldId = widget_info(Event.top,find_by_uname='dMD_angle_info_label')
 ;fnAngleValue = ReflSupportMath_getndigits(Event, angleValue)
 text = '(Angle: ' + strcompress(angleValue) + ' degrees)'
 widget_control, angleTextFieldId, set_value=text
END



