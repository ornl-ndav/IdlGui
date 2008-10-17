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
;This procedure is reached each time the tab 'RECAP' is reached
PRO refresh_recap_plot, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

ListOfFiles = (*(*global).list_OF_ascii_files)
IF (ListOfFiles[0] NE '') THEN BEGIN

    nbr_plot    = getNbrFiles(Event) ;number of files

    scaling_factor_array = (*(*global).scaling_factor)
;    pixel_offset   = (*(*global).pixel_offset_array)

    tfpData = (*(*global).realign_pData_y)
    
    xData               = (*(*global).pData_x)
    xaxis               = (*(*global).x_axis)
    congrid_coeff_array = (*(*global).congrid_coeff_array)
    xmax                = 0L
    x_axis              = LONARR(nbr_plot)
    y_coeff = 2
    x_coeff = 1
    
;check which array is the biggest (index)
;this array will be the base for the other array (xaxis will be based
;on this array
    max_coeff       = MAX(congrid_coeff_array)
    index_max_array = WHERE(congrid_coeff_array EQ max_coeff)
    
    trans_coeff_list = (*(*global).trans_coeff_list)
    
    max_thresold = FLOAT(-100)
    master_min = FLOAT(0)
    master_max = FLOAT(max_thresold)
    xmax_array = FLTARR(nbr_plot) ;x of max value per array
    ymax_array = FLTARR(nbr_plot) ;y of max value per array
    max_size   = 0              ;maximum x value
    index      = 0            ;loop variable (nbr of array to add/plot
    WHILE (index LT nbr_plot) DO BEGIN
     
        local_tfpData  = *tfpData[index]
        scaling_factor = scaling_factor_array[index]

;get only the central part of the data (when it's not the first one)
        IF (index NE 0) THEN BEGIN
            local_tfpData = local_tfpData[*,304L:2*304L-1]
        ENDIF

        IF (index EQ 1) THEN BEGIN
;            print, local_tfpData
;            print, 'scaling_factor: ' + strcompress(scaling_factor)
        ENDIF

;applied scaling factor
        local_tfpData /= scaling_factor
        
;check if user wants linear or logarithmic plot
        bLogPlot = isLogZaxisStep5Selected(Event)
        IF (bLogPlot) THEN BEGIN
            local_tfpData = ALOG10(local_tfpData)
            index_inf = WHERE(local_tfpData LT max_thresold, nIndex)
            IF (nIndex GT 0) THEN BEGIN
                local_tfpData[index_inf] = FLOAT(0)
            ENDIF
        ENDIF

        IF (index EQ 0) THEN BEGIN
;array that will serve as the background 
            base_array = local_tfpData 
            size       = (size(total_array,/DIMENSIONS))[0]
            max_size   = (size GT max_size) ? size : max_size
        ENDIF
        
;determine min and max value (for this array only)
;        local_min = MIN(local_tfpData)            
;        local_max = MAX(local_tfpData)
        
;store x-axis end value
        x_axis[index] = (size(local_tfpData,/DIMENSION))[0]
        
;determine max and min value of y (over all the data arrays)
;        master_min = (local_min LT master_min) ? local_min : master_min
        
;        master_max = FLOAT((local_max GT master_max) ? local_max : master_max)
        
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
        
        ++index
        
    ENDWHILE
    
    true_master_max = MAX(base_array,MIN=true_master_min) ;remove_me
    IF (bLogPlot) THEN BEGIN
;shift everything to +local_min to be able to plot it
        base_array += FLOAT(ABS(true_master_min))
    ENDIF
    
    master_max = true_master_max + ABS(true_master_min)
    master_min = true_master_min + ABS(true_master_min)

;rebin by 2 in y-axis final array
    rData = REBIN(base_array,(size(base_array))(1)*x_coeff, $
                  (size(base_array))(2)*y_coeff,/SAMPLE)
;    (*(*global).total_array) = rData
    total_array = rData
    
    DEVICE, DECOMPOSED=0
    LOADCT, 5, /SILENT
    
;plot color scale
    plotColorScale_step5, Event, master_min, master_max ;_gui
    
;select plot
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
    WIDGET_CONTROL, id_draw, GET_VALUE=id_value
    WSET,id_value
    
;plot main plot
    TVSCL, total_array, /DEVICE
    
;    i = 0
;    box_color = (*global).box_color
;    WHILE (i LT nbr_plot) DO BEGIN
;        plotBox, x_coeff, $
;          y_coeff, $
;          0, $
;          x_axis[i], $
;          COLOR=box_color[i]
;        ++i
;    ENDWHILE
    
    xrange   = (*global).xscale.xrange
    xticks   = (*global).xscale.xticks
    position = (*global).xscale.position
    
    refresh_plot_scale_step5, $
      EVENT    = Event, $
      XSCALE   = xrange, $
      XTICKS   = xticks, $
      POSITION = position

ENDIF
END

;------------------------------------------------------------------------------

PRO plotColorScale_step5, Event, master_min, master_max
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_color_draw_step5')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
ERASE

IF (isLogZaxisStep5Selected(Event)) THEN BEGIN
    divisions = 4
    perso_format = '(f6.2)'
    range  = FLOAT([master_min,master_max])
ENDIF ELSE BEGIN
    divisions = 20
    perso_format = ''
    range = [master_min,master_max]
ENDELSE

print, '(in plotColorScale_step5: Range:' ;remove_me
print, range ;remove_me

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
;This procedure plots the scale that surround the plot
PRO refresh_plot_scale_step5, EVENT     = Event, $
                              XSCALE    = xscale, $
                              XTICKS    = xticks, $
                              POSITION  = position

WIDGET_CONTROL, Event.top, GET_UVALUE=global

;change color of background    
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step5')

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
