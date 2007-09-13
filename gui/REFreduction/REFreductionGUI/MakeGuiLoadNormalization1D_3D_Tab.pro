PRO MakeGuiLoadNormalization1D_3D_Tab,D_DD_Tab,$
                                      D_DD_TabSize,$
                                      D_DD_TabTitle,$
                                      GlobalLoadGraphs

;define dimension and position of various componentsxs
RescaleBaseSize = [ 0, $
                    GlobalLoadGraphs[3]+0, $
                    GlobalLoadGraphs[2], $
                    D_DD_TabSize[3]-GlobalLoadGraphs[3]]

y_vertical_offset = 50
XaxisLabelSize  = [5,20]
YaxisLabelSize  = [XaxisLabelSize[0],XaxisLabelSize[1]+y_vertical_offset]
ZaxisLabelSize  = [YaxisLabelSize[0],YaxisLabelSize[1]+y_vertical_offset]

XaxisLabeltitle = 'X-axis:'
YaxisLabeltitle = 'Y-axis:'
ZaxisLabelTitle = 'Z-axis:'

x_offset = 50
XaxisAngleBaseSize  = [XaxisLabelSize[0]+x_offset,$
                       10,$
                       80,35]
YaxisAngleBaseSize  = [YaxisLabelSize[0]+x_offset,$
                       XaxisAngleBaseSize[1]+y_vertical_offset,$
                       80,35]
ZaxisMinBaseSize    = [ZaxisLabelSize[0]+x_offset,$
                       YaxisAngleBasesize[1]+y_vertical_offset,$
                       80,35]
x1_offset = 80
ZaxisMaxBaseSize    = [ZaxisMinBaseSize[0]+x1_offset,$
                       ZaxisMinBaseSize[1],$
                       80,35]

XaxisAngleBaseTitle = 'Angle'
YaxisAngleBaseTitle = 'Angle'
ZaxisMinBaseTitle   = 'Min'
ZaxisMaxBaseTitle   = 'Max'

AxisScaleList  = ['linear','log']
x2_offset = 75
x3_offset = 75
XaxisScaleSize = [XaxisAngleBaseSize[0] + x2_offset,$
                  XaxisAngleBaseSize[1]]
YaxisScaleSize = [YaxisAngleBaseSize[0] + x2_offset,$
                  YaxisAngleBaseSize[1]]
ZaxisScaleSize = [ZaxisMaxBaseSize[0] + x3_offset,$
                  ZaxisMaxBaseSize[1]]

XaxisResetButtonSize  = [300,XaxisScaleSize[1]+2,60,30]
XaxisResetButtonTitle = 'RESET X'
YaxisResetButtonSize  = [XaxisResetButtonSize[0],$
                         YaxisScaleSize[1]+2,$
                         XaxisResetButtonSize[2:3]]
YaxisResetButtonTitle = 'RESET Y'
ZaxisResetButtonSize  = [XaxisResetButtonSize[0],$
                         ZaxisScaleSize[1]+2,$
                         XaxisResetButtonSize[2:3]]
ZaxisResetButtonTitle = 'RESET Z'

;'Google' rotation base
Google_xoff=365
GoogleRotationBaseSize      = [Google_xoff,12,240,130]
GoogleRotationBaseTitleSize = [Google_xoff+70,2]
GoogleRotationBaseTitle     = 'Rotation Interface'

;google x-axis MM/M/P/PP
GoogleXaxisMMButtonSize  = [8,50,50,25]
GoogleXaxisMMButtonTitle = '--'
x1 = 50
GoogleXAxisMButtonSize   = [GoogleXaxisMMButtonSize[0]+x1,$
                            GoogleXaxisMMButtonSize[1],$
                            GoogleXaxisMMButtonSize[2]-15,$
                            GoogleXaxisMMButtonSize[3]]
GoogleXaxisMButtonTitle  = '-'
x2 = 95
GoogleXaxisPButtonSize   = [GoogleXaxisMButtonSize[0]+x2,$
                            GoogleXaxisMButtonSize[1:3]]
GoogleXaxisPButtonTitle  = '+'
x3 = 35
GoogleXaxisPPButtonSize  = [GoogleXaxisPButtonSize[0]+x3,$
                            GoogleXaxisMMButtonSize[1:3]]
GoogleXaxisPPButtonTitle = '++'

;reset button
x4=85
GoogleResetButtonSize    = [GoogleXaxisMMButtonSize[0]+x4,$
                            GoogleXaxisMMButtonSize[1]+5,$
                            58,17]
GoogleResetButtonTitle   = 'RESET'

;google y-axis PP/P/M/MM
GoogleYaxisPPButtonSize  = [104,5,40,30]
GoogleYaxisPPButtonTitle  = '++'
y1 = 30
GoogleYaxisPButtonSize   = [GoogleYaxisPPButtonSize[0],$
                            GoogleYaxisPPButtonSize[1]+y1,$
                            GoogleYaxisPPButtonSize[2],$
                            20]
GoogleYaxisPButtonTitle  = '+'
y2 = 37
GoogleYaxisMButtonSize   = [GoogleYaxisPButtonSize[0],$
                            GoogleYaxisPButtonSize[1]+y2,$
                            GoogleYaxisPPButtonSize[2],$
                            GoogleYaxisPButtonSize[3]]
GoogleYaxisMButtonTitle  = '-'
y3 = 21
GoogleYaxisMMButtonSize  = [GoogleYaxisPButtonSize[0],$
                            GoogleYaxisMButtonSize[1]+y3,$
                            GoogleYaxisPPButtonSize[2],$
                            GoogleYaxisPPButtonSize[3]]
GoogleYaxisMMButtonTitle = '--'

;***********************************************************************************
;Build 1D_3D tab
;***********************************************************************************
load_normalization_D_3D_tab_base = widget_base(D_DD_Tab,$
                                      uname='load_normalization_d_3d_tab_base',$
                                      title=D_DD_TabTitle[2],$
                                      xoffset=D_DD_TabSize[0],$
                                      yoffset=D_DD_TabSize[1],$
                                      scr_xsize=D_DD_TabSize[2],$
                                      scr_ysize=D_DD_TabSize[3])

load_normalization_D_3D_draw = widget_draw(load_normalization_D_3D_tab_base,$
                                  xoffset=GlobalLoadGraphs[0],$
                                  yoffset=GlobalLoadGraphs[1],$
                                  scr_xsize=GlobalLoadGraphs[2],$
                                  scr_ysize=GlobalLoadGraphs[3],$
                                  uname='load_normalization_d_3d_draw',$
                                  retain=2,$
                                  /button_events,$
                                  /motion_events)

;SCALE BASE
RescaleBase = widget_base(load_normalization_D_3D_tab_base,$
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
                             uname     = 'normalization_x_axis_angle_base',$
                             frame     = 0)

XaxisAnglecwField = CW_FIELD(XaxisAngleBase,$
                             ROW   = 1,$
                             XSIZE = 3,$
                             YSIZE = 1,$
                             /FLOAT,$
                             RETURN_EVENTS = 1,$
                             TITLE = XaxisAngleBaseTitle,$
                             UNAME = 'normalization1d_x_axis_angle_cwfield')

XaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = XaxisScaleSize[0],$
                             YOFFSET = XaxisScaleSize[1],$
                             UNAME   = 'normalization1d_x_axis_scale')

XaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = XaxisResetButtonSize[0],$
                                 YOFFSET   = XaxisResetButtonSize[1],$
                                 SCR_XSIZE = XaxisResetButtonSize[2],$
                                 SCR_YSIZE = XaxisResetButtonSize[3],$
                                 VALUE     = XaxisResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'normalization1d_x_axis_reset_button')

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
                             uname     = 'normalization_y_axis_angle_base',$
                             frame     = 0)

YaxisAnglecwField = CW_FIELD(YaxisAngleBase,$
                             ROW           = 1,$
                             XSIZE         = 3,$
                             YSIZE         = 1,$
                             /FLOAT,$
                             RETURN_EVENTS = 1,$
                             TITLE         = YaxisAngleBaseTitle,$
                             UNAME         = 'normalization1d_y_axis_angle_cwfield')
                             
YaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = YaxisScaleSize[0],$
                             YOFFSET = YaxisScaleSize[1],$
                             UNAME   = 'normalization1d_y_axis_scale')

YaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = YaxisResetButtonSize[0],$
                                 YOFFSET   = YaxisResetButtonSize[1],$
                                 SCR_XSIZE = YaxisResetButtonSize[2],$
                                 SCR_YSIZE = YaxisResetButtonSize[3],$
                                 VALUE     = YaxisResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'normalization1d_y_axis_reset_button')

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
                           UNAME     = 'normalization_z_axis_min_base')

ZaxisMinCwfield = CW_FIELD(ZaxisMinBase,$
                           ROW           = 1,$
                           XSIZE         = 5,$
                           YSIZE         = 1,$
                           /FLOAT,$
                           RETURN_EVENTS = 1,$
                           TITLE         = ZaxisMinBaseTitle,$
                           UNAME         = 'normalization1d_z_axis_min_cwfield')

ZaxisMaxBase = WIDGET_BASE(RescaleBase,$
                           XOFFSET   = ZaxisMaxBaseSize[0],$
                           YOFFSET   = ZaxisMaxBaseSize[1],$
                           SCR_XSIZE = ZaxisMaxBaseSize[2],$
                           SCR_YSIZE = ZaxisMaxBaseSize[3],$
                           UNAME     = 'normalization1d_z_axis_max_base')

ZaxisMaxCwfield = CW_FIELD(ZaxisMaxBase,$
                           ROW           = 1,$
                           XSIZE         = 5,$
                           YSIZE         = 1,$
                           /FLOAT,$
                           RETURN_EVENTS = 1,$
                           TITLE         = ZaxisMaxBaseTitle,$
                           UNAME         = 'normalization1d_z_axis_max_cwfield')

ZaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = ZaxisScaleSize[0],$
                             YOFFSET = ZaxisScaleSize[1],$
                             UNAME   = 'normalization1d_z_axis_scale')


ZaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = ZaxisResetButtonSize[0],$
                                 YOFFSET   = ZaxisResetButtonSize[1],$
                                 SCR_XSIZE = ZaxisResetButtonSize[2],$
                                 SCR_YSIZE = ZaxisResetButtonSize[3],$
                                 VALUE     = ZaxisResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'normalization1d_z_axis_reset_button')

;GOOGLE INTERACTIVE BASE
GoogleRotationTitle = WIDGET_LABEL(RescaleBase,$
                                   XOFFSET = GoogleRotationBaseTitleSize[0],$
                                   YOFFSET = GoogleRotationBaseTitleSize[1],$
                                   VALUE   = GoogleRotationBaseTitle)

GoogleRotationBase = WIDGET_BASE(RescaleBase,$
                                 XOFFSET   = GoogleRotationBaseSize[0],$
                                 YOFFSET   = GoogleRotationBaseSize[1],$
                                 SCR_XSIZE = GoogleRotationBaseSize[2],$
                                 SCR_YSIZE = GoogleRotationBaseSize[3],$
                                 UNAME     = 'normalization_google_rotation_base',$
                                 FRAME     = 1)

;GOOGLE X-AXIS
GoogleXaxisMMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleXaxisMMButtonSize[0],$
                                    YOFFSET   = GoogleXaxisMMButtonSize[1],$
                                    SCR_XSIZE = GoogleXaxisMMButtonSize[2],$
                                    SCR_YSIZE = GoogleXaxisMMButtonSize[3],$
                                    VALUE     = GoogleXaxisMMButtonTitle,$
                                    UNAME     = 'normalization1d_google_x_axis_mm_button',$
                                    SENSITIVE = 1)

GoogleXaxisMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleXaxisMButtonSize[0],$
                                   YOFFSET   = GoogleXaxisMButtonSize[1],$
                                   SCR_XSIZE = GoogleXaxisMButtonSize[2],$
                                   SCR_YSIZE = GoogleXaxisMButtonSize[3],$
                                   VALUE     = GoogleXaxisMButtonTitle,$
                                   UNAME     = 'normalization1d_google_x_axis_m_button',$
                                   SENSITIVE = 1)

GoogleXaxisPPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleXaxisPPButtonSize[0],$
                                    YOFFSET   = GoogleXaxisPPButtonSize[1],$
                                    SCR_XSIZE = GoogleXaxisPPButtonSize[2],$
                                    SCR_YSIZE = GoogleXaxisPPButtonSize[3],$
                                    VALUE     = GoogleXaxisPPButtonTitle,$
                                    UNAME     = 'normalization1d_google_x_axis_pp_button',$
                                    SENSITIVE = 1)

GoogleXaxisPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleXaxisPButtonSize[0],$
                                   YOFFSET   = GoogleXaxisPButtonSize[1],$
                                   SCR_XSIZE = GoogleXaxisPButtonSize[2],$
                                   SCR_YSIZE = GoogleXaxisPButtonSize[3],$
                                   VALUE     = GoogleXaxisPButtonTitle,$
                                   UNAME     = 'normalization1d_google_x_axis_p_button',$
                                   SENSITIVE = 1)
;RESET
GoogleResetButton = WIDGET_BUTTON(GoogleRotationBase,$
                                  XOFFSET   = GoogleResetButtonSize[0],$
                                  YOFFSET   = GoogleResetButtonSize[1],$
                                  SCR_XSIZE = GoogleResetButtonSize[2],$
                                  SCR_YSIZE = GoogleResetButtonSize[3],$
                                  UNAME     = 'normalization1d_google_reset_button',$
                                  VALUE     = GoogleResetButtonTitle,$
                                  SENSITIVE = 1)


;GOOGLE Y-AXIS
GoogleYaxisPPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleYaxisPPButtonSize[0],$
                                    YOFFSET   = GoogleYaxisPPButtonSize[1],$
                                    SCR_XSIZE = GoogleYaxisPPButtonSize[2],$
                                    SCR_YSIZE = GoogleYaxisPPButtonSize[3],$
                                    VALUE     = GoogleYaxisPPButtonTitle,$
                                    UNAME     = 'normalization1d_google_y_axis_pp_button',$
                                    SENSITIVE = 1)

GoogleYaxisPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleYaxisPButtonSize[0],$
                                   YOFFSET   = GoogleYaxisPButtonSize[1],$
                                   SCR_XSIZE = GoogleYaxisPButtonSize[2],$
                                   SCR_YSIZE = GoogleYaxisPButtonSize[3],$
                                   VALUE     = GoogleYaxisPButtonTitle,$
                                   UNAME     = 'normalization1d_google_y_axis_p_button',$
                                   SENSITIVE = 1)

GoogleYaxisMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleYaxisMButtonSize[0],$
                                    YOFFSET   = GoogleYaxisMButtonSize[1],$
                                    SCR_XSIZE = GoogleYaxisMButtonSize[2],$
                                    SCR_YSIZE = GoogleYaxisMButtonSize[3],$
                                    VALUE     = GoogleYaxisMButtonTitle,$
                                    UNAME     = 'normalization1d_google_y_axis_m_button',$
                                    SENSITIVE = 1)

GoogleYaxisMMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleYaxisMMButtonSize[0],$
                                   YOFFSET   = GoogleYaxisMMButtonSize[1],$
                                   SCR_XSIZE = GoogleYaxisMMButtonSize[2],$
                                   SCR_YSIZE = GoogleYaxisMMButtonSize[3],$
                                   VALUE     = GoogleYaxisMMButtonTitle,$
                                   UNAME     = 'normalization1d_google_y_axis_mm_button',$
                                   SENSITIVE = 1)

END
