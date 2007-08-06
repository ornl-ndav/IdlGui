;This function returns 1 if the specified axis scale is linear
;and 0 if it's logarithmic
FUNCTION getScale, Event, axis
if (axis EQ 'X') then begin
   uname = 'XaxisLinLog' 
endif else begin
   uname = 'YaxisLinLog'
endelse
axis_id = widget_info(Event.top,find_by_uname=uname)
widget_control, axis_id, get_value=value
return, value
END




;This function will retrieve the values of Xmin/max and Ymin/max
FUNCTION getXYMinMax, Event

;min-xaxis
XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
widget_control, XminId, get_value=Xmin

;max-xaxis
XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
widget_control, XmaxId, get_value=Xmax

;min-yaxis
YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
widget_control, YminId, get_value=Ymin

;max-yaxis
YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
widget_control, YmaxId, get_value=Ymax

return_array = [Xmin,Xmax,Ymin,Ymax]
return, return_array
END



;This function removes all the values outside the given
;range of values [0,10] from the array passed as argument
FUNCTION getArrayRangeOfNotNanValues, flt1_new
index = where(flt1_new GE 0 AND flt1_new LE 10)
return, index
return, rangeIndexes
END


;This function takes array as an argument and will
;return the first argument >= Q1 and the last one <=Q2
;
;To determine in which order the search should be done (increasing
;or decreasing order) the first and last argument will be checked first
FUNCTION getArrayRangeFromQ1Q2, flt0, Q1, Q2

FirstValue = flt0[0]
flt0_size = (size(flt0))[1]
LastValue  = flt0[flt0_size-1]

left_index = 0
right_index = (flt0_size-1)

found_left_index = 0
if (FirstValue LT LastValue) then begin ;increasing order
    for i=0,(flt0_size-1) do begin
        if (found_left_index EQ 0) then begin
            if (flt0[i] GE Q1) then begin
                left_index = i
                found_left_index = 1
            endif
        endif else begin
            if (flt0[i] GT Q2) then begin
                right_index = i-1
                break
            endif
        endelse
        endfor
endif else begin                ;decreasing order
    for i=0,(flt0_size-1) do begin
        if (found_left_index EQ 0) then begin
            if (flt0[i] LE Q2) then begin
                left_index = i
                found_left_index = 1
            endif
        endif else begin
            if (flt0[i] LT Q1) then begin
                right_index = i-1
                break
            endif
        endelse
    endfor
endelse          

returnArray = [left_index, right_index]
return, returnArray
END



;This function returns the true min and max value of the first array
;argument. True min and max means that the flt1 value of the
;corresponding min and max is defined, not NAN or not negative
FUNCTION getQminQmaxValue, flt0, flt1

flt1_size_array = size(flt1)
flt1_size = flt1_size_array[1]
flt1_GE0_index = where(flt1 GT 0)

flt0_tmp = fltarr(flt1_size)
flt0_tmp = flt0(flt1_GE0_index)

Qmin = min(flt0_tmp,max=Qmax,/nan)
QminQmax = [Qmin,Qmax]
return, QminQmax
END



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


;This function returns the number of element found in the droplist
;given
FUNCTION getNbrElementsInDroplist, Event, uname
  DropListId = widget_info(Event.top,find_by_uname=uname)
  nbr_elements = widget_info(DropListId, /droplist_number)
return, nbr_elements
END


;This function returns the current angle value from the text box
FUNCTION getCurrentAngleValue, Event
angleTextBoxId = widget_info(Event.top,find_by_uname='AngleTextField')
widget_control, angleTextBoxId, get_value=angleValue
return, angleValue
END


;This function outputs the value of the angle of the current selected
;file (degrees)
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

