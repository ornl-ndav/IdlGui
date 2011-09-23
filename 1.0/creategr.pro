pro creategr,a,b,sq,gr,q,hydrogen=hydrogen,rho=rho,sigma=sigma,interactive=interactive,qminpla=qminpla,d1=d1,qmaxft=qmaxft,scannr=scannr,backfile=backfile,usehq=usehq,sbs=sbs,sb2=sb2,l=l,maxr=maxr,ignq=ignq,normf=normf,help=help

if not var_defined(hydrogen) then hydrogen=0
if not var_defined(rho) then rho=0.02205
if not var_defined(sigma) then sigma=10.631
if not var_defined(interactive) then interactive=1
if not var_defined(qmaxft) then qmaxft=50
if not var_defined(qminpla) then qminpla=5
if not var_defined(d1) then d1=0.627
if not var_defined(scannr) then scannr=9999
if not var_defined(backfile) then backfile='backpdf.dat'
if not var_defined(usehq) then usehq=0
if not var_defined(sbs) then sbs=(4.1491+2*5.803)^2
if not var_defined(sb2) then sb2=4.1491^2+2*5.803^2
if not var_defined(l) then l=[1,20]
if not var_defined(maxr) then maxr=20
if not var_defined(ignq) then ignq=5
if not var_defined(q) then q=findgen(2500)*.02
if not var_defined(normf) then normf='normdatapdf.dat'
if not var_defined(help) then help=0

if help eq 1 then begin
print,'USAGE: creategr,a,b,sq,gr,q,hydrogen=hydrogen,rho=rho,sigma=sigma,interactive=interactive,qminpla=qminpla,d1=d1,qmaxft=qmaxft,scannr=scannr,backfile=backfile,usehq=usehq,sbs=sbs,sb2=sb2,l=l,maxr=maxr,ignq=ignq,normf=normf,help=help
print,'a: a variable for scan to be FT (input)'
print,'b: b variable for scan to be FT (input)'
print,'sq: S(Q) (ouput)'
print,'gr: g(r) with Lorch (output)'
print,' q: (input) Q, default findgen(2500)*.02'
print,'hydrogen =1 (try a hydrogen Placzek) =0 (no hydrogen Placzek)
print,' rho: density in molecules /A^3, default=0.02205 silica glass'
print,'interactive=0 no plots'
print,' qminpla (default=5A^-1) minimum Q to fit a Polynomial as self scattering background'
print,' d1 = diameter of the sample in cm (default = 0.627, a quarter inch)'
print,' qmaxft: maximum Q for FT (default=50)'
print,'scannr scannr used for output files'
print,'backfile= name of the backgroundfile created with makeback'
print,'usehq=1 use high Q behavior for normalization, =0 use absolute normalization'
print,'sbs= (sum of b)^2 default sbs=(4.1491+2*5.803)^2 (SiO2)'
print,'sb2= (sum of b^2) default sb2=4.1491^2+2*5.803^2 (SiO2)'
print,'l= [1,20] display range of the FT'
print,'maxr=20 maximum r where FT is calculated'
print,'ignq=5 minimum Q values to be ignored'
print,' normf: default normf=-normdatapdf.dat- normalization file generated withcreanorm' 
return
end

qign=ignq
rhovana=0.0722
sigmavana=5.08
d1vana=0.627

;read normalization file
openr,1,normf,err=err
close,1
if err ne 0 then begin
print,err,'no normalization file'
return
end
restore,normf

;read  file
openr,1,backfile,err=err
close,1
if err ne 0 then begin
print,err,'no background file'
return
end
restore,backfile

normall=normpdf(0,*)+normpdf(1,*)+normpdf(2,*)+normpdf(3,*)+normpdf(4,*)+normpdf(5,*)
normall=reform(normall)

smb=a-aback
smb(where (normall gt 0))=smb(where (normall gt 0))/normall(where (normall gt 0))
smb(0:qign)=0

if n_elements(smb) ne 2500 then print,' Careful. This does not appear to be a standard file'
if (hydrogen eq 0) then respla=poly_fit(q(fr(q,qminpla):*)^2,smb(fr(q,qminpla):*),2)
if (hydrogen eq 2) then begin
aa=[10,6,.5,6.,.1]
respla=curvefit(q(fr(q,qminpla):fr(q,50)),smb(fr(q,qminpla):fr(q,50)),q(fr(q,qminpla):fr(q,50))+0+1,aa,funct='pseudovoigt',/noder)
pseudovoigt,q,aa,pla
end

if interactive then begin
plot,q,smb
oplot,q,q*0+rho*sigma/(rhovana*sigmavana),color=255
if hydrogen eq 0 then oplot,q,poly(q^2,respla),color=255
if hydrogen eq 2 then oplot,q,pla,color=255
prtc
endif
bsmb=b-bback
bsmb(where (normpdf gt 0))=bsmb(where (normpdf gt 0))/normpdf(where (normpdf gt 0))
if hydrogen eq 0 then sq=smb-poly(q^2,respla)
if hydrogen eq 2 then sq=smb-pla
;stop
if usehq and hydrogen eq 0 then sq=sq/poly(max(q)^2,respla);*rhovana*sigmavana/rho/sigma
if usehq and hydrogen eq 2 then sq=sq/pla(fr(q,49));*rhovana*sigmavana/rho/sigma
if not usehq then sq=sq/rho/sigma*rhovana*sigmavana
if interactive then begin
plot,q,sq
prtc
endif
if hydrogen then begin
hplazcek,q,b,normpdf,pla
if interactive then begin
plot,q,smb
oplot,q,pla,color=255
prtc
endif
endif
;;;sq=smb-pla
;;;stop
nr=maxr/.01
fteqs,q(0:fr(q,qmaxft)),sq,rr,ft
fteqs,q(0:fr(q,qmaxft)),sq,findgen(nr)*.01,ft1
fteqs,q(0:fr(q,qmaxft)),sq,findgen(nr)*.01,ftl,l=1

f1=rho*sigma/rhovana/sigmavana*d1^2/d1vana^2
ft=ft/2/!pi^2/rho/sbs*sb2
ft1=ft1/2/!pi^2/rho/sbs*sb2
ftl=ftl/2/!pi^2/rho/sbs*sb2
if interactive then begin
plot,findgen(nr)*.01,ft1,xra=[l(0),l(1)]
oplot,findgen(nr)*.01,ftl,color=255,th=2
oplot,rr,ft,ps=2
prtc
plot,findgen(nr)*.01,ft1*findgen(nr)*.01,xra=[1,maxr]
oplot,findgen(nr)*.01,ftl*findgen(nr)*.01,color=255,th=2
oplot,rr,ft*rr,ps=2
prtc
endif
if scannr gt 999 then astring=string(scannr,format='(i4)')
if scannr gt 99 and  scannr lt 1000 then astring=string(scannr,format='(i3)')
if scannr gt 9 and  scannr lt 100 then astring=string(scannr,format='(i2)')
if scannr lt 10 then astring=string(scannr,format='(i)')
wstd,findgen(nr)*.01,ft1,'NOM_'+astring+'ftf.dat
wstd,findgen(nr)*.01,ftl,'NOM_'+astring+'ftl.dat
wstd,rr,ft,'NOM_'+astring+'ftnat.dat'
wstd,q,sq,'NOM_'+astring+'SQ.dat'


gr=ftl

return
end

