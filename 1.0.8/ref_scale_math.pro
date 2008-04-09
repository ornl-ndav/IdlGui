;###############################################################################
;*******************************************************************************

;This function converts the input angle into deg
FUNCTION convert_to_deg, f_angle_rad
f_angle_deg_local = (180 * f_angle_rad) / !PI
RETURN, f_angle_deg_local
END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^

;This functions gets the current angle value
;and do the conversion if necessary (in degree)
PRO get_angle_value_and_do_conversion, Event, angleValue

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check status of deg/rad button
AngleUnitsId = widget_info(Event.top,find_by_uname='AngleUnits')
widget_control, AngleUnitsId, get_value=indexSelected

IF (indexSelected NE 1) THEN BEGIN ;rad
    IDLsendToGeek_addLogBookText, Event, '--> Angle Value : ' + $
      STRCOMPRESS(angleValue,/REMOVE_ALL) + ' radians'
    IDLsendToGeek_addLogBookText, Event, '---> Conversion to degrees :'
    f_angle_deg           = convert_to_deg(float(angleValue))
    IDLsendToGeek_addLogBookText, Event, '--> Angle Value : ' + $
      STRCOMPRESS(f_angle_deg,/REMOVE_ALL) + ' degrees'
    (*global).angleValue  = f_angle_deg
;copy new value into text field
    AngleTextFieldId = widget_info(Event.top,find_by_uname='AngleTextField')
    widget_control, AngleTextFieldId, $
      set_value=strcompress(f_angle_deg,/remove_all)
;reverse status of rad/degree button
    widget_control, AngleUnitsId, set_value=1
ENDIF ELSE BEGIN
    IDLsendToGeek_addLogBookText, Event, '--> Angle Value : ' + $
      STRCOMPRESS(angleValue,/REMOVE_ALL) + ' degrees'
ENDELSE
END

;###############################################################################
;*******************************************************************************
