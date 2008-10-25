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

PRO determinePositionOfApplication, sMainBase, sBase

;size of MainBase
MainBaseSize = sMainBase.global.MainBaseSize
xoffset = MainBaseSize[0]
yoffset = MainBaseSize[1]
xsize   = MainBaseSize[2]
ysize   = MainBaseSize[3]

;size of tof_base
tof_xsize = sBase.size[2]
tof_ysize = sbase.size[3]

;determine offset of tof_base
tof_xoffset = xoffset + FIX((xsize - tof_xsize)/2)
tof_yoffset = yoffset + FIX((ysize - tof_ysize)/2)

;put new value of tof_offset in structure
sBase.size[0] = tof_xoffset
sBase.size[1] = tof_yoffset

END

;-------------------------------------------------------------------------------
PRO DefineMainBase_event, Event
WIDGET_CONTROL, event.top, GET_UVALUE=sMainBase
wWidget =  Event.top            ;widget id

CASE Event.id OF

    Widget_Info(wWidget, FIND_BY_UNAME='draw'): BEGIN
    END

    ELSE:
ENDCASE
END

;-------------------------------------------------------------------------------
PRO DefineMainBase, sMainBase, wBase
ourGroup = WIDGET_BASE()

;define structures .............................................................
sBase = { size: [0,$
                 0,$
                 200,$
                 60],$
          uname: 'tof_main_base',$
          title: sMainBase.title,$
          frame: 1}
          
;determine position of application
determinePositionOfApplication, sMainBase, sBase

wBase = WIDGET_BASE(GROUP_LEADER = ourGroup,$
                    TITLE        = sBase.title,$
                    XOFFSET      = sBase.size[0],$
                    YOFFSET      = sBase.size[1],$
                    SCR_XSIZE    = sBase.size[2],$
                    SCR_YSIZE    = sBase.size[3],$
                    MAP          = 1,$
                    UNAME        = sBase.uname)

Widget_Control, /REALIZE, wBase
XManager, 'MAIN_BASE', wBase, /NO_BLOCK
END

;***** Class constructor *******************************************************
FUNCTION IDLmakeTOFbase::init, $
   GLOBAL = global,$
   TYPE   = type      ;'all','selection','monitor'

CASE (type) OF
  'all': BEGIN
     title = 'Defined Full Name of ASCII File for Full Detector'
  END
  'selection': BEGIN
     title = 'Defined Full Name of ASCII File for Selection only' + $
             ' Defined by the ROI File'
  END
  'monitor': BEGIN
     title = 'Defined Full Name of ASCII File for Monitor'
  END
ENDCASE

;design Main Base
sMainBase = { global:   GLOBAL,$
              title:    title}

;Design Main Base
DefineMainBase, sMainBase, wBase
WIDGET_CONTROL, wBase, SET_UVALUE = sMainBase
XMANAGER, "DefineMainBase", wBase, /NO_BLOCK
RETURN, 1
END

;*******************************************************************************
PRO IDLmakeTOFbase__define
struct = {IDLmakeTOFbase,$
          x         : 0,$ ;width of each pixel
          y         : 0,$ ;height of each pixel
          xoff      : 0,$
          yoff      : 0,$
          title     : '',$
          uname     : '',$
          DrawUname : ''}
END
