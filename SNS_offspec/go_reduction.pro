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

;;+
; :Description:
;    Start the heart of the program
;
; :Params:
;    event
;
; :Author: j35
;-
pro go_reduction, event
compile_opt idl2

widget_control, event.top, get_uvalue=global

;Retrieve variables

list_data_nexus = (*(*global).list_data_nexus)
norm_nexus      = (*global).norm_nexus

QXbins = get_bins_qx(event)
QZbins = get_bins_qz(event)

QXmin = get_ranges_qx_min(event)
QXmax = get_ranges_qx_max(event)
QXrange = [QXmin, QXmax]

QZmin = get_ranges_qz_min(event)
QZmax = get_ranges_qz_max(event)
QZrange = [QZmin, QZmax]

TOFmin = get_tof_min(event)
TOFmax = get_tof_max(event)

PIXmin = get_pixel_min(event)
PIXmax = get_pixel_max(event)

center_pixel = get_center_pixel(event)
pixel_size = get_pixel_size(event)

SD_d = get_d_sd(event)
MD_d = get_d_md(event)







end