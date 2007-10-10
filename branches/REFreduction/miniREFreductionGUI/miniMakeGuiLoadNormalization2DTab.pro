PRO miniMakeGuiLoadNormalization2DTab, D_DD_Tab,$
                                   D_DD_BaseSize,$
                                   D_DD_TabTitle,$
                                   GlobalLoadGraphs

;Build 2D tab
load_normalization_DD_TAB_BASE = widget_base(D_DD_Tab,$
                                             uname='load_normalization_dd_tab_base',$
                                             title=D_DD_TabTitle[1],$
                                             xoffset=D_DD_BaseSize[0],$
                                             yoffset=D_DD_BaseSize[1],$
                                             scr_xsize=D_DD_BaseSize[2],$
                                             scr_ysize=D_DD_BaseSize[3])




load_normalization_DD_draw = widget_draw(load_normalization_DD_tab_base,$
                                         xoffset=GlobalLoadGraphs[4],$
                                         yoffset=GlobalLoadGraphs[5],$
                                         scr_xsize=GlobalLoadGraphs[6],$
                                         scr_ysize=GlobalLoadGraphs[7],$
                                         uname='load_normalization_DD_draw',$
                                         retain=2,$
                                         /button_events,$
                                         /motion_events)


END
