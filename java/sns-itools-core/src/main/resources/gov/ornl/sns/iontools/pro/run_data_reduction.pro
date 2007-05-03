function find_output_file_name, instrument, run_number, output_path

file_name = output_path + "/" + instrument + "_" 
file_name += strcompress(run_number,/remove_all) + ".txt"

return, file_name
end




pro PLOT_DATA_REDUCTION, outputPath, $
                         instrument, $
                         run_number, $
                         Ntof, $
                         Y12, $
                         Signalymin, $
                         yscale, $
                         ymin, $
                         ymax

output_file_name = FIND_OUTPUT_FILE_NAME(instrument, run_number, outputPath)

;tvscl_x_off = 42
tvscl_x_off = 0
;tvscl_y_off = 21
tvscl_y_off = 0

;catch, error_plot_status
;if (error_plot_status NE 0) then begin
;    text = 'Not enough data to plot'
;    CATCH,/cancel
;endif else begin
    
    openr,u,output_file_name,/get
    fs = fstat(u)
        
;define an empty string variable to hold results from reading the file
    tmp  = ''
    tmp0 = ''
    tmp1 = ''
    tmp2 = ''
    
    flt0 = -1.0
    flt1 = -1.0
    flt2 = -1.0
    
    Nelines = 0L    ;number of lines that does not start with a number
    Nndlines = 0L
    Ndlines = 0L
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
        
        true = 1
        case true of
            
            ((onebyte LT 48) OR (onebyte GT 57)): begin
                                ;case where we have non-numbers
                Nelines = Nelines + 1
                readf,u,tmp
            end
            
            else: begin
                                ;case where we (should) have data
                Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
                
                catch, Error_Status
                if Error_status NE 0 then begin
                    
                                ;you're done now...
                    CATCH, /CANCEL
                    
                endif else begin
                    
                    readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                    flt0 = [flt0,float(tmp0)] ;x axis
                    flt1 = [flt1,float(tmp1)] ;y axis
                    flt2 = [flt2,float(tmp2)] ;y_error axis
                    
                endelse
                
            end
        endcase
        
    endwhile
    
;strip -1 from beginning of each array
    flt0 = flt0[1:*]
    flt1 = flt1[1:*]
    flt2 = flt2[1:*]
        
;x_axis
    x_axis=flt0[sort(flt0[0:(Ntof-1)])]
    tvscl_x_axis = lindgen(float(x_axis[Ntof-1]))
    
;y_axis
    flt0_size = size(flt0)
    number_of_row = fix(flt0_size[1]/Ntof)
    
;define the final big array
    final_array = fltarr(Ntof,number_of_row)
    for i=0,(number_of_row-1) do begin
        final_array[0,i] = flt1[i*Ntof:i*Ntof+(Ntof-1)]
    endfor
        
    close,u
    free_lun,u

    ;max_top = max(final_array,/nan)
    ;min_top = min(final_array,/nan)

    max_value = float(ymax)
    indx_max = where(float(final_array) GT max_value, Nmax)
    if (Nmax NE 0) then begin
        final_array(indx_max) = !Values.F_NAN
    endif
    
            
    min_value = float(ymin)
    indx_min = where(final_array LT min_value, Nmin)
    if (Nmin NE 0) then begin
        final_array(indx_min) = !Values.F_NAN
    endif
    
    ;max_top = max(final_array,/nan)
    ;min_top = min(final_array,/nan)

;endelse
        
;;remove -inf and inf
;    indx1 = where(final_array EQ !VALUES.F_INFINITY, ngt1)
;    if (ngt1 NE 0) then begin
;        final_array(indx1) = (*global).plus_inf
;    endif
;    
;    indx2 = where(final_array EQ -!VALUES.F_INFINITY, ngt2)
;    if (ngt2 NE 0) then begin
;        final_array(indx2) = (*global).minus_inf
;    endif
    
    
;    if ( formula_selected EQ 'log10') then begin ;log10
        
;remove negative numbers and zeros too
    indx4 = where(final_array LE 0, ngt0)
    if (ngt0 NE 0) then begin
        final_array(indx4) = !values.F_NAN
    endif
    
if (yscale EQ 'log10') then begin

    indx5 = where(final_array GT 0, ngt1) 
    if (ngt1 NE 0) then begin
        final_array(indx5) = alog10(final_array(indx5))
    endif
    
endif


;    endif
    
;;indx3 = where(final_array EQ strcompress(!values.F_NAN), ngt)
;nan = !VALUES.F_NAN
;nan_user = (*global).nan_user
;for i=0,(number_of_row*Ntof-1) do begin
;    if (strcompress(final_array[i]) EQ strcompress(nan)) then begin
;        final_array[i] = nan_user 
;    endif
;endfor
    
;tvscl, final_array, /NAN
    
CATCH,/CANCEL
    
DEVICE, DECOMPOSED = 0
;    loadct,5
        
;    if (y12 GE 30) then begin
;        
;        tvscl_y_axis = (indgen(y12)+ymin)

;        tvimg = rebin(final_array, Ntof, New_Ny, /sample)
;        tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan
;        plot, tvscl_x_axis, tvscl_y_axis, $
;          yrange=[tvscl_y_axis[0],$
;                  tvscl_y_axis[y12-1]],yticklayout=0, $
;      ystyle=8, $
;        ystyle=1,$
;          xstyle=8, $
;          /nodata, /device, $
;          /noerase, $
;          xmargin=[7,0], $
;      ymargin=[2,0]
;        ymargin=[2,(393-New_Ny)/10],$
;          title='x-axis: tof(s) / y-axis: pixels'

;    endif else begin

set_plot, 'z'                   ;put image data in the display window
;erase

New_Nx = 2*Ntof
New_Ny = number_of_row * floor((500-tvscl_y_off)/number_of_row)

DEVICE,SET_RESOLUTION=[tvscl_x_off+New_Nx,tvscl_y_off+New_Ny]

;tvscl_y_axis = (indgen(y12)+ymin)*0.7
tvscl_y_axis = indgen(y12)
tvscl_y_axis_string = string(tvscl_y_axis)


tvimg = rebin(final_array, New_Nx, New_Ny, /sample)
tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan
;tvscl, tvimg, /nan
;plot, tvscl_x_axis, tvscl_y_axis, $
;  yrange=[tvscl_y_axis[0],$
;          tvscl_y_axis[y12-1]],yticklayout=0, $
;  ytickname=tvscl_y_axis_string, $
;  ystyle=1,$
;  xstyle=8, $
;  /nodata, /device, $
;  /noerase, $
;  xmargin=[7,0], $
;  ymargin=[2,(393-New_Ny)/10],$
;  title='x-axis: tof(s) / y-axis: distance (mm)'
            
tvimg=TVRD()
set_plot,'ION'
erase
loadct, 39, /silent
;tv,tvimg,0,-1
tv,tvimg,0

end




function PLOT_FIRST_TIME_DATA_REDUCTION, output_file_name, Ntof, Y12, ymin

;tvscl_x_off = 57
;tvscl_y_off = 25
tvscl_x_off = 0
tvscl_y_off = 0

;catch, error_plot_status
;if (error_plot_status NE 0) then begin
;    text = 'Not enough data to plot'
;    CATCH,/cancel
;endif else begin
    
    openr,u,output_file_name,/get
    fs = fstat(u)
        
;define an empty string variable to hold results from reading the file
    tmp  = ''
    tmp0 = ''
    tmp1 = ''
    tmp2 = ''
    
    flt0 = -1.0
    flt1 = -1.0
    flt2 = -1.0
    
    Nelines = 0L    ;number of lines that does not start with a number
    Nndlines = 0L
    Ndlines = 0L
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
        
        true = 1
        case true of
            
            ((onebyte LT 48) OR (onebyte GT 57)): begin
                                ;case where we have non-numbers
                Nelines = Nelines + 1
                readf,u,tmp
            end
            
            else: begin
                                ;case where we (should) have data
                Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
                
                catch, Error_Status
                if Error_status NE 0 then begin
                    
                                ;you're done now...
                    CATCH, /CANCEL
                    
                endif else begin
                    
                    readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                    flt0 = [flt0,float(tmp0)] ;x axis
                    flt1 = [flt1,float(tmp1)] ;y axis
                    flt2 = [flt2,float(tmp2)] ;y_error axis
                    
                endelse
                
            end
        endcase
        
    endwhile
    
;strip -1 from beginning of each array
    flt0 = flt0[1:*]
    flt1 = flt1[1:*]
    flt2 = flt2[1:*]
        
;x_axis
    x_axis=flt0[sort(flt0[0:(Ntof-1)])]
    tvscl_x_axis = lindgen(float(x_axis[Ntof-1]))
    
;y_axis
    flt0_size = size(flt0)
    number_of_row = fix(flt0_size[1]/Ntof)
    
;define the final big array
    final_array = fltarr(Ntof,number_of_row)
    for i=0,(number_of_row-1) do begin
        final_array[0,i] = flt1[i*Ntof:i*Ntof+(Ntof-1)]
    endfor
        
    close,u
    free_lun,u

    max_value= max(final_array,/nan)
    min_value = min(final_array,/nan)
    
    if (max_value NE '') then begin
        max_value = float(max_value[0])
        indx_max = where(float(final_array) GT max_value, Nmax)
        if (Nmax NE 0) then begin
            final_array(indx_max) = !Values.F_NAN
        endif
    endif
            
    if (min_value NE '') then begin
        min_value = float(min_value[0])
        indx_min = where(final_array LT min_value, Nmin)
        if (Nmin NE 0) then begin
            final_array(indx_min) = !Values.F_NAN
       endif
    endif
            
    max_top = max(final_array,/nan)
    min_top = min(final_array,/nan)

;endelse
        
;;remove -inf and inf
;    indx1 = where(final_array EQ !VALUES.F_INFINITY, ngt1)
;    if (ngt1 NE 0) then begin
;        final_array(indx1) = (*global).plus_inf
;    endif
;    
;    indx2 = where(final_array EQ -!VALUES.F_INFINITY, ngt2)
;    if (ngt2 NE 0) then begin
;        final_array(indx2) = (*global).minus_inf
;    endif
    
    
;    if ( formula_selected EQ 'log10') then begin ;log10
        
;remove negative numbers and zeros too
        indx4 = where(final_array LE 0, ngt0)
        if (ngt0 NE 0) then begin
            final_array(indx4) = !values.F_NAN
        endif
        
    indx5 = where(final_array GT 0, ngt1) 
    if (ngt1 NE 0) then begin
        final_array(indx5) = alog10(final_array(indx5))
    endif
        
;    endif
    
;;indx3 = where(final_array EQ strcompress(!values.F_NAN), ngt)
;nan = !VALUES.F_NAN
;nan_user = (*global).nan_user
;for i=0,(number_of_row*Ntof-1) do begin
;    if (strcompress(final_array[i]) EQ strcompress(nan)) then begin
;        final_array[i] = nan_user 
;    endif
;endfor
    
;tvscl, final_array, /NAN
    
CATCH,/CANCEL
DEVICE, DECOMPOSED = 0

;    loadct,5
        
;    if (y12 GE 30) then begin
;        
;        tvscl_y_axis = (indgen(y12)+ymin)

;        tvimg = rebin(final_array, Ntof, New_Ny, /sample)
;        tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan
;        plot, tvscl_x_axis, tvscl_y_axis, $
;          yrange=[tvscl_y_axis[0],$
;                  tvscl_y_axis[y12-1]],yticklayout=0, $
;      ystyle=8, $
;        ystyle=1,$
;          xstyle=8, $
;          /nodata, /device, $
;          /noerase, $
;          xmargin=[7,0], $
;      ymargin=[2,0]
;        ymargin=[2,(393-New_Ny)/10],$
;          title='x-axis: tof(s) / y-axis: pixels'

;    endif else begin

set_plot, 'z'                   ;put image data in the display window

New_Nx = Ntof
New_Ny = number_of_row * floor((500-tvscl_y_off)/number_of_row)

DEVICE,SET_RESOLUTION=[tvscl_x_off+New_Nx,tvscl_y_off+New_Ny]

;tvscl_y_axis = (indgen(y12)+ymin)*0.7
tvscl_y_axis = (indgen(y12))
tvscl_y_axis_string = string(tvscl_y_axis)


tvimg = rebin(final_array, New_Nx, New_Ny, /sample)
tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan, /device
;tvscl, tvimg, /nan
;plot, tvscl_x_axis, tvscl_y_axis, $
;  yrange=[tvscl_y_axis[0],$
;          tvscl_y_axis[y12-1]],yticklayout=0, $
;  ytickname=tvscl_y_axis_string, $
;  ystyle=1,$
;  xstyle=8, $
;  /nodata, /device, $
;  /noerase, $
;  xmargin=[7,0], $
;  ymargin=[2,(500-New_Ny)/10],$
;  title='x-axis: tof(s) / y-axis: distance (mm)'
            
tvimg=TVRD()
set_plot,'ION'
erase
loadct, 39, /silent
;tv,tvimg,0,-1
tv,tvimg,0

min_top = strcompress(min_top)
max_top = strcompress(max_top)

return, [min_top, max_top]
end



function RUN_DATA_REDUCTION, cmd, outputPath, run_number, instrument, Ntof, Y12, ymin

cmd_size_array = size(cmd)
cmd_size = cmd_size_array[1]

cmdLocal = ""

for i=0,(cmd_size-1) do begin
    cmdLocal += cmd[i] + " "
endfor

cd, outputPath
spawn, cmdLocal, listening

output_file_name = FIND_OUTPUT_FILE_NAME(instrument, run_number, outputPath)
array_result = PLOT_FIRST_TIME_DATA_REDUCTION(output_file_name, Ntof, Y12, ymin)

return, string(array_result)
end


