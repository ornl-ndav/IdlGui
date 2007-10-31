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




PRO BSSselection_SaveRoiFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get ROI full file name
RoiFullFileName = getRoiFullFileName(Event)

;get ROI array
pixel_excluded = (*(*global).pixel_excluded)
sz = (size(pixel_excluded))(1)

;open output file
openw, 1, RoiFullFileName

FOR i=0,(sz-1) DO BEGIN

    IF (pixel_excluded[i] EQ 0) THEN BEGIN

        IF (i LT 4096) THEN BEGIN ;bank1
            bank = 'bank1_'
        ENDIF ELSE BEGIN        ;bank2
            bank = 'bank2_'
        ENDELSE
        
        XY = getPixelIDfromXY_Untouched(i)
        X = strcompress(XY[0],/remove_all)
        Y = strcompress(XY[1],/remove_all)
        
        text = strcompress(i) + ': ' + bank + X + '_' + Y
        printf, 1, text

    ENDIF

ENDFOR

close, 1
free_lun, 1

END
