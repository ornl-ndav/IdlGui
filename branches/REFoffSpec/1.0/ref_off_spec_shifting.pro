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

PRO plotLine, Event, pixel_value, x_value, color
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get xmin and xmax (to cover full plot)
;get xmax
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step3_draw')
sDraw = WIDGET_INFO(id,/GEOMETRY)
xmax_plot = sDraw.xsize
x_axis = (*(*global).x_axis)
sz = N_ELEMENTS(x_axis)
x_max = (xmax_plot LT sz) ? xmax_plot : sz
;get xmin
x_min = 0.
NbrTicks = 40.
delta_x = (FLOAT(x_max) - FLOAT(x_min)) / NbrTicks
x_from = 0
x_to   = delta_x

IF (is_YandX_RefPixelSelected(Event) EQ 0) THEN BEGIN
;this way, only y is displayed (- - - - - - - - -)
    WHILE (x_to LE x_max) DO BEGIN
        plots, x_from, pixel_value * 2, $
          /DEVICE, $
          COLOR=color
        plots, x_to, pixel_value * 2, $
          /DEVICE, $
          COLOR=color, $
          /CONTINUE
        x_from = x_to + delta_x
        x_to   = x_from + delta_x
    ENDWHILE

ENDIF ELSE BEGIN
;this way, x and y are displayed (--- -- -|- -- ---)
    dx    = 5 ;length of each '-'
    dy    = 10 ;vertical length of central tick '|'
    i     = 1  ;1 tick, then 2, then 3 ....
    x     = x_value
    y     = 2*pixel_value
    xL    = x ;right coordinate of Left ticks
    xR    = x ;left  coordinate of Right ticks
    WHILE (xL GT 0 OR $
           xR LT x_max) DO BEGIN
        IF (xL GT 0) THEN BEGIN
            plots, xL, y, /DEVICE, COLOR=color
            plots, xL-i*dx, y, /DEVICE,/CONTINUE,COLOR=color
        ENDIF
        IF (xR LT x_max) THEN BEGIN
            plots, xR, y, /DEVICE, COLOR=color
            new_xR = (xR+i*dx GE x_max) ? x_max : xR+i*dx
            plots, new_xR, y, /DEVICE,/CONTINUE,COLOR=color
        ENDIF
        xL -= (i+1)*dx
        xR += (i+1)*dx
        ++i
    ENDWHILE
;plot vertical tick
    plots, x, y-dy, /DEVICE, COLOR=color
    plots, x, y+dy, /DEVICE, /CONTINUE, COLOR=color

ENDELSE

END


;------------------------------------------------------------------------------
;This function plots a line for each of the pixel referenced
PRO plotReferencedPixels, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
ref_pixel_list  = (*(*global).ref_pixel_list)
ref_x_list      = (*(*global).ref_x_list)
box_color       = (*global).box_color
sz = N_ELEMENTS(ref_pixel_list)
i   = 0
WHILE (i LT sz) DO BEGIN
    pixel_value = ref_pixel_list[i]
    x_value     = ref_x_list[i]
    IF (pixel_value NE 0) THEN BEGIN
        plotLine, Event, pixel_value, x_value, box_color[i]
    ENDIF
    ++i
ENDWHILE
;add tool at the beginning of line to show which one is the active one
index = getDropListSelectedIndex(Event, $
                                 'active_file_droplist_shifting')
XYOUTS, 5, 2*ref_pixel_list[index], $ ;x,y
  'ACTIVE',$
  COLOR=box_color[index],$
  /DEVICE
END

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

tfpData = (*(*global).realign_pData_y)

;retrieve data
; IF (N_ELEMENTS(ARRAY) EQ 0) THEN BEGIN
;     IF ((*global).plot_realign_data EQ 1) THEN BEGIN
;         tfpData = (*(*global).realign_pData_y)
;     ENDIF ELSE BEGIN
;         tfpData = (*(*global).pData_y)
;     ENDELSE
; ENDIF ELSE BEGIN
;     tfpData = array
; ENDELSE

xData               = (*(*global).pData_x)
xaxis               = (*(*global).x_axis)
congrid_coeff_array = (*(*global).congrid_coeff_array)
xmax                = 0L
x_axis              = LONARR(nbr_plot)
y_coeff = 2
x_coeff = 1

;applied or not transparency coeff ;0:no, 1:yes
bTransCoeff = isWithAttenuatorCoeff(Event)

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

;get only the central part of the data (when it's not the first one)
    IF (index NE 0) THEN BEGIN
        local_tfpData = local_tfpData[*,304L:2*304L-1]
    ENDIF
    
;Applied attenuator coefficient 
    IF (bTransCoeff EQ 1) THEN BEGIN ;yes
        transparency_1 = trans_coeff_list[index]
    ENDIF ELSE BEGIN
        transparency_1 = 1.
    ENDELSE
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
PRO replotAsciiData_shifting, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

total_array = (*(*global).total_array)

DEVICE, DECOMPOSED=0
LOADCT, 5, /SILENT

;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step3_draw')
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

;plot main plot
TVSCL, total_array, /DEVICE

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
putTextfieldValue, Event, $
  'manual_mode_file_value_shifting',$
  ref_file_name
END

;------------------------------------------------------------------------------
PRO ActiveFileDroplist, Event ;_shifting
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get selected active file
index = getDropListSelectedIndex(Event,'active_file_droplist_shifting')
;get name of file selected
file_name =  getDropListSelectedValue(Event, 'active_file_droplist_shifting')
;put file name in Manual Mode
putTextFieldValue, Event,'manual_mode_file_value_shifting', file_name

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
x_value     = Event.x
putTextFieldValue, Event, $
  'reference_pixel_value_shifting', $
  STRCOMPRESS(pixel_value,/REMOVE_ALL)
index = getDropListSelectedIndex(Event, $
                                 'active_file_droplist_shifting')
ref_pixel_list        = (*(*global).ref_pixel_list)
ref_pixel_list[index] = pixel_value
(*(*global).ref_pixel_list) = ref_pixel_list
(*(*global).ref_pixel_list_original) = ref_pixel_list

ref_x_list              = (*(*global).ref_x_list)
ref_x_list[index]       = x_value
(*(*global).ref_x_list) = ref_x_list

END

;------------------------------------------------------------------------------
;This procedure displays the Help message at the bottom left of the
;shifting tab
PRO display_shifting_help, Event, type
CASE (type) OF
    'reference_file': BEGIN
        text = "This file is used as the Reference file. It's usually the " + $
          "first file loaded, the file with the wider wavelength range. " + $
          "This file can not be shifted."
    END
    'active_file': BEGIN
        text = "The active file is the current file selected. According to" + $
          " the settings of the USE NON-ACTIVE FILE ATTENUATOR switch" + $
          " in the OPTIONS tab, "
        index = getCWBgroupValue(Event, $
                                 'transparency_attenuator_' + $
                                 'shifting_options')
        IF (index EQ 0) THEN BEGIN ;'no'
            text += " all the data set have their original true intensity"
        ENDIF ELSE BEGIN        ;'yes'
            text += "the intensity of all the other file is attenuated " + $
              "by a configurable attenuator factor (see the tab OPTIONS). "
            coeff = getShiftingAttenuatorPercentage(Event)
            text += " -> This factor is currently set to " + $
              STRCOMPRESS(coeff,/REMOVE_ALL) + "%. "
        ENDELSE
    END
    'reference_pixel': BEGIN
        text = "This pixel, defined using left click or by entering its" + $
          " value in the text box next to the <Reference Pixel:> label " + $
          "will be align with the Reference Pixel of the Reference File."
    END
    'pixel_down_up': BEGIN
        text = "This buttons are used to move down and up the reference" + $
          " pixel of the active file. Each click moves the pixel by" + $
          " the number of pixels defined in the text field next to" + $
          " the <Move by ...> label."
    END
    ELSE: text = ''
ENDCASE
putTextFieldValue, Event, 'help_text_field_shifting', text

END

;------------------------------------------------------------------------------
;this is reach by the automatic realign button
PRO realign_data, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
;retrieve arrays
; IF ((*global).first_realign) THEN BEGIN
;     tfpData = (*(*global).pData_y)
;     (*global).first_realign = 0
; ENDIF ELSE BEGIN
;     tfpData = (*(*global).realign_pData_y)
; ENDELSE

tfpData = (*(*global).realign_pData_y)
;local_tfpData = local_tfpData[*,304L:2*304L-1]

;array of realign data
Nbr_array = (size(tfpData))(1)
realign_tfpData = PTRARR(Nbr_array,/ALLOCATE_HEAP)

;retrieve pixel offset
ref_pixel_list = (*(*global).ref_pixel_list)
ref_pixel_offset_list = (*(*global).ref_pixel_offset_list)

nbr = N_ELEMENTS(ref_pixel_list)
IF (nbr GT 1) THEN BEGIN
;copy the first array
    realign_tfpData[0] = tfpData[0]
    index = 1
    WHILE (index LT nbr) DO BEGIN
        pixel_offset = ref_pixel_list[0]-ref_pixel_list[index]
        ref_pixel_offset_list[index] += pixel_offset
        array        = *tfpData[index]
        array        = array[*,304L:2*304L-1]
        IF (pixel_offset EQ 0 OR $
            ref_pixel_list[index] EQ 0) THEN BEGIN ;if no offset
            realign_tfpData[index] = tfpData[index]
        ENDIF ELSE BEGIN
            IF (pixel_offset GT 0) THEN BEGIN ;needs to move up
;move up each row by pixel_offset
;needs to start from the top when the offset is positive
                FOR i=303,pixel_offset,-1 DO BEGIN
                    array[*,i] = array[*,i-pixel_offset]
                ENDFOR
;bottom pixel_offset number of row are initialized to 0
                FOR j=0,pixel_offset DO BEGIN
                    array[*,j] = 0
                ENDFOR
            ENDIF ELSE BEGIN    ;needs to move down
                pixel_offset = ABS(pixel_offset)
                FOR i=0,(303-pixel_offset) DO BEGIN
                    array[*,i] = array[*,i+pixel_offset]
                ENDFOR
                FOR j=303,303-pixel_offset,-1 DO BEGIN
                    array[*,j] = 0
                ENDFOR
            ENDELSE
        ENDELSE
        
        local_data   = array
        dim2         = (size(local_data))(1)
        big_array    = STRARR(dim2,3*304L)
        big_array[*,304L:2*304L-1] = local_data
        *realign_tfpData[index] = big_array
;change reference pixel from old to neatew position
        ref_pixel_list[index] = ref_pixel_list[0]
        ++index
    ENDWHILE
ENDIF

(*(*global).ref_pixel_offset_list) = ref_pixel_offset_list
(*global).plot_realign_data  = 1
(*(*global).realign_pData_y) = realign_tfpData
(*(*global).ref_pixel_list)  = ref_pixel_list

;plot realign Data
plotAsciiData_shifting, Event
plotReferencedPixels, Event 
plot_selection_OF_2d_plot_mode, Event

;put new value of Reference Pixel for current active file
;get selected active file
index = getDropListSelectedIndex(Event,'active_file_droplist_shifting')
;display the value of the reference pixel for this file
ref_pixel_value = ref_pixel_list[index]
IF (ref_pixel_value EQ 0) THEN BEGIN    
    ref_pixel_value = 'N/A'
ENDIF
putTextFieldValue, Event, $
  'reference_pixel_value_shifting', $
  STRCOMPRESS(ref_pixel_value,/REMOVE_ALL)

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
PRO cancel_realign_data, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
(*global).plot_realign_data = 0

(*(*global).realign_pData_y) = (*(*global).untouched_realign_pData_y)

;plot realign Data
plotAsciiData_shifting, Event

ref_pixel_list = (*(*global).ref_pixel_list_original)
(*(*global).ref_pixel_list) = ref_pixel_list
;put new value of Reference Pixel for current active file
;get selected active file
index = getDropListSelectedIndex(Event,'active_file_droplist_shifting')
;display the value of the reference pixel for this file
ref_pixel_value = ref_pixel_list[index]
IF (ref_pixel_value EQ 0) THEN BEGIN    
    ref_pixel_value = 'N/A'
ENDIF
putTextFieldValue, Event, $
  'reference_pixel_value_shifting', $
  STRCOMPRESS(ref_pixel_value,/REMOVE_ALL)

;replot reference pixels
plotReferencedPixels, Event 
plot_selection_OF_2d_plot_mode, Event

;reset realign data boolean
(*global).first_realign = 1

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
PRO manual_move_mode_shifting, Event, DIRECTION=direction
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

;get selected active file
index = getDropListSelectedIndex(Event,'active_file_droplist_shifting')

;get the increment value selected by user
pixel_step = getTextFieldValue(Event, $
                               'move_by_x_pixel_value_manual_shifting')

;determine the new value of the reference pixel
IF (DIRECTION EQ 'up') THEN BEGIN
    pixel_step = ABS(pixel_step) ;<0 means that data will have to move up
ENDIF ELSE BEGIN
    pixel_step = -ABS(pixel_step)  ;>0 means that data will have to move down
ENDELSE

(*global).plot_realign_data = 1

;run realign process
manual_realign_data, Event, pixel_step, index

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO manual_realign_data, Event, pixel_step, index_to_work
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;;retrieve data
; IF ((*global).plot_realign_data EQ 1) THEN BEGIN
;     tfpData = (*(*global).pData_y)
;     ref_pixel_offset_list = (*(*global).ref_pixel_offset_list)
;     manual_ref_pixel = ref_pixel_offset_list[index_to_work]
; ENDIF ELSE BEGIN
;     tfpData = (*(*global).pData_y)
;     manual_ref_pixel = (*global).manual_ref_pixel
; ENDELSE

;data of active file
tfpData = (*(*global).realign_pData_y)
ref_pixel_offset_list = (*(*global).ref_pixel_offset_list)
manual_ref_pixel = ref_pixel_offset_list[index_to_work]

array = *tfpData[index_to_work]
array = array[*,304L:2*304L-1]

;pixel_step += manual_ref_pixel
;(*global).manual_ref_pixel = pixel_step

;pixel_offset
pixel_offset = pixel_step

;array of realign data
Nbr_array = (size(tfpData))(1)
realign_tfpData = PTRARR(Nbr_array,/ALLOCATE_HEAP)

;retrieve pixel offset
ref_pixel_list = (*(*global).ref_pixel_list)
nbr = N_ELEMENTS(ref_pixel_list)
big_index = 0
WHILE (big_index LT nbr) DO BEGIN
    IF (big_index EQ index_to_work) THEN BEGIN
        IF (pixel_offset GT 0) THEN BEGIN ;needs to move down
;move up each row by pixel_offset
;needs to start from the top when the offset is positive
            FOR i=303,pixel_offset,-1 DO BEGIN
                array[*,i] = array[*,i-pixel_offset]
            ENDFOR
;bottom pixel_offset number of row are initialized to 0
            FOR j=0,pixel_offset DO BEGIN
                array[*,j] = 0
            ENDFOR
        ENDIF ELSE BEGIN        ;needs to move up
            IF (pixel_offset LT 0) THEN BEGIN
                pixel_offset = ABS(pixel_offset)
                FOR i=0,(303-pixel_offset) DO BEGIN
                    array[*,i] = array[*,i+pixel_offset]
                ENDFOR
                FOR j=303,303-pixel_offset,-1 DO BEGIN
                    array[*,j] = 0
                ENDFOR
            ENDIF
        ENDELSE

;put back new value in original array
        local_data   = array
        dim2         = (size(local_data))(1)
        big_array    = STRARR(dim2,3*304L)
        big_array[*,304L:2*304L-1] = local_data
        *realign_tfpData[index_to_work] = big_array
        
    ENDIF ELSE BEGIN            ;end of 'if (i EQ index_work)'
        
        realign_tfpData[big_index] = tfpData[big_index]
        
    ENDELSE
    ++big_index
ENDWHILE

(*(*global).realign_pData_y) = realign_tfpData
ref_pixel_offset_list[index_to_work] = pixel_step
(*(*global).ref_pixel_offset_list) = ref_pixel_offset_list

;plot realign Data
plotAsciiData_shifting, Event
plotReferencedPixels, Event 
plot_selection_OF_2d_plot_mode, Event

END

;------------------------------------------------------------------------------
PRO move_to_next_active_file, Event ;_shifting

list_OF_files  = getDroplistValue(Event,$
                                  'active_file_droplist_shifting')
index_selected = getDropListSelectedIndex(Event,$
                                          'active_file_droplist_shifting')
sz = N_ELEMENTS(list_OF_files)
IF (index_selected NE sz-1) THEN BEGIN ;move-up to next active file and replot
    selectDroplistIndex, Event, $
      'active_file_droplist_shifting', $
      index_selected+1
    WIDGET_CONTROL,/HOURGLASS
    ActiveFileDroplist, Event   ;_shifting
    plotAsciiData_shifting, Event ;_shifting
    plotReferencedPixels, Event ;_shifting
    CheckShiftingGui, Event
    refresh_plot_selection_OF_2d_plot_mode, Event 
    WIDGET_CONTROL,HOURGLASS=0
ENDIF

END

















