PRO miniMakeGuiSettingsTab, MAIN_TAB, MainTabSize, SettingsTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
SettingsTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

;Build widgets
SETTINGS_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME='settings_base',$
                          TITLE=SettingsTabTitle,$
                          XOFFSET=SettingsTabSize[0],$
                          YOFFSET=SettingsTabSize[1],$
                          SCR_XSIZE=SettingsTabSize[2],$
                          SCR_YSIZE=SettingsTabSize[3])


END
