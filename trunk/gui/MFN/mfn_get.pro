FUNCTION getRunNumber, Event
id = widget_info(Event.top,find_by_uname='run_number_cw_field')
widget_control, id, get_value=RunNumber
RETURN, strcompress(RunNumber,/remove_all)
END


FUNCTION getInstrument, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
id = widget_info(Event.top,find_by_uname='instrument_droplist')
index = widget_info(id, /droplist_select)
instrumentShortList = (*(*global).instrumentShortList)
RETURN, instrumentShortList[index]
END


FUNCTION getOutputPath, Event
id = widget_info(Event.top,find_by_uname='output_path_text')
widget_control, id, get_value=outputPath
RETURN,strcompress(outputPath,/remove_all)
END
