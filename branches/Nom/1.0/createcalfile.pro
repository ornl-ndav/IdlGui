pro createcalfile,number , UDET , offset, mask1,wherebad ,group,name=name

n=n_elements(number)
if not var_defined(name) then name='nomad.calfile'

there,nthere,dthere,eightpacks,banks
pack=wherebad/1024l
select=indgen(n)
for i=0l,n-1 do begin
w=where(wherebad+eightpacks(pack)*1024l+2 eq i,n1)
select(i)=(n1 eq 0) and mask1(i)
end

openw,1,name
printf,1,'#          number    UDET    offset      select     group'
for i=0l,n-1 do begin
printf,1,number(i) , UDET(i) , offset(i), select(i) ,group(i),format='(i9,i16,f14.6,i8,i8)'
end
close,1
return
end

