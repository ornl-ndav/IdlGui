;load file button in step 1
PRO LOAD_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file=OPEN_FILE(Event) ;launch the program that open the OPEN IDL FILE Window
ShortFileName = get_file_name_only(file)
add_new_file_to_droplist, Event, ShortFileName

end



;clear file button in step 1
PRO CLEAR_FILE, Event
print, "in clear file"
end

;select color of plot in step 1
PRO CHANGE_COLOR_OF_PLOT, Event
print, "in change color of plot"
end

;droplist in step 1
PRO DISPLAY_INFO_ABOUT_FILE, Event
print, "in display_info_about_file"
end

;run calculation of CE in step 2
PRO RUN_STEP2, Event
print, "in run step2"
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





pro REFL_SUPPORT_EVENTCB
end

pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end


