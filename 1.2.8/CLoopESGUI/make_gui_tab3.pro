;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO make_gui_tab3, MAIN_TAB, MainTabSize, title

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
                   UNAME     = 'tab2_uname',$
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



