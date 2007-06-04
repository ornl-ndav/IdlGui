function imageproc_load_new, fname

filename = "/var/www/html/j35ion/java/IonData/";
filename = filename + fname
print,'filename ', filename
;'endocell.jpg'
;'glowing_gas.jpg'
;'marsglobe.jpg'
;'meteor_crater.jpg'

    read_jpeg, filename, image
    wset, 0
    if (size(image,/n_dimensions) eq 3) then begin
        newImage = bytarr(3, 640, 512)
        newimage[0,*,*] = congrid(image[0,*, *], 1, 640, 512)
        newimage[1,*,*] = congrid(image[1,*, *], 1, 640, 512)
        newimage[2,*,*] = congrid(image[2,*, *], 1, 640, 512)
        tmpimage = fix(newimage[0,*,*]) + fix(newimage[1,*,*]) + $
            fix(newimage[2,*,*])
        tmpimage = bytscl(tmpimage)
        newimage = reform(tmpimage)
    endif else begin
        newimage = congrid(image, 640, 512)
    endelse
    tv, rebin(newimage, 320, 256)

    return, newimage
end
