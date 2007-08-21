PRO RefReduction_NXsummary, Event, FileName, TextFieldUname
cmd = 'nxsummary ' + FileName + '--verbose'
spawn, cmd, listening
listeningSize = (size(listening))(1)
if (listeningSize GE 1) then begin
    putTextFieldArray, Event, TextFieldUname, listening, listeningSize
endif
END
