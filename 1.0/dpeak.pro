PRO dpeak, X, A, F
bx = EXP(-((x-A[1]) /a(2))^2/2)
bx2 = EXP(-((x-A[4])/a(5))^2/2)

F = A[0] * bx + A(3)*bx2+ A[6]

end
