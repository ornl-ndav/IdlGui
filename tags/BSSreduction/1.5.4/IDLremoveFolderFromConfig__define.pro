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

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLremoveFolderFromConfig::init, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global

config_file_name = (*global).config_file_name

;read file --------------------------------------------------------------------
file_size  = FILE_LINES(config_file_name)
file_array = STRARR(file_size)
OPENR, 1, config_file_name
READF, 1, file_array
CLOSE, 1

result = WHERE(file_array EQ '', nbr_input)
IF (nbr_input EQ 1) THEN BEGIN
    final_array = ['']
ENDIF ELSE BEGIN
    final_result = [0,result]
    CASE (index) OF
        0: BEGIN
            final_array = file_array[final_result[index+1]+1: $
                                     final_result[nbr_input]]
        END
        (nbr_input-1): BEGIN
            final_array = file_array[0: $
                                     final_result[nbr_input-1]]
        END
        ELSE: BEGIN
            final_array_1 = file_array[0: $
                                       final_result[index]-1]
            final_array_2 = file_array[final_result[index+1]: $
                                       final_result[index+2]]
            final_array = [final_array_1,final_array_2]
        END
    ENDCASE
    final_array = [final_array]    
ENDELSE

;replace config file with new array
OPENW, 1, config_file_name
FOR i=0,(N_ELEMENTS(final_array)-1) DO BEGIN
    PRINTF, 1, final_array[i]
ENDFOR
CLOSE, 1
FREE_LUN, 1

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLremoveFolderFromConfig__define
struct = {IDLremoveFolderFromConfig,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
