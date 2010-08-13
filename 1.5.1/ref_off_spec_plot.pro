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

PRO  cleanup_array, local_tfpdata
  local_tfpdata = BYTSCL(local_tfpdata,/NAN)
END

;------------------------------------------------------------------------------
PRO plotBox, Event, x_coeff, y_coeff, xmin, xmax, COLOR=color
; Change Code: Add passing of global structure (containing detector_pixels_y) (RC Ward Feb 13, 2010)
; Had to also pass Event along the command call for call to plotBox.
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ymin = 0 * y_coeff
;  ymax = 303 * y_coeff
  ymax = ((*global).detector_pixels_y-1 )* y_coeff
  xmin = xmin * x_coeff
  xmax = xmax * x_coeff
  
  PLOTS, [xmin, xmin, xmax, xmax, xmin],$
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
PRO plotAsciiData, Event, TYPE=type, RESCALE=rescale
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
      IDLsendLogBook_addLogBookText, Event, 'ERROR LOADING FILES!'
      RETURN
    ENDIF
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    PRINT, 'Entering plotAsciiData'
  ENDIF
  
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
  x_axis              = LONARR(nbr_plot)
  y_coeff             = 2
  x_coeff             = 1
  
  ;check which array is the biggest (index)
  ;this array will be the base for the other array (xaxis will be based
  ;on this array
  max_coeff       = MAX(congrid_coeff_array)
  index_max_array = WHERE(congrid_coeff_array EQ max_coeff)
  
  IF (N_ELEMENTS(TYPE) EQ 0) THEN BEGIN ;from browse button
    trans_coeff_list = FLTARR(nbr_plot) + 1.
    (*(*global).trans_coeff_list) = trans_coeff_list
  ENDIF ELSE BEGIN ;when using 'replot'
    trans_coeff_list = (*(*global).trans_coeff_list)
  ENDELSE
  
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
    local_tfpData = DOUBLE(local_tfpData * transparency_1)
    
    IF (N_ELEMENTS(RESCALE) NE 0) THEN BEGIN
    
      Max  = (*global).zmax_g
      IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
        PRINT, ' max(local_tfpData): ' + STRCOMPRESS(MAX(local_tfpData))
        PRINT, ' Max               : ' + STRCOMPRESS(Max)
      ENDIF
      
      fMax = DOUBLE(Max)
      
      index_GT = WHERE(local_tfpData GT fMax, nbr)
      IF (nbr GT 0) THEN BEGIN
        local_tfpData[index_GT] = !VALUES.D_NAN
      ENDIF
      
      Min  = (*global).zmin_g
      fMin = DOUBLE(Min)
      index_LT = WHERE(local_tfpData LT fMin, nbr1)
      IF (nbr1 GT 0) THEN BEGIN
        tmp = local_tfpData
        tmp[index_LT] = !VALUeS.D_NAN
        local_min = MIN(tmp,/NAN)
        local_tfpData[index_LT] = DOUBLE(0)
      ENDIF ELSE BEGIN
        local_min = MIN(local_tfpData,/NAN)
      ENDELSE
    ENDIF ;enf of N_ELEMENTS(RESCALE)
    
    ;array that will be used to display counts
    local_tfpdata_untouched = local_tfpdata
    
    ;check if user wants linear or logarithmic plot
    bLogPlot = isLogZaxisSelected(Event)
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
    ENDIF ELSE BEGIN ;linear
      ;        zero_index = WHERE(local_tfpdata EQ 0, nbr)
      ;        IF (nbr GT 0) THEN BEGIN
      ;            local_tfpdata[zero_index] = !VALUES.D_NAN
      ;        ENDIF
      ;determine min and max value (for this array only)
      IF (N_ELEMENTS(RESCALE) EQ 0) THEN BEGIN
        local_min = transparency_1 * MIN(local_tfpData,/NAN)
      ENDIF
      
      local_max = transparency_1 * MAX(local_tfpData,/NAN)
      min_array[index] = local_min
      max_array[index] = local_max
      ;save position of max value (used for log book only)
      idx1 = WHERE(transparency_1*local_tfpData EQ local_max)
    ENDELSE
    
    IF (index EQ 0) THEN BEGIN
      ;array that will serve as the background
      base_array = local_tfpData
      base_array_untouched = local_tfpdata_untouched ;for counts
      
      size = (SIZE(total_array,/DIMENSIONS))[0]
      max_size = (size GT max_size) ? SIZE : max_size
      
      ;give master_min and master_max the values of local min and max
      master_min = local_min
      master_max = local_max
      
    ENDIF
    
    ind1    = ARRAY_INDICES(local_tfpData,idx1)
    delta_x = xaxis[1]-xaxis[0]
    xmax_array[index] = ind1[0]*delta_x
    ymax_array[index] = ind1[1]/2.
    
    ;store x-axis end value
    x_axis[index] = (SIZE(local_tfpData,/DIMENSION))[0]
    
    ;determine max and min value of y (over all the data arrays)
    master_min = (local_min LT master_min) ? local_min : master_min
    master_max = (local_max GT master_max) ? local_max : master_max
    
    IF (index NE 0) THEN BEGIN
      index_no_null = WHERE(local_tfpData NE 0,nbr)
      IF (nbr NE 0) THEN BEGIN
        index_indices = ARRAY_INDICES(local_tfpData,index_no_null)
        sz = (SIZE(index_indices,/DIMENSION))[1]
        ;loop through all the not null values and add them to the background
        ;array if their value is greater than the background one
        i = 0L
        WHILE(i LT sz) DO BEGIN
          x = index_indices[0,i]
          y = index_indices[1,i]
          value_new = local_tfpData(x,y)
          value_new_untouched = local_tfpData_untouched(x,y)
          value_old = base_array(x,y)
          value_old_untouched = base_array_untouched(x,y)
          IF (value_new GT value_old) THEN BEGIN
            base_array(x,y) = value_new
            base_array_untouched(x,y) = value_new_untouched
          ENDIF
          ++i
        ENDWHILE
      ENDIF
    ENDIF
    
    ++index
    
  ENDWHILE
  
  ;rebin by 2 in y-axis final array
  rData = REBIN(base_array,(SIZE(base_array))(1)*x_coeff, $
    (SIZE(base_array))(2)*y_coeff,/SAMPLE)
  rData_untouched = REBIN(base_array_untouched, $
    (SIZE(base_array))(1)*x_coeff, $
    (SIZE(base_array))(2)*y_coeff,/SAMPLE)
  (*(*global).total_array) = rData
  (*(*global).total_array_untouched) = rData_untouched
  total_array = rData
  
  ;put information in log book about min and max
  InformLogBook, Event, min_array, max_array, xmax_array, ymax_array ;_gui
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  ;IF (N_ELEMENTS(RESCALE) EQ 0) THEN BEGIN
  ;    (*global).zmin_g = master_min
  ;    (*global).zmax_g = master_max
  ;ENDIF
  
  ;plot color scale
  plotColorScale, Event, master_min, master_max
  
  IF ((*global).debugging EQ 'yes') THEN BEGIN
    PRINT, ' master_max: ' + STRCOMPRESS(master_max,/REMOVE_ALL)
    PRINT, ' master_min: ' + STRCOMPRESS(master_min,/REMOVE_ALL)
  ENDIF
  
  (*global).zmax_g = master_max
  (*global).zmin_g = master_min
  
  putTextFieldValue, Event, 'step2_zmax', master_max, FORMAT='(e8.1)'
  putTextFieldValue, Event, 'step2_zmin', master_min, FORMAT='(e8.1)'
  
  ;select plot
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  ;plot main plot
  TVSCL, total_array, /DEVICE
  
  i = 0
  box_color = (*global).box_color
  WHILE (i LT nbr_plot) DO BEGIN
    plotBox, Event, x_coeff, $
      y_coeff, $
      0, $
      x_axis[i], $
      COLOR=box_color[i]
    ++i
  ENDWHILE
  
  IF (N_ELEMENTS(TYPE) EQ 0) THEN BEGIN
    contour_plot, Event, xaxis
  ENDIF
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    PRINT, 'Leaving plotAsciiData'
    PRINT
  ENDIF
  
;  ENDELSE
  
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

;  PLOT, RANDOMN(s,303L), $   
  PLOT, RANDOMN(s,(*global).detector_pixels_y-1), $
    XRANGE        = xscale,$
;    YRANGE        = [0L,303L],$
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

;------------------------------------------------------------------------------
PRO populate_step2_range_widgets, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    PRINT, 'Entering populate_step2_range'
  ENDIF
  
  zmin_w    = getTextFieldValue(Event,'step2_zmin')
  s_zmin_w  = STRCOMPRESS(zmin_w,/REMOVE_ALL)
  as_zmin_w = STRING(s_zmin_w, FORMAT='(e8.1)')
  
  zmin_g    = (*global).zmin_g
  s_zmin_g  = STRCOMPRESS(zmin_g,/REMOVE_ALL)
  as_zmin_g = STRING(s_zmin_g, FORMAT='(e8.1)')
  
  IF (as_zmin_w NE as_zmin_g) THEN BEGIN
    (*global).zmin_g = DOUBLE(zmin_w)
  ENDIF
  
  ;------------------------------------------------
  zmax_w    = getTextFieldValue(Event,'step2_zmax')
  s_zmax_w  = STRCOMPRESS(zmax_w,/REMOVE_ALL)
  as_zmax_w = STRING(s_zmax_w, FORMAT='(e8.1)')
  
  zmax_g    = (*global).zmax_g
  
  s_zmax_g  = STRCOMPRESS(zmax_g,/REMOVE_ALL)
  as_zmax_g = STRING(s_zmax_g, FORMAT='(e8.1)')
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    PRINT, '  zmax_g    : ' + STRCOMPRESS(zmax_g)
    PRINT, '  as_zmax_w : ' + as_zmax_w
    PRINT, '  as_zmax_g : ' + as_zmax_g
  ENDIF
  
  IF (as_zmax_w NE as_zmax_g) THEN BEGIN
    (*global).zmax_g = DOUBLE(zmax_w)
  ENDIF
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    PRINT, 'Leaving populate_step2_range'
    PRINT
  ENDIF
  
END


