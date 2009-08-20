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

PRO plot_data_for_beam_center_base, $
    EVENT=event, $
    base=base, $
    MAIN_GLOBAL=main_global, $
    GLOBAL_BC = global_bc
    
  min_pixel = (*global_bc).min_pixel_plotted
  max_pixel = (*global_bc).max_pixel_plotted
  min_tube  = (*global_bc).min_tube_plotted
  max_tube  = (*global_bc).max_tube_plotted
  
  both_banks = (*(*main_global).both_banks)
  zoom_data = both_banks[*,min_pixel:max_pixel,min_tube:max_tube]
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global_bc).tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 400,350)
  (*(*global_bc).rtt_zoom_data) = rtt_zoom_data
  
  id = WIDGET_INFO(base,FIND_BY_UNAME='beam_center_main_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, rtt_zoom_data
  
END

;------------------------------------------------------------------------------
;save background
PRO save_beam_center_background,  Event=event, BASE=base

  uname = 'beam_center_main_draw'
  IF (N_ELEMENTS(base) NE 0) THEN BEGIN
    id = WIDGET_INFO(base, FIND_BY_UNAME=uname)
    WIDGET_CONTROL,base,GET_UVALUE=global
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
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  (*(*global).background) = background
  
END