pro plot38,q,p,limit=limit,old=old

if not var_defined(limit) then limit=[.5,10]
if not var_defined(old) then old=0

!p.multi=[0,4,10]

there,nthere,there,eightpacks,banks,old=old

for i=0,nthere-1 do begin
plot,q,p(i,*),xra=limit,title='eightpack'+string(i)+'/'+string(eightpacks(i)+1),chars=2

end
!p.multi=[0,1,1]
return
end


