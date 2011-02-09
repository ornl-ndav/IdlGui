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
;    display the counts vs tof
;    in the new widget_base on the right of the main GUI
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_plot_counts_vs_xaxis, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
  widget_control, event.top, get_uvalue=global_axis_plot
  endif else begin
  widget_control, base, get_uvalue=global_axis_plot
  endelse
  
  global_px_vs_tof = (*global_axis_plot).global
  xaxis_plot_uname = (*global_px_vs_tof).counts_vs_xaxis_plot_uname
  counts_vs_xaxis_base = base
  id = widget_info(counts_vs_xaxis_base, find_by_uname=xaxis_plot_uname)
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  ;2d data
  data = (*(*global_px_vs_tof).data2d_linear)
  _data = total(data,2)
    
  ;nbr_ = n_elements(data[xdata,*])
  x_axis = (*global_px_vs_tof).tof_axis
  xrange = fltarr(2)
  xrange[0] = x_axis[0]
  xrange[1] = x_axis[-1]
  (*global_axis_plot).xrange = xrange
  (*global_axis_plot).ymax = max(_data)
  
  yaxis_type = (*global_px_vs_tof).counts_vs_xaxis_yaxis_type
  is_linear = 1
  if (yaxis_type eq 0) then begin
  
    plot, x_axis, _data, xtitle='TOF (ms)', ytitle='Counts', xstyle=1
    
  endif else begin
  
    catch,error
    if (error ne 0) then begin
      catch,/cancel
      erase
      return
    endif
    
    ;remove the 0 values
    nan_array = where(data eq 0)
    data[nan_array] = !values.f_nan
    
    ymax = max(_data)
    yrange = [0.01,ymax]
    
    plot, x_axis, _data, $
      xstyle = 1, $
      xtitle='TOF (ms)', $
      ytitle='Counts', $
      yrange = yrange, $
      /ylog
    is_linear = 0
    
  endelse
  
end

;+
; :Description:
;    display the counts vs Qz
;    in the new widget_base on the right of the main GUI
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_plot_counts_vs_yaxis,event=event, base=base, clear=clear
  compile_opt idl2
  
  if (keyword_set(event)) then begin
  widget_control, event.top, get_uvalue=global_axis_plot
  endif else begin
  widget_control, base, get_uvalue=global_axis_plot
  endelse
  
  global_px_vs_tof = (*global_axis_plot).global
  yaxis_plot_uname = (*global_px_vs_tof).counts_vs_yaxis_plot_uname
  counts_vs_xaxis_base = base
  id = widget_info(counts_vs_xaxis_base, find_by_uname=yaxis_plot_uname)
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (keyword_set(clear)) then begin
    erase
    return
  endif
  
  ;2d data
  data = (*(*global_px_vs_tof).data2d_linear)
  _data = total(data,1)
  
  y_axis = indgen(n_elements(_data))
  
  xrange = fltarr(2)
  xrange[0] = y_axis[0]
  xrange[1] = y_axis[-1]
  (*global_axis_plot).xrange = xrange
  (*global_axis_plot).ymax = max(_data)
    
  yaxis_type = (*global_px_vs_tof).counts_vs_xaxis_yaxis_type
  is_linear = 1
  if (yaxis_type eq 0) then begin
  
    plot, y_axis, _data, xtitle='Pixel', ytitle='Counts', xstyle=1
    
  endif else begin
  
    catch,error
    if (error ne 0) then begin
      catch,/cancel
      erase
      return
    endif
    
    ;remove the 0 values
    nan_array = where(data eq 0)
    data[nan_array] = !values.f_nan
    
    ymax = max(_data)
    yrange = [0.01,ymax]
    
    plot, y_axis, _data, $
      xstyle = 1, $
      xtitle='Pixel',$
      ytitle='Counts', $
      yrange = yrange, $
      /ylog
    is_linear = 0
    
  endelse
  
end

