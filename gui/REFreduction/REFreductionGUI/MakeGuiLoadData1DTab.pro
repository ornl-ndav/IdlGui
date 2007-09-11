PRO MakeGuiLoadData1DTab, D_DD_Tab, $
                          D_DD_TabSize, $
                          D_DD_TabTitle, $
                          GlobalLoadGraphs, $
                          LoadctList

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;define two tabs (Back/Signal Selection and Rescale)
BackPeakRescaleTabSize = [4,610,D_DD_TabSize[2]-20,D_DD_TabSize[3]-640]
BackPeakBaseSize       = [0,0,BackPeakRescaleTabSize[2],$
                          BackPeakRescaleTabSize[3]]
BackPeakBaseTitle      = '  Background and Peak Selection  '
RescaleBaseSize        = BackPeakBaseSize
RescaleBaseTitle       = '  Contrast Editor  '

;cw_bgroup of selection (back or signal)
Data1DSelectionList    = ['Select Background   ',$
                          'Select Peak   ',$
                          'ZOOM mode  ']
Data1DSelectionBaseSize = [0,0, D_DD_TabSize[2], D_DD_TabSize[3]]
Data1DSelectionSize     = [5, 0]

;Y_min and Y_max labels
dataYminLabelSize  = [385,0,100,25]
dataYminLabelTitle = '  Ymin  '
dataYmaxLabelSize  = [dataYminLabelSize[0]+109,$
                      0,$
                      dataYminLabelSize[2],$
                      dataYminLabelSize[3]]
dataYmaxLabelTitle = '  Ymax  '
 
d_L_B= 170
BaseLengthYmin = 90
BaseLengthYmax = 120
BaseHeight = 35
;Background Ymin and Ymax bases and cw_fields
;Ymin base and cw_field
Data1DSelectionBackgroundLabelSize    = [3,40]
Data1DSelectionBackgroundLabelTitle   = 'Background Range ......... ' 
Data1DSelectionBackgroundYminBaseSize = [Data1DSelectionBackgroundLabelSize[0]+d_L_B,$
                                         Data1DSelectionBackgroundLabelSize[1]-7,$
                                         BaseLengthYmin,BaseHeight]
Data1DSelectionBackgroundYminCWFieldSize  = [5,25]
Data1DSelectionBackgroundYminCWFieldTitle = 'Ymin:'
;Ymax base and cw_field
Data1DSelectionBackgroundYmaxBaseSize = [Data1DSelectionBackgroundYminBaseSize[0]+$
                                         Data1DSelectionBackgroundYminBasesize[2],$
                                         Data1DSelectionBackgroundYminBaseSize[1],$
                                         BaseLengthYmax,BaseHeight]
Data1DSelectionBackgroundYmaxCWFieldSize  = Data1DSelectionBackgroundYminCWFieldSize
Data1DSelectionBackgroundYmaxCWFieldTitle = '... Ymax:'

;SAVE and LOAD buttons
SaveLoadButtonSize  = [110,30]
SaveButtonSize      = [381,Data1DselectionBackgroundYmaxBaseSize[1]+3,$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
SaveButtonTitle     = 'S A V E'  
LoadButtonSize      = [SaveButtonSize[0]+SaveLoadButtonSize[0],$
                       SaveButtonSize[1],$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
LoadButtonTitle     = 'L O A D'

;Background ROI file
d_vertical_L_L = 70
DataBackgroundSelectionFileLabelSize  = [3,Data1DSelectionBackgroundLabelSize[0]+$
                                        d_vertical_L_L]
DataBackgroundSelectionFileLabelTitle = 'Background ROI file ......'
d_L_B_2 = 170
DataBackgroundSelectionFileTextFieldSize = [DataBackgroundSelectionFileLabelSize[0]+d_L_B_2,$
                                            DataBackgroundSelectionFileLabelSize[1]-4,$
                                            432,30]

;Peak Ymin and Ymax bases and cw_fields
d_vertical_L_L = 60
Data1DSelectionPeakLabelSize  = [3,45+d_vertical_L_L]
Data1DSelectionPeakLabelTitle = 'Peak Exclusion ........... ' 
Data1DSelectionPeakYminBaseSize = [Data1DSelectionPeakLabelSize[0]+d_L_B,$
                                   Data1DSelectionPeakLabelSize[1]-7,$
                                   BaseLengthYmin,BaseHeight]
Data1DSelectionPeakYminCWFieldSize  = Data1DSelectionBackgroundYmaxCWFieldSize
Data1DSelectionPeakYminCWFieldTitle = 'Ymin:'

;Ymax base and cw_field
Data1DSelectionPeakYmaxBaseSize = [Data1DSelectionPeakYminBaseSize[0]+$
                                   Data1DSelectionPeakYminBasesize[2],$
                                   Data1DSelectionPeakYminBaseSize[1],$
                                   BaseLengthYmax,BaseHeight]
Data1DSelectionPeakYmaxCWFieldSize  = Data1DSelectionPeakYminCWFieldSize
Data1DSelectionPeakYmaxCWFieldTitle = '... Ymax:'

;TAB #2 (Contrast Editor)
ContrastDropListSize      = [5,13,200,30]

ContrastBottomSliderSize  = [220,0,370,60]
ContrastBottomSliderTitle = 'Left Range'
ContrastBottomSliderMin = 0
ContrastBottomSliderMax = 255
ContrastBottomSliderDefaultValue = ContrastBottomSliderMin

ContrastNumberSliderSize  = [220,65,370,60]
ContrastNumberSliderTitle = 'Number color' 
ContrastNumberSliderMin = 1
ContrastNumberSliderMax = 255
ContrastNumberSliderDefaultValue = ContrastNumberSliderMax

ResetContrastButtonSize  = [ContrastDropListSize[0]+10,$
                            80,$
                            175,$
                            30]
ResetContrastButtonTitle = ' RESET FULL CONTRAST SESSION '

;***********************************************************************************
;Build 1D tab
;***********************************************************************************
load_data_D_tab_base = widget_base(D_DD_Tab,$
                                   uname='load_data_d_tab_base',$
                                   title=D_DD_TabTitle[0],$
                                   xoffset=D_DD_TabSize[0],$
                                   yoffset=D_DD_TabSize[1],$
                                   scr_xsize=D_DD_TabSize[2],$
                                   scr_ysize=D_DD_TabSize[3])

load_data_D_draw = widget_draw(load_data_D_tab_base,$
                               xoffset=GlobalLoadGraphs[0],$
                               yoffset=GlobalLoadGraphs[1],$
                               scr_xsize=GlobalLoadGraphs[2],$
                               scr_ysize=GlobalLoadGraphs[3],$
                               uname='load_data_D_draw',$
                               retain=2,$
                               /button_events,$
                               /motion_events)

;create the back/peak and rescale tab
BackPeakRescaleTab = widget_tab(load_data_D_tab_base,$
                                uname='data_back_peak_rescale_tab',$
                                xoffset=BackPeakRescaleTabSize[0],$
                                yoffset=BackPeakRescaleTabSize[1],$
                                scr_xsize=BackPeakRescaleTabSize[2],$
                                scr_ysize=BackPeakRescaleTabSize[3],$
                                location=0)

BackPeakBase = widget_base(BackPeakRescaleTab,$
                           uname='data_back_peak_base',$
                           xoffset=BackPeakBaseSize[0],$
                           yoffset=BackPeakBaseSize[1],$
                           scr_xsize=BackPeakBaseSize[2],$
                           scr_ysize=BackPeakBaseSize[3],$
                           title=BackPeakBaseTitle)

;create the widgets for the selection
Data1DselectionBase = widget_base(BackPeakBase,$
                                  uname='data_1d_selection_base',$
                                  xoffset=Data1DSelectionBaseSize[0],$
                                  yoffset=Data1DSelectionBaseSize[1],$
                                  scr_xsize=Data1DSelectionBaseSize[2],$
                                  scr_ysize=Data1DSelectionBaseSize[3])

Data1DSelection = cw_bgroup(Data1DSelectionBase,$
                            Data1DSelectionList,$
                            /exclusive,$
                            /RETURN_NAME,$
                            XOFFSET=Data1DSelectionSize[0],$
                            YOFFSET=Data1DSelectionSize[1],$
                            SET_VALUE=0.0,$
                            row=1,$
                            UNAME='data_1d_selection')

dataYminLabel = widget_label(Data1DselectionBase,$
                             uname='data_ymin_label_frame',$
                             xoffset=dataYminLabelSize[0],$
                             yoffset=dataYminLabelSize[1],$
                             scr_xsize=dataYminLabelSize[2],$
                             scr_ysize=dataYminLabelSize[3],$
                             value=dataYminLabelTitle,$
                             frame=2,$
                             sensitive=0)

dataYmaxLabel = widget_label(Data1DSelectionBase,$
                             uname='data_ymax_label_frame',$
                             xoffset=dataYmaxLabelSize[0],$
                             yoffset=dataYmaxLabelSize[1],$
                             scr_xsize=dataYmaxLabelSize[2],$
                             scr_ysize=dataYmaxLabelSize[3],$
                             value=dataYmaxLabelTitle,$
                             frame=2,$
                             sensitive=0)


;background selection
Data_1d_selection_background_label = $
  widget_label(Data1DSelectionBase,$
               xoffset=Data1DSelectionBackgroundLabelSize[0],$
               yoffset=Data1DSelectionBackgroundLabelSize[1],$
               value=Data1DSelectionBackgroundLabelTitle)

Data1DSelectionBackgroundYminBase = $
  widget_base(Data1DSelectionBase,$
              xoffset=Data1DSelectionBackgroundYminBaseSize[0],$
              yoffset=Data1DSelectionBackgroundYminBaseSize[1],$
              scr_xsize=Data1DSelectionBackgroundYminBaseSize[2],$
              scr_ysize=Data1DSelectionBackgroundYminBaseSize[3],$
              uname='Data1SelectionBackgroundYminBase')

Data1DSelectionBackgroundYminCWField = $
  CW_FIELD(Data1DSelectionBackgroundYminBase,$
           row=1,$
           xsize=Data1DSelectionBackgroundYminCWFieldSize[0],$
           ysize=Data1DSelectionBackgroundYminCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Data1DSelectionBackgroundYminCWFieldTitle,$
           uname='data_d_selection_background_ymin_cw_field')

Data1DSelectionBackgroundYmaxBase = $
  widget_base(Data1DSelectionBase,$
              xoffset=Data1DSelectionBackgroundYmaxBaseSize[0],$
              yoffset=Data1DSelectionBackgroundYmaxBaseSize[1],$
              scr_xsize=Data1DSelectionBackgroundYmaxBaseSize[2],$
              scr_ysize=Data1DSelectionBackgroundYmaxBaseSize[3],$
              uname='Data1SelectionBackgroundYmaxBase')

Data1DSelectionBackgroundYmaxCWField = $
  CW_FIELD(Data1DSelectionBackgroundYmaxBase,$
           row=1,$
           xsize=Data1DSelectionBackgroundYmaxCWFieldSize[0],$
           ysize=Data1DSelectionBackgroundYmaxCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Data1DSelectionBackgroundYmaxCWFieldTitle,$
           uname='data_d_selection_background_ymax_cw_field')

SaveButton = widget_button(Data1DSelectionBase,$,$
                           xoffset=SaveButtonSize[0],$
                           yoffset=SaveButtonSize[1],$
                           scr_xsize=SaveButtonSize[2],$
                           scr_ysize=SaveButtonSize[3],$
                           value=SaveButtonTitle,$
                           uname='data_roi_save_button',$
                           sensitive=0)
                           
LoadButton = widget_button(Data1DSelectionBase,$,$
                           xoffset=LoadButtonSize[0],$
                           yoffset=LoadButtonSize[1],$
                           scr_xsize=LoadButtonSize[2],$
                           scr_ysize=LoadButtonSize[3],$
                           value=LoadButtonTitle,$
                           uname='data_roi_load_button',$
                           sensitive=0)
                           
DataBackgroundSelectionFileLabel = $
  widget_label(Data1DSelectionBase,$
               xoffset=DataBackgroundSelectionFileLabelSize[0],$
               yoffset=DataBackgroundSelectionFileLabelSize[1],$ 
               value=DataBackgroundSelectionFileLabelTitle)

DataBackgroundSelectionFileTextField = $
  widget_Text(Data1DSelectionBase,$
              xoffset=DataBackgroundSelectionFileTextFieldSize[0],$
              yoffset=DataBackgroundSelectionFileTextFieldSize[1],$
              scr_xsize=DataBackgroundSelectionFileTextFieldSize[2],$
              scr_ysize=DataBackgroundSelectionFileTextFieldSize[3],$
              uname='data_background_selection_file_text_field',$
              /align_left,$
              /editable,$
              sensitive=0)

;Peak exclusion
Data_1d_selection_peak_label = $
  widget_label(Data1DSelectionBase,$
               xoffset=Data1DSelectionPeakLabelSize[0],$
               yoffset=Data1DSelectionPeakLabelSize[1],$
               value=Data1DSelectionPeakLabelTitle)

Data1DSelectionPeakYminBase = $
  widget_base(Data1DSelectionBase,$
              xoffset=Data1DSelectionPeakYminBaseSize[0],$
              yoffset=Data1DSelectionPeakYminBaseSize[1],$
              scr_xsize=Data1DSelectionPeakYminBaseSize[2],$
              scr_ysize=Data1DSelectionPeakYminBaseSize[3],$
              uname='Data1SelectionPeakYminBase')

Data1DSelectionPeakYminCWField = $
  CW_FIELD(Data1DSelectionPeakYminBase,$
           row=1,$
           xsize=Data1DSelectionPeakYminCWFieldSize[0],$
           ysize=Data1DSelectionPeakYminCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Data1DSelectionPeakYminCWFieldTitle,$
           uname='data_d_selection_peak_ymin_cw_field')

Data1DSelectionPeakYmaxBase = $
  widget_base(Data1DSelectionBase,$
              xoffset=Data1DSelectionPeakYmaxBaseSize[0],$
              yoffset=Data1DSelectionPeakYmaxBaseSize[1],$
              scr_xsize=Data1DSelectionPeakYmaxBaseSize[2],$
              scr_ysize=Data1DSelectionPeakYmaxBaseSize[3],$
              uname='Data1SelectionPeakYmaxBase')

Data1DSelectionPeakYmaxCWField = $
  CW_FIELD(Data1DSelectionPeakYmaxBase,$
           row=1,$
           xsize=Data1DSelectionPeakYmaxCWFieldSize[0],$
           ysize=Data1DSelectionPeakYmaxCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Data1DSelectionPeakYmaxCWFieldTitle,$
           uname='data_d_selection_peak_ymax_cw_field')


;Tab #2 (rescale base)
RescaleBase = widget_base(BackPeakRescaleTab,$
                          uname='data_rescale_base',$
                          xoffset=RescaleBaseSize[0],$
                          yoffset=RescaleBaseSize[1],$
                          scr_xsize=RescaleBaseSize[2],$
                          scr_ysize=RescaleBaseSize[3],$
                          title=RescaleBaseTitle)

ContrastDropList = widget_droplist(RescaleBase,$
                                   value=LoadctList,$
                                   xoffset=ContrastDropListSize[0],$
                                   yoffset=ContrastDropListSize[1],$
                                   scr_xsize=ContrastDropListSize[2],$
                                   scr_ysize=ContrastDropListSize[3],$
                                   /tracking_events,$
                                   uname='data_contrast_droplist')

ContrastBottomSlider = widget_slider(RescaleBase,$
                                     xoffset=ContrastBottomSliderSize[0],$
                                     yoffset=ContrastBottomSliderSize[1],$
                                     scr_xsize=ContrastBottomSliderSize[2],$
                                     scr_ysize=ContrastBottomSliderSize[3],$
                                     minimum=ContrastBottomSliderMin,$
                                     maximum=ContrastBottomSliderMax,$
                                     uname='data_contrast_bottom_slider',$
                                     /tracking_events,$
                                     title=ContrastBottomSliderTitle,$
                                     value=ContrastBottomSliderDefaultValue)

ContrastNumberSlider = widget_slider(RescaleBase,$
                                     xoffset=ContrastNumberSliderSize[0],$
                                     yoffset=ContrastNumberSliderSize[1],$
                                     scr_xsize=ContrastNumberSliderSize[2],$
                                     scr_ysize=ContrastNumberSliderSize[3],$
                                     minimum=ContrastNumberSliderMin,$
                                     maximum=ContrastNumberSliderMax,$
                                     uname='data_contrast_number_slider',$
                                     /tracking_events,$
                                     title=ContrastNumberSliderTitle,$
                                     value=ContrastNumberSliderDefaultValue)

ResetContrastButton = widget_button(RescaleBase,$
                                    xoffset=ResetContrastButtonSize[0],$
                                    yoffset=ResetContrastButtonSize[1],$
                                    scr_xsize=ResetContrastButtonSize[2],$
                                    scr_ysize=ResetContrastButtonSize[3],$
                                    value=ResetContrastButtonTitle,$
                                    sensitive=1,$
                                    uname='data_reset_contrast_button')


END

