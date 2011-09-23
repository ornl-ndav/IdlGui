pro strstrain,q,azimuth,data,qp,maxim,width=wi

if (not var_defined(wi)) then wi =2
nq=n_elements(q)
nt=n_elements(azimuth)
maxim=fltarr(nt)
d1=data
a=fltarr(nt,2)


for i=0,nt-1 do begin
m=max(data(*,i),m1)
res=poly_fit(q(m1-wi:m1+wi),data(m1-wi:m1+wi,i),2)
qp(i)=-0.5*res(1)/res(2)
maxim(i)=poly(qp(i),res)

end
return
end
