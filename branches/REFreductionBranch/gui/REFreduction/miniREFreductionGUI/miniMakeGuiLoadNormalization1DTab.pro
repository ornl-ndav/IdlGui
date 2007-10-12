PRO miniMakeGuiLoadNormalization1DTab, D_DD_Tab, $
                                   D_DD_TabSize, $
                                   D_DD_TabTitle, $
                                   GlobalLoadGraphs, $
                                   loadctList

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
normYminLabelSize  = [20, $
                      30, $
                      100, $
                      25]
normYminLabelTitle = '  Ymin  '
normYmaxLabelSize  = [normYminLabelSize[0]+140,$
                      normYminLabelSize[1],$
                      normYminLabelSize[2],$
                      normYminLabelSize[3]]
normYmaxLabelTitle = '  Ymax  '
 
d_L_B= 85
BaseLengthYmin = 90
BaseLengthYmax = 120
BaseHeight = 35

;cw_bgroup of selection (back or signal)
Norm1DSelectionList    = ['Select Back.   ',$
                          'Select Peak    ',$
                          'Zoom ']
Norm1DSelectionBaseSize = [5, $
                           0, $
                           400, $
                           30]
Norm1DSelectionSize     = [5, 0]

;Background Ymin and Ymax bases and cw_fields
;Ymin base and cw_field
Norm1DSelectionBackgroundLabelSize    = [5,80]
Norm1DSelectionBackgroundLabelTitle   = 'Back. range:' 
Norm1DSelectionBackgroundYminBaseSize = [Norm1DSelectionBackgroundLabelSize[0]+d_L_B,$
                                         Norm1DSelectionBackgroundLabelSize[1]-9,$
                                         BaseLengthYmin,BaseHeight]
Norm1DSelectionBackgroundYminCWFieldSize  = [5,25]
Norm1DSelectionBackgroundYminCWFieldTitle = 'Ymin:'
;Ymax base and cw_field
Norm1DSelectionBackgroundYmaxBaseSize = [Norm1DSelectionBackgroundYminBaseSize[0]+$
                                         Norm1DSelectionBackgroundYminBasesize[2]+10,$
                                         Norm1DSelectionBackgroundYminBaseSize[1],$
                                         BaseLengthYmax-9,BaseHeight]
Norm1DSelectionBackgroundYmaxCWFieldSize  = Norm1DSelectionBackgroundYminCWFieldSize
Norm1DSelectionBackgroundYmaxCWFieldTitle = ' Ymax:'

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
NormBackgroundSelectionFileLabelSize  = [5,150]
NormBackgroundSelectionFileLabelTitle = 'File:'
d_L_B_2 = 40
NormBackgroundSelectionFileTextFieldSize = [NormBackgroundSelectionFileLabelSize[0]+d_L_B_2,$
                                            NormBackgroundSelectionFileLabelSize[1]-4,$
                                            250,30]

;frame surrounding Background
BackFrameSize = [2,65,298,115]

;Peak Ymin and Ymax bases and cw_fields
d_vertical_L_L = 60
Norm1DSelectionPeakLabelSize  = [5,200]
Norm1DSelectionPeakLabelTitle = 'Peak Exclusion:' 
Norm1DSelectionPeakYminBaseSize = [Norm1DSelectionPeakLabelSize[0]+100,$
                                   Norm1DSelectionPeakLabelSize[1]-9,$
                                   BaseLengthYmin,BaseHeight]
Norm1DSelectionPeakYminCWFieldSize  = Norm1DSelectionBackgroundYmaxCWFieldSize
Norm1DSelectionPeakYminCWFieldTitle = 'Ymin:'

;Ymax base and cw_field
Norm1DSelectionPeakYmaxBaseSize = [Norm1DSelectionPeakYminBaseSize[0]+$
                                   Norm1DSelectionPeakYminBasesize[2],$
                                   Norm1DSelectionPeakYminBaseSize[1],$
                                   BaseLengthYmax,BaseHeight]
Norm1DSelectionPeakYmaxCWFieldSize  = Norm1DSelectionPeakYminCWFieldSize
Norm1DSelectionPeakYmaxCWFieldTitle = ' Ymax:'

;Save Pixel vs TOF (using uncombined format)
x1 = 120
Norm1DPixelTOFOutputButtonSize = [Norm1DSelectionPeakYmaxBaseSize[0]+x1,$
                                  Norm1DSelectionPeakYmaxBaseSize[1]+3,$
                                  220,30]
Norm1DPixelTOFOutputButtonTitle = 'Output Pixel vs TOF ASCII file'

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
Load_Normalization_D_TAB_BASE = $
  WIDGET_BASE(D_DD_Tab,$
              UNAME     = 'load_normalization_d_tab_base',$
              TITLE     = D_DD_TabTitle[0],$
              XOFFSET   = D_DD_TabSize[0],$
              YOFFSET   = D_DD_TabSize[1],$
              SCR_XSIZE = D_DD_TabSize[2],$
              SCR_YSIZE = D_DD_TabSize[3])

load_normalization_D_draw = $
  WIDGET_DRAW(load_normalization_D_tab_base,$
              XOFFSET   = GlobalLoadGraphs[0],$
              YOFFSET   = GlobalLoadGraphs[1],$
              SCR_XSIZE = GlobalLoadGraphs[2],$
              SCR_YSIZE = GlobalLoadGraphs[3],$
              UNAME     = 'load_normalization_D_draw',$
              RETAIN    = 2,$
              /BUTTON_EVENTS,$
              /MOTION_EVENTS)

;create the back/peak and rescale tab
BackPeakRescaleTab = $
  WIDGET_TAB(load_normalization_D_tab_base,$
             UNAME     = 'norm_back_peak_rescale_tab',$
             XOFFSET   = BackPeakRescaleTabSize[0],$
             YOFFSET   = BackPeakRescaleTabSize[1],$
             SCR_XSIZE = BackPeakRescaleTabSize[2],$
             SCR_YSIZE = BackPeakRescaleTabSize[3],$
             LOCATION  = 0)

BackPeakBase = WIDGET_BASE(BackPeakRescaleTab,$
                           UNAME     = 'norm_back_peak_base',$
                           XOFFSET   = BackPeakBaseSize[0],$
                           YOFFSET   = BackPeakBaseSize[1],$
                           SCR_XSIZE = BackPeakBaseSize[2],$
                           SCR_YSIZE = BackPeakBaseSize[3],$
                           TITLE     = BackPeakBaseTitle)

;create the widgets for the selection
Norm1DselectionBase = WIDGET_BASE(BackPeakBase,$
                                  UNAME     = 'normalization_1d_selection_base',$
                                  XOFFSET   = Norm1DSelectionBaseSize[0],$
                                  YOFFSET   = Norm1DSelectionBaseSize[1],$
                                  SCR_XSIZE = Norm1DSelectionBaseSize[2],$
                                  SCR_YSIZE = Norm1DSelectionBaseSize[3])

Norm1DSelection = CW_BGROUP(Norm1DSelectionBase,$
                            Norm1DSelectionList,$
                            /EXCLUSIVE,$
                            /RETURN_NAME,$
                            XOFFSET   = Norm1DSelectionSize[0],$
                            YOFFSET   = Norm1DSelectionSize[1],$
                            SET_VALUE = 0.0,$
                            row       = 1,$
                            FONT      = 'lucidasans-10',$
                            UNAME     = 'normalization_1d_selection')

NormYminLabel = WIDGET_LABEL(BackPeakBase,$
                             UNAME     = 'normalization_ymin_label_frame',$
                             XOFFSET   = NormYminLabelSize[0],$
                             YOFFSET   = NormYminLabelSize[1],$
                             SCR_XSIZE = NormYminLabelSize[2],$
                             SCR_YSIZE = NormYminLabelSize[3],$
                             VALUE     = NormYminLabelTitle,$
                             FRAME     = 2,$
                             SENSITIVE = 0)

NormYmaxLabel = WIDGET_LABEL(BackPeakBase,$
                             UNAME     = 'normalization_ymax_label_frame',$
                             XOFFSET   = NormYmaxLabelSize[0],$
                             YOFFSET   = NormYmaxLabelSize[1],$
                             SCR_XSIZE = NormYmaxLabelSize[2],$
                             SCR_YSIZE = NormYmaxLabelSize[3],$
                             VALUE     = NormYmaxLabelTitle,$
                             FRAME     = 2,$
                             SENSITIVE = 0)

;background selection
Norm_1d_selection_background_label = $
  WIDGET_LABEL(BackPeakBase,$
               XOFFSET = Norm1DSelectionBackgroundLabelSize[0],$
               YOFFSET = Norm1DSelectionBackgroundLabelSize[1],$
               VALUE   = Norm1DSelectionBackgroundLabelTitle)

Norm1DSelectionBackgroundYminBase = $
  WIDGET_BASE(BackPeakBase,$
              XOFFSET   = Norm1DSelectionBackgroundYminBaseSize[0],$
              YOFFSET   = Norm1DSelectionBackgroundYminBaseSize[1],$
              SCR_XSIZE = Norm1DSelectionBackgroundYminBaseSize[2],$
              SCR_YSIZE = Norm1DSelectionBackgroundYminBaseSize[3],$
              UNAME     = 'Norm1SelectionBackgroundYminBase')

Norm1DSelectionBackgroundYminCWField = $
  CW_FIELD(Norm1DSelectionBackgroundYminBase,$
           ROW           = 1,$
           XSIZE         = Norm1DSelectionBackgroundYminCWFieldSize[0],$
           YSIZE         = Norm1DSelectionBackgroundYminCWFieldSize[1],$
           /INTEGER,$
           RETURN_EVENTS = 1,$
           TITLE         = Norm1DSelectionBackgroundYminCWFieldTitle,$
           UNAME         = 'normalization_d_selection_background_ymin_cw_field')

Norm1DSelectionBackgroundYmaxBase = $
  WIDGET_BASE(BackPeakBase,$
              XOFFSET   = Norm1DSelectionBackgroundYmaxBaseSize[0],$
              YOFFSET   = Norm1DSelectionBackgroundYmaxBaseSize[1],$
              SCR_XSIZE = Norm1DSelectionBackgroundYmaxBaseSize[2],$
              SCR_YSIZE = Norm1DSelectionBackgroundYmaxBaseSize[3],$
              UNAME     = 'Norm1SelectionBackgroundYmaxBase')

Norm1DSelectionBackgroundYmaxCWField = $
  CW_FIELD(Norm1DSelectionBackgroundYmaxBase,$
           ROW           = 1,$
           XSIZE         = Norm1DSelectionBackgroundYmaxCWFieldSize[0],$
           YSIZE         = Norm1DSelectionBackgroundYmaxCWFieldSize[1],$
           /INTEGER,$
           RETURN_EVENTS = 1,$
           TITLE         = Norm1DSelectionBackgroundYmaxCWFieldTitle,$
           UNAME         = 'normalization_d_selection_background_ymax_cw_field')

SaveButton = WIDGET_BUTTON(BackPeakBase,$,$
                           XOFFSET   = SaveButtonSize[0],$
                           YOFFSET   = SaveButtonSize[1],$
                           SCR_XSIZE = SaveButtonSize[2],$
                           SCR_YSIZE = SaveButtonSize[3],$
                           VALUE     = SaveButtonTitle,$
                           UNAME     = 'normalization_roi_save_button',$
                           SENSITIVE = 0)
                           
LoadButton = WIDGET_BUTTON(BackPeakBase,$,$
                           XOFFSET   = LoadButtonSize[0],$
                           YOFFSET   = LoadButtonSize[1],$
                           SCR_XSIZE = LoadButtonSize[2],$
                           SCR_YSIZE = LoadButtonSize[3],$
                           VALUE     = LoadButtonTitle,$
                           UNAME     = 'normalization_roi_load_button',$
                           SENSITIVE = 0)
                           
NormBackgroundSelectionFileLabel = $
  WIDGET_LABEL(BackPeakBase,$
               XOFFSET = NormBackgroundSelectionFileLabelSize[0],$
               YOFFSET = NormBackgroundSelectionFileLabelSize[1],$ 
               VALUE   = NormBackgroundSelectionFileLabelTitle)

NormBackgroundSelectionFileTextField = $
  WIDGET_TEXT(BackPeakBase,$
              XOFFSET   = NormBackgroundSelectionFileTextFieldSize[0],$
              YOFFSET   = NormBackgroundSelectionFileTextFieldSize[1],$
              SCR_XSIZE = NormBackgroundSelectionFileTextFieldSize[2],$
              SCR_YSIZE = NormBackgroundSelectionFileTextFieldSize[3],$
              UNAME     = 'normalization_background_selection_file_text_field',$
              /ALIGN_LEFT,$
              /EDITABLE,$
              SENSITIVE = 0)

BackFrame = WIDGET_LABEL(BackPeakBase,$
                         XOFFSET   = BackFrameSize[0],$
                         YOFFSET   = BackFrameSize[1],$
                         SCR_XSIZE = BackFrameSize[2],$
                         SCR_YSIZE = BackFrameSize[3],$
                         FRAME     = 1,$
                         VALUE     = '')

;Peak exclusion
norm_1d_selection_peak_label = $
  WIDGET_LABEL(BackPeakBase,$
               XOFFSET = Norm1DSelectionPeakLabelSize[0],$
               YOFFSET = Norm1DSelectionPeakLabelSize[1],$
               VALUE   = Norm1DSelectionPeakLabelTitle)

Norm1DSelectionPeakYminBase = $
  WIDGET_BASE(BackPeakBase,$
              XOFFSET   = Norm1DSelectionPeakYminBaseSize[0],$
              YOFFSET   = Norm1DSelectionPeakYminBaseSize[1],$
              SCR_XSIZE = Norm1DSelectionPeakYminBaseSize[2],$
              SCR_YSIZE = Norm1DSelectionPeakYminBaseSize[3],$
              UNAME     = 'Norm1SelectionPeakYminBase')

Norm1DSelectionPeakYminCWField = $
  CW_FIELD(Norm1DSelectionPeakYminBase,$
           ROW           = 1,$
           XSIZE         = Norm1DSelectionPeakYminCWFieldSize[0],$
           YSIZE         = Norm1DSelectionPeakYminCWFieldSize[1],$
           /INTEGER,$
           RETURN_EVENTS = 1,$
           TITLE         = Norm1DSelectionPeakYminCWFieldTitle,$
           UNAME         = 'normalization_d_selection_peak_ymin_cw_field')

Norm1DSelectionPeakYmaxBase = $
  WIDGET_BASE(BackPeakBase,$
              XOFFSET   = Norm1DSelectionPeakYmaxBaseSize[0],$
              YOFFSET   = Norm1DSelectionPeakYmaxBaseSize[1],$
              SCR_XSIZE = Norm1DSelectionPeakYmaxBaseSize[2],$
              SCR_YSIZE = Norm1DSelectionPeakYmaxBaseSize[3],$
              UNAME     = 'Norm1SelectionPeakYmaxBase')

Norm1DSelectionPeakYmaxCWField = $
  CW_FIELD(Norm1DSelectionPeakYmaxBase,$
           ROW           = 1,$
           XSIZE         = Norm1DSelectionPeakYmaxCWFieldSize[0],$
           YSIZE         = Norm1DSelectionPeakYmaxCWFieldSize[1],$
           /INTEGER,$
           RETURN_EVENTS = 1,$
           TITLE         = Norm1DSelectionPeakYmaxCWFieldTitle,$
           UNAME         = 'normalization_d_selection_peak_ymax_cw_field')


;Tab #2 (contrast base)
ContrastBase = WIDGET_BASE(BackPeakRescaleTab,$
                           UNAME     = 'normalization_rescale_base',$
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
                                   UNAME     = 'normalization_contrast_droplist',$
                                   SENSITIVE = 0)

ContrastBottomSlider = WIDGET_SLIDER(ContrastBase,$
                                     XOFFSET   = ContrastBottomSliderSize[0],$
                                     YOFFSET   = ContrastBottomSliderSize[1],$
                                     SCR_XSIZE = ContrastBottomSliderSize[2],$
                                     SCR_YSIZE = ContrastBottomSliderSize[3],$
                                     MINIMUM   = ContrastBottomSliderMin,$
                                     MAXIMUM   = ContrastBottomSliderMax,$
                                     UNAME     = 'normalization_contrast_bottom_slider',$
                                     /TRACKING_EVENTS,$
                                     TITLE     = ContrastBottomSliderTitle,$
                                     VALUE     = ContrastBottomSliderDefaultValue,$
                                     SENSITIVE = 0)

ContrastNumberSlider = WIDGET_SLIDER(ContrastBase,$
                                     XOFFSET   = ContrastNumberSliderSize[0],$
                                     YOFFSET   = ContrastNumberSliderSize[1],$
                                     SCR_XSIZE = ContrastNumberSliderSize[2],$
                                     SCR_YSIZE = ContrastNumberSliderSize[3],$
                                     MINIMUM   = ContrastNumberSliderMin,$
                                     MAXIMUM   = ContrastNumberSliderMax,$
                                     UNAME     = 'normalization_contrast_number_slider',$
                                     /TRACKING_EVENTS,$
                                     TITLE     = ContrastNumberSliderTitle,$
                                     VALUE     = ContrastNumberSliderDefaultValue,$
                                     SENSITIVE = 0)

ResetContrastButton = WIDGET_BUTTON(ContrastBase,$
                                    XOFFSET   = ResetContrastButtonSize[0],$
                                    YOFFSET   = ResetContrastButtonSize[1],$
                                    SCR_XSIZE = ResetContrastButtonSize[2],$
                                    SCR_YSIZE = ResetContrastButtonSize[3],$
                                    VALUE     = ResetContrastButtonTitle,$
                                    UNAME     = 'normalization_reset_contrast_button',$
                                    SENSITIVE = 0)


;Tab #3 (rescale base)
RescaleBase = WIDGET_BASE(BackPeakRescaleTab,$
                          UNAME     = 'normalization_rescale_base',$
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
                           UNAME     = 'normalization_rescale_x_base',$
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
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = 'normalization_rescale_xmin_cwfield')

RescaleXMaxcwfieldBase = WIDGET_BASE(RescaleXBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleXMaxCWField = CW_FIELD(RescaleXMaxcwfieldBase,$
                             XSIZE         = RescaleMaxcwfieldSize[0],$
                             YSIZE         = RescaleMaxcwFieldSize[1],$
                             ROW           = 1,$
                             /FLOAT,$
                             RETURN_EVENTS = 1,$
                             TITLE         = RescaleMaxcwfieldLabel,$
                             UNAME         = 'normalization_rescale_xmax_cwfield')

RescaleXScaleDroplist = WIDGET_DROPLIST(RescaleXBase,$
                                        VALUE     = RescaleScaleDroplist,$
                                        XOFFSET   = RescaleScaleDroplistSize[0],$
                                        YOFFSET   = RescaleScaleDroplistSize[1],$
                                        UNAME     = 'normalization_rescale_x_droplist',$
                                        SENSITIVE = 0)

ResetXScaleButton = WIDGET_BUTTON(RescaleXBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetXScaleButtonTitle,$
                                  UNAME     = 'normalization_reset_xaxis_button',$
                                  SENSITIVE = 0)

;Y base
RescaleYLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET = RescaleYLabelSize[0],$
                             YOFFSET = RescaleYLabelSize[1],$
                             VALUE   = RescaleYLabelTitle)

RescaleYBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'normalization_rescale_Y_base',$
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
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = 'normalization_rescale_ymin_cwfield')
                             
RescaleYMaxcwfieldBase = WIDGET_BASE(RescaleYBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleYMaxCWField = CW_FIELD(RescaleYMaxcwfieldBase,$
                              XSIZE         = RescaleMaxcwfieldSize[0],$
                              YSIZE         = RescaleMaxcwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         ='normalization_rescale_ymax_cwfield')

ResetYScaleButton = WIDGET_BUTTON(RescaleYBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetYScaleButtonTitle,$
                                  UNAME     = 'normalization_reset_yaxis_button',$
                                  SENSITIVE = 0)

;Z base
RescaleZLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET = RescaleZLabelSize[0],$
                             YOFFSET = RescaleZLabelSize[1],$
                             VALUE   = RescaleZLabelTitle)

RescaleZBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'normalization_rescale_Z_base',$
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
                              UNAME         = 'normalization_rescale_zmin_cwfield')

RescaleZMaxcwfieldBase = WIDGET_BASE(RescaleZBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleZMaxCWField = CW_FIELD(RescaleZMaxcwfieldBase,$
                              XSIZE         = RescaleMaxcwfieldSize[0],$
                              YSIZE         = RescaleMaxcwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         = 'normalization_rescale_zmax_cwfield')

RescaleZScaleDroplist = WIDGET_DROPLIST(RescaleZBase,$
                                        VALUE     = RescaleScaleDroplist,$
                                        XOFFSET   = RescaleScaleDroplistSize[0],$
                                        YOFFSET   = RescaleScaleDroplistSize[1],$
                                        UNAME     = 'normalization_rescale_z_droplist',$
                                        SENSITIVE = 0)

ResetZScaleButton = WIDGET_BUTTON(RescaleZBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetZScaleButtonTitle,$
                                  UNAME     = 'normalization_reset_zaxis_button',$
                                  SENSITIVE = 0)

;full reset
FullResetButton = WIDGET_BUTTON(RescaleBase,$
                                XOFFSET   = FullResetButtonSize[0],$
                                YOFFSET   = FullResetButtonSize[1],$
                                SCR_XSIZE = FullResetButtonSize[2],$
                                SCR_YSIZE = FullResetButtonSize[3],$
                                UNAME     = 'normalization_full_reset_button',$
                                VALUE     = FullResetButtonTitle,$
                                SENSITIVE = 0)

END
