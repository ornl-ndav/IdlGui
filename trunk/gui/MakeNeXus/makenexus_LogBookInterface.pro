Function mfn_GenerateIsoTimeStamp
dateUnformated = systime()      ;ex: Thu Aug 23 16:15:23 2007
DateArray = strsplit(dateUnformated,' ',/extract) 
;ISO8601 : 2007-08-23T12:20:34-04:00
DateIso = strcompress(DateArray[4]) + '-'
month = 0
CASE (DateArray[1]) OF
    'Jan':month='01'
    'Feb':month='02'
    'Mar':month='03'
    'Apr':month='04'
    'May':month='05'
    'Jun':month='06'
    'Jul':month='07'
    'Aug':month='08'
    'Sep':month='09'
    'Oct':month='10'
    'Nov':month='11'
    'Dec':month='12'
endcase
DateIso += strcompress(month,/remove_all) + '-'
DateIso += strcompress(DateArray[2],/remove_all) + 'T'
DateIso += strcompress(DateArray[3],/remove_all) + '-04:00'
return, DateIso
END



;This function send by email a copy of the logBook
PRO mfn_EmailLogBook, Event, FullFileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams

;hostname
spawn, 'hostname', hostname

;get message added by user
message = getTextFieldValue(Event, 'send_to_geek_text')

;email logBook
text = "'Log Book of MFN - My First Nexus ("
text += (*global).version + ") sent by " + (*global).ucams
text += " (" + (*global).instrument + ") from " + hostname + "."
text += " Log Book is: " + FullFileName 
text += ". Message is: "

if (message NE '') then begin
    text += message
endif else begin
    text += "No messages added."
endelse
text += "'"

cmd =  'echo ' + text + '| mail -s "MFN LogBook" j35@ornl.gov'
spawn, cmd

;;; copy ROI files into /SNS/<instrument>/shared folder
;; shared_path = '/SNS/' + (*global).instrument + '/shared/'
;;; get DATA and NORM ROI files name
;; data_roi_file_name = getTextFieldValue(Event, 'reduce_data_region_of_interest_file_name')
;; norm_roi_file_name = getTextFieldValue(Event, 'reduce_normalization_region_of_interest_file_name')
;;; copy roi files into share folder
;; cp_cmd_data = 'cp ' + data_roi_file_name + ' ' + shared_path
;; cp_cmd_norm = 'cp ' + norm_roi_file_name + ' ' + shared_path

;; roi_data_error = 0
;; CATCH, roi_data_error
;; IF (roi_data_error NE 0) THEN BEGIN
;;     catch,/cancel
;;     LogBookText = 'Copy of ' + data_roi_file_name + ' in ' + shared_path + ' ... FAILED' 
;;     putLogBookMessage, Event, LogBookText, Append=1
;; ENDIF ELSE BEGIN
;;     spawn, cp_cmd_data, listening
;;     LogBookText = 'Copy of ' + data_roi_file_name + ' in ' + shared_path + ' ... OK' 
;;     putLogBookMessage, Event, LogBookText, Append=1
;; ENDELSE

;; IF (norm_roi_file_name NE '') THEN BEGIN
;;     roi_norm_error = 0
;;     CATCH, roi_norm_error
;;     IF (roi_norm_error NE 0) THEN BEGIN
;;         catch,/cancel
;;         LogBookText = 'Copy of ' + norm_roi_file_name + ' in ' + shared_path + ' ... FAILED' 
;;         putLogBookMessage, Event, LogBookText, Append=1
;;     ENDIF ELSE BEGIN
;;         spawn, cp_cmd_norm, listening
;;         LogBookText = 'Copy of ' + norm_roi_file_name + ' in ' + shared_path + ' ... OK' 
;;         putLogBookMessage, Event, LogBookText, Append=1
;;     ENDELSE
;; ENDIF

;tell the user that the email has been sent
LogBookText = 'LogBook has been sent successfully !'
AppendLogBook, Event, LogBookText
END



;This function output the log book in the IDL_LogBook folder of j35
PRO mfn_LogBookInterface, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create full name of log Book file
LogBookPath = (*global).LogBookPath
TimeStamp   = mfn_GenerateIsoTimeStamp()
program_name= (*global).program_name
instrument  = (*global).instrument
FullFileName = LogBookPath + program_name + '_' + instrument + '_'
FullFileName += TimeStamp + '.log'

;get full text of LogBook
LogBookText = getLogBookText(Event)
LogBook = ['COPY OF GENERAL USER LOG BOOK',LogBookText]
;get full text of myLogBook
MyLogBookText = getMyLogBookText(Event)
LogBook = [LogBook,$
           '',$
           '#############################################################',$
           '',$
           'COPY OF DEBUGGING TOOL LOG BOOK',$
           MyLogBookText]

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams
LogBookText = [ucamsText,LogBook]

;output file
openw, 1, FullFileName
sz = (size(LogBookText))(1)
for i=0,(sz-1) do begin
    text = LogBookText[i]
    printf, 1, text
endfor
close,1
free_lun,1

mfn_EmailLogBook, Event, FullFileName

END


