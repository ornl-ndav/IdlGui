PRO myFirstclick, Event
widget_control, Event.top,get_uvalue=global
print, 'I clicked my first button'
print, (*global).var
END






PRO plotASCII_eventcb

END
