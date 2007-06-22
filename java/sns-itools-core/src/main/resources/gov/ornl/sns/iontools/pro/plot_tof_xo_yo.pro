PRO PLOT_TOF_XO_YO, tof_min, tof_max, tofo, xo, yo, tmp_histo_file, Nx, Ny

Nx = Long(Nx)
Ny = Long(Ny)
xo = Long(xo)
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

if (tofo EQ 0) then begin

   counts_vs_tof = data[*,xo,yo]
   help, counts_vs_tof

endif else begin

    tof_min = Long(tof_min)
    tof_max = Long(tof_max)
    counts_vs_tof= data[tof_min:tof_max,xo,yo]
    
endelse
   
xtitle= '#time bins'
ytitle= 'Counts'

plot, counts_vs_tof, xtitle=xtitle, ytitle=ytitle

tvimg=TVRD()
set_plot,'ION'
tv,tvimg,0,-1

END
