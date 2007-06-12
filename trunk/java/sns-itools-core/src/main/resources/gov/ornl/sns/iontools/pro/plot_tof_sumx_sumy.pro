PRO PLOT_TOF_SUMX_SUMY, tmp_histo_file, Nx, Ny

Nx = Long(Nx)
Ny = Long(Ny)


set_plot, 'z'
DEVICE,SET_RESOLUTION=[Nx, Ny]
plot, indgen(Nx)
tvimg=TVRD()
set_plot,'ION'
tv,tvimg,0,-1

end
