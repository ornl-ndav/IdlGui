;if not var_defined(h511) then begin&$
;;restore,'/SNS/NOM/histo/histo511.dat'&$
;;endif
bad=[1,2,7,13,18,22,25,34,35,36,37]

openw,3,'nomad629.calfile'
printf,3,'#  number  UDET  offset  select  group'
index=0l
;;; restore,'histo178.dat'
simb=(h629)
;;; restore,'fmatrix191_34.dat'
fmatrix=findgen(38*1024l)

limit=0.01

n2=6&n3=9&n4=8&n5=7&n6=4&n1=4


q=findgen(2500)*.02

there,nthere,there,eightpacks
detpos,tt,phi,r
packs=fltarr(nthere,n_elements(q))
;;a=3.524 Ni
a= 5.4309 ;Si

hkl=[3,8,11,16,19]
approx=2*!pi*sqrt(hkl)/a
all=q*0
simbr=simb*0
h629b=fltarr(38*1024l,1000)
for i=0l,38912l-1 do h629b(i,*)=rebin(reform(h629(i,*)),1000)

; Bank 2 (gsas 5) 10-20 degree
for i=0,n2-1 do begin&$
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,h629b,i,resres,thre=7e-7,hkl=[8,11,3,8,11,16],q=findgen(8000)*.01,nonman=2,maxq=7,ndeg=4&$
;;;manfocus,simb,i,resres,thre=1e-5,hkl=[8,11],a=a,q=q,nonman=0,ndeg=4&$
prtc&$
for j=0,7 do begin& corrf=1./poly(findgen(128),resres(*,j,0))&$
fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,-corrf(k)+1,1,5&$
index=index+1&$
end&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,0,0,5&$
index=index+1&$
end&end&$
endif&$
print,i&$
endfor&$
end
;Bank 3 (Gsas 4) 20-45 degree
for i=n2,n2+n3-1 do begin&$
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,h629b,i,resres,thre=7e-7,hkl=[8,11,3,8,11,16],q=findgen(8000)*.01,nonman=2,maxq=7,ndeg=4&$

;;;manfocus,simb,i,resres,thre=1e-5,hkl=[8,11],a=a,q=q,nonman=0,ndeg=4&$
prtc&$
for j=0,7 do begin& corrf=1./poly(findgen(128),resres(*,j,0))&$
fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,-corrf(k)+1,1,4&$
index=index+1&$
end&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,0,0,4&$
index=index+1&$
end&end&$
simbr(i*1024l:(I+1)*1024l-1,*)=simb(i*1024l:(I+1)*1024l-1,*)&$
endif&$
print,i&$ 
endfor 

; bank 4 (gsas 3) 90 degree
print,'Now 400 at 4.6'
for i=n2+n3,n2+n3+n4-1 do begin&$
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,h629,i,resres,thre=2e-6,hkl=[8,11,3,8,11,16,19,24],q=findgen(8000)*.0025,nonman=2,maxq=7,ndeg=4&$
;;manfocus,simb,i,resres,thre=2e-5,hkl=[16,19],a=a,q=q,nonman=0,ndeg=4&$
prtc&$
for j=0,7 do begin& corrf=1./poly(findgen(128),resres(*,j,0))&$
fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,-corrf(k)+1,1,3&$
index=index+1&$
end&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,0,0,3&$
index=index+1&$
end&end&$
simbr(i*1024l:(I+1)*1024l-1,*)=simb(i*1024l:(I+1)*1024l-1,*)&$
endif&$
print,i&$
endfor
; bank 5 (gsas 2) 145 degree 
print,'Now 400 at 4.6'
for i=n2+n3+n4,n2+n3+n4+n5-1 do begin&$
w=where(i eq bad,n1)&$
if n1 lt 1 then begin&$
manfocus,h629,i,resres,thre=2e-6,hkl=[24,27,3,8,11,16,19,24],q=findgen(8000)*.0025,nonman=2,maxq=7,ndeg=4&$
;;;manfocus,simb,i,resres,thre=1e-4,hkl=[16,19],a=a,q=q,nonman=0,ndeg=4&$
prtc&$
for j=0,7 do begin& corrf=1./poly(findgen(128),resres(*,j,0))&$
fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,-corrf(k)+1,1,2&$
index=index+1&$
end&end&$
;quickrebin,simb,i,resres,rebinned,summedup,q=q&$
;simbr(i*1024l:(I+1)*1024l-1,*)=rebinned&$
;all=all+summedup&$
;packs(i,*)=summedup&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,0,0,2&$
index=index+1&$
end&end&$
simbr(i*1024l:(I+1)*1024l-1,*)=simb(i*1024l:(I+1)*1024l-1,*)&$
endif&$
print,i&$
endfor
; bank 6 (gsas 1) backscattering
print,'Now 400 at 4.6' 
for i=n2+n3+n4+n5,n2+n3+n4+n5+n6-1 do begin&$
w=where(i eq bad,n1)&$ 
if n1 lt 1 then begin&$
manfocus,h629,i,resres,thre=4e-6,hkl=[24,27,3,8,11,16,19,24,32,35,40],q=findgen(8000)*.0025,nonman=2,maxq=7,ndeg=4&$
;;;manfocus,simb,i,resres,thre=3e-3,hkl=[16,19],a=a,q=q,nonman=0,ndeg=4&$
prtc&$
for j=0,7 do begin& corrf=1./poly(findgen(128),resres(*,j,0))&$
fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,-corrf(k)+1,1,1&$
index=index+1&$
end&end&$
endif&$
if (n1 gt 0) then begin&$
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,0,0,1&$
index=index+1&$
end&end&$
simbr(i*1024l:(I+1)*1024l-1,*)=simb(i*1024l:(I+1)*1024l-1,*)&$
endif&$
print,i&$
endfor
; bank 1 (gsas 6) forward
h629b=fltarr(38*1024l,500)
for i=0l,38912l-1 do h629b(i,*)=rebin(reform(h629(i,*)),500)

for i=34,37 do begin&$
w=where(i eq bad,n1)&$  
if n1 lt 1 then begin&$ 
manfocus,h629b,i,resres,thre=1e-7,hkl=[8,11,3,8,11,16],q=findgen(500)*.02,nonman=2,maxq=7,ndeg=4,na=10&$
manfocus,simb,i,resres,thre=2e-6,hkl=[8,11],a=a,q=q,nonman=0,nde=6&$
prtc&$
for j=0,7 do begin& corrf=1./poly(findgen(128),resres(*,j,0))&$
fmatrix(i*1024l+j*128+findgen(128))=2*asin(sin(tt(8*eightpacks(i),*)/2)*corrf)&$
for k=0,127l do begin&$
printf,3,index,eightpacks(i)*1024l+j*128+k,-corrf(k)+1,1,6&$
index=index+1&$
end&end&endif&$
if (n1 gt 0) then begin&$ 
for j=0,7 do begin &fmatrix(i*1024l+j*128+findgen(128))=tt(8*eightpacks(i),*)&$
for k=0,127l do begin&$ 
printf,3,index,eightpacks(i)*1024l+j*128+k,0,0,1&$
index=index+1&$ 
end&end&$ 
simbr(i*1024l:(I+1)*1024l-1,*)=simb(i*1024l:(I+1)*1024l-1,*)&$
endif&$ 
print,i&$ 
endfor 

close,3
