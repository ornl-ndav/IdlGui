;==============================================================================

PRO MakeGuiMainBase, MAIN_BASE, global

MainBaseSize = (*global).MainBaseSize

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

XYoff = [0,0]
sMainTabSize = [XYoff[0], $
                        XYoff[1],$
                        MainBaseSize[2], $
                        MainBaseSize[3]]

;Tab titles
TabTitles = { tab1:     'TAB 1',$
              tab2:  'TAB 2'}

;build widgets

MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
                      UNAME     = 'main_tab',$
                      LOCATION  = 0,$
                      XOFFSET   = sMainTabSize[0],$
                      YOFFSET   = sMainTabSize[1],$
                      SCR_XSIZE = sMainTabSize[2],$
                      SCR_YSIZE = sMainTabSize[3],$
                      SENSITIVE = 1,$
                      /TRACKING_EVENTS)


make_gui_tab1, MAIN_TAB, sMainTabSize, TabTitles.tab1
;make_gui_tab2, MAIN_TAB, sMainTabSize, TabTitles.tab2

END
