pro pseudovoigt,x,a,f

;;;f=a(0)*voigt(a(1),x)+a(2)

l=1/!pi*(.5*a(0))/((x)^2+(.5*a(0))^2)
;Lorentzian centered at 0

g=1/sqrt(2*!pi*a(1)^2)*exp((-(x)^2/2/a(1)^2)>(-70))
; Gaussian centered at 0

f=a(2)*l+(1-a(2))*g
; linear combination

f=f*a(3)+a(4)
; times scale factor + constant

return
end
