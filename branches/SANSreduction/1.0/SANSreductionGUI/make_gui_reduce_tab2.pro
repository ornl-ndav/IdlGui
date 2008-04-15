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

PRO make_gui_reduce_tab2, REDUCE_TAB, tab_size, tab_title

;- Define Main Base of Reduce Tab 1 --------------------------------------------
sBaseTab2 = { size:  tab_size,$
              uname: 'reduce_tab2_base',$
              title: tab_title}

;- Overwrite Geometry ----------------------------------------------------------
XYoff    = [10,20]
sOG      = {size:  [XYoff[0],$
                    XYoff[1]],$
            value: '-> Overwrite Geometry'}
XYoff    = [150,-6]
sOGgroup = {size:  [XYoff[0],$
                    sOG.size[1]+XYoff[1]],$
            list:  ['YES','NO'],$
            uname: 'overwrite_geometry_group'}
XYoff    = [105,-3]
sOGbase  = {size:  [sOGgroup.size[0]+XYoff[0],$
                    sOGgroup.size[1]+XYoff[1],$
                    420,35],$
            uname: 'overwrite_geometry_base'}
XYoff     = [0,0]
sOGbutton = {size:  [XYoff[0],$
                     XYoff[1],$
                     sOGbase.size[2],$
                     sOGbase.size[3]],$
             value: 'BROWSE ...',$
             uname: 'overwrite_geometry_button'}

;- Time Zero offset (microS) ---------------------------------------------------
XYoff = [0,45]
sTZO  = {size:  [sOG.size[0]+XYoff[0],$
                 sOG.size[1]+XYoff[1]],$
         value: '-> Time Zero Offset (microS)  _________'}
XYoff = [250,0]
sTZO_detector_value = {size:  [sTZO.size[0]+XYoff[0],$
                               sTZO.size[1]+XYoff[1]],$
                       value: 'Detector:'}
XYoff = [65,-5]
sTZO_detector_field = {size:  [sTZO_detector_value.size[0]+XYoff[0],$
                               sTZO_detector_value.size[1]+XYoff[1],$
                               70,30],$
                       value: '',$
                       uname: 'time_zero_offset_detector_uname'}
XYoff = [80,0]
sTZO_beam_value = {size:  [sTZO_detector_field.size[0]+XYoff[0],$
                           sTZO_detector_value.size[1]+XYoff[1]],$
                       value: '_______  Beam Monitor:'}
XYoff = [140,0]
sTZO_beam_field = {size:  [sTZO_beam_value.size[0]+XYoff[0],$
                           sTZO_detector_field.size[1]+XYoff[1],$
                           sTZO_detector_field.size[2:3]],$
                   value: '',$
                   uname: 'time_zero_offset_beam_monitor_uname'}

;- Monitor Efficiency ---------------------------------------------------------
XYoff = [6,40]
sMEgroup = { size:  [XYoff[0],$
                     sTZO_detector_value.size[1]+XYoff[1]],$
             list:  ['ON','OFF'],$
             value: 1.0,$
             uname: 'monitor_efficiency_group',$
             title: '-> Monitor Efficiency '}

;- Q ---------------------------------------------------------------------------
XYoff = [5,50]
sQFrame = { size:  [XYoff[0],$
                    sMEgroup.size[1]+XYoff[1],$
                    tab_size[2]-20,$
                    45],$
            frame: 2}
XYoff = [20,-8]
sQTitle = { size:  [sQFrame.size[0]+XYoff[0],$
                    sQFrame.size[1]+XYoff[1]],$
            value: 'Q range'}
;Qmin
QXoff = 30
XYoff = [QXoff,15]
sQminLabel = { size:  [sQFrame.size[0]+XYoff[0],$
                       sQFrame.size[1]+XYoff[1]],$
               value: 'Min:'}
XYoff = [30,-5]
sQminText = {  size:  [sQminLabel.size[0]+XYoff[0],$
                       sQminLabel.size[1]+XYoff[1],$
                       70,30],$
               value: '',$
               uname: 'qmin_text_field'}

;Qmax
XYoff = [QXoff+5,0]
sQmaxLabel = { size:  [sQminText.size[0]+sQminText.size[2]+XYoff[0],$
                       sQminLabel.size[1]+XYoff[1]],$
               value: 'Max:'}
XYoff = [30,0]
sQmaxText = {  size:  [sQmaxLabel.size[0]+XYoff[0],$
                       sQminText.size[1]+XYoff[1],$
                       sQminText.size[2:3]],$
               value: '',$
               uname: 'qmax_text_field'}

;Qwidth
XYoff = [Qxoff+5,0]
sQwidthLabel = { size:  [sQmaxText.size[0]+sQminText.size[2]+XYoff[0],$
                         sQminLabel.size[1]+XYoff[1]],$
               value: 'Width:'}
XYoff = [45,0]
sQwidthText = {  size:  [sQwidthLabel.size[0]+XYoff[0],$
                         sQminText.size[1]+XYoff[1],$
                         sQminText.size[2:3]],$
                 value: '',$
               uname: 'qwidth_text_field'}

;Q scale
XYoff = [Qxoff+5,0]
sQscaleGroup = { size:  [sQwidthText.size[0]+sQwidthText.size[2]+XYoff[0],$
                         sQwidthText.size[1]+XYoff[1]],$
                 list:  ['Linear','Logarithmic'],$
                 value: 1.0,$
                 uname: 'q_scale_group'}

;===============================================================================
;= Build Widgets ===============================================================
BaseTab2 = WIDGET_BASE(REDUCE_TAB,$
                       UNAME     = sBaseTab2.uname,$
                       XOFFSET   = sBaseTab2.size[0],$
                       YOFFSET   = sBaseTab2.size[1],$
                       SCR_XSIZE = sBaseTab2.size[2],$
                       SCR_YSIZE = sBaseTab2.size[3],$
                       TITLE     = sBaseTab2.title)

;- Overwrite Geometry ----------------------------------------------------------
label = WIDGET_LABEL(BaseTab2,$
                     XOFFSET = sOG.size[0],$
                     YOFFSET = sOG.size[1],$
                     VALUE   = sOG.value,$
                     /ALIGN_LEFT)

group = CW_BGROUP(BaseTab2,$
                  sOGgroup.list,$
                  XOFFSET   = sOGgroup.size[0],$
                  YOFFSET   = sOGgroup.size[1],$
                  ROW       = 1,$
                  SET_VALUE = 1,$
                  UNAME     = sOGgroup.uname,$
                  /EXCLUSIVE)

base = WIDGET_BASE(BaseTab2,$
                   XOFFSET   = sOGbase.size[0],$
                   YOFFSET   = sOGBase.size[1],$
                   SCR_XSIZE = sOGbase.size[2],$
                   SCR_YSIZE = sOGbase.size[3],$
                   UNAME     = sOGbase.uname)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = sOGbutton.size[0],$
                       YOFFSET   = sOGbutton.size[1],$
                       SCR_XSIZE = sOGbutton.size[2],$
                       SCR_YSIZE = sOGbutton.size[3],$
                       VALUE     = sOGbutton.value,$
                       UNAME     = sOGbutton.uname)

;- Time Zero offset (microS) ---------------------------------------------------
label = WIDGET_LABEL(BaseTab2,$
                     XOFFSET = sTZO.size[0],$
                     YOFFSET = sTZO.size[1],$
                     VALUE   = sTZO.value)

label = WIDGET_LABEL(BaseTab2,$
                     XOFFSET = sTZO_detector_value.size[0],$
                     YOFFSET = sTZO_detector_value.size[1],$
                     VALUE   = sTZO_detector_value.value)

text = WIDGET_TEXT(BaseTab2,$
                   XOFFSET   = sTZO_detector_field.size[0],$
                   YOFFSET   = sTZO_detector_field.size[1],$
                   SCR_XSIZE = sTZO_detector_field.size[2],$
                   SCR_YSIZE = sTZO_detector_field.size[3],$
                   VALUE     = sTZO_detector_field.value,$
                   UNAME     = sTZO_detector_field.uname,$
                   /EDITABLE)

label = WIDGET_LABEL(BaseTab2,$
                     XOFFSET = sTZO_beam_value.size[0],$
                     YOFFSET = sTZO_beam_value.size[1],$
                     VALUE   = sTZO_beam_value.value)

text = WIDGET_TEXT(BaseTab2,$
                   XOFFSET   = sTZO_beam_field.size[0],$
                   YOFFSET   = sTZO_beam_field.size[1],$
                   SCR_XSIZE = sTZO_beam_field.size[2],$
                   SCR_YSIZE = sTZO_beam_field.size[3],$
                   VALUE     = sTZO_beam_field.value,$
                   UNAME     = sTZO_beam_field.uname,$
                   /EDITABLE)

;- Monitor Efficiency ---------------------------------------------------------
group = CW_BGROUP(BaseTab2,$
                  sMEgroup.list,$
                  XOFFSET    = sMEgroup.size[0],$
                  YOFFSET    = sMEgroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sMEgroup.value,$
                  UNAME      = sMEgroup.uname,$
                  LABEL_LEFT = sMEgroup.title,$
                  /EXCLUSIVE)

;- Q ---------------------------------------------------------------------------
wQTitle = WIDGET_LABEL(BaseTab2,$
                       XOFFSET = sQTitle.size[0],$
                       YOFFSET = sQTitle.size[1],$
                       VALUE   = sQTitle.value)
;Qmin
wQminLabel = WIDGET_LABEL(BaseTab2,$
                          XOFFSET = sQminLabel.size[0],$
                          YOFFSET = sQminLabel.size[1],$
                          VALUE   = sQminLabel.value)

wQminText = WIDGET_TEXT(BaseTab2,$
                        XOFFSET   = sQminText.size[0],$
                        YOFFSET   = sQminText.size[1],$
                        SCR_XSIZE = sQminText.size[2],$
                        SCR_YSIZE = sQminText.size[3],$
                        VALUE     = sQminText.value,$
                        UNAME     = sQminText.uname,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Qmax
wQmaxLabel = WIDGET_LABEL(BaseTab2,$
                          XOFFSET = sQmaxLabel.size[0],$
                          YOFFSET = sQmaxLabel.size[1],$
                          VALUE   = sQmaxLabel.value)

wQmaxText = WIDGET_TEXT(BaseTab2,$
                        XOFFSET   = sQmaxText.size[0],$
                        YOFFSET   = sQmaxText.size[1],$
                        SCR_XSIZE = sQmaxText.size[2],$
                        SCR_YSIZE = sQmaxText.size[3],$
                        VALUE     = sQmaxText.value,$
                        UNAME     = sQmaxText.uname,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Qwidth
wQwidthLabel = WIDGET_LABEL(BaseTab2,$
                          XOFFSET = sQwidthLabel.size[0],$
                          YOFFSET = sQwidthLabel.size[1],$
                          VALUE   = sQwidthLabel.value)

wQwidthText = WIDGET_TEXT(BaseTab2,$
                        XOFFSET   = sQwidthText.size[0],$
                        YOFFSET   = sQwidthText.size[1],$
                        SCR_XSIZE = sQwidthText.size[2],$
                        SCR_YSIZE = sQwidthText.size[3],$
                        VALUE     = sQwidthText.value,$
                        UNAME     = sQwidthText.uname,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Q scale
wQscaleGroup =  CW_BGROUP(BaseTab2,$
                          sQscaleGroup.list,$
                          XOFFSET    = sQscaleGroup.size[0],$
                          YOFFSET    = sQscaleGroup.size[1],$
                          ROW        = 1,$
                          SET_VALUE  = sQscaleGroup.value,$
                          UNAME      = sQscaleGroup.uname,$
                          /EXCLUSIVE)

;Q frame
wQFrame = WIDGET_LABEL(BaseTab2,$
                       XOFFSET   = sQFrame.size[0],$
                       YOFFSET   = sQFrame.size[1],$
                       SCR_XSIZE = sQFrame.size[2],$
                       SCR_YSIZE = sQFrame.size[3],$
                       VALUE     = '',$
                       FRAME     = sQFrame.frame)
END
