PRO LogBook, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create full name of log Book file
LogBookPath = (*global).LogBookPath
TimeStamp   = GenerateIsoTimeStamp()
application  = 'plotARCS'
FullFileName = LogBookPath + application + '_' 
FullFileName += TimeStamp + '.log'

;get full text of LogBook
LogBookText = getLogBookText(Event)

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams
LogBookText = [ucamsText,LogBookText]

;output file
no_error = 0
CATCH, no_error
If (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
;tell the user that the email has not been sent
    LogBookText = 'An error occured while contacting the GEEK. Please email j35@ornl.gov!'
    putStatus, Event, LogBookText
ENDIF ELSE BEGIN
    openw, 1, FullFileName
    sz = (size(LogBookText))(1)
    for i=0,(sz-1) do begin
        text = LogBookText[i]
        printf, 1, text
    endfor
    close,1
    free_lun,1
    EmailLogBook, Event, FullFileName
ENDELSE
END


;This function send by email a copy of the logBook
PRO EmailLogBook, Event, FullFileName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams

;hostname
spawn, 'hostname', hostname

;get message added by user
message = getStatusTextFieldValue(Event)

;email logBook
text = "'Log Book of plotARCS "
text += (*global).Version + " sent by " + (*global).ucams
text += " from " + hostname + "."
text += " Log Book is: " + FullFileName 
text += ". Message is: "

if (message NE '') then begin
    text += message
endif else begin
    text += "No messages added."
endelse
text += "'"

no_error = 0
CATCH, no_error
If (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
;tell the user that the email has not been sent
    LogBookText = 'An error occured while contacting the GEEK. Please email j35@ornl.gov!'
    putStatus, Event, LogBookText
ENDIF ELSE BEGIN
    cmd =  'echo ' + text + '| mail -s "plotARCS LogBook" j35@ornl.gov'
    spawn, cmd
;tell the user that the email has been sent
    LogBookText = 'LogBook has been sent successfully !'
    putStatus, Event, LogBookText
ENDELSE
END
