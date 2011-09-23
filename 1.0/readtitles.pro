pro readtitles,listofscans,ipts,rootdir=rootdir,sci=sci,flos=flos,help=help

if not var_defined(help) then help=0
if help eq 1 then begin
return
endif
if not var_defined(rootdir) then rootdir='/SNS/NOM/IPTS-'
if not var_defined(flos) then flos='los.txt'
if not var_defined(sci) then sci=0

if not var_defined(ipts) then begin
ipts=9999
read,'IPTS-Nr please? ',ipts
endif
if ipts gt 999 and ipts le 9999 then iptsstring=string(ipts,format='(i4)')
if ipts gt 99 and ipts le 999 then iptsstring=string(ipts,format='(i3)')
if ipts gt 9 and ipts le 99 then iptsstring=string(ipts,format='(i2)')
if ipts gt 0 and ipts le 9 then iptsstring=string(ipts,format='(i1)')

if not var_defined(listofscans) then begin
minsc=9999
moron: read,'Minimum Scan-Nr? ',minsc
read,'Maximum Scan-Nr (>minsc)? ',maxsc
if minsc ge maxsc then goto,moron
listofscans=minsc+indgen(maxsc-minsc+1)
endif
nlos=n_elements(listofscans)

openw,1,flos

dummy='dummy'
for i=0,nlos-1 do begin
scstring=string(listofscans(i),format='(i4)')
if not sci then openr,2,rootdir+iptsstring+'/0/'+scstring+'/preNeXus/NOM_'+scstring+'_runinfo.xml'
if sci then openr,2,rootdir+scstring+'/preNeXus/NOM_'+scstring+'_runinfo.xml'
flag=0
while flag eq 0 do begin
readf,2,dummy
found1 = STRPOS(dummy, '<Title>',/reverse_search)
found2 = STRPOS(dummy, '</Title>',/reverse_search)
title=STRMID( dummy, found1+7,found2-found1-7 )
if found1 ge 0 then flag=1
endwhile

print,fix(listofscans(i)),'  '+title
printf,1,fix(listofscans(i)),'  '+title
close,2
endfor
close,1
return
end

