pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='PORTAL_BASE'): begin
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='idl_tool_droplist'): begin
        idl_tool_droplist_cb, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='IDL_GO'): begin
       idl_go, Event
       end

;    Widget_Info(wWidget, FIND_BY_UNAME=$
;                'OPEN_HISTO_EVENT_FILE_BUTTON_tab1'): begin
;        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
;          OPEN_HISTO_EVENT_FILE_CB, Event
;    end
    

    Widget_Info(wWidget, FIND_BY_UNAME='PORTAL_GO'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          id=widget_info(Event.top,FIND_BY_UNAME='INSTRUMENT_TYPE_GROUP')
        WIDGET_control, id, GET_VALUE=instrument
        
        id=widget_info(Event.top,FIND_BY_UNAME='USER_TEXT')
        WIDGET_control, id, GET_VALUE=user
        
        CASE instrument OF
            0: print, "portal_value= ", instrument
            1: print, "portal_value= ", instrument
            2: print, "portal_value= ", instrument
        ENDCASE
        
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

Resolve_Routine, 'main_interface_eventcb',/COMPILE_FULL_FILE

global = ptr_new({$
                   active_idl_tool : '',$
                   host : '',$
                   tmp_nxdir_folder : 'makeNeXus_tmp',$
                   full_tmp_nxdir_folder_path : ''$
})


;comamnd to find name of host
cd_host = "/bin/hostname -s"
spawn, cd_host, host

(*global).host = host

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME='MAIN_BASE',$
                         SCR_XSIZE=665,$
                         SCR_YSIZE=310,$
                         XOFFSET=250,$
                         YOFFSET=50,$
                         NOTIFY_REALIZE='MAIN_REALIZE',$
                         TITLE='MAIN IDL INTERFACE',$
                         SPACE=3,$
                         XPAD=3,$
                         YPAD=3,$
                         MBAR=WID_BASE_0_MBAR)

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

PORTAL_BASE= widget_base(MAIN_BASE, $
                         UNAME='PORTAL_BASE',$
                         SCR_XSIZE=240, $
                         SCR_YSIZE=80, $
                         FRAME=10,$
                         SPACE=4,$
                         XPAD=3,$
                         YPAD=3)

PORTAL_LABEL = widget_label(PORTAL_BASE,$
                            XOFFSET=50,$
                            YOFFSET=3,$
                            VALUE="Select your IDL tool")

IDL_tool_list = ['                      ',$
                 'miniReflPak',$
                 'PlotBSS',$
                 'RealignBSS',$
                 'rebinNeXus']
IDL_tool_droplist = widget_droplist(PORTAL_BASE,$
                                    xoffset=20,$
                                    yoffset=25,$
                                    /dynamic_resize,$
                                    value=IDL_tool_list,$
                                    uname='idl_tool_droplist')

INFO_TITLE = widget_label(MAIN_BASE,$
                          uname='info_title',$
                          xoffset=8,$
                          yoffset=102,$
                          value='Description of tool')

INFO_BASE = widget_base(MAIN_BASE,$
                        UNAME="INFO_BASE",$
                        SCR_XSIZE=250,$
                        SCR_YSIZE=150,$
                        XOFFSET=5,$
                        YOFFSET=110,$
                        FRAME=1,$
                        SPACE=4, $
                        XPAD=3, YPAD=3)

INFO_description = widget_text(INFO_BASE,$
                               uname='info_description',$
                               scr_xsize=240,$
                               scr_ysize=130,$
                               xoffset=5,$
                               yoffset=10,$
                               /wrap,$
                               /scroll,$
                               value='')

IDL_GO = widget_button(MAIN_BASE,$
                       XOFFSET=7,$
                       YOFFSET=270,$
                       SCR_XSIZE=250,$
                       SCR_YSIZE=30,$
                       UNAME="IDL_GO",$
                       VALUE="LAUNCH APPLICATION",$
                       tooltip="Press to launch selected application",$
                      sensitive=0)

SCREEN_SHOT_BASE = widget_base(main_base,$
                               xoffset=265,$
                               yoffset=5,$
                               scr_xsize=390,$
                               scr_ysize=295,$
                               frame=1)

screen_shot_draw = widget_draw(SCREEN_SHOT_BASE,$
                               xoffset=0,$
                               yoffset=0,$
                               scr_xsize=388,$
                               scr_ysize=293)

  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro main_interface, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
   PORTAL_BASE, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
