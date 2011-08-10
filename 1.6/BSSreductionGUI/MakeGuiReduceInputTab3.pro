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

PRO MakeGuiReduceInputTab3, ReduceInputTab, ReduceInputTabSettings

;******************************************************************************
;                           Define size arrays
;******************************************************************************

;//////////////////////
;Run McStas NeXus file/
;//////////////////////
yoff = 50             
RMcNFBase = { size : [5,25,500,40],$
              button : { uname : 'rmcnf_button',$
                         value : '',$
                         list : ['Run McStas NeXus Files']}}

;////////
;Verbose/
;////////
VerboseBase = { size : [RMcNFbase.size[0],$
                        RMcNFbase.size[1]+yoff,$
                        200,$
                        RMcNFbase.size[3]],$
                button : { uname : 'verbose_button',$
                           value : RMcNFbase.button.value,$
                           list : ['Verbose']}}

;////////////////////////////////////////
;Alternate Background Subtraction Method/
;////////////////////////////////////////
ABSMBase = { size : [Verbosebase.size[0],$
                     Verbosebase.size[1]+yoff,$
                     400,$
                     Verbosebase.size[3]],$
             button : { uname : 'absm_button',$
                        value : RMcNFbase.button.value,$
                        list : ['Alternate Background Subtraction Method']}}

;/////////////////////////
;No Monitor Normalization/
;/////////////////////////
NMNBase = { size : [ABSMbase.size[0],$
                    ABSMbase.size[1]+yoff,$
                    400,$
                    ABSMbase.size[3]],$
             button : { uname : 'nmn_button',$
                        value : RMcNFbase.button.value,$
                        list : ['No Monitor Normalization']}}

;/////////////////////////////////
;No Monitor Efficiency Correction/
;/////////////////////////////////
NMECBase = { size : [NMNbase.size[0],$
                     NMNbase.size[1]+yoff,$
                     400,$
                     NMNbase.size[3]],$
             button : { uname : 'nmec_button',$
                        value : RMcNFbase.button.value,$
                        list : ['No Monitor Efficiency Correction']}}


;/////////////////////////////////////
;Normalization Integration Wavelength/
;/////////////////////////////////////
yoff += 10
NIWframe = { size : [5,NMECBase.size[1]+yoff,730,50],$
             frame: 4}

XYoff9 = [10,-14]
NIWBase = { size : [NIWframe.size[0]+XYoff9[0],$
                    NIWframe.size[1]+XYoff9[1],$
                    400,30],$
            button : { uname : 'niw_button',$
                       list : ['Normalization Integration Start ' + $
                               'and End Wavelength (Angstroms)'],$
                       value : 0}}

XYoff10 = [20,25]
NIWlowLabel = { size : [NIWframe.size[0]+XYoff10[0],$
                        NIWframe.size[1]+XYoff10[1]],$
                value : 'Start:',$
                uname : 'nisw_field_label',$
                sensitive : NIWBase.button.value}
XYoff11 = [50,-5]
NIWlowText  = { size : [NIWlowLabel.size[0]+XYoff11[0],$
                        NIWlowlabel.size[1]+XYoff11[1],$
                        100,30],$
                uname : 'nisw_field',$
                sensitive : NIWBase.button.value}

XYoff12 = [200,0]
NIWhighLabel = { size : [NIWlowLabel.size[0]+XYoff12[0],$
                         NIWlowLabel.size[1]+XYoff12[1]],$
                 value : 'End:',$
                 uname : 'niew_field_label',$
                 sensitive : NIWBase.button.value}
XYoff13 = [50,-5]
NIWhighText  = { size : [NIWhighLabel.size[0]+XYoff13[0],$
                         NIWhighlabel.size[1]+XYoff13[1],$
                         100,30],$
                 uname : 'niew_field',$
                 sensitive : NIWBase.button.value}

;//////////////////////////////////////////////////
;Low and High values that bracket the elastic peak/
;//////////////////////////////////////////////////
yoff += 25
TEframe = { size : [5,NIWframe.size[1]+yoff, $
                    NIWframe.size[2:3]],$
            frame: NIWframe.frame}

XYoff9 = [10,-14]
TEBase = {size : [TEframe.size[0]+XYoff9[0],$
                  TEframe.size[1]+XYoff9[1],$
                  510,$
                  30],$
          button : { uname : 'te_button',$
                     list : ['Low and High Time-of-Flight Values that ' + $
                             'Bracket the Elastic Peak (microSeconds)'],$
                     value : 0}}

XYoff10 = [20,25]
TElowLabel = { size : [TEframe.size[0]+XYoff10[0],$
                        TEframe.size[1]+XYoff10[1]],$
                value : 'Low:',$
                uname : 'te_low_field_label',$
                sensitive : TEBase.button.value}
XYoff11 = [50,-5]
TElowText  = { size : [TElowLabel.size[0]+XYoff11[0],$
                        TElowlabel.size[1]+XYoff11[1],$
                        100,30],$
                uname : 'te_low_field',$
                sensitive : TEBase.button.value}

XYoff12 = [200,0]
TEhighLabel = { size : [TElowLabel.size[0]+XYoff12[0],$
                         TElowLabel.size[1]+XYoff12[1]],$
                 value : 'High:',$
                 uname : 'te_high_field_label',$
                 sensitive : TEBase.button.value}
XYoff13 = [50,-5]
TEhighText  = { size : [TEhighLabel.size[0]+XYoff13[0],$
                         TEhighlabel.size[1]+XYoff13[1],$
                         100,30],$
                 uname : 'te_high_field',$
                 sensitive : TEBase.button.value}

;******************************************************************************
;                                Build GUI
;******************************************************************************
tab3_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[1])

;//////////////////////
;Run McStas NeXus file/
;//////////////////////
base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = RMcNFBase.size[0],$
                   YOFFSET   = RMcNFBase.size[1],$
                   SCR_XSIZE = RMcNFBase.size[2],$
                   SCR_YSIZE = RMcNFBase.size[3])

group = CW_BGROUP(base,$
                  RMCNFBASE.button.list,$
                  UNAME      = RMcNFBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = RMcNFBase.button.value)
                  
;////////
;Verbose/
;////////
base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = VerboseBase.size[0],$
                   YOFFSET   = VerboseBase.size[1],$
                   SCR_XSIZE = VerboseBase.size[2],$
                   SCR_YSIZE = VerboseBase.size[3])

group = CW_BGROUP(base,$
                  VerboseBASE.button.list,$
                  UNAME      = VerboseBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 1,$
                  ROW        = 1,$
                  LABEL_LEFT = VerboseBase.button.value)
                  

;////////////////////////////////////////
;Alternate Background Subtraction Method/
;////////////////////////////////////////
base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = ABSMBase.size[0],$
                   YOFFSET   = ABSMBase.size[1],$
                   SCR_XSIZE = ABSMBase.size[2],$
                   SCR_YSIZE = ABSMBase.size[3])

group = CW_BGROUP(base,$
                  ABSMBASE.button.list,$
                  UNAME      = ABSMBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = ABSMBase.button.value)
                  
;/////////////////////////
;No Monitor Normalization/
;/////////////////////////
base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = NMNBase.size[0],$
                   YOFFSET   = NMNBase.size[1],$
                   SCR_XSIZE = NMNBase.size[2],$
                   SCR_YSIZE = NMNBase.size[3])

group = CW_BGROUP(base,$
                  NMNBASE.button.list,$
                  UNAME      = NMNBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = NMNBase.button.value)

;/////////////////////////////////
;No Monitor Efficiency Correction/
;/////////////////////////////////
base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = NMECBase.size[0],$
                   YOFFSET   = NMECBase.size[1],$
                   SCR_XSIZE = NMECBase.size[2],$
                   SCR_YSIZE = NMECBase.size[3])

group = CW_BGROUP(base,$
                  NMECBASE.button.list,$
                  UNAME      = NMECBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = NMECBase.button.value)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Normalization Integration Start and End Wavelength\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = NIWBase.size[0],$
                   YOFFSET   = NIWBase.size[1],$
                   SCR_XSIZE = NIWBase.size[2],$
                   SCR_YSIZE = NIWBase.size[3])

group = CW_BGROUP(base,$
                  NIWBase.button.list,$
                  UNAME      = NIWBase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET   = NIWlowLabel.size[0],$
                     YOFFSET   = NIWlowLabel.size[1],$
                     VALUE     = NIWlowLabel.value,$
                     UNAME     = NIWlowLabel.uname,$
                     SENSITIVE = NIWlowLabel.sensitive)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = NIWlowText.size[0],$
                   YOFFSET   = NIWlowText.size[1],$
                   SCR_XSIZE = NIWlowText.size[2],$
                   SCR_YSIZE = NIWlowText.size[3],$
                   UNAME     = NIWlowText.uname,$
                   SENSITIVE = NIWLowText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET   = NIWhighLabel.size[0],$
                     YOFFSET   = NIWhighLabel.size[1],$
                     VALUE     = NIWhighLabel.value,$
                     UNAME     = NIWhighLabel.uname,$
                     SENSITIVE = NIWhighLabel.sensitive)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = NIWhighText.size[0],$
                   YOFFSET   = NIWhighText.size[1],$
                   SCR_XSIZE = NIWhighText.size[2],$
                   SCR_YSIZE = NIWhighText.size[3],$
                   UNAME     = NIWhighText.uname,$
                   SENSITIVE = NIWhighText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab3_base,$
                      XOFFSET   = NIWframe.size[0],$
                      YOFFSET   = NIWframe.size[1],$
                      SCR_XSIZE = NIWframe.size[2],$
                      SCR_YSIZE = NIWframe.size[3],$
                      FRAME     = NIWframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Low and High values that bracket the elastic peak\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = TEBase.size[0],$
                   YOFFSET   = TEBase.size[1],$
                   SCR_XSIZE = TEBase.size[2],$
                   SCR_YSIZE = TEBase.size[3])

group = CW_BGROUP(base,$
                  TEBase.button.list,$
                  UNAME      = TEBase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET   = TElowLabel.size[0],$
                     YOFFSET   = TElowLabel.size[1],$
                     VALUE     = TElowLabel.value,$
                     UNAME     = TElowLabel.uname,$
                     SENSITIVE = TElowLabel.sensitive)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = TElowText.size[0],$
                   YOFFSET   = TElowText.size[1],$
                   SCR_XSIZE = TElowText.size[2],$
                   SCR_YSIZE = TElowText.size[3],$
                   UNAME     = TElowText.uname,$
                   SENSITIVE = TElowText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET   = TEhighLabel.size[0],$
                     YOFFSET   = TEhighLabel.size[1],$
                     VALUE     = TEhighLabel.value,$
                     UNAME     = TEhighLabel.uname,$
                     SENSITIVE = TEhighLabel.sensitive)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = TEhighText.size[0],$
                   YOFFSET   = TEhighText.size[1],$
                   SCR_XSIZE = TEhighText.size[2],$
                   SCR_YSIZE = TEhighText.size[3],$
                   UNAME     = TEhighText.uname,$
                   SENSITIVE = TEhighText.sensitive,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab3_base,$
                      XOFFSET   = TEframe.size[0],$
                      YOFFSET   = TEframe.size[1],$
                      SCR_XSIZE = TEframe.size[2],$
                      SCR_YSIZE = TEframe.size[3],$
                      FRAME     = TEframe.frame,$
                      VALUE     = '')

END
