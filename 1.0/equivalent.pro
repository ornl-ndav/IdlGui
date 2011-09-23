pro equivalent,histo,iqes,ipacks,sumall,ibank,itubes,limit=limit,bad=bad,old=old,btl=btl ,usebtl=usebtl, replace=replace,abskorr=abskorr,multkorr=multkorr

if not var_defined(limit) then limit=[4,124] 
if not var_defined(bad) then bad=[999]
if not var_defined(replace) then replace=0
if not var_defined(abskorr) then abskorr=0
if not var_defined(multkorr) then multkorr=0
if not var_defined(usebtl) then usebtl=0
if var_defined(btl) then begin
makebtl=0
nbtl2=n_elements(btl)/2
endif
if not var_defined(btl) then begin
btl=[999,999]
makebtl=1
usebtl=0
end

there,nthere,there,eightpacks,banks,old=old

nnn=fltarr(6)
for i=0, 5 do begin&$
w=where(banks(i,*) ne 99,nn)&$
nnn(i)=nn&$
end
nn2=nnn(0)&n3=nnn(1)&n4=nnn(2)&n5=nnn(3)&n6=nnn(4)&nn1=nnn(5)


if abskorr then begin
absfile='muabs_v.dat'
restore,absfile
lambda=findgen(31)*.1
endif

s=size(histo)
nq=s(2)
if nq eq 0 then return
iqes=fltarr(6*128,nq)
ipacks=fltarr(nthere,nq)
ibank=fltarr(6,nq)
itubes=fltarr(8*nthere,nq)

for i=0,nthere-1 do begin
for k=0,7 do begin
for j=limit(0),limit(1) do begin
itubes(i*8+k,*)=itubes(i*8+k,*)+histo(i*1024l+k*128l+j,*)
end
end
end


for j=0,nn2-1 do begin
  tottube=findgen(8)
;;;data=histo((j*8)*128l+lindgen(1024),*)
;;;for k=0,7 do tottube(k)=total(data(k*128l:k*128+127,*))
  for k=0,7 do tottube(k)=total(itubes(j*8+k,*))
   m=median(tottube) 
   badtube=where(tottube lt .2*m,n2)
   if makebtl and  (n2 ne 0) then begin &for ibt=0,n2-1 do btl=[btl,badtube(ibt),j]&end
   if not makebtl then begin
     ww=where(btl(findgen(nbtl2)*2+1) eq j,n3)
     if n3 ne n2 then print,'badtube=',badtube,'in pack',j,'compared to list',btl(ww*2)
;;   endif ;  not makebtl 
   if not usebtl and  (n2 ne 0) then begin
     for ibt=0,n2-1 do print,'Not using bad tube list, badtube='+string(badtube(ibt),format='(i3)')+'in pack'+string(j,format='(i3)')
   endif ;  not usebtl
   if usebtl and n3 gt 0 then badtube=btl(ww*2)
   if usebtl and n3 eq 0 then badtube=99
  endif ; not makebtl
  w=where(j eq bad,n1)
    for k=0,7 do begin
    w=where(k eq badtube,n2)
      for i=0,1*128l-1 do begin
        if n1 lt 1 and n2 eq 0 then iqes(i,*)=iqes(i,*)+histo((j*8+k-0)*128l+i,*)
      endfor ; for i
    endfor ;for k
endfor ;for j
off=nn2
for j=0,n3-1 do begin
w=where(j+off eq bad,n1)
;;data=histo(((j+off)*8+k-0)*128l+lindgen(1024),*)
;;for k=0,7 do tottube(k)=total(data(k*128l:k*128+127,*))
for k=0,7 do tottube(k)=total(itubes((j+off)*8+k,*))
m=median(tottube)
badtube=where(tottube lt .2*m,n2)
if makebtl and  (n2 ne 0) then begin& for ibt=0,n2-1 do btl=[btl,badtube(ibt),j+off]&end
if not makebtl then begin
ww=where(btl(findgen(nbtl2)*2+1) eq j+off,n3)
if n3 ne n2 then print,'badtube=',badtube,'in pack',j+off,'compared to list',btl(ww*2)
if not usebtl and  (n2 ne 0) then begin
for ibt=0,n2-1 do print,'Not using bad tube list, badtube='+string(badtube(ibt),format='(i3)')+'in pack'+string(j+off,format='(i3)')
end
if usebtl and n3 gt 0 then badtube=btl(ww*2)
if usebtl and n3 eq 0 then badtube=99
end
for k=0,7 do begin
for i=1*128l,2*128l-1 do begin
w=where(k eq badtube,n2)
if n1 lt 1 and n2 eq 0 then iqes(i,*)=iqes(i,*)+histo(((off+j)*8+k-1)*128l+i,*)
end&end&end
off=nn2+n3
for j=0,n4-1 do begin
w=where(j+off eq bad,n1)
;;;data=histo(((j+off)*8+k-0)*128l+lindgen(1024),*)
;;;for k=0,7 do tottube(k)=total(data(k*128l:k*128+127,*))
for k=0,7 do tottube(k)=total(itubes((j+off)*8+k,*))
m=median(tottube)
badtube=where(tottube lt .2*m,n2)
if makebtl and  (n2 ne 0) then begin &for ibt=0,n2-1 do btl=[btl,badtube(ibt),j+off]&end
if not makebtl then begin
ww=where(btl(findgen(nbtl2)*2+1) eq j+off,n3)
if n3 ne n2 and n3 gt 0 then print,'badtube=',badtube,'in pack',j+off,'compared to list',btl(ww*2)
if n3 ne n2 and n3 eq 0 then print,'badtube=',badtube,'in pack',j+off,'nothing wrong according to btl'
if not usebtl and  (n2 ne 0) then begin
for ibt=0,n2-1 do print,'Not using bad tube list, badtube='+string(badtube(ibt),format='(i3)')+'in pack'+string(j+off,format='(i3)')
end
if usebtl and n3 gt 0 then badtube=btl(ww*2)
if usebtl and n3 eq 0 then badtube=99
end

for k=0,7 do begin
for i=2*128l,3*128l-1 do begin
w=where(k eq badtube,n2)
if n1 lt 1 and n2 eq 0 then iqes(i,*)=iqes(i,*)+histo(((off+j)*8+k-2)*128l+i,*)
end&end&end
off=nn2+n3+n4
for j=0,n5-1 do begin
w=where(j+off eq bad,n1)

;;data=histo(((j+off)*8+k-0)*128l+lindgen(1024),*)
;;for k=0,7 do tottube(k)=total(data(k*128l:k*128+127,*))
for k=0,7 do tottube(k)=total(itubes((j+off)*8+k,*))
m=median(tottube)
badtube=where(tottube lt .2*m,n2)
if makebtl and  (n2 ne 0) then begin &for ibt=0,n2-1 do btl=[btl,badtube(ibt),j+off]&end

if not makebtl then begin
ww=where(btl(findgen(nbtl2)*2+1) eq j+off,n3)
if n3 ne n2 and n3 gt 0 then print,'badtube=',badtube,'in pack',j+off,'compared to list',btl(ww*2)
if n3 ne n2 and n3 eq 0 then print,'badtube=',badtube,'in pack',j+off,'nothing wrong according to btl'

if not usebtl and  (n2 ne 0) then begin
for ibt=0,n2-1 do print,'Not using bad tube list, badtube='+string(badtube(ibt),format='(i3)')+'in pack'+string(j+off,format='(i3)')
end
if usebtl and n3 gt 0 then badtube=btl(ww*2)
if usebtl and n3 eq 0 then badtube=99
end

for k=0,7 do begin
w=where(k eq badtube,n2)
for i=3*128l,4*128l-1 do begin
if n1 lt 1 and n2 eq 0 then iqes(i,*)=iqes(i,*)+histo(((off+j)*8+k-3)*128l+i,*)
end&end&end
off=nn2+n3+n4+n5
for j=0,n6-1 do begin
w=where(j+off eq bad,n1)
;;data=histo((j*8+k-0)*128l+lindgen(1024),*)
;;for k=0,7 do tottube(k)=total(data(k*128l:k*128+127,*))
for k=0,7 do tottube(k)=total(itubes((j+off)*8+k,*))
m=median(tottube)
badtube=where(tottube lt .2*m,n2)
if makebtl and  (n2 ne 0) then begin &for ibt=0,n2-1 do btl=[btl,badtube(ibt),j+off]&end
if not makebtl then begin
ww=where(btl(findgen(nbtl2)*2+1) eq j+off,n3)
if n3 ne n2 and n3 gt 0 then print,'badtube=',badtube,'in pack',j+off,'compared to list',btl(ww*2)
if n3 ne n2 and n3 eq 0 then print,'badtube=',badtube,'in pack',j+off,'nothing wrong according to btl'
if not usebtl and  (n2 ne 0) then begin
for ibt=0,n2-1 do print,'Not using bad tube list, badtube='+string(badtube(ibt),format='(i3)')+'in pack'+string(j+off,format='(i3)')
end 
if usebtl and n3 gt 0 then badtube=btl(ww*2)
if usebtl and n3 eq 0 then badtube=99
end
for k=0,7 do begin
w=where(k eq badtube,n2)
for i=4*128l,5*128l-1 do begin
if n1 lt 1 and n2 eq 0 then iqes(i,*)=iqes(i,*)+histo(((off+j)*8+k-4)*128l+i,*)
end&end&end
off=nn2+n3+n4+n5+n6
for j=0,nn1-1 do begin
w=where(j+off eq bad,n1)
;;data=histo(((j+off)*8+k-0)*128l+lindgen(1024),*)
;;for k=0,7 do tottube(k)=total(data(k*128l:k*128+127,*))
for k=0,7 do tottube(k)=total(itubes((j+off)*8+k,*))
m=median(tottube)
badtube=where(tottube lt .2*m,n2)
if makebtl and  (n2 ne 0) then begin &for ibt=0,n2-1 do btl=[btl,badtube(ibt),j+off]&end
if not makebtl then begin
ww=where(btl(findgen(nbtl2)*2+1) eq j+off,n3)
if n3 ne n2 and n3 gt 0 then print,'badtube=',badtube,'in pack',j+off,'compared to list',btl(ww*2)
if not usebtl and  (n2 ne 0) then begin
for ibt=0,n2-1 do print,'Not using bad tube list, badtube='+string(badtube(ibt),format='(i3)')+'in pack'+string(j+off,format='(i3)')
end 
if usebtl and n3 gt 0 then badtube=btl(ww*2)
if usebtl and n3 eq 0 then badtube=99
end
for k=0,7 do begin
w=where(k eq badtube,n2)
for i=5*128l,6*128l-1 do begin
if n1 lt 1 and n2 eq 0 then iqes(i,*)=iqes(i,*)+histo(((off+j)*8+k-5)*128l+i,*)
end&end&end
sumall=fltarr(nq)
active=findgen(limit(1)-limit(0)+1)+limit(0)
for i=1,5 do active=[active,findgen(limit(1)-limit(0)+1)+limit(0)+i*128]
for i=0,nq-1 do sumall(i)=total(iqes(active,i))
for i=0,nq-1 do begin& for j=0,5 do ibank(j,i)=total(iqes(j*128+findgen(limit(1)-limit(0)+1)+limit(0),i))&end

;for ip=0,nthere-1 do begin
;w=where(ip eq bad,n1)
;if n1 ne 0 then begin
;for k=0,7 do tottube(k)=total(itubes(ip*8+k,*))
;m=median(tottube)
badtube=where(tottube lt .2*m,n2)
;if replace and (n2 ne 0) then
;meantube
;endif
;for it=0,7 do begin&$

;for i=0,nq-1 do begin&
;endif ;n1 ne 0
;endfor ;ip
if makebtl and n_elements(btl) gt 1 then btl=btl(2:*)
nbtl2=n_elements(btl)/2

for i=0,nthere-1 do begin
  w1=where(btl(findgen(nbtl2)*2+1) eq i,nn2)
  for k=0,7 do begin
  if nn2 gt 0 then w2=where(btl(w1*2) eq k,nn3)
  if nn2 eq 0 then nn3=0 
    if nn3 eq 0 then begin
       ipacks(i,*)=ipacks(i,*)+itubes(i*8+k,*)
    endif
    if nn3 eq 1 then itubes(i*8+k,*)=0
end&end
return
end




