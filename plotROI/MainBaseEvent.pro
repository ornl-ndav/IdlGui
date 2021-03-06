PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;1111111111111111111111111111111111111111111111111111111111111111111111111111111

;#### Instrument Droplist ###
    widget_info(wWidget, FIND_BY_UNAME='list_of_instrument'): BEGIN
        ListOfInstrument, Event ;_eventcb
        ValidatePlotButton, Event ;_GUI
    END

;##### NeXus Run Number ####
    widget_info(wWidget, FIND_BY_UNAME='nexus_run_number'): BEGIN
        LoadRunNumber, Event ;_Load
        PopulateNumberOfBanks, Event ;_GUI
        ValidatePlotButton, Event ;_GUI
    END

;#### Nexus Run Number Clear button ####
    widget_info(wWidget, FIND_BY_UNAME='clear_nexus_run_number'): BEGIN
        ClearTextField, Event, 'nexus_run_number' ;_Gui
        ValidatePlotButton, Event ;_Gui
    END

;#### Browse Nexus File ####
    widget_info(wWidget, FIND_BY_UNAME='browse_nexus'): BEGIN
        BrowseNexusFile, Event ;_eventcb
        PopulateNumberOfBanks, Event ;_GUI
        ValidatePlotButton, Event ;_GUI
    END

;#### Nexus File Text Field
    widget_info(wWidget, FIND_BY_UNAME='nexus_file_text_field'): BEGIN
        PopulateNumberOfBanks, Event ;_GUI
        ValidatePlotButton, Event ;_GUI
    END

;#### Nexus File Text Field Clear button ####
    widget_info(wWidget, FIND_BY_UNAME='clear_nexus_file_text_field'): BEGIN
        ClearTextField, Event, 'nexus_file_text_field' ;_Gui
        ValidatePlotButton, Event ;_Gui
    END

;#### Browse Roi file ####
    widget_info(wWidget, FIND_BY_UNAME='browse_roi_button'): BEGIN
        BrowseRoiFile, Event  ;_eventcb
        ValidatePreviewButton, Event ;_GUI
    END

;#### Roi file Text Field ####
    widget_info(wWidget, FIND_BY_UNAME='roi_text_field'): BEGIN
        ValidatePreviewButton, Event  ;_GUI
    END

;#### ROI Text Field Clear button ####
    widget_info(wWidget, FIND_BY_UNAME='clear_roi_text_field'): BEGIN
        ClearTextField, Event, 'roi_text_field' ;_Gui
        ValidatePreviewButton, Event  ;_GUI
    END

;#### Roi Preview Button ####
    widget_info(wWidget, FIND_BY_UNAME='preview_roi_button'): BEGIN
        PreviewRoiFile, Event ;_eventcb
    END

;#### Bank Droplist ####
    widget_info(wWidget, FIND_BY_UNAME='bank_droplist'): BEGIN
        DisplayBankSelected, Event   ;_eventcb
    END
    
;#### PLOT button ####
    widget_info(wWidget, FIND_BY_UNAME='plot_button'): BEGIN
        PlotData, Event ;_Plot
    END

;#### Send To Geek ####
    widget_info(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
        SendToGeek, Event ;IDLsendToGeek__define
    END
    
    ELSE:
    
ENDCASE

END
