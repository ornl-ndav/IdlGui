PRO MakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LoadTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

;Build widgets
LOAD_BASE = WIDGET_BASE(MAIN_TAB,$
                        UNAME='load_base',$
                        TITLE=LoadTabTitle,$
                        XOFFSET=LoadTabSize[0],$
                        YOFFSET=LoadTabSize[1],$
                        SCR_XSIZE=LoadTabSize[2],$
                        SCR_YSIZE=LoadTabSize[3])

;Build DATA and NORMALIZATION tabs
MakeGuiLoadDataNormalizationTab, LOAD_BASE 



END
