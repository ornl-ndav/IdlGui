PRO MakeGuiOutputTab, MAIN_TAB, MainTabSize, OutputBaseTitle

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************



;***********************************************************************************
;                                Build GUI
;***********************************************************************************
OutputBase = WIDGET_BASE(MAIN_TAB,$
                         XOFFSET   = 0,$
                         YOFFSET   = 0,$
                         SCR_XSIZE = MainTabSize[2],$
                         SCR_YSIZE = MainTabSize[3],$
                         TITLE     = OutputBaseTitle,$
                         UNAME     = 'output_base')


END
