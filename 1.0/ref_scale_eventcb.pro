;###############################################################################
;*******************************************************************************

;reset full session
PRO reset_all_button, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;reset all arrays
ResetArrays, Event ;_utility
ReinitializeColorArray, Event   ;_utility
ClearAllDropLists, Event        ;_Gui
ClearAllTextBoxes, Event        ;_Gui
ClearFileInfoStep1, Event       ;_Gui
ClearMainPlot, Event            ;_Gui
ResetPositionOfSlider, Event    ;_Gui
ResetAllOtherParameters, Event
ResetRescaleBase,Event
ActivateRescaleBase, Event, 0
ActivateClearFileButton, Event, 0
ClearColorLabel, Event          ;_Gui
ClearCElabelStep2, Event        ;_Gui
ClearStep2GlobalVariable, Event ;_Step2
ActivatePrintFileButton, Event, 0
(*global).NbrFilesLoaded = 0 ;Reset nbr of files loaded
ActivateStep2, Event, 0 ;_Gui, desactivate base of step2
ActivateStep3, Event, 0 ;_Gui, desactivate base of step3
ActivateOutputFileTab, Event, 0 ;_Gui, desactivate Output File tab
END

;###############################################################################
;*******************************************************************************

PRO rescale_data_changed, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,GET_UVALUE=global
(*global).replot_me  = 1
(*global).replotQnew = 1 ;means we need to replot the Qs
END

;###############################################################################
;*******************************************************************************

;reset X and Y axis rescalling
PRO ResetRescaleButton, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;repopulate Xmin, Xmax, Ymin and Ymax with first XYMinMax values
putXYMinMax, Event, (*(*global).XYMinMax) ;_put
DoPlot, Event
END

;###############################################################################
;*******************************************************************************

;This function reinitialize the Rescale base
PRO ResetRescaleBase,Event
;reset X and Y, Min and Max text fields
XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
XYMinMax = [XminId, XmaxId, YminId, YmaxId]
for i=0,3 do begin
   widget_control, XYMinMax[i], set_value=''
endfor
;reset Y lin/log
YaxisLinLogId = widget_info(Event.top,find_by_uname='YaxisLinLog')
widget_control, YaxisLinLogId, set_value=0
END

;###############################################################################
;*******************************************************************************

PRO REF_SCALE_EVENTCB
END

;###############################################################################
;*******************************************************************************

PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

;###############################################################################
;*******************************************************************************





