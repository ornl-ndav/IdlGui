PRO MakeGuiLogBook, STEPS_TAB, StepsTabSize

;*******************************************************************************
;Define Parameters
;*******************************************************************************
sLogBookBase = { size  : [0,0,StepsTabSize[2:3]],$
                 uname : 'log_book_base',$
                 title : 'LOG BOOK'}

;------------------------------------------------------------------------------
;Log Book Text
sLogBook = { size  : [0,0,StepsTabSize[2]-5,315],$
             uname : 'log_book_text'}

;-------------------------------------------------------------------------------
;Send To Geek
XYoff = [0,5]
sSTG = { size : [XYoff[0],$
                 sLogBook.size[1]+sLogBook.size[3]+XYoff[1],$
                 StepsTabSize[2]-20]}

;*******************************************************************************
;Build GUI
;*******************************************************************************
wLogBookBase = WIDGET_BASE(STEPS_TAB,$
                           UNAME     = sLogBookBase.uname,$
                           XOFFSET   = sLogBookBase.size[0],$
                           YOFFSET   = sLogBookBase.size[1],$
                           SCR_XSIZE = sLogBookBase.size[2],$
                           SCR_YSIZE = sLogBookBase.size[3],$
                           TITLE     = sLogBookBase.title)

;------------------------------------------------------------------------------
;Log Book Text
wLogBook = WIDGET_TEXT(wLogBookBase,$
                       UNAME     = sLogBook.uname,$
                       XOFFSET   = sLogBook.size[0],$
                       YOFFSET   = sLogBook.size[1],$
                       SCR_XSIZE = sLogBook.size[2],$
                       SCR_YSIZE = sLogBook.size[3],$
                       /SCROLL,$
                       /WRAP)

;-------------------------------------------------------------------------------
;Send To Geek
STGinstance = obj_new('IDLsendToGeek', $
                      XOFFSET   = sSTG.size[0],$
                      YOFFSET   = sSTG.size[1],$
                      XSIZE     = sSTG.size[2],$
                      MAIN_BASE = wLogBookBase)

END
