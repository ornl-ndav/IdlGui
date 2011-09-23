pro readgsas,tof,int,err,totf,ttb,difc,filen=filen

openr,1,filen

dummy='dummy'

for i=0,3 do readf,1,dummy
readf,1,dummy
reads,dummy,nbank,format='(1x,2i)'
npt=9782
totf=dblarr(nbank)
ttb=dblarr(nbank)
difc=dblarr(nbank)
tof=dblarr(nbank,npt)
int=dblarr(nbank,npt)
err=dblarr(nbank,npt)

a=1d0
b=1d0
c=1d0
for i=0,2 do readf,1,dummy
for i=0,nbank-1 do begin
readf,1,dummy
reads,dummy,a,b,c,format='(19x,f13.9,7x,f13.9,10x,f15.9)'
totf(i)=a
ttb(i)=b
difc(i)=c
print,totf(i),ttb(i),difc(i)
readf,1,dummy
readf,1,dummy
reads,dummy
reads,dummy,a,format='(6x,i5)'
nb=fix(a)
if nb gt npt then begin
print,'ERROR NPT < npt in Bank'
close,1
return
end
for j=0,nb-1 do begin
readf,1,a,b,c
tof(i,j)=a
int(i,j)=b
err(i,j)=c
end
end
close,1
return
end





