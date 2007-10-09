PRO miniMakeGuiLoadNormalization1D2DTab, LOAD_DATA_BASE,$
                                     D_DD_TabSize,$
                                     D_DD_BaseSize,$
                                     D_DD_TabTitle,$
                                     GlobalLoadGraphs,$
                                     loadctList

load_normalization_D_DD_Tab = WIDGET_TAB(LOAD_DATA_BASE,$
                                         UNAME='load_normalization_d_dd_tab',$
                                         LOCATION=1,$
                                         xoffset=D_DD_TabSize[0],$
                                         yoffset=D_DD_TabSize[1],$
                                         scr_xsize=D_DD_TabSize[2],$
                                         scr_ysize=D_DD_TabSize[3],$
                                         /tracking_events)

;build Load_Data_1D tab
miniMakeGuiLoadNormalization1DTab,$
  load_normalization_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs,$
  loadctList

miniMakeGuiLoadNormalization1D_3D_Tab,$
   load_normalization_D_DD_Tab,$
   D_DD_BaseSize,$
   D_DD_TabTitle,$
   GlobalLoadGraphs,$
   loadctList

;build Load_Data_2D tab
miniMakeGuiLoadNormalization2DTab,$
  load_normalization_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs

miniMakeGuiLoadNormalization2D_3D_Tab,$
   load_normalization_D_DD_Tab,$
   D_DD_BaseSize,$
   D_DD_TabTitle,$
   GlobalLoadGraphs,$
   loadctlist

END
