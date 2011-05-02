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
;    save the background image to be able
;    to replot it quicker
;
;  use the following to display it:
;   TV, (*(*global).background), true=3
;
; :Params:
;    event
;
; :Keywords:
;    main_base
;
; :Author: j35
;-
pro save_background,  event=event, main_base=main_base, uname=uname
compile_opt idl2

  if (~keyword_set(uname)) then uname = 'draw'

  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME=uname)
    widget_control, main_base, get_uvalue=global_plot
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global_plot
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  ;DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0]
  
  (*(*global_plot).background) = background
  
END