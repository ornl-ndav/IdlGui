PRO clear, tmp_histo_file, Nx, Ny

set_plot, 'z'
DEVICE,SET_RESOLUTION=[2*Nx, 2*Ny]
erase

tvimg=TVRD()
set_plot,'ION'
loadct, 39, /silent
tv,tvimg,0,-1

END
