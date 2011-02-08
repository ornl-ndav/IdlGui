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
;    calculate the x data from the x device
;
; :Params:
;    event
;
; :Author: j35
;-
function px_vs_tof_retrieve_data_x_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  x_device = event.x
  congrid_xcoeff = (*global_px_vs_tof).congrid_xcoeff
  xrange = float((*global_px_vs_tof).xrange) ;min and max pixels
  
  rat = float(x_device) / float(congrid_xcoeff)
  x_data = float(rat * (xrange[1] - xrange[0]) + xrange[0])
  
  return, x_data
  
end

;+
; :Description:
;    calculate the y data from the y device
;
; :Params:
;    event
;
; :Author: j35
;-
function px_vs_tof_retrieve_data_y_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  y_device = event.y
  congrid_ycoeff = (*global_px_vs_tof).congrid_ycoeff  ;using xcoeff because of transpose
  
  yrange = float((*global_px_vs_tof).yrange) ;min and max pixels
  
  rat = float(y_device) / float(congrid_ycoeff)
  y_data = float(rat * (yrange[1] - yrange[0]) + yrange[0])
  
  return, y_data
  
end

;+
; :Description:
;    returns the exact number of counts of the x and y device position
;
; :Params:
;    event
;
; :Returns:
;    counts
;
; :Author: j35
;-
function px_vs_tof_retrieve_data_z_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  data = (*(*global_px_vs_tof).data2d_linear) ;[51,65] where 51 is #pixels
  
  xdata_max = (size(data))[1]
  ydata_max = (size(data))[2]
  
  congrid_xcoeff = (*global_px_vs_tof).congrid_xcoeff
  congrid_ycoeff = (*global_px_vs_tof).congrid_ycoeff
  
  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff)
  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff)
  
;  if ((*global_px_vs_tof).shift_key_status) then begin
;  
;    xyEvent = (*global_plot).EventRangeSelection
;    x1event = xyEvent[0]
;    y1event = xyEvent[1]
;    
;    x1data = fix(float(x1event) * float(xdata_max) / congrid_xcoeff)
;    y1data = fix(float(y1event) * float(ydata_max) / congrid_ycoeff)
;    
;    xmin = min([xdata,x1data],max=xmax)
;    ymin = min([ydata,y1data],max=ymax)
;    
;    _data = total(data[xmin:xmax,ymin:ymax])
;    
;  endif else begin
  
    _data = data[xdata,ydata]
    
;  endelse
  
  ;; Debugging code
  ;  print, '(congrid_xcoeff,congrid_ycoeff)=(' + strcompress(congrid_xcoeff,/remove_all) + $
  ;  ',' + strcompress(congrid_ycoeff,/remove_all) + ')'
  ;  print, '(xdata,ydata)=(' + strcompress(xdata,/remove_all) + $
  ;  ',' + strcompress(ydata,/remove_all) + ')'
  ;  print, '(xdata_max,ydata_max)=(' + strcompress(xdata_max,/remove_all) + $
  ;  ',' + strcompress(ydata_max,/remove_all) + ')'
  ;  print
  
  return, _data
  
end
