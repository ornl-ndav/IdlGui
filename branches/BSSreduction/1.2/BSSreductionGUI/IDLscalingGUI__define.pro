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

;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END

;------------------------------------------------------------------------------
PRO determinePositionOfApplication, sMainBase, sBase

;size of MainBase
MainBaseSize = (*sMainBase.global).MainBaseSize
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

;------------------------------------------------------------------------------
PRO DefineMainBase_event, Event
WIDGET_CONTROL, event.top, GET_UVALUE=sMainBase
wWidget =  Event.top            ;widget id

CASE Event.id OF

;Cancel 
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
                'job_status_scaling_cancel_button'): BEGIN
        WIDGET_CONTROL, Event.top, /DESTROY
    END

;Ok
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
                'job_status_scaling_ok_button'): BEGIN
        cmd = sMainBase.CMD
        value = getTextFieldValue(Event,'job_status_scaling_value')
        WIDGET_CONTROL, Event.top, /DESTROY
        cmd += ' --rescale=' + value
        stitch_files_step2, sMainBase.Event, cmd
    END

    ELSE:
ENDCASE
END

;------------------------------------------------------------------------------
PRO DefineMainBase, sMainBase, wBase
ourGroup = WIDGET_BASE()

;define structure .............................................................
sBase = { size: [0,$
                 0,$
                 500,$
                 125],$
          uname: 'job_status_scaling_main_base',$
          title: sMainBase.title,$
          frame: 1}

;determine position of application
determinePositionOfApplication, sMainBase, sBase

;cw_bgroup
XYoff = [5,5]
sGroup = { size: [XYoff[0],$
                  XYoff[1]],$
           list: ['ON','OFF'],$
           set_value: 0,$
           uname: 'job_status_scaling_cw_bgroup',$
           value: 'Constant for Scaling the Final Data Spectrum  '}

;label/value
XYoff = [50,30]
sLabel = { size: [XYoff[0],$
                  sGroup.size[1]+XYoff[1]],$
           value: 'VALUE:'}
XYoff = [100,0]
sValue = { size: [sLabel.size[0]+XYoff[0],$
                  sLabel.size[1]+XYoff[1],$
                  100],$
           uname: 'job_status_scaling_value',$
           value: sMainBase.scaling_value}

;Button CANCEL and OK
sButtonCancel = { size: [150],$
                  value: 'CANCEL',$
                  uname: 'job_status_scaling_cancel_button',$
                  sensitive: 1}
                  
sButtonOk = { size: sButtonCancel.size[0],$
              value: 'OK',$
              uname: 'job_status_scaling_ok_button',$
              sensitive: 1}

;build gui ....................................................................
wBase = WIDGET_BASE(GROUP_LEADER = ourGroup,$
                    TITLE        = sBase.title,$
                    XOFFSET      = sBase.size[0],$
                    YOFFSET      = sBase.size[1],$
                    SCR_XSIZE    = sBase.size[2],$
                    SCR_YSIZE    = sBase.size[3],$
                    MAP          = 1,$
                    UNAME        = sBase.uname,$
                    /COLUMN)

;cw_bgroup -------------------------------------------------------------------
wBaseRow1 = WIDGET_BASE(wBase,$
                        /ALIGN_CENTER,$
                        /ROW)

wGroup = CW_BGROUP(wBaseRow1,$
                   sGroup.list,$
                   XOFFSET    = sGroup.size[0],$
                   YOFFSET    = sGroup.size[1],$
                   UNAME      = sGroup.uname,$
                   LABEL_LEFT = sGroup.value,$
                   SET_VALUE  = sGroup.set_value,$
                   /EXCLUSIVE,$
                   /ROW)

;label/value -----------------------------------------------------------------
wBaseRow = WIDGET_BASE(wBase,$
                       /ALIGN_CENTER,$
                       /ROW)

wLabel = WIDGET_LABEL(wBaseRow,$
                      XOFFSET = sLabel.size[0],$
                      YOFFSET = sLabel.size[1],$
                      VALUE   = sLabel.value)
wValue = WIDGET_TEXT(wBaseRow,$
                     XOFFSET   = sValue.size[0],$
                     YOFFSET   = sValue.size[1],$
                     SCR_XSIZE = sValue.size[2],$
                     UNAME     = sValue.uname,$
                     VALUE     = sValue.value,$
                     /EDITABLE,$
                     /ALIGN_LEFT)

;button cancel and ok --------------------------------------------------------
wBaseRow3 = WIDGET_BASE(wBase,$
                        /ALIGN_CENTER,$
                        /ROW)

wCancel = WIDGET_BUTTON(wBaseRow3,$
                        SCR_XSIZE = sButtonCancel.size[0],$
                        UNAME     = sButtonCancel.uname,$
                        VALUE     = sButtonCancel.value,$
                        SENSITIVE = sButtonCancel.sensitive)

wSpace = WIDGET_LABEL(wBaseRow3,$
                      VALUE = '     ')

wOk = WIDGET_BUTTON(wBaseRow3,$
                    SCR_XSIZE = sButtonOK.size[0],$
                    UNAME     = sButtonOk.uname,$
                    VALUE     = sButtonOk.value,$
                    SENSITIVE = sButtonOk.sensitive)

Widget_Control, /REALIZE, wBase
XManager, 'MAIN_BASE', wBase, /NO_BLOCK, CLEANUP = 'make_scaling_cleanup'
END

;------------------------------------------------------------------------------
PRO Make_scaling_cleanup, wBase
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLscalingGUI::init, Event, scaling_value, title, cmd
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;design Main Base
sMainBase = { global: GLOBAL,$
              CMD: cmd,$
              scaling_value: scaling_value,$
              Event:  event,$
              title:  title}

;Design Main Base
DefineMainBase, sMainBase, wBase
WIDGET_CONTROL, wBase, SET_UVALUE = sMainBase
XMANAGER, "DefineMainBase", wBase, /NO_BLOCK

RETURN, 1

END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLscalingGUI__define
struct = {IDLscalingGUI,$
          var: ''}
END
;******************************************************************************
;******************************************************************************

