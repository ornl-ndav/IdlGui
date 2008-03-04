;This function converts the TOF to Q 
PRO convert_TOF_to_Q, Event, angleValue
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt0       = (*(*global).flt0_xaxis)
flt0_array = size(flt0)
flt0_size  = flt0_array[1]
Q          = fltarr(flt0_size)

;get current angle value (in deg)
angleValue = float(angleValue)
;get current distance MD
dMD = getTextFieldValue(Event,'ModeratorDetectorDistanceTextField')
dMD = float(dMD)

h_over_mn = (*global).h_over_mn

CST = 4*!PI*sin((!PI * angleValue)/180)
FOR i=0,(flt0_size-1) DO BEGIN
    IF (i EQ (flt0_size-1)) THEN BEGIN
        lambda = h_over_mn * (flt0[i])
    ENDIF ELSE BEGIN
        lambda = h_over_mn * ((flt0[i] + flt0[i+1])/2)
    ENDELSE
    lambda /= dMD
    
    Q[i] = CST / lambda
END

(*(*global).flt0_xaxis) = Q

END
