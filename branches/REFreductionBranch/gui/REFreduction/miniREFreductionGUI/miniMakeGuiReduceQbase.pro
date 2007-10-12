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
                    

;*********************************************************
;Create GUI

;base
Q_base = widget_base(REDUCE_BASE,$
                     xoffset=QBaseSize[0],$
                     yoffset=QBaseSize[1],$
                     scr_xsize=QBaseSize[2],$
                     scr_ysize=QBaseSize[3])

;label that goes on top of frame
QLabel = widget_label(Q_base,$
                      xoffset=QLabelSize[0],$
                      yoffset=QLabelSize[1],$
                      value=QLabelTitle)

;Qmin label
QMinLabel = widget_label(Q_base,$
                         xoffset=QMinLabelSize[0],$
                         yoffset=QMinLabelSize[1],$
                         value=QMinLabelTitle)

;Qmin Text Field
QMinTextField = widget_text(Q_base,$
                            xoffset=QMinTextFieldSize[0],$
                            yoffset=QMinTextFieldSize[1],$
                            scr_xsize=QMinTextFieldSize[2],$
                            scr_ysize=QMinTextFieldSize[3],$
                            /align_left,$
                            /all_events,$
                            /editable,$
                            uname='q_min_text_field')

;Qmax label
QMaxLabel = widget_label(Q_base,$
                         xoffset=QMaxLabelSize[0],$
                         yoffset=QMaxLabelSize[1],$
                         value=QMaxLabelTitle)

;Qmax Text Field
QMaxTextField = widget_text(Q_base,$
                            xoffset=QMaxTextFieldSize[0],$
                            yoffset=QMaxTextFieldSize[1],$
                            scr_xsize=QMaxTextFieldSize[2],$
                            scr_ysize=QMaxTextFieldSize[3],$
                            /align_left,$
                            /editable,$
                            /all_events,$
                            uname='q_max_text_field')

;Qwidth label
QwidthLabel = widget_label(Q_base,$
                           xoffset=QwidthLabelSize[0],$
                           yoffset=QwidthLabelSize[1],$
                           value=QwidthLabelTitle)

;Qwidth Text Field
QwidthTextField = widget_text(Q_base,$
                              xoffset=QwidthTextFieldSize[0],$
                              yoffset=QwidthTextFieldSize[1],$
                              scr_xsize=QwidthTextFieldSize[2],$
                              scr_ysize=QwidthTextFieldSize[3],$
                              /align_left,$
                              /editable,$
                              /all_events,$
                              uname='q_width_text_field')

;QScale label
QScaleBGroup = cw_bgroup(Q_base,$
                         QScaleBGroupList,$
                         /exclusive,$
                         xoffset=QScaleBGroupSize[0],$
                         yoffset=QScaleBGroupSize[1],$
                         set_value=0,$
                         uname='q_scale_b_group',$
                         row=1)

;frame
QFrame = widget_label(Q_base,$
                      xoffset=QFrameSize[0],$
                      yoffset=QFrameSize[1],$
                      scr_xsize=QFrameSize[2],$
                      scr_ysize=QFrameSize[3],$
                      frame=1,$
                      value='')



END
