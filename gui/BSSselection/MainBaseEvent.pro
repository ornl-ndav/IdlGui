PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

;cw_field run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number'): begin
        bss_selection_LoadNexus, Event
    end

;BROWSE button run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number_button'): begin
        bss_selection_BrowseNexus, Event
    end
    
;counts vs tof draw
    widget_info(wWidget, FIND_BY_UNAME='counts_vs_tof_draw'): begin
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded

            if (Event.release EQ 1) then begin ;mouse released
                BSSselection_ZoomInCountsVsTofReleased, Event
            endif
            
            if (Event.press EQ 1) then begin ;mouse pressed
                if (Event.type EQ 0 ) then begin ;left click
                    BSSselection_ZoomInCountsVsTofPressed, Event
                endif
                
            endif

          endif
            
        end
    
;bank1 widget_draw
    widget_info(wWidget, FIND_BY_UNAME='top_bank_draw'): begin
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
            BSSselection_DisplayXYBankPixelInfo, Event, 'bank1'
            if( Event.type EQ 0 )then begin
            if (Event.press EQ 1) then $ ;left click
              BSSselection_DisplayCountsVsTof, Event
;              if 
;            if ((Event.press EQ 4) then $ ;right click
;            endif
;            if (Event.type EQ 1) then $ ;release
;              if (Event.type EQ 2) then $ ;move
;              endif
            endif
        endif
    end
    
;bank2 widget_draw
    widget_info(wWidget, FIND_BY_UNAME='bottom_bank_draw'): begin
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
            BSSselection_DisplayXYBankPixelInfo, Event, 'bank2'
            if( Event.type EQ 0 )then begin
            if (Event.press EQ 1) then $ ;left click
              BSSselection_DisplayCountsVsTof, Event
;              if 
;            (Event.press EQ 4) then $ ;right click
;            endif
;            if (Event.type EQ 1) then $ ;release
;              if (Event.type EQ 2) then $ ;move
;              endif
            endif
        endif
    end
    
    ELSE:
    
ENDCASE

END
