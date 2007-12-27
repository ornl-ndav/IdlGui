transpose_ok = 1      ; 0 for a histo_mapped file, 1 for a histo file
debug = 0	      ; to display debug statements
swap_endian_ok = 0    ; to swap or not endian

Nx=256L
Ny=304L
Nt=84L

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

file = "/SNS/users/j35/preNeXus/DAS/DAS_60_neutron_histo.dat"
openr,1,file
fs = fstat(1)
N=fs.size        ;size of file

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data

if (swap_endian_ok EQ 1) then data = swap_endian(data) 

close,1			    ;close file

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

title = "Interactive part"
help_window = widget_base(column=1,$
			  mbar=mbar,$
	        	  title=title,$
			  tlb_frame_attr=1,$
		          xsize=400,$ 
	        	  ysize=80,$
			  xoffset=500,$  ;offset relative to left border
			  yoffset=100)   ;offset relative to top border

;**Create the labels that will receive the information from the pixelID selected
; *Initialization of text boxes
help_menu_1 = 'To select the area of interest, left click the first '
help_menu_2 = 'corner of the zone then set the selection by left'
help_menu_3 = 'clicking the other corner up to its final position,'
help_menu_4 = 'and then right click to finish up the selection.'

value_group = [help_menu_1, help_menu_2, help_menu_3, help_menu_4]
text = widget_text(help_window, value=value_group, ysize=4)

widget_control, help_window, /realize


;**interactivity with graph************************

do_coords = 1

if do_coords EQ 1 then begin
;case to get the mouse click, return the (x,y) coordinates and the value
getvals = 0	;while getvals is GT 0, continue to check mouse down clicks

;continue to loop getting values while mouse clicks occur within the image window

x = lonarr(2)
y = lonarr(2)

first_round=0
r=255L  ;red max
g=0L    ;no green
b=255L  ;blue max

while (getvals EQ 0) do begin

	cursor,x,y,/down,/device
	if ((x-xoff LT 0) OR (x-xoff GT Ny) OR (y-yoff LT 0) or (y-yoff GT Nx) or (!mouse.button EQ 4)) then begin
		getvals = 1
	endif else begin
		if (first_round EQ 0) then begin
			X1=x
			Y1=y
			first_round = 1
			if (debug EQ 1) then begin
				print, "**** First point ****"
				print, "X1= ", X1
				print, "Y1= ", Y1
			endif
		endif else begin
			X2=x
			Y2=y
			if (debug EQ 1) then begin
				print, "**** Second point ****"
				print, "X2= ", X2
				print, "Y2= ", Y2
			endif
		
			if (transpose_ok EQ 1) then begin

				tvscl,simg,xoff,yoff,/device,xsize=Ny,ysize=Nx              
				plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],$
				  ystyle=1,xstyle=1,pos=[xoff,yoff,xoff+Ny, yoff+Nx],$
				  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
				  charthick=1.6

			endif else begin
		
				tvscl, simg, xoff, yoff,/device,xsize=Nx,ysize=Ny
				plot, [0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],$
  				  ystyle=1,xstyle=1,pos=[xoff,yoff,xoff+Nx,yoff+Ny],$
				  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
				  charthick=1.6

			endelse
 	
			plots, X1, Y1, /device, color=800
			plots, X1, Y2, /device, /continue, color=r+(g*256L)+(b*256L^2)
			plots, X2, Y2, /device, /continue, color=r+(g*256L)+(b*256L^2)
			plots, X2, Y1, /device, /continue, color=r+(g*256L)+(b*256L^2)
			plots, X1, Y1, /device, /continue, color=r+(g*256L)+(b*256L^2)
	
		endelse
	endelse

endwhile

endif

widget_control, help_window, /destroy


x=lonarr(2)
y=lonarr(2)

x[0]=X1-xoff
x[1]=X2-xoff
y[0]=Y1-yoff
y[1]=Y2-yoff

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

blank_line = ""

if transpose_ok EQ 1 then begin

	first_point = '  pixelID#: '+strcompress(y_min*304+x_min)+' (x= '+strcompress(y_min,/rem)+'; y= '+strcompress(x_min,/rem)+'; intensity= '+strcompress(simg[x_min,y_min],/rem)+')'
	second_point = '  pixelID#: '+strcompress(y_max*304+x_max)+' (x= '+strcompress(y_max,/rem)+'; y= '+strcompress(x_max,/rem)+'; intensity= '+strcompress(simg[x_max,y_max],/rem)+')'

	;calculation of inside region total counts
	inside_total = total(simg(x_min:x_max, y_min:y_max))
	outside_total = total(simg)-inside_total
	inside_average = inside_total/total_pixel_inside
	outside_average = outside_total/total_pixel_outside
	selection_label= 'The characteristics of the selection are: '
	number_pixelID = "  Number of pixelIDs inside the surface: "+strcompress(x12*y12,/rem)
	y_wide = '  Selection is '+strcompress(y12,/rem)+' pixels wide in the x direction'
	x_wide = '  Selection is '+strcompress(x12,/rem)+' pixels wide in the y direction'
		
endif else begin
	
	first_point = '  pixelID#: '+strcompress(x_min*304+y_min)+' (x= '+strcompress(x_min,/rem)+'; y= '+strcompress(y_min,/rem)+'; intensity= '+strcompress(simg[y_min,x_min],/rem)+')'
	second_point = '  pixelID#: '+strcompress(x_max*304+y_max)+' (x= '+strcompress(x_max,/rem)+'; y= '+strcompress(y_max,/rem)+'; intensity= '+strcompress(simg[y_max,x_max],/rem)+')'

	;calculation of inside region total counts
	inside_total = total(simg(y_min:y_max, x_min:x_max))
	outside_total = total(simg)-inside_total
	inside_average = inside_total/total_pixel_inside
	outside_average = outside_total/total_pixel_outside
	selection_label= 'The characteristics of the selection are: '
	number_pixelID = "  Number of pixelIDs inside the surface: "+strcompress(x12*y12,/rem)
	x_wide = '  Selection is '+strcompress(x12,/rem)+' pixels wide in the x direction'
	y_wide = '  Selection is '+strcompress(y12,/rem)+' pixels wide in the y direction'

endelse


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
