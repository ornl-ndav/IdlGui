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

PRO MakeGuiConfirmationBase, MAIN_BASE

;*******************************************************************************
;                           Define size arrays
;*******************************************************************************
confirm_base = { size  : [100, $
                          250, $
                          500, $
                          80],$
                 uname : 'confirmation_base',$
                 title : 'Confirmation box'}

label = { size  : [0,0],$
          value : '               Loading a new geometry will reset all your changes                 ',$
          frame : 1}

XY1off = [-0,40]
label2 = {size  : [label.size[0]+XY1off[0], $
                   label.size[1]+XY1off[1]],$
          value : 'Do you really want to load a new Geometry?'}

XYoff = [280,-7]
button1 = {size  : [label2.size[0]+XYoff[0],$
                    label2.size[1]+XYoff[1],$
                    100,30],$
           value : 'YES',$
           uname : 'yes_confirmation_button'}
          
XYoff = [0,0]
button2 = {size  : [button1.size[0]+button1.size[2],$
                    button1.size[1]+XYoff[1],$
                    button1.size[2],$
                    button1.size[3]],$
           value : 'NO',$
           uname : 'no_confirmation_button'}

;*******************************************************************************
;                                Build GUI
;*******************************************************************************
base1 = WIDGET_BASE(MAIN_BASE,$
                    UNAME        = confirm_base.uname,$
                    XOFFSET      = confirm_base.size[0],$
                    YOFFSET      = confirm_base.size[1],$
                    SCR_XSIZE    = confirm_base.size[2],$
                    SCR_YSIZE    = confirm_base.size[3],$
                    FRAME        = 3,$
                    MAP          = 0) ;remove 1 and put 0 back

label = WIDGET_LABEL(base1,$
                     XOFFSET   = label.size[0],$
                     YOFFSET   = label.size[1],$
                     FRAME     = label.frame,$
                     VALUE     = label.value)

label2 = WIDGET_LABEL(base1,$
                     XOFFSET   = label2.size[0],$
                     YOFFSET   = label2.size[1],$
                     VALUE     = label2.value)

button1 = WIDGET_BUTTON(base1,$
                       XOFFSET   = button1.size[0],$
                       YOFFSET   = button1.size[1],$
                       SCR_XSIZE = button1.size[2],$
                       SCR_YSIZE = button1.size[3],$
                       UNAME     = button1.uname,$
                       VALUE     = button1.value)

button2 = WIDGET_BUTTON(base1,$
                       XOFFSET   = button2.size[0],$
                       YOFFSET   = button2.size[1],$
                       SCR_XSIZE = button2.size[2],$
                       SCR_YSIZE = button2.size[3],$
                       UNAME     = button2.uname,$
                       VALUE     = button2.value)

END
