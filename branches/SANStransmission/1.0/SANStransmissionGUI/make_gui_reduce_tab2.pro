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

PRO make_gui_reduce_tab2, REDUCE_TAB, tab_size, tab_title, global

;- Define Main Base of Reduce Tab 1 -------------------------------------------
sBaseTab = { size:  tab_size,$
             uname: 'reduce_tab2_base',$
             title: tab_title}

;- Overwrite Geometry ---------------------------------------------------------
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
            uname: 'overwrite_geometry_base',$
            map  : 0}
XYoff     = [0,0]
sOGbutton = {size:  [XYoff[0],$
                     XYoff[1],$
                     sOGbase.size[2],$
                     sOGbase.size[3]],$
             value: 'Select a Geometry File ...',$
             uname: 'overwrite_geometry_button'}

;- Time Zero offset (microS) --------------------------------------------------
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

XYoff    = [250,10]
sMElabel = { size: [XYoff[0],sMEgroup.size[1]+XYoff[1]],$
             value: '--> Value:',$
             uname: 'monitor_efficiency_constant_label',$
             sensitive: 0}
XYoff    = [80,-6]
sMEvalue = { size: [sMElabel.size[0]+XYoff[0],$
                    sMElabel.size[1]+XYoff[1],$
                    50],$
             value: '',$
             uname: 'monitor_efficiency_constant_value',$
             sensitive: 0}

;- Wavelength -----------------------------------------------------------------
XYoff = [5,50]
sWavelengthFrame = { size:  [XYoff[0],$
                             sMEgroup.size[1]+XYoff[1],$
                             650,$
                             45],$
                     frame: 2}
XYoff = [20,-8]
sWavelengthTitle = { size:  [sWavelengthFrame.size[0]+XYoff[0],$
                             sWavelengthFrame.size[1]+XYoff[1]],$
                     value: (*global).CorrectPara.wavelength_range.title}
;Wavelengthmin
WavelengthXoff = 30
XYoff = [WavelengthXoff,15]
sWavelengthminLabel = { size:  [sWavelengthFrame.size[0]+XYoff[0],$
                                sWavelengthFrame.size[1]+XYoff[1]],$
                        value: 'Min:'}
XYoff = [30,-5]
sWavelengthminText = {  size:  [sWavelengthminLabel.size[0]+XYoff[0],$
                                sWavelengthminLabel.size[1]+XYoff[1],$
                                70,30],$
                        value: '',$
                        uname: 'wave_min_text_field'}

;Wavelengthmax
XYoff = [WavelengthXoff+5,0]
sWavelengthmaxLabel = { size:  [sWavelengthminText.size[0]+$
                                sWavelengthminText.size[2]+XYoff[0],$
                                sWavelengthminLabel.size[1]+XYoff[1]],$
                        value: 'Max:'}
XYoff = [30,0]
sWavelengthmaxText = {  size:  [sWavelengthmaxLabel.size[0]+XYoff[0],$
                                sWavelengthminText.size[1]+XYoff[1],$
                                sWavelengthminText.size[2:3]],$
                        value: '',$
                        uname: 'wave_max_text_field'}

;Wavelengthwidth
XYoff = [Wavelengthxoff+5,0]
sWavelengthwidthLabel = { size:  [sWavelengthmaxText.size[0]+$
                                  sWavelengthminText.size[2]+XYoff[0],$
                                  sWavelengthminLabel.size[1]+XYoff[1]],$
                          value: 'Width:'}
XYoff = [45,0]
sWavelengthwidthText = {  size:  [sWavelengthwidthLabel.size[0]+XYoff[0],$
                                  sWavelengthminText.size[1]+XYoff[1],$
                                  sWavelengthminText.size[2:3]],$
                          value: '',$
                          uname: 'wave_width_text_field'}

;Wavelength scale
XYoff = [Wavelengthxoff+5,0]
sWavelengthscaleGroup = { size:  [sWavelengthwidthText.size[0]+$
                                  sWavelengthwidthText.size[2]+XYoff[0],$
                                  sWavelengthwidthText.size[1]+XYoff[1]],$
                          list:  ['Linear','Logarithmic'],$
                          value: 1.0,$
                          uname: 'wave_scale_group'}

;- Verbose Mode ---------------------------------------------------------------
XYoff = [0,10]
sVerboseGroup = { size:  [sMEgroup.size[0]+XYoff[0],$
                          sWavelengthFrame.size[1]+$
                          sWavelengthFrame.size[3]+XYoff[1]],$
                  list:  ['ON','OFF'],$
                  value: 0.0,$
                  uname: 'verbose_mode_group',$
                  title: '-> Verbose Mode '}

;- Minimum Lambda Cut OFF -----------------------------------------------------
XYoff = [6,40]
sMinLambdaGroup = { size:  [XYoff[0],$
                            sVerboseGroup.size[1]+XYoff[1]],$
             list:  ['ON','OFF'],$
             value: 0.0,$
             uname: 'minimum_lambda_cut_off_group',$
             title: '-> Minimum Lambda Cut-Off '}

XYoff    = [280,10]
sMLlabel = { size: [XYoff[0],sMinLambdaGroup.size[1]+XYoff[1]],$
             value: '--> Value:',$
             uname: 'minimum_lambda_cut_off_label',$
             sensitive: 1}
XYoff    = [80,-6]
sMLvalue = { size: [sMLlabel.size[0]+XYoff[0],$
                    sMLlabel.size[1]+XYoff[1],$
                    50],$
             value: '4.0',$
             uname: 'minimum_lambda_cut_off_value',$
             sensitive: 1}
             
;- Maximum Lambda Cut Off -----------------------------------------------------
XYoff = [6,40]
sMaxLambdaGroup = { size:  [XYoff[0],$
                            sMinLambdaGroup.size[1]+XYoff[1]],$
                            list:  ['ON','OFF'],$
                            value: 1.0,$
                            uname: 'maximum_lambda_cut_off_group',$
                            title: '-> Maximum Lambda Cut-Off '}

XYoff    = [280,10]
sMaxLlabel = { size: [XYoff[0],sMaxLambdaGroup.size[1]+XYoff[1]],$
               value: '--> Value:',$
               uname: 'maximum_lambda_cut_off_label',$
               sensitive: 0}
XYoff    = [80,-6]
sMaxLvalue = { size: [sMaxLlabel.size[0]+XYoff[0],$
                      sMaxLlabel.size[1]+XYoff[1],$
                      50],$
               value: '',$
               uname: 'maximum_lambda_cut_off_value',$
               sensitive: 0}

;==============================================================================
;= Build Widgets ==============================================================
Basetab = WIDGET_BASE(REDUCE_TAB,$
                       UNAME     = sBaseTab.uname,$
                       XOFFSET   = sBaseTab.size[0],$
                       YOFFSET   = sBaseTab.size[1],$
                       SCR_XSIZE = sBaseTab.size[2],$
                       SCR_YSIZE = sBaseTab.size[3],$
                       TITLE     = sBaseTab.title)

;- Overwrite Geometry ---------------------------------------------------------
label = WIDGET_LABEL(Basetab,$
                     XOFFSET = sOG.size[0],$
                     YOFFSET = sOG.size[1],$
                     VALUE   = sOG.value,$
                     /ALIGN_LEFT)

group = CW_BGROUP(Basetab,$
                  sOGgroup.list,$
                  XOFFSET   = sOGgroup.size[0],$
                  YOFFSET   = sOGgroup.size[1],$
                  ROW       = 1,$
                  SET_VALUE = 1,$
                  UNAME     = sOGgroup.uname,$
                  /NO_RELEASE,$
                  /EXCLUSIVE)

base = WIDGET_BASE(Basetab,$
                   XOFFSET   = sOGbase.size[0],$
                   YOFFSET   = sOGBase.size[1],$
                   SCR_XSIZE = sOGbase.size[2],$
                   SCR_YSIZE = sOGbase.size[3],$
                   UNAME     = sOGbase.uname,$
                   MAP       = sOGbase.map)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = sOGbutton.size[0],$
                       YOFFSET   = sOGbutton.size[1],$
                       SCR_XSIZE = sOGbutton.size[2],$
                       SCR_YSIZE = sOGbutton.size[3],$
                       VALUE     = sOGbutton.value,$
                       UNAME     = sOGbutton.uname)

;- Time Zero offset (microS) --------------------------------------------------
label = WIDGET_LABEL(Basetab,$
                     XOFFSET = sTZO.size[0],$
                     YOFFSET = sTZO.size[1],$
                     VALUE   = sTZO.value)

label = WIDGET_LABEL(Basetab,$
                     XOFFSET = sTZO_detector_value.size[0],$
                     YOFFSET = sTZO_detector_value.size[1],$
                     VALUE   = sTZO_detector_value.value)

text = WIDGET_TEXT(Basetab,$
                   XOFFSET   = sTZO_detector_field.size[0],$
                   YOFFSET   = sTZO_detector_field.size[1],$
                   SCR_XSIZE = sTZO_detector_field.size[2],$
                   SCR_YSIZE = sTZO_detector_field.size[3],$
                   VALUE     = sTZO_detector_field.value,$
                   UNAME     = sTZO_detector_field.uname,$
                   /ALL_EVENTS,$
                   /EDITABLE)

label = WIDGET_LABEL(Basetab,$
                     XOFFSET = sTZO_beam_value.size[0],$
                     YOFFSET = sTZO_beam_value.size[1],$
                     VALUE   = sTZO_beam_value.value)

text = WIDGET_TEXT(Basetab,$
                   XOFFSET   = sTZO_beam_field.size[0],$
                   YOFFSET   = sTZO_beam_field.size[1],$
                   SCR_XSIZE = sTZO_beam_field.size[2],$
                   SCR_YSIZE = sTZO_beam_field.size[3],$
                   VALUE     = sTZO_beam_field.value,$
                   UNAME     = sTZO_beam_field.uname,$
                   /ALL_EVENTS,$
                   /EDITABLE)

;- Monitor Efficiency ---------------------------------------------------------
group = CW_BGROUP(Basetab,$
                  sMEgroup.list,$
                  XOFFSET    = sMEgroup.size[0],$
                  YOFFSET    = sMEgroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sMEgroup.value,$
                  UNAME      = sMEgroup.uname,$
                  LABEL_LEFT = sMEgroup.title,$
                  /EXCLUSIVE)

;label and value
wLabel = WIDGET_LABEL(Basetab,$
                      XOFFSET   = sMElabel.size[0],$
                      YOFFSET   = sMElabel.size[1],$
                      VALUE     = sMElabel.value,$
                      SENSITIVE = sMElabel.sensitive,$
                      UNAME     = sMElabel.uname)

wValue = WIDGET_TEXT(Basetab,$
                     XOFFSET   = sMEvalue.size[0],$
                     YOFFSET   = sMEvalue.size[1],$
                     SCR_XSIZE = sMEvalue.size[2],$
                     UNAME     = sMEvalue.uname,$
                     SENSITIVE = sMEvalue.sensitive,$
                     VALUE     = sMEvalue.value,$
                     /EDITABLE,$
                     /ALL_EVENTS,$
                     /ALIGN_LEFT)
                  
;- Wavelength -----------------------------------------------------------------
wWavelengthTitle = WIDGET_LABEL(Basetab,$
                       XOFFSET = sWavelengthTitle.size[0],$
                       YOFFSET = sWavelengthTitle.size[1],$
                       VALUE   = sWavelengthTitle.value)
;Wavelengthmin
wWavelengthminLabel = WIDGET_LABEL(Basetab,$
                          XOFFSET = sWavelengthminLabel.size[0],$
                          YOFFSET = sWavelengthminLabel.size[1],$
                          VALUE   = sWavelengthminLabel.value)

wWavelengthminText = WIDGET_TEXT(Basetab,$
                        XOFFSET   = sWavelengthminText.size[0],$
                        YOFFSET   = sWavelengthminText.size[1],$
                        SCR_XSIZE = sWavelengthminText.size[2],$
                        SCR_YSIZE = sWavelengthminText.size[3],$
                        VALUE     = sWavelengthminText.value,$
                        UNAME     = sWavelengthminText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Wavelengthmax
wWavelengthmaxLabel = WIDGET_LABEL(Basetab,$
                          XOFFSET = sWavelengthmaxLabel.size[0],$
                          YOFFSET = sWavelengthmaxLabel.size[1],$
                          VALUE   = sWavelengthmaxLabel.value)

wWavelengthmaxText = WIDGET_TEXT(Basetab,$
                        XOFFSET   = sWavelengthmaxText.size[0],$
                        YOFFSET   = sWavelengthmaxText.size[1],$
                        SCR_XSIZE = sWavelengthmaxText.size[2],$
                        SCR_YSIZE = sWavelengthmaxText.size[3],$
                        VALUE     = sWavelengthmaxText.value,$
                        UNAME     = sWavelengthmaxText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Wavelengthwidth
wWavelengthwidthLabel = WIDGET_LABEL(Basetab,$
                          XOFFSET = sWavelengthwidthLabel.size[0],$
                          YOFFSET = sWavelengthwidthLabel.size[1],$
                          VALUE   = sWavelengthwidthLabel.value)

wWavelengthwidthText = WIDGET_TEXT(Basetab,$
                        XOFFSET   = sWavelengthwidthText.size[0],$
                        YOFFSET   = sWavelengthwidthText.size[1],$
                        SCR_XSIZE = sWavelengthwidthText.size[2],$
                        SCR_YSIZE = sWavelengthwidthText.size[3],$
                        VALUE     = sWavelengthwidthText.value,$
                        UNAME     = sWavelengthwidthText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Wavelength scale
wWavelengthscaleGroup =  CW_BGROUP(Basetab,$
                          sWavelengthscaleGroup.list,$
                          XOFFSET    = sWavelengthscaleGroup.size[0],$
                          YOFFSET    = sWavelengthscaleGroup.size[1],$
                          ROW        = 1,$
                          SET_VALUE  = sWavelengthscaleGroup.value,$
                          UNAME      = sWavelengthscaleGroup.uname,$
                          /EXCLUSIVE)

;Wavelength frame
wWavelengthFrame = WIDGET_LABEL(Basetab,$
                       XOFFSET   = sWavelengthFrame.size[0],$
                       YOFFSET   = sWavelengthFrame.size[1],$
                       SCR_XSIZE = sWavelengthFrame.size[2],$
                       SCR_YSIZE = sWavelengthFrame.size[3],$
                       VALUE     = '',$
                       FRAME     = sWavelengthFrame.frame)

;- Verbose Mode ---------------------------------------------------------------
group = CW_BGROUP(Basetab,$
                  sVerboseGroup.list,$
                  XOFFSET    = sVerboseGroup.size[0],$
                  YOFFSET    = sVerboseGroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sVerboseGroup.value,$
                  UNAME      = sVerboseGroup.uname,$
                  LABEL_LEFT = sVerboseGroup.title,$
                  /EXCLUSIVE)

;- Minimum Lambda Cut Off -----------------------------------------------------
group = CW_BGROUP(Basetab,$
                  sMinLambdaGroup.list,$
                  XOFFSET    = sMinLambdaGroup.size[0],$
                  YOFFSET    = sMinLambdaGroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sMinLambdaGroup.value,$
                  UNAME      = sMinLambdaGroup.uname,$
                  LABEL_LEFT = sMinLambdaGroup.title,$
                  /EXCLUSIVE)

;label and value
wLabel = WIDGET_LABEL(Basetab,$
                      XOFFSET   = sMLlabel.size[0],$
                      YOFFSET   = sMLlabel.size[1],$
                      VALUE     = sMLlabel.value,$
                      SENSITIVE = sMLlabel.sensitive,$
                      UNAME     = sMLlabel.uname)

wValue = WIDGET_TEXT(Basetab,$
                     XOFFSET   = sMLvalue.size[0],$
                     YOFFSET   = sMLvalue.size[1],$
                     SCR_XSIZE = sMLvalue.size[2],$
                     UNAME     = sMLvalue.uname,$
                     SENSITIVE = sMLvalue.sensitive,$
                     VALUE     = sMLvalue.value,$
                     /EDITABLE,$
                     /ALL_EVENTS,$
                     /ALIGN_LEFT)
                  
;- Maximum Lambda Cut Off -----------------------------------------------------
group = CW_BGROUP(Basetab,$
                  sMaxLambdaGroup.list,$
                  XOFFSET    = sMaxLambdaGroup.size[0],$
                  YOFFSET    = sMaxLambdaGroup.size[1],$
                  ROW        = 1,$
                  SET_VALUE  = sMaxLambdaGroup.value,$
                  UNAME      = sMaxLambdaGroup.uname,$
                  LABEL_LEFT = sMaxLambdaGroup.title,$
                  /EXCLUSIVE)

;label and value
wLabel = WIDGET_LABEL(Basetab,$
                      XOFFSET   = sMaxLlabel.size[0],$
                      YOFFSET   = sMaxLlabel.size[1],$
                      VALUE     = sMaxLlabel.value,$
                      SENSITIVE = sMaxLlabel.sensitive,$
                      UNAME     = sMaxLlabel.uname)

wValue = WIDGET_TEXT(Basetab,$
                     XOFFSET   = sMaxLvalue.size[0],$
                     YOFFSET   = sMaxLvalue.size[1],$
                     SCR_XSIZE = sMaxLvalue.size[2],$
                     UNAME     = sMaxLvalue.uname,$
                     SENSITIVE = sMaxLvalue.sensitive,$
                     VALUE     = sMaxLvalue.value,$
                     /EDITABLE,$
                     /ALL_EVENTS,$
                     /ALIGN_LEFT)
                  

END
