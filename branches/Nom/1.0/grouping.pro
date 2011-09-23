pro grouping,histo,sumall,ibank,ipacks,itubes,wherebad=wherebad,abskorr=abskorr,multkorr=multkorr

if not var_defined(wherebad) then wherebad=[999999]
if not var_defined(abskorr) then abskorr=0
if not var_defined(multkorr) then multkorr=0
old=0

there,nthere,there,eightpacks,banks,old=old
nnn=indgen(6)
for i=0,5 do begin
w=where(banks(i,*) ne 99,n1)
nnn(i)=n1
endfor

for i=1,5 do nnn(i)=nnn(i)+nnn(i-1)
nnn=nnn-1
ntubes=nthere*8
npixels=nthere*1024l
nq=n_elements(histo(0,*))
itubes=fltarr(ntubes,nq)
ipacks=fltarr(nthere,nq)
ibank=fltarr(6,nq)
sumall=fltarr(nq)

; sum all pixels that are not bad into tubes

for i=0l,npixels-1 do begin
w=where(i eq wherebad,n1)
if n1 lt 1 then begin
tube=i/128
itubes(tube,*)=itubes(tube,*)+histo(i,*)
endif
endfor

; sum all tubes into eightpacks and sum all pixels into one array

for i=0,ntubes-1 do begin
pack=i/8
ipacks(pack,*)=ipacks(pack,*)+itubes(i,*)
sumall=sumall+itubes(i,*)
endfor

; sum packs into banks
ib=0
for i=0,nthere-1 do begin
if (i gt nnn(ib)) then ib=ib+1 
ibank(ib,*)=ibank(ib,*)+ipacks(i,*)
endfor
return
end
