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

PRO plotTxt_build_gui_event, Event
 
wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
	
ENDCASE
END

;------------------------------------------------------------------------------
FUNCTION plotTxt_build_gui, sStructure, $
                            plot_xsize, $
                            plot_ysize, $
                            min_z_value,$
                            max_z_value

xoffset = (*sStructure).base_geometry.xoffset
yoffset = (*sStructure).base_geometry.yoffset
xsize   = (*sStructure).base_geometry.xsize
ysize   = (*sStructure).base_geometry.ysize+10
title   = 'Sq(E) : ' + (*sStructure).output_file_name

main_base = WIDGET_BASE(XOFFSET   = xoffset,$
                        YOFFSET   = yoffset,$
                        SCR_XSIZE = xsize+150,$
                        SCR_YSIZE = ysize,$
                        TITLE     = title)

sys_color = WIDGET_INFO(main_base,/SYSTEM_COLORS)
(*sStructure).sys_color_face_3d = sys_color.face_3d

;build draw
xoff = 55
yoff = 45
draw_xsize = xsize - 2*xoff
draw_ysize = ysize - 2*yoff - 10

draw = WIDGET_DRAW(main_base,$
                   XOFFSET   = xoff+10,$
                   YOFFSET   = 40,$
                   SCR_XSIZE = draw_xsize,$
                   SCR_YSIZE = draw_ysize,$
                   UNAME     = 'plot_txt_draw')

;z-axis scale plot
s_scale_draw = WIDGET_DRAW(main_base,$
                           XOFFSET   = xsize,$
                           YOFFSET   = 10,$
                           SCR_XSIZE = 120,$
                           SCR_YSIZE = 720,$
                           UNAME     = 'plot_txt_zaxis_scale_draw')

;x-y scale plot
scale_draw = WIDGET_DRAW(main_base,$
                         XOFFSET = 10,$
                         YOFFSET = 0,$
                         SCR_XSIZE = xsize,$
                         SCR_YSIZE = 720,$
                         UNAME     = 'plot_txt_scale_draw')

plot_xsize = draw_xsize
plot_ysize = draw_ysize

Widget_Control, /REALIZE, main_base
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;plot scale
id_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='plot_txt_zaxis_scale_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
ERASE

;z-axis scale

divisions = 20
perso_format = '(E11.3)'
range  = [min_z_value,max_z_value]

colorbar, $
  /YLOG,$
  NCOLORS      = 255, $
  POSITION     = [0.58,0.01,0.95,0.99], $
  RANGE        = range,$
  DIVISIONS    = divisions,$
  PERSO_FORMAT = perso_format,$
  /VERTICAL,$
  COLOR        = 200
;  FORMAT       = '(I0)',$

;change color of background    
id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='plot_txt_scale_draw')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

;yrange
QRange = (*sStructure).QRange
nbr_y_value = N_ELEMENTS(QRange)
Qmin   = MIN(FLOAT(QRange),MAX=Qmax)
;add 1 yvalue
Qmax +=  (QRange[1]-QRange[0])

;xrange
ERange = (*sStructure).ERange
Emin   = MIN(ERange,MAX=EMax)
nbr_x_value = N_ELEMENTS(ERange)
WHILE (nbr_x_value GT 40) DO BEGIN
    nbr_x_value /= 5
ENDWHILE

plot, randomn(s,draw_xsize), $
  XRANGE     = [Emin,Emax],$
  YRANGE     = [Qmin,Qmax],$
  YSTYLE     = 1,$
  XSTYLE     = 1,$
  COLOR      = convert_rgb([0B,0B,255B]), $
  BACKGROUND = convert_rgb(sys_color.face_3d),$
  THICK      = 1, $
  XTICKLAYOUT = 0,$
  YTICKLAYOUT = 0,$
  XTICKS      = nbr_x_value,$
  YTICKS      = nbr_y_value,$
  XMARGIN     = [9.0,9.3],$
  YMARGIN     = [4,4],$
  XTITLE      = 'Energy transfer (ueV)',$
  YTITLE      = 'Q transfer (1/Angstroms)',$
  YTICKLEN    = -0.01,$
  XTICKLEN    = -0.015,$
  /NODATA

RETURN, main_base
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLplotTxt::init, sStructure

;get number of X(E) and Y(Q) elements
xsize = N_ELEMENTS((*sStructure).ERange)
ysize = N_ELEMENTS((*sStructure).QRange)

DEVICE, /DECOMPOSED

;remove NaN from data
data  = (*sStructure).fData
min_z_value = MIN(data,/NAN,MAX=max_z_value)
lDAta = ALOG10(data)

index_inf = WHERE(lDAta EQ -!VALUES.F_INFINITY, nbr)
IF (nbr GT 0) THEN BEGIN
    lDAta[index_inf] = !VALUES.F_NAN
ENDIF
min_value = MIN(lData,/NAN)
slData = lData - min_value

;build gui
main_base = plotTxt_build_gui(sStructure, $
                              plot_xsize, $
                              plot_ysize, $
                              min_z_value,$
                              max_z_value)

;plot data
id = WIDGET_INFO(main_base,FIND_BY_UNAME='plot_txt_draw')
WIDGET_CONTROL, id, GET_VALUE = plot_id
wset, plot_id


;cslData = REBIN(slData,1000,20*35)
cslData = CONGRID(slData,plot_xsize,plot_ysize) 
;give a much better realistic plot

DEVICE, DECOMPOSED = 0
TVSCL, cslData,/NAN
DEVICE, /DECOMPOSED

RETURN,1
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO IDLplotTxt__define
struct = {IDLplotTxt,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
