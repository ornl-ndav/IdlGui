 pro w2c,rcyl,hcyl,mu_abs,mu_scat,h_beam,muscat,absf,attf,inthisdir,scatpower,n_sim=n_sim,off=off

; rcyl is the radius of a cylindrical sample (in cm)
; hcyl is the overoall height of that cylinder assumed to be symetric around the beam (unless off <> 0)
; mu_abs is inverse absorption length (in cm^-1) of the sample
; mu_scat is the inverse scattering length (in cm^-1)
; height of the beam
; n_sim simulated neutrons (default 1e6)

if not var_defined(n_sim) then n_sim=1e6
if not var_defined(off) then off=0

w_beam=2*rcyl
; beam only as wide as the sample

nrepeat=10l

; x is up
; y is BL1A side
; z is neutron direction
; units are cm

detpossola,tt,phi,r,x,y,z,there,number,sola,helength
there,nthere,there,eightpacks
phithere=fltarr(nthere*8*128l)
ttthere=fltarr(nthere*8*128l)
for i=0l,nthere-1 do begin&for j=0,7 do  begin&phithere((i*8+j)*128l:(i*8+j+1)*128l-1)=phi(eightpacks(i)*8+j,*)&endfor&endfor
for i=0l,nthere-1 do begin&for j=0,7 do begin&  ttthere((i*8+j)*128l:(i*8+j+1)*128l-1)= tt(eightpacks(i)*8+j,*)&endfor&endfor

;phi and tt of the installed detectors

ntt=n_elements(ttthere)
ntt1=20
nphi1=18
; number of points for simulation in tt and phi direction
inthisdir=fltarr(ntt1,nphi1)
absf=fltarr(ntt1,nphi1)
attf=fltarr(ntt1,nphi1)
muscat=0l
s1=0l
t1=0l
a1=0l
a2=0l
nonc1=0l

; absorption/multiple scattering simulation
for irepeat=0,nrepeat-1 do begin

incident=fltarr(n_sim,2)
incident(*,0)=(2*randomu(seed,n_sim)-1)*h_beam/2.
; x of the incoming neutron in cm
incident(*,1)=(2*randomu(seed,n_sim)-1)
; leave the y dimension in arb units for now

path=2*rcyl*sqrt(1-incident(*,1)^2)
abslength=-alog(randomu(seed,n_sim))/mu_abs
scatlength=-alog(randomu(seed,n_sim))/mu_scat
absorbed=where((abslength lt scatlength) and (abslength lt path),n_absorbed)
scattered1=where((abslength ge scatlength) and (scatlength lt path),n_scattered1)
transmitted=where((abslength gt path) and (scatlength gt path),n_transmitted)
s1=s1+n_elements(scattered1)
t1=t1+n_elements(transmitted)
a1=a1+n_elements(absorbed)

poscat1=fltarr(n_elements(scattered1),3)
poscat1=poscat1+[incident(scattered1,0),incident(scattered1,1)*rcyl,scatlength(scattered1)-path(scattered1)/2]
;;n_scattered1=n_elements(scattered1)

tt=acos((2*randomu(seed,n_scattered1)-1))
phi=(randomu(seed,n_scattered1))*!pi*2.
nextlength=-alog(randomu(seed,n_scattered1))/(mu_abs+mu_scat)
abslength2=-alog(randomu(seed,n_scattered1))/mu_abs
scatlength2=-alog(randomu(seed,n_scattered1))/mu_scat


scatvabs=where(scatlength2 lt abslength2)
absvscat=where(abslength2 le scatlength2)


posnext=poscat1+[sin(tt)*sin(phi)*nextlength,sin(tt)*cos(phi)*nextlength,cos(tt)*nextlength]

insample=where((sqrt(posnext(*,1)^2+posnext(*,2)^2) lt rcyl) and (posnext(*,0) lt hcyl+off) and posnext(*,0) gt -hcyl-off )
onlyonce=where((sqrt(posnext(*,1)^2+posnext(*,2)^2) gt rcyl) or posnext(*,0) gt hcyl+off or posnext(*,0) le -hcyl-off)

insamplescat=setintersection(insample,scatvabs)
insampleabs=setintersection(insample,absvscat)
a2=a2+n_elements(insampleabs)
muscat=muscat+n_elements(insamplescat)
absbefscat=n_elements(absorbed)/float(n_sim)
n_scattered2=n_elements(insamplescat)
tt2=acos((2*randomu(seed,n_scattered2)-1))
phi2=(randomu(seed,n_scattered2))*!pi*2.

for i=0,ntt1-1 do begin
for j=0,nphi1-1 do begin
phmin=j/float(nphi1)*2*!pi
phmax=(j+1)/float(nphi1)*2*!pi
ttmin=i/float(ntt1)*!pi
ttmax=(i+1)/float(ntt1)*!pi
wscat1=where((tt(onlyonce) ge ttmin) and (tt(onlyonce) lt ttmax) and (phi(onlyonce) ge phmin) and (phi(onlyonce) lt phmax),nonce)
wscat2=where((tt(insample) ge ttmin) and (tt(insample) lt ttmax) and (phi(insample) ge phmin) and (phi(insample) lt phmax),nin)
inthisdir(i,j)=inthisdir(i,j)+nonce
nonc1=nonc1+nonce
wabs2=setintersection([wscat1,wscat2],insampleabs)
; those are the neutrons s

absf(i,j)=absf(i,j)+n_elements(wabs2);/float(nonce+nin);+n_elements(wabs2);/float(nonce)+absbefscat
wscat2=setintersection(wscat1,insamplescat)
wscat3=where((tt2 ge ttmin) and (tt2 lt ttmax) and (phi2 ge phmin) and (phi2 lt phmax))
inthisdir(i,j)=inthisdir(i,j)+n_elements(wscat3)
;attf(j,i)=attf(j,i)+n_elements(wscat2)/float(n_elements(wscat1))+n_elements(wabs2)/float(n_elements(wscat1))
end
end
end

;end of simulation part

inthisdir=inthisdir/float(nrepeat)/float(n_sim)
dphi=1/nphi1
for i=0,ntt1-1 do inthisdir(i,*)=inthisdir(i,*)/sin((i+.5)/float(ntt1)*!pi)
muscat=muscat/float(nrepeat)
s1=s1/float(nrepeat)
t1=t1/float(nrepeat)
a1=a1/float(nrepeat)
a2=a2/float(nrepeat)

absf=absf/float(nrepeat)
attf=attf/float(nrepeat)

Print,' absorbed (before scattered), scattered once, transmitted, scattered once only'
print,a1/float(n_sim),s1/float(n_sim),t1/float(n_sim),nonc1/float(n_sim)/float(nrepeat)

print, '2 scattering probability/ incident flux, 2 scattering probability/ single scattering,  scattered twice and escaping'

print, muscat/float(n_sim),muscat/s1,muscat/float(n_sim)/s1*float(n_sim)*(s1/float(n_sim)-a2/float(n_sim))

print, 'abs. probability second. path/ incident flux, abs. probability second. path/ single scattering'

print, a2/float(n_sim),a2/float(n_scattered1)
inthisdir=inthisdir/total(inthisdir)*n_elements(inthisdir)
scatpower=nonc1/float(n_sim)/float(nrepeat)+muscat/float(n_sim)/s1*float(n_sim)*(s1/float(n_sim)-a2/float(n_sim))

end
