pro afocust,q,pix,nreight,posNi1,widni1,posNi2,widni2,corrf,pf,onespec,isdq=isdq,a=a,limit=limit,lmin=lmin,lmax=lmax,dq0=dq0,nofit=nofit,hkl=hkl,g_one=g_one,n_dim=n_dim

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
if (not var_defined(g_one) )then g_one=0
if  (not var_defined(n_dim) )then n_dim=0



lammax=3
 detpos,tt
tt=tt(8*nreight,*)
s=size(posni1)

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

tts=[0.]
devs=[1.]
for i=0,s(1)-1 do begin&$
w=where(posni1(i,*)/approx(i) gt 0.8 and posni1(i,*)/approx(i) lt 1.2 ,n1)&$
if n1 gt 0 then tts=[tts,w]&$
if n1 gt 0 then devs=[devs,reform(posni1(i,w)/approx(i))]&$
end
tts=tts(1:*)
devs=devs(1:*)
plot,tts,devs,ps=2,yra=[.9,1.1]
res=poly_fit(tts,devs,4)
oplot,findgen(128),poly(findgen(128),res),th=2
devdev=devs-poly(findgen(128),res)
w1=where(abs(devdev) lt 0.05)
res1=poly_fit(tts(w1),devs(w1),4)
oplot,findgen(128),poly(findgen(128),res1),th=2,li=2

corrf=poly(findgen(128),res1)

if g_one then begin
pixf=pix
s=size(pix)
onespec=fltarr(s(2))
ncontr=lonarr(s(2))
for i=0,127 do begin&$
qi=q*poly(i,res)&$
for j=0,s(1)/128-1 do begin&$
temp=rebindtoq(pix(j*128l+i,*),q,qi)&$
pixf(j*128l+i,*)=temp&$
if (i ge limit(0)) and (i le limit(1)) then begin&$
onespec(fr(q,qmin(i)):fr(q,qmax(i)))=onespec(fr(q,qmin(i)):fr(q,qmax(i)))+temp(fr(q,qmin(i)):fr(q,qmax(i)))&$
ncontr(fr(q,qmin(i)):fr(q,qmax(i)))=ncontr(fr(q,qmin(i)):fr(q,qmax(i)))+1&$
endif&$
endfor&endfor
end
return
end
