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
               wTLB, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_, instrument, ucams
           endif else begin
               print, "access denied"
           endelse
           
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
                                  SET_VALUE=0.0,$
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

pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user

Resolve_Routine, 'data_reduction_eventcb',/COMPILE_FULL_FILE ; Load event callback routines

;define initial global values - these could be input via external file or other means

instrument_list = ['REF_L', 'REF_M']

global = ptr_new({$
                   output_path		: '/SNSlocal/users/',$
                   instrument		: instrument_list[instrument],$
                   user			: user,$
                   run_number		: '',$
                   img_ptr 		: ptr_new(0L),$
                   data_assoc		: ptr_new(0L)$
	})

case instrument OF
   0: begin 
      end
   1: begin 
      end
endcase


(*global).output_path = (*global).output_path + user + "/"

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
                                uname='display_data_base')

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
                                              value='CLEAR SELECTION')
save_selection_button = widget_button(select_signal_base,$
                                      uname='save_selection_button',$
                                      xoffset=125,$
                                      yoffset=35,$
                                      scr_xsize=120,$
                                      value='SAVE SELECTION')

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


;other plots tab
other_plots_base = widget_base(data_reduction_tab,$
                                uname='other_plots_base',$
                                TITLE='Extra plots',$
                                XOFFSET=0,$
                                YOFFSET=0)


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
                            value='',$
                            /scroll,$
                            /wrap)





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
