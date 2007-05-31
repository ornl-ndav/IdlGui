FUNCTION DISPLAY_XML_FILE_INFO, file_name, tmp_folder, nbr_line

output_file_name = tmp_folder + '/' + file_name

no_file = 0
catch, no_file
nbr_line = fix(nbr_line)

if (no_file NE 0) then begin

    plot_file_found = 0    
    
endif else begin

    openr,u,output_file_name,/get
    fs = fstat(u)
    
;define an empty string variable to hold results from reading the file
    tmp  = ''
    
    onebyte = 0b

    while (NOT eof(u)) do begin

        readu,u,onebyte         ;,format='(a1)'
        fs = fstat(u)
                                ;print,'onebyte: ',onebyte
        
                                ;rewinded file pointer one character
        if fs.cur_ptr EQ 0 then begin
            point_lun,u,0
        endif else begin
            point_lun,u,fs.cur_ptr - 1
        endelse
        
        info_array = strarr(nbr_line)
        for i=0,nbr_line do begin
            readf,u,tmp
            info_array[i] = tmp
        endfor

    endwhile
       
    close,u
    free_lun,u

endelse

result_array = strcompress(info_array)
return, result_array

END
