;this function is reached when the user click on the plot
PRO REFreduction_DataSelectionPressLeft, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

mouse_status = (*global).select_data_status

CASE (mouse_status) OF
    0: Begin
        print, 'first time left clicking'
        mouse_status_new = 1
    END
    1:        mouse_status_new = mouse_status
    2:  mouse_status_new = mouse_status
    3: Begin
        print, 'start plotting second border of back'
        mouse_status_new = 4
    end
    4:mouse_status_new = mouse_status
    5:  Begin
        print, 'start plotting second border of back'
        mouse_status_new = 4
    end
endcase

(*global).select_data_status = mouse_status_new

;x=event.x
;y=event.y

END




PRO REFreduction_DataSelectionPressRight, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

mouse_status = (*global).select_data_status
print, 'mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0: mouse_status_new = 3
    1: mouse_status_new = mouse_status
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
CASE (mouse_status) OF
    0:mouse_status_new = mouse_status
    1: Begin
        print, 'plotting back first border'
        mouse_status_new = mouse_status
        END
    2:mouse_status_new = mouse_status
    3:mouse_status_new = mouse_status
    4: Begin
        print, 'plotting back second border'
        mouse_status_new = mouse_status
    END
    5:mouse_status_new = mouse_status
endcase

END




PRO REFreduction_DataSelectionRelease, event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

mouse_status = (*global).select_data_status
CASE (mouse_status) OF
    0:mouse_status_new = mouse_status
    1: Begin
        print, 'just releasing back first border'
        mouse_status_new = 0
    END
    2:mouse_status_new = mouse_status
    3:mouse_status_new = mouse_status
    4: Begin
        print, 'done with plot of second back border'
        mouse_status_new = 5
        END
    5:mouse_status_new = mouse_status
endcase

(*global).select_data_status = mouse_status_new

END

