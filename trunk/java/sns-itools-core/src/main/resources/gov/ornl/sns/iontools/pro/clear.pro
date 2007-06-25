PRO clear, tmp_histo_file, Nx, Ny

Nx = long(Nx)
Ny = long(Ny)

Narray = [Nx,Ny]
Nmin = min(Narray,max=Nmax)

set_plot, 'z'
DEVICE,SET_RESOLUTION=[2*Nmin, 2*Nmax]
erase

tvimg=TVRD()
set_plot,'ION'
loadct, 39, /silent
tv,tvimg,0,-1

END
