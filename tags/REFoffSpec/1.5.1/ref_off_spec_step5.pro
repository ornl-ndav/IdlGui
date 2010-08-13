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
  
;  plot, randomn(s,303L), $
  plot, randomn(s,(*global).detector_pixels_y-1), $
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
    
  ;  id2 = widget_info(Event.top,find_by_uname='step5_scaling_draw')
  ;  widget_control, id2, get_value=id
  ;  wset, id
  ;  image = read_bmp('REFoffSpec_images/RecapScaling.bmp')
  ;  tv, image, 0,0,/true
  ;    MapBase, Event, 'scaling_base_step5', 1
    
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
    
   ; IF (scale_map_status EQ 1) THEN BEGIN
   ;   id2 = widget_info(Event.top,find_by_uname='step5_scaling_draw')
   ;   widget_control, id2, get_value=id
   ;   wset, id
   ;   image = read_bmp('REFoffSpec_images/RecapScaling.bmp')
   ;   tv, image, 0,0,/true
   ; ENDIF
   ; MapBase, Event, 'scaling_base_step5', scale_map_status
    
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
  ref_pixel_list = (*(*global).ref_pixel_list)
  
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
  
  x_axis = (*(*global).step5_selection_x_array)
  array_selected_total = (*(*global).step5_selection_y_array)
  array_error_selected_total = (*(*global).step5_selection_y_error_array)
  
  nbr_data = N_ELEMENTS(x_axis)
  
  ;create ascii file
  nbr_comments = 4
  nbr_lines = nbr_comments + nbr_data
  FileLine = STRARR(nbr_lines)
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  (*global).selection_type = type
  
  index = 0
  FileLine[index] = '#D ' + GenerateIsoTimeStamp()
  FileLine[++index] = ''
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_label = 'Q(Angstroms^-1)'
  ENDIF ELSE BEGIN
    x_axis_label = 'Lambda_T(Angstroms)'
  ENDELSE
  FileLine[++index] = '#L ' + x_axis_label + $
    ' Intensity(Counts/A) Sigma(Counts/A)'
  FileLine[++index] = ''
  
  IF (type EQ 'IvsQ') THEN BEGIN
    FOR i=(nbr_data-1),0,-1 DO BEGIN
      Line = STRCOMPRESS(x_axis[i],/REMOVE_ALL) + '  '
      Line += STRCOMPRESS(array_selected_total[i],/REMOVE_ALL)
      Line += '  ' + STRCOMPRESS(array_error_selected_total[i],/REMOVE_ALL)
      FileLine[++index] = Line
    ENDFOR
  ENDIF ELSE BEGIN
    FOR i=0,(nbr_data-1) DO BEGIN
      Line = STRCOMPRESS(x_axis[i],/REMOVE_ALL) + '  '
      Line += STRCOMPRESS(array_selected_total[i],/REMOVE_ALL)
      Line += '  ' + STRCOMPRESS(array_error_selected_total[i],/REMOVE_ALL)
      FileLine[++index] = Line
    ENDFOR
  ENDELSE
  
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
  
  putTextFieldValue, Event, $
    'i_vs_q_output_file_working_spin_state', $
    output_file
    
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: BEGIN ;IvsQ
      (*global).i_vs_q_ext = 'IvsQ.txt'
    END
    2: BEGIN ;IvsLambda
      (*global).i_vs_q_ext = 'IvsLambda.txt'
    END
  ENDCASE
  
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
  title = 'Select a directory for output files'
  
  path = DIALOG_PICKFILE(PATH = path,$
    TITLE = title, $
    /MUST_EXIST,$
    /DIRECTORY)
    
  IF (path NE '') THEN BEGIN
    (*global).working_path = path
    putButtonValue, Event, 'step5_browse_button_i_vs_q', path
  ENDIF
  
END
