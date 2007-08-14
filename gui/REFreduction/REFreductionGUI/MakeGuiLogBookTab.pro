PRO MakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LogBookTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

LogBookTextFieldSize = [10,10,1175,800]

;Build widgets
LOG_BOOK_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME='Log_book_base',$
                          TITLE=LogBookTabTitle,$
                          XOFFSET=LogBookTabSize[0],$
                          YOFFSET=LogBookTabSize[1],$
                          SCR_XSIZE=LogBookTabSize[2],$
                          SCR_YSIZE=LogBookTabSize[3])

Log_book_text_field = widget_text(LOG_BOOK_BASE,$
                                  UNAME='log_book_text_field',$
                                  xoffset=LogBookTextFieldSize[0],$
                                  yoffset=LogBookTextFieldSize[1],$
                                  scr_xsize=LogBookTextFieldSize[2],$
                                  scr_ysize=LogBookTextFieldSize[3],$
                                  /scroll,$
                                  /wrap)

END
