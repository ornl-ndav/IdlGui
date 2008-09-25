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

PRO make_gui_reduce_tab3, REDUCE_TAB, tab_size, tab_title

;- Define Main Base of Reduce Tab 1 -------------------------------------------
sBaseTab = { size:  tab_size,$
             uname: 'reduce_tab4_base',$
             title: tab_title}

;- Intermediate plot list -----------------------------------------------------
XYoff = [0,10]
sInterPlot = $
  { size:  [XYoff[0],$
            XYoff[1]],$
    list: ['Beam Monitor after Conversion To Wavelength',$
           'Beam Monitor in Wavelength after Efficiency Correction',$
           'Data of Each Pixel after Wavelength Conversion' + $
           ' (WARNING: HUGE FILE!)',$
           'Monitor Spectrum after Rebin to Detector Wavelength' + $
           ' Axis (WARNING: HUGE FILE!)',$
           'Fractional Counts and Area after Q Rebinning (Two Files)',$
           'Combined Spectrum of Data after Beam Monitor' + $
           ' Normalization'],$
    uname : 'intermediate_group_uname',$
    value : [0,0,0,0,0,0]}

;- inter#2 hidding base -------------------------------------------------------
XYoff = [5,43]
sInter2HiddingBase = { size:  [XYoff[0],$
                               XYoff[1],$
                               tab_size[2],$
                               20],$
                       frame:  0,$
                       uname:  'beam_monitor_hidding_base',$
                       map:    1}

XYoff = [17,0]
NotAvailableMessage = ' is NOT AVAILABLE !'
sInter2HiddingLabel = { size:  [XYoff[0],$
                                XYoff[1]],$
                        value: sInterPlot.list[1]+NotAvailableMessage}

;- Base of --dump-wave-bmmom about lambda -------------------------------------
XYoff = [0,180]
sBaseLambda = { size:  [XYoff[0],$
                        XYoff[1],$
                        tab_size[2],$
                        60],$
                uname: 'lambda_base',$
                map:   0}

XYoff = [5,10]
sLambdaFrame = { size:  [XYoff[0],$
                         XYoff[1],$
                         tab_size[2]-20,$
                         45],$
                 frame: 2}
XYoff = [20,-8]
sLambdaTitle = { size:  [sLambdaFrame.size[0]+XYoff[0],$
                         sLambdaFrame.size[1]+XYoff[1]],$
                 value: 'Lambda'}
;Lambda min
LambdaXoff = 30
XYoff = [LambdaXoff,15]
sLambdaminLabel = { size:  [sLambdaFrame.size[0]+XYoff[0],$
                            sLambdaFrame.size[1]+XYoff[1]],$
                    value: 'Min:'}
XYoff = [30,-5]
sLambdaminText = {  size:  [sLambdaminLabel.size[0]+XYoff[0],$
                            sLambdaminLabel.size[1]+XYoff[1],$
                            70,30],$
                    value: '',$
                    uname: 'lambda_min_text_field'}

;Lambdamax
XYoff = [LambdaXoff+5,0]
sLambdamaxLabel = { size:  [sLambdaminText.size[0]+ $
                            sLambdaminText.size[2]+XYoff[0],$
                            sLambdaminLabel.size[1]+XYoff[1]],$
                    value: 'Max:'}
XYoff = [30,0]
sLambdamaxText = {  size:  [sLambdamaxLabel.size[0]+XYoff[0],$
                            sLambdaminText.size[1]+XYoff[1],$
                            sLambdaminText.size[2:3]],$
                    value: '',$
                    uname: 'lambda_max_text_field'}

;Lambdawidth
XYoff = [Lambdaxoff+5,0]
sLambdawidthLabel = { size:  [sLambdamaxText.size[0]+ $
                              sLambdaminText.size[2]+XYoff[0],$
                              sLambdaminLabel.size[1]+XYoff[1]],$
                      value: 'Width:'}
XYoff = [45,0]
sLambdawidthText = {  size:  [sLambdawidthLabel.size[0]+XYoff[0],$
                              sLambdaminText.size[1]+XYoff[1],$
                              sLambdaminText.size[2:3]],$
                      value: '',$
                      uname: 'lambda_width_text_field'}

;Lambda scale
XYoff = [Lambdaxoff+5,0]
sLambdascaleGroup = { size:  [sLambdawidthText.size[0]+ $
                              sLambdawidthText.size[2]+XYoff[0],$
                              sLambdawidthText.size[1]+XYoff[1]],$
                      list:  ['Linear','Logarithmic'],$
                      value: 1.0,$
                      uname: 'lambda_scale_group'}

;==============================================================================
;= Build Widgets ==============================================================
Basetab = WIDGET_BASE(REDUCE_TAB,$
                       UNAME     = sBaseTab.uname,$
                       XOFFSET   = sBaseTab.size[0],$
                       YOFFSET   = sBaseTab.size[1],$
                       SCR_XSIZE = sBaseTab.size[2],$
                       SCR_YSIZE = sBaseTab.size[3],$
                       TITLE     = sBaseTab.title)

;- Inter#2 hidding base
wInter2Hiddingbase = WIDGET_BASE(Basetab,$
                                 XOFFSET   = sInter2HiddingBase.size[0],$
                                 YOFFSET   = sInter2HiddingBase.size[1],$
                                 SCR_XSIZE = sInter2HiddingBase.size[2],$
                                 SCR_YSIZE = sInter2HiddingBase.size[3],$
                                 UNAME     = sInter2HiddingBase.uname,$
                                 FRAME     = sInter2HiddingBase.frame,$
                                 MAP       = sInter2HiddingBase.map)

wInter2HiddingLabel = WIDGET_LABEL(wInter2HiddingBase,$
                                   XOFFSET = sInter2HiddingLabel.size[0],$
                                   YOFFSET = sInter2HiddingLabel.size[1],$
                                   VALUE   = sInter2HiddingLabel.value)

;- Intermediate plot list -----------------------------------------------------
InterGroup = CW_BGROUP(Basetab,$
                       sInterPlot.list,$
                       XOFFSET   = sInterPlot.size[0],$
                       YOFFSET   = sInterPlot.size[1],$
                       UNAME     = sInterPlot.uname,$
                       SET_VALUE = sInterPlot.value,$
                       /NONEXCLUSIVE)

;- Base of --dump-wave-bmmon about lambda -------------------------------------
LambdaBase = WIDGET_BASE(Basetab,$
                         XOFFSET   = sBaseLambda.size[0],$
                         YOFFSET   = sBaseLambda.size[1],$
                         SCR_XSIZE = sBaseLambda.size[2],$
                         SCR_YSIZE = sBaseLambda.size[3],$
                         UNAME     = sBaseLambda.uname,$
                         MAP       = sBaseLambda.map)

wQTitle = WIDGET_LABEL(LambdaBase,$
                       XOFFSET = sLambdaTitle.size[0],$
                       YOFFSET = sLambdaTitle.size[1],$
                       VALUE   = sLambdaTitle.value)
;Lambdamin
wLambdaminLabel = WIDGET_LABEL(LambdaBase,$
                               XOFFSET = sLambdaminLabel.size[0],$
                               YOFFSET = sLambdaminLabel.size[1],$
                               VALUE   = sLambdaminLabel.value)

wLambdaminText = WIDGET_TEXT(LambdaBase,$
                             XOFFSET   = sLambdaminText.size[0],$
                             YOFFSET   = sLambdaminText.size[1],$
                             SCR_XSIZE = sLambdaminText.size[2],$
                             SCR_YSIZE = sLambdaminText.size[3],$
                             VALUE     = sLambdaminText.value,$
                             UNAME     = sLambdaminText.uname,$
                             /EDITABLE,$
                             /ALL_EVENTS,$
                             /ALIGN_LEFT)

;Lambdamax
wLambdamaxLabel = WIDGET_LABEL(LambdaBase,$
                               XOFFSET = sLambdamaxLabel.size[0],$
                               YOFFSET = sLambdamaxLabel.size[1],$
                               VALUE   = sLambdamaxLabel.value)

wLambdamaxText = WIDGET_TEXT(LambdaBase,$
                             XOFFSET   = sLambdamaxText.size[0],$
                             YOFFSET   = sLambdamaxText.size[1],$
                             SCR_XSIZE = sLambdamaxText.size[2],$
                             SCR_YSIZE = sLambdamaxText.size[3],$
                             VALUE     = sLambdamaxText.value,$
                             UNAME     = sLambdamaxText.uname,$
                             /EDITABLE,$
                             /ALL_EVENTS,$
                             /ALIGN_LEFT)

;Lambdawidth
wLambdawidthLabel = WIDGET_LABEL(LambdaBase,$
                                 XOFFSET = sLambdawidthLabel.size[0],$
                                 YOFFSET = sLambdawidthLabel.size[1],$
                                 VALUE   = sLambdawidthLabel.value)

wLambdawidthText = WIDGET_TEXT(LambdaBase,$
                               XOFFSET   = sLambdawidthText.size[0],$
                               YOFFSET   = sLambdawidthText.size[1],$
                               SCR_XSIZE = sLambdawidthText.size[2],$
                               SCR_YSIZE = sLambdawidthText.size[3],$
                               VALUE     = sLambdawidthText.value,$
                               UNAME     = sLambdawidthText.uname,$
                               /EDITABLE,$
                               /ALL_EVENTS,$
                               /ALIGN_LEFT)

;Lambda scale
wLambdascaleGroup =  CW_BGROUP(LambdaBase,$
                               sLambdascaleGroup.list,$
                               XOFFSET    = sLambdascaleGroup.size[0],$
                               YOFFSET    = sLambdascaleGroup.size[1],$
                               ROW        = 1,$
                               SET_VALUE  = sLambdascaleGroup.value,$
                               UNAME      = sLambdascaleGroup.uname,$
                               /EXCLUSIVE)

;Lambda frame
wLambdaFrame = WIDGET_LABEL(LambdaBase,$
                            XOFFSET   = sLambdaFrame.size[0],$
                            YOFFSET   = sLambdaFrame.size[1],$
                            SCR_XSIZE = sLambdaFrame.size[2],$
                            SCR_YSIZE = sLambdaFrame.size[3],$
                            VALUE     = '',$
                            FRAME     = sLambdaFrame.frame)


END
