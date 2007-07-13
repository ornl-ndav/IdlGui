;This function converts the TOF to Q 
PRO convert_TOF_to_Q, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt0 = (*(*global).flt0_xaxis)

;get current angle value (in rad)
angleValue = getAngleValue(Event)
angleValue = float(angleValue)

;get current distance MD
dMD = getTextFieldValue(Event,'AngleTextField')
dMD = float(dMD)

h_over_mn = (*global).h_over_mn
CST = 4*!PI*sin(angleValue/2)
CST /= h_over_mn
CST *= dMD

flt0_size_array = size(flt0)
flt0_size = flt0_size_array[1]
for i=0,(flt0_size-1) do begin
    flt0[i]=CST/(flt0[i]*1E-6)
end

;get value of algorithm selected
algorithmSelected = getTOFtoQalgorithmSelected(Event)
if (algorithmSelected EQ 1) then begin  ;Jacobian method

    flt1 = (*(*global).flt1_yaxis)
    flt2 = (*(*global).flt2_yaxis_err)
    
endif

(*(*global).flt0_xaxis) = flt0

END
