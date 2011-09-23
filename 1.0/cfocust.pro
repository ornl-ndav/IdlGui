pro cfocust,q,pix,nreight,posNi1,widni1,posNi2,widni2,isdq=isdq,a=a,limit=limit,lmin=lmin,lmax=lmax,dq0=dq0,nofit=nofit,hkl=hkl,n_dim=n_dim

if (not var_defined(a)) then a=3.524
; default is Ni
if (not var_defined(hkl)) then hkl=[3,4,7,11,12,16,19,20,24,27,32,35,36,40,43,44]
if (not var_defined(isdq)) then isdq=1
; default is Q
if (not var_defined(limit)) then limit=[5,123]
; default 5 pixels at each end ignored
if (not var_defined(lmin)) then lmin=0.2
; default min lambda 0.2A
if (not var_defined(lmax) )then lmax=3
; default max lambda 3A
if (not var_defined(dq0) )then dq0=.1
if (not var_defined(nofit) )then nofit=1 
if (not var_defined(n_dim) )then n_dim=1

s=size(pix)
sums=fltarr(128,s(2))
for i=0,127 do begin&$
for j=0,s(1)/128-1 do begin&$
sums(i,*)=sums(i,*)+pix(j*128l+i,*)&$
end&end

lammax=3
 detpos,tt
tt=tt(8*nreight,*)
npeaks=n_elements(hkl)
posNi1=fltarr(npeaks,128)
widNi1=fltarr(npeaks,128)

if (isdq gt 0) then begin&$
approx=2*!pi*sqrt(hkl)/a&$
qmin=4*!pi/lmax*sin(tt/2)&$
qmax=4*!pi/lmin*sin(tt/2)&$
dq=dq0*approx/min(approx)&$
endif
if (isdq le 0) then begin
approx=a/sqrt(hkl)
qmin=0.5*lmin/sin(tt/2)
qmax=0.5*lmax/sin(tt/2)
dq=dq0*approx/min(approx)

endif

for i=limit(0),limit(1) do begin&$
for j=0,n_elements(hkl)-1 do begin&$
q1=approx(j)-dq(j)&$
q2=approx(j)+dq(j)&$
if (q1 gt qmin(i)) and (q2 lt qmax(i)) then begin&$
;if j eq 2 and i eq 50 then stop&$
res=gaussfit(q(fr(q,q1):fr(q,q2)),sums(i,fr(q,q1):fr(q,q2)),aa,chis=chis)&$
m=stdev(sums(i,fr(q,q1):fr(q,q2)),m1)&$
;print,i,aa(0),aa(1),approx(0),sqrt(chis)&$
if ( sqrt(chis) lt aa(0)) then begin&$
posni1(j,i)=aa(1)&$
widni1(j,i)=aa(2)&$
endif&$
endif&$
endfor&$
endfor
if (n_dim gt 1) then begin
posni2=fltarr(s(1)/128,128,n_elements(hkl))
widni2=posni2
for i=limit(0),limit(1) do begin&$
for k=0,s(1)/128-1 do begin&$
for j=0,n_elements(hkl)-1 do begin&$
q1=approx(j)-dq(j)&$
q2=approx(j)+dq(j)&$
if (q1 gt qmin(i)) and (q2 lt qmax(i)) then begin&$
res=gaussfit(q(fr(q,q1):fr(q,q2)),pix(k*128+i,fr(q,q1):fr(q,q2)),aa,chis=chis)&$
if ( sqrt(chis) lt aa(0)) then begin&$
posni2(k,i,j)=aa(1)&$
widni2(k,i,j)=aa(2)&$
endif&endif&$
endfor&$
endfor&endfor
endif
return
end
