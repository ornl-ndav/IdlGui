;This functions save the metadata of the files
PRO RefReduction_SaveFileInfo, Event, FilesToPlotList, NbrLine

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

sz = size(FilesToPLotList)
FileNbr = sz(1)

fltPreview_ptr = (*global).fltPreview_ptr

for j=0,(FileNbr-1) do begin
    
    WriteError = 0
    CATCH, WriteError
    if (WriteError NE 0) then begin

    endif else begin

        no_file = 0
        catch, no_file
        if (no_file NE 0) then begin
            catch,/cancel
            plot_file_found = 0    
        endif else begin
            openr,u,FilesToPlotList[j],/get
            fs = fstat(u)
;define an empty string variable to hold results from reading the file
            tmp = ''
            info_array = strarr(NbrLine)
            for i=0,((*global).PreviewFileNbrLine-1) do begin
                readf,u,tmp
                info_array[i] = tmp
            endfor
            close,u
            free_lun,u
        endelse

        *fltPreview_ptr[j] = info_array

    endelse ;end of Catch if statement

endfor

(*global).fltPreview_ptr = fltPreview_ptr

END




;This functions save the metadata of the XML file
PRO RefReduction_SaveXmlInfo, Event, xmlFile

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

fltPreview_ptr = (*global).fltPreview_ptr

no_file = 0
catch, no_file
if (no_file NE 0) then begin
    catch,/cancel
    plot_file_found = 0    
endif else begin
    openr,u,xmlFile,/get
;define an empty string variable to hold results from reading the file
    tmp = ''
    info_array = strarr(1) 
    while (NOT eof(u)) do begin
        readf,u,tmp
        info_array = [info_array,tmp]
    endwhile
    close,u
    free_lun,u
endelse

*fltPreview_ptr[1] = info_array
(*global).fltPreview_ptr = fltPreview_ptr

END
