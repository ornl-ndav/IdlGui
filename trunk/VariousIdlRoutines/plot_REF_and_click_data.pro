transpose_ok = 1

;****************************************************************
;******** HISTOGRAMMING API FOR IDL *****************************
;******** version with axis on the plot  ************************
;****************************************************************

;;**** pickup dialog box******************************************
; file = dialog_pickfile(/must_exist, $
; title='Select a binary file', $
; filter = ['*.dat'],$
; path='/Users/j35/CD4/DAS/REF/',$
; get_path = path)
;;****************************************************************

file = "/Users/j35/CD4/DAS/REF/DAS_60_neutron_histo.dat"
openr,1,file
fs = fstat(1)
N=fs.size        ;size of file

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data
data = swap_endian(data)    ;swap endian because PC -> Mac
close,1			    ;close file

;################################
Nx = 256L  	;information from xxx_runnumber_runinfo.xml
Ny = 304L
;Nt = 834L
Nt=84
;#################################

;find the non-null elements
indx1 = where(data GT 0, Ngt50)
img = lonarr(Nt,Nx,Ny)

img(indx1) = data(indx1)
simg = total(img,1)     ;sum over time bins
simg[0]=0
if transpose_ok EQ 1 then begin
	simg=transpose(simg)
endif

;format of graph
if transpose_ok EQ 1 then begin
	xtitle = "pixel y"
	ytitle = "pixel x"
endif else begin
	xtitle="pixel x"
	ytitle="pixel y"
endelse

title=""

window,1,xsize=500,ysize=400,xpos=50,ypos=250

;***************color*************

do_color = 1

if do_color EQ 1 then begin

	;Decomposed=0 causes the least-significant 8 bits of the color index value
	;to be interpreted as a PseudoColor index.
	DEVICE, DECOMPOSED = 0

	;pick your favorite color table...see xloadct
	loadct,5

endif

;*********end of color part***********************
xoff=110
yoff=90

if transpose_ok EQ 1 then begin

	tvscl,simg,xoff,yoff,/device,xsize=Ny,ysize=Nx              ;plot data

	;******pretty plot********************************

	plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],ystyle=1,xstyle=1, $
   		pos=[xoff,yoff,xoff+Ny, yoff+Nx],$
		  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
		  charthick=1.6

endif else begin

	tvscl,simg,xoff,yoff,/device,xsize=Nx,ysize=Ny              ;plot data

	;******pretty plot********************************

	plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],ystyle=1,xstyle=1, $
   		pos=[xoff,yoff,xoff+Nx, yoff+Ny],$
		  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
		  charthick=1.6

endelse

wshow

;**interactivity with graph************************

do_coords = 1

if do_coords EQ 1 then begin
;case to get the mouse click, return the (x,y) coordinates and the value
getvals = 1	;while getvals is GT 0, continue to check mouse down clicks

print,'Left click within the image to return (x,y) and f(x,y)'
print,'Right click, or click within the window, but outside the image to terminate check'

;continue to loop getting values while mouse clicks occur within the image window

x = lonarr(2)
y = lonarr(2)

for i=0,1 do begin

cursor,a,b,/down,/device

x[i] = a-xoff
y[i] = b-yoff

if transpose_ok EQ 1 then begin

	if ((x[i] LT 0) OR (x[i] GT Ny) OR (y[i] LT 0) OR (y[i] GT Nx) OR (!mouse.button EQ 4)) then begin
		getvals = 0
		print,'Terminating return data'
;	endif else begin
;		print, 'pixelID#:'+strcompress(y[i]*304+x[i])+'  (x['+strcompress(i,/rem)+'] = '+strcompress(y[i],/rem)+'; y['+strcompress(i,/rem)+']= '+strcompress(x[i],/rem)+'; val = '+strcompress(simg[y[i],x[i]],/rem)+')'
;	endelse
	endif

endif else begin

	if ((x[i] LT 0) OR (x[i] GT Nx) OR (y[i] LT 0) OR (y[i] GT Ny) OR (!mouse.button EQ 4)) then begin
		getvals = 0
		print,'Terminating return data'
;	endif else begin
;		print, 'pixelID#:'+strcompress(x[i]*304+y[i])+'  (x['+strcompress(i,/rem)+'] = '+strcompress(x[i],/rem)+'; y['+strcompress(i,/rem)+']= '+strcompress(y[i],/rem)+'; val = '+strcompress(simg[x[i],y[i]],/rem)+')'
;	endelse
	endif

endelse

endfor

endif

r=255L  ;red max
g=0L    ;no green
b=255L  ;blue max

x_plot = lonarr(2)
y_plot = lonarr(2)

for i=0,1 do begin
	x_plot[i]=x[i]+xoff
	y_plot[i]=y[i]+yoff
endfor

plots, x_plot[0], y_plot[0], /device, color=800
plots, x_plot[0], y_plot[1], /device, /continue, color=r+(g*256L)+(b*256L^2)
plots, x_plot[1], y_plot[1], /device, /continue, color=r+(g*256L)+(b*256L^2)
plots, x_plot[1], y_plot[0], /device, /continue, color=r+(g*256L)+(b*256L^2)
plots, x_plot[0], y_plot[0], /device, /continue, color=r+(g*256L)+(b*256L^2)

;***************

;**Create the main window
title = "Information about the surface selected"
tlb = widget_base(column=1,$
		  mbar=mbar,$
	          title=title,$
		  tlb_frame_attr=1,$
	          xsize=400,$ 
	          ysize=220,$
		  xoffset=500,$  ;offset relative to left border
		  yoffset=200)   ;offset relative to top border

;**Create the labels that will receive the information from the pixelID selected
; *Initialization of text boxes
pixel_label = 'The two corners are defined by:'

y_min = min(y)
y_max = max(y)
x_min = min(x)
x_max = max(x)

y12 = y_max-y_min
x12 = x_max-x_min
total_pixel_inside = x12*y12
total_pixel_outside = Nx*Ny - total_pixel_inside

if transpose_ok EQ 1 then begin

	first_point = '  pixelID#: '+strcompress(y_min*304+x_min)+' (x= '+strcompress(y_min,/rem)+'; y= '+strcompress(x_min,/rem)+'; intensity= '+strcompress(simg[x_min,y_min],/rem)+')'
	second_point = '  pixelID#: '+strcompress(y_max*304+x_max)+' (x= '+strcompress(y_max,/rem)+'; y= '+strcompress(x_max,/rem)+'; intensity= '+strcompress(simg[x_max,y_max],/rem)+')'

	;calculation of inside region total counts
	inside_total = total(simg(x_min:x_max, y_min:y_max))
	outside_total = total(simg)-inside_total
	inside_average = inside_total/total_pixel_inside
	outside_average = outside_total/total_pixel_outside
		
endif else begin
	
	first_point = '  pixelID#: '+strcompress(x_min*304+y_min)+' (x= '+strcompress(x_min,/rem)+'; y= '+strcompress(y_min,/rem)+'; intensity= '+strcompress(simg[y_min,x_min],/rem)+')'
	second_point = '  pixelID#: '+strcompress(x_max*304+y_max)+' (x= '+strcompress(x_max,/rem)+'; y= '+strcompress(y_max,/rem)+'; intensity= '+strcompress(simg[y_max,x_max],/rem)+')'

	;calculation of inside region total counts
	inside_total = total(simg(y_min:y_max, x_min:x_max))
	outside_total = total(simg)-inside_total
	inside_average = inside_total/total_pixel_inside
	outside_average = outside_total/total_pixel_outside

endelse

blank_line = ""
selection_label= 'The characteristics of the selection are: '
number_pixelID = "  Number of pixelIDs inside the surface: "+strcompress(x12*y12,/rem)
x_wide = '  Selection is '+strcompress(x12,/rem)+' pixels wide in the x direction'
y_wide = '  Selection is '+strcompress(y12,/rem)+' pixels wide in the y direction'

total_counts = 'Total counts:'
total_inside_region = ' Inside region : ' +strcompress(inside_total,/rem)
total_outside_region = ' Outside region : ' +strcompress(outside_total,/rem)
average_counts = 'Average counts:'
average_inside_region = ' Inside region : ' +strcompress(inside_average,/rem)
average_outside_region = ' Outside region : ' +strcompress(outside_average,/rem) 

value_group = [pixel_label,first_point, second_point, blank_line, selection_label, number_pixelid,$
	 x_wide, y_wide, blank_line,total_counts, total_inside_region, total_outside_region,$
	average_counts, average_inside_region, average_outside_region]
text = widget_text(tlb, value=value_group, ysize=15)

widget_control, tlb, /realize

end
