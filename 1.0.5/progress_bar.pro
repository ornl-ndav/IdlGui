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
;    This procedure initialize the progress bar, moves it and close it
;    at the end of the process
;
;
;
; :Keywords:
;    event
;    init
;    step
;    close
;
; :Author: j35
;-
pro progress_bar, event=event, init=init, step=step, close=close
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  if (keyword_set(init)) then begin
    mapBase, event=event, status=1, uname='progress_bar_base_uname'
    
    ;define what is going to be the delta step
    number_of_steps = (*global).pb_number_of_steps
    
    ;get size of progress bar
    id = widget_info(event.top, find_by_uname='progress_bar')
    geometry = widget_info(id,/geometry)
    xsize = geometry.xsize
    ysize = geometry.ysize
    
    device_step = fix(float(xsize) / float(number_of_steps))
    (*global).pb_each_step_xsize = device_step
    (*global).pb_ysize = ysize
    
    return
  endif
  
  ;hide the progress bar
  if (keyword_set(close)) then begin
    ;first reset the progress bar
    id_draw = widget_info(Event.top, find_by_uname='progress_bar')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
    (*global).pb_step = 0
    
    mapBase, event=event, status=0, uname='progress_bar_base_uname'
    return
  endif
  
  x = (*global).pb_each_step_xsize * (*global).pb_step
  y = (*global).pb_ysize
  
  id_draw = widget_info(Event.top, find_by_uname='progress_bar')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  polyfill, [0,x,x,0,0],[0,0,y,y,0], /device, color=fsc_color("yellow")
  
  new_pb_step = (*global).pb_step + 1
  (*global).pb_step = new_pb_step
  
end
