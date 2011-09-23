pro intstrain,q,azimuth,data,qp,maxim


nq=n_elements(q)
nt=n_elements(azimuth)
maxim=fltarr(nt)
d1=data
a=fltarr(nt,2)


for i=0,nt-1 do begin
m=max(data(*,i),m1)
temp=data(0:m1,i)*shift(data(0:m1,i),1)
temp=temp(1:*)
z1=where(temp lt 0)
temp=data(m1:*,i)*shift(data(m1:*,i),1)
temp=temp(1:*)
z2=m1+where(temp lt 0)+1

maxim(i)=q(m1)
qp(i)=total(data(z1:z2,i)*q(z1:z2))/total(data(z1:z2,i))
end
return
end
