PRO MakeGuiReduceInputTab6, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;///////////////////////////////////////////////////
;Time Zero Slope Parameter (Angstroms/microseconds)/
;///////////////////////////////////////////////////
yoff = 35
TZSPframe = { size : [5,yoff,730,50],$
                frame : 4}
XYoff1 = [10,-14]
TZSPbase = { size : [TZSPframe.size[0]+XYoff1[0],$
                     TZSPframe.size[1]+XYoff1[1],$
                     330,$
                     30],$
             button : { uname : 'tzsp_button',$
                        list : ['Time Zero Slope Parameter (Angstroms/microSeconds)'],$
                        value : 0}}

XYoff2 = [10,25]
TZSPvalueLabel = { size : [TZSPframe.size[0]+XYoff2[0],$
                           TZSPframe.size[1]+XYoff2[1]],$
                   value : 'Value:',$
                   uname : 'tzsp_value_text_label',$
                   sensitive : TZSPbase.button.value}
XYoff3 = [50,-5]
TZSPvalueText  = { size : [TZSPvalueLabel.size[0]+XYoff3[0],$
                           TZSPvaluelabel.size[1]+XYoff3[1],$
                           100,30],$
                   uname : 'tzsp_value_text',$
                   sensitive : TZSPbase.button.value}

XYoff4 = [200,0]
TZSPerrorLabel = { size : [TZSPvalueLabel.size[0]+XYoff4[0],$
                           TZSPvalueLabel.size[1]+XYoff4[1]],$
                   value : 'Error:',$
                   uname : 'tzsp_error_text_label',$
                   sensitive : TZSPbase.button.value}
XYoff5 = [50,-5]
TZSPerrorText  = { size : [TZSPerrorLabel.size[0]+XYoff5[0],$
                           TZSPerrorlabel.size[1]+XYoff5[1],$
                           100,30],$
                   uname : 'tzsp_error_text',$
                   sensitive : TZSPbase.button.value}

;//////////////////////////////////////////
;Time Zero Offset Parameter (microseconds)/
;//////////////////////////////////////////
yoff = 100
TZOPframe = { size : [TZSPframe.size[0],$
                      TZSPframe.size[1]+yoff,$
                      TZSPframe.size[2:3]],$
              frame : TZSPframe.frame}
XYoff1 = [10,-14]
TZOPbase = { size : [TZOPframe.size[0]+XYoff1[0],$
                     TZOPframe.size[1]+XYoff1[1],$
                     260,$
                     30],$
             button : { uname : 'tzop_button',$
                        list : ['Time Zero Offset Parameter (Angstroms)'],$
                        value : 0}}

XYoff2 = [10,25]
TZOPvalueLabel = { size : [TZOPframe.size[0]+XYoff2[0],$
                           TZOPframe.size[1]+XYoff2[1]],$
                   value : 'Value:',$
                   uname : 'tzop_value_text_label',$
                   sensitive : TZOPbase.button.value}
XYoff3 = [50,-5]
TZOPvalueText  = { size : [TZOPvalueLabel.size[0]+XYoff3[0],$
                           TZOPvaluelabel.size[1]+XYoff3[1],$
                           100,30],$
                   uname : 'tzop_value_text',$
                   sensitive : TZOPbase.button.value}

XYoff4 = [200,0]
TZOPerrorLabel = { size : [TZOPvalueLabel.size[0]+XYoff4[0],$
                           TZOPvalueLabel.size[1]+XYoff4[1]],$
                   value : 'Error:',$
                   uname : 'tzop_error_text_label',$
                   sensitive : TZOPbase.button.value}
XYoff5 = [50,-5]
TZOPerrorText  = { size : [TZOPerrorLabel.size[0]+XYoff5[0],$
                           TZOPerrorlabel.size[1]+XYoff5[1],$
                           100,30],$
                   uname : 'tzop_error_text',$
                   sensitive : TZOPbase.button.value}

;////////////////////////////////
;Energy Histogram Axis (mcro-eV)/
;////////////////////////////////
EHAframe = { size : [TZOPframe.size[0],$
                     TZOPframe.size[1]+yoff,$
                     TZOPframe.size[2:3]],$
             frame : TZSPframe.frame}
XYoff1 = [10,-8]
EHAbase = { size : [EHAframe.size[0]+XYoff1[0],$
                    EHaframe.size[1]+XYoff1[1],$
                    205,$
                    25],$
            button : { uname : 'eha_button',$
                       list : [' Energy Histogram Axis (micro-eV)'],$
                       value : 1}}

XYoff2 = [10,25]
EHAminLabel = { size : [EHAframe.size[0]+XYoff2[0],$
                        EHAframe.size[1]+XYoff2[1]],$
                value : 'Min:',$
                uname : 'eha_min_text_label',$
                sensitive : EHAbase.button.value}
XYoff3 = [50,-5]
EHAminText  = { size : [EHAminLabel.size[0]+XYoff3[0],$
                        EHAminlabel.size[1]+XYoff3[1],$
                          100,30],$
                uname : 'eha_min_text',$
                sensitive : EHAbase.button.value}

XYoff4 = [200,0]
EHAmaxLabel = { size : [EHAminLabel.size[0]+XYoff4[0],$
                        EHAminLabel.size[1]+XYoff4[1]],$
                value : 'Max:',$
                uname : 'eha_max_text_label',$
                sensitive : EHAbase.button.value}
XYoff5 = [50,-5]
EHAmaxText  = { size : [EHAmaxLabel.size[0]+XYoff5[0],$
                        EHAmaxLabel.size[1]+XYoff5[1],$
                        100,30],$
                uname : 'eha_max_text',$
                sensitive : EHAbase.button.value}

XYoff4 = [200,0]
EHAbinLabel = { size : [EHAmaxLabel.size[0]+XYoff4[0],$
                        EHAmaxLabel.size[1]+XYoff4[1]],$
                value : '  Width:',$
                uname : 'eha_bin_text_label',$
                sensitive : EHAbase.button.value}
XYoff5 = [85,-5]
EHAbinText  = { size : [EHAbinLabel.size[0]+XYoff5[0],$
                        EHAbinLabel.size[1]+XYoff5[1],$
                        100,30],$
                uname : 'eha_bin_text',$
                sensitive : EHAbase.button.value}

;//////////////////////////////////////////////
;Momentum Transfer Histogram Axis (1/Angstroms)
;//////////////////////////////////////////////
MTHAframe = { size : [EHAframe.size[0],$
                      EHAframe.size[1]+yoff,$
                      EHAframe.size[2:3]],$
              frame : EHAframe.frame}
XYoff1 = [10,-8]
MTHAbase = { size : [MTHAframe.size[0]+XYoff1[0],$
                     MTHAframe.size[1]+XYoff1[1],$
                     290,$
                     25],$
             button : { uname : 'mtha_button',$
                       list : [' Momentum Transfer Histogram Axis (1/Angstroms)'],$
                       value : 1}}

XYoff2 = [10,25]
MTHAminLabel = { size : [MTHAframe.size[0]+XYoff2[0],$
                         MTHAframe.size[1]+XYoff2[1]],$
                 value : 'Min:',$
                 uname : 'mtha_min_text_label',$
                 sensitive : MTHAbase.button.value}
XYoff3 = [50,-5]
MTHAminText  = { size : [MTHAminLabel.size[0]+XYoff3[0],$
                         MTHAminlabel.size[1]+XYoff3[1],$
                         100,30],$
                 uname : 'mtha_min_text',$
                 sensitive : MTHAbase.button.value}

XYoff4 = [200,0]
MTHAmaxLabel = { size : [MTHAminLabel.size[0]+XYoff4[0],$
                         MTHAminLabel.size[1]+XYoff4[1]],$
                 value : 'Max:',$
                 uname : 'mtha_max_text_label',$
                 sensitive : MTHAbase.button.value}
XYoff5 = [50,-5]
MTHAmaxText  = { size : [MTHAmaxLabel.size[0]+XYoff5[0],$
                         MTHAmaxLabel.size[1]+XYoff5[1],$
                         100,30],$
                 uname : 'mtha_max_text',$
                 sensitive : MTHAbase.button.value}

XYoff4 = [200,0]
MTHAbinLabel = { size : [MTHAmaxLabel.size[0]+XYoff4[0],$
                         MTHAmaxLabel.size[1]+XYoff4[1]],$
                 value : '  Width:',$
                 uname : 'mtha_bin_text_label',$
                 sensitive : MTHAbase.button.value}
XYoff5 = [85,-5]
MTHAbinText  = { size : [MTHAbinLabel.size[0]+XYoff5[0],$
                         MTHAbinLabel.size[1]+XYoff5[1],$
                         100,30],$
                 uname : 'mtha_bin_text',$
                 sensitive : MTHAbase.button.value}

;///////////////////////////////////////////////
;Global Instrument Final Wavelength (Angstroms)/
;///////////////////////////////////////////////
GIFWframe = { size : [MTHAframe.size[0],$
                      MTHAframe.size[1]+yoff,$
                      MTHAframe.size[2:3]],$
              frame : MTHAframe.frame}
XYoff1 = [10,-14]
GIFWbase = { size : [GIFWframe.size[0]+XYoff1[0],$
                     GIFWframe.size[1]+XYoff1[1],$
                     308,$
                     30],$
             button : { uname : 'gifw_button',$
                        list : ['Global Instrument Final Wavelength (Angstroms)'],$
                        value : 0}}

XYoff2 = [10,25]
GIFWvalueLabel = { size : [GIFWframe.size[0]+XYoff2[0],$
                          GIFWframe.size[1]+XYoff2[1]],$
                   value : 'Value:',$
                   uname : 'gifw_value_text_label',$
                   sensitive : GIFWbase.button.value}
XYoff3 = [50,-5]
GIFWvalueText  = { size : [GIFWvalueLabel.size[0]+XYoff3[0],$
                          GIFWvaluelabel.size[1]+XYoff3[1],$
                          100,30],$
                   uname : 'gifw_value_text',$
                   sensitive : GIFWbase.button.value}

XYoff4 = [200,0]
GIFWerrorLabel = { size : [GIFWvalueLabel.size[0]+XYoff4[0],$
                          GIFWvalueLabel.size[1]+XYoff4[1]],$
                   value : 'Error:',$
                   uname : 'gifw_error_text_label',$
                   sensitive : GIFWbase.button.value}
XYoff5 = [50,-5]
GIFWerrorText  = { size : [GIFWerrorLabel.size[0]+XYoff5[0],$
                          GIFWerrorlabel.size[1]+XYoff5[1],$
                           100,30],$
                   uname : 'gifw_error_text',$
                   sensitive : GIFWbase.button.value}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
tab6_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[3])

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time Zero Slope Parameter (Angstroms/microseconds)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab6_base,$
                   XOFFSET   = TZSPbase.size[0],$
                   YOFFSET   = TZSPbase.size[1],$
                   SCR_XSIZE = TZSPbase.size[2],$
                   SCR_YSIZE = TZSPbase.size[3])

group = CW_BGROUP(base,$
                  TZSPbase.button.list,$
                  UNAME      = TZSPbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = TZSPvalueLabel.size[0],$
                     YOFFSET   = TZSPvalueLabel.size[1],$
                     VALUE     = TZSPvalueLabel.value,$
                     SENSITIVE = TZSPbase.button.value,$
                     UNAME     = TZSPvalueLabel.uname)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = TZSPvalueText.size[0],$
                   YOFFSET   = TZSPvalueText.size[1],$
                   SCR_XSIZE = TZSPvalueText.size[2],$
                   SCR_YSIZE = TZSPvalueText.size[3],$
                   UNAME     = TZSPvalueText.uname,$
                   SENSITIVE = TZSPbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = TZSPerrorLabel.size[0],$
                     YOFFSET   = TZSPerrorLabel.size[1],$
                     VALUE     = TZSPerrorLabel.value,$
                     UNAME     = TZSPerrorLabel.uname,$
                     SENSITIVE = TZSPbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = TZSPerrorText.size[0],$
                   YOFFSET   = TZSPerrorText.size[1],$
                   SCR_XSIZE = TZSPerrorText.size[2],$
                   SCR_YSIZE = TZSPerrorText.size[3],$
                   UNAME     = TZSPerrorText.uname,$
                   SENSITIVE = TZSPbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab6_base,$
                      XOFFSET   = TZSPframe.size[0],$
                      YOFFSET   = TZSPframe.size[1],$
                      SCR_XSIZE = TZSPframe.size[2],$
                      SCR_YSIZE = TZSPframe.size[3],$
                      FRAME     = TZSPframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time Zero Offset Parameter (Angstroms/microseconds)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab6_base,$
                   XOFFSET   = TZOPbase.size[0],$
                   YOFFSET   = TZOPbase.size[1],$
                   SCR_XSIZE = TZOPbase.size[2],$
                   SCR_YSIZE = TZOPbase.size[3])

group = CW_BGROUP(base,$
                  TZOPbase.button.list,$
                  UNAME      = TZOPbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = TZOPvalueLabel.size[0],$
                     YOFFSET   = TZOPvalueLabel.size[1],$
                     VALUE     = TZOPvalueLabel.value,$
                     UNAME     = TZOPvalueLabel.uname,$
                     SENSITIVE = TZOPbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = TZOPvalueText.size[0],$
                   YOFFSET   = TZOPvalueText.size[1],$
                   SCR_XSIZE = TZOPvalueText.size[2],$
                   SCR_YSIZE = TZOPvalueText.size[3],$
                   UNAME     = TZOPvalueText.uname,$
                   SENSITIVE = TZOPbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = TZOPerrorLabel.size[0],$
                     YOFFSET   = TZOPerrorLabel.size[1],$
                     VALUE     = TZOPerrorLabel.value,$
                     UNAME     = TZOPerrorLabel.uname,$
                     SENSITIVE = TZOPbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = TZOPerrorText.size[0],$
                   YOFFSET   = TZOPerrorText.size[1],$
                   SCR_XSIZE = TZOPerrorText.size[2],$
                   SCR_YSIZE = TZOPerrorText.size[3],$
                   UNAME     = TZOPerrorText.uname,$
                   SENSITIVE = TZOPbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab6_base,$
                      XOFFSET   = TZOPframe.size[0],$
                      YOFFSET   = TZOPframe.size[1],$
                      SCR_XSIZE = TZOPframe.size[2],$
                      SCR_YSIZE = TZOPframe.size[3],$
                      FRAME     = TZOPframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Energy Histogram Axis (micro-eV)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab6_base,$
                   XOFFSET   = EHAbase.size[0],$
                   YOFFSET   = EHAbase.size[1],$
                   SCR_XSIZE = EHAbase.size[2],$
                   SCR_YSIZE = EHAbase.size[3])

label = WIDGET_LABEL(base,$
                     VALUE = EHAbase.button.list[0],$
                     UNAME = EHAbase.button.uname)
                     
label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = EHAminLabel.size[0],$
                     YOFFSET   = EHAminLabel.size[1],$
                     VALUE     = EHAminLabel.value,$
                     UNAME     = EHAminLabel.uname,$
                     SENSITIVE = EHAbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = EHAminText.size[0],$
                   YOFFSET   = EHAminText.size[1],$
                   SCR_XSIZE = EHAminText.size[2],$
                   SCR_YSIZE = EHAminText.size[3],$
                   UNAME     = EHAminText.uname,$
                   SENSITIVE = EHAbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = EHAmaxLabel.size[0],$
                     YOFFSET   = EHAmaxLabel.size[1],$
                     VALUE     = EHAmaxLabel.value,$
                     UNAME     = EHAmaxLabel.uname,$
                     SENSITIVE = EHAbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = EHAmaxText.size[0],$
                   YOFFSET   = EHAmaxText.size[1],$
                   SCR_XSIZE = EHAmaxText.size[2],$
                   SCR_YSIZE = EHAmaxText.size[3],$
                   UNAME     = EHAmaxText.uname,$
                   SENSITIVE = EHAbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = EHAbinLabel.size[0],$
                     YOFFSET   = EHAbinLabel.size[1],$
                     VALUE     = EHAbinLabel.value,$
                     UNAME     = EHAbinLabel.uname,$
                     SENSITIVE = EHAbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = EHAbinText.size[0],$
                   YOFFSET   = EHAbinText.size[1],$
                   SCR_XSIZE = EHAbinText.size[2],$
                   SCR_YSIZE = EHAbinText.size[3],$
                   UNAME     = EHAbinText.uname,$
                   SENSITIVE = EHAbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab6_base,$
                      XOFFSET   = EHAframe.size[0],$
                      YOFFSET   = EHAframe.size[1],$
                      SCR_XSIZE = EHAframe.size[2],$
                      SCR_YSIZE = EHAframe.size[3],$
                      FRAME     = EHAframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Global Instrument Final Wavelength (Angstroms)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab6_base,$
                   XOFFSET   = GIFWbase.size[0],$
                   YOFFSET   = GIFWbase.size[1],$
                   SCR_XSIZE = GIFWbase.size[2],$
                   SCR_YSIZE = GIFWbase.size[3])

group = CW_BGROUP(base,$
                  GIFWbase.button.list,$
                  UNAME      = GIFWbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = GIFWvalueLabel.size[0],$
                     YOFFSET   = GIFWvalueLabel.size[1],$
                     VALUE     = GIFWvalueLabel.value,$
                     UNAME     = GIFWvalueLabel.uname,$
                     SENSITIVE = GIFWbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = GIFWvalueText.size[0],$
                   YOFFSET   = GIFWvalueText.size[1],$
                   SCR_XSIZE = GIFWvalueText.size[2],$
                   SCR_YSIZE = GIFWvalueText.size[3],$
                   UNAME     = GIFWvalueText.uname,$
                   SENSITIVE = GIFWbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = GIFWerrorLabel.size[0],$
                     YOFFSET   = GIFWerrorLabel.size[1],$
                     VALUE     = GIFWerrorLabel.value,$
                     UNAME     = GIFWerrorLabel.uname,$
                     SENSITIVE = GIFWbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = GIFWerrorText.size[0],$
                   YOFFSET   = GIFWerrorText.size[1],$
                   SCR_XSIZE = GIFWerrorText.size[2],$
                   SCR_YSIZE = GIFWerrorText.size[3],$
                   UNAME     = GIFWerrorText.uname,$
                   SENSITIVE = GIFWbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab6_base,$
                      XOFFSET   = GIFWframe.size[0],$
                      YOFFSET   = GIFWframe.size[1],$
                      SCR_XSIZE = GIFWframe.size[2],$
                      SCR_YSIZE = GIFWframe.size[3],$
                      FRAME     = GIFWframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Momentum Transfer Histogram Axis
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab6_base,$
                   XOFFSET   = MTHAbase.size[0],$
                   YOFFSET   = MTHAbase.size[1],$
                   SCR_XSIZE = MTHAbase.size[2],$
                   SCR_YSIZE = MTHAbase.size[3])

label = WIDGET_LABEL(base,$
                     VALUE = MTHAbase.button.list[0],$
                     UNAME = MTHAbase.button.uname)
                     
label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = MTHAminLabel.size[0],$
                     YOFFSET   = MTHAminLabel.size[1],$
                     VALUE     = MTHAminLabel.value,$
                     UNAME     = MTHAminLabel.uname,$
                     SENSITIVE = MTHAbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = MTHAminText.size[0],$
                   YOFFSET   = MTHAminText.size[1],$
                   SCR_XSIZE = MTHAminText.size[2],$
                   SCR_YSIZE = MTHAminText.size[3],$
                   UNAME     = MTHAminText.uname,$
                   SENSITIVE = MTHAbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = MTHAmaxLabel.size[0],$
                     YOFFSET   = MTHAmaxLabel.size[1],$
                     VALUE     = MTHAmaxLabel.value,$
                     UNAME     = MTHAmaxLabel.uname,$
                     SENSITIVE = MTHAbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = MTHAmaxText.size[0],$
                   YOFFSET   = MTHAmaxText.size[1],$
                   SCR_XSIZE = MTHAmaxText.size[2],$
                   SCR_YSIZE = MTHAmaxText.size[3],$
                   UNAME     = MTHAmaxText.uname,$
                   SENSITIVE = MTHAbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab6_base,$
                     XOFFSET   = MTHAbinLabel.size[0],$
                     YOFFSET   = MTHAbinLabel.size[1],$
                     VALUE     = MTHAbinLabel.value,$
                     UNAME     = MTHAbinLabel.uname,$
                     SENSITIVE = MTHAbase.button.value)

text = WIDGET_TEXT(tab6_base,$
                   XOFFSET   = MTHAbinText.size[0],$
                   YOFFSET   = MTHAbinText.size[1],$
                   SCR_XSIZE = MTHAbinText.size[2],$
                   SCR_YSIZE = MTHAbinText.size[3],$
                   UNAME     = MTHAbinText.uname,$
                   SENSITIVE = MTHAbase.button.value,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab6_base,$
                      XOFFSET   = MTHAframe.size[0],$
                      YOFFSET   = MTHAframe.size[1],$
                      SCR_XSIZE = MTHAframe.size[2],$
                      SCR_YSIZE = MTHAframe.size[3],$
                      FRAME     = MTHAframe.frame,$
                      VALUE     = '')
END
