PRO REPLOT_DATA, run_number, instrument, ucams, loadct_variable

if (instrument EQ 'REF_L') then begin
    Nx = 304L
    Ny = 256L
endif else begin
    Nx = 256L
    Ny = 304L
endelse

file = '/SNS/users/' + ucams + '/local/' + instrument + '_tmp_histo_data.dat'
    
                                ;only read data if valid file given

openr,u,file,/get
                                ;find out file info
fs = fstat(u)

Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)

data_assoc = assoc(u,lonarr(Ntof))

                                ;make the image array
img = lonarr(Nx,Ny)

for i=0L,Nimg-1 do begin
    x = i MOD Nx
    y = i/Nx
    img[x,y] = total(data_assoc[i])
endfor

close, u
free_lun, u

img=transpose(img)    
set_plot, 'z'                   ;put image data in the display window
New_Nx = long(Nx*2)
New_Ny = long(2*Ny)
DEVICE,SET_RESOLUTION=[New_Ny,New_Nx]
erase

tvimg = rebin(img, New_Ny, New_Nx,/sample)
tvscl, tvimg, /device

tvimg=TVRD()
set_plot,'ION'

loadct,loadct_variable,/silent

tv,tvimg,0,-1

foundNeXus = 1

END


