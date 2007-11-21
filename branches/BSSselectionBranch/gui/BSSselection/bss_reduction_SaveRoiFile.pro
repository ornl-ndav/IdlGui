PRO BSSreduction_CreateRoiFileName, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path = (*global).roi_path
first_part = 'BASIS_'

RunNumber = (*global).RunNumber
IF (RunNumber NE '') THEN BEGIN
    first_part += strcompress(RunNumber,/remove_all) + '_'
ENDIF

get_iso8601, second_part
ext_part = (*global).roi_ext

name = path + first_part + second_part + ext_part

;put new name into field
putRoiFileName, Event, name

END




PRO BSSreduction_SetRoiPath, Event
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
    BSSreduction_CreateRoiFileName, Event

ENDIF
END




PRO BSSreduction_SaveRoiFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get ROI full file name
RoiFullFileName = getRoiFullFileName(Event)

LogBookText = 'ROI file has been created: ' + RoiFullFileName
AppendLogBookMessage, Event, LogBookText

;get ROI array
pixel_excluded = (*(*global).pixel_excluded)
sz = (size(pixel_excluded))(1)

error = 0
CATCH, error

IF (error NE 0) then begin

    CATCH, /CANCEL
    LogBookText = 'ERROR: ROI file has not been saved:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> ROI file name: ' + RoiFullFileName
    AppendLogBookMessage, Event, LogBookText
    MessageBox = 'ROI File Creation -> ERROR !'

ENDIF ELSE BEGIN
    
;open output file
    openw, 1, RoiFullFileName
    
;initialize info parameters
    ExcludedBank1Pixels = (*global).pixel_excluded_size / 2
    ExcludedBank2Pixels = ExcludedBank1Pixels
    IncludedBank1Pixels = 0
    IncludedBank2Pixels = 0

    FOR i=0,(sz-1) DO BEGIN
        
        IF (pixel_excluded[i] EQ 0) THEN BEGIN
            
            IF (i LT 4096) THEN BEGIN ;bank1
                bank = 'bank1_'
                IncludedBank1PIxels += 1
                ExcludedBank1PIxels -= 1
            ENDIF ELSE BEGIN    ;bank2
                bank = 'bank2_'
                IncludedBank2PIxels += 1
                ExcludedBank2PIxels -= 1
            ENDELSE
            
            XY = getXYfromPixelID_Untouched(i)
            X = strcompress(XY[0],/remove_all)
            Y = strcompress(XY[1],/remove_all)
            
            text = bank + X + '_' + Y
            printf, 1, text
            
        ENDIF
        
    ENDFOR
    
    close, 1
    free_lun, 1
    
    LogBookText = '    -> ROI file saved information: '
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '       * Bank 1:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '         - Number of pixels included: ' + $
      strcompress(IncludedBank1Pixels,/remove_all)
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '         - Number of pixels excluded: ' + $
      strcompress(ExcludedBank1Pixels,/remove_all)
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '       * Bank 2:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '         - Number of pixels included: ' + $
      strcompress(IncludedBank2Pixels,/remove_all)
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '         - Number of pixels excluded: ' + $
      strcompress(ExcludedBank2Pixels,/remove_all)
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '       * Total Number of pixels excluded: ' + $
      strcompress(ExcludedBank2Pixels + ExcludedBank1Pixels,/remove_all)
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '       * Total Number of pixels included: ' + $
      strcompress(IncludedBank2Pixels + IncludedBank1Pixels,/remove_all)
    AppendLogBookMessage, Event, LogBookText
    
    MessageBox = 'ROI File Creation -> SUCCESS !'

;populate RoI file name in reduce tab1
    putReduceRoiFileName, Event, RoiFullFileName

    (*global).SavedRoiFullFileName = RoiFullFileName

ENDELSE

putMessageBoxInfo, Event, MessageBox

;remove name of file loaded from Loaded ROI text
putLoadedRoiFileName, Event, ''

END
