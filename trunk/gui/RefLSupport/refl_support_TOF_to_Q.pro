;This function converts the TOF to Q 
PRO convert_TOF_to_Q, Event, angleValue
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt0 = (*(*global).flt0_xaxis)
flt0_array = size(flt0)
flt0_size = flt0_array[1]
Q = fltarr(flt0_size)

;get current angle value (in deg)
angleValue = float(angleValue)
print, 'angle value: ' + strcompress(angleValue) ;remove_me
;get current distance MD
dMD = getTextFieldValue(Event,'ModeratorDetectorDistanceTextField')
dMD = float(dMD)

h_over_mn = (*global).h_over_mn

CST = 4*!PI*sin((!PI * angleValue)/180)
for i=0,(flt0_size-1) do begin
    if (i EQ (flt0_size-1)) then begin
        lambda = h_over_mn * (flt0[i])
    endif else begin
        lambda = h_over_mn * ((flt0[i] + flt0[i+1])/2)
    endelse
    lambda /= dMD
    
    Q[i] = CST / lambda
end

;;get value of algorithm selected
;algorithmSelected = getTOFtoQalgorithmSelected(Event)
;if (algorithmSelected EQ 1) then begin  ;Jacobian method

;    flt1 = (*(*global).flt1_yaxis)
;    flt2 = (*(*global).flt2_yaxis_err)
    
;endif

(*(*global).flt0_xaxis) = Q



END
