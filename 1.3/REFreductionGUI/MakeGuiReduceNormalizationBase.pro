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
NormalizationBGroupList       = [' Yes   ',' No   ']
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
                                 RegionOfInterestLabelSize[1]-7,$
                                 453,30]

;Exclusion peak region / Background -------------------------------------------

XYoff = [-1,60] ;Peak Base and labels
sPeakBase = { size:  [RunsLabelSize[0]+XYoff[0],$
                      RunsLabelSize[1]+XYoff[1],$
                      365,30],$
              frame: 0,$
              uname: 'norm_peak_base',$
              map:   1}

XYoff = [0,7] ;Main label
sPeakMainLabel = { size:  XYoff,$
                   value: 'Peak Exclusion Region:'}
XYoff = [150,0]
sPeakYminLabel = { size: [sPeakMainLabel.size[0]+XYoff[0],$
                          sPeakMainLabel.size[1]+XYoff[1]],$
                   value: 'Ymin:'}
XYoff = [40,-6]
sPeakYminValue = { size: [sPeakYminLabel.size[0]+XYoff[0],$
                          sPeakYminLabel.size[1]+XYoff[1],$
                          50,30],$
                   value: '150',$
                   uname: 'norm_exclusion_low_bin_text'}
XYoff = [50,0]
sPeakYmaxLabel = { size: [sPeakYminValue.size[0]+XYoff[0],$
                          sPeakYminLabel.size[1]+XYoff[1]],$
                   value: 'Ymax:'}
XYoff = [40,0]
sPeakYmaxValue = { size: [sPeakYmaxLabel.size[0]+XYoff[0],$
                          sPeakYminValue.size[1]+XYoff[1],$
                          50,30],$
                   value: '111',$
                   uname: 'norm_exclusion_high_bin_text'}

;Polarization state to use ----------------------------------------------------
XYoff = [10,2]
sPolaStateBase = { size: [sPeakBase.size[0]+$
                          sPeakBase.size[2]+$
                          XYoff[0],$
                          sPeakBase.size[1]+$
                          XYoff[1],$
                          220,60],$
                   uname: 'norm_pola_base',$
                   frame: 1}

XYoff = [10,5]
sPolaCWBgroup = { size: [XYoff[0],$
                         XYoff[1]],$
                  list: ['Same as Data File','Off-Off'],$
                  title: 'Polarization state:',$
                  uname: 'normalization_pola_state',$
                  value: 0}

;Background Base, label and text_field ----------------------------------------
sBackBase = { size:  sPeakBase.size,$
              frame: 0,$
              uname: 'norm_background_base',$
              map:   0}

XYoff = [0,7]                   ;Main label
sBackMainLabel = { size:  XYoff,$
                   value: 'Background Selection File:'}
XYoff = [170,0]
sBackFileValue = { size: [sBackMainLabel.size[0]+XYoff[0],$
                          sBackMainLabel.size[1]+XYoff[1]-6,$
                          453,30],$
                   value: '',$
                   uname: 'norm_back_selection_file_value'}

;Background Flag  
XYoff = [0,10]             
BackgroundLabelSize = [sPeakBase.size[0]+XYoff[0],$
                       sPeakBase.size[1]+sPeakBase.size[3]+XYoff[1]]
BackgroundLabelTitle = 'Background:'
d_L_T_3 = 100
BackgroundBGroupSize = [BackgroundLabelSize[0]+d_L_T_3,$
                        BackgroundLabelSize[1]-5]
BackgroundBGroupList = [' Yes    ',' No    ']

;******************************************************************************
;Create GUI

NormalizationYesNoBase = WIDGET_BASE(REDUCE_BASE,$
                                     UNAME     = 'reduce_normalization_base',$
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
                            UNAME     = $
                            'reduce_normalization_runs_text_field',$
                            VALUE     = '',$
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
  WIDGET_LABEL(normalization_base,$
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
               VALUE     = '',$
               /ALIGN_LEFT)
  
;Polarization state to use ----------------------------------------------------
pola_base = WIDGET_BASE(normalization_base,$
                        XOFFSET   = sPolaStateBase.size[0],$
                        YOFFSET   = sPolaStateBase.size[1],$
                        SCR_XSIZE = sPolaStateBase.size[2],$
                        SCR_YSIZE = sPolaStateBase.size[3],$
                        UNAME     = sPolaStateBase.uname,$
                        FRAME     = sPolaStateBase.frame)
                        
pola_group = CW_BGROUP(pola_base,$
                       sPolaCWBgroup.list,$
                       XOFFSET   = sPolaCWBgroup.size[0],$
                       YOFFSET   = sPolaCWBgroup.size[1],$
                       LABEL_TOP = sPolaCWBgroup.title,$
                       UNAME     = sPolaCWBgroup.uname,$
                       SET_VALUE = sPolaCWBgroup.value,$
                       /ROW,$
                       /EXCLUSIVE)

;Peak exlusion Base -----------------------------------------------------------
wPeakBase = WIDGET_BASE(normalization_base,$
                        XOFFSET   = sPeakBase.size[0],$
                        YOFFSET   = sPeakBase.size[1],$
                        SCR_XSIZE = sPeakBase.size[2],$
                        SCR_YSIZE = sPeakBase.size[3],$
                        FRAME     = sPeakBase.frame,$
                        UNAME     = sPeakBase.uname,$
                        MAP       = sPeakBase.map)

wPeakMainLabel = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakMainLabel.size[0],$
                              YOFFSET = sPeakMainLabel.size[1],$
                              VALUE   = sPeakMainLabel.value)

wPeakYminLabel = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakYminLabel.size[0],$
                              YOFFSET = sPeakYminLabel.size[1],$
                              VALUE   = sPeakYminLabel.value)

wPeakYminValue = WIDGET_LABEL(wPeakBase,$
                              XOFFSET   = sPeakYminValue.size[0],$
                              YOFFSET   = sPeakYminValue.size[1],$
                              SCR_XSIZE = sPeakYminValue.size[2],$
                              SCR_YSIZE = sPeakYminValue.size[3],$
                              VALUE     = sPeakYminValue.value,$
                              UNAME     = sPeakYminValue.uname,$
                              /ALIGN_LEFT)

wPeakYmaxLabel = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakYmaxLabel.size[0],$
                              YOFFSET = sPeakYmaxLabel.size[1],$
                              VALUE   = sPeakYmaxLabel.value)

wPeakYmaxValue = WIDGET_LABEL(wPeakBase,$
                              XOFFSET   = sPeakYmaxValue.size[0],$
                              YOFFSET   = sPeakYmaxValue.size[1],$
                              SCR_XSIZE = sPeakYmaxValue.size[2],$
                              SCR_YSIZE = sPeakYmaxValue.size[3],$
                              UNAME     = sPeakYmaxValue.uname,$
                              VALUE     = sPeakYmaxValue.value,$
                              /ALIGN_LEFT)

;Background exlusion Base -----------------------------------------------------
wBackBase = WIDGET_BASE(normalization_base,$
                        XOFFSET   = sBackBase.size[0],$
                        YOFFSET   = sBackBase.size[1],$
                        SCR_XSIZE = sBackBase.size[2],$
                        SCR_YSIZE = sBackBase.size[3],$
                        FRAME     = sBackBase.frame,$
                        UNAME     = sBackBase.uname,$
                        MAP       = sBackBase.map)

wBackMainLabel = WIDGET_LABEL(wBackBase,$
                              XOFFSET = sBackMainLabel.size[0],$
                              YOFFSET = sBackMainLabel.size[1],$
                              VALUE   = sBackMainLabel.value)

wBackFileValue = WIDGET_LABEL(wBackBase,$
                              XOFFSET   = sBackFileValue.size[0],$
                              YOFFSET   = sBackFileValue.size[1],$
                              SCR_XSIZE = sBackFileValue.size[2],$
                              SCR_YSIZE = sBackFileValue.size[3],$
                              VALUE     = sBackFileValue.value,$
                              UNAME     = sBackFileValue.uname,$
                              /ALIGN_LEFT)

;background flag
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
