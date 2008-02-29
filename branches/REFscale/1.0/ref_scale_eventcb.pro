

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


;Cancel Load button
PRO ReflSupportEventcb_CancelLoadButton, Event 
  dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
  widget_control, dMDAngleBaseId, map=0
END


;When OK is pressed in dMDAngle base (to load a input file)
PRO ReflSupportEventcb_OkLoadButton, Event 
     ReflSupportOpenFile_LoadFile, Event       
END



;droplist of files in step 1
PRO DISPLAY_INFO_ABOUT_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get the long name of the selected file
LongFileName = getLongFileNameSelected(Event,'list_of_files_droplist')
  if (LongFileName EQ '') then begin
      clear_info_about_selected_file, Event
      ActivateClearFileButton, Event, 0
      ClearColorLabel, Event
      ActivateColorSlider,Event,0
  endif else begin
      display_info_about_selected_file, Event, LongFileName
      populateColorLabel, Event, LongFileName
      ActivateColorSlider,Event,1
      angleValue = getAngleValue(Event)
      displayAngleValue, Event, angleValue
  endelse
END


;when using automatic fitting of CE (step2)
PRO RUN_automatic_fitting, Event
ReflSupportStep2_fitCE, Event
END

;when using automatic scaling of CE (step2)
PRO run_automatic_scaling, Event
ReflSupportStep2_scaleCE, Event
END

;when using automatic fitting and scaling of CE (step2)
PRO run_full_step2, Event
run_automatic_fitting, Event

;show the scalling factor (but do not replot it)
;get the average Y value before
Ybefore = getTextFieldValue(Event, 'step2_y_before_text_field')
Yafter  = getTextFieldValue(Event, 'step2_y_after_text_field')

;check if Ybefore is numeric or not
YbeforeIsNumeric = isNumeric(Ybefore)
YafterIsNumeric  = isNumeric(Yafter)

;Ybefore and Yafter are numeric
if (YbeforeIsNumeric EQ 1 AND $
    YafterIsNumeric EQ 1) then begin

   putValueInLabel, Event, 'step2_q1q1_error_label', ''
   run_automatic_scaling, Event

endif else begin ;scaling factor can be calculated so second step (scaling) 
;automatic mode can be performed.

;display message in Q1 and Q2 boxe saying that auto stopped

putValueInLabel, Event, 'step2_q1q1_error_label', '**ERROR: Select another range of Qs**'

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


;work on file droplist in step 3
PRO STEP3_WORK_ON_FILE_DROPLIST, Event
steps_tab, Event, 1
end


;reset full session
PRO RESET_ALL_BUTTON, Event
;reset all arrays
ResetArrays, Event            ;reset all arrays
ReinitializeColorArray, Event
ClearAllDropLists, Event      ;clear all droplists
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
;Reset nbr of files loaded
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
(*global).NbrFilesLoaded = 0
END


;validate the rescalling parameters
PRO ValidateButton, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
(*global).replot_me = 1
;DoPlot,Event
END


;reset X and Y axis rescalling
PRO ResetRescaleButton, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;repopulate Xmin, Xmax, Ymin and Ymax with first XYMinMax values
putXYMinMax, Event, (*(*global).XYMinMax)
DoPlot, Event
END


;TOF or Q buttons
PRO InputFileFormat, Event
;; ValidateButton = getButtonValidated(Event,'InputFileFormat')
;; if (ValidateButton EQ 0) then begin ;TOF
;;     Validate = 1
;; endif else begin ;Q
;;     Validate = 0
;; endelse
;; ModeratorDetectorDistanceBaseId = $
;;   widget_info(Event.top,find_by_uname='ModeratorDetectorDistanceBase')
;; widget_control, ModeratorDetectorDistanceBaseId, map=Validate
;; checkLoadButtonStatus, Event
END


PRO replot_main_plot, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
if (((*global).replot_me) EQ 1) then begin
    steps_tab, Event,1
    (*global).replot_me = 0
endif
end


PRO rescale_data_changed, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
(*global).replot_me = 1
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





