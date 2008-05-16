PRO MakeGuiReduceNormalizationBase, Event, REDUCE_BASE, IndividualBaseWidth

;yes or not base
NormalizationYesNoBaseSize = [0,185,IndividualBaseWidth,40]

;yes or not offset
NormalizationBGroupLabelSize = [10,5]
NormalizationBGroupLabelTitle = 'N O R M A L I Z A T I O N:'
NormalizationBGroupList = [' Yes    ',' No    ']
d1=190
NormalizationBGroupSize = [NormalizationBGroupLabelSize[0]+d1,$
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
RegionOfInterestLabelSize = [RunsLabelSize[0],$
                             RunsLabelSize[1]+d_vertical_L_L]
RegionOfInterestLabelTitle = 'Region of interest (ROI) file:'
RegionOfInterestTextFieldSize = [230,$
                                 RegionOfInterestLabelSize[1]-5,$
                                 453,30]
                             
;Exclusion peak region
ExclusionPeakRegionLabelSize = [RunsLabelSize[0],$
                                RegionOfInterestLabelSize[1]+d_vertical_L_L]
ExclusionPeakRegionLabelTitle = 'Exclusion Peak Region:'

;low bin
ExclusionLowBinLabelSize = [ExclusionPeakRegionLabelSize[0]+200,$
                            ExclusionPeakRegionLabelSize[1]]
ExclusionLowBinLabelTitle = 'Low bin:'
d_L_T_2 = d_L_T + 10
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


;*********************************************************
;Create GUI

NormalizationYesNoBase = widget_base(REDUCE_BASE,$
                                     xoffset=NormalizationYesNoBaseSize[0],$
                                     yoffset=NormalizationYesNoBaseSize[1],$
                                     scr_xsize=NormalizationYesNoBaseSize[2],$
                                     scr_ysize=NormalizationyesNoBaseSize[3])
                                     
;normalization yes or no
NormalizationBGroupLabel = widget_label(NormalizationYesNoBase,$
                                        xoffset=NormalizationBGroupLabelSize[0],$
                                        yoffset=NormalizationBGroupLabelSize[1],$
                                        value=NormalizationBGroupLabelTitle)

NormalizationBGroup = cw_bgroup(NormalizationYesNoBase,$
                                NormalizationBGroupList,$
                                xoffset=NormalizationBGroupSize[0],$
                                yoffset=NormalizationBGroupSize[1],$
                                /exclusive,$
                                row=1,$
                                uname='yes_no_normalization_bgroup',$
                                set_value=0)

;base
normalization_base = widget_base(REDUCE_BASE,$
                                 uname='normalization_base',$
                                 xoffset=NormalizationBaseSize[0],$
                                 yoffset=NormalizationBaseSize[1],$
                                 scr_xsize=NormalizationBaseSize[2],$
                                 scr_ysize=NormalizationBaseSize[3])

;Normalization main label
NormalizationLabel = widget_label(normalization_base,$
                                  xoffset=NormalizationLabelSize[0],$
                                  yoffset=NormalizationLabelSize[1],$
                                  value=NormalizationLabelTitle)

;runs label
RunsLabel = widget_label(normalization_base,$
                         xoffset=RunsLabelSize[0],$
                         yoffset=RunsLabelSize[1],$
                         value=RunsLabelTitle)

;runs text field
RunsTextField = widget_text(normalization_base,$
                            xoffset=RunsTextFieldSize[0],$
                            yoffset=RunsTextFieldSize[1],$
                            scr_xsize=RunsTextFieldSize[2],$
                            scr_ysize=RunsTextFieldSize[3],$
                            /editable,$
                            /align_left,$
                            /all_events,$
                            uname='reduce_normalization_runs_text_field')

;region of interest label
RegionOfInterestLabel = widget_label(normalization_base,$
                                     xoffset=RegionOfInterestLabelSize[0],$
                                     yoffset=RegionOfInterestLabelSize[1],$
                                     value=RegionOfInterestLabelTitle)

;region of interest text field
RegionOfInterestTextField = widget_text(normalization_base,$
                                        xoffset=RegionOfInterestTextFieldSize[0],$
                                        yoffset=RegionOfInterestTextFieldSize[1],$
                                        scr_xsize=RegionOfInterestTextFieldSize[2],$
                                        scr_ysize=RegionOfInterestTextFieldSize[3],$
                                        /align_left,$
                                        uname='reduce_normalization_region_of_interest_file_name')

;exclusion peak region
ExclusionPeakRegionLabel = widget_label(normalization_base,$
                                        xoffset=ExclusionPeakRegionLabelSize[0],$
                                        yoffset=ExclusionPeakRegionLabelSize[1],$
                                        value=ExclusionPeakRegionLabelTitle)

;exclusion low bin
ExclusionLowBinLabel = widget_label(normalization_base,$
                                    xoffset=ExclusionLowBinLabelSize[0],$
                                    yoffset=ExclusionLowBinLabelSize[1],$
                                    value=ExclusionLowBinLabelTitle)

;exclusion low bin text field
ExclusionLowBinTextField = widget_text(normalization_base,$
                                       uname='norm_exclusion_low_bin_text',$
                                       xoffset=ExclusionLowBinTextFieldSize[0],$
                                       yoffset=ExclusionLowBinTextFieldSize[1],$
                                       scr_xsize=ExclusionLowBinTExtFieldSize[2],$
                                       scr_ysize=ExclusionLowBinTextFieldSize[3],$
                                       /align_left)

;exclusion high bin
ExclusionHighBinLabel = widget_label(normalization_base,$
                                     xoffset=ExclusionHighBinLabelSize[0],$
                                     yoffset=ExclusionHighBinLabelSize[1],$
                                     value=ExclusionHighBinLabelTitle)

;exclusion High bin text field
ExclusionHighBinTextField = widget_text(normalization_base,$
                                        uname='norm_exclusion_high_bin_text',$
                                        xoffset=ExclusionHighBinTextFieldSize[0],$
                                        yoffset=ExclusionHighBinTextFieldSize[1],$
                                        scr_xsize=ExclusionHighBinTExtFieldSize[2],$
                                        scr_ysize=ExclusionHighBinTextFieldSize[3],$
                                        /align_left)

;background
BackgroundLabel = widget_label(normalization_base,$
                               xoffset=BackgroundLabelSize[0],$
                               yoffset=BackgroundLabelSize[1],$
                               value=BackgroundLabelTitle)

BackgroundBGroup = cw_bgroup(normalization_base,$
                             BackgroundBGroupList,$
                             /exclusive,$
                             xoffset=BackgroundBGroupSize[0],$
                             yoffset=BackgroundBGroupSize[1],$
                             set_value=0,$
                             uname='normalization_background_cw_bgroup',$
                             row=1)

;frame
NormalizationFrame = widget_label(normalization_base,$
                         xoffset=NormalizationFrameSize[0],$
                         yoffset=NormalizationFrameSize[1],$
                         scr_xsize=NormalizationFrameSize[2],$
                         scr_ysize=NormalizationFrameSize[3],$
                         frame=1,$
                         value='')





END
