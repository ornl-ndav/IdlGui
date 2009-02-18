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

;This function is reached each time a new angle is loaded for either
;x or y axis. When the scale is changed for x,y and z (linear/log) and
;when a new min or max value is entered for Z-axis
PRO REFreduction_RescaleData2D3DPlot, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).DataNeXusFound) then begin

;retrive various paremeters
    if (isData2dXaxisScaleLog(Event)) then begin
        XaxisScale = 'log'
    endif else begin
        XaxisScale = 'linear'
    endelse
    
    if (isData2dYaxisScaleLog(Event)) then begin
        YaxisScale = 'log'
    endif else begin
        YaxisScale = 'linear'
    endelse
    
    if (isData2dZaxisScaleLog(Event)) then begin
        ZaxisScale = 'log'
    endif else begin
        ZaxisScale = 'linear'
    endelse
    
    ZMin = getTextFieldValue(Event, 'data2d_z_axis_min_cwfield')
    ZMax = getTextFieldValue(Event, 'data2d_z_axis_max_cwfield')
    
    XYangle = getTextFieldValue(Event, 'data2d_xy_axis_angle_cwfield')
    ZZAngle = getTextFieldValue(Event, 'data2d_zz_axis_angle_cwfield')

    (*global).PrevData2D3DAx = ZZangle
    (*global).PrevData2D3DAz = XYangle
    
    REFreduction_RescaleData2D3DPlot_RePlot2D3Plot, Event, $
      XaxisScale, $
      YaxisScale, $
      ZaxisScale, $
      Zmin, $
      Zmax, $
      XYangle,$
      ZZangle
    
endif

END


;This function refreshes the 3D plot using the various paremeters
PRO REFreduction_RescaleData2D3DPlot_RePlot2D3Plot, Event, $
                                                    XaxisScale, $
                                                    YaxisScale, $
                                                    ZaxisScale, $
                                                    Zmin, $
                                                    Zmax, $
                                                    XYangle,$
                                                    ZZangle

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

img = (*(*global).DATA_DD_ptr)
;
;if (!VERSION.os EQ 'darwin') then begin
;   img = swap_endian(img)
;endif

;get loadct for this plot
LoadctIndex = getDropListSelectedIndex(Event, 'data_loadct_2d_3d_droplist')
loadct, LoadctIndex

id_draw = widget_info(Event.top, find_by_uname='load_data_dd_3d_draw')
widget_control, id_draw, get_value=id_value
wset,id_value

if (ZaxisScale EQ 'log') then begin
    img = alog(img)
endif

CASE (XaxisScale) OF
    'linear': BEGIN
        CASE (YaxisScale) OF
            'linear': BEGIN
                shade_surf, $
                  img, $
                  Az=XYangle, $
                  Ax=ZZangle, $
                  MIN_VALUE = Zmin, $
                  MAX_VALUE = Zmax
            END
            'log' : BEGIN
                shade_surf, $
                  img, $
                  Az=XYangle, $
                  Ax=ZZangle, $
                  MIN_VALUE = Zmin, $
                  MAX_VALUE = Zmax, $
                  /YLOG
            END
        ENDCASE
    END
    'log' : BEGIN
        CASE (YaxisScale) OF
            'linear': BEGIN
                shade_surf, $
                  img, $
                  Az=XYangle, $
                  Ax=ZZangle, $
                  MIN_VALUE = Zmin, $
                  MAX_VALUE = Zmax, $
                  /XLOG
            END
            'log': BEGIN
                shade_surf, $
                  img, $
                  Az=XYangle, $
                  Ax=ZZangle, $
                  MIN_VALUE = Zmin, $
                  MAX_VALUE = Zmax, $
                  /XLOG, $
                  /YLOG
            END
        ENDCASE
    END
ENDCASE
END


;This function is reached when the user interacts with the google type
;orientation tool
PRO REFreduction_RotateData2D3DPlot_Orientation, Event, Axis, RotationFactor

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF ((*global).DataNeXusFound) then begin
    
    PrevData2D3DAx = (*global).PrevData2D3DAx
    PrevData2D3DAz = (*global).PrevData2D3DAz
    if (Axis EQ 'z-axis') then begin
        Data2D3DAx = PrevData2D3DAx + RotationFactor
        (*global).PrevData2D3DAx = Data2D3DAx
        Data2D3DAz = PrevData2D3DAz
    endif else begin
        Data2D3DAx = PrevData2D3DAx
        Data2D3DAz = PrevData2D3DAz + RotationFactor
        (*global).PrevData2D3DAz = Data2D3DAz
    endelse
    
;update left part of gui
;xy-axis
    putTextFieldValue, Event, '' + $
      'data2d_xy_axis_angle_cwfield', $
      Data2D3DAz, 0
    
;zz-axis
    putTextFieldValue, Event, '' + $
      'data2d_zz_axis_angle_cwfield',$
      Data2D3DAx, 0
    
    REFreduction_RescaleData2D3DPlot_Plot2D3Plot, Event, $
      Data2D3DAx, $
      Data2D3DAz
    
ENDIF

END


;This function plots the 3D using the Ax and Az paremeters passed
PRO REFreduction_RescaleData2D3DPlot_Plot2D3Plot, Event, $
                                                  Data2D3DAx, $
                                                  Data2D3DAz

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

img = (*(*global).DATA_DD_ptr)

;if (!VERSION.os EQ 'darwin') then begin
;   img = swap_endian(img)
;endif

id_draw = widget_info(Event.top, find_by_uname='load_data_dd_3d_draw')
widget_control, id_draw, get_value=id_value
wset,id_value

shade_surf, img, Ax=Data2D3DAx, Az=Data2D3DAz

END





;############ R E S E T ############################

;This function reset the z-axis of data 2D_3D plot
PRO REFreduction_ResetData2D3DPlotZaxis, Event
;[z-axis, xy-axis, zz-axis]
ResetArray = [1,0,0]
REFreduction_ResetData2D3DPlot, Event, ResetArray
END

;This function reset the xy-axis of data 2D_3D plot
PRO REFreduction_ResetData2D3DPlotXYaxis, Event
;[z-axis, xy-axis, zz-axis]
ResetArray = [0,1,0]
REFreduction_ResetData2D3DPlot, Event, ResetArray
END

;This function reset the zz-axis of data 2D_3D plot
PRO REFreduction_ResetData2D3DPlotZZaxis, Event
;[z-axis, xy-axis, zz-axis]
ResetArray = [0,0,1]
REFreduction_ResetData2D3DPlot, Event, ResetArray
END

;This function is reached when the RESET button inside the google type
;orientation tool is clicked.
PRO REFreduction_ResetData2D3DPlot_OrientationReset, Event
;[x-axis, y-axis, z-axis, xy-axis, zz-axis]
ResetArray = [1,1,1]
REFreduction_ResetData2D3DPlot, Event, ResetArray
END

;This function is reached when the FULL ESET button inside manual mode
;is clicked
PRO REFreduction_FullResetData2D3DPlot_OrientationReset, Event
;reinitialize x-y and z-axis droplist scales
setDropListValue, Event, 'data2d_x_axis_scale', 0
setDropListValue, Event, 'data2d_y_axis_scale', 0
setDropListValue, Event, 'data2d_z_axis_scale', 0

;reinitialize loadct
loadct,5
setDropListValue, Event, 'data_loadct_2d_3d_droplist', 5
;[x-axis, y-axis, z-axis, xy-axis, zz-axis]
ResetArray = [1,1,1]
REFreduction_ResetData2D3DPlot, Event, ResetArray
END




PRO REFreduction_ResetData2D3DPlot, Event, ResetArray

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (ResetArray[0]) then begin ;Zmin and Zmax

    Data_2d_3d_min_max = (*(*global).Data_2d_3d_min_max)
    Zmin = Data_2d_3d_min_max[0]
    Zmax = Data_2d_3d_min_max[1]

    putTextFieldValue, Event, 'data2d_z_axis_min_cwfield', Zmin, 0
    putTextFieldValue, Event, 'data2d_z_axis_max_cwfield', Zmax, 0

endif

if (ResetArray[1]) then begin

    Data2D3DAx = (*global).DefaultData2D3DAx
    putTextFieldValue, Event, 'data2d_xy_axis_angle_cwfield', Data2D3DAx, 0
    (*global).PrevData2D3DAx = Data2D3DAx

endif

if (ResetArray[2]) then begin

    Data2D3DAz = (*global).DefaultData2D3DAz
    putTextFieldValue, Event, 'data2d_zz_axis_angle_cwfield', Data2D3DAz, 0
    (*global).PrevData2D3DAz = Data2D3DAz

endif

REFreduction_RescaleData2D3DPlot, Event

END





PRO REFreduction_SwitchToManualData2DMode, Event

ManualBaseStatus    = 0
AutomaticBaseStatus = 1

REFreduction_SwitchToData2DMode, Event, $
  ManualBaseStatus, $
  AutomaticBaseStatus

END


PRO REFreduction_SwitchToAutoData2DMode, Event

ManualBaseStatus    = 1
AutomaticBaseStatus = 0

REFreduction_SwitchToData2DMode, Event, $
  ManualBaseStatus, $
  AutomaticBaseStatus

END




PRO REFreduction_SwitchToData2DMode, Event, $
                                     ManualBaseStatus, $
                                     AutomaticBaseStatus

MapBase, Event, 'data2d_rescale_tab1_base', ManualBaseStatus
MapBase, Event, 'data2d_rescale_tab2_base', AutomaticBaseStatus

END
