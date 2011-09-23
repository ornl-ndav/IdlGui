pro createnorm,bv,bb,bad=bad,detail=detail,gsasformat=gsasformat,calfile=calfile,abskorr=abskorr,normfile=normfile, help=help

if not var_defined(help) then help=0
if not var_defined(abskorr) then abskorr=1
if help then begin
print,'Creates a normdatapdf.dat (for pdf) or normdatag.dat (for GSAS)'
print,'Usage:createnorm,bv,bb,bad=bad,detail=detail,gsasformat=gsasformat,calfile=calfile,abskorr=abskorr,help=help'
print,'bv: Banks for Vana run'
print,'bb: Banks for backgorund run'
print,'bad=[1,2,3] : bad detectors'
print,'detail: not used yet'
print,'gsasformat=1 (gsas),gsasformat=0 (pdf)'
print,'calfile="yourcalfile.dat" calfile to use'
print,'abskorr=1: do absorption correction'
print,'help=1: print this help' 
return
endif

if not var_defined(normfile) and gsasformat eq 0 then normfile='normdatapdf.dat'
if not var_defined(normfile) and gsasformat eq 1 then normfile='normdatag.dat'

;if not var_defined(calfile) then calfile='nomad.calfile'
err=0
;if vananr gt 999 then av=string(vananr,format='(i4)')
;if vananr le 999 then av=string(vananr,format='(i3)')
;vanah='/SNS/NOM/histo/histo'+av+'.dat'
;if backnr gt 999 then ab=string(backnr,format='(i4)')
;if backnr le 999 then ab=string(backnr,format='(i3)')
;backh='/SNS/NOM/histo/histo'+ab+'.dat'
;openr,1,vanah,err=err
;close,1
;if err eq 0 then restore,vanah
lam=[3,1.8,1,.5,.2,.1]
absf=[.258,.165,.096,.049,.02,.01]
res_a=poly_fit(lam,absf,2)
if err eq 1 then begin
if gsasformat then gsasbinning,hv,hv1,fmatrix,use=1,option=1,filen=filen,pseudov=0,sil=1,calfile=calfile,detail=detail,bad=bad
if not gsasformat then dqtbinning,hv,hv1,fmatrix,use=1,option=1,filen=filen,pseudov=0,sil=1,calfile=cal
file,detail=detail,bad=bad
end
;openr,1,backh,err=err
;close,1
;if err eq 0 then restore,backh

if err eq 1 then begin
if gsasformat then gsasbinning,hb,hb1,fmatrix,use=1,option=1,filen=filen,pseudov=0,sil=1,calfile=calfile,detail=detail,bad=bad
if (not gsasformat) then dqtbinning,hb,hb1,fmatrix,use=1,option=1,filen=filen,pseudov=0,sil=1,calfile=calfile,detail=detail,bad=bad
end
a=3.03 ;vanadium
; (110),(200),(211),(220),(301),(222),(321),(400),(330),(420),(332),(422),(431)
hkl=[2,4,6,8,10,12,14,16,18,20,22,24,26]
reso=[0.013,0.0087,0.01,0.003,0.0025,0.021]*2

approx=2*!pi*sqrt(hkl)/a
approxd=2*!pi/approx
tofit=indgen(11,6)*0+99
tofit(0,0)=0
tofit(0:2,1)=indgen(3)
tofit(0:2,2)=indgen(3)
tofit(0:2,3)=[1,2,6]
tofit(0:7,4)=[2,3,4,5,6,8,10,12]

if gsasformat then begin&$
readgsas,tof,int,err,ttf,tt,difc,file='../gsas/NOM_553.gsa'
norma=bv-bb
if n_elements(norma) ne n_elements(tof) then begin
print,'Most likely the vanadium and background file are not in the right format'
print,' Have they been created with gsasbinning?'
return
endif


d=tof(2,*)/difc(2)*10
for i=0,5 do begin
for j=0,10 do begin
if tofit(j,i) ne 99 then begin
res=gaussfit(d(fr(d,approxd(tofit(j,i))-5*reso(i)*approxd(j)):fr(d,approxd(tofit(j,i))+5*reso(i)*approxd(j))),norma(i,fr(d,approxd(tofit(j,i))-5*reso(i)*approxd(j)):fr(d,approxd(tofit(j,i))+5*reso(i)*approxd(j))),aa)
norma(i,fr(d,approxd(tofit(j,i))-1.5*reso(i)*approxd(j)):fr(d,approxd(tofit(j,i))+1.5*reso(i)*approxd(j)))=poly(d(fr(d,approxd(tofit(j,i))-1.5*reso(i)*approxd(j)):fr(d,approxd(tofit(j,i))+1.5*reso(i)*approxd(j))),aa(3:*))
endif
endfor
endfor
endif
if not gsasformat then begin&$
tofit(0,0)=0
tofit(0:4,1)=[0,1,2,4,6]
tofit(0:6,2)=[0,1,2,3,4,6,8]
tofit(0:10,3)=[1,2,3,4,5,6,8,9,10,11,12]
tofit(0:9,4)=[2,3,4,5,6,8,9,10,11,12]

norma=bv-bb
q=findgen(2500)*.02
for i=0,5 do begin
for j=0,10 do begin
if tofit(j,i) ne 99 then begin
res=gaussfit(q(fr(q,approx(tofit(j,i))-5*reso(i)*approx(j)):fr(q,approx(tofit(j,i))+5*reso(i)*approx(j))),norma(i,fr(q,approx(tofit(j,i))-5*reso(i)*approx(j)):fr(q,approx(tofit(j,i))+5*reso(i)*approx(j))),aa)
norma(i,fr(q,approx(tofit(j,i))-1.5*reso(i)*approx(j)):fr(q,approx(tofit(j,i))+1.5*reso(i)*approx(j)))=poly(q(fr(q,approx(tofit(j,i))-1.5*reso(i)*approx(j)):fr(q,approx(tofit(j,i))+1.5*reso(i)*approx(j))),aa(3:*))
endif
endfor
endfor
endif
norm1=norma
n=n_elements(norm1(0,*))
if gsasformat then frac=0.02
if not gsasformat then frac=0.3

for i=0,5 do begin
n2=n_elements(norma(i,0.9*n:*))
res=poly_fit(findgen(n2),norma(i,0.9*n:*),4)
m=poly(n2-1,res)
fteqs,findgen(n),norma(i,*)-m,rr,ft
fteqs,rr(0:frac*n),ft,findgen(n),rev
w=where(norma(i,*) gt 1e-6,n1)
if n1 gt 0 then norm1(i,w)=rev(w)*2./!pi+m
end
norma=norm1

if gsasformat then begin
normg=norm1
openr,1,normfile,err=err
if err eq 0 then begin
print,'already exists. o.k. to continue?'
prtc
end
save,normg,file=normfile
endif
if not gsasformat then begin
if abskorr then begin
detpossola,tt,phi,r,x,y,z,there,number,sola,helength
there,nthere,there,eightpacks,banks
phithere=fltarr(nthere*8*128l)
ttthere=fltarr(nthere*8*128l)
for i=0l,nthere-1 do begin&for j=0,7 do  begin&phithere((i*8+j)*128l:(i*8+j+1)*128l-1)=phi(eightpacks(i)*8+j,*)&endfor&endfor
for i=0l,nthere-1 do begin&for j=0,7 do begin&  ttthere((i*8+j)*128l:(i*8+j+1)*128l-1)= tt(eightpacks(i)*8+j,*)&endfor&endfor
nall=0
for iban=0,5 do begin
w=where(banks(iban,*) ne 99,n1)
ttma=stdev(ttthere(findgen(n1*1024l)+nall*1024l),ttm)
lamdab=(4*!pi/q)*sin(ttm/2)
w=where(norm1(iban,*) gt 0)
norm1(iban,w)=norm1(iban,w)/(1-poly(lamdab(w),res_a))
nall=nall+n1
end
end
normpdf=norm1
openr,1,normfile,err=err
if err eq 0 then begin
print,'already exists. o.k. to continue?'
prtc
end
save,normpdf,file=normfile
endif

print,normfile+' created'
return
end


