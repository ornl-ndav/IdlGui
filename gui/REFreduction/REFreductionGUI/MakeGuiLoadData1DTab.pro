PRO MakeGuiLoadData1DTab, D_DD_Tab, D_DD_TabSize, D_DD_TabTitle, GlobalLoadGraphs

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;cw_bgroup of selection (back or signal)
Data1DSelectionList = ['Select Background Range    ',$
                       'Select Peak Exclusion      ']
Data1DSelectionBaseSize            = [0,605, D_DD_TabSize[2], D_DD_TabSize[3]]
Data1DSelectionSize                = [5, 5]

;Ymin and Ymax
Data1DSelectionBackgroundLabelSize  = [5,45]
Data1DSelectionBackgroundLabelTitle = 'Background Range ............... ' 
d_L_L= 200
Data1DSelectionBackgroundYminLabelSize = [Data1DSelectionBackgroundLabelSize[0]+$
                                          d_L_L,$
                                          Data1DSelectionBackgroundLabelSize[1]]
Data1DSelectionBackgroundYminLabelTitle = 'Ymin'
d_L_T = 30
Data1DSelectionBackgroundYminTextSize = [Data1DSelectionBackgroundYminLabelSize[0]+$
                                         d_L_T,$
                                         Data1DSelectionBackgroundYminLabelSize[1]-5,$
                                         45,30]
d_T_L = 50
Data1DSelectionBackgroundYmaxLabelSize = [Data1DSelectionBackgroundYminTextSize[0]+$
                                          d_T_L,$
                                          Data1DSelectionBackgroundYminLabelSize[1]]
Data1DSelectionBackgroundYmaxLabelTitle = '..... Ymax'
d_L_T_2 = d_L_T + 37
Data1DSelectionBackgroundYmaxTextSize = [Data1DSelectionbackgroundYmaxLabelSize[0]+$
                                         d_L_T_2,$
                                         Data1DSelectionBackgroundYminTextSize[1],$
                                         Data1DSelectionBackgroundYminTextSize[2],$
                                         Data1DSelectionBackgroundYminTextSize[3]]

d_vertical_L_L = 30
Data1DSelectionPeakLabelTitle = 'Peak Exclusion ................. ' 
Data1DSelectionPeakLabelSize       = [5, Data1DSelectionBackgroundLabelSize[1]+$
                                      d_vertical_L_L]
Data1DSelectionPeakYminLabelSize = [Data1DSelectionPeakLabelSize[0]+$
                                    d_L_L,$
                                    Data1DSelectionPeakLabelSize[1]]
Data1DSelectionPeakYminLabelTitle = 'Ymin'
Data1DSelectionPeakYminTextSize = [Data1DSelectionPeakYminLabelSize[0]+$
                                   d_L_T,$
                                   Data1DSelectionPeakYminLabelSize[1]-5,$
                                   Data1DSelectionBackgroundYminTextSize[2],$
                                   Data1DSelectionBackgroundYminTextSize[3]]
Data1DSelectionPeakYmaxLabelSize = [Data1DSelectionPeakYminTextSize[0]+$
                                    d_T_L,$
                                    Data1DSelectionPeakYminLabelSize[1]]
Data1DSelectionPeakYmaxLabelTitle = '..... Ymax'
Data1DSelectionPeakYmaxTextSize = [Data1DSelectionbackgroundYmaxLabelSize[0]+$
                                   d_L_T_2,$
                                   Data1DSelectionPeakYminTextSize[1],$
                                   Data1DSelectionPeakYminTextSize[2],$
                                   Data1DSelectionPeakYminTextSize[3]]

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
Data_1d_selection_background_label = widget_label(Data1DSelectionBase,$
                                                  xoffset=Data1DSelectionBackgroundLabelSize[0],$
                                                  yoffset=Data1DSelectionBackgroundLabelSize[1],$
                                                  value=Data1DSelectionBackgroundLabelTitle)

Data_1d_selection_background_ymin_label = $
  widget_label(Data1DSelectionBase,$
               xoffset=Data1DSelectionBackgroundYminLabelSize[0],$
               yoffset=Data1DSelectionBackgroundYminLabelSize[1],$
               value=Data1DSelectionBackgroundYminLabelTitle)

Data_1d_selection_background_ymin_text = $
  widget_text(Data1DSelectionBase,$
              xoffset=Data1DSelectionBackgroundYminTextSize[0],$
              yoffset=Data1DSelectionBackgroundYminTextSize[1],$
              scr_xsize=Data1DSelectionBackgroundYminTextSize[2],$
              scr_ysize=Data1DSelectionBackgroundYminTextSize[3],$
              value='',$
              uname='data_1d_selection_background_ymin_text',$
              /editable,$
              /align_left,$
              /all_events)


Data_1d_selection_background_ymax_label = $
  widget_label(Data1DSelectionBase,$
               xoffset=Data1DSelectionBackgroundYmaxLabelSize[0],$
               yoffset=Data1DSelectionBackgroundYmaxLabelSize[1],$
               value=Data1DSelectionBackgroundYmaxLabelTitle)

Data_1d_selection_background_ymax_text = $
  widget_text(Data1DSelectionBase,$
              xoffset=Data1DSelectionBackgroundYmaxTextSize[0],$
              yoffset=Data1DSelectionBackgroundYmaxTextSize[1],$
              scr_xsize=Data1DSelectionBackgroundYmaxTextSize[2],$
              scr_ysize=Data1DSelectionBackgroundYmaxTextSize[3],$
              value='',$
              uname='data_1d_selection_background_ymax_text',$
              /editable,$
              /align_left,$
              /all_events)


;Peak exclusion
Data_1d_selection_peak_label = widget_label(Data1DSelectionBase,$
                                                  xoffset=Data1DSelectionPeakLabelSize[0],$
                                                  yoffset=Data1DSelectionPeakLabelSize[1],$
                                                  value=Data1DSelectionPeakLabelTitle)

Data_1d_selection_peak_ymin_label = $
  widget_label(Data1DSelectionBase,$
               xoffset=Data1DSelectionPeakYminLabelSize[0],$
               yoffset=Data1DSelectionPeakYminLabelSize[1],$
               value=Data1DSelectionPeakYminLabelTitle)

Data_1d_selection_peak_ymin_text = $
  widget_text(Data1DSelectionBase,$
              xoffset=Data1DSelectionPeakYminTextSize[0],$
              yoffset=Data1DSelectionPeakYminTextSize[1],$
              scr_xsize=Data1DSelectionPeakYminTextSize[2],$
              scr_ysize=Data1DSelectionPeakYminTextSize[3],$
              value='',$
              uname='data_1d_selection_peak_ymin_text',$
              /editable,$
              /align_left,$
              /all_events)


Data_1d_selection_peak_ymax_label = $
  widget_label(Data1DSelectionBase,$
               xoffset=Data1DSelectionPeakYmaxLabelSize[0],$
               yoffset=Data1DSelectionPeakYmaxLabelSize[1],$
               value=Data1DSelectionPeakYmaxLabelTitle)

Data_1d_selection_peak_ymax_text = $
  widget_text(Data1DSelectionBase,$
              xoffset=Data1DSelectionPeakYmaxTextSize[0],$
              yoffset=Data1DSelectionPeakYmaxTextSize[1],$
              scr_xsize=Data1DSelectionPeakYmaxTextSize[2],$
              scr_ysize=Data1DSelectionPeakYmaxTextSize[3],$
              value='',$
              uname='data_1d_selection_peak_ymax_text',$
              /editable,$
              /align_left,$
              /all_events)

END

