PRO miniMakeGuiLoadData1DTab, D_DD_Tab, $
                              D_DD_TabSize, $
                              D_DD_TabTitle, $
                              GlobalLoadGraphs, $
                              LoadctList

;define 3 tabs (Back/Signal Selection, Contrast and Rescale)

BackPeakRescaleTabSize = [4, $
                          305, $;610
                          310, $
                          253] ;-640

;###############################################################################
;############################ TAB #1 ###########################################

BackPeakBaseSize       = [0, $
                          0, $
                          BackPeakRescaleTabSize[2],$
                          BackPeakRescaleTabSize[3]]

BackPeakBaseTitle      = 'Selection/Zoom'

;Y_min and Y_max labels
dataYminLabelSize  = [20, $
                      30, $
                      100, $
                      25]
dataYminLabelTitle = '  Ymin  '
dataYmaxLabelSize  = [dataYminLabelSize[0]+140,$
                      dataYminLabelSize[1],$
                      dataYminLabelSize[2],$
                      dataYminLabelSize[3]]
dataYmaxLabelTitle = '  Ymax  '
 
d_L_B= 85
BaseLengthYmin = 90
BaseLengthYmax = 120
BaseHeight = 35

;cw_bgroup of selection (back or signal)
Data1DSelectionList    = ['Select Back.   ',$
                          'Select Peak    ',$
                          'Zoom ']
Data1DSelectionBaseSize = [5, $
                           0, $
                           400, $
                           30]
Data1DSelectionSize     = [5, 0]

;Background Ymin and Ymax bases and cw_fields
;Ymin base and cw_field
Data1DSelectionBackgroundLabelSize    = [5,80]
Data1DSelectionBackgroundLabelTitle   = 'Back. range:' 
Data1DSelectionBackgroundYminBaseSize = [Data1DSelectionBackgroundLabelSize[0]+d_L_B,$
                                         Data1DSelectionBackgroundLabelSize[1]-9,$
                                         BaseLengthYmin,BaseHeight]
Data1DSelectionBackgroundYminCWFieldSize  = [5,25]
Data1DSelectionBackgroundYminCWFieldTitle = 'Ymin:'
;Ymax base and cw_field
Data1DSelectionBackgroundYmaxBaseSize = [Data1DSelectionBackgroundYminBaseSize[0]+$
                                         Data1DSelectionBackgroundYminBasesize[2]+10,$
                                         Data1DSelectionBackgroundYminBaseSize[1],$
                                         BaseLengthYmax-9,BaseHeight]
Data1DSelectionBackgroundYmaxCWFieldSize  = Data1DSelectionBackgroundYminCWFieldSize
Data1DSelectionBackgroundYmaxCWFieldTitle = ' Ymax:'

;SAVE and LOAD buttons
SaveLoadButtonSize  = [110,30]
SaveButtonSize      = [20,110,$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
SaveButtonTitle     = 'S A V E'  
LoadButtonSize      = [SaveButtonSize[0]+SaveLoadButtonSize[0]+25,$
                       SaveButtonSize[1],$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
LoadButtonTitle     = 'L O A D'

;Background ROI file
d_vertical_L_L = 70
DataBackgroundSelectionFileLabelSize  = [5,150]
DataBackgroundSelectionFileLabelTitle = 'File:'
d_L_B_2 = 40
DataBackgroundSelectionFileTextFieldSize = [DataBackgroundSelectionFileLabelSize[0]+d_L_B_2,$
                                            DataBackgroundSelectionFileLabelSize[1]-4,$
                                            250,30]

;frame surrounding Background
BackFrameSize = [2,65,298,115]

;Peak Ymin and Ymax bases and cw_fields
d_vertical_L_L = 60
Data1DSelectionPeakLabelSize  = [5,200]
Data1DSelectionPeakLabelTitle = 'Peak Exclusion:' 
Data1DSelectionPeakYminBaseSize = [Data1DSelectionPeakLabelSize[0]+100,$
                                   Data1DSelectionPeakLabelSize[1]-9,$
                                   BaseLengthYmin,BaseHeight]
Data1DSelectionPeakYminCWFieldSize  = Data1DSelectionBackgroundYmaxCWFieldSize
Data1DSelectionPeakYminCWFieldTitle = 'Ymin:'

;Ymax base and cw_field
Data1DSelectionPeakYmaxBaseSize = [Data1DSelectionPeakYminBaseSize[0]+$
                                   Data1DSelectionPeakYminBasesize[2],$
                                   Data1DSelectionPeakYminBaseSize[1],$
                                   BaseLengthYmax,BaseHeight]
Data1DSelectionPeakYmaxCWFieldSize  = Data1DSelectionPeakYminCWFieldSize
Data1DSelectionPeakYmaxCWFieldTitle = ' Ymax:'

;Save Pixel vs TOF (using uncombined format)
x1 = 120
Data1DPixelTOFOutputButtonSize = [Data1DSelectionPeakYmaxBaseSize[0]+x1,$
                                  Data1DSelectionPeakYmaxBaseSize[1]+3,$
                                  220,30]
Data1DPixelTOFOutputButtonTitle = 'Output Pixel vs TOF ASCII file'

;###############################################################################
;################################## Tab #2 #####################################

ContrastBaseSize       = BackPeakBaseSize
ContrastBaseTitle      = 'Contrast Editor'

;TAB #2 (Contrast Editor)
ContrastDropListSize      = [45,15,200,30]

ContrastBottomSliderSize  = [5,ContrastDropListsize[1]+40,290,60]
ContrastBottomSliderTitle = 'Left Range'
ContrastBottomSliderMin = 0
ContrastBottomSliderMax = 255
ContrastBottomSliderDefaultValue = ContrastBottomSliderMin

ContrastNumberSliderSize  = [5,ContrastBottomSliderSize[1]+55,290,60]
ContrastNumberSliderTitle = 'Number color' 
ContrastNumberSliderMin = 1
ContrastNumberSliderMax = 255
ContrastNumberSliderDefaultValue = ContrastNumberSliderMax

ResetContrastButtonSize  = [ContrastDropListSize[0]+10,$
                            ContrastNumberSliderSize[1]+65,$
                            175,$
                            30]
ResetContrastButtonTitle = ' RESET FULL CONTRAST SESSION '

;###############################################################################
;######################### Tab #3 ##############################################

RescaleBaseSize        = BackPeakBaseSize
RescaleBaseTitle       = 'Scale/Range'  

RescaleXBaseSize  = [1,8,300,35]
RescaleXLabelSize = [10,0]
RescaleXLabelTitle= 'X-axis' 

Y_base_offset = 65
RescaleYBaseSize  = [1,8+Y_base_offset,RescaleXBaseSize[2],35]
RescaleYLabelSize = [10,0+Y_base_offset]
RescaleYLabelTitle= 'Y-axis' 

RescaleZBaseSize  = [1,8+2*Y_base_offset,RescaleXBaseSize[2],35]
RescaleZLabelSize = [10,0+2*Y_base_offset]
RescaleZLabelTitle= 'Z-axis' 

RescaleMincwfieldBaseSize = [15,0,80,35]
RescaleMincwfieldSize = [4,1]
RescaleMincwfieldLabel = 'Min:'

RescaleMaxcwfieldBaseSize = [90,0,80,35]
RescaleMaxcwfieldSize = [4,1]
RescaleMaxcwfieldLabel = 'Max:'

RescaleScaleDroplistSize = [160,0]
RescaleScaleDropList     = ['linear','log'] 

ResetScaleButtonSize  = [245,3,50,30]
ResetXScaleButtonTitle = 'RESET'
ResetYScaleButtonTitle = 'RESET'
ResetZScaleButtonTitle = 'RESET'

;full reset
FullResetButtonSize = [8,190,290,30]
FullResetButtonTitle= 'FULL RESET'

;TAB #4 (output file)
OutputBaseTitle = 'ASCII File Settings'

OutputFileFolderButtonSize     = [5,5,115,30]
OutputFileFolderButtonTitle    = 'Output File Path:'
yoff = 5
OutputFileFolderTextFieldSize  = [OutputFileFolderButtonSize[0] + $
                                  OutputFileFolderButtonSize[2] + yoff,$
                                  OutputFileFolderButtonSize[1], $
                                  200, $
                                  30]
yoff_vertical = 35
OutputFileNameLabelSize        = [OutputFileFolderButtonSize[0] + 2,$
                                  OutputFileFolderButtonSize[1] + yoff_vertical]
OutputFileNameLabelTitle       = 'Output File Name:'
                                  



;***********************************************************************************
;Build 1D tab
;***********************************************************************************
load_data_D_tab_base = WIDGET_BASE(D_DD_Tab,$
                                   UNAME     = 'load_data_d_tab_base',$
                                   TITLE     = D_DD_TabTitle[0],$
                                   XOFFSET   = D_DD_TabSize[0],$
                                   YOFFSET   = D_DD_TabSize[1],$
                                   SCR_XSIZE = D_DD_TabSize[2],$
                                   SCR_YSIZE = D_DD_TabSize[3])

load_data_D_draw = WIDGET_DRAW(load_data_D_tab_base,$
                               XOFFSET   = GlobalLoadGraphs[0],$
                               YOFFSET   = GlobalLoadGraphs[1],$
                               SCR_XSIZE = GlobalLoadGraphs[2],$
                               SCR_YSIZE = GlobalLoadGraphs[3],$
                               UNAME     = 'load_data_D_draw',$
                               RETAIN    = 2,$
                               /BUTTON_EVENTS,$
                               /MOTION_EVENTS)

;create the back/peak and rescale tab
BackPeakRescaleTab = WIDGET_TAB(load_data_D_tab_base,$
                                UNAME     = 'data_back_peak_rescale_tab',$
                                XOFFSET   = BackPeakRescaleTabSize[0],$
                                YOFFSET   = BackPeakRescaleTabSize[1],$
                                SCR_XSIZE = BackPeakRescaleTabSize[2],$
                                SCR_YSIZE = BackPeakRescaleTabSize[3],$
                                LOCATION  = 0)

BackPeakBase = WIDGET_BASE(BackPeakRescaleTab,$
                           UNAME     = 'data_back_peak_base',$
                           XOFFSET   = BackPeakBaseSize[0],$
                           YOFFSET   = BackPeakBaseSize[1],$
                           SCR_XSIZE = BackPeakBaseSize[2],$
                           SCR_YSIZE = BackPeakBaseSize[3],$
                           TITLE     = BackPeakBaseTitle)

;create the widgets for the selection
Data1DselectionBase = WIDGET_BASE(BackPeakBase,$
                                  UNAME     = 'data_1d_selection_base',$
                                  XOFFSET   = Data1DSelectionBaseSize[0],$
                                  YOFFSET   = Data1DSelectionBaseSize[1],$
                                  SCR_XSIZE = Data1DSelectionBaseSize[2],$
                                  SCR_YSIZE = Data1DSelectionBaseSize[3])

Data1DSelection = CW_BGROUP(Data1DSelectionBase,$
                            Data1DSelectionList,$
                            /EXCLUSIVE,$
                            /RETURN_NAME,$
                            XOFFSET     = Data1DSelectionSize[0],$
                            YOFFSET     = Data1DSelectionSize[1],$
                            SET_VALUE   = 0.0,$
                            ROW         = 1,$
                            FONT        = 'lucidasans-10',$
                            UNAME       = 'data_1d_selection')

dataYminLabel = WIDGET_LABEL(BackPeakBase,$
                             UNAME     = 'data_ymin_label_frame',$
                             XOFFSET   = dataYminLabelSize[0],$
                             YOFFSET   = dataYminLabelSize[1],$
                             SCR_XSIZE = dataYminLabelSize[2],$
                             SCR_YSIZE = dataYminLabelSize[3],$
                             VALUE     = dataYminLabelTitle,$
                             FRAME     = 2,$
                             SENSITIVE = 0)

dataYmaxLabel = WIDGET_LABEL(BackPeakBase,$
                             UNAME     = 'data_ymax_label_frame',$
                             XOFFSET   = dataYmaxLabelSize[0],$
                             YOFFSET   = dataYmaxLabelSize[1],$
                             SCR_XSIZE = dataYmaxLabelSize[2],$
                             SCR_YSIZE = dataYmaxLabelSize[3],$
                             VALUE     = dataYmaxLabelTitle,$
                             FRAME     = 2,$
                             SENSITIVE = 0)

;background selection
Data_1d_selection_background_label = $
  widget_label(BackPeakBase,$
               XOFFSET = Data1DSelectionBackgroundLabelSize[0],$
               YOFFSET = Data1DSelectionBackgroundLabelSize[1],$
               VALUE   = Data1DSelectionBackgroundLabelTitle)

Data1DSelectionBackgroundYminBase = $
  widget_base(BackPeakBase,$
              XOFFSET   = Data1DSelectionBackgroundYminBaseSize[0],$
              YOFFSET   = Data1DSelectionBackgroundYminBaseSize[1],$
              SCR_XSIZE = Data1DSelectionBackgroundYminBaseSize[2],$
              SCR_YSIZE = Data1DSelectionBackgroundYminBaseSize[3],$
              UNAME     = 'Data1SelectionBackgroundYminBase')

Data1DSelectionBackgroundYminCWField = $
  CW_FIELD(Data1DSelectionBackgroundYminBase,$
           ROW           = 1,$
           XSIZE         = Data1DSelectionBackgroundYminCWFieldSize[0],$
           YSIZE         = Data1DSelectionBackgroundYminCWFieldSize[1],$
           RETURN_EVENTS = 1,$
           TITLE         = Data1DSelectionBackgroundYminCWFieldTitle,$
           UNAME         = 'data_d_selection_background_ymin_cw_field',$
           /INTEGER)

Data1DSelectionBackgroundYmaxBase = $
  widget_base(BackPeakBase,$
              XOFFSET   = Data1DSelectionBackgroundYmaxBaseSize[0],$
              YOFFSET   = Data1DSelectionBackgroundYmaxBaseSize[1],$
              SCR_XSIZE = Data1DSelectionBackgroundYmaxBaseSize[2],$
              SCR_YSIZE = Data1DSelectionBackgroundYmaxBaseSize[3],$
              UNAME     = 'Data1SelectionBackgroundYmaxBase')

Data1DSelectionBackgroundYmaxCWField = $
  CW_FIELD(Data1DSelectionBackgroundYmaxBase,$
           ROW           = 1,$
           XSIZE         = Data1DSelectionBackgroundYmaxCWFieldSize[0],$
           YSIZE         = Data1DSelectionBackgroundYmaxCWFieldSize[1],$
           RETURN_EVENTS = 1,$
           TITLE         = Data1DSelectionBackgroundYmaxCWFieldTitle,$
           UNAME         = 'data_d_selection_background_ymax_cw_field',$
           /INTEGER)

SaveButton = widget_button(BackPeakBase,$,$
                           XOFFSET   = SaveButtonSize[0],$
                           YOFFSET   = SaveButtonSize[1],$
                           SCR_XSIZE = SaveButtonSize[2],$
                           SCR_YSIZE = SaveButtonSize[3],$
                           VALUE     = SaveButtonTitle,$
                           UNAME     = 'data_roi_save_button',$
                           SENSITIVE = 0)
                           
LoadButton = widget_button(BackPeakBase,$,$
                           XOFFSET   = LoadButtonSize[0],$
                           YOFFSET   = LoadButtonSize[1],$
                           SCR_XSIZE = LoadButtonSize[2],$
                           SCR_YSIZE = LoadButtonSize[3],$
                           VALUE     = LoadButtonTitle,$
                           UNAME     = 'data_roi_load_button',$
                           SENSITIVE = 0)
                           
DataBackgroundSelectionFileLabel = $
  widget_label(BackPeakBase,$
               XOFFSET = DataBackgroundSelectionFileLabelSize[0],$
               YOFFSET = DataBackgroundSelectionFileLabelSize[1],$ 
               VALUE   = DataBackgroundSelectionFileLabelTitle)

DataBackgroundSelectionFileTextField = $
  widget_Text(BackPeakBase,$
              XOFFSET   = DataBackgroundSelectionFileTextFieldSize[0],$
              YOFFSET   = DataBackgroundSelectionFileTextFieldSize[1],$
              SCR_XSIZE = DataBackgroundSelectionFileTextFieldSize[2],$
              SCR_YSIZE = DataBackgroundSelectionFileTextFieldSize[3],$
              UNAME     ='data_background_selection_file_text_field',$
              SENSITIVE = 0,$
              /ALIGN_LEFT,$
              /EDITABLE)

BackFrame = WIDGET_LABEL(BackPeakBase,$
                         XOFFSET   = BackFrameSize[0],$
                         YOFFSET   = BackFrameSize[1],$
                         SCR_XSIZE = BackFrameSize[2],$
                         SCR_YSIZE = BackFrameSize[3],$
                         FRAME     = 1,$
                         VALUE     = '')

;Peak exclusion
Data_1d_selection_peak_label = $
  WIDGET_LABEL(BackPeakBase,$
               XOFFSET = Data1DSelectionPeakLabelSize[0],$
               YOFFSET = Data1DSelectionPeakLabelSize[1],$
               VALUE   = Data1DSelectionPeakLabelTitle)

Data1DSelectionPeakYminBase = $
  WIDGET_BASE(BackPeakBase,$
              XOFFSET   = Data1DSelectionPeakYminBaseSize[0],$
              YOFFSET   = Data1DSelectionPeakYminBaseSize[1],$
              SCR_XSIZE = Data1DSelectionPeakYminBaseSize[2],$
              SCR_YSIZE = Data1DSelectionPeakYminBaseSize[3],$
              UNAME     = 'Data1SelectionPeakYminBase')

Data1DSelectionPeakYminCWField = $
  CW_FIELD(Data1DSelectionPeakYminBase,$
           ROW           = 1,$
           XSIZE         = Data1DSelectionPeakYminCWFieldSize[0],$
           YSIZE         = Data1DSelectionPeakYminCWFieldSize[1],$
           RETURN_EVENTS = 1,$
           TITLE         = Data1DSelectionPeakYminCWFieldTitle,$
           UNAME         ='data_d_selection_peak_ymin_cw_field',$
           /INTEGER)


Data1DSelectionPeakYmaxBase = $
  widget_base(BackPeakBase,$
              XOFFSET   = Data1DSelectionPeakYmaxBaseSize[0],$
              YOFFSET   = Data1DSelectionPeakYmaxBaseSize[1],$
              SCR_XSIZE = Data1DSelectionPeakYmaxBaseSize[2],$
              SCR_YSIZE = Data1DSelectionPeakYmaxBaseSize[3],$
              UNAME     = 'Data1SelectionPeakYmaxBase')

Data1DSelectionPeakYmaxCWField = $
  CW_FIELD(Data1DSelectionPeakYmaxBase,$
           ROW           = 1,$
           XSIZE         = Data1DSelectionPeakYmaxCWFieldSize[0],$
           YSIZE         = Data1DSelectionPeakYmaxCWFieldSize[1],$
           RETURN_EVENTS = 1,$
           TITLE         = Data1DSelectionPeakYmaxCWFieldTitle,$
           UNAME         = 'data_d_selection_peak_ymax_cw_field',$
           /INTEGER)

;###############################################################################
;########################## Tab #2 #############################################
;####################### contrast base #########################################
;###############################################################################
ContrastBase = WIDGET_BASE(BackPeakRescaleTab,$
                           UNAME     = 'data_contrast_base',$
                           XOFFSET   = ContrastBaseSize[0],$
                           YOFFSET   = ContrastBaseSize[1],$
                           SCR_XSIZE = ContrastBaseSize[2],$
                           SCR_YSIZE = ContrastBaseSize[3],$
                           TITLE     = ContrastBaseTitle)

ContrastDropList = WIDGET_DROPLIST(ContrastBase,$
                                   VALUE     = LoadctList,$
                                   XOFFSET   = ContrastDropListSize[0],$
                                   YOFFSET   = ContrastDropListSize[1],$
                                   SCR_XSIZE = ContrastDropListSize[2],$
                                   SCR_YSIZE = ContrastDropListSize[3],$
                                   /TRACKING_EVENTS,$
                                   UNAME     = 'data_contrast_droplist',$
                                   SENSITIVE = 0)

ContrastBottomSlider = WIDGET_SLIDER(ContrastBase,$
                                     XOFFSET   = ContrastBottomSliderSize[0],$
                                     YOFFSET   = ContrastBottomSliderSize[1],$
                                     SCR_XSIZE = ContrastBottomSliderSize[2],$
                                     SCR_YSIZE = ContrastBottomSliderSize[3],$
                                     MINIMUM   = ContrastBottomSliderMin,$
                                     MAXIMUM   = ContrastBottomSliderMax,$
                                     UNAME     = 'data_contrast_bottom_slider',$
                                     TITLE     = ContrastBottomSliderTitle,$
                                     VALUE     = ContrastBottomSliderDefaultValue,$
                                     SENSITIVE = 0,$
                                     /TRACKING_EVENTS)

ContrastNumberSlider = WIDGET_SLIDER(ContrastBase,$
                                     XOFFSET   = ContrastNumberSliderSize[0],$
                                     YOFFSET   = ContrastNumberSliderSize[1],$
                                     SCR_XSIZE = ContrastNumberSliderSize[2],$
                                     SCR_YSIZE = ContrastNumberSliderSize[3],$
                                     MINIMUM   = ContrastNumberSliderMin,$
                                     MAXIMUM   = ContrastNumberSliderMax,$
                                     UNAME     = 'data_contrast_number_slider',$
                                     TITLE     = ContrastNumberSliderTitle,$
                                     VALUE     = ContrastNumberSliderDefaultValue,$
                                     SENSITIVE = 0,$
                                     /TRACKING_EVENTS)

ResetContrastButton = WIDGET_BUTTON(ContrastBase,$
                                    XOFFSET   = ResetContrastButtonSize[0],$
                                    YOFFSET   = ResetContrastButtonSize[1],$
                                    SCR_XSIZE = ResetContrastButtonSize[2],$
                                    SCR_YSIZE = ResetContrastButtonSize[3],$
                                    VALUE     = ResetContrastButtonTitle,$
                                    SENSITIVE = 0,$
                                    UNAME     = 'data_reset_contrast_button')


;###############################################################################
;########################## Tab #3 #############################################
;####################### Rescale Base  #########################################
;###############################################################################

RescaleBase = WIDGET_BASE(BackPeakRescaleTab,$
                          UNAME     = 'data_rescale_base',$
                          XOFFSET   = RescaleBaseSize[0],$
                          YOFFSET   = RescaleBaseSize[1],$
                          SCR_XSIZE = RescaleBaseSize[2],$
                          SCR_YSIZE = RescaleBaseSize[3],$
                          TITLE     = RescaleBaseTitle)

;X base
RescaleXLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET = RescaleXLabelSize[0],$
                             YOFFSET = RescaleXLabelSize[1],$
                             VALUE   = RescaleXLabelTitle)

RescaleXBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'data_rescale_x_base',$
                           XOFFSET   = RescaleXBaseSize[0],$
                           YOFFSET   = RescaleXBaseSize[1],$
                           SCR_XSIZE = RescaleXBaseSize[2],$
                           SCR_YSIZE = RescaleXBaseSize[3],$
                           FRAME     = 1)

RescaleXMincwfieldBase = WIDGET_BASE(RescaleXBase,$
                                     XOFFSET   = RescaleMincwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMincwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMincwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMincwfieldBaseSize[3])

RescaleXMinCWField = CW_FIELD(RescaleXMincwfieldBase,$
                              XSIZE         = RescaleMincwfieldSize[0],$
                              YSIZE         = RescaleMincwFieldSize[1],$
                              ROW           = 1,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = 'data_rescale_xmin_cwfield',$
                              /FLOAT)

RescaleXMaxcwfieldBase = WIDGET_BASE(RescaleXBase,$
                                     XOFFSET=RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET=RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE=RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE=RescaleMaxcwfieldBaseSize[3])

RescaleXMaxCWField = CW_FIELD(RescaleXMaxcwfieldBase,$
                              XSIZE         = RescaleMaxcwfieldSize[0],$
                              YSIZE         = RescaleMaxcwFieldSize[1],$
                              ROW           = 1,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         = 'data_rescale_xmax_cwfield',$
                              /FLOAT)

RescaleXScaleDroplist = WIDGET_DROPLIST(RescaleXBase,$
                                       VALUE     = RescaleScaleDroplist,$
                                       XOFFSET   = RescaleScaleDroplistSize[0],$
                                       YOFFSET   = RescaleScaleDroplistSize[1],$
                                       UNAME     = 'data_rescale_x_droplist',$
                                       SENSITIVE = 0)

ResetXScaleButton = WIDGET_BUTTON(RescaleXBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetXScaleButtonTitle,$
                                  UNAME     = 'data_reset_xaxis_button',$
                                  SENSITIVE = 0)

;Y base
RescaleYLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET = RescaleYLabelSize[0],$
                             YOFFSET = RescaleYLabelSize[1],$
                             VALUE   = RescaleYLabelTitle)

RescaleYBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'data_rescale_Y_base',$
                           XOFFSET   = RescaleYBaseSize[0],$
                           YOFFSET   = RescaleYBaseSize[1],$
                           SCR_XSIZE = RescaleYBaseSize[2],$
                           SCR_YSIZE = RescaleYBaseSize[3],$
                           FRAME     = 1)

RescaleYMincwfieldBase = WIDGET_BASE(RescaleYBase,$
                                     XOFFSET   = RescaleMincwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMincwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMincwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMincwfieldBaseSize[3])

RescaleYMinCWField = CW_FIELD(RescaleYMincwfieldBase,$
                              XSIZE         = RescaleMincwfieldSize[0],$
                              YSIZE         = RescaleMincwFieldSize[1],$
                              ROW           = 1,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = 'data_rescale_ymin_cwfield',$
                              /FLOAT)

RescaleYMaxcwfieldBase = WIDGET_BASE(RescaleYBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleYMaxCWField = CW_FIELD(RescaleYMaxcwfieldBase,$
                              XSIZE         = RescaleMaxcwfieldSize[0],$
                              YSIZE         = RescaleMaxcwFieldSize[1],$
                              ROW           = 1,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         = 'data_rescale_ymax_cwfield',$
                              /FLOAT)

ResetYScaleButton = WIDGET_BUTTON(RescaleYBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetYScaleButtonTitle,$
                                  UNAME     = 'data_reset_yaxis_button',$
                                  SENSITIVE =0)

;Z base
RescaleZLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET=RescaleZLabelSize[0],$
                             YOFFSET=RescaleZLabelSize[1],$
                             VALUE=RescaleZLabelTitle)

RescaleZBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'data_rescale_Z_base',$
                           XOFFSET   = RescaleZBaseSize[0],$
                           YOFFSET   = RescaleZBaseSize[1],$
                           SCR_XSIZE = RescaleZBaseSize[2],$
                           SCR_YSIZE = RescaleZBaseSize[3],$
                           FRAME     = 1)

RescaleZMincwfieldBase = WIDGET_BASE(RescaleZBase,$
                                     XOFFSET   = RescaleMincwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMincwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMincwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMincwfieldBaseSize[3])

RescaleZMinCWField = CW_FIELD(RescaleZMincwfieldBase,$
                              XSIZE         = RescaleMincwfieldSize[0],$
                              YSIZE         = RescaleMincwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = 'data_rescale_zmin_cwfield')

RescaleZMaxcwfieldBase = WIDGET_BASE(RescaleZBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleZMaxCWField = CW_FIELD(RescaleZMaxcwfieldBase,$
                              XSIZE        = RescaleMaxcwfieldSize[0],$
                              YSIZE        = RescaleMaxcwFieldSize[1],$
                              ROW          = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         = 'data_rescale_zmax_cwfield')


RescaleZScaleDroplist = WIDGET_DROPLIST(RescaleZBase,$
                                        VALUE     = RescaleScaleDroplist,$
                                        XOFFSET   = RescaleScaleDroplistSize[0],$
                                        YOFFSET   = RescaleScaleDroplistSize[1],$
                                        UNAME     = 'data_rescale_z_droplist',$
                                        SENSITIVE = 0)

ResetZScaleButton = WIDGET_BUTTON(RescaleZBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetZScaleButtonTitle,$
                                  UNAME     = 'data_reset_zaxis_button',$
                                  SENSITIVE = 0)

;full reset
FullResetButton = WIDGET_BUTTON(RescaleBase,$
                                XOFFSET   = FullResetButtonSize[0],$
                                YOFFSET   = FullResetButtonSize[1],$
                                SCR_XSIZE = FullResetButtonSize[2],$
                                SCR_YSIZE = FullResetButtonSize[3],$
                                UNAME     = 'data_full_reset_button',$
                                VALUE     = FullResetButtonTitle,$
                                SENSITIVE = 0)

END

