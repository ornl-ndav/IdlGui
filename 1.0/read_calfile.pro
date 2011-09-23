pro read_calfile,corrf,file=file

e=99
while e ne 0 do begin
openr,1,file,err=err
close,1
e=err
if (err ne 0) then begin&$
print,!ERROR_STATE.MSG
print,'calfile name'
read,file
end
end
rstd,a,b,file,nz=5
corrf=b(*,1)+1
return
end

