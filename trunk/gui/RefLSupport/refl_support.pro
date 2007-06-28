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


Resolve_Routine, 'more_nexus_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

;working_path = '/SNS/users/' + user + '/local/more_nexus/'

global = ptr_new({  $
                   Ntof			: 0L$
;                   img_ptr 		: ptr_new(0L),$
                 })

(*global).output_path = (*global).output_path + user + "/"
output_path = (*global).output_path 

; Create the top-level base and the tab.
title = " Output histo/event data - Check NeXus (" + (*global).instrument + ")"
MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, $
                        UNAME='MAIN_BASE', $
                        XOFFSET=150,$
                        YOFFSET=350, $
                        SCR_XSIZE=950, $
                        SCR_YSIZE=ysize, $
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
