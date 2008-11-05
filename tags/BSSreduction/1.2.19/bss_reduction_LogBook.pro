PRO BSSreduction_LogBook, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create full name of log Book file
LogBookPath = (*global).LogBookPath
TimeStamp   = BSSreduction_GenerateIsoTimeStamp()
instrument  = 'BASIS'
FullFileName = LogBookPath + instrument + '_' 
FullFileName += TimeStamp + '.log'

;copy ROI files into /SNS/<instrument>/shared folder
shared_path = '/SNS/' + (*global).instrument + '/shared/'
RoiFileName = getReduceRoiFullFileName(Event)
;change permisison of file and copy roi files into share folder 
chmod_cmd = 'chmod 755 ' + RoiFileName
cp_cmd    = 'cp ' + RoiFileName + ' ' + shared_path

;change permission of file first
roi_error = 0
;CATCH, roi_error
IF (roi_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    LogBookText = 'Change permission of ' + RoiFileName + ' to 755 ' + $
      ' ... FAILED' 
    AppendLogBookMessage, Event, LogBookText
ENDIF ELSE BEGIN
    spawn, chmod_cmd, listening, err_listening
    IF (err_listening[0] NE '') THEN BEGIN
        LogBookText = 'Change permission of ' + RoiFileName + $
          ' to 755 ... FAILED' 
    AppendLogBookMessage, Event, LogBookText
    ENDIF ELSE BEGIN
        LogBookText = 'Change permission of ' + RoiFileName + $
          ' to 755 ... OK' 
    AppendLogBookMessage, Event, LogBookText
    ENDELSE
ENDELSE

;copy file into final folder
;CATCH, roi_error
IF (roi_error NE 0) THEN BEGIN
    catch,/cancel
    LogBookText = 'Copy of ' + RoiFileName + ' in ' + $
      shared_path + ' ... FAILED' 
    AppendLogBookMessage, Event, LogBookText
ENDIF ELSE BEGIN
    spawn, cp_cmd, listening, err_listening
    IF (err_listening[0] NE '') THEN BEGIN
        LogBookText = 'Copy of ' + RoiFileName + ' in ' + $
          shared_path + ' ... FAILED' 
        AppendLogBookMessage, Event, LogBookText
    ENDIF ELSE BEGIN
        LogBookText = 'Copy of ' + RoiFileName + ' in ' + $
          shared_path + ' ... OK' 
        AppendLogBookMessage, Event, LogBookText
    ENDELSE
ENDELSE

;get full text of LogBook
LogBookText = getLogBookText(Event)

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams
LogBookText = [ucamsText,LogBookText]

;output file
openw, 1, FullFileName
sz = (size(LogBookText))(1)
for i=0,(sz-1) do begin
    text = LogBookText[i]
    printf, 1, text
endfor
close,1
free_lun,1

BSSreduction_EmailLogBook, Event, FullFileName

END


;This function send by email a copy of the logBook
PRO BSSreduction_EmailLogBook, Event, FullFileName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams

;hostname
spawn, 'hostname', hostname

;get message added by user
message = getTextFieldValue(Event, 'log_book_message')

;email logBook
text = "'Log Book of BSSreduction ("
text += (*global).BSSreductionVersion + ") sent by " + (*global).ucams
text += " (BASIS) from " + hostname + "."
text += " Log Book is: " + FullFileName 
text += ". Message is: "

if (message NE '') then begin
    text += message
endif else begin
    text += "No messages added."
endelse
text += "'"

cmd =  'echo ' + text + '| mail -s "BSSreduction LogBook" j35@ornl.gov'
spawn, cmd

;tell the user that the email has been sent
LogBookText = 'LogBook has been sent successfully !'
AppendLogBookMessage, Event, LogBookText

END

