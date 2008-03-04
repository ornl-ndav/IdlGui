





;This function displays the SF of the selected file
PRO ReflSupportStep3_display_SF_values, Event,index
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

SF_array = (*(*global).SF_array)

if (index NE 0) then begin
    SF = SF_array[index]
endif else begin
    SF = ''
endelse
ReflSupportWidget_setValue, Event, 'Step3SFTextField', SF
END





