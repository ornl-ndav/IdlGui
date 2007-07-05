;load file button in step 1
PRO LOAD_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

LongFileName=OPEN_FILE(Event) ;launch the program that open the OPEN IDL FILE Window

;continue only if a file has been selected
if (LongfileName NE '') then begin
   ;get only the file name (without path) of file
   ShortFileName = get_file_name_only(LongFileName)    
   ;add file to list of droplist (step1,step2 and 3)
   add_new_file_to_droplist, Event, ShortFileName, LongFileName 
   display_info_about_selected_file, Event, LongFileName
   plot_loaded_file, Event, LongFileName
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

;select color of plot in step 1
PRO REFRESH_PLOT_BUTTON, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

AssignColorToSelectedPlot,Event
ListLongFileName = (*(*global).ListOfLongFileName)
plot_loaded_file, Event, ListLongFileName
end

;droplist of files in step 1
PRO DISPLAY_INFO_ABOUT_FILE, Event
;get the long name of the selected file
LongFileName = getLongFileNameSelected(Event)
display_info_about_selected_file, Event, LongFileName
end

;run calculation of CE in step 2
PRO RUN_STEP2, Event
SaveQofCE,Event
end

;base file droplist in step 3
PRO STEP3_BASE_FILE_DROPLIST, Event
print, "in step3_base_file_droplist"
end

;work on file droplist in step 3
PRO STEP3_WORK_ON_FILE_DROPLIST, Event
print, "in step3_work_on_file_droplist"
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




