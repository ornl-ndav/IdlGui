PRO miniMakeGuiReduceDetectorBase, Event, REDUCE_BASE, IndividualBaseWidth

;size of Q base
DetectorBaseSize   = [0,390,IndividualBaseWidth, 60]

DetectorLabelSize  = [20,2]
DetectorLabelTitle = 'A N G L E   O F F S E T'
DetectorFrameSize  = [10,10,IndividualBaseWidth-30,45]

;Nexus Angle value
NexusAngleLabelSize  = [15,27]
NexusAngleLabelValue = 'Angle Value: N/A'

;Detector value
d_L_L = 150
DetectorValueLabelSize     = [NexusAngleLabelSize[0]+d_L_L,27]
DetectorValueLabelTitle    = 'Value:'
d_L_T = 40
DetectorValueTextFieldSize = [DetectorValueLabelSize[0]+d_L_T,$
                              DetectorValueLabelSize[1]-5,70,30]
d_L_L = 120
;Detector error
DetectorErrorLabelSize     = [DetectorValueLabelSize[0]+d_L_L,$
                              DetectorValueLabelSize[1]]
DetectorErrorLabelTitle    = '+/-'
DetectorErrorTextFieldSize = [DetectorErrorLabelSize[0]+d_L_T,$
                              DetectorErrorLabelSize[1]-5,70,30]

;Detector units
d_L_L = 130
DetectorUnitsBGroupList = ['degree','radian']
DetectorUnitsBGroupSize = [DetectorErrorLabelSize[0]+d_L_L,$
                           DetectorErrorTextFieldSize[1]]
                    
;GUI and NeXus data used labels
GuiDataUsedSize   = [580,37,100,20]
GuiDataUsedLabelTitle   = ' GUI data used '
NexusDataUsedSize = [580,8,100,20]
NexusDataUsedLabelTitle = 'NeXus data used'

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

;Nexus Angle value
NexusAngleLabel = WIDGET_LABEL(detector_base,$
                               XOFFSET=NexusAngleLabelSize[0],$
                               YOFFSET=NexusAngleLabelSize[1],$
                               VALUE=NexusAngleLabelValue)

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
                                     /all_events,$
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
                                     /all_events,$
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

;;NeXus data used
;NeXusDataUsedLabel = widget_label(detector_base,$
;                                  uname='nexus_data_used_label',$
;                                  xoffset=NexusDataUsedSize[0],$
;                                  yoffset=NexusDataUsedSize[1],$
;                                  scr_xsize=NexusDataUsedSize[2],$
;                                  scr_ysize=NexusDataUsedSize[3],$
;                                  value=NexusDataUsedLabelTitle,$
;                                  frame=1)
;;GUI data used
; GuiDataUsedLabel = widget_label(detector_base,$
;                                 uname='gui_data_used_label',$
;                                 xoffset=GuiDataUsedSize[0],$
;                                 yoffset=GuiDataUsedSize[1],$
;                                 scr_xsize=GuiDataUsedSize[2],$
;                                 scr_ysize=GuiDataUsedSize[3],$
;                                 value=GuiDataUsedLabelTitle,$
;                                 frame=1,$
;                                 sensitive=0)


;frame
DetectorFrame = widget_label(detector_base,$
                             xoffset=DetectorFrameSize[0],$
                             yoffset=DetectorFrameSize[1],$
                             scr_xsize=DetectorFrameSize[2],$
                             scr_ysize=DetectorFrameSize[3],$
                             frame=1,$
                             value='')



END
