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

Pro MakeGuiReduceInputTab6, ReduceInputTab, ReduceInputTabSettings

  ;******************************************************************************
  ;                           Define size arrays
  ;******************************************************************************

  yoff = 10
  ;//////////////////////////////////////////////////////////////////
  ;Constant to Scale the Background Spectra for Subtraction from the/
  ;sample data spectra                                              /
  ;//////////////////////////////////////////////////////////////////
  CSBSSframe = { size : [5, yoff,730,55],$
    frame : 4}
    
  XYoff = [10,-14]
  CSBSSbase = { size : [CSBSSframe.size[0]+XYoff[0],$
    CSBSSframe.size[1]+XYoff[1],$
    540,$
    30],$
    button : { uname : 'csbss_button',$
    list : ['Constant to Scale the Background ' + $
    'Spectra for Subtraction from the ' + $
    'Sample Data Spectra'],$
    value : 0}}
    
    
  XYoff10 = [15,25]
  CSBSSvalueLabel = { size : [CSBSSframe.size[0]+XYoff10[0],$
    CSBSSframe.size[1]+XYoff10[1]],$
    value : 'Value:',$
    uname : 'csbss_value_text_label',$
    sensitive : CSBSSBase.button.value}
  XYoff11 = [50,-5]
  CSBSSvalueText  = { size : [CSBSSvalueLabel.size[0]+XYoff11[0],$
    CSBSSvaluelabel.size[1]+XYoff11[1],$
    100,30],$
    uname : 'csbss_value_text',$
    sensitive : CSBSSBase.button.value}
    
  XYoff12 = [200,0]
  CSBSSerrorLabel = { size : [CSBSSvalueLabel.size[0]+XYoff12[0],$
    CSBSSvalueLabel.size[1]+XYoff12[1]],$
    value : 'Error:',$
    uname : 'csbss_error_text_label',$
    sensitive : CSBSSBase.button.value}
  XYoff13 = [50,-5]
  CSBSSerrorText  = { size : [CSBSSerrorLabel.size[0]+XYoff13[0],$
    CSBSSerrorlabel.size[1]+XYoff13[1],$
    100,30],$
    uname : 'csbss_error_text',$
    sensitive : CSBSSBase.button.value}
    
  ;//////////////////////////////////////////////////////////////////
  ;Constant to Scale the Background Spectra for Subtraction from the/
  ;normalization data spectra                                       /
  ;//////////////////////////////////////////////////////////////////
  yoff = 75
  CSNframe = { size : [CSBSSframe.size[0], $
    CSBSSframe.size[1]+yoff,$
    CSBSSframe.size[2:3]],$
    frame : CSBSSframe.frame}
    
  XYoff = [10,-14]
  CSNbase = { size : [CSNframe.size[0]+XYoff[0],$
    CSNframe.size[1]+XYoff[1],$
    585,$
    30],$
    button : { uname : 'csn_button',$
    list : ['Constant to Scale the Background' + $
    ' Spectra for Subtraction from the' + $
    ' Normalization Data Spectra'],$
    value : 0}}
    
  XYoff10 = [15,25]
  CSNvalueLabel = { size : [CSNframe.size[0]+XYoff10[0],$
    CSNframe.size[1]+XYoff10[1]],$
    value : 'Value:',$
    uname : 'csn_value_text_label',$
    sensitive : CSNBase.button.value}
  XYoff11 = [50,-5]
  CSNvalueText  = { size : [CSNvalueLabel.size[0]+XYoff11[0],$
    CSNvaluelabel.size[1]+XYoff11[1],$
    100,30],$
    uname : 'csn_value_text',$
    sensitive : CSNBase.button.value}
    
  XYoff12 = [200,0]
  CSNerrorLabel = { size : [CSNvalueLabel.size[0]+XYoff12[0],$
    CSNvalueLabel.size[1]+XYoff12[1]],$
    value : 'Error:',$
    uname : 'csn_error_text_label',$
    sensitive : CSNBase.button.value}
  XYoff13 = [50,-5]
  CSNerrorText  = { size : [CSNerrorLabel.size[0]+XYoff13[0],$
    CSNerrorlabel.size[1]+XYoff13[1],$
    100,30],$
    uname : 'csn_error_text',$
    sensitive : CSNBase.button.value}
    
  ;//////////////////////////////////////////////////////////////////
  ;Constant to Scale the Background Spectra for Subtraction from the/
  ;sample data associated empty container spectra                   /
  ;//////////////////////////////////////////////////////////////////
  yoff = 75
  BCSframe = { size : [CSNframe.size[0], $
    CSNframe.size[1]+yoff,$
    CSNframe.size[2:3]],$
    frame : CSNframe.frame}
    
  XYoff = [10,-14]
  BCSbase = { size : [BCSframe.size[0]+XYoff[0],$
    BCSframe.size[1]+XYoff[1],$
    710,$
    30],$
    button : { uname : 'bcs_button',$
    list : ['Constant to Scale the Background ' + $
    'Spectra for Subtraction from the' + $
    ' Sample Data Associated Empty' + $
    ' Container Spectra'],$
    value : 0}}
    
  XYoff10 = [15,25]
  BCSvalueLabel = { size : [BCSframe.size[0]+XYoff10[0],$
    BCSframe.size[1]+XYoff10[1]],$
    value : 'Value:',$
    uname : 'bcs_value_text_label',$
    sensitive : BCSBase.button.value}
  XYoff11 = [50,-5]
  BCSvalueText  = { size : [BCSvalueLabel.size[0]+XYoff11[0],$
    BCSvaluelabel.size[1]+XYoff11[1],$
    100,30],$
    uname : 'bcs_value_text',$
    sensitive : BCSBase.button.value}
    
  XYoff12 = [200,0]
  BCSerrorLabel = { size : [BCSvalueLabel.size[0]+XYoff12[0],$
    BCSvalueLabel.size[1]+XYoff12[1]],$
    value : 'Error:',$
    uname : 'bcs_error_text_label',$
    sensitive : BCSBase.button.value}
  XYoff13 = [50,-5]
  BCSerrorText  = { size : [BCSerrorLabel.size[0]+XYoff13[0],$
    BCSerrorlabel.size[1]+XYoff13[1],$
    100,30],$
    uname : 'bcs_error_text',$
    sensitive : BCSBase.button.value}
    
  ;//////////////////////////////////////////////////////////////////
  ;Constant to Scale the Background Spectra for Subtraction from the/
  ;normalization data associated empty container spectra            /
  ;//////////////////////////////////////////////////////////////////
  yoff = 75
  BCNframe = { size : [BCSframe.size[0], $
    BCSframe.size[1]+yoff,$
    BCSframe.size[2:3]],$
    frame : BCSframe.frame}
    
  XYoff = [10,-14]
  BCNbase = { size : [BCNframe.size[0]+XYoff[0],$
    BCNframe.size[1]+XYoff[1],$
    715,$
    30],$
    button : { uname : 'bcn_button',$
    list : ['Constant to Scale the Back. ' + $
    'Spectra for Subtraction from the' + $
    ' Normalization Data Associated Empty' + $
    ' Container Spectra'],$
    value : 0}}
    
  XYoff10 = [15,25]
  BCNvalueLabel = { size : [BCNframe.size[0]+XYoff10[0],$
    BCNframe.size[1]+XYoff10[1]],$
    value : 'Value:',$
    uname : 'bcn_value_text_label',$
    sensitive : BCNBase.button.value}
  XYoff11 = [50,-5]
  BCNvalueText  = { size : [BCNvalueLabel.size[0]+XYoff11[0],$
    BCNvaluelabel.size[1]+XYoff11[1],$
    100,30],$
    uname : 'bcn_value_text',$
    sensitive : BCNBase.button.value}
    
  XYoff12 = [200,0]
  BCNerrorLabel = { size : [BCNvalueLabel.size[0]+XYoff12[0],$
    BCNvalueLabel.size[1]+XYoff12[1]],$
    value : 'Error:',$
    uname : 'bcn_error_text_label',$
    sensitive : BCNBase.button.value}
  XYoff13 = [50,-5]
  BCNerrorText  = { size : [BCNerrorLabel.size[0]+XYoff13[0],$
    BCNerrorlabel.size[1]+XYoff13[1],$
    100,30],$
    uname : 'bcn_error_text',$
    sensitive : BCNBase.button.value}
    
  ;///////////////////////////////////////////////////////////////////
  ;Constant to Scale the Empty Container Spectra for subtraction from/
  ;the sample data                                                   /
  ;///////////////////////////////////////////////////////////////////
  yoff = 75
  CSframe = { size : [BCNframe.size[0], $
    BCNframe.size[1]+yoff,$
    BCNframe.size[2:3]],$
    frame : BCNframe.frame}
    
  XYoff = [10,-14]
  CSbase = { size : [CSframe.size[0]+XYoff[0],$
    CSframe.size[1]+XYoff[1],$
    525,$
    30],$
    button : { uname : 'cs_button',$
    list : ['Constant to Scale the Empty Container' + $
    ' Spectra for Subtraction from the' + $
    ' Sample Data'],$
    value : 0}}
    
  XYoff10 = [15,25]
  CSvalueLabel = { size : [CSframe.size[0]+XYoff10[0],$
    CSframe.size[1]+XYoff10[1]],$
    value : 'Value:',$
    uname : 'cs_value_text_label',$
    sensitive : CSBase.button.value}
  XYoff11 = [50,-5]
  CSvalueText  = { size : [CSvalueLabel.size[0]+XYoff11[0],$
    CSvaluelabel.size[1]+XYoff11[1],$
    100,30],$
    uname : 'cs_value_text',$
    sensitive : CSBase.button.value}
    
  XYoff12 = [200,0]
  CSerrorLabel = { size : [CSvalueLabel.size[0]+XYoff12[0],$
    CSvalueLabel.size[1]+XYoff12[1]],$
    value : 'Error:',$
    uname : 'cs_error_text_label',$
    sensitive : CSBase.button.value}
  XYoff13 = [50,-5]
  CSerrorText  = { size : [CSerrorLabel.size[0]+XYoff13[0],$
    CSerrorlabel.size[1]+XYoff13[1],$
    100,30],$
    uname : 'cs_error_text',$
    sensitive : CSBase.button.value}
    
  ;///////////////////////////////////////////////////////////////////
  ;Constant to Scale the Empty Container Spectra for subtraction from/
  ;the normalization data                                            /
  ;///////////////////////////////////////////////////////////////////
  yoff = 75
  CNframe = { size : [CSframe.size[0], $
    CSframe.size[1]+yoff,$
    CSframe.size[2:3]],$
    frame : CSframe.frame}
    
  XYoff = [10,-14]
  CNbase = { size : [CNframe.size[0]+XYoff[0],$
    CNframe.size[1]+XYoff[1],$
    565,$
    30],$
    button : { uname : 'cn_button',$
    list : ['Constant to Scale the Empty Container' + $
    ' Spectra for Subtraction from the' + $
    ' Normalization Data'],$
    value : 0}}
    
  XYoff10 = [15,25]
  CNvalueLabel = { size : [CNframe.size[0]+XYoff10[0],$
    CNframe.size[1]+XYoff10[1]],$
    value : 'Value:',$
    uname : 'cn_value_text_label',$
    sensitive : CNBase.button.value}
  XYoff11 = [50,-5]
  CNvalueText  = { size : [CNvalueLabel.size[0]+XYoff11[0],$
    CNvaluelabel.size[1]+XYoff11[1],$
    100,30],$
    uname : 'cn_value_text',$
    sensitive : CNBase.button.value}
    
  XYoff12 = [200,0]
  CNerrorLabel = { size : [CNvalueLabel.size[0]+XYoff12[0],$
    CNvalueLabel.size[1]+XYoff12[1]],$
    value : 'Error:',$
    uname : 'cn_error_text_label',$
    sensitive : CNBase.button.value}
  XYoff13 = [50,-5]
  CNerrorText  = { size : [CNerrorLabel.size[0]+XYoff13[0],$
    CNerrorlabel.size[1]+XYoff13[1],$
    100,30],$
    uname : 'cn_error_text',$
    sensitive : CNBase.button.value}
      
  ;**************************************************************************
  ;                                Build GUI
  ;**************************************************************************
  tab5_base = WIDGET_BASE(ReduceInputTab,$
    XOFFSET   = ReduceInputTabSettings.size[0],$
    YOFFSET   = ReduceInputTabSettings.size[1],$
    SCR_XSIZE = ReduceInputTabSettings.size[2],$
    SCR_YSIZE = ReduceInputTabSettings.size[3],$
    TITLE     = ReduceInputTabSettings.title[6])
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Constant to Scale the Background Spectra for Subtraction from the\
  ;sample data spectra                                              \
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  base = WIDGET_BASE(tab5_base,$
    XOFFSET   = CSBSSbase.size[0],$
    YOFFSET   = CSBSSbase.size[1],$
    SCR_XSIZE = CSBSSbase.size[2],$
    SCR_YSIZE = CSBSSbase.size[3])
    
  group = CW_BGROUP(base,$
    CSBSSbase.button.list,$
    UNAME      = CSBSSbase.button.uname,$
    SET_VALUE  = CSBSSbase.button.value,$
    ROW        = 1,$
    /NONEXCLUSIVE)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSBSSvalueLabel.size[0],$
    YOFFSET   = CSBSSvalueLabel.size[1],$
    VALUE     = CSBSSvalueLabel.value,$
    UNAME     = CSBSSvalueLabel.uname,$
    SENSITIVE = CSBSSvalueLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CSBSSvalueText.size[0],$
    YOFFSET   = CSBSSvalueText.size[1],$
    SCR_XSIZE = CSBSSvalueText.size[2],$
    SCR_YSIZE = CSBSSvalueText.size[3],$
    UNAME     = CSBSSvalueText.uname,$
    SENSITIVE = CSBSSvalueText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSBSSerrorLabel.size[0],$
    YOFFSET   = CSBSSerrorLabel.size[1],$
    VALUE     = CSBSSerrorLabel.value,$
    UNAME     = CSBSSerrorLabel.uname,$
    SENSITIVE = CSBSSerrorLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CSBSSerrorText.size[0],$
    YOFFSET   = CSBSSerrorText.size[1],$
    SCR_XSIZE = CSBSSerrorText.size[2],$
    SCR_YSIZE = CSBSSerrorText.size[3],$
    UNAME     = CSBSSerrorText.uname,$
    SENSITIVE = CSBSSerrorText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  frame  = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSBSSframe.size[0],$
    YOFFSET   = CSBSSframe.size[1],$
    SCR_XSIZE = CSBSSframe.size[2],$
    SCR_YSIZE = CSBSSframe.size[3],$
    FRAME     = CSBSSframe.frame,$
    VALUE     = '')
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Constant to Scale the Background Spectra for Subtraction from the\
  ;Normalization data spectra                                       \
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  base = WIDGET_BASE(tab5_base,$
    XOFFSET   = CSNbase.size[0],$
    YOFFSET   = CSNbase.size[1],$
    SCR_XSIZE = CSNbase.size[2],$
    SCR_YSIZE = CSNbase.size[3])
    
  group = CW_BGROUP(base,$
    CSNbase.button.list,$
    UNAME      = CSNbase.button.uname,$
    SET_VALUE  = CSNbase.button.value,$
    ROW        = 1,$
    /NONEXCLUSIVE)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSNvalueLabel.size[0],$
    YOFFSET   = CSNvalueLabel.size[1],$
    VALUE     = CSNvalueLabel.value,$
    UNAME     = CSNvalueLabel.uname,$
    SENSITIVE = CSNvalueLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CSNvalueText.size[0],$
    YOFFSET   = CSNvalueText.size[1],$
    SCR_XSIZE = CSNvalueText.size[2],$
    SCR_YSIZE = CSNvalueText.size[3],$
    UNAME     = CSNvalueText.uname,$
    SENSITIVE = CSNvalueText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSNerrorLabel.size[0],$
    YOFFSET   = CSNerrorLabel.size[1],$
    VALUE     = CSNerrorLabel.value,$
    UNAME     = CSNerrorLabel.uname,$
    SENSITIVE = CSNerrorLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CSNerrorText.size[0],$
    YOFFSET   = CSNerrorText.size[1],$
    SCR_XSIZE = CSNerrorText.size[2],$
    SCR_YSIZE = CSNerrorText.size[3],$
    UNAME     = CSNerrorText.uname,$
    SENSITIVE = CSNerrorText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  frame  = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSNframe.size[0],$
    YOFFSET   = CSNframe.size[1],$
    SCR_XSIZE = CSNframe.size[2],$
    SCR_YSIZE = CSNframe.size[3],$
    FRAME     = CSNframe.frame,$
    VALUE     = '')
    
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Constant to Scale the Background Spectra for Subtraction from the\
  ;sample data associated empty container spectra                   \
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  base = WIDGET_BASE(tab5_base,$
    XOFFSET   = BCSbase.size[0],$
    YOFFSET   = BCSbase.size[1],$
    SCR_XSIZE = BCSbase.size[2],$
    SCR_YSIZE = BCSbase.size[3])
    
  group = CW_BGROUP(base,$
    BCSbase.button.list,$
    UNAME      = BCSbase.button.uname,$
    SET_VALUE  = BCSbase.button.value,$
    ROW        = 1,$
    /NONEXCLUSIVE)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = BCSvalueLabel.size[0],$
    YOFFSET   = BCSvalueLabel.size[1],$
    VALUE     = BCSvalueLabel.value,$
    UNAME     = BCSvalueLabel.uname,$
    SENSITIVE = BCSvalueLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = BCSvalueText.size[0],$
    YOFFSET   = BCSvalueText.size[1],$
    SCR_XSIZE = BCSvalueText.size[2],$
    SCR_YSIZE = BCSvalueText.size[3],$
    UNAME     = BCSvalueText.uname,$
    SENSITIVE = BCSvalueText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = BCSerrorLabel.size[0],$
    YOFFSET   = BCSerrorLabel.size[1],$
    VALUE     = BCSerrorLabel.value,$
    UNAME     = BCSerrorLabel.uname,$
    SENSITIVE = BCSerrorLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = BCSerrorText.size[0],$
    YOFFSET   = BCSerrorText.size[1],$
    SCR_XSIZE = BCSerrorText.size[2],$
    SCR_YSIZE = BCSerrorText.size[3],$
    UNAME     = BCSerrorText.uname,$
    SENSITIVE = BCSerrorText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  frame  = WIDGET_LABEL(tab5_base,$
    XOFFSET   = BCSframe.size[0],$
    YOFFSET   = BCSframe.size[1],$
    SCR_XSIZE = BCSframe.size[2],$
    SCR_YSIZE = BCSframe.size[3],$
    FRAME     = BCSframe.frame,$
    VALUE     = '')
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Constant to Scale the Background Spectra for Subtraction from the\
  ;normalization data associated empty container spectra            \
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  base = WIDGET_BASE(tab5_base,$
    XOFFSET   = BCNbase.size[0],$
    YOFFSET   = BCNbase.size[1],$
    SCR_XSIZE = BCNbase.size[2],$
    SCR_YSIZE = BCNbase.size[3])
    
  group = CW_BGROUP(base,$
    BCNbase.button.list,$
    UNAME      = BCNbase.button.uname,$
    SET_VALUE  = BCNbase.button.value,$
    ROW        = 1,$
    /NONEXCLUSIVE)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = BCNvalueLabel.size[0],$
    YOFFSET   = BCNvalueLabel.size[1],$
    VALUE     = BCNvalueLabel.value,$
    UNAME     = BCNvalueLabel.uname,$
    SENSITIVE = BCNvalueLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = BCNvalueText.size[0],$
    YOFFSET   = BCNvalueText.size[1],$
    SCR_XSIZE = BCNvalueText.size[2],$
    SCR_YSIZE = BCNvalueText.size[3],$
    UNAME     = BCNvalueText.uname,$
    SENSITIVE = BCNvalueText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = BCNerrorLabel.size[0],$
    YOFFSET   = BCNerrorLabel.size[1],$
    VALUE     = BCNerrorLabel.value,$
    UNAME     = BCNerrorLabel.uname,$
    SENSITIVE = BCNerrorLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = BCNerrorText.size[0],$
    YOFFSET   = BCNerrorText.size[1],$
    SCR_XSIZE = BCNerrorText.size[2],$
    SCR_YSIZE = BCNerrorText.size[3],$
    UNAME     = BCNerrorText.uname,$
    SENSITIVE = BCNerrorText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  frame  = WIDGET_LABEL(tab5_base,$
    XOFFSET   = BCNframe.size[0],$
    YOFFSET   = BCNframe.size[1],$
    SCR_XSIZE = BCNframe.size[2],$
    SCR_YSIZE = BCNframe.size[3],$
    FRAME     = BCNframe.frame,$
    VALUE     = '')
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Constant to Scale the Empty Container Spectra for subtraction from\
  ;the sample data                                                   \
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  base = WIDGET_BASE(tab5_base,$
    XOFFSET   = CSbase.size[0],$
    YOFFSET   = CSbase.size[1],$
    SCR_XSIZE = CSbase.size[2],$
    SCR_YSIZE = CSbase.size[3])
    
  group = CW_BGROUP(base,$
    CSbase.button.list,$
    UNAME      = CSbase.button.uname,$
    SET_VALUE  = CSbase.button.value,$
    ROW        = 1,$
    /NONEXCLUSIVE)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSvalueLabel.size[0],$
    YOFFSET   = CSvalueLabel.size[1],$
    VALUE     = CSvalueLabel.value,$
    UNAME     = CSvalueLabel.uname,$
    SENSITIVE = CSvalueLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CSvalueText.size[0],$
    YOFFSET   = CSvalueText.size[1],$
    SCR_XSIZE = CSvalueText.size[2],$
    SCR_YSIZE = CSvalueText.size[3],$
    UNAME     = CSvalueText.uname,$
    SENSITIVE = CSvalueText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSerrorLabel.size[0],$
    YOFFSET   = CSerrorLabel.size[1],$
    VALUE     = CSerrorLabel.value,$
    UNAME     = CSerrorLabel.uname,$
    SENSITIVE = CSerrorLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CSerrorText.size[0],$
    YOFFSET   = CSerrorText.size[1],$
    SCR_XSIZE = CSerrorText.size[2],$
    SCR_YSIZE = CSerrorText.size[3],$
    UNAME     = CSerrorText.uname,$
    SENSITIVE = CSerrorText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  frame  = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CSframe.size[0],$
    YOFFSET   = CSframe.size[1],$
    SCR_XSIZE = CSframe.size[2],$
    SCR_YSIZE = CSframe.size[3],$
    FRAME     = CSframe.frame,$
    VALUE     = '')
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Constant to Scale the Empty Container Spectra for subtraction from\
  ;the normalization data                                            \
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  base = WIDGET_BASE(tab5_base,$
    XOFFSET   = CNbase.size[0],$
    YOFFSET   = CNbase.size[1],$
    SCR_XSIZE = CNbase.size[2],$
    SCR_YSIZE = CNbase.size[3])
    
  group = CW_BGROUP(base,$
    CNbase.button.list,$
    UNAME      = CNbase.button.uname,$
    SET_VALUE  = CNbase.button.value,$
    ROW        = 1,$
    /NONEXCLUSIVE)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CNvalueLabel.size[0],$
    YOFFSET   = CNvalueLabel.size[1],$
    VALUE     = CNvalueLabel.value,$
    UNAME     = CNvalueLabel.uname,$
    SENSITIVE = CNvalueLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CNvalueText.size[0],$
    YOFFSET   = CNvalueText.size[1],$
    SCR_XSIZE = CNvalueText.size[2],$
    SCR_YSIZE = CNvalueText.size[3],$
    UNAME     = CNvalueText.uname,$
    SENSITIVE = CNvalueText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  label = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CNerrorLabel.size[0],$
    YOFFSET   = CNerrorLabel.size[1],$
    VALUE     = CNerrorLabel.value,$
    UNAME     = CNerrorLabel.uname,$
    SENSITIVE = CNerrorLabel.sensitive)
    
  text = WIDGET_TEXT(tab5_base,$
    XOFFSET   = CNerrorText.size[0],$
    YOFFSET   = CNerrorText.size[1],$
    SCR_XSIZE = CNerrorText.size[2],$
    SCR_YSIZE = CNerrorText.size[3],$
    UNAME     = CNerrorText.uname,$
    SENSITIVE = CNerrorText.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  frame  = WIDGET_LABEL(tab5_base,$
    XOFFSET   = CNframe.size[0],$
    YOFFSET   = CNframe.size[1],$
    SCR_XSIZE = CNframe.size[2],$
    SCR_YSIZE = CNframe.size[3],$
    FRAME     = CNframe.frame,$
    VALUE     = '')
        
END
