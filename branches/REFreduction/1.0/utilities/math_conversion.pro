;This function converts an angle from radian to degree
FUNCTION convert_rad_to_deg, RadValue
value1 = float(RadValue)*(float(180))
value  = value1 / float(!PI)
return, value
END

;This function converts a lenght from various units to millimetre
FUNCTION convert_value_to_mm, value, units
CASE (units) OF
    'metre': coefficient = long(1./1000)
    ELSE   : coefficient = 1
ENDCASE
RETURN, value*coefficient
END
    
    
