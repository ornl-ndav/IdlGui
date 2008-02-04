;Returns the Run Number from the INPUT base
FUNCTION getEventRunNumber, Event
id = widget_info(Event.top,find_by_uname='run_number')
widget_control, id, get_value=RunNumber
RETURN, strcompress(RunNumber,/remove_all)
END


;Returns the contain of the Event file widget_text (in INPUT base)
FUNCTION getEventFile, Event
id = widget_info(Event.top,find_by_uname='event_file')
widget_control, id, get_value=event_file
RETURN, event_file
END


;Returns the full path up to the prenexus folder
;example: /ARCS-DAS-FS/2007_1_18_SCI/ARCS_16/
FUNCTION getRunPath, Event, RunNumber, runFullPath
IF (!VERSION.os EQ 'darwin') THEN BEGIN
;get global structure
    id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
    widget_control,id,get_uvalue=global
    runFullPath = (*global).mac_arcs_folder
    RETURN, 1
ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        catch,/cancel
        RETURN, 0
    ENDIF ELSE BEGIN
        spawn, 'findnexus -iARCS --prenexus ' + RunNumber, listening
        IF (strmatch(listening[0],'*ERROR*')) THEN BEGIN
            RETURN, 0
        ENDIF ELSE BEGIN
            runFullPath = listening[0]
            RETURN, 1
        ENDELSE
    ENDELSE
ENDELSE
END


;Get the list of mapping files
FUNCTION getMappingFileList
cmd = 'findcalib -m --listall -iARCS'
spawn, cmd, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN
    RETURN, listening
ENDIF ELSE BEGIN
    RETURN, ['']
ENDELSE
END


;get value of text field 
FUNCTION getTextFieldValue, Event, Uname
id = widget_info(Event.top,find_by_uname=Uname)
widget_control, id, get_value=value
RETURN, strcompress(value,/remove_all)
END



;get value status text_field
FUNCTION getStatusTextFieldValue, Event
id = widget_info(Event.top,find_by_uname='send_to_geek_message_text')
widget_control, id, get_value=value
RETURN, value
END


;retrieve selected mapping file from droplist
FUNCTION getMappingFile, Event
;get selected index
id = widget_info(Event.top, find_by_uname ='mapping_droplist')
index_selected = widget_info(id, /droplist_select)
widget_control, id, get_value=array
RETURN, array[index_selected]
END


;get histogram type 0:linear 1:log
FUNCTION getHistogramType, Event
id = widget_info(Event.top, find_by_uname ='bin_type_droplist')
index_selected = widget_info(id, /droplist_select)
RETURN, index_selected
END


;get full name of histo mapped file
FUNCTION getHistoMappedFileName, event_file_full_name, staging_folder
event_file_only_array = strsplit(event_file_full_name,'/',/extract,/regex,count=length)
file_base = strsplit(event_file_only_array[length-1] ,'event.dat',/extract,/regex,count=length) 
histo_file_name = file_base + 'histo_mapped.dat'
histo_file_full_name = staging_folder + histo_file_name
RETURN, histo_file_full_name
END


;get full contain of log book
FUNCTION getLogBookText, Event
id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, get_value=text
RETURN, text
END


;return the column of the bank selected
FUNCTION getColumnMainPlot, X
Xwidth = 32
FOR i=0,37 DO BEGIN
    xoff = i*37
    xmin = 10 + xoff
    xmax = xmin + Xwidth
    IF (X GE xmin AND X LE xmax) THEN RETURN, (i+1)
ENDFOR
RETURN, 0
END


;this is used to determine the index of the bank
;L1 -> 0, L2 -> 1, M1 -> 38 ....
FUNCTION getColumnMainPlotIndex, X
Xwidth = 32
FOR i=0,37 DO BEGIN
    xoff = i*37
    xmin = 10 + xoff
    xmax = xmin + Xwidth
    IF (X GE xmin AND X LE xmax) THEN RETURN, (i)
ENDFOR
RETURN, -1
END


;return the row of the bank selected
FUNCTION getRowMainPlot, Y
YposArray = ['L','M','T']
Ywidth    = 256
FOR i=0,2 DO BEGIN
    yoff = i * (256+5)
    ymin = 5 + yoff
    ymax = ymin + Ywidth
    IF (Y GE ymin AND Y LE ymax) THEN RETURN, YposArray[i]
ENDFOR
RETURN, ''
END



;this is used to determine the index of the bank
;L1 -> 0, L2 -> 1, M1 -> 38 ....
FUNCTION getRowMainPlotIndex, Y
YposArray = [0,1,2]
Ywidth    = 256
FOR i=0,2 DO BEGIN
    yoff = i * (256+5)
    ymin = 5 + yoff
    ymax = ymin + Ywidth
    IF (Y GE ymin AND Y LE ymax) THEN RETURN, YposArray[i]
ENDFOR
RETURN, -1
END




;return the bank number
FUNCTION getBank, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global1
X = Event.X
Y = Event.Y
column = getColumnMainPlot(X)
row    = getRowMainPlot(Y)
;Special case for 32A and 32B
IF (column EQ 32 AND row EQ 'M') THEN BEGIN
    IF (Y LT 394) THEN column = '32B'
    IF (Y GT 394) THEN column = '32A'
    IF (Y EQ 394) THEN column = ''
ENDIF
IF (Row NE '' AND Column NE 0) THEN BEGIN ;we click inside a bank
    RETURN, Row + strcompress(Column,/remove_all)
ENDIF ELSE BEGIN ;if we click outside a bank
    RETURN, ''
ENDELSE
END



FUNCTION getBinTypeFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, 'linear'
ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        return, 0
    ENDIF ELSE BEGIN
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('scale')
        return, strcompress(obj4c->getvalue())
    ENDELSE
ENDELSE
END



FUNCTION getBinOffsetFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, '0'
ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        return, 0
    ENDIF ELSE BEGIN
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('startbin')
        return, strcompress(obj4c->getvalue())
    ENDELSE
ENDELSE
END



FUNCTION getBinMaxSetFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, '100000'
ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        return, 0
    ENDIF ELSE BEGIN
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('endbin')
        return, strcompress(obj4c->getvalue())
    ENDELSE
ENDELSE
END



FUNCTION getBinWidthSetFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, '200'
ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        return, 0
    ENDIF ELSE BEGIN
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('width')
        return, strcompress(obj4c->getvalue())
    ENDELSE
ENDELSE
END



FUNCTION getBankIndex, Event, X, Y
;retrieve bank number
bank_number = getBank(Event)
ColumnIndex = getColumnMainPlotIndex(X)
RowIndex    = getRowMainPlotIndex(Y)
IF (ColumnIndex EQ -1) THEN RETURN, -1
IF (RowIndex EQ -1) THEN RETURN, -1
index = ColumnIndex + 38*RowIndex
;Special case for 32A and 32B
IF (ColumnIndex EQ 31 AND RowIndex EQ 1) THEN BEGIN
    IF (Y LE 394) THEN ++index 
ENDIF
;add 1 to all the banks that are after bank 32B
IF (ColumnIndex GT 31 AND RowIndex EQ 1 OR $
    RowIndex EQ 2) THEN BEGIN
    ++index
ENDIF
RETURN, index
END


;return the tube number from the bank view
FUNCTION getBankPlotX, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global2
Xfactor = (*global2).Xfactor
X = Event.X
return, strcompress(X/Xfactor,/remove_all)
END


;return the Y from the bank view
FUNCTION getBankPlotY, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global2
Yfactor = (*global2).Yfactor
Y = Event.Y
return, strcompress(Y/Yfactor,/remove_all)
END



;return the pixelID from the widget_text found in the bank base
FUNCTION getPixelIdFromBankBase, Event
value = getTextFieldValue(Event,'pixelid_input')
RETURN, value
END



;get type desired 'lin' or 'log'
FUNCTION getTypeDesired, Event
id = widget_info(Event.top,find_by_uname='plot_scale_type')
widget_control, id, get_value=value
IF (value EQ 'Linear Y-axis      ') THEN RETURN, 'lin'
RETURN, 'log'
END
    


