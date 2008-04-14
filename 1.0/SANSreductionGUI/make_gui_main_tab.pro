PRO make_gui_main_tab, MAIN_BASE, MainBaseSize

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

;Tab titles
TabTitles = { tab1 : ' LOAD DATA '}

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

;Build Load Data Tab
make_gui_tab1, MAIN_TAB, MainBaseSize, TabTitles

END
