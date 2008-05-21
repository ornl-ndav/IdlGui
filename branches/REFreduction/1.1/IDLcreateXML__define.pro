;******************************************************************************
Function IDLcreateXML_GenerateIsoTimeStamp
dateUnformated = SYSTIME()    
DateArray      = STRSPLIT(dateUnformated,' ',/EXTRACT) 
DateIso        = STRCOMPRESS(DateArray[4]) + 'y_'
month = 0
CASE (DateArray[1]) OF
    'Jan':month='01m'
    'Feb':month='02m'
    'Mar':month='03m'
    'Apr':month='04m'
    'May':month='05m'
    'Jun':month='06m'
    'Jul':month='07m'
    'Aug':month='08m'
    'Sep':month='09m'
    'Oct':month='10m'
    'Nov':month='11m'
    'Dec':month='12m'
ENDCASE
DateIso += STRCOMPRESS(month,/REMOVE_ALL) + '_'
DateIso += STRCOMPRESS(DateArray[2],/REMOVE_ALL) + 'd_'
;change format of time
time     = STRSPLIT(DateArray[3],':',/EXTRACT)
DateIso += STRCOMPRESS(time[0],/REMOVE_ALL) + 'h_'
DateIso += STRCOMPRESS(time[1],/REMOVE_ALL) + 'mn_'
DateIso += STRCOMPRESS(time[2],/REMOVE_ALL) + 's'
RETURN, DateIso
END

;******************************************************************************
;Create unique full xml file name
FUNCTION IDLcreateXML_CreateFullXmlFileName, XML_FILE_LOCATION,$
                                             INSTRUMENT,$
                                             APPLICATION,$
                                             UCAMS
;get time stamp
DateIso = IDLcreateXML_GenerateIsoTimeStamp()
FullFileName  = XML_FILE_LOCATION + '/' + APPLICATION
FullFileName += '_' + UCAMS + '_' + DateIso
FullFileName += '.xml'
RETURN, FullFileName
END

;******************************************************************************
;This function creates the XML file text
FUNCTION IDLcreateXML_CreateXMLtext, APPLICATION,$
                                     UCAMS,$
                                     COMMAND_LINE,$
                                     INSTRUMENT

text = ["<?xml version='1.0' encoding='UTF-8'?>"]
text = [text,"<SNSJOB"]
text = [text,'        NAME="' + APPLICATION + '"']
text = [text,'        USER="' + UCAMS + '"']
text = [text,'        REMOTEADDR="160.91.212.221"']
CASE (INSTRUMENT) OF
    'REF_L': host='lracq,lrac.sns.gov,heater.sns.gov,spare.sns.gov'
    'REF_M': host='mracq,mrac.sns.gov,heater.sns.gov,spare.sns.gov'
    ELSE:    host='heaterq,heater.sns.gov,spare.sns.gov'
ENDCASE
text = [text,'        EXECHOSTS="' + host + '"']
text = [text,'        RESOURCECONFIG="null"']
text = [text,'    <OPERATION NAME="stagein"/>']
text = [text,'    <OPERATION NAME="compute"']
text = [text,'             COMPUTATIONCMD="' + COMMAND_LINE + '"/>']
text = [text,'</SNSJOB>']
RETURN, text
END

;******************************************************************************
;This function create the XML file
FUNCTION IDLcreateXML_CreateXMLfile, xml_file_text, full_xml_file_name
file_error = 0
;CATCH, file_error   ;REMOVE COMMA
IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
ENDIF ELSE BEGIN
    OPENW, 1, full_xml_file_name
    sz = (size(xml_file_text))(1)
    FOR i=0,(sz-1) DO BEGIN
        printf, 1, xml_file_text[i]
    ENDFOR
    CLOSE,1
    FREE_LUN,1
ENDELSE
RETURN,1
END

;******************************************************************************
FUNCTION IDLcreateXML_ChangeFilePermission, full_xml_file_name
cmd = 'chmod 755 ' + full_xml_file_name
spawn, cmd, listening, err_listening
IF (err_listening[0] NE '') THEN RETURN,0
RETURN,1
END

;******************************************************************************
FUNCTION IDLcreateXML::init, APPLICATION = application,$
                     INSTRUMENT          = instrument,$
                     UCAMS               = ucams,$
                     XML_FILE_LOCATION   = xml_file_location,$
                     COMMAND_LINE        = command_line

;Create unique full xml file name
full_xml_file_name = IDLcreateXML_CreateFullXmlFileName(XML_FILE_LOCATION,$
                                                        INSTRUMENT,$
                                                        APPLICATION,$
                                                        UCAMS)

;Create XML file text
xml_file_text = IDLcreateXML_CreateXMLtext(APPLICATION,$
                                           UCAMS,$
                                           COMMAND_LINE,$
                                           INSTRUMENT)
                                           
;Create File
result1 = IDLcreateXML_CreateXMLfile(xml_file_text, $
                                     full_xml_file_name)

;Change Permission on file
result2 = IDLcreateXML_ChangeFilePermission(full_xml_file_name)

IF (result1 + result2 NE 2) THEN RETURN, 0
RETURN,1
END

;******************************************************************************
PRO IDLcreateXML__define
struct = {IDLcreateXML,$
          var: ''}
END
;******************************************************************************
