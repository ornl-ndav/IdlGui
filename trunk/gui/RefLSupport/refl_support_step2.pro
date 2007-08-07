;This function save Q1, Q2 and SF of the Critical Edge file selected
PRO ReflSupportStep2_fitCE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get long name of CE file
CE_LongFileName = (*global).full_CE_name

;get Q1 and Q2
Q1Q2SF = getQ1Q2SF(Event, 'STEP2')
Q1 = float(Q1Q2SF[0])
Q2 = float(Q1Q2SF[1])

;store the values of Q1 and Q2 for CE
Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
Q1_array[0]=Q1
Q2_array[0]=Q2
(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array

;fit CE file and determine scaling factor
LoadCEFile, Event, CE_LongFileName, Q1, Q2

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



;This function is the next step (after the fitting) to
;bring to 1 the average Q1 to Q2 part of CE
PRO ReflSupportStep2_scaleCE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;change the value of the ymax and ymin in the zoom box to 1.2 and 0
putValueInTextField, Event, 'YaxisMaxTextField', (*global).rescaling_ymax
putValueInTextField, Event, 'YaxisMinTextField', (*global).rescaling_ymin

;replot CE data with new scale
plot_rescale_CE_file, Event

END




PRO LoadCEFile, Event, CE_file_name, Q1, Q2
;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr
flt0 = *flt0_ptr[0]
flt1 = *flt1_ptr[0]
flt2 = *flt2_ptr[0]

;determine the working flt0, flt1 and flt2
RangeIndexes = getArrayRangeFromQ1Q2(flt0, Q1, Q2)
left_index = RangeIndexes[0]
right_index = RangeIndexes[1]

flt0_new = flt0[left_index:right_index]
flt1_new = flt1[left_index:right_index]
flt2_new = flt2[left_index:right_index]

;remove the non defined and inf values from flt0, flt1 and flt2
RangeIndexes = getArrayRangeOfNotNanValues(flt1_new)
flt0_new = flt0_new(RangeIndexes)
flt1_new = flt1_new(RangeIndexes)
flt2_new = flt2_new(RangeIndexes)

(*(*global).flt0_CE_range) = flt0_new

;Start function that will calculate the Fit function
FitCEFunction, Event, flt0_new, flt1_new, flt2_new
LongFileNameArray = [CE_file_name]
plot_loaded_file, Event, 'CE'

;display the value of the coeff in the A and B text boxes
cooef = (*(*global).CEcooef)
putValueInTextField, Event, 'step2_fitting_equation_a_text_field', strcompress(cooef[1])
putValueInTextField, Event, 'step2_fitting_equation_b_text_field', strcompress(cooef[0])

END








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
diff = Q2-Q1
delta = diff/Nbr_elements

;x_axis is composed (Nbr_elements+1)
x_axis=(findgen(Nbr_elements+1))*delta + Q1

;y_axis
y_axis=a*x_axis+b

AverageValue = total(y_axis)/(Nbr_elements+1)
(*global).CE_scaling_factor = AverageValue

;display value in Ybefore text field
putValueInTextField, Event, 'step2_y_before_text_field', strcompress(AverageValue)

END




;Manual fitting of CE file using loaded parameters
PRO manualCEfitting, Event
;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cooef1 = getValue(Event, 'step2_fitting_equation_a_text_field')
cooef0 = getValue(Event, 'step2_fitting_equation_b_text_field')

cooef1 = getNumeric(cooef1)
cooef0 = getNumeric(cooef0)

(*(*global).CEcooef) = [cooef0,cooef1]

plot_loaded_file, Event, (*global).full_CE_name

END




;This function plots the selected file
PRO plot_rescale_CE_file, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

IsXlin = getScale(Event,'X')
IsYlin = getScale(Event,'Y')

color_array = (*(*global).color_array)

DEVICE, DECOMPOSED = 0
loadct,5
    
flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr
            
;retrieve particular flt0, flt1 and flt2
flt0 = *flt0_ptr[0]
flt1 = *flt1_ptr[0]
flt2 = *flt2_ptr[0]

;divide by scaling factor
CE_scaling_factor = (*global).CE_scaling_factor
flt1 = flt1/CE_scaling_factor
flt2 = flt2/sqrt(CE_scaling_factor)

cooef = (*(*global).CEcooef)
if (cooef[0] NE 0 AND $
    cooef[1] NE 0) then begin
    cooef[0] /= CE_scaling_factor
    Cooef[1] /= CE_scaling_Factor
endif
(*(*global).CEcooef) = cooef

;save new values
flt0_rescale_ptr = (*global).flt0_rescale_ptr
*flt0_rescale_ptr[0] = flt0
(*global).flt0_rescale_ptr = flt0_rescale_ptr

flt1_rescale_ptr = (*global).flt1_rescale_ptr
*flt1_rescale_ptr[0] = flt1
(*global).flt1_rescale_ptr = flt1_rescale_ptr

flt2_rescale_ptr = (*global).flt2_rescale_ptr
*flt2_rescale_ptr[0] = flt2
(*global).flt2_rescale_ptr = flt2_rescale_ptr

;end of rescaling part

colorIndex = color_array[0]

XYMinMax = getXYMinMax(Event)
xmin = float(XYMinMax[0])
xmax = float(XYMinMax[1])
ymin = float(XYMinMax[2])
ymax = float(XYMinMax[3])

case IsXlin of
    0:begin
        case IsYlin of
            0: begin
                plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax]
            end
            1: begin
                plot,flt0,flt1,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax]
            end
        endcase
    end
    1: begin
        case IsYlin of
            0: begin
                plot,flt0,flt1,/xlog,xrange=[xmin,xmax],yrange=[ymin,ymax]
            end
            1: begin
                plot,flt0,flt1,/xlog,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax]
            end
        endcase
    end
endcase            

errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex

;polynome of degree 1 for CE 
if (cooef[0] NE 0 AND $
    cooef[1] NE 0) then begin
    show_error_plot=1
    flt0_new = (*(*global).flt0_CE_range)
    y_new = cooef(1)*flt0_new + cooef(0)
    oplot,flt0_new,y_new,color=400,thick=1.5
endif

END





