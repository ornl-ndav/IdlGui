pro plot6,q,b,limit=limit,old=old

if not var_defined(limit) then limit=[.5,10]
if not var_defined(old) then old=0

!p.multi=[0,2,3]

there,nthere,there,eightpacks,banks,old=old

for i=0,5 do begin
plot,q,b(i,*),xra=limit,title='bank'+string(i+1)

end
!p.multi=[0,1,1]
return
end


