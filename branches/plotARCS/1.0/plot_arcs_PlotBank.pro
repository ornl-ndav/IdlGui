PRO MakeGuiBankPlot_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global2

CASE event.id OF

ELSE:
ENDCASE

END






PRO plotDasView, tvimg, i, Xfactor, Yfactor
bank = tvimg[i*8:(i+1)*8-1,*]
bank_rebin = rebin(bank,8*Xfactor, 128L*Yfactor,/sample)
tvscl, bank_rebin, /device
END






PRO plotTofView, img, i, Xfactor, Yfactor
;find out the range of non-zero values using the first non-empty bank
;bank_index = 49
bank_index = 0
;img = [1000,128,920]
tvimg1     = total(img,2)       ;tvimg1 = [1000,920]
tvimg1     = transpose(tvimg1)  ;tvimg1 = [920,1000]
ngt0 = 0
WHILE (ngt0 EQ 0) DO BEGIN
;sum the 8 tubes together
    tvimg2     = tvimg1[bank_index*8:(bank_index+1)*8-1,*]
    tvimg2     = total(tvimg2,1)
    NZindexes  = WHERE(tvimg2 GT 0, ngt0)
    bank_index++
ENDWHILE
index_start = NZindexes[0]
index_stop  = NZindexes[ngt0-1]

;keep only all data between index_start and index_stop
tvimg2     = tvimg1[*,index_start:index_stop]
Npts       = (size(tvimg2))(2) ;number of tof that survive the where GT 0 routine
dim_new    = 10                ;ratio of points we want to remove in the Y axis (tof here)
ds         = Npts/dim_new      ;resulting downsampling ratio - how many points 
;dim_new    *= 2
;to become one point

;isolate various banks of data
;plot bottom  banks
bank         = tvimg2[i*8:(i+1)*8-1,*]
IF (ds LT (size(bank))(1)) THEN BEGIN
    bank_smooth  = smooth(bank,ds,/edge)
ENDIF ELSE BEGIN
    bank_smooth = bank
ENDELSE
bank_congrid = congrid(bank_smooth,8*Xfactor,dim_new*128)
;bank_congrid = congrid(bank_smooth,8*Xfactor,(128L*Yfactor))
tvscl, bank_congrid, /device
END












PRO PlotBank, img, i, bankName, bDasView

Xfactor = 10
Yfactor = 5

;build gui
wBase = ''
MakeGuiBankPlot, wBase, Xfactor, Yfactor

global2 = ptr_new({ wbase   : wbase})

WIDGET_CONTROL, wBase, SET_UVALUE = global2
XMANAGER, "MakeGuiBankPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5

;select plot area
id = widget_info(wBase,find_by_uname='bank_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

;main data array
tvimg = total(img,1)
tvimg = transpose(tvimg)

IF (bDasView EQ 0) THEN BEGIN 
    plotDasView, tvimg, i, Xfactor, Yfactor
ENDIF ELSE BEGIN
    plotTofView, img, i, Xfactor, Yfactor
ENDELSE

;display bank number in title ba
id = widget_info(wBase,find_by_uname='bank_plot_base')
widget_control, id, base_set_title= strcompress(bankName)

END
