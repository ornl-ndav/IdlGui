pro reqscale,result,q,scan,hkl=hkl,a=a,vs=vs

if not var_defined(hkl) then hkl=[3,8,11,16,19,24,27,32,35,40,43]
if not var_defined(VS) then vs=[3,2]
if not var_defined(a) then a=5.4309  ;That's Si

foundposition=float(hkl)
foundwidth=float(hkl)
approx=2*!pi*sqrt(hkl)/a
dqminus=approx(0:vs(0)-1)
dqplus=dqminus
dqminus(0)=(approx(1)-approx(0))/2.
dqplus(vs(0)-1)=(approx(vs(0)-1)-approx(vs(0)-2))/2.
dqminus(1:*)=(approx(1:*)-approx(0:vs(0)-2))/2.
dqplus(0:vs(0)-2)=(approx(1:*)-approx(0:vs(0)-2))/2.
plot,q,scan>1e-5,xra=[min(approx),max(approx)],/yty

for i=0,vs(0)-1 do begin
res=gaussfit(q(fr(q,approx(i)-dqminus(i)):fr(q,approx(i)+dqplus(i))),scan(fr(q,approx(i)-dqminus(i)):fr(q,approx(i)+dqplus(i))),aa,nt=4)
foundposition(i)=aa(1)
foundwidth(i)=aa(2)
oplot,q(fr(q,approx(i)-dqminus(i)):fr(q,approx(i)+dqplus(i))),res,th=2
end
print,foundposition
lastbg=aa(3)
deltar=approx(i-1)-aa(1)
lastsigma=aa(2)
aa=fltarr(14)
aa(12:13)=[lastbg,lastbg/100.]
aa(0+findgen(4)*3)=10*lastbg&$

for i=0,vs(1)-1 do begin&$
aa(1+findgen(4)*3)=approx(4*i+vs(0)+findgen(4))-deltar&$
aa(2+findgen(4)*3)=0.01*approx(4*i+vs(0)+findgen(4))&$
qminus=approx(4*i+vs(0))-.2&$
qplus=approx(4*i+vs(0)+3)+.2&$
         parinfo = replicate({value:0.D, fixed:0, $
                           limited:[0,0], limits:[0.D,0], step:0.D}, 14)&$
parinfo([1,4,7,10]).limited(*)=1&$
parinfo([0,3,6,9]).limited(0)=1&$
parinfo([2,5,8,10]).limited(*)=1&$
parinfo([1,4,7,10]).limits(0)=0.98*approx(4*i+vs(0)+findgen(4))&$
parinfo([1,4,7,10]).limits(1)=1.02*approx(4*i+vs(0)+findgen(4))&$
parinfo([0,3,6,9]).limits(0)=0&$
parinfo([2,5,8,11]).limits(0)=0.7*lastsigma&$
parinfo([2,5,8,11]).limits(1)=1.3*lastsigma&$
res=my_newcurvefit(q(fr(q,qminus):fr(q,qplus)),scan(fr(q,qminus):fr(q,qplus)),q(fr(q,qminus):fr(q,qplus))*0+1,aa,/noder,funct='viergauss',parinfo=parinfo)&$
foundposition(4*i+vs(0)+findgen(4))=aa(1+findgen(4)*3)&$
foundwidth(4*i+vs(0)+findgen(4))=aa(2+findgen(4)*3)&$
oplot,q(fr(q,qminus):fr(q,qplus)),res,th=2&$
end

result=[[foundposition],[approx],[foundwidth]]
return
end
