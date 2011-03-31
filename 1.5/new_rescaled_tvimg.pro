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

pro new_rescaled_tvimg, event, tvimg
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  data = (*(*global).bank1_data) ;[tof, 256, 304]
help, data
  if ((*global).instrument eq 'REF_L') then begin
  _data = total(data,3)
  endif else begin
  _data = total(data,2)
  endelse
    
    help, _data
    
  index_of_tof_range = (*global).index_of_tof_range
  index_tof_min = index_of_tof_range[0]
  index_tof_max = index_of_tof_range[1]
  
  if (index_tof_min eq -1) then index_tof_min = 0
  
  _tvimg = _data[index_tof_min:index_tof_max,*]
  
   id = widget_info(event.top, find_by_uname='load_data_D_draw')
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
   
   tvimg = congrid(_tvimg, new_xsize, new_ysize)
  
  help, tvimg
  
end