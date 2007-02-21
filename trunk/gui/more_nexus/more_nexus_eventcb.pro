pro more_nexus_eventcb
end







pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/more_nexus_title.bmp"
id = widget_info(wWidget,find_by_uname="logo_message_draw")
WIDGET_CONTROL, id, GET_VALUE=id_value
wset, id_value
image = read_bmp(image_logo)
tv, image,0,0,/true

;turn off hourglass
widget_control,hourglass=0

end








pro Main_realize_2, wWidget

tlb = get_tlb(wWidget)

;get the global data structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

end









pro display_preview_message, event, instrument, display_status

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

case instrument of

    'REF_L': begin

        id = widget_info(event.top,find_by_uname='drawing')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        wset, id_value
        
        if (display_status EQ 0) then begin
            no_preview="/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_REF_L.bmp"
            image = read_bmp(no_preview)
            tv, image,0,0,/true
        endif else begin
            erase
        endelse

    end

    'REF_M': begin

         id = widget_info(event.top,find_by_uname='drawing')
         WIDGET_CONTROL, id, GET_VALUE=id_value
         wset, id_value

         if (display_status EQ 0) then begin
             no_preview=$
               "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_REF_M.bmp"
             image = read_bmp(no_preview)
             tv, image,0,0,/true
         endif else begin
             erase
         endelse

     end

     'BSS': begin
         id_top = widget_info(event.top,find_by_uname='drawing_top')
         WIDGET_CONTROL, id_top, GET_VALUE=id_top_value

         id_bottom = widget_info(event.top,find_by_uname='drawing_bottom')
         WIDGET_CONTROL, id_bottom, GET_VALUE=id_bottom_value
         
         if (display_status EQ 0) then begin
             no_preview=$
               "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_BSS_top.bmp"
             image = read_bmp(no_preview)
             wset, id_top_value
             tv, image,0,0,/true

             no_preview=$
               "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_BSS_bottom.bmp"
             image = read_bmp(no_preview)
             wset, id_bottom_value
             tv, image,0,0,/true
         endif else begin
             wset, id_top_value
             erase
             wset, id_bottom_value
             erase
         endelse

     end
endcase

end





pro activate_preview_button_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

activate_preview_button_id = widget_info(Event.top,find_by_uname='activate_preview_button')

if ((*global).activate_preview EQ 0) then begin
     text = 'DESACTIVATE PREVIEW'
     value = 1
endif else begin
    text = 'ACTIVATE PREVIEW'
    value = 0
endelse

widget_control, activate_preview_button_id, set_value = text
(*global).activate_preview = value

display_preview_message, event, (*global).instrument, value

end






pro output_data_group_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

output_list_id = widget_info(Event.top,find_by_uname='output_data_group')
widget_control, output_list_id, get_value=selection

number_of_selection = 0 ;number of selection

;event output data
event_id = widget_info(event.top,find_by_uname='event_text_base')
if (selection[0] EQ 1) then begin
    map_value = 1
    number_of_selection += 1
endif else begin
    map_value = 0
endelse
widget_control, event_id, map=map_value

;histogram output data
histogram_id = widget_info(event.top,find_by_uname='histogram_text_base')
if (selection[1] EQ 1) then begin
    map_value = 1
    number_of_selection += 1
endif else begin
    map_value = 0
endelse
widget_control, histogram_id, map=map_value

;timebins output data
timebins_id = widget_info(event.top,find_by_uname='timebins_text_base')
if (selection[2] EQ 1) then begin
    map_value = 1
    number_of_selection += 1
endif else begin
    map_value = 0
endelse
widget_control, timebins_id, map=map_value

;pulseid output data
pulseid_id = widget_info(event.top,find_by_uname='pulseid_text_base')
if (selection[3] EQ 1) then begin
    map_value = 1
    number_of_selection += 1	
endif else begin
    map_value = 0
endelse
widget_control, pulseid_id, map=map_value

;infos output data
infos_id = widget_info(event.top,find_by_uname='infos_text_base')
if (selection[4] EQ 1) then begin
    map_value = 1
    number_of_selection += 1
endif else begin
    map_value = 0
endelse
widget_control, infos_id, map=map_value

output_data_button_base_id = widget_info(event.top,find_by_uname='output_data_button_base')
if (number_of_selection GE 1) then begin ;display go button
    widget_control, output_data_button_base_id, map=1
endif else begin
    widget_control, output_data_button_base_id, map=0
endelse

end







pro output_data_button_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

print, 'in output_data_button_cb'

end






pro open_nexus_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

HISTO_EVENT_FILE_TEXT_BOX_id = widget_info(Event.top,find_by_uname='HISTO_EVENT_FILE_TEXT_BOX')
widget_control, HISTO_EVENT_FILE_TEXT_BOX_id, get_value=run_number_text

;check if file is local or not
local = is_nexus_local(run_number_text)
(*global).local_nexus = local[0]
local_nexus = local[0]

;get run_number
run_number = remove_star_from_string(run_number_text)
(*global).run_number = run_number

instrument = (*global).instrument
;get full nexus path
full_nexus_name = find_full_nexus_name(Event,$
                                       local_nexus,$
                                       run_number,$
                                       instrument)

(*global).full_nexus_name = full_nexus_name

find_nexus = (*global).find_nexus
reinitialize_interface, event, find_nexus, instrument

output_data_base_id = widget_info(event.top,find_by_uname='output_data_base')

if (find_nexus EQ 0 or full_nexus_name EQ '') then begin

    widget_control, output_data_base_id, map=0

    if (local_nexus EQ 0) then begin
        nexus_name = 'Archive '
    endif else begin
        nexus_name = 'Local '
    endelse
    nexus_name += instrument + '_' + strcompress(run_number,/remove_all)
    nexus_name += ' ..... does not exist'
    output_into_text_box, event, 'infos_text', nexus_name, 0

endif else begin

    if ((*global).activate_preview EQ 1) then begin
;         display_data,$
;           event,$
;           instrument,$          ; instrument
;           full_nexus_name,$     ; full nexus name
;           (*global).tmp_folder ; where to create the histo_mapped file
    endif

    nexus_name = instrument + '_' + strcompress(run_number,/remove_all)
    nexus_name += ' has been found:'
    output_into_text_box, event, 'infos_text', nexus_name, 1
    output_into_text_box, event, 'infos_text', full_nexus_name

    widget_control, output_data_base_id, map=1

endelse









end








pro reinitialize_interface, event, find_nexus, instrument

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).activate_preview EQ 1) then begin
    
;erase display
    case instrument of 
        'REF_L': begin
            drawing_id = widget_info(Event.top,find_by_uname='drawing')
            widget_control, drawing_id, get_value=id
            wset, id
            erase
        end
        'REF_M': begin
            drawing_id = widget_info(Event.top,find_by_uname='drawing')
            widget_control, drawing_id, get_value=id
            wset, id
            erase
        end
        'BSS':begin
            drawing_top_id = widget_info(Event.top,find_by_uname='drawing_top')
            widget_control, drawing_top_id, get_value=id_top
            wset, id_top
            erase
            drawing_bottom_id = widget_info(Event.top,find_by_uname='drawing_bottom')
            widget_control, drawing_bottom_id, get_value=id_bottom
            wset, id_bottom
            erase
        end
    endcase
    
endif

;reinitialize log_book
log_book_id = widget_info(Event.top,find_by_uname='log_book_text')
widget_control, log_book_id, set_value=''

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
        output_error, Event, err_listening

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
        output_error, Event, err_listening

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
        output_error, Event, err_listening

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
        output_error, Event, err_listening

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
    output_error, Event, err_listening

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

  
  
  



  

pro COMPLETE_RUNINFO_FILE_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument =  (*global).instrument

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize_display
   
cmd = "less " + (*global).runinfo_xml_filename
spawn, cmd, listening, err_listening
output_error, Event, err_listening

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
output_error, Event, err_listening

id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_XML_DISPLAY_TEXT")
widget_control, id, set_value = listening

end









;____________________________________________________________________________________

function display_xml_info, filename, item_name

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
END








function read_xml_file, filename, nodename

filename = filename[0]
;and the nodename (xml key) for the data they want
;call the function to get the value we're looking for from the xml file
xml_node_value = get_xml_value(NodeName,filename)

return, xml_node_value

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







function get_full_path_to_preNeXus_path, listening, instrument, run_number

string_to_remove = instrument + "_" + strcompress(run_number,/remove_all)
string_to_remove += "_cvinfo.xml"
full_path=strsplit(listening,string_to_remove,/extract,/regex)

return, full_path

end





;return 1 if file is an event file
;return 0 if file is a histogram file
;return -1 if there is no event of histogram file
function check_if_file_is_event, name_if_event, name_if_histogram

check_cmd = "ls " + name_if_event
spawn, check_cmd, listening

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
output_error, Event, err_listening

if (listening NE '') then begin ;folder exists, we need to remove it first
    
    cmd_remove_folder = "rm -f -r " + full_folder_name
    cd, (*global).output_path
    spawn, cmd_remove_folder,listening, err_listening
    output_error, Event, err_listening

    full_text = "   > " + cmd_remove_folder
    widget_control, full_view_info, set_value=full_text, /append
    
endif 

;create folders
cmd_create_preNeXus_folder = "mkdir -p " + full_folder_name_preNeXus
cmd_create_NeXus_folder = "mkdir -p " + full_folder_name_NeXus

full_text = "   > " + cmd_create_preNeXus_folder
widget_control, full_view_info, set_value=full_text, /append
spawn, cmd_create_preNeXus_folder, listening, err_listening
output_error, Event, err_listening

full_text = '   > ' + cmd_create_NeXus_folder 
widget_control, full_view_info, set_value=full_text, /append
spawn, cmd_create_NeXus_folder, listening, err_listening
output_error, Event, err_listening

end












pro output_error, event, err_listening

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display what is going on
full_view_info = widget_info(event.top,find_by_uname='log_book_text')

if (err_listening NE '' OR err_listening NE ['']) then begin
    full_text = 'ERROR: ' + err_listening
    widget_control, full_view_info, set_value=full_text,/append
endif

end


