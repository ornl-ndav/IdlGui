pro w2c2,result,lambda,spectrum,inthisdir,scattpower,normf1,dq=dq,deltad=deltad,maxd=maxd,fmatrix=fmatrix,option_focus=option_focus,old=old,use_focus=use_focus

if not var_defined(option_focus) then option_focus=0
if (not var_defined(use_focus)) then use_focus=0


there,nthere,there,eightpacks,old=old
if use_focus and option_focus then begin&$
read_calfile,corrf,file='nomad.calfile'&$
if n_elements(corrf) ne 1024l*nthere then begin
print,'Not the correct number of elements in the calfile'
print,'FULL STOP'
return
end
end


if not var_defined(spectrum) then begin&read_bm,tof,lambda,bm,bmeff,bmpp,bmpc,fluxonsample&spectrum=fluxonsample&endif

; if spectrum isn't provided as an agrument read spectrum for a particular scan
; bmeff is total number of neutrons per bin over entire time
; bmpp is per pulse and 1 A 
; fluxonsample is normalized to the sample position on a spot .6cm wide and 2 cm high over the entire time

if not var_defined(normf1) then begin
read_pulsid,plow,phigh,evid,char
n_pulseg=n_elements(char)/60
normf=fltarr(n_pulseg)
onesecev=fltarr(n_pulseg)
for i=0l,n_pulseg-1 do begin
normf(i)=total(char(i*60l:(i+1)*60l-1))
onesecev(i)=evid((i+1)*60l-1)
end
ww=where(normf gt 0,nw)
if nw eq 0 then return
normf(ww)=1e6/normf(ww)
m=median(normf(ww))
wn1=where((normf lt 1.2*m) and (normf gt 0.8*m))
 d1=onesecev-shift(onesecev,1)
d1(0)=onesecev(0)
;plot,wn1,normf(wn1),/yno
normf(wn1)=normf(wn1)/float(n_elements(wn1))
end

; same as in dqtbinning 

if not var_defined(dq) then dq=1
if not var_defined(inthisdir) then begin

w2c,.31,2,.3669,.3669,1,muscat,absf,attf,inthisdir,scatpower,n_sim=1e7,off=5

; absorption/ multiple scattering simulation
; parameter cyl. radius 0.31, halbe hoehe des cylinders 2, inverse absorption length of V at 1.8 A; inverse scattering length of V,halbe hoehe des strahls 
end

; same as dqtbinning ...

if (dq gt 0) then print, 'Binning in Q' 
if (dq eq 0) then print, 'Binning in d'
if (dq lt 0) then print, 'Binning in TOF'

if (not var_defined(deltad)) then begin
if (dq gt 0) then deltad=0.02 
if (dq eq 0) then deltad=0.005
if (dq lt 0) then deltad=10.
endif
dd2=deltad/2.
if (not var_defined(maxd)) then begin
if (dq gt 0) then maxd=50. 
if (dq eq 0) then maxd=6.
if (dq lt 0) then maxd=166666. 
endif
nmaxd=fix(maxd/deltad)
d=findgen(nmaxd)*deltad


detpossola,tt,phi,rr,x,y,z,there,number,sola,helength

; initialize all arrays for the installed detectors
toftoq=fltarr(nthere*8*128l)
rthere=fltarr(nthere*8*128l)
ttthere=fltarr(nthere*8*128l)
phithere=fltarr(nthere*8*128l)
hethere=fltarr(nthere*8*128l)
solthere=fltarr(nthere*8*128l)
inthere=fltarr(nthere*8*128l)

result=fltarr(nthere*8*128l,nmaxd)
for i=0l,nthere-1 do begin&for j=0,7 do  rthere((i*8+j)*128l:(i*8+j+1)*128l-1)=rr(eightpacks(i)*8+j,*)&endfor

for i=0l,nthere-1 do begin&for j=0,7 do  ttthere((i*8+j)*128l:(i*8+j+1)*128l-1)= tt(eightpacks(i)*8+j,*)&endfor
if var_defined(fmatrix) then ttthere=fmatrix
for i=0l,nthere-1 do begin&for j=0,7 do  phithere((i*8+j)*128l:(i*8+j+1)*128l-1)= phi(eightpacks(i)*8+j,*)&endfor
for i=0l,nthere-1 do begin&for j=0,7 do  hethere((i*8+j)*128l:(i*8+j+1)*128l-1)= helength(eightpacks(i)*8+j,*)&endfor
for i=0l,nthere-1 do begin&for j=0,7 do  solthere((i*8+j)*128l:(i*8+j+1)*128l-1)= sola(eightpacks(i)*8+j,*)&endfor
inthere=interpolate(inthisdir,ttthere*20/!pi,phithere*18/2/!pi)

; efficiency of the detectors as a function of wavelength
p=30
l1=rebin(lambda,2000)
sp1=rebin(spectrum,2000)*8
e0=5333*l1/1.8*2.43e-5*p
if dq ge 1 then begin

; for all pixelsi

for i=0l,nthere*8*128l-1 do begin
;for i=0l,1023l do begin
;Q=4*!pi/lambda*sin(ttthere(i)/2)
Q=4*!pi/l1*sin(ttthere(i)/2)
if option_focus then q=q/corrf(i)
sq=rebindtoq(sp1/(l1(1)-l1(0))*l1/q,q,d)*d(1)
; sq = total number of neutrons on the sample per d (= equidistant Q) bin
eff=interpol((1-exp(-e0(1:*)*hethere(i)/10)),q(1:*),d)
; detection efficiency as a function of d (= equidistant Q)
result(i,*)=sq*solthere(i)/4/!pi*scatpower*eff*inthere(i)
; solthere(i)/4/!pi*scatpower probability of a neutron to scatter towards the detector
; eff probability of a neutron to be detected
; inthere(i) abs multiple correction for the sample
endfor
endif

if dq lt 1 then begin

; for all pixelsi

for i=0l,nthere*8*128l-1 do begin
;for i=0l,1023l do begin
;Q=4*!pi/lambda*sin(ttthere(i)/2)
Q=l1/2/sin(ttthere(i)/2)   ;;; that is really dspacing
if option_focus then q=q*corrf(i)
sq=rebindtoq(sp1,q,d)*q(1)/d(1)
; sq = total number of neutrons on the sample per d (= equidistant Q) bin
eff=interpol((1-exp(-e0(1:*)*hethere(i)/10)),q(1:*),d)
; detection efficiency as a function of d (= equidistant Q)
result(i,*)=sq*solthere(i)/4/!pi*scatpower*eff*inthere(i)
; solthere(i)/4/!pi*scattpower probability of a neutron to scatter towards the detector
; eff probability of a neutron to be detected
; inthere(i) abs multiple correction for the sample
endfor
endif

a=stdev(normf(wn1),m)
result=result*m
return
end


