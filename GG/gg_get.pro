;===============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;===============================================================================

;**************** Generic Functions ********************

;Returns the contain of a text field
FUNCTION getTextFieldValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value[0]
END

;*************** Particular Functions ********************

;Returns the index of the instrument selected in the 'loading
;geometry' base
FUNCTION getInstrumentSelectedIndex, Event
id = widget_info(Event.top, find_by_uname ='instrument_droplist')
RETURN, widget_info(id, /droplist_select)
END

;Returns the full file name of the geoemtry.xml file
FUNCTION getGeometryFileName, Event
RETURN, getTextFieldValue(Event,'geometry_text_field')
END

;Returns the full file name of the cvinfo.xml file
FUNCTION getCvinfoFileName, Event
RETURN, getTextFieldValue(Event,'cvinfo_text_field')
END

;Returns the instrument Selected
FUNCTION getInstrument, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
index = getInstrumentSelectedIndex(Event)
instrumentShortList = (*(*global).instrumentShortList)
RETURN, instrumentShortlist[index]
END

;Returns the result of finding or not the prenexus folder of the given
;run number for the given instrument. The prenexus path is also
;returns as an argument
FUNCTION getPreNexus, instrument, RunNumber, prenexus_path
cmd = 'findnexus --prenexus -i' + strcompress(instrument,/remove_all)
cmd += ' ' + strcompress(RunNumber,/remove_all)
spawn, cmd, result, err_listening
if (err_listening[0] NE '') THEN RETURN, 0
IF (STRMATCH(result[0],'ERROR*')) THEN BEGIN
    prenexus_path = ''
    RETURN, 0
ENDIF ELSE BEGIN
    prenexus_path = strcompress(result[0],/remove_all)
    RETURN, 1
ENDELSE
END


;Returns the cvinfo file name of the run number given
FUNCTION get_cvinfo_file_name, Event
;get instrument
instrument = getInstrument(Event)
;get RunNumber
RunNumber = getTextFieldValue(Event, 'cvinfo_run_number_field')
;find preNeXus
result = getPreNexus(instrument, RunNumber, prenexus_path)
IF (result EQ 1) THEN BEGIN
;append cvinfo file name to path found (if found)
    full_cvinfo_file_name = prenexus_path + '/' + instrument
    full_cvinfo_file_name += '_' + strcompress(RunNumber,/remove_all) + '_cvinfo.xml'
;return fileName
    RETURN, full_cvinfo_file_name
ENDIF ELSE BEGIN
    RETURN, ''
ENDELSE
END


;Get the list of geometry files
FUNCTION getGeometryList, instrument
cmd = 'findcalib -g --listall -i' + instrument
spawn, cmd, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN
    RETURN, listening
ENDIF ELSE BEGIN
    RETURN, ['']
ENDELSE
END


;Returns the index of the geometry file selected
FUNCTION getGeometrySelectedIndex, Event
id = widget_info(Event.top, find_by_uname ='geometry_droplist')
RETURN, widget_info(id, /droplist_select)
END


;Returns the array of geometry files
FUNCTION getGeometryValue, Event
id = widget_info(Event.top, find_by_uname ='geometry_droplist')
widget_control, id, get_value=array
return, array
END


;Returns the geometry file selected
FUNCTION getGeometryFile, Event
;get global structure
index = getGeometrySelectedIndex(Event)
value = getGeometryValue(Event)
RETURN, value[index]
END


;Returns the path of the output geometry file
FUNCTION get_output_path, Event
RETURN, getTextFieldValue(Event, 'geo_path_text_field')
END


;Returns the name of the output geometry file
FUNCTION get_output_name, Event
RETURN, getTextFieldValue(Event, 'geo_name_text_field')
END


FUNCTION getMotorsIndexOfName, Event, name, motors
ListOfName = motors.name
index = where(ListOfName EQ name)
return, index
end


;this function returns the content of the tag name specified 
;mostly used to return the content of SNSproblem_log from the
;nxs geometry file created.
FUNCTION getXmlTagContent, Event, tag_name, fullFileName
no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    return, ''
ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=fullFileName)
    oDocList = oDoc->GetElementsByTagName('NXroot')
    obj1 = oDocList->Item(0)
    obj2 = obj1->getElementsByTagName('SNSproblem_log')
    obj3 = obj2->Item(0)
    obj4 = obj3->GetFirstChild()
    return, obj4->GetNodeValue()
ENDELSE
END


FUNCTION getNumberOfError, Event, text
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;list_of_error
list_of_error = (*global).error_list
sz = (size(list_of_error))(1)
Nbr_error = 0
FOR i=0,(sz-1) DO BEGIN
    n=0
    pos=0
    while (pos NE -1) do begin
        pos = strpos(text,list_of_error[i],pos)
        if (pos ne -1) then ++pos
        ++n
    endwhile
    Nbr_error += (n-1)
ENDFOR
RETURN, Nbr_error
END
