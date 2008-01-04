;REACH by 'CL DIRECTORY ...' button
PRO CL_directoryButton, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get default cl_ouput_path
path  = (*global).cl_output_path
tilel = 'Select a place where to put the file...'
output_path = DIALOG_PICKFILE(PATH  = path,$
                              TITLE = title,$
                              /DIRECTORY)
;do something only if output_path is not empty and 
;if it exists
IF (output_path NE '' AND $
   FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN          
    (*global).cl_output_path = output_path ;save new path
                                ;put path in text field
    putTextFieldValue, event, 'cl_directory_text', output_path, 0
ENDIF
END


;REACH by the CL directory text
PRO CL_directoryText, Event
print, 'in CL_directoryText'
END

;REACH by 'CL FILE ...' button
PRO CL_fileButton, Event
print, 'in CL_fileButton'
END

;REACH by the CL file text
PRO CL_fileText, Event
print, 'in CL_fileText'
END

;REACH by the 'CREATE COMMAND LINE FILE'
PRO CL_outputButton, Event
print, 'in CL_outputButton'
END
