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

;------------------------------------------------------------------------------
PRO plotAsciiData, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
DEVICE, DECOMPOSED=0
LOADCT, 5, /SILENT

;retrieve data
pData = (*(*global).pData_y)
fpData = FLOAT(pData)
tfpData = TRANSPOSE(fpData)

;remove undefined values
index = WHERE(~FINITE(tfpData),Nindex)
IF (Nindex GT 0) THEN BEGIN
    tfpData[index] = 0
ENDIF

;rebin by 2 in y-axis
rData = REBIN(tfpData,(size(tfpData))(1)*2,(size(tfpData))(2)*2,/SAMPLE)

;pData = indgen(200,300)
TVSCL, rData,/DEVICE

END

;------------------------------------------------------------------------------
;This procedure plots the scale that surround the plot
PRO refresh_plot_scale, EVENT=Event, MAIN_BASE=MAIN_BASE
IF (N_ELEMENTS(EVENT) NE 0) THEN BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
;change color of background    
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step2')
ENDIF ELSE BEGIN
    WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global
;change color of background    
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scale_draw_step2')
ENDELSE    

WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

LOADCT, 0,/SILENT

plot, randomn(s,303L), $
  XRANGE        = [0,80],$
  YRANGE        = [0L,303L],$
  COLOR         = convert_rgb([0B,0B,255B]), $
  BACKGROUND    = convert_rgb((*global).sys_color_face_3d),$
  THICK         = 1, $
  TICKLEN       = -0.015, $
  XTICKLAYOUT   = 0,$
  YTICKLAYOUT   = 0,$
  XTICKS        = 8,$
  YTICKS        = 25,$
  YSTYLE        = 1,$
  YTICKINTERVAL = 10,$
  XMARGIN       = [7,0],$
  /NODATA

END
