;this function is reached when the user click on the plot
PRO REFreduction_DataSelectionPressLeft, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;signal, peak or zoom selection
BackSignalZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (BackSignalZoomStatus) OF
    0: begin ;back
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    end
    1: begin ;signal
        color = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    end
    2: begin ;zoom
    end
ENDCASE

if (BackSignalZoomStatus NE 2) then begin
    
    isPeakSelected = isDataPeakSelectionSelected(Event)

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
        end
    endcase
    
    if (isPeakSelected) then begin ;peak selection
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
        
        if (y_array[0] NE -1) then begin
            plots, 0, y_array[0], /device, color=color
            plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
        endif
        
        if (y_array[1] NE -1) then begin
            plots, 0, y_array[1], /device, color=color
            plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
        endif
        
    endif else begin            ;background selection
        color = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
        
        if (y_array[0] NE -1) then begin
            plots, 0, y_array[0], /device, color=color
            plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
        endif
        
        if (y_array[1] NE -1) then begin
            plots, 0, y_array[1], /device, color=color
            plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
        endif
        
    endelse
    
;display zoom if zomm tab is selected
    if (isDataZoomTabSelected(Event)) then begin
        RefReduction_zoom, $
          Event, $
          MouseX=event.x, $
          MouseY=event.y, $
          fact=(*global).DataZoomFactor,$
          uname='data_zoom_draw'
    endif
    
    (*global).select_data_status = mouse_status_new
    
;update Back and Peak Ymin and Ymax cw_fields of Data
    putDataBackgroundPeakYMinMaxValueInTextFields, Event
    
endif else begin                ;Zoom selected
    
    ;validate zoom display
    SetTabCurrent, $
      Event, $
      'data_nxsummary_zoom_tab', $
      1
    
    RefReduction_zoom, $
      Event, $
      MouseX=event.x, $
      MouseY=event.y, $
      fact=(*global).DataZoomFactor,$
      uname='data_zoom_draw'

    (*global).select_zoom_status = 1
    
endelse

END




PRO REFreduction_DataSelectionPressRight, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;signal, peak or zoom selection
BackSignalZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (BackSignalZoomStatus) OF
    0: begin ;back
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    end
    1: begin ;signal
        color = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    end
    2: begin ;zoom
    end
ENDCASE

if (BackSignalZoomStatus NE 2) then begin

    isPeakSelected = isDataPeakSelectionSelected(Event)

    RePlot1DDataFile, Event
    
;where to stop the plot of the lines
    xsize_1d_draw = (*global).Ntof_DATA-1
    
    mouse_status = (*global).select_data_status
;print, 'PressRight mouse_status: ' + strcompress(mouse_status)
    CASE (mouse_status) OF
        0: begin
            mouse_status_new = 3
        end
        1:  mouse_status_new = mouse_status
        2: mouse_status_new = mouse_status
        3: mouse_status_new = 0
        4: mouse_status_new = mouse_status
        5: mouse_status_new = 0
    endcase
    
    isPeakSelected = isDataPeakSelectionSelected(Event)
    
;back
    color = (*global).back_selection_color
    y_array = (*(*global).data_back_selection)
    
    if (y_array[0] NE -1) then begin
        plots, 0, y_array[0], /device, color=color
        plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    endif
    
    if (y_array[1] NE -1) then begin
        plots, 0, y_array[1], /device, color=color
        plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
    endif
    
;peak
    color = (*global).peak_selection_color
    y_array = (*(*global).data_peak_selection)
    
    if (y_array[0] NE -1) then begin
        plots, 0, y_array[0], /device, color=color
        plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    endif
    
    if (y_array[1] NE -1) then begin
        plots, 0, y_array[1], /device, color=color
        plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
    endif
    
    (*global).select_data_status = mouse_status_new
    
;reverse Ymin and Ymax label frame
    RefReduction_UpdateDataNormGui_reverseDataYminYmaxLabelsFrame, Event
    
;update Back and Peak Ymin and Ymax cw_fields
    putDataBackgroundPeakYMinMaxValueInTextFields, Event
    
endif ;end of not zoom selected

END



;this function is reached when the mouse moved into the widget_draw
PRO REFreduction_DataSelectionMove, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;signal, peak or zoom selection
BackSignalZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (BackSignalZoomStatus) OF
    0: begin ;back
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    end
    1: begin ;signal
        color = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    end
    2: begin ;zoom
    end
ENDCASE

if (BackSignalZoomStatus NE 2) then begin

    isPeakSelected = isDataPeakSelectionSelected(Event)

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
    endcase
    
    if (isPeakSelected) then begin ;peak selection
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
        
        if (y_array[0] NE -1) then begin
            plots, 0, y_array[0], /device, color=color
            plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
        endif
        
        if (y_array[1] NE -1) then begin
            plots, 0, y_array[1], /device, color=color
            plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
        endif
        
    endif else begin            ;background selection
        color = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
        
        if (y_array[0] NE -1) then begin
            plots, 0, y_array[0], /device, color=color
            plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
        endif
        
        if (y_array[1] NE -1) then begin
            plots, 0, y_array[1], /device, color=color
            plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
        endif
        
    endelse
    
    switch (mouse_status) OF
        1:
        4:begin
;display zoom if zomm tab is selected
            if (isDataZoomTabSelected(Event)) then begin
                RefReduction_zoom, $
                  Event, $
                  MouseX=event.x, $
                  MouseY=event.y, $
                  fact=(*global).DataZoomFactor,$
                  uname='data_zoom_draw'
            endif
        end
        else:
    endswitch
    
;update Back and Peak Ymin and Ymax cw_fields
    putDataBackgroundPeakYMinMaxValueInTextFields, Event

endif else begin                     ;zoom selected

    CASE ((*global).select_zoom_status) OF
        1: begin
            RefReduction_zoom, $
              Event, $
              MouseX=event.x, $
              MouseY=event.y, $
              fact=(*global).DataZoomFactor,$
              uname='data_zoom_draw'
        end
        else:
    ENDCASE
            
endelse

END




PRO REFreduction_DataSelectionRelease, event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;signal, peak or zoom selection
BackSignalZoomStatus = isDataBackPeakZoomSelected(Event)
CASE (BackSignalZoomStatus) OF
    0: begin ;back
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
    end
    1: begin ;signal
        color = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
    end
    2: begin ;zoom
    end
ENDCASE

if (BackSignalZoomStatus NE 2) then begin

    isPeakSelected = isDataPeakSelectionSelected(Event)

;where to stop the plot of the lines
    xsize_1d_draw = (*global).Ntof_DATA-1
    
    mouse_status = (*global).select_data_status
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
        2:mouse_status_new = mouse_status
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
    endcase
    
;signal or peak selection
    if (isPeakSelected) then begin ;peak selection
        (*(*global).data_peak_selection) = y_array
        
        ymin = min(y_array,max=ymax)
        
                                ;populate exclusion peak low and high bin
        putTextFieldValue,$
          Event,$
          'data_exclusion_low_bin_text',$
          strcompress(ymin/2,/remove_all),$
          0                     ;do not append
        
        putTextFieldValue,$
          Event,$
          'data_exclusion_high_bin_text',$
          strcompress(ymax/2,/remove_all),$
          0                     ;do not append
        
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
        
        if (y_array[0] NE -1) then begin
            plots, 0, y_array[0], /device, color=color
            plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
        endif
        
        if (y_array[1] NE -1) then begin
            plots, 0, y_array[1], /device, color=color
            plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
        endif
        
    endif else begin            ;background selection
        (*(*global).data_back_selection) = y_array
        color = (*global).peak_selection_color
        y_array = (*(*global).data_peak_selection)
        
        if (y_array[0] NE -1) then begin
            plots, 0, y_array[0], /device, color=color
            plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
        endif
        
        if (y_array[1] NE -1) then begin
            plots, 0, y_array[1], /device, color=color
            plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
        endif
        
    endelse
    
    (*global).select_data_status = mouse_status_new
    
;update Back and Peak Ymin and Ymax cw_fields
    putDataBackgroundPeakYMinMaxValueInTextFields, Event

endif else begin ;zoom selected

    RefReduction_zoom, $
      Event, $
      MouseX=event.x, $
      MouseY=event.y, $
      fact=(*global).DataZoomFactor,$
      uname='data_zoom_draw'

    (*global).select_zoom_status = 0

endelse

END

