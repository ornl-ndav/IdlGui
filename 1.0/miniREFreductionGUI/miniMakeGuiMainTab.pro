PRO miniMakeGuiMainTab, MAIN_BASE, MainBaseSize, instrument, PlotsTitle, debugger

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

;Tab titles
LoadTabTitle     = '       LOAD       ' 
ReduceTabTitle   = '      REDUCE      ' 
PlotsTabTitle    = '       PLOTS      ' 
BatchTabTitle    = '    BATCH MODE    ' 
LogBookTabTitle  = '     LOG BOOK     ' 

;build widgets
MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
                      UNAME     = 'main_tab',$
                      LOCATION  = 0,$
                      XOFFSET   = MainTabSize[0],$
                      YOFFSET   = MainTabSize[1],$
                      SCR_XSIZE = MainTabSize[2],$
                      SCR_YSIZE = MainTabSize[3],$
                      sensitive = 1,$
                      /TRACKING_EVENTS)

;build LOAD tab
miniMakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle, instrument

;build REDUCE tab
miniMakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTabTitle, PlotsTitle

;build PLOTS tab
miniMakeGuiPlotsTab, MAIN_TAB, MainTabSize, PlotsTabTitle, PlotsTitle

IF (debugger) THEN BEGIN
;;build BATCH MODE tab
    miniMakeGuiBatchTab, MAIN_TAB, MainTabSize, BatchTabTitle
ENDIF

;build LOG_BOOK tab
miniMakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

END
