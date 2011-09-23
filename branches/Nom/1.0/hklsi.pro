pro hklsi,hkl,squared,n=n

if not var_defined(n) then n=20

nc0=1l
nc1=3l
nca=nc0+nc1
for i=2,n do begin&$
nc2=nc0+nc1+1&$
nc0=nc1&$
nc1=nc2&$
nca=nca+nc2&$
end
allhkl=intarr(3,nca)
kk=0
for i=0,n do begin&$
for j=0,i do begin&$
for k=0,j do begin&$
allhkl(0,kk)=I&$
allhkl(1,kk)=j&$
allhkl(2,kk)=k&$
kk=kk+1&$
end&end&end
hkl=[1,1,1]

for i=0l,nca-1 do begin&$
if ((allhkl(0,i)/2)*2 ne allhkl(0,i)) and ((allhkl(1,i)/2)*2 ne allhkl(1,i)) and ((allhkl(2,i)/2)*2 ne allhkl(2,i)) then hkl=[[hkl],[allhkl(*,i)]]&$
if ((allhkl(0,i)/2)*2 eq allhkl(0,i)) and ((allhkl(1,i)/2)*2 eq allhkl(1,i)) and ((allhkl(2,i)/2)*2 eq allhkl(2,i)) and ((allhkl(0,i)+allhkl(1,i)+allhkl(2,i))/4)*4 eq (allhkl(0,i)+allhkl(1,i)+allhkl(2,i))  then hkl=[[hkl],[allhkl(*,i)]]&$
end
hkl=hkl(*,2:*)
s=size(hkl)
squared=fltarr(s(2))
for i=0l,s(2)-1 do squared(i)=hkl(0,i)^2+hkl(1,i)^2+hkl(2,i)^2
res=sort(squared)
squared=squared(res)
hkl=hkl(*,res)
hkl=hkl(*,where(squared gt 0))
squared=squared(where(squared gt 0))
res=uniq(squared)
squared=squared(res)
hkl=hkl(*,res)
return
end




