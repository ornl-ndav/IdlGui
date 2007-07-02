;This function gives the size of the array given
;as a parameter
FUNCTION getSizeOfArray, ListOfFiles

sizeArray = size(ListOfFiles)
return, sizeArray[1]
END


;This function returns the selected index of the 'uname'
;droplist given
FUNCTION getSelectedIndex, Event, uname
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

TextBoxId= widget_info(Event.top, find_by_uname=uname)
TextBoxIndex= widget_info(TextBoxId,/droplist_select)
return, TextBoxIndex
END


;This function checks if the newly loaded file has alredy
;been loaded. Return 1 if yes and 0 if not
FUNCTION isFileAlreadyInList, ListOfFiles, file
sizeArray = size(ListOfFiles)
size = sizeArray[1]
for i=0, (size-1) do begin
    if (ListOfFiles[i] EQ file) then begin
        return, 1
    endif
endfor
return, 0
end


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
PRO add_new_file_to_droplist, Event, ShortFileName, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
ListOfFiles = (*(*global).list_of_files)
ListOfLongFileName = (*(*global).ListOfLongFileName)
;is is the first file loaded
if (isListOfFilesSize0(ListOfFiles) EQ 1) then begin
    ListOfFiles = [ShortFileName]
    ListOfLongFileName = [LongFileName]
;if not
endif else begin
   ;is this file not already listed 
   if(isFileAlreadyInList(ListOfFiles,ShortFileName) EQ 0) then begin ;true newly file
        ListOfFiles = [ListOfFiles,ShortFileName]
        ListOfLongFileName = [ListOfLongFileName,LongFileName]
        CreateArrays,Event   ;if a file is added, the Q1,Q2,SF arrays are updated
    endif
endelse
(*(*global).list_of_files) = ListOfFiles
(*(*global).ListOfLongFileName) = ListOfLongFileName
;update droplists
updateDropList, Event, ListOfFiles
end


;This function refresh the list displays in all the droplist (step1-2 and 3)
PRO updateDropList, Event, ListOfFiles
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;update list of file in droplist of step1
list_of_files_droplist_id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, list_of_files_droplist_id, set_value=ListOfFiles
;update list of file in droplist of step2
base_file_droplist_id = widget_info(Event.top,find_by_uname='base_file_droplist')
widget_control, base_file_droplist_id, set_value=ListOfFiles
;update list of file in droplists of step3
step3_base_file_droplist_id = widget_info(Event.top,find_by_uname='step3_base_file_droplist')
widget_control, step3_base_file_droplist_id, set_value=ListOfFiles
step3_work_on_file_droplist_id = widget_info(Event.top,find_by_uname='step3_work_on_file_droplist')
widget_control, step3_work_on_file_droplist_id, set_value=ListOfFiles
END



;This functions displays the first few lines of the newly loaded file
PRO display_info_about_selected_file, Event, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
no_file = 0
nbr_line = fix(20) ;nbr of lines to display
catch, no_file
if (no_file NE 0) then begin
    plot_file_found = 0    
endif else begin
    openr,u,LongFileName,/get
    fs = fstat(u)
;define an empty string variable to hold results from reading the file
    tmp = ''
    while (NOT eof(u)) do begin
        readu,u,onebyte         ;,format='(a1)'
        fs = fstat(u)
        if fs.cur_ptr EQ 0 then begin
            point_lun,u,0
        endif else begin
            point_lun,u,fs.cur_ptr - 4
        endelse
        info_array = strarr(nbr_line)
        for i=0,(nbr_line) do begin
            readf,u,tmp
            info_array[i] = tmp
        endfor
    endwhile
    close,u
    free_lun,u
endelse


;populate text box with array
TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_value=info_array[0]
for i=1,(nbr_line-1) do begin
    widget_control, TextBoxId, set_value=info_array[i],/append
endfor
end


;this function creates and update the Q1, Q2, SF arrays when a file is added
PRO CreateArrays, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
SF_array = (*(*global).SF_array)

Q1_array = [Q1_array,0]
Q2_array = [Q2_array,0]
SF_array = [SF_array,0]

(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array
(*(*global).SF_array) = SF_array
END


;this function removes from the Q1,Q2,SF and List_of_files, the info at 
;given index iIndex
PRO RemoveIndexFromArray, Event, iIndex
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check size of array
ListOfFiles = (*(*global).list_of_files)
ListOfFilesSize = getSizeOfArray(ListOfFiles)

;if array contains only 1 element, reset all arrays
if (ListOfFilesSize EQ 1) then begin
   ResetArrays,Event
endif else begin
   RemoveIndexFromList, Event, iIndex
endelse

END

;This function reset all the arrays (Q1,Q2,SF,list_of_files and ListOfLongFileName)
PRO ResetArrays, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

list_of_files      = strarr(1)
Q1_array           = lonarr(1)
Q2_array           = lonarr(1)
SF_array           = lonarr(1)
ListOfLongFileName = strarr(1)

(*(*global).list_of_files)      = list_of_files
(*(*global).Q1_array)           = Q1_array
(*(*global).Q2_array)           = Q2_array
(*(*global).SF_array)           = SF_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
END


;This function remove the value at the index iIndex
PRO RemoveIndexFromList, Event, iIndex
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ListOfFiles = (*(*global).list_of_files)
Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
SF_array = (*(*global).SF_array)
ListOfLongFileName = (*(*global).ListOfLongFileName)

ListOfFiles        = ArrayDelete(ListOfFiles,AT=iIndex,Length=1)
Q1_array           = ArrayDelete(Q1_array,AT=iIndex,Length=1)
Q2_array           = ArrayDelete(Q2_array,AT=iIndex,Length=1)
SF_array           = ArrayDelete(SF_array,AT=iIndex,Length=1)
ListOfLongFileName = ArrayDelete(ListOfLongFileName,AT=iIndex,Length=1)

(*(*global).list_of_files)     = ListOfFiles
(*(*global).Q1_array)          = Q1_array
(*(*global).Q2_array)          = Q2_array
(*(*global).SF_array)          = SF_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
END


