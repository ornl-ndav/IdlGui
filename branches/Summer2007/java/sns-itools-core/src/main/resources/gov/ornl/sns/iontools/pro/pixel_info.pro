function distanceFromXborder, x
a = x * 0.7 ;in mm
return, a
end


function distanceFromXcenter, x
center_offset = 0.35
if (x LE 151) then begin        ;first half
    x_diff = 151-x
endif else begin                ;second half
    x_diff = x-152
endelse
b = center_offset + x_diff * 0.7 ;in mn
return, b
end


function distanceFromYborder, y
c = y * 0.7 ;in mm
return, c
end


function distanceFromYcenter, y
center_offset = 0.35
if (y LE 127) then begin        ;first half
 y_diff = 127-y
endif else begin                ;second half
 y_diff = y-128
endelse
d = center_offset + y_diff * 0.7 ; in mm
return, d
end


function getNumberOfCounts, Nx, Ny, tmp_file_name, x_local, y_local
openr,u,tmp_file_name,/get
fs = fstat(u)
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)
data_assoc = assoc(u,lonarr(Ntof))
;make the image array
img = lonarr(long(Ny),long(Nx))
for i=0L,Nimg-1 do begin
    x = i MOD Ny
    y = i/Ny
    img[x,y] = total(data_assoc[i])
endfor
close, u
free_lun, u
img=transpose(img)    
return, img[x_local,y_local]
end


function getPixelId, Nx, x, y
return, x + Nx*y
end


FUNCTION PIXEL_INFO, Nx, Ny, tmp_file_name, x, y

distXBorder = distanceFromXborder(x)
distXCenter = distanceFromXcenter(x)
distYBorder = distanceFromYborder(y)
distYCenter = distanceFromYcenter(y)
nbrCounts = getNumberOfCounts(Nx, Ny, tmp_file_name, x,y)
pixelID = getPixelId(Nx,x,y)
return, [strcompress(distXBorder),$
         strcompress(distXCenter),$
         strcompress(distYBorder),$
         strcompress(distYCenter),$
         strcompress(nbrCounts),$
         strcompress(pixelID)]
end















