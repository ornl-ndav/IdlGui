;==============================================================================
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
;==============================================================================

;This function checks if the user wants to overwrite the geometry or
;not and activate the gui accordingly
PRO GeometryGroupInteraction, Event 
value_OF_group = getCWBgroupValue(Event, 'overwrite_geometry_group')
IF (value_OF_group EQ 0) THEN BEGIN
    map_gui = 1
ENDIF ELSE BEGIN
    map_gui = 0
ENDELSE
map_base, Event, 'overwrite_geometry_base', map_gui
END

;------------------------------------------------------------------------------
;This function is reached by the browse button of the overwrite
;geometry
PRO BrowseGeometry, Event
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global
;retrieve global paramters
extension = (*global).geo_extension
filter    = (*global).geo_filter
path      = (*global).geo_path
title     = 'Please select a new Geometry file'

IDLsendToGeek_addLogBookText, Event, '> Selecting a new Geometry File :'

FullNexusName = BrowseRunNumber(Event, $       ;IDLloadNexus__define
                                extension, $
                                filter, $
                                title,$
                                GET_PATH=new_path,$
                                path)

IF (FullNexusName NE '') THEN BEGIN
;change default path
    (*global).geo_path = new_path
;put the full name of the new geometry file in the browsing button
    putNewButtonValue, Event, 'overwrite_geometry_button', FullNexusName
;put name of geoemetry file in the log book
    IDLsendToGeek_addLogBookText, Event, '-> New geometry file is : ' + $
      FullNexusName
    (*global).inst_geom = FullNexusName
ENDIF ELSE BEGIN
;display name of nexus file name
    putTab1NexusFileName, Event, ''
    message = '-> No new geometry file selected'
    IDLsendToGeek_addLogBookText, Event, message
ENDELSE    
END

;------------------------------------------------------------------------------
;This procedure is reached each time the user changes the ON/OFF
;switch of the min Lambda Cut Off
PRO min_lambda_cut_off_gui, Event
value_OF_group = getCWBgroupValue(Event, 'minimum_lambda_cut_off_group')
IF (value_OF_group EQ 0) THEN BEGIN
    sensitive_status = 1
ENDIF ELSE BEGIN
    sensitive_status = 0
ENDELSE
activate_widget, Event, 'minimum_lambda_cut_off_value', sensitive_status
END

;------------------------------------------------------------------------------
;This procedure is reached each time the user changes the ON/OFF
;switch of the max Lambda Cut Off
PRO max_lambda_cut_off_gui, Event
value_OF_group = getCWBgroupValue(Event, 'maximum_lambda_cut_off_group')
IF (value_OF_group EQ 0) THEN BEGIN
    sensitive_status = 1
ENDIF ELSE BEGIN
    sensitive_status = 0
ENDELSE
activate_widget, Event, 'maximum_lambda_cut_off_value', sensitive_status
END

;------------------------------------------------------------------------------
;This procedure is reached each time the user changes the ON/OFF
;switch of the monitor efficiency
PRO monitor_efficiency_constant_gui, Event
value_OF_group = getCWBgroupValue(Event,'monitor_efficiency_group')
IF (value_OF_group EQ 0) THEN BEGIN
    sensitive_status = 1
ENDIF ELSE BEGIN
    sensitive_status = 0
ENDELSE
activate_widget, Event, 'monitor_efficiency_constant_label', sensitive_status
activate_widget, Event, 'monitor_efficiency_constant_value', sensitive_status
END

;------------------------------------------------------------------------------
;This procedure is reached each time the user changes the YES/NO
;switch of the scaling constant
PRO scaling_constant_gui, Event 
value_OF_group = getCWBgroupValue(Event,'scaling_constant_group')
IF (value_OF_group EQ 0) THEN BEGIN
    sensitive_status = 1
ENDIF ELSE BEGIN
    sensitive_status = 0
ENDELSE
activate_widget, Event, 'scaling_constant_label', sensitive_status
activate_widget, Event, 'scaling_constant_value', sensitive_status

END
