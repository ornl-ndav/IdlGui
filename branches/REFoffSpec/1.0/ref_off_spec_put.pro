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
;- GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES
;------------------------------------------------------------------------------
;General routine to add a list to a widget_list
PRO putList, Event, uname, value
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=value
END

;------------------------------------------------------------------------------
PRO putTextFieldValue, Event, uname, text
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=text
END

;------------------------------------------------------------------------------
PRO putArrayTextFieldValue, Event, uname_array, text
sz = N_ELEMENTS(uname_array)
FOR i=0,(sz-1) DO BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname_array[i])
    WIDGET_CONTROL, id, SET_VALUE=text
ENDFOR
END

;------------------------------------------------------------------------------
;- SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC 
;------------------------------------------------------------------------------
;Function that updates the list of the ascii file list found in the step2
PRO putAsciiFileList, Event, value
putList, Event, 'ascii_file_list', value
END

;------------------------------------------------------------------------------
PRO putListOfFilesTransparency, Event, list_OF_files 
putList, Event, 'transparency_file_list', list_OF_files
END

;------------------------------------------------------------------------------
PRO putListOfFilesShifting, Event, list_OF_files 
putList, Event, 'active_file_droplist_shifting', list_OF_files
END

;------------------------------------------------------------------------------
PRO putXminStep4Step1Value, Event, value
putTextFieldValue, Event, 'selection_info_xmin_value', $
  STRCOMPRESS(value,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
PRO putYminStep4Step1Value, Event, value
putTextFieldValue, Event, 'selection_info_ymin_value', $
  STRCOMPRESS(value,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
PRO putXmaxStep4Step1Value, Event, value
putTextFieldValue, Event, 'selection_info_xmax_value', $
  STRCOMPRESS(value,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
PRO putYmaxStep4Step1Value, Event, value
putTextFieldValue, Event, 'selection_info_ymax_value', $
  STRCOMPRESS(value,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
PRO put_step4_step2_step2_lambda, Event, lambda_min, lambda_max
putTextFieldValue, Event,'step4_2_2_lambda1_text_field', $
  STRCOMPRESS(lambda_min,/REMOVE_ALL)
putTextFieldValue, Event,'step4_2_2_lambda2_text_field', $
  STRCOMPRESS(lambda_max,/REMOVE_ALL)
END
