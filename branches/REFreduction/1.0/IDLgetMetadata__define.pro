;This class method returns the tthd angle value
FUNCTION get_tthd, fileID
tthd_path = '/entry/instrument/bank1/tthd/value/'
pathID    = h5d_open(fileID,tthd_path)
tthd      = h5d_read(pathID)
h5d_close, pathID
RETURN, tthd
END

;This class method returns the tthd angle units
FUNCTION get_tthd_units, fileID
tthd_units_path = '/'
pathID          = h5d_open(fileID,tthd_units_path)
tthd_units      = h5d_read(pathID)
h5d_close, pathID
RETURN, tthd_units
END

;This class method returns the s1b value
FUNCTION get_s1b, fileID
s1b_path   = '/entry/instrument/aperture1/s1b/value/'
pathID     = h5d_open(fileID,s1b_path)
s1b        = h5d_read(pathID)
h5d_close, pathID
RETURN, s1b
END

;This class method returns the s1t value
FUNCTION get_s1t, fileID
s1t_path   = '/entry/instrument/aperture1/s1t/value/'
pathID     = h5d_open(fileID,s1t_path)
s1t        = h5d_read(pathID)
h5d_close, pathID
RETURN, s1t
END

;This class method returns the s2b value
FUNCTION get_s2b, fileID
s2b_path   = '/entry/instrument/aperture1/s2b/value/'
pathID     = h5d_open(fileID,s2b_path)
s2b        = h5d_read(pathID)
h5d_close, pathID
RETURN, s2b
END

;This class method returns the s2t value
FUNCTION get_s2t, fileID
s2t_path   = '/entry/instrument/aperture1/s2t/value/'
pathID     = h5d_open(fileID,s2t_path)
s2t        = h5d_read(pathID)
h5d_close, pathID
RETURN, s2t
END

;This class method returns the tthd angle units
FUNCTION get_tthd_units, fileID
tthd_units_path = '/entry/instrument/aperture1/s1b/'
pathID          = h5d_open(fileID,tthd_units_path)
tthd_units      = h5d_read(pathID)
h5d_close, pathID
RETURN, tthd_units
END

;This class method returns the thi angle value
FUNCTION get_thi, fileID
thi_path   = '/entry/instrument/aperture1/


;This function returns the angle (2*tthd - thi)
FUNCTION getAngleInDegrees, fileID
tthd         = get_tthd(fileID)
;tthd_units   = get_tthd_units(fileID)

;tthd_degrees = get_tthd_degrees(tthd,tthd_units)

thi         = get_thi(fileID)
;thi_units   = get_thi_units(nexus_full_path)
;thi_degrees = get_thi_degrees(thi,thi_units) 

;angle = 2*tthd_degrees - thi_degrees

;RETURN, strcompress(angle,/remove_all)
RETURN, strcompress(tthd,/remove_all) ;remove_me
END



;This class method returns the S1 value (in mm)
FUNCTION getS1InMm, fileID
S1       = get_s1(fileID)
S1_units = get_s2_units(fileID)
S1_mm    = getValueInMm(S1,S1_units)
RETURN, strcompress(S1_mm,/remove_all)
END



;This class method returns the S2 value (in mm)
FUNCTION getS2InMm, fileID
S2       = get_s2(fileID)
S2_units = get_s2_units(fileID)
S2_mm    = getValueInMm(S2,S2_units)
RETURN, strcompress(S2_mm,/remove_all)
END





;***** Class constructor ******
FUNCTION IDLgetMetadata::init, nexus_full_path

;open hdf5 nexus file
fileID = h5f_open(nexus_full_path)

;get angle
self.angle = getAngleInDegrees(fileID)
;get s1
self.S1    = getS1InMm(fileID)
;get s2
self.S2    = getS2InMm(fileID)

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
          nexus_full_path : '',$
          angle           : '',$
          S1              : '',$
          S2              : ''}
END
