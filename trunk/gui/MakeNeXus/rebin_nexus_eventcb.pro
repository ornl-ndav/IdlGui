function create_append_event_file, event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_view_info = widget_info(Event.top,find_by_uname='log_book_text')

full_text = 'Entering create_append_event_file:'
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

nbr_nexus_file = (*global).nbr_nexus_file
list_of_runs = (*(*global).list_of_runs)
full_tmp_nxdir_folder_path = (*global).full_tmp_nxdir_folder_path

instrument =  (*global).instrument

WIDGET_CONTROL, full_view_info, $
  SET_VALUE=' output_folder: ' + full_tmp_nxdir_folder_path, /APPEND

;check that all run number have been archived
nbr_run_check = 0
for i=0,(nbr_nexus_file-1) do begin
    (*global).find_nexus = 0
    full_nexus_name = find_full_nexus_name(Event, 0, list_of_runs[i], instrument)
    if ((*global).find_nexus EQ 1) then begin
        if (nbr_run_check EQ 0) then begin
            list_of_runs_check = [list_of_runs[i]]
            nbr_run_check = 1
        endif else begin
            list_of_runs_check = [list_of_runs_check,list_of_runs[i]]
            nbr_run_check += 1
        endelse
    endif
endfor
        
;nbr_run_check      -> nbr of runs that has a NeXus archived (3)
;list_of_runs_check -> list of runs that has a NeXus archived (30,31,33)

for i=0,(nbr_run_check-1) do begin
    full_text = ' Working on run ' + strcompress(list_of_runs[i])
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
    run_number = list_of_runs_check[i]

;copy event file into tmp folder
;get path to preNeXus file
    full_prenexus_name = $
      find_full_prenexus_name(Event, 0, run_number, instrument)
    full_neutron_event_file_name = $
      replace_string(full_prenexus_name,$
                     'cvinfo.xml',$
                     'neutron_event.dat')
;move file of interest into tmp folder
    cmd_cp = 'cp ' + full_neutron_event_file_name
    cmd_cp += ' ' + full_tmp_nxdir_folder_path + '/'
    cmd_cp_text = '> ' + cmd_cp
    WIDGET_CONTROL, full_view_info, SET_VALUE=cmd_cp_text, /APPEND
    spawn, cmd_cp, listening, err_listening
    output_into_text_box, event, 'log_book_text', listening
    output_error, event, 'log_book_text', err_listening
        
endfor

;added event file together into first event file
array_of_full_tmp_event_file_name = $
  produce_array_of_tmp_event_file_name(event,$
                                       instrument,$
                                       list_of_runs_check,$
                                       nbr_run_check,$
                                       full_tmp_nxdir_folder_path)
                                                                          

if (nbr_run_check GT 1) then begin
;append first file with all the other ones
    append_file, event, array_of_full_tmp_event_file_name, nbr_run_check
endif

return, array_of_full_tmp_event_file_name[0]
end








function get_archive_run_dir, file

archive_run_list = strsplit(file,'/',/regex,/extract,count=length)
archive_run_dir = '/'
for i=0,length-2 do begin
    archive_run_dir += archive_run_list[i] + '/'
endfor
return, archive_run_dir
end






function get_proposal_experiment_number, event, file, archived

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DAS_has_experiment_number=(*global).DAS_has_experiment_number

file_parsed = strsplit(file,"/",/regex,/extract,count=length)

if (archived EQ 0) then begin  ;file is on DAS
    if (DAS_has_experiment_number EQ 1) then begin ;no experiment number
        proposal_number = file_parsed[length-4]
        experiment_number = file_parsed[length-3]
    endif else begin            ;DAS has experiment number
        proposal_number = file_parsed[length-3]
        experiment_number = "/"
    endelse 

endif else begin ;file has been archived

    if (length EQ 7) then begin
        proposal_number = file_parsed[length-5]
        experiment_number = file_parsed[length-4]
    endif else begin
        proposal_number = file_parsed[length-4]
        experiment_number = "/"
    endelse

endelse

result = [proposal_number, experiment_number]
return, result

end







function get_das_run_dir, parent_folder_name

das_run_list = strsplit(parent_folder_name,'/',/regex,/extract,count=length)
das_run_dir = '/'
for i=0,length-2 do begin
    das_run_dir += das_run_list[i] + '/'
endfor

return, das_run_dir
end








function get_event_file_name_only, event_filename
event_filename_list = strsplit(event_filename,'/',/regex,/extract,count=length)
event_filename_only = event_filename_list[length-1]
return, event_filename_only
end







function get_histo_event_file_name_only,Event, neutron_event_file_name_only

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_list=strsplit(neutron_event_file_name_only,'event.dat$',/regex,/extract,count=length)
histo_file_name_only = file_list[0] + 'histo.dat'
histo_mapped_file_name_only = file_list[0] + 'histo_mapped.dat'
(*global).histo_mapped_file_name_only = histo_mapped_file_name_only
(*global).full_histo_mapped_file_name = (*global).full_path_to_preNeXus + $
  histo_mapped_file_name_only

return, histo_file_name_only
end







function get_full_timemap_file_name, full_histo_file_name

full_histo_file_name_array = strsplit(full_histo_file_name,'histo.dat',/regex,/extract)
full_timemap_file_name = full_histo_file_name_array[0] + 'timemap.dat'

return, full_timemap_file_name
end







pro get_histo_mapped_file_name, Event, neutron_event_file_name_only

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_list = strsplit(neutron_event_file_name_only,'.dat$',/regex,/extract,count=length)
histo_mapped_file_name_only = file_list[0] + '_mapped.dat'
(*global).histo_mapped_file_name_only = histo_mapped_file_name_only

end





function get_up_to_date_map_geo_tran_files, instrument

case instrument of
    'REF_L':beam_line='4B'
    'REF_M':beam_line='4A'
    'BSS':beam_line='2'
endcase

path_to_files_of_interest = "/SNS/" + instrument
path_to_files_of_interest += "/2006_1_" + beam_line + "_CAL/calibrations/"

;generic file names
mapping_file = instrument + "_TS_*.dat"
geometry_file = instrument + "_geom_*.nxs"
translation_file = instrument + "_*.nxt"

;get up-to-date mapping_file
ls_cmd = path_to_files_of_interest + mapping_file
spawn, "ls " + ls_cmd, mapping_list, err_listening

mapping_file = reverse(mapping_list[sort(mapping_list)])

;get up-to-date geometry_file
ls_cmd = path_to_files_of_interest + geometry_file
spawn, "ls " + ls_cmd, geometry_list, err_listening

geometry_file = reverse(geometry_list[sort(geometry_list)])

;get up-to-date translation_file
ls_cmd = path_to_files_of_interest + translation_file
spawn, "ls " + ls_cmd, translation_list, err_listening

translation_file = reverse(translation_list[sort(translation_list)])

;combine results
array_result=[mapping_file[0], geometry_file[0], translation_file[0]]

return, array_result

end








function CHANGE_MESSAGE, Event

id = widget_info(Event.top, FIND_BY_UNAME="archive_it_or_not")
WIDGET_CONTROL, id, get_value=archive_value

id1=widget_info(Event.top,FIND_BY_UNAME='CREATE_NEXUS')
if (Event.value EQ "YES") then begin
   widget_control, id1, SET_VALUE='CREATE and ARCHIVE NeXus'
endif else begin
   widget_control, id1, SET_VALUE='CREATE NeXus'
endelse

end






pro plot_data_REF_M, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve data parameters
Nx = (*global).Nx_REF_M
Ny = (*global).Ny_REF_M

;indicate reading data with hourglass icon
widget_control,/hourglass

;file to open
file = (*global).file_to_plot

;only read data if valid file given
if file NE '' then begin

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
	img[x,y] = total(data_assoc[i])
   endfor

   img=transpose(img)

   ;load data up in global ptr array
   (*(*global).img_ptr) = img
   (*(*global).data_assoc) = data_assoc
	
   ;now turn hourglass back off
   widget_control,hourglass=0

   ;put image data in the display window
   id = widget_info(Event.top, FIND_BY_UNAME="DISPLAY_WINDOW")
   WIDGET_CONTROL, id, map=1
   WIDGET_CONTROL, id, GET_VALUE = view_plot   
   wset,view_plot
   tvscl,img

   close, u
   free_lun, u
	
endif;valid file

end







pro plot_data_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve data parameters
Nx = (*global).Nx_REF_L
Ny = (*global).Ny_REF_L

;indicate reading data with hourglass icon
widget_control,/hourglass

;file to open
file = (*global).file_to_plot

;only read data if valid file given
if file NE '' then begin

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
	img[x,y] = total(data_assoc[i])
   endfor

   img=transpose(img)

   ;load data up in global ptr array
   (*(*global).img_ptr) = img
   (*(*global).data_assoc) = data_assoc
	
   ;now turn hourglass back off
   widget_control,hourglass=0

   ;put image data in the display window
   id = widget_info(Event.top, FIND_BY_UNAME="DISPLAY_WINDOW")
   WIDGET_CONTROL, id, map=1
   WIDGET_CONTROL, id, GET_VALUE = view_plot   
   wset,view_plot
   tvscl,img

   close, u
   free_lun, u
	
endif;valid file

end





pro plot_data_BSS, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve data parameters
;Nx = (*global).Nx_BSS
;Ny = (*global).Ny_BSS
Nx = 64L
Ny = 64L

file = (*global).file_to_plot
file_top = (*global).file_to_plot_top
file_bottom = (*global).file_to_plot_bottom

;only read data if valid file given
if ((*global).find_prenexus_on_das EQ 1 AND file NE '') then begin
    
;top bank
    openr,1,file
    fs=fstat(1)
    
;to get the size of the file
    file_size=fs.size
    
    N = long(file_size) / 4L    ;number of elements
    data = lonarr(N)
    readu,1,data
    
    close,1
    free_lun, 1
    
    pixel_number = 64*64*2
    Nt = N/(pixel_number)
    
;find the non-null elements
    indx1 = where(data GT 0, Ngt0)
    
    img = intarr(Nt,Nx,Ny)
    img(indx1)=data(indx1)
    
    simg = total(img,1) 	;sum over time bins
    
    top_bank = simg(0:63,0:63)
    bottom_bank = simg(0:63,64:127)
    
endif else begin                ;using NeXus file
    
    if (file_top NE '' AND file_bottom NE '') then begin
        
;top_bank
        file_name = [file_top, file_bottom]
        
        for i=0,1 do begin
            
            openr,1,file_name[i]
            fs=fstat(1)
            file_size=fs.size
            N=long(file_size)/4L
            data=lonarr(N)
            readu,1,data
            close,1
            free_lun,1
            pixel_number = 64*64
            Nt=N/(pixel_number)
            
            indx1 = where(data GT 0,Ngt0)
            img=intarr(Nt,Nx,Ny)
            img(indx1) = data(indx1)
            
            simg = total(img,1)
            case i of 
                0: top_bank = img
                1: bottom_bank = img
                else:
            endcase
            
        endfor
        
    endif
    
endelse

;work on top and bottom banks
top_bank = transpose(top_bank)
bottom_bank = transpose(bottom_bank)

x_coeff = 5
y_coeff = 2

New_Ny = y_coeff*Ny
New_Nx = x_coeff*Nx

xoff = 10
yoff = 10

;top bank
view_info = widget_info(Event.top,FIND_BY_UNAME='DISPLAY_WINDOW_0')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

;tvimg = congrid(top_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(top_bank, New_Nx, New_Ny,/sample)
tvscl, tvimg, /device

;bottom bank
view_info = widget_info(Event.top,FIND_BY_UNAME='DISPLAY_WINDOW_1')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

;tvimg = congrid(bottom_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(bottom_bank, New_Nx, New_Ny,/sample) 
tvscl, tvimg, /device

end







pro create_local_copy_of_histo_mapped, Event, on_das, is_file_histo

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
full_view_info = widget_info(Event.top,find_by_uname='log_book_text')

if (on_das EQ 0) then begin
    
    full_nexus_name = (*global).full_path_to_nexus
    
    if ((*global).instrument EQ "BSS") then begin
        
        cmd_dump = "nxdir " + full_nexus_name
        cmd_dump_top = cmd_dump + " -p /entry/bank1/data/ --dump "
        cmd_dump_bottom = cmd_dump + " -p /entry/bank2/data/ --dump "
;get name of output_file
        tmp_output_file = (*global).full_tmp_nxdir_folder_path 
        tmp_output_file += "/" + (*global).instrument
        tmp_output_file += "_" + (*global).run_number
        
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
        full_text = 'Create local copy of the histo mapped data: '
        widget_control, full_view_info, set_value=full_text, /append
        full_text = '(top part) > ' + cmd_dump_top
        widget_control, full_view_info, set_value=full_text, /append
        
        spawn, cmd_dump_top, listening, err_listening
        output_error, Event, 'log_book_text', err_listening

        text= "..done"
        widget_control, view_info, set_value=text, /append
                
        text= cmd_dump_bottom
        widget_control, view_info, set_value=text, /append
        text= "Processing....."
        widget_control, view_info, set_value=text, /append
        full_text = 'Create local copy of the histo mapped data: '
        widget_control, full_view_info, set_value=full_text, /append
        full_text = '(bottom part) > ' + cmd_dump_bottom
        widget_control, full_view_info, set_value=full_text, /append
        
        spawn, cmd_dump_bottom, listening, err_listening
        output_error, Event, 'log_book_text', err_listening

        text= "..done"
        widget_control, view_info, set_value=text, /append
        
    endif else begin
        
        cmd_dump = "nxdir " + full_nexus_name
        cmd_dump += " -p /entry/bank1/data/ --dump "
        
;get name of output_file
        tmp_output_file = (*global).full_tmp_nxdir_folder_path 
        tmp_output_file += "/" + (*global).instrument
        tmp_output_file += "_" + (*global).run_number
        
        tmp_output_file += ".dat"
        (*global).file_to_plot = tmp_output_file
        cmd_dump += tmp_output_file
        
;display command
        text= cmd_dump
        widget_control, view_info, set_value=text, /append
        text= "Processing....."
        widget_control, view_info, set_value=text, /append
        full_text = 'Create local copy of the histo mapped data: '
        widget_control, full_view_info, set_value=full_text, /append
        full_text = '> ' + cmd_dump
        widget_control, full_view_info, set_value=full_text, /append
        
        spawn, cmd_dump, listening, err_listening
        output_error, Event, 'log_book_text', err_listening

        text= "..done"
        widget_control, view_info, set_value=text, /append
        
    endelse
    
endif else begin                ;file is on das
    
    histo_event_filename = (*global).histo_event_filename
    max_time_bin = strcompress((*global).max_time_bin,/remove_all)
    pixel_number = strcompress((*global).pixel_number,/remove_all)
    full_tmp_nxdir_folder_path = (*global).full_tmp_nxdir_folder_path
    
;nothing to do if binary file is histogrma file
    if ((*global).is_file_histo EQ 0) then begin ;event binary file
        
;create local copy  of histo (1 time bin)
        cmd_Event_to_Histo = 'Event_to_Histo '
        cmd_Event_to_Histo += histo_event_filename
        cmd_Event_to_Histo += ' -l ' + max_time_bin
        cmd_Event_to_Histo += ' -p ' + pixel_number
        cmd_Event_to_Histo += ' -M ' + max_time_bin
        cmd_Event_to_Histo += ' -a ' + (*global).full_tmp_nxdir_folder_path
        full_text = "Create local histogram binary file"
        widget_control, full_view_info, set_value=full_text, /append
        full_text = '> ' + cmd_Event_to_Histo
        widget_control, full_view_info, set_value=full_text, /append
        
        spawn, cmd_Event_to_Histo, listening, err_listening
        output_error, Event, 'log_book_text', err_listening

        neutron_event_file_name_only = get_event_file_name_only(histo_event_filename)
        histo_file_name = get_histo_event_file_name_only(Event, neutron_event_file_name_only)
        full_histo_file_name = full_tmp_nxdir_folder_path + '/' + histo_file_name

        output_folder = full_tmp_nxdir_folder_path

    endif else begin
        
        neutron_event_file_name_only = get_event_file_name_only(histo_event_filename)
        get_histo_mapped_file_name, Event, neutron_event_file_name_only
        full_histo_file_name = histo_event_filename
        full_histo_mapped_file_name_only = full_tmp_nxdir_folder_path + '/' + $
          (*global).histo_mapped_file_name_only 

        output_folder = full_tmp_nxdir_folder_path

    endelse
    
    id = widget_info(Event.top, FIND_BY_UNAME="MAPPING_FILE_LABEL")
    widget_control, id, get_value=mapping_filename

    cmd_Map_Data = 'Map_Data '
    cmd_Map_Data += ' -t 1 -p ' + pixel_number
    cmd_Map_Data += ' -m ' + mapping_filename
    cmd_Map_Data += ' -n ' + full_histo_file_name
    cmd_Map_Data += ' -o ' + output_folder

    full_text = "Create local mapped histogram binary file"
    widget_control, full_view_info, set_value=full_text, /append
    full_text = '> ' + cmd_Map_Data
    widget_control, full_view_info, set_value=full_text, /append
    
    spawn, cmd_Map_Data, listening, err_listening
    output_error, Event, 'log_book_text', err_listening

    tmp_output_file = (*global).histo_mapped_file_name_only
    tmp_output_file = full_tmp_nxdir_folder_path + '/' + tmp_output_file
    (*global).file_to_plot = tmp_output_file
    full_text = 'local file created: '
    widget_control, full_view_info, set_value=full_text, /append
    full_text = '> ' + tmp_output_file
    widget_control, full_view_info, set_value=full_text, /append
    
endelse

end






pro DISPLAY_BUTTON, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id_display = widget_info(Event.top, find_by_uname='DISPLAY_BUTTON')
widget_control, id_display, sensitive=0

if ((*global).display_button_activate EQ 0) then begin ;button not activated

    (*global).display_button_activate = 1
    instrument =  (*global).instrument    
    
;change label of button
    id_button = widget_info(Event.top, find_by_uname='DISPLAY_BUTTON')
    widget_control, id_button, set_value='Desactivate preview'

;file to open
    create_local_copy_of_histo_mapped, $
      Event, $
      (*global).find_prenexus_on_das, $
      (*global).is_file_histo
    
    id=widget_info(Event.top,FIND_BY_UNAME="HISTOGRAM_STATUS")
    text = "Plotting......"
    widget_control, id, set_value = text, /append 

;plot data according to instrument type
    
    case instrument of        
        
        "REF_L": begin
            (*global).xsize_display = (*global).xsize_dislay_REF_L
            id = widget_info(Event.top, find_by_uname="MAIN_BASE")
            widget_control, id, scr_xsize=(*global).xsize_display
            
            id1 = widget_info(Event.top, find_by_uname="DISPLAY_WINDOW")
            widget_control, id1, scr_xsize=(*global).NY_REF_L
            widget_control, id1, scr_ysize=(*global).NX_REF_L
            
            plot_data_REF_L, event
            
        end
        "REF_M": begin
            (*global).xsize_display = (*global).xsize_display_REF_M
            id = widget_info(Event.top, find_by_uname="MAIN_BASE")
            widget_control, id, scr_xsize=(*global).xsize_display
            
            id1 = widget_info(Event.top, find_by_uname="DISPLAY_WINDOW")
            widget_control, id1, scr_xsize=(*global).NY_REF_M
            widget_control, id1, scr_ysize=(*global).NX_REF_M
            
            plot_data_REF_M, event      
            
        end
        "BSS"  : begin
            id = widget_info(Event.top, find_by_uname = "DISPLAY_WINDOW_BASE")
            widget_control, id, map=0
            
            (*global).xsize_display = (*global).xsize_display_BSS
            id = widget_info(Event.top, find_by_uname="MAIN_BASE")
            widget_control, id, scr_xsize=(*global).xsize_display
            
            id1 = widget_info(Event.top, find_by_uname="DISPLAY_WINDOW_1")
            widget_control, id1, map=1		
            
            plot_data_BSS, event
            
        end
    endcase
    
    id=widget_info(Event.top,FIND_BY_UNAME="HISTOGRAM_STATUS")
    text = "done"
    widget_control, id, set_value = text, /append 
    
endif else begin                ;if button released
    
    id = widget_info(Event.top, find_by_uname="MAIN_BASE")
    widget_control, id, scr_xsize=(*global).xsize
    
    id_button = widget_info(Event.top, find_by_uname='DISPLAY_BUTTON')
    widget_control, id_button, set_value='Activate preview'

    (*global).display_button_activate = 0

endelse

widget_control, id_display, sensitive=1

end

  
  
  



  
pro CLOSE_COMPLETE_XML_DISPLAY_TEXT_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize

end







pro COMPLETE_RUNINFO_FILE_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument =  (*global).instrument

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize_display
   
cmd = "less " + (*global).runinfo_xml_filename
spawn, cmd, listening, err_listening
output_error, Event, 'log_book_text', err_listening

id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_XML_DISPLAY_TEXT")
widget_control, id, set_value = listening

end







pro COMPLETE_CVINFO_FILE_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument =  (*global).instrument

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize_display
   
cmd = "less " + (*global).cvinfo_xml_filename
spawn, cmd, listening, err_listening
output_error, Event, 'log_book_text', err_listening

id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_XML_DISPLAY_TEXT")
widget_control, id, set_value = listening

end









;____________________________________________________________________________________

function display_xml_info, filename, item_name

no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN

    CATCH,/CANCEL
    return, ''

ENDIF ELSE BEGIN
    
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=filename)
    
    oDocList = oDoc->GetElementsByTagName('DetectorInfo')
    obj1 = oDocList->item(0)
    
    obj2=obj1->GetElementsByTagName('Scattering')
    obj3=obj2->item(0)
    
    obj4=obj3->GetElementsByTagName('NumTimeChannels')
    obj5=obj4->item(0)
    
    obj5b=obj5->getattributes()
    obj5c=obj5b->getnameditem(item_name)

    return, obj5c->getvalue()

ENDELSE
end






PRO xml_object_recurse, oNode, match, return_value

;check to see if this node matches the one we're looking for
if oNode->GetNodeName() EQ match then begin
;case where we find a match
;now we have to get the first child of this node to get the value
;for this node
   		oSibling = oNode->GetFirstChild()
;now that we found the sibling, save the result and pass it all the way back
;to the top
		if OBJ_VALID(oSibling) then return_value = oSibling->GetNodeValue()
end
   ; Visit children - process of recursing deeper into the object tree
   oSibling = oNode->GetFirstChild()
   WHILE OBJ_VALID(oSibling) DO BEGIN
      xml_object_recurse, oSibling, match, return_value
      oSibling = oSibling->GetNextSibling()
   ENDWHILE
END







;function that creates the XML object
function get_xml_value, NodeName, filename

no_error = 0
CATCH, no_error
if (no_error NE 0) THEN BEGIN
    catch,/cancel
    return, ''
endif else begin
;create XML object and load file
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=filename)
;now load it with our xml file of interest
;   oDoc->Load, filename
;initiate the variable that will contain the data we're interested in
    return_value = ''
;recurse the object tree and find what we're looking for
    xml_object_recurse, oDoc, NodeName, return_value
;	print,'Return Value: ',return_value
;send the findings back to the calling program
    return, return_value
;cleanup memory and destroy the object
    OBJ_DESTROY, oDoc
endelse
END








function read_xml_file, filename, nodename

filename = filename[0]
;and the nodename (xml key) for the data they want
;call the function to get the value we're looking for from the xml file
xml_node_value = get_xml_value(NodeName,filename)

return, xml_node_value

end






function check_access, Event, instrument, user

list_of_instrument = ['REF_L', 'REF_M', 'BSS']

;0:j35:jean / 1:pf9:pete / 2:2zr:michael / 3:mid:steve / 4:1qg:rick / 5:ha9:haile / 6:vyi:frank / 7:vuk:john 
;8:x4t:xiadong / 9:ele:eugene
list_of_users = ['j35','pf9','2zr','mid','1qg','ha9','vyi','vuk','x4t','ele']

;check if ucams is in the list
user_index=-1
for i =0, 9 do begin
   if (user EQ list_of_users[i]) then begin
     user_index = i
     break 
   endif
endfor

;for now, all users have access
user_index = 0

;;check if user is autorized for this instrument
; CASE instrument OF		
;    ;REF_L
;    0: CASE user_index OF
;         -1:
;         0:                      ;authorized
;         1:                      ;authorized
;         2:                      ;authorized
;         3:                      ;authorized
;         7:                      ;authorized
;         8:                      ;authorized
;         else: user_index=-1	;unauthorized
;       ENDCASE
;    ;REF_M
;    1: CASE user_index OF
; 	-1:
; 	0: 
; 	1: 
; 	2: 
; 	3: 
; 	4: 
; 	5: 
; 	6: 
; 	else: user_index=-1
;       ENDCASE
;    ;BSS
;    2: CASE user_index OF
; 	-1:
; 	0: 
; 	1: 
; 	2: 
; 	3: 
;         9:
; 	else: user_index=-1
;       ENDCASE
; ENDCASE	 
	
RETURN, user_index

end







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





;--------------------------------------------------------------------------------
; \brief main function that plot the window
;
; \argument wWidget (INPUT) 
;--------------------------------------------------------------------------------
pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/images/rebin_nexus_gui_logo.bmp"
id = widget_info(wWidget,find_by_uname="logo_message_draw")
WIDGET_CONTROL, id, GET_VALUE=id_value
wset, id_value
image = read_bmp(image_logo)
tv, image,0,0,/true

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



; \brief Empty stub procedure used for autoloading.
;
pro rebin_nexus_eventcb
end






pro REBINNING_TYPE_GROUP_CP, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, FIND_BY_UNAME='REBINNING_TYPE_GROUP')
WIDGET_CONTROL, id, GET_VALUE = value

REBINNING_LABEL_wT1_id = widget_info(Event.top,find_by_uname='REBINNING_LABEL_wT1')
REBINNING_TEXT_wT1_id = widget_info(Event.top,find_by_uname='REBINNING_TEXT_wT1')

if (value EQ 0) then begin
    text = 'Rebin value (microS)'
    value = strcompress((*global).default_rebin_coeff,/remove_all)
endif else begin
    text = 'Rebin coefficient'
    value = strcompress((*global).default_log_rebin_coeff,/remove_all)
endelse
	
widget_control, REBINNING_LABEL_wT1_id, set_value=text
widget_control, REBINNING_TEXT_wT1_id, set_value=value

end






function get_full_path_to_preNeXus_path, listening, instrument, run_number

string_to_remove = instrument + "_" + strcompress(run_number,/remove_all)
string_to_remove += "_cvinfo.xml"
full_path=strsplit(listening,string_to_remove,/extract,/regex)
full_path += '/'
return, full_path

end


;return 1 if file is an event file
;return 0 if file is a histogram file
;return -1 if there is no event of histogram file
function check_if_file_is_event, event, name_if_event, name_if_histogram

check_cmd = "ls " + name_if_event
spawn, check_cmd, listening, err_listening
output_error, event, 'log_book_text', err_listening

if (listening EQ '') then begin
    
    check_histo_cmd = "ls " + name_if_histogram
    spawn, check_histo_cmd, listening_histo

    if (listening_histo EQ '') then begin

        result = -1

    endif else begin

        result = 0

    endelse

endif else begin

    result = 1

endelse

return, result

end





pro reinitialize_display, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;hide histo_file_infos main_base
id = widget_info(Event.top, FIND_BY_UNAME="HIDE_HISTO_BASE")
widget_control, id, map=1

;hide event file interaction box
id = widget_info(Event.top, FIND_BY_UNAME="HISTO_INFO_BASE")
widget_control, id, map=0

;reinitialize xml text boxes
;name of xml file
id = widget_info(Event.top, FIND_BY_UNAME = "XML_FILE_TEXT")
text = ''
widget_control, id, set_value=text	

;get number of pixels
id = widget_info(Event.top, FIND_BY_UNAME="NUMBER_PIXELIDS_TEXT_tab1")
widget_control, id, set_value=text

;Title
id = widget_info(Event.top, FIND_BY_UNAME = "TITLE_TEXT")
widget_control, id, set_value=text

;Notes
id = widget_info(Event.top, FIND_BY_UNAME = "NOTES_TEXT")
widget_control, id, set_value=text

;SpecialDesignation
id = widget_info(Event.top, FIND_BY_UNAME = "SPECIAL_DESIGNATION")
widget_control, id, set_value=text

;Script ID
id = widget_info(Event.top, FIND_BY_UNAME = "SCRIPT_ID_TEXT")
widget_control, id, set_value=text

;file type
id = widget_info(Event.top, FIND_BY_UNAME="HISTO_EVENT_FILE_TYPE_RESULT")
widget_control, id, set_value=""

;desactivate xml buttons
runinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_RUNINFO_FILE")
widget_control, runinfo_id, sensitive=0
cvinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_CVINFO_FILE")
widget_control, cvinfo_id, sensitive=0

;reinitialize histogram status
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
text = ''
WIDGET_CONTROL, view_info, SET_VALUE=text

;create temporary folder
;check if temporary folder exists (if yes, remove it and recreate it)
tmp_nxdir_folder = (*global).tmp_nxdir_folder
full_tmp_nxdir_folder_path = (*global).output_path + tmp_nxdir_folder
(*global).full_tmp_nxdir_folder_path = full_tmp_nxdir_folder_path

; cmd_check = "ls -d " + full_tmp_nxdir_folder_path
; spawn, cmd_check, listening, err_listening
; output_error, Event, 'log_book_text',err_listening

; if (listening NE '') then begin
;     cmd_remove = "rm -r " + full_tmp_nxdir_folder_path
;     spawn, cmd_remove, listening, err_listening
;     output_error, Event, err_listening
; endif

;now create tmp folder
cmd_create = "mkdir " + full_tmp_nxdir_folder_path
spawn, cmd_create,  listening, err_listening
output_error, Event, 'log_book_text', err_listening

already_archived_base_id = widget_info(Event.top,find_by_uname='already_archived_base')
widget_control, already_archived_base_id, map=0

end

















pro OPEN_HISTO_EVENT_FILE_CB, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
full_view_info = widget_info(Event.top,find_by_uname='log_book_text')

;indicate reading data with hourglass icon
widget_control,/hourglass

;reinitialize window
reinitialize_display, Event

;desactive 'CREATE_NEXUS' button
rb_id=widget_info(Event.top, FIND_BY_UNAME='CREATE_NEXUS')
widget_control,rb_id,sensitive=0

;name of current instrument
instrument = (*global).instrument  ;REF_M, REF_L or BSS

;store run_number
run_number_id = widget_info(Event.top, FIND_BY_UNAME='HISTO_EVENT_FILE_TEXT_BOX')
widget_control, run_number_id, get_value=run_number
run_number=strcompress(run_number,/remove_all)

;check if there is only 1 run number or not
run_number_array = strsplit(run_number,',',/extract,count=length)
(*(*global).list_of_runs) = run_number_array
run_number = run_number_array[0] ;run that will be the matrix if other are added
(*global).run_number = run_number
(*global).nbr_nexus_file = length

general_message_id = widget_info(Event.top,find_by_uname='general_message')
if (length GT 1) then begin
    text = 'Metadata provided by run # ' + strcompress(run_number)
endif else begin
    text = ''
endelse
widget_control, general_message_id, set_value=text

wrong_run_number_format = 0
;CATCH, wrong_run_number_format

if (wrong_run_number_format ne 0) then begin ;run number is not a number
    
    widget_control, view_info, SET_VALUE="ERROR: Invalid run number"
    widget_control, full_view_info, $
      set_value='!! Program terminated: invalid run number !!',/append
    
    id_display = widget_info(Event.top, FIND_BY_UNAME="DISPLAY_BUTTON")
    widget_control, id_display, sensitive=0
    
    runinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_RUNINFO_FILE")
    widget_control, runinfo_id, sensitive=0
    
    cvinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_CVINFO_FILE")
    widget_control, cvinfo_id, sensitive=0
    
    archive_nexus_base_id = widget_info(Event.top, find_by_uname='archive_nexus_base')
    widget_control, archive_nexus_base_id, map=0

    already_archived_base_id = widget_info(Event.top, find_by_uname='already_archived_base')
    widget_control, already_archived_base_id, map=0
    
endif else begin
    
;get full preNeXus and NeXus path
    run_number = strcompress(run_number,/remove_all)
    full_text = 'Opening run # ' + run_number
    widget_control, full_view_info, set_value=full_text

    cmd_findnexus = "findnexus -i" + instrument
    cmd_findnexus += " " + run_number 
;    cmd_findnexus += " " + run_number + ' --archive '
    cmd_findprenexus = cmd_findnexus + " --prenexus "

    full_text = 'Find NeXus path: >' + cmd_findnexus
    widget_control, full_view_info, set_value=full_text, /append
    spawn, cmd_findnexus, listening_nexus, err_listening
    output_error, Event, 'log_book_text', err_listening

    full_text = '--> ' + listening_nexus
    widget_control, full_view_info, set_value=full_text, /append

    full_text = 'Find preNeXus path: >' + cmd_findprenexus
    widget_control, full_view_info, set_value=full_text, /append
    spawn, cmd_findprenexus, listening_prenexus, err_listening
    output_error, Event, 'log_book_text', err_listening

    full_text = '--> ' + listening_prenexus
    widget_control, full_view_info, set_value=full_text, /append
    
;check if nexus exist, if yes, it has been archived
    full_path_to_nexus = get_full_path_to_preNeXus_path(listening_nexus,$
                                                        instrument,$
                                                        run_number)

    full_path_to_prenexus = get_full_path_to_preNeXus_path(listening_prenexus,$
                                                           instrument,$
                                                           run_number)
    (*global).full_path_to_nexus = full_path_to_nexus
    
;/SNSlocal/instrument/
    local_string = '/SNSlocal/' + (*global).instrument + '/*'
    result_local = strmatch(full_path_to_nexus,local_string)

;/SNS/instrument/
;    result_archived = strmatch(full_path_to_nexus,"ERROR*")
    archived_string = 'SNS/'+(*global).instrument + '/*'
    result_archived = strmatch(full_path_to_nexus,archived_string)

;    archive_nexus_base_id = widget_info(Event.top,find_by_uname='archive_nexus_base')
    already_archived_label_id = widget_info(Event.top,find_by_uname='already_archived_label')
    already_archived_base_id = widget_info(Event.top,find_by_uname='already_archived_base')
    CREATE_NEXUS_id = widget_info(Event.top, find_by_uname='CREATE_NEXUS')

    if (result_archived[0] EQ 1) then begin ;file already archived

        (*global).already_archived = 1
        full_text = 'Run number already archived'
        widget_control, full_view_info, set_value=full_text, /append
        widget_control, already_archived_label_id, set_value=full_text
        find_nexus = 1
        widget_control, CREATE_NEXUS_id, set_value='Create local NeXus'
        widget_control, already_archived_base_id, map=1

    endif else begin ;file not archived yet

        if (result_local[0] EQ 1) then begin ;NeXus is in /SNSlocal/instrument/
            
            full_text = 'Not archived but in /SNSlocal/' + (*global).instrument
            widget_control, full_view_info, set_value=full_text, /append
            widget_control, already_archived_label_id, set_value=full_text
            find_nexus = 1
            
        endif else begin

            (*global).already_archived = 0
            full_text = 'Run number has not been archived yet'
            widget_control, full_view_info, set_value=full_text, /append
            widget_control, already_archived_label_id, set_value=full_text
            find_nexus = 0

        endelse

    endelse
    widget_control, already_archived_base_id, map=1

;get only path up to preNeXus path
    full_text = 'Get full path to preNeXus folder:'
    widget_control, full_view_info, set_value=full_text, /append
    full_path_to_prenexus = get_full_path_to_preNeXus_path(listening_prenexus,$
                                                           instrument,$
                                                           run_number)
    full_text = '--> ' + full_path_to_prenexus
    widget_control, full_view_info, set_value=full_text, /append

;check if prenexus exists
    result = strmatch(full_path_to_prenexus,"ERROR*")
    if (result[0] GE 1) then begin ;preNeXus does not exist

        full_text = 'This run number (' + run_number + ') does not exist'
        widget_control, full_view_info, set_value=full_text, /append
        find_prenexus = 0

    endif else begin ;preNeXus exist

        (*global).full_path_to_prenexus = full_path_to_prenexus
        find_prenexus = 1
;check if full_path_to_preNeXus is not on DAS
        match = "*" + instrument + "-DAS-FS/*"
        result_of_find_prenexus_on_DAS = strmatch(full_path_to_prenexus,match)
        
        if (result_of_find_prenexus_on_DAS[0] GE 1) then begin ;preNeXus exist only on DAS
            find_prenexus_on_das = 1
            (*global).find_prenexus_on_das = find_prenexus_on_das
            full_text = 'This run number only exists on the DAS system'
            widget_control, full_view_info, set_value=full_text, /append
        endif else begin ;preNeXus exist other than on DAS (= has been archived)
            find_prenexus_on_das = 0
            full_text = 'This run number was found in another place than the DAS'
            widget_control, full_view_info, set_value=full_text, /append
            (*global).find_prenexus_on_das = find_prenexus_on_das
        endelse
        
    endelse
    
    if (find_prenexus EQ 0) then begin ;run number does not exist
        
    endif else begin ;run number exists
        
;check if file is event or histo
        full_path_instr_run_number = full_path_to_prenexus + '/' + instrument + "_"
        full_path_instr_run_number += strcompress(run_number,/remove_all)
        (*global).full_path_instr_run_number = full_path_instr_run_number
        name_if_event = full_path_instr_run_number + "_neutron_event.dat"
        name_if_histogram = full_path_instr_run_number + "_neutron_histo.dat"
        main_file_is_event = check_if_file_is_event(event, name_if_event,name_if_histogram)
        full_text = 'Check if binary file is event or histo:'
        widget_control, full_view_info, set_value=full_text, /append
        
        if (main_file_is_event EQ 1) then begin ;file is an event file
            
            is_file_histo = 0   ;file is an event
                                ;produce name of main file
            (*global).is_file_histo = is_file_histo
            full_histo_event_filename = name_if_event
            (*global).histo_event_filename = full_histo_event_filename
            full_text = '-> EVENT file'
            widget_control, full_view_info, set_value=full_text, /append
            
        endif else begin
            
            if (main_file_is_event EQ 0) then begin ;file is a histogram file
                
                is_file_histo = 1 ;file is a histogram
                                ;produce name of main file
                (*global).is_file_histo = is_file_histo
                full_histo_event_filename = full_path_instr_run_number + "_neutron_histo.dat"
                (*global).histo_event_filename = full_histo_event_filename            
                full_text = '-> HISTOGRAM file'
                widget_control, full_view_info, set_value=full_text, /append
                
            endif else begin    ;there is no event or histogram file
                
                is_file_histo = -1
                (*global).is_file_histo = is_file_histo
                full_text = '-> UNKNOWN file '
                widget_control, full_view_info, set_value=full_text, /append
                
            endelse
            
        endelse

;get info from xml files
;determine name of xml files
        cvinfo_xml_filename = full_path_instr_run_number + "_cvinfo.xml"
        runinfo_xml_filename = full_path_instr_run_number + "_runinfo.xml"
        
        runinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_RUNINFO_FILE")
        widget_control, runinfo_id, sensitive=1
        
        cvinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_CVINFO_FILE")
        widget_control, cvinfo_id, sensitive=1
        
        (*global).cvinfo_xml_filename = cvinfo_xml_filename
        (*global).runinfo_xml_filename = runinfo_xml_filename
        
;name of xml file
        id = widget_info(Event.top, FIND_BY_UNAME = "XML_FILE_TEXT")
        text = instrument + "_" + run_number
        widget_control, id, set_value=string(text[0])	
        
;get number of pixels
        pixel_number = read_xml_file(runinfo_xml_filename, "MaxScatPixelID")
        pixel_number = strcompress(pixel_number,/remove_all)
        (*global).pixel_number = pixel_number
        id = widget_info(Event.top, FIND_BY_UNAME="NUMBER_PIXELIDS_TEXT_tab1")
        widget_control, id, set_value=string(pixel_number)
        
;Title
        id = widget_info(Event.top, FIND_BY_UNAME = "TITLE_TEXT")
        text = read_xml_file(runinfo_xml_filename, "Title")
        if (strlen(text) GT 40) then begin
            text = strmid(text,0,38) + "[...]"
        endif
        widget_control, id, set_value=string(text)
        
;Notes
        id = widget_info(Event.top, FIND_BY_UNAME = "NOTES_TEXT")
        text = read_xml_file(runinfo_xml_filename, "Notes")
        if (strlen(text) GT 40) then begin
            text = strmid(text,0,38) + "[...]"
        endif
        widget_control, id, set_value=string(text)
        
;SpecialDesignation
        id = widget_info(Event.top, FIND_BY_UNAME = "SPECIAL_DESIGNATION")
        text = read_xml_file(runinfo_xml_filename, "SpecialDesignation")
        if (strlen(text) GT 30) then begin
            text = strmid(text,0,28) + "[...]"
        endif
        widget_control, id, set_value=text
        
;Script ID
        id = widget_info(Event.top, FIND_BY_UNAME = "SCRIPT_ID_TEXT")
        text = read_xml_file(runinfo_xml_filename, "scriptID")
        if (strlen(text) GT 20) then begin
            text = strmid(text,0,18) + "[...]"
        endif
        widget_control, id, set_value=text
        
        case is_file_histo of
            
            1: begin            ;file is histogram
                
                id = widget_info(Event.top, $
                                 FIND_BY_UNAME="HISTO_EVENT_FILE_TYPE_RESULT")
                widget_control, id, set_value="histogram"
                
;activate histo_file_infos main_base
                id = widget_info(Event.top, $
                                 FIND_BY_UNAME="HIDE_HISTO_BASE")
                widget_control, id, map=1
                
;hide event file interaction box
                id = widget_info(Event.top, FIND_BY_UNAME="HISTO_INFO_BASE")
                widget_control, id, map=1
                
;get number of pixels and number of tof from file
                
                case (*global).instrument of
                    "REF_L": 	begin
                        Nimg = (*global).Nimg_REF_L
                    end
                    "REF_M": 	begin
                        Nimg = (*global).Nimg_REF_M
                    end
                    "BSS": 	begin
                        Nimg = long(strcompress(pixel_number))
                    end
                endcase
                (*global).pixel_number = Nimg
                
                file = full_histo_event_filename
                full_text = 'Open file to collect infos: ' + file
                widget_control, full_view_info, set_value=full_text,/append
                openr,u,file,/get
                
;find out file info
                fs = fstat(u)
                Ntof = fs.size/(Nimg*4L)
                close, u
                free_lun, u
                
                id = widget_info(Event.top, FIND_BY_UNAME = "HISTO_INFO_NUMBER_PIXELIDS_TEXT")
                widget_control, id, set_value = strcompress(Nimg,/remove_all)
                
                id = widget_info(Event.top, FIND_BY_UNAME = "HISTO_INFO_NUMBER_BINS_TEXT")
                widget_control, id, set_value = strcompress(NTOF,/remove_all)
                
;will create a local nexus file
                id_create_nexus = widget_info(Event.top, FIND_BY_UNAME="CREATE_NEXUS")
                widget_control, id_create_nexus, sensitive=1
            end
            
            0: begin            ;file is event
                
;activate "Create local NeXus" button
                id_create_nexus = widget_info(Event.top, FIND_BY_UNAME="CREATE_NEXUS")
                widget_control, id_create_nexus, sensitive=1
                
                id = widget_info(Event.top, FIND_BY_UNAME="HISTO_EVENT_FILE_TYPE_RESULT")
                widget_control, id, set_value="event"
                
                id = widget_info(Event.top, FIND_BY_UNAME="HISTO_INFO_BASE")
                widget_control, id, map=0
                
;get number of pixels
                pixel_number = read_xml_file(runinfo_xml_filename, "MaxScatPixelID")
                pixel_number = strcompress(pixel_number,/remove_all)
                id = widget_info(Event.top, FIND_BY_UNAME="NUMBER_PIXELIDS_TEXT_tab1")
                widget_control, id, set_value=pixel_number	
                
                item_value = display_xml_info(runinfo_xml_filename, "startbin")
                id = widget_info(Event.top, FIND_BY_UNAME="MIN_TIME_BIN_TEXT_wT1")
                widget_control, id, set_value=item_value
                
                item_value = display_xml_info(runinfo_xml_filename, "endbin")
                id = widget_info(Event.top, FIND_BY_UNAME="MAX_TIME_BIN_TEXT_wT1")
                widget_control, id, set_value=item_value
                (*global).max_time_bin = strcompress(item_value,/remove_all)
                
                id = widget_info(Event.top, FIND_BY_UNAME="HIDE_HISTO_BASE")
                widget_control, id, map=0
                
            end
            
            else: begin         ;there is no histogram or event file
                
                txt = "No event or histogram files detected"
                view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
                WIDGET_CONTROL, view_info, SET_VALUE=txt, /APPEND
                
            end
            
        endcase
        
        if ((*global).display_button_activate EQ 1) then begin
            
            case instrument of        
                
                "REF_L": begin
                    view_info = widget_info(Event.top, FIND_BY_UNAME="DISPLAY_WINDOW")
                    WIDGET_CONTROL, view_info, GET_VALUE=id
                    wset, id
                    erase
                    if (is_file_histo NE -1) then begin
                        create_local_copy_of_histo_mapped, $
                          Event, $
                          find_prenexus_on_das,$
                          if_file_histo
                        
                        plot_data_REF_L, event
                    endif 
                end
                
                "REF_M": begin
                    view_info= widget_info(Event.top, FIND_BY_UNAME="DISPLAY_WINDOW")
                    WIDGET_CONTROL, view_info, GET_VALUE=id
                    wset, id
                    erase
                    if (is_file_histo NE -1) then begin
                        create_local_copy_of_histo_mapped, $
                          Event, $
                          find_prenexus_on_das,$
                          is_file_histo

                        plot_data_REF_M, event      
                    endif
                end
                
                "BSS"  : begin
                    view_info_0 = widget_info(Event.top,FIND_BY_UNAME='DISPLAY_WINDOW_0')
                    view_info_1 = widget_info(Event.top,FIND_BY_UNAME='DISPLAY_WINDOW_1')
                    WIDGET_CONTROL, view_info_0, GET_VALUE=id_0
                    WIDGET_CONTROL, view_info_1, GET_VALUE=id_1
                    wset,id_0
                    erase
                    wset,id_1 
                    erase
                    if (is_file_histo NE -1) then begin
                        create_local_copy_of_histo_mapped, $
                          Event, $
                          find_prenexus_on_das, $
                          is_file_histo

                        plot_data_BSS, event
                    endif
                end
            endcase
            
        endif
        
    endelse
    
endelse

end






pro NUMBER_PIXEL_IDS_CB, event
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers
end




pro REBINNING_TEXT_CB, event
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers
end




pro MAX_TIME_BIN_TEXT_CB, event
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers
end





pro  DEFAULT_PATH_BUTTON_CB, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path = (*global).output_path
output_path = dialog_pickfile(path=path, /directory, title="Select the output file")

if (output_path EQ '') then begin
    output_path = (*global).output_path
endif

id = widget_info(Event.top, FIND_BY_UNAME='DEFAULT_FINAL_PATH_tab2')
widget_control, id, set_value=output_path

(*global).output_path = output_path

end







pro GO_HISTOGRAM_CB, event, full_folder_name_preNeXus, file

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
full_view_info = widget_info(Event.top,find_by_uname='log_book_text')

;linear or log rebinning
id = widget_info(Event.top, FIND_BY_UNAME='REBINNING_TYPE_GROUP')
WIDGET_CONTROL, id, GET_VALUE = linear_rebinning

;in GO_HISTOGRAM, we need to get widget values of tab 1 to do our work
id_0 = Widget_Info(event.top, FIND_BY_UNAME='REBINNING_TYPE_GROUP')
WIDGET_CONTROL, id_0, GET_VALUE = lin_log

id_1 = Widget_Info(event.top, FIND_BY_UNAME='NUMBER_PIXELIDS_TEXT_tab1')
WIDGET_CONTROL, id_1, GET_VALUE =number_pixels

id_2 = Widget_Info(event.top, FIND_BY_UNAME='REBINNING_TEXT_wT1')
WIDGET_CONTROL, id_2, GET_VALUE =rebinning

id_3 = Widget_Info(event.top, FIND_BY_UNAME='MAX_TIME_BIN_TEXT_wT1')
WIDGET_CONTROL, id_3, GET_VALUE =max_time_bin

id_4 = Widget_Info(event.top, FIND_BY_UNAME='MIN_TIME_BIN_TEXT_wT1')
WIDGET_CONTROL, id_4, GET_VALUE =min_time_bin

(*global).lin_log = lin_log
(*global).number_pixels = number_pixels
(*global).rebinning = rebinning
(*global).max_time_bin = max_time_bin
(*global).min_time_bin = min_time_bin

;if there is more than one NeXus run number, create an append file
;somewhere and used that event file instead.
nbr_nexus_file = (*global).nbr_nexus_file
if (nbr_nexus_file GT 1) then begin
    full_text = 'Nbr of nexus file: ' + strcompress(nbr_nexus_file)
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
    file = create_append_event_file(event)
endif 

if (linear_rebinning EQ 0) then begin ;linear rebinning

    cmd_line_histo = "Event_to_Histo "
    cmd_line_histo += "-l " + strcompress(rebinning,/remove_all)
    cmd_line_histo += " -M " + strcompress(max_time_bin,/remove_all)
    cmd_line_histo += " --time_offset " + strcompress(min_time_bin,/remove_all)
    cmd_line_histo += " -p " + strcompress(number_pixels,/remove_all)
    cmd_line_histo += " -a " + strcompress(full_folder_name_preNeXus,$
                                           /remove_all)
    cmd_line_histo += " " + file
    
;launch histogramming
    full_text = "Processing histogramming (linear)....."
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
    full_text = "   > " + cmd_line_histo
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

    str_time = systime(1)
    spawn, cmd_line_histo, listening, err_listening
    output_error, Event, 'log_book_text', err_listening
    end_time = systime(1)
    full_time = (end_time - str_time)
    full_text = "....Done in " + strcompress(full_time,/remove_all) + 's'
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

endif else begin ;log rebinning

    cmd_line_histo = "Event_to_Histo "
    cmd_line_histo += "-L " + strcompress(rebinning,/remove_all)
    cmd_line_histo += " -M " + strcompress(max_time_bin,/remove_all)
    cmd_line_histo += " -p " + strcompress(number_pixels,/remove_all)
    cmd_line_histo += " -a " + strcompress(full_folder_name_preNeXus,$
                                           /remove_all)
    cmd_line_histo += " " + file
    
;launch histogramming
    full_text = "Processing histogramming (logarithmic)....."
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
    full_text = "   > " + cmd_line_histo
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

    str_time = systime(1)
    spawn, cmd_line_histo, listening, err_listening
    output_error, Event, 'log_book_text', err_listening
    end_time = systime(1)
    full_time = (end_time - str_time)
    full_text = "....Done in " + strcompress(full_time,/remove_all) + 's'
    WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

endelse

;determine name of histo file
full_text = '   * Full name of event file: ' + file
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
event_filename = file

full_text = '   * Name of event file: '
neutron_event_file_name_only = get_event_file_name_only(event_filename)
full_text += neutron_event_file_name_only
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

full_text = '   * Name of histo file: '
histo_file_name_only = get_histo_event_file_name_only(Event,$
                                                      neutron_event_file_name_only)
(*global).histo_file_name_only = histo_file_name_only
full_text += histo_file_name_only
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

path = (*global).full_local_folder_name_preNeXus
full_histo_file_name = path + histo_file_name_only
full_histo_mapped_file_name = path + (*global).histo_mapped_file_name_only
full_text = '   * Full histo file name (NEW FILE CREATED): ' + full_histo_file_name
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
full_text = '   * Full histo mapped file name: ' + full_histo_mapped_file_name
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
    
;MAPPING OF HISTO FILE

;get full_name of timemap.dat file
full_timemap_file_name = get_full_timemap_file_name(full_histo_file_name)
openr,u,full_timemap_file_name,/get
fs = fstat(u)
number_tbin = fs.size/(4L)-1
close, u
free_lun, u

;number_tbin = ((*global).max_time_bin - $
;               (*global).min_time_bin) / (*global).rebinning
(*global).number_tbin = number_tbin
    
id = widget_info(Event.top, FIND_BY_UNAME="MAPPING_FILE_LABEL")
widget_control, id, get_value=mapping_filename
cmd_line_mapping = "Map_Data "
cmd_line_mapping += "-m " + mapping_filename
cmd_line_mapping += " -n " + full_histo_file_name
cmd_line_mapping += " -p " + strcompress(number_pixels, /remove_all)
cmd_line_mapping += " -t " + strcompress(number_tbin, /remove_all)

text = "Processing mapping....."
WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
cmd_line_displayed = "> " + cmd_line_mapping
WIDGET_CONTROL, full_view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch mapping
str_time = systime(1)
spawn, cmd_line_mapping, listening, err_listening
output_error, Event, 'log_book_text', err_listening
end_time = systime(1)    
full_time = end_time - str_time
full_text = '...done in ' + strcompress(full_time,/remove_all) + 's'
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

full_text = '    * Full histo mapped file name: ' + full_histo_mapped_file_name
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

;remove histo_file name
full_text = 'Removed histo file name (' + full_histo_file_name + ')...'
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
cmd_remove_histo = "rm -r " + full_histo_file_name
spawn, cmd_remove_histo, listening, err_listening
output_error, Event, 'log_book_text', err_listening
full_done = '...removed done'
WIDGET_CONTROL, full_view_info, SET_VALUE=full_done, /APPEND

end










pro CREATE_NEXUS_CB, event

wWidget = Event.top

;get the global data structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;desactivate GO_NEXUS button
rb_id=widget_info(wWidget, FIND_BY_UNAME='CREATE_NEXUS')
widget_control,rb_id,sensitive=0

;display what is going on
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
full_view_info = widget_info(Event.top,find_by_uname='log_book_text')

text = "Create NeXus..."
full_text = "Create NeXus:"
WIDGET_CONTROL, view_info, SET_VALUE=text
widget_control, full_view_info, set_value=full_text, /append

file = (*global).histo_event_filename
run_number = (*global).run_number
instrument = (*global).instrument 

if ((*global).already_archived EQ 1) then begin ;file has already been archived

    if ((*global).is_file_histo EQ 1) then begin ;file is histogram

        archive_run_dir = get_archive_run_dir(file)

        cmd_translate = '/SNS/software/bin/TS_translate.sh '
        cmd_translate += archive_run_dir
;tmp directory
        cmd_translate += ' --tempdir ' + (*global).full_tmp_nxdir_folder_path 
        
        parent_folder_name = (*global).output_path
        cmd_translate += ' --archiveRoot ' + parent_folder_name
        cmd_translate += ' --no_archive'
        
        full_text = ' > ' + cmd_translate
        widget_control, full_view_info, set_value=full_text, /append
        spawn, cmd_translate, listening, err_listening
        output_error, Event, 'log_book_text', err_listening

;check if NeXus is where it should be
        full_nexus_name = find_full_nexus_name(Event, 1, run_number, instrument)

        if ((*global).find_nexus EQ 1) then begin
            text = '..done'
            widget_control, view_info, set_value=text, /append
            text = 'NeXus file: ' + full_nexus_name
            full_text = 'Location of NeXus and preNeXus files: ' + parent_folder_name
            full_text += '/' + (*global).instrument
            widget_control, full_view_info, set_value=full_text, /append        
            full_text = text
            widget_control, full_view_info, set_value=full_text, /append        
            full_text = 'Nexus file has been created with success'
        endif else begin
            text = ' .. ERROR (check log book)'
            full_text = ' Process failed'
        endelse

        widget_control, view_info, set_value=text, /append
        widget_control, full_view_info, set_value=full_text, /append        

    endif else begin
        
        create_nexus_the_old_way, event

    endelse
    
endif else begin                ; file is on DAS
    
    if ((*global).is_file_histo EQ 1) then begin ;file is histogram
        
        ;create folder into home space
        create_folder, event

;isolate proposal number from full file name
        result = get_proposal_experiment_number(event, $
                                                file,$
                                                (*global).already_archived) 
        proposal_number = result[0]
        experiment_number = result[1]
        
        (*global).proposal_number = proposal_number
        (*global).experiment_number = experiment_number
        
        parent_folder_name = (*global).output_path
        
        das_run_dir = get_das_run_dir(file)
        
        full_text = ' ->das run dir: ' + das_run_dir
        widget_control, full_view_info, set_value=full_text, /append

        cmd_translate = 'TS_translate.sh '
        cmd_translate += das_run_dir
        
;tmp directory
        cmd_translate += ' --tempdir ' + (*global).full_tmp_nxdir_folder_path 
        
        cmd_translate += ' --no_archive'
        cmd_translate += ' --archiveRoot ' + parent_folder_name
                
        full_text = ' > ' + cmd_translate
        widget_control, full_view_info, set_value=full_text, /append
        spawn, cmd_translate, listening, err_listening
        output_error, Event, 'log_book_text', err_listening
        
;check if NeXus is where it should be
        full_nexus_name = find_full_nexus_name(Event, 1, run_number, instrument)

        if ((*global).find_nexus EQ 1) then begin
            text = '..done'
            widget_control, view_info, set_value=text, /append
            text = 'Location of NeXus: ' + parent_folder_name
            full_text = 'Location of NeXus and preNeXus files: ' + parent_folder_name
            full_text += '/' + (*global).instrument
            widget_control, view_info, set_value=text, /append
            widget_control, full_view_info, set_value=full_text, /append
            full_text = 'Nexus: ' + full_nexus_name
            widget_control, full_view_info, set_value=full_text, /append
            text = full_text
            widget_control, view_info, set_value=full_text, /append
            full_text = 'Nexus file has been created with success'
            widget_control, full_view_info, set_value=full_text, /append
        endif else begin
            text = ' .. ERROR (check log book)'
            full_text = ' Process failed.'
            widget_control, view_info, set_value=text, /append
            widget_control, full_view_info, set_value=full_text, /append
        endelse
        
    endif else begin
        
        id_0 = Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TYPE_GROUP')
        WIDGET_CONTROL, id_0, GET_VALUE = lin_log
        (*global).lin_log = lin_log
        
        id_1 = Widget_Info(wWidget, FIND_BY_UNAME='NUMBER_PIXELIDS_TEXT_tab1')
        WIDGET_CONTROL, id_1, GET_VALUE =number_pixels
        
        id_2 = Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TEXT_wT1')
        WIDGET_CONTROL, id_2, GET_VALUE =rebinning
        
        id_3 = Widget_Info(wWidget, FIND_BY_UNAME='MAX_TIME_BIN_TEXT_wT1')
        WIDGET_CONTROL, id_3, GET_VALUE =max_time_bin
        
        id_4 = Widget_Info(wWidget, FIND_BY_UNAME='MIN_TIME_BIN_TEXT_wT1')
        WIDGET_CONTROL, id_4, GET_VALUE =min_time_bin
        
        (*global).number_pixels = number_pixels
        (*global).rebinning = rebinning
        (*global).max_time_bin = max_time_bin
        (*global).min_time_bin = min_time_bin
        event_filename = (*global).histo_event_filename
        
        if (lin_log EQ 0) then begin ;linear rebinning
            
            ;remove old directory first
            create_folder, event

            das_run_dir = get_das_run_dir(event_filename)
            
            (*global).default_rebin_coeff = rebinning
            cmd_translate = 'TS_translate.sh '
            cmd_translate += das_run_dir
            cmd_translate += ' --time_width ' + rebinning
            cmd_translate += ' --max_time_bin ' + max_time_bin
            cmd_translate += ' --time_offset ' + min_time_bin
            
;tmp directory
            cmd_translate += ' --tempdir ' + (*global).full_tmp_nxdir_folder_path 
            
            parent_folder_name = (*global).output_path
            cmd_translate += ' --archiveRoot ' + parent_folder_name
            cmd_translate += ' --no_archive'
            
            full_text = ' > ' + cmd_translate
            widget_control, full_view_info, set_value=full_text, /append
            spawn, cmd_translate, listening, err_listening


            
;check if NeXus is where it should be
            full_nexus_name = find_full_nexus_name(Event, 1, run_number, instrument)

            if ((*global).find_nexus EQ 1) then begin
                text = '..done'
                widget_control, view_info, set_value=text, /append
                text = 'Location of NeXus: ' + parent_folder_name
                full_text = 'Location of NeXus and preNeXus files: ' + parent_folder_name
                full_text += '/' + (*global).instrument
                widget_control, view_info, set_value=text, /append
                widget_control, full_view_info, set_value=full_text, /append
                full_text = 'NeXus: ' + full_nexus_name
                (*global).full_local_nexus_name = full_nexus_name
                widget_control, full_view_info, set_value=full_text, /append
            endif else begin
                text = '... ERROR (consult Log Book)'
                output_error, Event, 'log_book_text', err_listening
                widget_control, full_view_info, set_value=listening, /append
                full_text = '.. process failed'
                widget_control, view_info, set_value=text, /append
                widget_control, full_view_info, set_value=full_text, /append
            endelse
            
        endif else begin        ;log rebinning 
                                ;this if for not archive and event files

            (*global).default_log_rebin_coeff = rebinning
                                ;use the old way
            create_nexus_the_old_way, event

        endelse
        
    endelse
    
endelse

end





pro create_folder, event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display what is going on
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
full_view_info = widget_info(Event.top,find_by_uname='log_book_text')

;create folder into working_path directory
full_text = " -> Create folder in working path:"
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

file=(*global).histo_event_filename ;full name of event or histo file
run_number = (*global).run_number ;run number 
is_file_histo = (*global).is_file_histo
already_archived = (*global).already_archived
instrument = (*global).instrument

;isolate proposal number from full file name
result = get_proposal_experiment_number(event, $
                                        file,$
                                        already_archived) 
proposal_number = result[0]
experiment_number = result[1]

(*global).proposal_number = proposal_number
(*global).experiment_number = experiment_number

parent_folder_name = (*global).output_path + instrument
full_folder_name = parent_folder_name + "/" + proposal_number 

if ((*global).translate_use_experiment_number EQ 1) then begin
    full_folder_name += "/" + experiment_number
endif

full_folder_name += "/" + run_number
full_folder_name_preNeXus = full_folder_name + "/preNeXus/"
full_folder_name_NeXus = full_folder_name + "/NeXus/"

(*global).full_local_folder_name = full_folder_name + '/'
(*global).full_local_folder_name_preNeXus = full_folder_name_preNeXus
(*global).full_local_folder_name_NeXus = full_folder_name_NeXus

;;check if folder exists already, if yes, remove it
cmd_folder_exist = "ls -d " + full_folder_name
full_text = "   > " + cmd_folder_exist
widget_control, full_view_info, set_value=full_text, /append

spawn, cmd_folder_exist, listening, err_listening
output_error, Event, 'log_book_text', err_listening

if (listening NE '') then begin ;folder exists, we need to remove it first
    
    cmd_remove_folder = "rm -f -r " + full_folder_name
    cd, (*global).output_path
    spawn, cmd_remove_folder,listening, err_listening
    output_error, Event, 'log_book_text', err_listening

    full_text = "   > " + cmd_remove_folder
    widget_control, full_view_info, set_value=full_text, /append
    
endif 

;create folders
cmd_create_preNeXus_folder = "mkdir -p " + full_folder_name_preNeXus
cmd_create_NeXus_folder = "mkdir -p " + full_folder_name_NeXus

full_text = "   > " + cmd_create_preNeXus_folder
widget_control, full_view_info, set_value=full_text, /append
spawn, cmd_create_preNeXus_folder, listening, err_listening
output_error, Event, 'log_book_text', err_listening

full_text = '   > ' + cmd_create_NeXus_folder 
widget_control, full_view_info, set_value=full_text, /append
spawn, cmd_create_NeXus_folder, listening, err_listening
output_error, Event, 'log_book_text', err_listening

end








pro create_nexus_the_old_way, event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display what is going on
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
full_view_info = widget_info(Event.top,find_by_uname='log_book_text')

;create folder into working_path directory
full_text = " -> Create folder in working path:"
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

file=(*global).histo_event_filename ;full name of event or histo file
run_number = (*global).run_number ;run number 
is_file_histo = (*global).is_file_histo
already_archived = (*global).already_archived
instrument = (*global).instrument

;isolate proposal number from full file name
result = get_proposal_experiment_number(event, $
                                        file,$
                                        already_archived) 
proposal_number = result[0]
experiment_number = result[1]

(*global).proposal_number = proposal_number
(*global).experiment_number = experiment_number

parent_folder_name = (*global).output_path + instrument
full_folder_name = parent_folder_name + "/" + proposal_number 

if ((*global).translate_use_experiment_number EQ 1) then begin
    full_folder_name += "/" + experiment_number
endif

full_folder_name += "/" + run_number
full_folder_name_preNeXus = full_folder_name + "/preNeXus/"
full_folder_name_NeXus = full_folder_name + "/NeXus/"

(*global).full_local_folder_name = full_folder_name + '/'
(*global).full_local_folder_name_preNeXus = full_folder_name_preNeXus
(*global).full_local_folder_name_NeXus = full_folder_name_NeXus

;;check if folder exists already, if yes, remove it
cmd_folder_exist = "ls -d " + full_folder_name
full_text = "   > " + cmd_folder_exist
widget_control, full_view_info, set_value=full_text, /append

spawn, cmd_folder_exist, listening, err_listening
output_error, Event, 'log_book_text', err_listening

if (listening NE '') then begin ;folder exists, we need to remove it first
    
    cmd_remove_folder = "rm -f -r " + full_folder_name
    cd, (*global).output_path
    spawn, cmd_remove_folder,listening, err_listening
    output_error, Event, 'log_book_text', err_listening

    full_text = "   > " + cmd_remove_folder
    widget_control, full_view_info, set_value=full_text, /append
    
endif 

;create folders
cmd_create_preNeXus_folder = "mkdir -p " + full_folder_name_preNeXus
cmd_create_NeXus_folder = "mkdir -p " + full_folder_name_NeXus

full_text = "   > " + cmd_create_preNeXus_folder
widget_control, full_view_info, set_value=full_text, /append
spawn, cmd_create_preNeXus_folder, listening, err_listening
output_error, Event, 'log_book_text', err_listening

full_text = '   > ' + cmd_create_NeXus_folder 
widget_control, full_view_info, set_value=full_text, /append
spawn, cmd_create_NeXus_folder, listening, err_listening
output_error, Event, 'log_book_text', err_listening

;histogrammed and mapped event file and put histo_mapped file in preNeXus folder
full_text = " -> Create histo_mapped file:"
WIDGET_CONTROL, view_info, SET_VALUE=txt, /APPEND
GO_HISTOGRAM_CB, event, full_folder_name_preNeXus, file

full_text = " -> Move files of interest into final location:"
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

;copy files of interest into preNeXus folders
full_path_to_preNeXus = (*global).full_path_to_preNeXus

;copy data
if (already_archived EQ 1) then begin  ;files already archived
    files_to_copy = ["*.xml","*.nxt"]
    for i=0,1 do begin
        cmd_copy = "cp " + full_path_to_preNeXus + files_to_copy[i] + " " + $
          full_folder_name_preNeXus
        text_cmd_copy = '> ' + cmd_copy
        widget_control,full_view_info,set_value=text_cmd_copy,/append
        spawn, cmd_copy, listening, err_listening
        output_error, Event, 'log_book_text', err_listening

        ;changed permission of all files copied
        cmd_permission = "chmod u+w " +  full_folder_name_preNeXus + files_to_copy[0]
        cmd_permission += " " + full_folder_name_preNeXus + files_to_copy[1]
        text_cmd_permission = '> ' + cmd_permission
        widget_control,full_view_info,set_value=text_cmd_permission,/append
        spawn, cmd_permission, listening, err_listening
        output_error, Event, 'log_book_text', err_listening

    endfor
endif else begin ;files not archived yet

;copy beamtimeinfo and cvlist
    path_up_to_proposal = '/' + instrument + (*global).DAS_mouting_point + '/'
    path_up_to_proposal += proposal_number + '/'
    beamtime_info_file_name = path_up_to_proposal + instrument + '_beamtimeinfo.xml'
    cvlist_file_name = path_up_to_proposal + instrument + '_cvlist.xml'

    path_up_to_run_number = path_up_to_proposal + instrument + '_' + run_number + '/'
    other_xml_files = path_up_to_run_number + '/' + '*.xml'

    cmd_copy = 'cp ' + beamtime_info_file_name + ' ' + cvlist_file_name
    cmd_copy += ' ' + other_xml_files
    cmd_copy += ' ' + full_folder_name_preNeXus
    
    text_cmd_copy = '> ' + cmd_copy
    widget_control,full_view_info,set_value=text_cmd_copy,/append
    spawn, cmd_copy, listening, err_listening
    output_error, Event, 'log_book_text', err_listening

endelse

;import geometry and mapping file into same directory
cmd_copy = "cp " + (*global).mapping_file 
cmd_copy += " " + (*global).geometry_file
cmd_copy += " " + full_folder_name_preNeXus
text_cmd_copy = '> ' + cmd_copy
widget_control, full_view_info, set_value=text_cmd_copy, /append
spawn, cmd_copy,listening, err_listening
output_error, Event, 'log_book_text', err_listening
text_done = '...copy done'
widget_control, full_view_info, set_value=text_done, /append

full_text = "-> Merge xml files:"
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

;merge files
cmd_merge = "TS_merge_preNeXus.sh " + (*global).translation_file
cmd_merge += " " + full_folder_name_preNeXus
text_cmd_merge = '> ' + cmd_merge
widget_control, full_view_info, set_value=text_cmd_merge,/append
spawn, cmd_merge,listening, err_listening
output_error, Event, 'log_book_text', err_listening
text_done = '...merge done'
widget_control, full_view_info, set_value=text_done, /append

full_text = "-> translate files:"
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

;create nexus file
cd, full_folder_name_preNeXus
full_nx_file_name = full_folder_name_preNeXus + (*global).instrument
full_nx_file_name += "_" + run_number 
full_nxt_file_name = full_nx_file_name + ".nxt"

cmd_translate = "nxtranslate " + full_nxt_file_name
text_cmd_translate = '> ' + cmd_translate
widget_control, full_view_info, set_value=text_cmd_translate,/append
spawn, cmd_translate,listening, err_listening
output_error, Event, 'log_book_text', err_listening
text_done = '... translation done'
widget_control, full_view_info, set_value=text_done, /append

full_text = "-> Move NeXus file to its final location:"
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND

;move new nexus file into its own location
full_name_of_nexus_file = full_nx_file_name + ".nxs"
cmd_move_NeXus = "mv " + full_name_of_nexus_file 
cmd_move_NeXus += " " + full_folder_name_NeXus
text_cmd_move_NeXus = '> ' + cmd_move_NeXus
WIDGET_CONTROL, full_view_info, SET_VALUE=text_cmd_move_NeXus, /APPEND
spawn, cmd_move_NeXus,listening, err_listening
output_error, Event, 'log_book_text', err_listening
text_done = '... move done'
widget_control, full_view_info, set_value=text_done, /append

full_text = "   * NeXus file:"
WIDGET_CONTROL, full_view_info, SET_VALUE=full_text, /APPEND
full_text = full_folder_name_NeXus + (*global).instrument
full_text += "_" + (*global).run_number + ".nxs"
widget_control, full_view_info, set_value=full_text,/append

;check if NeXus is where it should be
full_nexus_name = find_full_nexus_name(Event, 1, run_number, instrument)
(*global).full_local_nexus_name = full_nexus_name

;activate "Create local NeXus" button
id_create_nexus = widget_info(Event.top, FIND_BY_UNAME="CREATE_NEXUS")
widget_control, id_create_nexus, sensitive=1
id_create_nexus = widget_info(Event.top, FIND_BY_UNAME="CREATE_SHARE_NEXUS")
widget_control, id_create_nexus, sensitive=1

if ((*global).find_nexus EQ 1) then begin
    text = "... done"
    full_text = "... create NeXus is done"
    WIDGET_CONTROL, view_info, SET_VALUE=text, /append
    widget_control, full_view_info, set_value=full_text, /append
    full_text = 'NeXus: ' + full_nexus_name
    (*global).full_local_nexus_name = full_nexus_name
    text = full_text
    widget_control, full_view_info, set_value=full_text, /append
    WIDGET_CONTROL, view_info, SET_VALUE=text, /append
    full_text = 'Nexus file has been created with success'
    widget_control, full_view_info, set_value=full_text, /append
endif else begin
    text = "... ERROR (consult log book)"
    full_text = "... create NeXus failed"
    WIDGET_CONTROL, view_info, SET_VALUE=text, /append
    widget_control, full_view_info, set_value=full_text, /append
endelse

end














pro  tmp1, event
end






pro wTLB_REALIZE, wWidget
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end







pro sns_idl_button_eventcb, Event
spawn, '/SNS/users/j35/IDL/MainInterface/sns_idl_tools &'
end






pro exit_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

; tmp_folder= (*global).full_tmp_nxdir_folder_path

; ;remove temporary file
; if (tmp_folder NE '') then begin
;     cmd_remove = "rm -r " + tmp_folder
;     spawn, cmd_remove, listening, err_listening
; endif

widget_control,Event.top,/destroy
end




pro append_file, event, array_of_full_tmp_event_file_name, nbr_run_check

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_tmp_nxdir_folder_path = (*global).full_tmp_nxdir_folder_path

final_file = array_of_full_tmp_event_file_name[0]
cmd_cat = 'cat '

tmp_file = full_tmp_nxdir_folder_path + '/tmp_append_file.dat'

for i=0,(nbr_run_check-1) do begin
    cmd_cat += ' ' + array_of_full_tmp_event_file_name[i]
endfor
cmd_cat += ' > ' + tmp_file

cmd_cat_text = '> ' + cmd_cat
output_into_text_box, event, 'log_book_text', cmd_cat_text
spawn, cmd_cat, listening, err_listening
output_error, event, 'log_book_text', err_listening

;remove all event_file used
cmd_rm = 'Remove event files used: '
output_into_text_box, event, 'log_book_text', cmd_rm

for i=0,(nbr_run_check-1) do begin
    cmd_rm = 'rm -f ' + array_of_full_tmp_event_file_name[i]
    cmd_rm_text = '> ' + cmd_rm
    output_into_text_box, event, 'log_book_text', cmd_rm_text
    spawn, cmd_rm, listening, err_listening
    output_error, event, 'log_book_text', err_listening
endfor

;replace tmp_file by first event file name used
cmd_replace = 'mv ' + tmp_file + ' ' + array_of_full_tmp_event_file_name[0]
cmd_replace_text = '> ' + cmd_replace
output_into_text_box, event, 'log_book_text', cmd_replace_text
spawn, cmd_replace, listening, err_listening
output_error, event, 'log_book_text', err_listening

end



PRO COPY_NEXUS_INTO_SHARE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;continue only if process has been successful
IF ((*global).find_nexus EQ 1) THEN BEGIN

;display what is going on
    view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
    full_view_info = widget_info(Event.top,find_by_uname='log_book_text')
    
    full_nexus_name = (*global).full_local_nexus_name
    
    instrument = (*global).instrument
    proposal_number = (*global).proposal_number
    run_number = (*global).run_number
    run_number = strcompress(run_number,/remove_all)
    
    ShareFolder = '/SNS/' + instrument
    ShareFolder += '/' + proposal_number
    ShareFolder += '/shared'
    ShareFolder += '/'
    
    Sharefolder2 = '/SNS/' + instrument
    Sharefolder2 += '/shared/'
    
;get the iso8601 format date and time
    formated_date = ''
    get_iso8601, formated_date
    
    nexusFileName = instrument + '_' + run_number
    nexusFileName += '_' + formated_date + '.nxs'
    
    DestNeXus  = ShareFolder + nexusFileName
    DestNeXus2 = ShareFolder2 + nexusFileName 
    
    cp_cmd = 'cp ' + full_nexus_name
    cp_cmd += ' ' + DestNexus
    
    cp_cmd2 = 'cp ' + full_nexus_name
    cp_cmd2 += ' ' + DestNexus2
    
    cp_cmd_text  = '> ' + cp_cmd
    cp_cmd_text2 = '> ' + cp_cmd2
    
    widget_control, full_view_info, set_value=cp_cmd_text, /append
    WIDGET_CONTROL, view_info, SET_VALUE=cp_cmd_text, /append
    spawn, cp_cmd, listening
    status_text = ' .... copy done'
    widget_control, full_view_info, set_value=status_text, /append
    WIDGET_CONTROL, view_info, SET_VALUE=status_text, /append
    
    widget_control, full_view_info, set_value=cp_cmd_text2, /append
    WIDGET_CONTROL, view_info, SET_VALUE=cp_cmd_text2, /append
    spawn, cp_cmd2, listening
    status_text = ' .... copy done'
    widget_control, full_view_info, set_value=status_text, /append
    WIDGET_CONTROL, view_info, SET_VALUE=status_text, /append
ENDIF

END


;format date into ISO8601
PRO get_iso8601, formated_date

dateUnformated = systime()      ;ex: Thu Aug 23 16:15:23 2007
DateArray = strsplit(dateUnformated,' ',/extract) 

;ISO8601 : 2007-08-23T12:20:34-04:00
DateIso = strcompress(DateArray[4]) + '-'

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01'
    'Feb':month='02'
    'Mar':month='03'
    'Apr':month='04'
    'May':month='05'
    'Jun':month='06'
    'Jul':month='07'
    'Aug':month='08'
    'Sep':month='09'
    'Oct':month='10'
    'Nov':month='11'
    'Dec':month='12'
endcase

DateIso += strcompress(month,/remove_all) + '-'
DateIso += strcompress(DateArray[2],/remove_all) + 'T'
DateIso += strcompress(DateArray[3],/remove_all) + '-04:00'
formated_date = DateIso
END

