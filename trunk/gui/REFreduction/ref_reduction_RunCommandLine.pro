PRO RefReduction_RunCommandLine, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message ;processing message

;get command line to generate
cmd = getTextFieldValue(Event,'reduce_cmd_line_preview')

;display command line in log-book
cmd_text = 'Running Command Line:'
putLogBookMessage, Event, cmd_text, Append=1
cmd_text = ' -> ' + cmd
putLogBookMessage, Event, cmd_text, Append=1
cmd_text = '......... ' + PROCESSING
putLogBookMessage, Event, cmd_text, Append=1

status_text = 'Data Reduction ........ ' + PROCESSING
putTextFieldValue, event, 'data_reduction_status_text_field', status_text, 0

spawn, cmd, listening, err_listening
help, err_listening

if (err_listening[0] NE '') then begin
    (*global).DataReductionStatus = 'ERROR'
    LogBookText = getLogBookText(Event)
    Message = '* ERROR! *'
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
    ErrorLabel = 'ERROR MESSAGE:'
    putLogBookMessage, Event, ErrorLabel, Append=1
    putLogBookMessage, Event, err_listening, Append=1

    status_text = 'Data Reduction ........ ERROR! (-> Check Log Book)'
    putTextFieldValue, event, 'data_reduction_status_text_field', status_text, 0

endif else begin
    (*global).DataReductionStatus = 'OK'
    LogBookText = getLogBookText(Event)
    Message = 'Done'
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

    status_text = 'Data Reduction ........ DONE'
    putTextFieldValue, event, 'data_reduction_status_text_field', status_text, 0
end

END
