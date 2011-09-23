pro hplazcek,q,b,normpdf,pla,itot,pvs,allg=allg,inter=inter

if not var_defined(allg) then allg=0
if not var_defined(inter) then inter=0
if not allg then begin
a=(b(0,*)+b(1,*)+b(2,*)+b(3,*)+b(4,*)+b(5,*))
normall=(normpdf(0,*)+normpdf(1,*)+normpdf(2,*)+normpdf(3,*)+normpdf(4,*)+normpdf(5,*))
aa0=[10,6,.5,6.,.1]  
  
res=curvefit(q(fr(q,2):fr(q,50)),a(fr(q,2):fr(q,50))/normall(fr(q,2):fr(q,50)),q(fr(q,2):fr(q,50))+0+1,aa0,funct='pseudovoigt',/noder)
plot,q(0:fr(q,50)),a(0:fr(q,50))/normall(0:fr(q,50)),xra=[2,50],/yno
pseudovoigt,q,aa0,res
oplot,q,res,color=255,th=2
if inter then prtc
nq=n_elements(q)
pvs=fltarr(6,nq)
pla=fltarr(nq)
qmin=[0.5,1,2,3.5,4,0.5]
qmax=[17,25,40,50,50,10]
tt=[15,31,65,122,156,8]

itot=fltarr(nq)
contrib=fltarr(6,nq)
sumnorm=fltarr(nq)
!p.multi=[0,2,3]
;for i=0,5 do begin
;sumnorm(fr(q,qmin(i)):fr(q,qmax(i)))=sumnorm(fr(q,qmin(i)):fr(q,qmax(i)))+normpdf(i,fr(q,qmin(i)):fr(q,qmax(i)))
;end
sumnorm=(normpdf(0,*)+normpdf(1,*)+normpdf(2,*)+normpdf(3,*)+normpdf(4,*)+normpdf(5,*))
for i=0,5 do begin
;contrib(i ,fr(q,qmin(i)):fr(q,qmax(i)))=normpdf(i,fr(q,qmin(i)):fr(q,qmax(i)))/sumnorm(fr(q,qmin(i)):fr(q,qmax(i)))
contrib(i,where (sumnorm ne 0))=normpdf(i,where (sumnorm ne 0))/sumnorm(where (sumnorm ne 0))
aa=aa0
  
res=curvefit(q(fr(q,qmin(i)):fr(q,qmax(i))),b(i,fr(q,qmin(i)):fr(q,qmax(i)))/normpdf(i,fr(q,qmin(i)):fr(q,qmax(i))),q(fr(q,qmin(i)):fr(q,qmax(i)))+0+1,aa,funct='pseudovoigt',/noder)
plot,q(fr(q,qmin(i)):fr(q,qmax(i))),b(i,fr(q,qmin(i)):fr(q,qmax(i)))/normpdf(i,fr(q,qmin(i)):fr(q,qmax(i))),chars=2
pseudovoigt,q,aa,res
oplot,q,res,color=255,th=2
xyouts,5,.5,'<2theta>='+string(tt(i),format='(4i)')
;itot(fr(q,qmin(i)):fr(q,qmax(i)))=itot(fr(q,qmin(i)):fr(q,qmax(i)))+contrib(i,fr(q,qmin(i)):fr(q,qmax(i)))*b(i,fr(q,qmin(i)):fr(q,qmax(i)))
itot=itot+contrib(i,*)*b(i,*)
pla=pla+contrib(i,*)*res
;pvs(i,fr(q,qmin(i)):fr(q,qmax(i)))=res
pvs(i,*)=res
end
end
if inter then prtc
!p.multi=[0,1,1]
if allg then begin
nq=n_elements(q)
nbanks=size(b)
nbanks=nbanks(1)
pvs=fltarr(nbanks,nq)
pla=fltarr(nq)
qmin=3.5
qmax=50
for i=0,nbanks-1 do begin
aa=[10,6,.5,6.,.1]   
res=curvefit(q(fr(q,qmin):fr(q,qmax)),b(i,fr(q,qmin):fr(q,qmax)),q(fr(q,qmin):fr(q,qmax))+0+1,aa,funct='pseudovoigt',/noder)
plot,q,b(i,*)
pseudovoigt,q,aa,res
oplot,q,res,color=255
prtc

pvs(i,*)=res
end

end
;stop
return
end

