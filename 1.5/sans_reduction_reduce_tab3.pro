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
;This procedure is reached each time the user changes the ON/OFF
;switch of the detector efficiency
PRO detector_efficiency_constant_gui, Event
  value_OF_group = getCWBgroupValue(Event,'detector_efficiency_group')
  IF (value_OF_group EQ 0) THEN BEGIN
    sensitive_status = 1
  ENDIF ELSE BEGIN
    sensitive_status = 0
  ENDELSE
  activate_widget, Event, 'detector_efficiency_scaling_label', sensitive_status
  activate_widget, Event, 'detector_efficiency_scaling_value', sensitive_status
  activate_widget, Event, 'detector_efficiency_attenuator_value', sensitive_status
  activate_widget, Event, 'detector_efficiency_attenuator_label', sensitive_status
  activate_widget, Event, 'detector_efficiency_attenuator_units', sensitive_status
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

;------------------------------------------------------------------------------
FUNCTION isolate_coeff, file_coeff, scaling_value
  split_error = 0
  CATCH, split_error
  IF (split_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,['']
  ENDIF ELSE BEGIN
    sz = N_ELEMENTS(file_coeff)
    FOR i=0,(sz-1) DO BEGIN
      step1 = STRSPLIT(file_coeff[i],' ',/EXTRACT)
      IF (i EQ 0) THEN BEGIN
        result_array = [step1[1]]
      ENDIF ELSE BEGIN
        IF (step1[0] EQ 'Scaling') THEN BEGIN
          scaling_value = step1[2]
        ENDIF ELSE BEGIN
          result_array = [result_array,step1[1]]
        ENDELSE
      ENDELSE
    ENDFOR
  ENDELSE
  RETURN, result_array
END

;------------------------------------------------------------------------------
PRO BrowseLoadWaveFile, Event ;_reduce_tab3
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  title     = 'Please select a fitting Polynome File'
  extension = 'bkg'
  filter    = '*.bkg'
  path      = (*global).wave_dep_back_sub_path
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  poly_file = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    GET_PATH          = new_path,$
    DIALOG_PARENT     = id, $
    PATH              = path,$
    TITLE             = title,$
    /MUST_EXIST)
  IF (poly_file NE '') THEN BEGIN
    (*global).wave_dep_back_sub_path = new_path
    file_coeff = STRARR(FILE_LINES(poly_file))
    scaling_value = ''
    ;read file and extract string array
    OPENR, u, poly_file, /GET_LUN
    READF, u, file_coeff
    CLOSE, U
    FREE_LUN, u
    ;isolate coefficient
    list_OF_coeff = isolate_coeff(file_coeff, scaling_value)
    (*global).scaling_value = scaling_value
    ;put list of coeff in text box
    coeff_string = STRJOIN(list_OF_coeff,',')
    putTextFieldValue, Event, $
      'wave_dependent_back_sub_text_field', $
      coeff_string
    ;put name of file in button (just last part)
    file_name_only = FILE_BASENAME(poly_file)
    putNewButtonValue, Event, $
      'wave_dependent_back_browse_button', $
      file_name_only
  ENDIF
  
END
