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
DetectorUnitsBGroupList = ['degrees','radians']
DetectorUnitsBGroupSize = [DetectorErrorLabelSize[0]+d_L_L,$
                           DetectorErrorTextFieldSize[1]]
                    
;GUI and NeXus data used labels
GuiDataUsedSize   = [580,37,100,20]
GuiDataUsedLabelTitle   = ' GUI data used '
NexusDataUsedSize = [580,8,100,20]
NexusDataUsedLabelTitle = 'NeXus data used'

;##############################################################################
;############################## Create GUI ####################################
;##############################################################################

;base
detector_base = WIDGET_BASE(REDUCE_BASE,$
                            UNAME     = 'reduce_detector_base',$
                            XOFFSET   = DetectorBaseSize[0],$
                            YOFFSET   = DetectorBaseSize[1],$
                            SCR_XSIZE = DetectorBaseSize[2],$
                            SCR_YSIZE = DetectorBaseSize[3])

;label that goes on top of frame
DetectorLabel = WIDGET_LABEL(detector_base,$
                             XOFFSET = DetectorLabelSize[0],$
                             YOFFSET = DetectorLabelSize[1],$
                             VALUE   = DetectorLabelTitle)

;Nexus Angle value
NexusAngleLabel = WIDGET_LABEL(detector_base,$
                               XOFFSET = NexusAngleLabelSize[0],$
                               YOFFSET = NexusAngleLabelSize[1],$
                               VALUE   = NexusAngleLabelValue)

;Detector value label
DetectorValueLabel = WIDGET_LABEL(detector_base,$
                                  XOFFSET = DetectorValueLabelSize[0],$
                                  YOFFSET = DetectorValueLabelSize[1],$
                                  VALUE   = DetectorValueLabelTitle)

;Detector Value Text Field
DetectorValueTextField = WIDGET_TEXT(detector_base,$
                                     XOFFSET   = DetectorValueTextFieldSize[0],$
                                     YOFFSET   = DetectorValueTextFieldSize[1],$
                                     SCR_XSIZE = DetectorValueTextFieldSize[2],$
                                     SCR_YSIZE = DetectorValueTextFieldSize[3],$
                                     UNAME     = 'detector_value_text_field',$
                                     /ALIGN_LEFT,$
                                     /ALL_EVENTS,$
                                     /EDITABLE)

;Detector error label
DetectorErrorLabel = WIDGET_LABEL(detector_base,$
                                  XOFFSET = DetectorErrorLabelSize[0],$
                                  YOFFSET = DetectorErrorLabelSize[1],$
                                  VALUE   = DetectorErrorLabelTitle)

;Detector error Text Field
DetectorErrorTextField = WIDGET_TEXT(detector_base,$
                                     XOFFSET   = DetectorErrorTextFieldSize[0],$
                                     YOFFSET   = DetectorErrorTextFieldSize[1],$
                                     SCR_XSIZE = DetectorErrorTextFieldSize[2],$
                                     SCR_YSIZE = DetectorErrorTextFieldSize[3],$
                                     UNAME     = 'detector_error_text_field',$
                                     /ALIGN_LEFT,$
                                     /EDITABLE,$
                                     /ALL_EVENTS)

;Detector units
DetectorUnitsBGroup = CW_BGROUP(detector_base,$
                                DetectorUnitsBGroupList,$
                                XOFFSET   = DetectorUnitsBGroupSize[0],$
                                YOFFSET   = DetectorUnitsBGroupSize[1],$
                                SET_VALUE = 0,$
                                UNAME     = 'detector_units_b_group',$
                                ROW       = 1,$
                                /EXCLUSIVE)

;frame
DetectorFrame = WIDGET_LABEL(detector_base,$
                             XOFFSET   = DetectorFrameSize[0],$
                             YOFFSET   = DetectorFrameSize[1],$
                             SCR_XSIZE = DetectorFrameSize[2],$
                             SCR_YSIZE = DetectorFrameSize[3],$
                             FRAME     = 1,$
                             VALUE='')

END
