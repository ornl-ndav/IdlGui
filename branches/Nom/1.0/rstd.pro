pro rstd,q,i,name,pd=pd,nzeil=nzeil,sil=sil
setdefault,nzeil,2
setdefault,sil,0
openr,1,name
dum=''
dummycounter=0
datacounter=0l
while not eof(1) do begin
readf,1,dum
if strmid(dum,0,1) ne '#' then  datacounter=datacounter+1
if strmid(dum,0,1) eq '#' and datacounter eq 0 then dummycounter=dummycounter+1
endwhile
close,1
; first pass
if var_defined(pd) then begin
dummycounter=pd
datacounter=datacounter-pd
endif
openr,1,name
for i=0,dummycounter-1 do readf,1,dum
npt=datacounter
a=dblarr(nzeil*npt)
g=fltarr(npt,nzeil)
g(*,0)=findgen(npt)*nzeil
for i=1,nzeil-1 do g(*,i)=g(*,0)+i
readf,1,a
q=a(g(*,0))
if (nzeil eq 1) then i=q
if (nzeil gt 1) then begin
i=fltarr(npt,nzeil-1)
for ii=1,nzeil-1 do i(*,ii-1)=a(g(*,ii))
end
if (sil eq 0) then print,'NPT=',npt
close,1
return
end

