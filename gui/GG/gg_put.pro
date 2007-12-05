;**************** Generic Functions ********************
PRO putInTextField, Event, uname, file_name
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=strcompress(file_name)
END


;*************** Particular Functions ********************

;Put the file_name given in the text_fiels specified by the type
;(geometry,cvinfo)
PRO putFileNameInTextField, Event, type, file_name
uname = type + '_text_field'
putInTextField, Event, uname, file_name
END
