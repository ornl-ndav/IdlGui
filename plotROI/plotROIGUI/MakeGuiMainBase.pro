PRO MakeGuiMainBase, MAIN_BASE

;///////////////////////////////////////
;         Nexus Input Box
;///////////////////////////////////////
NEBframe = { size  : [5,5,400,70],$
             frame : 3 }



;***************************************
;            BUILD GUI
;***************************************

wNEBframe = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET   = NEBframe.size[0],$
                         YOFFSET   = NEBframe.size[1],$
                         SCR_XSIZE = NEBframe.size[2],$
                         SCR_YSIZE = NEBframe.size[3],$
                         FRAME     = NEBframe.frame,$
                         VALUE     = '')


END
