;==============================================================================

PRO make_gui_tab2, MAIN_TAB, MainTabSize, title

;Log Book Text
XYoff = [10,10]
sLogText = { size: [XYoff[0],$
                    XYoff[1],$
                    MainTabSize[2]-2*XYoff[0],$
                    MainTabSize[3]-80],$
             uname: 'log_book_text'}       

;Label for message
XYoff = [0,10]
sLabel = { size: [sLogText.size[0]+XYoff[0],$
                  sLogText.size[1]+$
                  sLogText.size[3]+$
                  XYoff[1]],$
           value: 'Message:'}
           
;text space for message
XYoff = [55,-6]
sTextField = { size: [sLabel.size[0]+XYoff[0],$
                      sLabel.size[1]+XYoff[1],$
                      625],$
               uname: 'log_book_message'}

;button to launch send log book
XYoff = [0,0]
sButton = { size: [sTextField.size[0]+$
                   sTextField.size[2]+$
                   XYoff[0],$
                   sTextField.size[1]+$
                   XYoff[1],$
                   100,$
                   30],$
            uname: 'send_to_geek_button',$
            value: 'SEND TO GEEK'}

;-----------------------------------------------------------------------------
Base = WIDGET_BASE(MAIN_TAB,$
                   UNAME     = 'tab2',$
                   XOFFSET   = MainTabSize[0],$
                   YOFFSET   = MainTabSize[1],$
                   SCR_XSIZE = MainTabSize[2],$
                   SCR_YSIZE = MainTabSize[3],$
                   TITLE     = title,$
                   map = 0)

text = WIDGET_TEXT(Base,$
                   XOFFSET   = sLogText.size[0],$
                   YOFFSET   = sLogText.size[1],$
                   SCR_XSIZE = sLogText.size[2],$
                   SCR_YSIZE = sLogText.size[3],$
                   UNAME     = sLogText.uname,$
                   /WRAP,$
                   /SCROLL)

wLabel = WIDGET_LABEL(Base,$
                      XOFFSET = sLabel.size[0],$
                      YOFFSET = sLabel.size[1],$
                      VALUE   = sLabel.value)

wTextField = WIDGET_TEXT(Base,$
                         XOFFSET   = sTextField.size[0],$
                         YOFFSET   = sTextField.size[1],$
                         SCR_XSIZE = sTextField.size[2],$
;                         SCR_YSIZE = sTextField.size[3],$
                         UNAME     = sTextField.uname,$
                         /EDITABLE)

wButton = WIDGET_BUTTON(Base,$
                        XOFFSET   = sButton.size[0],$
                        YOFFSET   = sButton.size[1],$
                        SCR_XSIZE = sButton.size[2],$
                        SCR_YSIZE = sButton.size[3],$
                        UNAME     = sButton.uname,$
                        VALUE     = sButton.value)

END



