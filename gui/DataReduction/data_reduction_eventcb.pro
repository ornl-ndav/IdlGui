function distance_from_xborder, x

a = x * 0.7 ;in mm

return, a
end





function distance_from_xcenter, x

center_offset = 0.35

if (x LE 151) then begin        ;first half
    x_diff = 151-x
endif else begin                ;second half
    x_diff = x-152
endelse
b = center_offset + x_diff * 0.7 ;in mn

return, b
end





function distance_from_yborder, y

c = y * 0.7 ;in mm

return, c
end






function distance_from_ycenter, y

center_offset = 0.35

if (y LE 127) then begin        ;first half
 y_diff = 127-y
endif else begin                ;second half
 y_diff = y-128
endelse
d = center_offset + y_diff * 0.7 ; in mm

return, d
end








function check_if_run_number_already_in_list, array_of_runs, run_number

array_of_runs_tmp = size(array_of_runs)
array_of_runs_type = array_of_runs_tmp[0]
array_of_runs_size = array_of_runs_tmp[1]
result=0

if (array_of_runs_type EQ 1) then begin

    run_number_local = strcompress(run_number,/remove_all)
    
    for i=0,(array_of_runs_size-1) do begin
        if (run_number_local EQ strcompress(array_of_runs[i],/remove_all)) then begin
            result=1
        endif
    endfor

endif

return, result
end











function produce_output_file_name, Event, run_number, extension

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_folder = (*global).local_folder

output_file_name = tmp_folder + (*global).instrument 
output_file_name += "_" + run_number + extension

return, output_file_name 
end


function get_list_of_runs, instrument, runs_to_process

if (instrument EQ 'REF_L') then begin

    array_of_runs = ''
    array_of_runs_1 = strsplit(runs_to_process,',',count=length,/extract)
    array_of_runs_2 = strarr(length)

    for j=0,(length-1) do begin

        array_of_runs_2 = strsplit(array_of_runs_1[j],'-',$
                                   count=length_1,/extract)
        if (length_1 GT 1) then begin
            ;check if there is a * before/after
            ;array_of_runs_2[0] and [1]
            local_nexus = is_local_nexus_function(array_of_runs_2)
            if (local_nexus[0] EQ 0 AND $
                local_nexus[1] EQ 0) then begin
                min = fix(array_of_runs_2[0])
                max = fix(array_of_runs_2[1])
                array_of_runs_add = strcompress(indgen(max-min+1)+min,/removee_all)
            endif else begin
                min = fix(remove_star_from_string(array_of_runs_2[0]))
                max = fix(remove_star_from_string(array_of_runs_2[1]))
                array_of_runs_add = strcompress(indgen(max[0]-min[0]+1)+min[0],/remove_all)
                array_of_runs_add += '*'
            endelse
            array_of_runs = [array_of_runs, array_of_runs_add]
        endif else begin
            array_of_runs = [array_of_runs, array_of_runs_2]
        endelse
    endfor
    size_array_of_runs = size(array_of_runs)
    array_of_runs = array_of_runs[1:size_array_of_runs[1]-1]
endif else begin
    size_array = size(runs_to_process)
    size_is = size_array[1]
    array_of_runs = runs_to_process[1:size_is-1]
endelse

return, array_of_runs
end







function get_final_list_of_runs, Event, runs_to_process   ;REF_M

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

runs_array = get_list_of_runs(instrument, runs_to_process)

array_size = size(runs_array)
array_size = array_size[1]
array_of_nexus_files = strarr(array_size)
runs_full_path = strarr(array_size)
runs_to_use_array = lonarr(array_size)
nbr_runs_to_use = 0

;check if there is a star after or before the run number
is_local_nexus_array = is_nexus_local(runs_array)

for i=0,(array_size-1) do begin

    if (is_local_nexus_array[i] EQ 0) then begin  ;nexus is in SNSlocal or SNS
        cmd_findnexus = 'findnexus'
    endif else begin ;nexus is local
        ;first remove the star
        runs_array[i] = remove_star_from_string(runs_array[i])
        cmd_findnexus = 'findnexus --prefix ~/local/' + instrument
    endelse

    cmd_findnexus +=  ' -i' + instrument
    cmd_findnexus += " " + strcompress(runs_array[i], /remove_all)
    text = ' >' + cmd_findnexus
    output_into_text_box, event, 'log_book_text', text
    spawn, cmd_findnexus, full_path_to_nexus

    array_of_nexus_files[i]=full_path_to_nexus
    
;create message for view_info
    result = strmatch(array_of_nexus_files[i],"ERROR*")
    
    if (result[0] GE 1 or full_path_to_nexus EQ '') then begin
        
        full_text = array_of_nexus_files[i] + ' (input # ' + $
          strcompress(i+1) + $
          ' does not exist)'
        
    endif else begin
        
        full_text = ' Runs # ' + runs_array[i] + ' OK (' +$
          array_of_nexus_files[i] + ')'
        runs_to_use_array[i]=1
        nbr_runs_to_use += 1
        
    endelse
    
    output_into_text_box, event, 'log_book_text', full_text
    
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
    text = strcompress(j) + ' valid run number(s)'
    
;create the runs_and_full_path array
    runs_and_full_path = strarr(j,2)

    for i=0,j-1 do begin
        runs_and_full_path[i,0] = runs_number[i]
        runs_and_full_path[i,1] = runs_full_path[i]
    endfor
        
    full_text = 'data_reduction will use ' + strcompress(j) + $
      ' run numbers:'
    full_text_2 = "   - run number  " + $
      strcompress(runs_number,/remove_all)
    
endif else begin
    
    text = '0 valid run number to use'
    full_text = text
    
endelse

;widget_control, view_info, set_value=text,/append
output_into_text_box, event, 'log_book_text', full_text
output_into_text_box, event, 'info_text', text

return, runs_and_full_path
end





function parse_current_text, current_text_local, symbol

new_text_array = strsplit(current_text_local,symbol,/regex,/extract,count=length)

if (length GT 1) then begin ;create array of elements
    size_of_array = fix(new_text_array[1]) - fix(new_text_array[0])
    array_of_elements_to_add_local = indgen(size_of_array+1)+new_text_array[0]
endif else begin
    array_of_elements_to_add_local = new_text_array
endelse

return, array_of_elements_to_add_local

end





pro selection_mode_REF_L_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).selection_mode = 1

;change display of current status
current_mode_status_label_id = widget_info(Event.top, $
                                           find_by_uname='current_mode_status_label')
widget_control, current_mode_status_label_id, set_value='SELECTION'

;change display of menu buttons
selection_mode_REF_L_id = widget_info(Event.top, $
                                      find_by_uname='selection_mode_REF_L')
widget_control, selection_mode_REF_L_id, set_value='*SELECTION'

info_mode_REF_L_id = widget_info(Event.top, $
                                      find_by_uname='info_mode_REF_L')
widget_control, info_mode_REF_L_id, set_value=' INFO'

end





pro info_mode_REF_L_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).selection_mode = 0

;change display of current status
current_mode_status_label_id = widget_info(Event.top, $
                                           find_by_uname='current_mode_status_label')
widget_control, current_mode_status_label_id, set_value='INFO'

;change display of menu buttons
selection_mode_REF_L_id = widget_info(Event.top, $
                                      find_by_uname='selection_mode_REF_L')
widget_control, selection_mode_REF_L_id, set_value=' SELECTION'

info_mode_REF_L_id = widget_info(Event.top, $
                                      find_by_uname='info_mode_REF_L')
widget_control, info_mode_REF_L_id, set_value='*INFO'

end






pro selection_mode_group_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get value of selection group
selection_mode_group_id = widget_info(Event.top, find_by_uname='selection_mode_group')
widget_control, selection_mode_group_id, get_value=selection_status

instrument = (*global).instrument

info_schema_base_id = widget_info(event.top,find_by_uname='info_schema_base')

if (selection_status EQ 0) then begin
    selection_status = 1
    widget_control, info_schema_base_id, map=0
endif else begin
    selection_status = 0
    widget_control, info_schema_base_id, map=1
    detector_layout=$
      "/SNS/users/j35/SVN/HistoTool/trunk/gui/images/detector_layout.bmp"
    id = widget_info(event.top,find_by_uname="schema_drawing")
    WIDGET_CONTROL, id, GET_VALUE=id_value
    wset, id_value
    image = read_bmp(detector_layout)
    tv, image,0,0,/true
endelse

(*global).selection_mode = selection_status

end




pro keep_selection_list_group_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get value of signal and back selection 
keep_selection_list_group_id = $
  widget_info(Event.top,find_by_uname='keep_selection_list_group')
widget_control, keep_selection_list_group_id, get_value=keep_selection_value

(*global).keep_signal_selection = keep_selection_value[0]
(*global).keep_back_selection = keep_selection_value[1]

end






pro several_nexus_combobox_eventcb, Event  ;REF_M

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

list_of_runs = (*(*global).list_of_runs)

;get info about combobox
combobox_id = widget_info(Event.top,find_by_uname='several_nexus_combobox')
widget_control, combobox_id, get_value=value
current_text = widget_info(combobox_id, /combobox_gettext)

array_of_elements_to_add = parse_current_text(current_text,"-")
size_of_array = size(array_of_elements_to_add)
size_of_array = size_of_array[1]

for i=0,size_of_array-1 do begin

;    current_text = strcompress(array_of_elements_to_add[i],/remove_all)
    current_text = string(array_of_elements_to_add[i])

    if (strcompress(current_text,/remove_all) NE '') then begin
        list_of_runs = [list_of_runs,strcompress(current_text,/remove_all)]
        list_of_runs = list_of_runs(sort(list_of_runs))
        list_of_runs_uniq = list_of_runs(uniq(list_of_runs, sort(list_of_runs)))
        
        size_before = size(list_of_runs)
        size_after = size(list_of_runs_uniq)
        
        if (size_after[1] NE size_before[1]) then begin
                                ;remove new entry from list
            result = where(list_of_runs_uniq NE strcompress(current_text,/remove_all),index)
            new_list_of_runs_uniq = list_of_runs_uniq[result]
            list_of_runs = new_list_of_runs_uniq
            
        endif else begin
            
            list_of_runs = list_of_runs_uniq
            
        endelse
        
        if (current_text NE 'N/A') then begin
            widget_control, combobox_id, set_value=list_of_runs
        endif
        
        (*(*global).list_of_runs) = list_of_runs

    endif        

endfor

new_size_array = size(list_of_runs)
new_size = new_size_array[1]
(*global).runs_to_process = (new_size-1)
case new_size of
    1: text=' 0 run #'
    2: text=' 1 run #'
    else: text = strcompress(new_size-1,/remove_all) + " runs #"
endcase

runs_to_process_label_id = widget_info(Event.top, find_by_uname='runs_to_process_label')
widget_control, runs_to_process_label_id, set_value=text

check_status_to_validate_go, Event

end






pro data_reduction_tab_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get active tab
other_plots_tab_id = widget_info(Event.top,find_by_uname='data_reduction_tab')
value = widget_info(other_plots_tab_id, /tab_current)

case value of

    0:begin
        if ((*global).data_reduction_done EQ 1) then begin
            refresh_plot_button_eventcb, Event
        endif
    end
    2:begin                     ;intermediate plots
        other_plots_tab_cb, Event
    end
    else:
endcase

end






pro other_plots_tab_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get active tab
other_plots_tab_id = widget_info(Event.top,find_by_uname='other_plots_tab')
value = widget_info(other_plots_tab_id, /tab_current)

;get plots_selected, drawing ids and intermediate file extension
plots_selected = (*global).plots_selected
tab_drawing_ids = (*global).tab_drawing_ids
intermediate_file_extension = (*global).intermediate_file_ext
title = (*global).intermediate_plots_title

;check label of current tab
widget_control, other_plots_tab_id

if (plots_selected[value] EQ 1 AND $
   (*global).data_reduction_done EQ 1) then begin

     ;drawing id
     drawing_id = tab_drawing_ids[value]
     file_extension = intermediate_file_extension[value]
     output_plot_file_name = produce_output_file_name(Event,$
                                                      (*global).run_number,$
                                                      file_extension)
     
     (*global).output_plot_file_name = output_plot_file_name

     plot_reduction, $
       Event, $
       output_plot_file_name, $
       drawing_id, $
       title[value]

 endif

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

det_angle_units_id = $
  widget_info(Event.top, find_by_uname='detector_angle_units',/droplist_select)
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
    output_into_text_box, event, 'log_book_text', text
    output_into_text_box, event, 'log_book_text', full_pid_file

    check_status_to_validate_go, Event

endif

end







pro several_nexus_combobox_help_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

push_button = (*global).push_button
id_help_base = widget_info(Event.top, find_by_uname='help_base')

if (push_button EQ 0) then begin
    
;put help contents
    widget_control, id_help_base, map=1
    (*global).push_button = 1

endif else begin
    
;remove help contents
    widget_control, id_help_base, map=0
    (*global).push_button = 0
endelse

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
    text = '1920-1924,1928,1930,1950-1955'

endif else begin

;put back previous contain of text box
    (*global).push_button = 0
    text = (*global).previous_text

endelse

widget_control, id_text_box, set_value=text

end








pro sequentially_help_runs_to_process, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

push_button = (*global).push_button
id_text_box = widget_info(Event.top, find_by_uname='sequentially_runs_to_process_text')

if (push_button EQ 0) then begin

;save previous contains of text box
    widget_control, id_text_box, get_value=previous_text
    (*global).previous_text = previous_text

;put help contains
    (*global).push_button = 1
    text = '1920-1924,1928,1930,1950-1955'

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
pro create_background_pid_array_file, Event, $
                                      XYsignal, $
                                      XYbackground, $
                                      XYbackground_2, $
                                      file_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

xmin_signal = XYsignal[0]
xmax_signal = XYsignal[1]
ymin_signal = XYsignal[2]
ymax_signal = XYsignal[3]

xmin_back = XYbackground[0]
xmax_back = XYbackground[1]
ymin_back = XYbackground[2]
ymax_back = XYbackground[3]

xmin_signal = round(xmin_signal/2)
xmax_signal = round(xmax_signal/2)
ymin_signal = round(ymin_signal/2)
ymax_signal = round(ymax_signal/2)

xmin_back = round(xmin_back/2)
xmax_back = round(xmax_back/2)
ymin_back = round(ymin_back/2)
ymax_back = round(ymax_back/2)

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

    xmin_back_2 = round(xmin_back_2/2)
    xmax_back_2 = round(xmax_back_2/2)
    ymin_back_2 = round(ymin_back_2/2)
    ymax_back_2 = round(ymax_back_2/2)
    
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

;tmp_folder = (*global).tmp_folder
tmp_folder = (*global).local_folder
pid_file_extension = (*global).pid_file_extension
first_part = tmp_folder + (*global).instrument
first_part += "_" + (*global).run_number

signal_pid_file_name = first_part + "_signal_" + pid_file_extension
background_pid_file_name = first_part + "_background_" + pid_file_extension

signal_background_pid_file_names = [signal_pid_file_name,$
                                    background_pid_file_name]

return, signal_background_pid_file_names
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

image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/images/data_reduction_gui_logo.bmp"
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
    output_into_text_box, event, 'info_text', text, 1
    
endif else begin
    
;indicate reading data with hourglass icon
    widget_control,/hourglass
    
    ;no data reduction done on this run number yet
    (*global).data_reduction_done = 0
    
    text = "Searching for NeXus file of run number " + $
      strcompress(run_number,/remove_all)
    text += "..."
    output_into_text_box, event, 'info_text', text,1
    text = "Openning/plotting Run # " + $
      strcompress(run_number,/remove_all) + "..."
    output_into_text_box, event, 'info_text', text

;get path to nexus run #
    instrument=(*global).instrument
    initial_run_number = run_number
    run_number = remove_star_from_string(run_number)
    (*global).run_number = run_number

    full_nexus_name = $
      find_full_nexus_name(Event,$
                           strmatch(initial_run_number,'*\**'),$
                           run_number,$
                           instrument)

;check result of search
    find_nexus = (*global).find_nexus
    if (find_nexus EQ 0) then begin

        text_nexus = "Warning! NeXus file does not exist"
        output_into_text_box, event, 'info_text', text_nexus
        output_into_text_box, event, 'log_book_text', text_nexus

    endif else begin

        text_nexus = "NeXus file has been localized: "
        (*global).full_nexus_name = full_nexus_name
        text_nexus += full_nexus_name
        output_into_text_box, event, 'log_book_text', text_nexus
        
        if (instrument EQ 'REF_M') then begin

            populate_distance_labels, event, full_nexus_name

        endif else begin ;REF_L

            populate_proton_charge, event, full_nexus_name

        endelse

;dump binary data of NeXus file into tmp_working_path
        text = " - dump binary data......."
        output_into_text_box, event, 'log_book_text', text
        dump_binary_data, Event, full_nexus_name       
        text = " - dump binary data.......done" 
        output_into_text_box, event, 'log_book_text', text

;read and plot nexus file
        read_and_plot_nexus_file, Event      

;tell the program that data are displayed
        (*global).file_opened = 1

;validate signal and background pid file
        signal_pid_file_button_id = widget_info(Event.top, $
                                                find_by_uname='signal_pid_file_button')
        background_pid_file_button_id = $
          widget_info(Event.top, $
                      find_by_uname='background_pid_file_button')
        widget_control, signal_pid_file_button_id, sensitive=1
        widget_control, background_pid_file_button_id, sensitive=1
        
        if (instrument EQ 'REF_L') then begin

            add_run_number_to_list_if_not_present, $
              event, $
              'sequentially_runs_to_process_text',$
              run_number
              
            add_run_number_to_list_if_not_present, $
              event, $
              'runs_to_process_text',$
              run_number

        endif else begin ;only copy run number into run to process if REF_M

            combobox_id = widget_info(Event.top,find_by_uname='several_nexus_combobox')
            new_text = strcompress(run_number,/remove_all)            
            list_of_runs = strarr(1)
            list_of_runs[0] = ' '
            array_text = [list_of_runs,new_text]
            (*(*global).list_of_runs) = array_text
            widget_control, combobox_id, set_value=array_text
            ;update label to '1 run #:'
            text = ' 1 run #'
            runs_to_process_label_id = widget_info(Event.top, $
                                                   find_by_uname='runs_to_process_label')
            widget_control, runs_to_process_label_id, set_value=text

        endelse
        
        check_status_to_validate_go, Event

    endelse
    
endelse

end




pro reset_and_erase_displays, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument
(*global).first_time_plotting_data_reduction = 1

;reinitialize xmin,xmax,ymin and ymax for rescalling plots
xmin = fltarr(6)
ymin = fltarr(6)
xmax = fltarr(6)
ymax = fltarr(6)
(*(*global).xmin_global) = xmin
(*(*global).ymin_global) = ymin
(*(*global).xmax_global) = xmax
(*(*global).ymax_global) = ymax

(*(*global).first_time_plotting_n) = intarr(6)+1

if (instrument EQ 'REF_M') then begin ;REF_M

    ;remove x-y axis interaction box and bring back to life REF_M logo
    REF_M_logo_base_id = widget_info(event.top,find_by_uname='REF_M_logo_base')
    widget_control, REF_M_logo_base_id, map=1
    x_y_axis_interaction_base_id = widget_info(event.top, find_by_uname='x_y_axis_interaction_base')
    widget_control, x_y_axis_interaction_base_id, map=0
    
;no data reduction plot available
    (*global).data_reduction_done = 0
    
;put intermediate output back to NO
    list_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group_REF_M')
    widget_control, list_id, set_value=1
    
;erase main plot (left box)
    id_draw = widget_info(Event.top, find_by_uname='display_data_base')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
;erase data reduction plot
    main_draw_id = widget_info(Event.top, find_by_uname='data_reduction_plot')
    widget_control, main_draw_id, get_value=id_value
    wset,id_value
    erase
    
;reset all boxes (pid ...)
    if ((*global).keep_signal_selection EQ 0) then begin
        signal_pid_text_id = widget_info(Event.top,find_by_uname='signal_pid_text')
        widget_control, signal_pid_text_id, set_value=''
    endif
    
    if ((*global).keep_back_selection EQ 0) then begin
        background_pid_text_id = widget_info(Event.top,find_by_uname='background_pid_text')
        widget_control, background_pid_text_id, set_value=''
    endif
    
    normalization_text_id = widget_info(Event.top,find_by_uname='normalization_text')
    widget_control, normalization_text_id, set_value=''
    
    combobox_id = widget_info(Event.top,find_by_uname='several_nexus_combobox')
    widget_control, combobox_id, set_value=(*global).initial_list_of_runs
    
;reset label of all intermediate plots
    tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
    tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
    tab_4_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')
    tab_5_id = $
      widget_info(Event.top, $
                  find_by_uname='background_region_from_normalization_region_summed_tof_base')
    widget_control, tab_1_id, base_set_title=''
    widget_control, tab_2_id, base_set_title=''
    widget_control, tab_4_id, base_set_title=''
    widget_control, tab_5_id, base_set_title=''
    
    (*global).plots_selected = [0,0,0,0]

endif else begin                ;REF_L

    ;remove action on zoom, loadct and reset uncombe data reduction plot
    zoom_button_id = widget_info(event.top,find_by_uname='zoom_button')
    loadct_button_id = widget_info(event.top,find_by_uname='loadct_button')
    reset_data_reduction_id = widget_info(event.top,find_by_uname='reset_data_reduction')
    widget_control, zoom_button_id, sensitive=0
    widget_control, loadct_button_id, sensitive=0
    widget_control, reset_data_reduction_id, sensitive=0

    ;remove max, min and loadct widget_draw
    data_reduction_scale_base_id = widget_info(event.top,find_by_uname='data_reduction_scale_base')
    widget_control, data_reduction_scale_base_id, sensitive=0
    
    ;remove data in max and min scale boxes
      data_reduction_scale_max_id = widget_info(event.top,find_by_uname='data_reduction_scale_max')
      data_reduction_scale_min_id = widget_info(event.top,find_by_uname='data_reduction_scale_min')
      widget_control, data_reduction_scale_max_id, set_value=''
      widget_control, data_reduction_scale_min_id, set_value=''

    ;remove scale plot
      data_reduction_scale_id = widget_info(Event.top,FIND_BY_UNAME='data_reduction_scale')
      WIDGET_CONTROL, data_reduction_scale_id, GET_VALUE=id
      wset, id
      erase
                                
;remove x-y axis interaction box and bring back to life REF_L logo
    REF_L_logo_base_id = widget_info(event.top,find_by_uname='REF_L_logo_base')
    widget_control, REF_L_logo_base_id, map=1
    x_y_axis_interaction_base_id = widget_info(event.top, find_by_uname='x_y_axis_interaction_base')
    widget_control, x_y_axis_interaction_base_id, map=0

    if ((*global).save_session EQ 0) then begin ;yes, save session

    endif else begin ;no, clear everything
        
;erase selection corners from global if desired
        if ((*global).keep_signal_selection EQ 0) then begin
            (*global).selection_signal = 0
        endif 
        
        if ((*global).keep_back_selection EQ 0) then begin
            (*global).selection_background = 0
            (*global).selection_background_2 = 0
        endif
        
;no data reduction plot available
        (*global).data_reduction_done = 0
        
;put intermediate output back to NO
        list_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group')
        widget_control, list_id, set_value=1
        
;erase main plot (left box)
        id_draw = widget_info(Event.top, find_by_uname='display_data_base')
        widget_control, id_draw, get_value=id_value
        wset,id_value
        erase
        
;erase data reduction plot
        main_draw_id = widget_info(Event.top, find_by_uname='data_reduction_plot')
        widget_control, main_draw_id, get_value=id_value
        wset,id_value
        erase
        
;reset all boxes (pid ...)
        if ((*global).keep_signal_selection EQ 0) then begin
            signal_pid_text_id = widget_info(Event.top,find_by_uname='signal_pid_text')
            widget_control, signal_pid_text_id, set_value=''
        endif
        
        if ((*global).keep_back_selection EQ 0) then begin
            background_pid_text_id = widget_info(Event.top,find_by_uname='background_pid_text')
            widget_control, background_pid_text_id, set_value=''
        endif
        
        normalization_text_id = widget_info(Event.top,find_by_uname='normalization_text')
        widget_control, normalization_text_id, set_value=''
        
        runs_to_process_text_id = widget_info(Event.top, find_by_uname='runs_to_process_text')
        widget_control, runs_to_process_text_id, set_value=''
        
;reset label of all intermediate plots
        tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
        tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
        tab_4_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')
        tab_5_id = $
          widget_info(Event.top, $
                      find_by_uname='background_region_from_normalization_region_summed_tof_base')
        widget_control, tab_1_id, base_set_title=''
        widget_control, tab_2_id, base_set_title=''
        widget_control, tab_4_id, base_set_title=''
        widget_control, tab_5_id, base_set_title=''
        
        tab_3_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_base')
        widget_control, tab_3_id, base_set_title=''
        (*global).plots_selected = [0,0,0,0,0]

    endelse
    
endelse

end





pro dump_binary_data, Event, full_nexus_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;create tmp_working_path
;get global structure
tmp_working_path = (*global).tmp_working_path
tmp_working_path += "_" + (*global).instrument + "/"

tmp_folder = (*global).tmp_folder
cmd_create = "mkdir " + tmp_folder

text= " [ " + cmd_create + " ..."
output_into_text_box, event, 'log_book_text', text
;widget_control, full_view_info, set_value=text, /append
spawn, cmd_create, listening, err_listening

output_into_text_box, event, 'log_book_text', listening
output_error, event, 'log_book_text', err_listening

text= "   ...done ]"
output_into_text_box, event, 'log_book_text', text
;widget_control, full_view_info, set_value=text, /append

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
output_into_text_box, event, 'log_book_text', text
;widget_control, full_view_info, set_value=text, /append

end





pro plot_selection,Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;;main plot id
;id_draw = widget_info(Event.top, find_by_uname='display_data_base')
;widget_control, id_draw, get_value=id_value
;wset,id_value

;do we want to keep signal selection
if ((*global).keep_signal_selection EQ 1) then begin

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

if ((*global).keep_back_selection EQ 1) then begin

    if ((*global).selection_background EQ 1) then begin
        
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

    if ((*global).selection_background_2 EQ 1) then begin

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

;retrieve data parameters
Nx = (*global).Nx
Ny = (*global).Ny
instrument = (*global).instrument

file = (*global).full_histo_mapped_name
nexus_file_name_only = (*global).nexus_file_name_only

full_view_info = widget_info(Event.top, find_by_uname='log_book_text')
text = " - plot NeXus file: " + nexus_file_name_only + "..."
output_into_text_box, event, 'log_book_text', text
;WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND

;determine path	
;path = (*global).tmp_folder
path = (*global).local_folder

cmd_create = "mkdir " + path
cmd_text = '> ' + cmd_create
output_into_text_box, event, 'log_book_text', cmd_text
;widget_control, full_view_info, set_value=cmd_text, /append
spawn, cmd_create, listening, error_listening
output_error, event, 'log_book_text', error_listening
cd, path
        
output_into_text_box, event, 'log_book_text', '[ - reading in data...'
;WIDGET_CONTROL, full_view_info, SET_VALUE=' [ - reading in data...', /APPEND
strtime = systime(1)

openr,u,file,/get
;find out file info
fs = fstat(u)
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)
(*global).Ntof = Ntof           ;set back in global structure

output_into_text_box, event, 'log_book_text', '... done reading data]'
;WIDGET_CONTROL, full_view_info, SET_VALUE='.... done reading data]', /APPEND
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

id_draw = widget_info(Event.top, find_by_uname='display_data_base')
widget_control, id_draw, get_value=id_value
wset,id_value

New_Ny = 2*Nx
New_Nx = 2*Ny

tvimg = rebin(img, New_Nx, New_Ny,/sample)
tvscl, tvimg, /device
    
;plot selection we want to keep
plot_selection,Event

endtime = systime(1)
tt_time = string(endtime - strtime)
text = 'Done in ' + strcompress(tt_time,/remove_all) + ' s'
output_into_text_box, event, 'log_book_text', text
;WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
	
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
text = "...Done"
output_into_text_box, event, 'log_book_text', text
;WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;now turn hourglass back off
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$








pro CTOOL, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

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
img = (*(*global).img_ptr)

New_Ny = 2*(*global).Nx
New_Nx = 2*(*global).Ny

tvimg = rebin(img, New_Nx, New_Ny,/sample)
tvscl, tvimg, /device

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









pro selection_press, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

;retrieve global parameters
file_opened = (*global).file_opened
;1: for selection mode      0: for info mode for REF_L
selection_mode= (*global).selection_mode

view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;working on signal or background ? (0 for signal, 1 for background_1
;and 2 for background_2)
signal_or_background = (*global).selection_value

;left mouse button in info mode
if (selection_mode EQ 0 AND file_opened EQ 1) then begin    

;get data
    img = (*(*global).img_ptr)

    tmp_tof = (*(*global).data_assoc)
    Nx = (*global).Nx
    
    x = Event.x
    y = Event.y

    x = round(x/2)
    y = round(y/2)

;set data
    text = " x= " + strcompress(x,/remove_all)
    text += " y= " + strcompress(y,/remove_all)
    
;put number of counts in number_of_counts label position
    text += " counts= " + strcompress(img(x,y))
    full_text = "PixelID infos : " + text

    output_into_text_box, event, 'log_book_text', full_text
;    output_into_text_box, event, 'info_text', text

    if (instrument EQ 'REF_M') then begin
        
        a = distance_from_xborder(x)
        b = distance_from_xcenter(x)
        c = distance_from_yborder(y)
        d = distance_from_ycenter(y)
        
        text = " a= " + strcompress(a) + " mm"
        text += "   b= " + strcompress(b) + " mm"
        output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
        
        text = " c= " + strcompress(c) + " mm"
        text += "   d= " + strcompress(d) + " mm"
        output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
        
    endif

endif

if (selection_mode EQ 1 AND file_opened EQ 1) then begin
    
    left_click_number = (*global).left_click_number
    
    x=event.x
    y=event.y
    
    if (left_click_number EQ 0) then begin
        
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
        
        (*global).left_click_number = 1

    endif else begin ;we pressed again to stop selection

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
        
        (*global).left_click_number = 0

        generate_info_about_selection, Event, signal_or_background

    endelse

endif

end



pro generate_info_about_selection, Event, signal_or_background

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;initialization of variables
x=lonarr(2)
y=lonarr(2)
         
Nx=(*global).Nx
Ny=(*global).Ny

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
         
y = round(y/2)
x = round(x/2)

y_min = min(y)
y_max = max(y)
x_min = min(x)
x_max = max(x)

y12 = y_max-y_min+1  ;+1 to take into account side of selection
x12 = x_max-x_min+1  ;+1 to take into account side of selection

if (signal_or_background EQ 0) then begin
    (*global).ymin = y_min
    (*global).y12=y12
endif 

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
        if ((*global).instrument EQ 'REF_L') then begin ;REF_L
            text_color_back_1 = " (red)"
        endif else begin ;REF_M
            text_color_back_1 = " (yellow)"
        endelse
        widget_control, view_info_tab, base_set_title="Background #1" + text_color_back_1
    endif else begin
        text_color_back_2 = " (red)"
        view_info = widget_info(Event.top,FIND_BY_UNAME='background_2_info')
        WIDGET_CONTROL, view_info, SET_VALUE=value_group
        view_info_tab = widget_info(Event.top, find_by_uname='background_2_tab_base')
        widget_control, view_info_tab, base_set_title="Background #2" + text_color_back_2
    endelse
    
endelse        

end




pro selection_release, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

;retrieve global parameters
file_opened = (*global).file_opened
;1: for selection mode      0: for info mode
selection_mode = (*global).selection_mode  

view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;working on signal or background ? (0 for signal, 1 for background_1
;and 2 for background_2)
signal_or_background = (*global).selection_value

left_click_number = (*global).left_click_number
if (selection_mode EQ 1 AND $
    file_opened EQ 1 AND $
    left_click_number EQ 1 ) then begin

    X2=event.x
    Y2=event.y
    
    SHOW_DATA,event

    if (signal_or_background EQ 0) then begin
        color_line = (*global).color_line_signal
        (*global).selection_signal = 1
        (*global).x2_signal = X2
        (*global).y2_signal = Y2
        X1=(*global).X1_signal
        Y1=(*global).Y1_signal
    endif 
                     
    if (signal_or_background EQ 1) then begin
        color_line = (*global).color_line_background
        (*global).selection_background = 1
        (*global).x2_back = X2
        (*global).y2_back = Y2
        X1=(*global).X1_back
        Y1=(*global).Y1_back
    endif
                     
    if (signal_or_background EQ 2) then begin
        color_line = (*global).color_line_background_2
        (*global).selection_background_2 = 1
        (*global).x2_back_2 = X2
        (*global).y2_back_2 = Y2
        X1=(*global).X1_back_2
        Y1=(*global).Y1_back_2
    endif
                     
;validate save_selection button if signal and background region are there
;     if (((*global).selection_signal EQ 1 AND $
;          (((*global).selection_background EQ 1) OR $
;           (*global).selection_background_2 EQ 1))) then begin
     if ((*global).selection_signal EQ 1) then begin
        id_save_selection = widget_info(Event.top, $
                                        find_by_uname='save_selection_button')
        widget_control, id_save_selection, sensitive=1
    endif
                     
    plots, X1, Y1, /device, color=color_line
    plots, X1, Y2, /device, /continue, color=color_line
    plots, X2, Y2, /device, /continue, color=color_line
    plots, X2, Y1, /device, /continue, color=color_line
    plots, X1, Y1, /device, /continue, color=color_line
    
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

    if ((*global).instrument EQ 'REF_M') then begin
        keep_current_selection_base_id = $
          widget_info(Event.top,$
                      find_by_uname='keep_current_selection_base')
        widget_control, keep_current_selection_base_id, map=0
    endif
endif

if ((*global).selection_background EQ 0 AND $
    (*global).selection_background_2 EQ 0) then begin

    background_list_group_id = widget_info(Event.top,find_by_uname='background_list_group')
    widget_control, background_list_group_id, set_value=1

endif
    
output_into_text_box, event, 'log_book_text', full_text
output_into_text_box, event, 'info_text', text
;widget_control, view_info, set_value=text, /append
;widget_control, full_view_info, set_value=full_text, /append
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
output_into_text_box, event, 'log_book_text', full_text
;widget_control, full_view_info, set_value=full_text, /append

(*global).signal_pid_file_name = signal_pid_file_name
widget_control, signal_id, set_value=pid_file_names[0]

if (background_selection EQ 1 OR background_2_selection EQ 1) then begin

    full_text = " - background Pid file name is: " + background_pid_file_name
    widget_control, background_id, set_value=pid_file_names[1]
    (*global).background_pid_file_name = background_pid_file_name
    
    output_into_text_box, event, 'log_book_text', full_text
    output_into_text_box, event, 'info_text', text
;   widget_control, view_info, set_value=text, /append
;    widget_control, full_view_info, set_value=full_text, /append

    background_list_group_id = widget_info(Event.top,find_by_uname='background_list_group')
    widget_control, background_list_group_id, set_value=0

endif else begin

    background_list_group_id = widget_info(Event.top,find_by_uname='background_list_group')
    widget_control, background_list_group_id, set_value=1

endelse

;check general status to activate or not go_button
check_status_to_validate_go, Event

if ((*global).instrument EQ 'REF_M') then begin
    keep_current_selection_base_id = widget_info(Event.top,$
                                                 find_by_uname='keep_current_selection_base')
    widget_control, keep_current_selection_base_id, map=1
endif

end





pro produce_pid_files, Event, signal_pid_file_name, background_pid_file_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

;signal selection
x1_signal = (*global).x1_signal
x2_signal = (*global).x2_signal
y1_signal = (*global).y1_signal
y2_signal = (*global).y2_signal

x1_signal = round(x1_signal/2)
x2_signal = round(x2_signal/2)
y1_signal = round(y1_signal/2)
y2_signal = round(y2_signal/2)

XYsignal = reorder(x1_signal, x2_signal, y1_signal, y2_signal)

;create output file
create_signal_pid_array_file, XYsignal, signal_pid_file_name

;background selection
x1_back = (*global).x1_back
x2_back = (*global).x2_back
y1_back = (*global).y1_back
y2_back = (*global).y2_back

x1_back = round(x1_back/2)
x2_back = round(x2_back/2)
y1_back = round(y1_back/2)
y2_back = round(y2_back/2)

XYbackground = reorder(x1_back, x2_back, y1_back, y2_back)

;background selection #2
x1_back_2 = (*global).x1_back_2
x2_back_2 = (*global).x2_back_2
y1_back_2 = (*global).y1_back_2
y2_back_2 = (*global).y2_back_2

x1_back_2 = round(x1_back_2/2)
x2_back_2 = round(x2_back_2/2)
y1_back_2 = round(y1_back_2/2)
y2_back_2 = round(y2_back_2/2)

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

instrument = (*global).instrument

;log book ids (full and simple)
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

if ((*global).entering_intermediate_file_output_for_first_time EQ 1) then begin

    if (value EQ 0) then begin  ;display other plots

;display labels on tabs
        intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
        widget_control, intermediate_plot_base, map=1

        ;save status of buttons
        plots_selection_id = widget_info(Event.top, $
                                         find_by_uname='intermediate_plots_list_group')
        widget_control, plots_selection_id, get_value=value_selection

        (*global).plots_selected = value_selection
        (*global).entering_selection_of_plots_by_yes_button = 1

    endif else begin            ;remove other plots 
        
        intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
        widget_control, intermediate_plot_base, map=0
        
                                ;remove labels on tabs
        tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
        tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
        tab_4_id = widget_info(Event.top, $
                               find_by_uname='normalization_region_summed_tof_base')
        tab_5_id = $
          widget_info(Event.top, $
                      find_by_uname=$
                      'background_region_from_normalization_region_summed_tof_base')
        widget_control, tab_1_id, base_set_title=''
        widget_control, tab_2_id, base_set_title=''
        widget_control, tab_4_id, base_set_title=''
        widget_control, tab_5_id, base_set_title=''
        
        if (instrument EQ 'REF_L') then begin
            tab_3_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_base')
            widget_control, tab_3_id, base_set_title=''
        endif

        full_text = 'No intermediate files will be produced'
        text = 'No intermediate plot'
        output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
;        widget_control, full_view_info, set_value=full_text, /append
;        widget_control, view_info, set_value=text, /append
        (*global).entering_selection_of_plots_by_yes_button = 0
        screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
        widget_control, screen_base_id, map=1
        
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
    spawn, cmd_remove, listening, err_listening
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






pro start_data_reduction_button_eventcb, Event   ;for REF_M

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
normalization_status_id = widget_info(Event.top, $
                                          find_by_uname='normalization_list_group_REF_M')
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
            
        output_into_text_box, event, 'info_text', "ERROR: normalization run number invalid"
        output_into_text_box, event, 'info_text', "Program Terminated"
        text = 'ERROR: normalization run number invalid - ' + run_number_normalization
        output_into_text_box, event, 'log_book_text', text        
;    WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
        output_into_text_box, event, 'log_book_text', "Program Terminated", /APPEND
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
                    full_text = $
                      'Normalization file used: ' + full_path_to_nexus_normalization  
                    
                endelse
                
        output_into_text_box, event, 'info_text', text        
        output_into_text_box, event, 'log_book_text', full_text
;        widget_control, view_info, set_value=text, /append
;        widget_control, full_view_info, set_value=full_text, /append
                
            endif
            
        endelse
        
        catch, /cancel
        
    endif else begin
        
        text = 'Please specify a normalization run number'
        full_text = 'Normalization run number: MISSING'
        output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
;        widget_control, view_info, set_value=text, /append
;        widget_control, full_view_info, set_value=full_text, /append
        stop_reduction = 1
        
    endelse
    
endif

;****************************
;check status of bkg flag
bkg_flag_id = widget_info(Event.top, find_by_uname='background_list_group')
widget_control, bkg_flag_id, get_value=bkg_flag

;*****************************
;get runs_to_process list of files
several_nexus_combobox_id = $
  widget_info(Event.top,$
              find_by_uname='several_nexus_combobox')
widget_control, several_nexus_combobox_id, get_value=runs_to_process
runs_and_full_path = get_final_list_of_runs(Event, runs_to_process)

;*****************************
;check status of normalize bkg
norm_bkg_id = widget_info(Event.top, find_by_uname='norm_background_list_group')
widget_control, norm_bkg_id, get_value=norm_bkg_value

;*****************************
;check status of intermediate outputs
interm_id = widget_info(Event.top, $
                        find_by_uname='intermediate_file_output_list_group_REF_M')
widget_control, interm_id, get_value=interm_status

;*****************************
;check status of instrument geometry file
instrument_geometry_button_id = widget_info(event.top, find_by_uname='instrument_geometry_list_group')
widget_control, instrument_geometry_button_id, get_value=instrument_geometry

array_of_parameters = retrieve_REF_M_parameters(Event)
wave_min = array_of_parameters[0]
wave_max = array_of_parameters[1]
wave_width = array_of_parameters[2]
detector_angle_rad = array_of_parameters[3]
detector_angle_err = array_of_parameters[4]

nbr_runs_to_use_size = size(runs_and_full_path)
nbr_runs_to_use = nbr_runs_to_use_size[1]

;if (nbr_runs_to_use GT 1) then begin
;    screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
;    widget_control, screen_base_id, map=1
;endif


    
 ;   (*global).processing_run_number = runs_and_full_path[i,0]
    
;start command line for REF_M
    REF_M_cmd_line = "reflect_reduction "
    
    for i=0,(nbr_runs_to_use-1) do begin

;add list of NeXus run numbers
        runs_text = " "
;    REF_M_cmd_line += full_path_to_nexus_normalization
        REF_M_cmd_line += runs_and_full_path[i,1]
        
    endfor

;instrument geometry
    if (instrument_geometry EQ 0) then begin
        instr_geom_cmd = " --inst_geom=" + (*global).instrument_geometry_file_name
        REF_M_cmd_line += instr_geom_cmd
    endif

;normalization
    if (norm_flag EQ 0) then begin
        
;    norm_cmd = " --norm=" + strcompress(run_number_normalization,/remove_all)
        norm_cmd = "  --norm=" + strcompress(full_path_to_nexus_normalization,/remove_all)
        REF_M_cmd_line += norm_cmd
        
    endif
    
;signal Pid file flag
    signal_pid_cmd = " --signal-roi-file=" + full_signal_pid_file_name
    REF_M_cmd_line += signal_pid_cmd
    
;background Pid file flag
    if (bkg_flag EQ 0) then begin
        bkg_pid_cmd = " --bkg-roi-file=" + full_background_pid_file_name 
        REF_M_cmd_line += bkg_pid_cmd
    endif  else begin      
        REF_M_cmd_line += " --no-bkg"
    endelse
    
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
        
;.bkg 
        if (list_of_plots[1] EQ 1) then begin
            interm_plot_cmd += " --dump-bkg"
        endif

;.norm
        if (list_of_plots[2] EQ 1) then begin
            interm_plot_cmd += " --dump-norm"
        endif
        
;.bnk
        if (list_of_plots[3] EQ 1) then begin
            interm_plot_cmd += " --dump-norm-bkg"
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
    
;    text = "Processing data reduction of run # " + $
;      strcompress(runs_and_full_path[i,0],/remove_all)
;    text += " ..."   
;    widget_control, view_info, set_value=text,/append

    full_text = " running using the following command line:"
    widget_control, full_view_info, set_value=full_text,/append
    
    full_text = "> " + REF_M_cmd_line
    cmd_line = REF_M_cmd_line
    
    widget_control, full_view_info, set_value=full_text,/append
    starting_time = systime(1)
    
    widget_control,/hourglass
    
;desactive run_reduction_button
    start_data_reduction_button_id = $
      widget_info(Event.top,$
                  find_by_uname='start_data_reduction_button')
    widget_control, start_data_reduction_button_id, sensitive=0
    
;main data reduction command line
    cd, (*global).local_folder
    spawn, cmd_line, listening  
    
    (*global).data_reduction_done = 1             
    
    ending_time = systime(1)
    
    total_processing_time = ending_time - starting_time
    full_text = ' -> work done in ' + $
      strcompress(total_processing_time,/remove_all) + ' s'
    
    output_into_text_box, event, 'log_book_text', full_text
;    output_into_text_box, event, 'info_text', text
;    widget_control, full_view_info, set_value=full_text,/append
;    widget_control, view_info, set_value=text,/append
    
    text = ' -> plotting main output file...'
    main_output_file_name = produce_output_file_name(Event, (*global).run_number, '.txt')
    (*global).main_output_file_name = main_output_file_name
    full_text = 'Plotting main output file: ' + main_output_file_name

    output_into_text_box, event, 'log_book_text', full_text
    output_into_text_box, event, 'info_text', text
;    widget_control, full_view_info, set_value=full_text,/append
;    widget_control, view_info, set_value=text,/append
    
;plot main .txt file
    draw_id = 'data_reduction_plot'
    title = "Intensity vs. TOF " 
    plot_reduction, $
      Event, $
      main_output_file_name, $
      draw_id, $
      title
    
    text = '...plot is done'
    full_text = '...plot is done'
    output_into_text_box, event, 'log_book_text', full_text
    output_into_text_box, event, 'info_text', text
;    widget_control, full_view_info, set_value=full_text,/append
;    widget_control, view_info, set_value=text,/append
    
text = '...Full process is done'
full_text = '...Full process is done'
output_into_text_box, event, 'log_book_text', full_text
output_into_text_box, event, 'info_text', text
;widget_control, full_view_info, set_value=full_text,/append
;widget_control, view_info, set_value=text,/append

end






pro cancel_data_reduction_button_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).cancel_data_reduction = 1

end







pro refresh_plot_button_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

main_output_file_name = (*global).main_output_file_name

draw_id = 'data_reduction_plot'
title = "Intensity vs. Wavelength (run # " + $
  strcompress((*global).processing_run_number,/remove_all) + ")"

plot_reduction, $
  Event, $
  main_output_file_name, $
  draw_id, $
  "Intensity vs. Wavelength"

end








pro intermediate_plots_list_validate_eventcb,Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

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
output_into_text_box, event, 'log_book_text', full_text
;widget_control, full_view_info, set_value=full_text, /append

tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
if (indx0 EQ 1) then begin ;signal region summed TOF

    widget_control, tab_1_id, base_set_title='Signal'
    number_of_plots_selected += 1
    
    full_text = ' - Signal region summed TOF'
    ;widget_control, full_view_info, set_value=full_text, /append
    output_into_text_box, event, 'log_book_text', full_text

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
;    widget_control, full_view_info, set_value=full_text, /append
    output_into_text_box, event, 'log_book_text', full_text
endif else begin

    ;remove this plot from the list of selected plots
    indx1 = 0
    new_value = [indx0, indx1, indx2, indx3, indx4]
    
    widget_control,list_of_plots_id,set_value=new_value
    widget_control, tab_2_id, base_set_title=''

endelse

tab_3_id = widget_info(Event.top, find_by_uname='signal_region_summed_tof_base')
if (indx2 EQ 1) then begin      ;signal region summed TOF
    
    widget_control, tab_3_id, base_set_title='Signal region with background'
    number_of_plots_selected += 1
    
    full_text = ' - Signal region summed TOF after subtracting the background'
;    widget_control, full_view_info, set_value=full_text, /append
     output_into_text_box, event, 'log_book_text', full_text   
endif else begin
    
    widget_control, tab_3_id, base_set_title=''
    
endelse

norm_id = widget_info(Event.top, find_by_uname='normalization_list_group_REF_L')
widget_control, norm_id, get_value=norm_flag ;0:with norm    1:no normalization

tab_4_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')
if (indx3 EQ 1 AND norm_flag EQ 0) then begin
    
    widget_control, tab_4_id, base_set_title='Normalization'
    number_of_plots_selected += 1
    
    full_text = ' - Normalization region summed TOF'
;    widget_control, full_view_info, set_value=full_text, /append
     output_into_text_box, event, 'log_book_text', full_text   
endif else begin
    
    indx3 = 0
    widget_control, tab_4_id, base_set_title=''
    
endelse

tab_5_id = $
  widget_info(Event.top, $
              find_by_uname='background_region_from_normalization_region_summed_tof_base')
if (indx4 EQ 1 AND norm_flag EQ 0) then begin
    
    widget_control, tab_5_id, base_set_title='Background from normalization'
    number_of_plots_selected += 1
    
    full_text = ' - Background region from normalization summed TOF'
;    widget_control, full_view_info, set_value=full_text, /append
     output_into_text_box, event, 'log_book_text', full_text   
endif else begin
    
    indx4 = 0
    widget_control, tab_5_id, base_set_title=''
    
endelse

intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, intermediate_plot_base, map=0

;if none of the plots have been selected change status of intermediate
;plots to NO
screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
if (number_of_plots_selected EQ 0) then begin

    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group')
    widget_control, inter_id, set_value=1
    full_text = ' NONE'
;    widget_control, full_view_info, set_value=full_text, /append
    output_into_text_box, event, 'log_book_text', full_text
    widget_control, screen_base_id, map=1

endif else begin
    
    inter_id = widget_info(Event.top,find_by_uname='intermediate_file_output_list_group')
    widget_control, inter_id, set_value=0
    widget_control, screen_base_id, map=0

endelse

text = 'Number of plots selected: '+ strcompress(number_of_plots_selected,/remove_all)
widget_control, view_info, set_value=text, /append
output_into_text_box, event, 'info_text', text

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
pro plot_reduction, Event, plot_file_name, draw_uname, title

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

;erase_reduction_plot, event, draw_uname

if (instrument EQ 'REF_L') then begin

    zoom_button_id = widget_info(event.top,find_by_uname='zoom_button')
    loadct_button_id = widget_info(event.top,find_by_uname='loadct_button')
    combine_data_spectrum_id = widget_info(event.top,find_by_uname='combine_data_spectrum_list_group')
    widget_control, combine_data_spectrum_id, get_value=combine_data_spectrum
    reset_data_reduction_id = widget_info(event.top,find_by_uname='reset_data_reduction')
    data_reduction_scale_base_id = widget_info(event.top,find_by_uname='data_reduction_scale_base')


    if (combine_data_spectrum EQ 0) then begin
        plot_reduction_normal_mode, Event, plot_file_name, draw_uname, title
        widget_control, zoom_button_id, sensitive=0
        widget_control, loadct_button_id, sensitive=0
        widget_control, reset_data_reduction_id, sensitive=0
        widget_control, data_reduction_scale_base_id, sensitive=0
    endif else begin
        plot_reduction_combine, Event, plot_file_name, draw_uname, title
        widget_control, zoom_button_id, sensitive=1
        widget_control, loadct_button_id, sensitive=1
        widget_control, reset_data_reduction_id, sensitive=1
        widget_control, data_reduction_scale_base_id, sensitive=1
    endelse

endif else begin

    plot_reduction_normal_mode, Event, plot_file_name, draw_uname, title

endelse

end




pro plot_reduction_normal_mode, Event, plot_file_name, draw_uname, title

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument

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

                flt0 = [flt0,float(tmp0)]
                                ;strip -1 from beginning of each array
                flt0 = flt0[1:*]
                flt1 = flt1[1:*]
                flt2 = flt2[1:*]
                                ;you're done now...
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

;check if plot is main plot or intermediate plot
other_plots_tab_id = widget_info(Event.top,find_by_uname='data_reduction_tab')
value = widget_info(other_plots_tab_id, /tab_current)

xmin_global = (*(*global).xmin_global)
xmax_global = (*(*global).xmax_global)
ymin_global = (*(*global).ymin_global)
ymax_global = (*(*global).ymax_global)

case value of
    
    0: n=0
    2: begin                    ;intermediate plots
        
;get active tab
        other_plots_tab_id = widget_info(Event.top,find_by_uname='other_plots_tab')
        value_intermediate = widget_info(other_plots_tab_id, /tab_current)
        
        case value_intermediate of
            
            0: n=1
            1: n=2
            2: n=3
            3: n=4
            4: n=5
             
        endcase
        
    end
    else: n=0
endcase

first_time_plotting_n = (*(*global).first_time_plotting_n)
first_time_plotting = first_time_plotting_n[n]

;populate text box
xmin_id = widget_info(Event.top,find_by_uname='xmin')
xmax_id = widget_info(Event.top,find_by_uname='xmax')
ymin_id = widget_info(Event.top,find_by_uname='ymin')
ymax_id = widget_info(Event.top,find_by_uname='ymax')

if (first_time_plotting EQ 1) then begin

    xmax = max(flt0,/nan)
    xmin = min(flt0,/nan)
    ymax = max(flt1,/nan)
    ymin = min(flt1,/nan)
    
;populate text_box
    widget_control, xmin_id, set_value=strcompress(xmin)
    widget_control, xmax_id, set_value=strcompress(xmax)
    widget_control, ymin_id, set_value=strcompress(ymin)
    widget_control, ymax_id, set_value=strcompress(ymax)
    
    xmin_global[n] = xmin
    ymin_global[n] = ymin
    xmax_global[n] = xmax
    ymax_global[n] = ymax

    first_time_plotting_n[n]=0
    
    if (instrument EQ 'REF_L') then begin
        REF_logo_base_id = widget_info(event.top,find_by_uname='REF_L_logo_base')
    endif else begin
        REF_logo_base_id = widget_info(event.top,find_by_uname='REF_M_logo_base')
    endelse
    
    widget_control, REF_logo_base_id, map=0
    x_y_axis_interaction_base_id = widget_info(event.top, find_by_uname='x_y_axis_interaction_base')
    widget_control, x_y_axis_interaction_base_id, map=1
    
endif else begin
    
    if ((*global).previous_n EQ n) then begin
        
        widget_control, xmin_id, get_value=xmin
        widget_control, xmax_id, get_value=xmax
        widget_control, ymin_id, get_value=ymin
        widget_control, ymax_id, get_value=ymax
        
        xmin=float(xmin)
        xmax=float(xmax)
        ymin=float(ymin)
        ymax=float(ymax)

        xmin_global[n] = xmin
        xmax_global[n] = xmax
        ymin_global[n] = ymin
        ymax_global[n] = ymax
        
    endif else begin

;populate xmin,xmax.... with appropriate values
        xmin = xmin_global[n]
        ymin = ymin_global[n]
        xmax = xmax_global[n]
        ymax = ymax_global[n]

        widget_control, xmin_id, set_value=strcompress(xmin,/remove_all)
        widget_control, xmax_id, set_value=strcompress(xmax,/remove_all)
        widget_control, ymin_id, set_value=strcompress(ymin,/remove_all)
        widget_control, ymax_id, set_value=strcompress(ymax,/remove_all)

    endelse

endelse

(*(*global).xmin_global) = xmin_global
(*(*global).xmax_global) = xmax_global
(*(*global).ymin_global) = ymin_global
(*(*global).ymax_global) = ymax_global
(*(*global).first_time_plotting_n) = first_time_plotting_n
(*global).previous_n = n

draw_id = widget_info(Event.top, find_by_uname=draw_uname)
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

catch, error_plot_status
if (error_plot_status NE 0) then begin
    text = 'Not enough data to plot'
    CATCH,/cancel

;log book ids (full and simple)
    view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
    full_view_info = widget_info(Event.top, find_by_uname='log_book_text')
    output_into_text_box, event, 'log_book_text', text
    output_into_text_box, event, 'info_text', text
endif else begin

;check status of x_axis (lin or log)
    x_axis_lin_log_REF_id = widget_info(event.top,find_by_uname='x_axis_lin_log_REF')
    widget_control, x_axis_lin_log_REF_id, get_value = x_axis_type
    
;check status of y_axis (lin or log)
    y_axis_lin_log_REF_id = widget_info(event.top,find_by_uname='y_axis_lin_log_REF')
    widget_control, y_axis_lin_log_REF_id, get_value= y_axis_type
    
    case x_axis_type of
        
        0:begin
            
            case y_axis_type of
                
                0: begin
                    plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title
                end
                
                1: begin
                    plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title,/ylog
                end
                
            endcase
            
        end
        
        1: begin
            
            case y_axis_type of
                
                0: begin
                    plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title,/xlog
                end
                
                1: begin
                    plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],title=title,/xlog,/ylog
                end
                
            endcase
            
        end
        
    endcase
    
    errplot,flt0,flt1 - flt2, flt1 + flt2,color = 100 ;'0xff00ffxl'
    
endelse

close,u
free_lun,u

end







pro plot_reduction_combine, Event, plot_file_name, draw_uname, title

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument
first_time_plotting_data_reduction = (*global).first_time_plotting_data_reduction

tvscl_x_off = 42
tvscl_y_off = 21

catch, error_plot_status
if (error_plot_status NE 0) then begin
    text = 'Not enough data to plot'
    CATCH,/cancel
    
;log book ids (full and simple)
    view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
    full_view_info = widget_info(Event.top, find_by_uname='log_book_text')
    output_into_text_box, event, 'log_book_text', text
    output_into_text_box, event, 'info_text', text

endif else begin
    
    Ntof = (*global).Ntof

    if (first_time_plotting_data_reduction EQ 1) then begin
            
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
        
        Nelines = 0L ;number of lines that does not start with a number
        Nndlines = 0L
        Ndlines = 0L
        onebyte = 0b
        
        while (NOT eof(u)) do begin
            
            readu,u,onebyte     ;,format='(a1)'
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
                    readf,u,tmp
                end
                
                else: begin
                                ;case where we (should) have data
                    Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
                    
                    catch, Error_Status
                    if Error_status NE 0 then begin
                        
                                ;you're done now...
                        CATCH, /CANCEL
                        
                    endif else begin
                        
                        readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                        flt0 = [flt0,float(tmp0)] ;x axis
                        flt1 = [flt1,float(tmp1)] ;y axis
                        flt2 = [flt2,float(tmp2)] ;y_error axis
                        
                    endelse
                    
                end
            endcase
            
        endwhile
        
;strip -1 from beginning of each array
        flt0 = flt0[1:*]
        flt1 = flt1[1:*]
        flt2 = flt2[1:*]
        
;check if plot is main plot or intermediate plot
        other_plots_tab_id = widget_info(Event.top,find_by_uname='data_reduction_tab')
        value = widget_info(other_plots_tab_id, /tab_current)
        
        case value of
            
            0: n=0
            2: begin            ;intermediate plots
                
;get active tab
                other_plots_tab_id = widget_info(Event.top,find_by_uname='other_plots_tab')
                value_intermediate = widget_info(other_plots_tab_id, /tab_current)
                
                case value_intermediate of
                    
                    0: n=1
                    1: n=2
                    2: n=3
                    3: n=4
                    4: n=5
                    
                endcase
                
            end
            else: n=0
        endcase
        
        first_time_plotting_n = (*(*global).first_time_plotting_n)
        first_time_plotting = first_time_plotting_n[n]
        
        if (first_time_plotting EQ 1) then begin
            
            first_time_plotting_n[n]=0
            REF_logo_base_id = widget_info(event.top,find_by_uname='REF_L_logo_base')
            
        endif
                    
        draw_id = widget_info(Event.top, find_by_uname=draw_uname)
        WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
        wset,view_plot_id
        
;x_axis
;        Ntof = 750L             ;remove_me
        x_axis=flt0[sort(flt0[0:(Ntof-1)])]
        tvscl_x_axis = lindgen(float(x_axis[Ntof-1]))
        (*(*global).tvscl_x_axis) = tvscl_x_axis
;y_axis
        flt0_size = size(flt0)
        number_of_row = fix(flt0_size[1]/Ntof)
        (*global).number_of_row_in_data_reduction_file = number_of_row
;define the final big array
        final_array = fltarr(Ntof,number_of_row)
        for i=0,(number_of_row-1) do begin
            final_array[0,i] = flt1[i*Ntof:i*Ntof+(Ntof-1)]
        endfor
        
        (*(*global).final_array) = final_array
        (*global).first_time_plotting_data_reduction = 0
        
        close,u
        free_lun,u

;plot of scale
        print, 'here'
        data_reduction_scale_id = widget_info(Event.top,FIND_BY_UNAME='data_reduction_scale')
        WIDGET_CONTROL, data_reduction_scale_id, GET_VALUE=id
        wset, id
        New_Ny = number_of_row * floor((393-tvscl_y_off)/number_of_row)
        cscl = lindgen(20,New_Ny)
        tvscl,cscl,25,10,/device
        
    endif else begin

        final_array = (*(*global).final_array)
        number_of_row = (*global).number_of_row_in_data_reduction_file 
        tvscl_x_axis = (*(*global).tvscl_x_axis)

    endelse

    if (instrument EQ 'REF_L') then begin

        data_reduction_scale_max_id = widget_info(event.top,find_by_uname='data_reduction_scale_max')
        data_reduction_scale_min_id = widget_info(event.top,find_by_uname='data_reduction_scale_min')
        
        if (first_time_plotting_data_reduction EQ 1) then begin
            
            max_top = max(final_array,/nan)
            min_top = min(final_array,/nan)
            widget_control, data_reduction_scale_max_id, set_value=strcompress(max_top)
            widget_control, data_reduction_scale_min_id, set_value=strcompress(min_top)
            
        endif
        
        if ((*global).reset_data_reduction EQ 0) then begin
            
;remove data outside the range selected in the text boxes
            widget_control, data_reduction_scale_max_id, get_value=max_value
            widget_control, data_reduction_scale_min_id, get_value=min_value
            
            if (max_value NE '') then begin
                max_value = float(max_value[0])
                indx_max = where(float(final_array) GT max_value, Nmax)
                if (Nmax NE 0) then begin
                    final_array(indx_max) = !Values.F_NAN
                endif
            endif
            
            if (min_value NE '') then begin
                min_value = float(min_value[0])
                indx_min = where(final_array LT min_value, Nmin)
                if (Nmin NE 0) then begin
                    final_array(indx_min) = !Values.F_NAN
                endif
            endif
            
        endif else begin

            max_top = max(final_array,/nan)
            min_top = min(final_array,/nan)
            widget_control, data_reduction_scale_max_id, set_value=strcompress(max_top)
            widget_control, data_reduction_scale_min_id, set_value=strcompress(min_top)
            (*global).reset_data_reduction = 0            

        endelse
        
    endif

;;remove -inf and inf
;    indx1 = where(final_array EQ !VALUES.F_INFINITY, ngt1)
;    if (ngt1 NE 0) then begin
;        final_array(indx1) = (*global).plus_inf
;    endif
;    
;    indx2 = where(final_array EQ -!VALUES.F_INFINITY, ngt2)
;    if (ngt2 NE 0) then begin
;        final_array(indx2) = (*global).minus_inf
;    endif
    
    uncombine_data_formula_id = widget_info(event.top,find_by_uname='uncombine_data_formula')
    widget_control, uncombine_data_formula_id, get_value=formula_list
    index = widget_info(uncombine_data_formula_id, /droplist_select)
    formula_selected = formula_list[index]
    
    if ( formula_selected EQ 'log10') then begin ;log10
        
;remove negative numbers and zeros too
        indx4 = where(final_array LE 0, ngt0)
        if (ngt0 NE 0) then begin
            final_array(indx4) = !values.F_NAN
        endif
        
        indx5 = where(final_array GT 0, ngt1) 
        if (ngt1 NE 0) then begin
            final_array(indx5) = alog10(final_array(indx5))
        endif
        
    endif
    
;;indx3 = where(final_array EQ strcompress(!values.F_NAN), ngt)
;nan = !VALUES.F_NAN
;nan_user = (*global).nan_user
;for i=0,(number_of_row*Ntof-1) do begin
;    if (strcompress(final_array[i]) EQ strcompress(nan)) then begin
;        final_array[i] = nan_user 
;    endif
;endfor
    
;tvscl, final_array, /NAN
    
    CATCH,/CANCEL
    
    DEVICE, DECOMPOSED = 0
;    loadct,5
    
    New_Ny = number_of_row * floor((393-tvscl_y_off)/number_of_row)

;comment out this part when using tmp button
;    y12=18
;    ymin=50

;comment this part when using tmp button
    y12=(*global).y12
    ymin=(*global).ymin


;    tvscl_y_axis = indgen(y12)

    data_reduction_id = widget_info(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, data_reduction_id, GET_VALUE=id
    wset, id
    
    if (y12 GE 30) then begin
        
        tvscl_y_axis = (indgen(y12)+ymin)

        tvimg = rebin(final_array, Ntof, New_Ny, /sample)
        tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan
        plot, tvscl_x_axis, tvscl_y_axis, $
          yrange=[tvscl_y_axis[0],$
                  tvscl_y_axis[y12-1]],yticklayout=0, $
;      ystyle=8, $
        ystyle=1,$
          xstyle=8, $
          /nodata, /device, $
          /noerase, $
          xmargin=[7,0], $
;      ymargin=[2,0]
        ymargin=[2,(393-New_Ny)/10],$
          title='x-axis: tof(s) / y-axis: pixels'

    endif else begin

        tvscl_y_axis = (indgen(y12)+ymin)*0.7
        tvscl_y_axis_string = string(tvscl_y_axis)
        
        tvimg = rebin(final_array, Ntof, New_Ny, /sample)
        tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan
        plot, tvscl_x_axis, tvscl_y_axis, $
          yrange=[tvscl_y_axis[0],$
                  tvscl_y_axis[y12-1]],yticklayout=0, $
          ytickname=tvscl_y_axis_string, $
;      ystyle=8, $
        ystyle=1,$
          xstyle=8, $
          /nodata, /device, $
          /noerase, $
          xmargin=[7,0], $
;      ymargin=[2,0]
        ymargin=[2,(393-New_Ny)/10],$
          title='x-axis: tof(s) / y-axis: distance (mm)'
            
    endelse

  endelse
  
end













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

;turn off plot selection if previous array was [0,0,0,0]
if (value_selection[0] EQ 0 AND $
    value_selection[1] EQ 0 AND $
    value_selection[2] EQ 0 AND $
    value_selection[3] EQ 0 ) then begin
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
        plots_selection_id = $
          widget_info(Event.top, find_by_uname='intermediate_plots_list_group')
        widget_control, plots_selection_id, get_value=value_selection

        (*global).plots_selected = value_selection
        (*global).entering_selection_of_plots_by_yes_button = 1        
        
    endif else begin            ;remove other plots 
        
        intermediate_plot_base = widget_info(Event.top, $
                                             find_by_uname='list_of_plots_base')
        widget_control, intermediate_plot_base, map=0
        
                                ;remove labels on tabs
        tab_1_id = widget_info(Event.top, $
                               find_by_uname='signal_region_tab_base')
        tab_2_id = widget_info(Event.top, $
                               find_by_uname='background_summed_tof_base')
        tab_3_id = widget_info(Event.top, $
                               find_by_uname='normalization_region_summed_tof_base')
        tab_4_id = $
          widget_info(Event.top, $
                      find_by_uname=$
                      'background_region_from_normalization_region_summed_tof_base')
        widget_control, tab_1_id, base_set_title=''
        widget_control, tab_2_id, base_set_title=''
        widget_control, tab_3_id, base_set_title=''
        widget_control, tab_4_id, base_set_title=''
        
        full_text = 'No intermediate files will be produced'
        text = 'No intermediate plot'

        output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
;        widget_control, full_view_info, set_value=full_text, /append
;        widget_control, view_info, set_value=text, /append

        (*global).entering_selection_of_plots_by_yes_button = 0        

        screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
        widget_control, screen_base_id, map=1

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

indx0 = value[0]                ;.sdc
indx1 = value[1]                ;.bkg
indx2 = value[2]                ;.nom
indx3 = value[3]                ;.bnm

number_of_plots_selected = 0

runs_to_process = (*global).runs_to_process
if (runs_to_process LE 1) then begin
    full_text = 'Name of intermediate plots that will be plotted:'
endif else begin
    full_text = 'Name of intermediate files that will be produced for each of the ' + $
      strcompress(runs_to_process,/remove_all) + ' runs number:'
endelse
output_into_text_box, event, 'log_book_text', full_text
;widget_control, full_view_info, set_value=full_text, /append

tab_1_id = widget_info(Event.top, find_by_uname='signal_region_tab_base')
if (indx0 EQ 1) then begin ;signal region summed TOF

    widget_control, tab_1_id, base_set_title='Signal'
    number_of_plots_selected += 1
    
    full_text = ' - Signal region summed TOF'
;    widget_control, full_view_info, set_value=full_text, /append
    output_into_text_box, event, 'log_book_text', full_text
endif else begin
    
    widget_control, tab_1_id, base_set_title=''
    
endelse

tab_2_id = widget_info(Event.top, find_by_uname='background_summed_tof_base')
if (indx1 EQ 1) then begin
    
    widget_control, tab_2_id, base_set_title='Background'
    number_of_plots_selected += 1
    
    full_text = ' - Background summed TOF'
;    widget_control, full_view_info, set_value=full_text, /append
 output_into_text_box, event, 'log_book_text', full_text   
endif else begin
                                ;remove this plot from the list of selected plots
    indx1 = 0
    new_value = [indx0, indx1, indx2, indx3]
    
    widget_control,list_of_plots_id,set_value=new_value
    widget_control, tab_2_id, base_set_title=''
    
endelse

norm_back_id = widget_info(Event.top, find_by_uname='normalization_list_group_REF_M')
widget_control, norm_back_id, get_value=norm_flag ;0:with norm    1:no normalization
tab_3_id = widget_info(Event.top, find_by_uname='normalization_region_summed_tof_base')

if (indx2 EQ 1 AND norm_flag EQ 0) then begin
    
    widget_control, tab_3_id, base_set_title='Normalization'
    number_of_plots_selected += 1
    
    full_text = ' - Normalization region summed TOF'
;    widget_control, full_view_info, set_value=full_text, /append
 output_into_text_box, event, 'log_book_text', full_text   
endif else begin
    
    indx2 = 0
    widget_control, tab_3_id, base_set_title=''
    
endelse

norm_id = widget_info(Event.top, find_by_uname='norm_background_list_group')
widget_control, norm_id, get_value=norm_flag ;0:with norm    1:no normalization
tab_4_id = $
  widget_info(Event.top, $
              find_by_uname='background_region_from_normalization_region_summed_tof_base')
if (indx3 EQ 1 AND norm_flag EQ 0) then begin
    
    widget_control, tab_4_id, base_set_title='Background from normalization'
    number_of_plots_selected += 1
    
    full_text = ' - Background region from normalization summed TOF'
;    widget_control, full_view_info, set_value=full_text, /append
 output_into_text_box, event, 'log_book_text', full_text   
endif else begin
    
    indx3 = 0
    widget_control, tab_4_id, base_set_title=''
    
endelse

intermediate_plot_base = widget_info(Event.top, find_by_uname='list_of_plots_base')
widget_control, intermediate_plot_base, map=0

;if none of the plots have been selected change status of intermediate
;plots to NO
screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
if (number_of_plots_selected EQ 0) then begin

    inter_id = $
      widget_info(Event.top,find_by_uname='intermediate_file_output_list_group_REF_M')
    widget_control, inter_id, set_value=1
    full_text = ' NONE'
;    widget_control, full_view_info, set_value=full_text, /append
output_into_text_box, event, 'log_book_text', full_text 
   widget_control, screen_base_id, map=1

endif else begin
    
    inter_id = $
      widget_info(Event.top,find_by_uname='intermediate_file_output_list_group_REF_M')
    widget_control, inter_id, set_value=0
    widget_control, screen_base_id, map=0
    
endelse

if ((*global).runs_to_process LE 1) then begin
    text = 'Number of plots selected: '+ strcompress(number_of_plots_selected,/remove_all)
endif else begin
    text = 'Number of files selected: '+ strcompress(number_of_plots_selected,/remove_all)
endelse

output_into_text_box, event, 'info_text', text
;widget_control, view_info, set_value=text, /append

(*global).plots_selected = [indx0,indx1,indx2,indx3]

end







;check status of all text boxes and buttons to validate or not GO Data
;Reduction
pro check_status_to_validate_go, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

status=0
instrument = (*global).instrument

;erase data_reduction plot
erase_reduction_plot, event, 'data_reduction_plot'
;reset_and_erase_displays, Event

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

;check status of with or without background, if no background text, check
;that no background has been checked. 

    background_list_group_id = widget_info(Event.top,find_by_uname='background_list_group')
    widget_control, background_list_group_id, get_value=back_index

    if (bkg_pid_text EQ '' AND back_index EQ 1) then begin
        bkg_pid_text = 'ok'
    endif

endelse

widget_control, norm_list_group_id, get_value=norm_list_group
normalization_text = "anything"
if (norm_list_group EQ 0) then begin
    normalization_text_id = widget_info(Event.top, find_by_uname='normalization_text')
    widget_control, normalization_text_id, get_value=normalization_text
endif

;check the number of intermediate plots desired
plots_selected = (*global).plots_selected
screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
if (instrument EQ 'REF_L') then begin
    if (plots_selected[0] EQ 0 AND $
        plots_selected[1] EQ 0 AND $
        plots_selected[2] EQ 0 AND $
        plots_selected[3] EQ 0 AND $
        plots_selected[4] EQ 0) then begin
        widget_control, screen_base_id, map=1
    endif else begin
        widget_control, screen_base_id, map=0
    endelse
endif else begin
    if (plots_selected[0] EQ 0 AND $
        plots_selected[1] EQ 0 AND $
        plots_selected[2] EQ 0 AND $
        plots_selected[3] EQ 0) then begin
        widget_control, screen_base_id, map=1
    endif else begin
        widget_control, screen_base_id, map=0
    endelse
endelse

;check if runs number not empty
if (instrument EQ 'REF_L') then begin
    runs_to_process_text_id = widget_info(Event.top, find_by_uname='runs_to_process_text')
    widget_control, runs_to_process_text_id, get_value=runs_to_process_text
endif else begin ; REF_M
    combobox_id = widget_info(Event.top,find_by_uname='several_nexus_combobox')
    widget_control, combobox_id, get_value=value
    size_value_array = size(value)
    runs_to_process = size_value_array[1]-1
    (*global).runs_to_process = runs_to_process
    case runs_to_process of 
        0: begin
            runs_to_process_text = '' ;0 run number
                                ;bring base that hide intermediate plots
            screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
            widget_control, screen_base_id, map=1
            end
        1: begin
            runs_to_process_text = 'anything' ;1 run number
           list_of_intermediate_plots_title_id = $
             widget_info(Event.top,$
                         find_by_uname='list_of_intermediate_plots_title')
           widget_control, $
             list_of_intermediate_plots_title_id, $
             set_value='List of intermediate plots'
            other_plots_base_id = $
              widget_info(Event.top,$
                          find_by_uname='access_to_list_of_intermediate_plots_button')
            widget_control, other_plots_base_id, set_value='Intermediate plots'
                                ;bring base that hide intermediate plots
            screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
            widget_control, screen_base_id, map=0
            end
        else: begin
            runs_to_process_text = 'anything' ;2 or more runs number
                                ;change title of intermediate plots label
           list_of_intermediate_plots_title_id = $
             widget_info(Event.top,$
                         find_by_uname='list_of_intermediate_plots_title')
           widget_control, $
             list_of_intermediate_plots_title_id, $
             set_value='List of intermediate files'
                                ;change title inside intermediate window
            other_plots_base_id = $
              widget_info(Event.top,$
                          find_by_uname='access_to_list_of_intermediate_plots_button')
            widget_control, other_plots_base_id, set_value='Intermediate files'
                                ;bring base that hide intermediate plots
            screen_base_id = widget_info(Event.top,find_by_uname='screen_base')
            widget_control, screen_base_id, map=1
        end
    endcase
endelse

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
    strcompress(runs_to_process_text,/remove_all) NE '') then begin

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

if (instrument EQ 'REF_M') then begin
    
start_data_reduction_button_id = $
  widget_info(Event.top,$
              find_by_uname='start_data_reduction_button')

    if (status EQ 1) then begin 
        widget_control,start_data_reduction_button_id, sensitive=1
    endif else begin
        widget_control,start_data_reduction_button_id, sensitive=0
    endelse

endif else begin

start_data_reduction_button_REF_L_id = $
  widget_info(Event.top,$
              find_by_uname='start_data_reduction_button_REF_L')

    if (status EQ 1) then begin 
        widget_control,start_data_reduction_button_REF_L_id, sensitive=1
    endif else begin
        widget_control,start_data_reduction_button_REF_L_id, sensitive=0
    endelse

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


pro background_list_group_eventcb, Event
check_status_to_validate_go, Event
end


pro sns_idl_button_eventcb, Event
spawn, '/SNS/users/j35/IDL/MainInterface/sns_idl_tools &'
end




pro working_path_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_working_path = (*global).tmp_working_path

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

no_folder = 0
catch, no_folder

if (no_folder NE 0) then begin

    text = 'Working folder is still: ' + (*global).local_folder
    output_into_text_box, event, 'log_book_text', text
    output_into_text_box, event, 'info_text', text

;    widget_control, view_info, set_value=text, /append
;    widget_control, full_view_info, set_value=text, /append

endif else begin

    tmp_working_path = dialog_pickfile(path=tmp_working_path,/directory)
    (*global).local_folder = tmp_working_path
    text = 'Working folder is now: ' + tmp_working_path
    output_into_text_box, event, 'log_book_text', text
;create folder 
    cmd_create = "mkdir " + tmp_working_path
    cmd_text = '> ' + cmd_create
    output_into_text_box, event, 'log_book_text', cmd_text
;    widget_control, full_view_info, set_value=cmd_text, /append
    spawn, cmd_create, listening, error_listening
    output_error, event, 'log_book_text', error_listening

endelse

catch,/cancel

end






pro working_path_ref_l_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

local_folder = (*global).local_folder

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

no_folder = 0
catch, no_folder

if (no_folder NE 0) then begin

    text = 'Working folder is still: ' + (*global).local_folder
    output_into_text_box, event, 'log_book_text', text
    output_into_text_box, event, 'info_text', text

;    widget_control, view_info, set_value=text, /append
;    widget_control, full_view_info, set_value=text, /append

endif else begin

    tmp_working_path = dialog_pickfile(path=local_folder,/directory)
    (*global).local_folder = tmp_working_path
    
;create folder 
    cmd_create = "mkdir " + tmp_working_path
    cmd_text = '> ' + cmd_create
    output_into_text_box, event, 'log_book_text', cmd_text
;    widget_control, full_view_info, set_value=cmd_text, /append
    spawn, cmd_create, listening, error_listening
    output_error, event, 'log_book_text', err_listening

endelse

catch,/cancel

end





function get_distance, text, pattern, index

result = strsplit(text, pattern, /extract)

return, result[index]
end








function display_xml_info_MDD, filename, item_name

oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=filename)

oDocList = oDoc->GetElementsByTagName('motors_91031')
obj1 = oDocList->item(0)

obj2=obj1->GetElementsByTagName('ModeratorSamDis')
obj3=obj2->item(0)

obj3b=obj3->getattributes()
obj3c=obj3b->getnameditem(item_name)

return, obj3c->getvalue()

end





function display_xml_info_SDD, filename, item_name

oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=filename)

oDocList = oDoc->GetElementsByTagName('motors_91031')
obj1 = oDocList->item(0)

obj2=obj1->GetElementsByTagName('SampleDetDis')
obj3=obj2->item(0)

obj3b=obj3->getattributes()
obj3c=obj3b->getnameditem(item_name)

return, obj3c->getvalue()

end






pro populate_distance_labels, event, full_nexus_name  ;REF_M

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd_nxdir = "nxdir -p NXdetector/NXgeometry/NXtranslation/distance -l "
cmd_nxdir += full_nexus_name

distance_err = 0
CATCH, distance_err

distance_sample_detector_das_id = $
  widget_info(Event.top,find_by_uname='distance_sample_detector_nexus')
    
if (distance_err NE 0) then begin
    widget_control, distance_sample_detector_das_id, set_value='N/A'
endif else begin
    spawn, cmd_nxdir, listening
    
    distance_tmp = get_distance(listening[0],',',2)
    distance = get_distance(distance_tmp, ']',0)
    
    if (distance EQ '') then begin
        distance = 'N/A'
    endif else begin
        distance += ' m'
    endelse

;distance sample - moderator nexus
    widget_control, distance_sample_detector_das_id, set_value=distance
endelse

catch, /cancel

;distance sample - moderator nexus nexus
cmd_nxdir = "nxdir -p NXmoderator/distance/ "
cmd_nxdir += full_nexus_name + ' -o'
spawn, cmd_nxdir, listening
distance_DS_tmp  = get_distance(listening[0],'=',1)

distance_err = 0
CATCH, distance_err

if (distance_DS_tmp EQ '') then begin
    distance_DS = 'N/A'
endif else begin
    distance_DS = abs(float(distance_DS_tmp))
    distance_DS = strcompress(distance_DS) + ' m'
endelse

catch, /cancel

distance_moderator_detector_nexus_id = $
  widget_info(Event.top,find_by_uname='distance_moderator_detector_nexus')

widget_control, distance_moderator_detector_nexus_id, $
  set_value=strcompress(distance_DS,/remove_all)

full_prenexus_name = $
  find_full_prenexus_name(Event, $
                          0, $
                          (*global).run_number, $
                          (*global).instrument)

;distance moderator_detector DAS
distance_err = 0
CATCH, distance_err

if (distance_err NE 0) then begin

    value = 'N/A'

endif else begin

    value = display_xml_info_MDD(full_prenexus_name[0], "value")
    
    if (value EQ '') then begin
        value = 'N/A'
    endif else begin
        value += ' mm'
    endelse

endelse

distance_moderator_detector_das_id = $
  widget_info(event.top, find_by_uname='distance_moderator_detector_das')
widget_control, distance_moderator_detector_das_id, set_value=value

catch, /cancel

distance_err = 0
CATCH, distance_err


if (distance_err NE 0) then begin

    value = 'N/A'

endif else begin

;distance sample detector DAS
    value = display_xml_info_SDD(full_prenexus_name[0], "value")
    value += ' mm'

endelse

distance_sample_detector_das_id = $
  widget_info(event.top, find_by_uname='distance_sample_detector_das')
widget_control, distance_sample_detector_das_id, set_value=value

catch, /cancel


end
















pro start_data_reduction_button_eventcb_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

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
normalization_status_id = widget_info(Event.top, $
                                      find_by_uname='normalization_list_group_REF_L')
widget_control, normalization_status_id, get_value=norm_flag

;norm_flag=0 means with normalization
 if (norm_flag EQ 0) then begin 

     normalization_text_id = widget_info(Event.top, find_by_uname='normalization_text')
     widget_control, normalization_text_id, get_value=run_number_normalization

     text= 'Normalization run used: ' + run_number_normalization
     output_into_text_box, event, 'log_book_text', text
;     WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
   
;     if (run_number_normalization NE '') then begin
        
; ;verify format 
;         wrong_format = 0
;         CATCH, wrong_run_number_format
        
;         if (wrong_run_number_format ne 0) then begin
            
;             WIDGET_CONTROL, view_info, $
;               SET_VALUE="ERROR: normalization run number invalid", /APPEND
;             WIDGET_CONTROL, view_info, SET_VALUE="Program Terminated", /APPEND
;             text = 'ERROR: normalization run number invalid - ' + run_number_normalization
;             WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
;             WIDGET_CONTROL, full_view_info, SET_VALUE="Program Terminated", /APPEND
;             wrong_format = 1
;             stop_reduction = 1
            
;         endif else begin
            
; ;routine use to test format of normalization run number
;             a=lonarr(float(run_number_normalization))
            
;             if (wrong_format EQ 0) then begin
                
; ;get full NeXus path
;                 cmd_findnexus = "findnexus -i" + (*global).instrument
;                 cmd_findnexus += " " + strcompress(run_number_normalization, /remove_all)
;                 spawn, cmd_findnexus, full_path_to_nexus_normalization
                
; ;check if nexus exists
;                 result = strmatch(full_path_to_nexus_normalization,"ERROR*")
                
;                 if (result[0] GE 1) then begin
                    
;                     find_nexus = 0 ;run# does not exist in archive
;                     text = 'Normalization file does not exist'
;                     full_text = 'Normalization run number file does not exist (' + $
;                       full_path_to_nexus_normalization + ')'
;                     stop_reduction = 1
                    
;                 endif else begin
                    
;                     find_nexus = 1 ;run# exist in archive
;                     text = 'Normalization file: OK'
;                     full_text = $
;                       'Normalization file used: ' + full_path_to_nexus_normalization  
                    
;                 endelse
                
;                 widget_control, view_info, set_value=text, /append
;                 widget_control, full_view_info, set_value=full_text, /append
                
;             endif
            
;         endelse
        
;         catch, /cancel
        
;     endif else begin
        
;         text = 'Please specify a normalization run number'
;         full_text = 'Normalization run number: MISSING'
;         widget_control, view_info, set_value=text, /append
;         widget_control, full_view_info, set_value=full_text, /append
;         stop_reduction = 1
        
;     endelse
    
 endif

;****************************
;check status of bkg flag
bkg_flag_id = widget_info(Event.top, find_by_uname='background_list_group')
widget_control, bkg_flag_id, get_value=bkg_flag

;*****************************
;get runs_to_process list of files

run_data_reduction_tab_id = widget_info(event.top,$
                                        find_by_uname='run_data_reduction_tab')
tab_value = widget_info(run_data_reduction_tab_id, /tab_current)
                                        
if (tab_value EQ 0) then begin
    runs_to_process_text_id = widget_info(Event.top, $
                                          find_by_uname='runs_to_process_text')
endif else begin
    runs_to_process_text_id = widget_info(event.top,$
                                          find_by_uname='sequentially_runs_to_process_text')
endelse

widget_control, runs_to_process_text_id, get_value=runs_to_process
runs_and_full_path = get_final_list_of_runs(Event, runs_to_process)

;*****************************
;check status of normalize bkg
norm_bkg_id = widget_info(Event.top, find_by_uname='norm_background_list_group')
widget_control, norm_bkg_id, get_value=norm_bkg_value

;*****************************
;check status of intermediate outputs
interm_id = widget_info(Event.top, find_by_uname='intermediate_file_output_list_group')

widget_control, interm_id, get_value=interm_status

nbr_runs_to_use_size = size(runs_and_full_path)
nbr_runs_to_use = nbr_runs_to_use_size[1]

;*****************************
;check status of instrument geometry file
instrument_geometry_button_id = widget_info(event.top, find_by_uname='instrument_geometry_list_group')
widget_control, instrument_geometry_button_id, get_value=instrument_geometry

;*****************************
;check status of combine data spectrum
combine_data_spectrum_id = widget_info(event.top,find_by_uname='combine_data_spectrum_list_group')
widget_control, combine_data_spectrum_id, get_value=combine_data_spectrum

if (tab_value EQ 0) then begin
    
;start command line for REF_L
;    REF_L_cmd_line = "reflect_tofred_batch " 

    REF_L_cmd_line = "reflect_tofred "   

;add list of NeXus run numbers
    runs_text = ""
    for j=0,(nbr_runs_to_use-1) do begin
        runs_text += strcompress(runs_and_full_path[j,0],/remove_all) + " "
    endfor
    REF_L_cmd_line += runs_text
    
;normalization
    if (norm_flag EQ 0) then begin
        norm_cmd = " --norm=" + strcompress(run_number_normalization,/remove_all)
        REF_L_cmd_line += norm_cmd
    endif
    
;    REF_L_cmd_line += " -- "
    
;instrument geometry
    if (instrument_geometry EQ 0) then begin
        instr_geom_cmd = " --inst_geom=" + (*global).instrument_geometry_file_name
        REF_L_cmd_line += instr_geom_cmd
    endif

;combine data spectrum
    if (combine_data_spectrum EQ 0) then begin
        comb_data_spect = " --combine"
        REF_L_cmd_line += comb_data_spect
    endif

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
            interm_plot_cmd += " --dump-bkg"
        endif
;.bkg   
        if (list_of_plots[1] EQ 1) then begin
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
        
;.bnk
        if (list_of_plots[4] EQ 1) then begin
            interm_plot_cmd += " --dump-norm-bkg"
        endif
        
        REF_L_cmd_line += interm_plot_cmd
        
    endif
    
    text = "Processing data reduction...."
    
    output_into_text_box, event, 'info_text', text
;    widget_control, view_info, set_value=text,/append
    full_text = " running using the following command line:"
    output_into_text_box, event, 'log_book_text', full_text
;    widget_control, full_view_info, set_value=full_text,/append
    
    full_text = "> " + REF_L_cmd_line
    cmd_line = REF_L_cmd_line
    
    output_into_text_box, event, 'log_book_text', full_text
;    widget_control, full_view_info, set_value=full_text,/append
    starting_time = systime(1)
    
    widget_control,/hourglass
    
;desactive run_reduction_button
    start_data_reduction_button_id = $
      widget_info(Event.top,find_by_uname='start_data_reduction_button_REF_L')
    widget_control, start_data_reduction_button_id, sensitive=0
    
;main data reduction command line

    spawn, cmd_line, listening  
    (*global).data_reduction_done = 1             
    
    text = "...DONE"
    ending_time = systime(1)
    
    total_processing_time = ending_time - starting_time
    full_text = '...DONE in ' + strcompress(total_processing_time,/remove_all) + ' s'
    
    output_into_text_box, event, 'log_book_text', full_text
    output_into_text_box, event, 'info_text', text
 
;   widget_control, full_view_info, set_value=full_text,/append
;    widget_control, view_info, set_value=text,/append
    
    run_number_min = get_min_run_number(runs_and_full_path)

    text = 'Plotting output main output file....'
    main_output_file_name = produce_output_file_name(Event, run_number_min, '.txt')
    (*global).main_output_file_name = main_output_file_name
    full_text = 'Plotting main output file: ' + main_output_file_name
    output_into_text_box, event, 'log_book_text', full_text
    output_into_text_box, event, 'info_text', text
 
;   widget_control, full_view_info, set_value=full_text,/append
;    widget_control, view_info, set_value=text,/append
    
;plot main .txt file
    draw_id = 'data_reduction_plot'
    title = "Intensity vs. Wavelength "
    plot_reduction, $
      Event, $
      main_output_file_name, $
      draw_id, $
      title
    
    text = '...plot is done'
    full_text = '...plot is done'
    output_into_text_box, event, 'log_book_text', full_text
    output_into_text_box, event, 'info_text', text
;    widget_control, full_view_info, set_value=full_text,/append
;    widget_control, view_info, set_value=text,/append
    
endif else begin

    for i=0,(nbr_runs_to_use-1) do begin
        
        full_text = '-> Working on run # ' + strcompress(runs_and_full_path[i,0]) + ':'
        output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
;        widget_control, full_view_info, set_value=full_text,/append
;        widget_control, view_info, set_value=full_text,/append

;start command line for REF_L
        REF_L_cmd_line = "reflect_tofred " 
        
;add list of NeXus run numbers
        runs_text = ""
        runs_text += strcompress(runs_and_full_path[i,0],/remove_all) + " "
        REF_L_cmd_line += runs_text
        
;normalization
        if (norm_flag EQ 0) then begin
            norm_cmd = " --norm=" + strcompress(run_number_normalization,/remove_all)
            REF_L_cmd_line += norm_cmd
        endif
        
;        REF_L_cmd_line += " -- "
        
;combine data spectrum
    if (combine_data_spectrum EQ 0) then begin
        comb_data_spect = " --combine"
        REF_L_cmd_line += comb_data_spect
    endif

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
            
;.bnk
            if (list_of_plots[4] EQ 1) then begin
                interm_plot_cmd += " --dump-norm-bkg"
            endif
            
            REF_L_cmd_line += interm_plot_cmd
            
        endif
        
        text = "Processing data reduction...."
        
;        widget_control, view_info, set_value=text,/append
        full_text = " running using the following command line:"
        output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
;        widget_control, full_view_info, set_value=full_text,/append
        
        full_text = "> " + REF_L_cmd_line
        cmd_line = REF_L_cmd_line
                output_into_text_box, event, 'log_book_text', full_text
;        widget_control, full_view_info, set_value=full_text,/append
        starting_time = systime(1)
        
        widget_control,/hourglass
        
;desactive run_reduction_button
        start_data_reduction_button_id = $
          widget_info(Event.top,find_by_uname='start_data_reduction_button_REF_L')
        widget_control, start_data_reduction_button_id, sensitive=0
        
;main data reduction command line
        spawn, cmd_line, listening  
        
        (*global).data_reduction_done = 1             
        
        text = "...DONE"
        ending_time = systime(1)
        
        total_processing_time = ending_time - starting_time
        full_text = '...DONE in ' + strcompress(total_processing_time,/remove_all) + ' s'
        
       output_into_text_box, event, 'log_book_text', full_text
       output_into_text_box, event, 'info_text', text
;        widget_control, full_view_info, set_value=full_text,/append
;        widget_control, view_info, set_value=text,/append
        
        text = 'Plotting output main output file....'
        run_number_min = get_min_run_number(runs_and_full_path)
        
        main_output_file_name = produce_output_file_name(Event, run_number_min, '.txt')
        (*global).main_output_file_name = main_output_file_name
        full_text = 'Plotting main output file: ' + main_output_file_name
       output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
;        widget_control, full_view_info, set_value=full_text,/append
;        widget_control, view_info, set_value=text,/append
        
;plot main .txt file
        draw_id = 'data_reduction_plot'
        title = "Intensity vs. Wavelength "
        plot_reduction, $
          Event, $
          main_output_file_name, $
          draw_id, $
          title
        
        text = '...plot is done'
        full_text = '...plot is done'
       output_into_text_box, event, 'log_book_text', full_text
        output_into_text_box, event, 'info_text', text
;        widget_control, full_view_info, set_value=full_text,/append
;        widget_control, view_info, set_value=text,/append
        
    endfor

endelse

text = '...done'
full_text = '...done'
output_into_text_box, event, 'log_book_text', full_text
output_into_text_box, event, 'info_text', text
;widget_control, full_view_info, set_value=full_text,/append
;widget_control, view_info, set_value=text,/append

widget_control,hourglass=0

end





pro open_nexus_button_eventcb, Event
open_nexus_file, event
end




pro save_session_group_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id=widget_info(Event.top,find_by_uname='save_session_group')
widget_control, id, get_value=value

(*global).save_session = value

if (value EQ 0) then begin

    keep_signal = 1
    keep_back = 1

endif else begin

    keep_signal = 0
    keep_back = 0

endelse

(*global).keep_signal_selection = keep_signal
(*global).keep_back_selection = keep_back

end




pro add_run_number_to_list_if_not_present, event, uname, run_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get list of run number to process
text_id = widget_info(Event.top,find_by_uname=uname)
widget_control, text_id, get_value=list_of_runs

;get list of runs if list not empty
if (list_of_runs NE '') then begin
    array_of_runs = get_list_of_runs ((*global).instrument, list_of_runs)

;check that run_number is not in list already
    already_present_run_number = check_if_run_number_already_in_list(array_of_runs,run_number)
    
    if (already_present_run_number EQ 0) then begin
        final_list_of_runs = list_of_runs + ',' + run_number
        widget_control, text_id, set_value=final_list_of_runs
    endif

endif else begin
    widget_control, text_id, set_value=run_number
endelse


end



pro restore_button_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check if plot is main plot or intermediate plot
other_plots_tab_id = widget_info(Event.top,find_by_uname='data_reduction_tab')
value = widget_info(other_plots_tab_id, /tab_current)

case value of
    
    0: n=0
    2: begin                    ;intermediate plots
        
;get active tab
        other_plots_tab_id = widget_info(Event.top,find_by_uname='other_plots_tab')
        value_intermediate = widget_info(other_plots_tab_id, /tab_current)
        
        case value_intermediate of
            
            0: n=1
            1: n=2
            2: n=3
            3: n=4
            4: n=5
             
        endcase
        
    end
    else:
endcase

first_time_plotting_n = (*(*global).first_time_plotting_n)
first_time_plotting_n[n]=1
(*(*global).first_time_plotting_n) = first_time_plotting_n

data_reduction_tab_cb, Event

end




pro populate_proton_charge, event, full_nexus_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

nxdir_cmd = 'nxdir ' + full_nexus_name
nxdir_cmd += ' -p /entry/proton_charge/ -o'
spawn, nxdir_cmd, listening

proton_charge_array = strsplit(listening,'=',/extract,/regex)
no_proton_charge = 0
catch, no_proton_charge
text = 'Proton charge = '
if (no_proton_charge NE 0) then begin
    catch, /cancel
    text += ' N/A'
endif else begin
    proton_charge_str = proton_charge_array[1]
    proton_charge_pC = double(proton_charge_str) * (0.36)
    text += strcompress(proton_charge_pC)
    text += ' 10^10 pC'
endelse
output_into_text_box, event, 'info_text', text

end







pro instrument_geometry_button_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

instrument_geometry = (*global).instrument_geometry  ;the actual status of the instrument geometry switch
first_time_entering_procedure = (*global).first_time_entering_procedure

if (first_time_entering_procedure EQ 0) then begin
    
    if (instrument_geometry EQ 'no') then begin  ;we want to overwrite the geometry file
        
        instr_geometry_path = (*global).instr_geometry_path
        
        pid_path = instr_geometry_path
        title = 'Select your instrument geometry file'
        filter = (*global).instrument + '_geom_*.nxs'
        
;open file
        full_geometry_file = dialog_pickfile(path=pid_path,$
                                             get_path=path,$
                                             title=title,$
                                             filter=filter)
        
        instrument_geometry_text_id = widget_info(Event.top,find_by_uname='instrument_geometry_text')
        
        if (full_geometry_file NE '') then begin
            
;    last_part_of_name = get_last_part_of_pid_file_name(full_geometry_file)
;    widget_control, instrument_geometry_text_id, set_value=last_part_of_name
            
;put info into log_book
            text = ' Data Reduction will use the geometry file:'
            output_into_text_box, event, 'log_book_text', text
            output_into_text_box, event, 'log_book_text', ' ' + full_geometry_file
            (*global).instrument_geometry_file_name = full_geometry_file
            
            check_status_to_validate_go, Event
            
        endif else begin
        
;change switch button to NO (no geometry file has been defined)
            instrument_geometry_button_id = widget_info(event.top, find_by_uname='instrument_geometry_list_group')
            widget_control, instrument_geometry_button_id, set_value=1

            text = ' Data Reduction will use the default geometry file.'
            output_into_text_box, event, 'log_book_text', text
                
        endelse
        
        (*global).instrument_geometry = 'yes'
        
    endif else begin
        
        text = ' Data Reduction will use the default geometry file.'
        output_into_text_box, event, 'log_book_text', text
        
        (*global).instrument_geometry = 'no'
        
    endelse
    
    first_time_entering_procedure = 1

endif else begin

    first_time_entering_procedure = 0

endelse

(*global).first_time_entering_procedure = first_time_entering_procedure 

if ((*global).instrument EQ 'REF_M') then begin

    instrument_geometry_base_id = widget_info(event.top,find_by_uname='instrument_geometry_base')
    widget_control, instrument_geometry_base_id, map=0

endif

end




pro  instrument_geometry_button_event, Event

instrument_geometry_base_id = widget_info(event.top,find_by_uname='instrument_geometry_base')
widget_control, instrument_geometry_base_id, map=1

end



pro tmp_plot_button_event, Event


;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

plot_file_name = '~/local/REF_L/REF_L_2854.txt'
draw_uname = 'data_reduction_plot'
title= 'try'
plot_reduction_combine, Event, plot_file_name, draw_uname, title

end





pro  combine_settings_button_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

combine_settings_base_id = widget_info(event.top,find_by_uname='combine_settings_base')
widget_control, combine_settings_base_id, map=1

end




pro combine_settings_validate_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

minus_inf_id = widget_info(event.top,find_by_uname='combine_settings_minus_infinity_value')
plus_inf_id = widget_info(event.top,find_by_uname='combine_infinity_plus_infinity_value')
nan_id = widget_info(event.top,find_by_uname='combine_infinity_nan_value')

widget_control, minus_inf_id, get_value=minus_inf
widget_control, plus_inf_id, get_value=plus_inf
widget_control, nan_id, get_value=nan_user

(*global).minus_inf = minus_inf
(*global).plus_inf = plus_inf
(*global).nan_user = nan_user

combine_settings_base_id = widget_info(event.top,find_by_uname='combine_settings_base')
widget_control, combine_settings_base_id, map=0

end





pro zoom_button_event, Event

draw_id = widget_info(Event.top, find_by_uname='data_reduction_plot')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

text = 'Right click to exit ZOOM'
output_into_text_box, event, 'info_text', text
zoom, /new_window, fact=2, xsize=405, ysize=393, /continuous

end



pro erase_reduction_plot, event, draw_uname

draw_id = widget_info(Event.top, find_by_uname=draw_uname)
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id
erase

end





pro loadct_button_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;xloadct,/MODAL,GROUP=id
xloadct,/modal,group=id

plot_file_name = (*global).main_output_file_name
draw_uname = 'data_reduction_plot'
title =' '
plot_reduction_combine, Event, plot_file_name, draw_uname, title

end



pro reset_data_reduction_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).reset_data_reduction = 1
plot_file_name = (*global).main_output_file_name
draw_uname = 'data_reduction_plot'
title =' '
plot_reduction_combine, Event, plot_file_name, draw_uname, title

end
