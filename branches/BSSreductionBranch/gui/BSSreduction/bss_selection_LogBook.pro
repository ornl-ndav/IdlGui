PRO BSSselection_LogBook, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create full name of log Book file
LogBookPath = (*global).LogBookPath
TimeStamp   = BSSselection_GenerateIsoTimeStamp()
instrument  = 'BASIS'
FullFileName = LogBookPath + instrument + '_' 
FullFileName += TimeStamp + '.log'

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

BSSselection_EmailLogBook, Event, FullFileName

END


;This function send by email a copy of the logBook
PRO BSSselection_EmailLogBook, Event, FullFileName

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
text = "'Log Book of BSSselection ("
text += (*global).BSSselectionVersion + ") sent by " + (*global).ucams
text += " (BASIS) from " + hostname + "."
text += " Log Book is: " + FullFileName 
text += ". Message is: "

if (message NE '') then begin
    text += message
endif else begin
    text += "No messages added."
endelse
text += "'"

cmd =  'echo ' + text + '| mail -s "BSSselection LogBook" j35@ornl.gov'
spawn, cmd

;tell the user that the email has been sent
LogBookText = 'LogBook has been sent successfully !'
AppendLogBookMessage, Event, LogBookText

END

