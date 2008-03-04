PRO  ActivateWidget, Event, uname, ActivateStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus
END


PRO MapBase, Event, uname, MapStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, map=MapStatus
END


PRO SetCWBgroup, Event, uname, value
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=value
END


PRO SetButtonValue, Event, uname, text
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=text
END


PRO SetTabCurrent, Event, uname, TabIndex
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_tab_current=TabIndex
END


PRO SetDropListValue, Event, uname, index
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_droplist_select=index
END


PRO SetSliderValue, Event, uname, index
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=index
END


;This procedure allows the text to show the last 2 lines of the Data
;log book
PRO showLastDataLogBookLine, Event
dataLogBook = getDataLogBookText(Event)
sz = (size(dataLogBook))(1)
id = widget_info(Event.top,find_by_uname='data_log_book_text_field')
widget_control, id, set_text_top_line=(sz-2)
END


;This procedure allows the text to show the last 2 lines of the Norm
;log book
PRO showLastNormLogBookLine, Event
NormLogBook = getNormalizationLogBookText(Event)
sz = (size(NormLogBook))(1)
id = widget_info(Event.top,find_by_uname='normalization_log_book_text_field')
widget_control, id, set_text_top_line=(sz-2)
END
