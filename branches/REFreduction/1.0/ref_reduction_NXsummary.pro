PRO RefReduction_NXsummary, Event, FileName, TextFieldUname
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message

LogText = '----> Display NXsummary of default selected file:'
putLogBookMessage,Event,LogText,Append=1

IF (!VERSION.os EQ 'darwin') THEN BEGIN
    cmd = 'head -n 22 ' + (*global).MacNXsummary
ENDIF ELSE BEGIN
    cmd = 'nxsummary ' + FileName + ' --verbose '
;    spawn, 'hostname',listening
;    CASE (listening) OF
;        'lrac': 
;        'mrac': 
;        else: BEGIN
;            if ((*global).instrument EQ (*global).REF_L) then begin
;                cmd = 'srun -Q -p lracq ' + cmd
;            endif else begin
;                cmd = 'srun -Q -p mracq ' + cmd
;            endelse
;        END
;    ENDCASE
ENDELSE
logText = '-----> cmd : ' + cmd + ' ... ' + PROCESSING
putLogBookMessage,Event,LogText,Append=1

;run nxsummary command
spawn, cmd, listening, err_listening
LogBookText = getLogBookText(Event)
IF (err_listening[0] EQ '') THEN BEGIN
    listeningSize = (size(listening))(1)
    if (listeningSize GE 1) then begin
        putTextFieldArray, Event, TextFieldUname, listening, listeningSize,0
    ENDIF
    Message = 'OK'
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
ENDIF ELSE BEGIN
    Message = 'FAILED'
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
ENDELSE
END
