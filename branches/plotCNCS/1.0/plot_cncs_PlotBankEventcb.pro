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

PRO RefreshBank, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global2
;select plot area
id = widget_info((*global2).wBase,find_by_uname='bank_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

Xfactor = (*global2).Xfactor
Yfactor = (*global2).Yfactor
IF ((*global2).bDasView EQ 0) THEN BEGIN 
    tvscl, (*(*global2).bank_rebin), /device
ENDIF ELSE BEGIN
    tvscl, (*(*global2).bank_congrid), /device
ENDELSE
END

;==============================================================================
PRO BankPlotInteraction, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global2
wbase   = (*global2).wBase
;retrieve bank number
BankX = getBankPlotX(Event)
putTextInTextField, Event, 'x_input', BankX
BankY = getBankPlotY(Event)
putTextInTextField, Event, 'y_input', BankY

;get pixelID
BankID = (*global2).bankName
PixelID = getPixelID(BankID, BankX, BankY)

print, 'PixelID: ' + strcompress(PixelID) ;remove_me

;get number of counts
tvimg = (*(*global2).tvimg)
real_pixelID = DOUBLE(PixelID) + (DOUBLE(BankID)-1) * 1024L
print, 'real_pixelID: ' + strcompress(real_pixelID) ;remove_me
putTextInTextField, Event, 'pixelid_input', $
STRCOMPRESS(real_pixelID,/REMOVE_ALL)
putTextInTextField, Event, 'counts', STRCOMPRESS(tvimg[real_pixelID],/REMOVE_ALL)

;display tube angle
TubeAngle = (*global2).TubeAngle
GeneralTube = (FIX(BankID)-1)*8 + FIX(BankX)
TubeAngleValue = TubeAngle[GeneralTube]
putTextInTextField, Event, 'scattering_angle', $
STRCOMPRESS(TubeAngleValue,/REMOVE_ALL)

END




PRO PlotPixelBox, x, y, x_coeff, y_coeff, color
plots, x*x_coeff, y*y_coeff, /device, color=color
plots, x*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
plots, (x+1)*x_coeff, y*y_coeff, /device, color=color
plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color

plots, x*x_coeff,y*y_coeff, /device,color=color
plots, (x+1)*x_coeff, y*y_coeff, /device, /continue, color=color
plots, x*x_coeff,(y+1)*y_coeff, /device,color=color
plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
END



PRO PlotSelectionBox, xmin, ymin, xmax, ymax, x_coeff, y_coeff, color
IF (xmin EQ xmax) THEN ++xmax
IF (ymin EQ ymax) THEN ++ymax
plots, xmin*x_coeff, ymin*y_coeff, /device, color=color
plots, xmin*x_coeff, ymax*y_coeff, /device, /continue, color=color
plots, xmax*x_coeff, ymin*y_coeff, /device, color=color
plots, xmax*x_coeff, ymax*y_coeff, /device, /continue, color=color

plots, xmin*x_coeff, ymin*y_coeff, /device,color=color
plots, xmax*x_coeff, ymin*y_coeff, /device, /continue, color=color
plots, xmin*x_coeff, ymax*y_coeff, /device,color=color
plots, xmax*x_coeff, ymax*y_coeff, /device, /continue, color=color
END



;plot single pixel when user move nouse over bank plot
PRO plotPixel, Event  
WIDGET_CONTROL, event.top, GET_UVALUE=global2
x       = Event.X
y       = Event.y
xfactor = (*global2).Xfactor
yfactor = (*global2).Yfactor

;id = widget_info((*global2).wbase,find_by_uname='bank_plot')
;WIDGET_CONTROL, id, GET_VALUE=id_value
;WSET, id_value

x = Fix(x/xfactor)
y = Fix(y/yfactor)

PlotPixelBox, x, y, xfactor, yfactor, 100
END





;plot full selection
PRO plotSelection, Event  
WIDGET_CONTROL, event.top, GET_UVALUE=global2
xfactor = (*global2).Xfactor
yfactor = (*global2).Yfactor
xmin    = (*global2).xLeftCorner
ymin    = (*global2).yLeftCorner
xmax    = Event.X
ymax    = Event.y

;id = widget_info((*global2).wbase,find_by_uname='bank_plot')
;WIDGET_CONTROL, id, GET_VALUE=id_value
;WSET, id_value

xmin = Fix(xmin)
ymin = Fix(ymin)
xmax = Fix(xmax/xfactor)
ymax = Fix(ymax/yfactor)

PlotSelectionBox, xmin, ymin, xmax, ymax, xfactor, yfactor, 50

END




PRO takeScreenshot, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global2
DEVICE, RETAIN=2
tmpImg = tvrd(TRUE=3)
sz = size(tmpImg)
tmpImg = rebin(tmpImg, sz(1)/2,sz(2)/2,sz(3))
(*(*global2).tmpImg) = tmpImg
END
