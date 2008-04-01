;-------------------------------------------------------------------------------
;***** GENERAL FUNCTION ********************************************************
;-------------------------------------------------------------------------------
;This procedure is reached by : - when a new tab is reached 
;                               - by the refresh plot button

PRO steps_tab, Event, isRefresh
;Retrieve Global variable
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PrevTabSelect = (*global).PrevTabSelect ;previous tab selected
steps_tab_id  = widget_info(Event.top, find_by_uname='steps_tab')
CurrTabSelect = widget_info(steps_tab_id,/tab_current) ;current tab selected

;do the rest of the stuff only if there is at least one file loaded
list_of_files       = (*(*global).list_of_files)
list_of_files_size  = (size(list_of_files))(1)

IF (getNbrOfFiles(Event) GT 0) THEN BEGIN
   
;do something only if it's a new tab or refresh button has been clicked
   IF ((PrevTabSelect NE CurrTabSelect) OR (isRefresh EQ 1)) THEN BEGIN          

      (*global).PrevTabSelect = CurrTabSelect

      CASE (CurrTabSelect) OF

         0: BEGIN               ;if first tab plot everything

            AssignColorToSelectedPlot,Event ;_Gui
            plot_loaded_file, Event, 'all' ;_Plot
            angleValue = getAngleValue(Event) ;_get
            displayAngleValue, Event, angleValue ;_Gui
        END

         1: BEGIN               ;if second tab plot only CE plot
            plot_loaded_file, Event, 'CE' ;_Plot
;recalculate Qs
            saveQxFromQ, Event, Q_NUMBER=1
            saveQxFromQ, Event, Q_NUMBER=2
;plot the Qmin and Qmax if any have been selected
            plotQs, Event, (*global).Q1x, (*global).Q2x ;_Plot
        END

         2: BEGIN ;if third tab plot only the file selected
             
;;get nbr of files loaded and activate gui accordingly
;also, be sure that the step2 has been run with success
             IF (getNbrOfFiles(Event) GT 1 AND $
                 CheckStep2Status(Event)) THEN BEGIN ;enable step3
                 validate_status = 1
             ENDIF ELSE BEGIN
                 validate_status = 0
             ENDELSE
             ActivateStep3, Event, validate_status
             ActivateButton, Event, 'Step3_automatic_rescale_button', validate_status
 ;activate or not AUTOMATIC SCALLING

            indexSelected = $
              getSelectedIndex(Event,'step3_work_on_file_droplist') ;_get
                                ;no interaction is possible on the CE file
            IF (indexSelected EQ 0) THEN BEGIN
                Step3DisableManualScalingBox, Event ;_Step3
            ENDIF ELSE BEGIN
                Step3EnableManualScalingBox, Event ;_Step3
            ENDELSE
             
             plot_loaded_file, Event, '2plots' ;_Plot

                                ;this function will disable the
                                ;editable boxes if first file selected
            ManageStep3Tab, Event  ;_Step3

                                ;This function displays the base file
                                ;name unless the first file is
                                ;selected, in this case, it shows that
                                ;the working file is the CE file
            Step3DisplayLowQFileName, Event, indexSelected ;_Step3
            
                                ;display the SF of the selected file
            Step3_display_SF_values, Event, indexSelected ;_Step3

         END

         ELSE:                  ;if fourth tab (settings tab) is selected

      ENDCASE

   ENDIF

ENDIF

END

