pro calculate_CAFFs,qo,qh,q,fo,fh

rstd,rr1,eldeo,'~/idl/eldeo.dat',sil=1
rstd,rr1,eldeh,'~/idl/eldeh.dat',sil=1


rstd,rr1,eldeoc,'~/idl/eldeoc.dat',sil=1

eldeov=eldeo-eldeoc

kappao=(-(qo-6.)/6.)^(-1./3.)

eldeoshift=(interpol(eldeov,rr1,rr1*kappao)>min(eldeo))+eldeoc
fteqs,rr1,eldeoshift,q,fo
fo=fo*4*!pi
kappa=(-(qh-1))^(-1./3.)
temp=(interpol(eldeh,rr1,rr1*kappa)>min(eldeh))
fteqs,rr1,temp,q,fh
fh=fh*4*!pi
return
end
