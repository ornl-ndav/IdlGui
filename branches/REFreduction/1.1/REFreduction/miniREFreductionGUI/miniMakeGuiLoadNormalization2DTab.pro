PRO miniMakeGuiLoadNormalization2DTab, D_DD_Tab,$
                                       D_DD_BaseSize,$
                                       D_DD_TabTitle,$
                                       GlobalLoadGraphs

;Build 2D tab
load_normalization_DD_TAB_BASE = $
  WIDGET_BASE(D_DD_Tab,$
              UNAME='load_normalization_dd_tab_base',$
              TITLE=D_DD_TabTitle[1],$
              XOFFSET=D_DD_BaseSize[0],$
              YOFFSET=D_DD_BaseSize[1],$
              SCR_XSIZE=D_DD_BaseSize[2],$
              SCR_YSIZE=D_DD_BaseSize[3])

load_normalization_DD_draw = WIDGET_DRAW(load_normalization_DD_tab_base,$
                                         XOFFSET=GlobalLoadGraphs[4],$
                                         YOFFSET=GlobalLoadGraphs[5],$
                                         SCR_XSIZE=GlobalLoadGraphs[6],$
                                         SCR_YSIZE=GlobalLoadGraphs[7],$
                                         UNAME='load_normalization_DD_draw',$
                                         RETAIN=2,$
                                         /BUTTON_EVENTS,$
                                         /MOTION_EVENTS)

END
