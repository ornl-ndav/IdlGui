pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
;    Widget_Info(wWidget, FIND_BY_UNAME='open_nexus_button'): begin
;        open_nexus_cb, Event
;    end
    
else:
    
endcase

end



pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user


Resolve_Routine, 'refl_support_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

;working_path = '/SNS/users/' + user + '/local/more_nexus/'

global = ptr_new({  $
                   Ntof			: 0L$
;                   img_ptr 		: ptr_new(0L),$
                 })

; Create the top-level base and the tab.
title = "REF_L SUPPORT - CRITICAL EDGES PROGRAM"

;def of parameters used for positioning and sizing widgets
;[xoff,yoff,width,height]

MainBaseSize = [150, 150, 1200, 600]


MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, $
                        UNAME='MAIN_BASE',$
                        XOFFSET=MainBaseSize[0],$
                        YOFFSET=MainBaseSize[1],$
                        SCR_XSIZE=MainBaseSize[2], $
                        SCR_YSIZE=MainBaseSize[3], $
                        title=title,$
                        MBAR=WID_BASE_0_MBAR)



;Realize the widgets, set the user value of the top-level
;base, and call XMANAGER to manage everything.
WIDGET_CONTROL, MAIN_BASE, /REALIZE
WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global ;we've used global, not stash as the structure name
XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro refl_support, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
wTLB, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
