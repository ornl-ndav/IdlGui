PRO MakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LoadTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]
D_DD_TabSize  = [0,50,MainTabSize[2],MainTabSize[3]-50]
D_DD_TabTitle = ['   1 Dimension   ',$
                 '   2 Dimensions  ']

;Build widgets
LOAD_BASE = WIDGET_BASE(MAIN_TAB,$
                        UNAME='load_base',$
                        TITLE=LoadTabTitle,$
                        XOFFSET=LoadTabSize[0],$
                        YOFFSET=LoadTabSize[1],$
                        SCR_XSIZE=LoadTabSize[2],$
                        SCR_YSIZE=LoadTabSize[3])

;Build DATA and NORMALIZATION tabs
MakeGuiLoadDataNormalizationTab,$
  LOAD_BASE,$
  MainTabSize,$
  D_DD_TabSize,$
  D_DD_TabTitle

END
