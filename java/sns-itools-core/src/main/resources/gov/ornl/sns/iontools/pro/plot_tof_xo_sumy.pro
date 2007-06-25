PRO PLOT_TOF_XO_SUMY, tof_min, tof_max, tofo, xo, tmp_histo_file, Nx, Ny

Nx = Long(Nx)
Ny = Long(Ny)
xo = Long(xo)

Narray = [Nx,Ny]
Nmin = min(Narray,max=Nmax)

set_plot, 'z'
DEVICE,SET_RESOLUTION=[2*Nmin, 2*Nmax]

openr,u,tmp_histo_file,/get
fs = fstat(u)
     
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)

data = lonarr(Ntof, Nx, Ny)
readu,u,data

close, u
free_lun, u

counts_vs_tof_intermediate=lonarr(Ntof)
counts_vs_tof_intermediate=total(data,3)

if (tofo EQ 0) then begin

   counts_vs_tof= counts_vs_tof_intermediate[*,xo]

endif else begin

    tof_min = Long(tof_min)
    tof_max = Long(tof_max)
    counts_vs_tof= counts_vs_tof_intermediate[tof_min:tof_max,xo]
    
endelse
   
xtitle= '#time bins'
ytitle= 'Counts'

plot, counts_vs_tof, xtitle=xtitle, ytitle=ytitle

tvimg=TVRD()
set_plot,'ION'
tv,tvimg,0,-1

END
