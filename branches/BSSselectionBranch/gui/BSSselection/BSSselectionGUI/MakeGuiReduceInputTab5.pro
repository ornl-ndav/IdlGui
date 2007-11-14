Pro MakeGuiReduceInputTab5, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

yoff = 20
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
                         list : ['Constant to Scale the Background Spectra for Subtraction from the Sample Data Spectra'],$
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
yoff = 90
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
                         list : ['Constant to Scale the Background Spectra for Subtraction from the Normalization Data Spectra'],$
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

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
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


END
