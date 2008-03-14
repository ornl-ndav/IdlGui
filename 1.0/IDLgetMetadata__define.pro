;This class method returns the Run Number of the given nexus
FUNCTION get_RunNumber, fileID
run_number_path = '/entry/run_number/'
error_value = 0
CATCH, error_value
IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID, run_number_path)
    run_number = h5d_read(pathID)
    h5d_close, pathID
    RETURN, run_number
ENDELSE
END

;This class method returns the s1b value
FUNCTION get_s1b, fileID
s1b_path   = '/entry/instrument/aperture1/s1b/value/'
error_value = 0
CATCH, error_value
IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID,s1b_path)
    s1b        = h5d_read(pathID)
    h5d_close, pathID
    RETURN, s1b
ENDELSE
END

;This function returns the units of s1b
FUNCTION get_s1b_units, fileID
s1b_units_path = '/entry/instrument/aperture1/s1b/value/'
error_units = 0
CATCH, error_units
IF (error_units NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID         = h5d_open(fileID,s1b_units_path)
    pathUnitsID    = h5a_open_name(pathID,'units')
    s1b_units      = h5a_read(pathUnitsID)
    h5a_close, pathUnitsID
    h5d_close, pathID
    RETURN, s1b_units
ENDELSE
END

;This function returns s1b in mm
FUNCTION get_s1b_mm, fileID
s1b_value = get_s1b(fileID)
s1b_units = get_s1b_units(fileID)
CASE (s1b_units) OF
    'millimetre': RETURN, convert_to_mm(s1b_value,s1b_units)
    'radian'    : RETURN, s1b_value
    ELSE        : RETURN, 'N/A'
ENDCASE       
END

;This class method returns the s1t value
FUNCTION get_s1t, fileID
s1t_path   = '/entry/instrument/aperture1/s1t/value/'
error_value = 0
CATCH, error_value
IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID,s1t_path)
    s1t        = h5d_read(pathID)
    h5d_close, pathID
    RETURN, s1t
ENDELSE
END

;This function returns the units of s1t
FUNCTION get_s1t_units, fileID
s1t_units_path = '/entry/instrument/aperture1/s1t/value/'
error_units = 0
CATCH, error_units
IF (error_units NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID         = h5d_open(fileID,s1t_units_path)
    pathUnitsID    = h5a_open_name(pathID,'units')
    s1t_units      = h5a_read(pathUnitsID)
    h5a_close, pathUnitsID
    h5d_close, pathID
    RETURN, s1t_units
ENDELSE
END

;This function returns s1t in mm
FUNCTION get_s1t_mm, fileID
s1t_value = get_s1t(fileID)
s1t_units = get_s1t_units(fileID)
CASE (s1t_units) OF
    'millimetre': RETURN, convert_to_mm(s1t_value,s1t_units)
    'metre'     : RETURN, s1t_value
    ELSE        : RETURN, 'N/A'
ENDCASE
END

;This class method returns the S1 value (in mm)
FUNCTION get_s1_mm, fileID
s1t       = get_s1t_mm(fileID)
s1b       = get_s1b_mm(fileID)
IF (strcompress(s1t,/remove_all) NE 'N/A' AND strcompress(s1b,/remove_all) NE 'N/A') THEN BEGIN
    RETURN, ABS(s1t-s1b)
ENDIF ELSE BEGIN
    RETURN, 'N/A'
ENDELSE
END






;This class method returns the s2b value
FUNCTION get_s2b, fileID
s2b_path   = '/entry/instrument/aperture2/s2b/value/'
error_value = 0
CATCH, error_value
IF (error_value NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID,s2b_path)
    s2b        = h5d_read(pathID)
    h5d_close, pathID
    RETURN, s2b
ENDELSE
END

;This function returns the units of s2b
FUNCTION get_s2b_units, fileID
s2b_units_path = '/entry/instrument/aperture2/s2b/value/'
error_units = 0
CATCH, error_units
IF (error_units NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,''
ENDIF ELSE BEGIN
    pathID         = h5d_open(fileID,s2b_units_path)
    pathUnitsID    = h5a_open_name(pathID,'units')
    s2b_units      = h5a_read(pathUnitsID)
    h5a_close, pathUnitsID
    h5d_close, pathID
    RETURN, s2b_units
ENDELSE
END

;This function returns s2b in mm
FUNCTION get_s2b_mm, fileID
s2b_value = get_s2b(fileID)
s2b_units = get_s2b_units(fileID)
CASE (s2b_units) OF 
    'millimetre': RETURN, convert_to_mm(s2b_value,s2b_units)
    'metre'     : RETURN, s2b_value
    ELSE        : RETURN, 'N/A'
ENDCASE
END

;This class method returns the s2t value
FUNCTION get_s2t, fileID
s2t_path   = '/entry/instrument/aperture2/s2t/value/'
error_value = 0
CATCH, error_value
IF (error_value NE 0) THEN BEGIN
    CATCH,/cancel
    RETURN, ''
ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID,s2t_path)
    s2t        = h5d_read(pathID)
    h5d_close, pathID
    RETURN, s2t
ENDELSE
END

;This function returns the units of s2t
FUNCTION get_s2t_units, fileID
s2t_units_path = '/entry/instrument/aperture2/s2t/value/'
error_units = 0
CATCH, error_units
IF (error_units NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID         = h5d_open(fileID,s2t_units_path)
    pathUnitsID    = h5a_open_name(pathID,'units')
    s2t_units      = h5a_read(pathUnitsID)
    h5a_close, pathUnitsID
    h5d_close, pathID
    RETURN, s2t_units
ENDELSE
END

;This function returns s2t in mm
FUNCTION get_s2t_mm, fileID
s2t_value = get_s2t(fileID)
s2t_units = get_s2t_units(fileID)
CASE (s2t_units) OF 
    'millimetre': RETURN, convert_to_mm(s2t_value,s2t_units)
    'metre'     : RETURN, s2t_value
    ELSE        : RETURN, 'N/A'
ENDCASE
END

;This class method returns the S2 value (in mm)
FUNCTION get_s2_mm, fileID
s2t       = get_s2t_mm(fileID)
s2b       = get_s2b_mm(fileID)
IF (strcompress(s2t,/remove_all) NE 'N/A' AND strcompress(s2b,/remove_all) NE 'N/A') THEN BEGIN
    RETURN, ABS(s2t-s2b)
ENDIF ELSE BEGIN
    RETURN, 'N/A'
ENDELSE
END




;This class method returns the theta angle units
FUNCTION get_theta_units, fileID
theta_units_path = '/entry/instrument/bank1/Theta/readback/'
error_units = 0
CATCH, error_units
IF (error_units NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID           = h5d_open(fileID,theta_units_path)
    pathUnitsID      = h5a_open_name(pathID,'units')
    theta_units      = h5a_read(pathUnitsID)
    h5a_close, pathUnitsID
    h5d_close, pathID
    RETURN, theta_units
ENDELSE
END

;This class method returns theta angle value
FUNCTION get_theta, fileID
theta_path = '/entry/instrument/bank1/Theta/readback/'
error_value = 0
CATCH, error_value
IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
ENDIF ELSE BEGIN
    pathID       = h5d_open(fileID,theta_path)
    theta        = h5d_read(pathID)
    h5d_close, pathID
    RETURN, theta
ENDELSE
END

;This function returns Theta in degrees
FUNCTION get_theta_degree, fileID
theta_value = get_theta(fileID)
theta_units = get_theta_units(fileID)
CASE (theta_units) OF
    'degree' : RETURN, theta_value
    'radian' : RETURN, convert_rad_to_deg(theta_value)
    ELSE: return, 'N/A'
ENDCASE
END



FUNCTION IDLgetMetadata::getAngle
RETURN, self.angle
END

FUNCTION IDLgetMetadata::getS1
RETURN, self.S1
END

FUNCTION IDLgetMetadata::getS2
RETURN, self.S2
END


FUNCTION IDLgetMetadata::getRunNumber
RETURN, self.RunNumber
END


;***** Class constructor ******
FUNCTION IDLgetMetadata::init, nexus_full_path

;open hdf5 nexus file
fileID = h5f_open(nexus_full_path)

;get angle (theta)
self.angle     = get_theta_degree(fileID)
;get s1
self.S1        = get_s1_mm(fileID)
;get s2
self.S2        = get_s2_mm(fileID)
;get RunNumber
self.RunNumber = get_RunNumber(fileID)

;close hdf5 nexus file
h5f_close, fileID

IF (self.angle NE '' AND $
    self.S1 NE '' AND $
    self.S2 NE '') THEN BEGIN
    RETURN, 1
ENDIF ELSE BEGIN
    RETURN, 0
ENDELSE
END



PRO IDLgetMetadata__define
struct = {IDLgetMetadata,$
          RunNumber       : '',$
          nexus_full_path : '',$
          angle           : '',$
          S1              : '',$
          S2              : ''}
END
