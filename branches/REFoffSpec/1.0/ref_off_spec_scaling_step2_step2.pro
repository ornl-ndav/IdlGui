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

;plot only the CE file (the first one loaded)
PRO display_step4_step2_step2_selection, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;first check that there is something to plot (that a selection of
;step1 of scaling has been done). If not, display a message asking for
;a selection first.

xy_position = (*global).step4_step1_selection
IF (xy_position[0]+xy_position[2] NE 0 AND $
    xy_position[1]+xy_position[3] NE 0) THEN BEGIN ;valid selection

    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='draw_step4_step2')
    WIDGET_CONTROL, id_draw, GET_VALUE=id_value
    WSET,id_value

;array that will contain the counts vs wavelenght of each data file
    IvsLambda_selection       = (*(*global).IvsLambda_selection)
    IvsLambda_selection_error = (*(*global).IvsLambda_selection_error)
    box_color            = (*global).box_color
    t_data_to_plot       = *IvsLambda_selection[0]
    t_data_to_plot_error = *IvsLambda_selection_error[0]
    color                = box_color[0]
    xrange = (*(*global).step4_step2_step1_xrange)
    xtitle = 'Wavelength'
    ytitle = 'Counts'
    ymax_value = (*global).step4_step1_ymax_value
    PLOT, xrange, $
      t_data_to_plot, $
      XTITLE = xtitle, $
      YTITLE = ytitle,$
      COLOR  = color,$
      YRANGE = [0,ymax_value],$
      XSTYLE = 1,$
      PSYM   = 1
    ERRPLOT, xrange,$
      t_data_to_plot-t_data_to_plot_error,$
      t_data_to_plot+t_data_to_plot_error,$
      COLOR = 250
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

;refresh plot 2d of step4_2_2
display_step4_step2_step2_selection, Event

CASE ((*global).step4_2_2_lambda_selected) OF
    'min': BEGIN
        step4_2_2_lambda_array[0] = Event.x
    END
    'max': BEGIN
        step4_2_2_lambda_array[1] = Event.x
    END
ELSE:
ENDCASE

(*global).step4_2_2_lambda_array = step4_2_2_lambda_array

;plot Lambda on top of plot
plotLambdaSelected, Event

;display lambda in boxes
display_lambda_selected, Event

END

;------------------------------------------------------------------------------
PRO step4_2_move, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global
step4_2_2_lambda_array = (*global).step4_2_2_lambda_array

;refresh plot 2d of step4_2_2
display_step4_step2_step2_selection, Event

CASE ((*global).step4_2_2_lambda_selected) OF
    'min': BEGIN
        step4_2_2_lambda_array[0] = Event.x
    END
    'max': BEGIN
        step4_2_2_lambda_array[1] = Event.x
    END
ELSE:
ENDCASE

(*global).step4_2_2_lambda_array = step4_2_2_lambda_array

;plot Lambda on top of plot
plotLambdaSelected, Event

;display lambda in boxes
display_lambda_selected, Event

END

;------------------------------------------------------------------------------
PRO plotLambdaSelected, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global
step4_2_2_lambda_array = (*global).step4_2_2_lambda_array

xmin = (*global).step4_2_2_draw_xmin
ymin = (*global).step4_2_2_draw_ymin
xmax = (*global).step4_2_2_draw_xmax
ymax = (*global).step4_2_2_draw_ymax

FOR i=0,1 DO BEGIN
    lambda = step4_2_2_lambda_array[i]
    IF (lambda GE xmin AND $
        lambda LT xmax) THEN BEGIN
        plots, lambda, ymin, /DEVICE, color=200
        plots, lambda, ymax, /DEVICE, /CONTINUE, color=200
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
Lambda_value = FLOAT(Event.x - gr_xmin) * ratio + xmin

CASE ((*global).step4_2_2_lambda_selected) OF
    'min': BEGIN
        uname = 'step4_2_2_lambda1_text_field'
    END
    'max': BEGIN
        uname = 'step4_2_2_lambda2_text_field'
    END
ELSE:
ENDCASE

putTextFieldValue, Event, uname, STRCOMPRESS(lambda_value,/REMOVE_ALL)

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
activate_widget, Event, 'step4_2_2_auto_button', status
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
;Reach by the Automatic fitting and scaling of step4/step2/step2
PRO step4_2_2_automatic_fitting_scaling, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

PROCESSING = (*global).processing
FAILED     = (*global).failed
OK         = (*global).ok

text = '> Automatic Fitting and Scaling :' 
IDLsendToGeek_addLogBookText, Event, text

;Display Lambda min and max values selected
Lda_array = get_step4_step2_step2_lambda(Event)
Lda_min   = Lda_array[0]
Lda_max   = Lda_array[1]
idl_send_to_geek_addLogBookText, Event, '--> Lambda min : ' + $
  STRCOMPRESS(Lda_min,/REMOVE_ALL)
idl_send_to_geek_addLogBookText, Event, '--> Lambda max : ' + $
  STRCOMPRESS(Lda_max,/REMOVE_ALL)

idl_send_to_geek_addLogBookText, Event, '-> Fitting ... ' + PROCESSING 
fit_error = 0
CATCH, fit_error
IF (fit_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
ENDIF ELSE BEGIN
    Step4_step3_step2_fitCE, Event          ;scaling_step2_step2
    idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
ENDELSE






END



;------------------------------------------------------------------------------
PRO Step4_step3_step2_fitCE, Event 

END
