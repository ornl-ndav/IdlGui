; if the histogram h248 does not exist, read in the histograms generated with dqtbinning from disk
if not var_defined(h248) then begin&$
restore,'/SNS/NOM/histo/histo248un.dat'&$
restore,'/SNS/NOM/histo/histo249un.dat'&$
restore,'/SNS/NOM/histo/histo250un.dat'&$
restore,'/SNS/NOM/histo/histo253un.dat'&$
restore,'/SNS/NOM/histo/histo254un.dat'&$
restore,'/SNS/NOM/histo/histo255un.dat'&$
endif

; this specifies bad detector 8-packs
bad=[5,6,9,10,11,22,25,32,33]

; things preceeded with ;;; are not needed at this point
;;; restore,'histo178.dat'

; simb (Si measurement minus background) is the variable containing the 
; histogram 
simb=(h248+h249+h250)/3-(h253+h254+h255)/3.
;;; restore,'fmatrix191_34.dat'

; define the variable fmatrix as a floating point array 
fmatrix=findgen(34*1024l)

;;;limit=0.01

; number of 8-packs in equivalent positions (banks)
n2=6&n3=9&n4=8&n5=7&n6=2&n1=2

;;;simb=(h191-h178)
;;;simb=(h119f)-h103f*(c119)/float(c103)
;;;simb(22*1024l:23*1024l-1,*)=0
;;;;simb(11*1024l:12*1024l-1,*)=0

; define a Q vector (may not be needed)
q=findgen(2500)*.02

; generate variables with nominal detector positions
there,nthere,there,eightpacks
detpos,tt,phi,r

; cell parameter for Si
a=5.4309
hkl=[3,8,11,16,19,24,27]
; where the peak should be
approx=2*!pi*sqrt(hkl)/a

; go through all detectors in the first bank
for i=0,n2-1 do begin&$
; don't even look at it if we already know it's bad
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,simb,i,res,thre=3e-7&$
; calculate a new two theta based on the result
corrf=approx(0)/poly(findgen(128),[res(0),res(1)/2.,res(2)/4.])&$
for j=0,7 do begin& fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&end&$
endif&$
; if we don't know anything because the detector is bad keep the nominal values
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&end&$
endif&$
print,i&$
endfor

; same for the next group of detectors
for i=n2,n2+n3-1 do begin&$
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,simb,i,res,thre=1e-6&$
corrf=approx(0)/poly(findgen(128),[res(0),res(1)/2.,res(2)/4.])&$
for j=0,7 do begin& fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&end&$
endif&$
print,i&$ 
endfor 

; same again but use the (220) reflection (The (111) doesn't show up) 
print,'Now 220'
for i=n2+n3,n2+n3+n4-1 do begin&$
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,simb,i,res,thre=1e-6&$
corrf=approx(1)/poly(findgen(128),[res(0),res(1)/2.,res(2)/4.])&$
for j=0,7 do begin& fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&end&$
endif&$
print,i&$
endfor

; same again but now the (220) and the (111) are hidden
print,'Now 311'
for i=n2+n3+n4,n2+n3+n4+n5-1 do begin&$
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,simb,i,res,thre=1e-6&$
corrf=approx(1)/poly(findgen(128),[res(0),res(1)/2.,res(2)/4.])&$
for j=0,7 do begin& fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&end&$
endif&$
print,i&$
endfor

; same again but now the (311), (220), the (111) are hidden
print,'Now 400' 
for i=n2+n3+n4+n5,n2+n3+n4+n5+n6-1 do begin&$
w=where(i eq bad,n1)&$ 
if n1 lt 1 then begin&$
manfocus,simb,i,res,thre=1e-6&$
corrf=approx(1)/poly(findgen(128),[res(0),res(1)/2.,res(2)/4.])&$
for j=0,7 do begin& fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&end&$
endif&$
print,i&$
endfor

;save fmatrix for future use
save,fmatrix,'fmatrix246.dat'

