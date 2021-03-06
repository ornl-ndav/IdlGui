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

;-------------------------------------------------------------------------------
PRO activateWidget, Event, uname, activate_status
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, sensitive=activate_status
END

;-------------------------------------------------------------------------------
PRO activateWidgets, Event, uname_array, activate_status
  sz = N_ELEMENTS(uname_array)
  index = 0
  WHILE (index LT sz) DO BEGIN
    activateWidget, Event, uname_array[index], activate_status
    index++
  ENDWHILE
END

;-------------------------------------------------------------------------------
PRO MapBase, Event, uname, status
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, MAP=status
END

;===============================================================================
;===============================================================================
PRO activatePreviewButton, Event, status
  activateWidget, Event, 'preview_runinfo_file', status
END

;-------------------------------------------------------------------------------
PRO activateCreateHistoMapButton, Event, activate_status
  id = widget_info(Event.top,find_by_uname='create_histo_mapped_button')
  widget_control, id, sensitive=activate_status
END

;-------------------------------------------------------------------------------
PRO activateMappingBase, Event, activate_status
  uname_array = ['mapping_frame',$
    'mapping_label',$
    'mapping_droplist']
  sz = (size(uname_array))(1)
  FOR i=0,(sz-1) DO BEGIN
    id = widget_info(Event.top,find_by_uname=uname_array[i])
    widget_control, id, sensitive=activate_status
  ENDFOR
END

;-------------------------------------------------------------------------------
PRO activateHistogrammingBase, Event, activate_status
  uname_array = ['histo_frame',$
    'histo_frame_label',$
    'min_time_bin_label',$
    'min_time_bin',$
    'max_time_bin_label',$
    'max_time_bin',$
    'bin_width_label',$
    'bin_width',$
    'bin_type_label',$
    'bin_type_droplist']
  sz = (size(uname_array))(1)
  FOR i=0,(sz-1) DO BEGIN
    id = widget_info(Event.top,find_by_uname=uname_array[i])
    widget_control, id, sensitive=activate_status
  ENDFOR
END

;-------------------------------------------------------------------------------
PRO ActivateHistoMappingBasesStatus, Event
  ;get value of input event file widget_text
  EventFile = getEventFile(Event)
  IF(EventFile NE '') THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activateHistogrammingBase, Event, activate_status
  activateMappingBase, Event, activate_status
END

;-------------------------------------------------------------------------------
PRO ActivateHistoMappingBaseFromWidgetText, Event
  ;get event file name entered in widget_text
  EventFile = getEventFile(Event)
  IF (FILE_TEST(EventFile)) THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activateHistogrammingBase, Event, activate_status
  activateMappingBase, Event, activate_status
END

;-------------------------------------------------------------------------------
PRO ActivateOrNotCreateHistogramMapped, Event
  activate_go_histo_mapped_status = 1
  ;if there is an event file and file exist
  EventFile = getEventFile(Event)
  IF (FILE_TEST(EventFile)) THEN BEGIN
  ;nothing to do, everything is ok so far
  ENDIF ELSE BEGIN
    activate_go_histo_mapped_status = 0
  ENDELSE
  ;if the mandatory paramters of the histogram are there
  max_time_bin = getTextFieldValue(Event,'max_time_bin')
  bin_width    = getTextFieldValue(Event,'bin_width')
  IF (max_time_bin NE '' AND bin_width NE '') THEN BEGIN
  ;nothing to do, everything is ok so far
  ENDIF ELSE BEGIN
    activate_go_histo_mapped_status = 0
  ENDELSE
  ;if there is at least one mapping
  mapping_file = getMappingFile(Event)
  IF (mapping_file NE '') THEN BEGIN
  ;nothing to do, everything is ok so far
  ENDIF ELSE BEGIN
    activate_go_histo_mapped_status = 0
  ENDELSE
  ;activate or not go_histo_mapped
  ;and activate or not preview runinfo file
  IF (activate_go_histo_mapped_status) THEN BEGIN
    activateCreateHistoMapButton, Event, 1
    activatePreviewButton, Event, 1
  ENDIF ELSE BEGIN
    activateCreateHistoMapButton, Event, 0
    activatePreviewButton, Event, 0
  ENDELSE
END

;-------------------------------------------------------------------------------
PRO ActivateOrNotPlotButton, Event
  ;get histo_mapped file name
  histo_mapped_file = getTextFieldValue(Event,'histo_mapped_text_field')
  IF (FILE_TEST(histo_mapped_file)) THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activateWidget, Event, 'plot_button', activate_status
;activate SAVE_AS button as well
;activateWidget, Event,
;               'save_as_histo_mapped_button',
;                activate_status ;REMOVE_COMMENTS
END

;-------------------------------------------------------------------------------
PRO ActivateOrNotPlotButton_from_NexusTab, Event
  BaseActivated = getArchivedOrListAllBaseActivated(Event)
  IF (BaseActivated EQ 'archived' OR $
    BaseActivated EQ 'list_all') THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activateWidget, Event, 'plot_button', activate_status
END

;-------------------------------------------------------------------------------
PRO setHistogrammingTypeValue, Event, index
  id = widget_info(Event.top,find_by_uname='bin_type_droplist')
  widget_control, id, set_droplist_select=index
END

;-------------------------------------------------------------------------------
PRO ActivateArchivedBase, Event
  MapBase, Event, 'archived_base', 1
  MapBase, Event, 'list_all_base', 0
END

;-------------------------------------------------------------------------------
PRO ActivateListAllBase, Event
  MapBase, Event, 'archived_base', 0
  MapBase, Event, 'list_all_base', 1
END

;-------------------------------------------------------------------------------
PRO HideArchivedListAllBase, Event
  MapBase, Event, 'nexus_file_name_base', 0
END

;-------------------------------------------------------------------------------
PRO ShowArchivedListAllBase, Event
  MapBase, Event, 'nexus_file_name_base', 1
END

;-------------------------------------------------------------------------------
PRO ActivatePreviewBase, Event, activate_status
  MapBase, Event, 'nxsummary_base', activate_status
END

;-------------------------------------------------------------------------------
PRO ShowLastLineLogBook, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='log_book')
  WIDGET_CONTROL, id, GET_VALUE = text
  sz = (SIZE(text))(1)
  IF (sz GT 10) THEN BEGIN
    WIDGET_CONTROL, id, SET_TEXT_TOP_LINE=sz-9
  ENDIF
END

;===============================================================================

