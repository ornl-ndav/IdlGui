function find_output_file_name, instrument, run_number, output_path

file_name = output_path + "/" + instrument + "_" 
file_name += strcompress(run_number,/remove_all) + ".txt"

return, file_name
end




pro PLOT_DATA_REDUCTION_COMBINE, instrument,$
                                 run_number,$
                                 outputPath,$
                                 xScale, $
                                 xmin, $
                                 xmax, $
                                 yScale, $
                                 ymin, $
                                 ymax


xmax = float(xmax)
xmin = float(xmin)
ymax = float(ymax)
ymin = float(ymin)

output_file_name = FIND_OUTPUT_FILE_NAME(instrument, run_number, outputPath)

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

Nelines = 0L
Nndlines = 0L
Ndlines = 0L
onebyte = 0b

while (NOT eof(u)) do begin
    
    readu,u,onebyte             ;,format='(a1)'
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
                                ;print,'Non-data Line: ',Nndlines
            readf,u,tmp
        end
        
        else: begin
                                ;case where we (should) have data
            Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
            
            catch, Error_Status
            if Error_status NE 0 then begin

                flt0 = [flt0,float(tmp0)]
                                ;strip -1 from beginning of each array
                flt0 = flt0[1:*]
                flt1 = flt1[1:*]
                flt2 = flt2[1:*]
                                ;you're done now...
                CATCH, /CANCEL
            endif else begin
                readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                flt0 = [flt0,float(tmp0)]
                flt1 = [flt1,float(tmp1)]
                flt2 = [flt2,float(tmp2)]
                
            endelse
            
        end
    endcase
    
endwhile

;xmax = max(flt0,/nan)
;xmin = min(flt0,/nan)
;ymax = max(flt1,/nan)
;ymin = min(flt1,/nan)

catch, error_plot_status
if (error_plot_status NE 0) then begin
    text = 'Not enough data to plot'
    CATCH,/cancel
endif else begin
    set_plot, 'z'               ;put image data in the display window
    New_Nx = long(650)
    New_Ny = long(500)
    DEVICE,SET_RESOLUTION=[New_Nx,New_Ny]
    erase
endelse

title='Run #: ' + strcompress(run_number)
xtitle = 'tof (microS)'

case xScale of
    
    'linear':begin
        
        case yScale of
            
            'linear': begin
                plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title
            end
            
            'log10': begin
                plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title,/ylog
            end
            
        endcase
        
    end
    
    'log10': begin
        
        case yScale of
            
            'linear': begin
                plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title,/xlog
            end
            
            'log10': begin
                plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title,/xlog,/ylog
            end
            
        endcase
        
    end
    
endcase

errplot,flt0,flt1 - flt2, flt1 + flt2,color = 100

close,u
free_lun,u

tvimg=TVRD()
set_plot,'ION'
loadct, 39, /silent

;tv,tvimg,0,-1
tv,tvimg,0

end




function PLOT_FIRST_TIME_DATA_REDUCTION_COMBINE, output_file_name, $
                                                 run_number


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

Nelines = 0L
Nndlines = 0L
Ndlines = 0L
onebyte = 0b

while (NOT eof(u)) do begin
    
    readu,u,onebyte             ;,format='(a1)'
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
                                ;print,'Non-data Line: ',Nndlines
            readf,u,tmp
        end
        
        else: begin
                                ;case where we (should) have data
            Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
            
            catch, Error_Status
            if Error_status NE 0 then begin

                flt0 = [flt0,float(tmp0)]
                                ;strip -1 from beginning of each array
                flt0 = flt0[1:*]
                flt1 = flt1[1:*]
                flt2 = flt2[1:*]
                                ;you're done now...
                CATCH, /CANCEL
            endif else begin
                readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                flt0 = [flt0,float(tmp0)]
                flt1 = [flt1,float(tmp1)]
                flt2 = [flt2,float(tmp2)]
                
            endelse
            
        end
    endcase
    
endwhile

xmax = max(flt0,/nan)
xmin = min(flt0,/nan)
ymax = max(flt1,/nan)
ymin = min(flt1,/nan)

catch, error_plot_status
if (error_plot_status NE 0) then begin
    text = 'Not enough data to plot'
    CATCH,/cancel
endif else begin
    set_plot, 'z'               ;put image data in the display window
    New_Nx = long(650)
    New_Ny = long(500)
    DEVICE,SET_RESOLUTION=[New_Nx,New_Ny]
    erase
endelse

title='Run #: ' + strcompress(run_number)
xtitle = 'tof (microS)'

plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title,/ylog
errplot,flt0,flt1 - flt2, flt1 + flt2,color = 100

close,u
free_lun,u

tvimg=TVRD()
set_plot,'ION'
loadct, 39, /silent
;tv,tvimg,0,-1
tv,tvimg,0

return, [strcompress(xmin), strcompress(xmax), strcompress(ymin), strcompress(ymax)]
end





function RUN_DATA_REDUCTION_COMBINE, cmd, $
                                     outputPath, $
                                     run_number, $
                                     instrument

cmd_size_array = size(cmd)
cmd_size = cmd_size_array[1]

cmdLocal = ""
for i=0,(cmd_size-1) do begin
    cmdLocal += cmd[i] + " "
endfor

;run data reduction command line
cd, outputPath
;cmdLocal = "srun " + cmdLocal
spawn, cmdLocal, listening

output_file_name = FIND_OUTPUT_FILE_NAME(instrument, run_number, outputPath)

array_result = PLOT_FIRST_TIME_DATA_REDUCTION_COMBINE(output_file_name, run_number)

return, array_result
end


