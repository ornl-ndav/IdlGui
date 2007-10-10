PRO PLOT_TOF_SELECTION, xaxis, $
                        tof_min, $
                        tof_max, $
                        tofo, $
                        xmin, $
                        xmax, $
                        ymin, $
                        ymax, $
                        tmp_histo_file, $
                        Nx, $
                        Ny

xaxis = Long(xaxis)
xmin = Long(xmin)
xmax = Long(xmax)
ymin = Long(ymin)
ymax = Long(ymax)
Nx = Long(Nx)
Ny = Long(Ny)

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

if (tofo EQ 0) then begin

    counts_vs_tof_inter1 = data(*,xmin:xmax, ymin:ymax)

endif else begin

    tof_min = Long(tof_min)
    tof_max = Long(tof_max)
    counts_vs_tof_inter1 = data(tof_min:tof_max,xmin:xmax, ymin:ymax)

endelse

if (xaxis EQ 0) then begin ;TOF

    counts_vs_tof_inter2 = total(counts_vs_tof_inter1,2)
    counts_vs_tof = total(counts_vs_tof_inter2,2)
    xtitle= '#time bins'

endif else begin

    if (xaxis EQ 1) then begin ;X

            counts_vs_tof_inter2 = total(counts_vs_tof_inter1,1)
            counts_vs_tof = total(counts_vs_tof_inter2,2)
            xtitle = 'X pixels'

    endif else begin ;Y

            counts_vs_tof_inter2 = total(counts_vs_tof_inter1,1)
            counts_vs_tof = total(counts_vs_tof_inter2,1)
            xtitle = 'Y pixels'

    endelse

endelse

ytitle= 'Counts'

plot, counts_vs_tof, xtitle=xtitle, ytitle=ytitle

tvimg=TVRD()
set_plot,'ION'
tv,tvimg,0,-1


END
