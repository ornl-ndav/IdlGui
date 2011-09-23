pro plotoneeight,histo,ntoplot,limit=limit,dq=dq,q=q,maxq=maxq

if not var_defined(limit) then limit=[4,123]
if not var_defined(dq) then dq=1
if (not var_defined(q)) and dq then q=findgen(2500)*.02
if (not var_defined(q)) and (not dq) then q=findgen(1000)*.05
deltaq=q(1)-q(0)
if not var_defined(maxq) then maxq=max(q)
nmaxq=fr(q,maxq)


s=size(histo)
plotarr=fltarr(1024,nmaxq)

for i=0,7 do plotarr(i*128l+limit(0)+findgen(limit(1)-limit(0)),*)=histo(ntoplot*1024l+i*128l+limit(0)+findgen(limit(1)-limit(0)),0:nmaxq-1)

;window,xsize=1050/2,ysize=s(2)/4+4,colors=256
window,xsize=1050/2,ysize=700,colors=256
plot,/noda,[0,512 ],[min(q),max(q)],/xst,/yst,xmar=0,ymar=0
loadct,3
tvscl,congrid(plotarr,512,700)
q3=CONVERT_COORD(0,3/.02/4,/device,/to_data)
q40=CONVERT_COORD(512,700*.8 ,/device,/to_data)
q30=CONVERT_COORD(512,700*.6,/device,/to_data) 
q20=CONVERT_COORD(512,700*.4,/device,/to_data) 
q10=CONVERT_COORD(512,700*.2,/device,/to_data) 
oplot,[0,q10(0)],[q10(1),q10(1)],color=255,li=2
oplot,[0,q20(0)],[q20(1),q20(1)],color=255,li=2
oplot,[0,q30(0)],[q30(1),q30(1)],color=255,li=2
oplot,[0,q40(0)],[q40(1),q40(1)],color=255,li=2
if dq then begin
xyouts,20,q10(1)+1*deltaq/.02,'Q='+string(maxq*.2,format='(f5.2)'),color=255
xyouts,20,q20(1)+1*deltaq/.02,'Q='+string(maxq*.4,format='(f6.2)'),color=255
xyouts,20,q30(1)+1*deltaq/.02,'Q='+string(maxq*.6,format='(f6.2)'),color=255
xyouts,20,q40(1)+1*deltaq/.02,'Q='+string(maxq*.8,format='(f6.2)'),color=255
endif
if not dq then begin
xyouts,20,q10(1)+.1,'d='+string(maxq*.2,format='(f5.2)'),color=255
xyouts,20,q20(1)+.1,'d='+string(maxq*.4,format='(f5.2)'),color=255
xyouts,20,q30(1)+.1,'d='+string(maxq*.6,format='(f5.2)'),color=255
xyouts,20,q40(1)+.1,'d='+string(maxq*.8,format='(f5.2)'),color=255
endif
return
end

