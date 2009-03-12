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

PRO MakeGuiEmptyCell, REDUCE_BASE, global

;determine position of base
xsize = 250
ysize = 280

xoffset  = 175
yoffset  = 100

sBase = { size: [xoffset,$
                 yoffset,$
                 xsize,$
                 ysize],$
          uname: 'empty_cell_or_data_background_base',$
          title: 'CONFLICT IN YOUR SELECTION!',$
          map: 0 }

XYoff = [10,0]
sLabel = { size: [0+XYoff[0],$
                  257+XYoff[1]],$
           value: 'Click the Direction you Want to Take!',$
           uname: 'direction_to_take_uname',$
           frame: 3}

wBase = WIDGET_BASE(REDUCE_BASE,$
                    XOFFSET      = sBase.size[0],$
                    YOFFSET      = sBase.size[1],$
                    SCR_XSIZE    = sBase.size[2],$
                    SCR_YSIZE    = sBase.size[3],$
                    MAP          = sBase.map,$
                    FRAME        = 10,$
                    TITLE        = sBase.title,$
                    UNAME        = sBase.uname)

data_background_draw = WIDGET_DRAW(wBase,$
                                   XOFFSET = 101,$
                                   YOFFSET = 7,$
                                   SCR_XSIZE = 118,$
                                   SCR_YSIZE = 42,$
                                   UNAME     = 'data_background_draw',$
                                   RETAIN=2,$
                                   /BUTTON_EVENTS,$
                                   /MOTION_EVENTS)

empty_cell_draw = WIDGET_DRAW(wBase,$
                              XOFFSET = 141,$
                              YOFFSET = 57,$
                              SCR_XSIZE = 109,$
                              SCR_YSIZE = 35,$
                              UNAME     = 'empty_cell_draw',$
                              RETAIN=2,$
                              /BUTTON_EVENTS,$
                              /MOTION_EVENTS)

draw1 = WIDGET_DRAW(wBase,$
                    XOFFSET = 0,$
                    YOFFSET = 0,$
                    SCR_XSIZE = 251,$
                    SCR_YSIZE = 257,$
                    UNAME     = 'confuse_background',$
                    RETAIN=2,$
                    /BUTTON_EVENTS,$
                    /MOTION_EVENTS)
 

 label = WIDGET_LABEL(wBase,$
                      XOFFSET = sLabel.size[0],$
                      YOFFSET = sLabel.size[1],$
                      VALUE   = sLabel.value,$
                      UNAME   = sLabel.uname)

END
