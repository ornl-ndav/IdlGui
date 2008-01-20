PRO MakeGuiMainPLot_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global1

CASE event.id OF

;selection of mbar button - DAS view
    widget_info(event.top, FIND_BY_UNAME='plot_das_view_button_mbar'): begin
        plotDASviewFullInstrument, global1
    end

;selection of mbar button - tof view 
    widget_info(event.top, FIND_BY_UNAME='plot_tof_view_button_mbar'): begin
        plotTOFviewFullInstrument, global1
    end

ELSE:
ENDCASE

END
















PRO plotGridMainPlot, global1

;retrieve values from inside structure
Xfactor = (*global1).Xfactor
Yfactor = (*global1).Yfactor
Xcoeff  = (*global1).Xcoeff
Ycoeff  = (*global1).Ycoeff
off     = (*global1).off
xoff    = (*global1).xoff

;##########################################
;PLOT BANKS GRID ##########################
;##########################################
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
FOR i=0,(38-1) DO BEGIN
    plots, i*(Xcoeff)+i*off+xoff    , yoff       , /device, color=color
    plots, i*(Xcoeff)+i*off+xoff    , Ycoeff+yoff, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, Ycoeff+yoff, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, yoff       , /device, color=color, /continue
    plots, i*(Xcoeff)+i*off+xoff    , yoff       , /device, color=color, /continue
ENDFOR

END




PRO plotDASviewFullInstrument, global1

;retrieve values from inside structure
img     = (*(*global1).img)
Xfactor = (*global1).Xfactor
Yfactor = (*global1).Yfactor
Xcoeff  = (*global1).Xcoeff
Ycoeff  = (*global1).Ycoeff
off     = (*global1).off
xoff    = (*global1).xoff

;main data array
tvimg = total(img,1)
tvimg = transpose(tvimg)

;select plot area
id = widget_info((*global1).wBase,find_by_uname='main_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value
ERASE

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

;plot grid
plotGridMainPlot, global1
END






PRO plotTOFviewFullInstrument, global1

;##########################################################
;############# Plot x,tof integrated over y ###############
;##########################################################

;select plot area
id = widget_info((*global1).wBase,find_by_uname='main_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value
ERASE

;retrieve values from inside structure
img     = (*(*global1).img)
Xfactor = (*global1).Xfactor
Yfactor = (*global1).Yfactor
Xcoeff  = (*global1).Xcoeff
Ycoeff  = (*global1).Ycoeff
off     = (*global1).off
xoff    = (*global1).xoff
img     = (*(*global1).img)

;find out the range of non-zero values using bank #41
bank_index = 49
;img = [1000,128,920]
tvimg1     = total(img,2)       ;tvimg1 = [1000,920]
tvimg1     = transpose(tvimg1)  ;tvimg1 = [920,1000]

;sum the 8 tubes together
tvimg2     = tvimg1[bank_index*8:(bank_index+1)*8-1,*]
tvimg2     = total(tvimg2,1)
NZindexes  = WHERE(tvimg2 GT 0, ngt0)
index_start = NZindexes[0]
index_stop  = NZindexes[ngt0-1]

;keep only all data between index_start and index_stop
tvimg2     = tvimg1[*,index_start:index_stop]
Npts       = (size(tvimg2))(2) ;number of tof that survive the where GT 0 routine
dim_new    = Ycoeff            ;number of points we want in the Y axis (tof here)
ds         = Npts/dim_new      ;resulting downsampling ratio - how many points 
dim_new    *= 2
;to become one point

;isolate various banks of data
;plot bottom  banks
for i=0,(38-1) do begin
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    bank_smooth  = smooth(bank,ds,/edge)
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new)
    tvscl, bank_congrid, /device, i*(Xcoeff)+i*off+xoff, off
endfor

;plot middle banks
yoff   = Ycoeff + 2*off
for i=38,68 do begin
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    bank_smooth  = smooth(bank,ds,/edge)
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new)
    tvscl, bank_congrid, /device, (i-38)*(Xcoeff)+(i-38)*off+xoff, yoff
endfor

;plot 32A and 32B of middle banks


;plot 33 to 38 of middle banks


;plot top banks
yoff   = 2*Ycoeff + 3*off
for i=77,114 do begin
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    bank_smooth  = smooth(bank,ds,/edge)
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new)
    tvscl, bank_congrid, /device, (i-77)*(Xcoeff)+(i-77)*off+xoff, yoff
endfor

;plot grid
plotGridMainPlot, global1

END














PRO PlotMainPlot, histo_mapped_file

;build gui
wBase = ''
MakeGuiMainPlot, wBase
;main parameters
Xfactor = 4
Yfactor = 2
Xcoeff  = 8   * Xfactor
Ycoeff  = 128 * Yfactor
off     = 5
xoff    = 10

global1 = ptr_new({ histo_file_name : histo_mapped_file,$
                    Xfactor : 4,$
                    Yfactor : 2,$
                    Xcoeff  : 8 * 4,$
                    Ycoeff  : 128L * 2,$
                    off     : 5,$
                    xoff    : 10,$
                    img     : ptr_new(0L),$
                    wbase   : wbase})

WIDGET_CONTROL, wBase, SET_UVALUE = global1
XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5

;open file
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

(*(*global1).img)= img

;plot das view of full instrument
plotDASviewFullInstrument, global1

END
