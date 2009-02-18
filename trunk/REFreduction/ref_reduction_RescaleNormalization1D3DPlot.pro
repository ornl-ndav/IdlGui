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
PRO REFreduction_RescaleNorm1D3DPlot, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).NormNeXusFound) then begin

;retrive various paremeters
    if (isNormXaxisScaleLog(Event)) then begin
        XaxisScale = 'log'
    endif else begin
        XaxisScale = 'linear'
    endelse
    
    if (isNormYaxisScaleLog(Event)) then begin
        YaxisScale = 'log'
    endif else begin
        YaxisScale = 'linear'
    endelse
    
    if (isNormZaxisScaleLog(Event)) then begin
        ZaxisScale = 'log'
    endif else begin
        ZaxisScale = 'linear'
    endelse
    
    ZMin = getTextFieldValue(Event, 'normalization1d_z_axis_min_cwfield')
    ZMax = getTextFieldValue(Event, 'normalization1d_z_axis_max_cwfield')
    
    XYangle = getTextFieldValue(Event, 'normalization1d_xy_axis_angle_cwfield')
    ZZAngle = getTextFieldValue(Event, 'normalization1d_zz_axis_angle_cwfield')

    (*global).PrevNorm1D3DAx = ZZangle
    (*global).PrevNorm1D3DAz = XYangle
    
    REFreduction_RescaleNorm1D3DPlot_RePlot1D3Plot, Event, $
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
PRO REFreduction_RescaleNorm1D3DPlot_RePlot1D3Plot, Event, $
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

img = (*(*global).NORM_D_TOTAL_ptr)

;if (!VERSION.os EQ 'darwin') then begin
;   img = swap_endian(img)
;endif

;get loadct for this plot
LoadctIndex = getDropListSelectedIndex(Event, 'normalization_loadct_1d_3d_droplist')
loadct, LoadctIndex

id_draw = widget_info(Event.top, find_by_uname='load_normalization_d_3d_draw')
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
PRO REFreduction_RotateNorm1D3DPlot_Orientation, Event, Axis, RotationFactor

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF ((*global).NormNeXusFound) then begin
    
    PrevNorm1D3DAx = (*global).PrevNorm1D3DAx
    PrevNorm1D3DAz = (*global).PrevNorm1D3DAz
    if (Axis EQ 'z-axis') then begin
        Norm1D3DAx = PrevNorm1D3DAx + RotationFactor
        (*global).PrevNorm1D3DAx = Norm1D3DAx
        Norm1D3DAz = PrevNorm1D3DAz
    endif else begin
        Norm1D3DAx = PrevNorm1D3DAx
        Norm1D3DAz = PrevNorm1D3DAz + RotationFactor
        (*global).PrevNorm1D3DAz = Norm1D3DAz
    endelse
    
;update left part of gui
;xy-axis
    putTextFieldValue, Event, '' + $
      'normalization1d_xy_axis_angle_cwfield', $
      Norm1D3DAz, 0
    
;zz-axis
    putTextFieldValue, Event, '' + $
      'normalization1d_zz_axis_angle_cwfield',$
      Norm1D3DAx, 0
    
    REFreduction_RescaleNorm1D3DPlot_Plot1D3Plot, Event, $
      Norm1D3DAx, $
      Norm1D3DAz
    
ENDIF

END


;This function plots the 3D using the Ax and Az paremeters passed
PRO REFreduction_RescaleNorm1D3DPlot_Plot1D3Plot, Event, $
                                                  Norm1D3DAx, $
                                                  Norm1D3DAz

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

img = (*(*global).NORM_D_TOTAL_ptr)

;if (!VERSION.os EQ 'darwin') then begin
;   img = swap_endian(img)
;endif

;DEVICE, DECOMPOSED = 0
;loadct,

id_draw = widget_info(Event.top, find_by_uname='load_normalization_d_3d_draw')
widget_control, id_draw, get_value=id_value
wset,id_value

shade_surf,img,Ax=Norm1D3DAx,Az=Norm1D3DAz

END





;############ R E S E T ############################

;This function reset the z-axis of data 1D_3D plot
PRO REFreduction_ResetNorm1D3DPlotZaxis, Event
;[z-axis, xy-axis, zz-axis]
ResetArray = [1,0,0]
REFreduction_ResetNorm1D3DPlot, Event, ResetArray
END

;This function reset the xy-axis of data 1D_3D plot
PRO REFreduction_ResetNorm1D3DPlotXYaxis, Event
;[z-axis, xy-axis, zz-axis]
ResetArray = [0,1,0]
REFreduction_ResetNorm1D3DPlot, Event, ResetArray
END

;This function reset the zz-axis of data 1D_3D plot
PRO REFreduction_ResetNorm1D3DPlotZZaxis, Event
;[z-axis, xy-axis, zz-axis]
ResetArray = [0,0,1]
REFreduction_ResetNorm1D3DPlot, Event, ResetArray
END

;This function is reached when the RESET button inside the google type
;orientation tool is clicked.
PRO REFreduction_ResetNorm1D3DPlot_OrientationReset, Event
;[x-axis, y-axis, z-axis, xy-axis, zz-axis]
ResetArray = [1,1,1]
REFreduction_ResetNorm1D3DPlot, Event, ResetArray
END

;This function is reached when the FULL ESET button inside manual mode
;is clicked
PRO REFreduction_FullResetNorm1D3DPlot_OrientationReset, Event
;reinitialize x-y and z-axis droplist scales
setDropListValue, Event, 'normalization1d_x_axis_scale', 0
setDropListValue, Event, 'normalization1d_y_axis_scale', 0
setDropListValue, Event, 'normalization1d_z_axis_scale', 0

;reinitialize loadct
loadct,5
setDropListValue, Event, 'normalization_loadct_1d_3d_droplist', 5
;[x-axis, y-axis, z-axis, xy-axis, zz-axis]
ResetArray = [1,1,1]
REFreduction_ResetNorm1D3DPlot, Event, ResetArray
END




PRO REFreduction_ResetNorm1D3DPlot, Event, ResetArray

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (ResetArray[0]) then begin ;Zmin and Zmax

    normalization_1d_3d_min_max = (*(*global).normalization_1d_3d_min_max)
    Zmin = Normalization_1d_3d_min_max[0]
    Zmax = Normalization_1d_3d_min_max[1]

    putTextFieldValue, Event, 'normalization1d_z_axis_min_cwfield', Zmin, 0
    putTextFieldValue, Event, 'normalization1d_z_axis_max_cwfield', Zmax, 0

endif

if (ResetArray[1]) then begin

    Norm1D3DAx = (*global).DefaultNorm1D3DAx
    putTextFieldValue, Event, 'normalization1d_xy_axis_angle_cwfield', Norm1D3DAx, 0
    (*global).PrevNorm1D3DAx = Norm1D3DAx

endif

if (ResetArray[2]) then begin

    Norm1D3DAz = (*global).DefaultNorm1D3DAz
    putTextFieldValue, Event, 'normalization1d_zz_axis_angle_cwfield', Norm1D3DAz, 0
    (*global).PrevNorm1D3DAz = Norm1D3DAz

endif

REFreduction_RescaleNormalization2D3DPlot, Event

END



PRO REFreduction_SwitchToManualNorm1DMode, Event

ManualBaseStatus    = 0
AutomaticBaseStatus = 1

REFreduction_SwitchToNorm1DMode, Event, $
  ManualBaseStatus, $
  AutomaticBaseStatus

END


PRO REFreduction_SwitchToAutoNorm1DMode, Event

ManualBaseStatus    = 1
AutomaticBaseStatus = 0

REFreduction_SwitchToNorm1DMode, Event, $
  ManualBaseStatus, $
  AutomaticBaseStatus

END




PRO REFreduction_SwitchToNorm1DMode, Event, $
                                     ManualBaseStatus, $
                                     AutomaticBaseStatus

MapBase, Event, 'normalization1d_rescale_tab1_base', ManualBaseStatus
MapBase, Event, 'normalization1d_rescale_tab2_base', AutomaticBaseStatus

END
