;procedure triggered each time a new tab is reached or refresh plot button
PRO steps_tab, Event, isRefresh
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PrevTabSelect = (*global).PrevTabSelect ;previous tab selected
steps_tab_id = widget_info(Event.top, find_by_uname='steps_tab')
CurrTabSelect = widget_info(steps_tab_id,/tab_current) ;current tab selected

;do the rest of the stuff only if there is at least one file loaded
list_of_files = (*(*global).list_of_files)
list_of_files_size_array = size(list_of_files)
list_of_files_size = list_of_files_size_array[1]
if (list_of_files_size EQ 1 && $
    list_of_files[0] EQ '') then begin
;nothing to do, no file loaded
endif else begin 
   
   if (PrevTabSelect NE CurrTabSelect OR $
       isRefresh EQ 1) then begin
      (*global).PrevTabSelect = CurrTabSelect
      CASE (CurrTabSelect) OF
         0: begin               ;if first tab plot everything
            AssignColorToSelectedPlot,Event
            ListLongFileName = (*(*global).ListOfLongFileName)
            plot_loaded_file, Event, ListLongFileName
            angleValue = getAngleValue(Event)
            displayAngleValue, Event, angleValue
        end
         1: begin               ;if second tab plot only CE plot
            LongFileName = (*global).full_CE_name
            LongFileNameArray = strarr(1)
            LongFileNameArray[0]=LongFileName
            plot_loaded_file, Event,LongFileNameArray
            
                                ;display the Qmin and Qmax for the CE file
                                ;for now, the first file loaded is
                                ;considered as being the CE file
            ReflSupportWidget_display_Q_values, Event, 0, 2  

         end
         2: begin               ;if third tab plot only the file selected
            LongFileName1 = getLongFileNameSelected(Event,$
                                                    'step3_work_on_file_droplist')
            ListLongFileName = [LongFileName1]
            plot_loaded_file, Event, ListLongFileName

                                ;this function will disable the
                                ;editable boxes if first file selected
            ReflSupportWidget_ManageStep3Tab, Event 
                                
                                ;display the Qmin and Qmax for the CE file
                                ;for now, the first file loaded is
                                ;considered as being the CE file
            indexSelected = getSelectedIndex(Event,'step3_work_on_file_droplist')
            ReflSupportWidget_display_Q_values, Event, indexSelected, 3  
         end
         else:                  ;if fourth tab (settings tab) is selected
      ENDCASE
   endif
endelse

;if (PrevTabSelect NE CurrTabSelect OR $
;    isRefresh EQ 1) then begin
;    (*global).PrevTabSelect = CurrTabSelect
;    CASE (CurrTabSelect) OF
;        0: begin                ;if first tab plot everything
;        end
;        1: begin                ;if second tab plot only CE plot
            ReflSupportWidget_refresh_draw_labels_tab2, Event
;        end
;        2: begin            ;if third tab plot only two files selected
;            refresh_draw_labels_tab3, Event
;        end
;        else:
;    ENDCASE
;endif

END


;clear file button in step 1
PRO CLEAR_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get the selected index of the load
;list droplist
TextBoxIndex = getSelectedIndex(Event, 'list_of_files_droplist')
RemoveIndexFromArray, Event, TextBoxIndex
;update GUI
ListOfFiles = (*(*global).list_of_files)
updateGUI, Event, ListOfFiles
;plot all loaded files
ListLongFileName = (*(*global).ListOfLongFileName)
plot_loaded_file, Event, ListLongFileName
display_info_about_file, Event
angleValue = getAngleValue(Event)
displayAngleValue, Event, angleValue

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
run_automatic_scaling, Event
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


;run calculation of base->work on in step 3
PRO RUN_STEP3, Event
  print, "in run_step3"
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
END


;validate the rescalling parameters
PRO ValidateButton, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
DoPlot,Event
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
ValidateButton = getButtonValidated(Event,'InputFileFormat')
if (ValidateButton EQ 0) then begin ;TOF
    Validate = 1
endif else begin ;Q
    Validate = 0
endelse
ModeratorDetectorDistanceBaseId = $
  widget_info(Event.top,find_by_uname='ModeratorDetectorDistanceBase')
widget_control, ModeratorDetectorDistanceBaseId, map=Validate
checkLoadButtonStatus, Event
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





