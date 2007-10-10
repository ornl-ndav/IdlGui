PRO miniMakeGuiLoadData1D2DTab, LOAD_DATA_BASE,$
                            D_DD_TabSize,$
                            D_DD_BaseSize,$
                            D_DD_TabTitle,$
                            GlobalLoadGraphs,$
                            LoadctList

load_data_D_DD_Tab = WIDGET_TAB(LOAD_DATA_BASE,$
                                UNAME='load_data_d_dd_tab',$
                                LOCATION=1,$
                                xoffset=D_DD_TabSize[0],$
                                yoffset=D_DD_TabSize[1],$
                                scr_xsize=D_DD_TabSize[2],$
                                scr_ysize=D_DD_TabSize[3],$
                                /tracking_events)

;;first tab selected
;widget_control, load_data_D_DD_Tab, set_tab_current = 0 ;1D plot

;build Load_Data_1D tab
miniMakeGuiLoadData1DTab,$
  load_data_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs,$
  LoadctList


end
pro temp

miniMakeGuiLoadData1D_3D_Tab,$
  load_data_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs,$
  LoadctList
  
;build Load_Data_2D tab
miniMakeGuiLoadData2DTab,$
  load_data_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs

miniMakeGuiLoadData2D_3D_Tab,$
  load_data_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs,$
  LoadctList

END
