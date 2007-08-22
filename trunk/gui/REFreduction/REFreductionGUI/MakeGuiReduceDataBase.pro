PRO MakeGuiReduceDataBase, Event, REDUCE_BASE, IndividualBaseWidth

;size of Data base
DataBaseSize   = [0,10,IndividualBaseWidth, 170]

DataLabelSize  = [20,2]
DataLabelTitle = 'D A T A'
DataFrameSize  = [10,10,IndividualBaseWidth-30,150]

;runs number
RunsLabelSize     = [33,27]
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

;base
data_base = widget_base(REDUCE_BASE,$
                        xoffset=DataBaseSize[0],$
                        yoffset=DataBaseSize[1],$
                        scr_xsize=DataBaseSize[2],$
                        scr_ysize=DataBaseSize[3])

;Data main label
DataLabel = widget_label(data_base,$
                         xoffset=DataLabelSize[0],$
                         yoffset=DataLabelSize[1],$
                         value=DataLabelTitle)

;runs label
RunsLabel = widget_label(data_base,$
                         xoffset=RunsLabelSize[0],$
                         yoffset=RunsLabelSize[1],$
                         value=RunsLabelTitle)

;runs text field
RunsTextField = widget_text(data_base,$
                            xoffset=RunsTextFieldSize[0],$
                            yoffset=RunsTextFieldSize[1],$
                            scr_xsize=RunsTextFieldSize[2],$
                            scr_ysize=RunsTextFieldSize[3],$
                            /editable,$
                            /align_left,$
                            uname='reduce_data_runs_text_field')

;region of interest label
RegionOfInterestLabel = widget_label(data_base,$
                                     xoffset=RegionOfInterestLabelSize[0],$
                                     yoffset=RegionOfInterestLabelSize[1],$
                                     value=RegionOfInterestLabelTitle)

;region of interest text field
RegionOfInterestTextField = widget_text(data_base,$
                                        xoffset=RegionOfInterestTextFieldSize[0],$
                                        yoffset=RegionOfInterestTextFieldSize[1],$
                                        scr_xsize=RegionOfInterestTextFieldSize[2],$
                                        scr_ysize=RegionOfInterestTextFieldSize[3],$
                                        /align_left,$
                                        uname='reduce_data_region_of_interest_file_name')

;exclusion peak region
ExclusionPeakRegionLabel = widget_label(data_base,$
                                        xoffset=ExclusionPeakRegionLabelSize[0],$
                                        yoffset=ExclusionPeakRegionLabelSize[1],$
                                        value=ExclusionPeakRegionLabelTitle)

;exclusion low bin
ExclusionLowBinLabel = widget_label(data_base,$
                                    xoffset=ExclusionLowBinLabelSize[0],$
                                    yoffset=ExclusionLowBinLabelSize[1],$
                                    value=ExclusionLowBinLabelTitle)

;exclusion low bin text field
ExclusionLowBinTextField = widget_text(data_base,$
                                       xoffset=ExclusionLowBinTextFieldSize[0],$
                                       yoffset=ExclusionLowBinTextFieldSize[1],$
                                       scr_xsize=ExclusionLowBinTExtFieldSize[2],$
                                       scr_ysize=ExclusionLowBinTextFieldSize[3],$
                                       /align_left)


;exclusion high bin
ExclusionHighBinLabel = widget_label(data_base,$
                                     xoffset=ExclusionHighBinLabelSize[0],$
                                     yoffset=ExclusionHighBinLabelSize[1],$
                                     value=ExclusionHighBinLabelTitle)

;exclusion High bin text field
ExclusionHighBinTextField = widget_text(data_base,$
                                       xoffset=ExclusionHighBinTextFieldSize[0],$
                                       yoffset=ExclusionHighBinTextFieldSize[1],$
                                       scr_xsize=ExclusionHighBinTExtFieldSize[2],$
                                       scr_ysize=ExclusionHighBinTextFieldSize[3],$
                                       /align_left)

;background
BackgroundLabel = widget_label(data_base,$
                               xoffset=BackgroundLabelSize[0],$
                               yoffset=BackgroundLabelSize[1],$
                               value=BackgroundLabelTitle)

BackgroundBGroup = cw_bgroup(data_base,$
                             BackgroundBGroupList,$
                             /exclusive,$
                             xoffset=BackgroundBGroupSize[0],$
                             yoffset=BackgroundBGroupSize[1],$
                             set_value=0,$
                             uname='data_background_cw_bgroup',$
                             row=1)



;frame
DataFrame = widget_label(data_base,$
                         xoffset=DataFrameSize[0],$
                         yoffset=DataFrameSize[1],$
                         scr_xsize=DataFrameSize[2],$
                         scr_ysize=DataFrameSize[3],$
                         frame=1,$
                         value='')





END
