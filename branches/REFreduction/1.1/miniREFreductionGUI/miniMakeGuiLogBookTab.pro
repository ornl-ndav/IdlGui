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

PRO miniMakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LogBookTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]

LogBookTextFieldSize = [10,10,LogBookTabSize[2]-20,595]

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
