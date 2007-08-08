;This is the main function that will do the scaling of all the loaded
;files one after the other
PRO ReflSupportStep3_AutomaticRescaling, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr
Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)

;get fitting order from settings tab
fitting_order_array = fix(getTextFieldValue(Event, 'poly_fit_order_text_box'))
fitting_order = fitting_order_array[0]

;get number of files loaded
nbrFile = (*global).NbrFilesLoaded
for i=1,(nbrFile-1) do begin

;get Qmin and Qmax
    Qmin = float(Qmin_array[i])
    Qmax = float(Qmax_array[i-1])

;;change the Q range
;    Qrange = (Qmax - Qmin)
;;remove 5% of first part and 50% of last part
;    Qmin = Qmin + (Qrange*5)/100
;    Qmax = Qmax - (Qrange*50)/100

;remove first two Q
    Qmax = 0.1
;HIGH Q file
;get flt0 of high Q file
    flt0_highQ = *flt0_ptr[i]
    flt1_highQ = *flt1_ptr[i]
    flt2_highQ = *flt2_ptr[i]

;determine the working indexes of flt0, flt1 and flt2 for high Q file
    RangeIndexes = getArrayRangeFromQ1Q2(flt0_highQ, Qmin, Qmax)
    left_index = RangeIndexes[0]
    right_index = RangeIndexes[1]
    
;determine working range of low Q file
    flt0_highQ_new = flt0_highQ[left_index:right_index]
    flt1_highQ_new = flt1_highQ[left_index:right_index]
    flt2_highQ_new = flt2_highQ[left_index:right_index]

;remove the non defined and inf values from flt0_highQ, flt1_highQ and flt2_highQ
    RangeIndexes = getArrayRangeOfNotNanValues(flt1_highQ_new)
    flt0_highQ_new = flt0_highQ_new(RangeIndexes)
    flt1_highQ_new = flt1_highQ_new(RangeIndexes)
    flt2_highQ_new = flt2_highQ_new(RangeIndexes)

;remove points that are error GE than their values
    RangeIndexes = getArrayRangeOfErrorGEValue(flt1_highQ_new, flt2_highQ_new)
    flt0_highQ_new = flt0_highQ_new(RangeIndexes)
    flt1_highQ_new = flt1_highQ_new(RangeIndexes)
    flt2_highQ_new = flt2_highQ_new(RangeIndexes)

;store flt0_highQ_new into flt0_pointer[0]
    flt0_ptr = (*global).flt0_range
    *flt0_ptr[0] = flt0_highQ_new
    (*global).flt0_range = flt0_ptr

;start function that will calculate the fit parameters
    FitOrder_n_Function, Event, flt0_highQ_new, flt1_highQ_new, flt2_highQ_new, i, fitting_order

;LOW Q file
;get flt0 of low Q file
    flt0_lowQ = *flt0_ptr[i-1]
    flt1_lowQ = *flt1_ptr[i-1]
    flt2_lowQ = *flt2_ptr[i-1]

;determine the working indexes of flt0, flt1 and flt2 for low Q file
    RangeIndexes = getArrayRangeFromQ1Q2(flt0_lowQ, Qmin, Qmax)
    left_index = RangeIndexes[0]
    right_index = RangeIndexes[1]
    
;determine working range of high Q file
    flt0_lowQ_new = flt0_lowQ[left_index:right_index]
    flt1_lowQ_new = flt1_lowQ[left_index:right_index]
    flt2_lowQ_new = flt2_lowQ[left_index:right_index]

;remove the non defined and inf values from flt0_lowQ, flt1_lowQ and flt2_lowQ
    RangeIndexes = getArrayRangeOfNotNanValues(flt1_lowQ_new)
    flt0_lowQ_new = flt0_lowQ_new(RangeIndexes)
    flt1_lowQ_new = flt1_lowQ_new(RangeIndexes)
    flt2_lowQ_new = flt2_lowQ_new(RangeIndexes)

;remove points that are error GE than their values
    RangeIndexes = getArrayRangeOfErrorGEValue(flt1_LowQ_new, flt2_LowQ_new)
    flt0_LowQ_new = flt0_LowQ_new(RangeIndexes)
    flt1_LowQ_new = flt1_LowQ_new(RangeIndexes)
    flt2_LowQ_new = flt2_LowQ_new(RangeIndexes)

;store flt0_LowQ_new into flt0_pointer[1]
    *flt0_ptr[1] = flt0_LowQ_new
    (*global).flt0_range = flt0_ptr

;start function that will calculate the fit parameters
    FitOrder_n_Function, Event, flt0_lowQ_new, flt1_lowQ_new, flt2_lowQ_new, i-1, fitting_order

endfor

plot_loaded_file, Event, '2plots'

END




;This function displays in the Qmin and Qmax text fields the 
;Qmin and Qmax of the CE file
PRO ReflSupportStep3_display_Q_values, Event,index
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)

if (index EQ 0) then begin
    Qmin_text = ''
    Qmax_text = ''
endif else begin
    Qmin_text = Qmin_array[index]
    Qmax_text = Qmax_array[index-1]
endelse
ReflSupportWidget_setValue, Event, 'Step3ManualQMinTextField', Qmin_text
ReflSupportWidget_setValue, Event, 'Step3ManualQMaxTextField', Qmax_text

END



;This function displays the base file name unless the first file is
;selected, in this case, it shows that the working file is the CE file
PRO  ReflSupportStep3_displayLowQFileName, Event, indexSelected
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (indexSelected EQ 0) then begin
    textHighQ = 'C.E. file ->'
    textLowQ  = ''
    text      = ''
endif else begin
    textLowQ  = 'Low Q file:'
    textHighQ = 'High Q file:'
    list_of_files = (*(*global).list_of_files)
    text = list_of_files[indexSelected-1]
endelse
putValueInLabel, Event, 'Step3ManualModeLowQFileLabel',textLowQ
putValueInLabel, Event, 'Step3ManualModeHighQFileLabel',textHighQ
putValueInLabel, Event, 'Step3ManualModeLowQFileName',text
END



;This function is reached only when the CE file of step 3 has been
;selected in the droplist. In this case, all the widgets of the manual
;scalling box are hidden
PRO ReflSupportStep3_DisableManualScalingBox, Event
ReflSupportWidget_HideBase, Event, 'Step3ManualModeHiddenFrame', 1
END


;This function is reached only when the selected file in the step 3
;droplist is any of the file except the first one (CE file). In this
;case, all the widgets of the manual scalling box are shown.
PRO ReflSupportStep3_EnableManualScalingBox, Event
ReflSupportWidget_HideBase, Event, 'Step3ManualModeHiddenFrame', 0
END
