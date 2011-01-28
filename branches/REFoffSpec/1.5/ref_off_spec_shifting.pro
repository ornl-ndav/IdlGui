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
            plots, xL, y, /DEVICE, $
               COLOR=color
            plots, xL-i*dx, y, /DEVICE,/CONTINUE,$
               COLOR=color
        ENDIF
        IF (xR LT x_max) THEN BEGIN
            plots, xR, y, /DEVICE, $
               COLOR=color
            new_xR = (xR+i*dx GE x_max) ? x_max : xR+i*dx
            plots, new_xR, y, /DEVICE,/CONTINUE, $
               COLOR=color
        ENDIF
        xL -= (i+1)*dx
        xR += (i+1)*dx
        ++i
    ENDWHILE
;plot vertical tick
    plots, x, y-dy, /DEVICE, $
        COLOR=color
        
    plots, x, y+dy, /DEVICE, /CONTINUE, $
        COLOR=color
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
PRO plotAsciiData_shifting, Event, RESET=reset
WIDGET_CONTROL, Event.top, GET_UVALUE=global

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Entering plotAsciiData_shifting'
ENDIF

;get number of files loaded
nbr_plot = getNbrFiles(Event)

tfpData             = (*(*global).realign_pData_y)
xData               = (*(*global).pData_x)
xaxis               = (*(*global).x_axis)
congrid_coeff_array = (*(*global).congrid_coeff_array)
xmax                = 0L
x_axis              = LONARR(nbr_plot)
y_coeff             = 2
x_coeff             = 1

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

;bLogPlot = isLogZaxisShiftingSelected(Event)
;IF (bLogPlot) THEN BEGIN
;    zmax = (*global).log_zmax
;    zmin = (*global).log_zmin
;ENDIF ELSE BEGIN
;    zmax = (*global).lin_zmax
;    zmin = (*global).lin_zmin
;ENDELSE

zmax  = (*global).zmax_g
zmin  = (*global).zmin_g

IF ((*global).debugging EQ 'yes') THEN BEGIN
    print, ' zmin: ' + STRCOMPRESS(zmin,/REMOVE_ALL)
    print, ' zmax: ' + STRCOMPRESS(zmax,/REMOVE_ALL)
ENDIF

WHILE (index LT nbr_plot) DO BEGIN
    
    local_tfpData = *tfpData[index]

;get only the central part of the data (when it's not the first one)
    IF (index NE 0) THEN BEGIN
;        local_tfpData = local_tfpData[*,304L:2*304L-1]
        local_tfpData = local_tfpData[*, (*global).detector_pixels_y:2* (*global).detector_pixels_y-1]        
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

;Applied attenuator coefficient 
    IF (bTransCoeff EQ 1) THEN BEGIN ;yes
        transparency_1 = trans_coeff_list[index]
    ENDIF ELSE BEGIN
        transparency_1 = 1.
    ENDELSE
    local_tfpData = local_tfpData * transparency_1
    
;array that will be used to display counts 
    local_tfpdata_untouched = local_tfpdata

;check if user wants linear or logarithmic plot
    bLogPlot = isLogZaxisShiftingSelected(Event)
    IF (bLogPlot) THEN BEGIN
        zero_index = WHERE(local_tfpdata EQ 0., nbr)
        IF (nbr GT 0) THEN BEGIN
            local_tfpdata[zero_index] = !VALUES.D_NAN
        ENDIF
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
;        IF (N_ELEMENTS(RESCALE) EQ 0) THEN BEGIN
;            local_min = transparency_1 * MIN(local_tfpData,/NAN)
;        ENDIF
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
        base_array_untouched = local_tfpData_untouched ;for counts
        size = (size(total_array,/DIMENSIONS))[0]
        max_size = (size GT max_size) ? size : max_size
;give master_min and master_max the values of local min and max 
        master_min = local_min
        master_max = local_max
    ENDIF
; ERROR OCCURED ON NEXT LINE ON 5MAY10. Index out of range on call to ARRAY_INDICES.
    ind1    = ARRAY_INDICES(local_tfpData,idx1)
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

;rebin by 2 in y-axis final array
rData = REBIN(base_array,(size(base_array))(1)*x_coeff, $
              (size(base_array))(2)*y_coeff,/SAMPLE)
(*(*global).total_array) = rData

rData_untouched = REBIN(base_array_untouched, $
                        (size(base_array))(1)*x_coeff, $
                        (size(base_array))(2)*y_coeff,/SAMPLE)
(*(*global).total_array_untouched) = rData_untouched

total_array = rData

DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
LOADCT,  color_table, /SILENT

(*global).zmax_g = master_max
(*global).zmin_g = master_min

;plot color scale
plotColorScale_shifting, Event, master_min, master_max ;_gui

;IF (bLogPlot) THEN BEGIN
;    (*global).log_zmin = master_min
;    (*global).log_zmax = master_max
;ENDIF ELSE BEGIN
;    (*global).lin_zmin = master_min
;    (*global).lin_zmax = master_max
;ENDELSE

putTextFieldValue, Event, 'step3_zmax', master_max, FORMAT='(e8.1)'
putTextFieldValue, Event, 'step3_zmin', master_min, FORMAT='(e8.1)'

;select plot
id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step3_draw')
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
    print, 'Leaving plotAsciiData_shifting'
    print
ENDIF

END

;------------------------------------------------------------------------------
PRO replotAsciiData_shifting, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

total_array = (*(*global).total_array)

DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
LOADCT, color_table, /SILENT

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

; Set color table to B&W linear so that background is neutral color for plot scale
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
(*(*global).short_list_OF_ascii_files) = short_list_OF_files
;print, "test: updateStep3FileNames: short list of files: ",short_list_OF_files
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
;IF (ref_pixel_value EQ 0) THEN BEGIN    
;    ref_pixel_value = 'N/A'
;ENDIF
putTextFieldValue, Event, $
  'reference_pixel_value_shifting', $
  STRCOMPRESS(ref_pixel_value,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
PRO SavePlotReferencePixel, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
; 9 Jan 2011: pixel_value is float variable 
;pixel_value = FIX(FLOAT(Event.y)/2.)
pixel_value = FLOAT(Event.y)/2.
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

;==========================================================================
; Change Code (9 Jan 2011): Add capability to alter RefPix in Shifting step
 RefPixSave = (*(*global).RefPixSave)
 PreviousRefPix = (*(*global).PreviousRefPix)
; DEBUG =====
; print, " RefPix: ", RefPixSave[index]
; print, " Previous RefPix: ", PreviousRefPix 
; DEBUG =====
 IF (index EQ 0) THEN BEGIN
; Change Code (RC Ward, 12 Jan 2011): treat reference RefPix differently
   RefPixSave[index] = pixel_value
   Delta =   RefPixSave[index] - PreviousRefPix[index]
 ENDIF ELSE BEGIN
   RefPixSave[index] = PreviousRefPix[index] + pixel_value - RefPixSave[0] 
 ENDELSE
; DEBUG =====
;  print, " new RefPix: ", RefPixSave[index]
; DEBUG =====
; update value of RefPix
  (*(*global).RefPixSave) = RefPixSave 
;==========================================================================


ref_x_list              = (*(*global).ref_x_list)
ref_x_list[index]       = x_value
(*(*global).ref_x_list) = ref_x_list

;==========================================================================
; Change Code (9 Jan 2011): Add capability to alter RefPix in Shifting step
    RefPix_file_name = (*global).input_file_name
; 9 Jan 2011 - clean up how RefPix file is named
; DEBUG ========================================
;    print, "Full RefPix filename: ", RefPix_file_name
    OPENW, 1, RefPix_file_name
    PRINTF, 1, RefPixSave
    CLOSE, 1
    FREE_LUN, 1
;==========================================================================
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
            text += "all the data sets have their original true intensity."
        ENDIF ELSE BEGIN        ;'yes'
            text += "the intensity of all the other file is attenuated " + $
              "by a configurable attenuator factor (see the OPTIONS tab). "
            coeff = getShiftingAttenuatorPercentage(Event)
            text += " -> This factor is currently set to " + $
              STRCOMPRESS(coeff,/REMOVE_ALL) + "%. "
        ENDELSE
    END
    'reference_pixel': BEGIN
        text = "This pixel, defined using left click or by entering its" + $
          " value in the text box next to the <Reference Pixel:> label, " + $
          "will be aligned with the Reference Pixel of the Reference File."
    END
    'pixel_down_up': BEGIN
        text = "These buttons are used to move down and up the reference" + $
          " pixel of the active file. Each click moves the reference by" + $ 
          " the number of pixels as defined in the <Move by ...> text field."
    END
    ELSE: text = ''
ENDCASE
putTextFieldValue, Event, 'help_text_field_shifting', text

END

;------------------------------------------------------------------------------
;this is reached by the automatic realign button
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

tfpData       = (*(*global).realign_pData_y)
tfpData_error = (*(*global).realign_pData_y_error)

; This line was commented out 
;local_tfpData = local_tfpData[*,304L:2*304L-1]
;local_tfpData = local_tfpData[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1]

;array of realign data
Nbr_array             = (size(tfpData))(1)
realign_tfpData       = PTRARR(Nbr_array,/ALLOCATE_HEAP)
realign_tfpData_error = PTRARR(Nbr_array,/ALLOCATE_HEAP)
;pixel_offset_array    = INTARR(Nbr_array)
; Change code (29 Dec 2010): Change pixel_offset_array to FLOAT from INT
pixel_offset_array    = FLTARR(Nbr_array)

;retrieve pixel offset
ref_pixel_list        = (*(*global).ref_pixel_list)
ref_pixel_offset_list = (*(*global).ref_pixel_offset_list)   

nbr = N_ELEMENTS(ref_pixel_list) 

IF (nbr GT 1) THEN BEGIN
;copy the first array
    realign_tfpData[0]       = tfpData[0]
    realign_tfpData_error[0] = tfpData_error[0]
    index = 1
    WHILE (index LT nbr) DO BEGIN
        pixel_offset = ref_pixel_list[0]-ref_pixel_list[index]
; DEBUG =====
;   print, "in shifting: ",index, " ",pixel_offset
; DEBUG =====
        pixel_offset_array[index] = pixel_offset ;save pixel_offset
;=================================================================
; I THINK THIS IS WRONG - IT DOUBLES THE VALUE OF PIXEL OFFSET
; NOT SURE WHY THIS IS THE WAY IT IS
;        ref_pixel_offset_list[index] += pixel_offset
; CHANGED TO
        ref_pixel_offset_list[index] = pixel_offset
;=================================================================        
        array        = *tfpData[index]
;        array        = array[*,304L:2*304L-1]
        array        = array[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1]       
        array_error  = *tfpData_error[index]
;        array_error  = array_error[*,304L:2*304L-1]
        array_error  = array_error[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1]        
        IF (pixel_offset EQ 0 OR $
            ref_pixel_list[index] EQ 0) THEN BEGIN ;if no offset
            realign_tfpData[index]       = tfpData[index]
            realign_tfpData_error[index] = tfpData_error[index]
        ENDIF ELSE BEGIN
            IF (pixel_offset GT 0) THEN BEGIN ;needs to move up
;move up each row by pixel_offset
;needs to start from the top when the offset is positive

;              FOR i=303,pixel_offset,-1 DO BEGIN
                FOR i=(*global).detector_pixels_y-1,pixel_offset,-1 DO BEGIN
                    array[*,i]       = array[*,i-pixel_offset]
                    array_error[*,i] = array_error[*,i-pixel_offset]
                ENDFOR
;bottom pixel_offset number of row are initialized to 0
                FOR j=0,pixel_offset DO BEGIN
                    array[*,j]       = 0
                    array_error[*,j] = 0
                ENDFOR
            ENDIF ELSE BEGIN    ;needs to move down
                pixel_offset = ABS(pixel_offset)
;               FOR i=0,(303-pixel_offset) DO BEGIN
                FOR i=0,((*global).detector_pixels_y-1-pixel_offset) DO BEGIN
                    array[*,i]       = array[*,i+pixel_offset]
                    array_error[*,i] = array_error[*,i+pixel_offset]
                ENDFOR
               FOR j=(*global).detector_pixels_y-1,(*global).detector_pixels_y-1-pixel_offset,-1 DO BEGIN                
;                FOR j=303,303-pixel_offset,-1 DO BEGIN
                    array[*,j]       = 0
                    array_error[*,j] = 0
                ENDFOR
            ENDELSE
        ENDELSE
        
        local_data       = array
        local_data_error = array_error
        dim2         = (size(local_data))(1)
;        big_array    = STRARR(dim2,3*304L)
;        big_array[*,304L:2*304L-1] = local_data
        big_array    = STRARR(dim2,3*(*global).detector_pixels_y)
        big_array[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1] = local_data        
        *realign_tfpData[index] = big_array

;        big_array_error    = STRARR(dim2,3*304L)
;        big_array_error[*,304L:2*304L-1] = local_data_error
        big_array_error    = STRARR(dim2,3*(*global).detector_pixels_y)
        big_array_error[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1] = local_data_error        
        *realign_tfpData_error[index] = big_array_error

;change reference pixel from old to new position
        ref_pixel_list[index] = ref_pixel_list[0]
        ++index
    ENDWHILE
ENDIF

(*(*global).pixel_offset_array)    = pixel_offset_array
(*(*global).ref_pixel_offset_list) = ref_pixel_offset_list
(*global).plot_realign_data        = 1
(*(*global).realign_pData_y)       = realign_tfpData
(*(*global).realign_pData_y_error) = realign_tfpData_error
(*(*global).ref_pixel_list)        = ref_pixel_list

;plot realign Data
plotAsciiData_shifting, Event
plotReferencedPixels, Event 
plot_selection_OF_2d_plot_mode, Event

;put new value of Reference Pixel for current active file
;get selected active file
index = getDropListSelectedIndex(Event,'active_file_droplist_shifting')
;display the value of the reference pixel for this file
ref_pixel_value = ref_pixel_list[index]

;;IF (ref_pixel_value EQ 0) THEN BEGIN    
;;    ref_pixel_value = 'N/A'
;;ENDIF
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

(*(*global).realign_pData_y)       = (*(*global).untouched_realign_pData_y)
(*(*global).realign_pData_y_error) = $
  (*(*global).untouched_realign_pData_y_error)

  PreviousRefPix = (*(*global).PreviousRefPix)
; DEBUG =====
;  print, " In cancel_realign_data: previous RefPix: ", PreviousRefPix
; DEBUG =====
;plot realign Data
plotAsciiData_shifting, Event

ref_pixel_list = (*(*global).ref_pixel_list_original)
(*(*global).ref_pixel_list) = ref_pixel_list
;put new value of Reference Pixel for current active file
;get selected active file
index = getDropListSelectedIndex(Event,'active_file_droplist_shifting')
;display the value of the reference pixel for this file
ref_pixel_value = ref_pixel_list[index]

;IF (ref_pixel_value EQ 0) THEN BEGIN    
;    ref_pixel_value = 'N/A'
;ENDIF
putTextFieldValue, Event, $
  'reference_pixel_value_shifting', $
  STRCOMPRESS(ref_pixel_value,/REMOVE_ALL)

;=====================================================================
; Change Code (15 Jan 2011, RC Ward): restore original RefPix values
   (*(*global).RefPixSave) = PreviousRefPix
   (*(*global).ref_pixel_list) = PreviousRefPix
    RefPixSave = (*(*global).RefPixSave)
; Define ref_pixel_list
   ref_pixel_list = (*(*global).ref_pixel_list)
; Define ref_pixel_offset_list
   ref_pixel_offset_list = (*(*global).ref_pixel_offset_list) 
;get number of files loaded
   nbr_plot = getNbrFiles(Event)
   FOR index = 0, nbr_plot-1 DO BEGIN
      ref_pixel_list[index] = RefPixSave[index]
      pixel_offset = RefPixSave[0] - RefPixSave[index]
      ref_pixel_offset_list[index] = pixel_offset
    ENDFOR
   (*(*global).ref_pixel_list) = ref_pixel_list
   (*(*global).ref_pixel_offset_list)= ref_pixel_offset_list
; DEBUG===============   
;  print, "CANCEL in Shifting: ref_pixel_list: ", ref_pixel_list
;  print, "CANCEL in Shifting: ref_pixel_offset_ ist: ", ref_pixel_offset_list
; DEBUG===============
; Change Code (9 Jan 2011): Write out previous values to RefPix file
    RefPix_file_name = (*global).input_file_name
; 9 Jan 2011 - clean up how RefPix file is named
; DEBUG ==============
;     print, "Full RefPix filename: ", RefPix_file_name
; DEBUG ==============
    OPENW, 1, RefPix_file_name
    PRINTF, 1, RefPixSave
    CLOSE, 1
    FREE_LUN, 1  
;=====================================================================
;   
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
tfpData               = (*(*global).realign_pData_y)
tfpData_error         = (*(*global).realign_pData_y_error)
ref_pixel_offset_list = (*(*global).ref_pixel_offset_list)
manual_ref_pixel      = ref_pixel_offset_list[index_to_work]

array = *tfpData[index_to_work]
;array = array[*,304L:2*304L-1]
array = array[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1]
array_error = *tfpData_error[index_to_work]
;array_error = array_error[*,304L:2*304L-1]
array_error = array_error[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1]
;pixel_step += manual_ref_pixel
;(*global).manual_ref_pixel = pixel_step

;pixel_offset
pixel_offset = pixel_step

;array of realign data
Nbr_array = (size(tfpData))(1)
realign_tfpData       = PTRARR(Nbr_array,/ALLOCATE_HEAP)
realign_tfpData_error = PTRARR(Nbr_array,/ALLOCATE_HEAP)

;retrieve pixel offset
ref_pixel_list = (*(*global).ref_pixel_list)
nbr = N_ELEMENTS(ref_pixel_list)
big_index = 0
WHILE (big_index LT nbr) DO BEGIN
    IF (big_index EQ index_to_work) THEN BEGIN
        IF (pixel_offset GT 0) THEN BEGIN ;needs to move down
;move up each row by pixel_offset
;needs to start from the top when the offset is positive
;          FOR i=303,pixel_offset,-1 DO BEGIN
; DEBUG =====
; print, "TEST TEST (*global).detector_pixels_y-1: ",(*global).detector_pixels_y-1
; DEBUG =====
           FOR i=(*global).detector_pixels_y-1,pixel_offset,-1 DO BEGIN
                array[*,i]       = array[*,i-pixel_offset]
                array_error[*,i] = array_error[*,i-pixel_offset]
            ENDFOR
;bottom pixel_offset number of row are initialized to 0
            FOR j=0,pixel_offset DO BEGIN
                array[*,j]       = 0
                array_error[*,j] = 0
            ENDFOR
        ENDIF ELSE BEGIN        ;needs to move up
            IF (pixel_offset LT 0) THEN BEGIN
                pixel_offset = ABS(pixel_offset)
;              FOR i=0,(303-pixel_offset) DO BEGIN
                FOR i=0,((*global).detector_pixels_y-1-pixel_offset) DO BEGIN
                    array[*,i]       = array[*,i+pixel_offset]
                    array_error[*,i] = array_error[*,i+pixel_offset]
                ENDFOR
;                FOR j=303L,303L-pixel_offset,-1 DO BEGIN
               FOR j=(*global).detector_pixels_y-1,(*global).detector_pixels_y-1-pixel_offset,-1 DO BEGIN
                    array[*,j]       = 0
                    array_error[*,j] = 0
                ENDFOR
            ENDIF
        ENDELSE

;put back new value in original array
        local_data       = array
        local_data_error = array_error
        dim2         = (size(local_data))(1)
;        big_array    = STRARR(dim2,3*304L)
;        big_array[*,304L:2*304L-1] = local_data
        big_array    = STRARR(dim2,3*(*global).detector_pixels_y)
        big_array[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1] = local_data
        *realign_tfpData[index_to_work] = big_array

;        big_array_error    = STRARR(dim2,3*304L)
;        big_array_error[*,304L:2*304L-1] = local_data_error
         big_array_error    = STRARR(dim2,3*(*global).detector_pixels_y)
         big_array_error[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1] = local_data_error
        *realign_tfpData_error[index_to_work] = big_array_error
        
    ENDIF ELSE BEGIN            ;end of 'if (i EQ index_work)'
        
        realign_tfpData[big_index]       = tfpData[big_index]
        realign_tfpData_error[big_index] = tfpData_error[big_index]
        
    ENDELSE
    ++big_index
ENDWHILE

(*(*global).realign_pData_y)         = realign_tfpData
(*(*global).realign_pData_y_error)   = realign_tfpData_error
ref_pixel_offset_list[index_to_work] = pixel_step
(*(*global).ref_pixel_offset_list)   = ref_pixel_offset_list

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

;------------------------------------------------------------------------------
PRO populate_step3_range_widgets, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

IF ((*global).debugging EQ 'yes') THEN BEGIN
    print, 'Entering populate_step3_range_widgets'
ENDIF

zmin_w    = getTextFieldValue(Event,'step3_zmin')
s_zmin_w  = STRCOMPRESS(zmin_w,/REMOVE_ALL)
as_zmin_w = STRING(s_zmin_w, FORMAT='(e8.1)')

zmin_g    = (*global).zmin_g
s_zmin_g  = STRCOMPRESS(zmin_g,/REMOVE_ALL)
as_zmin_g = STRING(s_zmin_g, FORMAT='(e8.1)')

IF (as_zmin_w NE as_zmin_g) THEN BEGIN
    print, ' New value of zmin_g is: ' + strcompress(zmin_w)
    (*global).zmin_g = DOUBLE(zmin_w)
ENDIF

;------------------------------------------------
zmax_w    = getTextFieldValue(Event,'step3_zmax')
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
    print, ' New value of zmax_g is: ' + strcompress(zmax_w)
    (*global).zmax_g = DOUBLE(zmax_w)
ENDIF

IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Leaving populate_step3_range_widgets'
    print
ENDIF

END

;------------------------------------------------------------------------------
PRO populate_step3_range_init, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

putTextFieldValue, Event, 'step3_zmax', (*global).zmax_g, FORMAT='(e8.1)'
putTextFieldValue, Event, 'step3_zmin', (*global).zmin_g, FORMAT='(e8.1)'

END











