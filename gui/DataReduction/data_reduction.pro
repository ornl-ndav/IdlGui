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

;Widget to change the color of graph for REF_L
        Widget_Info(wWidget, FIND_BY_UNAME='CTOOL_MENU_REF_L'): begin
            if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
              CTOOL_REF_L, Event
        end
        
;signal or background selection zone for REF_L
    widget_info(wWidget, FIND_BY_UNAME='selection_list_group'): begin
        selection_list_group_cb, Event
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

    widget_info(wWidget, FIND_BY_UNAME='background_list_group'): begin
        background_list_group_eventcb, Event
    end
;intermediate file output for REF_L
    widget_info(wWidget, FIND_BY_UNAME='intermediate_file_output_list_group'):begin
        intermediate_file_output_list_group_eventcb,Event
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
                                  SET_VALUE=1.0,$          ;REMOVE_ME, put 0.0 back
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
                         SCR_YSIZE=450,$
                         XOFFSET=250,$
                         YOFFSET=22,$
                         NOTIFY_REALIZE='MAIN_REALIZE_data_reduction',$
                         TITLE='Data Reduction GUI for REF_L',$
                         SPACE=3,$
                         XPAD=3,$
                         YPAD=3,$
                         MBAR=WID_BASE_0_MBAR)
global = ptr_new({$
                   ct                   : 5,$
                   pass                 : 0,$
                   data_assoc		: ptr_new(0L),$
                   file_opened          : 0,$
                   find_nexus           : 0L,$
                   full_histo_mapped_name : '',$
                   full_nexus_name      : '',$
                   img_ptr 		: ptr_new(0L),$
                   instrument		: instrument_list[instrument],$
                   nexus_file_name_only : '',$
                   Nx                   : 0L,$
                   Ny                   : 0L,$
                   Ntof                 : 0L,$
                   output_path		: '/SNSlocal/users/',$
                   run_number		: '',$
                   selection_value      : 0,$
                   selection_signal     : 0,$
                   selection_background : 0,$
                   tmp_folder           : '',$
                   tmp_working_path     : '.tmp_data_reduction',$
                   ucams                : user,$
                   x1_back              : 0L,$
                   x2_back              : 0L,$
                   y1_back              : 0L,$
                   y2_back              : 0L,$
                   x1_signal            : 0L,$
                   x2_signal            : 0L,$
                   y1_signal            : 0L,$
                   y2_signal            : 0L,$
                   color_line_signal    : 100L,$
                   color_line_background: 300L $
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
                                   uname='nexus_run_number_box')
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
                                /BUTTON_EVENTS,/MOTION_EVENTS)

;SELECT SIGNAL and BACKGROUND INTERFACE
select_signal_base = widget_base(MAIN_BASE,$
                                 xoffset=5,$
                                 yoffset=360,$
                                 scr_xsize=253,$
                                 scr_ysize=70,$
                                 frame=1)
selection_title = widget_label(select_signal_base,$
                               xoffset=5,$
                               yoffset=9,$
                               value='Selection: ')
selection_list = ['Signal',$
                  'Background']
selection_list_group = CW_BGROUP(select_signal_base,$ 
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
                                location=0,$
                                xoffset=0,$
                                yoffset=0,$
                                scr_xsize=xsize_of_tabs,$
                                scr_ysize=ysize_of_tabs)
  
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
                                      value='Signal Pid file')
signal_pid_file_text = widget_text(data_reduction_base,$
                                   uname='signal_pid_file_text',$
                                   xoffset=110,$
                                   yoffset=5,$
                                   scr_xsize=190,$
                                   value='',$
                                   /align_left,$
                                   /editable)
background_title = widget_label(data_reduction_base,$
                                xoffset=8,$
                                yoffset=47,$
                                value='Background:')
background_list = ['Yes',$
                  'No']
background_list_group = CW_BGROUP(data_reduction_base,$ 
                                  background_list,$
                                  /exclusive,$
                                  /RETURN_NAME,$
                                  XOFFSET=100,$
                                  YOFFSET=40,$
                                  SET_VALUE=0.0,$
                                  row=1,$
                                  uname='background_list_group')

background_file_base = widget_base(data_reduction_base,$
                                   uname='background_file_base',$
                                   xoffset=0,$
                                   yoffset=75,$
                                   scr_xsize=xsize_of_tabs,$
                                   scr_ysize=40,$
                                   frame=0)

background_file_button = widget_button(background_file_base,$
                                       uname='background_file_button',$
                                       xoffset=5,$
                                       yoffset=7,$
                                       value='Background file')

background_file_text = widget_text(background_file_base,$
                                   uname='background_file_text',$
                                   xoffset=110,$
                                   yoffset=5,$
                                   scr_xsize=190,$
                                   value='',$
                                   /align_left,$
                                   /editable)

normalization_label = widget_label(data_reduction_base,$
                                   xoffset=5,$
                                   yoffset=130,$
                                   value='Normalization - Run number:')
normalization_text = widget_text(data_reduction_base,$
                                 xoffset=180,$
                                 yoffset=123,$
                                 scr_xsize=120,$
                                 value='',$
                                 uname='normalization_text',$
                                /editable,$
                                /align_left)

runs_to_process_label = widget_label(data_reduction_base,$
                                     xoffset=5,$
                                     yoffset=172,$
                                     value='Runs #')
runs_to_process_text = widget_text(data_reduction_base,$
                                   xoffset=50,$
                                   yoffset=165,$
                                   scr_xsize=250,$
                                   value='',$
                                   uname='runs_to_process_text',$
                                   /editable,$
                                   /align_left)

intermediate_file_label = widget_label(data_reduction_base,$
                                       xoffset=5,$
                                       yoffset=206,$
                                       value='Intermediate file output:')

intermediate_file_output_list = ['Yes',$
                                 'No']
intermediate_file_output_list_group = CW_BGROUP(data_reduction_base,$ 
                                                intermediate_file_output_list,$
                                                /exclusive,$
                                                /RETURN_NAME,$
                                                XOFFSET=170,$
                                                YOFFSET=200,$
                                                SET_VALUE=1.0,$
                                                row=1,$
                                                uname='intermediate_file_output_list_group')

start_data_reduction_button = widget_button(data_reduction_base,$
                                            xoffset=5,$
                                            yoffset=232,$
                                            scr_xsize=295,$
                                            value='START DATA REDUCTION',$
                                            uname='start_data_reduction_button')

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


;selection boxes info tab
fourth_tab_base = widget_base(data_reduction_tab,$
                                  uname='fourth_tab_base',$
                                  TITLE='Selection infos',$
                                  XOFFSET=0,$
                                  YOFFSET=0)

signal_info_label = widget_label(fourth_tab_base,$
                                 value='S I G N A L',$
                                 xoffset=150,$
                                 yoffset=5)

signal_info = widget_text(fourth_tab_base,$
                          uname='signal_info',$
                          xoffset=5,$
                          yoffset=25,$
                          scr_xsize=350,$
                          scr_ysize=375,$
                          /wrap,$
                         /scroll)

background_info_label = widget_label(fourth_tab_base,$
                                     value='B A C K G R O U N D',$
                                     xoffset=500,$
                                     yoffset=5)

background_info = widget_text(fourth_tab_base,$
                              uname='background_info',$
                              xoffset=370,$
                              yoffset=25,$
                              scr_xsize=350,$
                              scr_ysize=375,$
                              /wrap,$
                             /scroll)

;other plots tab
other_plots_base = widget_base(data_reduction_tab,$
                               uname='other_plots_base',$
                               TITLE='Extra plots',$
                               XOFFSET=0,$
                               YOFFSET=0)


FILE_MENU_REF_L = Widget_Button(WID_BASE_0_MBAR, $
                                  UNAME='FILE_MENU_REF_L',$
                                  /MENU,$
                                  VALUE='MENU')

CTOOL_MENU_REF_L = Widget_Button(FILE_MENU_REF_L, UNAME='CTOOL_MENU_REF_L'  $
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
                         SCR_XSIZE=1200,$
                         SCR_YSIZE=450,$
                         XOFFSET=250,$
                         YOFFSET=22,$
                         NOTIFY_REALIZE='MAIN_REALIZE_data_reduction',$
                         TITLE='Data Reduction GUI for REF_M',$
                         SPACE=3,$
                         XPAD=3,$
                         YPAD=3,$
                         MBAR=WID_BASE_0_MBAR)
global = ptr_new({$
                   ct                   : 5,$
                   pass                 : 0,$
                   data_assoc		: ptr_new(0L),$
                   file_opened          : 0,$
                   find_nexus           : 0L,$
                   full_histo_mapped_name : '',$
                   full_nexus_name      : '',$
                   img_ptr 		: ptr_new(0L),$
                   instrument		: instrument_list[instrument],$
                   nexus_file_name_only : '',$
                   Nx                   : 0L,$
                   Ny                   : 0L,$
                   Ntof                 : 0L,$
                   output_path		: '/SNSlocal/users/',$
                   run_number		: '',$
                   selection_value      : 0,$
                   selection_signal     : 0,$
                   selection_background : 0,$
                   tmp_folder           : '',$
                   tmp_working_path     : '.tmp_data_reduction',$
                   ucams                : user,$
                   x1_back              : 0L,$
                   x2_back              : 0L,$
                   y1_back              : 0L,$
                   y2_back              : 0L,$
                   x1_signal            : 0L,$
                   x2_signal            : 0L,$
                   y1_signal            : 0L,$
                   y2_signal            : 0L,$
                   color_line_signal    : 100L,$
                   color_line_background: 300L $
                 })

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

(*global).Nx = 256L
(*global).Ny = 304L


(*global).output_path = (*global).output_path + user + "/"

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
nexus_run_number_box_REF_M = widget_text(nexus_run_number_base,$
                                   xoffset=80,$
                                   yoffset=5,$
                                   /editable,$
                                   /align_left,$
                                   scr_xsize=80,$
                                   scr_ysize=30,$
                                   uname='nexus_run_number_box_REF_M')
nexus_run_number_go_REF_M = widget_button(nexus_run_number_base,$
                                    xoffset=180,$
                                    yoffset=7,$
                                    scr_xsize=100,$
                                    value='O P E N',$
                                    uname='nexus_run_number_go_REF_M')

;BOTTOM LEFT BOX - DISPLAY DATA
display_data_base_REF_M = widget_draw(MAIN_BASE,$
                                xoffset=5,$
                                yoffset=70,$  
                                scr_xsize=304,$
                                scr_ysize=256,$
                                uname='display_data_base_REF_M',$
                                retain=2,$
                                /BUTTON_EVENTS,/MOTION_EVENTS)


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
                               value='Selection: ')
selection_list = ['Signal   ',$
                  'Background']
selection_list_group_REF_M = CW_BGROUP(select_signal_base,$ 
                                 selection_list,$
                                 /exclusive,$
                                 /RETURN_NAME,$
                                 XOFFSET=100,$
                                 YOFFSET=3,$
                                 SET_VALUE=0.0,$
                                 row=1,$
                                 UNAME='selection_list_group_REF_M')

clear_selection_button_REF_M = widget_button(select_signal_base,$
                                       uname='clear_selection_button_REF_M',$
                                       xoffset=15,$
                                       yoffset=35,$
                                       scr_xsize=120,$
                                       value='CLEAR SELECTION',$
                                       sensitive=0)
save_selection_button_REF_M = widget_button(select_signal_base,$
                                      uname='save_selection_button_REF_M',$
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
                                location=0,$
                                xoffset=0,$
                                yoffset=0,$
                                scr_xsize=xsize_of_tabs,$
                                scr_ysize=ysize_of_tabs)
  
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

signal_pid_file_button_REF_M = widget_button(data_reduction_base,$
                                      uname='signal_pid_file_button_REF_M',$
                                      xoffset=5,$
                                      yoffset=7,$
                                      value='Signal Pid file')
signal_pid_file_text_REF_M = widget_text(data_reduction_base,$
                                   uname='signal_pid_file_text_REF_M',$
                                   xoffset=110,$
                                   yoffset=5,$
                                   scr_xsize=190,$
                                   value='',$
                                   /align_left,$
                                   /editable)
background_title = widget_label(data_reduction_base,$
                                xoffset=8,$
                                yoffset=47,$
                                value='Background:')
background_list = ['Yes',$
                  'No']
background_list_group_REF_M = CW_BGROUP(data_reduction_base,$ 
                                  background_list,$
                                  /exclusive,$
                                  /RETURN_NAME,$
                                  XOFFSET=100,$
                                  YOFFSET=40,$
                                  SET_VALUE=0.0,$
                                  row=1,$
                                  uname='background_list_group_REF_M')

background_file_base = widget_base(data_reduction_base,$
                                   uname='background_file_base',$
                                   xoffset=0,$
                                   yoffset=75,$
                                   scr_xsize=xsize_of_tabs,$
                                   scr_ysize=40,$
                                   frame=0)

background_file_button_REF_M = widget_button(background_file_base,$
                                       uname='background_file_button_REF_M',$
                                       xoffset=5,$
                                       yoffset=7,$
                                       value='Background file')

background_file_text_REF_M = widget_text(background_file_base,$
                                   uname='background_file_text_REF_M',$
                                   xoffset=110,$
                                   yoffset=5,$
                                   scr_xsize=190,$
                                   value='',$
                                   /align_left,$
                                   /editable)

normalization_label = widget_label(data_reduction_base,$
                                   xoffset=5,$
                                   yoffset=130,$
                                   value='Normalization - Run number:')
normalization_text = widget_text(data_reduction_base,$
                                 xoffset=180,$
                                 yoffset=123,$
                                 scr_xsize=120,$
                                 value='',$
                                 uname='normalization_text',$
                                /editable,$
                                /align_left)

runs_to_process_label = widget_label(data_reduction_base,$
                                     xoffset=5,$
                                     yoffset=172,$
                                     value='Runs #')
runs_to_process_text_REF_M = widget_text(data_reduction_base,$
                                   xoffset=50,$
                                   yoffset=165,$
                                   scr_xsize=250,$
                                   value='',$
                                   uname='runs_to_process_text_REF_M',$
                                   /editable,$
                                   /align_left)

intermediate_file_label = widget_label(data_reduction_base,$
                                       xoffset=5,$
                                       yoffset=206,$
                                       value='Intermediate file output:')

intermediate_file_output_list = ['Yes',$
                                 'No']
intermediate_file_output_list_group_REF_M = CW_BGROUP(data_reduction_base,$ 
                                                intermediate_file_output_list,$
                                                /exclusive,$
                                                /RETURN_NAME,$
                                                XOFFSET=170,$
                                                YOFFSET=200,$
                                                SET_VALUE=1.0,$
                                                row=1,$
                                                uname='intermediate_file_output_list_group_REF_M')

start_data_reduction_button_REF_M = widget_button(data_reduction_base,$
                                            xoffset=5,$
                                            yoffset=232,$
                                            scr_xsize=295,$
                                            value='START DATA REDUCTION',$
                                            uname='start_data_reduction_button_REF_M')

;info text box 
info_text_REF_M = widget_text(data_reduction_base,$
                        xoffset=5,$
                        yoffset=265,$
                        scr_xsize=295,$
                        scr_ysize=120,$
                        /scroll,$
                        /wrap,$
                       uname='info_text_REF_M')

data_reduction_plot_REF_M = widget_draw(first_tab_base,$
                                  xoffset=315,$
                                  yoffset=5,$
                                  scr_xsize=405,$
                                  scr_ysize=393,$
                                  uname='data_reduction_plot_REF_M')



;log book tab
log_book_base = widget_base(data_reduction_tab,$
                         uname='log_book_base',$
                         TITLE='Log book',$
                         XOFFSET=0,$
                         YOFFSET=0)

log_book_text_REF_M = widget_text(log_book_base,$
                            uname='log_book_text_REF_M',$
                            scr_xsize=720,$
                            scr_ysize=395,$
                            xoffset=5,$
                            yoffset=5,$
                            /scroll,$
                            /wrap)


;selection boxes info tab
fourth_tab_base = widget_base(data_reduction_tab,$
                                  uname='fourth_tab_base',$
                                  TITLE='Selection infos',$
                                  XOFFSET=0,$
                                  YOFFSET=0)

signal_info_label = widget_label(fourth_tab_base,$
                                 value='S I G N A L',$
                                 xoffset=150,$
                                 yoffset=5)

signal_info_REF_M = widget_text(fourth_tab_base,$
                          uname='signal_info_REF_M',$
                          xoffset=5,$
                          yoffset=25,$
                          scr_xsize=350,$
                          scr_ysize=375,$
                          /wrap,$
                         /scroll)

background_info_label = widget_label(fourth_tab_base,$
                                     value='B A C K G R O U N D',$
                                     xoffset=500,$
                                     yoffset=5)

background_info_REF_M = widget_text(fourth_tab_base,$
                              uname='background_info_REF_M',$
                              xoffset=370,$
                              yoffset=25,$
                              scr_xsize=350,$
                              scr_ysize=375,$
                              /wrap,$
                             /scroll)

;other plots tab
other_plots_base = widget_base(data_reduction_tab,$
                               uname='other_plots_base',$
                               TITLE='Extra plots',$
                               XOFFSET=0,$
                               YOFFSET=0)


FILE_MENU_REF_M = Widget_Button(WID_BASE_0_MBAR, $
                                  UNAME='FILE_MENU_REF_M',$
                                  /MENU,$
                                  VALUE='MENU')

CTOOL_MENU_REF_M = Widget_Button(FILE_MENU_REF_M, UNAME='CTOOL_MENU_REF_M'  $
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





