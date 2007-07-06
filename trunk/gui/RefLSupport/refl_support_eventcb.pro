;procedure triggered each time a new tab is reached or refresh plot button
PRO steps_tab, Event, isRefresh
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PrevTabSelect = (*global).PrevTabSelect ;previous tab selected

steps_tab_id = widget_info(Event.top, find_by_uname='steps_tab')
CurrTabSelect = widget_info(steps_tab_id,/tab_current) ;current tab selected

if (PrevTabSelect NE CurrTabSelect OR $
    isRefresh EQ 1) then begin
    (*global).PrevTabSelect = CurrTabSelect
    CASE (CurrTabSelect) OF
        0: begin                    ;if first tab plot everything
            AssignColorToSelectedPlot,Event
            ListLongFileName = (*(*global).ListOfLongFileName)
            plot_loaded_file, Event, ListLongFileName
        end
        1: begin                ;if second tab plot only CE plot
            LongFileName = getLongFileNameSelected(Event,'base_file_droplist') 
            plot_loaded_file, Event,LongFileName
        end
        2: begin            ;if third tab plot only two files selected
            LongFileName1 = getLongFileNameSelected(Event,'step3_base_file_droplist')
            LongFileName2 = getLongFileNameSelected(Event,'step3_work_on_file_droplist')
            ListLongFileName = [LongFileName1,LongFileName2]
            plot_loaded_file, Event, ListLongFileName
        end
    ENDCASE
endif
END

;load file button in step 1
PRO LOAD_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

LongFileName=OPEN_FILE(Event) ;launch the program that open the OPEN IDL FILE Window

;continue only if a file has been selected
if (LongfileName NE '') then begin
   ;get only the file name (without path) of file
   ShortFileName = get_file_name_only(LongFileName)    
   ;add file to list of droplist (step1, step2 and 3)
   add_new_file_to_droplist, Event, ShortFileName, LongFileName 
   display_info_about_selected_file, Event, LongFileName
endif

;plot all loaded files
ListLongFileName = (*(*global).ListOfLongFileName)
plot_loaded_file, Event, ListLongFileName
end


;clear file button in step 1
PRO CLEAR_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get the selected index of the load list droplist
TextBoxIndex = getSelectedIndex(Event, 'list_of_files_droplist')
RemoveIndexFromArray, Event, TextBoxIndex

;update list displays in all droplists
ListOfFiles = (*(*global).list_of_files)
updateDropList, Event, ListOfFiles
end

;droplist of files in step 1
PRO DISPLAY_INFO_ABOUT_FILE, Event
;get the long name of the selected file
LongFileName = getLongFileNameSelected(Event,'list_of_files_droplist')
display_info_about_selected_file, Event, LongFileName
end

;run calculation of CE in step 2
PRO RUN_STEP2, Event
SaveQofCE,Event
end

;Ce file droplist in step 2
PRO step2_base_file_droplist, Event
steps_tab, Event, 1
end


;base file droplist in step 3
PRO STEP3_BASE_FILE_DROPLIST, Event
steps_tab, Event, 1
end

;work on file droplist in step 3
PRO STEP3_WORK_ON_FILE_DROPLIST, Event
steps_tab, Event, 1
end

;run calculation of base->work on in step 3
PRO RUN_STEP3, Event
  print, "in run_step3"
end

;reset full session
PRO RESET_ALL_BUTTON, Event
;reset all arrays
ResetArrays, Event       ;reset all arrays
ClearAllDropLists, Event ;clear all droplists
ClearAllTextBoxes, Event ;clear all textBoxes
ClearFileInfoStep1, Event ;clear contain of info file (Step1)
ClearMainPlot, Event     ;clear main plot window
END




pro REFL_SUPPORT_EVENTCB
end

pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end




