PRO miniMakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LogBookTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

LogBookTextFieldSize = [10,10,LogBookTabSize[2]-20,605]

LabelSize  = [7, $
              LogBookTextFieldSize[3]+25]
LabelTitle = 'Message to add:'

OutputTextFieldSize = [105,LabelSize[1]-8,610,35]
 
SendLogBookButtonSize = [OutputTextFieldSize[0]+OutputTextFieldSize[2], $
                         OutputTextFieldSize[1], $
                         150,30]

SendLogBookButtonTitle = 'Send log Book to Geek'

;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

LOG_BOOK_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME     = 'Log_book_base',$
                          TITLE     = LogBookTabTitle,$
                          XOFFSET   = LogBookTabSize[0],$
                          YOFFSET   = LogBookTabSize[1],$
                          SCR_XSIZE = LogBookTabSize[2],$
                          SCR_YSIZE = LogBookTabSize[3])

Log_book_text_field = WIDGET_TEXT(LOG_BOOK_BASE,$
                                  UNAME     = 'log_book_text_field',$
                                  XOFFSET   = LogBookTextFieldSize[0],$
                                  YOFFSET   = LogBookTextFieldSize[1],$
                                  SCR_XSIZE = LogBookTextFieldSize[2],$
                                  SCR_YSIZE = LogBookTextFieldSize[3],$
                                  /SCROLL,$
                                  /WRAP)

LabelMessage = WIDGET_LABEL(LOG_BOOK_BASE,$
                            XOFFSET = LabelSize[0],$
                            YOFFSET = LabelSize[1],$
                            VALUE   = LabelTitle)

OutputTextField = WIDGET_TEXT(LOG_BOOK_BASE,$
                              XOFFSET   = OutputTextFieldSize[0],$
                              YOFFSET   = OutputTextFieldSize[1],$
                              SCR_XSIZE = OutputTextFieldSize[2],$
                              SCR_YSIZE = OutputTextFieldSize[3],$
                              UNAME     = 'log_book_output_text_field',$
                              /EDITABLE)

SendLogBookButton = WIDGET_BUTTON(LOG_BOOK_BASE,$
                                  XOFFSET   = SendLogBookButtonSize[0],$
                                  YOFFSET   = SendLogBookButtonSize[1],$
                                  SCR_XSIZE = SendLogBookButtonSize[2],$
                                  SCR_YSIZE = SendLogBookButtonSize[3],$
                                  VALUE     = SendLogBookButtonTitle,$
                                  UNAME     = 'send_log_book_button')

END
