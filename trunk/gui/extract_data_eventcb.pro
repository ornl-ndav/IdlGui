; \brief function that parse the input file name and produced the output file name
; if the output file name exists already, an increment index is added at the end of the 
; name, just before the extension ".txt"
;
; \argument file_name (INPUT) the name of the input file
; \argument file_index (INPUT) the index of the last input file created
FUNCTION GetRegionFile, file_name, file_index
	file_name = strsplit(file_name,'.dat',/extract,/regex,count=length)     ;to remove the '.dat' part of the name
	file_name = file_name + '_' + strcompress(file_index,/rem) + '.txt'     ;replaced by _#.txt
	++file_index
	return, file_name
end

; \brief function to obtain the top level base widget given an arbitrary widget ID.
;
; \argument wWidget (INPUT)
;
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
;end of get_tlb

; \brief Empty stub procedure used for autoloading.
;
pro extract_data_eventcb
end
; end of extract_data


; \brief main function that plot the window
;
; \argument wWidget (INPUT) 
;
pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
; end of MAIN_REALIZE


; \brief procedure to image the data
;
; \argument event (INPUT)
;
pro SHOW_DATA,event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global


	;get window numbers
	view_id = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW')
	WIDGET_CONTROL, view_id, GET_VALUE = view_win_num

	;Decomposed=0 causes the least-significant 8 bits of the color index value
	;to be interpreted as a PseudoColor index.
	DEVICE, DECOMPOSED = 0

	if (*global).pass EQ 0 then begin
		;load the default color table on first pass thru SHOW_DATA
		loadct,(*global).ct
		(*global).pass = 1 ;clear the flag...
	endif

	wset,view_win_num
	tvscl,(*(*global).img_ptr)

end
; end of SHOW_DATA


; \brief 
;
; \argument event (INPUT) 
;
pro VIEW_ONBUTTON,event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;left mouse button
IF (event.press EQ 1) then begin

view_info = widget_info(Event.top,FIND_BY_UNAME='MODE_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE="MODE: 1 click"

	;get data
	img = (*(*global).img_ptr)
	data = (*(*global).data_ptr)

	x = Event.x
	y = Event.y

	;set data
	(*global).x = x
	(*global).y = y

	;get window numbers - x
	view_x = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_X')
	WIDGET_CONTROL, view_x, GET_VALUE = view_win_num_x

	;get window numbers - y
	view_y = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_Y')
	WIDGET_CONTROL, view_y, GET_VALUE = view_win_num_y
	
	;do funky stuff since can't figure out how to plot along y axis...
	;plot y in x window
	;read this data into a temporary file
	;then image this plot in the window it belongs in...
	wset,view_win_num_x
	plot,img(x,*),/xstyle,title='Y Axis',XMARGIN=[10,10]
	tmp_img = tvrd()
	tmp_img = reverse(transpose(tmp_img),1)
	wset,view_win_num_y
	tv,tmp_img

	;now plot,x
	wset,view_win_num_x
	plot,img(*,y),/xstyle,title='X Axis'

	;now plot tof
	;get window numbers - tof
	view_tof = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_TOF')
	WIDGET_CONTROL, view_tof, GET_VALUE = view_win_num_tof
	wset,view_win_num_tof
	;remember, img is transposed versus data...not sure this is right yet ************
	plot,reform(data(*,y,x)),title='TOF Axis'

endif

;right mouse button
IF (event.press EQ 4) then begin

view_info = widget_info(Event.top,FIND_BY_UNAME='MODE_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE="MODE: selection"

	;;disable refresh button during ctool
	;rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON')
	;widget_control,rb_id,sensitive=0

	print,'right button press'

	;get window numbers
	view_id = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW')
	WIDGET_CONTROL, view_id, GET_VALUE = view_win_num

;from the rubber_band program

getvals = 0	;while getvals is GT 0, continue to check mouse down clicks

;continue to loop getting values while mouse clicks occur within the image window

view_main=widget_info(Event.top, FIND_BY_UNAME='VIEW_DRAW')
WIDGET_CONTROL, view_main, GET_VALUE = id
wset,id

Nx = (*global).Nx
Ny = (*global).Ny
window_counter = (*global).window_counter

x = lonarr(2)
y = lonarr(2)

first_round=0
r=255L  ;red max
g=0L    ;no green
b=255L  ;blue max

cursor, x,y,/down,/device

if (window_counter GE 1) then begin
;	widget_control, my_tlb, /destroy
endif

display_info =0	
print, "Nx= " , Nx

click_outside = 0
while (getvals EQ 0) do begin

	cursor,x,y,/nowait,/device


	if ((x LT 0) OR (x GT Ny) OR (y LT 0) OR (y GT Nx)) then begin
		click_outside = 1
		getvals = 1
		print,'Terminating return data'
		view_info = widget_info(Event.top,FIND_BY_UNAME='MODE_INFOS')
		WIDGET_CONTROL, view_info, SET_VALUE="MODE: 1 click"

	endif else begin
	
	if (first_round EQ 0) then begin
		X1=x
		Y1=y
		first_round = 1
	endif else begin
		X2=x
		Y2=y
		SHOW_DATA,event
		plots, X1, Y1, /device, color=800
		plots, X1, Y2, /device, /continue, color=r+(g*256L)+(b*256L^2)
		plots, X2, Y2, /device, /continue, color=r+(g*256L)+(b*256L^2)
		plots, X2, Y1, /device, /continue, color=r+(g*256L)+(b*256L^2)
		plots, X1, Y1, /device, /continue, color=r+(g*256L)+(b*256L^2)

		if (!mouse.button EQ 4) then begin    ;stop the process
			getvals = 1
			display_info = 1
		endif
	endelse

	endelse
endwhile

if (click_outside EQ 1) then begin
	;do nothing
endif else begin


if (display_info EQ 1) then begin

x=lonarr(2)
y=lonarr(2)

x[0]=X1
x[1]=X2
y[0]=Y1
y[1]=Y2

print, "x[0]= ", X1
print, "y[0]= " ,Y1
print, "x[1]= ", X2
print, "y[1]= " ,Y2


;**Create the main window
;title = "Information about the surface selected"
;tlb = widget_base(column=1,$
;		  mbar=mbar,$
;	          title=title,$
;		  tlb_frame_attr=1,$
;	          xsize=400,$ 
;	          ysize=220,$
;		  xoffset=800,$  ;offset relative to left border
;		  yoffset=200)   ;offset relative to top border

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

data = (*(*global).data_ptr)
simg = (*(*global).img_ptr)

first_point = '  pixelID#: '+strcompress(y_min*304+x_min)+' (x= '+strcompress(x_min,/rem)+'; y= '+strcompress(y_min,/rem)+'; intensity= '+strcompress(simg[x_min,y_min],/rem)+')'
second_point = '  pixelID#: '+strcompress(y_max*304+x_max)+' (x= '+strcompress(x_max,/rem)+'; y= '+strcompress(y_max,/rem)+'; intensity= '+strcompress(simg[x_max,y_max],/rem)+')'

;calculation of inside region total counts
inside_total = total(simg(x_min:x_max, y_min:y_max))
outside_total = total(simg)-inside_total
inside_average = inside_total/total_pixel_inside
outside_average = outside_total/total_pixel_outside
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

;text = widget_text(, value=value_group, ysize=15)

view_info = widget_info(Event.top,FIND_BY_UNAME='PIXELID_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE=""
WIDGET_CONTROL, view_info, SET_VALUE=value_group, /APPEND

;end of part from the rubber_band program

;	Q = CW_DEFROI(view_id)
;	if Q[0] NE -1 then begin
;	print,'Storing Indicies'
;
;	save_id = widget_info(Event.top,FIND_BY_UNAME='SAVE_BUTTON')
;	WIDGET_CONTROL, save_id, sensitive=1
;
;	;store indicies
;	(*(*global).indicies) = Q
;	(*global).have_indicies = 1
;
;	endif

endif else begin

endelse

rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON')
widget_control,rb_id,sensitive=1

selection = data(*,y_min:y_max,x_min:x_max)  
selection = total(selection,2)
selection = total(selection,2)

view_info = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION')
WIDGET_CONTROL, view_info, GET_VALUE = view_num_info
wset, view_num_info
plot, selection

;enable save button once a selection is done
rb_id=widget_info(Event.top, FIND_BY_UNAME='SAVE_BUTTON')
widget_control,rb_id,sensitive=1

(*(*global).selection_ptr) = selection

endelse ;click_outside
click_outside = 0

endif

;display_info = 0

end

; end of VIEW_ONBUTTON

; \brief
;
; \argument Event INPUT)
pro SAVE_REGION, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

regionfile = GetRegionFile((*global).filename, (*global).filename_index)

path="~/CD4/REF_M/REF_M_7/"   ;need to automatically determine path according to open file location

outfile = dialog_pickfile(file=regionfile,PATH=path,title='Select Output Data File',/write,filter="*.txt")

if outfile NE '' then begin
	
	selection = (*(*global).selection_ptr)

	view_main=widget_info(Event.top, FIND_BY_UNAME='TBIN_TXT')
	WIDGET_CONTROL, view_main, GET_VALUE=id
	tbin = float(id)

	;get region indicies
	indicies = (*(*global).indicies)
	;remember, indicies are of the 2D image in (x,y) - need to convert to 3D indicies
	;to get TOF info...

	Nselection = n_elements(selection)

	if Nselection GT 0 then begin

	data = fltarr(2,Nselection)
	for i=0L, Nselection-1 do begin
		data[0,i]=tbin*i
	endfor
	
	data(1,*)=selection	
		
;		;get data
;		data = (*(*global).data_ptr)
;
;		Nx = (*global).Nx
;		Ny = (*global).Ny
;		Ntof = (*global).Ntof
;
;		;will need to figure out how to format output data as it is required to be
;		;just giving it a start for now... ***********************
;		tmpdata = lonarr(Nindicies,Ntof)
;		for i=0L,Nindicies-1 do begin
;			x = indicies[i] MOD Ny
;			y = indicies[i] / Ny
;
;			tmpdata[i,*] = data[*,y,x]
;		endfor
		
		openw,u,outfile,/get_lun
		printf,u,data
		close,u
		free_lun,u

	endif;Nselection

endif

end
; end of SAVE_REGION




; \brief 
;
; \argument Event (INPUT)
pro CTOOL, Event

	;disable refresh button during ctool
	rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON')
	widget_control,rb_id,sensitive=0

	;get global structure
	id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
	widget_control,id,get_uvalue=global

	xloadct,/MODAL,GROUP=id

	SHOW_DATA,event

	;turn refresh button back on
	widget_control,rb_id,sensitive=1
end
;end of CTOOL

;\brief 
;
; \argument Event (INPUT) 
PRO REFRESH, Event
;refresh image plot

	SHOW_DATA,event
	
	;remove data from info text box
	view_info = widget_info(Event.top,FIND_BY_UNAME='PIXELID_INFOS')
	WIDGET_CONTROL, view_info, SET_VALUE=""

	;remove counts vs tof plot
	view_infof = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION')
	WIDGET_CONTROL, view_info, GET_VALUE=id
	wset, id
	ERASE

end
; end of REPRESH

; \brief
;
; \argument Event (INPUT)
pro EXIT_PROGRAM, Event

widget_control,Event.top,/destroy

end
; end of EXIT_PROGRAM


; \brief
;
; \argument Event (INPUT)
pro OPEN_FILE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global


;retrieve data parameters
Nx 		= (*global).Nx
Ny 		= (*global).Ny
Ntof 	= (*global).Ntof
filter = (*global).filter

;indicate reading data with hourglass icon
widget_control,/hourglass

;open file

path="/users/j35/CD4/REF_M/REF_M_7/"
file = dialog_pickfile(path=path,get_path=path,title='Select Data File',filter=filter)


;only read data if valid file given
if file NE '' then begin

	(*global).filename = file ; store input filename

	print,'Reading in data  ',systime(0)

	openr,u,file,/get
	;find out file info
	fs = fstat(u)
	Ntof = fs.size/(Ny*Nx*4L)
	(*global).Ntof = Ntof	;set back in global structure
	data = lonarr(Ntof,Nx,Ny)
	readu,u,data

	;data = swap_endian(data)

;	img=total(data,1)
	img = transpose(total(data,1))

	;load data up in global ptr array
	(*(*global).data_ptr) = data
	(*(*global).img_ptr) = img

	close,u
	free_lun,u


	;now turn hourglass back off
	widget_control,hourglass=0

	;put image data in main draw window
	SHOW_DATA,event
	
	;now we can activate 'Refresh' button
	;disable refresh button during ctool
	rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON')
	widget_control,rb_id,sensitive=1


	print,'Complete  ',systime(0)

endif;valid file


end
; end of OPEN_FILE
