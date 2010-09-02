;===============================================================================
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
;===============================================================================

PRO MakeGuiFinalResultBase, MAIN_BASE

;*******************************************************************************
;                           Define size arrays
;*******************************************************************************
confirm_base = { size  : [100, $
                          80, $
                          500, $
                          125],$
                 uname : 'final_result_base'}

label = { size  : [0,0],$
          value : '                    CREATION OF A NEW GEOMETRY FILE - ' + $
          'STATUS                      ',$
          frame : 1}

XYoff = [5,25]
text  = { size  : [label.size[0]+XYoff[0],$
                   label.size[0]+XYoff[1],$
                   490,$
                   65],$
          uname : 'final_result_text_field'}

XYoff = [277,text.size[3]]
button_error = { size      : [label.size[0]+XYoff[0],$
                              text.size[1]+XYoff[1],$
                              100,35],$
                 value     : 'ERROR LOG_BOOK',$
                 uname     : 'final_result_error_button',$
                 sensitive : 0}

XYoff = [377,text.size[3]]
button = { size      : [label.size[0]+XYoff[0],$
                        text.size[1]+XYoff[1],$
                        100,35],$
           value     : 'OK',$
           uname     : 'final_result_ok_button',$
           sensitive : 0}


;ERROR_LOG_BOOK
error_log_book_base = { size  : [100,$
                                 216,$
                                 confirm_base.size[2],$
                                 200],$
                        uname : 'error_log_book_base'}

error_log_book_label = { size  : [0,0],$
                         value : '             ERROR GENERATED DURING THE ' + $
                         'PRODUCTION OF THE GEOMETRY FILE           ',$
                         frame : 1}

xyoff = [5,25]
error_text  = { size  : [error_log_book_label.size[0]+xyoff[0],$
                         error_log_book_label.size[0]+xyoff[1],$
                         490,$
                         139],$
                uname : 'error_text_field'}

xyoff = [377,error_text.size[3]]
error_ok_button = { size      : [error_log_book_label.size[0]+xyoff[0],$
                                 error_text.size[1]+xyoff[1],$
                                 100,35],$
                    value     : 'CLOSE',$
                    uname     : 'close_error_log_book_button',$
                    sensitive : 0}

;*******************************************************************************
;                                build gui
;*******************************************************************************
base1 = widget_base(main_base,$
                    uname        = confirm_base.uname,$
                    xoffset      = confirm_base.size[0],$
                    yoffset      = confirm_base.size[1],$
                    scr_xsize    = confirm_base.size[2],$
                    scr_ysize    = confirm_base.size[3],$
                    frame        = 3,$
                    map          = 0)

label = widget_label(base1,$
                     xoffset   = label.size[0],$
                     yoffset   = label.size[1],$
                     frame     = label.frame,$
                     value     = label.value)

text1 = widget_text(base1,$
                    xoffset    = text.size[0],$
                    yoffset    = text.size[1],$
                    scr_xsize  = text.size[2],$
                    scr_ysize  = text.size[3],$
                    uname      = text.uname,$
                    /wrap,$
                    /scroll)

button1 = widget_button(base1,$
                        xoffset   = button_error.size[0],$
                        yoffset   = button_error.size[1],$
                        scr_xsize = button_error.size[2],$
                        scr_ysize = button_error.size[3],$
                        value     = button_error.value,$
                        uname     = button_error.uname,$
                        sensitive = button_error.sensitive)

button = widget_button(base1,$
                       xoffset   = button.size[0],$
                       yoffset   = button.size[1],$
                       scr_xsize = button.size[2],$
                       scr_ysize = button.size[3],$
                       uname     = button.uname,$
                       value     = button.value,$
                       sensitive = button.sensitive)
                    
;error base
base1 = WIDGET_BASE(MAIN_BASE,$
                    UNAME        = error_log_book_base.uname,$
                    XOFFSET      = error_log_book_base.size[0],$
                    YOFFSET      = error_log_book_base.size[1],$
                    SCR_XSIZE    = error_log_book_base.size[2],$
                    SCR_YSIZE    = error_log_book_base.size[3],$
                    FRAME        = 3,$
                    MAP          = 0)

error_log_book_label = WIDGET_LABEL(base1,$
                     XOFFSET   = error_log_book_label.size[0],$
                     YOFFSET   = error_log_book_label.size[1],$
                     FRAME     = error_log_book_label.frame,$
                     VALUE     = error_log_book_label.value)

error_text1 = WIDGET_TEXT(base1,$
                    XOFFSET    = error_text.size[0],$
                    YOFFSET    = error_text.size[1],$
                    SCR_XSIZE  = error_text.size[2],$
                    SCR_YSIZE  = error_text.size[3],$
                    UNAME      = error_text.uname,$
                    /WRAP,$
                    /SCROLL)

button1 = WIDGET_button(base1,$
                        XOFFSET   = error_ok_button.size[0],$
                        YOFFSET   = error_ok_button.size[1],$
                        SCR_XSIZE = error_ok_button.size[2],$
                        SCR_YSIZE = error_ok_button.size[3],$
                        VALUE     = error_ok_button.value,$
                        UNAME     = error_ok_button.uname)

END
