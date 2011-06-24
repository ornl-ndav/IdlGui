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
;    This will produce a jpeg file of the plot (with scale!)
;
; :Keywords:
;    event
;    file_format    ['jpg'] only for now
;
;
;
; :Author: j35
;-
pro take_screenshot, event=event, file_format=file_format
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  global = (*global_plot).global
  
  output_path = (*global).output_path
  id = widget_info(event.top, find_by_uname='final_plot_base')
  main_geometry = widget_info(id,/geometry)
  xsize = main_geometry.xsize
  ysize = main_geometry.ysize
  
  output_file_name = dialog_pickfile(default_extension='.' + file_format, $
    dialog_parent=id, $
    path=path, $
    /write, $
    filter = '*.' + file_format, $
    get_path=new_path, $
    title = 'Name of ' + file_format + ' file to create')
    
  if (output_file_name[0] eq '') then return
  
  (*global).output_path = new_path
  
  sys_color = widget_info(id,/system_colors)
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk
  
  id_scale = widget_info(event.top, find_by_uname='scale')
  widget_control, id_scale, get_value=id_value
  wset,id_value
  image_scale = tvrd(true=3)
  
  id_draw = widget_info(event.top, find_by_uname='draw')
  geometry = widget_info(id_draw, /geometry)
  xoffset = geometry.xoffset
  yoffset = geometry.yoffset
  widget_control, id_draw, get_value=id_value
  wset,id_value
  image_draw = tvrd(true=3)
  
  id_colorbar = widget_info(event.top, find_by_uname='colorbar')
  geometry = widget_info(id_colorbar, /geometry)
  xoffset_colorbar = geometry.xoffset
  yoffset_colorbar = geometry.yoffset
  widget_control, id_colorbar, get_value=id_value
  wset, id_value
  image_colorbar = tvrd(true=3)
  
  ;window, 0, xsize=xsize, ysize=ysize, title=output_file_name
  base1=widget_base()
  wBase1 = widget_base(title='Preview of ' + output_file_name,$
    /column)
  _draw = widget_draw(wBase1,$
    xsize = xsize,$
    ysize = ysize,$
    uname='_draw')
  widget_control, wBase1, /realize
  
  widget_control, _draw, get_value=id_value
  wset, id_value
  
  tv, image_scale, 0, 0, true=3
  
  device, decomposed=0
  loadct, (*global_plot).default_loadct, /silent
  
  tv, image_draw, xoffset, yoffset, true=3
  tv, image_colorbar, xoffset_colorbar, yoffset_colorbar, true=3
  
  case (file_format) of
    'png': begin
      write_png, output_file_name[0], tvrd(/true)
    end
    'jpg': begin
      write_jpeg, output_file_name[0], tvrd()
    end
    else:
  endcase
  
end