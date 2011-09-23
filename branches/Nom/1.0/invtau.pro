 function invtau,y,tau,n
x=y

for i=0,n do begin
test=x*exp(-tau*x)
x=x+(y-test)
endfor
;res=[1,-0.00222778,0.000597000]
;x=x/poly(alog(y),res)
return,x
end
