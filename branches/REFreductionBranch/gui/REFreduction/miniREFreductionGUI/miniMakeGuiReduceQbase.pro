PRO miniMakeGuiReduceQBase, Event, REDUCE_BASE, IndividualBaseWidth

;size of Q base
QBaseSize   = [0,335,IndividualBaseWidth, 55]

QLabelSize  = [20,2]
QLabelTitle = 'Q'
QFrameSize  = [10,10,IndividualBaseWidth-30,40]

;Qmin
QminLabelSize     = [15,23]
QminLabelTitle    = 'Minimum:'
d_L_T = 60
QminTextFieldSize = [QminLabelSize[0]+d_L_T,$
                     QminLabelSize[1]-5,70,30]
d_L_L = 145
;Qmax
QmaxLabelSize     = [QminLabelSize[0]+d_L_L,$
                     QminLabelSize[1]]
QmaxLabelTitle    = 'Maximum:'
QmaxTextFieldSize = [QmaxLabelSize[0]+d_L_T,$
                     QminTextFieldSize[1],$
                     QminTextFieldSize[2],$
                     QminTextFieldSize[3]]
;Qwidth
QwidthLabelSize     = [QmaxLabelSize[0]+d_L_L,$
                       QmaxLabelSize[1]]
QwidthLabelTitle    = 'Width:'
d_L_T_2 = d_L_T - 10
QwidthTextFieldSize = [QwidthLabelSize[0]+d_L_T_2,$
                       QminTextFieldSize[1],$
                       QminTextFieldSize[2],$
                       QminTextFieldSize[3]]

;Qscale
QScaleBGroupList = ['linear','log' ]
d_L_T_3 = d_L_T + 30
QScaleBGroupSize = [QwidthTextFieldSize[0]+d_L_T_3,$
                    QminTextFieldSize[1]]
                    
;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

;base
Q_base = WIDGET_BASE(REDUCE_BASE,$
                     XOFFSET   = QBaseSize[0],$
                     YOFFSET   = QBaseSize[1],$
                     SCR_XSIZE = QBaseSize[2],$
                     SCR_YSIZE = QBaseSize[3])

;label that goes on top of frame
QLabel = WIDGET_LABEL(Q_base,$
                      XOFFSET = QLabelSize[0],$
                      YOFFSET = QLabelSize[1],$
                      VALUE   = QLabelTitle)

;Qmin label
QMinLabel = WIDGET_LABEL(Q_base,$
                         XOFFSET = QMinLabelSize[0],$
                         YOFFSET = QMinLabelSize[1],$
                         VALUE   = QMinLabelTitle)

;Qmin Text Field
QMinTextField = WIDGET_TEXT(Q_base,$
                            XOFFSET   = QMinTextFieldSize[0],$
                            YOFFSET   = QMinTextFieldSize[1],$
                            SCR_XSIZE = QMinTextFieldSize[2],$
                            SCR_YSIZE = QMinTextFieldSize[3],$
                            UNAME     = 'q_min_text_field',$
                            /ALIGN_LEFT,$
                            /ALL_EVENTS,$
                            /EDITABLE)

;Qmax label
QMaxLabel = WIDGET_LABEL(Q_base,$
                         XOFFSET = QMaxLabelSize[0],$
                         YOFFSET = QMaxLabelSize[1],$
                         VALUE   = QMaxLabelTitle)

;Qmax Text Field
QMaxTextField = WIDGET_TEXT(Q_base,$
                            XOFFSET   = QMaxTextFieldSize[0],$
                            YOFFSET   = QMaxTextFieldSize[1],$
                            SCR_XSIZE = QMaxTextFieldSize[2],$
                            SCR_YSIZE = QMaxTextFieldSize[3],$
                            UNAME     = 'q_max_text_field',$
                            /ALIGN_LEFT,$
                            /EDITABLE,$
                            /ALL_EVENTS)

;Qwidth label
QwidthLabel = WIDGET_LABEL(Q_base,$
                           XOFFSET = QwidthLabelSize[0],$
                           YOFFSET = QwidthLabelSize[1],$
                           VALUE   = QwidthLabelTitle)

;Qwidth Text Field
QwidthTextField = WIDGET_TEXT(Q_base,$
                              XOFFSET   = QwidthTextFieldSize[0],$
                              YOFFSET   = QwidthTextFieldSize[1],$
                              SCR_XSIZE = QwidthTextFieldSize[2],$
                              SCR_YSIZE = QwidthTextFieldSize[3],$
                              UNAME     = 'q_width_text_field',$
                              /ALIGN_LEFT,$
                              /EDITABLE,$
                              /ALL_EVENTS)

;QScale label
QScaleBGroup = CW_BGROUP(Q_base,$
                         QScaleBGroupList,$
                         XOFFSET=QScaleBGroupSize[0],$
                         YOFFSET=QScaleBGroupSize[1],$
                         SET_VALUE=0,$
                         UNAME='q_scale_b_group',$
                         ROW=1,$
                         /EXCLUSIVE)

;frame
QFrame = WIDGET_LABEL(Q_base,$
                      XOFFSET   = QFrameSize[0],$
                      YOFFSET   = QFrameSize[1],$
                      SCR_XSIZE = QFrameSize[2],$
                      SCR_YSIZE = QFrameSize[3],$
                      FRAME     = 1,$
                      VALUE     = '')

END
