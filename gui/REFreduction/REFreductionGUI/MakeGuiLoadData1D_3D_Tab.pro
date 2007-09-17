PRO MakeGuiLoadData1D_3D_Tab, D_DD_Tab, $
                              D_DD_TabSize, $
                              D_DD_TabTitle, $
                              GlobalLoadGraphs, $
                              LoadctList

;define dimension and position of various components
RescaleTabSize = [5,$
                  GlobalLoadGraphs[3]+1, $
                  GlobalLoadGraphs[2], $
                  D_DD_TabSize[3]-GlobalLoadGraphs[3]-30]
RescaleBaseSize = [0,0,$                  
                   GlobalLoadGraphs[2], $
                   D_DD_TabSize[3]-GlobalLoadGraphs[3]]
RescaleTab1Title = 'MANUAL'
RescaleTab2title = 'AUTOMATIC'

;x-axis (droplist)
XaxisLabelSize      = [10,0]
XaxisLabeltitle     = 'X-axis:'
XaxisLabelFrameSize = [5,8,100,45]
AxisScaleList       = ['linear','log']
XaxisScaleSize      = [10,15]

;y-axis (droplist)
YaxisLabelSize      = [120,0]
YaxisLabeltitle     = 'Y-axis:'
YaxisLabelFrameSize = [YaxisLabelSize[0]-5,XaxisLabelFrameSize[1:3]]
YaxisScaleSize      = [YaxisLabelSize[0],15]

;1d_3d_loadct button
LoadctLabelSize      = [230,0]
LoadctLabelTitle     = 'Contrast'
LoadctLabelFrameSize = [LoadctLabelSize[0]-5,XaxisLabelFrameSize[1],200,$
                       XaxisLabelFrameSize[3]]
LoadctDroplistSize   = [LoadctLabelSize[0],15,100,30]

;z-axis (droplist-xmin-xmax-reset)
y_vertical_offset   = 55
ZaxisLabelSize      = [XaxisLabelSize[0],$
                       XaxisLabelSize[1]+y_vertical_offset]
ZaxisLabelTitle     = 'Z-axis:'
ZaxisLabelFrameSize = [ZaxisLabelSize[0]-5,XaxisLabelFrameSize[1]+y_vertical_offset,$
                       400,XaxisLabelFrameSize[3]]
ZaxisScaleSize      = [ZaxisLabelSize[0],15+y_vertical_offset]
                       
;min/max
; x2_offset= 85
; ZaxisMinBaseSize    = [ZaxisScaleSize[0]+x2_offset,$
;                        ZaxisScaleSize[1],$
;                        80,35]
; x3_offset = 80
; ZaxisMaxBaseSize    = [ZaxisMinBaseSize[0]+x3_offset,$
;                        ZaxisMinBaseSize[1],$
;                        80,35]
; ZaxisMinBaseTitle   = 'Min'
; ZaxisMaxBaseTitle   = 'Max'

; XaxisResetButtonSize  = [290,XaxisScaleSize[1]+2,70,30]
; XaxisResetButtonTitle = 'RESET X'
; YaxisResetButtonSize  = [XaxisResetButtonSize[0],$
;                          YaxisScaleSize[1]+2,$
;                          XaxisResetButtonSize[2:3]]
; YaxisResetButtonTitle = 'RESET Y'
; ZaxisResetButtonSize  = [XaxisResetButtonSize[0],$
;                          ZaxisScaleSize[1]+2,$
;                          XaxisResetButtonSize[2:3]]
; ZaxisResetButtonTitle = 'RESET Z'

; ;XYaxis
; XYAxisLabelSize      = [ZaxisLabelSize[0],ZaxisLabelSize[1]+y_vertical_offset]
; XYAxisLabelTitle     = 'XY-axis:'
; x4_offset= 50
; XYAxisAngleBaseSize  = [XYAxisLabelSize[0]+x4_offset,$
;                        XYAxisLabelSize[1]-10,$
;                        85,35]
; XYAxisAngleBaseTitle = 'Angle:'
; x5_offset = 83
; XYAxisAngleResetButtonSize  = [XYAxisAngleBaseSize[0]+x5_offset,$
;                                XYAxisAngleBaseSize[1]+3,$
;                                40,30]
; XYAxisAngleResetButtonTitle = 'RST'

; x6_offset = 180
; ZZAxisLabelSize      = [XYAxisLabelSize[0]+x6_offset, $
;                         XYAxisLabelSize[1]]
; ZZAxisLabelTitle     = 'Z-axis:'
; ZZAxisAngleBaseSize  = [ZZAxisLabelSize[0]+x4_offset,$
;                         XYAxisAngleBaseSize[1],$
;                         XYAxisAngleBaseSize[2:3]]
; ZZAxisAngleBaseTitle = 'Angle:'
; ZZAxisAngleResetButtonSize  = [ZZAxisAngleBaseSize[0]+x5_offset,$
;                                XYAxisAngleResetButtonSize[1],$
;                                XYAxisAngleResetButtonSize[2:3]]
; ZZAxisAngleResetButtonTitle = 'RST'














;'Google' rotation base
Google_xoff=365
;GoogleRotationBaseTitleSize = [Google_xoff-20,2]
GoogleRotationBaseTitleSize = [83,0]
GoogleRotationBaseTitle     = 'R O T A T I O N                                  I N T E R F A C E'

;google xy-axis MM/M/P/PP
;MMM, MM and M
GoogleXYaxisMMMButtonSize  = [75,60,70,35]
GoogleXYaxisMMMButtonTitle = '- - -'
x1 = 5
y1 = 3
scr_y = 6
scr_x = 15
GoogleXYaxisMMButtonSize   = [GoogleXYaxisMMMButtonSize[0]+GoogleXYaxisMMMButtonSize[2]+x1,$
                              GoogleXYaxisMMMButtonSize[1]+y1,$
                              GoogleXYaxisMMMButtonSize[2]-scr_x,$
                              GoogleXYaxisMMMButtonSize[3]-scr_y]
GoogleXYaxisMMButtonTitle = '- -'
GoogleXYAxisMButtonSize   = [GoogleXYaxisMMButtonSize[0]+GoogleXYaxisMMButtonSize[2]+x1,$
                             GoogleXYaxisMMButtonSize[1]+y1,$
                             GoogleXYaxisMMButtonSize[2]-scr_x,$
                             GoogleXYaxisMMButtonSize[3]-scr_y]
GoogleXYaxisMButtonTitle  = '-'
;reset button
GoogleResetButtonSize    = [GoogleXYaxisMButtonSize[0]+GoogleXYaxisMButtonSize[2]+x1,$
                            GoogleXYaxisMButtonSize[1]+y1,$
                            60,$
                            GoogleXYaxisMButtonSize[3]-scr_y]
GoogleResetButtonTitle   = 'RESET'

;P, PP and PPP
GoogleXYaxisPButtonSize   = [GoogleResetButtonSize[0]+GoogleResetButtonSize[2]+x1,$
                            GoogleXYaxisMButtonSize[1:3]]
GoogleXYaxisPButtonTitle  = '+'
GoogleXYaxisPPButtonSize  = [GoogleXYaxisPButtonSize[0]+GoogleXYaxisPButtonSize[2]+x1,$
                            GoogleXYaxisMMButtonSize[1:3]]
GoogleXYaxisPPButtonTitle = '+ +'
GoogleXYaxisPPPButtonSize = [GoogleXYaxisPPButtonSize[0]+GoogleXYaxisPPButtonSize[2]+x1,$
                             GoogleXYaxisMMMButtonSize[1:3]]
GoogleXYaxisPPPButtonTitle = '+ + +'

;google z-axis PP/P/M/MM
xoff = 100
GoogleZaxisPPPButtonSize  = [255,0,60,30]
GoogleZaxisPPPButtonTitle = '+ + +'
x1_off = 4
y1_off = 1
scr_xsize = 7
scr_ysize = 8
GoogleZaxisPPButtonSize   = [GoogleZaxisPPPButtonSize[0]+x1_off,$
                             GoogleZaxisPPPButtonSize[1]+GoogleZAxisPPPButtonSize[3]+y1_off,$
                             GoogleZaxisPPPButtonSize[2]-scr_xsize,$
                             GoogleZaxisPPPButtonSize[3]-scr_ysize]
GoogleZaxisPPButtonTitle  = '+ +'
GoogleZaxisPButtonSize   = [GoogleZaxisPPButtonSize[0]+x1_off,$
                            GoogleZaxisPPButtonSize[1]+GoogleZaxisPPButtonSize[3]+y1_off,$
                            GoogleZaxisPPButtonSize[2]-scr_xsize,$
                            GoogleZaxisPPButtonSize[3]-scr_ysize]
GoogleZaxisPButtonTitle  = '+'
GoogleZaxisMButtonSize   = [GoogleZaxisPButtonSize[0],$
                            GoogleResetButtonSize[1]+GoogleResetButtonSize[3]+y1_off,$
                            GoogleZaxisPButtonSize[2:3]]
GoogleZaxisMButtonTitle  = '-'
GoogleZaxisMMButtonSize  = [GoogleZaxisPPButtonSize[0],$
                            GoogleZaxisMButtonSize[1]+GoogleZaxisMButtonSize[3]+y1_off,$
                            GoogleZaxisPPButtonSize[2:3]]
GoogleZaxisMMButtonTitle = '- -'
GoogleZaxisMMMButtonSize  = [GoogleZaxisPPPButtonSize[0],$
                            GoogleZaxisMMButtonSize[1]+GoogleZaxisMMButtonSize[3]+y1_off,$
                            GoogleZaxisPPPButtonSize[2:3]]
GoogleZaxisMMMButtonTitle = '- - -'

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
                                  uname='load_data_d_3d_draw',$
                                  retain=2,$
                                  /button_events,$
                                  /motion_events)

RescaleTab = WIDGET_TAB(load_data_D_3D_tab_base,$
                        UNAME     = 'data_rescale_tab',$
                        LOCATION  = 2,$
                        XOFFSET   = RescaleTabSize[0],$
                        YOFFSET   = RescaleTabSize[1],$
                        SCR_XSIZE = RescaleTabSize[2],$
                        SCR_YSIZE = RescaleTabSize[3],$
                        /TRACKING_EVENTS)

;### First tab - Manual mode
RescaleTab1Base = WIDGET_BASE(RescaleTab,$
                               UNAME     = 'data_rescale_tab1_base',$
                               XOFFSET   = RescaleBaseSize[0],$
                               YOFFSET   = RescaleBaseSize[1],$
                               SCR_XSIZE = RescaleBaseSize[2],$
                               SCR_YSIZE = RescaleBaseSize[3],$
                               TITLE     = RescaleTab1Title)
                              
;X-AXIS
XaxisLabel = WIDGET_LABEL(RescaleTab1Base,$
                          XOFFSET  = XaxisLabelSize[0],$
                          YOFFSET  = XaxisLabelSize[1],$
                          VALUE    = XaxisLabelTitle)

XaxisScale = WIDGET_DROPLIST(RescaleTab1Base,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = XaxisScaleSize[0],$
                             YOFFSET = XaxisScaleSize[1],$
                             UNAME   = 'data1d_x_axis_scale')

XaxisLabelFrame = WIDGET_LABEL(RescaleTab1Base,$
                               XOFFSET   = XaxisLabelFrameSize[0],$
                               YOFFSET   = XaxisLabelFrameSize[1],$
                               SCR_XSIZE = XaxisLabelFrameSize[2],$
                               SCR_YSIZE = XaxisLabelFrameSize[3],$
                               VALUE     = '',$
                               FRAME     = 1)

; Y-AXIS
YaxisLabel = WIDGET_LABEL(RescaleTab1Base,$
                          XOFFSET  = YaxisLabelSize[0],$
                          YOFFSET  = YaxisLabelSize[1],$
                          VALUE    = YaxisLabelTitle)

YaxisScale = WIDGET_DROPLIST(RescaleTab1Base,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = YaxisScaleSize[0],$
                             YOFFSET = YaxisScaleSize[1],$
                             UNAME   = 'data1d_y_axis_scale')

YaxisLabelFrame = WIDGET_LABEL(RescaleTab1Base,$
                               XOFFSET   = YaxisLabelFrameSize[0],$
                               YOFFSET   = YaxisLabelFrameSize[1],$
                               SCR_XSIZE = YaxisLabelFrameSize[2],$
                               SCR_YSIZE = YaxisLabelFrameSize[3],$
                               VALUE     = '',$
                               FRAME     = 1)

;loadct
LoadctLabel = WIDGET_LABEL(RescaleTab1Base,$
                           XOFFSET = LoadctLabelSize[0],$
                           YOFFSET = LoadctLabelSize[1],$
                           VALUE   = LoadctLabelTitle)

LoadctDroplist = WIDGET_DROPLIST(RescaleTab1Base,$
                                 VALUE     = LoadctList,$
                                 UNAME     = 'data_loadct_1d_3d_droplist',$
                                 XOFFSET   = LoadctDroplistSize[0],$
                                 YOFFSET   = LoadctDroplistSize[1],$
                                 SENSITIVE = 1,$
                                 /TRACKING_EVENTS)

LoadctLabelFrame = WIDGET_LABEL(RescaleTab1Base,$
                                FRAME = 1,$
                                XOFFSET = LoadctLabelFrameSize[0],$
                                YOFFSET = LoadctLabelFrameSize[1],$
                                SCR_XSIZE = LoadctLabelFrameSize[2],$
                                SCR_YSIZE = LoadctLabelFrameSize[3])

; Z-AXIS
ZaxisLabel = WIDGET_LABEL(RescaleTab1Base,$
                          XOFFSET  = ZaxisLabelSize[0],$
                          YOFFSET  = ZaxisLabelSize[1],$
                          VALUE    = ZaxisLabelTitle)

ZaxisScale = WIDGET_DROPLIST(RescaleTab1Base,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = ZaxisScaleSize[0],$
                             YOFFSET = ZaxisScaleSize[1],$
                             UNAME   = 'data1d_z_axis_scale')

ZaxisLabelFrame = WIDGET_LABEL(RescaleTab1Base,$
                               XOFFSET   = ZaxisLabelFrameSize[0],$
                               YOFFSET   = ZaxisLabelFrameSize[1],$
                               SCR_XSIZE = ZaxisLabelFrameSize[2],$
                               SCR_YSIZE = ZaxisLabelFrameSize[3],$
                               VALUE     = '',$
                               FRAME     = 1)



; ZaxisMinBase = WIDGET_BASE(RescaleBase,$
;                            XOFFSET   = ZaxisMinBaseSize[0],$
;                            YOFFSET   = ZaxisMinBaseSize[1],$
;                            SCR_XSIZE = ZaxisMinBaseSize[2],$
;                            SCR_YSIZE = ZaxisMinBaseSize[3],$
;                            UNAME     = 'data_z_axis_min_base')

; ZaxisMinCwfield = CW_FIELD(ZaxisMinBase,$
;                            ROW           = 1,$
;                            XSIZE         = 5,$
;                            YSIZE         = 1,$
;                            /FLOAT,$
;                            RETURN_EVENTS = 1,$
;                            TITLE         = ZaxisMinBaseTitle,$
;                            UNAME         = 'data1d_z_axis_min_cwfield')

; ZaxisMaxBase = WIDGET_BASE(RescaleBase,$
;                            XOFFSET   = ZaxisMaxBaseSize[0],$
;                            YOFFSET   = ZaxisMaxBaseSize[1],$
;                            SCR_XSIZE = ZaxisMaxBaseSize[2],$
;                            SCR_YSIZE = ZaxisMaxBaseSize[3],$
;                            UNAME     = 'data1d_z_axis_max_base')

; ZaxisMaxCwfield = CW_FIELD(ZaxisMaxBase,$
;                            ROW           = 1,$
;                            XSIZE         = 5,$
;                            YSIZE         = 1,$
;                            /FLOAT,$
;                            RETURN_EVENTS = 1,$
;                            TITLE         = ZaxisMaxBaseTitle,$
;                            UNAME         = 'data1d_z_axis_max_cwfield')



; ZaxisResetButton = WIDGET_BUTTON(RescaleBase,$
;                                  XOFFSET   = ZaxisResetButtonSize[0],$
;                                  YOFFSET   = ZaxisResetButtonSize[1],$
;                                  SCR_XSIZE = ZaxisResetButtonSize[2],$
;                                  SCR_YSIZE = ZaxisResetButtonSize[3],$
;                                  VALUE     = ZaxisResetButtonTitle,$
;                                  SENSITIVE = 1,$
;                                  UNAME     = 'data1d_z_axis_reset_button')



















;### Second tab - Automatic mode
RescaleTab2Base = WIDGET_BASE(RescaleTab,$
                              UNAME     = 'data_rescale_tab2_base',$
                              XOFFSET   = RescaleBaseSize[0],$
                              YOFFSET   = RescaleBaseSize[1],$
                              SCR_XSIZE = RescaleBaseSize[2],$
                              SCR_YSIZE = RescaleBaseSize[3],$
                              TITLE     = RescaleTab2Title)


;GOOGLE XY-AXIS
GoogleXYaxisMMMButton = WIDGET_BUTTON(RescaleTab2Base,$
                                    XOFFSET   = GoogleXYaxisMMMButtonSize[0],$
                                    YOFFSET   = GoogleXYaxisMMMButtonSize[1],$
                                    SCR_XSIZE = GoogleXYaxisMMMButtonSize[2],$
                                    SCR_YSIZE = GoogleXYaxisMMMButtonSize[3],$
                                    VALUE     = GoogleXYaxisMMMButtonTitle,$
                                    UNAME     = 'data1d_google_xy_axis_mmm_button',$
                                    SENSITIVE = 1)

GoogleXYaxisMMButton = WIDGET_BUTTON(RescaleTab2Base,$
                                    XOFFSET   = GoogleXYaxisMMButtonSize[0],$
                                    YOFFSET   = GoogleXYaxisMMButtonSize[1],$
                                    SCR_XSIZE = GoogleXYaxisMMButtonSize[2],$
                                    SCR_YSIZE = GoogleXYaxisMMButtonSize[3],$
                                    VALUE     = GoogleXYaxisMMButtonTitle,$
                                    UNAME     = 'data1d_google_xy_axis_mm_button',$
                                    SENSITIVE = 1)

GoogleXYaxisMButton = WIDGET_BUTTON(RescaleTab2Base,$
                                   XOFFSET   = GoogleXYaxisMButtonSize[0],$
                                   YOFFSET   = GoogleXYaxisMButtonSize[1],$
                                   SCR_XSIZE = GoogleXYaxisMButtonSize[2],$
                                   SCR_YSIZE = GoogleXYaxisMButtonSize[3],$
                                   VALUE     = GoogleXYaxisMButtonTitle,$
                                   UNAME     = 'data1d_google_xy_axis_m_button',$
                                   SENSITIVE = 1)

GoogleXYaxisPPButton = WIDGET_BUTTON(RescaleTab2Base,$
                                    XOFFSET   = GoogleXYaxisPPButtonSize[0],$
                                    YOFFSET   = GoogleXYaxisPPButtonSize[1],$
                                    SCR_XSIZE = GoogleXYaxisPPButtonSize[2],$
                                    SCR_YSIZE = GoogleXYaxisPPButtonSize[3],$
                                    VALUE     = GoogleXYaxisPPButtonTitle,$
                                    UNAME     = 'data1d_google_xy_axis_pp_button',$
                                    SENSITIVE = 1)

GoogleXYaxisPButton = WIDGET_BUTTON(RescaleTab2Base,$
                                   XOFFSET   = GoogleXYaxisPButtonSize[0],$
                                   YOFFSET   = GoogleXYaxisPButtonSize[1],$
                                   SCR_XSIZE = GoogleXYaxisPButtonSize[2],$
                                   SCR_YSIZE = GoogleXYaxisPButtonSize[3],$
                                   VALUE     = GoogleXYaxisPButtonTitle,$
                                   UNAME     = 'data1d_google_xy_axis_p_button',$
                                   SENSITIVE = 1)

GoogleXYaxisPPPButton = WIDGET_BUTTON(RescaleTab2Base,$
                                      XOFFSET   = GoogleXYaxisPPPButtonSize[0],$
                                      YOFFSET   = GoogleXYaxisPPPButtonSize[1],$
                                      SCR_XSIZE = GoogleXYaxisPPPButtonSize[2],$
                                      SCR_YSIZE = GoogleXYaxisPPPButtonSize[3],$
                                      VALUE     = GoogleXYaxisPPPButtonTitle,$
                                      UNAME     = 'data1d_google_xy_axis_ppp_button',$
                                      SENSITIVE = 1)
;RESET
GoogleResetButton = WIDGET_BUTTON(RescaleTab2Base,$
                                  XOFFSET   = GoogleResetButtonSize[0],$
                                  YOFFSET   = GoogleResetButtonSize[1],$
                                  SCR_XSIZE = GoogleResetButtonSize[2],$
                                  SCR_YSIZE = GoogleResetButtonSize[3],$
                                  UNAME     = 'data1d_google_reset_button',$
                                  VALUE     = GoogleResetButtonTitle,$
                                  SENSITIVE = 1)


;GOOGLE Z-AXIS
GoogleZaxisPPPButton = WIDGET_BUTTON(RescaleTab2Base,$
                                     XOFFSET   = GoogleZaxisPPPButtonSize[0],$
                                     YOFFSET   = GoogleZaxisPPPButtonSize[1],$
                                     SCR_XSIZE = GoogleZaxisPPPButtonSize[2],$
                                     SCR_YSIZE = GoogleZaxisPPPButtonSize[3],$
                                     VALUE     = GoogleZaxisPPPButtonTitle,$
                                     UNAME     = 'data1d_google_z_axis_ppp_button',$
                                     SENSITIVE = 1)

GoogleZaxisPPButton = WIDGET_BUTTON(RescaleTab2Base,$
                                    XOFFSET   = GoogleZaxisPPButtonSize[0],$
                                    YOFFSET   = GoogleZaxisPPButtonSize[1],$
                                    SCR_XSIZE = GoogleZaxisPPButtonSize[2],$
                                    SCR_YSIZE = GoogleZaxisPPButtonSize[3],$
                                    VALUE     = GoogleZaxisPPButtonTitle,$
                                    UNAME     = 'data1d_google_z_axis_pp_button',$
                                    SENSITIVE = 1)

GoogleZaxisPButton = WIDGET_BUTTON(RescaleTab2Base,$
                                   XOFFSET   = GoogleZaxisPButtonSize[0],$
                                   YOFFSET   = GoogleZaxisPButtonSize[1],$
                                   SCR_XSIZE = GoogleZaxisPButtonSize[2],$
                                   SCR_YSIZE = GoogleZaxisPButtonSize[3],$
                                   VALUE     = GoogleZaxisPButtonTitle,$
                                   UNAME     = 'data1d_google_z_axis_p_button',$
                                   SENSITIVE = 1)

GoogleZaxisMButton = WIDGET_BUTTON(RescaleTab2Base,$
                                    XOFFSET   = GoogleZaxisMButtonSize[0],$
                                    YOFFSET   = GoogleZaxisMButtonSize[1],$
                                    SCR_XSIZE = GoogleZaxisMButtonSize[2],$
                                    SCR_YSIZE = GoogleZaxisMButtonSize[3],$
                                    VALUE     = GoogleZaxisMButtonTitle,$
                                    UNAME     = 'data1d_google_z_axis_m_button',$
                                    SENSITIVE = 1)

GoogleZaxisMMButton = WIDGET_BUTTON(RescaleTab2Base,$
                                   XOFFSET   = GoogleZaxisMMButtonSize[0],$
                                   YOFFSET   = GoogleZaxisMMButtonSize[1],$
                                   SCR_XSIZE = GoogleZaxisMMButtonSize[2],$
                                   SCR_YSIZE = GoogleZaxisMMButtonSize[3],$
                                   VALUE     = GoogleZaxisMMButtonTitle,$
                                   UNAME     = 'data1d_google_z_axis_mm_button',$
                                   SENSITIVE = 1)

GoogleZaxisMMMButton = WIDGET_BUTTON(RescaleTab2Base,$
                                     XOFFSET   = GoogleZaxisMMMButtonSize[0],$
                                     YOFFSET   = GoogleZaxisMMMButtonSize[1],$
                                     SCR_XSIZE = GoogleZaxisMMMButtonSize[2],$
                                     SCR_YSIZE = GoogleZaxisMMMButtonSize[3],$
                                     VALUE     = GoogleZaxisMMMButtonTitle,$
                                     UNAME     = 'data1d_google_z_axis_mmm_button',$
                                     SENSITIVE = 1)

GoogleRotationTitle = WIDGET_LABEL(RescaleTab2Base,$
                                   XOFFSET = GoogleRotationBaseTitleSize[0],$
                                   YOFFSET = GoogleRotationBaseTitleSize[1],$
                                   VALUE   = GoogleRotationBaseTitle)

END





PRO REMOVE_ME

;XY and Z axis angle interaction
XYaxisLabel = WIDGET_LABEL(RescaleBase,$
                           XOFFSET  = XYaxisLabelSize[0],$
                           YOFFSET  = XYaxisLabelSize[1],$
                           VALUE    = XYaxisLabelTitle)

XYaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = XYaxisAngleResetButtonSize[0],$
                                 YOFFSET   = XYaxisAngleResetButtonSize[1],$
                                 SCR_XSIZE = XYaxisAngleResetButtonSize[2],$
                                 SCR_YSIZE = XYaxisAngleResetButtonSize[3],$
                                 VALUE     = XYaxisAngleResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'data1d_xy_axis_reset_button')

XYaxisAngleBase = WIDGET_BASE(RescaleBase,$
                              XOFFSET   = XYaxisAngleBaseSize[0],$
                              YOFFSET   = XYaxisAngleBaseSize[1],$
                              SCR_XSIZE = XYaxisAngleBaseSize[2],$
                              SCR_YSIZE = XYaxisAngleBaseSize[3],$
                              UNAME     = 'data_xy_axis_angle_base')

XYaxisAngleCwfield = CW_FIELD(XYaxisAngleBase,$
                              ROW           = 1,$
                              XSIZE         = 3,$
                              YSIZE         = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = XYaxisAngleBaseTitle,$
                              UNAME         = 'data1d_xy_axis_angle_cwfield')

ZZaxisLabel = WIDGET_LABEL(RescaleBase,$
                           XOFFSET  = ZZaxisLabelSize[0],$
                           YOFFSET  = ZZaxisLabelSize[1],$
                           VALUE    = ZZaxisLabelTitle)

ZZaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = ZZaxisAngleResetButtonSize[0],$
                                 YOFFSET   = ZZaxisAngleResetButtonSize[1],$
                                 SCR_XSIZE = ZZaxisAngleResetButtonSize[2],$
                                 SCR_YSIZE = ZZaxisAngleResetButtonSize[3],$
                                 VALUE     = ZZaxisAngleResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'data1d_zz_axis_reset_button')

ZZaxisAngleBase = WIDGET_BASE(RescaleBase,$
                              XOFFSET   = ZZaxisAngleBaseSize[0],$
                              YOFFSET   = ZZaxisAngleBaseSize[1],$
                              SCR_XSIZE = ZZaxisAngleBaseSize[2],$
                              SCR_YSIZE = ZZaxisAngleBaseSize[3],$
                              UNAME     = 'data_zz_axis_angle_base')

ZZaxisAngleCwfield = CW_FIELD(ZZaxisAngleBase,$
                              ROW           = 1,$
                              XSIZE         = 3,$
                              YSIZE         = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = ZZaxisAngleBaseTitle,$
                              UNAME         = 'data1d_zz_axis_angle_cwfield')


END

