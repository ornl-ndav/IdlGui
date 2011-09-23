pro makegsas,runnr,live=live,detail=detail,silent=silent,calfile=calfile,bad=bad,normf=normf,backf=backf

if not var_defined(live) then live=0
if not var_defined(detail) then detail=1
if not var_defined(calfile) then calfile='nomad.calfile'
if not var_defined(normf) then normf='normdatag.dat'
if not var_defined(backf) then backf='backgsas.dat'

if runnr le 999 then a=string(runnr,format='(i3)')
if runnr gt 999 then a=string(runnr,format='(i4)')
if live eq 0 then filen='../../../../NOM-DAS-FS/2011_2_1B_SCI/NOM_'+a+'/NOM_'+a+'_neutron_event.dat'
if live eq 1 then filen='../../shared/live/'+a+'/preNeXus/NOM_'+a+'_live_neutron_event.dat'
if live eq 2 then filen='../../2011_2_1B_SCI/1/'+a+'/preNeXus/NOM_'+a+'_neutron_event.dat'
; read normdata
openr,1,normf,err=err

if err ne 0 then begin
print,'normdatag.dat doesnt exist'
return
end
close,1
restore,normf
normgsas=normg
s=size(normgsas)
if detail eq 1 and s(1) ne 6 then begin
print,detail,s
print,'Is this the right normalization file?'
return
end
if detail eq 2 and s(1) ne 38 then begin
print,'Is this the right normalization file?'
return
end
openr,1,backf,err=err

if err ne 0 then begin
print,'backgsas.dat doesnt exist'
return
end
close,1
restore,backf

gsasbinning,h,h1,fmatrix,use=1,option=1,filen=filen,pseudov=0,sil=1,calfile=calfile,detail=detail
if detail eq 1 then begin& h2=rotate(h1,3)&for i=0,5 do h2(i,*)=h1(*,i)&h1=h2&end
if detail eq 2 then h1=rotate(h1,3)
h1=h1-bback
readgsas,tof,int,err,ttf,tt,difc,file='../gsas/NOM_553.gsa'
gsasname='NOM_'+a+'.gsa
in=h1
in(where(normgsas ne 0))=in(where(normgsas ne 0))/normgsas(where(normgsas ne 0))
writegsas,tof,in,err,ttf,tt,difc,file=gsasname
print,gsasname+' written'
return
end





