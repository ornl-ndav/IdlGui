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
; @author : Erik Watkins
;           (refashioned by j35@ornl.gov)
;
;==============================================================================

pro go_rtof_reduction, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;retrieve variables
  rtof_ascii_file = getValue(event=event,$
  uname='rtof_file_text_field_uname')
  rtof_ascii_file = rtof_ascii_file[0]
  
  rtof_nexus_geometry_file = getValue(event=event,$
  uname='rtof_nexus_geometry_file')
  
   full_check_message = !null
    QZmax = get_ranges_qz_max(event)
    QZmin = get_ranges_qz_min(event)
    check_input, value=QZmax, $
      label='Range Q: Qz max', $
      full_check_message = full_check_message
    check_input, value=QZmin, $
      label='Range Q: Qz min', $
      full_check_message = full_check_message
    QZrange = [QZmin, QZmax]
    
    QXbins = get_bins_qx(event)
    check_input, value=QXbins, $
      label='Bins Qx', $
      full_check_message = full_check_message
    QZbins = get_bins_qz(event)
    check_input, value=QZbins, $
      label='Bins Qz', $
      full_check_message = full_check_message
      
    QXmin = get_ranges_qx_min(event)
    check_input, value=QXmin, $
      label='Range Q: Qx min', $
      full_check_message = full_check_message
    QXmax = get_ranges_qx_max(event)
    check_input, value=QXmax, $
      label='Range Q: Qx max', $
      full_check_message = full_check_message
    QXrange = [QXmin, QXmax]
    
    TOFmin = get_tof_min(event)
    check_input, value=TOFmin, $
      label='from TOF (ms)', $
      full_check_message = full_check_message
    TOFmax = get_tof_max(event)
    check_input, value=TOFmax, $
      label='to TOF (ms)', $
      full_check_message = full_check_message
    TOFrange = [TOFmin, TOFmax]
    
    center_pixel = get_center_pixel(event)
    check_input, value=center_pixel, $
      label='center pixel', $
      full_check_message = full_check_message
    pixel_size = get_pixel_size(event)
    check_input, value=pixel_size, $
      label='pixel size', $
      full_check_message = full_check_message
      
    SD_d = get_d_sd(event) ;mm
    check_input, value=SD_d, $
      label='distance sample to detector (mm)', $
      full_check_message = full_check_message
      
    MD_d = get_d_md(event) ;mm
    check_input, value=MD_d, $
      label='distance moderator to detector (mm)', $
      full_check_message = full_check_message
      
    qxwidth = float(get_qxwidth(event))
    check_input, value=qxwidth, $
      label='specular reflexion, QxWidth', $
      full_check_message = full_check_message
    tnum = fix(get_tnum(event))
    check_input, value=tnum, $
      label='specular reflexion, tnum', $
      full_check_message = full_check_message
    
  
  
end