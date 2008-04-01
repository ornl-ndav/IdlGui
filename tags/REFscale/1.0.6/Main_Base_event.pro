PRO MAIN_BASE_event, Event

;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  wWidget =  Event.top          ;widget id
  
  CASE (Event.id) OF
      
      Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
      END
      
;-------------------------------------------------------------------------------
;***** GENERAL FUNCTION ********************************************************
;-------------------------------------------------------------------------------
      
;Event of the main widget_tab
      Widget_Info(wWidget, FIND_BY_UNAME='steps_tab'): BEGIN
          steps_tab, Event, 0  ;_Tabs
      END

;Main Plot Drawing Window
      Widget_Info(wWidget, FIND_BY_UNAME='plot_window'): BEGIN
          IF (getNbrOfFiles(Event) GT 0) THEN BEGIN
              steps_tab_id  = widget_info(Event.top, find_by_uname='steps_tab')
;current tab selected
              CurrTabSelect = widget_info(steps_tab_id,/tab_current) 
              CASE (CurrTabSelect) OF 
                  1: BEGIN
;only for CE tab (step2) AND only if more than 1 file
                      IF (getTabSelected(Event) EQ 1 AND $ 
                          getNbrOfFiles(Event) GE 1) THEN BEGIN 
                          XMinMax = getDrawXMin(Event)
                          CASE (Event.type) OF
                              0 : BEGIN
                                  CASE (Event.press) OF ;left or right click
                                      1 : Step2LeftClick, Event, XMinMax ;left click
                                      4 : Step2RightClick, Event ;right click
                                      ELSE:
                                  ENDCASE
                              END
                              1 : Step2ReleaseClick, Event, XMinMax ;button released
                              2 : Step2MoveClick, Event, XMinMax ;mouse is moving
                              ELSE:
                          ENDCASE
                      ENDIF
                  END
                  ELSE: replot_main_plot, Event ;_Plot
              ENDCASE
          ENDIF ;end of if(getNbrOfFiles(Event))
      END
      
;------------------------------------------------------------------------------- 
;***** MAIN BASE GUI ***********************************************************
;-------------------------------------------------------------------------------
      
;Event of <RESET_FULL_SESSION> button
      Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button'): BEGIN
          reset_all_button, Event ;_event
      END
      
;Event of <REFRESH PLOTS> button
      Widget_Info(wWidget, FIND_BY_UNAME='refresh_plot_button'): BEGIN
          steps_tab, Event, 1 ;_Tabs
      END
      
;Event of <OUTPUT FILE> button
      Widget_Info(wWidget, FIND_BY_UNAME='print_button'):BEGIN
          ProduceOutputFile, Event ;_produce_output
      END
      
;Event triggered by 'Reset X/Y'     
      Widget_Info(wWidget, FIND_BY_UNAME='ResetButton'): BEGIN
          ResetRescaleButton, Event ;_eventcb
       END

;-------------------------------------------------------------------------------
;***** STEP 1 - [LOAD FILES] ***************************************************
;-------------------------------------------------------------------------------
      
;Event of <Load File> button
      Widget_Info(wWidget, FIND_BY_UNAME='load_button'): BEGIN
          LoadFileButton, Event ;_Load
      END
      
;Event of 'List of Files:' droplist
      Widget_Info(wWidget, FIND_BY_UNAME='list_of_files_droplist'): BEGIN
          display_info_about_file, Event ;_Gui
      END
      
;Event of <Clear File>
      Widget_Info(wWidget, FIND_BY_UNAME='clear_button'): BEGIN
          clear_file, Event ;_Load
      END
      
;-------------------------------------------------------------------------------
;****** STEP 1 / In the LOAD TOF base ******************************************
;-------------------------------------------------------------------------------
      
;Event of <CANCEL> button
      Widget_Info(wWidget, FIND_BY_UNAME='cancel_load_button'): BEGIN
          CancelTOFLoadButton, Event ;_Load
      END
      
;Event of <OK> button
      Widget_Info(wWidget, FIND_BY_UNAME='ok_load_button'): BEGIN
          OkLoadButton, Event ;_Load
      END
      
;Event of the 'Distance Moderator-Detector (m):' widget_text
      Widget_Info(wWidget, FIND_BY_UNAME= $
                  'ModeratorDetectorDistanceTextField'): BEGIN
          CheckOpenButtonStatus, Event ;_Gui
      END
      
;Event of the 'Polar angle:' text_field
      Widget_Info(wWidget, FIND_BY_UNAME='AngleTextField'): BEGIN
          CheckOpenButtonStatus, Event ;_Gui
      END
      
;-------------------------------------------------------------------------------
;***** STEP 2 - [DEFINE CRITICAL EDGE FILE] ************************************
;-------------------------------------------------------------------------------
      
;Event triggered by <Automatic Fitting/Rescaling of CE>     
      Widget_Info(wWidget, FIND_BY_UNAME='step2_button'): BEGIN
          run_full_step2, Event ;_Step2
      END
      
;Event triggered by <Manual Scaling of CE>
      Widget_Info(wWidget, FIND_BY_UNAME='step2_manual_scaling_button'): BEGIN
          manualCEscaling, Event ;_Step2
      END

;Event trigerred when editing the SF text field
      Widget_Info(wWidget, FIND_BY_UNAME='step2_sf_text_field'): BEGIN
          manual_sf_editing, Event ;_Step2
      END      
      
;Event trigerred by Qmin cw_field
      Widget_Info(wWidget, FIND_BY_UNAME='step2_q1_text_field'): BEGIN
          ManualNewQ, Event ;_Step2
      END      
      
;Event trigerred by Qmin cw_field
      Widget_Info(wWidget, FIND_BY_UNAME='step2_q2_text_field'): BEGIN
          ManualNewQ, Event ;_Step2
      END      
      
;-------------------------------------------------------------------------------
;***** STEP 3 - [RESCALE FILES] ************************************************
;-------------------------------------------------------------------------------
      
;Event triggered by widget_droplist
      Widget_Info(wWidget, FIND_BY_UNAME='step3_work_on_file_droplist'): BEGIN
          steps_tab, Event, 1   ;_Tab
      END
      
;Event triggered by [Automatic rescaling]
      Widget_Info(wWidget, FIND_BY_UNAME='Step3_automatic_rescale_button'): BEGIN
          Step3AutomaticRescaling, Event ;_Step3
      END

;Event trigerred by the CW_FIELD SF rescaling
      Widget_Info(wWidget, FIND_BY_UNAME='Step3SFTextField'): BEGIN
          step = FLOAT(getTextFieldValue(Event,'Step3SFTextField'))
          Step3RescaleFile2, Event, step ;_Step3
      END      
      
;Event triggered by [+++]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_3increase_button'): BEGIN
          Step3RescaleFile, Event, 0.5 ;_Step3
      END
      
;Event triggered by [++]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_2increase_button'): BEGIN
          Step3RescaleFile, Event, 0.1 ;_Step3
      END
      
;Event triggered by [+]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_1increase_button'): BEGIN
          Step3RescaleFile, Event, 0.01 ;_Step3
      END
      
;Event triggered by [---]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_3decrease_button'): BEGIN
          Step3RescaleFile, Event, -0.5 ;_Step3
      END
      
;Event triggered by [--]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_2decrease_button'): BEGIN
          Step3RescaleFile, Event, -0.1 ;_Step3
      END
      
;Event triggered by [-]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_1decrease_button'): BEGIN
          Step3RescaleFile, Event, -0.01 ;_Step3
      END
     
ELSE:
  ENDCASE
  
;Event triggered by 'X-axis  min:' widget_text
  SWITCH (Event.id) OF
;Event triggered by 'X-axis  min:' widget_text
      Widget_Info(wWidget, FIND_BY_UNAME='XaxisMinTextField'): 
;Event triggered by 'X-axis  max:' widget_text
      Widget_Info(wWidget, FIND_BY_UNAME='XaxisMaxTextField'): 
;Event of lin or log switch of X axis
      Widget_Info(wWidget, FIND_BY_UNAME='XaxisLinLog'):
;Event triggered by 'Y-axis  min:' widget_text
      Widget_Info(wWidget, FIND_BY_UNAME='YaxisMinTextField'): 
;Event triggered by 'Y-axis  max:' widget_text
      Widget_Info(wWidget, FIND_BY_UNAME='YaxisMaxTextField'): 
;Event of lin or log switch of Y axis
      Widget_Info(wWidget, FIND_BY_UNAME='YaxisLinLog'): BEGIN
          rescale_data_changed, Event ;_eventcb
      END
      ELSE:
  ENDSWITCH
  
END

