PRO MakeGuiReduceInputTab4, ReduceInputTab, ReduceInputTabSettings

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
                        list : ['Time Zero Slope Parameter (Angstroms/microSeconds)']}}

XYoff2 = [10,25]
TZSPvalueLabel = { size : [TZSPframe.size[0]+XYoff2[0],$
                           TZSPframe.size[1]+XYoff2[1]],$
                      value : 'Value:'}
XYoff3 = [50,-5]
TZSPvalueText  = { size : [TZSPvalueLabel.size[0]+XYoff3[0],$
                           TZSPvaluelabel.size[1]+XYoff3[1],$
                           100,30],$
                   uname : 'tzsp_value_text'}

XYoff4 = [200,0]
TZSPerrorLabel = { size : [TZSPvalueLabel.size[0]+XYoff4[0],$
                           TZSPvalueLabel.size[1]+XYoff4[1]],$
                   value : 'Error:'}
XYoff5 = [50,-5]
TZSPerrorText  = { size : [TZSPerrorLabel.size[0]+XYoff5[0],$
                           TZSPerrorlabel.size[1]+XYoff5[1],$
                           100,30],$
                   uname : 'tzsp_error_text'}

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
                        list : ['Time Zero Offset Parameter (Angstroms)']}}

XYoff2 = [10,25]
TZOPvalueLabel = { size : [TZOPframe.size[0]+XYoff2[0],$
                           TZOPframe.size[1]+XYoff2[1]],$
                      value : 'Value:'}
XYoff3 = [50,-5]
TZOPvalueText  = { size : [TZOPvalueLabel.size[0]+XYoff3[0],$
                           TZOPvaluelabel.size[1]+XYoff3[1],$
                           100,30],$
                   uname : 'tzop_value_text'}

XYoff4 = [200,0]
TZOPerrorLabel = { size : [TZOPvalueLabel.size[0]+XYoff4[0],$
                           TZOPvalueLabel.size[1]+XYoff4[1]],$
                   value : 'Error:'}
XYoff5 = [50,-5]
TZOPerrorText  = { size : [TZOPerrorLabel.size[0]+XYoff5[0],$
                           TZOPerrorlabel.size[1]+XYoff5[1],$
                           100,30],$
                   uname : 'tzop_error_text'}

;////////////////////////////////
;Energy Histogram Axis (mcro-eV)/
;////////////////////////////////
EHAframe = { size : [TZOPframe.size[0],$
                      TZOPframe.size[1]+yoff,$
                     TZOPframe.size[2:3]],$
             frame : TZSPframe.frame}
XYoff1 = [10,-14]
EHAbase = { size : [EHAframe.size[0]+XYoff1[0],$
                    EHaframe.size[1]+XYoff1[1],$
                    225,$
                    30],$
            button : { uname : 'tzop_button',$
                       list : ['Energy Histogram Axis (micro-eV)']}}

XYoff2 = [10,25]
EHAminLabel = { size : [EHAframe.size[0]+XYoff2[0],$
                        EHAframe.size[1]+XYoff2[1]],$
                value : 'Min:'}
XYoff3 = [50,-5]
EHAminText  = { size : [EHAminLabel.size[0]+XYoff3[0],$
                        EHAminlabel.size[1]+XYoff3[1],$
                          100,30],$
                uname : 'eha_min_text'}

XYoff4 = [200,0]
EHAmaxLabel = { size : [EHAminLabel.size[0]+XYoff4[0],$
                        EHAminLabel.size[1]+XYoff4[1]],$
                value : 'Max:'}
XYoff5 = [50,-5]
EHAmaxText  = { size : [EHAmaxLabel.size[0]+XYoff5[0],$
                        EHAmaxLabel.size[1]+XYoff5[1],$
                        100,30],$
                uname : 'eha_max_text'}

XYoff4 = [200,0]
EHAbinLabel = { size : [EHAmaxLabel.size[0]+XYoff4[0],$
                        EHAmaxLabel.size[1]+XYoff4[1]],$
                value : 'Bin Width:'}
XYoff5 = [85,-5]
EHAbinText  = { size : [EHAbinLabel.size[0]+XYoff5[0],$
                        EHAbinLabel.size[1]+XYoff5[1],$
                        100,30],$
                uname : 'eha_bin_text'}
;///////////////////////////////////////////////
;Global Instrument Final Wavelength (Angstroms)/
;///////////////////////////////////////////////
GIFWframe = { size : [EHAframe.size[0],$
                      EHAframe.size[1]+yoff,$
                      EHAframe.size[2:3]],$
              frame : EHAframe.frame}
XYoff1 = [10,-14]
GIFWbase = { size : [GIFWframe.size[0]+XYoff1[0],$
                     GIFWframe.size[1]+XYoff1[1],$
                     308,$
                     30],$
             button : { uname : 'gifw_button',$
                        list : ['Global Instrument Final Wavelength (Angstroms)']}}

XYoff2 = [10,25]
GIFWvalueLabel = { size : [GIFWframe.size[0]+XYoff2[0],$
                          GIFWframe.size[1]+XYoff2[1]],$
                  value : 'Value:'}
XYoff3 = [50,-5]
GIFWvalueText  = { size : [GIFWvalueLabel.size[0]+XYoff3[0],$
                          GIFWvaluelabel.size[1]+XYoff3[1],$
                          100,30],$
                  uname : 'gifw_value_text'}

XYoff4 = [200,0]
GIFWerrorLabel = { size : [GIFWvalueLabel.size[0]+XYoff4[0],$
                          GIFWvalueLabel.size[1]+XYoff4[1]],$
                  value : 'Error:'}
XYoff5 = [50,-5]
GIFWerrorText  = { size : [GIFWerrorLabel.size[0]+XYoff5[0],$
                          GIFWerrorlabel.size[1]+XYoff5[1],$
                          100,30],$
                  uname : 'gifw_error_text'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
tab4_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[3])

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time Zero Slope Parameter (Angstroms/microseconds)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
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

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = TZSPvalueLabel.size[0],$
                     YOFFSET = TZSPvalueLabel.size[1],$
                     VALUE   = TZSPvalueLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TZSPvalueText.size[0],$
                   YOFFSET   = TZSPvalueText.size[1],$
                   SCR_XSIZE = TZSPvalueText.size[2],$
                   SCR_YSIZE = TZSPvalueText.size[3],$
                   UNAME     = TZSPvalueText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = TZSPerrorLabel.size[0],$
                     YOFFSET = TZSPerrorLabel.size[1],$
                     VALUE   = TZSPerrorLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TZSPerrorText.size[0],$
                   YOFFSET   = TZSPerrorText.size[1],$
                   SCR_XSIZE = TZSPerrorText.size[2],$
                   SCR_YSIZE = TZSPerrorText.size[3],$
                   UNAME     = TZSPerrorText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = TZSPframe.size[0],$
                      YOFFSET   = TZSPframe.size[1],$
                      SCR_XSIZE = TZSPframe.size[2],$
                      SCR_YSIZE = TZSPframe.size[3],$
                      FRAME     = TZSPframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time Zero Offset Parameter (Angstroms/microseconds)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
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

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = TZOPvalueLabel.size[0],$
                     YOFFSET = TZOPvalueLabel.size[1],$
                     VALUE   = TZOPvalueLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TZOPvalueText.size[0],$
                   YOFFSET   = TZOPvalueText.size[1],$
                   SCR_XSIZE = TZOPvalueText.size[2],$
                   SCR_YSIZE = TZOPvalueText.size[3],$
                   UNAME     = TZOPvalueText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = TZOPerrorLabel.size[0],$
                     YOFFSET = TZOPerrorLabel.size[1],$
                     VALUE   = TZOPerrorLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = TZOPerrorText.size[0],$
                   YOFFSET   = TZOPerrorText.size[1],$
                   SCR_XSIZE = TZOPerrorText.size[2],$
                   SCR_YSIZE = TZOPerrorText.size[3],$
                   UNAME     = TZOPerrorText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = TZOPframe.size[0],$
                      YOFFSET   = TZOPframe.size[1],$
                      SCR_XSIZE = TZOPframe.size[2],$
                      SCR_YSIZE = TZOPframe.size[3],$
                      FRAME     = TZOPframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Energy Histogram Axis (micro-eV)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
                   XOFFSET   = EHAbase.size[0],$
                   YOFFSET   = EHAbase.size[1],$
                   SCR_XSIZE = EHAbase.size[2],$
                   SCR_YSIZE = EHAbase.size[3])

group = CW_BGROUP(base,$
                  EHAbase.button.list,$
                  UNAME      = EHAbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = EHAminLabel.size[0],$
                     YOFFSET = EHAminLabel.size[1],$
                     VALUE   = EHAminLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = EHAminText.size[0],$
                   YOFFSET   = EHAminText.size[1],$
                   SCR_XSIZE = EHAminText.size[2],$
                   SCR_YSIZE = EHAminText.size[3],$
                   UNAME     = EHAminText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = EHAmaxLabel.size[0],$
                     YOFFSET = EHAmaxLabel.size[1],$
                     VALUE   = EHAmaxLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = EHAmaxText.size[0],$
                   YOFFSET   = EHAmaxText.size[1],$
                   SCR_XSIZE = EHAmaxText.size[2],$
                   SCR_YSIZE = EHAmaxText.size[3],$
                   UNAME     = EHAmaxText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = EHAbinLabel.size[0],$
                     YOFFSET = EHAbinLabel.size[1],$
                     VALUE   = EHAbinLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = EHAbinText.size[0],$
                   YOFFSET   = EHAbinText.size[1],$
                   SCR_XSIZE = EHAbinText.size[2],$
                   SCR_YSIZE = EHAbinText.size[3],$
                   UNAME     = EHAbinText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = EHAframe.size[0],$
                      YOFFSET   = EHAframe.size[1],$
                      SCR_XSIZE = EHAframe.size[2],$
                      SCR_YSIZE = EHAframe.size[3],$
                      FRAME     = EHAframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Global Instrument Final Wavelength (Angstroms)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab4_base,$
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

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = GIFWvalueLabel.size[0],$
                     YOFFSET = GIFWvalueLabel.size[1],$
                     VALUE   = GIFWvalueLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = GIFWvalueText.size[0],$
                   YOFFSET   = GIFWvalueText.size[1],$
                   SCR_XSIZE = GIFWvalueText.size[2],$
                   SCR_YSIZE = GIFWvalueText.size[3],$
                   UNAME     = GIFWvalueText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab4_base,$
                     XOFFSET = GIFWerrorLabel.size[0],$
                     YOFFSET = GIFWerrorLabel.size[1],$
                     VALUE   = GIFWerrorLabel.value)

text = WIDGET_TEXT(tab4_base,$
                   XOFFSET   = GIFWerrorText.size[0],$
                   YOFFSET   = GIFWerrorText.size[1],$
                   SCR_XSIZE = GIFWerrorText.size[2],$
                   SCR_YSIZE = GIFWerrorText.size[3],$
                   UNAME     = GIFWerrorText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab4_base,$
                      XOFFSET   = GIFWframe.size[0],$
                      YOFFSET   = GIFWframe.size[1],$
                      SCR_XSIZE = GIFWframe.size[2],$
                      SCR_YSIZE = GIFWframe.size[3],$
                      FRAME     = GIFWframe.frame,$
                      VALUE     = '')





END
