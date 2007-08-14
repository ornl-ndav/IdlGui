PRO MakeGuiLoadData1D2DTab, LOAD_DATA_BASE,$
                            D_DD_TabSize,$
                            D_DD_BaseSize,$
                            D_DD_TabTitle,$
                            GlobalLoadGraphs

load_data_D_DD_Tab = WIDGET_TAB(LOAD_DATA_BASE,$
                                UNAME='load_data_d_dd_tab',$
                                LOCATION=0,$
                                xoffset=D_DD_TabSize[0],$
                                yoffset=D_DD_TabSize[1],$
                                scr_xsize=D_DD_TabSize[2],$
                                scr_ysize=D_DD_TabSize[3],$
                                /tracking_events)

;build Load_Data_1D tab
MakeGuiLoadData1DTab,$
  load_data_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs

;build Load_Data_2D tab
MakeGuiLoadData2DTab,$
  load_data_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs

END
