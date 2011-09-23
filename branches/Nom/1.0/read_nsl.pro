function read_nsl,dum
openr,1,'~neuefein/public/nsl.dat'
dum=''
nzeilen=0
while not eof(1) do begin
readf,1,dum
nzeilen=nzeilen+1
endwhile
close,1
nsl={element:strarr(nzeilen),bcoh:fltarr(nzeilen),$
xcoh:fltarr(nzeilen),xinc:fltarr(nzeilen),xscat:fltarr(nzeilen),$
xabs:fltarr(nzeilen)}
openr,1,'~neuefein/public/nsl.dat'
for i=0,nzeilen-1 do begin
readf,1,dum,a,b,c,d,e,format='(a2,5f9.4)'
nsl.element(i)=dum
nsl.bcoh(i)=a
nsl.xcoh(i)=b
nsl.xinc(i)=c
nsl.xscat(i)=d
nsl.xabs(i)=e
end

w=where(strmid(nsl.element,1,1) eq ' ')
nsl.element(w)=strmid(nsl.element(w),0,1)
close,1
return,nsl
end
