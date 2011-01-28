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

FUNCTION get_sangle, fileID
; Change code (RC Ward, 15 Sept 2010): Get run_number to determine how to read metadata.
run_number_path = '/entry-Off_Off/run_number/'
pathID = h5d_open(fileID, run_number_path)
run_number = h5d_read(pathID)
;print, "in get_sangle - run_number: ", run_number
if (run_number LE 6682) then begin
  sangle_value_path = '/entry-Off_Off/sample/SANGLE/readback/'
  sangle_units_path = '/entry-Off_Off/sample/SANGLE/readback/units/'
endif else begin
  sangle_value_path = '/entry-Off_Off/sample/SANGLE/value/'
  sangle_units_path = '/entry-Off_Off/sample/SANGLE/value/units/'
endelse
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

;-------------------------------------------------------------------------------
FUNCTION get_dangle, fileID
; Change code (RC Ward, 15 Sept 2010): Get run_number to determine how to read metadata.
run_number_path = '/entry-Off_Off/run_number/'
pathID = h5d_open(fileID, run_number_path)
run_number = h5d_read(pathID)
if (run_number LE 6682) then begin
  dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE/readback/'
  dangle_units_path = '/entry-Off_Off/instrument/bank1/DANGLE/readback/units/'
endif else begin
  dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE/value/'
  dangle_units_path = '/entry-Off_Off/instrument/bank1/DANGLE/value/units/'
endelse
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ['','']
  ENDIF ELSE BEGIN
    pathID = h5d_open(fileID, dangle_value_path)
    dangle = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    RETURN, [STRCOMPRESS(dangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
  ENDELSE
END

;-------------------------------------------------------------------------------
FUNCTION get_dangle0, fileID
; Change code (RC Ward, 15 Sept 2010): Get run_number to determine how to read metadata.
run_number_path = '/entry-Off_Off/run_number/'
pathID = h5d_open(fileID, run_number_path)
run_number = h5d_read(pathID)
if (run_number LE 6682) then begin
  dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE0/readback/'
  dangle_units_path = '/entry-Off_Off/instrument/bank1/DANGLE0/readback/units/'
endif else begin
  dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE0/value/'
  dangle_units_path = '/entry-Off_Off/instrument/bank1/DANGLE0/value/units/'
endelse  
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ['','']
  ENDIF ELSE BEGIN
    pathID = h5d_open(fileID, dangle_value_path)
    dangle = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    RETURN, [STRCOMPRESS(dangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION get_dirpix, fileID
; Change code (RC Ward, 15 Sept 2010): Get run_number to determine how to read metadata.
run_number_path = '/entry-Off_Off/run_number/'
pathID = h5d_open(fileID, run_number_path)
run_number = h5d_read(pathID)
if (run_number LE 6682) then begin
  dirpix_path = '/entry-Off_Off/instrument/bank1/DIRPIX/readback/'
endif else begin
  dirpix_path = '/entry-Off_Off/instrument/bank1/DIRPIX/value/'
endelse
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
  ENDIF ELSE BEGIN
    pathID = h5d_open(fileID, dirpix_path)
    dirpix = h5d_read(pathID)
    h5d_close, pathID
    RETURN, STRCOMPRESS(dirpix,/REMOVE_ALL)
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION get_sample_det_distance, fileID
; Change code (RC Ward, 15 Sept 2010): Get run_number to determine how to read metadata.
run_number_path = '/entry-Off_Off/run_number/'
pathID = h5d_open(fileID, run_number_path)
run_number = h5d_read(pathID)
if (run_number LE 6682) then begin
  dist_value_path = '/entry-Off_Off/instrument/bank1/SampleDetDis/readback/'
  dist_units_path = '/entry-Off_Off/instrument/bank1/SampleDetDis/readback/units/'
endif else begin
  dist_value_path = '/entry-Off_Off/instrument/bank1/SampleDetDis/value/'
  dist_units_path = '/entry-Off_Off/instrument/bank1/SampleDetDis/value/units/'
endelse
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ['','']
  ENDIF ELSE BEGIN
    pathID = h5d_open(fileID, dist_value_path)
    dist   = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    RETURN, [STRCOMPRESS(dist,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
  ENDELSE
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLgetMetadata_REF_M::getSangle
  angle_units = get_sangle(self.fileID)
  units = angle_units[1]
  IF (units EQ '') THEN RETURN, ''
  angle = FLOAT(angle_units[0])
  IF (units EQ 'degree') THEN BEGIN
    angle = convert_to_rad(angle)
  ENDIF
  RETURN, angle
END

FUNCTION IDLgetMetadata_REF_M::getDangle
  angle_units = get_dangle(self.fileID)
  units = angle_units[1]
  IF (units EQ '') THEN RETURN, ''
  angle = FLOAT(angle_units[0])
  IF (units EQ 'degree') THEN BEGIN
    angle = convert_to_rad(angle)
  ENDIF
  RETURN, angle
END

FUNCTION IDLgetMetadata_REF_M::getDangle0
  angle_units = get_dangle0(self.fileID)
  units = angle_units[1]
  IF (units EQ '') THEN RETURN, ''
  angle = FLOAT(angle_units[0])
  IF (units EQ 'degree') THEN BEGIN
    angle = convert_to_rad(angle)
  ENDIF
  RETURN, angle
END

FUNCTION IDLgetMetadata_REF_M::getDirPix
  DirPix = get_dirpix(self.fileID)
  RETURN, DirPix[0]
END

FUNCTION IDLgetMetadata_REF_M::getSampleDetDist
  distance_units = get_sample_det_distance(self.fileID)
  units = distance_units[1]
  IF (units EQ '') THEN RETURN, ''
  distance = FLOAT(distance_units[0])
  IF (units NE 'metre') THEN BEGIN
    distance = convert_to_metre(distance, units)
  ENDIF
  RETURN, distance
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLgetMetadata_REF_M::init, nexus_full_path

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
  
  RETURN, 1
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO IDLgetMetadata_REF_M__define
  struct = {IDLgetMetadata_REF_M,$
    fileID: 0L, $
    nexus_full_path : ''}
END
;******************************************************************************
;******************************************************************************

