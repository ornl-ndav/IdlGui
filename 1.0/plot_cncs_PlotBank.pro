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
PRO MakeGuiBankPlot_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global2

CASE event.id OF
    widget_info(event.top, FIND_BY_UNAME='bank_plot'): begin
        BankPlotInteraction, Event ;to continuously get the pixelid, X and Y
        IF (Event.press NE 1 AND $
            (*global2).MousePressed EQ 0) THEN BEGIN ;if left click not pressed
            refreshBank, Event
            plotPixel, Event    ;in plot_arcs_PlotBankEventcb.pro
        ENDIF 
        IF (Event.press NE 1 AND $
            (*global2).MousePressed EQ 1) THEN BEGIN ;if left click pressed
            refreshBank, Event
            plotSelection, Event 
        ENDIF
        IF (Event.press EQ 1) THEN BEGIN
            (*global2).MousePressed = 1
            (*global2).xLeftCorner = Event.x/(*global2).Xfactor
            (*global2).yLeftCorner = Event.y/(*global2).Yfactor
        ENDIF
        IF (Event.release EQ 1) THEN BEGIN ;mouse released
            ;refreshBank, Event
            ;plotSelection, Event 
            takeScreenshot, Event ;that will be dispayed on the right of the
                                ;IvsTOF plot
            xRightCorner = Event.x/(*global2).Xfactor
            yRightCorner = Event.y/(*global2).Yfactor

            pixelID = getPixelIdRangeFromBankBase((*global2).bankName,$
                                                  (*global2).xLeftCorner,$
                                                  (*global2).yLeftCorner,$
                                                  xRightCorner,$
                                                  yRightCorner)


            PlotTof, (*global2).img, $
              (*global2).bankName, $
              (*global2).xLeftCorner, $
              (*global2).yLeftCorner, $
              xRightCorner, $
              yRightCorner, $
              pixelID,$
              (*(*global2).tmpImg)

            (*global2).MousePressed = 0
        ENDIF
        
    END
ELSE:
ENDCASE

END

;-------------------------------------------------------------------------------
PRO plotDasView, tvimg, i, Xfactor, Yfactor, bank_rebin
bank = tvimg[i*8:(i+1)*8-1,*]
bank_rebin = rebin(bank,8*Xfactor, 128L*Yfactor,/sample)
tvscl, bank_rebin, /device
END

;------------------------------------------------------------------------------
PRO plotTofView, img, i, Xfactor, Yfactor, bank_congrid
;find out the range of non-zero values using the first non-empty bank
;bank_index = 49
bank_index = 0
;img = [1000,128,920]
tvimg1     = total(img,2)       ;tvimg1 = [1000,920]
tvimg1     = transpose(tvimg1)  ;tvimg1 = [920,1000]
ngt0 = 0
WHILE (ngt0 EQ 0) DO BEGIN
;sum the 8 tubes together
    tvimg2     = tvimg1[bank_index*8:(bank_index+1)*8-1,*]
    tvimg2     = total(tvimg2,1)
    NZindexes  = WHERE(tvimg2 GT 0, ngt0)
    bank_index++
ENDWHILE
index_start = NZindexes[0]
index_stop  = NZindexes[ngt0-1]

;keep only all data between index_start and index_stop
tvimg2     = tvimg1[*,index_start:index_stop]
Npts       = (size(tvimg2))(2) ;number of tof that survive the where GT 0 routine
dim_new    = 10            ;ratio of points we want to remove in the Y
                                ;axis (tof here)
ds         = Npts/dim_new      ;resulting downsampling ratio - how many points 
;dim_new    *= 2
;to become one point

;isolate various banks of data
;plot bottom  banks
bank         = tvimg2[i*8:(i+1)*8-1,*]
IF (ds LT (size(bank))(1)) THEN BEGIN
    bank_smooth  = smooth(bank,ds,/edge)
ENDIF ELSE BEGIN
    bank_smooth = bank
ENDELSE
bank_congrid = congrid(bank_smooth,8*Xfactor,dim_new*128)
;bank_congrid = congrid(bank_smooth,8*Xfactor,(128L*Yfactor))
tvscl, bank_congrid, /device
END

;------------------------------------------------------------------------------
PRO PlotBank, img, i, bankName, bDasView, TubeAngle

Xfactor = 10
Yfactor = 5

;build gui
wBase = ''
MakeGuiBankPlot, wBase, Xfactor, Yfactor

global2 = ptr_new({ wbase           : wbase,$
                    i               : i,$
                    bDasView        : bDasView,$
                    xLeftCorner     : 0,$
                    yLeftCorner     : 0,$
                    MousePressed    : 0,$ ;1 when mouse is pressed and keep pressed
                    Xfactor         : Xfactor,$
                    Yfactor         : Yfactor,$  
                    bankName        : bankName,$ ;ex: T16
                    tvimg           : ptr_new(0L),$
                    tvimg_transpose : ptr_new(0L),$
                    tmpImg          : ptr_new(0L),$
                    bank_rebin      : ptr_new(0L),$
                    bank_congrid    : ptr_new(0L),$
                    TubeAngle       : TubeAngle,$
                    img             : img})     

WIDGET_CONTROL, wBase, SET_UVALUE = global2
XMANAGER, "MakeGuiBankPlot", wBase, GROUP_LEADER = ourGroup,/NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5, /SILENT

;select plot area
id = widget_info(wBase,find_by_uname='bank_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

;main data array
tvimg = total(img,1)
(*(*global2).tvimg) = tvimg
tvimg = transpose(tvimg)
(*(*global2).tvimg_transpose) = tvimg

;IF (bDasView EQ 0) THEN BEGIN 
    plotDasView, tvimg, i, Xfactor, Yfactor, bank_rebin
    (*(*global2).bank_rebin) = bank_rebin
;ENDIF ELSE BEGIN
;    plotTofView, img, i, Xfactor, Yfactor, bank_congrid
;    (*(*global2).bank_congrid) = bank_congrid
;ENDELSE

;display bank number in title bar
id = widget_info(wBase,find_by_uname='bank_plot_base')
widget_control, id, base_set_title= 'Bank #: ' + $
strcompress(bankName,/REMOVE_ALL)

END
