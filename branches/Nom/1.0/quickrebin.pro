pro quickrebin,simb,n,resres,simbr,simbsum,q=q


if not var_defined(q) then q=findgen(2500)*.02

data=simb(n*1024l:n*1024l+1023l,*)
simbr=data*0
simbsum=q*0

for i=0,1023l do begin
tube=fix(i/128)
pixel=i-tube*128
qr=q/poly(pixel,resres(*,tube,0))
simbr(i,*)=rebindtoq(data(i,*),qr,q)
simbsum=simbsum+simbr(i,*)
if ((i/100)*100 eq i) then print,i
end
return
end


