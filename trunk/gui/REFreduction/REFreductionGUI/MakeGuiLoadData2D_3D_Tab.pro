PRO MakeGuiLoadData2D_3D_Tab, D_DD_Tab, D_DD_BaseSize, D_DD_TabTitle, GlobalLoadGraphs

;Build 2D tab
load_data_DD_3D_TAB_BASE = widget_base(D_DD_Tab,$
                                       uname='load_data_dd_3d_tab_base',$
                                       title=D_DD_TabTitle[3],$
                                       xoffset=D_DD_BaseSize[0],$
                                       yoffset=D_DD_BaseSize[1],$
                                       scr_xsize=D_DD_BaseSize[2],$
                                       scr_ysize=D_DD_BaseSize[3])


load_data_DD_draw = widget_draw(load_data_DD_3D_tab_base,$
                                xoffset=GlobalLoadGraphs[4],$
                                yoffset=GlobalLoadGraphs[5],$
                                scr_xsize=GlobalLoadGraphs[6],$
                                scr_ysize=GlobalLoadGraphs[7],$
                                uname='load_data_DD_3d_draw',$
                                retain=2,$
                                /button_events,$
                                /motion_events)


END
