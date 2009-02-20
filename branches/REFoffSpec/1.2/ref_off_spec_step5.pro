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
;PRO refresh_recap_plot, Event, RESCALE=rescale
;  ;get global structure
;  WIDGET_CONTROL, Event.top, GET_UVALUE=global
;
;  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
;    print, 'Entering refresh_recap_plot'
;  ENDIF
;
;  nbr_plot    = getNbrFiles(Event) ;number of files
;
;  scaling_factor_array = (*(*global).scaling_factor)
;  tfpData              = (*(*global).realign_pData_y)
;  tfpData_error        = (*(*global).realign_pData_y_error)
;  xData                = (*(*global).pData_x)
;  xaxis                = (*(*global).x_axis)
;  congrid_coeff_array  = (*(*global).congrid_coeff_array)
;  xmax                 = 0L
;  x_axis               = LONARR(nbr_plot)
;  y_coeff              = 2
;  x_coeff              = 1
;
;  ;check which array is the biggest (index)
;  ;this array will be the base for the other array (xaxis will be based
;  ;on this array
;  max_coeff       = MAX(congrid_coeff_array)
;  index_max_array = WHERE(congrid_coeff_array EQ max_coeff)
;
;  trans_coeff_list = (*(*global).trans_coeff_list)
;
;  max_thresold = FLOAT(-100)
;  master_min   = 0
;  master_max   = 0.
;  min_array    = FLTARR(nbr_plot)
;  max_array    = FLTARR(nbr_plot)
;  xmax_array   = FLTARR(nbr_plot)   ;x of max value per array
;  ymax_array   = FLTARR(nbr_plot)   ;y of max value per array
;  max_size     = 0                ;maximum x value
;  index        = 0                ;loop variable (nbr of array to add/plot
;
;  WHILE (index LT nbr_plot) DO BEGIN
;
;    print, 'entering while loop' ;remove_me
;
;    local_tfpData       = *tfpData[index]
;    local_tfpData_error = *tfpData_error[index]
;    scaling_factor      = scaling_factor_array[index]
;
;    ;get only the central part of the data (when it's not the first one)
;    IF (index NE 0) THEN BEGIN
;      local_tfpData      = FLOAT(local_tfpData[*,304L:2*304L-1])
;      local_tfpData_eror = FLOAT(local_tfpData_error[*,304L:2*304L-1])
;    ENDIF
;
;    ;applied scaling factor
;    local_tfpData       /= scaling_factor
;    local_tfpData_error /= scaling_factor
;
;    IF (N_ELEMENTS(RESCALE) NE 0) THEN BEGIN
;
;      Max  = (*global).zmax_g_recap
;      fMax = DOUBLE(Max)
;      ;      fMax = -1e15
;      ;      print, 'fMax: ' + strcompress(fMax) ;remove_me
;
;      index_GT = WHERE(local_tfpData GT fMax, nbr)
;      IF (nbr GT 0) THEN BEGIN
;        local_tfpData[index_GT]       = !VALUES.D_NAN
;        local_tfpData_error[index_GT] = !VALUES.D_NAN
;      ENDIF
;
;      Min  = (*global).zmin_g_recap
;      fMin = DOUBLE(Min)
;      index_LT = WHERE(local_tfpData LT fMin, nbr1)
;      IF (nbr1 GT 0) THEN BEGIN
;        tmp = local_tfpData
;        tmp[index_LT] = !VALUeS.D_NAN
;        local_min = MIN(tmp,/NAN)
;        local_tfpData[index_LT] = DOUBLE(0)
;        local_tfpData_error[index_LT] = DOUBLE(0)
;      ENDIF ELSE BEGIN
;        local_min = MIN(local_tfpData,/NAN)
;      ENDELSE
;    ENDIF ;end of N_ELEMENTS(RESCALE)
;
;    ;array that will be used to display counts
;    local_tfpdata_untouched = local_tfpdata
;
;    ;check if user wants linear or logarithmic plot
;    bLogPlot = isLogZaxisStep5Selected(Event)
;    IF (bLogPlot) THEN BEGIN
;
;      zero_index = WHERE(local_tfpData EQ 0)
;      help, zero_index ;remove_me
;      local_tfpdata[zero_index] = !VALUES.F_NAN
;
;      local_min = MIN(local_tfpData,/NAN)
;      local_max = MAX(local_tfpData,/NAN)
;      min_array[index] = local_min
;      max_array[index] = local_max
;
;      local_tfpData = ALOG10(local_tfpData)
;
;    ;      print, 'before cleanup data'
;    ;      help, local_tfpData
;    ;      print, local_tfpData[100:250,300] ;remove_me
;    ;
;    ;      cleanup_array, local_tfpDAta ;_plot
;    ;      print, 'after cleanup data'
;    ;      help, local_tfpData
;    ;      print, local_tfpData[100:250,300] ;remove_me
;
;    ENDIF ELSE BEGIN
;
;      local_min = MIN(local_tfpData,/NAN)
;      local_max = MAX(local_tfpData,/NAN)
;      min_array[index] = local_min
;      max_array[index] = local_max
;
;    ENDELSE
;
;    ;    if (index eq 0) THEN begin
;    ;      window,0, title='index 0'
;    ;    endif else begin
;    ;      window,1, title='index 1'
;    ;    endelse
;    ;    print, 'index: ' + strcompress(index)
;    ;    help, local_tfpdata
;    ;    ;cleanup_array, local_tfpdata
;    ;    tvscl, local_tfpdata,/device
;    ;    print
;    ;
;
;    IF (index EQ 0) THEN BEGIN
;      ;array that will serve as the background
;      base_array           = local_tfpData
;      base_array_error     = local_tfpData_error
;      base_array_untouched = local_tfpData_untouched
;      ;size       = (size(total_array,/DIMENSIONS))[0]
;      ;max_size   = (size GT max_size) ? size : max_size
;      ;give master_min and master_max the values of local min and max
;      master_min = local_min
;      master_max = local_max
;    ENDIF
;
;    ;store x-axis end value
;    x_axis[index] = (size(local_tfpData,/DIMENSION))[0]
;
;    ;determine max and min value of y (over all the data arrays)
;    master_min = (local_min LT master_min) ? local_min : master_min
;    master_max = (local_max GT master_max) ? local_max : master_max
;
;    IF (index NE 0) THEN BEGIN
;      index_no_null = WHERE(local_tfpData NE 0,nbr)
;      IF (nbr NE 0) THEN BEGIN
;        index_indices = ARRAY_INDICES(local_tfpData,index_no_null)
;        sz = (size(index_indices,/DIMENSION))[1]
;        ;loop through all the not null values and add them to the background
;        ;array if their value is greater than the background one
;        i = 0L
;
;        ;        print, local_tfpdata[50:200,150] ;remove_me
;        ;        help, local_tfpdata
;        ;        print
;        ;        print, base_array[50:200,150]
;        ;        help, base_array
;
;        WHILE(i LT sz) DO BEGIN
;          x = index_indices[0,i]
;          y = index_indices[1,i]
;          ;  print, 'x:' + strcompress(x) + ' y:' + strcompress(y) ;remove_me
;          value_new           = local_tfpData(x,y)
;          value_new_untouched = local_tfpData_untouched(x,y)
;          value_old           = base_array(x,y)
;          value_old_untouched = base_array_untouched(x,y)
;          print, 'value_new:' + string(value_new) + $
;            ' value_old:' + string(value_old)
;
;          IF (value_new GT value_old) THEN BEGIN
;            print, 'in thererererer'
;            base_array(x,y)           = value_new
;            base_array_error(x,y)     = local_tfpData_error(x,y)
;            base_array_untouched(x,y) = value_new_untouched
;          ENDIF
;          ++i
;        ENDWHILE
;      ENDIF
;    ENDIF
;
;    ++index
;    print, 'index is: ' +strcompress(index) ;remove_me
;
;
;  ENDWHILE
;
;  print, 'leaving while loop' ;remove_me
;
;  ;  print, 'total array leaving the for loop' ;remove_me
;  ;  print, base_array[50:200,300] ;remove_me
;  ;  help, base_array
;
;  ;rebin by 2 in y-axis final array
;  rData = REBIN(base_array, $
;    (size(base_array))(1)*x_coeff, $
;    (size(base_array))(2)*y_coeff,/SAMPLE)
;  rData_error = REBIN(base_array_error, $
;    (size(base_array_error))(1)*x_coeff, $
;    (size(base_array_error))(2)*y_coeff,/SAMPLE)
;
;  total_array = rData
;
;  (*(*global).total_array_error) = base_array_error
;  (*(*global).total_array_untouched) = base_array_untouched
;
;  (*global).zmax_g_recap = master_max
;  (*global).zmin_g_recap = master_min
;
;  DEVICE, DECOMPOSED=0
;  LOADCT, 5, /SILENT
;
;  print, '#1'
;
;  putTextFieldValue, Event, 'step5_zmax', (*global).zmax_g_recap, FORMAT='(e8.1)'
;  putTextFieldValue, Event, 'step5_zmin', (*global).zmin_g_recap, FORMAT='(e8.1)'
;
;  print, '#11'
;
;  ;plot color scale
;  ;plotColorScale_step5, Event, master_min, master_max ;_gui
;
;  print, '#2'
;
;  ;select plot
;  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
;  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
;  WSET,id_value
;
;  print, '#3'
;
;  cleanup_array, total_array ;_plot
;
;  print, '#4'
;
;  ;plot main plot
;  TVSCL, total_array, /DEVICE
;  ;  print, 'Total Array:' ;remove_me
;  ;  print, total_array[50:200,150] ;remove_me
;  ;
;  xrange   = (*global).xscale.xrange
;  xticks   = (*global).xscale.xticks
;  position = (*global).xscale.position
;
;  print, '#5'
;
;  refresh_plot_scale_step5, $
;    EVENT    = Event, $
;    XSCALE   = xrange, $
;    XTICKS   = xticks, $
;    POSITION = position
;
;  print, '#6'
;
;  print, 'leaving refresh_recap_plot' ;remove_me
;
;END

;------------------------------------------------------------------------------

PRO plotColorScale_step5, Event, master_min, master_max

  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='scale_color_draw_step5')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  ERASE
  
  IF (isLogZaxisStep5Selected(Event)) THEN BEGIN
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
PRO check_step5_gui, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ListOfFiles = (*(*global).list_OF_ascii_files)
  IF (ListOfFiles[0] EQ '') THEN BEGIN
  
    map_status = 1
    id1 = widget_info(Event.top,find_by_uname='step5_shifting_draw')
    widget_control, id1, get_value=id
    wset, id
    image = read_bmp('REFoffSpec_images/RecapShifting.bmp')
    tv, image, 0,0,/true
    
    id2 = widget_info(Event.top,find_by_uname='step5_scaling_draw')
    widget_control, id2, get_value=id
    wset, id
    image = read_bmp('REFoffSpec_images/RecapScaling.bmp')
    tv, image, 0,0,/true
    MapBase, Event, 'scaling_base_step5', 1
    
  ENDIF ELSE BEGIN
  
    map_status = 0
    
    scaling_factor = (*(*global).scaling_factor)
    sz    = N_ELEMENTS(scaling_factor)
    index = 0
    scale_map_status = 0
    WHILE (index NE sz) DO BEGIN
      IF (scaling_factor[index] EQ 1) THEN BEGIN
        scale_map_status = 1
        BREAK
      ENDIF
      ++index
    ENDWHILE
    
    IF (scale_map_status EQ 1) THEN BEGIN
      id2 = widget_info(Event.top,find_by_uname='step5_scaling_draw')
      widget_control, id2, get_value=id
      wset, id
      image = read_bmp('REFoffSpec_images/RecapScaling.bmp')
      tv, image, 0,0,/true
    ENDIF
    MapBase, Event, 'scaling_base_step5', scale_map_status
    
    uname_list = ['step5_zmax',$
      'step5_zmin',$
      'step5_z_reset']
    activate_widget_list, Event, uname_list, 0^scale_map_status
    
  ENDELSE
  MapBase, Event, 'shifting_base_step5', map_status
  
END

;------------------------------------------------------------------------------
PRO populate_step5_range_widgets, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).debugging EQ 'yes') THEN BEGIN
    print, 'Entering populate_step5_range_widgets'
  ENDIF
  
  zmin_w    = getTextFieldValue(Event,'step5_zmin')
  s_zmin_w  = STRCOMPRESS(zmin_w,/REMOVE_ALL)
  as_zmin_w = STRING(s_zmin_w, FORMAT='(e8.1)')
  
  zmin_g    = (*global).zmin_g_recap
  s_zmin_g  = STRCOMPRESS(zmin_g,/REMOVE_ALL)
  as_zmin_g = STRING(s_zmin_g, FORMAT='(e8.1)')
  
  IF (as_zmin_w NE as_zmin_g) THEN BEGIN
    print, ' New value of zmin_g is: ' + strcompress(zmin_w)
    (*global).zmin_g_recap = DOUBLE(zmin_w)
  ENDIF
  
  ;------------------------------------------------
  zmax_w    = getTextFieldValue(Event,'step5_zmax')
  s_zmax_w  = STRCOMPRESS(zmax_w,/REMOVE_ALL)
  as_zmax_w = STRING(s_zmax_w, FORMAT='(e8.1)')
  
  zmax_g    = (*global).zmax_g_recap
  s_zmax_g  = STRCOMPRESS(zmax_g,/REMOVE_ALL)
  as_zmax_g = STRING(s_zmax_g, FORMAT='(e8.1)')
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, '  zmax_g    : ' + strcompress(zmax_g)
    print, '  as_zmax_w : ' + as_zmax_w
    print, '  as_zmax_g : ' + as_zmax_g
  ENDIF
  
  IF (as_zmax_w NE as_zmax_g) THEN BEGIN
    print, ' New value of zmax_g is: ' + strcompress(zmax_w)
    (*global).zmax_g_recap = DOUBLE(zmax_w)
  ENDIF
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Leaving populate_step5_range_widgets'
    print
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO plot_step5_i_vs_Q_selection, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  refresh_recap_plot, Event, RESCALE=1
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  x0 = (*global).step5_x0
  y0 = (*global).step5_y0
  
  x1 = Event.x
  y1 = Event.y
  
  color = (*global).step5_i_vs_q_color
  
  plots, [x0, x0, x1, x1, x0],$
    [y0,y1, y1, y0, y0],$
    /DEVICE,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
PRO replot_step5_i_vs_Q_selection, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x0 = (*global).step5_x0
  y0 = (*global).step5_y0
  
  x1 = (*global).step5_x1
  y1 = (*global).step5_y1
  
  color = (*global).step5_i_vs_q_color
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  plots, [x0, x0, x1, x1, x0],$
    [y0,y1, y1, y0, y0],$
    /DEVICE,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
PRO inform_log_book_step5_selection, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x0 = (*global).step5_x0 ;lambda
  y0 = (*global).step5_y0 ;lambda
  x1 = (*global).step5_x1 ;pixel
  y1 = (*global).step5_y1 ;pixel
  
  ry0 = FIX(y0/2)
  ry1 = FIX(y1/2)
  yBottom = MIN([ry0,ry1],MAX=yTop)
  
  xMin = MIN([x0,x1],MAX=xMax)
  x_axis = (*(*global).x_axis)
  Lambda_min = x_axis[xMin]
  Lambda_max = x_axis[xMax]
  
  LogText = '> User selected a I vs Q region in the Step5 (Recap) tab:'
  IDLsendToGeek_addLogBookText, Event, LogText
  LogText = '    Bottom Pixel: ' + STRCOMPRESS(yBottom,/REMOVE_ALL)
  IDLsendToGeek_addLogBookText, Event, LogText
  LogText = '    Lambda min: ' + STRCOMPRESS(lambda_min,/REMOVE_ALL) + $
    ' Angstroms'
  IDLsendToGeek_addLogBookText, Event, LogText
  LogText = '    Top Pixel: ' + STRCOMPRESS(yTop,/REMOVE_ALL)
  IDLsendToGeek_addLogBookText, Event, LogText
  LogText = '    Lambda max: ' + STRCOMPRESS(lambda_max,/REMOVE_ALL) + $
    ' Angstroms'
  IDLsendToGeek_addLogBookText, Event, LogText
  
END

;------------------------------------------------------------------------------
PRO produce_i_vs_q_output_file, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  WIDGET_CONTROL, /HOURGLASS
  
  base_array_untouched = (*(*global).total_array_untouched)
  base_array_error     = (*(*global).total_array_error)
  
  x0 = (*global).step5_x0 ;lambda
  y0 = (*global).step5_y0 ;pixel
  x1 = (*global).step5_x1 ;lambda
  y1 = (*global).step5_y1 ;pixel
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  ymin = FIX(ymin/2)
  ymax = FIX(ymax/2)
  
  array_selected = base_array_untouched[xmin:xmax,ymin:ymax]
  array_selected_total = TOTAL(array_selected,2)
  
  array_error_selected = base_array_error[xmin:xmax,ymin:ymax]
  y = (size(array_error_selected))(2)
  array_error_selected_total = TOTAL(array_error_selected,2)/FLOAT(y)
  
  x_axis = (*(*global).x_axis)
  x_axis_selected = x_axis[xmin:xmax]
  x_axis_in_Q = convert_from_lambda_to_Q(x_axis_selected)
  nbr_data = N_ELEMENTS(x_axis_selected)
  
  ;create ascii file
  nbr_comments = 4
  nbr_lines = nbr_comments + nbr_data
  FileLine = STRARR(nbr_lines)
  
  index = 0
  FileLine[index] = '#D ' + GenerateIsoTimeStamp()
  FileLine[++index] = ''
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_label = 'Lambda_T(Angstroms)'
  ENDIF ELSE BEGIN
    x_axis_label = 'Q(Angstroms^-1)'
  ENDELSE
  FileLine[++index] = '#L ' + x_axis_label + $
    ' Intensity(Counts/A) Sigma(Counts/A)'
  FileLine[++index] = ''
  
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis = x_axis_in_Q
  ENDIF ELSE BEGIN
    x_axis = x_axis_selected
  ENDELSE
  
  FOR i=0,(nbr_data-1) DO BEGIN
    Line = STRCOMPRESS(x_axis[i],/REMOVE_ALL) + '  '
    Line += STRCOMPRESS(array_selected_total[i],/REMOVE_ALL)
    Line += '  ' + STRCOMPRESS(array_error_selected_total[i],/REMOVE_ALL)
    FileLine[++index] = Line
  ENDFOR
  
  ;name of file to create
  output_file_name = getTextFieldValue(Event,'step5_file_name_i_vs_q')
  output_file_path = getButtonValue(Event,'step5_browse_button_i_vs_q')
  output_file = output_file_path + output_file_name
  
  no_error = 0
  CATCH,no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    update_step5_preview_button, Event, FILE=output_file
    WIDGET_CONTROL, HOURGLASS=0
    RETURN
  ENDIF ELSE BEGIN
    OPENW, 1, output_file
    sz = N_ELEMENTS(FileLine)
    FOR i=0,(sz-1) DO BEGIN
      PRINTF, 1, FileLine[i]
    ENDFOR
    CLOSE, 1
    FREE_LUN, 1
    
  ENDELSE
  
  update_step5_preview_button, Event, OUTPUT_FILE=output_file
  WIDGET_CONTROL, HOURGLASS=0
  
END

;------------------------------------------------------------------------------
PRO update_step5_preview_button, Event, OUTPUT_FILE=output_file

  IF (N_ELEMENTS(FILE) EQ 0) THEN BEGIN
    output_file_name = getTextFieldValue(Event,'step5_file_name_i_vs_q')
    output_file_path = getButtonValue(Event,'step5_browse_button_i_vs_q')
    output_file = output_file_path + output_file_name
  ENDIF
  
  IF (FILE_TEST(output_file,/READ)) THEN BEGIN
    activate_preview_button = 1
  ENDIF ELSE BEGIN
    activate_preview_button = 0
  ENDELSE
  
  activate_widget, Event, 'preview_button_i_vs_q', activate_preview_button
  
END

;------------------------------------------------------------------------------
PRO step5_preview_button, Event

  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  output_file_name = getTextFieldValue(Event,'step5_file_name_i_vs_q')
  output_file_path = getButtonValue(Event,'step5_browse_button_i_vs_q')
  output_file = output_file_path + output_file_name
  
  IF (FILE_TEST(output_file)) THEN BEGIN
    XDISPLAYFILE, output_file, $
      TITLE = 'Preview of ' + output_file
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO step5_browse_path_button, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path  = (*global).working_path
  title = 'Select where you want to create the ASCII file'
  
  path = DIALOG_PICKFILE(PATH = path,$
    TITLE = title, $
    /MUST_EXIST,$
    /DIRECTORY)
    
  IF (path NE '') THEN BEGIN
    (*global).working_path = path
    putButtonValue, Event, 'step5_browse_button_i_vs_q', path
  ENDIF
  
END
