function rebindtoq,a,q1,q2

n1=n_elements(q1)
n2=n_elements(q2)
b=q2*0
dq2=q2(1)-q2(0)

q3=[0,min(q1)-dq2*.5]
i3=[0,0]
for i=0,n2-1 do begin

;if q2(i)+dq2*.5 lt min(q1) then b(i)=0
;if q2(i)-dq2*.5 gt max(q1) then b(i)=0
w=where((q1 lt q2(i)+dq2*.5) and  (q1 gt q2(i)-dq2*.5),nw)
if (nw gt 0) then begin
i3=[i3,total(a(w))/float(nw)]
q3=[q3,total(q1(w))/float(nw)]
endif
endfor

b=interpol(i3,q3,q2)




return,b
end
