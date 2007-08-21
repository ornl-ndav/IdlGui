PRO MakeGuiLoadData1DTab, D_DD_Tab, D_DD_TabSize, D_DD_TabTitle, GlobalLoadGraphs

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;cw_bgroup of selection (back or signal)
Data1DSelectionList = ['Select Background Range    ',$
                       'Select Peak Exclusion      ']
Data1DSelectionBaseSize            = [0,605, D_DD_TabSize[2], D_DD_TabSize[3]]
Data1DSelectionSize                = [5, 5]
 
d_L_B= 170
BaseLengthYmin = 90
BaseLengthYmax = 120
BaseHeight = 35
;Background Ymin and Ymax bases and cw_fields
;Ymin base and cw_field
Data1DSelectionBackgroundLabelSize  = [3,45]
Data1DSelectionBackgroundLabelTitle = 'Background Range ......... ' 
Data1DSelectionBackgroundYminBaseSize = [Data1DSelectionBackgroundLabelSize[0]+d_L_B,$
                                         Data1DSelectionBackgroundLabelSize[1]-7,$
                                         BaseLengthYmin,BaseHeight]
Data1DSelectionBackgroundYminCWFieldSize = [5,30]
Data1DSelectionBackgroundYminCWFieldTitle = 'Ymin:'
;Ymax base and cw_field
Data1DSelectionBackgroundYmaxBaseSize = [Data1DSelectionBackgroundYminBaseSize[0]+$
                                         Data1DSelectionBackgroundYminBasesize[2],$
                                         Data1DSelectionBackgroundYminBaseSize[1],$
                                         BaseLengthYmax,BaseHeight]
Data1DSelectionBackgroundYmaxCWFieldSize = Data1DSelectionBackgroundYminCWFieldSize
Data1DSelectionBackgroundYmaxCWFieldTitle = '... Ymax:'

;SAVE and LOAD buttons
SaveLoadButtonSize = [113,30]
SaveButtonSize      = [384,Data1DselectionBackgroundYmaxBaseSize[1]+3,$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
SaveButtonTitle     = 'S A V E'  
LoadButtonSize      = [SaveButtonSize[0]+SaveLoadButtonSize[0],$
                       SaveButtonSize[1],$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
LoadButtonTitle     = 'L O A D'

d_vertical_L_L = 77
DataBackgroundSelectionFileLabelSize = [3,Data1DSelectionBackgroundLabelSize[0]+$
                                        d_vertical_L_L]
DataBackgroundSelectionFileLabelTitle = 'Background ROI file ......'
d_L_B_2 = 170
DataBackgroundSelectionFileTextFieldSize = [DataBackgroundSelectionFileLabelSize[0]+d_L_B_2,$
                                            DataBackgroundSelectionFileLabelSize[1]-4,$
                                            440,30]
                                    
;Peak Ymin and Ymax bases and cw_fields
d_vertical_L_L = 70
Data1DSelectionPeakLabelSize  = [3,45+d_vertical_L_L]
Data1DSelectionPeakLabelTitle = 'Peak Exclusion ........... ' 
Data1DSelectionPeakYminBaseSize = [Data1DSelectionPeakLabelSize[0]+d_L_B,$
                                   Data1DSelectionPeakLabelSize[1]-7,$
                                   BaseLengthYmin,BaseHeight]
Data1DSelectionPeakYminCWFieldSize = Data1DSelectionBackgroundYmaxCWFieldSize
Data1DSelectionPeakYminCWFieldTitle = 'Ymin:'
;Ymax base and cw_field
Data1DSelectionPeakYmaxBaseSize = [Data1DSelectionPeakYminBaseSize[0]+$
                                   Data1DSelectionPeakYminBasesize[2],$
                                   Data1DSelectionPeakYminBaseSize[1],$
                                   BaseLengthYmax,BaseHeight]
Data1DSelectionPeakYmaxCWFieldSize = Data1DSelectionPeakYminCWFieldSize
Data1DSelectionPeakYmaxCWFieldTitle = '... Ymax:'


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

;create the widgets for the selection
Data1DselectionBase = widget_base(load_data_D_tab_base,$
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
                           uname='data_roi_save_button')
                           
LoadButton = widget_button(Data1DSelectionBase,$,$
                           xoffset=LoadButtonSize[0],$
                           yoffset=LoadButtonSize[1],$
                           scr_xsize=LoadButtonSize[2],$
                           scr_ysize=LoadButtonSize[3],$
                           value=LoadButtonTitle,$
                           uname='data_roi_load_button')
                           
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
              /editable)

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

END

