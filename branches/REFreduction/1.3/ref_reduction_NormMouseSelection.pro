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

;this function is reached when the user click on the plot (for Norm)
PRO REFreduction_NormSelectionPressLeft, event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  (*global).NormXMouseSelection = event.x
  
  ;ROI, peak, back or zoom selection
  ROISignalBackZoomStatus = isNormBackPeakZoomSelected(Event)
  CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                   ;ROI
      color   = (*global).roi_selection_color
      y_array = (*(*global).norm_roi_selection)
    END
    1: BEGIN                    ;signal
      color   = (*global).peak_selection_color
      y_array = (*(*global).norm_peak_selection)
    END
    2: BEGIN                    ;back
      color   = (*global).back_selection_color
      y_array = (*(*global).norm_back_selection)
    END
    3: BEGIN                    ;zoom
      ;be sure the data draw has been selected
      id_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='load_normalization_D_draw')
      WIDGET_CONTROL, id_draw, GET_VALUE=id_value
      WSET,id_value
    END
  ENDCASE
  
  if (ROISignalBackZoomStatus NE 3) then begin
  
    ;where to stop the plot of the lines
    ;xsize_1d_draw = (*global).Ntof_NORM-1
    xsize_1d_draw = 608L
    
    mouse_status = (*global).select_norm_status
    ;print, 'PressLeft mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
      0: Begin
        ;refresh plot
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        
        ;plot y1
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        
        y2=y_array[1]
        ;plot only if y2 is not -1
        if (y2 NE -1) then begin
          plots, 0, y2, /device, color=color
          plots, xsize_1d_draw, y2, /device, /continue, color=color
        endif
        
        mouse_status_new = 1
        
        UpDownMessage = (*global).UpDownMessage
        putTextFieldValue, event, 'NORM_left_interaction_help_text', $
          UpDownMessage, 0
          
      END
      1:  mouse_status_new = mouse_status
      2:  mouse_status_new = mouse_status
      3: Begin
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        
        y1 = y_array[0]
        ;plot only if y1 is not -1
        if (y1 NE -1) then begin
          plots, 0, y1, /device, color=color
          plots, xsize_1d_draw, y1, /device, /continue, color=color
        endif
        
        ;plot y2
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = 4
        
        UpDownMessage = (*global).UpDownMessage
        putTextFieldValue, event, 'NORM_left_interaction_help_text', $
          UpDownMessage, 0
          
      end
      4:mouse_status_new = mouse_status
      5:  Begin
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        
        y1 = y_array[0]
        
        ;plot only if y1 is not -1
        if (y1 NE -1) then begin
          plots, 0, y1, /device, color=color
          plots, xsize_1d_draw, y1, /device, /continue, color=color
        endif
        
        ;plot y2
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = 4
        
        UpDownMessage = (*global).UpDownMessage
        putTextFieldValue, event, $
          'NORM_left_interaction_help_text', $
          UpDownMessage, 0
          
      END
    ENDCASE
    
    ;This function replot the other selection
    ReplotNormOtherSelection, Event, ROIsignalBackZoomStatus
    
    (*global).select_norm_status = mouse_status_new
    
    ;update Back and Peak Ymin and Ymax cw_fields of Data
    putNormBackgroundPeakYMinMaxValueInTextFields, Event
    
  ENDIF ELSE BEGIN ;zoom selected
  
    ;validate zoom display
    SetTabCurrent, $
      Event, $
      'normalization_nxsummary_zoom_tab', $
      1
      
    RefReduction_zoom, $
      Event, $
      MouseX = event.x, $
      MouseY = event.y, $
      fact   = (*global).NormalizationZoomFactor,$
      uname  = 'normalization_zoom_draw'
      
  ENDELSE
  
  (*global).select_norm_zoom_status = 1
  
END




PRO REFreduction_NormSelectionPressRight, event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;ROI, peak, back or zoom selection
  ROISignalBackZoomStatus = isNormBackPeakZoomSelected(Event)
  CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                   ;ROI
      color   = (*global).roi_selection_color
      y_array = (*(*global).norm_roi_selection)
    END
    1: BEGIN                    ;signal
      color   = (*global).peak_selection_color
      y_array = (*(*global).norm_peak_selection)
    END
    2: BEGIN                    ;back
      color   = (*global).back_selection_color
      y_array = (*(*global).norm_back_selection)
    END
    3: BEGIN                    ;zoom
      ;be sure the data draw has been selected
      id_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='load_normalization_D_draw')
      WIDGET_CONTROL, id_draw, GET_VALUE=id_value
      WSET,id_value
    END
  ENDCASE
  
  IF (ROISignalBackZoomStatus NE 3) THEN BEGIN
  
    ;replot main plot
    REFReduction_RescaleNormalizationPlot,Event
    
    ;where to stop the plot of the lines
    ;xsize_1d_draw = (*global).Ntof_NORM - 1
    xsize_1d_draw = 608L
    
    mouse_status = (*global).select_norm_status
    ;print, 'PressRight mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
      0: BEGIN
        mouse_status_new = 3
      END
      1:  mouse_status_new = mouse_status
      2: mouse_status_new = mouse_status
      3: mouse_status_new = 0
      4: mouse_status_new = mouse_status
      5: mouse_status_new = 0
    ENDCASE
    
    ;Replot other selections
    ReplotNormAllSelection, Event
    
    ;Switch Ymin and Ymax message label
    SwitchNormYminYmaxLabel, Event ;_GUI
    
    (*global).select_norm_status = mouse_status_new
    
    ;update Back and Peak Ymin and Ymax cw_fields
    putNormBackgroundPeakYMinMaxValueInTextFields, Event
    
  ENDIF
  
END


;this function is reached when the mouse moved into the widget_draw
PRO REFreduction_NormSelectionMove, event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;ROI, peak, back or zoom selection
  ROISignalBackZoomStatus = isNormBackPeakZoomSelected(Event)
  CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;back or ROI
      color   = (*global).roi_selection_color
      y_array = (*(*global).norm_roi_selection)
    END
    1: BEGIN                    ;signal
      color   = (*global).peak_selection_color
      y_array = (*(*global).norm_peak_selection)
    END
    2: BEGIN                    ;back
      color   = (*global).back_selection_color
      y_array = (*(*global).norm_back_selection)
    END
    3: BEGIN                    ;zoom
    END
  ENDCASE
  
  IF (ROISignalBackZoomStatus NE 3) THEN BEGIN
  
    ;where to stop the plot of the lines
    ;xsize_1d_draw = (*global).Ntof_NORM - 1
    xsize_1d_draw = 608L
    
    mouse_status = (*global).select_norm_status
    ;print, 'Move mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
      0:mouse_status_new = mouse_status
      1: Begin
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        mouse_status_new = mouse_status
        
        y2 = y_array[1]
        if (y2 NE -1) then begin
          plots, 0, y2, /device, color=color
          plots, xsize_1d_draw, y2, /device, /continue, color=color
        endif
        
        ;refresh plot
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
      END
      2:mouse_status_new = mouse_status
      3: Begin
        ;refresh plot
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        mouse_status_new = mouse_status
        
        y1 = y_array[0]
        if (y1 NE -1) then begin
          plots, 0, y1, /device, color=color
          plots, xsize_1d_draw, y1, /device, /continue, color=color
        endif
      END
      4: Begin
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        
        y1 = y_array[0]
        if (y1 NE -1) then begin
          plots, 0, y1, /device, color=color
          plots, xsize_1d_draw, y1, /device, /continue, color=color
        endif
        
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = mouse_status
      END
      5:mouse_status_new = mouse_status
    endcase
    
    ;This function replot the other selection
    ReplotNormOtherSelection, Event, ROIsignalBackZoomStatus
    
  ENDIF ELSE BEGIN                ;Zoom selected
  
    IF ((*global).select_norm_zoom_status) THEN BEGIN
    
      ;      validate zoom display
      SetTabCurrent, $
        Event, $
        'normalization_nxsummary_zoom_tab', $
        1
        
      RefReduction_zoom, $
        Event, $
        MouseX = event.x, $
        MouseY = event.y, $
        fact   = (*global).DataZoomFactor,$
        uname  = 'normalization_zoom_draw'
        
    ENDIF
    
  ENDELSE
  
END




PRO REFreduction_NormSelectionRelease, event
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;ROI, peak, back or zoom selection
  ROISignalBackZoomStatus = isNormBackPeakZoomSelected(Event)
  CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;back or ROI
      color   = (*global).roi_selection_color
      y_array = (*(*global).norm_roi_selection)
    END
    1: BEGIN                    ;signal
      color   = (*global).peak_selection_color
      y_array = (*(*global).norm_peak_selection)
    END
    2: BEGIN                    ;back
      color   = (*global).back_selection_color
      y_array = (*(*global).norm_back_selection)
    END
    3: BEGIN                    ;zoom
    END
  ENDCASE
  
  mouse_status_new = (*global).select_norm_status
  mouse_status     = mouse_status_new
  
  IF (ROISignalBackZoomStatus NE 3) THEN BEGIN
  
    ;where to stop the plot of the lines
    ;xsize_1d_draw = (*global).Ntof_NORM - 1
    xsize_1d_draw = 608L
    
    ;print, 'Release mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
      0:mouse_status_new = mouse_status
      1: Begin
        ;refresh plot
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        mouse_status_new = 0
        ;get y mouse
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        
        y2 = y_array[1]
        if (y2 NE -1) then begin
          plots, 0, y2, /device, color=color
          plots, xsize_1d_draw, y2, /device, /continue, color=color
        endif
        
        y_array = [y,y2]
      END
      2:mouse_status_new = mouse_status
      3: mouse_status_new = mouse_status
      4: Begin
        REFReduction_RescaleNormalizationPlot,Event
        ;            RePlot1DNormFile, Event
        
        y1 = y_array[0]
        if (y1 NE -1) then begin
          plots, 0, y1, /device, color=color
          plots, xsize_1d_draw, y1, /device, /continue, color=color
        endif
        
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        y_array = [y1,y]
        mouse_status_new = 5
      END
      5:mouse_status_new = mouse_status
    endcase
    
    (*global).select_norm_zoom_status = 0
    
  ENDIF
  
  CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;ROI
      (*(*global).norm_roi_selection) = y_array
    END
    1: BEGIN                    ;signal
      (*(*global).norm_peak_selection) = y_array
      ymin = min(y_array,max=ymax)
      ;populate exclusion peak low and high bin
      putTextFieldValue,$
        Event,$
        'norm_d_selection_peak_ymin_cw_field',$
        strcompress(ymin/2,/remove_all),$
        0                     ;do not append
      putTextFieldValue,$
        Event,$
        'norm_d_selection_peak_ymax_cw_field',$
        strcompress(ymax/2,/remove_all),$
        0                     ;do not append
    END
    2: BEGIN                    ;back
      (*(*global).norm_back_selection) = y_array
    END
    3: BEGIN
      IF ((*global).select_norm_zoom_status) THEN BEGIN
        RefReduction_zoom, $
          Event, $
          MouseX = event.x, $
          MouseY = event.y, $
          fact   = (*global).NormalizationZoomFactor,$
          uname  = 'normalization_zoom_draw'
        (*global).select_norm_zoom_status = 0
      ENDIF
    END
  ENDCASE
  
  ReplotNormOtherSelection, Event, ROIsignalBackZoomStatus
  (*global).select_norm_status = mouse_status_new
  
  ;update Back and Peak Ymin and Ymax cw_fields
  putNormBackgroundPeakYMinMaxValueInTextFields, Event
  
END


;------------------------------------------------------------------------------
;This function replot all the other selection
PRO ReplotNormOtherSelection, Event, ROIsignalBackZoomStatus
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;where to stop the plot of the lines
  ;xsize_1d_draw = (*global).Ntof_NORM-1
  xsize_1d_draw = 608L
  
  ;check if user wants peak or background
  isPeakSelected = isNormPeakSelected(Event)
  
  id_draw = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='load_normalization_D_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;roi
      replot_roi  = 0
      IF (isPeakSelected) THEN BEGIN
        replot_peak = 1
        replot_back = 0
      ENDIF ELSE BEGIN
        replot_peak = 0
        replot_back = 1
      ENDELSE
    END
    1: BEGIN                    ;peak
      replot_roi  = 1
      replot_peak = 0
      replot_back = 0
    END
    2: BEGIN                    ;background
      replot_roi  = 1
      replot_peak = 0
      replot_back = 0
    END
    3: BEGIN                    ;display zoom if zoom tab is selected
      replot_roi  = 0
      replot_peak = 0
      replot_back = 0
      IF ((*global).select_norm_zoom_status) THEN BEGIN
        RefReduction_zoom, $
          Event, $
          MouseX = event.x, $
          MouseY = event.y, $
          fact   = (*global).NormalizationZoomFactor,$
          uname  = 'normalization_zoom_draw'
      ENDIF
    END
  ENDCASE
  
  IF (replot_roi) THEN BEGIN
    color   = (*global).roi_selection_color
    y_array = (*(*global).norm_roi_selection)
    IF (y_array[0] NE -1) THEN BEGIN
      PLOTS, 0, y_array[0], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[0], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
    IF (y_array[1] NE -1) THEN BEGIN
      PLOTS, 0, y_array[1], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[1], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
  ENDIF
  
  IF (replot_peak) THEN BEGIN
    color = (*global).peak_selection_color
    y_array = (*(*global).norm_peak_selection)
    IF (y_array[0] NE -1) THEN BEGIN
      PLOTS, 0, y_array[0], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[0], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
    IF (y_array[1] NE -1) THEN BEGIN
      PLOTS, 0, y_array[1], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[1], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
  ENDIF
  
  IF (replot_back) THEN BEGIN
    color = (*global).back_selection_color
    y_array = (*(*global).norm_back_selection)
    IF (y_array[0] NE -1) THEN BEGIN
      PLOTS, 0, y_array[0], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[0], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
    IF (y_array[1] NE -1) THEN BEGIN
      PLOTS, 0, y_array[1], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[1], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
  ENDIF
  
  ;plot zoom if zoom tab is selected
  IF (isNormZoomTabSelected(Event) AND $
    ROISignalBackZoomStatus NE 3 AND $
    (*global).select_norm_zoom_status) THEN BEGIN
    RefReduction_zoom, $
      Event, $
      MouseX = event.x, $
      MouseY = event.y, $
      fact   = (*global).NormalizationZoomFactor,$
      uname  = 'normalization_zoom_draw'
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO ReplotNormAllSelection, Event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;where to stop the plot of the lines
  ;xsize_1d_draw = (*global).Ntof_NORM-1
  xsize_1d_draw = 608L
  
  ;check if user wants peak or background
  isPeakSelected = isNormPeakSelected(Event)
  
  id_draw = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='load_normalization_D_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  color   = (*global).roi_selection_color
  y_array = (*(*global).norm_roi_selection)
  IF (y_array[0] NE -1) THEN BEGIN
    PLOTS, 0, y_array[0], /DEVICE, COLOR=color
    PLOTS, xsize_1d_draw, y_array[0], $
      /DEVICE, $
      /CONTINUE, $
      COLOR=color
  ENDIF
  IF (y_array[1] NE -1) THEN BEGIN
    PLOTS, 0, y_array[1], /DEVICE, COLOR=color
    PLOTS, xsize_1d_draw, y_array[1], $
      /DEVICE, $
      /CONTINUE, $
      COLOR=color
  ENDIF
  
  IF (isPeakSelected) THEN BEGIN
    color = (*global).peak_selection_color
    y_array = (*(*global).norm_peak_selection)
    IF (y_array[0] NE -1) THEN BEGIN
      PLOTS, 0, y_array[0], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[0], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
    IF (y_array[1] NE -1) THEN BEGIN
      PLOTS, 0, y_array[1], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[1], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
  ENDIF ELSE BEGIN
    color = (*global).back_selection_color
    y_array = (*(*global).norm_back_selection)
    IF (y_array[0] NE -1) THEN BEGIN
      PLOTS, 0, y_array[0], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[0], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
    IF (y_array[1] NE -1) THEN BEGIN
      PLOTS, 0, y_array[1], /DEVICE, COLOR=color
      PLOTS, xsize_1d_draw, y_array[1], $
        /DEVICE, $
        /CONTINUE, $
        COLOR=color
    ENDIF
  ENDELSE
  
  ROISignalBackZoomStatus = isNormBackPeakZoomSelected(Event)
  ;plot zoom if zoom tab is selected
  IF (isNormZoomTabSelected(Event) AND $
    ROIsignalBackZoomStatus NE 3 AND $
    (*global).select_norm_zoom_status) THEN BEGIN
    RefReduction_zoom, $
      Event, $
      MouseX = event.x, $
      MouseY = event.y, $
      fact   = (*global).NormalizationZoomFactor,$
      uname  = 'normalization_zoom_draw'
  ENDIF
  
END

