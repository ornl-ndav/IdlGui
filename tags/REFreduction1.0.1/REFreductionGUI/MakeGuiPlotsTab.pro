PRO MakeGuiPlotsTab, MAIN_TAB, MainTabSize, PlotsTabTitle, PlotsTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
PlotsTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

;Build widgets
PLOTS_BASE = WIDGET_BASE(MAIN_TAB,$
                         UNAME='plots_base',$
                         TITLE=PlotsTabTitle,$
                         XOFFSET=PlotsTabSize[0],$
                         YOFFSET=PlotsTabSize[1],$
                         SCR_XSIZE=PlotsTabSize[2],$
                         SCR_YSIZE=PlotsTabSize[3])

;Build Main plot and Intermediate plots tab
MakeGuiPlotsMainIntermediatesBases, PLOTS_BASE, PlotsTitle

END
