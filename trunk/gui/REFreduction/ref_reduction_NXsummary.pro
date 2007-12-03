PRO RefReduction_NXsummary, Event, FileName, TextFieldUname
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (!VERSION.os EQ 'darwin') then begin
   cmd = 'head -n 22 ' + (*global).MacNXsummary
endif else begin
   cmd = 'nxsummary ' + FileName + ' --verbose'

   spawn, 'hostname',listening
   CASE (listening) OF
       'lrac': 
       'mrac': 
       else: BEGIN
           if ((*global).instrument EQ (*global).REF_L) then begin
               cmd = 'srun -p lracq ' + cmd
           endif else begin
               cmd = 'srun -p mracq ' + cmd
           endelse
       END
   ENDCASE

endelse

spawn, cmd, listening
listeningSize = (size(listening))(1)
if (listeningSize GE 1) then begin
    putTextFieldArray, Event, TextFieldUname, listening, listeningSize,0
endif
END
