pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
;portal_go
    
    Widget_Info(wWidget, FIND_BY_UNAME='USER_TEXT'): begin
        USER_TEXT_CB, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='PORTAL_GO'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          id=widget_info(Event.top,FIND_BY_UNAME='INSTRUMENT_TYPE_GROUP')
        WIDGET_control, id, GET_VALUE=instrument
        ucams = get_ucams()
        
        if (check_access(Event, instrument, ucams) NE -1) then begin
            id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
            WIDGET_CONTROL, id, /destroy
            if (instrument EQ 0) then begin
                wTLB, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_, instrument, ucams
            endif else begin
                wTLC, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_, instrument, ucams
            endelse
            
        endif else begin
            image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/DataReduction/access_denied.bmp"
            id = widget_info(wWidget,find_by_uname="logo_message_draw")
            WIDGET_CONTROL, id, GET_VALUE=id_value
            wset, id_value
            image = read_bmp(image_logo)
            tv, image,0,0,/true
        endelse
        
    end
    
    
;open nexus file button for REF_L
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number_go'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          open_nexus_file, Event
    end
    
;open nexus file button for REF_M
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number_go_REF_M'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          open_nexus_file, Event
    end

;open signal pid file
    Widget_Info(wWidget, FIND_BY_UNAME='signal_pid_file_button'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          open_pid_file, Event, "signal"
    end

;open back pid file
    Widget_Info(wWidget, FIND_BY_UNAME='background_pid_file_button'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          open_pid_file, Event, "background"
    end

;help on format input of runs to process
    Widget_Info(wWidget, FIND_BY_UNAME='runs_to_process_help'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          help_runs_to_process, Event
    end

;Exit widget in the top toolbar for REF_L
    Widget_Info(wWidget, FIND_BY_UNAME='EXIT_MENU_REF_L'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          EXIT_PROGRAM_REF_L, Event
    end
    
;Exit widget in the top toolbar for REF_M
    Widget_Info(wWidget, FIND_BY_UNAME='EXIT_MENU_REF_M'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          EXIT_PROGRAM_REF_M, Event
    end
    
;Widget to change the color of graph for REF_L and REF_M
    Widget_Info(wWidget, FIND_BY_UNAME='CTOOL_MENU'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          CTOOL, Event
    end
    
;signal or background selection zone for REF_L and REF_M
    widget_info(wWidget, FIND_BY_UNAME='selection_list_group'): begin
        selection_list_group_cb, Event
    end
    
;intermediate file output for REF_L
    Widget_Info(wWidget, FIND_BY_UNAME=''): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          save_selection_cb, Event
    end

;tracking events for intermediate file tabs of REF_L
    widget_info(wWidget, FIND_BY_UNAME='other_plots_tab'): begin
        other_plots_tab_cb, Event
    end

;tracking events for main tab
    widget_info(wWidget, FIND_BY_UNAME='data_reduction_tab'): begin
        data_reduction_tab_cb, Event
    end

;draw_interaction for REF_L
    Widget_Info(wWidget, FIND_BY_UNAME='display_data_base'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
          if( Event.type eq 0 )then $
          selection, Event
    end
;clear selection button for REF_L
    Widget_Info(wWidget, FIND_BY_UNAME='clear_selection_button'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          clear_selection_cb, Event
    end
    
;save selection button for REF_L
    Widget_Info(wWidget, FIND_BY_UNAME='save_selection_button'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          save_selection_cb, Event
    end
    
;INSIDE DATA_REDUCTION_WINDOW
;with or without background for REF_L
;    widget_info(wWidget, FIND_BY_UNAME='background_list_group'): begin
;        background_list_group_eventcb, Event
;    end

;with or without background for REF_M
;    widget_info(wWidget, FIND_BY_UNAME='background_list_group_REF_M'): begin
;        background_list_group_eventcb_REF_M, Event
;    end

;with or without normalization for REF_L
    widget_info(wWidget, FIND_BY_UNAME='normalization_list_group_REF_L'): begin
        normalization_list_group_eventcb_REF_L, Event
    end

;with or without normalization for REF_M
    widget_info(wWidget, FIND_BY_UNAME='normalization_list_group_REF_M'): begin
        normalization_list_group_eventcb_REF_M, Event
    end

;intermediate file output for REF_L (yes/no)
    widget_info(wWidget, FIND_BY_UNAME='intermediate_file_output_list_group'):begin
        intermediate_file_output_list_group_eventcb,Event
    end

;intermediate file output for REF_M (yes/no)
    widget_info(wWidget, FIND_BY_UNAME='intermediate_file_output_list_group_REF_M'):begin
        intermediate_file_output_list_group_eventcb_REF_M,Event
    end

;intermediate file output for REF_M
    widget_info(wWidget, FIND_BY_UNAME='access_to_list_of_intermediate_plots_button'):begin
        access_to_list_of_intermediate_plots_eventcb,Event
    end

;display list of intermediate plots
    Widget_Info(wWidget, FIND_BY_UNAME='access_to_list_of_intermediate_plots'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          access_to_list_of_intermediate_plots_eventcb, Event
    end

;validate list of intermediate file output for REF_L
    widget_info(wWidget, FIND_BY_UNAME='intermediate_plots_list_validate'):begin
        intermediate_plots_list_validate_eventcb,Event
    end

;validate list of intermediate file output for REF_M
    widget_info(wWidget, FIND_BY_UNAME='intermediate_plots_list_validate_REF_M'):begin
        intermediate_plots_list_validate_eventcb_REF_M,Event
    end

;cancel list of intermediate file output for REF_L
    widget_info(wWidget, Find_by_uname='intermediate_plots_list_cancel'):begin
        intermediate_plots_list_cancel_eventcb,Event
    end

;cancel list of intermediate file output for REF_M
    widget_info(wWidget, Find_by_uname='intermediate_plots_list_cancel_REF_M'):begin
        intermediate_plots_list_cancel_eventcb_REF_M,Event
    end

;start data reduction for REF_L and REF_M
    widget_info(wWidget, FIND_BY_UNAME='start_data_reduction_button'): begin
        start_data_reduction_button_eventcb, Event
    end

;normalization run number text box
    widget_info(wWidget, FIND_BY_UNAME='normalization_text'): begin
        normalization_text_eventcb, Event
    end

;wavelength min text box
    widget_info(wWidget, FIND_BY_UNAME='wavelength_min_text'): begin
        wavelength_min_text_eventcb, Event
    end

;wavelength max text box
    widget_info(wWidget, FIND_BY_UNAME='wavelength_max_text'): begin
        wavelength_max_text_eventcb, Event
    end

;wavelength width text box
    widget_info(wWidget, FIND_BY_UNAME='wavelength_width_text'): begin
        wavelength_width_text_eventcb, Event
    end

;detector angle value text box
    widget_info(wWidget, FIND_BY_UNAME='detector_angle_value'): begin
        detector_angle_value_eventcb, Event
    end

;detector angle value error text box
    widget_info(wWidget, FIND_BY_UNAME='detector_angle_err'): begin
        detector_angle_err_eventcb, Event
    end

;signal pid text box
    widget_info(wWidget, FIND_BY_UNAME='signal_pid_text'): begin
        signal_pid_text_eventcb, Event
    end

;background pid text box
    widget_info(wWidget, FIND_BY_UNAME='background_pid_text'): begin
        background_pid_text_eventcb, Event
    end

;open nexus file
    widget_info(wWidget, FIND_BY_UNAME='nexus_run_number_box'): begin
        nexus_run_number_box_eventcb, Event
    end

;list of run to process text box
    widget_info(wWidget, FIND_BY_UNAME='runs_to_process_text'): begin
        runs_to_process_text_eventcb, Event
    end

;combobox to run several NeXus files
    Widget_Info(wWidget, FIND_BY_UNAME='several_nexus_combobox'): begin
        several_nexus_combobox_eventcb, Event
    end

    else:
    
endcase

end


pro PORTAL_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;define parameters
scr_x 	= 880				;main window width
scr_y 	= 750				;main window height 
ctrl_x	= 1				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 304				;main width of draw area
draw_y 	= 256				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 150			;plot box height
plot_length = 304			;plot box length

Resolve_Routine, 'data_reduction_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

MAIN_BASE = Widget_Base(GROUP_LEADER=wGroup,$
                        UNAME='MAIN_BASE',$
                        SCR_XSIZE=265,$
                        SCR_YSIZE=250,$
                        XOFFSET=450,$
                        YOFFSET=50,$
                        NOTIFY_REALIZE='MAIN_REALIZE',$
                        TITLE='Data Reduction',$
                        SPACE=3,$
                        XPAD=3,$
                        YPAD=3,$
                        MBAR=WID_BASE_0_MBAR)

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

PORTAL_BASE= widget_base(MAIN_BASE,$
                         UNAME='PORTAL_BASE',$
                         SCR_XSIZE=240,$
                         SCR_YSIZE=80,$
                         FRAME=10,$
                         SPACE=4,$
                         XPAD=3,$
                         YPAD=3,$
                         column=1)

PORTAL_LABEL = widget_label(PORTAL_BASE,$
                            XOFFSET=40,$
                            YOFFSET=3,$
                            VALUE="SELECT YOUR INSTRUMENT")

instrument_list = ['Liquids Reflectometer',$
                   'Magnetism Reflectometer']

INSTRUMENT_TYPE_GROUP = CW_BGROUP(PORTAL_BASE,$ 
                                  instrument_list,$
                                  /exclusive,$
                                  /RETURN_NAME,$
                                  XOFFSET=30,$
                                  YOFFSET=25,$
                                  SET_VALUE=1.0,$          
                                  UNAME='INSTRUMENT_TYPE_GROUP')

LOGO_MESSAGE_BASE = widget_base(MAIN_BASE,$
                        UNAME="USER_BASE",$
                        SCR_XSIZE=265,$
                        SCR_YSIZE=70,$
                        XOFFSET=0,$
                        YOFFSET=110,$
                        FRAME=10,$
                        SPACE=4,$
                        XPAD=3,$
                        YPAD=3)

logo_message_draw = widget_draw(logo_message_base,$
                                uname='logo_message_draw',$
                                xoffset=5,$
                                yoffset=5,$
                                scr_xsize=235,$
                                scr_ysize=60,$
                                uvalue=0)

PORTAL_GO = widget_button(MAIN_BASE,$
                          XOFFSET=3,$
                          YOFFSET=210,$
                          SCR_XSIZE=260,$
                          SCR_YSIZE=30,$
                          UNAME="PORTAL_GO",$
                          VALUE="E N T E R",$
                          tooltip="Press to enter main program")

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user   ;for REF_L

Resolve_Routine, 'data_reduction_eventcb',/COMPILE_FULL_FILE ; Load event callback routines

;define initial global values - these could be input via external file or other means

instrument_list = ['REF_L', 'REF_M']

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME='MAIN_BASE',$
                         SCR_XSIZE=1000,$
                         SCR_YSIZE=440,$
                         XOFFSET=250,$
                         YOFFSET=22,$
                         NOTIFY_REALIZE='MAIN_REALIZE_data_reduction',$
                         TITLE='Data Reduction GUI for REF_L',$
                         SPACE=3,$
                         XPAD=3,$
                         YPAD=3,$
                         MBAR=WID_BASE_0_MBAR)
global = ptr_new({$
                   entering_intermediate_file_output_for_first_time : 0,$
                   signal_pid_file_name : '',$
                   background_pid_file_name : '',$
                   ct                   : 5,$
                   pass                 : 0,$
                   data_assoc		: ptr_new(0L),$
                   tab_drawing_ids      : ['signal_region_draw',$
                                           'background_summed_tof_draw',$
                                           'signal_region_summed_tof_draw',$
                                           'normalization_region_summed_tof_draw',$
                                     'background_region_from_normalization_region_summed_tof_draw'],$
                   intermediate_file_ext: ['.sdc',$
                                           '.bkg',$
                                           '.sub',$
                                           '.nom',$
                                           '.bnm'],$
                   intermediate_plots_title: ['Summed signal region',$
                                              'Summed background region',$
                                              'Summed signal region with background subtraction',$
                                              'Summed normalization signal region',$
                                              'Summed normalization background'],$
                   entering_selection_of_plots_by_yes_button : 0,$
                   file_opened          : 0,$
                   find_nexus           : 0L,$
                   full_histo_mapped_name : '',$
                   full_nexus_name      : '',$
                   img_ptr 		: ptr_new(0L),$
                   instrument		: instrument_list[instrument],$
                   main_output_file_name : '',$
                   nexus_file_name_only : '',$
                   Nx                   : 0L,$
                   Ny                   : 0L,$
                   Ntof                 : 0L,$
                   output_path		: '/SNSlocal/users/',$
                   pid_file_extension   : 'Pid.txt',$
                   previous_text        : '',$
                   push_button          : 0,$
                   run_number		: '',$
                   selection_value      : 0,$
                   selection_signal     : 0,$
                   selection_background : 0,$
                   selection_background_2 : 0,$
                   tmp_folder           : '',$
                   tmp_working_path     : '.tmp_data_reduction',$
                   ucams                : user,$
                   x1_back              : 0L,$
                   x2_back              : 0L,$
                   y1_back              : 0L,$
                   y2_back              : 0L,$
                   x1_back_2            : 0L,$
                   x2_back_2            : 0L,$
                   y1_back_2            : 0L,$
                   y2_back_2            : 0L,$
                   x1_signal            : 0L,$
                   x2_signal            : 0L,$
                   y1_signal            : 0L,$
                   y2_signal            : 0L,$
                   color_line_signal    : 250L,$
                   color_line_background: 300L,$
                   color_line_background_2: 100L,$
                   data_reduction_done : 0,$
                   plots_selected : [0,0,0,0,0] $
                 })

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;case instrument OF
;    0: begin ;REF_L
(*global).Nx = 304L
(*global).Ny = 256L
;    end
;    1: begin ;REF_M
;        (*global).Nx = 256L
;        (*global).Ny = 304L
;    end
;endcase

(*global).output_path = (*global).output_path + user + "/"

;#########################
;intermediate plots window
list_of_plots_base = widget_base(MAIN_BASE,$
                                 uname='list_of_plots_base',$
                                 xoffset=400,$
                                 yoffset=150,$
                                 scr_xsize=330,$
                                 scr_ysize=220,$
                                 xpad=5,$
                                 ypad=5,$
                                 frame=2,$
                                map=0)

list_of_intermediate_plots_base = widget_base(list_of_plots_base,$
                                              uname='list_of_intermediate_plots_base',$
                                              xoffset=0,$
                                              yoffset=0,$
                                              scr_xsize=330,$
                                              scr_ysize=180,$
                                              column=1)

list_of_intermediate_plots_title = widget_label(list_of_intermediate_plots_base,$
                                                value='List of intermediate plots',$
                                                frame=2)

intermediate_plots_list = ['Signal region summed TOF',$
                           'Background summed TOF',$
                           'Signal region summed TOF',$
                           'Normalization region summed TOF',$
                           'Background region from normalization summed TOF']

intermediate_plots_list_GROUP = CW_BGROUP(list_of_intermediate_plots_base,$ 
                                          intermediate_plots_list,$
                                          /RETURN_NAME,$
                                          /nonexclusive,$
                                          XOFFSET=30,$
                                          YOFFSET=25,$
                                          UNAME='intermediate_plots_list_group',$
                                          set_value=[1,1,1,1,1])

intermediate_plots_list_validate = widget_button(list_of_plots_base,$
                                                 uname='intermediate_plots_list_validate',$
                                                 value='Validate',$
                                                 scr_xsize=150,$
                                                 xoffset=30,$
                                                 yoffset=180)

intermediate_plots_list_cancel = widget_button(list_of_plots_base,$
                                               uname='intermediate_plots_list_cancel',$
                                               value='Cancel',$
                                               scr_xsize=100,$
                                               xoffset=200,$
                                               yoffset=180)
                                               


;TOP LEFT BOX - OPEN NEXUS
nexus_run_number_base = widget_base(MAIN_BASE,$
                                    xoffset=5,$
                                    yoffset=5,$
                                    scr_xsize=253,$
                                    scr_ysize=40,$
                                    frame=1)
nexus_run_number_title = widget_label(nexus_run_number_base,$
                                      xoffset=5,$
                                      yoffset=10,$
                                      value='Run number')
nexus_run_number_box = widget_text(nexus_run_number_base,$
                                   xoffset=80,$
                                   yoffset=5,$
                                   /editable,$
                                   /align_left,$
                                   scr_xsize=80,$
                                   scr_ysize=30,$
                                   uname='nexus_run_number_box',$
                                  /all_events)
nexus_run_number_go = widget_button(nexus_run_number_base,$
                                    xoffset=180,$
                                    yoffset=7,$
                                    value='O P E N',$
                                    uname='nexus_run_number_go')

;BOTTOM LEFT BOX - DISPLAY DATA
display_data_base = widget_draw(MAIN_BASE,$
                                xoffset=5,$
                                yoffset=50,$
                                scr_xsize=256,$
                                scr_ysize=304,$
                                uname='display_data_base',$
                                retain=2,$
                                /BUTTON_EVENTS,$
                                /MOTION_EVENTS)

;SELECT SIGNAL and BACKGROUND INTERFACE
select_signal_base = widget_base(MAIN_BASE,$
                                 xoffset=5,$
                                 yoffset=360,$
                                 scr_xsize=253,$
                                 scr_ysize=70,$
                                 frame=1)
selection_title = widget_label(select_signal_base,$
                               xoffset=0,$
                               yoffset=9,$
                               value='Selection')
selection_list = ['Signal',$
                  'Back_1',$
                  'Back_2']
selection_list_group = CW_BGROUP(select_signal_base,$ 
                                 selection_list,$
                                 /exclusive,$
                                 /RETURN_NAME,$
                                 XOFFSET=60,$
                                 YOFFSET=3,$
                                 SET_VALUE=0.0,$
                                 row=1,$
                                 UNAME='selection_list_group')

clear_selection_button = widget_button(select_signal_base,$
                                       uname='clear_selection_button',$
                                       xoffset=5,$
                                       yoffset=35,$
                                       scr_xsize=120,$
                                       value='CLEAR SELECTION',$
                                       sensitive=0)
save_selection_button = widget_button(select_signal_base,$
                                      uname='save_selection_button',$
                                      xoffset=125,$
                                      yoffset=35,$
                                      scr_xsize=120,$
                                      value='SAVE SELECTION',$
                                      sensitive=0)

;data_reduction and other_plots tab
;DATA REDUCTION and PLOTS BASE
xsize_of_tabs = 730
ysize_of_tabs = 430
data_reduction_plots_base = widget_base(MAIN_BASE,$
                                        xoffset=265,$
                                        yoffset=5,$
                                        scr_xsize=xsize_of_tabs,$
                                        scr_ysize=ysize_of_tabs)

data_reduction_tab = widget_tab(data_reduction_plots_base,$
                                uname='data_reduction_tab',$
                                location=0,$
                                xoffset=0,$
                                yoffset=0,$
                                scr_xsize=xsize_of_tabs,$
                                scr_ysize=ysize_of_tabs,$
                                /tracking_events)
  
;data reduction tab
first_tab_base = widget_base(data_reduction_tab,$
                                  uname='data_reduction_base',$
                                  TITLE='Data Reduction',$
                                  XOFFSET=0,$
                                  YOFFSET=0)
data_reduction_base = widget_base(first_tab_base,$
                                  xoffset=5,$
                                  yoffset=5,$
                                  scr_xsize=305,$
                                  scr_ysize=390,$
                                  frame=1)

signal_pid_file_button = widget_button(data_reduction_base,$
                                      uname='signal_pid_file_button',$
                                      xoffset=5,$
                                      yoffset=7,$
                                      value='Signal Pid file',$
                                      sensitive=0)

signal_pid_file_text = widget_text(data_reduction_base,$
                                   uname='signal_pid_text',$
                                   xoffset=110,$
                                   yoffset=5,$
                                   scr_xsize=190,$
                                   value='',$
                                   /align_left,$
                                   /editable,$
                                   /all_events)

;background_title = widget_label(data_reduction_base,$
;                                xoffset=8,$
;                                yoffset=47,$
;                                value='Background:')
; background_list = ['Yes',$
;                   'No']
; background_list_group = CW_BGROUP(data_reduction_base,$ 
;                                   background_list,$
;                                   /exclusive,$
;                                   /RETURN_NAME,$
;                                   XOFFSET=100,$
;                                   YOFFSET=40,$
;                                   SET_VALUE=0.0,$
;                                   row=1,$
;                                   uname='background_list_group')

; background_file_base = widget_base(data_reduction_base,$
;                                    uname='background_file_base',$
;                                    xoffset=0,$
;                                    yoffset=70,$
;                                    scr_xsize=xsize_of_tabs,$
;                                    scr_ysize=40,$
;                                    frame=0)

background_pid_file_button = widget_button(data_reduction_base,$
                                           uname='background_pid_file_button',$
                                           xoffset=5,$
                                           yoffset=47,$
                                           value='Back. Pid file',$
                                           sensitive=0)

background_file_text = widget_text(data_reduction_base,$
                                   uname='background_pid_text',$
                                   xoffset=110,$
                                   yoffset=47,$
                                   scr_xsize=190,$
                                   value='',$
                                   /align_left,$
                                   /editable,$
                                   /all_events)

norm_y_offset = 20
normalization_label = widget_label(data_reduction_base,$
                                   xoffset=5,$
                                   yoffset=117-norm_y_offset,$
                                   value='Normalization:')

normalization_list = ['Yes',$
                      'No']
normalization_list_group_REF_L = CW_BGROUP(data_reduction_base,$ 
                                           normalization_list,$
                                           /exclusive,$
                                           /RETURN_NAME,$
                                           XOFFSET=90,$
                                           YOFFSET=110-norm_y_offset,$
                                           SET_VALUE=0.0,$
                                           row=1,$
                                           uname='normalization_list_group_REF_L')

norm_run_number_base = widget_base(data_reduction_base,$
                                   uname='norm_run_number_base',$
                                   xoffset=175,$
                                   yoffset=110-norm_y_offset,$
                                   scr_xsize=150,$
                                   scr_ysize=34)

normalization_label = widget_label(norm_run_number_base,$
                                   xoffset=0,$
                                   yoffset=7,$
                                   value='-> Run #')

normalization_text = widget_text(norm_run_number_base,$
                                 xoffset=55,$
                                 yoffset=2,$
                                 scr_xsize=70,$
                                 value='',$
                                 uname='normalization_text',$
                                 /editable,$
                                 /align_left,$
                                 /all_events)

norm_bkg_offset = 10
norm_background_title = widget_label(data_reduction_base,$
                                     xoffset=5,$
                                     yoffset=145-norm_bkg_offset,$
                                     value='Norm. bkg.:')


norm_background_list = ['Yes',$
                        'No']
norm_background_list_group = CW_BGROUP(data_reduction_base,$ 
                                       norm_background_list,$
                                       /exclusive,$
                                       /RETURN_NAME,$
                                       XOFFSET=75,$
                                       YOFFSET=138-norm_bkg_offset,$
                                       SET_VALUE=0.0,$
                                       row=1,$
                                       uname='norm_background_list_group')

norm_frame = widget_base(data_reduction_base,$
                          xoffset=0,$
                          yoffset=136-norm_bkg_offset,$
                          scr_xsize=162,$
                          scr_ysize=31,$
                          frame=1)

bkg_offset = 10
background_title = widget_label(data_reduction_base,$
                                     xoffset=175,$
                                     yoffset=145-bkg_offset,$
                                     value='Bkg.:')

background_list = ['Yes',$
                   'No']
background_list_group = CW_BGROUP(data_reduction_base,$ 
                                  background_list,$
                                  /exclusive,$
                                  /RETURN_NAME,$
                                  XOFFSET=210,$
                                  YOFFSET=138-bkg_offset,$
                                  SET_VALUE=0.0,$
                                  row=1,$
                                  uname='background_list_group')

back_frame = widget_base(data_reduction_base,$
                         xoffset=170,$
                         yoffset=136-norm_bkg_offset,$
                         scr_xsize=130,$
                         scr_ysize=31,$
                         frame=1)

runs_to_process_label = widget_label(data_reduction_base,$
                                     xoffset=5,$
                                     yoffset=183-norm_bkg_offset,$
                                     value='Runs #')
runs_to_process_text = widget_text(data_reduction_base,$
                                   xoffset=50,$
                                   yoffset=173-norm_bkg_offset,$
                                   scr_xsize=230,$
                                   value='',$
                                   uname='runs_to_process_text',$
                                   /editable,$
                                   /align_left,$
                                   /all_events)
runs_to_process_help = widget_button(data_reduction_base,$
                                     uname='runs_to_process_help',$
                                     xoffset=280,$
                                     yoffset=173-norm_bkg_offset,$
                                     scr_xsize=20,$
                                     scr_ysize=30,$
                                     value='?',$
                                    /pushbutton_events,$
                                     tooltip='Click to see the format of input to use')

intermediate_file_label = widget_label(data_reduction_base,$
                                       xoffset=5,$
                                       yoffset=210,$
                                       value='Intermediate files output:')

intermediate_file_output_list = ['Yes',$
                                 'No']
intermediate_file_output_list_group = CW_BGROUP(data_reduction_base,$ 
                                                intermediate_file_output_list,$
                                                /exclusive,$
                                                /RETURN_NAME,$
                                                XOFFSET=170,$
                                                YOFFSET=204,$
                                                SET_VALUE=1.0,$
                                                row=1,$
                                                uname='intermediate_file_output_list_group')

acces_to_list_of_intermediate_plots = widget_button(data_reduction_base,$
                                                    uname='access_to_list_of_intermediate_plots',$
                                                    xoffset=260,$
                                                    yoffset=207,$
                                                    value='Plots')
                                                  
start_data_reduction_button = widget_button(data_reduction_base,$
                                            xoffset=5,$
                                            yoffset=235,$
                                            scr_xsize=295,$
                                            value='START DATA REDUCTION',$
                                            uname='start_data_reduction_button',$
                                            sensitive=0)

;info text box 
info_text = widget_text(data_reduction_base,$
                        xoffset=5,$
                        yoffset=265,$
                        scr_xsize=295,$
                        scr_ysize=120,$
                        /scroll,$
                        /wrap,$
                        uname='info_text')

data_reduction_plot = widget_draw(first_tab_base,$
                                  xoffset=315,$
                                  yoffset=5,$
                                  scr_xsize=405,$
                                  scr_ysize=393,$
                                  uname='data_reduction_plot')

;selection boxes info tab
fourth_tab_base = widget_base(data_reduction_tab,$
                                  uname='fourth_tab_base',$
                                  TITLE='Selection infos',$
                                  XOFFSET=0,$
                                  YOFFSET=0)

selection_tab = widget_tab(fourth_tab_base,$
                                  location=0,$
                                  xoffset=0,$
                                  yoffset=0,$
                                  scr_xsize=xsize_of_tabs-10,$
                                  scr_ysize=ysize_of_tabs-30)
  
;signal_selection_tab
signal_tab_base = widget_base(selection_tab,$
                              uname='signal_tab_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

signal_info = widget_text(signal_tab_base,$
                          uname='signal_info',$
                          xoffset=0,$
                          yoffset=5,$
                          scr_xsize=710,$
                          scr_ysize=370,$
                          /wrap,$
                          /scroll)

;background_1_selection_tab
background_1_tab_base = widget_base(selection_tab,$
                                    uname='background_1_tab_base',$
                                    TITLE='',$
                                    XOFFSET=0,$
                                    YOFFSET=0)

background_1_info = widget_text(background_1_tab_base,$
                          uname='background_info',$
                          xoffset=0,$
                          yoffset=5,$
                          scr_xsize=710,$
                          scr_ysize=370,$
                          /wrap,$
                          /scroll)

;background_2_selection_tab
background_2_tab_base = widget_base(selection_tab,$
                                  uname='background_2_tab_base',$
                                  TITLE='',$
                                  XOFFSET=0,$
                                  YOFFSET=0)

background_2_info = widget_text(background_2_tab_base,$
                          uname='background_2_info',$
                          xoffset=0,$
                          yoffset=5,$
                          scr_xsize=710,$
                          scr_ysize=370,$
                          /wrap,$
                          /scroll)

;other plots tab
other_plots_base = widget_base(data_reduction_tab,$
                               uname='other_plots_base',$
                               TITLE='Extra plots',$
                               XOFFSET=0,$
                               YOFFSET=0)

other_plots_tab = widget_tab(other_plots_base,$
                             uname='other_plots_tab',$                             
                             location=0,$
                             xoffset=0,$
                             yoffset=0,$
                             scr_xsize=xsize_of_tabs-10,$
                             scr_ysize=ysize_of_tabs-30,$
                             /tracking_events)

;signal region plot
signal_region_tab_base = widget_base(other_plots_tab,$
                              uname='signal_region_tab_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

signal_region_draw = widget_draw(signal_region_tab_base,$
                                 uname='signal_region_draw',$
                                 xoffset=2,$
                                 yoffset=2,$
                                 scr_xsize=710,$
                                 scr_ysize=383)

;background summed TOF plot
background_summed_tof_tab_base = widget_base(other_plots_tab,$
                              uname='background_summed_tof_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

background_summed_tof_draw = widget_draw(background_summed_tof_tab_base,$
                                         uname='background_summed_tof_draw',$
                                         xoffset=2,$
                                         yoffset=2,$
                                         scr_xsize=710,$
                                         scr_ysize=383)

;signal region summed tof plot
signal_region_summed_tof_tab_base = widget_base(other_plots_tab,$
                              uname='signal_region_summed_tof_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

signal_region_summed_tof_draw = widget_draw(signal_region_summed_tof_tab_base,$
                                            uname='signal_region_summed_tof_draw',$
                                            xoffset=2,$
                                            yoffset=2,$
                                            scr_xsize=710,$
                                            scr_ysize=383)

;normalization region summed tof plot
normalization_region_summed_tof_tab_base = widget_base(other_plots_tab,$
                              uname='normalization_region_summed_tof_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

normalization_region_summed_tof_draw = widget_draw(normalization_region_summed_tof_tab_base,$
                                                   uname='normalization_region_summed_tof_draw',$
                                                   xoffset=2,$
                                                   yoffset=2,$
                                                   scr_xsize=710,$
                                                   scr_ysize=383)


;background region from normalization summed tof
background_region_from_normalization_region_summed_tof_tab_base = widget_base(other_plots_tab,$
                              uname='background_region_from_normalization_region_summed_tof_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

background_region_from_normalization_region_summed_tof_draw = widget_draw($
                              background_region_from_normalization_region_summed_tof_tab_base,$
                              uname='background_region_from_normalization_region_summed_tof_draw',$
                              xoffset=2,$
                              yoffset=2,$
                              scr_xsize=710,$
                              scr_ysize=383)


;log book tab
log_book_base = widget_base(data_reduction_tab,$
                         uname='log_book_base',$
                         TITLE='Log book',$
                         XOFFSET=0,$
                         YOFFSET=0)

log_book_text = widget_text(log_book_base,$
                            uname='log_book_text',$
                            scr_xsize=720,$
                            scr_ysize=395,$
                            xoffset=5,$
                            yoffset=5,$
                            /scroll,$
                            /wrap)

FILE_MENU_REF_L = Widget_Button(WID_BASE_0_MBAR, $
                                  UNAME='FILE_MENU_REF_L',$
                                  /MENU,$
                                  VALUE='MENU')

CTOOL_MENU = Widget_Button(FILE_MENU_REF_L, UNAME='CTOOL_MENU'  $
                           ,VALUE='Color Tool...')


EXIT_MENU_REF_L = Widget_Button(FILE_MENU_REF_L, UNAME='EXIT_MENU_REF_L'  $
                                ,VALUE='Exit')





Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end



pro wTLC, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_, instrument, user

Resolve_Routine, 'data_reduction_eventcb',/COMPILE_FULL_FILE ; Load event callback routines

;define initial global values - these could be input via external file or other means

instrument_list = ['REF_L', 'REF_M']

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME='MAIN_BASE',$
                         SCR_XSIZE=1050,$
                         SCR_YSIZE=442,$
                         XOFFSET=250,$
                         YOFFSET=22,$
                         NOTIFY_REALIZE='MAIN_REALIZE_data_reduction',$
                         TITLE='Data Reduction GUI for REF_M',$
                         SPACE=3,$
                         XPAD=3,$
                         YPAD=3,$
                         MBAR=WID_BASE_0_MBAR)
global = ptr_new({$
                   entering_intermediate_file_output_for_first_time : 0,$
                   signal_pid_file_name : '',$
                   background_pid_file_name : '',$
                   ct                   : 5,$
                   pass                 : 0,$
                   data_assoc		: ptr_new(0L),$
                   entering_selection_of_plots_by_yes_button : 0,$
                   file_opened          : 0,$
                   find_nexus           : 0L,$
                   full_histo_mapped_name : '',$
                   full_nexus_name      : '',$
                   tab_drawing_ids      : ['signal_region_draw',$
                                           'background_summed_tof_draw',$
                                           'normalization_region_summed_tof_draw',$
                                     'background_region_from_normalization_region_summed_tof_draw'],$
                   intermediate_file_ext: ['.sdc',$
                                           '.bkg',$
                                           '.nom',$
                                           '.bnm'],$
                   intermediate_plots_title: ['Summed signal region',$
                                              'Summed background region',$
                                              'Summed normalization signal region',$
                                              'Summed normalization background'],$
                   img_ptr 		: ptr_new(0L),$
                   instrument		: instrument_list[instrument],$
                   main_output_file_name: '',$
                   nexus_file_name_only : '',$
                   Nx                   : 0L,$
                   Ny                   : 0L,$
                   Ntof                 : 0L,$
                   output_path		: '/SNSlocal/users/',$
                   output_plots         : 1,$
                   previous_text        : '',$
                   push_button          : 0,$
                   pid_file_extension   : 'Pid.txt',$
                   run_number		: '',$
                   runs_to_process      : 0,$
                   selection_value      : 0,$
                   selection_signal     : 0,$
                   selection_background : 0,$
                   selection_background_2 : 0,$
                   tmp_folder           : '',$
                   tmp_working_path     : '.tmp_data_reduction',$
                   ucams                : user,$
                   x1_back              : 0L,$
                   x2_back              : 0L,$
                   y1_back              : 0L,$
                   y2_back              : 0L,$
                   x1_back_2            : 0L,$
                   x2_back_2            : 0L,$
                   y1_back_2            : 0L,$
                   y2_back_2            : 0L,$
                   x1_signal            : 0L,$
                   x2_signal            : 0L,$
                   y1_signal            : 0L,$
                   y2_signal            : 0L,$
                   color_line_signal    : 250L,$
                   color_line_background: 3000L,$
                   color_line_background_2: 100L,$
                   data_reduction_done : 0,$
                   plots_selected : [0,0,0,0],$
                   list_of_runs : ptr_new(0L),$
                   initial_list_of_runs : [' '] $
                 })

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

(*global).Nx = 256L
(*global).Ny = 304L

list_of_runs = strarr(1)
list_of_runs[0] = ' '
(*(*global).list_of_runs) = list_of_runs

(*global).output_path = (*global).output_path + user + "/"

;#########################
;intermediate plots window
list_of_plots_base = widget_base(MAIN_BASE,$
                                 uname='list_of_plots_base',$
                                 xoffset=450,$
                                 yoffset=200,$
                                 scr_xsize=330,$
                                 scr_ysize=220,$
                                 xpad=5,$
                                 ypad=5,$
                                 frame=2,$
                                 map=0)

list_of_intermediate_plots_base = widget_base(list_of_plots_base,$
                                              uname='list_of_intermediate_plots_base',$
                                              xoffset=0,$
                                              yoffset=0,$
                                              scr_xsize=330,$
                                              scr_ysize=180,$
                                              column=1)

list_of_intermediate_plots_title = widget_label(list_of_intermediate_plots_base,$
                                                uname='list_of_intermediate_plots_title',$
                                                value='List of intermediate plots',$
                                                frame=2)

intermediate_plots_list = ['Signal region summed TOF',$
                           'Background summed TOF',$
                           'Normalization region summed TOF',$
                           'Background region from normalization summed TOF']

intermediate_plots_list_GROUP = CW_BGROUP(list_of_intermediate_plots_base,$ 
                                          intermediate_plots_list,$
                                          /RETURN_NAME,$
                                          /nonexclusive,$
                                          XOFFSET=30,$
                                          YOFFSET=25,$
                                          UNAME='intermediate_plots_list_group',$
                                          set_value=[1,1,1,1])

intermediate_plots_list_validate = widget_button(list_of_plots_base,$
                                                 uname='intermediate_plots_list_validate_REF_M',$
                                                 value='Validate',$
                                                 scr_xsize=150,$
                                                 xoffset=30,$
                                                 yoffset=180)

intermediate_plots_list_cancel = widget_button(list_of_plots_base,$
                                               uname='intermediate_plots_list_cancel_REF_M',$
                                               value='Cancel',$
                                               scr_xsize=100,$
                                               xoffset=200,$
                                               yoffset=180)
                                               

;TOP LEFT BOX - OPEN NEXUS
nexus_run_number_base = widget_base(MAIN_BASE,$
                                    xoffset=5,$
                                    yoffset=5,$
                                    scr_xsize=300,$
                                    scr_ysize=40,$
                                    frame=1)

nexus_run_number_title = widget_label(nexus_run_number_base,$
                                      xoffset=5,$
                                      yoffset=10,$
                                      value='Run number')
nexus_run_number_box = widget_text(nexus_run_number_base,$
                                   xoffset=80,$
                                   yoffset=5,$
                                   /editable,$
                                   /align_left,$
                                   scr_xsize=80,$
                                   scr_ysize=30,$
                                   uname='nexus_run_number_box',$
                                  /all_events)
nexus_run_number_go_REF_M = widget_button(nexus_run_number_base,$
                                    xoffset=180,$
                                    yoffset=7,$
                                    scr_xsize=100,$
                                    value='O P E N',$
                                    uname='nexus_run_number_go_REF_M')

;BOTTOM LEFT BOX - DISPLAY DATA
display_data_base = widget_draw(MAIN_BASE,$
                                xoffset=5,$
                                yoffset=70,$  
                                scr_xsize=304,$
                                scr_ysize=256,$
                                uname='display_data_base',$
                                retain=2,$
                                /BUTTON_EVENTS,$
                                /MOTION_EVENTS)


;SELECT SIGNAL and BACKGROUND INTERFACE
select_signal_base = widget_base(MAIN_BASE,$
                                 xoffset=5,$
                                 yoffset=360,$
                                 scr_xsize=300,$
                                 scr_ysize=70,$
                                 frame=1)
selection_title = widget_label(select_signal_base,$
                               xoffset=5,$
                               yoffset=9,$
                               value='Selection:')
selection_list = ['Signal ',$
                  'Back_1 ',$
                  'Back_2']
selection_list_group= CW_BGROUP(select_signal_base,$ 
                                selection_list,$
                                /exclusive,$
                                /RETURN_NAME,$
                                XOFFSET=80,$
                                YOFFSET=3,$
                                SET_VALUE=0.0,$
                                row=1,$
                                UNAME='selection_list_group')

clear_selection_button = widget_button(select_signal_base,$
                                       uname='clear_selection_button',$
                                       xoffset=15,$
                                       yoffset=35,$
                                       scr_xsize=120,$
                                       value='CLEAR SELECTION',$
                                       sensitive=0)
save_selection_button = widget_button(select_signal_base,$
                                      uname='save_selection_button',$
                                      xoffset=155,$
                                      yoffset=35,$
                                      scr_xsize=120,$
                                      value='SAVE SELECTION',$
                                      sensitive=0)

;data_reduction and other_plots tab
;DATA REDUCTION and PLOTS BASE
xsize_of_tabs = 730
ysize_of_tabs = 430
data_reduction_plots_base = widget_base(MAIN_BASE,$
                                        xoffset=315,$
                                        yoffset=5,$
                                        scr_xsize=xsize_of_tabs,$
                                        scr_ysize=ysize_of_tabs)

data_reduction_tab = widget_tab(data_reduction_plots_base,$
                                uname='data_reduction_tab',$
                                location=0,$
                                xoffset=0,$
                                yoffset=0,$
                                scr_xsize=xsize_of_tabs,$
                                scr_ysize=ysize_of_tabs,$
                                /tracking_events)
  
;data reduction tab
first_tab_base = widget_base(data_reduction_tab,$
                                  uname='first_tab_base',$
                                  TITLE='Data Reduction',$
                                  XOFFSET=0,$
                                  YOFFSET=0)
data_reduction_base = widget_base(first_tab_base,$
                                  xoffset=5,$
                                  yoffset=5,$
                                  scr_xsize=305,$
                                  scr_ysize=390,$
                                  frame=1)

;Wavelength part (min, max, width)
wavelength_label = widget_label(data_reduction_base,$
                                uname='wavelength_label',$
                                xoffset=10,$
                                yoffset=3,$
                                value='Wavelength')

WAVELENGTH_base = widget_base(data_reduction_base,$
                              UNAME='WAVELENGTH_LABEL',$
                              XOFFSET=5,$
                              YOFFSET=12,$
                              scr_xsize=150,$
                              scr_ysize=115,$
                              frame=1)

wavelength_frame_x_offset = 5
wavelength_frame_y_offset = 20 

;min
min_y_offset = wavelength_frame_y_offset
min_x_offset = wavelength_frame_x_offset
WAVELENGTH_MIN_LABEL= widget_label(wavelength_base,$
                                   UNAME='wavelength_min_label',$
                                   XOFFSET=min_x_offset,$
                                   YOFFSET=min_y_offset,$
                                   VALUE="min")

WAVELENGTH_MIN_TEXT = widget_text(wavelength_base,$
                                  UNAME='wavelength_min_text',$
                                  XOFFSET=min_x_offset+30,$
                                  YOFFSET=min_y_offset-10,$
                                  SCR_XSIZE=50,$
                                  VALUE='0',$
                                  /editable,$
                                  /all_events,$
                                 /no_newline)

WAVELENGTH_MIN_A_LABEL= widget_label(wavelength_base,$
                                     UNAME='WAVELENGTH_MIN_A_LABEL',$
                                     XOFFSET=min_x_offset+80,$
                                     YOFFSET=min_y_offset,$
                                     VALUE="Angstroms")

; max
max_y_offset = wavelength_frame_y_offset+30
max_x_offset = wavelength_frame_x_offset   
WAVELENGTH_MAX_LABEL= widget_label(wavelength_base,$
                                   UNAME='WAVELENGTH_MAX_LABEL',$
                                   XOFFSET=max_x_offset,$
                                   YOFFSET=max_y_offset,$
                                   VALUE="max")

WAVELENGTH_MAX_TEXT = widget_text(wavelength_base,$
                                  UNAME='wavelength_max_text',$
                                  XOFFSET=max_x_offset+30,$
                                  YOFFSET=max_y_offset-5,$
                                  SCR_XSIZE=50,$
                                  VALUE='10',$
                                  /editable,$
                                  /all_events)

WAVELENGTH_MAX_A_LABEL= widget_label(wavelength_base,$
                                     UNAME='WAVELENGTH_MAX_A_LABEL',$
                                     XOFFSET=max_x_offset+80,$
                                     YOFFSET=max_y_offset,$
                                     VALUE="Angstroms")

; width
width_y_offset =  wavelength_frame_y_offset +65
width_x_offset = wavelength_frame_x_offset - 10
WAVELENGTH_WIDTH_LABEL= widget_label(wavelength_base,$
                                     UNAME='WAVELENGTH_WIDTH_LABEL',$
                                     XOFFSET=width_x_offset,$
                                     YOFFSET=width_y_offset,$
                                     VALUE="width")

WAVELENGTH_WIDTH_TEXT = widget_text(wavelength_base,$
                                    UNAME='wavelength_width_text',$
                                    XOFFSET=width_x_offset+40,$
                                    YOFFSET=width_y_offset-5,$
                                    SCR_XSIZE=50,$
                                    VALUE='0.1',$
                                    /editable,$
                                    /all_events)

WAVELENGTH_WIDTH_A_LABEL= widget_label(wavelength_base,$
                                       UNAME='WAVELENGTH_WIDTH_A_LABEL',$
                                       XOFFSET=width_x_offset+90,$
                                       YOFFSET=width_y_offset,$
                                       VALUE="Angstroms")

;detector angle base
detector_label = widget_label(data_reduction_base,$
                              xoffset=165,$
                              yoffset=3,$
                              value='Detector angle')

detector_base = widget_base(data_reduction_base,$
                            uname='detector_base',$
                            xoffset=160,$
                            yoffset=12,$
                            scr_xsize=135,$
                            scr_ysize=75,$
                            frame=1)

DETECTOR_ANGLE_VALUE = widget_text(detector_base,$
                                   UNAME='detector_angle_value',$
                                   XOFFSET=0,$
                                   YOFFSET=10,$
                                   SCR_XSIZE=50,$
                                   VALUE='0',$
                                   /editable,$
                                   /all_events)

DETECTOR_ANGLE_ERR = widget_text(detector_base,$
                                 UNAME='detector_angle_err',$
                                 XOFFSET=80,$
                                 YOFFSET=10,$
                                 SCR_XSIZE=50,$
                                 VALUE='0',$
                                 /editable,$
                                 /all_events)

DETECTOR_ANGLE_PLUS_MINUS = widget_label(detector_base,$
                                         UNAME='DETECTOR_ANGLE_PLUS_MINUS',$
                                         XOFFSET=55,$
                                         YOFFSET=15,$
                                         VALUE='+/-')

angle_units = ["radians","degres"]
DETECTOR_ANGLE_UNITS = widget_droplist(detector_base,$
                                       UNAME='detector_angle_units',$
                                       XOFFSET=15,$
                                       YOFFSET=40,$
                                       VALUE=angle_units, $
                                       title='')

;signal Pid file
signal_pid_file_button = widget_button(data_reduction_base,$
                                       uname='signal_pid_file_button',$
                                       xoffset=5,$
                                       yoffset=135,$
                                       value='Signal - Pid file',$
                                       scr_xsize=137)

signal_pid_text = widget_text(data_reduction_base,$
                              uname='signal_pid_text',$
                              xoffset=160,$
                              yoffset=130,$
                              scr_xsize=140,$
                              /editable,$
                              /all_events)

 background_title = widget_label(data_reduction_base,$
                                 xoffset=160,$
                                 yoffse=100,$
                                value='Background:')
 background_list = ['Y',$
                    'N']
 background_list_group = CW_BGROUP(data_reduction_base,$ 
                                   background_list,$
                                   /exclusive,$
                                   /RETURN_NAME,$
                                   XOFFSET=230,$
                                   YOFFSET=95,$
                                   SET_VALUE=0.0,$
                                   row=1,$
                                   uname='background_list_group')

background_pid_file_button = widget_button(data_reduction_base,$
                                             uname='background_pid_file_button',$
                                             xoffset=5,$
                                             yoffset=164,$
                                             value='Background - Pid file')

background_pid_text = widget_text(data_reduction_base,$
                                  uname='background_pid_text',$
                                  xoffset=160,$
                                  yoffset=160,$
                                  scr_xsize=140,$
                                  value='',$
                                  /align_left,$
                                  /editable,$
                                  /all_events)

normalization_label = widget_label(data_reduction_base,$
                                   xoffset=5,$
                                   yoffset=196,$
                                   value='Normalization:')

normalization_list = ['Yes',$
                      'No']
normalization_list_group_REF_M = CW_BGROUP(data_reduction_base,$ 
                                           normalization_list,$
                                           /exclusive,$
                                           /RETURN_NAME,$
                                           XOFFSET=90,$
                                           YOFFSET=190,$
                                           SET_VALUE=0.0,$
                                           row=1,$
                                           uname='normalization_list_group_REF_M')

norm_run_number_base = widget_base(data_reduction_base,$
                                   uname='norm_run_number_base',$
                                   xoffset=175,$
                                   yoffset=190,$
                                   scr_xsize=200,$
                                   scr_ysize=30)

normalization_label = widget_label(norm_run_number_base,$
                                   xoffset=0,$
                                   yoffset=7,$
                                   value='-> Run #')

normalization_text = widget_text(norm_run_number_base,$
                                 xoffset=52,$
                                 yoffset=0,$
                                 scr_xsize=73,$
                                 value='',$
                                 uname='normalization_text',$
                                 /editable,$
                                 /align_left,$
                                 /all_events)

;one or several runs to process in the same time
runs_to_process_label = widget_label(data_reduction_base,$
                                     uname='runs_to_process_label',$
                                     xoffset=5,$
                                     yoffset=233,$
                                     value=' 0 run #')

list_value = (*global).initial_list_of_runs
several_nexus_combobox = widget_combobox(data_reduction_base,$
                                         uname='several_nexus_combobox',$
                                          xoffset=65,$
                                          yoffset=225,$
                                          scr_ysize=30,$
                                          scr_xsize=110,$
                                          /editable,$
                                          value=list_value)

; runs_to_process_text= widget_text(data_reduction_base,$
;                                   xoffset=75,$
;                                   yoffset=225,$
;                                   scr_xsize=100,$
;                                   value='',$
;                                   uname='runs_to_process_text',$
;                                   /editable,$
;                                   /align_left,$
;                                   /all_events)

;norm-bkg
norm_background_title = widget_label(data_reduction_base,$
                                     xoffset=5,$
                                     yoffset=270,$
                                     value='Norm. bkg.:')

norm_background_list = ['Yes',$
                        'No']
norm_background_list_group = CW_BGROUP(data_reduction_base,$ 
                                       norm_background_list,$
                                       /exclusive,$
                                       /RETURN_NAME,$
                                       XOFFSET=80,$
                                       YOFFSET=263,$
                                       SET_VALUE=0.0,$
                                       row=1,$
                                       uname='norm_background_list_group')

;intermediate files/plots
intermediate_file_label = widget_button(data_reduction_base,$
                                       xoffset=180,$
                                       yoffset=233,$
                                       value='Intermediate plots',$
                                       uname='access_to_list_of_intermediate_plots_button')

intermediate_file_output_list = ['Yes',$
                                 'No ']
intermediate_file_output_list_group = CW_BGROUP(data_reduction_base,$ 
                                                intermediate_file_output_list,$
                                                /exclusive,$
                                                /RETURN_NAME,$
                                                XOFFSET=190,$
                                                YOFFSET=255,$
                                                SET_VALUE=1.0,$
                                                row=1,$
                                                uname='intermediate_file_output_list_group_REF_M')

intermediate_file_frame = widget_base(data_reduction_base,$
                                      xoffset=177,$
                                      yoffset=222,$
                                      scr_xsize=122,$
                                      scr_ysize=65,$
                                      frame=1)


;start data reduction base
start_data_reduction_base = widget_base(data_reduction_base,$
                                        xoffset=5,$
                                        yoffset=290,$
                                        scr_xsize=295,$
                                        scr_ysize=40)

start_data_reduction_button = widget_button(start_data_reduction_base,$
                                            xoffset=0,$
                                            yoffset=5,$
                                            scr_xsize=295,$
                                            scr_ysize=35,$
                                            value='START DATA REDUCTION',$
                                            uname='start_data_reduction_button',$
                                            sensitive=0)

; start_data_reduction_tab = widget_tab(start_data_reduction_base,$
;                                       uname='start_data_reduction_tab',$
;                                       location=2,$
;                                       xoffset=0,$
;                                       yoffset=0,$
;                                       scr_xsize=295,$
;                                       scr_ysize=40,$
;                                       /tracking_events)

;;work on 1 NeXus file at a time
;one_nexus_file_base = widget_base(start_data_reduction_tab,$
;                                  uname='one_nexus_file_base',$
;                                  xoffset=0,$
;                                  yoffset=0,$
;                                  title='1')


;; work on several NeXus file at a time
; several_nexus_file_base = widget_base(start_data_reduction_tab,$
;                                       uname='several_nexus_file_base',$
;                                       xoffset=0,$
;                                       yoffset=0,$
;                                       title='..')

; list_value = (*global).initial_list_of_runs
; several_nexus_combobox = widget_combobox(several_nexus_file_base,$
;                                          uname='several_nexus_combobox',$
;                                          xoffset=5,$
;                                          yoffset=3,$
;                                          scr_ysize=30,$
;                                          scr_xsize=110,$
;                                          /editable,$
;                                          value=list_value)

; start_data_reduction_several_nexus_button = widget_button(several_nexus_file_base,$
;                                                           xoffset=115,$
;                                                           yoffset=0,$
;                                                           scr_xsize=155,$
;                                                           scr_ysize=35,$
;                                                           value='START DATA REDUCTION',$
;                                                  uname='start_data_reduction_several_nexus_button',$
;                                                           sensitive=0)




;info text box 
info_text_REF_M = widget_text(data_reduction_base,$
                              xoffset=5,$
                              yoffset=265+65,$
                              scr_xsize=295,$
                              scr_ysize=55,$
                              /scroll,$
                              /wrap,$
                              uname='info_text')

data_reduction_plot = widget_draw(first_tab_base,$
                                  xoffset=315,$
                                  yoffset=5,$
                                  scr_xsize=405,$
                                  scr_ysize=393,$
                                  uname='data_reduction_plot')

;selection boxes info tab
fourth_tab_base = widget_base(data_reduction_tab,$
                                  uname='fourth_tab_base',$
                                  TITLE='Selection infos',$
                                  XOFFSET=0,$
                                  YOFFSET=0)


selection_tab = widget_tab(fourth_tab_base,$
                                  location=0,$
                                  xoffset=0,$
                                  yoffset=0,$
                                  scr_xsize=xsize_of_tabs-10,$
                                  scr_ysize=ysize_of_tabs-30)
  

;signal_selection_tab
signal_tab_base = widget_base(selection_tab,$
                              uname='signal_tab_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

signal_info = widget_text(signal_tab_base,$
                          uname='signal_info',$
                          xoffset=0,$
                          yoffset=5,$
                          scr_xsize=710,$
                          scr_ysize=370,$
                          /wrap,$
                          /scroll)

;background_1_selection_tab
background_1_tab_base = widget_base(selection_tab,$
                                    uname='background_1_tab_base',$
                                    TITLE='',$
                                    XOFFSET=0,$
                                    YOFFSET=0)

background_1_info = widget_text(background_1_tab_base,$
                          uname='background_info',$
                          xoffset=0,$
                          yoffset=5,$
                          scr_xsize=710,$
                          scr_ysize=370,$
                          /wrap,$
                          /scroll)

;background_2_selection_tab
background_2_tab_base = widget_base(selection_tab,$
                                  uname='background_2_tab_base',$
                                  TITLE='',$
                                  XOFFSET=0,$
                                  YOFFSET=0)

background_2_info = widget_text(background_2_tab_base,$
                          uname='background_2_info',$
                          xoffset=0,$
                          yoffset=5,$
                          scr_xsize=710,$
                          scr_ysize=370,$
                          /wrap,$
                          /scroll)

;other plots tab
other_plots_base = widget_base(data_reduction_tab,$
                               uname='other_plots_base',$
                               TITLE='Extra plots',$
                               XOFFSET=0,$
                               YOFFSET=0)

screen_base = widget_base(other_plots_base,$
                          uname='screen_base',$
                          xoffset=0,$
                          yoffset=0,$
                          scr_xsize=730,$
                          scr_ysize=400,$
                          map=1)


other_plots_tab = widget_tab(other_plots_base,$
                             uname='other_plots_tab',$
                             location=0,$
                             xoffset=0,$
                             yoffset=0,$
                             scr_xsize=xsize_of_tabs-10,$
                             scr_ysize=ysize_of_tabs-30,$
                             /tracking_events)

;signal region plot
signal_region_tab_base = widget_base(other_plots_tab,$
                              uname='signal_region_tab_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

signal_region_draw = widget_draw(signal_region_tab_base,$
                                 uname='signal_region_draw',$
                                 xoffset=2,$
                                 yoffset=2,$
                                 scr_xsize=710,$
                                 scr_ysize=383)

;background summed TOF plot
background_summed_tof_tab_base = widget_base(other_plots_tab,$
                              uname='background_summed_tof_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

background_summed_tof_draw = widget_draw(background_summed_tof_tab_base,$
                                         uname='background_summed_tof_draw',$
                                         xoffset=2,$
                                         yoffset=2,$
                                         scr_xsize=710,$
                                         scr_ysize=383)

; ;signal region summed tof plot
; signal_region_summed_tof_tab_base = widget_base(other_plots_tab,$
;                               uname='signal_region_summed_tof_base',$
;                               TITLE='',$
;                               XOFFSET=0,$
;                               YOFFSET=0)

; signal_region_summed_tof_draw = widget_draw(signal_region_summed_tof_tab_base,$
;                                             uname='signal_region_summed_tof_draw',$
;                                             xoffset=2,$
;                                             yoffset=2,$
;                                             scr_xsize=710,$
;                                             scr_ysize=383)

;normalization region summed tof plot
normalization_region_summed_tof_tab_base = widget_base(other_plots_tab,$
                              uname='normalization_region_summed_tof_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

normalization_region_summed_tof_draw = widget_draw(normalization_region_summed_tof_tab_base,$
                                                   uname='normalization_region_summed_tof_draw',$
                                                   xoffset=2,$
                                                   yoffset=2,$
                                                   scr_xsize=710,$
                                                   scr_ysize=383)

;background region from normalization summed tof
background_region_from_normalization_region_summed_tof_tab_base = widget_base(other_plots_tab,$
                              uname='background_region_from_normalization_region_summed_tof_base',$
                              TITLE='',$
                              XOFFSET=0,$
                              YOFFSET=0)

background_region_from_normalization_region_summed_tof_draw = widget_draw($
                              background_region_from_normalization_region_summed_tof_tab_base,$
                              uname='background_region_from_normalization_region_summed_tof_draw',$
                              xoffset=2,$
                              yoffset=2,$
                              scr_xsize=710,$
                              scr_ysize=383)

;log book tab
log_book_base = widget_base(data_reduction_tab,$
                         uname='log_book_base',$
                         TITLE='Log book',$
                         XOFFSET=0,$
                         YOFFSET=0)

log_book_text_REF_M = widget_text(log_book_base,$
                            uname='log_book_text',$
                            scr_xsize=720,$
                            scr_ysize=395,$
                            xoffset=5,$
                            yoffset=5,$
                            /scroll,$
                            /wrap)

FILE_MENU_REF_M = Widget_Button(WID_BASE_0_MBAR, $
                                  UNAME='FILE_MENU_REF_M',$
                                  /MENU,$
                                  VALUE='MENU')

CTOOL_MENU = Widget_Button(FILE_MENU_REF_M, UNAME='CTOOL_MENU'  $
                                 ,VALUE='Color Tool...')


EXIT_MENU_REF_M = Widget_Button(FILE_MENU_REF_M, UNAME='EXIT_MENU_REF_M'  $
                                ,VALUE='Exit')


Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end









;
; Empty stub procedure used for autoloading.
;
pro data_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
   PORTAL_BASE, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra    ;REMOVE_COMMENTS
;wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, 0, "j35"     ;REMOVE_ME
end





