pro createmask,wherebad,listofscans,ipts,rootdir=rootdir,sci=sci,ignedge=ignedge,bad=bad,btl=btl,help=help

firstn=1e7
thresh=firstn/10000.

if not var_defined(help) then help=0
if help eq 1 then begin
print,'USAGE: createmask,wherebad,listofscans,ipts,rootdir=rootdir,sci=sci,ignedge=ignedge,bad=bad,btl=btl,help=help
print,'wherebad = array to contain a list of bad pixels to be used by grouping'
print,'listofscans (optional) list of scans to be investigated,
print,' e.g. listofscans=[1000,1432] look for bad pixel in scan 1000 and 1432]
print,'ipts (optional) IPTS number'
print,"rootdir= '/SNS/NOM/IPTS-' (that is the default) look for the data in/SNS/NOM/IPTS-..."
print,'sci=1 means data are not in an ipts directory but in an sci directory'
print,'ignedge (default 3), ignedge=n ignores the n fisr and last pixel in each tube'
print,'bad=bad returns a bad eightpack list'
print,'btl=blt returns a bad tube list'
print,'help=1 prints this help'
return 
endif
if not var_defined(rootdir) then rootdir='/SNS/NOM/IPTS-'
if not var_defined(ignedge) then ignedge=3
if not var_defined(sci) then sci=0

if not var_defined(ipts) then begin
ipts=9999
read,'IPTS-Nr please? ',ipts
endif

if not var_defined(listofscans) then begin
minsc=9999
moron: read,'Minimum Scan-Nr? ',minsc
read,'Maximum Scan-Nr (>minsc)? ',maxsc
if minsc ge maxsc then goto,moron
listofscans=minsc+indgen(maxsc-minsc+1)
endif
nlos=n_elements(listofscans)
there,nthere,dthere,eightpacks,old=old
npixel=99*1024l
bad=[999]
btl1=[999]
tpack=fltarr(nthere)
ttube=fltarr(nthere*8)


if ipts gt 999 and ipts le 9999 then iptsstring=string(ipts,format='(i4)')
if ipts gt 99 and ipts le 999 then iptsstring=string(ipts,format='(i3)')
if ipts gt 9 and ipts le 99 then iptsstring=string(ipts,format='(i2)')
if ipts gt 0 and ipts le 9 then iptsstring=string(ipts,format='(i1)')
data= lonarr(firstn*2)
for i=0,nlos-1 do begin
scstring=string(listofscans(i),format='(i4)')
if not sci then openr,1,rootdir+iptsstring+'/0/'+scstring+'/preNeXus/NOM_'+scstring+'_neutron_event.dat'
if sci then openr,1,rootdir+scstring+'/preNeXus/NOM_'+scstring+'_neutron_event.dat'
fs=fstat(1)
N=fs.size   ; length of the file in bytes

Nbytes = 4  ; data are Uint32 = 4 bytes
N = fs.size/Nbytes
if n/2 gt firstn then begin
readu,1,data
a=histogram(data(lindgen(firstN)*2+1),min=0,max=npixel-1)
for j=0,nthere-1 do begin
tpack(j)=total(a(eightpacks(j)*1024l:eightpacks(j)*1024l+1023l))
for k=0,7 do ttube(j*8+k)=total(a(eightpacks(j)*1024l+k*128+findgen(128)))
end
wpack=where(tpack lt thresh,n1)
if n1 gt 0 then bad=[bad,wpack]
wtube=where(ttube lt thresh/8,n1)
if n1 gt 0 then btl1=[btl1,wtube]
endif
close,1
endfor

if n_elements(bad) gt 1 then bad=bad(1:*)
if n_elements(btl1) gt 1 then btl1=btl1(1:*)
print,'All bad',bad
u=uniq(bad,sort(bad))
bad=bad(u)
print,'Unique bad',bad
u=uniq(btl1,sort(btl1))
btl1=btl1(u)
btl=[999,999]

wherebad=[999999]
if bad(0) ne 999 then begin
for i=0,n_elements(bad)-1 do wherebad=[wherebad,bad(i)*1024l+findgen(1024)]
endif
for i=0,n_elements(btl1)-1 do begin
btl=[btl,btl1(i)-btl1(i)/8*8,btl1(i)/8]
w=where(btl1(i)/8 eq bad,n1)
if n1 lt 1 then wherebad=[wherebad,btl1(i)*128l+findgen(128)]
endfor
if ignedge gt 0 then begin
for i=0,nthere-1 do begin
for j=0,7 do begin
wherebad=[wherebad,i*1024l+j*128l+findgen(ignedge)]
wherebad=[wherebad,i*1024l+j*128l+127l-findgen(ignedge)]
endfor
endfor
endif
if n_elements(btl) gt 2 then btl=btl(2:*)

if n_elements(wherebad) gt 1 then wherebad=wherebad(1:*)
wherebad=wherebad(sort(wherebad))
u=uniq(wherebad)
wherebad=wherebad(u)



return
end


