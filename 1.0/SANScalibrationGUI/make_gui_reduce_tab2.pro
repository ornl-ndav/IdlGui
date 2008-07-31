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

PRO make_gui_reduce_tab2, REDUCE_TAB, tab_size, tab_title

;- Define Main Base of Reduce Tab 1 -------------------------------------------
sBaseTab = { size:  tab_size,$
             uname: 'reduce_tab2_base',$
             title: tab_title}

;- Time Zero offset (microS) --------------------------------------------------
XYoff = [10,20] ;title
sTZObase = { size: [XYoff[0],$
                    XYoff[1],$
                    tab_size[2]-30, $
                    45],$
             frame: 1,$
             uname: 'time_zero_offset_base'}
XYoff = [20,-8]
sTZOtitle = { size: [sTZObase.size[0]+XYoff[0],$
                     sTZObase.size[1]+XYoff[1]],$
              value: 'Time Zero Offset (microS)'}

XYoff = [50,15]
sTZO_detector_value = {size:  [XYoff[0],$
                               XYoff[1]],$
                       value: 'Detector:'}
XYoff = [65,-5]
sTZO_detector_field = {size:  [sTZO_detector_value.size[0]+XYoff[0],$
                               sTZO_detector_value.size[1]+XYoff[1],$
                               70,30],$
                       value: '',$
                       uname: 'time_zero_offset_detector_uname'}
XYoff = [120,0]
sTZO_beam_value = {size:  [sTZO_detector_field.size[0]+XYoff[0],$
                           sTZO_detector_value.size[1]+XYoff[1]],$
                       value: 'Beam Monitor:'}
XYoff = [90,0]
sTZO_beam_field = {size:  [sTZO_beam_value.size[0]+XYoff[0],$
                           sTZO_detector_field.size[1]+XYoff[1],$
                           sTZO_detector_field.size[2:3]],$
                   value: '',$
                   uname: 'time_zero_offset_beam_monitor_uname'}
XYOff = [60,0]
sTZOhelp = { size: [sTZO_beam_field.size[0]+sTZO_beam_field.size[2]+XYoff[0],$
                    sTZO_beam_value.size[1]+XYoff[1]],$
             value: '(Specify the time zero offset in microseconds of the ' +$
             'Detector and the Monitor)'}

;- Monitor Efficiency ---------------------------------------------------------
XYoff = [0,20] ;title
sMEbase = { size: [sTZOBase.size[0]+XYoff[0],$
                   sTZObase.size[1]+sTZObase.size[3]+XYoff[1],$
                   sTZObase.size[2:3]], $
             frame: 1,$
             uname: 'monitor_efficiency_base'}
XYoff = [20,-8]
sMEtitle = { size: [sMEbase.size[0]+XYoff[0],$
                    sMEbase.size[1]+XYoff[1]],$
             value: 'Monitor Efficiency',$
             uname: 'monitor_efficiency_title'}

XYoff = [50,10]
sMEgroup = { size: [sTZO_detector_value.size[0]+XYoff[0],$
                    XYoff[1]],$
             uname: 'monitor_efficiency_group',$
             list: ['YES','NO'],$
             value: 0.0}
XYoff = [0,5]
sMElabel = { size: [sTZO_beam_value.size[0]+XYoff[0],$
                    sMEgroup.size[1]+XYoff[1]],$
             uname: 'monitor_efficiency_constant_label',$
             value: 'Value:'}
XYoff = [50,-6]
sMEvalue = { size: [sMElabel.size[0]+XYoff[0],$
                    sMElabel.size[1]+XYoff[1],$
                    sTZO_detector_field.size[2:3]],$
             value: '',$
             uname: 'monitor_efficiency_constant_value'}
XYoff = [0,0]
sMEhelp = { size: [sTZOhelp.size[0]+XYoff[0],$
                   sMElabel.size[1]+XYoff[1]],$
            value: '(Specify the monitor efficiency constant in 1/Angstroms)'}

;- Wavelength -----------------------------------------------------------------
XYoff = [0,20]
sQbase = { size:  [sMEbase.size[0]+XYoff[0],$
                   sMEbase.size[1]+sMEbase.size[3]+XYoff[1],$
                   sMEbase.size[2:3]],$
           frame: sMEbase.frame,$
           uname: 'wave_base'}
XYoff = [20,-8]
sQTitle = { size:  [sQbase.size[0]+XYoff[0],$
                    sQbase.size[1]+XYoff[1]],$
            value: 'Wavelength Range'}
;Qmin
QXoff = 70
XYoff = [80,12]
sQminLabel = { size:  [XYoff[0],$
                       XYoff[1]],$
               value: 'Min:'}
XYoff = [30,-5]
sQminText = {  size:  [sQminLabel.size[0]+XYoff[0],$
                       sQminLabel.size[1]+XYoff[1],$
                       70,30],$
               value: '',$
               uname: 'wave_min_text_field'}

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
               uname: 'wave_max_text_field'}

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
               uname: 'wave_width_text_field'}

;Q scale
XYoff = [Qxoff+5,0]
sQscaleGroup = { size:  [sQwidthText.size[0]+sQwidthText.size[2]+XYoff[0],$
                         sQwidthText.size[1]+XYoff[1]],$
                 list:  ['Linear','Logarithmic'],$
                 value: 0.0,$
                 uname: 'wave_scale_group'}

;- Lambda cut-off -------------------------------------------------------------
XYoff = [0,20]
sQLbase = { size: [sQbase.size[0]+XYoff[0],$
                   sQbase.size[1]+sQbase.size[3]+XYoff[1],$
                   sQbase.size[2:3]],$
            frame: sMEbase.frame,$
            uname: 'wave_cut_off_base'}
XYoff = [20,-8]
sQLTitle = { size:  [sQLbase.size[0]+XYoff[0],$
                     sQLbase.size[1]+XYoff[1]],$
             value: 'Wavelength Cut-off (Angstroms)'}

;- Minimum
XYoff = [80,5]
sMinLambdaGroup = { size:  [XYoff[0],$
                            XYoff[1]],$
                    list:  ['ON','OFF'],$
                    value: 0.0,$
                    uname: 'minimum_lambda_cut_off_group',$
                    title: 'Minimum:'}
XYoff    = [180,2]
sMLvalue = { size: [sMinLambdaGroup.size[0]+XYoff[0],$
                    sMinLambdaGroup.size[1]+XYoff[1],$
                    50],$
             value: '4.0',$
             uname: 'minimum_lambda_cut_off_value',$
             sensitive: 1}
             
;- Maximum
XYoff = [350,0]
sMaxLambdaGroup = { size:  [sMinLambdaGroup.size[0]+XYoff[0],$
                            sMinLambdaGroup.size[1]],$
                    list:  ['ON','OFF'],$
                    value: 1.0,$
                    uname: 'maximum_lambda_cut_off_group',$
                    title: 'Maximum:'}
XYoff = [180,3]
sMaxValue = { size: [sMaxLambdaGroup.size[0]+XYoff[0],$
                     sMaxLambdaGroup.size[1]+XYoff[1],$
                     sMLvalue.size[2]],$
              value: '',$
              uname: 'maximum_lambda_cut_off_value',$
              sensitive: 0}

;- Accelerator down time ------------------------------------------------------
XYoff = [0,20]
sADTbase = { size: [sQLbase.size[0]+XYoff[0],$
                   sQLbase.size[1]+sQLbase.size[3]+XYoff[1],$
                   sQLbase.size[2:3]],$
            frame: sMEbase.frame,$
            uname: 'accelerator_down_time_base'}
XYoff = [20,-8]
sADTTitle = { size:  [sADTbase.size[0]+XYoff[0],$
                      sADTbase.size[1]+XYoff[1]],$
              uname: 'accelerator_down_time_title',$
              value: 'Accelerator Down Time (seconds)'}
XYoff = [50,15]
sADTvalue = {size:  [XYoff[0],$
                     XYoff[1]],$
             value: 'Value:'}
XYoff = [45,-5]
sADT_field = {size:  [sADTvalue.size[0]+XYoff[0],$
                      sADTvalue.size[1]+XYoff[1],$
                      70,30],$
              value: '',$
              uname: 'accelerator_down_time_text_field'}

;- Flags ----------------------------------------------------------------------
XYoff = [0,20]
sFlagsBase = { size: [sADTbase.size[0]+XYoff[0],$
                      sADTBase.size[1]+sADTBase.size[3]+XYoff[1],$
                      sADTBase.size[2],$
                      80],$
               frame: sQLBase.frame}
XYoff = [20,-8]
sFlagsTitle = { size:  [sFlagsBase.size[0]+XYoff[0],$
                        sFlagsBase.size[1]+XYoff[1]],$
                value: 'Flags'}

;- Overwrite Geometry
XYoff    = [20,20]
sOG      = {size:  [XYoff[0],$
                    XYoff[1]],$
            value: '* Overwrite Geometry'}
XYoff    = [150,-6]
sOGgroup = {size:  [XYoff[0],$
                    sOG.size[1]+XYoff[1]],$
            list:  ['YES','NO'],$
            uname: 'overwrite_geometry_group'}
XYoff    = [105,-3]
sOGbase  = {size:  [sOGgroup.size[0]+XYoff[0],$
                    sOGgroup.size[1]+XYoff[1],$
                    700,30],$
            uname: 'overwrite_geometry_base',$
            map:   0}
XYoff     = [0,0]
sOGbutton = {size:  [XYoff[0],$
                     XYoff[1],$
                     sOGbase.size[2],$
                     sOGbase.size[3]],$
             value: 'Select a Geometry File ...',$
             uname: 'overwrite_geometry_button'}

;- Verbose Mode ---------------------------------------------------------------
XYoff = [0,20]
sVerboseGroup = { size:  [sOG.size[0]+XYoff[0],$
                          sOG.size[1]+XYoff[1]],$
                  list:  ['YES','NO'],$
                  value: 0.0,$
                  uname: 'verbose_mode_group',$
                  title: '* Verbose Mode      '}

;==============================================================================
;= Build Widgets ==============================================================
Basetab = WIDGET_BASE(REDUCE_TAB,$
                       UNAME     = sBaseTab.uname,$
                       XOFFSET   = sBaseTab.size[0],$
                       YOFFSET   = sBaseTab.size[1],$
                       SCR_XSIZE = sBaseTab.size[2],$
                       SCR_YSIZE = sBaseTab.size[3],$
                       TITLE     = sBaseTab.title)

;- Time Zero offset (microS) --------------------------------------------------
label = WIDGET_LABEL(Basetab,$
                     XOFFSET = sTZOtitle.size[0],$
                     YOFFSET = sTZOtitle.size[1],$
                     VALUE   = sTZOtitle.value)

base = WIDGET_BASE(BaseTab,$
                   XOFFSET   = sTZObase.size[0],$
                   YOFFSET   = sTZObase.size[1],$
                   SCR_XSIZE = sTZObase.size[2],$
                   SCR_YSIZE = sTZObase.size[3],$
                   FRAME     = sTZObase.frame,$
                   UNAME     = sTZObase.uname)
                   
label = WIDGET_LABEL(Base,$
                     XOFFSET = sTZO_detector_value.size[0],$
                     YOFFSET = sTZO_detector_value.size[1],$
                     VALUE   = sTZO_detector_value.value)

text = WIDGET_TEXT(Base,$
                   XOFFSET   = sTZO_detector_field.size[0],$
                   YOFFSET   = sTZO_detector_field.size[1],$
                   SCR_XSIZE = sTZO_detector_field.size[2],$
                   SCR_YSIZE = sTZO_detector_field.size[3],$
                   VALUE     = sTZO_detector_field.value,$
                   UNAME     = sTZO_detector_field.uname,$
                   /ALL_EVENTS,$
                   /EDITABLE)

label = WIDGET_LABEL(Base,$
                     XOFFSET = sTZO_beam_value.size[0],$
                     YOFFSET = sTZO_beam_value.size[1],$
                     VALUE   = sTZO_beam_value.value)

text = WIDGET_TEXT(Base,$
                   XOFFSET   = sTZO_beam_field.size[0],$
                   YOFFSET   = sTZO_beam_field.size[1],$
                   SCR_XSIZE = sTZO_beam_field.size[2],$
                   SCR_YSIZE = sTZO_beam_field.size[3],$
                   VALUE     = sTZO_beam_field.value,$
                   UNAME     = sTZO_beam_field.uname,$
                   /ALL_EVENTS,$
                   /EDITABLE)

help = WIDGET_LABEL(Base,$
                    XOFFSET = sTZOhelp.size[0],$
                    YOFFSET = sTZOhelp.size[1],$
                    VALUE   = sTZOhelp.value)

;- Monitor Efficiency ---------------------------------------------------------
label = WIDGET_LABEL(Basetab,$
                     XOFFSET = sMEtitle.size[0],$
                     YOFFSET = sMEtitle.size[1],$
                     VALUE   = sMEtitle.value,$
                     UNAME   = sMEtitle.uname)

base = WIDGET_BASE(BaseTab,$
                   XOFFSET   = sMEbase.size[0],$
                   YOFFSET   = sMEbase.size[1],$
                   SCR_XSIZE = sMEbase.size[2],$
                   SCR_YSIZE = sMEbase.size[3],$
                   FRAME     = sMEbase.frame,$
                   UNAME     = sMEbase.uname)
                   
group = CW_BGROUP(Base,$
                  sMEgroup.list,$
                  XOFFSET    = sMEgroup.size[0],$
                  YOFFSET    = sMEgroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sMEgroup.value,$
                  UNAME      = sMEgroup.uname,$
                  /EXCLUSIVE)

;label and value
wLabel = WIDGET_LABEL(Base,$
                      XOFFSET   = sMElabel.size[0],$
                      YOFFSET   = sMElabel.size[1],$
                      VALUE     = sMElabel.value,$
                      UNAME     = sMElabel.uname)

wValue = WIDGET_TEXT(Base,$
                     XOFFSET   = sMEvalue.size[0],$
                     YOFFSET   = sMEvalue.size[1],$
                     SCR_XSIZE = sMEvalue.size[2],$
                     SCR_YSIZE = sMEvalue.size[3],$
                     UNAME     = sMEvalue.uname,$
                     VALUE     = sMEvalue.value,$
                     /EDITABLE,$
                     /ALL_EVENTS,$
                     /ALIGN_LEFT)

;help
whelp = WIDGET_LABEL(Base,$
                     XOFFSET = sMEhelp.size[0],$
                     YOFFSET = sMEhelp.size[1],$
                     VALUE   = sMEhelp.value)

;- Q --------------------------------------------------------------------------
wQTitle = WIDGET_LABEL(Basetab,$
                       XOFFSET = sQTitle.size[0],$
                       YOFFSET = sQTitle.size[1],$
                       VALUE   = sQTitle.value)

;Q base
Base = WIDGET_BASE(Basetab,$
                   XOFFSET   = sQbase.size[0],$
                   YOFFSET   = sQbase.size[1],$
                   SCR_XSIZE = sQbase.size[2],$
                   SCR_YSIZE = sQbase.size[3],$
                   FRAME     = sQbase.frame,$
                   UNAME     = sQbase.uname)


;Qmin
wQminLabel = WIDGET_LABEL(Base,$
                          XOFFSET = sQminLabel.size[0],$
                          YOFFSET = sQminLabel.size[1],$
                          VALUE   = sQminLabel.value)

wQminText = WIDGET_TEXT(Base,$
                        XOFFSET   = sQminText.size[0],$
                        YOFFSET   = sQminText.size[1],$
                        SCR_XSIZE = sQminText.size[2],$
                        SCR_YSIZE = sQminText.size[3],$
                        VALUE     = sQminText.value,$
                        UNAME     = sQminText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Qmax
wQmaxLabel = WIDGET_LABEL(Base,$
                          XOFFSET = sQmaxLabel.size[0],$
                          YOFFSET = sQmaxLabel.size[1],$
                          VALUE   = sQmaxLabel.value)

wQmaxText = WIDGET_TEXT(Base,$
                        XOFFSET   = sQmaxText.size[0],$
                        YOFFSET   = sQmaxText.size[1],$
                        SCR_XSIZE = sQmaxText.size[2],$
                        SCR_YSIZE = sQmaxText.size[3],$
                        VALUE     = sQmaxText.value,$
                        UNAME     = sQmaxText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Qwidth
wQwidthLabel = WIDGET_LABEL(Base,$
                          XOFFSET = sQwidthLabel.size[0],$
                          YOFFSET = sQwidthLabel.size[1],$
                          VALUE   = sQwidthLabel.value)

wQwidthText = WIDGET_TEXT(Base,$
                        XOFFSET   = sQwidthText.size[0],$
                        YOFFSET   = sQwidthText.size[1],$
                        SCR_XSIZE = sQwidthText.size[2],$
                        SCR_YSIZE = sQwidthText.size[3],$
                        VALUE     = sQwidthText.value,$
                        UNAME     = sQwidthText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Q scale
wQscaleGroup =  CW_BGROUP(Base,$
                          sQscaleGroup.list,$
                          XOFFSET    = sQscaleGroup.size[0],$
                          YOFFSET    = sQscaleGroup.size[1],$
                          ROW        = 1,$
                          SET_VALUE  = sQscaleGroup.value,$
                          UNAME      = sQscaleGroup.uname,$
                          /EXCLUSIVE)

;- Lambda cut-off -------------------------------------------------------------
wQLTitle = WIDGET_LABEL(Basetab,$
                       XOFFSET = sQLTitle.size[0],$
                       YOFFSET = sQLTitle.size[1],$
                       VALUE   = sQLTitle.value)

;Lambda base
Base = WIDGET_BASE(Basetab,$
                   XOFFSET   = sQLbase.size[0],$
                   YOFFSET   = sQLbase.size[1],$
                   SCR_XSIZE = sQLbase.size[2],$
                   SCR_YSIZE = sQLbase.size[3],$
                   FRAME     = sQLbase.frame,$
                   UNAME     = sQLbase.uname)

;- Minimum
group = CW_BGROUP(Base,$
                  sMinLambdaGroup.list,$
                  XOFFSET    = sMinLambdaGroup.size[0],$
                  YOFFSET    = sMinLambdaGroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sMinLambdaGroup.value,$
                  UNAME      = sMinLambdaGroup.uname,$
                  LABEL_LEFT = sMinLambdaGroup.title,$
                  /EXCLUSIVE)

wValue = WIDGET_TEXT(Base,$
                     XOFFSET   = sMLvalue.size[0],$
                     YOFFSET   = sMLvalue.size[1],$
                     SCR_XSIZE = sMLvalue.size[2],$
                     UNAME     = sMLvalue.uname,$
                     SENSITIVE = sMLvalue.sensitive,$
                     VALUE     = sMLvalue.value,$
                     /EDITABLE,$
                     /ALL_EVENTS,$
                     /ALIGN_LEFT)

;- Maximum
group = CW_BGROUP(Base,$
                  sMaxLambdaGroup.list,$
                  XOFFSET    = sMaxLambdaGroup.size[0],$
                  YOFFSET    = sMaxLambdaGroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sMaxLambdaGroup.value,$
                  UNAME      = sMaxLambdaGroup.uname,$
                  LABEL_LEFT = sMaxLambdaGroup.title,$
                  /EXCLUSIVE)

wValue = WIDGET_TEXT(Base,$
                     XOFFSET   = sMaxvalue.size[0],$
                     YOFFSET   = sMaxvalue.size[1],$
                     SCR_XSIZE = sMaxvalue.size[2],$
                     UNAME     = sMaxvalue.uname,$
                     SENSITIVE = sMaxvalue.sensitive,$
                     VALUE     = sMaxvalue.value,$
                     /EDITABLE,$
                     /ALL_EVENTS,$
                     /ALIGN_LEFT)

;- Accelerator down time ------------------------------------------------------
wTitle = WIDGET_LABEL(Basetab,$
                      XOFFSET = sADTTitle.size[0],$
                      YOFFSET = sADTTitle.size[1],$
                      UNAME   = sADTTitle.uname,$
                      VALUE   = sADtTitle.value)

;ADT base
Base = WIDGET_BASE(Basetab,$
                   XOFFSET   = sADTbase.size[0],$
                   YOFFSET   = sADTbase.size[1],$
                   SCR_XSIZE = sADTbase.size[2],$
                   SCR_YSIZE = sADTbase.size[3],$
                   FRAME     = sADTbase.frame,$
                   UNAME     = sADTbase.uname)

label = WIDGET_LABEL(Base,$
                     XOFFSET = sADTvalue.size[0],$
                     YOFFSET = sADTvalue.size[1],$
                     VALUE   = sADTvalue.value)

text = WIDGET_TEXT(Base,$
                   XOFFSET   = sADT_field.size[0],$
                   YOFFSET   = sADT_field.size[1],$
                   SCR_XSIZE = sADT_field.size[2],$
                   SCR_YSIZE = sADT_field.size[3],$
                   VALUE     = sADT_field.value,$
                   UNAME     = sADT_field.uname,$
                   /ALL_EVENTS,$
                   /EDITABLE)

;- Flags ----------------------------------------------------------------------
wFlagTitle = WIDGET_LABEL(Basetab,$
                       XOFFSET = sFlagsTitle.size[0],$
                       YOFFSET = sFlagsTitle.size[1],$
                       VALUE   = sFlagsTitle.value)

;Wave frame
Base = WIDGET_Base(Basetab,$
                   XOFFSET   = sFlagsBase.size[0],$
                   YOFFSET   = sFlagsBase.size[1],$
                   SCR_XSIZE = sFlagsBase.size[2],$
                   SCR_YSIZE = sFlagsBase.size[3],$
                   FRAME     = sFlagsBase.frame)

;- Overwrite Geometry ---------------------------------------------------------
label = WIDGET_LABEL(Base,$
                     XOFFSET = sOG.size[0],$
                     YOFFSET = sOG.size[1],$
                     VALUE   = sOG.value,$
                     /ALIGN_LEFT)

group = CW_BGROUP(Base,$
                  sOGgroup.list,$
                  XOFFSET   = sOGgroup.size[0],$
                  YOFFSET   = sOGgroup.size[1],$
                  ROW       = 1,$
                  SET_VALUE = 1,$
                  UNAME     = sOGgroup.uname,$
                  /NO_RELEASE,$
                  /EXCLUSIVE)

base1 = WIDGET_BASE(Base,$
                   XOFFSET   = sOGbase.size[0],$
                   YOFFSET   = sOGBase.size[1],$
                   SCR_XSIZE = sOGbase.size[2],$
                   SCR_YSIZE = sOGbase.size[3],$
                   UNAME     = sOGbase.uname,$
                   MAP       = sOGbase.map)

button = WIDGET_BUTTON(base1,$
                       XOFFSET   = sOGbutton.size[0],$
                       YOFFSET   = sOGbutton.size[1],$
                       SCR_XSIZE = sOGbutton.size[2],$
                       SCR_YSIZE = sOGbutton.size[3],$
                       VALUE     = sOGbutton.value,$
                       UNAME     = sOGbutton.uname)

;- Verbose Mode ---------------------------------------------------------------
group = CW_BGROUP(Base,$
                  sVerboseGroup.list,$
                  XOFFSET    = sVerboseGroup.size[0],$
                  YOFFSET    = sVerboseGroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sVerboseGroup.value,$
                  UNAME      = sVerboseGroup.uname,$
                  LABEL_LEFT = sVerboseGroup.title,$
                  /EXCLUSIVE)

END
