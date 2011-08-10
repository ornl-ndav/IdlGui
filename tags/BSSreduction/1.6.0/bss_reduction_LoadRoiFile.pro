FUNCTION BSSreduction_retrieveStringArray, Event, FileName, NbrElement

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




PRO BSSreduction_retrievePixelExcludedArray, Event, FileName

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;put each line of the file into a strarray
  NbrElement = 0
  FileArray = BSSreduction_retrieveStringArray(Event, FileName, NbrElement)
  
  ;Create Excluded Array
  pixel_excluded_size = (*global).pixel_excluded_size
  PixelExcludedArray = MAKE_ARRAY(pixel_excluded_size,/INTEGER,VALUE=1)
  PixelExcludedArray_bank3_4 = make_array(pixel_excluded_size,/integer,value=1)
  
  LogBookText = '   -> Nbr of pixels to include: ' + $
    strcompress(NbrElement,/remove_all)
  AppendLogBookMessage, Event, LogBookText
  LogBookText = '   -> Sample data from file  : '
  AppendLogBookMessage, Event, LogBookText
  
  ;display_info = 1 if we want to see a sample
  RoiPreviewArray = (*global).RoiPreviewArray
  error_status = 0
  
  FOR i=0,(NbrElement-1) DO BEGIN
  
    IF (WHERE(i EQ RoiPreviewArray) NE -1) THEN BEGIN
      display_info = 1
    ENDIF
    
    pixelid = getPixelIDfromRoiString(Event, $
      FileArray[i], $
      display_info, $
      error_status)
      
    IF (error_status EQ 1) THEN BEGIN
      break
    ENDIF
    
    if (pixelid lt 2*4096) then begin
      PixelExcludedArray[pixelid] = 0
    endif else begin
      pixelid -= 2*4096
      PixelExcludedArray_bank3_4[pixelid] = 0
    endelse
    
    IF (display_info EQ 1) THEN display_info = 0
    
  ENDFOR
  
  (*global).ROI_error_status = error_status
  (*(*global).pixel_excluded) = PixelExcludedArray
  (*(*global).pixel_excluded_base) = PixelExcludedArray
  (*(*global).pixel_excluded_bank3_4) = PixelExcludedArray_bank3_4
  (*(*global).pixel_excluded_base_bank3_4) = PixelExcludedArray_bank3_4
  
END




PRO BSSreduction_LoadRoiFile, Event

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
    
  no_error = 0
  CATCH, no_error
  
  IF (RoiFullFileName NE '') THEN BEGIN
  
    IF (no_error NE 0) then begin
    
      CATCH, /CANCEL
      messageBox = 'ROI File Loading -> ERROR !'
      LogBookMessage = 'ERROR loading the ROI file ' + RoiFullFileName
      AppendLogBookMessage, Event, LogBookMessage
      
      ;remove name of file loaded from Loaded ROI text
      putLoadedRoiFileName, Event, ''
      
    ENDIF ELSE BEGIN
    
      LogBookText = 'Loading ROI file: ' + RoiFullFileName
      AppendLogBookMessage, Event, LogBookText
      
      ;put name of file loaded from in loaded ROI text field
      putLoadedRoiFileName, Event, RoiFullFileName
      
      ;Read ROI file
      BSSreduction_retrievePixelExcludedArray, Event, RoiFullFileName
      
      IF ((*global).ROI_error_status EQ 1) THEN BEGIN
        messageBox = 'ROI File Loading -> ERROR !'
        LogBookMessage = 'ERROR loading the ROI file ' + RoiFullFileName
        AppendLogBookMessage, Event, LogBookMessage
      ENDIF ELSE BEGIN
        ;plot new ROI file
        PlotIncludedPixels, Event
        
        message = 'ROI File Loading -> SUCCESS !'
        LogBookMessage = '   -> ROI File has been loaded with SUCCESS !'
        AppendLogBookMessage, Event, LogBookMessage
        
        ;add full file name in REDUCE tab
        putReduceRoiFileName, Event, RoiFullFileName
        
      ENDELSE
      
    ENDELSE
    
    putMessageBoxInfo, Event, MessageBox
    
  ENDIF ELSE BEGIN                ;don't do anything
  
  ENDELSE
  
END

;-----------------------------------------------------------------------------
PRO LoadRoiFile, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  RoiFullFileName = getTextFieldValue(Event,'load_roi_file_text')
  
  no_error = 0
  CATCH, no_error
  
  IF (RoiFullFileName NE '') THEN BEGIN
  
    IF (no_error NE 0) then begin
    
      CATCH, /CANCEL
      messageBox = 'ROI File Loading -> ERROR !'
      LogBookMessage = 'ERROR loading the ROI file ' + RoiFullFileName
      AppendLogBookMessage, Event, LogBookMessage
      
    ENDIF ELSE BEGIN
    
      LogBookText = 'Loading ROI file: ' + RoiFullFileName
      AppendLogBookMessage, Event, LogBookText
      
      ;Read ROI file
      BSSreduction_retrievePixelExcludedArray, Event, RoiFullFileName
      
      IF ((*global).ROI_error_status EQ 1) THEN BEGIN
        messageBox = 'ROI File Loading -> ERROR !'
        LogBookMessage = 'ERROR loading the ROI file ' + RoiFullFileName
        AppendLogBookMessage, Event, LogBookMessage
      ENDIF ELSE BEGIN
        ;plot new ROI file
        PlotIncludedPixels, Event
        
        message = 'ROI File Loading -> SUCCESS !'
        LogBookMessage = '   -> ROI File has been loaded with SUCCESS !'
        AppendLogBookMessage, Event, LogBookMessage
        
        ;add full file name in REDUCE tab
        putReduceRoiFileName, Event, RoiFullFileName
        
      ENDELSE
      
    ENDELSE
    
    putMessageBoxInfo, Event, MessageBox
    
  ENDIF ELSE BEGIN                ;don't do anything
  
  ENDELSE
  
END


