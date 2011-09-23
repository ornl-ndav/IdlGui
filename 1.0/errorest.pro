
pro errorest,int,ei,ni,file=file_pid,maxtime=maxtime

if not var_defined(pulse_group) then pulse_group=60

read_pulsid,plow,phigh,evid,char,filename=file_pid

n_pulseg=n_elements(char)/pulse_group
normf=fltarr(n_pulseg)
onesecev=fltarr(n_pulseg)
for i=0l,n_pulseg-1 do begin
normf(i)=total(char(i*60l:(i+1)*60l-1))
onesecev(i)=evid((i+1)*60l-1)
end
ww=where(normf gt 0,nw)
if nw eq 0 then return
normf(ww)=1e6/normf(ww)
m=median(normf(ww))
wn1=where((normf lt 1.2*m) and (normf gt 0.8*m))
 d1=onesecev-shift(onesecev,1)
d1(0)=onesecev(0)
if var_defined(maxtime) then begin
if n_elements(wn1) gt maxtime then wn1=wn1(0:maxtime)
end
normf(wn1)=normf(wn1)/float(n_elements(wn1))
n1=stdev(normf,n2)
ni=int/n2
ei=sqrt(ni)
print,n2,ni(1000)
stop
return
end









