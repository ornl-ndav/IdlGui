;this function return 1 if the ListOfFiles is empty (first load)
;otherwise it returns 0
FUNCTION isListOfFilesSize0, ListOfFiles
sizeArray = size(ListOfFiles)
if (sizeArray[1] EQ 1) then begin
    ;check if argument is empty string
    if (ListOfFiles[0] EQ '') then begin
        return, 1
    endif else begin
        return, 0
    endelse
endif else begin
    return, 0
endelse
end



;This function remove the short file name and keep
;the path and reset the default working path
Function DEFINE_NEW_DEFAULT_WORKING_PATH, Event, file
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
path = get_path_to_file_name(file)
(*global).input_path = path ;reset the default path
return, path
end




;this function display the OPEN FILE from IDL
;get global structure
Function OPEN_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
title    = 'Select file:'
filter   = '*' + (*global).file_extension
pid_path = (*global).input_path
;open file
FullFileName = dialog_pickfile(path=pid_path,$
                               get_path=path,$
                               title=title,$
                               filter=filter)
;redefine the working path
path = define_new_default_working_path(Event,FullFileName)
return, FullFileName
end



;This functions populate the various droplist boxes
;It also checks if the newly file loaded is not already 
;present in the list, in this case, it's not added
PRO add_new_file_to_droplist, Event, file
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ListOfFiles = (*(*global).list_of_files)
if (isListOfFilesSize0(ListOfFiles) EQ 1) then begin
    ListOfFiles = [file]
endif else begin
;    if(isFileAlreadyInList EQ 0) then begin ;true newly file
        ListOfFiles = [ListOfFiles,file]
;    endif
endelse

(*(*global).list_of_files) = ListOfFiles
list_of_files_droplist_id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, list_of_files_droplist_id, set_value=ListOfFiles

end




