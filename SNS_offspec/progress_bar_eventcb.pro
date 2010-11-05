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

;+
; :Description:
;    Mapped the progress bar at the beginning of the process
;
; :Params:
;    event
;
; :Author: j35
;-
pro show_progress_bar, event
  compile_opt idl2
  mapBase, event=event, status=1 , uname='progress_bar_base'
end

;+
; :Description:
;    Hide (unmapped) the progress bar at the end of the process
;
; :Params:
;    event
;
; :Author: j35
;-
pro hide_progress_bar, event
  compile_opt idl2
  mapBase, event=event, status=0 , uname='progress_bar_base'
end

;+
; :Description:
;    update the progress bar according to the current process number
;
; :Params:
;    event
;    process_number
;    total_number_processes
;
; :Author: j35
;-
pro update_progress_bar_percentage, event, $
process_number, $
total_number_processes
  compile_opt idl2
  
  print, process_number
  
  id = widget_info(event.top, find_by_uname='progress_bar_uname')
  geometry = widget_info(id,/geometry)
  
  xsize = geometry.xsize
  ysize = geometry.ysize

  ratio = float(process_number) / float(total_number_processes)
  _xsize = xsize * (float(ratio))
  
  device, decomposed = 0
  loadct, 5
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  x = [0, _xsize, _xsize, 0, 0]
  y = [0, 0, ysize, ysize, 0]
  polyfill, x, y, color=50, /device
  
  ;strangely, this 'print' is required to see the first polyfill of the
  ;progress bar !!!!
  print
  
end