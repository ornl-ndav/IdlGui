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

PRO plot_reduce_step2_norm, Event, recalculate=recalculate, plot_range=plot_range

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  DEVICE, DECOMPOSED=0
  ; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  ;select plot
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_step2_create_roi_draw_uname')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  if (keyword_set(recalculate)) then begin
  
    ;check if user wants lin or log
    uname = 'reduce_step2_create_roi_lin_log'
    lin_log_status = getCWBgroupValue(Event, uname) ;0:lin, 1:log
    IF (lin_log_status EQ 0) THEN BEGIN ;linear
      rtData = (*(*global).norm_rtData)
    ENDIF ELSE BEGIN
      rtData = (*(*global).norm_rtData_log)
    ENDELSE
    
    geometry = widget_info(id_draw,/geometry)
    xsize = geometry.xsize
    (*global).reduce_rebin_roi_rebin_x = xsize
    
    if (keyword_set(plot_range)) then begin
    
      tof1 = getTextFieldValue(event,'reduce_step2_tof1')
      tof2 = getTextFieldValue(event,'reduce_step2_tof2')
      
      _tof1 = float(tof1)
      _tof2 = float(tof2)
      
      tof = (*(*global).norm_tof)
      
      index_tof1 = getIndexOfValueInArray(array=tof, value=_tof1*1000, from=1)
      index_tof2 = getIndexOfValueInArray(array=tof, value=_tof2*1000, to=1)

      new_tof = tof[index_tof1:index_tof2]
      (*(*global).tmp_norm_tof) = new_tof

      index_tof_min = min([index_tof1,index_tof2],max=index_tof_max)
      rtdata = rtdata[index_tof_min:index_tof_max,*]
      
    endif
    
    size = size(rtdata,/dim)
    ysize = size[1]
    
    crtData = congrid(rtDAta, xsize, ysize, /interp)
    
    ;plot main plot
    TVSCL, crtData, /DEVICE
    
    save_roi_base_background,  event=event
    
  endif else begin
  
    TV, (*(*global).roi_base_background), true=3
    
    
  endelse
  
END


pro save_roi_base_background,  event=event, main_base=main_base, uname=uname
  compile_opt idl2
  
  if (~keyword_set(uname)) then uname = 'reduce_step2_create_roi_draw_uname'
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME=uname)
    widget_control, main_base, get_uvalue=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0]
  
  (*(*global).roi_base_background) = background
  
END
