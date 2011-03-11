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

;this function will disabled or not the cw_fields and buttons
;if no NeXus has been found
PRO updateDataWidget, Event, isNeXusFound
ActivateWidget, Event, 'data_back_peak_rescale_tab', isNeXusFound
ACtivateWidget, Event, 'save_as_jpeg_button_data', isNeXusFound
END

;this function will disabled or not the cw_fields and buttons
;if no NeXus has been found
PRO updateNormWidget, Event, isNeXusFound
ActivateWidget, Event, 'norm_back_peak_rescale_tab', isNexusFound
ACtivateWidget, Event, 'save_as_jpeg_button_normalization', isNeXusFound
END

;this function will clear the text field if no nexus has been found
PRO updateDataTextFields, Event, isNeXusFound
if (isNeXusFound) then begin ;NeXus has been found
endif else begin ;Nexus not found
    putTextFieldValue, event, 'data_file_info_text','', 0
    putTextFieldValue, event, 'DATA_left_interaction_help_text','',0
endelse
END

;this function will clear the text field if no nexus has been found
PRO updateNormTextFields, Event, isNeXusFound
if (isNeXusFound) then begin ;NeXus has been found
endif else begin ;Nexus not found
    putTextFieldValue, event, 'normalization_file_info_text','', 0
    putTextFieldValue, event, 'NORM_left_interaction_help_text','',0
endelse
END

;This function will clear the 1D and 2D Data draw if no NeXus found
PRO clearOffDatadisplay, Event, isNeXusFound
if (~isNexusFound) then begin   ;NeXus not found
    id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
    id_draw = widget_info(Event.top, find_by_uname='load_data_DD_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase    
ENDIF 
END

;This function will clear the 1D and 2D Normalization draw if no NeXus found
PRO clearOffNormdisplay, Event, isNeXusFound
if (~isNexusFound) then begin   ;NeXus not found
    
    id_draw = widget_info(Event.top, find_by_uname='load_normalization_D_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
    id_draw = widget_info(Event.top, find_by_uname= $
                          'load_normalization_DD_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
ENDIF 
END

;****************************** M A I N ****************************
;This function updates the GUI according to the result of Data NeXus
;found or not
PRO RefReduction_update_data_gui_if_NeXus_found, Event, isNeXusFound
updateDataWidget, Event, isNeXusFound ;update cw_fields and buttons
updateDataTextFields, Event, isNeXusFound ;update text_fields contain
clearOffDatadisplay, Event, isNeXusFound ;erase 1D and 2D widget_draw
END

;This function updates the GUI according to the result of Norm NeXus
;found or not
PRO RefReduction_update_normalization_gui_if_NeXus_found, Event, isNeXusFound
updateNormWidget, Event, isNeXusFound ;update cw_fields and buttons
updateNormTextFields, Event, isNeXusFound ;update text_fields contain
clearOffNormdisplay, Event, isNeXusFound ;erase 1D and 2D widget_draw
END

;This function checks if the zoom option has been selected for the
;Data tab
PRO REFreduction_DataBackPeakZoomEvent, Event
value = getCWBgroupValue(Event, 'data_1d_selection')
if (value EQ 2) then begin
;erase display only if this one is only 1 line long
    text = getTextFieldValue(Event, 'DATA_left_interaction_help_text')
    sz = (size(text))(1)
    if (sz EQ 1) then begin
        putTextFieldValue, event, 'DATA_left_interaction_help_text', '', 0
    endif
endif
END

;This function checks if the zoom option has been selected for the
;Normalization tab
PRO REFreduction_NormBackPeakZoomEvent, Event
value = getCWBgroupValue(Event, 'normalization_1d_selection')
if (value EQ 2) then begin
;erase display only if this one is only 1 line long
    text = getTextFieldValue(Event, 'NORM_left_interaction_help_text')
    sz = (size(text))(1)
    if (sz EQ 1) then begin
        putTextFieldValue, event, 'NORM_left_interaction_help_text', '', 0
    endif
endif
END

;This function populate the 1D_3D tab of DATA
PRO REFreduction_UpdateData1D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
;z_min
putTextFieldValue, event, $
  'data1d_z_axis_min_cwfield', $
  strcompress(zmin,/remove_all), 0
;z_max
putTextFieldValue, event, $
  'data1d_z_axis_max_cwfield', $
  strcompress(zmax,/remove_all), 0
;XYangle
putTextFieldValue, event, $
  'data1d_xy_axis_angle_cwfield', $
  strcompress(XYangle,/remove_all), 0
;ZZangle
putTextFieldValue, event, $
  'data1d_zz_axis_angle_cwfield', $
  strcompress(ZZangle,/remove_all), 0
END

;This function populate the 2D_3D tab of DATA
PRO REFreduction_UpdateData2D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
;z_min
putTextFieldValue, event, $
  'data2d_z_axis_min_cwfield', $
  strcompress(zmin,/remove_all), 0
;z_max
putTextFieldValue, event, $
  'data2d_z_axis_max_cwfield', $
  strcompress(zmax,/remove_all), 0
;XYangle
putTextFieldValue, event, $
  'data2d_xy_axis_angle_cwfield', $
  strcompress(XYangle,/remove_all), 0
;ZZangle
putTextFieldValue, event, $
  'data2d_zz_axis_angle_cwfield', $
  strcompress(ZZangle,/remove_all), 0
END

;This function populate the 1D_3D tab of Normalization
PRO REFreduction_UpdateNorm1D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
;z_min
putTextFieldValue, event, $
  'normalization1d_z_axis_min_cwfield', $
  strcompress(zmin,/remove_all), 0
;z_max
putTextFieldValue, event, $
  'normalization1d_z_axis_max_cwfield', $
  strcompress(zmax,/remove_all), 0
;XYangle
putTextFieldValue, event, $
  'normalization1d_xy_axis_angle_cwfield', $
  strcompress(XYangle,/remove_all), 0
;ZZangle
putTextFieldValue, event, $
  'normalization1d_zz_axis_angle_cwfield', $
  strcompress(ZZangle,/remove_all), 0
END

;This function populate the 2D_3D tab of NORMALIZATION
PRO REFreduction_UpdateNorm2D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
;z_min
putTextFieldValue, event, $
  'normalization2d_z_axis_min_cwfield', $
  strcompress(zmin,/remove_all), 0
;z_max
putTextFieldValue, event, $
  'normalization2d_z_axis_max_cwfield', $
  strcompress(zmax,/remove_all), 0
;XYangle
putTextFieldValue, event, $
  'normalization2d_xy_axis_angle_cwfield', $
  strcompress(XYangle,/remove_all), 0
;ZZangle
putTextFieldValue, event, $
  'normalization2d_zz_axis_angle_cwfield', $
  strcompress(ZZangle,/remove_all), 0
END

