PRO PLOT_TOFO_SUMX_SUMY, TbinMin, TbinMax, tmp_histo_file, Nx, Ny

TbinMin = Long(TbinMin)
TbinMax = Long(TbinMax)
Nx = Long(Nx)
Ny = Long(Ny)

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

counts_vs_tof_inter1 = data(TbinMin:TbinMax,*,*)
counts_vs_tof_inter2 = total(counts_vs_tof_inter1,2)
counts_vs_tof = lonarr(Ntof)
counts_vs_tof = total(counts_vs_tof_inter2,2)

xtitle= '#time bins'
ytitle= 'Counts'

plot, counts_vs_tof, xtitle=xtitle, ytitle=ytitle

tvimg=TVRD()
set_plot,'ION'
tv,tvimg,0,-1

END
