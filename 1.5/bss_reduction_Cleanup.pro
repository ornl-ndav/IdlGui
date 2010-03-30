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

PRO BSSreduction_Cleanup, Main_Base

  Widget_Control, Main_Base, get_uvalue=global
  
  ;cleanup temporary live folder
  cmd = 'rm -rf ' + (*global).tmp_live_shared_folder
  spawn, cmd, listening, err_listening
  
  if (n_elements(global) EQ 0) then return
  
  ; Free up the pointers
  ptr_free, (*global).icon_ok
  ptr_free, (*global).icon_failed
  ptr_free, (*global).pMetadata
  ptr_free, (*global).pMetadataValue
  ptr_free, (*global).job_status_uname
  ptr_free, (*global).leaf_uname_array
  ptr_free, (*global).job_status_root_id
  ptr_free, (*global).job_status_root_status
  ptr_free, (*global).absolute_leaf_index
  ptr_free, (*global).FullNameOutputPlots
  ptr_free, (*global).WidgetsToActivate
  ptr_free, (*global).full_counts_vs_tof_data
  ptr_free, (*global).PreviewCountsVsTofAsciiArray
  ptr_free, (*global).bank1
  ptr_free, (*global).bank1_sum
  ptr_free, (*global).bank2
  ptr_free, (*global).bank2_sum
  ptr_free, (*global).pixel_excluded
  ptr_free, (*global).pixel_excluded_base
  ptr_free, (*global).default_pixel_excluded
  ptr_free, global

;Create Config File Name
;BSSreduction_CreateConfigFile, global
  
END

