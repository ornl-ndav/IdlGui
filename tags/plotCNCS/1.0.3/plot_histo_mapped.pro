;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

DEVICE, DECOMPOSED = 0
loadct, 5, /SILENT

Xfactor = 4
Yfactor = 2
Xcoeff  = 8   * Xfactor
Ycoeff  = 128 * Yfactor
off     = 5
xoff    = 10

histo_mapped_file = '~/local/ARCS_1_neutron_histo_mapped.dat'
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

;##########################################
;PLOT DATA ################################
;##########################################

title = 'Real View of Instrument (Y,X integrated over TOF)'
window,0,XPOS=50,YPOS=50,XSIZE=1425,YSIZE=790, TITLE = title
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

;##########################################################
;############# Plot x,tof integrated over y ###############
;##########################################################

title = 'TOF View of Instrument (TOF,X integrated over Y)'
window,1,XPOS=50,YPOS=50,XSIZE=1425,YSIZE=790, TITLE = title

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
for i=0,(38-1) do begin
    plots, i*(Xcoeff)+i*off+xoff    , yoff       , /device, color=color
    plots, i*(Xcoeff)+i*off+xoff    , Ycoeff+yoff, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, Ycoeff+yoff, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, yoff       , /device, color=color, /continue
    plots, i*(Xcoeff)+i*off+xoff    , yoff       , /device, color=color, /continue
endfor











END
