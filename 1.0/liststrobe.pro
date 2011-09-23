pro liststrobe,wstrobe,filen=file,timebin=timebin

if not var_defined(timebin) then timebin=1

openr,1,file
fs=fstat(1)
N=fs.size   ; length of the file in bytes

Nbytes = 8  ; data are Uint32 = 4 bytes
N = fs.size/Nbytes

chunk=10000000l
nchunk=fix(N/chunk)+1
data=lindgen(2*chunk)
nswitch=0
allws=[1]
allw2=[1]
for i=0l,nchunk-1 do begin
if i eq nchunk-1 then data=lindgen(2*(n-i*chunk)) 
readu,1,data
ww1=where(data(lindgen(chunk)*2+1) ge 2^30.,nn1)+i*chunk
ww2=where(data(ww1*2+1)/2*2 eq data(ww1*2+1),nn2)
allws=[allws,ww1]
allw2=[allw2,ww2]
nswitch=nswitch+nn1
print,i,nswitch
end
if nswitch eq nswitch/2*2 then allws=allws(0:n_elements(allws)-2)
if nswitch eq nswitch/2*2 then allw2=allw2(0:n_elements(allw2)-2)
allws=allws(1:*)
allw2=allw2(1:*)
allw2=allw2-allw2/2*2
nall=n_elements(allws)
hightolow=fltarr(nall)
hightolow(findgen(nall/2)*2+1)=1
close,1
liststrobe=lindgen(nall-1,2*timebin)
for i=0,nall-2 do begin
delta=(allws(i+1)-allws(i))/timebin
for j=0,timebin-1 do begin
liststrobe((i-abs(hightolow(i)-hightolow(0))),j+hightolow(i)*timebin)=allws(i)+j*delta
liststrobe((i-abs(hightolow(i)-hightolow(0)))+1,j+hightolow(i)*timebin)=allws(i)+(j+1)*delta-1
end
end
wstrobe=liststrobe

return
end



