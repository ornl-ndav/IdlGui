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
;    Plot the first time the scale at the bottom of the base
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
pro plot_refpix_colorbar, event=event, base=base, zmin, zmax, type=type
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    id_draw = widget_info(event.top,find_by_uname='refpix_colorbar')
    widget_control, event.top, get_uvalue=global_refpix
  endif else begin
    id_draw = widget_info(base, find_by_uname='refpix_colorbar')
    widget_control, base, get_uvalue=global_refpix
  endelse
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  default_loadct = (*global_refpix).default_loadct
  loadct, default_loadct, /silent
  
  default_scale_settings = (*global_refpix).default_scale_settings
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
; :keywords:
;   plot_range
;
; :Author: j35
;-
pro refresh_reduce_step2_colorbar, event, plot_range=plot_range
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id_draw = WIDGET_INFO(Event.top,$
    FIND_BY_UNAME='reduce_step2_colorbar_uname')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  default_loadct = 5
  loadct, default_loadct, /silent
  
  uname = 'reduce_step2_create_roi_lin_log'
  lin_log_status = getCWBgroupValue(Event, uname) ;0:lin, 1:log
  rtData = (*(*global).norm_rtData)
  
   if (keyword_set(plot_range)) then begin
    
      tof1 = getTextFieldValue(event,'reduce_step2_tof1')
      tof2 = getTextFieldValue(event,'reduce_step2_tof2')
      
      _tof1 = float(tof1)
      _tof2 = float(tof2)
      
      tof = (*(*global).norm_tof)
      
      index_tof1 = getIndexOfValueInArray(array=tof, value=_tof1*1000, from=1)
      index_tof2 = getIndexOfValueInArray(array=tof, value=_tof2*1000, to=1)

      index_tof_min = min([index_tof1,index_tof2],max=index_tof_max)

      sz_rtdata = size(rtdata,/dim)
      if (index_tof_max eq sz_rtdata[0]) then index_tof_max--
      rtdata = rtdata[index_tof_min:index_tof_max,*]
      
    endif

  zmin = min(rtData,max=zmax)
  
  position = [0.02,0.5,0.95,0.9]
  
  if (lin_log_status eq 0) then begin ;linear
  
    divisions = 20
    perso_format = '(e8.2)'
    perso_format = '(i0)'
    range = [zmin,zmax]
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = position, $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      annotatecolor = 'white',$
      /vertical
      
  endif else begin
  
    divisions = 10
    perso_format = '(e8.1)'
    range = float([zmin,zmax])
    range = [1,zmax]
    
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = position, $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      ylog = 1,$
      /vertical
      
  endelse
  
  xyouts, 0.5, 0.97 , 'COUNTS',/normal, charsize=10, alignment=0.5
  
end