pro makebin,listofscans,template,help=help,bintemplate=bintemplate

if not var_defined(bintemplate) then bintemplate='bin9999.bat'
if not var_defined(template) then template='9999'
if not var_defined(help) then help=0
if help eq 1 then begin
print,'USAGE: makebin,listofscans,template,help=help,bintemplate=bintemplate'
print,'Creates a number of bin files fo listofscans and dosome.bat file'
print,'listofscans eg [2510,2515,1518] of findgen(10)+2510'
print,'if listofscans is not defined it will be determined interactively'
print,"template string to be replaced by scannumber eg '9999' (default)" 
print,"bintemplate='bin9999.bat (default) binfile used as template"
print,'help=1 (default 0) prints this message'
return
endif
if not var_defined(rootdir) then rootdir='/SNS/NOM/IPTS-'

;if not var_defined(ipts) then begin
;ipts=9999
;read,'IPTS-Nr please? ',ipts
;endif
;if ipts gt 999 and ipts le 9999 then iptsstring=string(ipts,format='(i4)')
;if ipts gt 99 and ipts le 999 then iptsstring=string(ipts,format='(i3)')
;if ipts gt 9 and ipts le 99 then iptsstring=string(ipts,format='(i2)')
;if ipts gt 0 and ipts le 9 then iptsstring=string(ipts,format='(i1)')

if not var_defined(listofscans) then begin
minsc=9999
moron: read,'Minimum Scan-Nr? ',minsc
read,'Maximum Scan-Nr (>minsc)? ',maxsc
if minsc ge maxsc then goto,moron
listofscans=minsc+indgen(maxsc-minsc+1)
endif
nlos=n_elements(listofscans)

openr,1,bintemplate
zeile=0
dummy='dummy'
for i=0,nlos-1 do begin
scstring=string(listofscans(i),format='(i4)')
openw,2+i,'bin'+scstring+'.bat'
endfor
while not eof(1) do begin
readf,1,dummy
dummy1=dummy
for i=0,nlos-1 do begin
dummy=dummy1
flag=0
scstring=string(listofscans(i),format='(i4)')
while flag eq 0 do begin
found1 = STRPOS(dummy,template,/reverse_search)
if found1 ge 0 then dummy=STRMID( dummy,0,found1)+scstring+STRMID(dummy,found1+4)
if found1 lt 0 then flag=1
endwhile
printf,2+i,dummy
endfor

zeile=zeile+1
endwhile
close,1
for i=0,nlos-1 do begin
close,2+i
endfor
openw,1,'dosome.bat'
for i=0,nlos-1 do begin
scstring=string(listofscans(i),format='(i4)')
printf,1,'idl bin'+scstring+'.bat&'
endfor
close,1
return
end

