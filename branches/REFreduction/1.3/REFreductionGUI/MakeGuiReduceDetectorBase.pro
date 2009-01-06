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

PRO MakeGuiReduceDetectorBase, Event, REDUCE_BASE, IndividualBaseWidth

;size of Q base
DetectorBaseSize   = [0,470,IndividualBaseWidth, 60]

DetectorLabelSize  = [20,2]
DetectorLabelTitle = 'Angle Offset'
DetectorFrameSize  = [10,10,IndividualBaseWidth-30,45]

;Nexus Angle value
NexusAngleLabelSize  = [30,27]
NexusAngleLabelValue = 'Angle Value: N/A'

;Detector value
d_L_L = 202
DetectorValueLabelSize     = [NexusAngleLabelSize[0]+d_L_L,27]
DetectorValueLabelTitle    = 'Value:'
d_L_T = 40
DetectorValueTextFieldSize = [DetectorValueLabelSize[0]+d_L_T,$
                              DetectorValueLabelSize[1]-5,70,30]
d_L_L = 170
;Detector error
DetectorErrorLabelSize     = [DetectorValueLabelSize[0]+d_L_L,$
                              DetectorValueLabelSize[1]]
DetectorErrorLabelTitle    = '+/-'
DetectorErrorTextFieldSize = [DetectorErrorLabelSize[0]+d_L_T,$
                              DetectorErrorLabelSize[1]-5,70,30]

;Detector units
d_L_L = 130
DetectorUnitsBGroupList = [' degrees',' radians']
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
                            UNAME  = 'reduce_detector_base',$
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

;frame
DetectorFrame = widget_label(detector_base,$
                             xoffset=DetectorFrameSize[0],$
                             yoffset=DetectorFrameSize[1],$
                             scr_xsize=DetectorFrameSize[2],$
                             scr_ysize=DetectorFrameSize[3],$
                             frame=1,$
                             value='')



END
