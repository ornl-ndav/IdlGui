 function lastzero,q,in

nq=n_elements(q)
for i=nq-1,1,-1 do begin
if (in(i)*in(i-1) lt 0) then return,i
end
return,-99
end

