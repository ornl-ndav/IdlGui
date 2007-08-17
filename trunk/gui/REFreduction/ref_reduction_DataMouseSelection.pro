;this function is reached when the user click on the plot
PRO REFreduction_DataSelectionPressLeft, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

mouse_status = (*global).select_data_status
print, 'PressLeft mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0: Begin
;refresh plot
        RePlot1DDataFile, Event
        color = (*global).back_selection_color
        y=event.y
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color

        y_array = (*(*global).data_back_selection)
        y2=y_array[1]
        plots, 0, y2, /device, color=color
        plots, (*global).xsize_1d_draw, y2, /device, /continue, color=color
        
        mouse_status_new = 1
    END
    1:  mouse_status_new = mouse_status
    2:  mouse_status_new = mouse_status
    3: Begin
        RePlot1DDataFile, Event
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, (*global).xsize_1d_draw, y1, /device, /continue, color=color

        y=event.y
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = 4
    end
    4:mouse_status_new = mouse_status
    5:  Begin
        RePlot1DDataFile, Event
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, (*global).xsize_1d_draw, y1, /device, /continue, color=color

        y=event.y
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = 4
    end
endcase

(*global).select_data_status = mouse_status_new


END




PRO REFreduction_DataSelectionPressRight, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
WIDGET_CONTROL, id_draw, GET_VALUE = id
DEVICE, DECOMPOSED = 0
wset, id
y_array = (*(*global).data_back_selection)
for i=0,1 do begin
    y=y_array[i]
    plots, 0, y, /device, color=color
    plots, (*global).xsize_1d_draw, y, /device, /continue, color=color
endfor

mouse_status = (*global).select_data_status
print, 'PressRight mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0: begin
        mouse_status_new = 3
        end
    1:  mouse_status_new = mouse_status
    2: mouse_status_new = mouse_status
    3: mouse_status_new = mouse_status
    4: mouse_status_new = mouse_status
    5: mouse_status_new = 0
endcase

(*global).select_data_status = mouse_status_new

END



;this function is reached when the mouse moved into the widget_draw
PRO REFreduction_DataSelectionMove, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

mouse_status = (*global).select_data_status
print, 'Move mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0:mouse_status_new = mouse_status
    1: Begin
        RePlot1DDataFile, Event
        color = (*global).back_selection_color
        mouse_status_new = mouse_status

        y_array = (*(*global).data_back_selection)
        y2 = y_array[1]
        plots, 0, y2, /device, color=color
        plots, (*global).xsize_1d_draw, y2, /device, /continue, color=color

;refresh plot
        y=event.y
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color
        END
    2:mouse_status_new = mouse_status
    3: Begin
;refresh plot
        RePlot1DDataFile, Event
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
;        y=y_array[0]
        y=event.y
        mouse_status_new = mouse_status
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color

        y2 = y_array[1]
        plots, 0, y2, /device, color=color
        plots, (*global).xsize_1d_draw, y2, /device, /continue, color=color
    END
    4: Begin
        RePlot1DDataFile, Event
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, (*global).xsize_1d_draw, y1, /device, /continue, color=color

        y=event.y
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color
        
        mouse_status_new = mouse_status
    END
    5:mouse_status_new = mouse_status
endcase

;plots, X2, Y2, /device, /continue, color=color_line
;plots, X2, Y1, /device, /continue, color=color_line
;plots, X1, Y1, /device, /continue, color=color_line






END




PRO REFreduction_DataSelectionRelease, event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global


id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
WIDGET_CONTROL, id_draw, GET_VALUE = id
DEVICE, DECOMPOSED = 0
wset, id

mouse_status = (*global).select_data_status
print, 'Release mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0:mouse_status_new = mouse_status
    1: Begin
;refresh plot
        RePlot1DDataFile, Event
        y_array = (*(*global).data_back_selection)

        color = (*global).back_selection_color
        mouse_status_new = 0
;get y mouse
        y=event.y
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color
        (*(*global).data_back_selection) = [y,0]

        y2 = y_array[1]
        plots, 0, y2, /device, color=color
        plots, (*global).xsize_1d_draw, y2, /device, /continue, color=color

    END
    2:mouse_status_new = mouse_status
    3:mouse_status_new = mouse_status
    4: Begin
        RePlot1DDataFile, Event
        color = (*global).back_selection_color
        y_array = (*(*global).data_back_selection)
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, (*global).xsize_1d_draw, y1, /device, /continue, color=color

        y=event.y
        plots, 0, y, /device, color=color
        plots, (*global).xsize_1d_draw, y, /device, /continue, color=color
        
        (*(*global).data_back_selection) = [y1,y]
        mouse_status_new = 5
        END
    5:mouse_status_new = mouse_status
endcase

(*global).select_data_status = mouse_status_new

END

