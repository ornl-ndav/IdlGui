PRO MakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTitle

LogBookBase = WIDGET_BASE(MAIN_TAB,$
                          XOFFSET   = 0,$
                          YOFFSET   = 0,$
                          SCR_XSIZE = MainTabSize[2],$
                          SCR_YSIZE = MainTabSize[3],$
                          TITLE     = LogBookTitle,$
                          COLUMN    = 1)

;log book text
fbase = WIDGET_BASE(LogBookBase,$
                    /BASE_ALIGN_CENTER)

text = WIDGET_TEXT(fbase,$
                   VALUE = '',$
                   UNAME = 'log_book',$
                   SCR_XSIZE=1190,$
                   SCR_YSIZE=655,$
                   /SCROLL,/WRAP)

;debug log_book
sbase = WIDGET_BASE(LogBookBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW=1)

label = WIDGET_LABEL(sbase,$
                     VALUE='Add message:',$
                     SCR_YSIZE = 30)

text = WIDGET_TEXT(sbase,$
                   UNAME='log_book_message',$
                   SCR_XSIZE = 955,$
                   SCR_YSIZE = 35,$
                   VALUE = '',$
                   /EDITABLE)

button = WIDGET_BUTTON(sbase,$
                       UNAME='send_log_book',$
                       VALUE='SEND LogBook TO GEEK',$
                       SCR_XSIZE=140,$
                       SCR_YSIZE=30)                    

END
