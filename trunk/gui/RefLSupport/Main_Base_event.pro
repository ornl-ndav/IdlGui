PRO MAIN_BASE_event, Event

;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  wWidget =  Event.top          ;widget id
  
  case Event.id of
     
     Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
     end
     
     Widget_Info(wWidget, FIND_BY_UNAME='steps_tab'): begin
        steps_tab, Event, 0
     end
     
                                ;--reset all button
     Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button'): begin
        reset_all_button, Event
     end
     
                                ;--refresh plots
     Widget_Info(wWidget, FIND_BY_UNAME='refresh_plot_button'): begin
        steps_tab, Event, 1
     end

     Widget_Info(wWidget, FIND_BY_UNAME='print_button'):begin
        ReflSupport_ProduceOutputFile, Event
     end

     Widget_Info(wWidget, FIND_BY_UNAME='plot_window'):begin
        replot_main_plot, Event
     end
     
     ;XaxisLinLog
     Widget_Info(wWidget, FIND_BY_UNAME='XaxisLinLog'):begin
        rescale_data_changed, Event
     end
     
     ;YaxisLinLog
     Widget_Info(wWidget, FIND_BY_UNAME='YaxisLinLog'):begin
        rescale_data_changed, Event
     end

;--step1--

     ;when LOADING a new file
     Widget_Info(wWidget, FIND_BY_UNAME='load_button'): begin
        ReflSupportEventcb_LoadFileButton, Event 
     end

;in dMDAngle base, cancel button
     Widget_Info(wWidget, FIND_BY_UNAME='cancel_load_button'): begin
        ReflSupportEventcb_CancelLoadButton, Event 
     end

     Widget_Info(wWidget, FIND_BY_UNAME='ok_load_button'): begin
        ReflSupportEventcb_OkLoadButton, Event 
     end

     Widget_Info(wWidget, FIND_BY_UNAME='list_of_files_droplist'): begin
        display_info_about_file, Event
     end
     
     Widget_Info(wWidget, FIND_BY_UNAME='clear_button'): begin
        clear_file, Event
     end
     
     Widget_Info(wWidget, FIND_BY_UNAME='InputFileFormat'): begin
        InputFileFormat, Event
     end
     
                                ;when distance text field is edited
     Widget_Info(wWidget, FIND_BY_UNAME='ModeratorDetectorDistanceTextField'): begin
             ReflSupportWidget_checkOpenButtonStatus, Event 
     end
     
                                ;when angle text field is edited
     Widget_Info(wWidget, FIND_BY_UNAME='AngleTextField'): begin
             ReflSupportWidget_checkOpenButtonStatus, Event 
     end
     
                                ;--step2--
     Widget_Info(wWidget, FIND_BY_UNAME='base_file_droplist'): begin
        step2_base_file_droplist, Event
     end
     
     Widget_Info(wWidget, FIND_BY_UNAME='Step2_button'): begin
        run_full_step2, Event
     end
     
     ;automatic fitting of CE
     Widget_Info(wWidget, FIND_BY_UNAME='step2_automatic_fitting_button'): begin
         run_automatic_fitting, Event
     end
     
     ;automatic scaling of CE
     Widget_Info(wWidget, FIND_BY_UNAME='step2_automatic_scaling_button'): begin
         run_automatic_scaling, Event
     end

     ;manual fitting of CE file
     Widget_Info(wWidget, FIND_BY_UNAME='step2ManualGoButton'): begin
         manualCEfitting, Event
     end
       

;--step 3--
     Widget_Info(wWidget, FIND_BY_UNAME='step3_work_on_file_droplist'): begin
        step3_work_on_file_droplist, Event
     end
     
     Widget_Info(wWidget, FIND_BY_UNAME='Step3_button'): begin
        run_step3, Event
     end
     
     ;changing min value of yaxis
     Widget_Info(wWidget, FIND_BY_UNAME='YaxisMinTextField'): begin
        rescale_data_changed, Event
     end
     
     ;changing max value of yaxis
     Widget_Info(wWidget, FIND_BY_UNAME='YaxisMaxTextField'): begin
        rescale_data_changed, Event
     end

     ;changing min value of xaxis
     Widget_Info(wWidget, FIND_BY_UNAME='XaxisMinTextField'): begin
        rescale_data_changed, Event
     end

     ;changing max value of xaxis
     Widget_Info(wWidget, FIND_BY_UNAME='XaxisMaxTextField'): begin
        rescale_data_changed, Event
     end
                                     
                                ;--validate rescale
     Widget_Info(wWidget, FIND_BY_UNAME='ValidateButton'): begin
        ValidateButton, Event
     end
     
                                ;--reset X and Y rescale button
     Widget_Info(wWidget, FIND_BY_UNAME='ResetButton'): begin
        ResetRescaleButton, Event
     end
     
                                ;replot ri and delta_ri
     widget_info(wWidget, FIND_BY_UNAME='step2_ri_draw'):begin
        ri_logo=$
           "/SNS/users/j35/SVN/HistoTool/trunk/gui/RefLSupport/ri.bmp"
        id = widget_info(wWidget,find_by_uname='step2_ri_draw')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        wset, id_value
        image = read_bmp(ri_logo)
        tv, image,-8,0,/true
     end

     ;launch the automatic rescaling of all loaded files
     Widget_Info(wWidget, FIND_BY_UNAME='Step3_automatic_rescale_button'): begin
        ReflSupportStep3_AutomaticRescaling, Event
     end

     ;SF += 0.5
     Widget_Info(wWidget, FIND_BY_UNAME='step3_3increase_button'): begin
         ReflSupportStep3_RescaleFile, Event, 0.5
     end

     ;SF += 0.1
     Widget_Info(wWidget, FIND_BY_UNAME='step3_2increase_button'): begin
         ReflSupportStep3_RescaleFile, Event, 0.1
     end

     ;SF += 0.01
     Widget_Info(wWidget, FIND_BY_UNAME='step3_1increase_button'): begin
         ReflSupportStep3_RescaleFile, Event, 0.01
     end

     ;SF -= 0.5
     Widget_Info(wWidget, FIND_BY_UNAME='step3_3decrease_button'): begin
         ReflSupportStep3_RescaleFile, Event, -0.5
     end
     
    ;SF -= 0.1
     Widget_Info(wWidget, FIND_BY_UNAME='step3_2decrease_button'): begin
         ReflSupportStep3_RescaleFile, Event, -0.1
     end
 
    ;SF -= 0.01
     Widget_Info(wWidget, FIND_BY_UNAME='step3_1decrease_button'): begin
         ReflSupportStep3_RescaleFile, Event, -0.01
     end
 





else:
  endcase
  
END
