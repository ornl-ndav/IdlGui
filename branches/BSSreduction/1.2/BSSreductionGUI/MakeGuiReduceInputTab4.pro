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

PRO MakeGuiReduceInputTab4, ReduceInputTab, ReduceInputTabSettings

;******************************************************************************
;                           Define size arrays
;******************************************************************************

;////////////////////////////////////////////////////////
;Time-Independent Background TOF channels (microSeconds)/
;////////////////////////////////////////////////////////
yoff = 35
TIBtofFrame = { size : [5,yoff,730,50],$
                frame : 4}
XYoff = [10,-14]
TIBtofBase = { size : [TIBtofFrame.size[0]+XYoff[0],$
                       TIBtofFrame.size[1]+XYoff[1],$
                       425,$
                       30],$
               button : { uname : 'tib_tof_button',$
                          list : ['Time-Independent Background ' + $
                                  'Time-of-Flight Channels (microSeconds)'],$
                          value : 0,$
                          sensitive : 0}}
XYoff1 = [10,23]
TIBtofLabel1 = { size : [TIBtofFrame.size[0]+XYoff1[0],$
                         TIBtofFrame.size[1]+XYoff1[1]],$
                 uname : 'tibtof_channel1_text_label',$
                 value : 'TOF channels    #1'}
XYoff2 = [115,-6]
TIBtofText1 = { size : [TIBtofLabel1.size[0]+XYoff2[0],$
                        TIBtofLabel1.size[1]+XYoff2[1],$
                        70,30],$
                uname : 'tibtof_channel1_text',$
                sensitive : TIBtofBase.button.value}
                
XYoff3 = [243,1]
TIBtofLabel2 = { size : [TIBtofLabel1.size[0]+XYoff3[0],$
                         TIBtofLabel1.size[1]],$
                 value : '#2',$
                 uname : 'tibtof_channel2_text_label',$
                 sensitive : TIBtofBase.button.value}
XYoff4 = [20,0]
TIBtofText2 = { size : [TIBtofLabel2.size[0]+XYoff4[0],$
                        TIBtofText1.size[1],$
                        70,30],$
                uname : 'tibtof_channel2_text',$
                sensitive : TIBtofBase.button.value}

XYoff5 = [150,1]
TIBtofLabel3 = { size : [TIBtofLabel2.size[0]+XYoff5[0],$
                         TIBtofLabel2.size[1]],$
                 value : '#3',$
                 uname : 'tibtof_channel3_text_label',$
                 sensitive : TIBtofBase.button.value}
XYoff6 = [20,0]
TIBtofText3 = { size : [TIBtofLabel3.size[0]+XYoff6[0],$
                        TIBtofText2.size[1],$
                        70,30],$
                uname : 'tibtof_channel3_text',$
                sensitive : TIBtofBase.button.value}

XYoff7 = [150,1]
TIBtofLabel4 = { size : [TIBtofLabel3.size[0]+XYoff7[0],$
                         TIBtofLabel3.size[1]],$
                 value : '#4',$
                 uname : 'tibtof_channel4_text_label',$
                 sensitive : TIBtofBase.button.value}
XYoff8 = [20,0]
TIBtofText4 = { size : [TIBtofLabel4.size[0]+XYoff8[0],$
                        TIBtofText3.size[1],$
                        70,30],$
                uname : 'tibtof_channel4_text',$
                sensitive : TIBtofBase.button.value}

;/////////////////////////////////////////////////////
;Time-Independent Background Constant for Sample Data/
;/////////////////////////////////////////////////////
yoff = 80
TIBCfSDframe = { size : [TIBtofFrame.size[0],$
                         TIBtofFrame.size[1]+yoff,$
                         TIBtofFrame.size[2],$
                         55],$
                 frame: TIBtofFrame.frame}

XYoff9 = [10,-14]
TIBCfSDBase = { size : [TIBCfSDframe.size[0]+XYoff9[0],$
                        TIBCfSDframe.size[1]+XYoff9[1],$
                        340,$
                        30],$
                button : { uname : 'tibc_for_sd_button',$
                           list : ['Time-Independent Background ' + $
                                   'Constant for Sample Data'],$
                           value : 0}}

XYoff10 = [10,25]
TIBCfSDvalueLabel = { size : [TIBCfSDframe.size[0]+XYoff10[0],$
                              TIBCfSDframe.size[1]+XYoff10[1]],$
                      value : 'Value:',$
                      uname : 'tibc_for_sd_value_text_label',$
                      sensitive : TIBCfSDBase.button.value}
XYoff11 = [50,-5]
TIBCfSDvalueText  = { size : [TIBCfSDvalueLabel.size[0]+XYoff11[0],$
                              TIBCfSDvaluelabel.size[1]+XYoff11[1],$
                              100,30],$
                      uname : 'tibc_for_sd_value_text',$
                      sensitive : TIBCfSDBase.button.value}

XYoff12 = [200,0]
TIBCfSDerrorLabel = { size : [TIBCfSDvalueLabel.size[0]+XYoff12[0],$
                              TIBCfSDvalueLabel.size[1]+XYoff12[1]],$
                      value : 'Error:',$
                      uname : 'tibc_for_sd_error_text_label',$
                      sensitive : TIBCfSDBase.button.value}
XYoff13 = [50,-5]
TIBCfSDerrorText  = { size : [TIBCfSDerrorLabel.size[0]+XYoff13[0],$
                              TIBCfSDerrorlabel.size[1]+XYoff13[1],$
                              100,30],$
                      uname : 'tibc_for_sd_error_text',$
                      sensitive : TIBCfSDBase.button.value}

;/////////////////////////////////////////////////////////
;Time-Independent Background Constant for background Data/
;/////////////////////////////////////////////////////////
yoff = yoff + 20
TIBCfBDframe = { size : [TIBtofFrame.size[0],$
                         TIBCfSDbase.size[1]+yoff,$
                         TIBtofFrame.size[2],$
                         TIBCfSDframe.size[3]],$
                 frame: TIBtofFrame.frame}

XYoff9 = [10,-14]
TIBCfBDBase = { size : [TIBCfBDframe.size[0]+XYoff9[0],$
                        TIBCfBDframe.size[1]+XYoff9[1],$
                        365,$
                        30],$
                button : { uname : 'tibc_for_bd_button',$
                           list : ['Time-Independent Background ' + $
                                   'Constant for Background Data'],$
                           value : 0}}
XYoff10 = [10,25]
TIBCfBDvalueLabel = { size : [TIBCfBDframe.size[0]+XYoff10[0],$
                              TIBCfBDframe.size[1]+XYoff10[1]],$
                      value : 'Value:',$
                      uname : 'tibc_for_bd_value_text_label',$
                      sensitive : TIBCfBDBase.button.value}
XYoff11 = [50,-5]
TIBCfBDvalueText  = { size : [TIBCfBDvalueLabel.size[0]+XYoff11[0],$
                              TIBCfBDvaluelabel.size[1]+XYoff11[1],$
                              100,30],$
                      uname : 'tibc_for_bd_value_text',$
                      sensitive : TIBCfBDBase.button.value}

XYoff12 = [200,0]
TIBCfBDerrorLabel = { size : [TIBCfBDvalueLabel.size[0]+XYoff12[0],$
                              TIBCfBDvalueLabel.size[1]+XYoff12[1]],$
                      value : 'Error:',$
                      uname : 'tibc_for_bd_error_text_label',$
                      sensitive : TIBCfBDBase.button.value}
XYoff13 = [50,-5]
TIBCfBDerrorText  = { size : [TIBCfBDerrorLabel.size[0]+XYoff13[0],$
                              TIBCfBDerrorlabel.size[1]+XYoff13[1],$
                              100,30],$
                      uname : 'tibc_for_bd_error_text',$
                      sensitive : TIBCfBDBase.button.value}

;////////////////////////////////////////////////////////////
;Time-Independent Background Constant for Normalization Data/
;////////////////////////////////////////////////////////////
TIBCfNDframe = { size : [TIBtofFrame.size[0],$
                         TIBCfBDbase.size[1]+yoff,$
                         TIBCfBDframe.size[2],$
                         TIBCfBDframe.size[3]],$
                 frame: TIBtofFrame.frame}

XYoff9 = [10,-14]
TIBCfNDBase = { size : [TIBCfNDframe.size[0]+XYoff9[0],$
                        TIBCfNDframe.size[1]+XYoff9[1],$
                        385,$
                        30],$
                button : { uname : 'tibc_for_nd_button',$
                           list : ['Time-Independent Background Constant ' + $
                                   'for Normalization Data'],$
                           value : 0}}

XYoff10 = [10,25]
TIBCfNDvalueLabel = { size : [TIBCfNDframe.size[0]+XYoff10[0],$
                              TIBCfNDframe.size[1]+XYoff10[1]],$
                      value : 'Value:',$
                      uname : 'tibc_for_nd_value_text_label',$
                      sensitive : TIBCfNDBase.button.value}
XYoff11 = [50,-5]
TIBCfNDvalueText  = { size : [TIBCfNDvalueLabel.size[0]+XYoff11[0],$
                              TIBCfNDvaluelabel.size[1]+XYoff11[1],$
                              100,30],$
                      uname : 'tibc_for_nd_value_text',$
                      sensitive : TIBCfNDBase.button.value}

XYoff12 = [200,0]
TIBCfNDerrorLabel = { size : [TIBCfNDvalueLabel.size[0]+XYoff12[0],$
                              TIBCfNDvalueLabel.size[1]+XYoff12[1]],$
                      value : 'Error:',$
                      uname : 'tibc_for_nd_error_text_label',$
                      sensitive : TIBCfNDBase.button.value}
XYoff13 = [50,-5]
TIBCfNDerrorText  = { size : [TIBCfNDerrorLabel.size[0]+XYoff13[0],$
                              TIBCfNDerrorlabel.size[1]+XYoff13[1],$
                              100,30],$
                      uname : 'tibc_for_nd_error_text',$
                      sensitive : TIBCfNDBase.button.value}

;////////////////////////////////////////////////////////
;Time-Independent Background Constant for Empty Can Data/
;////////////////////////////////////////////////////////
TIBCfECDframe = { size : [TIBtofFrame.size[0],$
                         TIBCfNDbase.size[1]+yoff,$
                         TIBCfNDframe.size[2],$
                         TIBCfNDframe.size[3]],$
                 frame: TIBtofFrame.frame}

XYoff9 = [10,-14]
TIBCfECDBase = { size : [TIBCfECDframe.size[0]+XYoff9[0],$
                        TIBCfECDframe.size[1]+XYoff9[1],$
                        360,$
                        30],$
                button : { uname : 'tibc_for_ecd_button',$
                           list : ['Time-Independent Background Constant' + $
                                   ' for Empty Can Data'],$
                           value : 0}}

XYoff10 = [10,25]
TIBCfECDvalueLabel = { size : [TIBCfECDframe.size[0]+XYoff10[0],$
                               TIBCfECDframe.size[1]+XYoff10[1]],$
                       value : 'Value:',$
                       uname : 'tibc_for_ecd_value_text_label',$
                       sensitive : TIBCfECDBase.button.value}
XYoff11 = [50,-5]
TIBCfECDvalueText  = { size : [TIBCfECDvalueLabel.size[0]+XYoff11[0],$
                              TIBCfECDvaluelabel.size[1]+XYoff11[1],$
                               100,30],$
                       uname : 'tibc_for_ecd_value_text',$
                       sensitive : TIBCfECDBase.button.value}

XYoff12 = [200,0]
TIBCfECDerrorLabel = { size : [TIBCfECDvalueLabel.size[0]+XYoff12[0],$
                               TIBCfECDvalueLabel.size[1]+XYoff12[1]],$
                       value : 'Error:',$
                       uname : 'tibc_for_ecd_error_text_label',$
                       sensitive : TIBCfECDBase.button.value}
XYoff13 = [50,-5]
TIBCfECDerrorText  = { size : [TIBCfECDerrorLabel.size[0]+XYoff13[0],$
                              TIBCfECDerrorlabel.size[1]+XYoff13[1],$
                              100,30],$
                      uname : 'tibc_for_ecd_error_text',$
                       sensitive : TIBCfECDBase.button.value}

;/////////////////////////////////////////////////////////
;Time-Independent Background Constant for Scattering Data/
;/////////////////////////////////////////////////////////
yoff = 80
TIBCfScatDframe = { size : [TIBCfECDframe.size[0],$
                            TIBCfECDframe.size[1]+yoff,$
                            TIBCfECDframe.size[2],$
                            55],$
                    frame: TIBtofFrame.frame}

XYoff9 = [10,-14]
TIBCfScatDBase = { size : [TIBCfScatDframe.size[0]+XYoff9[0],$
                        TIBCfScatDframe.size[1]+XYoff9[1],$
                        365,$
                        30],$
                button : { uname : 'tibc_for_scatd_button',$
                           list : ['Time-Independent Background Constant' + $
                                   ' for Scattering Data'],$
                           value : 0}}

XYoff10 = [10,25]
TIBCfScatDvalueLabel = { size : [TIBCfScatDframe.size[0]+XYoff10[0],$
                              TIBCfScatDframe.size[1]+XYoff10[1]],$
                      value : 'Value:',$
                      uname : 'tibc_for_scatd_value_text_label',$
                      sensitive : TIBCfScatDBase.button.value}
XYoff11 = [50,-5]
TIBCfScatDvalueText  = { size : [TIBCfScatDvalueLabel.size[0]+XYoff11[0],$
                              TIBCfScatDvaluelabel.size[1]+XYoff11[1],$
                              100,30],$
                      uname : 'tibc_for_scatd_value_text',$
                      sensitive : TIBCfScatDBase.button.value}

XYoff12 = [200,0]
TIBCfScatDerrorLabel = { size : [TIBCfScatDvalueLabel.size[0]+XYoff12[0],$
                              TIBCfScatDvalueLabel.size[1]+XYoff12[1]],$
                      value : 'Error:',$
                      uname : 'tibc_for_scatd_error_text_label',$
                      sensitive : TIBCfScatDBase.button.value}
XYoff13 = [50,-5]
TIBCfScatDerrorText  = { size : [TIBCfScatDerrorLabel.size[0]+XYoff13[0],$
                              TIBCfScatDerrorlabel.size[1]+XYoff13[1],$
                              100,30],$
                      uname : 'tibc_for_scatd_error_text',$
                      sensitive : TIBCfScatDBase.button.value}

;******************************************************************************
;                                Build GUI
;******************************************************************************
tab4_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[2])

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background TOF channels (microSeconds)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
                   XOFFSET   = TIBtofBase.size[0],$
                   YOFFSET   = TIBtofBase.size[1],$
                   SCR_XSIZE = TIBtofBase.size[2],$
                   SCR_YSIZE = TIBtofBase.size[3])
                   
group = CW_BGROUP(base,$
                  TIBtofBase.button.list,$
                  UNAME      = TIBtofBase.button.uname,$
                  SET_VALUE  = TIBtofBase.button.value,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

TIBtofLabel1 = WIDGET_LABEL(tab4_base,$
                            XOFFSET   = TIBtofLabel1.size[0],$
                            YOFFSET   = TIBtofLabel1.size[1],$
                            SENSITIVE = TIBtofBase.button.sensitive,$
                            UNAME     = TIBtofLabel1.uname,$
                            VALUE     = TIBtofLabel1.value)

TIBtofText1 = WIDGET_TEXT(tab4_base,$
                          XOFFSET    = TIBtofText1.size[0],$
                          YOFFSET    = TIBtofText1.size[1],$
                          SCR_XSIZE  = TIBtofText1.size[2],$
                          SCR_YSIZE  = TIBtofText1.size[3],$
                          UNAME      = TIBtofText1.uname,$
                          SENSITIVE  = TIBtofBase.button.sensitive,$
                          /EDITABLE,$
                          /ALL_EVENTS,$
                          /ALIGN_LEFT)


TIBtofLabel2 = WIDGET_LABEL(tab4_base,$
                            XOFFSET   = TIBtofLabel2.size[0],$
                            YOFFSET   = TIBtofLabel2.size[1],$
                            SENSITIVE = TIBtofBase.button.sensitive,$
                            UNAME     = TIBtofLabel2.uname,$
                            VALUE     = TIBtofLabel2.value)

TIBtofText2 = WIDGET_TEXT(tab4_base,$
                          XOFFSET    = TIBtofText2.size[0],$
                          YOFFSET    = TIBtofText2.size[1],$
                          SCR_XSIZE  = TIBtofText2.size[2],$
                          SCR_YSIZE  = TIBtofText2.size[3],$
                          UNAME      = TIBtofText2.uname,$
                          SENSITIVE  = TIBtofBase.button.sensitive,$
                          /EDITABLE,$
                          /ALL_EVENTS,$
                          /ALIGN_LEFT)


TIBtofLabel3 = WIDGET_LABEL(tab4_base,$
                            XOFFSET   = TIBtofLabel3.size[0],$
                            YOFFSET   = TIBtofLabel3.size[1],$
                            SENSITIVE = TIBtofBase.button.sensitive,$
                            UNAME     = TIBtofLabel3.uname,$
                            VALUE     = TIBtofLabel3.value)

TIBtofText3 = WIDGET_TEXT(tab4_base,$
                          XOFFSET    = TIBtofText3.size[0],$
                          YOFFSET    = TIBtofText3.size[1],$
                          SCR_XSIZE  = TIBtofText3.size[2],$
                          SCR_YSIZE  = TIBtofText3.size[3],$
                          UNAME      = TIBtofText3.uname,$
                          SENSITIVE  = TIBtofBase.button.sensitive,$
                          /EDITABLE,$
                          /ALL_EVENTS,$
                          /ALIGN_LEFT)


TIBtofLabel4 = WIDGET_LABEL(tab4_base,$
                            XOFFSET   = TIBtofLabel4.size[0],$
                            YOFFSET   = TIBtofLabel4.size[1],$
                            SENSITIVE = TIBtofBase.button.sensitive,$
                            UNAME     = TIBtofLabel4.uname,$
                            VALUE     = TIBtofLabel4.value)

TIBtofText4 = WIDGET_TEXT(tab4_base,$
                          XOFFSET    = TIBtofText4.size[0],$
                          YOFFSET    = TIBtofText4.size[1],$
                          SCR_XSIZE  = TIBtofText4.size[2],$
                          SCR_YSIZE  = TIBtofText4.size[3],$
                          UNAME      = TIBtofText4.uname,$
                          SENSITIVE  = TIBtofBase.button.sensitive,$
                          /EDITABLE,$
                          /ALL_EVENTS,$
                          /ALIGN_LEFT)

TIBtofFrame = WIDGET_LABEL(tab4_base,$
                           XOFFSET   = TIBtofFrame.size[0],$
                           YOFFSET   = TIBtofFrame.size[1],$
                           SCR_XSIZE = TIBtofFrame.size[2],$
                           SCR_YSIZE = TIBtofFrame.size[3],$
                           FRAME     = TIBtofFrame.frame,$
                           VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background Constant for Sample Data\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
                   XOFFSET   = TIBCfSDbase.size[0],$
                   YOFFSET   = TIBCfSDbase.size[1],$
                   SCR_XSIZE = TIBCfSDbase.size[2],$
                   SCR_YSIZE = TIBCfSDbase.size[3])

group = CW_BGROUP(base,$
                  TIBCfSDbase.button.list,$
                  UNAME      = TIBCfSDbase.button.uname,$
                  SET_VALUE  = TIBCfSDbase.button.value,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfSDvalueLabel.size[0],$
                     YOFFSET   = TIBCfSDvalueLabel.size[1],$
                     VALUE     = TIBCfSDvalueLabel.value,$
                     UNAME     = TIBCfSDvalueLabel.uname,$
                     SENSITIVE = TIBCfSDvalueLabel.sensitive)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCFSDvalueText.size[0],$
                   YOFFSET   = TIBCFSDvalueText.size[1],$
                   SCR_XSIZE = TIBCFSDvalueText.size[2],$
                   SCR_YSIZE = TIBCFSDvalueText.size[3],$
                   UNAME     = TIBCFSDvalueText.uname,$
                   SENSITIVE = TIBCFSDvalueText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfSDerrorLabel.size[0],$
                     YOFFSET   = TIBCfSDerrorLabel.size[1],$
                     VALUE     = TIBCfSDerrorLabel.value,$
                     UNAME     = TIBCfSDerrorLabel.uname,$
                     SENSITIVE = TIBCfSDerrorLabel.sensitive)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCFSDerrorText.size[0],$
                   YOFFSET   = TIBCFSDerrorText.size[1],$
                   SCR_XSIZE = TIBCFSDerrorText.size[2],$
                   SCR_YSIZE = TIBCFSDerrorText.size[3],$
                   UNAME     = TIBCFSDerrorText.uname,$
                   SENSITIVE = TIBCFSDerrorText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = TIBCfSDframe.size[0],$
                      YOFFSET   = TIBCfSDframe.size[1],$
                      SCR_XSIZE = TIBCfSDframe.size[2],$
                      SCR_YSIZE = TIBCfSDframe.size[3],$
                      FRAME     = TIBCfSDframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background Constant for Background Data\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
                   XOFFSET   = TIBCfBDbase.size[0],$
                   YOFFSET   = TIBCfBDbase.size[1],$
                   SCR_XSIZE = TIBCfBDbase.size[2],$
                   SCR_YSIZE = TIBCfBDbase.size[3])

group = CW_BGROUP(base,$
                  TIBCfBDbase.button.list,$
                  UNAME      = TIBCfBDbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfBDvalueLabel.size[0],$
                     YOFFSET   = TIBCfBDvalueLabel.size[1],$
                     VALUE     = TIBCfBDvalueLabel.value,$
                     UNAME     = TIBCfBDvalueLabel.uname,$
                     SENSITIVE = TIBCfBDvalueLabel.sensitive)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfBDvalueText.size[0],$
                   YOFFSET   = TIBCfBDvalueText.size[1],$
                   SCR_XSIZE = TIBCfBDvalueText.size[2],$
                   SCR_YSIZE = TIBCfBDvalueText.size[3],$
                   UNAME     = TIBCfBDvalueText.uname,$
                   SENSITIVE = TIBCfBDvalueText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfBDerrorLabel.size[0],$
                     YOFFSET   = TIBCfBDerrorLabel.size[1],$
                     VALUE     = TIBCfBDerrorLabel.value,$
                     UNAME     = TIBCfBDerrorLabel.uname,$
                     SENSITIVE = TIBCfBDerrorLabel.sensitive)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfBDerrorText.size[0],$
                   YOFFSET   = TIBCfBDerrorText.size[1],$
                   SCR_XSIZE = TIBCfBDerrorText.size[2],$
                   SCR_YSIZE = TIBCfBDerrorText.size[3],$
                   UNAME     = TIBCfBDerrorText.uname,$
                   SENSITIVE = TIBCfBDerrorText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = TIBCfBDframe.size[0],$
                      YOFFSET   = TIBCfBDframe.size[1],$
                      SCR_XSIZE = TIBCfBDframe.size[2],$
                      SCR_YSIZE = TIBCfBDframe.size[3],$
                      FRAME     = TIBCfBDframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background Constant for Normalization Data\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
                   XOFFSET   = TIBCfNDbase.size[0],$
                   YOFFSET   = TIBCfNDbase.size[1],$
                   SCR_XSIZE = TIBCfNDbase.size[2],$
                   SCR_YSIZE = TIBCfNDbase.size[3])

group = CW_BGROUP(base,$
                  TIBCfNDbase.button.list,$
                  UNAME      = TIBCfNDbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfNDvalueLabel.size[0],$
                     YOFFSET   = TIBCfNDvalueLabel.size[1],$
                     VALUE     = TIBCfNDvalueLabel.value,$
                     UNAME     = TIBCfNDvalueLabel.uname,$
                     SENSITIVE = TIBCfNDbase.button.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfNDvalueText.size[0],$
                   YOFFSET   = TIBCfNDvalueText.size[1],$
                   SCR_XSIZE = TIBCfNDvalueText.size[2],$
                   SCR_YSIZE = TIBCfNDvalueText.size[3],$
                   UNAME     = TIBCfNDvalueText.uname,$
                   SENSITIVE = TIBCfNDbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfNDerrorLabel.size[0],$
                     YOFFSET   = TIBCfNDerrorLabel.size[1],$
                     VALUE     = TIBCfNDerrorLabel.value,$
                     UNAME     = TIBCfNDerrorLabel.uname,$
                     SENSITIVE = TIBCfNDbase.button.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfNDerrorText.size[0],$
                   YOFFSET   = TIBCfNDerrorText.size[1],$
                   SCR_XSIZE = TIBCfNDerrorText.size[2],$
                   SCR_YSIZE = TIBCfNDerrorText.size[3],$
                   UNAME     = TIBCfNDerrorText.uname,$
                   SENSITIVE = TIBCfNDbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = TIBCfNDframe.size[0],$
                      YOFFSET   = TIBCfNDframe.size[1],$
                      SCR_XSIZE = TIBCfNDframe.size[2],$
                      SCR_YSIZE = TIBCfNDframe.size[3],$
                      FRAME     = TIBCfNDframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background Constant for Empty Can Data\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
                   XOFFSET   = TIBCfECDbase.size[0],$
                   YOFFSET   = TIBCfECDbase.size[1],$
                   SCR_XSIZE = TIBCfECDbase.size[2],$
                   SCR_YSIZE = TIBCfECDbase.size[3])

group = CW_BGROUP(base,$
                  TIBCfECDbase.button.list,$
                  UNAME      = TIBCfECDbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfECDvalueLabel.size[0],$
                     YOFFSET   = TIBCfECDvalueLabel.size[1],$
                     VALUE     = TIBCfECDvalueLabel.value,$
                     UNAME     = TIBCfECDvalueLabel.uname,$
                     SENSITIVE = TIBCfECDbase.button.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfECDvalueText.size[0],$
                   YOFFSET   = TIBCfECDvalueText.size[1],$
                   SCR_XSIZE = TIBCfECDvalueText.size[2],$
                   SCR_YSIZE = TIBCfECDvalueText.size[3],$
                   UNAME     = TIBCfECDvalueText.uname,$
                   SENSITIVE = TIBCfECDbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfECDerrorLabel.size[0],$
                     YOFFSET   = TIBCfECDerrorLabel.size[1],$
                     VALUE     = TIBCfECDerrorLabel.value,$
                     UNAME     = TIBCfECDerrorLabel.uname,$
                     SENSITIVE = TIBCfECDbase.button.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfECDerrorText.size[0],$
                   YOFFSET   = TIBCfECDerrorText.size[1],$
                   SCR_XSIZE = TIBCfECDerrorText.size[2],$
                   SCR_YSIZE = TIBCfECDerrorText.size[3],$
                   UNAME     = TIBCfECDerrorText.uname,$
                   SENSITIVE = TIBCfECDbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = TIBCfECDframe.size[0],$
                      YOFFSET   = TIBCfECDframe.size[1],$
                      SCR_XSIZE = TIBCfECDframe.size[2],$
                      SCR_YSIZE = TIBCfECDframe.size[3],$
                      FRAME     = TIBCfECDframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background Constant for Scattering Data\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
                   XOFFSET   = TIBCfScatDbase.size[0],$
                   YOFFSET   = TIBCfScatDbase.size[1],$
                   SCR_XSIZE = TIBCfScatDbase.size[2],$
                   SCR_YSIZE = TIBCfScatDbase.size[3])

group = CW_BGROUP(base,$
                  TIBCfScatDbase.button.list,$
                  UNAME      = TIBCfScatDbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfScatDvalueLabel.size[0],$
                     YOFFSET   = TIBCfScatDvalueLabel.size[1],$
                     VALUE     = TIBCfScatDvalueLabel.value,$
                     UNAME     = TIBCfScatDvalueLabel.uname,$
                     SENSITIVE = TIBCfScatDbase.button.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfScatDvalueText.size[0],$
                   YOFFSET   = TIBCfScatDvalueText.size[1],$
                   SCR_XSIZE = TIBCfScatDvalueText.size[2],$
                   SCR_YSIZE = TIBCfScatDvalueText.size[3],$
                   UNAME     = TIBCfScatDvalueText.uname,$
                   SENSITIVE = TIBCfScatDbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET   = TIBCfScatDerrorLabel.size[0],$
                     YOFFSET   = TIBCfScatDerrorLabel.size[1],$
                     VALUE     = TIBCfScatDerrorLabel.value,$
                     UNAME     = TIBCfScatDerrorLabel.uname,$
                     SENSITIVE = TIBCfScatDbase.button.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TIBCfScatDerrorText.size[0],$
                   YOFFSET   = TIBCfScatDerrorText.size[1],$
                   SCR_XSIZE = TIBCfScatDerrorText.size[2],$
                   SCR_YSIZE = TIBCfScatDerrorText.size[3],$
                   UNAME     = TIBCfScatDerrorText.uname,$
                   SENSITIVE = TIBCfScatDbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = TIBCfScatDframe.size[0],$
                      YOFFSET   = TIBCfScatDframe.size[1],$
                      SCR_XSIZE = TIBCfScatDframe.size[2],$
                      SCR_YSIZE = TIBCfScatDframe.size[3],$
                      FRAME     = TIBCfScatDframe.frame,$
                      VALUE     = '')

END
