;Create the output array for signal selection
pro CREATE_SIGNAL_PID_FILE, XY, file_name

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

