function get_tlb,wWidget

id = wWidget
cntr = 0
while id NE 0 do begin

	tlb = id
	id = widget_info(id,/parent)
	cntr = cntr + 1
	if cntr GT 10 then begin
		print,'Top Level Base not found...'
		tlb = -1
	endif
endwhile

return,tlb

end



pro plot_data_eventcb
end


pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0








end




pro OPEN_HISTOGRAM, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).filter_histo = '*_histo.dat'
OPEN_FILE, Event

end



pro OPEN_MAPPED_HISTOGRAM, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).filter_histo = '*_histo_mapped.dat'
OPEN_FILE, Event

end



pro OPEN_FILE, Event

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

spawn, "pwd",listening

if ((*global).path EQ '') then begin
   path = listening
endif else begin
   path = (*global).path
endelse

file = dialog_pickfile(/must_exist,$
	title="Select a histogram file for BSS",$
	filter= (*global).filter_histo,$
	path = path,$
	get_path = path)

;check if there is really a file
if (file NE '') then begin

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')

if (path NE '') then begin
   (*global).path = path
   text = "file openned:" 
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = file
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endif else begin

   text = "No file openned"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

text = " Opening/Reading file.......... "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

openr,1,file
fs=fstat(1)

;to get the size of the file
file_size=fs.size

text = "Infos about file" 
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "  Size of file : " + strcompress(file_size,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

Nbytes = (*global).nbytes
N = long(file_size) / Nbytes  ;number of elements

text = "  Nbre of elements : " + strcompress(N,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

data = lonarr(N)
readu,1,data

if ((*global).swap_endian EQ 1) then begin

   data=swap_endian(data)
   text = "true"

endif else begin

   text = "false"

endelse

text1 = "  Swap endian : " + text
WIDGET_CONTROL, view_info, SET_VALUE=text1, /APPEND

close,1

Nx=(*global).Nx
Ny=(*global).Ny
Nt = long(N)/(long(Nx*Ny))

text = "  Nt : " + strcompress(Nt,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;find the non-null elements
indx1 = where(data GT 0, Ngt0)
text = "  Number of non-null elements : " + strcompress(Ngt0,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

img = intarr(Nt,Nx,Ny)
img(indx1)=data(indx1)
simg=total(img,1)	;sum over time bins

top_bank = simg(0:63,0:63)
bottom_bank = simg(0:63,64:127)

top_bank = transpose(top_bank)
bottom_bank = transpose(bottom_bank)

xtitle = (*global).xtitle
ytitle = (*global).ytitle
title = file

if ((*global).do_color EQ 1) then begin
   
   DEVICE, DECOMPOSED=0
   loadct, 2

endif

Ny_pixels = (*global).Ny_pixels
Nx_tubes = (*global).Nx_tubes

x_coeff = 12.5
y_coeff = 3.9

New_Ny = y_coeff*Ny_pixels
New_Nx = x_coeff*Nx_tubes
xoff = 10
yoff = 10

;top bank
view_info = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_TOP_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

tvimg = congrid(top_bank, New_Nx, New_Ny, /interp)
tvscl, tvimg, /device

;plot grid
for i=1,63 do begin
  plots, i*x_coeff, 0, /device, color=300
  plots, i*x_coeff, 64*y_coeff, /device, /continue, color=300

  plots, 0,i*x_coeff, /device,color=300
  plots, 64*x_coeff, i*x_coeff, /device, /continue, color=300
endfor

;bottom bank
view_info = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_BOTTOM_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

tvimg = congrid(bottom_bank, New_Nx, New_Ny, /interp)
tvscl, tvimg, /device

;plot grid
for i=1,63 do begin
  plots, i*x_coeff, 0, /device, color=300
  plots, i*x_coeff, 64*y_coeff, /device, /continue, color=300

  plots, 0,i*x_coeff, /device,color=300
  plots, 64*x_coeff, i*x_coeff, /device, /continue, color=300
endfor

;plot scales
;tubes axis
view_info = widget_info(Event.top,FIND_BY_UNAME='X_SCALE')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

TvLCT, [70,255,0],[70,255,255],[70,0,0],1
plot, [0,Nx_tubes],/nodata,/device,xrange=[0,Nx_tubes],$
	xstyle=1+8, ystyle=4, /noerase, charsize=1.0, charthick=1.6,$
	xmargin=[1,1], xticks=8, xtitle=xtitle, color=2,$
	xTickLen=.5, XGridStyle=2, xminor=7, xtickinterval=4

;top pixels axis
view_info = widget_info(Event.top,FIND_BY_UNAME='Y_SCALE_TOP_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

TvLCT, [70,255,0],[70,255,255],[70,0,0],1
plot, [0,Ny_pixels],/nodata,/device,yrange=[0,Ny_pixels],$
	ystyle=1+8, xstyle=4, /noerase, charsize=1.0, charthick=1.6,$
	ymargin=[1,1], yticks=8, color=2,$
	yTickLen=-.1, YGridStyle=2, Yminor=7, Ytickinterval=4


;bottom pixels axis
view_info = widget_info(Event.top,FIND_BY_UNAME='Y_SCALE_BOTTOM_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

TvLCT, [70,255,0],[70,255,255],[70,0,0],1
plot, [0,Ny_pixels],/nodata,/device,yrange=[0,Ny_pixels],$
	ystyle=1+8, xstyle=4, /noerase, charsize=1.0, charthick=1.6,$
	ymargin=[1,1], yticks=8, color=2,$
	yTickLen=-.1, YGridStyle=2, Yminor=7, Ytickinterval=4


view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = " ....Plotting COMPLETED "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

 
endif else begin

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = " No new file loaded "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

;turn off hourglass
widget_control,hourglass=0

end




pro ABOUT_MENU, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "" 
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "**** plotBSS ****"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = ""
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Developers:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Steve Miller (millersd@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Peter Peterson (petersonpf@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Michael Reuter (reuterma@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Jean Bilheux (bilheuxjm@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end



pro EXIT_PROGRAM, Event

widget_control,Event.top,/destroy

end















