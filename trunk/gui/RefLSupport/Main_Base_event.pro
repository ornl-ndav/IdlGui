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
     
;--step1--

     ;when LOADING a new file
     Widget_Info(wWidget, FIND_BY_UNAME='load_button'): begin
         ReflSupportOpenFile_LoadFile, Event       
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
        checkLoadButtonStatus, Event
     end
     
                                ;when angle text field is edited
     Widget_Info(wWidget, FIND_BY_UNAME='AngleTextField'): begin
        checkLoadButtonStatus, Event
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
       
                                ;--step3--
     Widget_Info(wWidget, FIND_BY_UNAME='step3_work_on_file_droplist'): begin
        step3_work_on_file_droplist, Event
     end
     
     Widget_Info(wWidget, FIND_BY_UNAME='Step3_button'): begin
        run_step3, Event
     end
     
                                ;--reset all button
     Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button'): begin
        reset_all_button, Event
     end
     
                                ;--refresh plots
     Widget_Info(wWidget, FIND_BY_UNAME='refresh_plot_button'): begin
        steps_tab, Event, 1
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
     
else:
  endcase
  
END
