pro hplazcek,q,b,normpdf,pla,itot,pvs,allg=allg

if not var_defined(allg) then allg=0

if not allg then begin

nq=n_elements(q)
pvs=fltarr(6,nq)
pla=fltarr(nq)
qmin=[0.5,1,2,3.5,4,0.5]
qmax=[17,25,40,50,50,10]
itot=fltarr(nq)
contrib=fltarr(6,nq)
sumnorm=fltarr(nq)
;for i=0,5 do begin
;sumnorm(fr(q,qmin(i)):fr(q,qmax(i)))=sumnorm(fr(q,qmin(i)):fr(q,qmax(i)))+normpdf(i,fr(q,qmin(i)):fr(q,qmax(i)))
;end
sumnorm=(normpdf(0,*)+normpdf(1,*)+normpdf(2,*)+normpdf(3,*)+normpdf(4,*)+normpdf(5,*))
for i=0,5 do begin
;contrib(i ,fr(q,qmin(i)):fr(q,qmax(i)))=normpdf(i,fr(q,qmin(i)):fr(q,qmax(i)))/sumnorm(fr(q,qmin(i)):fr(q,qmax(i)))
contrib(i,where (sumnorm ne 0))=normpdf(i,where (sumnorm ne 0))/sumnorm(where (sumnorm ne 0))
aa=[10,6,.5,6.,.1]  
  
res=curvefit(q(fr(q,qmin(i)):fr(q,qmax(i))),b(i,fr(q,qmin(i)):fr(q,qmax(i))),q(fr(q,qmin(i)):fr(q,qmax(i)))+0+1,aa,funct='pseudovoigt',/noder)
plot,q(fr(q,qmin(i)):fr(q,qmax(i))),b(i,fr(q,qmin(i)):fr(q,qmax(i)))
pseudovoigt,q,aa,res
oplot,q,res,color=255
;prtc

;itot(fr(q,qmin(i)):fr(q,qmax(i)))=itot(fr(q,qmin(i)):fr(q,qmax(i)))+contrib(i,fr(q,qmin(i)):fr(q,qmax(i)))*b(i,fr(q,qmin(i)):fr(q,qmax(i)))
itot=itot+contrib(i,*)*b(i,*)
pla=pla+contrib(i,*)*res
;pvs(i,fr(q,qmin(i)):fr(q,qmax(i)))=res
pvs(i,*)=res
end
end
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

