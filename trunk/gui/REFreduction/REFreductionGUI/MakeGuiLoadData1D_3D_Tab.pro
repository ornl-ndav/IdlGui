PRO MakeGuiLoadData1D_3D_Tab, D_DD_Tab, $
                              D_DD_TabSize, $
                              D_DD_TabTitle, $
                              GlobalLoadGraphs

;define dimension and position of various componentsxs
RescaleBaseSize = [ 0, $
                    GlobalLoadGraphs[3], $
                    GlobalLoadGraphs[2], $
                    D_DD_TabSize[3]-GlobalLoadGraphs[3]]

y_vertical_offset = 35
XaxisLabelSize  = [5,10]
YaxisLabelSize  = [XaxisLabelSize[0],XaxisLabelSize[1]+y_vertical_offset]
ZaxisLabelSize  = [YaxisLabelSize[0],YaxisLabelSize[1]+y_vertical_offset]

XaxisLabeltitle = 'X-axis:'
YaxisLabeltitle = 'Y-axis:'
ZaxisLabelTitle = 'Z-axis:'

x_offset = 50
XaxisAngleBaseSize  = [XaxisLabelSize[0]+x_offset,$
                       0,$
                       80,35]
YaxisAngleBaseSize  = [YaxisLabelSize[0]+x_offset,$
                       XaxisAngleBaseSize[1]+y_vertical_offset,$
                       80,30]
ZaxisMinBaseSize    = [ZaxisLabelSize[0]+x_offset,$
                       YaxisAngleBasesize[1]+y_vertical_offset,$
                       80,30]
x1_offset = 80
ZaxisMaxBaseSize    = [ZaxisMinBaseSize[0]+x1_offset,$
                       ZaxisMinBaseSize[1],$
                       80,30]

XaxisAngleBaseTitle = 'Angle'
YaxisAngleBaseTitle = 'Angle'
ZaxisMinBaseTitle   = 'Min'
ZaxisMaxBaseTitle   = 'Max'

AxisScaleList  = ['linear','log']
x2_offset = 80
x3_offset = 100
XaxisScaleSize = [XaxisAngleBaseSize[0] + x2_offset,$
                  XaxisAngleBaseSize[1]]
YaxisScaleSize = [YaxisAngleBaseSize[0] + x2_offset,$
                  YaxisAngleBaseSize[1]]
ZaxisScaleSize = [ZaxisMaxBaseSize[0] + x3_offset,$
                  ZaxisMaxBaseSize[1]]

;***********************************************************************************
;Build 1D_3D tab
;***********************************************************************************
load_data_D_3D_tab_base = widget_base(D_DD_Tab,$
                                      uname='load_data_d_3d_tab_base',$
                                      title=D_DD_TabTitle[2],$
                                      xoffset=D_DD_TabSize[0],$
                                      yoffset=D_DD_TabSize[1],$
                                      scr_xsize=D_DD_TabSize[2],$
                                      scr_ysize=D_DD_TabSize[3])

load_data_D_3D_draw = widget_draw(load_data_D_3D_tab_base,$
                                  xoffset=GlobalLoadGraphs[0],$
                                  yoffset=GlobalLoadGraphs[1],$
                                  scr_xsize=GlobalLoadGraphs[2],$
                                  scr_ysize=GlobalLoadGraphs[3],$
                                  uname='load_data_D_3d_draw',$
                                  retain=2,$
                                  /button_events,$
                                  /motion_events)

;SCALE BASE
RescaleBase = widget_base(load_data_D_3D_tab_base,$
                          xoffset=RescaleBaseSize[0],$
                          yoffset=RescaleBaseSize[1],$
                          scr_xsize=RescaleBaseSize[2],$
                          scr_ysize=RescaleBaseSize[3],$
                          frame=0)

;X-AXIS
XaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET  = XaxisLabelSize[0],$
                          YOFFSET  = XaxisLabelSize[1],$
                          VALUE    = XaxisLabelTitle)

XaxisAngleBase = WIDGET_BASE(Rescalebase,$
                             XOFFSET   = XaxisAngleBaseSize[0],$
                             YOFFSET   = XaxisAngleBaseSize[1],$
                             SCR_XSIZE = XaxisAngleBaseSize[2],$
                             SCR_YSIZE = XaxisAngleBaseSize[3],$
                             uname     = 'data_x_axis_angle_base',$
                             frame     = 0)

XaxisAnglecwField = CW_FIELD(XaxisAngleBase,$
                             ROW   = 1,$
                             XSIZE = 3,$
                             YSIZE = 1,$
                             /FLOAT,$
                             RETURN_EVENTS = 1,$
                             TITLE = XaxisAngleBaseTitle,$
                             UNAME = 'data_x_axis_angle_cwfield')

XaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = XaxisScaleSize[0],$
                             YOFFSET = XaxisScaleSize[1],$
                             UNAME   = 'data_x_axis_scale')

;Y-AXIS
YaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET  = YaxisLabelSize[0],$
                          YOFFSET  = YaxisLabelSize[1],$
                          VALUE    = YaxisLabelTitle)

YaxisAngleBase = WIDGET_BASE(Rescalebase,$
                             XOFFSET   = YaxisAngleBaseSize[0],$
                             YOFFSET   = YaxisAngleBaseSize[1],$
                             SCR_XSIZE = YaxisAngleBaseSize[2],$
                             SCR_YSIZE = YaxisAngleBaseSize[3],$
                             uname     = 'data_y_axis_angle_base',$
                             frame     = 0)

YaxisAnglecwField = CW_FIELD(YaxisAngleBase,$
                             ROW   = 1,$
                             XSIZE = 3,$
                             YSIZE = 1,$
                             /FLOAT,$
                             RETURN_EVENTS = 1,$
                             TITLE = YaxisAngleBaseTitle,$
                             UNAME = 'data_y_axis_angle_cwfield')
                             
YaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = YaxisScaleSize[0],$
                             YOFFSET = YaxisScaleSize[1],$
                             UNAME   = 'data_y_axis_scale')

;Z-AXIS
ZaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET  = ZaxisLabelSize[0],$
                          YOFFSET  = ZaxisLabelSize[1],$
                          VALUE    = ZaxisLabelTitle)

ZaxisMinBase = WIDGET_BASE(RescaleBase,$
                           XOFFSET   = ZaxisMinBaseSize[0],$
                           YOFFSET   = ZaxisMinBaseSize[1],$
                           SCR_XSIZE = ZaxisMinBaseSize[2],$
                           SCR_YSIZE = ZaxisMinBaseSize[3],$
                           UNAME     = 'data_z_axis_min_base')

ZaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = ZaxisScaleSize[0],$
                             YOFFSET = ZaxisScaleSize[1],$
                             UNAME   = 'data_z_axis_scale')



END

