FUNCTION BSSselection_retrieveStringArray, Event, FileName, NbrElement

openr, u, FileName, /get

onebyte = 0b
tmp = ''
i = 0
NbrLine = getNbrLines(FileName)
FileArray = strarr(NbrLine)

while (NOT eof(u)) do begin
    
    readu,u,onebyte
    fs = fstat(u)
    
    if (fs.cur_ptr EQ 0) then begin
        point_lun,u,0
    endif else begin
        point_lun,u,fs.cur_ptr - 1
    endelse
    
    readf,u,tmp
    FileArray[i++] = tmp
            
endwhile

close, u
free_lun,u
NbrElement = i ;nbr of lines

RETURN, FileArray
END




PRO BSSselection_retrievePixelExcludedArray, Event, FileName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;put each line of the file into a strarray
NbrElement = 0
FileArray = BSSselection_retrieveStringArray(Event, FileName, NbrElement)

;Create Excluded Array
pixel_excluded_size = (*global).pixel_excluded_size
PixelExcludedArray = MAKE_ARRAY(pixel_excluded_size,/INTEGER,VALUE=1)

FOR i=0,(NbrElement-1) DO BEGIN

    pixelid = getPixelIDfromRoiString(FileArray[i])
    PixelExcludedArray[pixelid] = 0

ENDFOR

(*(*global).pixel_excluded) = PixelExcludedArray

END




PRO BSSselection_LoadRoiFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;define ROI filter
roi_ext = (*global).roi_ext
filter = '*' + roi_ext

;get default path
RoiPath = (*global).roi_path

title = 'Select a Region Of Interest (ROI) file to load'

;open ROI file
RoiFullFileName = DIALOG_PICKFILE(PATH = RoiPath,$
                                  TITLE = title,$
                                  FILTER = filter,$
                                  DEFAULT_EXTENSION = roi_ext)

IF (RoiFullFileName NE '') THEN BEGIN
    
;Read ROI file
    BSSselection_retrievePixelExcludedArray, Event, RoiFullFileName
    
;plot new ROI file
    PlotIncludedPixels, Event
    
ENDIF ELSE BEGIN                ;don't do anything
    
    
ENDELSE

END
