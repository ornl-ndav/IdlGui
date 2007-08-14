PRO MakeGuiLoadDataNormalizationTab, LOAD_BASE

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
DataNormalizationTabSize = [0,0,1000,600]

;Tab titles
DataTitle          = '       DATA       '
NormalizationTitle = '  NORMALIZATION   '

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
                    Datatitle

;build NORMALIZATION tab
MakeGuiLoadNormalizationTab, DataNormalizationTab,$
                             DataNormalizationTabSize,$
                             NormalizationTitle

END
