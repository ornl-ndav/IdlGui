pro ftneqs,q,int,r,ft,lorch=lorch

; FT of int(Q)  -> ft(r) the meaning of Q and r may be reversed ; actually it calculates  sum i(Q) sin(Qr)/(Qr) Q^2 dQ

if (not var_defined(lorch)) then lorch=0

dq=q*0
nq=n_elements(q)
dq(1:nq-2)=(q(2:*)-q(0:nq-3))/2.
dq(0)=(q(0)+q(1))/2.
dq(nq-1)=q(nq-1)-q(nq-2)

; Q or r is not assumed to be equidistant

int1=int*q^2
; multiply with Q^2 beforehand

if n_elements(r) eq 0 then r=(dindgen(nq))*!pi/max(q) ; if r is undefined, define it.

nr=n_elements(r)
ft=dblarr(nr)
; define ft as a double precision vector

if (lorch eq 0) then begin&for i=0,nr-1 do begin&x=q*r(i)& ft(i)=total(int1*j0(x)*dq) &end&end

if (lorch ne 0) then begin&for i=0,nr-1 do begin&x=q*r(i)& ft(i)=total(int1*dq*j0(x)*j0(!pi*q/max(q))) &end&end

; do the summation

return
end

function j0,x
; this function calculates sin(x)/x, avoiding division by zero (sin(0)/0=1)

y=x
w=where(x gt 1e-20,n)
if n gt 0 then y(w)=sin(x(w))/x(w)
w=where(x lt 1e-20,n)
if n gt 0 then y(w)=1.d0
return,y
end








