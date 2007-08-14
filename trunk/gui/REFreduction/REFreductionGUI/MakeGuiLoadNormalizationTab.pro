PRO MakeGuiLoadNormalizationTab, DataNormalizationTab,$
                                 DataNormalizationTabSize,$
                                 NormalizationTitle
  
;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LoadNormalizationTabSize = [0,0,$
                            DataNormalizationTabSize[2],$
                            DataNormalizationTabSize[3]]

;Build widgets
LOAD_NORMALIZATION_BASE = WIDGET_BASE(DataNormalizationTab,$
                                      UNAME='load_normalization_base',$
                                      TITLE=NormalizationTitle,$
                                      XOFFSET=LoadNormalizationTabSize[0],$
                                      YOFFSET=LoadNormalizationTabSize[1],$
                                      SCR_XSIZE=LoadNormalizationTabSize[2],$
                                      SCR_YSIZE=LoadNormalizationTabSize[3])

END
