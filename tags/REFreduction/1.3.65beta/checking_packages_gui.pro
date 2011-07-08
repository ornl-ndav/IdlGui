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
PRO update_gui_status_sensitivity, MAIN_BASE, uname_array, status
sz    = N_ELEMENTS(uname_array)
index = 0
WHILE (index LT sz) DO BEGIN
   id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME=uname_array[index])
   WIDGET_CONTROL, id, SENSITIVE=status
   index++
ENDWHILE
END

;------------------------------------------------------------------------------
PRO update_gui_according_to_package, MAIN_BASE, my_package

;my_package[0].driver = findnexus
;my_package[1].driver = reflect_reduction
;my_package[2].driver = nxdir

;if findnexus can not be found, disable cw_fields that works with findnexus
IF (my_package[0].found EQ 0) THEN BEGIN
   findnexus_gui_status = 0
ENDIF 
uname_array = ['load_data_run_number_text_field',$
               'data_archived_or_full_cwbgroup',$
               'load_normalization_run_number_text_field',$
               'normalization_archived_or_full_cwbgroup']
update_gui_status_sensitivity, MAIN_BASE, uname_array, findnexus_gui_status

;if nxdir is missing, desactivate browse and cw_fields
IF (my_package[2].found EQ 0) THEN BEGIN
   nxdir_gui_status = 0
ENDIF
uname_array = ['load_data_run_number_text_field',$
               'data_archived_or_full_cwbgroup',$
               'load_normalization_run_number_text_field',$
               'normalization_archived_or_full_cwbgroup',$
               'browse_data_nexus_button',$
               'browse_norm_nexus_button']
update_gui_status_sensitivity, MAIN_BASE, uname_array, nxdir_gui_status

END
