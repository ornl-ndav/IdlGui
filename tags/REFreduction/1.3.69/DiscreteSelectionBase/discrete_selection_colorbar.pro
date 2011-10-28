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
;    Plot the first time the scale on the right of the main plot
;
; :Params:
;    zmin
;    zmax
;
; :Keywords:
;    event
;    base
;    type   0 for linear, 1 for logarithmic
;
; :Author: j35
;-
pro plot_discrete_selection_colorbar, event=event, base=base, zmin, zmax, type=type
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    id_draw = widget_info(event.top,find_by_uname='discrete_selection_colorbar')
    widget_control, event.top, get_uvalue=global_tof_selection
  endif else begin
    id_draw = widget_info(base, find_by_uname='discrete_selection_colorbar')
    widget_control, base, get_uvalue=global_tof_selection
  endelse
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  default_loadct = (*global_tof_selection).default_loadct
  loadct, default_loadct, /silent
  
  default_scale_settings = (*global_tof_selection).default_scale_settings
  if (default_scale_settings eq 0) then begin ;linear
  
    divisions = 20
    perso_format = '(e8.1)'
    range = [zmin,zmax]
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.75,0.01,0.95,0.99], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      /VERTICAL
      
  endif else begin
  
    divisions = 10
    perso_format = '(e8.1)'
    range = float([zmin,zmax])
    
    if (default_loadct eq 6) then begin
      colorbar, $
        AnnotateColor = 'white',$
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endif else begin
    
      colorbar, $
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endelse
    
  endelse
  
end

;+
; :Description:
;    Refresh the colorbar scale
;
; :Params:
;    event
;
; :Author: j35
;-
pro refresh_plot_discrete_selection_colorbar, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_tof_selection
  
  zrange = (*global_tof_selection).zrange
  zmin = zrange[0]
  zmax = zrange[1]
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='discrete_selection_colorbar')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  default_loadct = (*global_tof_selection).default_loadct
  loadct, default_loadct, /silent
  
  default_scale_settings = (*global_tof_selection).default_scale_settings
  if (default_scale_settings eq 0) then begin ;linear
  
    divisions = 20
    perso_format = '(e8.1)'
    range = [zmin,zmax]
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.75,0.01,0.95,0.99], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      annotatecolor = 'white',$
      /VERTICAL
      
  endif else begin
  
    divisions = 10
    perso_format = '(e8.1)'
    range = float([zmin,zmax])
    
    if (default_loadct eq 6) then begin
    
      colorbar, $
        AnnotateColor = 'white',$
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endif else begin
    
      colorbar, $
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endelse
    
  endelse
  
end