PRO MakeGuiMainTab, MAIN_BASE, MainBaseSize

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

;Tab titles
LoadTabTitle     = '       LOAD       ' 
ReduceTabTitle   = '      REDUCE      ' 
PlotsTabTitle    = '       PLOTS      ' 
LogBookTabTitle  = '     LOG BOOK     ' 
SettingsTabTitle = '     SETTINGS     ' 

;build widgets
MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
                      UNAME='main_tab',$
                      LOCATION=0,$
                      XOFFSET=MainTabSize[0],$
                      YOFFSET=MainTabSize[1],$
                      SCR_XSIZE=MainTabSize[2],$
                      SCR_YSIZE=MainTabSize[3],$
                      /TRACKING_EVENTS)

;build LOAD tab
MakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle

;build REDUCE tab
MakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTabTitle

;build PLOTS tab
MakeGuiPlotsTab, MAIN_TAB, MainTabSize, PlotsTabTitle

;build LOG_BOOK tab
MakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

;build SETTINGS tab
MakeGuiSettingsTab, MAIN_TAB, MainTabSize, SettingsTabTitle


END
