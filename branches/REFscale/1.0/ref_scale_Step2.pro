;###############################################################################
;*******************************************************************************

PRO LoadCEFile, Event, CE_file_name, Q1, Q2

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr
flt0     = *flt0_ptr[0]
flt1     = *flt1_ptr[0]
flt2     = *flt2_ptr[0]

;determine the working flt0, flt1 and flt2
RangeIndexes = getArrayRangeFromQ1Q2(flt0, Q1, Q2) ;_get
left_index   = RangeIndexes[0]
right_index  = RangeIndexes[1]

flt0_new = flt0[left_index:right_index]
flt1_new = flt1[left_index:right_index]
flt2_new = flt2[left_index:right_index]

;remove the non defined and inf values from flt0, flt1 and flt2
RangeIndexes = getArrayRangeOfNotNanValues(flt1_new) ;_get
flt0_new     = flt0_new(RangeIndexes)
flt1_new     = flt1_new(RangeIndexes)
flt2_new     = flt2_new(RangeIndexes)

(*(*global).flt0_CE_range) = flt0_new

;Start function that will calculate the Fit function
FitCEFunction, Event, flt0_new, flt1_new, flt2_new ;_fit
LongFileNameArray = [CE_file_name]
plot_loaded_file, Event, 'CE' ;_Plot

;display the value of the coeff in the A and B text boxes
cooef = (*(*global).CEcooef)
putValueInTextField, Event, $
  'step2_fitting_equation_a_text_field', $
  strcompress(cooef[1])         ;_put
putValueInTextField, Event, $
  'step2_fitting_equation_b_text_field', $
  strcompress(cooef[0])         ;_put

END

;*******************************************************************************

;this function will calculate the average Y value between Q1 and Q2 of
;the fitted function for CE only
PRO CalculateAverageFittedY, Event, Q1, Q2

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

CEcooef = (*(*global).CEcooef)
;y=ax+b
b=CEcooef[0]
a=CEcooef[1]

;create an array of Nbr_elements = 100 elements between Q1 and Q2
Nbr_elements = 100
diff         = Q2-Q1
delta        = diff / Nbr_elements

;x_axis is composed (Nbr_elements+1)
x_axis = (findgen(Nbr_elements+1))*delta + Q1

;y_axis
y_axis = a * x_axis + b

AverageValue = total(y_axis)/(Nbr_elements+1)
(*global).CE_scaling_factor = AverageValue

;display value in Ybefore text field
putValueInTextField, Event, $
  'step2_y_before_text_field', $
  strcompress(AverageValue)     ;_put

END

;*******************************************************************************

;This function save Q1, Q2 and SF of the Critical Edge file selected
PRO Step2_fitCE, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get long name of CE file
CE_LongFileName       = (*global).full_CE_name
;get Q1 and Q2
Q1Q2SF                = getQ1Q2SF(Event, 'STEP2') ;_get
Q1                    = float(Q1Q2SF[0])
Q2                    = float(Q1Q2SF[1])
;store the values of Q1 and Q2 for CE
Q1_array              = (*(*global).Q1_array)
Q2_array              = (*(*global).Q2_array)
Q1_array[0]           = Q1
Q2_array[0]           = Q2
(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array

;fit CE file and determine scaling factor
LoadCEFile, Event, CE_LongFileName, Q1, Q2 ;_Step2

;calculate average Y before rescaling
CalculateAverageFittedY, Event, Q1, Q2

;show the scalling factor (but do not replot it)
;get the average Y value before
Ybefore = getTextFieldValue(Event, 'step2_y_before_text_field')
Yafter  = getTextFieldValue(Event, 'step2_y_after_text_field')

;check if Ybefore is numeric or not
YbeforeIsNumeric = isNumeric(Ybefore)
YafterIsNumeric  = isNumeric(Yafter)

;Ybefore and Yafter are numeric
if (YbeforeIsNumeric EQ 1 AND $
    YafterIsNumeric EQ 1) then begin

   Ybefore = getNumeric(Ybefore)
   Yafter  = getNumeric(Yafter)

  ;put scaling factor in its box
   scaling_factor = float(Ybefore) / float(Yafter)
   (*global).CE_scaling_factor = scaling_factor

  ;activate scaling button once the fitting is done
   ActivateButton, Event, 'step2_automatic_scaling_button', 1

endif else begin ;scaling factor can be calculated
   
   scaling_factor = 'NaN'
  ;desactivate scaling button once the fitting is done
   ActivateButton, Event, 'step2_automatic_scaling_button', 0

endelse   

putValueInTextField, Event,'step2_sf_text_field', scaling_factor

END

;*******************************************************************************

;This function is the next step (after the fitting) to
;bring to 1 the average Q1 to Q2 part of CE
PRO Step2_scaleCE, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;change the value of the ymax and ymin in the zoom box to 1.2 and 0
putValueInTextField, Event, 'YaxisMaxTextField', (*global).rescaling_ymax ;_put
putValueInTextField, Event, 'YaxisMinTextField', (*global).rescaling_ymin ;_put

;replot CE data with new scale
plot_rescale_CE_file, Event ;_Plot

END


;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^

;when using automatic fitting and scaling of CE (step2)
PRO run_full_step2, Event

Step2_fitCE, Event ;_Step2

;show the scalling factor (but do not replot it)
;get the average Y value before
Ybefore = getTextFieldValue(Event, 'step2_y_before_text_field') ;_get
Yafter  = getTextFieldValue(Event, 'step2_y_after_text_field') ;_get

;check if Ybefore is numeric or not
YbeforeIsNumeric = isNumeric(Ybefore) ;_is
YafterIsNumeric  = isNumeric(Yafter) ;_is

;Ybefore and Yafter are numeric
IF (YbeforeIsNumeric EQ 1 AND $
    YafterIsNumeric EQ 1) THEN BEGIN
    
    putValueInLabel, Event, 'step2_qminqmax_error_label', '' ;_put
    Step2_scaleCE, Event        ;_Step2
    
ENDIF ELSE BEGIN ;scaling factor can be calculated so second step (scaling) 
;automatic mode can be performed.
    
;display message in Q1 and Q2 boxe saying that auto stopped
    putValueInLabel, Event, 'step2_qminqmax_error_label', $
      '**ERROR: Select another range of Qs**'
    
ENDELSE   
END

;###############################################################################
;*******************************************************************************

;###############################################################################
;*******************************************************************************

;###############################################################################
;*******************************************************************************
