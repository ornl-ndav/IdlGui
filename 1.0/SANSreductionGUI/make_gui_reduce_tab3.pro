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

PRO make_gui_reduce_tab3, REDUCE_TAB, tab_size, tab_title

;- Define Main Base of Reduce Tab 1 --------------------------------------------
sBaseTab3 = { size:  tab_size,$
              uname: 'reduce_tab3_base',$
              title: tab_title}

;- Intermediate plot list ------------------------------------------------------
XYoff = [0,10]
sInterPlot = { size:  [XYoff[0],$
                       XYoff[1]],$
               list: ['Beam Monitor after Conversion To Wavelength',$
                      'Beam Monitor in Wavelength after Efficiency Correction',$
                      'Data of Each Pixel after Wavelength Conversion' + $
                      ' (WARNING: HUGE FILE!)',$
                      'Monitor Spectrum after Rebin to Detector Wavelength' + $
                      ' Axis (WARNING: HUGE FILE!)',$
                      'Combined Spectrum of Data after Beam Monitor' + $
                      ' Normalization'],$
               uname : 'intermediate_group_uname',$
               value : [0,0,0,0,0]}

;- inter#2 hidding base
XYoff = [5,43]
sInter2HiddingBase = { size:  [XYoff[0],$
                               XYoff[1],$
                               tab_size[2],$
                               20],$
                       frame:  0,$
                       uname:  'beam_monitor_hidding_base',$
                       map:    0}

XYoff = [17,0]
NotAvailableMessage = ' is NOT AVAILABLE !'
sInter2HiddingLabel = { size:  [XYoff[0],$
                                XYoff[1]],$
                        value: sInterPlot.list[1]+NotAvailableMessage}

;===============================================================================
;= Build Widgets ===============================================================
BaseTab3 = WIDGET_BASE(REDUCE_TAB,$
                       UNAME     = sBaseTab3.uname,$
                       XOFFSET   = sBaseTab3.size[0],$
                       YOFFSET   = sBaseTab3.size[1],$
                       SCR_XSIZE = sBaseTab3.size[2],$
                       SCR_YSIZE = sBaseTab3.size[3],$
                       TITLE     = sBaseTab3.title)

;- Inter#2 hidding base
wInter2Hiddingbase = WIDGET_BASE(BaseTab3,$
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

;- Intermediate plot list ------------------------------------------------------
InterGroup = CW_BGROUP(BaseTab3,$
                       sInterPlot.list,$
                       XOFFSET   = sInterPlot.size[0],$
                       YOFFSET   = sInterPlot.size[1],$
                       UNAME     = sInterPlot.uname,$
                       SET_VALUE = sInterPlot.value,$
                       /NONEXCLUSIVE)

END
