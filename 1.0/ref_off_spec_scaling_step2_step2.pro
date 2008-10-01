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
    IvsLambda_selection = (*(*global).IvsLambda_selection)
    box_color      = (*global).box_color
    t_data_to_plot = *IvsLambda_selection[0]
    color          = box_color[0]
    xrange = (*(*global).step4_step2_step1_xrange)
    xtitle = 'Wavelength'
    ytitle = 'Counts'
    ymax_value = (*global).step4_step1_ymax_value
    plot, xrange, $
      t_data_to_plot, $
      XTITLE = xtitle, $
      YTITLE = ytitle,$
      COLOR  = color,$
      YRANGE = [0,ymax_value],$
      XSTYLE = 1
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

