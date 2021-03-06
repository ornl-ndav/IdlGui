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

;This class method returns the Run Number of the given nexus
FUNCTION get_RunNumber, fileID, pola_state_name
  IF (N_ELEMENTS(POLA_STATE_NAME) EQ 0) THEN BEGIN
    run_number_path = '/entry/run_number/'
  ENDIF ELSE BEGIN
    run_number_path = '/' + pola_state_name + '/run_number/'
  ENDELSE
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

;------------------------------------------------------------------------------
FUNCTION get_sangle, fileID
  sangle_value_path = '/entry-Off_Off/sample/SANGLE/readback/'
  sangle_units_path = '/entry-Off_Off/sample/SANGLE/readback/units/'
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ['','']
  ENDIF ELSE BEGIN
    pathID = h5d_open(fileID, sangle_value_path)
    sangle = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    RETURN, [STRCOMPRESS(sangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
  ENDELSE
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLgetMetadata::getRunNumber
  RETURN, self.RunNumber
END

FUNCTION IDLgetMetadata::getSangle
  angle_units = get_sangle(self.fileID)
  units = angle_units[1]
  IF (units EQ '') THEN RETURN, ''
  angle = FLOAT(angle_units[0])
  IF (units EQ 'degree') THEN BEGIN
    angle = convert_to_rad(angle)
  ENDIF
  RETURN, angle
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLgetMetadata::init, nexus_full_path, pola_state_path

  ;open hdf5 nexus file
  error_file = 0
  CATCH, error_file
  IF (error_file NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
  ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
    self.fileID = fileID
  ENDELSE
  
  self.RunNumber = get_RunNumber(fileID, pola_state_path)
  
  RETURN, 1
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO IDLgetMetadata__define
  struct = {IDLgetMetadata,$
    RunNumber       : '',$
    fileID: 0L, $
    nexus_full_path : ''}
END
;******************************************************************************
;******************************************************************************

