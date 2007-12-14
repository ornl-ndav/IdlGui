histo_mapped_file = '~/local/ARCS_5_neutron_histo_mapped.dat'
openr,u,histo_mapped_file,/get
fs=fstat(u)

Nx = long(38*8*3+8)
Ny = long(128)
Nimg = long(Nx*Ny)
Ntof = fs.size/(Nimg*4L)

;read data
data = lonarr(Ntof*Nimg)
readu,u,data

indx1 = where(data GT 0, ngt0)
img = intarr(Ntof,Ny,Nx)
IF (ngt0 GT 0) THEN BEGIN
    img(indx1) = data(indx1)
ENDIF

tvimg = total(img,1)
tvimg = transpose(tvimg)

;plot the data
DEVICE, DECOMPOSED = 0
loadct, 5

window,0
tvscl, tvimg, /device

close, u
free_lun,u


END
