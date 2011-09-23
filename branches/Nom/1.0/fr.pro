function fr,r,rx

m=0

nr=n_elements(r)

for i=1,nr-1 do begin
if (r(i-1) le rx) and (r(i) gt rx) then m=i-1
end
if rx ge max(r) then m=nr-1
return,m
end
