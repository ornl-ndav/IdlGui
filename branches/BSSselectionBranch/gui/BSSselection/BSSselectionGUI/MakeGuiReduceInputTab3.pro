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







END
