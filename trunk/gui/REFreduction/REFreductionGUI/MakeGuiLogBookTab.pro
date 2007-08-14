PRO MakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LogBookTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

;Build widgets
LOG_BOOK_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME='Log_book_base',$
                          TITLE=LogBookTabTitle,$
                          XOFFSET=LogBookTabSize[0],$
                          YOFFSET=LogBookTabSize[1],$
                          SCR_XSIZE=LogBookTabSize[2],$
                          SCR_YSIZE=LogBookTabSize[3])


END
