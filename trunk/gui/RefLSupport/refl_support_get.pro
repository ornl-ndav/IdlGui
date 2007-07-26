;this function gives the current selected tab
FUNCTION getTabSelected, Event
TabId = widget_info(Event.top,find_by_uname='steps_tab')
tabSelected = widget_info(TabId,/TAB_CURRENT)
return, tabSelected
end


;This functions gives the index of the color selected
FUNCTION getColorIndex, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
list_of_color_slider_id = widget_info(event.top,find_by_uname='list_of_color_slider')
widget_control, list_of_color_slider_id, get_value = ColorIndex
return, colorIndex
END


;This function gives the algorithm selected to do the TOF to Q 
;0 for simple method, 1 for Jacobian (the one uses by Michael)
FUNCTION getTOFtoQalgorithmSelected, Event
 tof_to_Q_algorithm_id = widget_info(event.top, find_by_uname='tof_to_Q_algorithm')
 widget_control, tof_to_Q_algorithm_id, get_value=algorithm_index
 return, algorithm_index
END


;This function returns the selected index of the 'uname'
;droplist given
FUNCTION getSelectedIndex, Event, uname
 TextBoxId= widget_info(Event.top, find_by_uname=uname)
 TextBoxIndex= widget_info(TextBoxId,/droplist_select)
 return, TextBoxIndex
END


;This function returns the current angle value from the text box
FUNCTION getCurrentAngleValue, Event
angleTextBoxId = widget_info(Event.top,find_by_uname='AngleTextField')
widget_control, angleTextBoxId, get_value=angleValue
return, angleValue
END


;This function outputs the value of the angle of the current selected file
FUNCTION getAngleValue, Event
 id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
 widget_control,id,get_uvalue=global
 angle_array = (*(*global).angle_array)
 fileIndex = getSelectedIndex(Event,'list_of_files_droplist')
 angleValue = angle_array[fileIndex]
 return, angleValue
end


;This function returns 1 if the first button is validated
;and 0 if it's the second
FUNCTION getButtonValidated, Event, uname
  TOFid = widget_info(Event.top,find_by_uname=uname)
  widget_control, TOFid, get_value=value
  return, value
END


;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = string
RETURN, string
END


;This function returns the value found in the text field given
FUNCTION getValue, Event, uname
unameId = widget_info(Event.top,find_by_uname=uname)
widget_control,unameId,get_value=value
return, value
END


;This function returns Q1, Q2 and SF of the current selected tab
FUNCTION getQ1Q2SF, Event, TAB

IF (TAB EQ 'STEP2') then begin
    Q1 = getValue(Event, 'step2_q1_text_field')    
    Q2 = getValue(Event, 'step2_q2_text_field')
    SF = getValue(Event, 'step2_sf_text_field')
ENDIF ELSE BEGIN
    Q1 = getValue(Event, 'step3_q1_text_field')    
    Q2 = getValue(Event, 'step3_q2_text_field')
    SF = getValue(Event, 'step3_sf_text_field')
ENDELSE
Q1Q2SF = [float(Q1),float(Q2),float(SF)]
RETURN, Q1Q2SF
END


;This function gives the size of the array given
;as a parameter
FUNCTION getSizeOfArray, ListOfFiles
sizeArray = size(ListOfFiles)
return, sizeArray[1]
END


;this function gives the long name of the file selected in the uname droplist
FUNCTION getLongFileNameSelected, Event, uname
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get the selected index of the load list droplist
TextBoxIndex = getSelectedIndex(Event, uname)
ListOfLongFileName = (*(*global).ListOfLongFileName)
LongFileName = ListOfLongFileName[TextBoxIndex]
return, LongFileName
END

