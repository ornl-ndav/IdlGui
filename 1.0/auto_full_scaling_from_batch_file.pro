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
;   This procedures is reached when a batch file has been loaded without
;   a scaling factor (SF) value for the critical edge (CE) file.
;   the procedures is going to determine the CE range (min Q -> 0.009),
;   scale to 1 and scale automatically the following files
;
; :Params:
;    Event
;;
; :Author: j35
;-
pro auto_full_scaling_from_batch_file, Event
  compile_opt idl2
  
  widget_control, Event.top, get_uvalue=global
  
  PlotLoadedFiles, Event      ;_Plot
  
  BatchTable       = (*(*global).BatchTable)
  NbrRowMax        = (SIZE(batchTable))[2]
  flt0_ptr         = (*global).flt0_ptr
  flt1_ptr         = (*global).flt1_ptr
  
  ;work on CE file (determine Q range to use to average y range to 1)
  x_axis_ce_file = *flt0_ptr[0]
  qmin = float(x_axis_ce_file[0]) 
  qmax = float(x_axis_ce_file[n_elements(x_axis_ce_file)-1]) < 0.009
  
  putValueInTextField, event, 'step2_q1_text_field', qmin
  putValueInTextField, event, 'step2_q2_text_field', qmax
  run_full_step2, Event ;_Step2
  
  ;change scale to log and replot
  id = widget_info(event.top, find_by_uname='YaxisLinLog')
  widget_control, id, set_value=1
  
  ;automatic scaling of other files
  Step3AutomaticRescaling, Event ;_Step3
  
  PlotLoadedFiles, Event      ;_Plot
  
  ;force the axis to start at 0
  putValueInTextField, Event,'XaxisMinTextField', strcompress(0,/remove_all)
  putValueInTextField, Event,'YaxisMinTextField', strcompress(0.000001,/remove_all)
  plot_loaded_file, Event, 'all' ;_Plot

end