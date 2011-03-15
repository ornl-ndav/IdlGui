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

FUNCTION retrieve_Data, Event, $
    FullNexusName, $
    spin_state
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  instrument = (*global).instrument
  ref_pixel_list = (*(*global).ref_pixel_list)
  
  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    ;display message about invalid file format
    ;    putDataLogBookMessage, Event, $
    ;      'Nexus format not supported by this application', APPEND=1
    RETURN,0
  ENDIF ELSE BEGIN
    fileID    = H5F_OPEN(FullNexusName)
    IF (instrument EQ 'REF_M') THEN BEGIN
      data_path = '/entry-' + spin_state + '/bank1/data'
      tof_path  = '/entry-' + spin_state + '/bank1/time_of_flight' 
    ENDIF ELSE BEGIN
      data_path = '/entry/bank1/data'
      tof_path = '/entry/bank1/time_of_flight'
    ENDELSE
    fieldID = H5D_OPEN(fileID,data_path)
    data = H5D_READ(fieldID)
    (*(*global).norm_data) = data
    h5d_close, fieldID
    
    ;retrieve tof
    tofID = h5d_open(fileID, tof_path)
    tof = h5d_read(tofID)
    (*(*global).norm_tof) = tof
    h5d_close, tofID
    
    h5f_close, fileID
    
    IF (instrument EQ 'REF_M') THEN BEGIN
      tData = TOTAL(data,2)
    ENDIF ELSE BEGIN
      tData = TOTAL(data,3)
    ENDELSE

    (*(*global).norm_tData) = tData
    
    x = (size(tData))(1)
    y = (size(tData))(2)
    
    (*global).reduce_step2_norm_tof = x
    
    rtData = REBIN(tData, x, 2*y)
    (*(*global).norm_rtData) = rtData
    
    ;save the log version of it as well
    ;(*(*global).norm_rtData_log)
    
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = WHERE(tData EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      tData[index] = !VALUES.D_NAN
    ENDIF
    tData = ALOG10(tData)
    tData = BYTSCL(tData,/NAN)
    rtData = REBIN(tData, x, 2*y)
    (*(*global).norm_rtData_log) = rtData
    
    RETURN, 1
  ENDELSE
  
END

