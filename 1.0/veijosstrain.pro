pro veijosstrain,q,azimuth,data,qp

nq=n_elements(q)
nt=n_elements(azimuth)

d1=data
a=fltarr(nt,2)


for i=0,nt-1 do d1(*,i)=(shift(data(*,i),1)-shift(data(*,i),-1))/(shift(q,1)-shift(q,-1))
a1=[1,1e-10]
for i=1,nt-1 do begin
func_extra=[[reform(data(1:nq-2,i-1))],[reform(d1(1:nq-2,i-1))]]
res=my_newcurvefit(q(1:nq-2),reform(data(1:nq-2,i)),q(1:nq-2)*0+1,A1,FUNCTI='ab',/noder,func_extra=func_extra)
a(i,*)=a1
end
func_extra=[[reform(data(1:nq-2,nt-1))],[reform(d1(1:nq-2,nt-1))]]
res=my_newcurvefit(q(1:nq-2),data(1:nq-2,0),q(1:nq-2)*0+1,A1,FUNCTI='ab',/noder,func_extra=func_extra)
a(0,*)=a1
dq=a(*,1)/a(*,0)
m=max(data(*,0),m1)

res=poly_fit(q(m1-2:m1+2),data(m1-2:m1+2,0),2)


qp(0)=-0.5*res(1)/res(2)
for i=1,nt-1 do qp(i)=qp(i-1)-dq(i)
return
end

pro ab,x,a,f,pder,func_extra=fe

f=a(0)*fe(*,0)+a(1)*fe(*,1)

return
end
