PRO MakeGuiLoadDataNormalizationTab, LOAD_BASE,$
                                     MainBaseSize,$
                                     D_DD_TabSize,$
                                     D_DD_BaseSize,$
                                     D_DD_TabTitle,$
                                     GlobalRunNumber,$
                                     RunNumberTitles,$
                                     GlobalLoadDataGraphs,$
                                     FileInfoSize

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
DataNormalizationTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

;Tab titles
DataTitle          = '         D A T A          '
NormalizationTitle = '      N O R M A L I Z A T I O N      '

;build widgets
DataNormalizationTab = WIDGET_TAB(LOAD_BASE,$
                                  UNAME='data_normalization_tab',$
                                  LOCATION=0,$
                                  XOFFSET=DataNormalizationTabSize[0],$
                                  YOFFSET=DataNormalizationTabSize[1],$
                                  SCR_XSIZE=DataNormalizationTabSize[2],$
                                  SCR_YSIZE=DataNormalizationTabSize[3],$
                                  /TRACKING_EVENTS)

;build DATA tab
MakeGuiLoadDataTab, DataNormalizationTab,$
  DataNormalizationTabSize,$
  DataTitle,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles,$
  GlobalLoadDataGraphs,$
  FileInfoSize


;build NORMALIZATION tab
MakeGuiLoadNormalizationTab, DataNormalizationTab,$
  DataNormalizationTabSize,$
  NormalizationTitle,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles,$
  GlobalLoadDataGraphs,$
  FileInfoSize

END
