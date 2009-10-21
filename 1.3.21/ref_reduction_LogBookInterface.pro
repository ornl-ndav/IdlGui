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

;This function create log book in /SNS/users/logbook
PRO RefReduction_LogBookInterface, Event

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

data_roi_file_name = $
  getTextFieldValue(Event, $
                    'reduce_data_region_of_interest_file_name')
norm_roi_file_name = $
  getTextFieldValue(Event, $
                    'reduce_normalization_region_of_interest_file_name')
BatchFileName = (*global).BatchFileName

nbr_files = 0
IF (data_roi_file_name NE '') THEN nbr_files++
IF (norm_roi_file_name NE '') THEN nbr_files++
IF (BatchFileName NE '') THEN nbr_files++

IF (nbr_files GT 0) THEN BEGIN
    list_OF_files = STRARR(nbr_files)
    index = 0
    IF (data_roi_file_name NE '') THEN $
      list_OF_files[index++] = data_roi_file_name
    IF (norm_roi_file_name NE '') THEN $
      list_OF_files[index++] = norm_roi_file_name
    IF (BatchFileName NE '') THEN list_OF_files[index++] = BatchFileName

ENDIF ELSE BEGIN

    list_OF_files = STRARR(1)
        
ENDELSE

iLogBook = OBJ_NEW('IDLsendLogBook', Event, $
                   LIST_OF_FILES_TO_TAR = list_OF_files)

END



