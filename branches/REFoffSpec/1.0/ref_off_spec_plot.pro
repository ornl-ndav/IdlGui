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
ymin = 0 * y_coeff
ymax = 303 * y_coeff
xmin = xmin * x_coeff
xmax = xmax * x_coeff

plots, [xmin, xmin, xmax, xmax, xmin],$
  [ymin,ymax, ymax, ymin, ymin],$
  /DEVICE,$
  COLOR =color

END

;------------------------------------------------------------------------------
PRO Cleanup_data, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;get number of files loaded
nbr_plot = getNbrFiles(Event)

;retrieve data
pData       = (*(*global).pData_y)
pData_error = (*(*global).pData_y_error)
j = 0
WHILE (j  LT nbr_plot) DO BEGIN
    
    fpData        = FLOAT(*pData[j])
    tfpData       = TRANSPOSE(fpData)
    tfpData_error = TRANSPOSE(*pData_error[j])

;remove undefined values
    index = WHERE(~FINITE(tfpData),Nindex)
    IF (Nindex GT 0) THEN BEGIN
        tfpData[index] = 0
    ENDIF
    
    *pData[j]       = tfpData
    *pData_error[j] = tfpData_error
    ++j

ENDWHILE

(*(*global).pData_y)       = pData
(*(*global).pData_y_error) = pData_error

END

;------------------------------------------------------------------------------
PRO plotColorScale, Event, master_min, master_max
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_color_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
ERASE

IF (isLogZaxisSelected(Event)) THEN BEGIN
    divisions = 4
    perso_format = '(f6.2)'
    range  = FLOAT([master_min,master_max])
ENDIF ELSE BEGIN
    divisions = 20
    perso_format = ''
    range = [master_min,master_max]
ENDELSE

colorbar, $
  NCOLORS      = 255, $
  POSITION     = [0.58,0.01,0.95,0.99], $
  RANGE        = range,$
  DIVISIONS    = divisions,$
  FORMAT       = '(I0)',$
  PERSO_FORMAT = perso_format,$
  /VERTICAL

END


;------------------------------------------------------------------------------
PRO plotAsciiData, Event, TYPE=type
WIDGET_CONTROL, Event.top, GET_UVALUE=global

new_way = 1 ;1 for new way, 0 for old way of adding data together

IF (N_ELEMENTS(TYPE) EQ 0) THEN BEGIN
;;clean up data
    Cleanup_data, Event
;create new x-axis and new pData_y
    congrid_data, Event
ENDIF

;get number of files loaded
nbr_plot = getNbrFiles(Event)

;retrieve data
tfpData             = (*(*global).pData_y)
xData               = (*(*global).pData_x)
xaxis               = (*(*global).x_axis)
congrid_coeff_array = (*(*global).congrid_coeff_array)
xmax                = 0L
IF (new_way) THEN BEGIN
    x_axis              = LONARR(nbr_plot)
ENDIF ELSE BEGIN
    x_axis              = LONARR(1) ;max value of each x-axis
ENDELSE
y_coeff = 2
x_coeff = 1

;help, *tfpData[0]  -> [1089,304]
;help, *tfpData[1]  -> [565,304]

;check which array is the biggest (index)
;this array will be the base for the other array (xaxis will be based
;on this array
max_coeff       = MAX(congrid_coeff_array)
index_max_array = WHERE(congrid_coeff_array EQ max_coeff)

IF (N_ELEMENTS(TYPE) EQ 0) THEN BEGIN ;from browse button
;    IF ((*global).first_load EQ 1) THEN BEGIN
;populate trans_coeff_list using default value of (1,1,...)
    trans_coeff_list = FLTARR(nbr_plot) + 1.
    (*(*global).trans_coeff_list) = trans_coeff_list
;    ENDIF ELSE BEGIN
;        trans_coeff_list = (*(*global).trans_coeff_list)        
;        trans_coeff_list = [trans_coeff_list,1.]
;    ENDELSE
;    (*(*global).trans_coeff_list) = trans_coeff_list
ENDIF ELSE BEGIN ;when using 'replot'
    trans_coeff_list = (*(*global).trans_coeff_list)
ENDELSE

master_min = 0
master_max = 0
min_array  = FLTARR(nbr_plot) ;array of all the min values
max_array  = FLTARR(nbr_plot) ;array of all the max values
xmax_array = FLTARR(nbr_plot) ;x of max value per array
ymax_array = FLTARR(nbr_plot) ;y of max value per array
max_size   = 0 ;maximum x value
index      = 0 ;loop variable (nbr of array to add/plot
WHILE (index LT nbr_plot) DO BEGIN
    
    local_tfpData = *tfpData[index]

;Applied attenuator coefficient 
    transparency_1 = trans_coeff_list[index]
    local_tfpData = local_tfpData * transparency_1

;check if user wants linear or logarithmic plot
    bLogPlot = isLogZaxisSelected(Event)
    IF (bLogPlot) THEN BEGIN
        local_tfpData = ALOG10(local_tfpData)
        index_inf = WHERE(local_tfpData LT 0, nIndex)
        IF (nIndex GT 0) THEN BEGIN
            local_tfpData[index_inf] = 0
        ENDIF
    ENDIF

    IF (new_way) THEN BEGIN

        IF (index EQ 0) THEN BEGIN
;array that will serve as the background 
            base_array = local_tfpData 
            size = (size(total_array,/DIMENSIONS))[0]
            max_size = (size GT max_size) ? size : max_size
        ENDIF

;determine min and max value (for this array only)
        local_min = transparency_1 * MIN(local_tfpData)
        local_max = transparency_1 * MAX(local_tfpData)
        min_array[index] = local_min
        max_array[index] = local_max

;save position of max value (used for log book only)
        idx1 = WHERE(transparency_1*local_tfpData EQ local_max)
        ind1 = ARRAY_INDICES(local_tfpData,idx1)
        delta_x = xaxis[1]-xaxis[0]
        xmax_array[index] = ind1[0]*delta_x
        ymax_array[index] = ind1[1]/2.
        
;store x-axis end value
        x_axis[index] = (size(local_tfpData,/DIMENSION))[0]

;determine max and min value of y (over all the data arrays)
        master_min = (local_min LT master_min) ? local_min : master_min
        master_max = (local_max GT master_max) ? local_max : master_max

        IF (index NE 0) THEN BEGIN
            index_no_null = WHERE(local_tfpData NE 0,nbr)
            IF (nbr NE 0) THEN BEGIN
                index_indices = ARRAY_INDICES(local_tfpData,index_no_null)
                sz = (size(index_indices,/DIMENSION))[1]
;loop through all the not null values and add them to the background
;array if their value is greater than the background one
                i = 0L
                WHILE(i LT sz) DO BEGIN
                    x = index_indices[0,i]
                    y = index_indices[1,i]
                    value_new = local_tfpData(x,y)
                    value_old = base_array(x,y)
                    IF (value_new GT value_old) THEN BEGIN
                        base_array(x,y) = value_new
                    ENDIF
                    ++i
                ENDWHILE
            ENDIF
        ENDIF

    ENDIF ELSE BEGIN
    
;rebin by 2 in y-axis
        rData = REBIN(local_tfpData,(size(local_tfpData))(1)*x_coeff, $
                      (size(local_tfpData))(2)*y_coeff,/SAMPLE)
        
        size = (size(total_array,/DIMENSIONS))[0]
        max_size = (size GT max_size) ? size : max_size
        
        transparency_1 = trans_coeff_list[index]
;determine min and max value (for this array only)
        local_min = transparency_1 * MIN(rData)
        local_max = transparency_1 * MAX(rData)
        
;save position of max value (used for log book only)
        idx1 = WHERE(transparency_1*rData EQ local_max)
        ind1 = ARRAY_INDICES(rData,idx1)
        delta_x = xaxis[1]-xaxis[0]
        xmax_array[index] = ind1[0]*delta_x
        ymax_array[index] = ind1[1]/2.
        
;determine max and min value of y (over all the data arrays)
        master_min = (local_min LT master_min) ? local_min : master_min
        master_max = (local_max GT master_max) ? local_max : master_max
        IF (index EQ 0) THEN BEGIN ;first pass
            total_array = rData
            x_axis[0] = (size(rData,/DIMENSION))[0]
            min_array[0] = local_min
            max_array[0] = local_max
        ENDIF ELSE BEGIN        ;other pass
            size = (size(rData,/DIMENSIONS))[0]
            x_axis = [x_axis,size]
            min_array[index] = local_min
            max_array[index] = local_max
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
            ENDIF ELSE BEGIN    ;new array is smaller
                x = (size(total_array,/DIMENSIONS))[0]
                y = (size(total_array,/DIMENSIONS))[1]
                new_array = LONARR(x,y)
                idx = WHERE(rData NE 0)
                ind = ARRAY_INDICES(rData,idx)
                imax = (size(ind,/DIMENSIONS))[1]
                FOR i=0L,imax-1 DO BEGIN
                    new_array(ind[0,i],ind[1,i]) = rData(ind[0,i],ind[1,i])
                ENDFOR
                total_array = BYTSCL(total_array + $
                                     transparency_1*new_array,/NAN)
            ENDELSE
        ENDELSE
        
        (*(*global).total_array) = total_array

    ENDELSE ;end of 'if (new_way)'

    ++index
    
ENDWHILE

IF (new_way) THEN BEGIN
;rebin by 2 in y-axis final array
    rData = REBIN(base_array,(size(base_array))(1)*x_coeff, $
                  (size(base_array))(2)*y_coeff,/SAMPLE)
    (*(*global).total_array) = rData
    total_array = rData
ENDIF

;put information in log book about min and max
InformLogBook, Event, min_array, max_array, xmax_array, ymax_array ;_gui

DEVICE, DECOMPOSED=0
LOADCT, 5, /SILENT

;plot color scale
plotColorScale, Event, master_min, master_max ;_gui

;select plot
;id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step2')
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

;plot main plot
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

    contour_plot, Event, xaxis

ENDIF

END


;------------------------------------------------------------------------------
PRO contour_plot, Event, xaxis
WIDGET_CONTROL, Event.top, GET_UVALUE=global

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

;------------------------------------------------------------------------------
PRO changeTransparencyFullReset, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
trans_coeff_list = (*(*global).trans_coeff_list)
sz = N_ELEMENTS(trans_coeff_list)
index = 0
WHILE (index LT sz) DO BEGIN
    IF (index EQ 0) THEN BEGIN
        trans_coeff_list[index] = 1
    ENDIF ELSE BEGIN
        trans_coeff_list[index] = 1
    ENDELSE
    ++index
ENDWHILE
(*(*global).trans_coeff_list) = trans_coeff_list
index_selected   = getTranFileSelected(Event)
IF (index_selected EQ 0) THEN BEGIN
    putTextFieldValue, Event, 'transparency_coeff', 'N/A'
ENDIF ELSE BEGIN
    putTextFieldValue, Event, $
      'transparency_coeff', $
      STRCOMPRESS(trans_coeff_list[index_selected]*100,/REMOVE_ALL)
ENDELSE
plotASCIIdata, Event, TYPE='replot' ;_plot
;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END


