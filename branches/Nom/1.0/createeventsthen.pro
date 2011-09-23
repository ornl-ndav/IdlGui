readtemplog,time,temp,file='/SNS/NOM/templog600.dat'
time=time+3600  ;for winter time
read_pulsid,plow,phigh,evid,char,file='/SNS/NOM/NOM_600/NOM_600_pulseid.dat'

inrange=where(time gt min(phigh) and time lt max(phigh))
tmin=min(temp(inrange))
tmax=max(temp(inrange))
time=time(inrange)
temp=temp(inrange)

tempw=findgen(fix(tmax)-fix(tmin))+fix(tmin)

eventsthen=fltarr(n_elements(tempw))
for i=0, n_elements(tempw)-1 do begin&$
when=where(temp gt tempw(i) and temp lt tempw(i)+1,n1)&$
if n1 gt 0 then begin&$
minwhen=min(when)&$
maxwhen=max(when)&$
eventsthen(i)=min(abs(time(minwhen)-phigh),m1)&$
eventsthen(i)=m1&$
end

eventsthen=evid(eventsthen(sort(eventsthen)))
tempw=tempw(sort(eventsthen))+.5


