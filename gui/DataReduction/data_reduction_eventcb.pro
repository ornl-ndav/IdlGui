function produce_output_file_name, Event, run_number, extension

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_folder = (*global).tmp_folder

output_file_name = tmp_folder + (*global).instrument 
output_file_name += "_" + run_number + extension

return, output_file_name 
end


function retrieve_REF_M_parameters, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

wave_min_id = widget_info(Event.top, find_by_uname='wavelength_min_text')
wave_max_id = widget_info(Event.top, find_by_uname='wavelength_max_text')
wave_width_id = widget_info(Event.top, find_by_uname='wavelength_width_text')

widget_control, wave_min_id, get_value=wave_min
widget_control, wave_max_id, get_value=wave_max
widget_control, wave_width_id, get_value=wave_width

det_angle_id = widget_info(Event.top, find_by_uname='detector_angle_value')
det_angle_err_id = widget_info(Event.top, find_by_uname='detector_angle_err')

widget_control, det_angle_id, get_value=detector_angle
widget_control, det_angle_err_id, get_value=detector_angle_err

det_angle_units_id = widget_info(Event.top, find_by_uname='detector_angle_units',/droplist_select)
widget_control, det_angle_units_id, get_value=all_det_angle_units
index = widget_info(det_angle_units_id, /droplist_select)
det_angle_units = all_det_angle_units[index]

if (det_angle_units EQ 'degres') then begin
    coeff = ((2*!pi)/180)
    detector_angle_rad = coeff*detector_angle 
    detector_angle_err_rad = coeff*detector_angle_err
endif else begin
    detector_angle_rad = detector_angle
    detector_angle_err_rad = detector_angle_err
endelse

array_of_parameters = [wave_min, wave_max, wave_width, detector_angle_rad, detector_angle_err]
return, array_of_parameters

end







function get_last_part_of_pid_file_names, signal_pid, background_pid

array_name_signal = strsplit(signal_pid,'/',count=length,/extract)
pid_name = array_name_signal[length-1]

array_name_background = strsplit(background_pid,'/',count=length,/extract)
background_name = array_name_background[length-1]

last_part_of_pid_file_name = [pid_name, background_name]

return, last_part_of_pid_file_name
end





function get_list_of_runs, runs_to_process

array_of_runs = strsplit(runs_to_process,',',count=length,/extract)

return, array_of_runs
end




function get_last_part_of_pid_file_name, full_pid_file_name

array_pid_file_name = strsplit(full_pid_file_name,'/',count=length,/extract)
pid_file_name = array_pid_file_name[length-1]

return, pid_file_name
end





;this function reorder two numbers
function  reorder, x1, x2, y1, y2 

X=[x1,x2]
xmin = min(X, max=xmax)

Y=[y1,y2]
ymin = min(Y, max=ymax)

return, [xmin, xmax, ymin, ymax]
end





pro open_pid_file, Event, type

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

title = 'Select ' + type + ' Pid file'
filter= '*_' + type + '_' + (*global).pid_file_extension
pid_path = (*global).tmp_folder
;open file
full_pid_file = dialog_pickfile(path=pid_path,$
                                 get_path=path,$
                                 title=title,$
                                 filter=filter)

if (full_pid_file NE '') then begin

    last_part_of_Pid_name = get_last_part_of_pid_file_name(full_pid_file)

    if (type EQ 'signal') then begin
        text_box_id = widget_info(Event.top, find_by_uname='signal_pid_text')
        (*global).signal_pid_file_name = full_pid_file
    endif else begin
        text_box_id = widget_info(Event.top, find_by_uname='background_pid_text')
        (*global).background_pid_file_name = full_pid_file
    endelse
    
    widget_control, text_box_id, set_value=last_part_of_Pid_name
    
;put info into log_book
    full_view_info = widget_info(Event.top, find_by_uname='log_book_text')
    text = type + ' Pid file has been loaded: '
    widget_control, full_view_info, set_value=text, /append
    widget_control, full_view_info, set_value=full_pid_file, /append

    check_status_to_validate_go, Event

endif

end




pro help_runs_to_process, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

push_button = (*global).push_button
id_text_box = widget_info(Event.top, find_by_uname='runs_to_process_text')


if (push_button EQ 0) then begin

;save previous contains of text box
    widget_control, id_text_box, get_value=previous_text
    (*global).previous_text = previous_text

;put help contains
    (*global).push_button = 1
    text = '1924,1925,1930,1946,1947,1950'

endif else begin

;put back previous contain of text box
    (*global).push_button = 0
    text = (*global).previous_text

endelse

widget_control, id_text_box, set_value=text

end






;Create the output array for signal selection
pro create_signal_pid_array_file, XY, file_name

xmin = XY[0]
xmax = XY[1]
ymin = XY[2]
ymax = XY[3]

openw, 1, file_name

i=0
for x=xmin, xmax do begin
    for y=ymin, ymax do begin
        text = 'bank1_' + strcompress(x,/remove_all)
        text += '_' + strcompress(y,/remove_all)
        printf, 1,text
        ++i
    endfor
endfor

close, 1
free_lun, 1

end







;Create the output array for background selection
pro create_background_pid_array_file, Event, XYsignal, XYbackground, XYbackground_2, file_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

xmin_signal = XYsignal[0]
xmax_signal = XYsignal[1]
ymin_signal = XYsignal[2]
ymax_signal = XYsignal[3]

xmin_back = XYbackground[0]
xmax_back = XYbackground[1]
ymin_back = XYbackground[2]
ymax_back = XYbackground[3]


;define arrays
;Nx = (*global).Nx
;Ny = (*global).Ny
Nx = (*global).Ny
Ny = (*global).Nx
signal_array=intarr(Nx, Ny)
background_1_array = intarr(Nx, Ny)

;create signal array
for x=xmin_signal, xmax_signal do begin
    for y=ymin_signal, ymax_signal do begin
        signal_array[x,y]=1
    endfor
endfor

;create background arraay

for x=xmin_back, xmax_back do begin
    for y=ymin_back, ymax_back do begin
        background_1_array[x,y]=1
    endfor
endfor

;if there is a second background selection
if ((*global).selection_background_2 EQ 1) then begin  
    xmin_back_2 = XYbackground_2[0]
    xmax_back_2 = XYbackground_2[1]
    ymin_back_2 = XYbackground_2[2]
    ymax_back_2 = XYbackground_2[3]

    background_2_array = intarr(Nx, Ny)
    
    for x=xmin_back_2,xmax_back_2 do begin
        for y=ymin_back_2, ymax_back_2 do begin
            background_2_array[x,y]=1
        endfor
    endfor

;create new background array
 
    background_1_array += background_2_array
   
endif

;remove from background array, pixel already in signal array

for x=xmin_signal,xmax_signal do begin
    for y=ymin_signal, ymax_signal do begin
        background_1_array[x,y] = 0
    endfor
endfor


openw, 1, file_name

i=0
for x=0, Nx-1 do begin
    for y=0, Ny-1 do begin
        if (background_1_array[x,y] NE 0) then begin
            text = 'bank1_' + strcompress(x,/remove_all)
            text += '_' + strcompress(y,/remove_all)
            printf, 1,text
            ++i
        endif
    endfor
endfor

close, 1
free_lun, 1

end









function get_signal_background_pid_file_name, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_folder = (*global).tmp_folder
pid_file_extension = (*global).pid_file_extension
first_part = tmp_folder + (*global).instrument
first_part += "_" + (*global).run_number

signal_pid_file_name = first_part + "_signal_" + pid_file_extension
background_pid_file_name = first_part + "_background_" + pid_file_extension

signal_background_pid_file_names = [signal_pid_file_name,$
                                    background_pid_file_name]

return, signal_background_pid_file_names
end






function get_ucams

cd , "~/"
cmd_pwd = "pwd"
spawn, cmd_pwd, listening
print, "listening is: ", listening
array_listening=strsplit(listening,'/',count=length,/extract)
ucams = array_listening[2]
return, ucams
end





FUNCTION get_name_of_tmp_output_file, Event, tmp_working_path, instr

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

run_number = (*global).run_number

(*global).nexus_file_name_only = instr + "_" + $
  strcompress(run_number,/remove_all) + $
  ".nxs"

tmp_output_file_name = tmp_working_path
tmp_output_file_name += instr + "_" + strcompress(run_number,/remove_all)
tmp_output_file_name += "_neutron_histo_mapped.dat"

return, tmp_output_file_name

end




FUNCTION find_full_nexus_name, Event, run_number, instrument    

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -i" + instrument + " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name

;check if nexus exists
result = strmatch(full_nexus_name,"*ERROR*")

if (result GE 1) then begin
    find_nexus = 0
endif else begin
    find_nexus = 1
endelse

(*global).find_nexus = find_nexus

return, full_nexus_name

end




Function find_nexus_path, NeXus_runs_array, length, instrument

NeXus_path_array = strarr(length)
j=0

for i=0,length-1 do begin
    cmd = "findnexus -i" + instrument + " " + strcompress(NeXus_runs_array[i],/remove_all)
    spawn, cmd, full_nexus_name

;check if nexus exist
result = strmatch(full_nexus_name,"*ERROR*")

if (result EQ 0) then begin
    NeXus_path_array[j] = full_nexus_name
    ++j
endif

endfor

return, [j, NeXus_path_array] 
end





function check_access, Event, instrument, ucams

list_of_instrument = ['REF_L', 'REF_M']

;0:j35:jean / 1:pf9:pete / 2:2zr:michael / 3:mid:steve / 4:1qg:rick / 5:ha9:haile / 6:vyi:frank / 7:vuk:john 
;8:x4t:xiadong / 9:ele:eugene
list_of_ucams = ['j35','pf9','2zr','mid','1qg','ha9','vyi','vuk','x4t','ele']

;check if ucams is in the list
ucams_index=-1
for i =0, 9 do begin
   if (ucams EQ list_of_ucams[i]) then begin
     ucams_index = i
     break 
   endif
endfor

;check if user is autorized for this instrument
CASE instrument OF		
   ;REF_L
   0: CASE  ucams_index OF
        -1:
	0: 		;authorized
	1: 		;authorized
	2: 		;authorized
	3: 		;authorized
	4: ucams_index=-1	;unauthorized
	5: ucams_index=-1	;unauthorized
	6: ucams_index=-1	;unauthorized
	7: 		;authorized
	8: 		;authorized
	9: ucams_index=-1	;unauthorized
      ENDCASE
   ;REF_M
   1: CASE ucams_index OF
	-1:
	0: 
	1: 
	2: 
	3: 
	4: 
	5: 
	6: 
	7: ucams_index=-1
	8: ucams_index=-1
	9: ucams_index=-1
      ENDCASE
ENDCASE	 
	
RETURN, ucams_index
 
end

;---------------------------------------------------------------------------------
pro USER_TEXT_cb, Event   ;for REF_M

view_id = widget_info(Event.top,FIND_BY_UNAME='LEFT_TOP_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='RIGHT_TOP_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='LEFT_BOTTOM_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='RIGHT_BOTTOM_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;------------------------------------------------------------------------------------------
; \brief function to obtain the top level base widget given an arbitrary widget ID.
;
; \argument wWidget (INPUT)
;------------------------------------------------------------------------------------------
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




;main_realize of the front door interface (instrument selection)
pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/DataReduction/data_reduction_gui_logo.bmp"
id = widget_info(wWidget,find_by_uname="logo_message_draw")
WIDGET_CONTROL, id, GET_VALUE=id_value
wset, id_value
image = read_bmp(image_logo)
tv, image,0,0,/true

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;main_realize of main data_reduction display
pro MAIN_REALIZE_data_reduction, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






; \brief Empty stub procedure used for autoloading.
;
pro data_reduction_eventcb
end




pro wTLB_REALIZE, wWidget
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end




;OPEN NEXUS FILE
pro open_nexus_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;reset file_opened
(*global).file_opened = 0

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;retrieve run_number
id_run_number = widget_info(Event.top, FIND_BY_UNAME='nexus_run_number_box')
widget_control, id_run_number, get_value=run_number

;erase all displays
reset_and_erase_displays, Event    

if (run_number EQ '') then begin

    text = "!!! Please specify a run number !!! " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text
    widget_control, full_view_info, set_value=text
    
endif else begin
    
;indicate reading data with hourglass icon
    widget_control,/hourglass

    (*global).run_number = run_number
    
    text = "Searching for NeXus file of run number " + strcompress(run_number,/remove_all)
    text += "..."
    WIDGET_CONTROL, full_view_info, SET_VALUE=text
    text = "Openning/plotting Run # " + strcompress(run_number,/remove_all) + "..."
    WIDGET_CONTROL, view_info, SET_VALUE=text

;get path to nexus run #
    instrument=(*global).instrument
    full_nexus_name = find_full_nexus_name(Event, run_number, instrument)
    
;check result of search
    find_nexus = (*global).find_nexus
    if (find_nexus EQ 0) then begin
        text_nexus = "Warning! NeXus file does not exist"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
        WIDGET_CONTROL, full_view_info, SET_VALUE=text_nexus,/append
    endif else begin
        text_nexus = "NeXus file has been localized: "
        (*global).full_nexus_name = full_nexus_name
        text_nexus += full_nexus_name
        WIDGET_CONTROL, full_view_info, SET_VALUE=text_nexus,/append
        
;dump binary data of NeXus file into tmp_working_path
        text = " - dump binary data......."
        WIDGET_CONTROL, full_view_info, SET_VALUE=text,/append
        dump_binary_data, Event, full_nexus_name       
        text = " - dump binary data.......done" 
        WIDGET_CONTROL, full_view_info, SET_VALUE=text,/append

;read and plot nexus file
        read_and_plot_nexus_file, Event      

;tell the program that data are displayed
        (*global).file_opened = 1

;validate signal and background pid file
        signal_pid_file_button_id = widget_info(Event.top, find_by_uname='signal_pid_file_button')
        background_pid_file_button_id = widget_info(Event.top, $
                                                    find_by_uname='background_pid_file_button')
        widget_control, signal_pid_file_button_id, sensitive=1
        widget_control, background_pid_file_button_id, sensitive=1
        
        ;put nexus run number into list of nexus runs if REF_L
        runs_to_process_text_id = widget_info(Event.top, find_by_uname='runs_to_process_text')
        if (instrument EQ 'REF_L') then begin
            widget_control, runs_to_process_text_id, get_value=previous_text
            new_text = strcompress(run_number,/remove_all) + ',' + previous_text
            widget_control, runs_to_process_text_id, set_value=new_text
        endif else begin ;only copy run number into run to process if REF_M
            new_text = strcompress(run_number,/remove_all)
            widget_control, runs_to_process_text_id, set_value=new_text
        endelse

        if (instrument EQ 'REF_L') then begin
            check_status_to_validate_go, Event
        endif

    endelse
    
endelse

end




pro reset_and_erase_displays, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).selection_signal = 0
(*global).selection_background = 0

id_draw = widget_info(Event.top, find_by_uname='display_data_base')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

end





PRO dump_binary_data, Event, full_nexus_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;create tmp_working_path
;get global structure
tmp_working_path = (*global).tmp_working_path
tmp_working_path += "_" + (*global).instrument + "/"

tmp_folder = (*global).output_path + tmp_working_path
(*global).tmp_folder = tmp_folder
cmd_create = "mkdir " + tmp_folder

text= " [ " + cmd_create + "..."
widget_control, full_view_info, set_value=text, /append
spawn, cmd_create
text= "   ...done ]"
widget_control, full_view_info, set_value=text, /append

cmd_dump = "nxdir " + full_nexus_name
cmd_dump += " -p /entry/bank1/data/ --dump "

;get tmp_output_file_name
instr=(*global).instrument
tmp_output_file_name = get_name_of_tmp_output_file(Event, tmp_folder, instr)
cmd_dump += tmp_output_file_name

(*global).full_histo_mapped_name = tmp_output_file_name

;display command
text= " [ " + cmd_dump + "..."
widget_control, full_view_info, set_value=text, /append
spawn, cmd_dump, listening

;display result of command
;text= listening
text= "   ...done ]"
widget_control, full_view_info, set_value=text, /append

end




;--------------------------------------------------------------------------
; \brief
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro read_and_plot_nexus_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;;first close previous file if there is one
;if (N_ELEMENTS(U)) NE 0 then begin
;    close, u
;    free_lun,u
;endif 

;retrieve data parameters
Nx = (*global).Nx
Ny = (*global).Ny


file = (*global).full_histo_mapped_name
nexus_file_name_only = (*global).nexus_file_name_only

full_view_info = widget_info(Event.top, find_by_uname='log_book_text')
text = " - plot NeXus file: " + nexus_file_name_only + "..."
WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND

;determine path	
path = (*global).tmp_folder
cd, path
        
WIDGET_CONTROL, full_view_info, SET_VALUE=' [ - reading in data...', /APPEND
strtime = systime(1)

openr,u,file,/get
;find out file info
fs = fstat(u)
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)
(*global).Ntof = Ntof           ;set back in global structure

data_assoc = assoc(u,lonarr(Ntof))

;make the image array
img = lonarr(Nx,Ny)
for i=0L,Nimg-1 do begin
    x = i MOD Nx   ;Nx=304
    y = i/Nx
    img[x,y] = total(data_assoc[i])
endfor			

img=transpose(img)

;load data up in global ptr array
(*(*global).img_ptr) = img
(*(*global).data_assoc) = data_assoc
	
DEVICE, DECOMPOSED = 0
if (*global).pass EQ 0 then begin
;load the default color table on first pass thru SHOW_DATA
    loadct,(*global).ct
    (*global).pass = 1          ;clear the flag...
endif

;put image data in main draw window
id_draw = widget_info(Event.top, find_by_uname='display_data_base')
widget_control, id_draw, get_value=id_value
wset,id_value
tvscl,img

endtime = systime(1)
tt_time = string(endtime - strtime)
text = 'Done in ' + strcompress(tt_time,/remove_all) + ' s'
WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
	
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
text = "...Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;now turn hourglass back off
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$








pro CTOOL, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;xloadct,/MODAL,GROUP=id
xloadct,/modal,group=id

SHOW_DATA,event

end





pro SHOW_DATA,event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get window numbers
id_draw = widget_info(Event.top, find_by_uname='display_data_base')
WIDGET_CONTROL, id_draw, GET_VALUE = id

;Decomposed=0 causes the least-significant 8 bits of the color index value
	;to be interpreted as a PseudoColor index.
DEVICE, DECOMPOSED = 0

wset, id
tvscl,(*(*global).img_ptr)

selection_value = (*global).selection_value
selection_signal = (*global).selection_signal
selection_background = (*global).selection_background
selection_background_2 = (*global).selection_background_2

if (selection_value EQ 0) then begin

    if (selection_background EQ 1) then begin
    
        color_line = (*global).color_line_background
        
        x1 = (*global).x1_back
        x2 = (*global).x2_back
        y1 = (*global).y1_back
        y2 = (*global).y2_back
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

    if (selection_background_2 EQ 1) then begin

        color_line = (*global).color_line_background_2

        x1 = (*global).x1_back_2
        x2 = (*global).x2_back_2
        y1 = (*global).y1_back_2
        y2 = (*global).y2_back_2
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line

    endif

endif

if (selection_value EQ 1) then begin

    if (selection_signal EQ 1) then begin
    
        color_line = (*global).color_line_signal
        
        x1 = (*global).x1_signal
        x2 = (*global).x2_signal
        y1 = (*global).y1_signal
        y2 = (*global).y2_signal
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

    if (selection_background_2 EQ 1) then begin

        color_line = (*global).color_line_background_2

        x1 = (*global).x1_back_2
        x2 = (*global).x2_back_2
        y1 = (*global).y1_back_2
        y2 = (*global).y2_back_2
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line

    endif

endif

if (selection_value EQ 2) then begin

    if (selection_background EQ 1) then begin
    
        color_line = (*global).color_line_background
        
        x1 = (*global).x1_back
        x2 = (*global).x2_back
        y1 = (*global).y1_back
        y2 = (*global).y2_back
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

    if (selection_signal EQ 1) then begin
    
        color_line = (*global).color_line_signal
        
        x1 = (*global).x1_signal
        x2 = (*global).x2_signal
        y1 = (*global).y1_signal
        y2 = (*global).y2_signal
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





pro selection_list_group_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, FIND_BY_UNAME='selection_list_group')
WIDGET_CONTROL, id, GET_VALUE = value

(*global).selection_value = value

end







;--------------------------------------------------------------------------
; \brief 
;
; \argument event (INPUT) 
;--------------------------------------------------------------------------
pro selection, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_opened = (*global).file_opened

view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;working on signal or background ? (0 for signal, 1 for background_1
;and 2 for background_2)
signal_or_background = (*global).selection_value

;left mouse button
IF ((event.press EQ 1) AND (file_opened EQ 1)) then begin
    
;get data
    img = (*(*global).img_ptr)

    tmp_tof = (*(*global).data_assoc)
    Nx = (*global).Nx
    
    x = Event.x
    y = Event.y

;set data
    text = " x= " + strcompress(x,/remove_all)
    text += " y= " + strcompress(y,/remove_all)
    
;put number of counts in number_of_counts label position
    text += " counts= " + strcompress(img(x,y))
    full_text = "PixelID infos : " + text
    widget_control, view_info, set_value=text, /append
    widget_control, full_view_info, set_value=full_text, /append
endif

;right mouse button
IF ((event.press EQ 4) AND (file_opened EQ 1)) then begin
    
;get window numbers
    id_draw = widget_info(Event.top, find_by_uname='display_data_base')
    WIDGET_CONTROL, id_draw, GET_VALUE = id
    wset, id
    
;from the rubber_band program
    getvals = 0 ;while getvals is GT 0, continue to check mouse down clicks
    
;continue to loop getting values while mouse clicks occur within the image window
    
    Nx = (*global).Nx
    Ny = (*global).Ny
    
    x = lonarr(2)
    y = lonarr(2)
    
    first_round=0
    
    cursor, x,y,/down,/device
    display_info =0	
    click_outside = 0
    
    while (getvals EQ 0) do begin
        
        cursor,x,y,/nowait,/device
        
        if ((x LT 0) OR (x GT Ny) OR (y LT 0) OR (y GT Nx)) then begin
            
            click_outside = 1
            getvals = 1
            
        endif else begin
            
            if (first_round EQ 0) then begin
                
                X1=x
                Y1=y
                
                if (signal_or_background EQ 0) then begin
                    
                    (*global).x1_signal = x
                    (*global).y1_signal = y
                    
                endif 
                    
                if (signal_or_background EQ 1) then begin
                    
                    (*global).x1_back = x
                    (*global).y1_back = y
                        
                endif 
                      
                if (signal_or_background EQ 2) then begin

                    (*global).x1_back_2 = x
                    (*global).y1_back_2 = y
                        
                endif
                    
                id_save_selection = widget_info(Event.top, $
                                                find_by_uname='clear_selection_button')
                widget_control, id_save_selection, sensitive=1
                
                first_round = 1
                text = " Rigth click to select other corner"		
                
            endif else begin
                
                X2=x
                Y2=y
                SHOW_DATA,event
                
                if (signal_or_background EQ 0) then begin
                    color_line = (*global).color_line_signal
                    (*global).selection_signal = 1
                endif 
                
                if (signal_or_background EQ 1) then begin
                    color_line = (*global).color_line_background
                    (*global).selection_background = 1
                endif
                
                if (signal_or_background EQ 2) then begin
                    color_line = (*global).color_line_background_2
                    (*global).selection_background_2 = 1
                endif
                
;validate save_selection button if signal and background region are there
                
                if (((*global).selection_signal EQ 1 AND $
                ((*global).selection_background EQ 1) OR $
                  (*global).selection_background_2 EQ 1)) then begin
                    id_save_selection = widget_info(Event.top, $
                                                    find_by_uname='save_selection_button')
                    widget_control, id_save_selection, sensitive=1
                endif
                
                plots, X1, Y1, /device, color=color_line
                plots, X1, Y2, /device, /continue, color=color_line
                plots, X2, Y2, /device, /continue, color=color_line
                plots, X2, Y1, /device, /continue, color=color_line
                plots, X1, Y1, /device, /continue, color=color_line
                
                if (signal_or_background EQ 0) then begin
                    
                    (*global).x2_signal = x
                    (*global).y2_signal = y
                    
                endif 
                
                if (signal_or_background EQ 1) then begin
                    
                    (*global).x2_back = x
                    (*global).y2_back = y
                    
                endif 
                        
                if (signal_or_background EQ 2) then begin      

                    (*global).x2_back_2 = x
                    (*global).y2_back_2 = y
                    
                endif    

                if (!mouse.button EQ 4) then begin ;stop the process
                    
                    getvals = 1
                    display_info = 1
                    
                endif
                
            endelse
            
        endelse
        
    endwhile
    
    if (click_outside EQ 1) then begin
        
        x=lonarr(2)
        y=lonarr(2)
        
            if (signal_or_background EQ 0) then begin

                x[0]=(*global).x1_signal
                x[1]=(*global).x2_signal
                y[0]=(*global).y1_signal
                y[1]=(*global).y2_signal
                
            endif 
        
            if (signal_or_background EQ 1) then begin
                
                x[0]=(*global).x1_back
                x[1]=(*global).x2_back
                y[0]=(*global).y1_back
                y[1]=(*global).y2_back
                
            endif
            
            if (signal_or_background EQ 2) then begin
    
                x[0]=(*global).x1_back_2
                x[1]=(*global).x2_back_2
                y[0]=(*global).y1_back_2
                y[1]=(*global).y2_back_2
                
            endif
            
;Initialization of text boxes
            full_text_selection_1 = ''
            full_text_selection_2 = 'The two corners are defined by:'
            
            y_min = min(y)
            y_max = max(y)
            x_min = min(x)
            x_max = max(x)
            
            y12 = y_max-y_min
            x12 = x_max-x_min
            total_pixel_inside = x12*y12
            total_pixel_outside = Nx*Ny - total_pixel_inside
            
            simg = (*(*global).img_ptr)
            
            starting_id = (y_min*304+x_min)
            starting_id_string = strcompress(starting_id)
            
            ending_id = (y_max*304+x_max)
            ending_id_string = strcompress(ending_id)
            
            full_text_selection_3 = '    Bottom left corner:  '
            full_text_selection_3_1 = '      pixelID#: ' + starting_id_string + $
              ' (x= '+strcompress(x_min,/rem) + $
              '; y= '+strcompress(y_min,/rem) + $
              ' intensity= ' + strcompress(simg[x_min,y_min],/rem)+')'
            
            full_text_selection_4 = '    Top right corner:  '
            full_text_selection_4_1 = '      pixelID#: ' + ending_id_string + $
              ' (x= '+strcompress(x_max,/rem) + $
              '; y= '+strcompress(y_max,/rem) + $
              ' intensity= ' + strcompress(simg[x_max,y_max],/rem)+')'
            
                                ;calculation of inside region total counts
            inside_total = total(simg(x_min:x_max, y_min:y_max))
            outside_total = total(simg)-inside_total
            inside_average = inside_total/total_pixel_inside
            outside_average = outside_total/total_pixel_outside
            
            full_text_selection_5 = ""
            full_text_selection_6 = 'General infos about selection: '
            full_text_selection_7 = "   - Number of pixelIDs inside the surface: " + $
              strcompress(x12*y12,/rem)
            full_text_selection_8 = "   - Selection width: " + strcompress(x12,/rem) + $
              ' pixels'
            full_text_selection_9 = "   - Selection height: " + strcompress(y12,/rem) + $
              ' pixels
            full_text_selection_10 = "   - Total inside selection counts: " + $
              strcompress(inside_total,/rem)
            full_text_selection_11 = ""
            full_text_selection_12 = "   - Total outside selection counts: " + $
              strcompress(outside_total,/rem)
            full_text_selection_13 = "   - Average inside selection counts: " + $
              strcompress(inside_average,/rem)
            full_text_selection_14 = "   - Average outside selection counts: " + $
              strcompress(outside_average,/rem) 
            
            value_group = [full_text_selection_2,$
                           full_text_selection_1,$
                           full_text_selection_3,$
                           full_text_selection_3_1,$
                           full_text_selection_4,$
                           full_text_selection_4_1,$
                           full_text_selection_5,$
                           full_text_selection_6,$
                           full_text_selection_1,$
                           full_text_selection_7,$
                           full_text_selection_8,$
                           full_text_selection_9,$
                           full_text_selection_10,$
                           full_text_selection_11,$
                           full_text_selection_12,$
                           full_text_selection_13,$
                           full_text_selection_14]
            
;check if selection is for signal of for background
            if (signal_or_background EQ 0) then begin
                view_info = widget_info(Event.top,FIND_BY_UNAME='signal_info')
                WIDGET_CONTROL, view_info, SET_VALUE=value_group
                    view_info_tab = widget_info(Event.top, find_by_uname='signal_tab_base')
                    widget_control, view_info_tab, base_set_title="Signal (white)"
            endif else begin
                if (signal_or_background EQ 1) then begin
                    view_info = widget_info(Event.top,FIND_BY_UNAME='background_info')
                    WIDGET_CONTROL, view_info, SET_VALUE=value_group
                    view_info_tab = widget_info(Event.top, find_by_uname='background_1_tab_base')
                    widget_control, view_info_tab, base_set_title="Background #1 (blue)"
                endif else begin
                    view_info = widget_info(Event.top,FIND_BY_UNAME='background_2_info')
                    WIDGET_CONTROL, view_info, SET_VALUE=value_group
                    view_info_tab = widget_info(Event.top, find_by_uname='background_2_tab_base')
                    widget_control, view_info_tab, base_set_title="Background #2 (red)"
                endelse
                
            endelse        
            
        endif else begin
            
        endelse
        
    endif
    
end






pro clear_selection_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

value = (*global).selection_value

if (value EQ 0) then begin
    (*global).selection_signal = 0
    text = "Clear signal selection"
    full_text = "Clear signal selection"
    selection_info = widget_info(Event.top,FIND_BY_UNAME='signal_info')
    view_info_tab = widget_info(Event.top, find_by_uname='signal_tab_base')
    ;remove text from signal pid text
    signal_id = widget_info(Event.top, find_by_uname='signal_pid_text')
    widget_control, signal_id, set_value = ''
endif else begin
    if (value EQ 1) then begin
        (*global).selection_background = 0 
        text = "Clear background selection"
        full_text = "Clear background selection"
        selection_info = widget_info(Event.top,FIND_BY_UNAME='background_info')
        view_info_tab = widget_info(Event.top, find_by_uname='background_1_tab_base')
        background_id = widget_info(Event.top, find_by_uname='background_pid_text')
        widget_control, background_id, set_value = ''
    endif else begin
        (*global).selection_background_2 = 0
        text = "Clear background selection #2"
        full_text = "Clear background selection #2"
        selection_info = widget_info(Event.top,FIND_BY_UNAME='background_2_info')
        view_info_tab = widget_info(Event.top, find_by_uname='background_2_tab_base')
        background_id = widget_info(Event.top, find_by_uname='background_pid_text')
        widget_control, background_id, set_value = ''
    endelse
endelse

id_save_selection = widget_info(Event.top, find_by_uname='save_selection_button')
widget_control, id_save_selection, sensitive=0

if ((*global).selection_signal EQ 0 AND $
    (*global).selection_background EQ 0 AND $
    (*global).selection_background_2 EQ 0) then begin
    
    id_save_selection = widget_info(Event.top, find_by_uname='clear_selection_button')
    widget_control, id_save_selection, sensitive=0
    
endif

widget_control, view_info, set_value=text, /append
widget_control, full_view_info, set_value=full_text, /append
widget_control, selection_info, set_value=''
widget_control, view_info_tab, base_set_title=''
SHOW_DATA,event

end






pro save_selection_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

signal_background_pid_file_names = get_signal_background_pid_file_name(Event)
signal_pid_file_name = signal_background_pid_file_names[0]
background_pid_file_name = signal_background_pid_file_names[1]

signal_id = widget_info(Event.top, find_by_uname='signal_pid_text')
background_id = widget_info(Event.top, find_by_uname='background_pid_text')

background_selection = (*global).selection_background
background_2_selection = (*global).selection_background_2

full_text = "Signal and background selection have been saved"
text = "Signal & background selection - SAVED"

;populate signal and background pid file name in data reduction tab
pid_file_names = get_last_part_of_pid_file_names(signal_pid_file_name, $
                                                 background_pid_file_name)

produce_pid_files, Event, signal_pid_file_name, background_pid_file_name

;output full name of pid files in log-book
full_text = " - signal Pid file name is: " + signal_pid_file_name
widget_control, full_view_info, set_value=full_text, /append

(*global).signal_pid_file_name = signal_pid_file_name

full_text = " - background Pid file name is: " + background_pid_file_name
widget_control, background_id, set_value=pid_file_names[1]
(*global).background_pid_file_name = background_pid_file_name

widget_control, view_info, set_value=text, /append
widget_control, full_view_info, set_value=full_text, /append

widget_control, signal_id, set_value=pid_file_names[0]

check_status_to_validate_go, Event

end





pro produce_pid_files, Event, signal_pid_file_name, background_pid_file_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;signal selection
x1_signal = (*global).x1_signal
x2_signal = (*global).x2_signal
y1_signal = (*global).y1_signal
y2_signal = (*global).y2_signal

XYsignal = reorder(x1_signal, x2_signal, y1_signal, y2_signal)

;create output file
create_signal_pid_array_file, XYsignal, signal_pid_file_name

;background selection
x1_back = (*global).x1_back
x2_back = (*global).x2_back
y1_back = (*global).y1_back
y2_back = (*global).y2_back

XYbackground = reorder(x1_back, x2_back, y1_back, y2_back)

;background selection #2
x1_back_2 = (*global).x1_back_2
x2_back_2 = (*global).x2_back_2
y1_back_2 = (*global).y1_back_2
y2_back_2 = (*global).y2_back_2

XYbackground_2 = reorder(x1_back_2, x2_back_2, y1_back_2, y2_back_2)

;create output file
create_background_pid_array_file, $
  Event, $  
  XYsignal, $
  XYbackground, $
  XYbackground_2, $
  background_pid_file_name

end








pro background_list_group_eventcb, Event

;check value of selection
id = widget_info(Event.top, FIND_BY_UNAME='background_list_group')
WIDGET_CONTROL, id, GET_VALUE = value

back_info = widget_info(Event.top, find_by_uname='background_file_base')

if (value EQ 0) then begin 
    widget_control, back_info, map=1
endif else begin
    widget_control, back_info, map=0
endelse

end


pro background_list_group_eventcb_REF_M, Event

;check value of selection
id = widget_info(Event.top, FIND_BY_UNAME='background_list_group_REF_M')
WIDGET_CONTROL, id, GET_VALUE = value

back_info = widget_info(Event.top, find_by_uname='background_file_base_REF_M')

if (value EQ 0) then begin 
    widget_control, back_info, map=1
endif else begin
    widget_control, back_info, map=0
endelse

end



pro normalization_list_group_eventcb_REF_L, Event

;check value of selection
id = widget_info(Event.top, FIND_BY_UNAME='normalization_list_group_REF_L')
WIDGET_CONTROL, id, GET_VALUE = value

norm_info = widget_info(Event.top, find_by_uname='norm_run_number_base')

if (value EQ 0) then begin 
    widget_control, norm_info, map=1
endif else begin
    widget_control, norm_info, map=0
endelse

check_status_to_validate_go, Event

end



pro normalization_list_group_eventcb_REF_M, Event

;check value of selection
id = widget_info(Event.top, FIND_BY_UNAME='normalization_list_group_REF_M')
WIDGET_CONTROL, id, GET_VALUE = value

norm_info = widget_info(Event.top, find_by_uname='norm_run_number_base')

if (value EQ 0) then begin 
    widget_control, norm_info, map=1
endif else begin
    widget_control, norm_info, map=0
endelse

check_status_to_validate_go, Event

end







pro intermediate_file_output_list_group_eventcb, Event

;check value of intermediate file output
id = widget_info(Event.top, find_by_uname='intermediate_file_output_list_group')
widget_control, id, get_value = value

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;log book ids (full and simple)
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

if ((*global).entering_intermediate_file_output_for_first_time EQ 1) then begin

    if (value EQ 0) then begin  ;display other plots

;display labels on tabs
        intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
        widget_control, intermediate_plot_base, map=1

        ;save status of buttons
        plots_selection_id = widget_info(Event.top, find_by_uname='intermediate_plots_list_group')
        widget_control, plots_selection_id, get_value=value_selection

        (*global).plots_selected = value_selection
        (*global).entering_selection_of_plots_by_yes_button = 1

    endif else begin            ;remove other plots 
        
        intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
        widget_control, intermediate_plot_base, map=0
        
                                ;remove labels on tabs
        tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
        tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
        tab_3_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_base')
        tab_4_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')
        tab_5_id = widget_info(Event.top, $
                               find_by_uname='background_region_from_normalization_region_summed_tof_base')
        widget_control, tab_1_id, base_set_title=''
        widget_control, tab_2_id, base_set_title=''
        widget_control, tab_3_id, base_set_title=''
        widget_control, tab_4_id, base_set_title=''
        widget_control, tab_5_id, base_set_title=''
        
        full_text = 'No intermediate files will be produced'
        text = 'No intermediate plot'
        widget_control, full_view_info, set_value=full_text, /append
        widget_control, view_info, set_value=text, /append
        (*global).entering_selection_of_plots_by_yes_button = 0
        
    endelse

    (*global).entering_intermediate_file_output_for_first_time = 0

endif else begin

    (*global).entering_intermediate_file_output_for_first_time = 1

endelse

end 



pro access_to_list_of_intermediate_plots_eventcb, Event

intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, intermediate_plot_base, map=1

end






pro EXIT_PROGRAM_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;remove temporary file
tmp_folder = (*global).tmp_folder
if (tmp_folder NE '') then begin
    cmd_remove = "rm -r " + tmp_folder
    spawn, cmd_remove
endif

widget_control,Event.top,/destroy

end


pro EXIT_PROGRAM_REF_M, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;remove temporary file
tmp_folder = (*global).tmp_folder
if (tmp_folder NE '') then begin
    cmd_remove = "rm -r " + tmp_folder
    spawn, cmd_remove
endif

widget_control,Event.top,/destroy

end






pro start_data_reduction_button_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument
stop_reduction = 0

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;retrieve values of all input

;retrieve value of signal and background pid file
full_signal_pid_file_name = (*global).signal_pid_file_name
full_background_pid_file_name = (*global).background_pid_file_name

;*****************************
;get normalization run number
;check if we want normalization or not
if (instrument EQ 'REF_L') then begin
    normalization_status_id = widget_info(Event.top, $
                                          find_by_uname='normalization_list_group_REF_L')
endif else begin
    normalization_status_id = widget_info(Event.top, $
                                          find_by_uname='normalization_list_group_REF_M')
endelse
widget_control, normalization_status_id, get_value=norm_flag

;norm_flag=0 means with normalization
if (norm_flag EQ 0) then begin 

    normalization_text_id = widget_info(Event.top, find_by_uname='normalization_text')
    widget_control, normalization_text_id, get_value=run_number_normalization
    
    if (run_number_normalization NE '') then begin
        
                                ;verify format 
        wrong_format = 0
        CATCH, wrong_run_number_format
        
        if (wrong_run_number_format ne 0) then begin
            
            WIDGET_CONTROL, view_info, $
              SET_VALUE="ERROR: normalization run number invalid", /APPEND
            WIDGET_CONTROL, view_info, SET_VALUE="Program Terminated", /APPEND
            text = 'ERROR: normalization run number invalid - ' + run_number_normalization
            WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
            WIDGET_CONTROL, full_view_info, SET_VALUE="Program Terminated", /APPEND
            wrong_format = 1
            stop_reduction = 1
            
        endif else begin
            
;routine use to test format of normalization run number
            a=lonarr(float(run_number_normalization))
            
            if (wrong_format EQ 0) then begin
                
;get full NeXus path
                cmd_findnexus = "findnexus -i" + (*global).instrument
                cmd_findnexus += " " + strcompress(run_number_normalization, /remove_all)
                spawn, cmd_findnexus, full_path_to_nexus_normalization
                
;check if nexus exists
                result = strmatch(full_path_to_nexus_normalization,"ERROR*")
                
                if (result[0] GE 1) then begin
                    
                    find_nexus = 0 ;run# does not exist in archive
                    text = 'Normalization file does not exist'
                    full_text = 'Normalization run number file does not exist (' + $
                      full_path_to_nexus_normalization + ')'
                    stop_reduction = 1
                    
                endif else begin
                    
                    find_nexus = 1 ;run# exist in archive
                    text = 'Normalization file: OK'
                    full_text = 'Normalization file used: ' + full_path_to_nexus_normalization  
                    
                endelse
                
                widget_control, view_info, set_value=text, /append
                widget_control, full_view_info, set_value=full_text, /append
                
            endif
            
        endelse
        
        catch, /cancel
        
    endif else begin
        
        text = 'Please specify a normalization run number'
        full_text = 'Normalization run number: MISSING'
        widget_control, view_info, set_value=text, /append
        widget_control, full_view_info, set_value=full_text, /append
        stop_reduction = 1
        
    endelse

endif

;****************************
;check status of bkg flag
bkg_flag_id = widget_info(Event.top, find_by_uname='background_list_group')
widget_control, bkg_flag_id, get_value=bkg_flag

;*****************************
;get runs_to_process list of files
runs_to_process_text_id = widget_info(Event.top, find_by_uname='runs_to_process_text')
widget_control, runs_to_process_text_id, get_value=runs_to_process

if (runs_to_process NE '') then begin

    runs_array = get_list_of_runs(runs_to_process)
    array_size = size(runs_array)
    array_size = array_size[1]
    array_of_nexus_files = strarr(array_size)
    runs_full_path = strarr(array_size)
    runs_to_use_array = lonarr(array_size)
    nbr_runs_to_use = 0
    
    for i=0,(array_size-1) do begin
        
        cmd_findnexus = "findnexus -i" + instrument
        cmd_findnexus += " " + strcompress(runs_array[i], /remove_all)
        spawn, cmd_findnexus, full_path_to_nexus
        array_of_nexus_files[i]=full_path_to_nexus
        
;create message for view_info
        result = strmatch(array_of_nexus_files[i],"ERROR*")

        if (result[0] GE 1 or full_path_to_nexus EQ '') then begin
            
;        text = 'runs # ' + runs_array[i] + '(input # ' + strcompress(i+1) +'): INVALID'
            full_text = array_of_nexus_files[i] + '(input # ' + $
              strcompress(i+1) + $
              ') does not exist'
            
        endif else begin
            
;        text = 'runs # ' + runs_array[i] + ': OK'
            full_text = 'runs # ' + runs_array[i] + ' OK (' +$
              array_of_nexus_files[i] + ')'
            runs_to_use_array[i]=1
            nbr_runs_to_use += 1
            
        endelse
        
;    widget_control, view_info, set_value=text,/append
        widget_control, full_view_info, set_value=full_text,/append
        
    endfor
    
;produce final list of runs to use
    if (nbr_runs_to_use GT 0) then begin
        runs_number = lonarr(nbr_runs_to_use)
        j=0
        for i=0,(array_size-1) do begin
            if (runs_to_use_array[i] EQ 1) then begin
                runs_number[j]=runs_array[i]
                runs_full_path[j]=array_of_nexus_files[i]
            j+=1
            endif
        endfor
        
        valid_run_number = j
        text = strcompress(j) + ' valid run numbers'
        full_text = 'data_reduction will use ' + strcompress(j) + ' run numbers:'
        full_text_2 = "   - run number  " + strcompress(runs_number,/remove_all)
    endif else begin
        
        text = '0 valid run number to use'
        full_text = text
        
    endelse
    
    widget_control, view_info, set_value=text,/append
    widget_control, full_view_info, set_value=full_text,/append
    widget_control, full_view_info, set_value=full_text_2,/append
    
endif else begin
    
    text = 'Please specify at least one run number'
    full_text = 'No Run number has been specified'
    widget_control, view_info, set_value=text, /append
    widget_control, full_view_info, set_value=full_text, /append
    
endelse

;*****************************
;check status of normalize bkg
norm_bkg_id = widget_info(Event.top, find_by_uname='norm_background_list_group')
widget_control, norm_bkg_id, get_value=norm_bkg_value

;*****************************
;check status of intermediate outputs
if (instrument EQ 'REF_L') then begin
    
    interm_id = widget_info(Event.top, find_by_uname='intermediate_file_output_list_group')
    
endif else begin
    
    interm_id = widget_info(Event.top, find_by_uname='intermediate_file_output_list_group_REF_M')
    
endelse

widget_control, interm_id, get_value=interm_status

if (instrument EQ 'REF_M') then begin
    
    array_of_parameters = retrieve_REF_M_parameters(Event)
    wave_min = array_of_parameters[0]
    wave_max = array_of_parameters[1]
    wave_width = array_of_parameters[2]
    detector_angle_rad = array_of_parameters[3]
    detector_angle_err = array_of_parameters[4]
    
endif 

if (instrument EQ 'REF_L') then begin

;start command line for REF_L
    REF_L_cmd_line = "reflect_tofred_batch " 
   
;add list of NeXus run numbers
    runs_text = ""
    for i=0,(nbr_runs_to_use-1) do begin
        runs_text += strcompress(runs_number[i],/remove_all) + " "
    endfor
    REF_L_cmd_line += runs_text
    
;normalization
    if (norm_flag EQ 0) then begin
        
        norm_cmd = " --norm=" + strcompress(run_number_normalization,/remove_all)
        REF_L_cmd_line += norm_cmd
        
    endif
    
REF_L_cmd_line += " -- "

;signal Pid file flag
    signal_pid_cmd = " --signal-roi-file=" + full_signal_pid_file_name
    REF_L_cmd_line += signal_pid_cmd
    
;background Pid file flag
    bkg_pid_cmd = " --bkg-roi-file=" + full_background_pid_file_name 
    REF_L_cmd_line += bkg_pid_cmd
    
;background flag
if (bkg_flag EQ 1) then begin
    REF_L_cmd_line += " --no-bkg"
endif

;--no-norm-bkg
    if (norm_bkg_value EQ 1) then begin
        norm_bkg_cmd = " --no-norm-bkg"
        REF_L_cmd_line += norm_bkg_cmd
    endif
    
;--dump_all or various plots
    if (interm_status EQ 0) then begin
        list_of_plots = (*global).plots_selected
        
        interm_plot_cmd = ""
;.sdc 
        if (list_of_plots[0] EQ 1) then begin
            interm_plot_cmd += " --dump-specular"
        endif
        
;.sub
        if (list_of_plots[2] EQ 1) then begin
            interm_plot_cmd += " --dump-sub"
        endif
        
;.norm
        if (list_of_plots[3] EQ 1) then begin
            interm_plot_cmd += " --dump-norm"
        endif
        
        REF_L_cmd_line += interm_plot_cmd
    endif    
    
endif else begin ;for REF_M

;start command line for REF_M
    REF_M_cmd_line = "reflect_reduction "

;add list of NeXus run numbers
    runs_text = ""
    REF_M_cmd_line += full_path_to_nexus_normalization
    
;normalization
    if (norm_flag EQ 0) then begin
    
    norm_cmd = " --norm=" + strcompress(run_number_normalization,/remove_all)
    REF_M_cmd_line += norm_cmd

endif

;signal Pid file flag
signal_pid_cmd = " --signal-roi-file=" + full_signal_pid_file_name
REF_M_cmd_line += signal_pid_cmd

;background Pid file flag
bkg_pid_cmd = " --bkg-roi-file=" + full_background_pid_file_name 
REF_M_cmd_line += bkg_pid_cmd

;background flag
if (bkg_flag EQ 1) then begin
    REF_M_cmd_line += " --no-bkg"
endif

;--no-norm-bkg
if (norm_bkg_value EQ 1) then begin
    norm_bkg_cmd = " --no-norm-bkg"
    REF_M_cmd_line += norm_bkg_cmd
endif

;--dump_all or various plots
if (interm_status EQ 0) then begin
    list_of_plots = (*global).plots_selected

    interm_plot_cmd = ""
;.sdc 
    if (list_of_plots[0] EQ 1) then begin
        interm_plot_cmd += " --dump-specular"
    endif
    
;.sub
    if (list_of_plots[2] EQ 1) then begin
        interm_plot_cmd += " --dump-sub"
    endif
    
;.norm
    if (list_of_plots[3] EQ 1) then begin
        interm_plot_cmd += " --dump-norm"
    endif

    REF_M_cmd_line += interm_plot_cmd

endif

;min, max and width angles
    l_bins_cmd = " --l-bins=" + strcompress(wave_min,/remove_all)
    l_bins_cmd += "," + strcompress(wave_max,/remove_all)
    l_bins_cmd += "," + strcompress(wave_width,/remove_all)
    
    REF_M_cmd_line += l_bins_cmd    
    
;detector_angle
    det_angle_cmd = " --det-angle="      
    det_angle_cmd += strcompress(detector_angle_rad,/remove_all)
    det_angle_cmd += "," + strcompress(detector_angle_err,/remove_all)
    
    REF_M_cmd_line += det_angle_cmd
    
endelse

text = "Processing data reduction....."
widget_control, view_info, set_value=text,/append
full_text = " Data Reduction is running using the following command line:"
widget_control, full_view_info, set_value=full_text,/append

if (instrument EQ 'REF_L') then begin
    full_text = "> " + REF_L_cmd_line
    cmd_line = REF_L_cmd_line
endif else begin
    full_text = "> " + REF_M_cmd_line
    cmd_line = REF_M_cmd_line
endelse

widget_control, full_view_info, set_value=full_text,/append

starting_time = systime(1)

widget_control,/hourglass
spawn, cmd_line, listening   ;REMOVE_ME

text = "...DONE"
ending_time = systime(1)

total_processing_time = ending_time - starting_time
full_text = '...DONE in ' + strcompress(total_processing_time,/remove_all) + ' s'

widget_control, full_view_info, set_value=full_text,/append
widget_control, view_info, set_value=text,/append

text = 'Plotting output main output file....'
main_output_file_name = produce_output_file_name(Event, (*global).run_number, '.txt')
(*global).main_output_file_name = main_output_file_name
full_text = 'Plotting main output file: ' + main_output_file_name
widget_control, full_view_info, set_value=full_text,/append
widget_control, view_info, set_value=text,/append

;plot main .txt file
draw_id = widget_info(Event.top, find_by_uname='data_reduction_plot')
plot_reduction, $
  Event, $
  main_output_file_name, $
  draw_id, $
  "Intensity vs. Wavelength"

text = '...done'
full_text = '...done'
widget_control, full_view_info, set_value=full_text,/append
widget_control, view_info, set_value=text,/append

widget_control,hourglass=0

;reactivate appropriate refresh buttons and plot data
refresh_main_plot_id = widget_info(Event.top, find_by_uname='refresh_main_plot_button')
widget_control, refresh_main_plot_id, sensitive=1

;remove_me
print, 'list_of_plots: ', list_of_plots

if (list_of_plots[0] EQ 1) then begin ;tab_1
    tab_1_refresh_button = widget_info(Event.top,find_by_uname='signal_region_refresh_plot_button')
    draw_id = widget_info(Event.top, find_by_uname='signal_region_draw')
    
    widget_control, tab_1_refresh_button, sensitive=1
    output_1_file_name = produce_output_file_name(Event, (*global).run_number, '.sdc')
    plot_reduction, $
      Event, $
      output_1_file_name, $
      draw_id, $
      "plot #1"
endif

if (list_of_plots[1] EQ 1) then begin ;tab_2
    tab_2_refresh_button = widget_info(Event.top,find_by_uname='background_refresh_plot_button')
    draw_id = widget_info(Event.top, find_by_uname='background_summed_tof_draw')

    widget_control, tab_2_refresh_button, sensitive=1
    output_2_file_name = produce_output_file_name(Event, (*global).run_number, '.bkg')
    plot_reduction, $
      Event, $
      output_2_file_name, $
      draw_id, $
      "plot #2"
endif

if (list_of_plots[2] EQ 1) then begin ;tab_3
    tab_3_refresh_button = widget_info(Event.top,find_by_uname='signal_refresh_plot_button')
    draw_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_draw')

    widget_control, tab_3_refresh_button, sensitive=1
    output_3_file_name = produce_output_file_name(Event, (*global).run_number, '.sub')
    plot_reduction, $
      Event, $
      output_3_file_name, $
      draw_id, $
      "plot #3"
endif

if (list_of_plots[3] EQ 1) then begin ;tab_4
    tab_4_refresh_button = widget_info(Event.top,find_by_uname='normalization_refresh_plot_button')
    draw_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_draw')

    widget_control, tab_4_refresh_button, sensitive=1
    output_4_file_name = produce_output_file_name(Event, (*global).run_number, '.nom')
    plot_reduction, $
      Event, $
      output_4_file_name, $
      draw_id, $
      "plot #4"
endif

if (list_of_plots[4] EQ 1) then begin ;tab_5
    tab_5_refresh_button = widget_info(Event.top,find_by_uname='background_2_refresh_plot_button')
    draw_id = widget_info(Event.top,$
                          find_by_uname='background_region_from_normalization_region_summed_tof_draw')

    widget_control, tab_5_refresh_button, sensitive=1
    output_5_file_name = produce_output_file_name(Event, (*global).run_number, '.bnk')
    plot_reduction, $
      Event, $
      output_5_file_name, $
      draw_id, $
      "plot #5"
endif

end




pro refresh_plot_button_eventcb, Event, drawing_uname

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

draw_id = widget_info(Event.top, find_by_uname=drawing_uname)

case drawing_uname of
    
    'data_reduction_plot': begin
        title='Intensity vs. Wavelength'
        print, 'title is: ', title
    end
    'signal_region_draw' : begin
        title=''
        print, 'inside signal_region_draw'
    end
    'background_summed_tof_draw' : begin
        title=''
        print, 'background_summed_tof_draw'
    end
    'signal_region_summed_tof_draw' : begin
        title=''
        print, 'signal_region_summed_tof_draw'
    end
    'normalization_region_summed_tof_draw' : begin
        title=''
        print, 'normalization_region_summed_tof_draw'    
    end
    'background_region_from_normalization_region_summed_tof_draw' : begin
        title = ''
        print, 'background_region_from_normalization_region_summed_tof_draw'
    end

endcase

plot_reduction, $
  Event, $
  (*global).main_output_file_name, $
  draw_id, $
  title

end


pro intermediate_plots_list_validate_eventcb,Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

list_of_plots_id = widget_info(Event.top, find_by_uname='intermediate_plots_list_group')
widget_control, list_of_plots_id, get_value=value

;log book ids (full and simple)
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;index 1 of array: .sdc (signal region summed TOF)
;index 2 of array: .bkg (background summed TOL)
;index 3 of array: .sub (signal region summed TOF)
;index 4 of array: .nom (normalization region summed TOF)
;index 5 of array: .bnk (background region normalization summed TOF)

indx0 = value[0]
indx1 = value[1]
indx2 = value[2]
indx3 = value[3]
indx4 = value[4]

number_of_plots_selected = 0

full_text = 'Name of intermediate plots that will be plotted:'
widget_control, full_view_info, set_value=full_text, /append

tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
if (indx0 EQ 1) then begin ;signal region summed TOF

    widget_control, tab_1_id, base_set_title='Signal'
    number_of_plots_selected += 1
    
    full_text = ' - Signal region summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    widget_control, tab_1_id, base_set_title=''

endelse

;back_id = widget_info(Event.top, find_by_uname='background_list_group')
;widget_control, back_id, get_value=bkg_flag  ;0:with bkg    1:no bkg

tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
if (indx1 EQ 1) then begin

    widget_control, tab_2_id, base_set_title='Background'
    number_of_plots_selected += 1

    full_text = ' - Background summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    ;remove this plot from the list of selected plots
    indx1 = 0
    new_value = [indx0, indx1, indx2, indx3, indx4]
    
    widget_control,list_of_plots_id,set_value=new_value
    widget_control, tab_2_id, base_set_title=''

endelse

tab_3_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_base')
if (indx2 EQ 1) then begin ;signal region summed TOF

    widget_control, tab_3_id, base_set_title='Signal region with background'
    number_of_plots_selected += 1

    full_text = ' - Signal region summed TOF after subtracting the background'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    widget_control, tab_3_id, base_set_title=''

endelse

if (instrument EQ 'REF_L') then begin
    norm_id = widget_info(Event.top, find_by_uname='normalization_list_group_REF_L')
endif else begin
    norm_id = widget_info(Event.top, find_by_uname='normalization_list_group_REF_M')
endelse
widget_control, norm_id, get_value=norm_flag  ;0:with norm    1:no normalization

tab_4_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')
if (indx3 EQ 1 AND norm_flag EQ 0) then begin

    widget_control, tab_4_id, base_set_title='Normalization'
    number_of_plots_selected += 1

    full_text = ' - Normalization region summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    indx3 = 0
    widget_control, tab_4_id, base_set_title=''

endelse

tab_5_id = widget_info(Event.top, $
                       find_by_uname='background_region_from_normalization_region_summed_tof_base')
if (indx4 EQ 1 AND norm_flag EQ 0) then begin

    widget_control, tab_5_id, base_set_title='Background from normalization'
    number_of_plots_selected += 1

    full_text = ' - Background region from normalization summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    indx4 = 0
    widget_control, tab_5_id, base_set_title=''

endelse

intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, intermediate_plot_base, map=0

;if none of the plots have been selected change status of intermediate
;plots to NO
if (number_of_plots_selected EQ 0) then begin

    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group')
    widget_control, inter_id, set_value=1
    full_text = ' NONE'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin
    
    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group')
    widget_control, inter_id, set_value=0
    
endelse

    text = 'Number of plots selected: '+ strcompress(number_of_plots_selected,/remove_all)
    widget_control, view_info, set_value=text, /append

(*global).plots_selected = [indx0,indx1,indx2,indx3,indx4]


end






pro intermediate_plots_list_cancel_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, intermediate_plot_base, map=0

;reinitialize status of plots
value_selection = (*global).plots_selected
                            
plots_selection_id = widget_info(Event.top, find_by_uname='intermediate_plots_list_group')
widget_control, plots_selection_id, set_value=value_selection

;turn off plot selection if previous array was [0,0,0,0,0]
if (value_selection[0] EQ 0 AND $
    value_selection[1] EQ 0 AND $
    value_selection[2] EQ 0 AND $
    value_selection[3] EQ 0 AND $
    value_selection[4] EQ 0) then begin

    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group')
    widget_control, inter_id, set_value=1

endif

if ((*global).entering_selection_of_plots_by_yes_button EQ 1) then begin
 
    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group')
    widget_control, inter_id, set_value=1

endif   
  
(*global).entering_selection_of_plots_by_yes_button = 0

end




;plot routine that can plot the main plot or any of the intermediate plots
pro plot_reduction, Event, plot_file_name, draw_id, title

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;CATCH, wrong_text_file

;if (wrong_text_file ne 0) then begin

;	WIDGET_CONTROL, view_info, SET_VALUE="ERROR: Invalid .txt file", /APPEND
;	WIDGET_CONTROL, view_info, SET_VALUE="Program Terminated", /APPEND

;endif else begin

openr,u,plot_file_name,/get
fs = fstat(u)

;define an empty string variable to hold results from reading the file
tmp  = ''
tmp0 = ''
tmp1 = ''
tmp2 = ''

flt0 = -1.0
flt1 = -1.0
flt2 = -1.0

Nelines = 0L
Nndlines = 0L
Ndlines = 0L
onebyte = 0b

while (NOT eof(u)) do begin
    
    readu,u,onebyte             ;,format='(a1)'
    fs = fstat(u)
                                ;print,'onebyte: ',onebyte
    
                                ;rewinded file pointer one character
    if fs.cur_ptr EQ 0 then begin
        point_lun,u,0
    endif else begin
        point_lun,u,fs.cur_ptr - 1
    endelse
    
    true = 1
    case true of
        
        ((onebyte LT 48) OR (onebyte GT 57)): begin
                                ;case where we have non-numbers
            Nelines = Nelines + 1
                                ;print,'Non-data Line: ',Nndlines
            readf,u,tmp
        end
        
        else: begin
                                ;case where we (should) have data
            Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
            
            catch, Error_Status
            if Error_status NE 0 then begin
;			Print, 'Handling case where we only have the wavelength bin and no data...'
;			print, 'This case occurs in the last line of the data file.'
;     		PRINT, 'Error index: ', Error_status
;      		PRINT, 'Error message: ', !ERROR_STATE.MSG
;			Print, 'Handling Error Now'
                                ;do something to handle error condition...
                                ;append the last number to flt0
                flt0 = [flt0,float(tmp0)]
                                ;strip -1 from beginning of each array
                flt0 = flt0[1:*]
                flt1 = flt1[1:*]
                flt2 = flt2[1:*]
                                ;you're done now...
; 			Print,'Error Handling Complete'
                CATCH, /CANCEL
            endif else begin
                readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                flt0 = [flt0,float(tmp0)]
                flt1 = [flt1,float(tmp1)]
                flt2 = [flt2,float(tmp2)]
                
            endelse
            
        end
    endcase
    
endwhile

;view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
;text = 'Number of non-data lines: ' + strcompress(Nndlines,/remove_all)
;WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;text = 'Number of data lines: ' + strcompress(Ndlines,/remove_all)
;WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;window,0
;!p.multi=[0,2,2]
;plot,flt0,title='Wavelength'
;plot,flt1,title='Intensity'
;plot,flt2,title='Sigma'

WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

plot,flt0,flt1,title=title
errplot,flt0,flt1 - flt2, flt1 + flt2,color = 100 ;'0xff00ffxl'

;!p.multi=0

close,u
free_lun,u

;endelse

;CATCH, /CANCEL

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$












;get interm. window
pro access_to_list_of_intermediate_plots_eventcb, Event

list_of_plots_id = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, list_of_plots_id, map=1

end


;cancel button inside inter. window
pro intermediate_plots_list_cancel_eventcb_REF_M, Event   

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, intermediate_plot_base, map=0

;reinitialize status of plots
value_selection = (*global).plots_selected
                            
plots_selection_id = widget_info(Event.top, find_by_uname='intermediate_plots_list_group')
widget_control, plots_selection_id, set_value=value_selection

inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group_REF_M')

;turn off plot selection if previous array was [0,0,0,0,0]
if (value_selection[0] EQ 0 AND $
    value_selection[1] EQ 0 AND $
    value_selection[2] EQ 0 AND $
    value_selection[3] EQ 0 AND $
    value_selection[4] EQ 0) then begin

    widget_control, inter_id, set_value=1

endif

if ((*global).entering_selection_of_plots_by_yes_button EQ 1) then begin
 
    widget_control, inter_id, set_value=1

endif   
  
(*global).entering_selection_of_plots_by_yes_button = 0

end


;when selection yes or no
pro intermediate_file_output_list_group_eventcb_REF_M, Event   

;check value of intermediate file output
id = widget_info(Event.top, find_by_uname='intermediate_file_output_list_group_REF_M')
widget_control, id, get_value = value

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;log book ids (full and simple)
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

if ((*global).entering_intermediate_file_output_for_first_time EQ 1) then begin

    if (value EQ 0) then begin  ;display other plots

;display labels on tabs
        intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
        widget_control, intermediate_plot_base, map=1

        ;save status of buttons
        plots_selection_id = widget_info(Event.top, find_by_uname='intermediate_plots_list_group')
        widget_control, plots_selection_id, get_value=value_selection

        (*global).plots_selected = value_selection
        (*global).entering_selection_of_plots_by_yes_button = 1        
        
    endif else begin            ;remove other plots 
        
        intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
        widget_control, intermediate_plot_base, map=0
        
                                ;remove labels on tabs
        tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
        tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
        tab_3_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_base')
        tab_4_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')
        tab_5_id = widget_info(Event.top, $
                               find_by_uname='background_region_from_normalization_region_summed_tof_base')
        widget_control, tab_1_id, base_set_title=''
        widget_control, tab_2_id, base_set_title=''
        widget_control, tab_3_id, base_set_title=''
        widget_control, tab_4_id, base_set_title=''
        widget_control, tab_5_id, base_set_title=''
        
        full_text = 'No intermediate files will be produced'
        text = 'No intermediate plot'
        widget_control, full_view_info, set_value=full_text, /append
        widget_control, view_info, set_value=text, /append

        (*global).entering_selection_of_plots_by_yes_button = 0        

    endelse

    (*global).entering_intermediate_file_output_for_first_time = 0

endif else begin

    (*global).entering_intermediate_file_output_for_first_time = 1

endelse

end 


pro intermediate_plots_list_validate_eventcb_REF_M,Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

list_of_plots_id = widget_info(Event.top, find_by_uname='intermediate_plots_list_group')
widget_control, list_of_plots_id, get_value=value

;log book ids (full and simple)
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;index 1 of array: .sdc (signal region summed TOF)
;index 2 of array: .bkg (background summed TOL)
;index 3 of array: .sub (signal region summed TOF)
;index 4 of array: .nom (normalization region summed TOF)
;index 5 of array: .bnk (background region normalization summed TOF)

indx0 = value[0]
indx1 = value[1]
indx2 = value[2]
indx3 = value[3]
indx4 = value[4]

number_of_plots_selected = 0

full_text = 'Name of intermediate plots that will be plotted:'
widget_control, full_view_info, set_value=full_text, /append


tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
if (indx0 EQ 1) then begin ;signal region summed TOF

    widget_control, tab_1_id, base_set_title='Signal'
    number_of_plots_selected += 1
    
    full_text = ' - Signal region summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    widget_control, tab_1_id, base_set_title=''

endelse

;back_id = widget_info(Event.top, find_by_uname='background_list_group')
;widget_control, back_id, get_value=bkg_flag  ;0:with bkg    1:no bkg

tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
if (indx1 EQ 1) then begin

    widget_control, tab_2_id, base_set_title='Background'
    number_of_plots_selected += 1

    full_text = ' - Background summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    ;remove this plot from the list of selected plots
    indx1 = 0
    new_value = [indx0, indx1, indx2, indx3, indx4]
    
    widget_control,list_of_plots_id,set_value=new_value
    widget_control, tab_2_id, base_set_title=''

endelse

tab_3_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_base')
if (indx2 EQ 1) then begin ;signal region summed TOF

    widget_control, tab_3_id, base_set_title='Signal region with background'
    number_of_plots_selected += 1

    full_text = ' - Signal region summed TOF after subtracting the background'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    widget_control, tab_3_id, base_set_title=''

endelse

norm_id = widget_info(Event.top, find_by_uname='norm_background_list_group')
widget_control, norm_id, get_value=norm_flag  ;0:with norm    1:no normalization

tab_4_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')
if (indx3 EQ 1 AND norm_flag EQ 0) then begin

    widget_control, tab_4_id, base_set_title='Normalization'
    number_of_plots_selected += 1

    full_text = ' - Normalization region summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    indx3 = 0
    widget_control, tab_4_id, base_set_title=''

endelse

tab_5_id = widget_info(Event.top, $
                       find_by_uname='background_region_from_normalization_region_summed_tof_base')
if (indx4 EQ 1 AND norm_flag EQ 0) then begin

    widget_control, tab_5_id, base_set_title='Background from normalization'
    number_of_plots_selected += 1

    full_text = ' - Background region from normalization summed TOF'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin

    indx4 = 0
    widget_control, tab_5_id, base_set_title=''

endelse

intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, intermediate_plot_base, map=0

;if none of the plots have been selected change status of intermediate
;plots to NO
if (number_of_plots_selected EQ 0) then begin

    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group_REF_M')
    widget_control, inter_id, set_value=1
    full_text = ' NONE'
    widget_control, full_view_info, set_value=full_text, /append

endif else begin
    
    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group_REF_M')
    widget_control, inter_id, set_value=0
    
endelse

    text = 'Number of plots selected: '+ strcompress(number_of_plots_selected,/remove_all)
    widget_control, view_info, set_value=text, /append

(*global).plots_selected = [indx0,indx1,indx2,indx3,indx4]

end





;check status of all text boxes and buttons to validate or not GO Data
;Reduction
pro check_status_to_validate_go, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

status=0
instrument = (*global).instrument
start_data_reduction_button_id = widget_info(Event.top,$
                                             find_by_uname='start_data_reduction_button')

;check if there is a signal pid file 
signal_pid_text_id = widget_info(Event.top,find_by_uname='signal_pid_text')
widget_control, signal_pid_text_id, get_value=signal_pid_text

;check if there is background pid file
bkg_pid_text_id = widget_info(Event.top,find_by_uname='background_pid_text')
widget_control, bkg_pid_text_id, get_value=bkg_pid_text

;check status of normalization flag
if (instrument EQ 'REF_L') then begin
    norm_list_group_id = widget_info(Event.top, $
                                     find_by_uname='normalization_list_group_REF_L')
endif else begin
    norm_list_group_id = widget_info(Event.top, $
                                     find_by_uname='normalization_list_group_REF_M')
endelse

widget_control, norm_list_group_id, get_value=norm_list_group
normalization_text = "anything"
if (norm_list_group EQ 0) then begin
    normalization_text_id = widget_info(Event.top, find_by_uname='normalization_text')
    widget_control, normalization_text_id, get_value=normalization_text
endif

;check if runs number not empty
runs_to_process_text_id = widget_info(Event.top, find_by_uname='runs_to_process_text')
widget_control, runs_to_process_text_id, get_value=runs_to_process_text

if (instrument EQ 'REF_M') then begin

wave_min_id = widget_info(Event.top, find_by_uname='wavelength_min_text')
widget_control, wave_min_id, get_value=wave_min

wave_max_id = widget_info(Event.top, find_by_uname='wavelength_max_text')
widget_control, wave_max_id, get_value=wave_max

wave_width_id = widget_info(Event.top, find_by_uname='wavelength_width_text')
widget_control, wave_width_id, get_value=wave_width

det_angle_value_id = widget_info(Event.top, find_by_uname='detector_angle_value')
widget_control, det_angle_value_id, get_value=det_angle_value

det_angle_err_id = widget_info(Event.top, find_by_uname='detector_angle_err')
widget_control, det_angle_err_id, get_value=det_angle_err

endif

if (strcompress(signal_pid_text,/remove_all) NE '' AND $
    strcompress(bkg_pid_text,/remove_all) NE '' AND $
    strcompress(normalization_text,/remove_all) NE '' AND $
    strcompress(runs_to_process_text,/remove_all)) then begin

    status = 1

    if (instrument EQ 'REF_M') then begin
        

        wave_min = strcompress(wave_min[0],/remove_all)
        wave_max = strcompress(wave_max[0],/remove_all)
        wave_width = strcompress(wave_width[0],/remove_all)
        det_angle_value = strcompress(det_angle_value[0],/remove_all)
        det_angle_err = strcompress(det_angle_err[0],/remove_all)

        if (wave_min NE '' AND $
            wave_max NE '' AND $
            wave_width NE '' AND $
            det_angle_value NE '' AND $
            det_angle_err NE '') then begin
            
            status = 1

        endif else begin

            status = 0

        endelse
        
    endif
    
endif

if (status EQ 1) then begin

    widget_control,start_data_reduction_button_id, sensitive=1

endif else begin

    widget_control,start_data_reduction_button_id, sensitive=0

endelse

end




;reach when various text boxes are reached
pro normalization_text_eventcb, Event
check_status_to_validate_go, Event
end

pro wavelength_min_text_eventcb, Event
check_status_to_validate_go, Event
end

pro wavelength_max_text_eventcb, Event
check_status_to_validate_go, Event
end

pro wavelength_width_text_eventcb, Event
check_status_to_validate_go, Event
end

pro detector_angle_value_eventcb, Event
check_status_to_validate_go, Event
end

pro detector_angle_err_eventcb, Event
check_status_to_validate_go, Event
end

pro signal_pid_text_eventcb, Event
check_status_to_validate_go, Event
end

pro background_pid_text_eventcb, Event
check_status_to_validate_go, Event
end

pro nexus_run_number_box_eventcb, Event
check_status_to_validate_go, Event
end

pro runs_to_process_text_eventcb, Event
check_status_to_validate_go, Event
end
