pro makepdf,runnr,live=live,silent=silent,calfile=calfile,bad=bad,normf=normf,backf=backf,rootdir=rootdir,qminpla=qminpla,qmax=qmax,maxr=maxr,help=help

if not var_defined(live) then live=0
if not var_defined(calfile) then calfile='nomad.calfile'
if not var_defined(normf) then normf='normdatapdf.dat'
if not var_defined(backf) then backf='backpdf.dat'
if not var_defined(rootdir) then rootdir='../../../../NOM-DAS-FS/2011_2_1B_SCI/NOM_'
if not var_defined(qminpla) then qminpla=20
if not var_defined(qmax) then qmax=30
if not var_defined(maxr) then maxr=20
if not var_defined(help) then help=0
if not var_defined(silent) then silent=0

if help then begin

print,'USAGE:  makepdf,runnr,live=live,silent=silent,calfile=calfile,bad=bad,normf=normf,backf=backf,rootdir=rootdir,qminpla=qminpla,qmax=qmax,maxr=maxr,help=help'
print,'runnr: Runnr to be processed'
print,'live=0 (default) process saved data,live=1: try to process live data'
print,' silent (not used)'
print,' calfile=name of cafile'
print,' bad= [1,2] means 8-pack 1,2 had no HV'
print,' normf= name of normalization file'
print,' backf= name of background file'
print,' rootdir= sets an offset path for event file'
print,' qminpla= (default 20A^-1) min Q to fit a polynomial as approximation of the self-scatterin'
print,' qmax= (default 30A^-1) Q-max for the fourier transform'
print,' maxr= (default 20A) is the max_r for which FT is calculated)'
print,' help=1 (default 0) prints this help'
return
endif

if runnr le 999 then a1=string(runnr,format='(i3)')
if runnr gt 999 then a1=string(runnr,format='(i4)')
if live eq 0 then filen=rootdir+a1+'/NOM_'+a1+'_neutron_event.dat'
if live eq 1 then filen='../../shared/live/'+a1+'/preNeXus/NOM_'+a1+'_live_neutron_event.dat'

; read normdata
openr,1,normf,err=err

if err ne 0 then begin
print,'normdatapdf.dat doesnt exist'
return
end
close,1
restore,normf
s=size(normpdf)
openr,1,backf,err=err

if err ne 0 then begin
print,'backgsas.dat doesnt exist'
return
end
close,1
restore,backf

allf='all'+a1+'.dat'
openr,1,allf,err=err

if err eq 0 then print,allf, '   already exist'
close,1

if err eq 0 then begin
restore,allf
end
if err ne 0 then begin
dqtbinning,h,fmatrix,use=1,option=1,dq=1,filen=filen,pseudov=0,calfile=calfile,sil=silent
equivalent,h,e,p,a,b,bad=bad
save,e,p,a,b,filen='all'+a1+'.dat'
end
creategr,a,b,sq,gr,qminpla=qminpla,qmax=qmax,maxr=maxr,backf=backf,scannr=runnr,inter=(not silent)
save,sq,gr,filen='sqgr'+a1+'.dat
return
end





