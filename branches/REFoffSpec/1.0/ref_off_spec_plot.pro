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
    
    print, max(tfpData) ;remove_me

    *pData[j] = tfpData
    ++j

ENDWHILE

(*(*global).pData_y) = pData

END


;------------------------------------------------------------------------------
PRO plotAsciiData, Event, TYPE=type
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;select plot
;id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step2')
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
DEVICE, DECOMPOSED=0
LOADCT, 5, /SILENT

IF (N_ELEMENTS(TYPE) EQ 0) THEN BEGIN
;;clean up data
    Cleanup_data, Event
;create new x-axis and new pData_y
    congrid_data, Event
ENDIF

;retrieve data
tfpData             = (*(*global).pData_y)
xData               = (*(*global).pData_x)
xaxis               = (*(*global).x_axis)
congrid_coeff_array = (*(*global).congrid_coeff_array)
xmax                = 0L
x_axis              = LONARR(1) ;max value of each x-axis
y_coeff = 2
x_coeff = 1

;get number of files loaded
nbr_plot = getNbrFiles(Event)

;check which array is the biggest (index)
max_coeff       = MAX(congrid_coeff_array)
index_max_array = WHERE(congrid_coeff_array EQ max_coeff)

index = 0
max_size = 0

IF (N_ELEMENTS(TYPE) EQ 0) THEN BEGIN
    IF ((*global).first_load EQ 1) THEN BEGIN
;populate trans_coeff_list using default value of (1,1,...)
        trans_coeff_list = FLTARR(nbr_plot) + 1.
    ENDIF ELSE BEGIN
        trans_coeff_list = (*(*global).trans_coeff_list)
        trans_coeff_list = [trans_coeff_list,1.]
    ENDELSE
    (*(*global).trans_coeff_list) = trans_coeff_list
ENDIF ELSE BEGIN
    trans_coeff_list = (*(*global).trans_coeff_list)
ENDELSE

WHILE (index LT nbr_plot) DO BEGIN
    
    local_tfpData = *tfpData[index]

;check if user wants linear or logarithmic plot
    bLogPlot = isLogZaxisSelected(Event)
    IF (bLogPlot) THEN BEGIN
        local_tfpData = ALOG10(local_tfpData)
        index_inf = WHERE(local_tfpData LT 0, nIndex)
        IF (nIndex GT 0) THEN BEGIN
            local_tfpData[index_inf] = 0
        ENDIF
    ENDIF

;rebin by 2 in y-axis
    rData = REBIN(local_tfpData,(size(local_tfpData))(1)*x_coeff, $
                  (size(local_tfpData))(2)*y_coeff,/SAMPLE)

    size = (size(total_array,/DIMENSIONS))[0]
    max_size = (size GT max_size) ? size : max_size
    
    transparency_1 = trans_coeff_list[index]
    IF (index EQ 0) THEN BEGIN ;first pass
        total_array = rData
        x_axis[0] = (size(rData,/DIMENSION))[0]
    ENDIF ELSE BEGIN ;other pass
        size = (size(rData,/DIMENSIONS))[0]
        x_axis = [x_axis,size]
        IF (size GT max_size) THEN BEGIN ;if new array is bigger
            new_total_array = rData
            old_array = total_array
;add old array to total_array
;#1 make old array same size as new array
            x = (size(rData,/DIMENSIONS))[0]
            y = (size(rData,/DIMENSIONS))[1]
            new_array = LONARR(x,y)
;#2 find out where there are data
            idx = WHERE(rData NE 0)
            new_array[idx] = old_array[idx]
;#3 add arrays together
            total_array = BYTSCL(new_total_array + $
                                 transparency_1* $
                                 new_array, $
                                 /NAN)
        ENDIF ELSE BEGIN        ;new array is smaller
            x = (size(total_array,/DIMENSIONS))[0]
            y = (size(total_array,/DIMENSIONS))[1]
            new_array = LONARR(x,y)
            idx = WHERE(rData NE 0)
            ind = ARRAY_INDICES(rData,idx)
            imax = (size(ind,/DIMENSIONS))[1]
            FOR i=0L,imax-1 DO BEGIN
                new_array(ind[0,i],ind[1,i]) = rData(ind[0,i],ind[1,i])
            ENDFOR
            total_array = BYTSCL(total_array + transparency_1*new_array,/NAN)
        ENDELSE
    ENDELSE
    
    ++index
    
ENDWHILE

TVSCL, total_array, /DEVICE

i = 0
box_color = (*global).box_color
WHILE (i LT nbr_plot) DO BEGIN
    plotBox, x_coeff, $
      y_coeff, $
      0, $
      x_axis[i], $
      COLOR=box_color[i]
    ++i
ENDWHILE

IF (N_ELEMENTS(TYPE) EQ 0) THEN BEGIN

;plot xaxis
    sz    = N_ELEMENTS(xaxis)
    xrange = [0,xaxis[sz-1]]
    xticks = (sz/50)
    
;print, xrange
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
    sDraw = WIDGET_INFO(id,/GEOMETRY)
    XYoff = [44,40]
    xoff = XYoff[0]+16
    
;get number of xvalue from bigger range
    position = [XYoff[0], $
                XYoff[1], $
                sz+XYoff[0], $
                sDraw.ysize+XYoff[1]-4]    

    IF (sz GT sDraw.xsize) THEN BEGIN
        xRange = [0,xaxis[sDraw.xsize]]
    ENDIF

;save parameters
    (*global).xscale.xrange   = xrange
    (*global).xscale.xticks   = xticks
    (*global).xscale.position = position
    
    refresh_plot_scale, $
      EVENT    = Event, $
      XSCALE   = xrange, $
      XTICKS   = xticks, $
      POSITION = position

ENDIF

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

xticks = (xticks GT 60) ? 55 : xticks
(*global).xscale.xticks = xticks

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

;------------------------------------------------------------------------------
PRO changeTransparencyCoeff, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
index_selected   = getTranFileSelected(Event)
;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
IF (index_selected EQ 0) THEN BEGIN
    putTextFieldValue, Event, 'transparency_coeff', 'N/A'
ENDIF ELSE BEGIN
    trans_value      = getTextFieldValue(Event,'transparency_coeff')
    trans_coeff_list = (*(*global).trans_coeff_list)
;make sure the value loaded is a valid coefficient
    ON_IOERROR, done
    fix_trans_value = FLOAT(trans_value)
    trans_coeff_list[index_selected] = FLOAT(fix_trans_value)/100.
    (*(*global).trans_coeff_list) = trans_coeff_list
    plotASCIIdata, Event, TYPE='replot' ;_plot
ENDELSE
done:
;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END
