PRO MakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
ReduceTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]


;Build widgets
REDUCE_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME='reduce_base',$
                          TITLE=ReduceTabTitle,$
                          XOFFSET=ReduceTabSize[0],$
                          YOFFSET=ReduceTabSize[1],$
                          SCR_XSIZE=ReduceTabSize[2],$
                          SCR_YSIZE=ReduceTabSize[3])


END
