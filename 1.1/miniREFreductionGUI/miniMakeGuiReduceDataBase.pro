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

PRO miniMakeGuiReduceDataBase, Event, REDUCE_BASE, IndividualBaseWidth

;size of Data base
DataBaseSize   = [0,0,IndividualBaseWidth, 155]

DataLabelSize  = [20,2]
DataLabelTitle = 'D A T A'
DataFrameSize  = [10,10,IndividualBaseWidth-30,135]

;runs number
RunsLabelSize     = [15,27]
RunsLabelTitle    = 'Runs:'
d_L_T = 40
RunsTextFieldSize = [RunsLabelSize[0]+d_L_T,$
                     RunsLabelSize[1]-5,498,30]

d_vertical_L_L = 30
;region of interest 
RegionOfInterestLabelSize = [RunsLabelSize[0],$
                             RunsLabelSize[1]+d_vertical_L_L]
RegionOfInterestLabelTitle = 'Region of interest (ROI) file:'
RegionOfInterestTextFieldSize = [200,$
                                 RegionOfInterestLabelSize[1]-5,$
                                 353,30]
                             
;Exclusion peak region
ExclusionPeakRegionLabelSize = [RunsLabelSize[0],$
                                RegionOfInterestLabelSize[1]+d_vertical_L_L]
ExclusionPeakRegionLabelTitle = 'Exclusion Peak Region:'

;low bin
ExclusionLowBinLabelSize = [ExclusionPeakRegionLabelSize[0]+200,$
                            ExclusionPeakRegionLabelSize[1]]
ExclusionLowBinLabelTitle = 'Low bin:'
d_L_T_2 = d_L_T + 20
ExclusionLowBinTextFieldSize = [ExclusionLowBinLabelSize[0]+d_L_T_2,$
                                ExclusionLowBinLabelSize[1]-5,$
                                70,30]

;high bin
ExclusionHighBinLabelSize = [ExclusionLowBinLabelSize[0]+180,$
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


;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

;base
data_base = WIDGET_BASE(REDUCE_BASE,$
                        XOFFSET   = DataBaseSize[0],$
                        YOFFSET   = DataBaseSize[1],$
                        SCR_XSIZE = DataBaseSize[2],$
                        SCR_YSIZE = DataBaseSize[3])

;Data main label
DataLabel = WIDGET_LABEL(data_base,$
                         XOFFSET = DataLabelSize[0],$
                         YOFFSET = DataLabelSize[1],$
                         VALUE   = DataLabelTitle)

;runs label
RunsLabel = WIDGET_LABEL(data_base,$
                         XOFFSET = RunsLabelSize[0],$
                         YOFFSET = RunsLabelSize[1],$
                         VALUE   = RunsLabelTitle)

;runs text field
RunsTextField = WIDGET_TEXT(data_base,$
                            XOFFSET   = RunsTextFieldSize[0],$
                            YOFFSET   = RunsTextFieldSize[1],$
                            SCR_XSIZE = RunsTextFieldSize[2],$
                            SCR_YSIZE = RunsTextFieldSize[3],$
                            UNAME     = 'reduce_data_runs_text_field',$
                            /EDITABLE,$
                            /ALIGN_LEFT,$
                            /ALL_EVENTS)

;region of interest label
RegionOfInterestLabel = WIDGET_LABEL(data_base,$
                                     XOFFSET = RegionOfInterestLabelSize[0],$
                                     YOFFSET = RegionOfInterestLabelSize[1],$
                                     VALUE   = RegionOfInterestLabelTitle)

;region of interest text field
RegionOfInterestTextField = $
  WIDGET_TEXT(data_base,$
              XOFFSET   = RegionOfInterestTextFieldSize[0],$
              YOFFSET   = RegionOfInterestTextFieldSize[1],$
              SCR_XSIZE = RegionOfInterestTextFieldSize[2],$
              SCR_YSIZE = RegionOfInterestTextFieldSize[3],$
              UNAME     = 'reduce_data_region_of_interest_file_name',$
              /ALIGN_LEFT)

;exclusion peak region
ExclusionPeakRegionLabel = $
  WIDGET_LABEL(data_base,$
               XOFFSET = ExclusionPeakRegionLabelSize[0],$
               YOFFSET = ExclusionPeakRegionLabelSize[1],$
               VALUE   = ExclusionPeakRegionLabelTitle)

;exclusion low bin
ExclusionLowBinLabel = WIDGET_LABEL(data_base,$
                                    XOFFSET = ExclusionLowBinLabelSize[0],$
                                    YOFFSET = ExclusionLowBinLabelSize[1],$
                                    VALUE   = ExclusionLowBinLabelTitle)

;exclusion low bin text field
ExclusionLowBinTextField = $
  WIDGET_TEXT(data_base,$
              UNAME     = 'data_exclusion_low_bin_text',$
              XOFFSET   = ExclusionLowBinTextFieldSize[0],$
              YOFFSET   = ExclusionLowBinTextFieldSize[1],$
              SCR_XSIZE = ExclusionLowBinTExtFieldSize[2],$
              SCR_YSIZE = ExclusionLowBinTextFieldSize[3],$
              /ALIGN_LEFT)

;exclusion high bin
ExclusionHighBinLabel = WIDGET_LABEL(data_base,$
                                     XOFFSET = ExclusionHighBinLabelSize[0],$
                                     YOFFSET = ExclusionHighBinLabelSize[1],$
                                     VALUE   = ExclusionHighBinLabelTitle)

;exclusion High bin text field
ExclusionHighBinTextField = $
  WIDGET_TEXT(data_base,$
              UNAME     = 'data_exclusion_high_bin_text',$
              XOFFSET   = ExclusionHighBinTextFieldSize[0],$
              YOFFSET   = ExclusionHighBinTextFieldSize[1],$
              SCR_XSIZE = ExclusionHighBinTExtFieldSize[2],$
              SCR_YSIZE = ExclusionHighBinTextFieldSize[3],$
              /ALIGN_LEFT)

;background
BackgroundLabel = WIDGET_LABEL(data_base,$
                               XOFFSET = BackgroundLabelSize[0],$
                               YOFFSET = BackgroundLabelSize[1],$
                               VALUE   = BackgroundLabelTitle)

BackgroundBGroup = CW_BGROUP(data_base,$
                             BackgroundBGroupList,$
                             XOFFSET   = BackgroundBGroupSize[0],$
                             YOFFSET   = BackgroundBGroupSize[1],$
                             SET_VALUE = 0,$
                             UNAME     = 'data_background_cw_bgroup',$
                             ROW       = 1,$
                             /EXCLUSIVE)

;frame
DataFrame = WIDGET_LABEL(data_base,$
                         XOFFSET   = DataFrameSize[0],$
                         YOFFSET   = DataFrameSize[1],$
                         SCR_XSIZE = DataFrameSize[2],$
                         SCR_YSIZE = DataFrameSize[3],$
                         FRAME     = 1,$
                         VALUE='')

END
