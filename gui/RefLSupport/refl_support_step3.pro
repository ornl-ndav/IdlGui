PRO ReflSupportStep3_AutomaticRescalin, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

END



;This function displays in the Qmin and Qmax text fields the 
;Qmin and Qmax of the CE file
PRO ReflSupportStep3_display_Q_values, Event,index

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)

ReflSupportWidget_setValue, Event, 'Step3ManualQMinTextField', Qmin_array[index]
ReflSupportWidget_setValue, Event, 'Step3ManualQMaxTextField', Qmax_array[index]

END


;This function displays the base file name unless the first file is
;selected, in this case, it shows that the working file is the CE file
PRO  ReflSupportStep3_displayLowQFileName, Event, indexSelected

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (indexSelected EQ 0) then begin
    textHighQ = 'C.E. file ->'
    textLowQ  = ''
    text      = ''
endif else begin
    textLowQ  = 'Low Q file:'
    textHighQ = 'High Q file:'
    list_of_files = (*(*global).list_of_files)
    text = list_of_files[indexSelected-1]
endelse
putValueInLabel, Event, 'Step3ManualModeLowQFileLabel',textLowQ
putValueInLabel, Event, 'Step3ManualModeHighQFileLabel',textHighQ
putValueInLabel, Event, 'Step3ManualModeLowQFileName',text
END

;This function is reached only when the CE file of step 3 has been
;selected in the droplist. In this case, all the widgets of the manual
;scalling box should be disable.
PRO ReflSupportStep3_DisableManualScalingBox, Event
ReflSupportWidget_enableStep3ManualScalingWidgets, Event, 0
END


;This function is reached only when the selected file in the step 3
;droplist is any of the file except the first one (CE file). In this
;case, all the widgets of the manual scalling box should be enabled.
PRO ReflSupportStep3_EnableManualScalingBox, Event
ReflSupportWidget_enableStep3ManualScalingWidgets, Event, 1
END
