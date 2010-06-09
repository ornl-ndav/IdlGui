PRO BSSreduction_CreateConfigFile, global

ConfigFileName = (*global).DefaultConfigFileName
openw, 1, ConfigFileName

;Input
sz = N_TAGS(((*global).Configuration.Input))
TagNames = tag_names((*global).Configuration.Input)

FOR I=0,(sz-1) DO BEGIN
    text = TagNames[i] + ' ' + strcompress((*global).Configuration.Input.(i),/remove_all)
    printf, 1, text
ENDFOR

;Reduce
sz = N_TAGS(((*global).Configuration.Reduce))
FOR I=0,(sz-1) DO BEGIN
    sz2 = N_TAGS((*global).Configuration.Reduce.(i))
    TagNames = tag_names((*global).Configuration.Reduce.(i))
    sz = (size(TagNames))(1)
    FOR j=0,(sz-1) DO BEGIN
        text = TagNames[j] + ' ' + strcompress((*global).Configuration.Reduce.(i).(j),/remove_all)
        printf, 1, text
    ENDFOR
ENDFOR

close, 1
free_lun, 1

END




PRO BSSreduction_PopulateGui, Event, FileArray

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

  sz = (size(FileArray))(1)
  FOR i=0,(sz-1) DO BEGIN
    
      NameValue = strsplit(FileArray[i],' ',/EXTRACT)
      sz = (size(NameValue))(1)
    
      IF (sz GT 1) THEN BEGIN
        
          IF (STRMATCH(NameValue[0],'*button*',/FOLD_CASE)) THEN BEGIN ;it's a button
            
              IF (STRLOWCASE(NameValue[0]) NE 'rsdf_multiple_runs_button') THEN BEGIN
                  
                  IF(NameValue[1] EQ '0') THEN BEGIN
                      SetButton, event, STRLOWCASE(NameValue[0]), 0
                  ENDIF ELSE BEGIN
                      SetButton, event, STRLOWCASE(NameValue[0]), 1
                  ENDELSE

                  BSSreduction_EnableOrNotFields, Event, STRLOWCASE(NameValue[0])
            
              ENDIF

          ENDIF ELSE BEGIN
            
              IF (STRMATCH(NameValue[0],'*color*',/FOLD_CASE)) THEN BEGIN ;it's a slider
                
                  value = Fix(NameValue[1])
                
                  CASE (STRLOWCASE(NameValue[0])) OF
                      'colorverticalgrid': (*global).ColorVerticalGrid = value
                      'colorhorizontalgrid' : (*global).ColorHorizontalGrid = value
                      'colorexcludedpixels' : (*global).ColorExcludedPixels = value
                      'colorselectedpixel' : (*global).ColorSelectedPixel = value
                  ENDCASE
                
              ENDIF ELSE BEGIN
                
                  IF (STRMATCH(NameValue[0],'*loadct*',/FOLD_CASE)) THEN BEGIN ;loadct
                    
                      (*global).LoadctMainPlot = Fix(NameValue[1])
                    
                  ENDIF ELSE BEGIN
                    
                      putTextInTextField, Event, STRLOWCASE(NameValue[0]), NameValue[1]
                    
                  ENDELSE
                
              ENDELSE
            
          ENDELSE
        
      ENDIF ELSE BEGIN
          
          putTextInTextField, Event, STRLOWCASE(NameValue[0]), ''

      ENDELSE
  ENDFOR

;Load Nexus if there is one
bss_reduction_LoadNexus, Event, 1

;Load ROI if there is one


END




PRO BSSreduction_LoadingConfigurationFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

no_error = 0
CATCH, no_error

;message saying that config file is loaded
MessageBox = 'Loading Configuration File ... ' + (*global).processing
putMessageBoxInfo, Event, MessageBox

IF (no_error NE 0) THEN BEGIN
    CATCH,/cancel
    MessageBox = 'Loading Configuration File ... FAILED'
    putMessageBoxInfo, Event, MessageBox
ENDIF ELSE BEGIN

;read config file
    FileName = (*global).DefaultConfigFileName
    
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
    NbrElement = i              ;nbr of lines
    
    BSSreduction_PopulateGui, Event, FileArray

    LogBookMessage = '-> Configuration file (' + FileName + ') has been loaded'
    InitialLogBookMessage = getLogBookText(Event)
    IF (InitialLogBookMessage[0] EQ '') THEN BEGIN
        PutLogBookMessage, Event, LogBookMessage
    ENDIF ELSE BEGIN
        AppendLogBookMessage, Event, LogBookMessage
    ENDELSE

    MessageBox = 'Loading Configuration File ... OK'
    putMessageBoxInfo, Event, MessageBox
    
ENDELSE    
    
END



