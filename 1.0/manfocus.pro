pro manfocus,simb,n,resres,thre=thre,hkl=hkl,a=a,q=q,nonman=nonman,ndeg=ndeg,na=na,dq=dq,excl=excl,maxq=maxq,ignedge=ignedge

if not var_defined(thre) then thre=1e-6
if not var_defined(hkl) then hkl=[3,8,11]
if not var_defined(a) then a=5.4309  ;That's Si
if not var_defined(q) then q=findgen(2500)*.02
if not var_defined(nonman) then nonman=0
if not var_defined(ndeg) then ndeg=2
if not var_defined(na) then na=5
if not var_defined(dq) then dq=1
if not var_defined(excl) then excl=4
if not var_defined(maxq) then maxq=max(q)
if not var_defined(ignedge) then ignedge=3

if dq then ppp=maxq/700.
if not dq then ppp=0.005*2. 

data=simb(n*1024l:(n+1)*1024l-1,*)
nhkl=n_elements(hkl)
if dq then approx=2*!pi*sqrt(hkl)/a
if not dq then approx=a/sqrt(hkl)
dqminus=approx
dqplus=approx
dqminus(0)=(approx(1)-approx(0))/2.
dqplus(nhkl-1)=(approx(nhkl-1)-approx(nhkl-2))/2.
dqminus(1:*)=(approx(1:*)-approx(0:nhkl-2))/2.
dqplus(0:nhkl-2)=(approx(1:*)-approx(0:nhkl-2))/2.
if not dq then begin
dqplus=-dqplus
dqminus=-dqminus
end
tottube=findgen(8)
for i=0,7 do tottube(i)=total(data(i*128l+ignedge:i*128+127-ignedge,10:*))
m=mean(tottube)
badtube=where(tottube lt .2*m)
print,'badtube=',badtube

thestart: plotoneeight,simb<thre>0,n,dq=dq,q=q,maxq=maxq
if (nonman eq 0) then begin
 cursor,x1,y1,/device,/down
p1=CONVERT_COORD(x1,y1,/device,/to_data)
oplot,[p1(0),p1(0)],[p1(1),p1(1)],ps=2,color=255
cursor,x2,y2,/device,/down
p2=CONVERT_COORD(x2,y2,/device,/to_data)
oplot,[p2(0),p2(0)],[p2(1),p2(1)],ps=2,color=255

print,x2,y2
cursor,x3,y3,/device,/down 
p3=CONVERT_COORD(x3,y3,/device,/to_data) 
oplot,[p3(0),p3(0)],[p3(1),p3(1)],ps=2,color=255
cursor,x4,y4,/device,/down
p4=CONVERT_COORD(x4,y4,/device,/to_data)
oplot,[p4(0),p4(0)],[p4(1),p4(1)],ps=2,color=255
tube=x1/64
pix=[x1,x2,x3,x4]-tube*64
res=poly_fit(pix,[y1,y2,y3,y4],2)
end
if dq then pm=min([1.15,(approx(1)/approx(0))^.9])
if not dq then pm=min([1.15,(approx(0)/approx(1))^.9])
if nonman eq 1 then res=[approx(0),0,0]/ppp
if nonman eq 2 then begin&$
iave=data(excl,*)*0&$
for k=0,na-1 do begin&$ 
for itube=0,7 do iave=iave+data(excl+k+itube*128,*)&end
estimate=approx(0)
aa=[.1,approx(0),.1,1.,.01]
resg=gaussfit(q(fr(q,estimate/pm):fr(q,estimate*pm)),iave(fr(q,estimate/pm):fr(q,estimate*pm)),aa,nt=5)&$
y1=aa(1)
iave=data(excl,*)*0&$
for k=0,na-1 do begin&$
for itube=0,7 do iave=iave+data(127-excl-k+itube*128,*)&end
resg=gaussfit(q(fr(q,estimate/pm):fr(q,estimate*pm)),iave(fr(q,estimate/pm):fr(q,estimate*pm)),aa,nt=5)&$
y2=aa(1)
x1=excl/2.
x2=(127-excl)/2.
p2=CONVERT_COORD(x2,y2/ppp,/device,/to_data)
p1=CONVERT_COORD(x1,y1/ppp,/device,/to_data)
oplot,[x1,x1],[p1(1),p1(1)],ps=1,color=255
oplot,[x2,x2],[p2(1),p1(2)],ps=2,color=255
res=[y1-(y2-y1)/(x2-x1)*x1,(y2-y1)/(x2-x1),0]/ppp

oplot,findgen(64),(poly(findgen(60),res*ppp)-dqminus(0))/(y1)*p1(1),li=4,color=255
oplot,findgen(64),(poly(findgen(60),res*ppp)+dqplus(0))/(y1)*p1(1),li=2,color=255
endif

print,res
;for j=0,1023l do
posi=fltarr(1024,nhkl)
for i=0,1023l,na do begin&$
pixel=i-(i/128)*128&$
tube=i/128&$
w=where(tube eq badtube,n1)&$
if n1 eq 0 then begin&$
iave=data(0,*)*0&$
if pixel le na/2 then begin&$
for k=0,na-1 do iave=iave+data((i/128)*128+k,*)&endif&$
if pixel gt na/2 and pixel lt 127-na/2 then begin&$
for k=0,na-1 do iave=iave+data(i-na/2+k,*)&endif&$
if pixel ge 127-na/2 then begin&$
for k=0,na-1 do iave=iave+data((i/128)*128+128-na+k,*)&endif&$
j=0&$
estimate=poly(pixel/2,res*ppp*approx(j)/approx(0))&$
;plot,q(fr(q,estimate-.5):fr(q,estimate+.5)),iave(fr(q,estimate-.5):fr(q,estimate+.5)),ps=2&$
resg=gaussfit(q(fr(q,estimate-dqminus(j)):fr(q,estimate+dqplus(j))),iave(fr(q,estimate-dqminus(j)):fr(q,estimate+dqplus(j))),aa,nt=3)&$
;oplot,q(fr(q,estimate-.5):fr(q,estimate+.5)),resg&$
;print,pixel,i,j,aa(1)&$
posi(i,j)=aa(1)&$
endif&$
end
resres=fltarr(ndeg+1,8,nhkl)
for i=0,7 do begin&$
w=where( i eq badtube,n1)&$
if n1 eq 0 then begin&$
j=0&$
w=where(abs(posi(0+i*128+excl:127-excl+i*128,j)-poly((findgen(128-2*excl)+excl)/2,res*ppp)*approx(j)/approx(0)) lt 0.2)&$
resp=poly_fit(w,posi(w+i*128+excl,j)/approx(j),ndeg)&$
;plot,w,posi(w+i*128,j)/approx(j),/yno&$
;oplot,findgen(128),poly(findgen(128),resp)&$
;prtc&$
resres(*,i,j)=resp&$
endif&$
end
pq=fltarr(64,8,nhkl)
for i=0,7 do begin&$
for j=0,nhkl-1 do begin&$
pn=poly(findgen(64)*2,resres(*,i,0)*approx(j)/ppp)&$
for k=0,63 do begin&$
pp=CONVERT_COORD(k,pn(k),/device,/to_data)&pq(k,i,j)=pp(1)&end&$
end&end
onetube=CONVERT_COORD(64,0,/device,/to_data)

for j=0,nhkl-1 do begin&$
for i=0,7 do begin&$
oplot,i*onetube(0)+findgen(64)/64*onetube(0),pq(*,i,j),color=255&end&end
;;;print,'accept? <0,1>'
;;;read,accept
accept=1
if accept lt .5 then goto, thestart


return
end
