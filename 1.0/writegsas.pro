pro writegsas,tof,int,err,totf,ttb,difc,filen=filen

s=size(int)
nbanks=s(1)
rm=[4,3,2,1,0,5]

dummy='dummy'
openr,1,'../gsas/NOM_553.gsa
openw,2,filen
for i=0,7 do readf,1,dummy

for i=0,nbanks-1 do begin
readf,1,dummy
printf,2,dummy
readf,1,dummy
printf,2,dummy
readf,1,dummy
printf,2,dummy
reads,dummy,a,format='(6x,i5)'
nb=fix(a)
if nb ne s(2) then begin
print,dummy
print,nb,s(1),'Cant handle that.'
close,1
close,2
return
end
for j=0,nb-1 do begin
if j le nb-2 then tofn=(tof(i,j+1)-tof(i,j))
if j eq nb-1 then tofn=(tof(i,j)-tof(i,j-1))

readf,1,tof1,int1,err1
printf,2,tof(i,j),int(rm(i),j)*tofn,err(i,j),format='(3f22.9,"            ")'
end
end
close,1
close,2
return
end







