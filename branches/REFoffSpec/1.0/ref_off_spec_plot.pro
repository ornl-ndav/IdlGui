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

PRO plotBox, x_coeff, y_coeff, xmin, xmax, COLOR=color
ymin = 0
ymax = 303
plots, xmin*x_coeff, ymin*y_coeff, $
  /DEVICE, $
  COLOR=color
plots, xmax*x_coeff, ymin*y_coeff, /DEVICE, $
  /CONTINUE, $
  COLOR=color
plots, xmax*x_coeff, ymax*y_coeff, /DEVICE, $
  /CONTINUE, $
  COLOR=color
plots, xmin*x_coeff, ymax*y_coeff, /DEVICE, $
  /CONTINUE, $
  COLOR=color
plots, xmin*x_coeff, ymin*y_coeff, /DEVICE, $
  /CONTINUE, $
  COLOR=color
END

;------------------------------------------------------------------------------
PRO Cleanup_data, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;get number of files loaded
nbr_plot = getNbrFiles(Event)

;retrieve data
pData = (*(*global).pData_y)
j = 0
WHILE (j  LT nbr_plot) DO BEGIN
    
    fpData = FLOAT(*pData[j])
    tfpData = TRANSPOSE(fpData)
    
;remove undefined values
    index = WHERE(~FINITE(tfpData),Nindex)
    IF (Nindex GT 0) THEN BEGIN
        tfpData[index] = 0
    ENDIF

    *pData[j] = tfpData
    ++j

ENDWHILE

(*(*global).pData_y) = pData

END


;------------------------------------------------------------------------------
PRO plotAsciiData, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
DEVICE, DECOMPOSED=0
LOADCT, 5, /SILENT

;clean up data
Cleanup_data, Event
;create new x-axis and new pData_y
congrid_data, Event
;retrieve data
tfpData = (*(*global).pData_y)
xData   = (*(*global).pData_x)
;get number of files loaded
nbr_plot = getNbrFiles(Event)

index = 0
WHILE (index LT nbr_plot) DO BEGIN
    
    local_tfpData = *tfpData[index]

;rebin by 2 in y-axis
    y_coeff = 2
    x_coeff = 1
    rData = REBIN(local_tfpData,(size(local_tfpData))(1)*x_coeff, $
                  (size(local_tfpData))(2)*y_coeff,/SAMPLE)
 
;pData = indgen(200,300)
    TVSCL, rData,/DEVICE
    
;plot box around
    xmin = 0
    xmax = (size(tfpData))(1)
    plotBox, x_coeff, y_coeff, xmin, xmax, COLOR=200
    
;print, xrange
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
    sDraw = WIDGET_INFO(id,/GEOMETRY)
    XYoff = [42,40]
    xoff = XYoff[0]+16

;get number of xvalue
    
    sz = N_ELEMENTS(*xData[index])
    position = [XYoff[0],XYoff[1],sz+XYoff[0],sDraw.ysize+XYoff[1]-4]    
    ++index
    
ENDWHILE

;plot xaxis
xaxis = (*(*global).x_axis)
sz    = N_ELEMENTS(xaxis)
xrange = [0,xaxis[sz-1]]
xticks = 15

refresh_plot_scale, $
  EVENT  = Event, $
  XSCALE = xrange, $
  XTICKS = xticks, $
  POSITION = position

END

;------------------------------------------------------------------------------
;This procedure plots the scale that surround the plot
PRO refresh_plot_scale, EVENT     = Event, $
                        MAIN_BASE = MAIN_BASE, $
                        XSCALE    = xscale, $
                        XTICKS    = xticks, $
                        POSITION  = position

IF (N_ELEMENTS(EVENT) NE 0) THEN BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
;change color of background    
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step2')
ENDIF ELSE BEGIN
    WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global
;change color of background    
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='step2_draw')
    id_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scale_draw_step2')
ENDELSE    

WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

LOADCT, 0,/SILENT

IF (N_ELEMENTS(XSCALE) EQ 0) THEN xscale = [0,80]
IF (N_ELEMENTS(XTICKS) EQ 0) THEN xticks = 8
IF (N_ELEMENTS(POSITION) EQ 0) THEN BEGIN
    sDraw = WIDGET_INFO(id,/GEOMETRY)
    position = [42,40,sDraw.xsize-42, sDraw.ysize+36]
ENDIF

WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

plot, randomn(s,303L), $
  XRANGE        = xscale,$
  YRANGE        = [0L,303L],$
  COLOR         = convert_rgb([0B,0B,255B]), $
  BACKGROUND    = convert_rgb((*global).sys_color_face_3d),$
  THICK         = 1, $
  TICKLEN       = -0.015, $
  XTICKLAYOUT   = 0,$
  YTICKLAYOUT   = 0,$
  XTICKS        = xticks,$
  YTICKS        = 25,$
  YSTYLE        = 1,$
  XSTYLE        = 1,$
  YTICKINTERVAL = 10,$
  ;XMARGIN       = [7,0],$
  POSITION      = position,$
  NOCLIP        = 0,$
  /NODATA,$
  /DEVICE

END
