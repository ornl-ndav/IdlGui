PRO RefReduction_NXsummary, Event, FileName, TextFieldUname
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (!VERSION.os EQ 'darwin') then begin
   cmd = 'head -n 22 ' + (*global).MacNXsummary
endif else begin
   cmd = 'nxsummary ' + FileName + ' --verbose'
endelse

spawn, cmd, listening
listeningSize = (size(listening))(1)
if (listeningSize GE 1) then begin
    putTextFieldArray, Event, TextFieldUname, listening, listeningSize,0
endif
END
