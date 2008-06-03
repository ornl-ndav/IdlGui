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

;this function is reached when the user click on the plot
PRO REFreduction_DataSelectionPressLeft, event

;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

(*global).DataXMouseSelection = event.x

;ROI, peak, back or zoom selection
ROISignalBackZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;back or ROI
        color   = (*global).roi_selection_color
        y_array = (*(*global).data_roi_selection)
    END
    1: BEGIN                    ;signal
        color   = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    END
    2: BEGIN                    ;back
        color   = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    END
    3: BEGIN                    ;zoom
;be sure the data draw has been selected
        id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME='load_data_D_draw')
        WIDGET_CONTROL, id_draw, GET_VALUE=id_value
        WSET,id_value
    END
ENDCASE

IF (ROISignalBackZoomStatus NE 3) THEN BEGIN
    
;where to stop the plot of the lines
    xsize_1d_draw = (*global).Ntof_DATA-1
    
    mouse_status = (*global).select_data_status
;print, 'PressLeft mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
        0: Begin
;refresh plot
            RePlot1DDataFile, Event
            
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
            putTextFieldValue, event, $
              'DATA_left_interaction_help_text', $
              UpDownMessage, 0

        END
        1:  mouse_status_new = mouse_status
        2:  mouse_status_new = mouse_status
        3: Begin
            RePlot1DDataFile, Event
            
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
              'DATA_left_interaction_help_text', $
              UpDownMessage, 0

        end
        4:mouse_status_new = mouse_status
        5:  Begin
            RePlot1DDataFile, Event
            
            y1 = y_array[0]
;plot only if y1 is not -1
            if (y1 NE -1) then begin
                plots, 0, y1, /device, color=color
                plots, xsize_1d_draw, y1, /device, /continue, color=color
            endif
            
            y=event.y
            plots, 0, y, /device, color=color
            plots, xsize_1d_draw, y, /device, /continue, color=color
            
            mouse_status_new = 4

            UpDownMessage = (*global).UpDownMessage
            putTextFieldValue, event, $
              'DATA_left_interaction_help_text', $
              UpDownMessage, 0

        end
    endcase

;This function replot the other selection 
    ReplotOtherSelection, Event, ROIsignalBackZoomStatus

    (*global).select_data_status = mouse_status_new
    
;update Back and Peak Ymin and Ymax cw_fields of Data
    putDataBackgroundPeakYMinMaxValueInTextFields, Event

ENDIF ELSE BEGIN                ;Zoom selected
    
    ;validate zoom display
     SetTabCurrent, $
       Event, $
       'data_nxsummary_zoom_tab', $
       1
    
     RefReduction_zoom, $
       Event, $
       MouseX = event.x, $
       MouseY = event.y, $
       fact   = (*global).DataZoomFactor,$
       uname  = 'data_zoom_draw'
 
ENDELSE

(*global).select_zoom_status = 1

END




PRO REFreduction_DataSelectionPressRight, event

;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

;ROI, peak, back or zoom selection
ROISignalBackZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;back or ROI
        color   = (*global).roi_selection_color
        y_array = (*(*global).data_roi_selection)
    END
    1: BEGIN                    ;signal
        color   = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    END
    2: BEGIN                    ;back
        color   = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    END
    3: BEGIN                    ;zoom
    END
ENDCASE

IF (ROISignalBackZoomStatus NE 3) THEN BEGIN

    RePlot1DDataFile, Event
    
;where to stop the plot of the lines
    xsize_1d_draw = (*global).Ntof_DATA-1
    
    mouse_status = (*global).select_data_status
;print, 'PressRight mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
        0: BEGIN
            mouse_status_new = 3
        END
        1: mouse_status_new = mouse_status
        2: mouse_status_new = mouse_status
        3: mouse_status_new = 0
        4: mouse_status_new = mouse_status
        5: mouse_status_new = 0
    ENDCASE

;replot other selections    
ReplotAllSelection, Event

;Switch Ymin and Ymax message label
SwitchDataYminYmaxLabel, Event ;_GUI

; ROI
;     color = (*global).roi_selection_color
;     y_array = (*(*global).data_roi_selection)
    
;     IF (y_array[0] NE -1) THEN BEGIN
;         PLOTS, 0, y_array[0], /DEVICE, COLOR=color
;         PLOTS, xsize_1d_draw, y_array[0], /DEVICE, /CONTINUE, COLOR=color
;     ENDIF
    
;     IF (y_array[1] NE -1) THEN BEGIN
;         PLOTS, 0, y_array[1], /DEVICE, COLOR=color
;         PLOTS, xsize_1d_draw, y_array[1], /DEVICE, /CONTINUE, COLOR=color
;     ENDIF

; peak
;     color = (*global).peak_selection_color
;     y_array = (*(*global).data_peak_selection)
    
;     IF (y_array[0] NE -1) THEN BEGIN
;         PLOTS, 0, y_array[0], /DEVICE, COLOR=color
;         PLOTS, xsize_1d_draw, y_array[0], /DEVICE, /CONTINUE, COLOR=color
;     ENDIF
    
;     IF (y_array[1] NE -1) THEN BEGIN
;         PLOTS, 0, y_array[1], /DEVICE, COLOR=color
;         PLOTS, xsize_1d_draw, y_array[1], /DEVICE, /CONTINUE, COLOR=color
;     ENDIF

; back
;     color = (*global).back_selection_color
;     y_array = (*(*global).data_back_selection)
    
;     IF (y_array[0] NE -1) THEN BEGIN
;         PLOTS, 0, y_array[0], /DEVICE, COLOR=color
;         PLOTS, xsize_1d_draw, y_array[0], /DEVICE, /CONTINUE, COLOR=color
;     ENDIF
    
;     IF (y_array[1] NE -1) THEN BEGIN
;         PLOTS, 0, y_array[1], /DEVICE, COLOR=color
;         PLOTS, xsize_1d_draw, y_array[1], /DEVICE, /CONTINUE, COLOR=color
;     ENDIF
    
    (*global).select_data_status = mouse_status_new
    
;update Back and Peak Ymin and Ymax cw_fields
    putDataBackgroundPeakYMinMaxValueInTextFields, Event
    
endif ;end of not zoom selected

END







;this function is reached when the mouse moved into the widget_draw
PRO REFreduction_DataSelectionMove, event

;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

;ROI, peak, back or zoom selection
ROISignalBackZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;back or ROI
        color   = (*global).roi_selection_color
        y_array = (*(*global).data_roi_selection)
    END
    1: BEGIN                    ;signal
        color   = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    END
    2: BEGIN                    ;back
        color   = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    END
    3: BEGIN                    ;zoom
    END
ENDCASE

IF (ROISignalBackZoomStatus NE 3) then begin

;where to stop the plot of the lines
    xsize_1d_draw = (*global).Ntof_DATA-1
    
    mouse_status = (*global).select_data_status
;print, 'Move mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
        0:mouse_status_new = mouse_status
        1: Begin
            RePlot1DDataFile, Event
            mouse_status_new = mouse_status
            
;check if y2 is not -1
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
            RePlot1DDataFile, Event
            mouse_status_new = mouse_status
            
;check if y1 is not -1
            y1 = y_array[0]
            if (y1 NE -1) then begin
                plots, 0, y1, /device, color=color
                plots, xsize_1d_draw, y1, /device, /continue, color=color
            endif
            
        END
        4: Begin
            RePlot1DDataFile, Event
            
;check if y1 is not -1
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
    ENDCASE
    
;This function replot the other selection 
    ReplotOtherSelection, Event, ROIsignalBackZoomStatus

ENDIF ELSE BEGIN                ;Zoom selected
    
    IF ((*global).select_zoom_status) THEN BEGIN
        
;      validate zoom display
        SetTabCurrent, $
          Event, $
          'data_nxsummary_zoom_tab', $
          1
        
        RefReduction_zoom, $
          Event, $
          MouseX = event.x, $
          MouseY = event.y, $
          fact   = (*global).DataZoomFactor,$
          uname  = 'data_zoom_draw'
        
    ENDIF
    
ENDELSE

END




PRO REFreduction_DataSelectionRelease, event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;ROI, peak, back or zoom selection
ROISignalBackZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;back or ROI
        color   = (*global).roi_selection_color
        y_array = (*(*global).data_roi_selection)
    END
    1: BEGIN                    ;signal
        color   = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    END
    2: BEGIN                    ;back
        color   = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    END
    3: BEGIN                    ;zoom
    END
ENDCASE

mouse_status_new = (*global).select_data_status
mouse_status     = mouse_status_new

IF (ROISignalBackZoomStatus NE 3) then begin

;where to stop the plot of the lines
    xsize_1d_draw = (*global).Ntof_DATA-1
    
;print, 'Release mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
        0:mouse_status_new = mouse_status
        1: Begin
;refresh plot
            RePlot1DDataFile, Event
            mouse_status_new = 0
;get y mouse
            y=event.y
            plots, 0, y, /device, color=color
            plots, xsize_1d_draw, y, /device, /continue, color=color
            
;check if y2 is not -1
            y2 = y_array[1]
            if (y2 NE -1) then begin
                plots, 0, y2, /device, color=color
                plots, xsize_1d_draw, y2, /device, /continue, color=color
            endif
            
            y_array = [y,y2]
        END
        2: mouse_status_new = mouse_status
        3: mouse_status_new = mouse_status
        4: Begin
            RePlot1DDataFile, Event
            
;check if y1 is not -1
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
    ENDCASE

    (*global).select_zoom_status = 0

ENDIF

CASE (ROISignalBackZoomStatus) OF
    0: BEGIN                    ;ROI
         (*(*global).data_roi_selection) = y_array
;         color = (*global).roi_selection_color
;         y_array = (*(*global).data_roi_selection)
;         IF (y_array[0] NE -1) THEN BEGIN
;             PLOTS, 0, y_array[0], /DEVICE, COLOR=color
;             PLOTS, xsize_1d_draw, y_array[0], /DEVICE, /CONTINUE, COLOR=color
;         ENDIF
;         IF (y_array[1] NE -1) THEN BEGIN
;             PLOTS, 0, y_array[1], /DEVICE, COLOR=color
;             PLOTS, xsize_1d_draw, y_array[1], /DEVICE, /CONTINUE, COLOR=color
;         ENDIF
    END
    1: BEGIN                    ;signal
        (*(*global).data_peak_selection) = y_array
        ymin = min(y_array,max=ymax)
;populate exclusion peak low and high bin
        putTextFieldValue,$
          Event,$
          'data_d_selection_peak_ymin_cw_field',$
          strcompress(ymin/2,/remove_all),$
          0                     ;do not append
        putTextFieldValue,$
          Event,$
          'data_d_selection_peak_ymax_cw_field',$
          strcompress(ymax/2,/remove_all),$
          0                     ;do not append
;         color = (*global).back_selection_color
;         y_array = (*(*global).data_back_selection)
;         IF (y_array[0] NE -1) THEN BEGIN
;             PLOTS, 0, y_array[0], /DEVICE, COLOR=color
;             PLOTS, xsize_1d_draw, y_array[0], $
;               /DEVICE, $
;               /CONTINUE, $
;               COLOR=color
;         ENDIF
;         IF (y_array[1] NE -1) THEN BEGIN
;             PLOTS, 0, y_array[1], /DEVICE, COLOR=color
;             PLOTS, xsize_1d_draw, y_array[1], $
;               /DEVICE, $
;               /CONTINUE, $
;               COLOR=color
;        ENDIF
    END
    2: BEGIN                    ;back
         (*(*global).data_back_selection) = y_array
;         color = (*global).peak_selection_color
;         y_array = (*(*global).data_peak_selection)
;         IF (y_array[0] NE -1) THEN BEGIN
;             PLOTS, 0, y_array[0], /DEVICE, COLOR=color
;             PLOTS, xsize_1d_draw, y_array[0], /DEVICE, /CONTINUE, COLOR=color
;         ENDIF
;         IF (y_array[1] NE -1) THEN BEGIN
;             PLOTS, 0, y_array[1], /DEVICE, COLOR=color
;             PLOTS, xsize_1d_draw, y_array[1], /DEVICE, /CONTINUE, COLOR=color
;         ENDIF
    END
    3: BEGIN
        IF ((*global).select_zoom_status) THEN BEGIN
            RefReduction_zoom, $
              Event, $
              MouseX = event.x, $
              MouseY = event.y, $
              fact   = (*global).DataZoomFactor,$
              uname  = 'data_zoom_draw'
            (*global).select_zoom_status = 0
        ENDIF
    END
ENDCASE

ReplotOtherSelection, Event, ROIsignalBackZoomStatus
(*global).select_data_status = mouse_status_new
;update Back and Peak Ymin and Ymax cw_fields
putDataBackgroundPeakYMinMaxValueInTextFields, Event

END


;------------------------------------------------------------------------------
;This function replot all the other selection
PRO ReplotOtherSelection, Event, ROIsignalBackZoomStatus
;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

;where to stop the plot of the lines
xsize_1d_draw = (*global).Ntof_DATA-1

;check if user wants peak or background
isPeakSelected = isDataPeakSelected(Event) 

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
        IF ((*global).select_zoom_status) THEN BEGIN
            RefReduction_zoom, $
              Event, $
              MouseX=event.x, $
              MouseY=event.y, $
              fact=(*global).DataZoomFactor,$
              uname ='data_zoom_draw'
        ENDIF
    END
ENDCASE

IF (replot_roi) THEN BEGIN
    color   = (*global).roi_selection_color
    y_array = (*(*global).data_roi_selection)
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
    y_array = (*(*global).data_peak_selection)
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
    y_array = (*(*global).data_back_selection)
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
IF (isDataZoomTabSelected(Event) AND $
    ROISignalBackZoomStatus NE 3 AND $
    (*global).select_zoom_status) THEN BEGIN
    RefReduction_zoom, $
      Event, $
      MouseX = event.x, $
      MouseY = event.y, $
      fact   = (*global).DataZoomFactor,$
      uname  = 'data_zoom_draw'
ENDIF
    
END

;------------------------------------------------------------------------------
PRO ReplotAllSelection, Event

;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

;where to stop the plot of the lines
xsize_1d_draw = (*global).Ntof_DATA-1

;check if user wants peak or background
isPeakSelected = isDataPeakSelected(Event) 

color   = (*global).roi_selection_color
y_array = (*(*global).data_roi_selection)
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
    y_array = (*(*global).data_peak_selection)
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
    y_array = (*(*global).data_back_selection)
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

ROISignalBackZoomStatus = isDataBackPeakZoomSelected(Event)
;plot zoom if zoom tab is selected
IF (isDataZoomTabSelected(Event) AND $
    ROIsignalBackZoomStatus NE 3 AND $
    (*global).select_zoom_status) THEN BEGIN
    RefReduction_zoom, $
      Event, $
      MouseX = event.x, $
      MouseY = event.y, $
      fact   = (*global).DataZoomFactor,$
      uname  = 'data_zoom_draw'
ENDIF

END
