PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;#1### Instrument Selection #####
;Instrument Selection
    widget_info(wWidget, FIND_BY_UNAME='instrument_droplist'): begin
        ggEventcb_InstrumentSelection, Event ;in gg_eventcb.pro
        putGeometryFileInDroplist, Event ;in gg_put.pro
        putSelectedGeometryFileInTextField, Event ;in gg_eventcb.pro
        populateNameOfOutputFile, Event, 'run' ;in gg_eventcb.pro
        clearCvinfoBase, Event ;in gg_eventcb.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
    end
    
;geometry file selection droplist
    widget_info(wWidget, FIND_BY_UNAME='geometry_droplist'): begin
        putSelectedGeometryFileInTextField, Event ;in gg_eventcb.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
    end

;#1### geometry.xml #####
;Browsing
    widget_info(wWidget, FIND_BY_UNAME='geometry_browse_button'): begin
        gg_Browse, Event, 'geometry' ;in gg_Browse.pro
        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro	
    end
    
;#1### geometry.xml #####
;Preview of geometry.xml
    widget_info(wWidget, FIND_BY_UNAME='geometry_preview'): begin
        gg_Preview, Event, 'geometry' ;in gg_Preview.pro
    end
    
;#1### geometry.xml #####
;geometry.xml text field
    widget_info(wWidget, FIND_BY_UNAME='geometry_text_field'): begin
        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
    end
    
;#1### cvinfo.xml #####
;run number
    widget_info(wWidget, FIND_BY_UNAME='cvinfo_run_number_field'): begin
        retrieve_cvinfo_file_name, Event ;in gg_eventcb.pro
        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
        populateNameOfOutputFile, Event, 'run' ;in gg_eventcb.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
    end
    
;Browsing
    widget_info(wWidget, FIND_BY_UNAME='cvinfo_browse_button'): begin
        gg_Browse, Event, 'cvinfo' ;in gg_Browse.pro
        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
        populateNameOfOutputFile, Event, 'run' ;in gg_eventcb.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
    end
    
;#1### cvinfo.xml #####
;Preview of cvinfo.xml
    widget_info(wWidget, FIND_BY_UNAME='cvinfo_preview'): begin
        gg_Preview, Event, 'cvinfo' ;in gg_Preview.pro
    end
    
;#1### cvinfo.xml #####
;cvinfo.xml text field
    widget_info(wWidget, FIND_BY_UNAME='cvinfo_text_field'): begin
;        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
    end

;#Geometry Name Generator
;Auto name generator without date
    widget_info(wWidget, FIND_BY_UNAME='auto_name_with_run_button'): begin
        sensitive_widget, Event, 'auto_name_with_run_button' , 0
        sensitive_widget, Event, 'auto_name_with_time_button', 1
        populateNameOfOutputFile, Event, 'run' ;in gg_eventcb.pro
    END

;Auto name generator with date
    widget_info(wWidget, FIND_BY_UNAME='auto_name_with_time_button'): begin
        sensitive_widget, Event, 'auto_name_with_run_button' , 1
        sensitive_widget, Event, 'auto_name_with_time_button', 0
        populateNameOfOutputFile, Event, 'time' ;in gg_eventcb.pro
    END

;Geometry path 
    widget_info(wWidget, FIND_BY_UNAME='geo_path_button'): begin
        determine_Geometry_path, Event ;in gg_eventcb.pro
    END

;Geometry path text field
    widget_info(wWidget, FIND_BY_UNAME='geo_path_text_field'): BEGIN
        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
    END
    
;#1### LOADING GEOMETRY button
    widget_info(wWidget, FIND_BY_UNAME='loading_geometry_button'): begin
        load_geometry, Event ;in gg_eventcb.pro
    end
    
    ELSE:
    
ENDCASE

END
