PRO MakeGuiReduceDetectorBase, Event, REDUCE_BASE, IndividualBaseWidth

;size of Q base
DetectorBaseSize   = [0,70,IndividualBaseWidth, 60]

DetectorLabelSize  = [20,2]
DetectorLabelTitle = 'Detector Angle'
DetectorFrameSize  = [10,10,IndividualBaseWidth-30,45]

;Detector value
DetectorValueLabelSize     = [33,27]
DetectorValueLabelTitle    = 'Value:'
d_L_T = 60
DetectorValueTextFieldSize = [DetectorValueLabelSize[0]+d_L_T,$
                              DetectorValueLabelSize[1]-5,70,30]
d_L_L = 180
;Detector error
DetectorErrorLabelSize     = [DetectorValueLabelSize[0]+d_L_L,$
                              DetectorValueLabelSize[1]]
DetectorErrorLabelTitle    = '+/-'
DetectorErrorTextFieldSize = [DetectorErrorLabelSize[0]+d_L_T,$
                              DetectorErrorLabelSize[1]-5,70,30]

;Detector units
DetectorUnitsBGroupList = [' degree   ',' radian   ']
DetectorUnitsBGroupSize = [DetectorErrorLabelSize[0]+d_L_L,$
                           DetectorErrorTextFieldSize[1]]
                    

;*********************************************************
;Create GUI

;base
detector_base = widget_base(REDUCE_BASE,$
                            xoffset=DetectorBaseSize[0],$
                            yoffset=DetectorBaseSize[1],$
                            scr_xsize=DetectorBaseSize[2],$
                            scr_ysize=DetectorBaseSize[3])

;label that goes on top of frame
DetectorLabel = widget_label(detector_base,$
                             xoffset=DetectorLabelSize[0],$
                             yoffset=DetectorLabelSize[1],$
                             value=DetectorLabelTitle)

;Detector value label
DetectorValueLabel = widget_label(detector_base,$
                                  xoffset=DetectorValueLabelSize[0],$
                                  yoffset=DetectorValueLabelSize[1],$
                                  value=DetectorValueLabelTitle)

;Detector Value Text Field
DetectorValueTextField = widget_text(detector_base,$
                                     xoffset=DetectorValueTextFieldSize[0],$
                                     yoffset=DetectorValueTextFieldSize[1],$
                                     scr_xsize=DetectorValueTextFieldSize[2],$
                                     scr_ysize=DetectorValueTextFieldSize[3],$
                                     /align_left,$
                                     /editable,$
                                     uname='detector_value_text_field')

;Detector error label
DetectorErrorLabel = widget_label(detector_base,$
                                  xoffset=DetectorErrorLabelSize[0],$
                                  yoffset=DetectorErrorLabelSize[1],$
                                  value=DetectorErrorLabelTitle)

;Detector error Text Field
DetectorErrorTextField = widget_text(detector_base,$
                                     xoffset=DetectorErrorTextFieldSize[0],$
                                     yoffset=DetectorErrorTextFieldSize[1],$
                                     scr_xsize=DetectorErrorTextFieldSize[2],$
                                     scr_ysize=DetectorErrorTextFieldSize[3],$
                                     /align_left,$
                                     /editable,$
                                     uname='detector_error_text_field')
;Detector units
DetectorUnitsBGroup = cw_bgroup(detector_base,$
                                DetectorUnitsBGroupList,$
                                /exclusive,$
                                xoffset=DetectorUnitsBGroupSize[0],$
                                yoffset=DetectorUnitsBGroupSize[1],$
                                set_value=0,$
                                uname='detector_units_b_group',$
                                row=1)

;frame
DetectorFrame = widget_label(detector_base,$
                             xoffset=DetectorFrameSize[0],$
                             yoffset=DetectorFrameSize[1],$
                             scr_xsize=DetectorFrameSize[2],$
                             scr_ysize=DetectorFrameSize[3],$
                             frame=1,$
                             value='')



END
