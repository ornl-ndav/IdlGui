;Create the output array for signal selection
pro create_signal_pid_array_file, XY, file_name

xmin = XY[0]
xmax = XY[1]
ymin = XY[2]
ymax = XY[3]

openw, 1, file_name

i=0
for x=xmin, xmax do begin
    for y=ymin, ymax do begin
        text = 'bank1_' + strcompress(x,/remove_all)
        text += '_' + strcompress(y,/remove_all)
        printf, 1,text
        ++i
    endfor
endfor

close, 1
free_lun, 1

end







;Create the output array for background selection
pro create_background_pid_array_file, Event, $
                                      XYsignal, $
                                      XYbackground, $
                                      XYbackground_2, $
                                      file_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

xmin_signal = XYsignal[0]
xmax_signal = XYsignal[1]
ymin_signal = XYsignal[2]
ymax_signal = XYsignal[3]

xmin_back = XYbackground[0]
xmax_back = XYbackground[1]
ymin_back = XYbackground[2]
ymax_back = XYbackground[3]

xmin_signal = round(xmin_signal/2)
xmax_signal = round(xmax_signal/2)
ymin_signal = round(ymin_signal/2)
ymax_signal = round(ymax_signal/2)

xmin_back = round(xmin_back/2)
xmax_back = round(xmax_back/2)
ymin_back = round(ymin_back/2)
ymax_back = round(ymax_back/2)

Nx = (*global).Ny
Ny = (*global).Nx
signal_array=intarr(Nx, Ny)
background_1_array = intarr(Nx, Ny)

;create signal array
for x=xmin_signal, xmax_signal do begin
    for y=ymin_signal, ymax_signal do begin
        signal_array[x,y]=1
    endfor
endfor

;create background arraay

for x=xmin_back, xmax_back do begin
    for y=ymin_back, ymax_back do begin
        background_1_array[x,y]=1
    endfor
endfor

;if there is a second background selection
if ((*global).selection_background_2 EQ 1) then begin  

    xmin_back_2 = XYbackground_2[0]
    xmax_back_2 = XYbackground_2[1]
    ymin_back_2 = XYbackground_2[2]
    ymax_back_2 = XYbackground_2[3]

    xmin_back_2 = round(xmin_back_2/2)
    xmax_back_2 = round(xmax_back_2/2)
    ymin_back_2 = round(ymin_back_2/2)
    ymax_back_2 = round(ymax_back_2/2)
    
    background_2_array = intarr(Nx, Ny)
    
    for x=xmin_back_2,xmax_back_2 do begin
        for y=ymin_back_2, ymax_back_2 do begin
            background_2_array[x,y]=1
        endfor
    endfor
    
;create new background array
    
    background_1_array += background_2_array
    
endif

;remove from background array, pixel already in signal array

for x=xmin_signal,xmax_signal do begin
    for y=ymin_signal, ymax_signal do begin
        background_1_array[x,y] = 0
    endfor
endfor

openw, 1, file_name

i=0
for x=0, Nx-1 do begin
    for y=0, Ny-1 do begin
        if (background_1_array[x,y] NE 0) then begin
            text = 'bank1_' + strcompress(x,/remove_all)
            text += '_' + strcompress(y,/remove_all)
            printf, 1,text
            ++i
        endif
    endfor
endfor

close, 1
free_lun, 1

end





function get_signal_background_pid_file_name, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;tmp_folder = (*global).tmp_folder
tmp_folder = (*global).local_folder
pid_file_extension = (*global).pid_file_extension
first_part = tmp_folder + (*global).instrument
first_part += "_" + (*global).run_number

signal_pid_file_name = first_part + "_signal_" + pid_file_extension
background_pid_file_name = first_part + "_background_" + pid_file_extension

signal_background_pid_file_names = [signal_pid_file_name,$
                                    background_pid_file_name]

return, signal_background_pid_file_names
end

