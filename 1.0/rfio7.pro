
pro rfio7,ndummy,nsp,t,tau,x,y,n,name,e,dunkel=dunkel
; Liest einen Spektra FIO file. ndummy DUmmyzeilen werden "uberlesen ;if name lt 10 then name=string(name,format='(i1)') ;if name lt 100 and name ge 10 then name=string(name,format='(i2)') ;if name ge 100 then name=string(name,format='(i3)') ;name='/tmp
;name='/tmp/neuefein/mark_tt_'+name+'.fio'
dm='mist'
if not var_defined(dunkel) then dunkel=0

a=fltarr(nsp+1,10000)
b=fltarr(nsp+1)
on_ioerror,schluss
lesen=0
i=0
debut:openr,1,name
for i=0,ndummy do readf,1,dm
i=-1

while not eof(1) do begin
i=i+1
readf,1,b
a(*,i)=b(*)
endwhile

close,1
print,i,' Werte eingelesen aus File:',name
npt=i
res=[1.66247,-1.10418e-05]
x=a(0,0:npt-1)
y=a(1:*,0:npt-1)
e1=sqrt(y(0,*))
n=invtau(y(0,*),tau/t,100)
e1=e1*n/y(0,*)
e2=sqrt(y(7,*))
n=n/(y(5,*)-dunkel*t)

;n=n/y(1,*)
e=sqrt((e1/y(7,*))^2+(n*e2/y(7,*))^2)
;e=sqrt((e1/y(1,*))^2+(n*e2/y(1,*))^2)
e=e(*)
;3.93
x=x(*)
n=n(*)
return
schluss:if !err eq -167 then begin
print,!err_string
read,'Wie heist der file doch gleich??  ',name
goto,debut
endif
print,!err_string,!err
heteinde:close,1
end
;*exp(y(4,*)/10*3.5e-6)
;poly(y(0,*)/10.,res)
;(1-2.88e-6*y(0,*)/t-2.77205e-11*(y(0,*)/t)^2))
