PRO REFreduction_LoadDatafile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get Data Run Number from DataTextField
DataRunNumber = getTextFieldValue(Event,'load_data_run_number_text_field')
LogBookText = '-> Openning Run Number: ' + DataRunNumber + '...'
putLogBookMessage, Event, LogBookText, 0
putDataLogBookMessage, Event, LogBookText, 0

if (DataRunNumber EQ '') then begin ;Run number field is empty



endif else begin

;indicate reading data with hourglass icon
    widget_control,/hourglass

    LogBookText = '----> Checking if NeXus run number exist....'
    putLogBookMessage, Event, LogBookText,1

;check if nexus exist and if it does, returns the full path
        
;get path to nexus run #
    instrument=(*global).instrument ;retrieve name of instrument
    isNeXusFound = 0 ;by default, NeXus not found
    full_nexus_name = find_full_nexus_name(Event,$
                                           DataRunNumber,$
                                           instrument,$
                                           isNeXusFound)
    
    if (~isNeXusFound) then begin ;NeXus has not been found

        LogBookText = getLogBookText(Event)
        help, LogBookText

    endif else begin ;NeXus has been found


    endelse


stop
    





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


END
