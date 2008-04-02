PRO MakeGuiMainTab, MAIN_BASE, MainBaseSize, XYfactor

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

;Tab titles
SelectionTitle   = '  S E L E C T I O N  '
ReduceTitle      = '  R E D U C E  '
OutputTitle      = '  O U T P U T '
LogBookTitle     = '  L O G   B O O K  '

;build widgets
MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
                      UNAME     = 'main_tab',$
                      LOCATION  = 0,$
                      XOFFSET   = MainTabSize[0],$
                      YOFFSET   = MainTabSize[1],$
                      SCR_XSIZE = MainTabSize[2],$
                      SCR_YSIZE = MainTabSize[3],$
                      SENSITIVE = 1,$
                      /TRACKING_EVENTS)

;build SELECTION tab
MakeGuiSelectionTab, MAIN_TAB, MainTabSize, SelectionTitle, XYfactor, MAIN_BASE

;build REDUCE tab
MakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTitle

;build OUTPUT tab
MakeGuiOutputTab, MAIN_TAB, MainTabsize, OutputTitle

;build LogBook tab
MakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTitle

END
