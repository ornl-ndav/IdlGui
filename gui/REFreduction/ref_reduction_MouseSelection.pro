;this function is reached when the user click on the plot
PRO REFreduction_SelectionPressLeft, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

x=event.x
y=event.y

print, 'Left clicking the mouse'


END




PRO REFreduction_SelectionPressRight, event
print, 'Right clicking the mouse'


END




;this function is reached when the mouse moved into the widget_draw
PRO REFreduction_SelectionMove, event
print, 'Moving the mouse
END




PRO REFreduction_SelectionRelease, event
print, 'Releasing the mouse'
END

