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

FUNCTION getLogBookText, Event
id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, get_value=text
RETURN, text
END

FUNCTION getMyLogBookText, Event
id = widget_info(Event.top,find_by_uname='my_log_book')
widget_control, id, get_value=text
RETURN, text
END

FUNCTION getTextFieldValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value
END

FUNCTION getProposalNumber, Event, prenexus_path
textSplit = strsplit(prenexus_path,'/',/extract)
RETURN, textSplit[1]
END


FUNCTION getNbrPolaState, Event, file_name
oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    return, 0
ENDIF ELSE BEGIN
    oDocList = oDoc->GetElementsByTagName('DetectorInfo')
    obj1 = oDocList->item(0)
    obj2=obj1->GetElementsByTagName('States')
    obj3=obj2->item(0)
    obj3b=obj3->getattributes()
    obj3c=obj3b->getnameditem('number')
    return, fix(obj3c->getvalue())
ENDELSE
END
