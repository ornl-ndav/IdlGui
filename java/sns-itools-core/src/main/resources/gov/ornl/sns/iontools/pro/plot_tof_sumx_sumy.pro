PRO PLOT_TOF_SUMX_SUMY, tmp_histo_file, Nx, Ny

Nx = Long(Nx)
Ny = Long(Ny)

set_plot, 'z'
DEVICE,SET_RESOLUTION=[2*Nx, 2*Ny]

openr,u,tmp_histo_file,/get
fs = fstat(u)
     
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)

data_assoc = assoc(u,lonarr(Ntof, Nx))

counts_vs_tof=lonarr(Ntof)
for i=0L, (Ny-1) do begin
    counts_vs_tof += total(data_assoc[i],2)
endfor

close, u
free_lun, u

xtitle= '#time bins'
ytitle= 'Counts'

plot, counts_vs_tof, xtitle=xtitle, ytitle=ytitle

tvimg=TVRD()
set_plot,'ION'
tv,tvimg,0,-1

end
