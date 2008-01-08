;This function output the log book in the IDL_LogBook folder of j35
PRO RefReduction_LogBookInterface, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create full name of log Book file
LogBookPath = (*global).LogBookPath
TimeStamp   = RefReduction_GenerateIsoTimeStamp()
instrument  = (*global).instrument
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

REFreduction_EmailLogBook, Event, FullFileName

END


;This function send by email a copy of the logBook
PRO REFreduction_EmailLogBook, Event, FullFileName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams

;hostname
spawn, 'hostname', hostname

;get message added by user
message = getTextFieldValue(Event, 'log_book_output_text_field')

;email logBook
text = "'Log Book of RefReduction ("
text += (*global).REFreductionVersion + ") sent by " + (*global).ucams
text += " (" + (*global).instrument + ") from " + hostname + "."
text += " Log Book is: " + FullFileName 
text += ". Message is: "

if (message NE '') then begin
    text += message
endif else begin
    text += "No messages added."
endelse
text += "'"

cmd =  'echo ' + text + '| mail -s "REFreduction LogBook" j35@ornl.gov'
spawn, cmd

;copy ROI files into /SNS/<instrument>/shared folder
shared_path = '/SNS/' + (*global).instrument + '/shared/'
;get DATA and NORM ROI files name
data_roi_file_name = getTextFieldValue(Event, 'reduce_data_region_of_interest_file_name')
norm_roi_file_name = getTextFieldValue(Event, 'reduce_normalization_region_of_interest_file_name')
;copy roi files into share folder
cp_cmd_data = 'cp ' + data_roi_file_name + ' ' + shared_path
cp_cmd_norm = 'cp ' + norm_roi_file_name + ' ' + shared_path

roi_data_error = 0
CATCH, roi_data_error
IF (roi_data_error NE 0) THEN BEGIN
    catch,/cancel
    LogBookText = 'Copy of ' + data_roi_file_name + ' in ' + shared_path + ' ... FAILED' 
    putLogBookMessage, Event, LogBookText, Append=1
ENDIF ELSE BEGIN
    spawn, cp_cmd_data, listening
    LogBookText = 'Copy of ' + data_roi_file_name + ' in ' + shared_path + ' ... OK' 
    putLogBookMessage, Event, LogBookText, Append=1
ENDELSE

IF (norm_roi_file_name NE '') THEN BEGIN
    roi_norm_error = 0
    CATCH, roi_norm_error
    IF (roi_norm_error NE 0) THEN BEGIN
        catch,/cancel
        LogBookText = 'Copy of ' + norm_roi_file_name + ' in ' + shared_path + ' ... FAILED' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDIF ELSE BEGIN
        spawn, cp_cmd_norm, listening
        LogBookText = 'Copy of ' + norm_roi_file_name + ' in ' + shared_path + ' ... OK' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDELSE
ENDIF

;tell the user that the email has been sent
LogBookText = 'LogBook has been sent successfully !'
putLogBookMessage, Event, LogBookText, Append=1

END
