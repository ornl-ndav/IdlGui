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
FUNCTION plotTxt_build_gui, sStructure, plot_xsize, plot_ysize

xoffset = (*sStructure).base_geometry.xoffset
yoffset = (*sStructure).base_geometry.yoffset
xsize   = (*sStructure).base_geometry.xsize
ysize   = (*sStructure).base_geometry.ysize
title   = 'Sq(E) : ' + (*sStructure).output_file_name

main_base = WIDGET_BASE(XOFFSET   = xoffset,$
                        YOFFSET   = yoffset,$
                        SCR_XSIZE = xsize,$
                        SCR_YSIZE = ysize,$
                        TITLE     = title)

;build draw
xoff = 40
yoff = 40
draw_xsize = xsize - 2*xoff
draw_ysize = ysize - 2*yoff
draw = WIDGET_DRAW(main_base,$
                   XOFFSET   = xoff,$
                   YOFFSET   = yoff,$
                   SCR_XSIZE = draw_xsize,$
                   SCR_YSIZE = draw_ysize,$
                   UNAME     = 'plot_text_draw')

plot_xsize = draw_xsize
plot_ysize = draw_ysize

Widget_Control, /REALIZE, main_base
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

RETURN, main_base
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLplotTxt::init, sStructure

;get number of X(E) and Y(Q) elements
xsize = N_ELEMENTS((*sStructure).ERange)
ysize = N_ELEMENTS((*sStructure).QRange)

;build gui
main_base = plotTxt_build_gui(sStructure, plot_xsize, plot_ysize)

;plot data
id = WIDGET_INFO(main_base,FIND_BY_UNAME='plot_text_draw')
WIDGET_CONTROL, id, GET_VALUE = plot_id
wset, plot_id

;remove NaN from data
data = (*sStructure).fData
;index_nan = WHERE(data EQ !VALUES.F_NAN, nbr)
;IF (nbr GT 0) THEN BEGIN
;    data[index_nan] = 0
;ENDIF

lDAta = ALOG10(data)

index_inf = WHERE(lDAta EQ -!VALUES.F_INFINITY, nbr)
IF (nbr GT 0) THEN BEGIN
    lDAta[index_inf] = !VALUES.F_NAN
ENDIF
min_value = MIN(lData,/NAN)
slData = lData - min_value

;cslData = REBIN(slData,1000,20*35)
cslData = CONGRID(slData,plot_xsize,plot_ysize) ;give a much better realistic
                                ;plot

DEVICE, DECOMPOSED = 0
tvscl, cslData,/NAN

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
