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

;re_plot the fittin
PRO re_plot_fitting, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  SF = (*(*global).scaling_factor)
  ;fitting_parameters = (*global).step4_2_2_fitting_parameters
  ;a = fitting_parameters[0]
  ;b = fitting_parameters[1]
  x_axis = (*(*global).step4_2_2_x_array_to_fit)
  
  AverageValue = (*global).AverageValue
  SF           = getTextFieldValue(Event,'step2_sf_text_field')
  A = AverageValue / FLOAT(SF)
  
  IF (AverageValue EQ 0) THEN BEGIN ;do nothing
  ENDIF ELSE BEGIN
    plot_fitting, Event, x_axis=x_axis, A=A
  ENDELSE
END

;------------------------------------------------------------------------------
;plot the fitting only
PRO plot_fitting, Event, x_axis=x_axis, A=a, B=b
  ;y_new = FLOAT(b)*x_axis + FLOAT(a)
  y_new = FLOAT(a) + 0*x_axis
  oplot, x_axis, y_new, COLOR=250, thick=1.5
END

;------------------------------------------------------------------------------
;refresh the plot and plot the fitting on top of it
PRO plot_ce_fit, Event, _EXTRA=extra ;scaling_step2_step2
  ;replot data
  display_step4_step2_step2_selection, Event
  ;plot Lambda on top of plot
  plotLambdaSelected, Event
  ;plot fitting
  plot_fitting, Event, _EXTRA=extra
END

;------------------------------------------------------------------------------
;plot only the CE file (the first one loaded)
PRO display_step4_step2_step2_selection, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;first check that there is something to plot (that a selection of
  ;step1 of scaling has been done). If not, display a message asking for
  ;a selection first.
  
  ; Code change RCW (Feb 8, 2010): Get Background color from XML file
     PlotBackground = (*global).BackgroundCurvePlot
     ref_plot_error_color = (*global).ref_plot_error_color
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  xy_position = (*global).step4_step1_selection
  IF (xy_position[0]+xy_position[2] NE 0 AND $
    xy_position[1]+xy_position[3] NE 0) THEN BEGIN ;valid selection
    
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='draw_step4_step2')
    WIDGET_CONTROL, id_draw, GET_VALUE=id_value
    WSET,id_value
    
    ;array that will contain the counts vs wavelenght of each data file
    IvsLambda_selection       = (*(*global).IvsLambda_selection)
    IvsLambda_selection_error = (*(*global).IvsLambda_selection_error)
    box_color                 = (*global).box_color
    t_data_to_plot            = *IvsLambda_selection[0]
    t_data_to_plot_error      = *IvsLambda_selection_error[0]
    color                     = box_color[0]
    xrange = (*(*global).step4_step2_step1_xrange)
    xtitle = 'Wavelength'
    ytitle = 'Counts'
    ;    ymax_value = (*global).step4_step1_ymax_value
    ymax_value = DOUBLE(getTextFieldValue(Event,'step4_2_zoom_y_max'))
    ymin_value = DOUBLE(getTextFieldValue(Event,'step4_2_zoom_y_min'))
    
    xmin_value = getTextFieldValue(Event,'step4_2_zoom_x_min')
    xmax_value = getTextFieldValue(Event,'step4_2_zoom_x_max')
    
    psym       = getStep4Step2PSYMselected(Event)
    isLog      = getStep4Step2PlotType(Event)
    
    IF (isLog) THEN BEGIN
      PLOT, xrange, $
        t_data_to_plot, $
        XTITLE = xtitle, $
        YTITLE = ytitle,$
        COLOR  = color,$
        BACKGROUND = FSC_COLOR(PlotBackground),$
        ;YRANGE = [(*global).ymin_log_mode,ymax_value],$
        YRANGE = [ymin_value,ymax_value],$
        XRANGE = [xmin_value,xmax_value],$
        XSTYLE = 1,$
        PSYM   = psym,$
        /YLOG
    ENDIF ELSE BEGIN
      PLOT, xrange, $
        t_data_to_plot, $
        XTITLE = xtitle, $
        YTITLE = ytitle,$
        COLOR  = color,$
         BACKGROUND = FSC_COLOR(PlotBackground),$
        XRANGE = [xmin_value,xmax_value],$
        YRANGE = [ymin_value,ymax_value],$
        XSTYLE = 1,$
        PSYM   = psym
    ENDELSE

; Code Change (RC Ward, Mar 5, 2010): Set color of line to ref_plot_error_color, was 250    
    IF (isWithScalingErrorBars(Event)) THEN BEGIN
    
      IF (isLog) THEN BEGIN
        ERRPLOT, xrange,$
          t_data_to_plot-alog10(t_data_to_plot_error),$
          t_data_to_plot+alog10(t_data_to_plot_error),$
          color = FSC_COLOR(ref_plot_error_color)
      ENDIF ELSE BEGIN
        ERRPLOT, xrange,$
          t_data_to_plot-t_data_to_plot_error,$
          t_data_to_plot+t_data_to_plot_error,$
          color = FSC_COLOR(ref_plot_error_color)
      ENDELSE
    ENDIF
  ENDIF
END

;------------------------------------------------------------------------------
PRO step4_2_reverse_status_OF_lambda_selected, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).step4_2_2_lambda_selected EQ 'min') THEN BEGIN
    (*global).step4_2_2_lambda_selected = 'max'
    putTextFieldValue, Event, 'Lambda_min_select', ''
    putTextFieldValue, Event, 'Lambda_max_select', '<'
  ENDIF ELSE BEGIN
    (*global).step4_2_2_lambda_selected = 'min'
    putTextFieldValue, Event, 'Lambda_min_select', '<'
    putTextFieldValue, Event, 'Lambda_max_select', ''
  ENDELSE
END

;------------------------------------------------------------------------------
PRO step4_2_left_click, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  step4_2_2_lambda_array = (*global).step4_2_2_lambda_array
  step4_2_2_lambda_value_array = (*global).step4_2_2_lambda_value_array
  
  ;refresh plot 2d of step4_2_2
  display_step4_step2_step2_selection, Event
  
  CASE ((*global).step4_2_2_lambda_selected) OF
    'min': BEGIN
      step4_2_2_lambda_array[0] = Event.x
      cursor, X, Y, /DATA, /NOWAIT
      step4_2_2_lambda_value_array[0] = X
    END
    'max': BEGIN
      step4_2_2_lambda_array[1] = Event.x
      cursor, X, Y, /DATA, /NOWAIT
      step4_2_2_lambda_value_array[1] = X
    END
    ELSE:
  ENDCASE
  
  (*global).step4_2_2_lambda_array = step4_2_2_lambda_array
  (*global).step4_2_2_lambda_value_array = step4_2_2_lambda_value_array
  
  ;  ;plot Lambda on top of plot
  ;  plotLambdaSelected, Event
  
  ;display lambda in boxes
  display_lambda_selected, Event
  
  re_plot_lambda_selected, Event
  
END

;------------------------------------------------------------------------------
PRO step4_2_move, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  step4_2_2_lambda_array = (*global).step4_2_2_lambda_array
  step4_2_2_lambda_value_array = (*global).step4_2_2_lambda_value_array
  
  ;refresh plot 2d of step4_2_2
  display_step4_step2_step2_selection, Event
  
  CASE ((*global).step4_2_2_lambda_selected) OF
    'min': BEGIN
      step4_2_2_lambda_array[0] = Event.x
      cursor, X, Y, /DATA, /NOWAIT
      step4_2_2_lambda_value_array[0] = X
    END
    'max': BEGIN
      step4_2_2_lambda_array[1] = Event.x
      cursor, X, Y, /DATA, /NOWAIT
      step4_2_2_lambda_value_array[1] = X
    END
    ELSE:
  ENDCASE
  
  (*global).step4_2_2_lambda_array = step4_2_2_lambda_array
  (*global).step4_2_2_lambda_value_array = step4_2_2_lambda_value_array
  
  ;display lambda in boxes
  display_lambda_selected, Event
  
  ;plot Lambda on top of plot
  re_plot_lambda_selected, Event
;  plotLambdaSelected, Event
  
END

;------------------------------------------------------------------------------
PRO plotLambdaSelected, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
; Code change RCW (Feb 9, 2010: pass CE selection vertical line color in global (was set to 200)
   ceselect_vertical_line_color = (*global).ceselect_vertical_line_color

  step4_2_2_lambda_array = (*global).step4_2_2_lambda_array
  
  xmin = (*global).step4_2_2_draw_xmin
  ymin = (*global).step4_2_2_draw_ymin
  xmax = (*global).step4_2_2_draw_xmax
  ymax = (*global).step4_2_2_draw_ymax
  
  FOR i=0,1 DO BEGIN
    lambda = step4_2_2_lambda_array[i]
    IF (lambda GE xmin AND $
      lambda LT xmax) THEN BEGIN      
     plots, lambda, ymin, /DEVICE, color = FSC_COLOR(ceselect_vertical_line_color)
     plots, lambda, ymax, /DEVICE, /CONTINUE, color = FSC_COLOR(ceselect_vertical_line_color)
    ENDIF
  ENDFOR
  
END

;------------------------------------------------------------------------------
PRO display_lambda_selected, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;display value of Lambda min and max in boxes
  step4_2_2_lambda_array = (*global).step4_2_2_lambda_array
  
  gr_xmin = (*global).step4_2_2_draw_xmin
  gr_xmax = (*global).step4_2_2_draw_xmax
  
  xrange       = (*(*global).step4_step2_step1_xrange)
  nbr_elements = N_ELEMENTS(xrange)
  xmax         = xrange[nbr_elements-1]
  xmin         = xrange[0]
  
  ratio        = (FLOAT(xmax) - FLOAT(xmin))/(FLOAT(gr_xmax) - FLOAT(gr_xmin))
  
  Lambda_value_0 = FLOAT(step4_2_2_lambda_array[0] - gr_xmin) * ratio + xmin
  Lambda_value_1 = FLOAT(step4_2_2_lambda_array[1] - gr_xmin) * ratio + xmin
  
  uname_0 = 'step4_2_2_lambda1_text_field'
  uname_1 = 'step4_2_2_lambda2_text_field'
  
  step4_2_2_lambda_value_array = (*global).step4_2_2_lambda_value_array
  
  Q1 = step4_2_2_lambda_value_array[0]
  Q2 = step4_2_2_lambda_value_array[1]
  
  Qmin = MIN([Q1,Q2], MAX=Qmax)
  
  ;  putTextFieldValue, Event, uname_0, STRCOMPRESS(lambda_value_0,/REMOVE_ALL)
  ;  putTextFieldValue, Event, uname_1, STRCOMPRESS(lambda_value_1,/REMOVE_ALL)
  
  putTextFieldValue, Event, uname_0, STRCOMPRESS(Qmin,/REMOVE_ALL)
  putTextFieldValue, Event, uname_1, STRCOMPRESS(Qmax,/REMOVE_ALL)
  
END

;------------------------------------------------------------------------------
PRO reorder_step4_2_2_lambda, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;get lambda min and max values
  Lambda   = get_step4_step2_step2_lambda(Event)
  fLambda  = FLOAT(Lambda)
  sfLambda = fLambda(SORT(fLambda))
  IF (sfLambda[0] NE fLambda[0]) THEN BEGIN
    ;reverse status
    step4_2_reverse_status_OF_lambda_selected, Event
    ;reverse lambda_gr
    step4_2_2_lambda_array = (*global).step4_2_2_lambda_array
    (*global).step4_2_2_lambda_array = $
      [step4_2_2_lambda_array[1],$
      step4_2_2_lambda_array[0]]
  ENDIF
  
  IF (sfLambda[0] EQ FLOAT(0) ) THEN BEGIN
    sLambdaMin = 'N/A'
  ENDIF ELSE BEGIN
    sLambdaMin = STRCOMPRESS(sfLambda[0],/REMOVE_ALL)
  ENDELSE
  putTextFieldValue, Event, 'step4_2_2_lambda1_text_field', sLambdaMin
  
  IF (sfLambda[1] EQ FLOAT(0)) THEN BEGIN
    sLambdaMax = 'N/A'
  ENDIF ELSE BEGIN
    sLambdaMax = STRCOMPRESS(sfLambda[1],/REMOVE_ALL)
  ENDELSE
  putTextFieldValue, Event, 'step4_2_2_lambda2_text_field', sLambdaMax
  
END

;------------------------------------------------------------------------------
PRO check_step4_step2_step2, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  step4_2_2_lambda_array = (*global).step4_2_2_lambda_array
  
  IF (step4_2_2_lambda_array[0] NE 0 AND $
    step4_2_2_lambda_array[1] NE 0) THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  activate_widget, Event, 'auto_mode_base', status
END

;------------------------------------------------------------------------------
PRO manual_lambda_input, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve manual lambda min and max
  lambda_array = get_step4_step2_step2_lambda(Event)
  gr_xmin      = (*global).step4_2_2_draw_xmin
  gr_xmax      = (*global).step4_2_2_draw_xmax
  xrange       = (*(*global).step4_step2_step1_xrange)
  nbr_elements = N_ELEMENTS(xrange)
  xmax         = xrange[nbr_elements-1]
  xmin         = xrange[0]
  
  ratio          = (FLOAT(xmax) - FLOAT(xmin))/(FLOAT(gr_xmax) - FLOAT(gr_xmin))
  ratio          = 1/ratio
  Lambda_value_1 = (FLOAT(lambda_array[0]) - xmin) * ratio + gr_xmin
  Lambda_value_2 = (FLOAT(lambda_array[1]) - xmin) * ratio + gr_xmin
  
  (*global).step4_2_2_lambda_array = [FLOAT(Lambda_value_1),$
    FLOAT(Lambda_value_2)]
    
  ;refresh plot
  display_step4_step2_step2_selection, Event
  ;plot lambda
  plotLambdaSelected, Event
  
END

;------------------------------------------------------------------------------
;this function is reached each time the user changes the selection of step1
PRO reset_step4_2_2_selection, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  (*global).step4_2_2_lambda_array = [0,0]
  putTextFieldValue, Event, 'step4_2_2_lambda1_text_field', ''
  putTextFieldValue, Event, 'step4_2_2_lambda2_text_field', ''
END

;------------------------------------------------------------------------------
PRO display_error_message, Event, STEP=step
  Message = ['Error during the ' + STEP + ' process!',$
    '',$
    'Please modify the selection and try again']
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_2_2_auto_button')
  result = DIALOG_MESSAGE(Message,$
    /INFORMATION, $
    TITLE = 'Fitting/Scaling FAILED!',$
    DIALOG_PARENT = id)
    
END

;------------------------------------------------------------------------------
;Reach by the Automatic fitting and scaling of step4/step2/step2
PRO step4_2_2_automatic_fitting_scaling, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  PROCESSING = (*global).processing
  FAILED     = (*global).failed
  OK         = (*global).ok
  
  fit_scale_status = 1 ;worked by default
  
  text = '> Automatic Fitting and Scaling :'
  IDLsendToGeek_addLogBookText, Event, text
  
  ;Display Lambda min and max values selected
  Lda_array = get_step4_step2_step2_lambda(Event)
  Lda_min   = Lda_array[0]
  Lda_max   = Lda_array[1]

  IDLsendToGeek_addLogBookText, Event, '--> Lambda min : ' + $
    STRCOMPRESS(Lda_min,/REMOVE_ALL)
  IDLsendToGeek_addLogBookText, Event, '--> Lambda max : ' + $
    STRCOMPRESS(Lda_max,/REMOVE_ALL)
    
  ;Fitting --------------------------------------
  IDLsendToGeek_addLogBookText, Event, '-> Fitting ... ' + PROCESSING
  fit_error = 0
  CATCH, fit_error
  IF (fit_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    fit_scale_status = 0
  ENDIF ELSE BEGIN

    Step4_step2_step2_fitCE, Event, lda_min, lda_max ;scaling_step2_step2
    IF ((*global).step4_2_2_fitting_status EQ 0) THEN BEGIN
      IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
      fit_scale_status = 0
      display_error_message, Event, STEP='fitting'
    ENDIF ELSE BEGIN
      IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
    ENDELSE
  ENDELSE
  
  IF ((*global).step4_2_2_fitting_status) THEN BEGIN
    ;Scaling --------------------------------------
    IDLsendToGeek_addLogBookText, Event, '-> Scaling ... ' + PROCESSING
    scale_error = 0
    CATCH, scale_error
    IF (scale_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
      fit_scale_status = 0
      display_error_message, Event, STEP='scaling'
    ENDIF ELSE BEGIN
      step4_step2_step2_scaleCE, Event ;scaling_step2_step2
      IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
    ENDELSE
  ENDIF
  
  IF (fit_scale_status) THEN BEGIN ;populate droplist of step3
    populate_step4_2_3_droplist, Event ;scaling_step2_step3
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO step4_step2_step2_scaleCE, Event, RESET=reset
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;get scale factor (average value between lda_min and lda_max)
  IF (N_ELEMENTS(RESET) EQ 0) THEN BEGIN
    s_scale_factor = getTextFieldValue(Event,'step2_sf_text_field')
  ENDIF ELSE BEGIN
    s_scale_factor = getTextFieldValue(Event,'step2_y_before_text_field')
    putTextFieldvalue, Event, 'step2_sf_text_field',s_scale_factor
  ENDELSE
  
  f_scale_factor = FLOAT(s_scale_factor)
  nbr_files      = getNbrFiles(Event)
  scaling_factor = FLTARR(nbr_files) + 1
  scaling_factor[0] = f_scale_factor
  (*(*global).scaling_factor) = scaling_factor
  
  ;retrieve Y and Y_error of CE file and rescale them according to
  ;scaling factor found
  IvsLambda_selection                    = $
    (*(*global).IvsLambda_selection_backup)
  IvsLambda_selection_error              = $
    (*(*global).IvsLambda_selection_error_backup)
    
  ;create new big array
  sz = (size(IvsLambda_selection))(1)
  new_IvsLambda_selection       = PTRARR(sz,/ALLOCATE_HEAP)
  new_IvsLambda_selection_error = PTRARR(sz,/ALLOCATE_HEAP)
  index = 0
  WHILE (index LT sz) DO BEGIN
    *new_IvsLambda_selection[index]       = *IvsLambda_selection[index]
    *new_IvsLambda_selection_error[index] = *IvsLambda_selection_error[index]
    index++
  ENDWHILE
  
  y_array                                = *new_IvsLambda_selection[0]
  y_error_array                          = *new_IvsLambda_selection_error[0]
  
  y_array_rescale                        = y_array/f_scale_factor
  
  y_error_array_rescale                  = y_error_array/f_scale_factor
  *new_IvsLambda_selection[0]            = y_array_rescale
  *new_IvsLambda_selection_error[0]      = y_error_array_rescale
  (*(*global).IvsLambda_selection)       = new_IvsLambda_selection
  (*(*global).IvsLambda_selection_error) = new_IvsLambda_selection_error
  
  ;make sure they all have the same size
  ;get the biggest size
  sz_max = 0
  FOR i=0, (nbr_files-1) DO BEGIN
    sz = N_ELEMENTS(*new_IvsLambda_selection[i])
    IF (sz GT sz_max) THEN sz_max = sz
  ENDFOR
  FOR i=0, (nbr_files-1) DO BEGIN
  
    sz = N_ELEMENTS(*new_IvsLambda_selection[i])
    IF (sz LT sz_max) THEN BEGIN
      local_IvsLambda_selection = FLTARR(sz_max)
      local_IvsLambda_selection_error = FLTARR(sz_max)
      
      local_IvsLambda_selection[0:sz-1] = *new_IvsLambda_selection[i]
      local_IvsLambda_selection_error[0:sz-1] = *new_IvsLambda_selection_error[i]
      
      local_IvsLambda_selection[sz:sz_max-1] = !VALUES.F_NAN
      local_IvsLambda_selection_error[sz:sz_max-1] = !VALUES.F_NAN
      
      *new_IvsLambda_selection[i] = local_IvsLambda_selection
      *new_IvsLambda_selection_error[i] = local_IvsLambda_selection_error
      
    ENDIF
  ENDFOR
  
  (*(*global).IvsLambda_selection_step3_backup) = new_IvsLambda_selection
  (*(*global).IvsLambda_selection_error_step3_backup) = $
    new_IvsLambda_selection_error
    
  ;we also need to rescale the fitting parameters to replot the fitting line
  ;after rescalling
  ;fitting_parameters = (*global).step4_2_2_fitting_parameters_backup
  ;a = fitting_parameters[0]
  ;b = fitting_parameters[1]
  ;a_rescale = a / f_scale_factor
  ;b_rescale = b / f_scale_factor
  ;(*global).step4_2_2_fitting_parameters = [a_rescale,b_rescale]
  ;we can now replot CE file and fitting line too
    
  ;replot data
  display_step4_step2_step2_selection, Event
  ;plot Lambda on top of plot
  plotLambdaSelected, Event
  ;replot fitting line
  re_plot_fitting, Event
  
;PTR_FREE, new_IvsLambda_selection
  
END

;------------------------------------------------------------------------------
PRO Step4_step2_step2_fitCE, Event, lda_min, lda_max
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;get x-axis
  xrange = (*(*global).step4_step2_step1_xrange)
  ;get index where lda_min and lda_max are
  lda_index = getArrayRangeFromlda1lda2(xrange, lda_min, lda_max)

  ;Isolate the X, Y and Y_error array between lda_min and lda_max
  x_array_to_fit            = xrange[lda_index[0]:lda_index[1]]

  (*(*global).step4_2_2_x_array_to_fit) = x_array_to_fit
  IvsLambda_selection       = (*(*global).IvsLambda_selection_backup)
  ;IvsLambda_selection_error = (*(*global).IvsLambda_selection_error_backup)
  y_array                   = *IvsLambda_selection[0]
  ;y_error_array             = *IvsLambda_selection_error[0]
  y_array_to_fit            = y_array[lda_index[0]:lda_index[1]]

  ;y_error_array_to_fit      = y_error_array[lda_index[0]:lda_index[1]]
  
  ;calculate the average value over the range selected
  AverageValue = MEAN(y_array_to_fit)
; Code change (RC Ward, March 23, 2010): Try using MAX value here
; AverageValue = MAX(y_array_to_fit)
  
  (*global).AverageValue = AverageValue

  putTextFieldValue, Event, $
    'step2_y_before_text_field',$
    STRCOMPRESS(AverageValue,/REMOVE_ALL)
  putTextFieldValue, Event,$
    'step2_sf_text_field',$
    STRCOMPRESS(AverageValue,/REMOVE_ALL)
    
  ;;determine the fitting parameters of this data
  ;fit_data, Event, x_array_to_fit, y_array_to_fit, y_error_array_to_fit, a, b
  ;(*global).step4_2_2_fitting_parameters_backup = [a,b]
  ;IF ((a EQ 0 AND $
  ;     b EQ 0) OR $
  ;    ~FINITE(a) OR $
  ;    ~FINITE(b)) THEN BEGIN
  ;    a_value = 'NaN'
  ;    b_value = 'NaN'
  ;    (*global).step4_2_2_fitting_status = 0
  ;ENDIF ELSE BEGIN                ;found a and b
  ;    a_value = STRCOMPRESS(a,/REMOVE_ALL)
  ;    b_value = STRCOMPRESS(b,/REMOVE_ALL)
  ;;   x_range_fit = x_array_to_fit
  ;;;   plot_ce_fit, Event, x_axis=x_range_fit, A=a, B=b ;scaling_step2_step2
  ;;Calculate the average value inside the lda range selected
  ;    calculate_average_fitted_y, Event, a, b, lda_min, lda_max
  ;    (*global).step4_2_2_fitting_status = 1
  ;ENDELSE
    
  (*global).step4_2_2_fitting_status = 1
END

;------------------------------------------------------------------------------
PRO calculate_average_fitted_y, Event, a, b, lda_min, lda_max
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;create an array of Nbr_elements = 100 elements between lda_min and lda_max
  Nbr_elements = 100
  f_lda_min    = FLOAT(lda_min)
  f_lda_max    = FLOAT(lda_max)
  diff         = f_lda_max - f_lda_min
  delta        = diff / Nbr_elements
  ;x_axis is composed (Nbr_elements+1)
  x_axis       = (FINDGEN(Nbr_elements+1))*delta + f_lda_min
  ;y_axis
  y_axis       = b * x_axis + a
  AverageValue = total(y_axis)/(Nbr_elements+1)
  putTextFieldValue, Event, $
    'step2_y_before_text_field',$
    STRCOMPRESS(AverageValue,/REMOVE_ALL)
  putTextFieldValue, Event,$
    'step2_sf_text_field',$
    STRCOMPRESS(AverageValue,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
PRO check_step4_2_2_gui, Event ;scaling_step4_step2

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;  ;check if a and b are not 'N/A', if yes, activate SF text_field
  ;  a = getTextFieldValue(Event, 'step2_fitting_equation_a_text_field')
  ;  b = getTextFieldValue(Event, 'step2_fitting_equation_b_text_field')
  ;  IF (a EQ 'NaN' OR $
  ;    a EQ '-NaN' OR $
  ;    b EQ 'NaN' OR $
  ;    b EQ '-NaN') THEN BEGIN
  IF ((*global).AverageValue EQ 0) THEN BEGIN
    sensitive_status = 0
  ENDIF ELSE BEGIN
    sensitive_status = 1
  ENDELSE
  activate_widget, Event, 'step2_sf_text_field', sensitive_status
  activate_widget, Event, 'step2_manual_scaling_button', sensitive_status
  activate_widget, Event, 'step4_2_2_reset_scaling_button', sensitive_status
END

;------------------------------------------------------------------------------
PRO step4_2_2_manual_scaling, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  PROCESSING = (*global).processing
  FAILED     = (*global).failed
  OK         = (*global).ok
  
  IDLsendToGeek_addLogBookText, Event, '-> Manual Scaling ... ' + PROCESSING
  scale_error = 0
  CATCH, scale_error
  IF (scale_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
  ENDIF ELSE BEGIN
    step4_step2_step2_scaleCE, Event ;scaling_step2_step2
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
  ENDELSE
END

;------------------------------------------------------------------------------
PRO step4_2_2_reset_scaling, Event
  step4_step2_step2_scaleCE, Event, RESET=1
END
