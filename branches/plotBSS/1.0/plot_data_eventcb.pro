FUNCTION find_full_nexus_name, Event, run_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -iBSS" + " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name

;check if nexus exists
result = strmatch(full_nexus_name[0],"ERROR*")

if (result GE 1) then begin
    find_nexus = 0
endif else begin
    find_nexus = 1
endelse

(*global).find_nexus = find_nexus

return, full_nexus_name[0]

end




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

(*global).file = file
(*global).file_open = 'histo'
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

  PLOT_HISTO_FILE, Event

endif else begin

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = " No new file loaded "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

;turn off hourglass
widget_control,hourglass=0

end


;------------------------------------------------------------------------
pro PLOT_HISTO_FILE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).refresh_histo EQ 0) then begin

  file = (*global).file 

  view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
  text = " Opening/Reading file.......... "
  WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
  text = file
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

  (*global).Nt = Nt

  ;update Tbin_interaction
  max_tbin_slider_id = widget_info(Event.top,FIND_BY_UNAME='MAX_TBIN_SLIDER')
  min_tbin_slider_id = widget_info(Event.top,FIND_BY_UNAME='MIN_TBIN_SLIDER')
  max_tbin_text_id = widget_info(Event.top,FIND_BY_UNAME='MAX_TBIN_TEXT')
  widget_control, max_tbin_slider_id, SET_SLIDER_MAX=Nt-1
  widget_control, max_tbin_slider_id, SET_VALUE=Nt-1
  widget_control, min_tbin_slider_id, SET_SLIDER_MAX=Nt-1
  widget_control, max_tbin_text_id, SET_VALUE=strcompress(Nt-1,/remove_all)

  text = "  Nt : " + strcompress(Nt,/remove_all)
  WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

  ;find the non-null elements
  indx1 = where(data GT 0, Ngt0)
  text = "  Number of non-null elements : " + strcompress(Ngt0,/remove_all)
  WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;  img = intarr(Nt,Nx,Ny)
  img = lonarr(Nt, Nx, Ny)
  img(indx1)=data(indx1)
  (*(*global).img) = img 
	
  simg = total(img,1) 	;sum over time bins

  tbin_frame_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='tbin_frame')
  WIDGET_CONTROL, tbin_frame_id, sensitive=1

endif else begin

   img = (*(*global).img)
	
   ;get value of min_tbin and max_tbin
   min_tbin = long((*global).min_tbin)   
   max_tbin = long((*global).max_tbin)
   Nx = (*global).Nx
   Ny = (*global).Ny
     
   new_Nt = max_tbin - min_tbin

   if (new_Nt EQ 0) then begin
       new_Nt = 1
   endif   
   
   new_img = intarr(new_Nt+1,Nx,Ny)
   new_img = img(min_tbin:max_tbin,*,*)
   simg = total(new_img,1)

   tbin_refresh_button_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='TBIN_REFRESH_BUTTON')
   WIDGET_CONTROL, tbin_refresh_button_id, sensitive=0

endelse

top_bank = simg(0:63,0:63)
bottom_bank = simg(0:63,64:127)

(*(*global).top_bank) = top_bank
(*(*global).bottom_bank) = bottom_bank

top_bank = transpose(top_bank)
bottom_bank = transpose(bottom_bank)

xtitle = (*global).xtitle
ytitle = (*global).ytitle
title = (*global).file

if ((*global).do_color EQ 1) then begin
   
   DEVICE, DECOMPOSED=0
   loadct, 2

endif

Ny_pixels = (*global).Ny_pixels
Nx_tubes = (*global).Nx_tubes

x_coeff = 12
(*global).x_coeff = x_coeff
y_coeff = 4
(*global).y_coeff = y_coeff

New_Ny = y_coeff*Ny_pixels
New_Nx = x_coeff*Nx_tubes
xoff = 10
yoff = 10

;top bank
view_info = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_TOP_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

;tvimg = congrid(top_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(top_bank, New_Nx, New_Ny,/sample)
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

;tvimg = congrid(bottom_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(bottom_bank, New_Nx, New_Ny,/sample) 
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
plot, [0,Nx_tubes],/nodata,/device,xrange=[0,Nx_tubes-1],$
	xstyle=1+8, ystyle=4, /noerase, charsize=1.0, charthick=1.6,$
	xmargin=[1,3], xticks=8, xtitle=xtitle, color=2,$
	xTickLen=.5, XGridStyle=2, xminor=7, xtickinterval=4

;top pixels axis
view_info = widget_info(Event.top,FIND_BY_UNAME='Y_SCALE_TOP_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

TvLCT, [70,255,0],[70,255,255],[70,0,0],1
plot, [0,Ny_pixels-1],/nodata,/device,yrange=[0,Ny_pixels-1],$
	ystyle=1+8, xstyle=4, charsize=0.8, charthick=1.3,$
	ymargin=[0,0], yticks=8, color=2,$
	yTickLen=-.1, YGridStyle=2, Yminor=7, Ytickinterval=3


;bottom pixels axis
view_info = widget_info(Event.top,FIND_BY_UNAME='Y_SCALE_BOTTOM_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

TvLCT, [70,255,0],[70,255,255],[70,0,0],1
plot, [0,Ny_pixels-1],/nodata,/device,yrange=[0,Ny_pixels-1],$
	ystyle=1+8, xstyle=4, charsize=0.8, charthick=1.3,$
	ymargin=[0,0], yticks=8, color=2,$
	yTickLen=-.1, YGridStyle=2, Yminor=7, Ytickinterval=3

;plot of top scale
view_info = widget_info(Event.top,FIND_BY_UNAME='SCALE_TOP_PLOT')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

max_top = max(top_bank)
cscl = lindgen(20,New_Ny-10)
tvscl,cscl,40,5,/device
plot,[0,20],[0,max_top*y_coeff],/device,pos=[35,5,35,240],/noerase,/nodata,$
	xticks=1,xtickv=1,charsize=0.8

;plot of bottom scale
view_info = widget_info(Event.top,FIND_BY_UNAME='SCALE_BOTTOM_PLOT')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

max_bottom = max(bottom_bank)
cscl = lindgen(20,New_Ny-10)
tvscl,cscl,40,5,/device
plot,[0,20],[0,max_bottom*y_coeff],/device,pos=[35,5,35,240],/noerase,/nodata,$
	xticks=1,xtickv=1,charsize=0.8

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = " ....Plotting COMPLETED "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

(*global).file_already_opened = 1
(*global).refresh_histo = 0
 
end




pro ABOUT_MENU, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "" 
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "**** plotBSS (v.090506)****"
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


;--------------------------------------------------------------------------------
pro EXIT_PROGRAM, Event

widget_control,Event.top,/destroy

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;---------------------------------------------------------------------------------
pro IDENTIFICATION_TEXT_cb, Event  

view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_LEFT')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_RIGHT')
WIDGET_CONTROL, view_id, set_value= ''	

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_path = (*global).default_path

text_id=widget_info(Event.top, FIND_BY_UNAME='IDENTIFICATION_TEXT')
WIDGET_CONTROL, text_id, GET_VALUE=ucams

(*global).ucams = ucams

working_path = default_path + strcompress(ucams,/remove_all)+ '/'
(*global).working_path = working_path

text_id=widget_info(Event.top, FIND_BY_UNAME='DEFAULT_PATH_TEXT')
WIDGET_CONTROL, text_id, SET_VALUE=working_path

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;--------------------------------------------------------------------------------------------
pro IDENTIFICATION_BSS_GO_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

text_id=widget_info(Event.top, FIND_BY_UNAME='IDENTIFICATION_TEXT')
WIDGET_CONTROL, text_id, GET_VALUE=character_id
(*global).character_id = character_id

;check 3 characters id
ucams=(*global).ucams

name = ''
case ucams of
	'ele': name = 'Eugene Mamontov'
        'z3i': name = 'Michaela Zamponi'
	'eg9': name = 'Stephanie Hammons'
	'2zr': name = 'Michael Reuter'
	'pf9': name = 'Peter Peterson'
	'j35': name = 'Zizou'
	'mid': name = 'Steve Miller'
	else : name = ''
endcase

if (name EQ '') then begin

;put a message saying that it's an invalid 3 character id

   error_message = "INVALID UCAMS"
   view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_LEFT')
   WIDGET_CONTROL, view_id, set_value= error_message	
   view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_RIGHT')
   WIDGET_CONTROL, view_id, set_value= error_message	

   view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
   text = "Invalid 3 characters id... please try another user identification id"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   
endif else begin


   cd_works = 0
   catch, cd_works
   if (cd_works NE 0) then begin
   
       catch,/cancel
       error_message = "INVALID UCAMS"
       view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_LEFT')
       WIDGET_CONTROL, view_id, set_value= error_message	
       view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_RIGHT')
       WIDGET_CONTROL, view_id, set_value= error_message	
       
       view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
       text = "Invalid 3 characters id... please try another user identification id"
       WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
       
   endif else begin
       
;working path is set
       (*global).name = name
       working_path = (*global).working_path

       cd, working_path
              
       welcome = "Welcome " + strcompress(name,/remove_all)
       welcome += "  (working directory: " + strcompress(working_path,/remove_all) + ")"	
       view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
       WIDGET_CONTROL, view_id, base_set_title= welcome	
       
       view_id = widget_info(Event.top,FIND_BY_UNAME='IDENTIFICATION_BASE')
       WIDGET_CONTROL, view_id, destroy=1
       
       view_id = widget_info(Event.top,FIND_BY_UNAME='OUTPUT_PATH_NAME')
       WIDGET_CONTROL, view_id, set_value=working_path

       view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
       text = "LOGIN parameters:"
       WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
       text = "User id           : " + ucams
       WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
       text = "Name              : " + name
       WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
       text = "Working directory : " + working_path
       WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
       
                                ;enabled background buttons/draw/text/labels
       list_id = ['OUTPUT_PATH',$
                  'OPEN_NEXUS']
       list_id_size = size(list_id)
       for i=0, (list_id_size[1]-1) do begin
           id = widget_info(Event.top, find_by_uname=list_id[i])
           widget_control, id, sensitive=1
       endfor
       
       if (ucams EQ 'j35') then begin
           list_id=['OPEN_MAPPED_HISTOGRAM',$
                    'OPEN_HISTOGRAM',$
                    'TRANSLATION_FRAME']
           size_list=size(list_id)
           for i=0,(size_list[1]-1) do begin
               id = widget_info(Event.top, find_by_uname=list_id[i])
               widget_control, id, sensitive=1
           endfor
       endif
       
       create_tmp_folder, Event
       
   endelse
   
endelse

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;---------------------------------------------------------------------------
pro OUTPUT_PATH_cb, Event 

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

working_path = (*global).working_path
working_path = dialog_pickfile(path=working_path,/directory)
(*global).working_path = working_path

name = (*global).name

welcome = "Welcome " + strcompress(name,/remove_all)
welcome += "  (working directory: " + $
  strcompress(working_path,/remove_all) + ")"	
view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, view_id, base_set_title= welcome	

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "Working directory set to:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = working_path
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

view_info = widget_info(Event.top,FIND_BY_UNAME="OUTPUT_PATH_NAME")
WIDGET_CONTROL, view_info, set_value=working_path

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;-------------------------------------------------------------------------
pro EVENT_FILE_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

event_file_path= (*global).event_file_path

file = dialog_pickfile(/must_exist,$
	title="Select an event file for BSS",$
	filter= (*global).filter_event,$
	path = event_file_path,$
	get_path = path)

;check if there is really a file
if (file NE '') then begin

(*global).event_filename = file

;isolate only name
view_info = widget_info(Event.top,FIND_BY_UNAME='EVENT_FILENAME')
file_list = strsplit(file,'/',/extract,COUNT=nbr)

(*global).event_filename_only = file_list[nbr-1]

WIDGET_CONTROL, view_info, set_value=file_list[nbr-1]

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "Event file name:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = file
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

id = widget_info(Event.top,FIND_BY_UNAME='EVENT_TO_HISTO')
Widget_Control, id, sensitive=1

endif else begin

   view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
   text = "No file openned"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;--------------------------------------------------------------------------
pro DEFAULT_PATH_BUTTON_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

working_path = (*global).working_path
working_path = dialog_pickfile(path=working_path,/directory)
(*global).working_path = working_path

name = (*global).name

welcome = "Welcome " + strcompress(name,/remove_all)
welcome += "  (working directory: " + strcompress(working_path,/remove_all) + ")"	
view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, view_id, base_set_title= welcome	

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "Working directory set to:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = working_path
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

view_info = widget_info(Event.top,FIND_BY_UNAME='DEFAULT_PATH_TEXT')
text = working_path
WIDGET_CONTROL, view_info, SET_VALUE=text




end
;**************************************************************************************



;--------------------------------------------------------------------------------------
pro EVENT_TO_HISTO_cb, Event

widget_control,hourglass=1

id = widget_info(Event.top,FIND_BY_UNAME='EVENT_TO_HISTO')
Widget_Control, id, sensitive=0

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

output_path = (*global).working_path
event_filename = (*global).event_filename
pixelids = (*global).pixelids

view_info = widget_info(Event.top,FIND_BY_UNAME='TIME_BIN_VALUE')
WIDGET_CONTROL, view_info, GET_VALUE=tbin

view_info = widget_info(Event.top,FIND_BY_UNAME='MAX_TIMEBIN_VALUE')
WIDGET_CONTROL, view_info, GET_VALUE=max_tbin

view_info = widget_info(Event.top,FIND_BY_UNAME='OFFSET_TIMEBIN_VALUE')
WIDGET_CONTROL, view_info, GET_VALUE=min_tbin

cmd = "Event_to_Histo"
cmd += " -p " + strcompress(pixelids,/remove_all)
cmd += " -l " + strcompress(tbin,/remove_all)
cmd += " -M " + strcompress(max_tbin,/remove_all)
cmd += " --time_offset " + strcompress(min_tbin,/remove_all)
cmd += " " + event_filename
cmd += " -a " + output_path

cmd_display = "Histogramming......"
view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_display, /APPEND
cmd_display = "> " + cmd
WIDGET_CONTROL, view_info, SET_VALUE=cmd_display, /APPEND

str_time = systime(1)
text = "Processing....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

spawn, cmd, listening

WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;generate name of histogram file
event_filename_only = (*global).event_filename_only
file_name = strsplit(event_filename_only,"event.dat",/extract,/regex,count=length) 
histogram_filename_only = file_name + "histo.dat"
(*global).histogram_filename_only = histogram_filename_only

histogram_filename = (*global).working_path + histogram_filename_only


nbr_tbin = (long(max_tbin) - long(min_tbin)) / long(tbin)
print, "max_tbin= " , max_tbin
print, "tbin= ", tbin
print, "nbr_tbin= ", nbr_tbin
print, "min_tbin= ", min_tbin

cmd = "Map_Data"
cmd += " -p " + strcompress(pixelids,/remove_all)
cmd += " -t " + strcompress(nbr_tbin,/remove_all)
cmd += " -n " + histogram_filename
cmd += " -m " + (*global).mapping_filename
cmd += " -o " + output_path

cmd_display = "Mapping......"
view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_display, /APPEND
cmd_display = "> " + cmd
WIDGET_CONTROL, view_info, SET_VALUE=cmd_display, /APPEND

str_time = systime(1)
text = "Processing....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

spawn, cmd, listening

WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

histo_mapped_filename = file_name + "histo_mapped.dat"
text = "File generated is"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = histo_mapped_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

(*global).file = (*global).working_path + histo_mapped_filename

PLOT_HISTO_FILE, Event

id = widget_info(Event.top,FIND_BY_UNAME='EVENT_TO_HISTO')
Widget_Control, id, sensitive=1

end





pro VIEW_ONBUTTON_top, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_already_opened = (*global).file_already_opened
Ny = (*global).Ny_pixels

;left mouse button
IF ((event.press EQ 1 ) AND (file_already_opened EQ 1)) then begin

   top_bank = (*(*global).top_bank)

   x = Event.x
   y = Event.y

   x=x/12
   y=y/4
   pixelid= x*(Ny)+y
   counts = top_bank(pixelid)

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "---- TOP BANK ---- "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             tube # : " + strcompress(x,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             pixel #: " + strcompress(y,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             PixelID: " + strcompress(pixelid,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             Counts : " + strcompress(counts,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	
info_overflow_BSS, Event

endif

end


pro VIEW_ONBUTTON_bottom, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_already_opened = (*global).file_already_opened
Ny = (*global).Ny_pixels
pixel_offset = (*global).pixel_offset

;left mouse button
IF ((event.press EQ 1 ) AND (file_already_opened EQ 1)) then begin

   bottom_bank = (*(*global).bottom_bank)

   x = Event.x
   y = Event.y

   x=x/12
   y=y/4
   true_pixelid= x*(Ny)+y + pixel_offset
   pixelid = x*(Ny)+y
   counts = bottom_bank(pixelid)

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "---- BOTTOM BANK ---- "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             tube # : " + strcompress(x,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             pixel #: " + strcompress(y,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             PixelID: " + strcompress(true_pixelid,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "             Counts : " + strcompress(counts,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	
info_overflow_BSS, Event

endif

end



pro info_overflow_BSS, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

overflow_number = (*global).overflow_number

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
WIDGET_CONTROL, view_info, GET_VALUE=text

num_lines = n_elements(text)

if (num_lines gt overflow_number) then begin
	text = text(50:*)
        num_lines = num_lines - 50
	WIDGET_CONTROL, view_info, SET_VALUE=text
endif

end







pro min_tbin_slider, Event

min_tbin_slider_id = widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_SLIDER')
WIDGET_CONTROL, min_tbin_slider_id, GET_VALUE=min_tbin

;to fix minimum value of max tbin slider
max_tbin_slider_id = widget_info(Event.top,FIND_BY_UNAME='MAX_TBIN_SLIDER')
widget_control, max_tbin_slider_id, SET_SLIDER_MIN=min_tbin

min_tbin=strcompress(min_tbin,/remove_all)
min_tbin_text_id=widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_TEXT')
WIDGET_CONTROL, min_tbin_text_id, SET_VALUE=min_tbin

check_validity, Event

end

pro min_tbin_text, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

min_tbin_text_id=widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_TEXT')
WIDGET_CONTROL, min_tbin_text_id, GET_VALUE=min_tbin

Nt = (*global).Nt

if (min_tbin LE Nt) then begin

   min_tbin_slider_id = widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_SLIDER')
   widget_control, min_tbin_slider_id, SET_VALUE=min_tbin

   minimum_of_max_tbin_slider_id = widget_info(Event.top,FIND_BY_UNAME='MAX_TBIN_SLIDER')
   widget_control, minimum_of_max_tbin_slider_id, SET_SLIDER_MIN=min_tbin

endif else begin

   min_tbin_slider_id = widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_SLIDER')
   widget_control, min_tbin_slider_id, SET_VALUE=Nt

   min_tbin_text_id = widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_TEXT')
   widget_control, min_tbin_text_id, SET_VALUE=strcompress(Nt,/remove_all)

endelse   

check_validity, Event

end




pro max_tbin_slider, Event

max_tbin_slider_id = widget_info(Event.top, FIND_BY_UNAME='MAX_TBIN_SLIDER')
WIDGET_CONTROL, max_tbin_slider_id, GET_VALUE=max_tbin

max_tbin=strcompress(max_tbin,/remove_all)
max_tbin_text_id=widget_info(Event.top, FIND_BY_UNAME='MAX_TBIN_TEXT')
WIDGET_CONTROL, max_tbin_text_id, SET_VALUE=max_tbin

check_validity, Event

end





pro max_tbin_text, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

max_tbin_text_id=widget_info(Event.top, FIND_BY_UNAME='MAX_TBIN_TEXT')
WIDGET_CONTROL, max_tbin_text_id, GET_VALUE=max_tbin

Nt=(*global).Nt

if (max_tbin LE Nt) then begin

   max_tbin_slider_id = widget_info(Event.top, FIND_BY_UNAME='MAX_TBIN_SLIDER')
   widget_control, max_tbin_slider_id, SET_VALUE=max_tbin

endif else begin

   max_tbin_slider_id = widget_info(Event.top, FIND_BY_UNAME='MAX_TBIN_SLIDER')
   widget_control, max_tbin_slider_id, SET_VALUE=Nt

   max_tbin_text_id=widget_info(Event.top, FIND_BY_UNAME='MAX_TBIN_TEXT')
   WIDGET_CONTROL, max_tbin_text_id, SET_VALUE=strcompress(Nt,/remove_all)
   
endelse
  
check_validity, Event

end





pro tbin_refresh_button, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

max_tbin_text_id = widget_info(Event.top, FIND_BY_UNAME='MAX_TBIN_TEXT')
widget_control, max_tbin_text_id, GET_VALUE=max_tbin

min_tbin_text_id = widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_TEXT')
widget_control, min_tbin_text_id, GET_VALUE=min_tbin

if (long(min_tbin) GT long(max_tbin)) then begin
   max_tbin = min_tbin
endif

(*global).max_tbin = max_tbin
(*global).min_tbin = min_tbin

;check if we opened an histo or a NeXus file
if ((*global).file_open EQ 'histo') then begin
    PLOT_HISTO_FILE, Event
endif else begin
    PLOT_NEXUS_FILE, Event
endelse

end





pro check_validity, Event

;get global structure
id = widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control, id, get_uvalue=global

min_tbin_slider_id = widget_info(Event.top, FIND_BY_UNAME='MIN_TBIN_SLIDER')
max_tbin_slider_id = widget_info(Event.top,FIND_BY_UNAME='MAX_TBIN_SLIDER')
tbin_refresh_button_id = widget_info(Event.top, FIND_BY_UNAME='TBIN_REFRESH_BUTTON')

WIDGET_CONTROL, min_tbin_slider_id, GET_VALUE=min_tbin_value
WIDGET_CONTROL, max_tbin_slider_id, GET_VALUE=max_tbin_value

if (min_tbin_value GT max_tbin_value) then begin

   WIDGET_CONTROL, tbin_refresh_button_id, sensitive=0

endif else begin

   WIDGET_CONTROL, tbin_refresh_button_id, sensitive=1
   (*global).refresh_histo = 1
   
endelse

end






;========================OPEN NEXUS============================

pro OPEN_NEXUS_INTERFACE, Event

nexus_base_id = widget_info(Event.top, find_by_uname='OPEN_NEXUS_BASE')
widget_control, nexus_base_id, map=1

end


PRO OPEN_RUN_NUMBER, Event

run_number_txt_id = widget_info(Event.top, find_by_uname='OPEN_RUN_NUMBER_TEXT')
widget_control, run_number_txt_id, get_value=run_number

OPEN_NEXUS, Event, run_number

END






pro CANCEL_OPEN_RUN_NUMBER, Event

id_open_nexus_base = widget_info(Event.top, find_by_uname='OPEN_NEXUS_BASE')
widget_control, id_open_nexus_base, map=0

run_number_txt_id = widget_info(Event.top, find_by_uname='OPEN_RUN_NUMBER_TEXT')
widget_control, run_number_txt_id, set_value=""

end










pro OPEN_NEXUS, Event, run_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate initialization with hourglass icon
widget_control,/hourglass

;hide open_nexus interface
open_nexus_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_NEXUS_BASE')
widget_control, open_nexus_id, map=0

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')

if (run_number EQ '') then begin
    
    text = "!!! Please specify a run number !!! " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text,/append
    
endif else begin
    
    (*global).run_number = run_number
    (*global).file_open = 'nexus'

    text = "Opening NeXus file # " + strcompress(run_number,/remove_all) + "....."
    WIDGET_CONTROL, view_info, SET_VALUE=text
    
;get path to nexus run #
    full_nexus_name = find_full_nexus_name(Event, run_number)

;check result of search
    find_nexus = (*global).find_nexus
    if (find_nexus EQ 0) then begin
        text_nexus = "Warning! NeXus file does not exist"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
    endif else begin
        (*global).full_nexus_name = full_nexus_name
        text_nexus = "(" + full_nexus_name + ")"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
        
;dump binary data of NeXus file into tmp_working_path
        create_local_copy_of_histo_mapped, Event
        
;read and plot nexus file
        READ_NEXUS_FILE, Event

    endelse

endelse

;turn off hourglass
widget_control,hourglass=0

end




pro READ_NEXUS_FILE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

run_number = (*global).run_number

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "- Opening and Reading run # " + strcompress(run_number,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;global parameters
Nx = (*global).Nx
Ny_scat = (*global).Ny_scat
Ny_scat_bank = Ny_scat / 2

;opening top part
file_top = (*global).file_to_plot_top
openr,u,file_top,/get

fs=fstat(u)
file_size=fs.size

Nbytes = (*global).nbytes
N = long(file_size) / Nbytes    ;number of elements

Nt = long(N)/(long(Nx*(Ny_scat_bank)))
(*global).Nt = Nt
image_top = ulonarr(Nt, Nx, Ny_scat_bank)

readu,u,image_top
close,u

;opening bottom part
file_bottom = (*global).file_to_plot_bottom
openr,u,file_bottom,/get

fs=fstat(u)
file_size=fs.size

image_bottom = ulonarr(Nt, Nx, Ny_scat_bank)

readu,u,image_bottom
close,u

(*(*global).image_top) = image_top
(*(*global).image_bottom) = image_bottom

PLOT_NEXUS_FILE, Event

text = "...done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end





pro create_local_copy_of_histo_mapped, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_nexus_name = (*global).full_nexus_name

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')

cmd_dump = "nxdir " + full_nexus_name
cmd_dump_top = cmd_dump + " -p /entry/bank1/data/ --dump "
cmd_dump_bottom = cmd_dump + " -p /entry/bank2/data/ --dump "

;get name of output_file
tmp_output_file = (*global).full_tmp_nxdir_folder_path 
tmp_output_file += "/BSS"
tmp_output_file += "_" + strcompress((*global).run_number,/remove_all)

tmp_output_file_top = tmp_output_file + "_top.dat"
tmp_output_file_bottom = tmp_output_file + "_bottom.dat"
(*global).file_to_plot_top = tmp_output_file_top
(*global).file_to_plot_bottom = tmp_output_file_bottom

cmd_dump_top += tmp_output_file_top 
cmd_dump_bottom += tmp_output_file_bottom

;display command

text= cmd_dump_top
widget_control, view_info, set_value=text, /append
text= "Processing....."
widget_control, view_info, set_value=text, /append
spawn, cmd_dump_top, listening

text= cmd_dump_bottom
widget_control, view_info, set_value=text, /append
text= "Processing....."
widget_control, view_info, set_value=text, /append

spawn, cmd_dump_bottom, listening

;display result of command
;text= listening
text="Done"
widget_control, view_info, set_value=text, /append

end





pro create_tmp_folder, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_nxdir_folder = (*global).tmp_nxdir_folder
full_tmp_nxdir_folder_path = (*global).working_path + tmp_nxdir_folder
(*global).full_tmp_nxdir_folder_path = full_tmp_nxdir_folder_path

cmd_check = "ls -d " + full_tmp_nxdir_folder_path
spawn, cmd_check, listening

if (listening NE '') then begin
    cmd_remove = "rm -r " + full_tmp_nxdir_folder_path
    spawn, cmd_remove
endif

;now create tmp folder
cmd_create = "mkdir " + full_tmp_nxdir_folder_path
spawn, cmd_create,  listening

end




pro PLOT_NEXUS_FILE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

data_top = (*(*global).image_top)
data_bottom = (*(*global).image_bottom)


Nx=(*global).Nx
Ny=(*global).Ny_scat

if ((*global).refresh_histo EQ 0) then begin

Nt=(*global).Nt

;update Tbin_interaction interface
max_tbin_slider_id = widget_info(Event.top,FIND_BY_UNAME='MAX_TBIN_SLIDER')
min_tbin_slider_id = widget_info(Event.top,FIND_BY_UNAME='MIN_TBIN_SLIDER')
max_tbin_text_id = widget_info(Event.top,FIND_BY_UNAME='MAX_TBIN_TEXT')
widget_control, max_tbin_slider_id, SET_SLIDER_MAX=Nt-1
widget_control, max_tbin_slider_id, SET_VALUE=Nt-1
widget_control, min_tbin_slider_id, SET_SLIDER_MAX=Nt-1
widget_control, max_tbin_text_id, SET_VALUE=strcompress(Nt-1,/remove_all)

;find the non-null elements
indx1 = where(data_top GT 0, Ngt0)
indx2 = where(data_bottom GT 0, Ngt1)
img_top = lonarr(Nt, Nx, Ny/2)
img_bottom = lonarr(Nt, Nx, Ny/2)
img_top(indx1) = data_top(indx1)
img_bottom(indx2) = data_bottom(indx2)

;sum over time bins
top_bank = total(img_top,1)
bottom_bank = total(img_bottom,1)

tbin_frame_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='tbin_frame')
WIDGET_CONTROL, tbin_frame_id, sensitive=1

endif else begin ;if file has already been opened

;get value of min_tbin and max_tbin
    min_tbin = long((*global).min_tbin)   
    max_tbin = long((*global).max_tbin)
    Nx = (*global).Nx
    Ny = (*global).Ny
     
    new_Nt = max_tbin - min_tbin

    if (new_Nt EQ 0) then begin
        new_Nt = 1
    endif   
   
    new_img_top = intarr(new_Nt+1,Nx,Ny)
    new_img_bottom = intarr(new_Nt+1,Nx,Ny)

    new_img_top = data_top(min_tbin:max_tbin,*,*)
    new_img_bottom = data_bottom(min_tbin:max_tbin,*,*)
    
    top_bank = total(new_img_top,1)
    bottom_bank = total(new_img_bottom,1)

    tbin_refresh_button_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='TBIN_REFRESH_BUTTON')
    WIDGET_CONTROL, tbin_refresh_button_id, sensitive=0

endelse

(*(*global).top_bank) = top_bank
(*(*global).bottom_bank) = bottom_bank

top_bank = transpose(top_bank)
bottom_bank = transpose(bottom_bank)

if ((*global).do_color EQ 1) then begin
    
    DEVICE, DECOMPOSED=0
    loadct, 2
    
endif

Ny_pixels = (*global).Ny_pixels
Nx_tubes = (*global).Nx_tubes

x_coeff = 12
(*global).x_coeff = x_coeff
y_coeff = 4
(*global).y_coeff = y_coeff

New_Ny = y_coeff*Ny_pixels
New_Nx = x_coeff*Nx_tubes
xoff = 10
yoff = 10

;top bank
view_info = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_TOP_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

;tvimg = congrid(top_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(top_bank, New_Nx, New_Ny,/sample)
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

;tvimg = congrid(bottom_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(bottom_bank, New_Nx, New_Ny,/sample) 
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
plot, [0,Nx_tubes],/nodata,/device,xrange=[0,Nx_tubes-1],$
  xstyle=1+8, ystyle=4, /noerase, charsize=1.0, charthick=1.6,$
  xmargin=[1,3], xticks=8, xtitle=xtitle, color=2,$
  xTickLen=.5, XGridStyle=2, xminor=7, xtickinterval=4

;top pixels axis
view_info = widget_info(Event.top,FIND_BY_UNAME='Y_SCALE_TOP_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

TvLCT, [70,255,0],[70,255,255],[70,0,0],1
plot, [0,Ny_pixels-1],/nodata,/device,yrange=[0,Ny_pixels-1],$
  ystyle=1+8, xstyle=4, charsize=0.8, charthick=1.3,$
  ymargin=[0,0], yticks=8, color=2,$
  yTickLen=-.1, YGridStyle=2, Yminor=7, Ytickinterval=3


;bottom pixels axis
view_info = widget_info(Event.top,FIND_BY_UNAME='Y_SCALE_BOTTOM_BANK')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

TvLCT, [70,255,0],[70,255,255],[70,0,0],1
plot, [0,Ny_pixels-1],/nodata,/device,yrange=[0,Ny_pixels-1],$
  ystyle=1+8, xstyle=4, charsize=0.8, charthick=1.3,$
  ymargin=[0,0], yticks=8, color=2,$
  yTickLen=-.1, YGridStyle=2, Yminor=7, Ytickinterval=3

;plot of top scale
view_info = widget_info(Event.top,FIND_BY_UNAME='SCALE_TOP_PLOT')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

max_top = max(top_bank)
print, max_top
cscl = lindgen(20,New_Ny-10)
tvscl,cscl,40,5,/device
plot,[0,20],[0,max_top*y_coeff],/device,pos=[35,5,35,240],/noerase,/nodata,$
  xticks=1,xtickv=1,charsize=0.8

;plot of bottom scale
view_info = widget_info(Event.top,FIND_BY_UNAME='SCALE_BOTTOM_PLOT')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
erase

max_bottom = max(bottom_bank)
cscl = lindgen(20,New_Ny-10)
tvscl,cscl,40,5,/device
plot,[0,20],[0,max_bottom*y_coeff],/device,pos=[35,5,35,240],/noerase,/nodata,$
  xticks=1,xtickv=1,charsize=0.8

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = " ....Plotting COMPLETED "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

(*global).file_already_opened = 1
(*global).refresh_histo = 0

end
