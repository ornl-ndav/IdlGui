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



pro RealignGUI_eventcb
end


pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0


end





pro OPEN_MAPPED_HISTOGRAM, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

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
   path = (*global).working_path
endelse

path = "/SNS/users/j35/" ;REMOVE_ME
file = dialog_pickfile(/must_exist,$
	title="Select a histogram file for BSS",$
	filter= (*global).filter_histo,$
	path = path,$
	get_path = path)

;check if there is really a file
if (file NE '') then begin

(*global).file = file

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')

if (path NE '') then begin
   (*global).path = path
   text = "File: " 
   WIDGET_CONTROL, view_info, SET_VALUE=text
   text = file
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

   (*global).file_already_opened = 1

endif else begin

   text = "No file openned"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

PLOT_HISTO_FILE, Event

endif else begin

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
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

file = (*global).file 

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = " Opening/Reading file.......... "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = file
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

openr,u,file,/get

;to get the size of the file
fs=fstat(u)
file_size=fs.size

text = "Infos about file:" 
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "  - Size of file : " + strcompress(file_size,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

Nbytes = (*global).nbytes
N = long(file_size) / Nbytes    ;number of elements

text = "  - Nbre of elements : " + strcompress(N,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

Nx = (*global).Nx
Ny_diff = (*global).Ny_diff
Ny_scat = (*global).Ny_scat

Nt = long(N)/(long(Nx*(Ny_diff + Ny_scat)))
(*global).Nt = Nt

image1 = ulonarr(Nt,Nx,Ny_scat)
readu,u,image1
diff = ulonarr(Nt,Nx,Ny_diff)
readu,u,diff
close,/all

if ((*global).swap_endian EQ 1) then begin
    
    image1=swap_endian(image1)
    diff=swap_endian(diff)
    text = "true"
    
endif else begin
    
    text = "false"
    
endelse

text1 = "  - Swap endian : " + text
WIDGET_CONTROL, view_info, SET_VALUE=text1, /APPEND

text = "  - Number of Tbins : " + strcompress(Nt,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

image_2d_1 = total(image1,1)


tmp = image_2d_1[0:63,0:31]
tmp = reverse(tmp,1)
image_2d_1[0:63,0:31] = tmp

tmp = image_2d_1[64:*,32:*]
tmp = reverse(tmp,1)
image_2d_1[64:*,32:*] = tmp

(*(*global).image_2d_1) = image_2d_1 

draw_info= widget_info(Event.top, find_by_uname='draw_tube_pixels_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

;calculate i1,i2,i3,i4 and i5 for all the tubes
calculate_ix, Event

;display i1,i2,i3,i4 and i5 for tube 0
display_ix, Event, 0

;fill pixelids counts in right table
pixelIDs_info_id = widget_info(Event.top, FIND_BY_UNAME='pixels_counts_values')
text = ' 0: ' + strcompress(image_2d_1[0,0],/remove_all)
widget_control, pixelIDs_info_id, set_value=text
for i=1,127 do begin
    text = strcompress(i) + ': ' + strcompress(image_2d_1[i,0],/remove_all)
    widget_control, pixelIDs_info_id, set_value=text, /append
endfor

;color
DEVICE, DECOMPOSED = 0
loadct,5

;plot DAS'plot
das_plot_id = widget_info(Event.top, find_by_uname='DAS_plot_draw')
widget_control, das_plot_id, get_value=das_id
wset, das_id

xoff=5
yoff=5
x_size=400
y_size=100
New_Nx = 530
New_Ny = 200
image_2d_1 = transpose(image_2d_1)
tvimg = congrid(image_2d_1,New_Nx,New_Ny,/interp)
tvscl, tvimg, xoff, yoff, /device, xsize=x_size, ysize=y_size

DEVICE, DECOMPOSED = 1

end









pro calculate_ix, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

image_2d_1 = (*(*global).image_2d_1)
Ntubes = (*global).Ny_scat      ;Number of tubes

i1 = intarr(Ntubes)             ;first part of tube start
i2 = intarr(Ntubes)             ;first part of tube end
i3 = intarr(Ntubes)             ;second part of tube start
i4 = intarr(Ntubes)             ;second part of tube end
i5 = intarr(Ntubes)             ;central position between the two parts

len1 = intarr(Ntubes)           ;length of first part of tube
len2 = intarr(Ntubes)           ;length of second part of tube

off1 = 25                       ;max position of first part tube start
off2 = 50                       ;min position of first part tube end 
off3 = 80                 ;max position of second part tube start     
off4 = 110                      ;min position of second part tube end

for i=0,Ntubes-1 do begin
    
    sum_tube = total(image_2d_1[*,i]) ;check if there are counts for that tube
    
    if (sum_tube EQ 0) then begin ;if there is no data in tube
        
        indx1=0
        indx2=62
        cntr=63
        indx3=65
        indx4=127
        
    endif else begin
        
        tube_pair = image_2d_1[*,i] ; - smooth(0.75*image_2d_1[*,i],5)
        
                                ;place where I'm going to remove counts in file
        
        diff_rise = tube_pair - shift(tube_pair,1)
        diff_fall = tube_pair - shift(tube_pair,-1)
        
        tmp0 = min(image_2d_1[off2:off3,i],cntr)
        cntr += off2
        
        tmp1 = max(diff_rise[0:off1],indx1)
        tmp2 = max(diff_fall[off2:cntr],indx2)
        indx2 += off2
        tmp3 = max(diff_rise[cntr:off3],indx3)
        indx3 += cntr
        tmp4 = max(diff_fall[off4:*],indx4)
        indx4 += off4
        
    endelse
        
                                ;store the indexes in an array i
    i1[i] = indx1
    i2[i] = indx2
    i3[i] = indx3
    i4[i] = indx4
    i5[i] = cntr
    
                                ;store the size of each size of the tube in len1 and len2
    len1[i] = i2[i] - i1[i]
    len2[i] = i4[i] - i3[i]
    
endfor

(*(*global).i1) = i1
(*(*global).i2) = i2
(*(*global).i3) = i3
(*(*global).i4) = i4
(*(*global).i5) = i5

(*(*global).len1) = len1
(*(*global).len2) = len2

end







pro display_ix, Event, i

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

image_2d_1 = (*(*global).image_2d_1)

i1=(*(*global).i1)
i2=(*(*global).i2)
i3=(*(*global).i3)
i4=(*(*global).i4)
i5=(*(*global).i5)

indx1 = i1[i]
indx2 = i2[i]
indx3 = i3[i]
indx4 = i4[i]
cntr = i5[i]

draw_info= widget_info(Event.top, find_by_uname='draw_tube_pixels_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

;loadct,0
plot, image_2d_1[*,i]
oplot,image_2d_1[*,i],psym=4,color=255
plots,[indx1,image_2d_1[indx1,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx2,image_2d_1[indx2,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[cntr,image_2d_1[cntr,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx3,image_2d_1[indx3,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx4,image_2d_1[indx4,i]],psym=4,color=255+(256*0)+(150*256),thick=3

tube_number = i

if ((*global).new_tube EQ 1) then begin

    (*global).new_tube = 0
    pixelIDs_info_id = widget_info(Event.top, FIND_BY_UNAME='pixels_counts_values')
    text = ' 0: ' + strcompress(image_2d_1[0,tube_number],/remove_all)
    widget_control, pixelIDs_info_id, set_value=text
    for i=1,127 do begin
        text = strcompress(i) + ': ' + strcompress(image_2d_1[i,tube_number],/remove_all)
        widget_control, pixelIDs_info_id, set_value=text, /append
    endfor

endif

;show the values of indx1, indx2....etc into their own spaces
indx1_id = widget_info(Event.top, find_by_uname="tube0_left_text")
indx2_id = widget_info(Event.top, find_by_uname="tube0_right_text")
cntr_id = widget_info(Event.top, find_by_uname="center_text")
indx3_id = widget_info(Event.top, find_by_uname="tube1_left_text")
indx4_id = widget_info(Event.top, find_by_uname="tube1_right_text")

widget_control, indx1_id, set_value=strcompress(indx1,/remove_all)
widget_control, indx2_id, set_value=strcompress(indx2,/remove_all)
widget_control, cntr_id, set_value=strcompress(cntr,/remove_all)
widget_control, indx3_id, set_value=strcompress(indx3,/remove_all)
widget_control, indx4_id, set_value=strcompress(indx4,/remove_all)


end





pro plot_tubes_pixels, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

(*global).new_tube = 1
display_ix, Event, tube_number

end



pro get_pixels_infos, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
widget_control, pixel_slider_id, get_value=pixel_number

tube_slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, tube_slider_id, get_value=tube_number

draw_info= widget_info(Event.top, find_by_uname='draw_tube_pixels_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

display_ix, Event, tube_number

image_2d_1 = (*(*global).image_2d_1)
plots,[pixel_number,image_2d_1[pixel_number,tube_number]],psym=4,color=(0*256)+(256*0)+(150*256),thick=3

end





pro move_tube_edges, Event, tube_side, left_right, minus_plus

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

case tube_side of
    0: begin
        if (left_right EQ "left") then begin
            i1=(*(*global).i1)
            if (minus_plus EQ "minus") then begin
                i1[tube_number]-=1
            endif else begin
                i1[tube_number]+=1
            endelse
            (*(*global).i1)=i1
            id=widget_info(Event.top,find_by_uname="tube0_left_text")
            widget_control, id, set_value=strcompress(i1[tube_number],/remove_all)
        endif else begin
            i2=(*(*global).i2)
            if (minus_plus EQ "minus") then begin
                i2[tube_number]-=1
            endif else begin
                i2[tube_number]+=1
            endelse
            (*(*global).i2)=i2
            id=widget_info(Event.top,find_by_uname="tube0_right_text")
            widget_control, id, set_value=strcompress(i2[tube_number],/remove_all)
        endelse
    end
    1: begin
        if (left_right EQ "left") then begin
            i3=(*(*global).i3)
            if (minus_plus EQ "minus") then begin
                i3[tube_number]-=1
            endif else begin
                i3[tube_number]+=1
            endelse
            (*(*global).i3)=i3
            id=widget_info(Event.top,find_by_uname="tube1_left_text")
            widget_control, id, set_value=strcompress(i3[tube_number],/remove_all)
        endif else begin
            i4=(*(*global).i4)
            if (minus_plus EQ "minus") then begin
                i4[tube_number]-=1
            endif else begin
                i4[tube_number]+=1
            endelse
            (*(*global).i4)=i4
            id=widget_info(Event.top,find_by_uname="tube1_right_text")
            widget_control, id, set_value=strcompress(i4[tube_number],/remove_all)
        endelse
    end
    "center": begin
            i5=(*(*global).i5)
            if (minus_plus EQ "minus") then begin
                i5[tube_number]-=1
            endif else begin
                i5[tube_number]+=1
            endelse
            (*(*global).i5)=i5
            id=widget_info(Event.top,find_by_uname="center_text")
            widget_control, id, set_value=strcompress(i5[tube_number],/remove_all)
        end
endcase

;display i1,i2,i3,i4 and i5 for given tube (tube_number) 
display_ix, Event, tube_number

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
pro IDENTIFICATION_GO_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

text_id=widget_info(Event.top, FIND_BY_UNAME='IDENTIFICATION_TEXT')
WIDGET_CONTROL, text_id, GET_VALUE=character_id
(*global).character_id = character_id

;check 3 characters id
ucams=(*global).ucams

print, ucams ;REMOVE_ME

name = ''
case ucams of
	'ele': name = 'Eugene Mamontov'
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

endif else begin

   (*global).name = name
   working_path = (*global).working_path

   welcome = "Welcome " + strcompress(name,/remove_all)
   welcome += "  (working directory: " + strcompress(working_path,/remove_all) + ")"	
   view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
   WIDGET_CONTROL, view_id, base_set_title= welcome	

   view_id = widget_info(Event.top,FIND_BY_UNAME='IDENTIFICATION_BASE')
   WIDGET_CONTROL, view_id, destroy=1

;   view_id = widget_info(Event.top,FIND_BY_UNAME='OUTPUT_PATH_NAME')
;   WIDGET_CONTROL, view_id, set_value=working_path

   ;working path is set
   cd, working_path
 
;    view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
;    text = "LOGIN parameters:"
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "User id           : " + ucams
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "Name              : " + name
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "Working directory : " + working_path
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
; 
  
endelse

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;----------------------------------------------------------------------------------------
pro OUTPUT_PATH_cb, Event 

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

view_info = widget_info(Event.top,FIND_BY_UNAME="OUTPUT_PATH_NAME")
WIDGET_CONTROL, view_info, set_value=working_path

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;-----------------------------------------------------------------------------------------
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;--------------------------------------------------------------------------------------
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
   print, "inside min_tbin GT max_tbin"
   max_tbin = min_tbin
endif

(*global).max_tbin = max_tbin
(*global).min_tbin = min_tbin

PLOT_HISTO_FILE, Event

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
