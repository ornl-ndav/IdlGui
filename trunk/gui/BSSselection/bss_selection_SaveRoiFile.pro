PRO BSSselection_CreateRoiFileName, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path = (*global).roi_path
first_part = 'BASIS_'
get_iso8601, second_part
ext_part = (*global).roi_ext

name = path + first_part + second_part + ext_part

;put new name into field
putRoiFileName, Event, name
END



PRO BSSselection_SetRoiPath, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get value of button
current_path = (*global).roi_path

new_path = dialog_pickfile(PATH = current_path,$
                           TITLE = 'Select ROI destination folder',$
                           /DIRECTORY)

IF (new_path NE '') THEN BEGIN ;change label of ROI path
    
    (*global).roi_path = new_path
    
;display only the last part of the path
;    path_to_display = strmid(new_path,10,11,/reverse_offset)
;    path_to_display = '...' + path_to_display
    path_to_display = new_path
    putRoiPathButtonValue, Event, path_to_display

;gives new ROI output path in LogBook
    LogBookText = 'A new output path for the Region Of Interest (ROI) files has been set:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> Path was    : ' + current_path
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> Path is now : ' + new_path
    AppendLogBookMessage, Event, LogBookText

;put new path and file name in Save ROI text
    BSSselection_CreateRoiFileName, Event

ENDIF
END
