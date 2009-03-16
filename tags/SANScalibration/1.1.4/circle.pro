function circle,Nx,Ny,x0,y0,r
;function to return the indicies for values within the radius of a
;circle

indx = intarr(Nx,Ny)
	for y=0L,Ny-1 do begin
		for x=0L,Nx-1 do begin
			rval = sqrt((x-x0)^2 + (y-y0)^2)
			if rval LE r then indx[x,y] = 1
		endfor;i
	endfor;j
return,indx
end
