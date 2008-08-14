;------------------------------------------------------------------------------
;this function is trigerred each time the user changes tab
PRO tab_event, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='main_tab')
CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
PrevTabSelect = (*global).PrevTabSelect

IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
    0: BEGIN ;step1 (reduction)
    END
    1: BEGIN ;load
        refresh_plot_scale, EVENT=Event ;_plot
    END
    2: BEGIN ;log book
        
    END
    ELSE:
    ENDCASE
    (*global).PrevTabSelect = CurrTabSelect
ENDIF
END

;------------------------------------------------------------------------------
PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
PRO ref_off_spec_eventcb, event
END

;------------------------------------------------------------------------------

