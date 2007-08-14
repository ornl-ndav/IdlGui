PRO MakeGuiLoadNormalization1DTab, D_DD_Tab, D_DD_TabSize, D_DD_TabTitle, GlobalLoadGraphs

;Build 1D tab
Load_Normalization_D_TAB_BASE = widget_base(D_DD_Tab,$
                                            uname='load_normalization_d_tab_base',$
                                            title=D_DD_TabTitle[0],$
                                            xoffset=D_DD_TabSize[0],$
                                            yoffset=D_DD_TabSize[1],$
                                            scr_xsize=D_DD_TabSize[2],$
                                            scr_ysize=D_DD_TabSize[3])

load_normalization_D_draw = widget_draw(load_normalization_D_tab_base,$
                                        xoffset=GlobalLoadGraphs[0],$
                                        yoffset=GlobalLoadGraphs[1],$
                                        scr_xsize=GlobalLoadGraphs[2],$
                                        scr_ysize=GlobalLoadGraphs[3],$
                                        uname='load_normalization_D_draw',$
                                        retain=2,$
                                        /button_events,$
                                        /motion_events)



END
