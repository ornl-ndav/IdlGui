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
;This procedure plots the scale that surround the plot
PRO refresh_plot_scale_scaling_step1, EVENT     = Event, $
                                      XSCALE    = xscale, $
                                      XTICKS    = xticks, $
                                      POSITION  = position

WIDGET_CONTROL, Event.top, GET_UVALUE=global
;change color of background    
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_draw_step4_step1')

; Set color table to B&W linear so that bacground is neutral color for plot scale
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

;plot, randomn(s,303L), $
plot, randomn(s,(*global).detector_pixels_y-1), $
  XRANGE        = xscale,$
;  YRANGE        = [0L,303L],$
  YRANGE        = [0L,(*global).detector_pixels_y-1],$
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
PRO contour_plot_scaling_step1, Event, xaxis
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;plot xaxis
sz     = N_ELEMENTS(xaxis)
xrange = [0,xaxis[sz-1]]
xticks = (sz/50)

;print, xrange
id    = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step1_draw')
sDraw = WIDGET_INFO(id,/GEOMETRY)
XYoff = [44,40]
xoff  = XYoff[0]+16

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

refresh_plot_scale_scaling_step1, $
  EVENT    = Event, $
  XSCALE   = xrange, $
  XTICKS   = xticks, $
  POSITION = position

END

;------------------------------------------------------------------------------
PRO plotColorScale_scaling_step1, Event, master_min, master_max
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_color_draw_step4_step1')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value
ERASE

IF (isLogZaxisScalingStep1Selected(Event)) THEN BEGIN
    divisions = 10
    perso_format = '(e8.1)'
    range  = FLOAT([master_min,master_max])
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.75,0.01,0.95,0.99], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      YLOG = 1,$
      /VERTICAL
ENDIF ELSE BEGIN
    divisions = 20
    perso_format = '(e8.1)'
    range = [master_min,master_max]
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.75,0.01,0.95,0.99], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      /VERTICAL
ENDELSE

END

;------------------------------------------------------------------------------
PRO plotAsciiData_scaling_step1, Event, RESET=reset
WIDGET_CONTROL, Event.top, GET_UVALUE=global

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Entering plotAsciiData_scaling'
ENDIF

;get number of files loaded
nbr_plot = getNbrFiles(Event)

tfpData = (*(*global).realign_pData_y)

xData               = (*(*global).pData_x)
xaxis               = (*(*global).x_axis)
congrid_coeff_array = (*(*global).congrid_coeff_array)
xmax                = 0L
x_axis              = LONARR(nbr_plot)
y_coeff             = 2
x_coeff             = 1

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

zmax = (*global).zmax_g
zmin = (*global).zmin_g

IF ((*global).debugging EQ 'yes') THEN BEGIN
    print, ' zmin: ' + STRCOMPRESS(zmin,/REMOVE_ALL)
    print, ' zmax: ' + STRCOMPRESS(zmax,/REMOVE_ALL)
ENDIF

WHILE (index LT nbr_plot) DO BEGIN
    
    local_tfpData = *tfpData[index]

;get only the central part of the data (when it's not the first one)
    IF (index NE 0) THEN BEGIN
;        local_tfpData = local_tfpData[*,304L:2*304L-1]
        local_tfpData = local_tfpData[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1]        
        
    ENDIF
    
    IF (N_ELEMENTS(RESET) EQ 0) THEN BEGIN

        fmax     = DOUBLE(zmax)
        index_GT = WHERE(local_tfpData GT fmax, nbr)
        IF (nbr GT 0) THEN BEGIN
            local_tfpData[index_GT] = !VALUES.D_NAN
        ENDIF
        
        fmin     = DOUBLE(zmin)
        index_LT = WHERE(local_tfpData LT fmin, nbr1)
        IF (nbr1 GT 0) THEN BEGIN
            tmp = local_tfpData
            tmp[index_LT] = !VALUES.D_NAN
            local_min = MIN(tmp,/NAN)
            local_tfpData[index_LT] = DOUBLE(0)
        ENDIF ELSE BEGIN
            local_min = MIN(local_tfpData,/NAN)
        ENDELSE
        
    ENDIF

    transparency_1 = 1.
    local_tfpData = local_tfpData * transparency_1
    
    local_tfpData_untouched = local_tfpData

;check if user wants linear or logarithmic plot
    bLogPlot = isLogZaxisScalingStep1Selected(Event)
    IF (bLogPlot) THEN BEGIN

        zero_index = WHERE(local_tfpdata EQ 0) 
        local_tfpdata[zero_index] = !VALUES.D_NAN

        local_min = transparency_1 * MIN(local_tfpData,/NAN)
        local_max = transparency_1 * MAX(local_tfpData,/NAN)
        min_array[index] = local_min
        max_array[index] = local_max
;save position of max value (used for log book only)
        idx1 = WHERE(transparency_1*local_tfpData EQ local_max)

        local_tfpData = ALOG10(local_tfpData)
        cleanup_array, local_tfpdata ;_plot

    ENDIF ELSE BEGIN

;determine min and max value (for this array only)
        local_min = transparency_1 * MIN(local_tfpData,/NAN)
        local_max = transparency_1 * MAX(local_tfpData,/NAN)
        min_array[index] = local_min
        max_array[index] = local_max
;save position of max value (used for log book only)
        idx1 = WHERE(transparency_1*local_tfpData EQ local_max)

    ENDELSE
    
    IF (index EQ 0) THEN BEGIN
;array that will serve as the background 
        base_array           = local_tfpData 
        base_array_untouched = local_tfpData_untouched
        size = (size(total_array,/DIMENSIONS))[0]
        max_size = (size GT max_size) ? size : max_size
;give master_min and master_max the values of local min and max 
        master_min = local_min
        master_max = local_max
    ENDIF
    
;save position of max value (used for log book only)
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
                value_new           = local_tfpData(x,y)
                value_new_untouched = local_tfpData_untouched(x,y)
                value_old           = base_array(x,y)
                value_old_untouched = base_array_untouched(x,y)
                IF (value_new GT value_old) THEN BEGIN
                    base_array(x,y)           = value_new
                    base_array_untouched(x,y) = value_new_untouched
                ENDIF
                ++i
            ENDWHILE
        ENDIF
    ENDIF
    
    ++index
    
ENDWHILE

(*(*global).x_axis_max_values) = x_axis

;rebin by 2 in y-axis final array
rData = REBIN(base_array,(size(base_array))(1)*x_coeff, $
              (size(base_array))(2)*y_coeff,/SAMPLE)
(*(*global).total_array) = rData
total_array = rData

rData_untouched = REBIN(base_array_untouched, $
                        (size(base_array))(1)*x_coeff, $
                        (size(base_array))(2)*y_coeff,/SAMPLE)
(*(*global).total_array_untouched) = rData_untouched

DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
LOADCT, color_table, /SILENT

(*global).zmax_g = master_max
(*global).zmin_g = master_min

;plot color scale
plotColorScale_scaling_step1, Event, master_min, master_max ;_gui

putTextFieldValue, Event, 'step4_zmax', master_max, FORMAT='(e8.1)'
putTextFieldValue, Event, 'step4_zmin', master_min, FORMAT='(e8.1)'

;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step1_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

;plot main plot
TVSCL, total_array, /DEVICE

i = 0
box_color = (*global).box_color
WHILE (i LT nbr_plot) DO BEGIN
; Change Code: pass Event on command line to call plotBox (RC Ward, Feb 15, 2010)
    plotBox, Event, x_coeff, $
      y_coeff, $
      0, $
      x_axis[i], $
      COLOR=box_color[i]
    ++i
ENDWHILE

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Leaving plotAsciiData_scaling'
    print
ENDIF


END

;------------------------------------------------------------------------------
;This procedure refreshes the plot
PRO refresh_step4_step1_plot, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;refresh scale plot
xaxis = (*(*global).x_axis)
contour_plot_scaling_step1, Event, xaxis

;refresh main plot
plotAsciiData_scaling_step1, Event

;refresh the selection
refresh_plotStep4Step1Selection, Event

END

;------------------------------------------------------------------------------
PRO replotAsciiData_scaling_step1, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

total_array = (*(*global).total_array)

DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
LOADCT, color_table, /SILENT

;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step1_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

;plot main plot
TVSCL, total_array, /DEVICE

y_coeff             = 2
x_coeff             = 1
x_axis = (*(*global).x_axis_max_values)

;get number of files loaded
nbr_plot = getNbrFiles(Event)

i = 0
box_color = (*global).box_color
WHILE (i LT nbr_plot) DO BEGIN
; Change Code: pass Event on command line to call plotBox (RC Ward, Feb 15, 2010)
    plotBox, Event, x_coeff, $
      y_coeff, $
      0, $
      x_axis[i], $
      COLOR=box_color[i]
    ++i
ENDWHILE

END

;------------------------------------------------------------------------------
;This procedure saves the left position (xmin and ymin) of the selection
PRO save_selection_left_position_step4_step1, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
xy_position    = (*global).step4_step1_selection
xy_position[0] = Event.x
xy_position[1] = Event.y
(*global).step4_step1_selection = xy_position
END

;------------------------------------------------------------------------------
PRO save_fix_corner, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
xy_position    = (*global).step4_step1_selection
xmin = MIN([xy_position[0],xy_position[2]],MAX=xmax)
ymin = MIN([xy_position[1],xy_position[3]],MAX=ymax)

IF ((*global).ResizeOrMove EQ 'resize') THEN BEGIN

    fix_corner = INTARR(2)
    corner_selected = (*global).corner_selected
    IF (corner_selected[0] EQ 1) THEN BEGIN
        fix_corner[0] = xmax
    ENDIF ELSE BEGIN
        fix_corner[0] = xmin
    ENDELSE

    IF (corner_selected[1] EQ 1) THEN BEGIN
        fix_corner[1] = ymax
    ENDIF ELSE BEGIN
        fix_corner[1] = ymin
    ENDELSE
    (*global).fix_corner = fix_corner
    
ENDIF
END

;------------------------------------------------------------------------------
PRO plotStep4Step1Selection, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
xy_position = (*global).step4_step1_selection

x=Event.x
y=Event.y
physical_x_y, Event, x, y ;this make sure that we are not outside the window

xy_position[2] = x
xy_position[3] = y

xmin = MIN([xy_position[0],xy_position[2]],MAX=xmax)
ymin = MIN([xy_position[1],xy_position[3]],MAX=ymax)

(*global).step4_step1_selection = xy_position
color = 200

plots, [xmin, xmin, xmax, xmax, xmin],$
  [ymin,ymax, ymax, ymin, ymin],$
  /DEVICE,$
  COLOR =color

END

;------------------------------------------------------------------------------
PRO refresh_plotStep4Step1Selection, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
xy_position = (*global).step4_step1_selection
xmin = xy_position[0]
ymin = xy_position[1]
xmax = xy_position[2]
ymax = xy_position[3]
IF (xmin + xmax NE 0) THEN BEGIN
    color = 200
    PLOTS, [xmin, xmin, xmax, xmax, xmin],$
      [ymin,ymax, ymax, ymin, ymin],$
      /DEVICE,$
      COLOR = color
ENDIF
END

;------------------------------------------------------------------------------
PRO move_step4_step1_selection, Event, DIRECTION=direction
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;refresh main plot
replotAsciiData_scaling_step1, Event
xy_position = (*global).step4_step1_selection
xmin = MIN([xy_position[0],xy_position[2]],MAX=xmax)
ymin = MIN([xy_position[1],xy_position[3]],MAX=ymax)

delta_x = xmax-xmin
delta_y = ymax-ymin

step = getTextFieldValue(Event,'step4_step1_move_selection_step_value')
;make sure xmin is GE 0, Xmax LT (size of base)
;same thing for ymin and ymax
id    = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step1_draw')
sDraw = WIDGET_INFO(id,/GEOMETRY)
xmax_plot = sDraw.xsize
ymax_plot = sDraw.ysize

CASE (direction) OF
    'left': BEGIN
        xmin -= step
        IF (xmin LT 0) THEN BEGIN 
           xmin = 0
           xmax = delta_x
       ENDIF ELSE BEGIN
           xmax -= step
       ENDELSE
    END
    'right': BEGIN
        xmax += step
        IF (xmax GT xmax_plot) THEN BEGIN
            xmax = xmax_plot        
            xmin = xmax - delta_x
        ENDIF ELSE BEGIN
            xmin += step
        ENDELSE
    END
    'up': BEGIN
        ymax += step        
        IF (ymax GT ymax_plot) THEN BEGIN
            ymax = ymax_plot
            ymin = ymax - delta_y
        ENDIF ELSE BEGIN
            ymin += step
        ENDELSE
    END
    'down': BEGIN
        ymin -= step
        IF (ymin LT 0) THEN BEGIN
            ymin = 0
            ymax = delta_y
        ENDIF ELSE BEGIN
            ymax -= step
        ENDELSE
    END
ENDCASE

;replot new selection
color = 200
PLOTS, [xmin, xmin, xmax, xmax, xmin],$
  [ymin,ymax, ymax, ymin, ymin],$
  /DEVICE,$
  COLOR = color

(*global).step4_step1_selection = [xmin,ymin,xmax,ymax]
END

;------------------------------------------------------------------------------
;This function checks if the left click is on a selection line (or
;close to it) or not. If it does, then we will enter the
;move_selection mode
FUNCTION check_IF_click_OR_move_situation, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
xy_position    = (*global).step4_step1_selection
pixel_range    = getStep4Step1SelectionPixelRange(Event)
current_x      = Event.x
current_y      = Event.y
;this make sure that we are not outside the window
physical_x_y, Event, current_x, current_y 

diffxmin = ABS(xy_position[0]-current_x)
diffxmax = ABS(xy_position[2]-current_x)
min_diffx = MIN([diffxmin,diffxmax])
IF (min_diffx LE pixel_range) THEN BEGIN
    save_position_to_move_selection, Event
    RETURN, 0
ENDIF

diffymin = ABS(xy_position[1]-current_y)
diffymax = ABS(xy_position[3]-current_y)
min_diffy = MIN([diffymin,diffymax])
IF (min_diffy LE pixel_range) THEN BEGIN
    save_position_to_move_selection, Event
    RETURN, 0
ENDIF

RETURN, 1
END

;------------------------------------------------------------------------------
FUNCTION check_IF_resize_OR_move_situation, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
xy_position = (*global).step4_step1_selection
x1 = xy_position[0]
y1 = xy_position[1]
x2 = xy_position[2]
y2 = xy_position[3]

pixel_range    = getStep4Step1SelectionPixelRange(Event)
current_x      = Event.x
current_y      = Event.y

;define new x/y min and max
xy_position = (*global).step4_step1_selection
xmin = MIN([xy_position[0],xy_position[2]], MAX=xmax)
ymin = MIN([xy_position[1],xy_position[3]], MAX=ymax)

IF (ABS(current_x - x1) LE pixel_range OR $
    ABS(current_x - x2) LE pixel_range) THEN BEGIN ;check for x values

    IF (ABS(current_y - y1) LE pixel_range OR $
        ABS(current_y - y2) LE pixel_range) THEN BEGIN

        corner_selected_xmin_ymin = [0,0]

        IF (ABS(current_x - xmin) LE pixel_range) THEN BEGIN
            corner_selected_xmin_ymin[0] = 1
        ENDIF ELSE BEGIN
            corner_selected_xmin_ymin[0] = 0
        ENDELSE
        
        IF (ABS(current_y - ymin) LE pixel_range) THEN BEGIN
            corner_selected_xmin_ymin[1] = 1
        ENDIF ELSE BEGIN
            corner_selected_xmin_ymin[1] = 0
        ENDELSE
        
        (*global).corner_selected = corner_selected_xmin_ymin
        RETURN, 'resize'
    ENDIF
ENDIF
RETURN, 'move'
END

;------------------------------------------------------------------------------
PRO save_position_to_move_selection, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
x = Event.x
y = Event.y
;this make sure that we are not outside the window
physical_x_y, Event, x, y
move_selection_position = [x, y]
(*global).step4_step1_move_selection_position = move_selection_position
display_x_y_min_max_step4_step1, Event, TYPE='move'
END

;------------------------------------------------------------------------------
;this is reached when user wants to move or resize selection
PRO move_selection_step4_step1, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;retrieve old position of x,y
move_selection_position = (*global).step4_step1_move_selection_position
old_x = move_selection_position[0]
old_y = move_selection_position[1]
;retrieve current position of x,y
current_x      = Event.x
current_y      = Event.y
;this make sure that we are not outside the window
physical_x_y, Event, current_x, current_y 

(*global).step4_step1_move_selection_position = [current_x,current_y]
;check differences
diff_x = current_x - old_x
diff_y = current_y - old_y
;define new x/y min and max
xy_position = (*global).step4_step1_selection
xmin = MIN([xy_position[0],xy_position[2]], MAX=xmax)
ymin = MIN([xy_position[1],xy_position[3]], MAX=ymax)

;type is the corner clicked (0:tof/left 1:top/right 2:bottom/right....)
ResizeOrMove = (*global).ResizeOrMove

IF (ResizeOrMove EQ 'move') THEN BEGIN
    
    new_xmin = xmin+diff_x
    new_ymin = ymin+diff_y
    new_xmax = xmax+diff_x
    new_ymax = ymax+diff_y

ENDIF ELSE BEGIN

    pixel_range     = getStep4Step1SelectionPixelRange(Event)
    fix_corner      = (*global).fix_corner
    corner_selected = (*global).corner_selected

    IF (corner_selected[0] EQ 1) THEN BEGIN ;xmin has been selected
        new_xmax = fix_corner[0]
        new_xmin = current_x
    ENDIF ELSE BEGIN            ;xmax has been selected
        new_xmin = fix_corner[0]
        new_xmax = current_x
    ENDELSE

    IF (corner_selected[1] EQ 1) THEN BEGIN ;ymin selected
        new_ymax = fix_corner[1]
        new_ymin = current_y
    ENDIF ELSE BEGIN ;ymax selected
        new_ymin = fix_corner[1]
        new_ymax = current_y
    ENDELSE

ENDELSE
    
;check if we have to move the selection (not if we are going to be
;outside the range)
total_array = (*(*global).total_array)
x_size = (size(total_array))(1)
y_size = (size(total_array))(2)
IF (new_xmax GE x_size) THEN new_xmax = x_size-1
IF (new_xmin LE 0) THEN new_xmin = 0
IF (new_ymax GE y_size) THEN new_ymax = y_size-1
IF (new_ymin LE 0) THEN new_ymin = 0

xy_position = [new_xmin, new_ymin, new_xmax, new_ymax]

(*global).step4_step1_selection = xy_position
END

;------------------------------------------------------------------------------
PRO display_x_y_min_max_step4_step1, Event, TYPE=type
WIDGET_CONTROL, Event.top, GET_UVALUE=global
IF (TYPE EQ 'left_click') THEN BEGIN
    selection_position = (*global).step4_step1_move_selection_position
    xmin = selection_position[0]
    ymin = selection_position[1]/2
    xmax = 'N/A'
    ymax = 'N/A'
ENDIF ELSE BEGIN
    xy_position = (*global).step4_step1_selection
    xmin = xy_position[0]
    ymin = xy_position[1]/2
    xmax = xy_position[2]
    ymax = xy_position[3]/2
    xmin = MIN([xmin,xmax],MAX=xmax)
    ymin = MIN([ymin,ymax],MAX=ymax)
; Change Code (RC Ward, 7 June 2010): Save the values of xmin, ymin, xmax, ymax for Step 5
    (*global).step5_selection_savefrom_step4 = [xmin, ymin, xmax, ymax]

; Change code (RC Ward, 8 July 2010): print in status box the shifts employed
;sxmin = STRING(xmin, FORMAT = '(I5)')
;symin = STRING(ymin, FORMAT = '(I5)')
;sxmax = STRING(xmax, FORMAT = '(I5)')
;symax = STRING(ymax, FORMAT = '(I5)')
;LogMessage = '> Step 4: Selection Window  xmin: ' + sxmin + '  xmax: ' + sxmax + '  ymin: ' + symin + '  symax: ' + symax
;IDLsendToGeek_addLogBookText, Event, LogMessage 
;print, LogMessage
;    print, ' in step 4 step 1: ', xmin, ymin, xmax, ymax

ENDELSE

sxmin = STRCOMPRESS(xmin,/REMOVE_ALL)
symin = STRCOMPRESS(ymin,/REMOVE_ALL)
sxmax = STRCOMPRESS(xmax,/REMOVE_ALL)
symax = STRCOMPRESS(ymax,/REMOVE_ALL)

putTextfieldValue, Event, 'selection_info_xmin_value', sxmin
putTextfieldValue, Event, 'selection_info_ymin_value', symin
putTextfieldValue, Event, 'selection_info_xmax_value', sxmax
putTextfieldValue, Event, 'selection_info_ymax_value', symax

END

;------------------------------------------------------------------------------
PRO physical_x_y, Event, x, y
WIDGET_CONTROL, Event.top, GET_UVALUE=global
total_array = (*(*global).total_array)
x_size = (size(total_array))(1)
y_size = (size(total_array))(2)

IF (x LE 0) THEN x=0
IF (x GE x_size) THEN x=x_size-1
IF (y LE 0) THEN y=0
IF (y GE y_size) THEN y=y_size-1

END

;------------------------------------------------------------------------------
;This procedure is reached each time the user hits enter in one of the
;four text field xmin, ymin, xmax and ymax
PRO move_selection_manually_step4_step1, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;work on Min values
xmin = FIX(getStep4Step1XminValue(Event))
ymin = FIX(getStep4Step1YminValue(Event))
ymin_to_test = 2*ymin

;this make sure that we are not outside the window
physical_x_y, Event, xmin, ymin_to_test
ymin = ymin_to_test / 2

;work on Max values
xmax = getStep4Step1XmaxValue(Event)
ymax = getStep4Step1YmaxValue(Event)
ymax_to_test = 2*ymax

;this make sure that we are not outside the window
physical_x_y, Event, xmax, ymax_to_test
ymax = ymax_to_test / 2

xmin = MIN([xmin,xmax],MAX=xmax)
ymin = MIN([ymin,ymax],MAX=ymax)

   (*global).step4_step1_selection = [xmin, ymin_to_test, xmax, ymax_to_test]
; Change Code (RC Ward, 7 June 2010): Save the values of xmin, ymin, xmax, ymax for Step 5
   (*global).step5_selection_savefrom_step4 = [xmin, ymin, xmax, ymax]

; Change code (RC Ward, 8 July 2010): print in status box the shifts employed
sxmin = STRING(xmin, FORMAT = '(I5)')
symin = STRING(ymin, FORMAT = '(I5)')
sxmax = STRING(xmax, FORMAT = '(I5)')
symax = STRING(ymax, FORMAT = '(I5)')
LogMessage = '> Step 4:    Selection Window  xmin: ' + sxmin + '  xmax: ' + sxmax + '  ymin: ' + symin + '  symax: ' + symax
IDLsendToGeek_addLogBookText, Event, LogMessage 
;print, LogMessage

;   print, ' in step 4 step 1: ', xmin, ymin, xmax, ymax

;refresh plot
replotAsciiData_scaling_step1, Event
;refresh selection plot
refresh_plotStep4Step1Selection, Event

;put back the right values of xmin, ymin, xmax and ymax
putXminStep4Step1Value, Event, xmin
putYminStep4Step1Value, Event, Ymin
putXmaxStep4Step1Value, Event, xmax
putYmaxStep4Step1Value, Event, Ymax

END

;------------------------------------------------------------------------------
PRO populate_step4_range_init, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

putTextFieldValue, Event, 'step4_zmax', (*global).zmax_g, FORMAT='(e8.1)'
putTextFieldValue, Event, 'step4_zmin', (*global).zmin_g, FORMAT='(e8.1)'

END

;------------------------------------------------------------------------------
PRO populate_step4_range_widgets, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

IF ((*global).debugging EQ 'yes') THEN BEGIN
    print, 'Entering populate_step4_range_widgets'
ENDIF

zmin_w    = getTextFieldValue(Event,'step4_zmin')
s_zmin_w  = STRCOMPRESS(zmin_w,/REMOVE_ALL)
as_zmin_w = STRING(s_zmin_w, FORMAT='(e8.1)')

zmin_g    = (*global).zmin_g
s_zmin_g  = STRCOMPRESS(zmin_g,/REMOVE_ALL)
as_zmin_g = STRING(s_zmin_g, FORMAT='(e8.1)')

IF (as_zmin_w NE as_zmin_g) THEN BEGIN
    (*global).zmin_g = DOUBLE(zmin_w)
ENDIF

;................................................
zmax_w    = getTextFieldValue(Event,'step4_zmax')
s_zmax_w  = STRCOMPRESS(zmax_w,/REMOVE_ALL)
as_zmax_w = STRING(s_zmax_w, FORMAT='(e8.1)')

zmax_g    = (*global).zmax_g

s_zmax_g  = STRCOMPRESS(zmax_g,/REMOVE_ALL)
as_zmax_g = STRING(s_zmax_g, FORMAT='(e8.1)')

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, '  zmax_g    : ' + strcompress(zmax_g)
    print, '  as_zmax_w : ' + as_zmax_w
    print, '  as_zmax_g : ' + as_zmax_g
ENDIF

IF (as_zmax_w NE as_zmax_g) THEN BEGIN
    (*global).zmax_g = DOUBLE(zmax_w)
ENDIF

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Leaving populate_step4_range_widgets'
    print
ENDIF

END

;------------------------------------------------------------------------------
PRO populate_step4_range_widgets, Event

WIDGET_CONTROL, Event.top, GET_UVALUE=global

IF ((*global).debugging EQ 'yes') THEN BEGIN
    print, 'Entering populate_step4_range_widgets'
ENDIF

zmin_w    = getTextFieldValue(Event,'step4_zmin')
s_zmin_w  = STRCOMPRESS(zmin_w,/REMOVE_ALL)
as_zmin_w = STRING(s_zmin_w, FORMAT='(e8.1)')

zmin_g    = (*global).zmin_g
s_zmin_g  = STRCOMPRESS(zmin_g,/REMOVE_ALL)
as_zmin_g = STRING(s_zmin_g, FORMAT='(e8.1)')

IF (as_zmin_w NE as_zmin_g) THEN BEGIN
    (*global).zmin_g = DOUBLE(zmin_w)
ENDIF

;------------------------------------------------
zmax_w    = getTextFieldValue(Event,'step4_zmax')
s_zmax_w  = STRCOMPRESS(zmax_w,/REMOVE_ALL)
as_zmax_w = STRING(s_zmax_w, FORMAT='(e8.1)')

zmax_g    = (*global).zmax_g

s_zmax_g  = STRCOMPRESS(zmax_g,/REMOVE_ALL)
as_zmax_g = STRING(s_zmax_g, FORMAT='(e8.1)')

IF (as_zmax_w NE as_zmax_g) THEN BEGIN
    (*global).zmax_g = DOUBLE(zmax_w)
ENDIF

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, '  zmax_g    : ' + strcompress(zmax_g)
    print, '  as_zmax_w : ' + as_zmax_w
    print, '  as_zmax_g : ' + as_zmax_g
ENDIF

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Leaving populate_step4_range_widgets'
    print
ENDIF

END

;------------------------------------------------------------------------------
; This code is in here twice - this section commented out on 28 Dec 2010
;PRO populate_step4_range_init, Event
;WIDGET_CONTROL, Event.top, GET_UVALUE=global

;putTextFieldValue, Event, 'step4_zmax', (*global).zmax_g, FORMAT='(e8.1)'
;putTextFieldValue, Event, 'step4_zmin', (*global).zmin_g, FORMAT='(e8.1)'

;END
