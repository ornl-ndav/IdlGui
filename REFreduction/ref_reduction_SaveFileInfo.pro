;This functions save the metadata of the files
PRO RefReduction_SaveFileInfo, Event, FilesToPlotList, NbrLine
;get global structure
id = WIDGET_INFO(EVENT.TOP, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

sz = SIZE(FilesToPLotList)
FileNbr = sz(1)

fltPreview_ptr = (*global).fltPreview_ptr

FOR j=0,(FileNbr-1) DO BEGIN
    WriteError = 0
    CATCH, WriteError
    IF (WriteError NE 0) THEN BEGIN
    ENDIF ELSE BEGIN
        no_file = 0
        catch, no_file
        IF (no_file NE 0) THEN BEGIN
            CATCH,/CANCEL
            plot_file_found = 0    
        ENDIF ELSE BEGIN
            OPENR,u,FilesToPlotList[j],/GET
            fs = FSTAT(u)
;define an empty string variable to hold results from reading the file
            tmp = ''
            info_array = STRARR(NbrLine)
            FOR i=0,((*global).PreviewFileNbrLine-1) DO BEGIN
                READF,u,tmp
                info_array[i] = tmp
            ENDFOR
            CLOSE,u
            FREE_LUN,u
        ENDELSE
        *fltPreview_ptr[j] = info_array
    ENDELSE ;end of Catch if statement
ENDFOR
(*global).fltPreview_ptr = fltPreview_ptr
END




;This functions save the metadata of the XML file
PRO RefReduction_SaveXmlInfo, Event, xmlFile
;get global structure
id = WIDGET_INFO(EVENT.TOP, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

fltPreview_ptr = (*global).fltPreview_ptr

no_file = 0
catch, no_file
IF (no_file NE 0) THEN BEGIN
    CATCH,/CANCEL
    plot_file_found = 0    
ENDIF ELSE BEGIN
    OPENR,u,xmlFile,/GET
;define an empty string variable to hold results from reading the file
    tmp = ''
    info_array = STRARR(1) 
    WHILE (NOT EOF(u)) DO BEGIN
        READF,u,tmp
        info_array = [info_array,tmp]
    ENDWHILE
    CLOSE,u
    FREE_LUN,u
ENDELSE
*fltPreview_ptr[1] = info_array
(*global).fltPreview_ptr = fltPreview_ptr
END
