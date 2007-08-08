;This function rescale manually the working file using the new SF 
PRO ReflSupportStep3_RescaleFile, Event, delta_SF

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr

;get value of current SF
sSF = getTextFieldValue(Event,'Step3SFTextField')
SF = float(sSF)
SF += float(delta_SF)

if (SF LE 0) then begin
    SF = float(0.0001)
endif

;put new SF value in text box
putValueInTextField, Event,'Step3SFTextField',SF

;get selected index of droplist
index = getSelectedIndex(Event,'step3_work_on_file_droplist')

flt1 = *flt1_ptr[index]
flt2 = *flt2_ptr[index]

SF = SF[0]

;rescale data
flt1 = flt1 / SF
flt2 = flt2 / sqrt(SF)

flt1_rescale_ptr = (*global).flt1_rescale_ptr
flt2_rescale_ptr = (*global).flt2_rescale_ptr

*flt1_rescale_ptr[index] = flt1
*flt2_rescale_ptr[index] = flt2

(*global).flt1_rescale_ptr = flt1_rescale_ptr
(*global).flt2_rescale_ptr = flt2_rescale_ptr

plot_loaded_file, Event, '2plots'

;this function displays in step3 the list of flt0, flt1 for low Q file
;and flt1 for high Q file
ReflSupportStep3_OutputFlt0Flt1, Event

END


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
    text2     = ''
endif else begin
    textLowQ  = 'Low Q file:'
    textHighQ = 'High Q file:'
    list_of_files = (*(*global).list_of_files)
    text = list_of_files[indexSelected-1]
    text2 = list_of_files[indexSelected]
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



;This function displays the flt0, flt1 array of the low Q file and the flt1
;array of the high Q file
PRO ReflSupportStep3_OutputFlt0Flt1, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get selected index of droplist
index = getSelectedIndex(Event,'step3_work_on_file_droplist')

flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr

flt0_lowQ   = *flt0_ptr[index-1]
flt0_highQ  = *flt0_ptr[index]
flt1_lowQ   = *flt1_ptr[index-1]
flt1_highQ  = *flt1_ptr[index]
Q1 = (*(*global).Qmin_array)
Q2 = (*(*global).Qmax_array)

;Qmin and Qmax
QminHighQ = Q1[index]
QmaxLowQ  = Q2[index-1]

;remove -inf, inf and NAN values from flt1_lowQ and flt1_highQ
flt1_lowQ_range = getArrayRangeOfNotNanValues(flt1_lowQ)
flt1_lowQ = flt1_lowQ(flt1_lowQ_range)
flt0_lowQ = flt0_lowQ(flt1_lowQ_range)

flt1_highQ_range = getArrayRangeOfNotNanValues(flt1_highQ)
flt1_highQ = flt1_highQ(flt1_highQ_range)
flt0_highQ = flt0_highQ(flt1_highQ_range)

;get index of values inside range of data
;check where to start, Qmin of HighQ for each flt0
flt0_lowQ_index_array = getArrayRangeFromQ1Q2(flt0_LowQ, QminHighQ, QmaxLowQ)
flt0_lowQ = flt0_lowQ[flt0_lowQ_index_array[0]:flt0_lowQ_index_array[1]]
flt1_lowQ = flt1_lowQ[flt0_lowQ_index_array[0]:flt0_lowQ_index_array[1]]

flt0_highQ_index_array = getArrayRangeFromQ1Q2(flt0_HighQ, QminHighQ, QmaxLowQ)
flt0_highQ = flt0_highQ[flt0_highQ_index_array[0]:flt0_highQ_index_array[1]]
flt1_highQ = flt1_highQ[flt0_highQ_index_array[0]:flt0_highQ_index_array[1]]

;create master_flt0 (addtion of flt0_low and flt0_high)
;WORK on flt0
flt0_lowQ  = flt0_lowQ[sort(flt0_lowQ)]
flt0_highQ = flt0_highQ[sort(flt0_highQ)]
flt0 = [flt0_lowQ, flt0_highQ]
flt0_uniq = flt0[uniq(flt0,sort(flt0))]
flt0_size = (size(flt0_uniq))(1)

nbr_to_display = float(getTextFieldValue(Event,'nbrDataTextField'))

if (nbr_to_display LE flt0_size) then begin
    max_number = nbr_to_display
endif else begin
    max_number = flt0_size
endelse

max_number = max_number[0]

i_lowQ  = 0
i_highQ = 0
for i=0,(max_number-1) do begin
    text = strcompress(flt0_uniq[i])
    text += "      "
    if (flt0_lowQ[i_lowQ] EQ flt0_uniq[i]) then begin
        print, 'in 1'
        text += strcompress(flt1_lowQ[i_lowQ])
        i_lowQ += 1
    endif
    text += "      "
    if (flt0_highQ[i_highQ] EQ flt0_uniq[i]) then begin
        print, 'in 2'
        text += strcompress(flt1_highQ[i_highQ])
        i_highQ += 1
    endif

    if (i EQ 0) then begin
        putValueInTextField,Event,'step3_flt_text_filed',text
    endif else begin
        appendValueInTextField,Event,'step3_flt_text_filed',text
    endelse
endfor

END


