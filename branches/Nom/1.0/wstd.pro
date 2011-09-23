pro wstd,q,int,name,nzei=nzei,comment=comment
openw,2,name
npt=min([n_elements(q),n_elements(int)])
printf,2,npt,format='(1h#,i11)'
printf,2,'#     file:    '+name
printf,2,'#     created: '+systime(0)
if var_defined(comment) then $
printf,2,'#     Comment: '+comment
printf,2,'#     '

setdefault,nzei,2
if nzei eq 1 then for i=0,npt-1 do printf,2,q(i)
if nzei eq 2 then begin
for i=0,npt-1 do printf,2,q(i),int(i)
if (n_elements(q) ne n_elements(int)) then print, '!!! Achtung: x hat ',$
n_elements(q),' Elemente und y ',n_elements(int),'.NPT ist jetzt gleich ',npt,$
'in file',name
goto,heteinde
end
n1=n_elements(int)/(nzei-1)
if n1*(nzei-1) ne n_elements(int) then begin & print,'@@@ Error! Wrong number of elements in wstd'&end
if n1*(nzei-1) eq n_elements(int) then begin
s=size(int)
if (s(1) eq n_elements(q)) then for i=0,npt-1 do printf,2,q(i),int(i,*)
if (s(2) eq n_elements(q)) then for i=0,npt-1 do printf,2,q(i),int(*,i)
end
heteinde:
close,2
return
end
