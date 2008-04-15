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




END
