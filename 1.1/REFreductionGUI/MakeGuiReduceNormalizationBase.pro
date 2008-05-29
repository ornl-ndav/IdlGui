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

PRO MakeGuiReduceNormalizationBase, Event, REDUCE_BASE, IndividualBaseWidth

;yes or not base
NormalizationYesNoBaseSize = [0,185,IndividualBaseWidth,40]

;yes or not offset
NormalizationBGroupLabelSize  = [10,5]
NormalizationBGroupLabelTitle = 'N O R M A L I Z A T I O N:'
NormalizationBGroupList       = [' Yes    ',' No    ']
d1=190
NormalizationBGroupSize  = [NormalizationBGroupLabelSize[0]+d1,$
                            NormalizationBGroupLabelSize[1]-5]

;size of Norm base
NormalizationBaseSize   = [0,NormalizationYesNoBaseSize[1]+40,$
                           IndividualBaseWidth, 180]

;frame
Yoffset= 0
NormalizationLabelSize  = [20,2+Yoffset]
NormalizationLabelTitle = 'N O R M A L I Z A T I O N'
NormalizationFrameSize  = [10,10+Yoffset,IndividualBaseWidth-30,150]

;runs number
RunsLabelSize     = [33,27+Yoffset]
RunsLabelTitle    = 'Runs:'
d_L_T = 50
RunsTextFieldSize = [RunsLabelSize[0]+d_L_T,$
                     RunsLabelSize[1]-5,600,30]

d_vertical_L_L = 35
;region of interest 
RegionOfInterestLabelSize     = [RunsLabelSize[0],$
                                 RunsLabelSize[1]+d_vertical_L_L]
RegionOfInterestLabelTitle    = 'Region of interest (ROI) file:'
RegionOfInterestTextFieldSize = [230,$
                                 RegionOfInterestLabelSize[1]-5,$
                                 453,30]

;Exclusion peak region
ExclusionPeakRegionLabelSize  = [RunsLabelSize[0],$
                                RegionOfInterestLabelSize[1]+d_vertical_L_L]
ExclusionPeakRegionLabelTitle = 'Exclusion Peak Region:'

;low bin
ExclusionLowBinLabelSize  = [ExclusionPeakRegionLabelSize[0]+200,$
                             ExclusionPeakRegionLabelSize[1]]
ExclusionLowBinLabelTitle = 'Low bin:'
d_L_T_2 = d_L_T + 10
ExclusionLowBinTextFieldSize = [ExclusionLowBinLabelSize[0]+d_L_T_2,$
                                ExclusionLowBinLabelSize[1]-5,$
                                70,30]

;high bin
ExclusionHighBinLabelSize  = [ExclusionLowBinLabelSize[0]+180,$
                              ExclusionPeakRegionLabelSize[1]]
ExclusionHighBinLabelTitle = 'High bin:'
ExclusionHighBinTextFieldSize = [ExclusionHighBinLabelSize[0]+d_L_T_2,$
                                 ExclusionLowBinTextFieldSize[1],$
                                 ExclusionLowBinTextFieldSize[2],$
                                 ExclusionLowBinTextFieldSize[3]]
                                
;background
BackgroundLabelSize = [ExclusionPeakRegionLabelSize[0],$
                       ExclusionHighBinLabelSize[1]+d_vertical_L_L]
BackgroundLabelTitle = 'Background:'
d_L_T_3 = d_L_T_2 + 40
BackgroundBGroupSize = [BackgroundLabelSize[0]+d_L_T_3,$
                        BackgroundLabelSize[1]-5]
BackgroundBGroupList = [' Yes    ',' No    ']


;******************************************************************************
;Create GUI

NormalizationYesNoBase = WIDGET_BASE(REDUCE_BASE,$
                                     XOFFSET   = $
                                     NormalizationYesNoBaseSize[0],$
                                     YOFFSET   = $
                                     NormalizationYesNoBaseSize[1],$
                                     SCR_XSIZE = $
                                     NormalizationYesNoBaseSize[2],$
                                     SCR_YSIZE = $
                                     NormalizationyesNoBaseSize[3])
                                     
;normalization yes or no
NormalizationBGroupLabel = WIDGET_LABEL(NormalizationYesNoBase,$
                                        XOFFSET = $
                                        NormalizationBGroupLabelSize[0],$
                                        YOFFSET = $
                                        NormalizationBGroupLabelSize[1],$
                                        VALUE   = $
                                        NormalizationBGroupLabelTitle)

NormalizationBGroup = CW_BGROUP(NormalizationYesNoBase,$
                                NormalizationBGroupList,$
                                XOFFSET   = NormalizationBGroupSize[0],$
                                YOFFSET   = NormalizationBGroupSize[1],$
                                ROW       = 1,$
                                UNAME     = 'yes_no_normalization_bgroup',$
                                SET_VALUE = 0,$
                                /EXCLUSIVE)

;base
normalization_base = WIDGET_BASE(REDUCE_BASE,$
                                 UNAME     = 'normalization_base',$
                                 XOFFSET   = NormalizationBaseSize[0],$
                                 YOFFSET   = NormalizationBaseSize[1],$
                                 SCR_XSIZE = NormalizationBaseSize[2],$
                                 SCR_YSIZE = NormalizationBaseSize[3])

;Normalization main label
NormalizationLabel = WIDGET_LABEL(normalization_base,$
                                  XOFFSET = NormalizationLabelSize[0],$
                                  YOFFSET = NormalizationLabelSize[1],$
                                  VALUE   = NormalizationLabelTitle)

;runs label
RunsLabel = WIDGET_LABEL(normalization_base,$
                         XOFFSET = RunsLabelSize[0],$
                         YOFFSET = RunsLabelSize[1],$
                         VALUE   = RunsLabelTitle)

;runs text field
RunsTextField = WIDGET_TEXT(normalization_base,$
                            XOFFSET   = RunsTextFieldSize[0],$
                            YOFFSET   = RunsTextFieldSize[1],$
                            SCR_XSIZE = RunsTextFieldSize[2],$
                            SCR_YSIZE = RunsTextFieldSize[3],$
                            UNAME     =  $
                            'reduce_normalization_runs_text_field',$
                            /EDITABLE,$
                            /ALIGN_LEFT,$
                            /ALL_EVENTS)
                            
;region of interest label
RegionOfInterestLabel = WIDGET_LABEL(normalization_base,$
                                     XOFFSET = RegionOfInterestLabelSize[0],$
                                     YOFFSET = RegionOfInterestLabelSize[1],$
                                     VALUE   = RegionOfInterestLabelTitle)

;region of interest text field
RegionOfInterestTextField = $
  WIDGET_TEXT(normalization_base,$
              XOFFSET   = $
              RegionOfInterestTextFieldSize[0],$
              YOFFSET   = $
              RegionOfInterestTextFieldSize[1],$
              SCR_XSIZE = $
              RegionOfInterestTextFieldSize[2],$
              SCR_YSIZE = $
              RegionOfInterestTextFieldSize[3],$
              UNAME     = $
              'reduce_normalization_region_of_interest_file_name',$
              /ALIGN_LEFT)
  
;exclusion peak region
ExclusionPeakRegionLabel = WIDGET_LABEL(normalization_base,$
                                        XOFFSET = $
                                        ExclusionPeakRegionLabelSize[0],$
                                        YOFFSET = $
                                        ExclusionPeakRegionLabelSize[1],$
                                        VALUE   = $
                                        ExclusionPeakRegionLabelTitle)

;exclusion low bin
ExclusionLowBinLabel = WIDGET_LABEL(normalization_base,$
                                    XOFFSET = ExclusionLowBinLabelSize[0],$
                                    YOFFSET = ExclusionLowBinLabelSize[1],$
                                    VALUE   = ExclusionLowBinLabelTitle)

;exclusion low bin text field
ExclusionLowBinTextField = WIDGET_TEXT(normalization_base,$
                                       UNAME     = $
                                       'norm_exclusion_low_bin_text',$
                                       XOFFSET   = $
                                       ExclusionLowBinTextFieldSize[0],$
                                       YOFFSET   = $
                                       ExclusionLowBinTextFieldSize[1],$
                                       SCR_XSIZE = $
                                       ExclusionLowBinTExtFieldSize[2],$
                                       SCR_YSIZE = $
                                       ExclusionLowBinTextFieldSize[3],$
                                       /ALIGN_LEFT)

;exclusion high bin
ExclusionHighBinLabel = WIDGET_LABEL(normalization_base,$
                                     XOFFSET = $
                                     ExclusionHighBinLabelSize[0],$
                                     YOFFSET = $
                                     ExclusionHighBinLabelSize[1],$
                                     VALUE = $
                                     ExclusionHighBinLabelTitle)

;exclusion High bin text field
ExclusionHighBinTextField = WIDGET_TEXT(normalization_base,$
                                        UNAME     = $
                                        'norm_exclusion_high_bin_text',$
                                        XOFFSET   = $
                                        ExclusionHighBinTextFieldSize[0],$
                                        YOFFSET   = $
                                        ExclusionHighBinTextFieldSize[1],$
                                        SCR_XSIZE = $
                                        ExclusionHighBinTExtFieldSize[2],$
                                        SCR_YSIZE = $
                                        ExclusionHighBinTextFieldSize[3],$
                                        /ALIGN_LEFT)

;background
BackgroundLabel = WIDGET_LABEL(normalization_base,$
                               XOFFSET = BackgroundLabelSize[0],$
                               YOFFSET = BackgroundLabelSize[1],$
                               VALUE   = BackgroundLabelTitle)

BackgroundBGroup = CW_BGROUP(normalization_base,$
                             BackgroundBGroupList,$
                             XOFFSET   = BackgroundBGroupSize[0],$
                             YOFFSET   = BackgroundBGroupSize[1],$
                             SET_VALUE = 0,$
                             UNAME     = 'normalization_background_cw_bgroup',$
                             ROW       = 1,$
                             /EXCLUSIVE)

;frame
NormalizationFrame = WIDGET_LABEL(normalization_base,$
                                  XOFFSET   = NormalizationFrameSize[0],$
                                  YOFFSET   = NormalizationFrameSize[1],$
                                  SCR_XSIZE = NormalizationFrameSize[2],$
                                  SCR_YSIZE = NormalizationFrameSize[3],$
                                  FRAME     = 1,$
                                  VALUE     = '')


END
