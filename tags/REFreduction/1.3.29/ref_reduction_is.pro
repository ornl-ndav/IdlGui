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

Function isDataPeakSelectionSelected, Event
  id = widget_info(Event.top,find_by_uname='data_1d_selection')
  widget_control, id, get_value=isPeakSelected
  return, isPeakSelected
END

;------------------------------------------------------------------------------
Function isNormPeakSelectionSelected, Event
  id = widget_info(Event.top,find_by_uname='normalization_1d_selection')
  widget_control, id, get_value=isPeakSelected
  return, isPeakSelected
END

;------------------------------------------------------------------------------
;This function returns:
; 0: if Region Of Interest (ROI)
; 1: if Peak
; 2: if Backround
; 3: if Zoom
Function isDataBackPeakZoomSelected, Event
  tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='data_roi_peak_background_tab')
  CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
  CASE (CurrTabSelect) OF
    0: RETURN, 0
    1: BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_data_back_group')
      WIDGET_CONTROL, id, GET_VALUE = SelectionStatus
      RETURN, SelectionSTatus+1
    END
    2: RETURN, 3
  ENDCASE
END

;------------------------------------------------------------------------------
;This function returns:
; 0: if Region Of Interest (ROI)
; 1: if Peak
; 2: if Backround
; 3: if Zoom
Function isNormBackPeakZoomSelected, Event
  tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='norm_roi_peak_background_tab')
  CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
  CASE (CurrTabSelect) OF
    0: RETURN, 0
    1: BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_norm_back_group')
      WIDGET_CONTROL, id, GET_VALUE = SelectionStatus
      RETURN, SelectionSTatus+1
    END
    2: RETURN, 3
  ENDCASE
END

;------------------------------------------------------------------------------
Function isDataYminSelected, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='data_ymin_ymax_label')
  WIDGET_CONTROL, id, GET_VALUE = value
  IF (value EQ 'Current working selection -> Ymin') THEN BEGIN
    RETURN, 1
  ENDIF ELSE BEGIN
    RETURN, 0
  ENDELSE
END

;------------------------------------------------------------------------------
Function isNormYminSelected, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='norm_ymin_ymax_label')
  WIDGET_CONTROL, id, GET_VALUE = value
  IF (value EQ 'Current working selection -> Ymin') THEN BEGIN
    RETURN, 1
  ENDIF ELSE BEGIN
    RETURN, 0
  ENDELSE
END



Function isDataWithBackground, Event
  id = widget_info(Event.top,find_by_uname='data_background_cw_bgroup')
  widget_control, id, get_value=isWithBackground
  if (isWithBackground EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END

;------------------------------------------------------------------------------
;This function checks which cw_bgroup is selected for data (PEAK or BACKGROUND)
FUNCTION isDataPeakSelected, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_data_back_group')
  WIDGET_CONTROL, id, GET_VALUE=value
  IF (value EQ 0) THEN RETURN,1
  RETURN,0
END

;------------------------------------------------------------------------------
;This function checks which cw_bgroup is selected for Norm. (PEAK or
;BACKGROUND)
FUNCTION isNormPeakSelected, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_norm_back_group')
  WIDGET_CONTROL, id, GET_VALUE=value
  IF (value EQ 0) THEN RETURN,1
  RETURN,0
END

;------------------------------------------------------------------------------
Function isNormPeakSelectionSelected, Event
  id = widget_info(Event.top,find_by_uname='normalization_1d_selection')
  widget_control, id, get_value=isPeakSelected
  return, isPeakSelected
END


Function isNormWithBackground, Event
  id = widget_info(Event.top,find_by_uname='normalization_background_cw_bgroup')
  widget_control, id, get_value=isWithBackground
  if (isWithBackground EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END


Function isReductionWithNormalization, Event
  id = widget_info(Event.top,find_by_uname='yes_no_normalization_bgroup')
  widget_control, id, get_value=isWithNormalization
  if (isWithNormalization EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END


Function isWithFiltering, Event
  id = widget_info(Event.top,find_by_uname='filtering_data_cwbgroup')
  widget_control, id, get_value=isWithFiltering
  if (isWithFiltering EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END


Function isWithDToT, Event
  id = widget_info(Event.top,find_by_uname='delta_t_over_t_cwbgroup')
  widget_control, id, get_value= status
  if (status EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END


Function isWithDataInstrumentGeometryOverwrite, Event
  id = widget_info(Event.top, $
    find_by_uname='overwrite_data_instrument_geometry_cwbgroup')
  widget_control, id, get_value=isWithIGOverwrite
  if (isWithIGOverwrite EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END


Function isWithNormInstrumentGeometryOverwrite, Event
  id = widget_info(Event.top, $
    find_by_uname='overwrite_norm_instrument_geometry_cwbgroup')
  widget_control, id, get_value=isWithIGOverwrite
  if (isWithIGOverwrite EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END


Function isBaseMap, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  isMap = widget_info(id, /map)
  return, isMap
END


Function isDataZoomTabSelected, Event
  tab_id = widget_info(Event.top,find_by_uname='data_nxsummary_zoom_tab')
  CurrTabSelect = widget_info(tab_id,/tab_current)
  return, CurrTabSelect
END


Function isNormZoomTabSelected, Event
  tab_id = widget_info(Event.top, $
    find_by_uname='normalization_nxsummary_zoom_tab')
  CurrTabSelect = widget_info(tab_id,/tab_current)
  return, CurrTabSelect
END


Function isWidgetSensitive, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  sensitiveStatus = widget_info(id,/sensitive)
  return, sensitiveStatus
END


Function isArchivedDataNexusDesired, Event
  id = widget_info(Event.top,find_by_uname='data_archived_or_full_cwbgroup')
  widget_control,id,get_value=status
  if (status EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END

;------------------------------------------------------------------------------
Function isArchivedEmptyCellNexusDesired, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='empty_cell_archived_or_all_uname')
  WIDGET_CONTROL,id,GET_VALUE=status
  IF (status EQ 0) THEN BEGIN
    RETURN, 1
  ENDIF ELSE BEGIN
    RETURN, 0
  ENDELSE
END

;------------------------------------------------------------------------------
Function isArchivedNormNexusDesired, Event
  id = widget_info(Event.top, $
    find_by_uname='normalization_archived_or_full_cwbgroup')
  widget_control,id,get_value=status
  if (status EQ 0) then begin
    return, 1
  endif else begin
    return, 0
  endelse
END

;------------------------------------------------------------------------------
FUNCTION isArchivedEmptyCellNexusDesired, Event
  id = widget_info(Event.top, $
    find_by_uname='empty_cell_archived_or_all_uname')
  WIDGET_CONTROL,id,GET_VALUE=status
  IF (status EQ 0) THEN BEGIN
    RETURN, 1
  ENDIF ELSE BEGIN
    RETURN, 0
  ENDELSE
END

;------------------------------------------------------------------------------
;1D_3D booleans
FUNCTION isDataXaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='data1d_x_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isDataYaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='data1d_y_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isDataZaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='data1d_z_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isNormXaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='normalization1d_x_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isNormYaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='normalization1d_y_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isNormZaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='normalization1d_z_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END



;2D_3D booleans
FUNCTION isData2dXaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='data2d_x_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isData2dYaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='data2d_y_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isData2dZaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='data2d_z_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isNorm2dXaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='normalization2d_x_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isNorm2dYaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='normalization2d_y_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

FUNCTION isNorm2dZaxisScaleLog, Event
  id = widget_info(Event.top,find_by_uname='normalization2d_z_axis_scale')
  index = widget_info(id, /droplist_select)
  return, index
END

;------------------------------------------------------------------------------
FUNCTION isPeakBaseMap, Event
  RETURN, isBaseMap(Event, 'data_peak_base')
END

;------------------------------------------------------------------------------
FUNCTION isNormPeakBaseMap, Event
  RETURN, isBaseMap(Event, 'norm_peak_base')
END

;------------------------------------------------------------------------------
FUNCTION isPathExist, file_name
  path = FILE_DIRNAME(file_name)
  RETURN, FILE_TEST(path,/DIRECTORY)
END

;------------------------------------------------------------------------------
FUNCTION isTOFcuttingUnits_microS, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_data_tof_units_micros')
  result = WIDGET_INFO(id, /button_SET)
  RETURN, result
END
