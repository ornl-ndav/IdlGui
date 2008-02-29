

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

















PRO ReflSupportwidget_ClearCElabelStep2, Event
cd_label_id = widget_info(Event.top,find_by_uname='short_ce_file_name')
widget_control, cd_label_id, set_value='No File loaded'
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






