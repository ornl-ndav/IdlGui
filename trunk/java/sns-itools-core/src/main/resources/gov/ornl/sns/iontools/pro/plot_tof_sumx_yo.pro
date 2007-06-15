PRO PLOT_TOF_SUMX_YO, yo, tmp_histo_file, Nx, Ny

Nx = Long(Nx)
Ny = Long(Ny)
yo = Long(yo)

set_plot, 'z'
DEVICE,SET_RESOLUTION=[2*Nx, 2*Ny]

openr,u,tmp_histo_file,/get
fs = fstat(u)
     
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)

data = lonarr(Ntof, Nx, Ny)
readu,u,data

close, u
free_lun, u

counts_vs_tof_intermediate=lonarr(Ntof)
counts_vs_tof_intermediate=total(data,2)
counts_vs_tof=counts_vs_tof_intermediate[*,yo]

xtitle= '#time bins'
ytitle= 'Counts'

plot, counts_vs_tof, xtitle=xtitle, ytitle=ytitle

tvimg=TVRD()
set_plot,'ION'
tv,tvimg,0,-1

END
