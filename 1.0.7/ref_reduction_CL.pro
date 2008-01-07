PRO ActivateOutputButtonStatus, Event
output_path = getTextFieldValue(Event,'cl_directory_text')
output_name = getTextFieldValue(Event,'cl_file_text')
IF (FILE_TEST(output_path,/DIRECTORY) AND $
    output_name NE '') THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
ActivateWidget, Event, 'output_cl_button', activate_status
END


;REACH by 'CL DIRECTORY ...' button
PRO CL_directoryButton, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get default cl_ouput_path
path  = (*global).cl_output_path
title = 'Select a place where to put the file...'
output_path = DIALOG_PICKFILE(PATH  = path,$
                              TITLE = title,$
                              /DIRECTORY)
;do something only if output_path is not empty and 
;if it exists
IF (output_path NE '' AND $
   FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN          
    putTextFieldValue, event, 'cl_directory_text', output_path, 0
ENDIF
ActivateOutputButtonStatus, Event
END


;REACH by the CL directory text
PRO CL_directoryText, Event
ActivateOutputButtonStatus, Event
END


;REACH by 'CL FILE ...' button
PRO CL_fileButton, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get default cl_file_ext
filter = (*global).cl_file_ext3
path   = (*global).cl_output_path
title  = 'Select file name that will contain the command line text...'
output_file = DIALOG_PICKFILE(PATH              = path,$
                              TITLE             = title,$
                              FILTER = filter)
IF (output_file NE '' AND $
    FILE_TEST(output_file)) THEN BEGIN
;get only the file name (without full path)
    file_array = strsplit(output_file,'/',COUNT=count,/EXTRACT)
    output_file = file_array[count-1]
    putTextFieldValue, event, 'cl_file_text', output_file, 0
ENDIF 
ActivateOutputButtonStatus, Event
END


;REACH by the CL file text
PRO CL_fileText, Event
ActivateOutputButtonStatus, Event
END


;REACH by the 'CREATE COMMAND LINE FILE'
PRO CL_outputButton, Event
;get output_path and output_filename
output_path = getTextFieldValue(Event,'cl_directory_text')
output_name = getTextFieldValue(Event,'cl_file_text')
full_output_filename = output_path + '/' + output_name
;get command line string
cml_text = getTextFieldValue(Event,'reduce_cmd_line_preview')

END
