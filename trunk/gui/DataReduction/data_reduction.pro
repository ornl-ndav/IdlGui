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
            
            id=widget_info(Event.top,FIND_BY_UNAME='USER_TEXT')
            WIDGET_control, id, GET_VALUE=user
            
            if (check_access(Event, instrument, user) NE -1) then begin
                id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
                WIDGET_CONTROL, id, /destroy
                wTLB, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_, instrument, user
            endif else begin
                access = "!ACCESS!"
                denied = "!DENIED!"		
                id=widget_info(Event.top,FIND_BY_UNAME='LEFT_TOP_ACCESS_DENIED')
                WIDGET_control, id, set_value=access
                id=widget_info(Event.top,FIND_BY_UNAME='LEFT_BOTTOM_ACCESS_DENIED')
                WIDGET_control, id, set_value=denied
                id=widget_info(Event.top,FIND_BY_UNAME='RIGHT_TOP_ACCESS_DENIED')
                WIDGET_control, id, set_value=access
                id=widget_info(Event.top,FIND_BY_UNAME='RIGHT_BOTTOM_ACCESS_DENIED')
                WIDGET_control, id, set_value=denied
                id=widget_info(Event.top,FIND_BY_UNAME="USER_TEXT")
                WIDGET_control, id, set_value=""
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

USER_BASE = widget_base(MAIN_BASE,$
                        UNAME="USER_BASE",$
                        SCR_XSIZE=265,$
                        SCR_YSIZE=70,$
                        XOFFSET=0,$
                        YOFFSET=110,$
                        FRAME=10,$
                        SPACE=4,$
                        XPAD=3,$
                        YPAD=3)

USER_LABEL = Widget_label(USER_BASE,$
                          XOFFSET=65,$
                          YOFFSET=3,$
                          VALUE="ENTER YOUR UCAMS")

USER_TEXT = widget_text(USER_BASE,$
                        UNAME='USER_TEXT',$
                        XOFFSET=90,$
                        YOFFSET=25,$
                        SCR_XSIZE=40,$
                        SCR_YSIZE=35,$
                        VALUE='',$
                        /EDITABLE,$
                        /ALL_EVENTS)

LEFT_TOP_ACCESS_DENIED = widget_label(USER_BASE,$
                                      UNAME='LEFT_TOP_ACCESS_DENIED',$
                                      XOFFSET=5,$
                                      YOFFSET=20,$
                                      SCR_XSIZE=80,$
                                      SCR_YSIZE=25,$
                                      VALUE="")

LEFT_BOTTOM_ACCESS_DENIED = widget_label(USER_BASE,$
                                         UNAME='LEFT_BOTTOM_ACCESS_DENIED',$
                                         XOFFSET=5,$
                                         YOFFSET=40,$
                                         SCR_XSIZE=80,$
                                         SCR_YSIZE=25,$
                                         VALUE="")

RIGHT_TOP_ACCESS_DENIED = widget_label(USER_BASE,$
                                       UNAME='RIGHT_TOP_ACCESS_DENIED',$
                                       XOFFSET=135,$
                                       YOFFSET=20,$	
                                       SCR_XSIZE=80,$
                                       SCR_YSIZE=25,$
                                       VALUE="")

RIGHT_BOTTOM_ACCESS_DENIED = widget_label(USER_BASE,$
                                          UNAME='RIGHT_BOTTOM_ACCESS_DENIED',$
                                          XOFFSET=135,$
                                          YOFFSET=40,$	
                                          SCR_XSIZE=80,$
                                          SCR_YSIZE=25,$
                                          VALUE="")

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
                         SCR_XSIZE=500,$
                         SCR_YSIZE=500,$
                         XOFFSET=250,$
                         YOFFSET=22,$
                         NOTIFY_REALIZE='MAIN_REALIZE',$
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
                                 scr_ysize=50,$
                                 frame=1)
selection_list = ['Signal',$
                  'Background']

selection_list_group = CW_BGROUP(MAIN_BASE,$ 
                                  selection_list,$
                                  /exclusive,$
                                  /RETURN_NAME,$
                                  XOFFSET=5,$
                                  YOFFSET=5,$
                                  SET_VALUE=0.0,$
                                  UNAME='selection_list_group')




Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro data_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
;   PORTAL_BASE, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra    ;REMOVE_COMMENTS
wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, 0, "j35"     ;REMOVE_ME
end
