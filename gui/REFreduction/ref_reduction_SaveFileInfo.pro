;This functions save the metadata of the files
PRO RefReduction_SaveFileInfo, Event, FilesToPlotList, NbrLine

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

sz = size(FilesToPLotList)
FileNbr = sz(1)

print, 'FileNbr: ' + strcompress(FileNbr,/remove_all)

fltPreview_ptr = (*global).fltPreview_ptr

for j=0,(FileNbr-1) do begin
    
    no_file = 0
    catch, no_file
    if (no_file NE 0) then begin
        catch,/cancel
        plot_file_found = 0    
    endif else begin
        print, 'file to plot: ' + FilesToPlotList[j]
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

endfor

(*global).fltPreview_ptr = fltPreview_ptr

END
