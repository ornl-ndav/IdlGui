PRO MakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LogBookTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

LogBookTextFieldSize = [10,10,1175,800]

LabelSize  = [7,825]
LabelTitle = 'Message to add:'

OutputTextFieldSize = [105,LabelSize[1]-8,930,35]
 
SendLogBookButtonSize = [OutputTextFieldSize[0]+OutputTextFieldSize[2], $
                         OutputTextFieldSize[1], $
                         150,30]

SendLogBookButtonTitle = 'Send log Book to Geek'

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

LabelMessage = WIDGET_LABEL(LOG_BOOK_BASE,$
                            XOFFSET=LabelSize[0],$
                            YOFFSET=LabelSize[1],$
                            VALUE=LabelTitle)

OutputTextField = WIDGET_TEXT(LOG_BOOK_BASE,$
                              XOFFSET   = OutputTextFieldSize[0],$
                              YOFFSET   = OutputTextFieldSize[1],$
                              SCR_XSIZE = OutputTextFieldSize[2],$
                              SCR_YSIZE = OutputTextFieldSize[3],$
                              UNAME     = 'log_book_output_text_field',$
                              /EDITABLE)

SendLogBookButton = widget_button(LOG_BOOK_BASE,$
                                  xoffset=SendLogBookButtonSize[0],$
                                  yoffset=SendLogBookButtonSize[1],$
                                  scr_xsize=SendLogBookButtonSize[2],$
                                  scr_ysize=SendLogBookButtonSize[3],$
                                  value=SendLogBookButtonTitle,$
                                  uname='send_log_book_button')

END
