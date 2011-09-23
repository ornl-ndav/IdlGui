pro abskorr,af,mf,sigmaa=sigmaa,sigmas=sigmas,h1=h1,h2=h2,rcyl=rcyl,rho=rho,mmol=mmol,pointdensity=pointdensity,nl=nl,naf=naf,n_sim=n_sim,nout=nout,help=help

if not var_defined(help) then help=0
if help eq 1 then begin
print,'USAGE:abskorr,af,mf,sigmaa=sigmaa,sigmas=sigmas,h1=h1,h2=h2,rcyl=rcyl,rho=rho,mmol=mmol,pointdensity=pointdensity,nl=nl,naf=naf,n_sim=n_sim,nout=nout,help=help'
print,'af: output attenuation factor including scattering pixel per pixel as a function of wavelength'
print,'mf: multiple scattering factor as a function of wavelength'
print,'sigmaa= absorption cross section in barns'
print,'sigmas= scattering cross section in barns'
print,'H1= height of the sample below the beam (cm)'
print,'H2= height of the sample above the beam (cm)'
print,'rcyl= radius of the sample (cm)'
print,'rho= density (gcm^-3)'
print,'nmol= molar mass of the sample (gmol^-1)'
print,'pointdensity simulation density along a tube pointdensity=4 means 4 out of 128 pixel positions are simulated the rest is interpolated'
print,'nl= wavelength points to be simulated'
print,'n_sim= number of neutrons simulated on incident '
print,'nout= number of neutrons simulated on exit'
print,'help=1 prints this message'
return
end


if not var_defined(sigmaa) then sigmaa=5.08
if not var_defined(sigmas) then sigmas=5.1
if not var_defined(r) then rcyl=0.627/2
if not var_defined(rho) then rho=6.11
if not var_defined(mmol) then mmol=50.9415
if not var_defined(h_beam) then h_beam=1
if not var_defined(h1) then h1=1
if not var_defined(h2) then h2=4
if not var_defined(pointdensity) then pointdensity=4
if not var_defined(nl) then nl=3
if not var_defined(naf) then naf=31

doabs=(naf-1)/nl


rho1=rho/mmol*.602205
muabs=sigmaa*rho1
muscat=sigmas*rho1
alongtube=[findgen(pointdensity)/float(pointdensity)*128,127]


; x is up
; y is BL1A side
; z is neutron direction
; units are cm

if not var_defined(n_sim) then n_sim=1e7
if not var_defined(nout) then nout=100000

dl1=2.9/float(naf-1)
lambda=findgen(naf)*dl1+.1

detpossola,tt,phi,r,x,y,z,there,number,sola,helength
there,nthere,there,eightpacks
phithere=fltarr(nthere*8*128l)
ttthere=fltarr(nthere*8*128l)
wott=fltarr(nl+1,nthere*8*128l)
af=fltarr(naf,nthere*8*128l)
mf=fltarr(naf)
abs1=fltarr(naf)
scat1=fltarr(naf)


for i=0l,nthere-1 do begin&for j=0,7 do  begin&phithere((i*8+j)*128l:(i*8+j+1)*128l-1)=phi(eightpacks(i)*8+j,*)&endfor&endfor
for i=0l,nthere-1 do begin&for j=0,7 do begin&  ttthere((i*8+j)*128l:(i*8+j+1)*128l-1)= tt(eightpacks(i)*8+j,*)&endfor&endfor

;phi and tt of the installed detectors

incident=fltarr(n_sim,2)
incident(*,0)=(2*randomu(seed,n_sim)-1)*h_beam/2.
; x of the incoming neutron in cm
incident(*,1)=(2*randomu(seed,n_sim)-1)
; leave the y dimension in arb units for now

path=2*rcyl*sqrt(1-incident(*,1)^2)

for i=0,naf-1 do begin

alllength=-alog(randomu(seed,n_sim))/(muabs*lambda(i)/1.8+muscat)
interact=where((alllength lt path),n_interact)
abs1(i)=n_interact/float(n_sim)*muabs*lambda(i)/1.8/(muabs*lambda(i)/1.8+muscat)
scat1(i)=n_interact/float(n_sim)*muscat/(muabs*lambda(i)/1.8+muscat)
poscat1=fltarr(n_interact,3)
poscat1=poscat1+[incident(interact,0),incident(interact,1)*rcyl,alllength(interact)-path(interact)/2]

if (i/doabs)*doabs eq i then begin
for jj=0l,nthere*8-1 do begin
for kk=0,pointdensity do begin
j=jj*128+alongtube(kk)
direction=[sin(ttthere(j))*cos(phithere(j)),sin(ttthere(j))*sin(phithere(j)),cos(ttthere(j))]
wo=wayout(poscat1(randomu(seed,nout)*n_interact,*),h1,h2,rcyl,direction,10)
a=stdev(wo,b)
wott(i/doabs,j)=b
print,j,wott(i/doabs,j)
endfor
endfor
endif
endfor
; wott: way out to tube


; interpolate the way out along a tube
for i=0,nl do begin&$
for jj=0l,nthere*8-1 do begin&$
res=poly_fit(alongtube,wott(i,jj*128+alongtube),4)&$
wott(i,jj*128:(jj+1)*128-1)=poly(findgen(128),res)&$
end&$
end

; interpolate the attenuation factor along lambda

for i=0,naf-1 do begin&$
di=i-(i/doabs)*doabs&$
if i/doabs lt nl then wotti=wott((i/doabs),*)-(wott((i/doabs),*)-wott((i/doabs)+1,*))/float(doabs)*di&$
if i/doabs eq nl then wotti=wott((i/doabs),*)&$
af(i,*)=abs1(i)+(1-abs1(i))*(1-exp(-wotti*(muabs*lambda(i)/1.8+muscat)))&$
a=stdev(1-exp(wotti*muscat),b)&$
mf(i)=b&$
endfor
return
end
function wayout,scatpos,h1,h2,rcyl,direction,estimate

ns=size(scatpos)
ns=ns(1)
ew1=scatpos
ew2=ew1

e1=fltarr(ns)+estimate
all_dist=e1
for i=0l,ns-1 do ew1(i,*)=scatpos(i,*)+e1(i)*direction
out=where(ew1(*,0) gt h2 or -ew1(*,0) gt h1 or sqrt(ew1(*,2)^2+ew1(*,1)^2) gt rcyl,nout)
in=where(ew1(*,0) lt h2 and -ew1(*,0) lt h1 and sqrt(ew1(*,2)^2+ew1(*,1)^2) lt rcyl,nin)
for j=0,31 do begin
e1=e1/2
if nout gt 0 then all_dist(out)=all_dist(out)-e1(out)
if nin gt 0 then all_dist(in)=all_dist(in)+e1(in)
for i=0l,ns-1 do ew1(i,*)=scatpos(i,*)+all_dist(i)*direction
out=where(ew1(*,0) gt h2 or -ew1(*,0) gt h1 or sqrt(ew1(*,2)^2+ew1(*,1)^2) gt rcyl,nout)
in=where(ew1(*,0) lt h2 and -ew1(*,0) lt h1 and sqrt(ew1(*,2)^2+ew1(*,1)^2) lt rcyl,nin)
end
return,all_dist
end
