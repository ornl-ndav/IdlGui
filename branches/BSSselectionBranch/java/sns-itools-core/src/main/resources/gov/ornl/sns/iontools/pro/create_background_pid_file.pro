;Create the output array for background selection
pro CREATE_BACKGROUND_PID_FILE, Nx, Ny, $
                                XYsignal, $
                                XYbackground, $
                                XYbackground_2, $
                                back2_selected,$
                                file_name

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
if (back2_selected EQ 1) then begin  

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

