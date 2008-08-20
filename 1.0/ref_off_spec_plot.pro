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
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step2')
;id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
;DEVICE, DECOMPOSED=0
;LOADCT, 5, /SILENT

;;clean up data
Cleanup_data, Event
;create new x-axis and new pData_y
congrid_data, Event
;retrieve data
tfpData   = (*(*global).pData_y)
xData     = (*(*global).pData_x)
xaxis     = (*(*global).x_axis)
xmax_list = FLTARR(1)
xmax      = 0
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
    
    grayPalette = OBJ_NEW('IDLgrPalette')
    grayPalette->Loadct,5
    colorTable = 5

    CASE (index) OF
        0: BEGIN
            backgroundImage  = rData
            xmax_local = (size(backgroundImage))(1)
            xmax_list[0] = xmax_local
            backgroundImgObj = $
              OBJ_NEW('IDLgrImage', $
                      backgroundImage, $
                      Dimensions=[xmax_local,304], $
                      Palette=grayPalette)
            ;create a model for the images. Add images to model
            thisModel = OBJ_NEW('IDLgrModel')
            thisModel->Add, backgroundImgObj

        END
        ELSE: BEGIN
            foregroundImage = rData
            s = SIZE(foregroundImage,/DIMENSIONS)
            alpha_image = BYTARR(4,s[0],s[1])
            LOADCT, colorTable
            TVLCT, r, g, b, /GET
            alpha_image[0,*,*] = r[foregroundImage]
            alpha_image[1,*,*] = g[foregroundImage]
            alpha_image[2,*,*] = b[foregroundImage]

;Pixels with value 0 will be totally transparent
;Other pixels will start out half transparent        
            blendMask = BytArr(s[0],s[1])
            blendMask[WHERE(foregroundImage GT 0)] = 1B
            alpha_image[3,*,*] = blendMask * 50B ;128B
            
            xmax_local = (size(foregroundImage))(1)
            xmax_list = [xmax_list,xmax_local]
            alphaImage = OBJ_NEW('IDLgrImage', alpha_image, $
                                 Dimensions=[xmax_local,304],$
                                 InterLeave=0,$
                                 Blend_func=[3,4])
            thisModel->Add, alphaImage
            
        END
    ENDCASE

    xmax = (xmax_local GT xmax) ? xmax_local : xmax
;==============================================================================
;==============================================================================
    
;pData = indgen(200,300)
;    TVSCL, rData,/DEVICE
    
;plot box around
;    xmin = 0
;    xmax = (size(*tfpData[index]))(1)
;    plotBox, x_coeff, y_coeff, xmin, xmax, COLOR=(*global).box_color
;    (*global).box_color += 50

    ++index
    
ENDWHILE

;create a view
viewRect = [0,0,xmax,304]
thisView = OBJ_NEW('IDLgrView',Viewplane_Rect=viewRect)
thisView->Add, thisModel

id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
Widget_Control, id_draw, Get_Value=thisWindow
thisWindow->Draw, thisView

thisContainer = Obj_New('IDL_Container')
thisContainer->Add, backgroundImgObj
thisContainer->Add, thisWindow
thisContainer->Add, thisModel
thisContainer->Add, grayPalette
thisContainer->Add, thisView

;plot boxes
nbr_box = N_ELEMENTS(xmax_list)
i = 0
WHILE (i LT nbr_box) DO BEGIN
    xmin = 0
    plotBox, x_coeff, y_coeff, $
      xmin, xmax_list[i], $
      COLOR=(*global).box_color
    (*global).box_color += 50
    ++i
ENDWHILE

;plot xaxis
sz    = N_ELEMENTS(xaxis)
xrange = [0,xaxis[sz-1]]
xticks = (sz/50)

;print, xrange
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
sDraw = WIDGET_INFO(id,/GEOMETRY)
XYoff = [42,40]
xoff = XYoff[0]+16

;get number of xvalue from bigger range
position = [XYoff[0],XYoff[1],sz+XYoff[0],sDraw.ysize+XYoff[1]-4]    

;save parameters
(*global).xscale.xrange   = xrange
(*global).xscale.xticks   = xticks
(*global).xscale.position = position

refresh_plot_scale, $
  EVENT    = Event, $
  XSCALE   = xrange, $
  XTICKS   = xticks, $
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
;    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step2')
ENDIF ELSE BEGIN
    WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global
;change color of background    
;    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='step2_draw')
    id_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scale_draw_step2')
ENDELSE    

;WIDGET_CONTROL, id, GET_VALUE=id_value
;WSET, id_value

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

;------------------------------------------------------------------------------
PRO change_xaxis_ticks, Event, TYPE=type
WIDGET_CONTROL, Event.top, GET_UVALUE=global
xticks = (*global).xscale.xticks

CASE TYPE OF
    'less': xticks1 = xticks - 5
    'more': xticks1 = xticks + 5
    ELSE:
ENDCASE

IF (xticks1 GT 0 AND $
    xticks1 LT 60) THEN BEGIN
    xticks = xticks1
ENDIF

(*global).xscale.xticks = xticks

;save parameters
xrange   = (*global).xscale.xrange 
position = (*global).xscale.position 

refresh_plot_scale, $
  EVENT    = Event, $
  XSCALE   = xrange, $
  XTICKS   = xticks, $
  POSITION = position

END
