DEVICE, DECOMPOSED = 0
loadct, 5

window,0,XPOS=50,YPOS=50,XSIZE=1425,YSIZE=790
Xfactor = 4
Yfactor = 2


;##########################################
;PLOT DATA ################################
;##########################################
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
close, u
free_lun,u

indx1 = where(data GT 0, ngt0)
img = intarr(Ntof,Ny,Nx)
IF (ngt0 GT 0) THEN BEGIN
    img(indx1) = data(indx1)
ENDIF

tvimg = total(img,1)
tvimg = transpose(tvimg)

;isolate various banks of data
bank = lonarr(8,128)
;plot bottom  banks
for i=0,(38-1) do begin
    bank = tvimg[i*8:(i+1)*8-1,*]
    bank_rebin = rebin(bank,8*Xfactor, 128*Yfactor,/sample)
    tvscl, bank_rebin, /device, i*(Xcoeff)+i*off+xoff,  off
endfor

;plot middle banks
yoff   = Ycoeff + 2*off
for i=38,68 do begin
    bank = tvimg[i*8:(i+1)*8-1,*]
    bank_rebin = rebin(bank,8*Xfactor, 128*Yfactor,/sample)
    tvscl, bank_rebin, /device, (i-38)*(Xcoeff)+(i-38)*off+xoff, yoff
endfor

;plot 32A and 32B of middle banks


;plot 33 to 38 of middle banks


;plot top banks
yoff   = 2*Ycoeff + 3*off
for i=77,114 do begin
    bank = tvimg[i*8:(i+1)*8-1,*]
    bank_rebin = rebin(bank,8*Xfactor, 128*Yfactor,/sample)
    tvscl, bank_rebin, /device, (i-77)*(Xcoeff)+(i-77)*off+xoff, yoff
endfor



;##########################################
;PLOT BANKS GRID ##########################
;##########################################
Xcoeff = 8   * Xfactor
Ycoeff = 128 * Yfactor
off    = 5
xoff   = 10
;;plot grid of bottom bank
color  = 100
for i=0,(38-1) do begin
    plots, i*(Xcoeff)+i*off+xoff    , off       , /device, color=color
    plots, i*(Xcoeff)+i*off+xoff    , Ycoeff+off, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, Ycoeff+off, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, off       , /device, color=color, /continue
    plots, i*(Xcoeff)+i*off+xoff    , off       , /device, color=color, /continue
endfor

;;plot grid of middle bank
;from bank 1 to 31
color  = 150
yoff   = Ycoeff + 2*off
for i=0,(31-1) do begin
    plots, i*(Xcoeff)+i*off+xoff    , yoff , /device, color=color
    plots, i*(Xcoeff)+i*off+xoff    , yoff+Ycoeff , /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, yoff+Ycoeff , /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, yoff , /device, color=color, /continue
    plots, i*(Xcoeff)+i*off+xoff    , yoff  , /device, color=color, /continue
endfor

;bank 32A and 32B
color  = 200
yoff   = Ycoeff + 2*off
Ycoeff = 128
i=31
plots, i*(Xcoeff)+i*off+xoff    , yoff , /device, color=color
plots, i*(Xcoeff)+i*off+xoff    , yoff+Ycoeff , /device, color=color, /continue
plots, (i+1)*(Xcoeff)+i*off+xoff, yoff+Ycoeff , /device, color=color, /continue
plots, (i+1)*(Xcoeff)+i*off+xoff, yoff , /device, color=color, /continue
plots, i*(Xcoeff)+i*off+xoff    , yoff  , /device, color=color, /continue

yoff   = 3*Ycoeff + 2*off
plots, i*(Xcoeff)+i*off+xoff    , yoff , /device, color=color
plots, i*(Xcoeff)+i*off+xoff    , Ycoeff+yoff , /device, color=color, /continue
plots, (i+1)*(Xcoeff)+i*off+xoff, Ycoeff+yoff , /device, color=color, /continue
plots, (i+1)*(Xcoeff)+i*off+xoff, yoff , /device, color=color, /continue
plots, i*(Xcoeff)+i*off+xoff    , yoff  , /device, color=color, /continue

;from bank 33 to 38
color  = 150
Ycoeff = 128 * 2
yoff   = Ycoeff + 2*off
for i=32,(38-1) do begin
    plots, i*(Xcoeff)+i*off+xoff    , yoff , /device, color=color
    plots, i*(Xcoeff)+i*off+xoff    , yoff+Ycoeff , /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, yoff+Ycoeff , /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, yoff , /device, color=color, /continue
    plots, i*(Xcoeff)+i*off+xoff    , yoff  , /device, color=color, /continue
endfor

;;plot grid of top banks
color  = 100
yoff   = 2*Ycoeff + 3*off
for i=0,(38-1) do begin
    plots, i*(Xcoeff)+i*off+xoff    , yoff       , /device, color=color
    plots, i*(Xcoeff)+i*off+xoff    , Ycoeff+yoff, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, Ycoeff+yoff, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, yoff       , /device, color=color, /continue
    plots, i*(Xcoeff)+i*off+xoff    , yoff       , /device, color=color, /continue
endfor

END
