pro get_run_number_from_full_nexus_name,event, full_nexus_name,instr

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;split by "/"
split_full_name = strsplit(full_nexus_name,'/',/extract,/regex,count=length)
nexus_name = split_full_name[length-1]

;remove instr name
instr_slash = instr + "_"
run_number_nxs = strsplit(nexus_name,instr_slash,/extract,/regex)

;remoe nxs extension
nxs_extension = ".nxs"
help, run_number_nxs

run_number = strsplit(run_number_nxs,nxs_extension,/extract,/regex)

(*global).run_number = run_number[0]

end


pro erase_plots, Event, instr

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (instr EQ "REF_L") then begin

    id=lonarr(7)
    id[0] = widget_info(Event.top, find_by_uname="VIEW_DRAW_COUNTS_TOF_REF_L")
    id[1] = widget_info(Event.top, find_by_uname="VIEW_DRAW_SUM_Y_REF_L")
    id[2] = widget_info(Event.top, find_by_uname="VIEW_DRAW_Y_REF_L")
    id[3] = widget_info(Event.top, find_by_uname="VIEW_DRAW_SUM_X_REF_L")
    id[4] = widget_info(Event.top, find_by_uname="VIEW_DRAW_X_REF_L")
    id[5] = widget_info(Event.top, find_by_uname="VIEW_DRAW_TOF_REF_L")
    id[6] = widget_info(Event.top, find_by_uname="VIEW_DRAW_REF_L")

    for i=0,6 do begin
	WIDGET_CONTROL, id[i], GET_VALUE=id_value
        wset, id_value
        erase
    endfor
    
endif else begin
    
    id=lonarr(8)
    id[0] = widget_info(Event.top, find_by_uname="VIEW_DRAW")
    id[1] = widget_info(Event.top, find_by_uname="VIEW_DRAW_TOF")
    id[2] = widget_info(Event.top, find_by_uname="VIEW_DRAW_X")
    id[3] = widget_info(Event.top, find_by_uname="VIEW_DRAW_SELECTION_X")
    id[4] = widget_info(Event.top, find_by_uname="VIEW_DRAW_X_REF_M_HIDDING")
    id[5] = widget_info(Event.top, find_by_uname="VIEW_DRAW_Y")
    id[6] = widget_info(Event.top, find_by_uname="VIEW_DRAW_SELECTION_Y")
    id[7] = widget_info(Event.top, find_by_uname="VIEW_DRAW_REDUCTION")

    for i=0,7 do begin
	WIDGET_CONTROL, id[i], GET_VALUE=id_value
        wset, id_value
        erase
    endfor
    
endelse


end





FUNCTION find_full_nexus_name, Event, run_number, instrument    

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -i" + instrument + " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name

;check if nexus exists
result = strmatch(full_nexus_name,"ERROR*")

if (result GE 1) then begin
    find_nexus = 0
endif else begin
    find_nexus = 1
endelse

(*global).find_nexus = find_nexus

return, full_nexus_name

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




PRO dump_binary_data_REF_L, Event, full_nexus_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_working_path = (*global).tmp_working_path

cmd_dump = "nxdir " + full_nexus_name
cmd_dump += " -p /entry/bank1/data/ --dump "

;get tmp_output_file_name
instr="REF_L"
tmp_output_file_name = get_name_of_tmp_output_file(Event, tmp_working_path, instr)
cmd_dump += tmp_output_file_name

(*global).full_histo_mapped_name = tmp_output_file_name

;display command
view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
text= cmd_dump
widget_control, view_info, set_value=text, /append
text= "Processing....."
widget_control, view_info, set_value=text, /append

spawn, cmd_dump, listening

;display result of command
;text= listening
text="Done"
widget_control, view_info, set_value=text, /append

end





PRO dump_binary_data, Event, full_nexus_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_working_path = (*global).tmp_working_path

cmd_dump = "nxdir " + full_nexus_name
cmd_dump += " -p /entry/bank1/data/ --dump "

;get tmp_output_file_name
instr = "REF_M"
tmp_output_file_name = get_name_of_tmp_output_file(Event, tmp_working_path, instr)
cmd_dump += tmp_output_file_name

(*global).full_histo_mapped_name = tmp_output_file_name

;display command
view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text= cmd_dump
widget_control, view_info, set_value=text, /append
text= "Processing....."
widget_control, view_info, set_value=text, /append

spawn, cmd_dump, listening

;display result of command
;text= listening
text="Done"
widget_control, view_info, set_value=text, /append

end







PRO OPEN_NEXUS_FILE_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;erase all the plots
erase_plots, Event, "REF_L"

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')

;get run#
id_run_number = widget_info(Event.top, FIND_BY_UNAME='RUN_NUMBER_BOX_REF_L')
widget_control, id_run_number, get_value=run_number

if (run_number EQ '') then begin

    text = "!!! Please specify a run number !!! " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text,/append
    
endif else begin

    (*global).run_number = run_number
    
    text = "Open NeXus file of run number " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text,/append
    
;get path to nexus run #
    instrument="REF_L"
    full_nexus_name = find_full_nexus_name(Event, run_number, instrument)
    
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
        dump_binary_data_REF_L, Event, full_nexus_name
        
;read and plot nexus file
        read_and_plot_nexus_file_REF_L, Event
    endelse

endelse

end









PRO OPEN_NEXUS_FILE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;erase all the plots
erase_plots, Event, "REF_M"

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')

;get run#
id_run_number = widget_info(Event.top, FIND_BY_UNAME='RUN_NUMBER_BOX')
widget_control, id_run_number, get_value=run_number

if (run_number EQ '') then begin

    text = "No run number specified" + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text,/append

endif else begin 

    (*global).run_number = run_number
    
    text = "Open NeXus file of run number " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text,/append
    
;get path to nexus run #
    instrument = "REF_M"
    full_nexus_name = find_full_nexus_name(Event, run_number, instrument)
    
;check result of search
    find_nexus = (*global).find_nexus
    if (find_nexus EQ 0) then begin
        text_nexus = "WARNING! NeXus file does not exist"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
    endif else begin
        (*global).full_nexus_name = full_nexus_name
        text_nexus = "(" + full_nexus_name + ")"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
        
;dump binary data of NeXus file into tmp_working_path
        dump_binary_data, Event, full_nexus_name
        
;read and plot nexus file
        read_and_plot_nexus_file, Event
        
    endelse

endelse

end






PRO OPEN_USERS_DEFINED_NEXUS_FILE_, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;erase all the plots
erase_plots, Event, "REF_L"

;get general_infos window id
view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')

nexus_path = (*global).nexus_path
filter = "*.nxs"

;open file
full_nexus_name = dialog_pickfile(path=nexus_path,$
                                  get_path=path,$
                                  title='Select Data File',$
                                  filter=filter)

if full_nexus_name NE '' then begin

	(*global).full_nexus_name = full_nexus_name ; store input filename

;get run_number
        instr="REF_L"
        get_run_number_from_full_nexus_name, Event, full_nexus_name, instr

;dump binary data of NeXus file into tmp_working_path
        dump_binary_data_REF_L, Event, full_nexus_name

;read and plot nexus file
        read_and_plot_nexus_file_REF_L, Event

endif


END











pro read_and_plot_nexus_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;first close previous file if there is one
if (N_ELEMENTS(U)) NE 0 then begin
	close, u
	free_lun,u
endif 

if ((*global).file_already_opened EQ 0) then (*global).file_already_opened = 1

;retrieve data parameters
Nx 		= (*global).Nx
Ny 		= (*global).Ny

;indicate reading data with hourglass icon
widget_control,/hourglass

file = (*global).full_histo_mapped_name

;only read data if valid file given
if file NE '' then begin

	(*global).filename = file ; store input filename
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
	text = "Read and plot NeXus file: " + strcompress(file,/remove_all)
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;put info from NeXus file name
        nexus_filename = (*global).full_nexus_name
        
	view_info = widget_info(Event.top,FIND_BY_UNAME='NEXUS_INFOS')
	WIDGET_CONTROL, view_info, SET_VALUE='Title:'
	cmd = "nxdir " + nexus_filename + " -p /entry/title -o"
	spawn, cmd, listening
	WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND
	
	WIDGET_CONTROL, view_info, SET_VALUE='Notes:', /APPEND
	cmd = "nxdir " + nexus_filename + " -p /entry/notes -o"
	spawn, cmd, listening
	WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND
	
	;determine path	
;	path = "/SNSlocal/users/j35/"   ;REMOVE_ME
        path = (*global).working_path
        cd, path

;	;display path
;	view_info = widget_info(Event.top,FIND_BY_UNAME='PATH_TEXT')
;	WIDGET_CONTROL, view_info, SET_VALUE=path
	(*global).path = path
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
	WIDGET_CONTROL, view_info, SET_VALUE='Reading in data....', /APPEND
	strtime = systime(1)

	openr,u,file,/get

	;find out file info
	fs = fstat(u)
	Nimg = Nx*Ny
	Ntof = fs.size/(Nimg*4L)
	(*global).Ntof = Ntof	;set back in global structure

	data_assoc = assoc(u,lonarr(Ntof))
	
	;make the image array
	img = lonarr(Nx,Ny)
	for i=0L,Nimg-1 do begin
		x = i MOD Nx
		y = i/Nx
;		img[y,x] = total(swap_endian(data_assoc[i]))
		img[x,y] = total(data_assoc[i])
	endfor

	img=transpose(img)

	;load data up in global ptr array
	(*(*global).img_ptr) = img
	(*(*global).data_assoc) = data_assoc
	
	;now turn hourglass back off
	widget_control,hourglass=0

	;put image data in main draw window
	SHOW_DATA,event
	
	;now we can activate 'Refresh' button
	;disable refresh button during ctool
	rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON')
	widget_control,rb_id,sensitive=1

	endtime = systime(1)
	tt_time = string(endtime - strtime)
	text = 'Done in ' + strcompress(tt_time,/remove_all) + ' s'
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	
endif;valid file

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;---------------------------------------------------------------------
PRO info_overflow_REF_M, Event

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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$










;---------------------------------------------------------------------
pro info_overflow_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

overflow_number = (*global).overflow_number

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
WIDGET_CONTROL, view_info, GET_VALUE=text

num_lines = n_elements(text)

if (num_lines gt overflow_number) then begin
	text = text(50:*)
        num_lines = num_lines - 50
	WIDGET_CONTROL, view_info, SET_VALUE=text
endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;---------------------------------------------------------------------
; \brief function that parse the input file name and produced the output file name
; if the output file name exists already, an increment index is added at the end of the 
; name, just before the extension ".txt"
;
; \argument file_name (INPUT) the name of the input file
; \argument file_index (INPUT) the index of the last input file created
;---------------------------------------------------------------------
FUNCTION GetRegionFile, file_name, file_index, part_to_remove, file_extension
	file_name = strsplit(file_name,part_to_remove,/extract,/regex,count=length)     ;to remove the part_to_remove part of the name
	file_name = file_name + '_' + strcompress(file_index,/rem) + file_extension     ;replaced by _#.nxs
	++file_index
	return, file_name
end




;------------------------------------------------------------------------
; \brief function to obtain the top level base widget given an arbitrary widget ID.
;
; \argument wWidget (INPUT)
;-----------------------------------------------------------------------
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



;-----------------------------------------------------------------------------
pro ABOUT_cb, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')

about_text = " "
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " ***** mini ReflPak  v4.0 *****"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " "
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " Developers:"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Steve Miller (millersd@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Peter Peterson (petersonpf@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Michael Reuter (reuterma@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Jean Bilheux (bilheuxjm@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " "
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND

info_overflow_REF_M, Event

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;-----------------------------------------------------------------------------
pro ABOUT_MENU_REF_L_cb, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')

about_text = " "
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " ***** mini ReflPak  v4.0 *****"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " "
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " Developers:"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Steve Miller (millersd@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Peter Peterson (petersonpf@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Michael Reuter (reuterma@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = "     Jean Bilheux (bilheuxjm@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND
about_text = " "
WIDGET_CONTROL, view_info, SET_VALUE=about_text, /APPEND

info_overflow_REF_L, Event

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;---------------------------------------------------------------------------
pro DEFAULT_PATH_cb, Event    ;for REF_M

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

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;-----------------------------
pro SET_DEFAULT_NEXUS_PATH_REF_L, Event    ;for REF_L

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

nexus_path = (*global).nexus_path
nexus_path = dialog_pickfile(path=working_path,/directory)
(*global).nexus_path = nexus_path

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
text = "Working NeXus directory set to:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = nexus_path
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;----------------------------------------------------------------------------
pro DEFAULT_PATH_REF_L_cb, Event    ;for REF_L

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

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
text = "Working directory set to:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = working_path
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;-----------------------------------------------------------------------------
pro DEFAULT_PATH_BUTTON_cb, Event   ;for REF_M

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_path = (*global).default_path

working_path = dialog_pickfile(path=default_path,/directory)

text_id=widget_info(Event.top, FIND_BY_UNAME='DEFAULT_PATH_TEXT')

if (working_path NE '') then begin
	(*global).working_path = working_path
	WIDGET_CONTROL, text_id, SET_VALUE=working_path
endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;---------------------------------------------------------------------------
pro DEFAULT_PATH_BUTTON_REF_L_cb, Event   ;for REF_L

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_path = (*global).default_path

working_path = dialog_pickfile(path=default_path,/directory)

text_id=widget_info(Event.top, FIND_BY_UNAME='DEFAULT_PATH_TEXT')

if (working_path NE '') then begin
	(*global).working_path = working_path
	WIDGET_CONTROL, text_id, SET_VALUE=working_path
endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






;---------------------------------------------------------------------------
pro IDENTIFICATION_GO_cb, Event   ;for REF_M

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
 	'1qg': name = 'Richard Goyette'
	'2zr': name = 'Michael Reuter'
	'ha9': name = 'hailemariam Ambaye'
	'pf9': name = 'Peter Peterson'
	'vyi': name = 'Frank Klose'
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

   (*global).name = name
   working_path = (*global).working_path
   
   tmp_working_path = working_path + (*global).tmp_working_path_extenstion
   (*global).tmp_working_path = tmp_working_path

   tmp_message = "temporary working folder is set to: " + $
     tmp_working_path

   welcome = "Welcome " + strcompress(name,/remove_all)
   welcome += "  (working directory: " + $
     strcompress(working_path,/remove_all) + ")"	
   view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
   WIDGET_CONTROL, view_id, base_set_title= welcome	

   view_id = widget_info(Event.top,FIND_BY_UNAME='IDENTIFICATION_BASE')
   WIDGET_CONTROL, view_id, destroy=1

   ;working path is set
   cd, working_path

   ;check if temporary folder exists (if yes, remove it and recreate it)
   cmd_check = "ls -d " + tmp_working_path
   spawn, cmd_check, listening

   if (listening NE '') then begin
       cmd_remove = "rm -r " + tmp_working_path
       spawn, cmd_remove
   endif

   ;now create tmp folder
   cmd_create = "mkdir " + tmp_working_path
   spawn, cmd_create,  listening

   view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
   text = "LOGIN parameters:"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = "User id           : " + ucams
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = "Name              : " + name
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = "Working directory : " + working_path
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = ""
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   WIDGET_CONTROL, view_info, SET_VALUE=tmp_message, /APPEND

;enable background buttons/draw/text/labels
id_list=['UTILS_MENU',$
         'CTOOL_MENU',$
         'MODE_INFOS',$
         'CURSOR_X_LABEL',$
         'CURSOR_X_POSITION',$
         'CURSOR_Y_LABEL',$
         'CURSOR_Y_POSITION',$
         'NUMBER_OF_COUNTS_VALUE',$
         'NUMBER_OF_COUNTS_LABEL',$
         'SELECTION_INFOS',$
         'PIXELID_INFOS',$
         'MICHAEL_SPACE_LABEL',$
         'WAVELENGTH_LABEL',$
         'WAVELENGTH_MIN_LABEL',$
         'WAVELENGTH_MIN_TEXT',$
         'WAVELENGTH_MIN_A_LABEL',$
         'WAVELENGTH_MAX_LABEL',$
         'WAVELENGTH_MAX_TEXT',$
         'WAVELENGTH_MAX_A_LABEL',$
         'WAVELENGTH_WIDTH_LABEL',$
         'WAVELENGTH_WIDTH_TEXT',$
         'WAVELENGTH_WIDTH_A_LABEL',$
         'FRAME_WAVELENGTH',$
         'DETECTOR_LABEL',$
         'DETECTOR_ANGLE_VALUE',$
         'DETECTOR_ANGLE_PLUS_MINUS',$
         'DETECTOR_ANGLE_ERR',$
         'DETECTOR_ANGLE_UNITS',$
         'FILE_NAME_LABEL',$
         'FILE_NAME_TEXT',$
         'BACKGROUND_SWITCH',$
         'NORMALIZATION_SWITCH',$
         'NORM_FILE_TEXT']

id_list_size = size(id_list)
for i=0,(id_list_size[1]-1) do begin
    id = widget_info(Event.top,FIND_BY_UNAME=id_list[i])
    Widget_Control, id, sensitive=1
endfor

endelse

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;-----------------------------------------------------------------------------
pro IDENTIFICATION_GO_REF_L_cb, Event   ;for REF_L

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

text_id=widget_info(Event.top, FIND_BY_UNAME='IDENTIFICATION_TEXT_REF_L')
WIDGET_CONTROL, text_id, GET_VALUE=character_id
(*global).character_id = character_id

;check 3 characters id
ucams=(*global).ucams

name = ''
case ucams of
	'vuk': name = 'John Ankner'
	'x4t': name = 'Xiaodong Tao'
	'2zr': name = 'Michael Reuter'
	'pf9': name = 'Peter Peterson'
	'j35': name = 'Zizou'
	'mid': name = 'Steve Miller'
	else : name = ''
endcase

if (name EQ '') then begin

;put a message saying that it's an invalid 3 character id

   error_message = "INVALID UCAMS"
   view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_LEFT_REF_L')
   WIDGET_CONTROL, view_id, set_value= error_message	
   view_id = widget_info(Event.top,$
                         FIND_BY_UNAME='ERROR_IDENTIFICATION_RIGHT_REF_L')
   WIDGET_CONTROL, view_id, set_value= error_message	

   view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
   text = "Invalid 3 characters id... please try another user identification id"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   
endif else begin

   (*global).name = name
   working_path = (*global).working_path
   (*global).nexus_path = working_path

   tmp_working_path = working_path + (*global).tmp_working_path_extenstion
   (*global).tmp_working_path = tmp_working_path

   welcome = "Welcome " + strcompress(name,/remove_all)
   welcome += "  (working directory: " + $
     strcompress(working_path,/remove_all) + ")"	
   view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
   WIDGET_CONTROL, view_id, base_set_title= welcome	

   view_id = widget_info(Event.top,FIND_BY_UNAME='IDENTIFICATION_BASE_REF_L')
   WIDGET_CONTROL, view_id, destroy=1

   ;working path is set
   cd, working_path
 
   ;check if temporary folder exists (if yes, remove it and recreate it)
   cmd_check = "ls -d " + tmp_working_path
   spawn, cmd_check, listening

   if (listening NE '') then begin
       cmd_remove = "rm -r " + tmp_working_path
       spawn, cmd_remove
   endif

   ;now create tmp folder
   cmd_create = "mkdir " + tmp_working_path
   spawn, cmd_create,  listening

   view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
   text = "LOGIN parameters:"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = "User id           : " + ucams
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = "Name              : " + name
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = "Working directory : " + working_path
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;enable background buttons/draw/text/labels
id_list=['OPEN_NEXUS_FILE_BUTTON',$
         'RUN_NUMBER_BOX_REF_L',$
         'OPEN_RUN_NUMBER_REF_L']

id_list_size = size(id_list)
for i=0,(id_list_size[1]-1) do begin
    id = widget_info(Event.top,FIND_BY_UNAME=id_list[i])
    Widget_Control, id, sensitive=1
endfor

endelse

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






;---------------------------------------------------------------------------------
pro IDENTIFICATION_TEXT_cb, Event   ;for REF_M

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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;--------------------------------------------------------------------------
pro IDENTIFICATION_TEXT_REF_L_cb, Event   ;for REF_L

view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_LEFT_REF_L')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_RIGHT_REF_L')
WIDGET_CONTROL, view_id, set_value= ''	

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_path = (*global).default_path

text_id=widget_info(Event.top, FIND_BY_UNAME='IDENTIFICATION_TEXT_REF_L')
WIDGET_CONTROL, text_id, GET_VALUE=ucams

(*global).ucams = ucams

working_path = default_path + strcompress(ucams,/remove_all)+ '/'
(*global).working_path = working_path

text_id=widget_info(Event.top, FIND_BY_UNAME='DEFAULT_PATH_TEXT_REF_L')
WIDGET_CONTROL, text_id, SET_VALUE=working_path

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$







;-----------------------------------------------------------------------------
; \brief Empty stub procedure used for autoloading.
;-----------------------------------------------------------------------------
pro extract_data_eventcb
end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;--------------------------------------------------------------------------------
; \brief main function that plot the window
;
; \argument wWidget (INPUT) 
;--------------------------------------------------------------------------------
pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;------------------------------------------------------------------------------
; \brief procedure to image the data
;
; \argument event (INPUT)
;------------------------------------------------------------------------------
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

id = widget_info(Event.top,FIND_BY_UNAME='CTOOL_MENU')
Widget_Control, id, sensitive=1

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;---------------------------------------------------------------------------
; \brief 
;
; \argument event (INPUT) 
;---------------------------------------------------------------------------
pro VIEW_ONBUTTON, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_already_opened = (*global).file_already_opened

;left mouse button
IF ((event.press EQ 1 ) AND (file_already_opened EQ 1)) then begin

   view_info = widget_info(Event.top,FIND_BY_UNAME='MODE_INFOS')
   WIDGET_CONTROL, view_info, SET_VALUE="MODE: INFOS"

   ;get data
   img = (*(*global).img_ptr)
   ;data = (*(*global).data_ptr)
   tmp_tof = (*(*global).data_assoc)
   Nx= (*global).Nx

   x = Event.x
   y = Event.y

   ;set data
   (*global).x = x
   (*global).y = y

   ;put x and y into cursor x and y labels position
   view_info = widget_info(Event.top,FIND_BY_UNAME='CURSOR_X_POSITION')
   WIDGET_CONTROL, view_info, SET_VALUE=strcompress(x)
   view_info = widget_info(Event.top,FIND_BY_UNAME='CURSOR_Y_POSITION')
   WIDGET_CONTROL, view_info, SET_VALUE=strcompress(y)
	

   ;get window numbers - x (hidding)
   view_x = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_X_REF_M_HIDDING')
   WIDGET_CONTROL, view_x, GET_VALUE = view_win_num_x_hidding

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
   wset,view_win_num_x_hidding
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
   ;remember that img is transposed, tmp_tof is not so this is why we switch x<->y
   pixelid=x*Nx+y     

   ;tof_arr=swap_endian(tmp_tof[pixelid])

   tof_arr=(tmp_tof[pixelid])
   plot, tof_arr,title='TOF Axis'	
   ;plot,reform(data(*,y,x)),title='TOF Axis'

endif

;right mouse button
IF ((event.press EQ 4) AND (file_already_opened EQ 1)) then begin

   view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
   text = "Mode: SELECTION"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = " left click to select first corner or
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = " right click to quit SELECTION mode"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

   view_info = widget_info(Event.top,FIND_BY_UNAME='MODE_INFOS')
   WIDGET_CONTROL, view_info, SET_VALUE="MODE: SELECTION"

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

   display_info =0	
   click_outside = 0

   while (getvals EQ 0) do begin

      cursor,x,y,/nowait,/device

      if ((x LT 0) OR (x GT Ny) OR (y LT 0) OR (y GT Nx)) then begin

         click_outside = 1
         getvals = 1
         view_info = widget_info(Event.top,FIND_BY_UNAME='MODE_INFOS')
         WIDGET_CONTROL, view_info, SET_VALUE="MODE: INFOS"
         view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
         text = " Mode: INFOS"
         WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

      endif else begin
	
         if (first_round EQ 0) then begin

            X1=x
   	    Y1=y
	    first_round = 1
	    text = " Rigth click to select other corner"		
	    view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
 	    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

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

	 ;plot integrated x and y of selection
  
         ;get window numbers - x (selection hidding)
         view_x = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_X_REF_M_HIDDING')
         WIDGET_CONTROL, view_x, GET_VALUE = view_win_num_x_hidding

	 ;get window numbers - x (selection)
         view_x = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION_X')
         WIDGET_CONTROL, view_x, GET_VALUE = view_win_num_x_selection

         ;get window numbers - y (selection)
         view_y = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION_Y')
         WIDGET_CONTROL, view_y, GET_VALUE = view_win_num_y_selection

         img = (*(*global).img_ptr)
         img_total = img(x_min:x_max,y_min:y_max)
	 img_total_x = total(img_total,2)
         img_total_y = total(img_total,1)

	 true_img_total_x = lonarr(x_max)
	 true_img_total_y = lonarr(y_max)
	 true_img_total_x(x_min-1) = img_total_x
	 true_img_total_y(y_min-1) = img_total_y

	 ;for y via hidden_x
         wset,view_win_num_x_hidding
	 plot,true_img_total_y,title='Y Axis',XMARGIN=[10,10],/xstyle,xrange=[y_min,y_max]
         tmp_img = tvrd()
         tmp_img = reverse(transpose(tmp_img),1)
         wset,view_win_num_y_selection
         tv,tmp_img

         ;now plot,x
         wset,view_win_num_x_selection
         plot,true_img_total_x,/xstyle,title='X Axis',xrange=[x_min,x_max]

         blank_line = ""

         data = (*(*global).data_ptr)
         simg = (*(*global).img_ptr)

         starting_id = (y_min*304+x_min)
         starting_id_string = strcompress(starting_id)
         (*global).starting_id_x = x_min
         (*global).starting_id_y = y_min

         ending_id = (y_max*304+x_max)
         ending_id_string = strcompress(ending_id)
         (*global).ending_id_x = x_max
         (*global).ending_id_y = y_max

         first_point = '  pixelID#: '+ starting_id_string + $
	  '(x= '+strcompress(x_min,/rem)+'; y= '+strcompress(y_min,/rem)
         first_point_2= '           intensity= '+strcompress(simg[x_min,y_min],/rem)+')'

         second_point = '  pixelID#: '+ ending_id_string + $
	  '(x= '+strcompress(x_max,/rem)+'; y= '+strcompress(y_max,/rem)
         second_point_2= '           intensity= '+strcompress(simg[x_max,y_max],/rem)+')'

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

         value_group = [selection_label,$
                        number_pixelid,$
                        x_wide, y_wide,$
                        blank_line,total_counts,$
                        total_inside_region,$
                        total_outside_region,$
                        average_counts,$
                        average_inside_region,$
                        average_outside_region,$
                        blank_line,$
                        pixel_label,$
                        first_point,$
                        first_point_2,$
                        second_point,$
                        second_point_2]

         view_info = widget_info(Event.top,FIND_BY_UNAME='PIXELID_INFOS')
         WIDGET_CONTROL, view_info, SET_VALUE=""
         WIDGET_CONTROL, view_info, SET_VALUE=value_group, /APPEND

         ;end of part from the rubber_band program

      endif

;;;UNCOMMENT THIS PART TO MAKE COUNTS vs TBIN ACTIVE AGAIN
;;rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON')
;;widget_control,rb_id,sensitive=1
;;
;;selection = data(*,y_min:y_max,x_min:x_max)  
;;selection = total(selection,2)
;;selection = total(selection,2)
;;
;;view_info = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION')
;;WIDGET_CONTROL, view_info, GET_VALUE = view_num_info
;;wset, view_num_info
;;plot, selection
;;
;;;enable save button once a selection is done
;;rb_id=widget_info(Event.top, FIND_BY_UNAME='SAVE_BUTTON')
;;widget_control,rb_id,sensitive=1
;;
;;(*(*global).selection_ptr) = selection

      ;enable save button once a selection is done
      rb_id=widget_info(Event.top, FIND_BY_UNAME='SAVE_BUTTON')
      widget_control,rb_id,sensitive=1

      rb_id=widget_info(Event.top, FIND_BY_UNAME='START_CALCULATION')
      widget_control,rb_id,sensitive=1

   endelse ;click_outside

   click_outside = 0

endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;-------------------------------------------------------------------------
; \brief
;
; \argument Event INPUT)
;--------------------------------------------------------------------------
pro SAVE_REGION, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cd, (*global).working_path

;retrieve data
nexus_file = (*global).full_nexus_name
x_min =(*global).starting_id_x
y_min =(*global).starting_id_y
x_max =(*global).ending_id_x
y_max=(*global).ending_id_y

cmd_line = "tof_slicer -v "
cmd_line += "--starting-ids=" + strcompress(x_min,/remove_all) $
	+ ',' + strcompress(y_min,/remove_all)
cmd_line += " --ending-ids=" + strcompress(x_max,/remove_all) $
	 + ',' + strcompress(y_max,/remove_all)
cmd_line += " --data=" + nexus_file

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch data_reduction
str_time = systime(1)
text = "Processing....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;display message from data reduction verbose flag
WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;;
;;regionfile = GetRegionFile((*global).filename, (*global).filename_index)
;;
;;path="~/CD4/REF_M/REF_M_7/"   ;need to automatically determine path according to open file location
;;
;;outfile = dialog_pickfile(file=regionfile,PATH=path,title='Select Output Data File',/write,filter="*.txt")
;;
;;if outfile NE '' then begin
;;	
;;	selection = (*(*global).selection_ptr)
;;
;;	view_main=widget_info(Event.top, FIND_BY_UNAME='TBIN_TXT')
;;	WIDGET_CONTROL, view_main, GET_VALUE=tbin
;;	tbin = float(tbin)
;;	(*global).time_bin = tbin  
;;
;;	;get region indicies
;;	indicies = (*(*global).indicies)
;;	;remember, indicies are of the 2D image in (x,y) - need to convert to 3D indicies
;;	;to get TOF info...
;;
;;	Nselection = n_elements(selection)
;;
;;	if Nselection GT 0 then begin
;;
;;	data = fltarr(2,Nselection)
;;	for i=0L, Nselection-1 do begin
;;		data[0,i]=tbin*i
;;	endfor
;;	
;;	data(1,*)=selection	
;;		
;;;		;get data
;;;		data = (*(*global).data_ptr)
;;;
;;;		Nx = (*global).Nx
;;;		Ny = (*global).Ny
;;;		Ntof = (*global).Ntof
;;;
;;;		;will need to figure out how to format output data as it is required to be
;;;		;just giving it a start for now... ***********************
;;;		tmpdata = lonarr(Nindicies,Ntof)
;;;		for i=0L,Nindicies-1 do begin
;;;			x = indicies[i] MOD Ny
;;;			y = indicies[i] / Ny
;;;
;;;			tmpdata[i,*] = data[*,y,x]
;;;		endfor
;;		
;;		openw,u,outfile,/get_lun
;;		printf,u,data
;;		close,u
;;		free_lun,u
;;
;;	endif;Nselection
;;
;;endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$










;--------------------------------------------------------------------------
; \brief 
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$







;--------------------------------------------------------------------------
;\brief 
;
; \argument Event (INPUT) 
;--------------------------------------------------------------------------
PRO REFRESH, Event
;refresh image plot

SHOW_DATA,event
	
;remove data from info text box
view_info = widget_info(Event.top,FIND_BY_UNAME='PIXELID_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE=""

;disable save button after refreshing selection
rb_id=widget_info(Event.top, FIND_BY_UNAME='SAVE_BUTTON')
widget_control,rb_id,sensitive=0

;disalble GO button after refreshing selection
rb_id=widget_info(Event.top, FIND_BY_UNAME='START_CALCULATION')
widget_control,rb_id,sensitive=0

;remove counts vs tof plot
;	view_infof = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION')
;	WIDGET_CONTROL, view_info, GET_VALUE=id
;	wset, id
;	ERASE

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;--------------------------------------------------------------------------
; \brief
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro EXIT_PROGRAM, Event

if (N_ELEMENTS(U)) NE 0 then begin
	close, u
	free_lun,u
endif 

widget_control,Event.top,/destroy

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
; \brief
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro OPEN_FILE, Event

;first close previous file if there is one
if (N_ELEMENTS(U)) NE 0 then begin
	close, u
	free_lun,u
endif 

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).file_already_opened EQ 0) then (*global).file_already_opened = 1

;retrieve data parameters
Nx 		= (*global).Nx
Ny 		= (*global).Ny
filter = (*global).filter_histo  

;indicate reading data with hourglass icon
widget_control,/hourglass

;open file
path = (*global).path
file = dialog_pickfile(path=path,get_path=path,title='Select Data File',filter=filter)

;only read data if valid file given
if file NE '' then begin

	(*global).filename = file ; store input filename
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
	text = "Open histogram file: " + strcompress(file,/remove_all)
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;get only the last part of the file (its name)
	file_list=strsplit(file,'/',/extract,count=length)     ;to get only the last part of the name
	filename_only=file_list[length-1]	
	(*global).filename_only = filename_only ; store only name of the file (without the path)

;	print, "filenameonly= " , filename_only

	;determine name of nexus file according to histogram file name
	
	index = (*global).histo_map_index	

	if (index EQ 1) then begin
		file_list=strsplit(file,'_neutron_histo_mapped.dat',$
		/REGEX,/extract,count=length) ;to remove last part of the name
		run_number=strsplit(file_list[0],'_',/regex,/extract,count=length)
		run_number=run_number[length-1]
	endif else begin
		file_list=strsplit(file,'_neutron_histo.dat',$
		/REGEX,/extract,count=length) ;to remove last part of the name
		run_number=strsplit(file_list[0],'_',/regex,/extract,count=length)
		run_number=run_number[length-1]
	endelse

	filename_short=file_list[0]	
	file_list=strsplit(filename_short,'/',/REGEX,/extract,count=length) ;to remove last part of the name
	short_nexus_filename = file_list[length-1]
	nexus_path = (*global).nexus_path

	nexus_filename = nexus_path + run_number + "/NeXus/" + short_nexus_filename + ".nxs"
;	print, "nexus filename: " , nexus_filename	

	(*global).nexus_filename = nexus_filename

	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
	WIDGET_CONTROL, view_info, SET_VALUE='Nexus file: ', /APPEND
	WIDGET_CONTROL, view_info, SET_VALUE=nexus_filename, /APPEND
		
	;put info from NeXus file name
	view_info = widget_info(Event.top,FIND_BY_UNAME='NEXUS_INFOS')
	WIDGET_CONTROL, view_info, SET_VALUE='Title:'
	cmd = "nxdir " + nexus_filename + " -p /entry/title -o"
	spawn, cmd, listening
	WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND
	
	WIDGET_CONTROL, view_info, SET_VALUE='Notes:', /APPEND
	cmd = "nxdir " + nexus_filename + " -p /entry/notes -o"
	spawn, cmd, listening
	WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND
	
	;determine path	
	path_list=strsplit(file,filename_only,/reg,/extract)
	path=path_list[0]
	cd, path

;	;display path
;	view_info = widget_info(Event.top,FIND_BY_UNAME='PATH_TEXT')
;	WIDGET_CONTROL, view_info, SET_VALUE=path
	(*global).path = path
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
	WIDGET_CONTROL, view_info, SET_VALUE='Reading in data....', /APPEND
	strtime = systime(1)

	openr,u,file,/get
	;find out file info
	fs = fstat(u)
	Nimg = Nx*Ny
	Ntof = fs.size/(Nimg*4L)
	(*global).Ntof = Ntof	;set back in global structure

	;using assoc
	;(assoc defines a template structure for reading data. Since data are ordered Ntof, Ny, Nx, Ntof
	;varie the fastest. This being the case, it's not convenient to define an y,x data plane, and it's more
	;convenient to define the data structure to be an individual TOF array.
	data_assoc = assoc(u,lonarr(Ntof))
	
	;make the image array
	img = lonarr(Nx,Ny)
	for i=0L,Nimg-1 do begin
		x = i MOD Nx
		y = i/Nx
;		img[y,x] = total(swap_endian(data_assoc[i]))
		img[x,y] = total(data_assoc[i])
	endfor

	img=transpose(img)

	;old fashion way
;	data = lonarr(Ntof,Nx,Ny)
;	readu,u,data
;	;data = swap_endian(data)
;	img = transpose(total(data,1))
;	(*(*global).data_ptr) = data

	;load data up in global ptr array
	(*(*global).img_ptr) = img
	(*(*global).data_assoc) = data_assoc
	
	;now turn hourglass back off
	widget_control,hourglass=0

	;put image data in main draw window
	SHOW_DATA,event
	
	;now we can activate 'Refresh' button
	;disable refresh button during ctool
	rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON')
	widget_control,rb_id,sensitive=1

	endtime = systime(1)
	tt_time = string(endtime - strtime)
	text = 'Done in ' + strcompress(tt_time,/remove_all) + ' s'
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	
endif;valid file

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;--------------------------------------------------------------------------
pro OPEN_HISTO_MAPPED, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global

  (*global).histo_map_index = 1
  (*global).filter_histo = '*_histo_mapped.dat'

  OPEN_FILE, Event

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;--------------------------------------------------------------------------
pro OPEN_HISTO_UNMAPPED, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
	
  (*global).histo_map_index = 0
  (*global).filter_histo = '*_histo.dat'

  OPEN_FILE, Event

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;--------------------------------------------------------------------------
pro DATA_REDUCTION, Event

;first disable GO button during calculation
go_id=widget_info(Event.top, FIND_BY_UNAME='START_CALCULATION')
widget_control,go_id,sensitive=0

print, "In data_reduction"  ;REMOVE_ME

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;set up working path
working_path = (*global).working_path
cd, working_path

;retrieve name of nexus file
nexus_filename = (*global).full_nexus_name
;nexus_filename = (*global).nexus_filename

;retrieve parameters from different text boxes

;wavelength minimum
  view_wave_min=widget_info(Event.top, FIND_BY_UNAME='WAVELENGTH_MIN_TEXT')
  WIDGET_CONTROL, view_wave_min, GET_VALUE=wavelength_min
  wavelength_min = float(wavelength_min)
  (*global).wavelength_min = wavelength_min  

;wavelength maximum
  view_wave_max=widget_info(Event.top, FIND_BY_UNAME='WAVELENGTH_MAX_TEXT')
  WIDGET_CONTROL, view_wave_max, GET_VALUE=wavelength_max
  wavelength_max = float(wavelength_max)
  (*global).wavelength_max = wavelength_max  

;wavelength width
  view_wave_width=widget_info(Event.top, FIND_BY_UNAME='WAVELENGTH_WIDTH_TEXT')
  WIDGET_CONTROL, view_wave_width, GET_VALUE=wavelength_width
  wavelength_width = float(wavelength_width)
  (*global).wavelength_width = wavelength_width  

;detector angle
;value
  view_det_angle=widget_info(Event.top, FIND_BY_UNAME='DETECTOR_ANGLE_VALUE')
  WIDGET_CONTROL, view_det_angle, GET_VALUE=detector_angle
  detector_angle = float(detector_angle)
;error
  view_det_angle_err=widget_info(Event.top,FIND_BY_UNAME='DETECTOR_ANGLE_ERR')
  WIDGET_CONTROL, view_det_angle_err, GET_VALUE=detector_angle_err
  detector_angle_err = float(detector_angle_err)

;convert angle into radians
;check units selected
  view_angle_units=widget_info(Event.top, FIND_BY_UNAME='DETECTOR_ANGLE_UNITS',/droplist_select)
  WIDGET_CONTROL, view_angle_units, get_value=detector_angle_units
  index=widget_info(view_angle_units,/droplist_select)
  detector_angle_units = detector_angle_units[index]	  

  if (index EQ 1) then begin
	coeff = ((2*!pi)/180)
	detector_angle_rad = coeff*detector_angle 
	detector_angle_err_rad = coeff*detector_angle_err
  endif else begin
	detector_angle_rad = detector_angle
	detector_angle_err_rad = detector_angle_err
  endelse
  (*global).detector_angle = detector_angle_rad
  (*global).detector_angle_err = detector_angle_err_rad


;get starting and ending pixelIDs
starting_id_x = (*global).starting_id_x
starting_id_y = (*global).starting_id_y
ending_id_x = (*global).ending_id_x
ending_id_y = (*global).ending_id_y

;check switch background
  view_back_switch=widget_info(Event.top, $
                               FIND_BY_UNAME='BACKGROUND_SWITCH',/button_set)
  WIDGET_CONTROL, view_back_switch, get_uvalue=switch_value
  index=widget_info(view_back_switch,/button_set)
  if (index EQ 1) then begin
	with_back = 1
	background_flag = ""
  endif else begin
	with_back = 0
	background_flag = "--no-bkg"
  endelse
  (*global).with_background = with_back
	
;check switch normalization
  view_norm_switch=widget_info(Event.top, $
                               FIND_BY_UNAME='NORMALIZATION_SWITCH',/button_set)
  WIDGET_CONTROL, view_norm_switch, get_uvalue=switch_value
  index=widget_info(view_norm_switch,/button_set)
  if (index EQ 1) then begin
	with_norm = 1
	norm_file = (*global).norm_filename
	normalization_flag = "--norm=" + norm_file
  endif else begin
	with_norm = 0
	normalization_flag = ""
  endelse
  (*global).with_normalization = with_norm

;define command line to run data reduction
space = " "
cmd_line= "reflect_reduction " ;program to run
cmd_line += nexus_filename     ;data NeXus file
cmd_line += " --l-bins="       ;wavelength
cmd_line += strcompress(wavelength_min,/remove_all) + "," + $
	strcompress(wavelength_max,/remove_all) + "," + $
	strcompress(wavelength_width,/remove_all)  ;parameters of --l-bins
cmd_line += " --starting-ids=" ;starting selection x and y
cmd_line += strcompress(starting_id_x,/remove_all) + "," + $
	strcompress(starting_id_y,/remove_all)      ;xmin and ymin
cmd_line += " --ending-ids="   ;ending selection x and y
cmd_line += strcompress(ending_id_x,/remove_all) + "," + $
	strcompress(ending_id_y,/remove_all)	     ;xmax and ymax
cmd_line += " --det-angle="      ;detector angle
cmd_line += strcompress(detector_angle_rad,/remove_all) + "," + $
	strcompress(detector_angle_err,/remove_all)   ;value and error
;cmd_line += "," + detector_angle_units		      ;units
cmd_line += "," + "radians"   ;radians all the time because we are doing the conversion from deg to rad
cmd_line += space
cmd_line += background_flag	;"" if with back; "--no-bkg" if without back
cmd_line += space
cmd_line += normalization_flag   ;--norm=<name of file> if with normalization; "" if without
cmd_line += " -v"

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch data_reduction
str_time = systime(1)
text = "Processing....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;CATCH, wrong_nexus_file
;
;if (wrong_nexus_file ne 0) then begin
;
;	WIDGET_CONTROL, view_info, SET_VALUE="ERROR: Invalid NeXus", /APPEND
;	WIDGET_CONTROL, view_info, SET_VALUE="Program Terminated", /APPEND
;
;endif else begin
			
	;indicate initialization with hourglass icon
	widget_control,/hourglass

	spawn, cmd_line, listening, /stderr

;	CATCH, /CANCEL

	;turn off hourglass
	widget_control,hourglass=0

	;display message from data reduction verbose flag
	WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND

	end_time = systime(1)
	text = "Done"
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	text = "Processing_time: " + $
          strcompress((end_time-str_time),/remove_all) + " s"
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;plot resulting data reduction plot
	plot_reduction, event

	;reactivate GO button once calculation is done
	widget_control,go_id,sensitive=1

;endelse

info_overflow_REF_M, Event

end 
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
pro plot_reduction, Event

strt_time = systime(1)

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

working_path = (*global).working_path
;nexus_file = (*global).nexus_filename
nexus_file = (*global).full_nexus_name

print, "nexus_filename_only= " + (*global).nexus_file_name_only

data_reduction_file = working_path +  "REF_M_" + $
  strcompress((*global).run_number,/remove_all) + '.txt'

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')

text = 'Entering Data Reduction plot:'
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = 'Reading file: ' + data_reduction_file
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

CATCH, wrong_text_file

if (wrong_text_file ne 0) then begin

	WIDGET_CONTROL, view_info, SET_VALUE="ERROR: Invalid .txt file", /APPEND
	WIDGET_CONTROL, view_info, SET_VALUE="Program Terminated", /APPEND

endif else begin

openr,u,data_reduction_file,/get


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

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
space = ''
WIDGET_CONTROL, view_info, SET_VALUE=space, /APPEND
intro="*** Infos about file generated ***
WIDGET_CONTROL, view_info, SET_VALUE=intro, /APPEND

while (NOT eof(u)) do begin

	readu,u,onebyte;,format='(a1)'
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
;		print,tmp
		WIDGET_CONTROL, view_info, SET_VALUE=tmp, /APPEND
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
			readf,u,tmp0,tmp1,tmp2,format='(3F0)';
			flt0 = [flt0,float(tmp0)]
			flt1 = [flt1,float(tmp1)]
			flt2 = [flt2,float(tmp2)]

		endelse

	end
	endcase

endwhile

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = 'Number of non-data lines: ' + strcompress(Nndlines,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = 'Number of data lines: ' + strcompress(Ndlines,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;window,0
;!p.multi=[0,2,2]
;plot,flt0,title='Wavelength'
;plot,flt1,title='Intensity'
;plot,flt2,title='Sigma'

view_tof = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_REDUCTION')
WIDGET_CONTROL, view_tof, GET_VALUE = view_win_num_tof
wset,view_win_num_tof
plot,flt0,flt1,title='Intensity vs. Wavelength'
errplot,flt0,flt1 - flt2, flt1 + flt2,color = 100;'0xff00ffxl'

;!p.multi=0


close,u
free_lun,u
stop_time = systime(1)

endelse

CATCH, /CANCEL

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
; \brief
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro OPEN_NORMALIZATION, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check first if button was on or off
  view_norm_switch=widget_info(Event.top, FIND_BY_UNAME='NORMALIZATION_SWITCH',/button_set)
  WIDGET_CONTROL, view_norm_switch, get_uvalue=switch_value
  index=widget_info(view_norm_switch,/button_set)
  if (index EQ 0) then begin
	;remove text from normalization text box
	view_info = widget_info(Event.top,FIND_BY_UNAME='NORM_FILE_TEXT')
	WIDGET_CONTROL, view_info, SET_VALUE=""
  endif else begin
	
;retrieve data parameters
filter = (*global).filter_normalization

;indicate reading data with hourglass icon
widget_control,/hourglass

;open file
path=(*global).working_path
file = dialog_pickfile(path=path,get_path=path,title='Select Data File',filter=filter)

;save name of file only if valid file given

if file NE '' then begin

	(*global).norm_filename=file

	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
	text = "Open normalization file: " + strcompress(file,/remove_all)
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;get only the last part of the file (its name)
	file_list=strsplit(file,'/',/extract,count=length)     ;to get only the last part of the name
	filename_only=file_list[length-1]	
	view_info = widget_info(Event.top,FIND_BY_UNAME='NORM_FILE_TEXT')
	WIDGET_CONTROL, view_info, SET_VALUE=filename_only

endif else begin
  ;change status of switch to off
  view_norm_switch=widget_info(Event.top, FIND_BY_UNAME='NORMALIZATION_SWITCH',/button_set)
  WIDGET_CONTROL, view_norm_switch, set_button=0
endelse

endelse

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
; \brief
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro read_and_plot_nexus_file_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;first close previous file if there is one
if (N_ELEMENTS(U)) NE 0 then begin
	close, u
	free_lun,u
endif 

;retrieve data parameters
Nx 		= (*global).Nx
Ny 		= (*global).Ny

;indicate reading data with hourglass icon
widget_control,/hourglass

file = (*global).full_histo_mapped_name
nexus_file_name_only = (*global).nexus_file_name_only

;only read data if valid file given
if file NE '' then begin

	(*global).file_already_opened = 1

	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
	text = "Plot NeXus file: " + nexus_file_name_only
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	
	;determine path	
        path = (*global).working_path
        cd, path

	view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
	WIDGET_CONTROL, view_info, SET_VALUE='Reading in data....', /APPEND
	strtime = systime(1)

	openr,u,file,/get
	;find out file info
	fs = fstat(u)
	Nimg = Nx*Ny
	Ntof = fs.size/(Nimg*4L)
	(*global).Ntof = Ntof	;set back in global structure

	;using assoc
	;(assoc defines a template structure for reading data. Since data are ordered Ntof, Ny, Nx, Ntof
	;varie the fastest. This being the case, it's not convenient to define an y,x data plane, and it's more
	;convenient to define the data structure to be an individual TOF array.
	data_assoc_tof = assoc(u,lonarr(Ntof,Nx))
	data_assoc = assoc(u,lonarr(Ntof))

	;make the image array
	img = lonarr(Nx,Ny)
	for i=0L,Nimg-1 do begin
		y = i MOD Ny
		x = i/Ny
		img[x,y] = total(data_assoc[i])
	endfor			

	img=transpose(img)

;*********************************************************
;*********************************************************

	counts_vs_tof=lonarr(Ntof)
	for i=0L, Ny-1  do begin
		counts_vs_tof += total(data_assoc_tof[i],2)
	endfor
	
	(*(*global).counts_vs_tof) = counts_vs_tof

	view_counts_tof = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_COUNTS_TOF_REF_L')
	WIDGET_CONTROL, view_counts_tof, GET_VALUE = view_win_counts_tof_ref_l
	wset,view_win_counts_tof_ref_l
	plot, counts_vs_tof, title = 'Integrated counts vs tof'

; ********************************************************
; ********************************************************

	;load data up in global ptr array
	(*(*global).img_ptr) = img
	(*(*global).data_assoc) = data_assoc
	
	;plot sum_x and sum_y in their window

	view_sum_x = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SUM_X_REF_L')
	WIDGET_CONTROL, view_sum_x, GET_VALUE = view_win_num_sum_x
	view_sum_y = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SUM_Y_REF_L')
	WIDGET_CONTROL, view_sum_y, GET_VALUE = view_win_num_sum_y
	view_sum_x_hidding = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_X_REF_L_HIDDING')
	WIDGET_CONTROL, view_sum_x_hidding, GET_VALUE = view_win_num_sum_x_hidding

	wset,view_win_num_sum_x_hidding
	sum_y = total(img,1)
	plot,sum_y,/xstyle,title='SUM Y Axis'
	tmp_img = tvrd()
	tmp_img = reverse(transpose(tmp_img),1)
;	tmp_img = congrid(tmp_img,120,350,/INTERP)
	wset,view_win_num_sum_y
	tv,tmp_img
		
	wset,view_win_num_sum_x
	sum_x = total(img,2)
	plot,sum_x,/xstyle,title='SUM X Axis'

	;now turn hourglass back off
	widget_control,hourglass=0

	;put image data in main draw window
	SHOW_DATA_REF_L,event
	
	;now we can activate 'Refresh' button
	;disable refresh button during ctool
	rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON_REF_L')
	widget_control,rb_id,sensitive=1

	endtime = systime(1)
	tt_time = string(endtime - strtime)
	text = 'Done in ' + strcompress(tt_time,/remove_all) + ' s'
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	
	;disable save button after refreshing selection
	rb_id=widget_info(Event.top, FIND_BY_UNAME='SAVE_BUTTON_REF_L')
	widget_control,rb_id,sensitive=1

endif;valid file

id = widget_info(Event.top,FIND_BY_UNAME='CTOOL_MENU_REF_L')
Widget_Control, id, sensitive=1

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
pro OPEN_HISTO_MAPPED_REF_L, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global

  (*global).histo_map_index = 1
  (*global).filter_histo = '*_histo_mapped.dat'

  OPEN_FILE_REF_L, Event

end

pro OPEN_HISTO_UNMAPPED_REF_L, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
	
  (*global).histo_map_index = 0
  (*global).filter_histo = '*_histo.dat'

  OPEN_FILE_REF_L, Event

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;---------------------------------------------------------------------------
pro SAVE_REGION_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cd, (*global).working_path

;retrive data 
nexus_file = (*global).full_nexus_name

y_min =(*global).starting_id_x
x_min =(*global).starting_id_y
y_max =(*global).ending_id_x
x_max=(*global).ending_id_y

cmd_line = "tof_slicer -v "
cmd_line += "--starting-ids=" + strcompress(x_min,/remove_all) $
	+ ',' + strcompress(y_min,/remove_all)
cmd_line += " --ending-ids=" + strcompress(x_max,/remove_all) $
	 + ',' + strcompress(y_max,/remove_all)
cmd_line += " --data=" + nexus_file

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch data_reduction
str_time = systime(1)
text = "Processing....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;display message from data reduction verbose flag
WIDGET_CONTROL, view_info, SET_VALUE=listening, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

info_overflow_REF_L, Event

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$








;--------------------------------------------------------------------------
; \brief
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro EXIT_PROGRAM_REF_L, Event

if (N_ELEMENTS(U)) NE 0 then begin
	close, u
	free_lun,u
endif 

widget_control,Event.top,/destroy

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;--------------------------------------------------------------------------
; \brief 
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro CTOOL_REF_L, Event

	;disable refresh button during ctool
	rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON_REF_L')
	widget_control,rb_id,sensitive=0

	;get global structure
	id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
	widget_control,id,get_uvalue=global

	xloadct,/MODAL,GROUP=id

	SHOW_DATA_REF_L,event

	;turn refresh button back on
	widget_control,rb_id,sensitive=1
end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
; \brief procedure to image the data
;
; \argument event (INPUT)
;--------------------------------------------------------------------------
pro SHOW_DATA_REF_L,event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Nx = (*global).Nx
Ny = (*global).Ny

;get window numbers
view_id = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_REF_L')
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
;\brief 
;
; \argument Event (INPUT) 
;--------------------------------------------------------------------------
PRO REFRESH_REF_L, Event
;refresh image plot

SHOW_DATA_REF_L,event
	
;remove data from info text box
view_info = widget_info(Event.top,FIND_BY_UNAME='PIXELID_INFOS_REF_L')
WIDGET_CONTROL, view_info, SET_VALUE=""


;remove counts vs tof plot
;	view_infof = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION')
;	WIDGET_CONTROL, view_info, GET_VALUE=id
;	wset, id
;	ERASE

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------
; \brief 
;
; \argument event (INPUT) 
;--------------------------------------------------------------------------
pro VIEW_ONBUTTON_REF_L,event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_already_opened = (*global).file_already_opened

;left mouse button
IF ((event.press EQ 1) AND (file_already_opened EQ 1)) then begin

   ;get data
   img = (*(*global).img_ptr)
   ;data = (*(*global).data_ptr)
   tmp_tof = (*(*global).data_assoc)
   Nx= (*global).Nx

   x = Event.x
   y = Event.y

   ;set data
   (*global).x = x
   (*global).y = y

   ;put x and y into cursor x and y labels position
   view_info = widget_info(Event.top,FIND_BY_UNAME='CURSOR_X_POSITION_REF_L')
   WIDGET_CONTROL, view_info, SET_VALUE=strcompress(x)
   view_info = widget_info(Event.top,FIND_BY_UNAME='CURSOR_Y_POSITION_REF_L')
   WIDGET_CONTROL, view_info, SET_VALUE=strcompress(y)
	
   ;put number of counts in number_of_counts label position
   view_info = widget_info(Event.top,FIND_BY_UNAME='NUMBER_OF_COUNTS_VALUE')
   WIDGET_CONTROL, view_info, SET_VALUE=strcompress(img(x,y))

   ;get window numbers - x
   view_x = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_X_REF_L')
   WIDGET_CONTROL, view_x, GET_VALUE = view_win_num_x

   ;get window numbers - y
   view_y = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_Y_REF_L')
   WIDGET_CONTROL, view_y, GET_VALUE = view_win_num_y

   ;get window numbers - x hidding
   view_x_hidding = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_X_REF_L_HIDDING')
   WIDGET_CONTROL, view_x_hidding, GET_VALUE = view_win_num_sum_x_hidding

   ;do funky stuff since can't figure out how to plot along y axis...
   ;plot y in x window
   ;read this data into a temporary file
   ;then image this plot in the window it belongs in...
   wset,view_win_num_sum_x_hidding
   plot,img(x,*),/xstyle,title='Y Axis'
   tmp_img = tvrd()
   tmp_img = reverse(transpose(tmp_img),1)
;   tmp_img = congrid(tmp_img,120,350,/INTERP)
   wset,view_win_num_y
   tv,tmp_img

   ;now plot,x
   wset,view_win_num_x
   plot,img(*,y),/xstyle,title='X Axis'

   ;now plot tof
   ;get window numbers - tof
   view_tof = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_TOF_REF_L')
   WIDGET_CONTROL, view_tof, GET_VALUE = view_win_num_tof
   wset,view_win_num_tof
   ;remember that img is transposed, tmp_tof is not so this is why we switch x<->y
   pixelid=x*Nx+y     

   tof_arr=(tmp_tof[pixelid])
   plot, tof_arr,title='TOF Axis'	
   ;plot,reform(data(*,y,x)),title='TOF Axis'

endif

;right mouse button
IF ((event.press EQ 4) AND (file_already_opened EQ 1)) then begin

   view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
   text = "Mode: SELECTION"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = " left click to select first corner or
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
   text = " right click to quit SELECTION mode"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

   ;get window numbers
   view_id = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_REF_L')
   WIDGET_CONTROL, view_id, GET_VALUE = view_win_num

   ;from the rubber_band program

   getvals = 0	;while getvals is GT 0, continue to check mouse down clicks

   ;continue to loop getting values while mouse clicks occur within the image window

   view_main=widget_info(Event.top, FIND_BY_UNAME='VIEW_DRAW_REF_L')
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

   display_info =0	

   click_outside = 0

   while (getvals EQ 0) do begin

      cursor,x,y,/nowait,/device
	
      if ((x LT 0) OR (x GT Ny) OR (y LT 0) OR (y GT Nx)) then begin

	 click_outside = 1
	 getvals = 1
	 view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
	 text = " Mode: INFOS"
	 WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

      endif else begin
	
	 if (first_round EQ 0) then begin
	    
            X1=x
	    Y1=y
	    first_round = 1
	    text = " Rigth click to select other corner"		
	    view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS_REF_L')
	    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	 endif else begin
		
            X2=x
	    Y2=y
	    SHOW_DATA_REF_L,event
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

         ;**Create the labels that will receive the information from the pixelID selected
         ;*Initialization of text boxes
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

         starting_id = (y_min*304+x_min)
         starting_id_string = strcompress(starting_id)
         (*global).starting_id_x = x_min
         (*global).starting_id_y = y_min

         ending_id = (y_max*304+x_max)
         ending_id_string = strcompress(ending_id)
         (*global).ending_id_x = x_max
         (*global).ending_id_y = y_max

         first_point = '  pixelID#: '+ starting_id_string +' (x= '+strcompress(x_min,/rem)+$
          '; y= '+strcompress(y_min,/rem)
         first_point_2= '           intensity= '+strcompress(simg[x_min,y_min],/rem)+')'
         second_point = '  pixelID#: '+ ending_id_string +' (x= '+strcompress(x_max,/rem)+$
          '; y= '+strcompress(y_max,/rem)+'
         second_point_2= '           intensity= '+strcompress(simg[x_max,y_max],/rem)+')'

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

         value_group = [selection_label, number_pixelid,$
          x_wide, y_wide, blank_line,total_counts, total_inside_region, total_outside_region,$
          average_counts, average_inside_region, average_outside_region,blank_line,pixel_label,first_point,$
          first_point_2,second_point,second_point_2]

         ;text = widget_text(, value=value_group, ysize=17)

         view_info = widget_info(Event.top,FIND_BY_UNAME='PIXELID_INFOS_REF_L')
         WIDGET_CONTROL, view_info, SET_VALUE=""
         WIDGET_CONTROL, view_info, SET_VALUE=value_group, /APPEND

      endif 

;;;UNCOMMENT THIS PART TO MAKE COUNTS vs TBIN ACTIVE AGAIN
;;rb_id=widget_info(Event.top, FIND_BY_UNAME='REFRESH_BUTTON_REF_L')
;;widget_control,rb_id,sensitive=1
;;
;;selection = data(*,y_min:y_max,x_min:x_max)  
;;selection = total(selection,2)
;;selection = total(selection,2)
;;
;;view_info = widget_info(Event.top,FIND_BY_UNAME='VIEW_DRAW_SELECTION')
;;WIDGET_CONTROL, view_info, GET_VALUE = view_num_info
;;wset, view_num_info
;;plot, selection
;;
;;;enable save button once a selection is done
;;rb_id=widget_info(Event.top, FIND_BY_UNAME='SAVE_BUTTON')
;;widget_control,rb_id,sensitive=1
;;
;;(*(*global).selection_ptr) = selection

      ;enable save button once a selection is done
      rb_id=widget_info(Event.top, FIND_BY_UNAME='SAVE_BUTTON_REF_L')
      widget_control,rb_id,sensitive=1

   endelse ;click_outside

   click_outside = 0

endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
