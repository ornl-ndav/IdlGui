;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

;This function converts an angle from radian to degree
FUNCTION convert_rad_to_deg, RadValue
value1 = float(RadValue)*(float(180))
value  = value1 / float(!PI)
return, value
END

;This function converts a lenght from various units to millimetre
FUNCTION convert_to_mm, value, units
CASE (units) OF
    'metre': coefficient = long(1./1000)
    ELSE   : coefficient = 1
ENDCASE
RETURN, value*coefficient
END
    
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
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

;******************************************************************************
;******************************************************************************
FUNCTION idl_get_metadata::getAngle
RETURN, self.angle
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION idl_get_metadata::init, nexus_full_path
;open hdf5 nexus file
error_file = 0
CATCH, error_file
IF (error_file NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
ENDELSE
;get angle (theta)
self.angle  = get_theta_degree(fileID)
;close hdf5 nexus file
h5f_close, fileID
IF (self.angle NE '') THEN BEGIN
    RETURN, 1
ENDIF ELSE BEGIN
    RETURN, 0
ENDELSE
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO idl_get_metadata__define
struct = {idl_get_metadata,$
          nexus_full_path : '',$
          angle           : ''}
END
;******************************************************************************
;******************************************************************************

