PRO MAIN_BASE_event, Event

;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  wWidget =  Event.top          ;widget id
  
  CASE (Event.id) OF
      
      Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
      end
      
;-------------------------------------------------------------------------------
;***** GENERAL FUNCTION ********************************************************
;-------------------------------------------------------------------------------
      
;Event of the main widget_tab
      Widget_Info(wWidget, FIND_BY_UNAME='steps_tab'): begin
          steps_tab, Event, 0  ;_Tabs
      end
      
;-------------------------------------------------------------------------------    
;***** MAIN BASE GUI ***********************************************************
;-------------------------------------------------------------------------------
      
;Event of <RESET_FULL_SESSION> button
      Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button'): begin
          reset_all_button, Event ;_event
      end
      
;Event of <REFRESH PLOTS> button
      Widget_Info(wWidget, FIND_BY_UNAME='refresh_plot_button'): begin
          steps_tab, Event, 1 ;_Tabs
      end
      
;Event of <OUTPUT FILE> button
      Widget_Info(wWidget, FIND_BY_UNAME='print_button'):begin
          ProduceOutputFile, Event ;_produce_output
      end
      
;Event of main Widget_draw
      Widget_Info(wWidget, FIND_BY_UNAME='plot_window'):begin
          replot_main_plot, Event ;_Plot
      end
      
;Event triggered by 'Reset X/Y'     
      Widget_Info(wWidget, FIND_BY_UNAME='ResetButton'): BEGIN
          ResetRescaleButton, Event ;_eventcb
       END

;-------------------------------------------------------------------------------
;***** STEP 1 - [LOAD FILES] ***************************************************
;-------------------------------------------------------------------------------
      
;Event of <Load File> button
      Widget_Info(wWidget, FIND_BY_UNAME='load_button'): begin
          LoadFileButton, Event ;_Load
      end
      
;Event of 'List of Files:' droplist
      Widget_Info(wWidget, FIND_BY_UNAME='list_of_files_droplist'): begin
          display_info_about_file, Event ;_Gui
      end
      
;Event of <Clear File>
      Widget_Info(wWidget, FIND_BY_UNAME='clear_button'): begin
          clear_file, Event ;_Load
      end
      
;-------------------------------------------------------------------------------
;****** STEP 1 / In the LOAD TOF base ******************************************
;-------------------------------------------------------------------------------
      
;Event of <CANCEL> button
      Widget_Info(wWidget, FIND_BY_UNAME='cancel_load_button'): begin
          CancelTOFLoadButton, Event ;_Load
      end
      
;Event of <OK> button
      Widget_Info(wWidget, FIND_BY_UNAME='ok_load_button'): begin
          OkLoadButton, Event ;_Load
      end
      
;Event of the 'Distance Moderator-Detector (m):' widget_text
      Widget_Info(wWidget, FIND_BY_UNAME= $
                  'ModeratorDetectorDistanceTextField'): begin
          CheckOpenButtonStatus, Event ;_Gui
      end
      
;Event of the 'Polar angle:' text_field
      Widget_Info(wWidget, FIND_BY_UNAME='AngleTextField'): begin
          CheckOpenButtonStatus, Event ;_Gui
      end
      
;-------------------------------------------------------------------------------
;***** STEP 2 - [DEFINE CRITICAL EDGE FILE] ************************************
;-------------------------------------------------------------------------------
      
;Event triggered by <Automatic Fitting/Rescaling of CE>     
      Widget_Info(wWidget, FIND_BY_UNAME='Step2_button'): begin
          run_full_step2, Event
      end
      
;Event triggered by <Automatic Fitting>
      Widget_Info(wWidget, FIND_BY_UNAME='step2_automatic_fitting_button'): begin
          run_automatic_fitting, Event
      end
      
;Event triggered by <Automatic Scaling>
      Widget_Info(wWidget, FIND_BY_UNAME='step2_automatic_scaling_button'): begin
          run_automatic_scaling, Event
      end
      
;Event triggered by <Manual Fitting of CE>
      Widget_Info(wWidget, FIND_BY_UNAME='step2ManualGoButton'): begin
          manualCEfitting, Event
      end
      
;Event triggered by <Manual Scaling of CE>
      Widget_Info(wWidget, FIND_BY_UNAME='step2_manual_scaling_button'): begin
          manualCEscaling, Event
      end
      
;-------------------------------------------------------------------------------
;***** STEP 3 - [RESCALE FILES] ************************************************
;-------------------------------------------------------------------------------
      
;Event triggered by widget_droplist
      Widget_Info(wWidget, FIND_BY_UNAME='step3_work_on_file_droplist'): begin
          step3_work_on_file_droplist, Event
      end
      
;Event triggered by [Automatic rescaling]
      Widget_Info(wWidget, FIND_BY_UNAME='Step3_automatic_rescale_button'): begin
          ReflSupportStep3_AutomaticRescaling, Event
      end
      
;Event triggered by [+++]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_3increase_button'): begin
          ReflSupportStep3_RescaleFile, Event, 0.5
      end
      
;Event triggered by [++]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_2increase_button'): begin
          ReflSupportStep3_RescaleFile, Event, 0.1
      end
      
;Event triggered by [+]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_1increase_button'): begin
          ReflSupportStep3_RescaleFile, Event, 0.01
      end
      
;Event triggered by [---]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_3decrease_button'): begin
          ReflSupportStep3_RescaleFile, Event, -0.5
      end
      
;Event triggered by [--]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_2decrease_button'): begin
          ReflSupportStep3_RescaleFile, Event, -0.1
      end
      
;Event triggered by [-]
      Widget_Info(wWidget, FIND_BY_UNAME='step3_1decrease_button'): begin
          ReflSupportStep3_RescaleFile, Event, -0.01
      end
     
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

