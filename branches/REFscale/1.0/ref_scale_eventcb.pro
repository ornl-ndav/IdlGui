;###############################################################################
;*******************************************************************************

;reset full session
PRO reset_all_button, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;reset all arrays
ResetArrays, Event ;_utility
ReinitializeColorArray, Event ;_utility
ClearAllDropLists, Event   
ClearAllTextBoxes, Event      ;clear all textBoxes
ClearFileInfoStep1, Event     ;clear contain of info file (Step1)
ClearMainPlot, Event          ;clear main plot window
ResetPositionOfSlider, Event  ;reset color slider and previousColorIndex
ResetAllOtherParameters, Event
ResetRescaleBase,Event
ActivateRescaleBase, Event, 0
ActivateClearFileButton, Event, 0
ClearColorLabel, Event
ReflSupportWidget_ClearCElabelStep2, Event
ActivatePrintFileButton, Event, 0
(*global).NbrFilesLoaded = 0 ;Reset nbr of files loaded

END

;###############################################################################
;*******************************************************************************

PRO rescale_data_changed, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,GET_UVALUE=global
(*global).replot_me = 1
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












;Load a file button
PRO ReflSupportEventcb_LoadFileButton, Event 
                                ;check the status of the TOF or Q button
                                ;if Q, go directly to ReflSuppportOpenFile_Loadfile
                                ;if TOF, display TOF interactive box
 FormatFileSelected = getButtonValidated(Event,'InputFileFormat')   
  if (FormatFileSelected EQ 0) then begin ;TOF
         ;display the dMD and angle value base
     dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
     widget_control, dMDAngleBaseId, map=1
                                ;check status of ok_load button
     ReflSupportWidget_checkOpenButtonStatus, Event 
  endif else begin              ;Q
     ReflSupportOpenFile_LoadFile, Event
  endelse
END










;Ce file droplist in step 2
PRO step2_base_file_droplist, Event
steps_tab, Event, 1
END


;base file droplist in step 3
PRO STEP3_BASE_FILE_DROPLIST, Event
steps_tab, Event, 1
end






;validate the rescalling parameters
PRO ValidateButton, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
(*global).replot_me = 1
;DoPlot,Event
END












PRO REF_SCALE_EVENTCB
END


pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end





