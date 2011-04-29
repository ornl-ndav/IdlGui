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

;##############################################################################
;******************************************************************************

PRO LoadCEFile, Event, CE_file_name, Q1, Q2
  ;retrieve global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  flt0_ptr = (*global).flt0_ptr
  flt1_ptr = (*global).flt1_ptr
  flt2_ptr = (*global).flt2_ptr
  
  ;rescale the other spin states as well
  spin_index = get_current_spin_index(event)
  if (spin_index ne -1) then begin
  
    flt0     = *flt0_ptr[0, spin_index]
    flt1     = *flt1_ptr[0, spin_index]
    flt2     = *flt2_ptr[0, spin_index]
    
  endif else begin
  
    flt0     = *flt0_ptr[0]
    flt1     = *flt1_ptr[0]
    flt2     = *flt2_ptr[0]
    
  endelse
  
  ;determine the working flt0, flt1 and flt2
  RangeIndexes = getArrayRangeFromQ1Q2(flt0, Q1, Q2) ;_get
  left_index   = RangeIndexes[0]
  right_index  = RangeIndexes[1]
  
  flt0_new = flt0[left_index:right_index]
  flt1_new = flt1[left_index:right_index]
  flt2_new = flt2[left_index:right_index]
  ;remove the non defined and inf values from flt0, flt1 and flt2
  RangeIndexes = getArrayRangeOfNotNanValues(flt1_new) ;_get
  flt0_new     = flt0_new(RangeIndexes)
  flt1_new     = flt1_new(RangeIndexes)
  flt2_new     = flt2_new(RangeIndexes)
  (*(*global).flt0_CE_range) = flt0_new
  ;Start function that will calculate the Fit function
  FitCEFunction, Event, flt0_new, flt1_new, flt2_new ;_fit
  LongFileNameArray = [CE_file_name]
  plot_loaded_file, Event, 'CE' ;_Plot
  ;display the value of the coeff in the A and B text boxes
  cooef = (*(*global).CEcooef)
  putValueInTextField, Event, $
    'step2_fitting_equation_a_text_field', $
    STRCOMPRESS(cooef[1],/REMOVE_ALL)         ;_put
  putValueInTextField, Event, $
    'step2_fitting_equation_b_text_field', $
    STRCOMPRESS(cooef[0],/REMOVE_ALL)         ;_put
END

;******************************************************************************

;this function will calculate the average Y value between Q1 and Q2 of
;the fitted function for CE only
PRO CalculateAverageFittedY, Event, Q1, Q2
  ;retrieve global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  CEcooef = (*(*global).CEcooef)
  ;y=ax+b
  b=CEcooef[0]
  a=CEcooef[1]
  ;create an array of Nbr_elements = 100 elements between Q1 and Q2
  Nbr_elements = 100
  diff         = Q2-Q1
  delta        = diff / Nbr_elements
  ;x_axis is composed (Nbr_elements+1)
  x_axis = (findgen(Nbr_elements+1))*delta + Q1
  ;y_axis
  y_axis = a * x_axis + b
  AverageValue = total(y_axis)/(Nbr_elements+1)
  (*global).CE_scaling_factor = AverageValue
  ;display value in Ybefore text field
  putValueInTextField, Event, $
    'step2_y_before_text_field', $
    STRCOMPRESS(AverageValue,/REMOVE_ALL)     ;_put
END

;******************************************************************************

;This function save Q1, Q2 and SF of the Critical Edge file selected
PRO Step2_fitCE, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  ;get long name of CE file
  CE_LongFileName       = (*global).full_CE_name
  ;get Q1 and Q2
  Q1Q2SF                = getQ1Q2SF(Event, 'STEP2') ;_get
  Q1                    = float(Q1Q2SF[0])
  Q2                    = float(Q1Q2SF[1])
  ;store the values of Q1 and Q2 for CE
  Q1_array              = (*(*global).Q1_array)
  Q2_array              = (*(*global).Q2_array)
  Q1_array[0]           = Q1
  Q2_array[0]           = Q2
  (*(*global).Q1_array) = Q1_array
  (*(*global).Q2_array) = Q2_array
  ;fit CE file and determine scaling factor
  LoadCEFile, Event, CE_LongFileName, Q1, Q2 ;_Step2
  ;calculate average Y before rescaling
  CalculateAverageFittedY, Event, Q1, Q2
  ;show the scalling factor (but do not replot it)
  ;get the average Y value before
  Ybefore = getTextFieldValue(Event, 'step2_y_before_text_field')
  Yafter  = 1 ;Average value after is 1 by default
  putValueInTextField, Event, 'step2_y_after_text_field', $
    STRCOMPRESS(Yafter,/REMOVE_ALL)
  ;check if Ybefore is numeric or not
  YbeforeIsNumeric = isNumeric(Ybefore)
  YafterIsNumeric  = isNumeric(Yafter)
  ;Ybefore and Yafter are numeric
  IF (YbeforeIsNumeric EQ 1 AND $
    YafterIsNumeric EQ 1) THEN BEGIN
    Ybefore = getNumeric(Ybefore)
    Yafter  = getNumeric(Yafter)
    ;put scaling factor in its box
    scaling_factor = float(Ybefore) / float(Yafter)
    (*global).CE_scaling_factor = scaling_factor
    SF_array = (*(*global).SF_array)
    SF_array[0] = scaling_factor
    (*(*global).SF_array) = SF_array
    
  ENDIF ELSE BEGIN ;scaling factor can be calculated
    scaling_factor = 'NaN'
  ENDELSE
  putValueInTextField, Event,'step2_sf_text_field', scaling_factor
END

;******************************************************************************

;This function is the next step (after the fitting) to
;bring to 1 the average Q1 to Q2 part of CE
PRO Step2_scaleCE, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  ;change the value of the ymax and ymin in the zoom box to 1.2 and 0
  ymax = strcompress((*global).rescaling_ymax,/remove_all)
  putValueInTextField, Event, 'YaxisMaxTextField', ymax
  ymin = strcompress((*global).rescaling_ymin,/remove_all)
  putValueInTextField, Event, 'YaxisMinTextField', ymin
  ;replot CE data with new scale
  plot_rescale_CE_file, Event ;_Plot
END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*

;when using automatic fitting and scaling of CE (step2)
PRO run_full_step2, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  idl_send_to_geek_addLogBookText, Event, '> Automatic Fitting and Scaling :'
  
  ;display Qmin and Qmax values
  Qmin = getTextFieldValue(Event,'step2_q1_text_field')
  Qmax = getTextFieldValue(Event,'step2_q2_text_field')
  idl_send_to_geek_addLogBookText, Event, '-> Qmin : ' + $
    STRCOMPRESS(Qmin,/REMOVE_ALL)
  idl_send_to_geek_addLogBookText, Event, '-> Qmax : ' + $
    STRCOMPRESS(Qmax,/REMOVE_ALL)
    
  idl_send_to_geek_addLogBookText, Event, '-> Fitting ... ' + PROCESSING
  fit_error = 0
  CATCH, fit_error
  IF (fit_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
  ENDIF ELSE BEGIN
    Step2_fitCE, Event          ;_Step2
    idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
  ENDELSE
  
  ;show the scaling factor (but do not replot it)
  ;get the average Y value before
  Ybefore = getTextFieldValue(Event, 'step2_y_before_text_field') ;_get
  Yafter  = getTextFieldValue(Event, 'step2_y_after_text_field') ;_get
  idl_send_to_geek_addLogBookText, Event, '-> Ybefore : ' + $
    STRCOMPRESS(Ybefore,/REMOVE_ALL)
  idl_send_to_geek_addLogBookText, Event, '-> Yafter  : ' + $
    STRCOMPRESS(Yafter,/REMOVE_ALL)
    
  ;check if Ybefore is numeric or not
  YbeforeIsNumeric = isNumeric(Ybefore) ;_is
  YafterIsNumeric  = isNumeric(Yafter) ;_is
  
  ;Ybefore and Yafter are numeric
  IF (YbeforeIsNumeric EQ 1 AND $
    YafterIsNumeric EQ 1) THEN BEGIN
    idl_send_to_geek_addLogBookText, Event, $
      '-> Ybefore and Yafter are numeric : YES'
      
    putValueInLabel, Event, 'step2_qminqmax_error_label', '' ;_put
    
    idl_send_to_geek_addLogBookText, Event, '-> Scaling ... ' + PROCESSING
    scale_error = 0
    CATCH, scale_error
    IF (scale_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
    ENDIF ELSE BEGIN
      Step2_scaleCE, Event    ;_Step2
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
    ENDELSE
    
    ;display SF in the log book
    SF = getTextFieldValue(Event, 'step2_sf_text_field')
    idl_send_to_geek_addLogBookText, Event, $
      '-> Scaling Factor (SF) of Critcal ' + $
      'Edge (CE) File : ' + STRCOMPRESS(SF,/REMOVE_ALL)
      
    ;update the BatchTable if any
    if ((*global).BatchFileName ne '') then begin
      index_array = getIndexArrayOfActiveBatchRow(Event)
      BatchTable      = (*(*global).BatchTable)
      BatchTable[8,index_array[0]] = STRCOMPRESS(SF,/REMOVE_ALL)
      (*(*global).BatchTable) = BatchTable
      UpdateBatchTable, Event, BatchTable ;_batch
    endif
    
    (*global).force_activation_step2 = 0 ;no need to force activation of step2
    
  ENDIF ELSE BEGIN ;scaling factor can be calculated so second step (scaling)
    ;automatic mode can be performed.
    ;display message in Q1 and Q2 boxe saying that auto stopped
    putValueInLabel, Event, 'step2_qminqmax_error_label', $
      '**ERROR: Select another range of Qs**'
    idl_send_to_geek_addLogBookText, Event, $
      '-> Ybefore and Yafter are numeric : NO'
  ENDELSE
  
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  plotQs, Event, (*global).Q1x, (*global).Q2x ;_Plot
  ;check if manual widgets can be validated or not
  CheckManualModeStep2Buttons, Event
  idl_send_to_geek_showLastLineLogBook, Event
END

;##############################################################################
;******************************************************************************

PRO manualCEscaling, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  idl_send_to_geek_addLogBookText, Event, '> Manual Scaling :'
  
  ;show the scaling factor (but do not replot it)
  ;get the average Y value before and after
  Ybefore = getTextFieldValue(Event, 'step2_y_before_text_field') ;_get
  Yafter  = getTextFieldValue(Event, 'step2_y_after_text_field') ;_get
  idl_send_to_geek_addLogBookText, Event, '-> Ybefore : ' + $
    STRCOMPRESS(Ybefore,/REMOVE_ALL)
  idl_send_to_geek_addLogBookText, Event, '-> Yafter  : ' + $
    STRCOMPRESS(Yafter,/REMOVE_ALL)
    
  ;check if Ybefore is numeric or not
  YbeforeIsNumeric = isNumeric(Ybefore) ;_is
  YafterIsNumeric  = isNumeric(Yafter) ;_is
  ;Ybefore and Yafter are numeric
  IF (YbeforeIsNumeric EQ 1 AND $
    YafterIsNumeric EQ 1) THEN BEGIN
    idl_send_to_geek_addLogBookText, Event, $
      '-> Ybefore and Yafter are numeric : YES'
    putValueInLabel, Event, 'step2_qminqmax_error_label', '' ;_put
    
    idl_send_to_geek_addLogBookText, Event, '-> Scaling ... ' + PROCESSING
    scale_error = 0
    CATCH, scale_error
    IF (scale_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
    ENDIF ELSE BEGIN
      manual_Step2_scaleCE, Event, Yafter ;_Step2
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
    ENDELSE
    ;display SF in the log book
    SF = getTextFieldValue(Event, 'step2_sf_text_field')
    idl_send_to_geek_addLogBookText, Event, $
      '-> Scaling Factor (SF) of Critcal ' + $
      'Edge (CE) File : ' + STRCOMPRESS(SF,/REMOVE_ALL)
      
    ;update the BatchTable
    BatchTable = (*(*global).BatchTable)
    BatchTable[7,0] = STRCOMPRESS(SF,/REMOVE_ALL)
    (*(*global).BatchTable) = BatchTable
    
    (*global).force_activation_step2 = 0 ;no need to force activation of step2
    
  ENDIF ELSE BEGIN ;scaling factor can be calculated so second step (scaling)
    ;automatic mode can be performed.
    ;display message in Q1 and Q2 boxe saying that auto stopped
    putValueInLabel, Event, 'step2_qminqmax_error_label', $
      '**ERROR: Select another range of Qs**'
    idl_send_to_geek_addLogBookText, Event, $
      '-> Ybefore and Yafter are numeric : NO'
  ENDELSE
  idl_send_to_geek_showLastLineLogBook, Event
END

;##############################################################################
;******************************************************************************

;This function is the next step (after the fitting) to
;bring to 1 the average Q1 to Q2 part of CE
PRO manual_Step2_scaleCE, Event, Yafter
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  ;change the value of the ymax and ymin in the zoom box to 1.2 and 0
  putValueInTextField, Event, 'YaxisMaxTextField',  (Yafter + 0.2)    ;_put
  putValueInTextField, Event, 'YaxisMinTextField', (*global).rescaling_ymin ;_put
  ;Scaling Factor
  ScalingFactor = getTextFieldValue(Event,'step2_sf_text_field')
  (*global).CE_scaling_factor = float(ScalingFactor)
  ;replot CE data with new scale
  plot_rescale_CE_file, Event ;_Plot
END

;##############################################################################
;******************************************************************************

;This function is reached each time the SF text Field is edited
PRO manual_sf_editing, Event ;_Step2
  ;get the average Y value before
  Ybefore = getTextFieldValue(Event,'step2_y_before_text_field') ;_get
  ;get current scaling factor
  sf      = getTextFieldValue(Event,'step2_sf_text_field') ;_get
  sf      = sf[0]
  ;check if Ybefore is numeric or not
  YbeforeIsNumeric = isNumeric(Ybefore) ;_is
  sfIsNumeric      = isNumeric(sf) ;_is
  IF (YbeforeIsNumeric EQ 1 AND $
    sfIsNumeric EQ 1 AND $
    float(sf) NE 0) THEN BEGIN
    newYafter = FLOAT(Ybefore) / FLOAT(sf)
    newYafter = STRCOMPRESS(newYafter,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    newYafter = 'N/A'
  ENDELSE
  putValueInTextField, Event, 'step2_y_after_text_field', newYafter ;_put
END

;##############################################################################
;******************************************************************************
;This is reach when the user left click on the plot of step2
PRO Step2LeftClick, Event, XMinMax
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  (*global).left_mouse_pressed = 1
  ;replot_main_plot, Event         ;_Plot
  CURSOR, x, y, /DATA
  CASE ((*global).Q_selection) OF
    1: BEGIN
      (*global).replot_me = 1
      ActivateQSelection, Event, 1 ;show that we are working with Qmin
      saveQ, Event, Q_NUMBER = 1, x ;_Step2
      IF ((*global).Q2 NE 0) THEN BEGIN
        ;            print, 'start to plot Q1 and replot Q2'
        plot_loaded_file, Event, 'CE' ;_Plot
        plotQs, Event, x, (*global).Q2 ;_Plo
      ENDIF ELSE BEGIN
        ;            print, 'start to plot Q1'
        plot_loaded_file, Event, 'CE' ;_Plot
        ;       plotQ, Event, Event.x ;_Plot
        plotQ, Event, x
      ENDELSE
      putValueInTextField, Event, $
        'step2_q1_text_field', $
        STRCOMPRESS((*global).Q1,/REMOVE_ALL)
    END
    2: BEGIN
      (*global).replot_me = 1
      ActivateQSelection, Event, 2 ;show that we are working with Qmax
      saveQ, Event, Q_NUMBER = 2, x ;_Step2
      IF ((*global).Q1 NE 0) THEN BEGIN
        ;            print, 'start to plot Q2 and replot Q1'
        plot_loaded_file, Event, 'CE' ;_Plot
        plotQs, Event, x, (*global).Q1 ;_Plot
      ENDIF ELSE BEGIN
        ;            print, 'start to plot Q2'
        plot_loaded_file, Event, 'CE' ;_Plot
        plotQ, Event, x ;_Plot
      ENDELSE
      putValueInTextField, Event, $
        'step2_q2_text_field', $
        STRCOMPRESS((*global).Q2,/REMOVE_ALL)
    END
  ;    ELSE: BEGIN
  ;      (*global).replot_me = 1
  ;      ActivateQSelection, Event, 1 ;show that we are working with Qmin
  ;      (*global).Q_selection = 1
  ;      plot_loaded_file, Event, 'CE' ;_Plot
  ;      plotQ, Event, x   ;_Plot
  ;      ;        print, 'start to plot Q1'
  ;      saveQ, Event, Q_NUMBER = 1, x ;_Step2
  ;      putValueInTextField, Event, $
  ;        'step2_q1_text_field', $
  ;        STRCOMPRESS((*global).Q1,/REMOVE_ALL)
  ;    END
  ENDCASE
END

;##############################################################################
;******************************************************************************
;This is reach when the user right click on the plot of step2
PRO Step2RightClick, Event
  widget_control,Event.top,get_uvalue=global
  CASE ((*global).Q_selection) OF
    1: BEGIN
      ActivateQSelection, Event, 2 ;show that we are working with Qmax
      ;        print, 'Was working with 1 and will now work with 2'
      (*global).Q_selection = 2
    END
    2: BEGIN
      ActivateQSelection, Event, 1 ;show that we are working with Qmin
      ;        print, 'Was working with 2 and will now work with 1'
      (*global).Q_selection = 1
    END
    ELSE:
  ENDCASE
END

;##############################################################################
;******************************************************************************
;This is reach when the user released the button on the plot of step2
PRO Step2ReleaseClick, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  Q_selection = (*global).Q_selection
  
  ;order Q1 and Q2
  Q1 = FLOAT(getValue(event=event,uname='step2_q1_text_field'))
  Q2 = FLOAT(getValue(event=event,uname='step2_q2_text_field'))
  
  IF (Q1 GT 0 AND Q2 GT 0) THEN BEGIN
  
    CASE (Q_selection) OF
      1: BEGIN
        IF (Q1 GT Q2) THEN BEGIN ;reverse working Q
          (*global).Q_selection = 2
          ActivateQSelection, Event, 2 ;show that we are working with Qmax
        ENDIF
      END
      2: BEGIN
        IF (Q2 LT Q1) THEN BEGIN ;reverse working Q
          (*global).Q_selection = 1
          ActivateQSelection, Event, 1 ;show that we are working with Qmax
        ENDIF
      END
    ENDCASE
    
    Qmin = MIN([Q1,Q2],MAX=Qmax)
    
    putValueInTextField, Event, 'step2_q1_text_field', Qmin
    putValueInTextField, Event, 'step2_q2_text_field', Qmax
    
    (*global).Q1  = Qmin
    (*global).Q2  = Qmax
    
  ENDIF
  
  (*global).left_mouse_pressed = 0
  
  ;Check if Automatic Button can be validated or not
  CheckAutoModeStep2Button, Event
END

;##############################################################################
;******************************************************************************
;This is reach when the user moves the mouse on the plot of step2
PRO Step2MoveClick, Event, XMinMax
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;  replot_main_plot, Event         ;_Plot
  IF ((*global).left_mouse_pressed) THEN BEGIN
    CASE ((*global).Q_selection) OF
      1: BEGIN
        CURSOR, x, y, /DATA
        saveQ, Event, Q_NUMBER = 1, x ;_Step2
        (*global).replot_me = 1
        plot_loaded_file, Event, 'CE' ;_Plot
        IF ((*global).Q2 NE 0) THEN BEGIN
          plotQs, Event, x, (*global).Q2 ;_Plot
        ;          print, '-> Move Q1 plot and replot Q2'
        ENDIF ELSE BEGIN
          plotQ, Event, x ;_Plot
        ;          print, '-> Move Q1 plot'
        ENDELSE
        putValueInTextField, Event, $
          'step2_q1_text_field', $
          STRCOMPRESS((*global).Q1,/REMOVE_ALL)
      END
      2: BEGIN
        CURSOR, x, y, /data
        saveQ, Event, Q_NUMBER = 2, x ;_Step2
        (*global).replot_me = 1
        plot_loaded_file, Event, 'CE' ;_Plot
        IF ((*global).Q1 NE 0) THEN BEGIN
          plotQs, Event, (*global).Q1, x ;_Plot
        ;          print, '-> Move Q2 plot and replot Q1'
        ENDIF ELSE BEGIN
          plotQ, Event, x ;_Plot
        ;          print, '-> Move Q2 plot'
        ENDELSE
        putValueInTextField, Event, $
          'step2_q2_text_field', $
          STRCOMPRESS((*global).Q2,/REMOVE_ALL)
      END
      ELSE:
    ENDCASE
  ENDIF ELSE BEGIN ;this is where I replot the main plot and the Qs
    IF ((*global).replotQnew) THEN BEGIN
      ;      print, 'in (*global).replotQnew = 1'
      saveQxFromQ, Event, Q_NUMBER = 1 ;_Step2
    ENDIF
    IF ((*global).Q1 NE 0) THEN BEGIN
      ;      print, 'in (*global).Q1 = 1'
      plotQ, Event, (*global).Q1
    ENDIF
    IF ((*global).replotQnew) THEN BEGIN
      ;      print, 'in (*global).replotQnew = 1'
      saveQxFromQ, Event, Q_NUMBER = 2 ;_Step2
    ENDIF
    IF ((*global).Q2 NE 0) THEN BEGIN
      ;      print, 'in (*global).Q2 = 1'
      plotQ, Event, (*global).Q2
    ENDIF
    (*global).replotQnew = 0
  ENDELSE
END

;##############################################################################
;******************************************************************************

PRO saveQ,  Event, Q_NUMBER = Q_NUMBER, Q
  widget_control,event.top,get_uvalue=global
  ;calculate true Q
  IF (Q_NUMBER EQ 1) THEN BEGIN
    (*global).Q1  = Q
  ENDIF ELSE BEGIN
    (*global).Q2  = Q
  ENDELSE
END

;##############################################################################
;******************************************************************************
;This function determine what is the Qx (widget_draw x position ) of
;the Q given
PRO saveQxFromQ, Event, Q_NUMBER=Q_NUMBER
  widget_control,Event.top,get_uvalue=global
  
  ;cursor, x, y, /data
  
  ;Qx and Q
  IF (Q_NUMBER EQ 1) THEN BEGIN
    Q  = (*global).Q1
  ENDIF ELSE BEGIN
    Q  = (*global).Q2
  ENDELSE
  
  ;print, 'Q: ' + strcompress(Q)
  
  ;Xmin and Xmax
  XMinMax   = getDrawXMin(Event)
  draw_Qmin = XMinMax[0]
  draw_Qmax = XMinMax[1]
  
  ;print, 'XminMax:'
  ;print, XminMax
  
  ;X position of left and right margins
  draw_xmin = (*global).draw_xmin
  draw_xmax = (*global).draw_xmax
  
  ;Calculate Coeff
  coeff1  = (float(Q) - float(draw_Qmin))
  coeff2  = (float(draw_Qmax)-float(draw_Qmin))
  coeff   = coeff1 / coeff2
  
  ;get new X position of Q
  newX = coeff * (draw_xmax - draw_xmin) + draw_xmin
  
  IF (Q_NUMBER EQ 1) THEN BEGIN
    (*global).Q1x = newX
  ENDIF ELSE BEGIN
    (*global).Q2x = newX
  ENDELSE
  
;print, '(*global).Q1x: ' + string(newX)
  
;print, 'leaving SaveQxFromQ'
  
END

;##############################################################################
;******************************************************************************
;This function only reach during step2 when Qmin and Qmax are edited
PRO ManualNewQ, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  ;replot main plot
  (*global).replot_me = 1
  replot_main_plot, Event         ;_Plot
  ;retrieve values of Qmin and Qmax from the cw-fields
  Q1 = getValue(event=event,uname='step2_q1_text_field')
  Q2 = getValue(event=event,uname='step2_q2_text_field')
  ;save new value of Q1 and Q2
  (*global).Q1 = Q1
  (*global).Q2 = Q2
  ;calculate new position of selection
  saveQxFromQ, Event, Q_NUMBER=1
  saveQxFromQ, Event, Q_NUMBER=2
  ;replot new Qs
  IF (Q1 NE 0 AND Q2 NE 0) THEN BEGIN
    plotQs, Event, (*global).Q1, (*global).Q2 ;_Plot
  ENDIF ELSE BEGIN
    IF (Q2 EQ 0 AND Q1 NE 0) THEN BEGIN
      plotQ, Event, (*global).Q1 ;_Plot
    ENDIF
    IF (Q1 EQ 0 AND Q2 NE 0) THEN BEGIN
      plotQ, Event, (*global).Q2
    ENDIF
  ENDELSE
END

;##############################################################################
;******************************************************************************
PRO ClearStep2GlobalVariable, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  ;Qx
  (*global).Q1x = 0L
  (*global).Q2x = 0L
  ;Q
  (*global).Q1  = 0.
  (*global).Q2  = 0.
  ;X,Y
  (*global).X   = 0
  (*global).Y   = 0
END

;##############################################################################
;******************************************************************************
;This function retrieves Q1 and Q2 and replaces Qmin by the min of
;Q1,Q2 and replaces Qmax by the max of Q1,Q2
PRO SortQs, Event
  ;retrieve values of Qmin and Qmax from the cw-fields
  Q1 = getValue(event=event,uname='step2_q1_text_field')
  Q2 = getValue(event=event,uname='step2_q2_text_field')
  IF (Q1 NE 0 AND Q2 NE 0) THEN BEGIN
    Qmin = MIN([Q1,Q2],MAX=Qmax)
    putValueInTextField, Event, 'step2_q1_text_field', $
      STRCOMPRESS(Qmin,/REMOVE_ALL)
    putValueInTextField, Event, 'step2_q2_text_field', $
      STRCOMPRESS(Qmax,/REMOVE_ALL)
    ManualNewQ, Event
  ENDIF
END
