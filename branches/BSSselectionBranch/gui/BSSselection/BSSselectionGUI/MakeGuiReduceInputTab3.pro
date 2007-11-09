PRO MakeGuiReduceInputTab3, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;////////////////////////////////////////////////////////
;Time-Independent Background TOF channels (microSeconds)/
;////////////////////////////////////////////////////////
TIBtofFrame = { size : [5,13,730,50],$
                frame : 1}
XYoff = [10,-8]
TIBtofLabel = { size : [TIBtofFrame.size[0]+XYoff[0],$
                        TIBtofFrame.size[1]+XYoff[1]],$
                value : 'Time-Independent Background Time-of-Flight Channels (microSeconds)'}
XYoff1 = [10,28]
TIBtofLabel1 = { size : [TIBtofFrame.size[0]+XYoff1[0],$
                         TIBtofFrame.size[0]+XYoff1[1]],$
                value : 'TOF channels    #1'}
XYoff2 = [115,-6]
TIBtofText1 = { size : [TIBtofLabel1.size[0]+XYoff2[0],$
                        TIBtofLabel1.size[1]+XYoff2[1],$
                        70,30],$
                uname : 'tibtof_channel1_text'}
                
XYoff3 = [243,1]
TIBtofLabel2 = { size : [TIBtofLabel1.size[0]+XYoff3[0],$
                         TIBtofLabel1.size[1]],$
                 value : '#2'}
XYoff4 = [20,0]
TIBtofText2 = { size : [TIBtofLabel2.size[0]+XYoff4[0],$
                        TIBtofText1.size[1],$
                        70,30],$
                uname : 'tibtof_channel2_text'}

XYoff5 = [150,1]
TIBtofLabel3 = { size : [TIBtofLabel2.size[0]+XYoff5[0],$
                         TIBtofLabel2.size[1]],$
                 value : '#3'}
XYoff6 = [20,0]
TIBtofText3 = { size : [TIBtofLabel3.size[0]+XYoff6[0],$
                        TIBtofText2.size[1],$
                        70,30],$
                uname : 'tibtof_channel3_text'}

XYoff7 = [150,1]
TIBtofLabel4 = { size : [TIBtofLabel3.size[0]+XYoff7[0],$
                         TIBtofLabel3.size[1]],$
                 value : '#4'}
XYoff8 = [20,0]
TIBtofText4 = { size : [TIBtofLabel4.size[0]+XYoff8[0],$
                        TIBtofText3.size[1],$
                        70,30],$
                uname : 'tibtof_channel4_text'}


;/////////////////////////////////////////////////////
;Time-Independent Background Constant for Sample Data/
;/////////////////////////////////////////////////////
yoff = 70
TIBCfSDframe = { size : [TIBtofFrame.size[0],$
                         TIBtofFrame.size[1]+yoff,$
                         TIBtofFrame.size[2],$
                         55],$
                 frame: TIBtofFrame.frame}

XYoff9 = [10,-12]
TIBCfSDBase = { size : [TIBCfSDframe.size[0]+XYoff9[0],$
                        TIBCfSDframe.size[1]+XYoff9[1],$
                        340,$
                        30],$
                button : { uname : 'tibc_for_sd_button',$
                           list : ['Time-Independent Background Constant for Sample Data']}}

XYoff10 = [10,25]
TIBCfSDvalueLabel = { size : [TIBCfSDframe.size[0]+XYoff10[0],$
                              TIBCfSDframe.size[1]+XYoff10[1]],$
                      value : 'Value:'}
XYoff11 = [50,-5]
TIBCfSDvalueText  = { size : [TIBCfSDvalueLabel.size[0]+XYoff11[0],$
                              TIBCfSDvaluelabel.size[1]+XYoff11[1],$
                              100,30],$
                      uname : 'tibc_for_sd_value_text'}

XYoff12 = [200,0]
TIBCfSDerrorLabel = { size : [TIBCfSDvalueLabel.size[0]+XYoff12[0],$
                              TIBCfSDvalueLabel.size[1]+XYoff12[1]],$
                      value : 'Error:'}
XYoff13 = [50,-5]
TIBCfSDerrorText  = { size : [TIBCfSDerrorLabel.size[0]+XYoff13[0],$
                              TIBCfSDerrorlabel.size[1]+XYoff13[1],$
                              100,30],$
                      uname : 'tibc_for_sd_error_text'}

;/////////////////////////////////////////////////////
;Time-Independent Background Constant for background Data/
;/////////////////////////////////////////////////////
yoff = 90
TIBCfBDframe = { size : [TIBtofFrame.size[0],$
                         TIBCfSDbase.size[1]+yoff,$
                         TIBtofFrame.size[2],$
                         TIBCfSDframe.size[3]],$
                 frame: TIBtofFrame.frame}

XYoff9 = [10,-12]
TIBCfBDBase = { size : [TIBCfBDframe.size[0]+XYoff9[0],$
                        TIBCfBDframe.size[1]+XYoff9[1],$
                        365,$
                        30],$
                button : { uname : 'tibc_for_bd_button',$
                           list : ['Time-Independent Background Constant for Background Data']}}

XYoff10 = [10,25]
TIBCfBDvalueLabel = { size : [TIBCfBDframe.size[0]+XYoff10[0],$
                              TIBCfBDframe.size[1]+XYoff10[1]],$
                      value : 'Value:'}
XYoff11 = [50,-5]
TIBCfBDvalueText  = { size : [TIBCfBDvalueLabel.size[0]+XYoff11[0],$
                              TIBCfBDvaluelabel.size[1]+XYoff11[1],$
                              100,30],$
                      uname : 'tibc_for_bd_value_text'}

XYoff12 = [200,0]
TIBCfBDerrorLabel = { size : [TIBCfBDvalueLabel.size[0]+XYoff12[0],$
                              TIBCfBDvalueLabel.size[1]+XYoff12[1]],$
                      value : 'Error:'}
XYoff13 = [50,-5]
TIBCfBDerrorText  = { size : [TIBCfBDerrorLabel.size[0]+XYoff13[0],$
                              TIBCfBDerrorlabel.size[1]+XYoff13[1],$
                              100,30],$
                      uname : 'tibc_for_bd_error_text'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
tab3_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[2])

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background TOF channels (microSeconds)\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

TIBtofLabel = WIDGET_LABEL(tab3_base,$
                           XOFFSET = TIBtofLabel.size[0],$
                           YOFFSET = TIBtofLabel.size[1],$
                           VALUE   = TIBtofLabel.value)

TIBtofLabel1 = WIDGET_LABEL(tab3_base,$
                            XOFFSET = TIBtofLabel1.size[0],$
                            YOFFSET = TIBtofLabel1.size[1],$
                            VALUE   = TIBtofLabel1.value)

TIBtofText1 = WIDGET_TEXT(tab3_base,$
                          XOFFSET   = TIBtofText1.size[0],$
                          YOFFSET   = TIBtofText1.size[1],$
                          SCR_XSIZE = TIBtofText1.size[2],$
                          SCR_YSIZE = TIBtofText1.size[3],$
                          UNAME     = TIBtofText1.uname,$
                          /EDITABLE,$
                          /ALIGN_LEFT)


TIBtofLabel2 = WIDGET_LABEL(tab3_base,$
                            XOFFSET = TIBtofLabel2.size[0],$
                            YOFFSET = TIBtofLabel2.size[1],$
                            VALUE   = TIBtofLabel2.value)

TIBtofText2 = WIDGET_TEXT(tab3_base,$
                          XOFFSET   = TIBtofText2.size[0],$
                          YOFFSET   = TIBtofText2.size[1],$
                          SCR_XSIZE = TIBtofText2.size[2],$
                          SCR_YSIZE = TIBtofText2.size[3],$
                          UNAME     = TIBtofText2.uname,$
                          /EDITABLE,$
                          /ALIGN_LEFT)


TIBtofLabel3 = WIDGET_LABEL(tab3_base,$
                            XOFFSET = TIBtofLabel3.size[0],$
                            YOFFSET = TIBtofLabel3.size[1],$
                            VALUE   = TIBtofLabel3.value)

TIBtofText3 = WIDGET_TEXT(tab3_base,$
                          XOFFSET   = TIBtofText3.size[0],$
                          YOFFSET   = TIBtofText3.size[1],$
                          SCR_XSIZE = TIBtofText3.size[2],$
                          SCR_YSIZE = TIBtofText3.size[3],$
                          UNAME     = TIBtofText3.uname,$
                          /EDITABLE,$
                          /ALIGN_LEFT)


TIBtofLabel4 = WIDGET_LABEL(tab3_base,$
                            XOFFSET = TIBtofLabel4.size[0],$
                            YOFFSET = TIBtofLabel4.size[1],$
                            VALUE   = TIBtofLabel4.value)

TIBtofText4 = WIDGET_TEXT(tab3_base,$
                          XOFFSET   = TIBtofText4.size[0],$
                          YOFFSET   = TIBtofText4.size[1],$
                          SCR_XSIZE = TIBtofText4.size[2],$
                          SCR_YSIZE = TIBtofText4.size[3],$
                          UNAME     = TIBtofText4.uname,$
                          /EDITABLE,$
                          /ALIGN_LEFT)

TIBtofFrame = WIDGET_LABEL(tab3_base,$
                           XOFFSET   = TIBtofFrame.size[0],$
                           YOFFSET   = TIBtofFrame.size[1],$
                           SCR_XSIZE = TIBtofFrame.size[2],$
                           SCR_YSIZE = TIBtofFrame.size[3],$
                           FRAME     = TIBtofFrame.frame,$
                           VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background Constant for Sample Data\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab3_base,$
                   XOFFSET   = TIBCfSDbase.size[0],$
                   YOFFSET   = TIBCfSDbase.size[1],$
                   SCR_XSIZE = TIBCfSDbase.size[2],$
                   SCR_YSIZE = TIBCfSDbase.size[3])

group = CW_BGROUP(base,$
                  TIBCfSDbase.button.list,$
                  UNAME      = TIBCfSDbase.button.uname,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  /NONEXCLUSIVE)

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET = TIBCfSDvalueLabel.size[0],$
                     YOFFSET = TIBCfSDvalueLabel.size[1],$
                     VALUE   = TIBCfSDvalueLabel.value)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = TIBCFSDvalueText.size[0],$
                   YOFFSET   = TIBCFSDvalueText.size[1],$
                   SCR_XSIZE = TIBCFSDvalueText.size[2],$
                   SCR_YSIZE = TIBCFSDvalueText.size[3],$
                   UNAME     = TIBCFSDvalueText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET = TIBCfSDerrorLabel.size[0],$
                     YOFFSET = TIBCfSDerrorLabel.size[1],$
                     VALUE   = TIBCfSDerrorLabel.value)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = TIBCFSDerrorText.size[0],$
                   YOFFSET   = TIBCFSDerrorText.size[1],$
                   SCR_XSIZE = TIBCFSDerrorText.size[2],$
                   SCR_YSIZE = TIBCFSDerrorText.size[3],$
                   UNAME     = TIBCFSDerrorText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab3_base,$
                      XOFFSET   = TIBCfSDframe.size[0],$
                      YOFFSET   = TIBCfSDframe.size[1],$
                      SCR_XSIZE = TIBCfSDframe.size[2],$
                      SCR_YSIZE = TIBCfSDframe.size[3],$
                      FRAME     = TIBCfSDframe.frame,$
                      VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Time-Independent Background Constant for Background Data\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

base = WIDGET_BASE(tab3_base,$
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

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET = TIBCfBDvalueLabel.size[0],$
                     YOFFSET = TIBCfBDvalueLabel.size[1],$
                     VALUE   = TIBCfBDvalueLabel.value)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = TIBCfBDvalueText.size[0],$
                   YOFFSET   = TIBCfBDvalueText.size[1],$
                   SCR_XSIZE = TIBCfBDvalueText.size[2],$
                   SCR_YSIZE = TIBCfBDvalueText.size[3],$
                   UNAME     = TIBCfBDvalueText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

label = WIDGET_LABEL(tab3_base,$
                     XOFFSET = TIBCfBDerrorLabel.size[0],$
                     YOFFSET = TIBCfBDerrorLabel.size[1],$
                     VALUE   = TIBCfBDerrorLabel.value)

text = WIDGET_TEXT(tab3_base,$
                   XOFFSET   = TIBCfBDerrorText.size[0],$
                   YOFFSET   = TIBCfBDerrorText.size[1],$
                   SCR_XSIZE = TIBCfBDerrorText.size[2],$
                   SCR_YSIZE = TIBCfBDerrorText.size[3],$
                   UNAME     = TIBCfBDerrorText.uname,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

frame  = WIDGET_LABEL(tab3_base,$
                      XOFFSET   = TIBCfBDframe.size[0],$
                      YOFFSET   = TIBCfBDframe.size[1],$
                      SCR_XSIZE = TIBCfBDframe.size[2],$
                      SCR_YSIZE = TIBCfBDframe.size[3],$
                      FRAME     = TIBCfBDframe.frame,$
                      VALUE     = '')

END
