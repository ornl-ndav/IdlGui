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
PRO plotColorScale_shifting, Event, master_min, master_max
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_color_draw_step3')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
ERASE

IF (isLogZaxisShiftingSelected(Event)) THEN BEGIN
    divisions = 4
    format = '(I0)'
    range  = FLOAT([master_min,master_max])
ENDIF ELSE BEGIN
    divisions = 20
    format = '(I0)'
    range = [master_min,master_max]
ENDELSE

colorbar, $
  NCOLORS   = 255, $
  POSITION  = [0.58,0.01,0.95,0.99], $
  RANGE     = range,$
  DIVISIONS = divisions,$
  FORMAT    = format,$
  /VERTICAL

END


;------------------------------------------------------------------------------
PRO plotAsciiData_shifting, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;get number of files loaded
nbr_plot = getNbrFiles(Event)

;retrieve data
tfpData             = (*(*global).pData_y)
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
    bLogPlot = isLogZaxisShiftingSelected(Event)
    IF (bLogPlot) THEN BEGIN
        local_tfpData = ALOG10(local_tfpData)
        index_inf = WHERE(local_tfpData LT 0, nIndex)
        IF (nIndex GT 0) THEN BEGIN
            local_tfpData[index_inf] = 0
        ENDIF
    ENDIF
    
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
    
    ++index
    
ENDWHILE

;rebin by 2 in y-axis final array
rData = REBIN(base_array,(size(base_array))(1)*x_coeff, $
              (size(base_array))(2)*y_coeff,/SAMPLE)
(*(*global).total_array) = rData
total_array = rData

DEVICE, DECOMPOSED=0
LOADCT, 5, /SILENT

;plot color scale
plotColorScale_shifting, Event, master_min, master_max ;_gui

;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step3_draw')
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

END


;------------------------------------------------------------------------------
PRO contour_plot_shifting, Event, xaxis
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;plot xaxis
sz    = N_ELEMENTS(xaxis)
xrange = [0,xaxis[sz-1]]
xticks = (sz/50)

;print, xrange
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step3_draw')
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

refresh_plot_scale_shifting, $
  EVENT    = Event, $
  XSCALE   = xrange, $
  XTICKS   = xticks, $
  POSITION = position

END

;------------------------------------------------------------------------------
;This procedure plots the scale that surround the plot
PRO refresh_plot_scale_shifting, EVENT     = Event, $
                                 MAIN_BASE = MAIN_BASE, $
                                 XSCALE    = xscale, $
                                 XTICKS    = xticks, $
                                 POSITION  = position

IF (N_ELEMENTS(EVENT) NE 0) THEN BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
;change color of background    
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step3')
ENDIF ELSE BEGIN
    WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global
;change color of background    
    id_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scale_draw_step3')
ENDELSE    

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
PRO change_xaxis_ticks_shifting, Event, TYPE=type
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

refresh_plot_scale_shifting, $
  EVENT    = Event, $
  XSCALE   = xrange, $
  XTICKS   = xticks, $
  POSITION = position

END

;------------------------------------------------------------------------------
PRO updateStep3FileNames, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get list of files
list_OF_files = (*(*global).list_OF_ascii_files)
;get only short file name of all files
short_list_OF_files = getShortName(list_OF_files)
;put list of files in droplist of step3
putListOfFilesShifting, Event, short_list_OF_files  ;remove comments
IF (short_list_OF_Files[0] EQ '') THEN BEGIN
    ref_file_name = 'N/A'
ENDIF ELSE BEGIN
    ref_file_name = short_list_OF_files[0]
ENDELSE
putTextFieldValue, Event, $
  'reference_file_name_shifting', $
  ref_file_name

END

;------------------------------------------------------------------------------
PRO ActiveFileDroplist, Event ;_shifting
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get selected active file
index = getDropListSelectedIndex(Event,'active_file_droplist_shifting')
trans_coeff_list = (*(*global).trans_coeff_list)
sz = N_ELEMENTS(trans_coeff_list)
i = 0
WHILE (i LT sz) DO BEGIN
    IF (i EQ index) THEN BEGIN
        new_value = 1
    ENDIF ELSE BEGIN
        new_value = 0.1
    ENDELSE
    trans_coeff_list[i] = new_value
    ++i
ENDWHILE
(*(*global).trans_coeff_list) = trans_coeff_list
;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step3_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
ERASE
;display the value of the reference pixel for this file
ref_pixel_list  = (*(*global).ref_pixel_list)
ref_pixel_value = ref_pixel_list[index]
IF (ref_pixel_value EQ 0) THEN BEGIN    
    ref_pixel_value = 'N/A'
ENDIF
putTextFieldValue, Event, $
  'reference_pixel_value_shifting', $
  STRCOMPRESS(ref_pixel_value,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
PRO SavePlotReferencePixel, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
pixel_value = FIX(FLOAT(Event.y)/2.)
putTextFieldValue, Event, $
  'reference_pixel_value_shifting', $
  STRCOMPRESS(pixel_value,/REMOVE_ALL)
index          = getDropListSelectedIndex(Event, $
                                          'active_file_droplist_shifting')
ref_pixel_list        = (*(*global).ref_pixel_list)
ref_pixel_list[index] = pixel_value
(*(*global).ref_pixel_list) = ref_pixel_list
END
