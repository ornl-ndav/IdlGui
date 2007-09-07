PRO MakeGuiLoadNormalization1DTab, D_DD_Tab, D_DD_TabSize, D_DD_TabTitle, GlobalLoadGraphs

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;cw_bgroup of selection (back or signal)
Norm1DSelectionList = ['Select Background   ',$
                       'Select Peak   ',$
                       'ZOOM mode  ']
Norm1DSelectionBaseSize = [0,605, D_DD_TabSize[2], D_DD_TabSize[3]]
Norm1DSelectionSize     = [5, 5]

NormYminLabelSize  = [390,5,100,25]
NormYminLabelTitle = '  Ymin  '
NormYmaxLabelSize  = [NormYminLabelSize[0]+113,$
                      5,$
                      NormYminLabelSize[2],$
                      NormYminLabelSize[3]]
NormYmaxLabelTitle = '  Ymax  '
 
d_L_B= 170
BaseLengthYmin = 90
BaseLengthYmax = 120
BaseHeight = 35
;Background Ymin and Ymax bases and cw_fields
;Ymin base and cw_field
Norm1DSelectionBackgroundLabelSize    = [3,45]
Norm1DSelectionBackgroundLabelTitle   = 'Background Range ......... ' 
Norm1DSelectionBackgroundYminBaseSize = [Norm1DSelectionBackgroundLabelSize[0]+d_L_B,$
                                         Norm1DSelectionBackgroundLabelSize[1]-7,$
                                         BaseLengthYmin,BaseHeight]
Norm1DSelectionBackgroundYminCWFieldSize  = [5,30]
Norm1DSelectionBackgroundYminCWFieldTitle = 'Ymin:'
;Ymax base and cw_field
Norm1DSelectionBackgroundYmaxBaseSize     = [Norm1DSelectionBackgroundYminBaseSize[0]+$
                                             Norm1DSelectionBackgroundYminBasesize[2],$
                                             Norm1DSelectionBackgroundYminBaseSize[1],$
                                             BaseLengthYmax,BaseHeight]
Norm1DSelectionBackgroundYmaxCWFieldSize  = Norm1DSelectionBackgroundYminCWFieldSize
Norm1DSelectionBackgroundYmaxCWFieldTitle = '... Ymax:'

;SAVE and LOAD buttons
SaveLoadButtonSize = [113,30]
SaveButtonSize      = [384,Norm1DselectionBackgroundYmaxBaseSize[1]+3,$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
SaveButtonTitle     = 'S A V E'  
LoadButtonSize      = [SaveButtonSize[0]+SaveLoadButtonSize[0],$
                       SaveButtonSize[1],$
                       SaveLoadButtonSize[0],$
                       SaveLoadButtonSize[1]]
LoadButtonTitle     = 'L O A D'

d_vertical_L_L = 77
NormBackgroundSelectionFileLabelSize = [3,Norm1DSelectionBackgroundLabelSize[0]+$
                                        d_vertical_L_L]
NormBackgroundSelectionFileLabelTitle = 'Background ROI file ......'
d_L_B_2 = 170
NormBackgroundSelectionFileTextFieldSize = [NormBackgroundSelectionFileLabelSize[0]+d_L_B_2,$
                                            NormBackgroundSelectionFileLabelSize[1]-4,$
                                            440,30]
                                    
;Peak Ymin and Ymax bases and cw_fields
d_vertical_L_L = 70
Norm1DSelectionPeakLabelSize  = [3,45+d_vertical_L_L]
Norm1DSelectionPeakLabelTitle = 'Peak Exclusion ........... ' 
Norm1DSelectionPeakYminBaseSize = [Norm1DSelectionPeakLabelSize[0]+d_L_B,$
                                   Norm1DSelectionPeakLabelSize[1]-7,$
                                   BaseLengthYmin,BaseHeight]
Norm1DSelectionPeakYminCWFieldSize  = Norm1DSelectionBackgroundYmaxCWFieldSize
Norm1DSelectionPeakYminCWFieldTitle = 'Ymin:'
;Ymax base and cw_field
Norm1DSelectionPeakYmaxBaseSize = [Norm1DSelectionPeakYminBaseSize[0]+$
                                   Norm1DSelectionPeakYminBasesize[2],$
                                   Norm1DSelectionPeakYminBaseSize[1],$
                                   BaseLengthYmax,BaseHeight]
Norm1DSelectionPeakYmaxCWFieldSize = Norm1DSelectionPeakYminCWFieldSize
Norm1DSelectionPeakYmaxCWFieldTitle = '... Ymax:'


;***********************************************************************************
;Build 1D tab
;***********************************************************************************
Load_Normalization_D_TAB_BASE = widget_base(D_DD_Tab,$
                                            uname='load_normalization_d_tab_base',$
                                            title=D_DD_TabTitle[0],$
                                            xoffset=D_DD_TabSize[0],$
                                            yoffset=D_DD_TabSize[1],$
                                            scr_xsize=D_DD_TabSize[2],$
                                            scr_ysize=D_DD_TabSize[3])

load_normalization_D_draw = widget_draw(load_normalization_D_tab_base,$
                                        xoffset=GlobalLoadGraphs[0],$
                                        yoffset=GlobalLoadGraphs[1],$
                                        scr_xsize=GlobalLoadGraphs[2],$
                                        scr_ysize=GlobalLoadGraphs[3],$
                                        uname='load_normalization_D_draw',$
                                        retain=2,$
                                        /button_events,$
                                        /motion_events)


;create the widgets for the selection
Norm1DselectionBase = widget_base(load_normalization_D_tab_base,$
                                  uname='normalization_1d_selection_base',$
                                  xoffset=Norm1DSelectionBaseSize[0],$
                                  yoffset=Norm1DSelectionBaseSize[1],$
                                  scr_xsize=Norm1DSelectionBaseSize[2],$
                                  scr_ysize=Norm1DSelectionBaseSize[3])

Norm1DSelection = cw_bgroup(Norm1DSelectionBase,$
                            Norm1DSelectionList,$
                            /exclusive,$
                            /RETURN_NAME,$
                            XOFFSET=Norm1DSelectionSize[0],$
                            YOFFSET=Norm1DSelectionSize[1],$
                            SET_VALUE=0.0,$
                            row=1,$
                            UNAME='normalization_1d_selection')

NormYminLabel = widget_label(Norm1DselectionBase,$
                             uname='normalization_ymin_label_frame',$
                             xoffset=NormYminLabelSize[0],$
                             yoffset=NormYminLabelSize[1],$
                             scr_xsize=NormYminLabelSize[2],$
                             scr_ysize=NormYminLabelSize[3],$
                             value=NormYminLabelTitle,$
                             frame=2,$
                             sensitive=0)

NormYmaxLabel = widget_label(Norm1DSelectionBase,$
                             uname='normalization_ymax_label_frame',$
                             xoffset=NormYmaxLabelSize[0],$
                             yoffset=NormYmaxLabelSize[1],$
                             scr_xsize=NormYmaxLabelSize[2],$
                             scr_ysize=NormYmaxLabelSize[3],$
                             value=NormYmaxLabelTitle,$
                             frame=2,$
                             sensitive=0)

;background selection
Norm_1d_selection_background_label = $
  widget_label(Norm1DSelectionBase,$
               xoffset=Norm1DSelectionBackgroundLabelSize[0],$
               yoffset=Norm1DSelectionBackgroundLabelSize[1],$
               value=Norm1DSelectionBackgroundLabelTitle)

Norm1DSelectionBackgroundYminBase = $
  widget_base(Norm1DSelectionBase,$
              xoffset=Norm1DSelectionBackgroundYminBaseSize[0],$
              yoffset=Norm1DSelectionBackgroundYminBaseSize[1],$
              scr_xsize=Norm1DSelectionBackgroundYminBaseSize[2],$
              scr_ysize=Norm1DSelectionBackgroundYminBaseSize[3],$
              uname='Norm1SelectionBackgroundYminBase')

Norm1DSelectionBackgroundYminCWField = $
  CW_FIELD(Norm1DSelectionBackgroundYminBase,$
           row=1,$
           xsize=Norm1DSelectionBackgroundYminCWFieldSize[0],$
           ysize=Norm1DSelectionBackgroundYminCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Norm1DSelectionBackgroundYminCWFieldTitle,$
           uname='normalization_d_selection_background_ymin_cw_field')

Norm1DSelectionBackgroundYmaxBase = $
  widget_base(Norm1DSelectionBase,$
              xoffset=Norm1DSelectionBackgroundYmaxBaseSize[0],$
              yoffset=Norm1DSelectionBackgroundYmaxBaseSize[1],$
              scr_xsize=Norm1DSelectionBackgroundYmaxBaseSize[2],$
              scr_ysize=Norm1DSelectionBackgroundYmaxBaseSize[3],$
              uname='Norm1SelectionBackgroundYmaxBase')

Norm1DSelectionBackgroundYmaxCWField = $
  CW_FIELD(Norm1DSelectionBackgroundYmaxBase,$
           row=1,$
           xsize=Norm1DSelectionBackgroundYmaxCWFieldSize[0],$
           ysize=Norm1DSelectionBackgroundYmaxCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Norm1DSelectionBackgroundYmaxCWFieldTitle,$
           uname='normalization_d_selection_background_ymax_cw_field')

SaveButton = widget_button(Norm1DSelectionBase,$,$
                           xoffset=SaveButtonSize[0],$
                           yoffset=SaveButtonSize[1],$
                           scr_xsize=SaveButtonSize[2],$
                           scr_ysize=SaveButtonSize[3],$
                           value=SaveButtonTitle,$
                           uname='normalization_roi_save_button',$
                           sensitive=0)
                           
LoadButton = widget_button(Norm1DSelectionBase,$,$
                           xoffset=LoadButtonSize[0],$
                           yoffset=LoadButtonSize[1],$
                           scr_xsize=LoadButtonSize[2],$
                           scr_ysize=LoadButtonSize[3],$
                           value=LoadButtonTitle,$
                           uname='normalization_roi_load_button',$
                           sensitive=0)
                           
NormBackgroundSelectionFileLabel = $
  widget_label(Norm1DSelectionBase,$
               xoffset=NormBackgroundSelectionFileLabelSize[0],$
               yoffset=NormBackgroundSelectionFileLabelSize[1],$ 
               value=NormBackgroundSelectionFileLabelTitle)

NormBackgroundSelectionFileTextField = $
  widget_Text(Norm1DSelectionBase,$
              xoffset=NormBackgroundSelectionFileTextFieldSize[0],$
              yoffset=NormBackgroundSelectionFileTextFieldSize[1],$
              scr_xsize=NormBackgroundSelectionFileTextFieldSize[2],$
              scr_ysize=NormBackgroundSelectionFileTextFieldSize[3],$
              uname='normalization_background_selection_file_text_field',$
              /align_left,$
              /editable,$
              sensitive=0)

;Peak exclusion
norm_1d_selection_peak_label = $
  widget_label(Norm1DSelectionBase,$
               xoffset=Norm1DSelectionPeakLabelSize[0],$
               yoffset=Norm1DSelectionPeakLabelSize[1],$
               value=Norm1DSelectionPeakLabelTitle)

Norm1DSelectionPeakYminBase = $
  widget_base(Norm1DSelectionBase,$
              xoffset=Norm1DSelectionPeakYminBaseSize[0],$
              yoffset=Norm1DSelectionPeakYminBaseSize[1],$
              scr_xsize=Norm1DSelectionPeakYminBaseSize[2],$
              scr_ysize=Norm1DSelectionPeakYminBaseSize[3],$
              uname='Norm1SelectionPeakYminBase')

Norm1DSelectionPeakYminCWField = $
  CW_FIELD(Norm1DSelectionPeakYminBase,$
           row=1,$
           xsize=Norm1DSelectionPeakYminCWFieldSize[0],$
           ysize=Norm1DSelectionPeakYminCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Norm1DSelectionPeakYminCWFieldTitle,$
           uname='normalization_d_selection_peak_ymin_cw_field')

Norm1DSelectionPeakYmaxBase = $
  widget_base(Norm1DSelectionBase,$
              xoffset=Norm1DSelectionPeakYmaxBaseSize[0],$
              yoffset=Norm1DSelectionPeakYmaxBaseSize[1],$
              scr_xsize=Norm1DSelectionPeakYmaxBaseSize[2],$
              scr_ysize=Norm1DSelectionPeakYmaxBaseSize[3],$
              uname='Norm1SelectionPeakYmaxBase')

Norm1DSelectionPeakYmaxCWField = $
  CW_FIELD(Norm1DSelectionPeakYmaxBase,$
           row=1,$
           xsize=Norm1DSelectionPeakYmaxCWFieldSize[0],$
           ysize=Norm1DSelectionPeakYmaxCWFieldSize[1],$
           /integer,$
           return_events=1,$
           title=Norm1DSelectionPeakYmaxCWFieldTitle,$
           uname='normalization_d_selection_peak_ymax_cw_field')

END
