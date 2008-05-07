;===============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;===============================================================================

PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;1111111111111111111111111111111111111111111111111111111111111111111111111111111

;#1### Instrument Selection #####
;Instrument Selection
    widget_info(wWidget, FIND_BY_UNAME='instrument_droplist'): begin
        putGeometryFileInDroplist, Event ;in gg_put.pro
        putSelectedGeometryFileInTextField, Event ;in gg_eventcb.pro
        populateNameOfOutputFile, Event, 'run' ;in gg_eventcb.pro
        clearCvinfoBase, Event ;in gg_eventcb.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
        ggEventcb_InstrumentSelection, Event ;in gg_eventcb.pro
        gg_GuiUpdate_selectPreviewButtons, Event
    end
    
;geometry file selection droplist
    widget_info(wWidget, FIND_BY_UNAME='geometry_droplist'): begin
        putSelectedGeometryFileInTextField, Event ;in gg_eventcb.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
        gg_GuiUpdate_selectPreviewButtons, Event
    end

;#1### geometry.xml #####
;Browsing
    widget_info(wWidget, FIND_BY_UNAME='geometry_browse_button'): begin
        gg_Browse, Event, 'geometry' ;in gg_Browse.pro
        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro	
        gg_GuiUpdate_selectPreviewButtons, Event
    end
    
;#1### geometry.xml #####
;Preview of geometry.xml
    widget_info(wWidget, FIND_BY_UNAME='geometry_preview'): begin
        gg_Preview, Event, 'geometry' ;in gg_Preview.pro
        gg_previewUpdateGeoXmlTextField, Event ;in gg_Preview.pro
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
        sensitive_widget, Event, 'cvinfo_preview', 0 ;disable preview button
        sensitive_widget, Event, 'loading_geometry_button', 0 ;disable LOADING GEOMETRY
        retrieve_cvinfo_file_name, Event ;in gg_eventcb.pro
        loading_geometry_button_status, Event ;in gg_GUIupdate.pro
        populateNameOfOutputFile, Event, 'run' ;in gg_eventcb.pro
        ValidateOrNotOutputGeometryFileBase, Event ;in gg_GUIupdate.pro
        gg_GuiUpdate_selectPreviewButtons, Event
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
    
;2222222222222222222222222222222222222222222222222222222222222222222222222222222
;tree selection
    widget_info(wWidget, FIND_BY_UNAME='widget_tree_root'): begin
        root_selected, Event ;in gg_Table.pro
     end
    
   widget_info(wWidget, FIND_BY_UNAME='leaf1'): begin
       leaf_selected, Event, 'leaf1' ;in gg_Table.pro
     end
 
   widget_info(wWidget, FIND_BY_UNAME='leaf2'): begin
       leaf_selected, Event, 'leaf2' ;in gg_Table.pro
   end

   widget_info(wWidget, FIND_BY_UNAME='leaf3'): begin
       leaf_selected, Event, 'leaf3' ;in gg_Table.pro
     end

   widget_info(wWidget, FIND_BY_UNAME='leaf4'): begin
       leaf_selected, Event, 'leaf4' ;in gg_Table.pro
     end

;full reset (read xml and populate table)
    widget_info(wWidget, FIND_BY_UNAME='full_reset_button'): begin
        ReadXmlFile, Event ;in gg_ReadXml.pro
        reset_parameters, Event ;ing gg_eventcb.pro
    end

;load new base geometry (show confirm base)
    widget_info(wWidget, FIND_BY_UNAME='load_new_geometry_button'): begin
        LoadNewGeometryButton, Event ;in gg_evenctb
    end
    
;yes validate new base geometry (in confirm base)
    widget_info(wWidget, FIND_BY_UNAME='yes_confirmation_button'): begin
        YesLoadNewGeometry, Event ;in gg_evenctb
    end

;no validate new base geometry (in confirm base)
    widget_info(wWidget, FIND_BY_UNAME='no_confirmation_button'): begin
        NoLoadNewGeometry, Event ;in gg_evenctb
    end

;final result status base
    widget_info(wWidget, FIND_BY_UNAME='final_result_ok_button'): begin
        final_result_ok, Event ;in gg_evenctb

    end

;Create new geometry file
    widget_info(wWidget, FIND_BY_UNAME='create_geometry_file_button'): begin
        CreateNewGeometryFile, Event      ;in gg_evenctb
    end

;Table 
    widget_info(wWidget, FIND_BY_UNAME='table_widget'): begin
        DisplaySelectedElement, Event ;in gg_GUIupdate.pro
    end
    
;validate value change
    widget_info(wWidget, FIND_BY_UNAME='current_value_text_field'): begin
        changeValue, Event ;in gg_Table.pro
    end
    
;validate units change
    widget_info(wWidget, FIND_BY_UNAME='current_units_text_field'): begin
        changeUnits, Event ;in gg_Table.pro
    end

;validate value and units change
    widget_info(wWidget, FIND_BY_UNAME='validate_selected_element_button'): begin
        changeValueAndUnits, Event ;in gg_Table.pro
    end

;Selected element Reset
    widget_info(wWidget, FIND_BY_UNAME='reset_selected_element_button'): begin
        resetValueAndUnits, Event ;in gg_Table.pro
    end

;Error log book button (that will map the log_book_text base)
    widget_info(wWidget, FIND_BY_UNAME='final_result_error_button'): begin
        displayErrorLogBook, Event ;'in gg_ErrorLogBook.pr'
        activateMap, Event, 'error_log_book_base', 1
        ;desactivate final_result_ok_button and final_result_error_button
        sensitive_widget, Event, 'final_result_ok_button', 0
        sensitive_widget, Event, 'final_result_error_button', 0
    end

;Close error log book button (that will hide the log_book_text base)
    widget_info(wWidget, FIND_BY_UNAME='close_error_log_book_button'): begin
        activateMap, Event, 'error_log_book_base', 0
        ;activate final_result_ok_button and final_result_error_button
        sensitive_widget, Event, 'final_result_ok_button', 1
        sensitive_widget, Event, 'final_result_error_button', 1
    end
    
;4th button on the left
    widget_info(wWidget, FIND_BY_UNAME='check_error_log_button'): begin
        displayErrorLogBook, Event ;'in gg_ErrorLogBook.pro'
        activateMap, Event, 'error_log_book_base', 1
    end

    ELSE:
    
ENDCASE

END
