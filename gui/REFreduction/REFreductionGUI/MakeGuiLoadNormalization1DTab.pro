PRO MakeGuiLoadNormalization1DTab, D_DD_Tab, D_DD_TabSize, D_DD_TabTitle, GlobalLoadGraphs


;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;cw_bgroup of selection (back or signal)
Normalization1DSelectionList = ['Select Background Range    ',$
                       'Select Peak Exclusion      ']
Normalization1DSelectionBaseSize            = [0,605, D_DD_TabSize[2], D_DD_TabSize[3]]
Normalization1DSelectionSize                = [5, 5]

;Ymin and Ymax
Normalization1DSelectionBackgroundLabelSize  = [5,45]
Normalization1DSelectionBackgroundLabelTitle = 'Background Range Selected ...... ' 
d_L_L= 200
Normalization1DSelectionBackgroundYminLabelSize = [Normalization1DSelectionBackgroundLabelSize[0]+$
                                          d_L_L,$
                                          Normalization1DSelectionBackgroundLabelSize[1]]
Normalization1DSelectionBackgroundYminLabelTitle = 'Ymin'
d_L_T = 30
Normalization1DSelectionBackgroundYminTextSize = [Normalization1DSelectionBackgroundYminLabelSize[0]+$
                                         d_L_T,$
                                         Normalization1DSelectionBackgroundYminLabelSize[1]-5,$
                                         45,30]
d_T_L = 50
Normalization1DSelectionBackgroundYmaxLabelSize = [Normalization1DSelectionBackgroundYminTextSize[0]+$
                                          d_T_L,$
                                          Normalization1DSelectionBackgroundYminLabelSize[1]]
Normalization1DSelectionBackgroundYmaxLabelTitle = '..... Ymax'
d_L_T_2 = d_L_T + 37
Normalization1DSelectionBackgroundYmaxTextSize = [Normalization1DSelectionbackgroundYmaxLabelSize[0]+$
                                         d_L_T_2,$
                                         Normalization1DSelectionBackgroundYminTextSize[1],$
                                         Normalization1DSelectionBackgroundYminTextSize[2],$
                                         Normalization1DSelectionBackgroundYminTextSize[3]]

d_vertical_L_L = 30
Normalization1DSelectionPeakLabelTitle = 'Peak Exclusion ................. ' 
Normalization1DSelectionPeakLabelSize       = [5, Normalization1DSelectionBackgroundLabelSize[1]+$
                                      d_vertical_L_L]
Normalization1DSelectionPeakYminLabelSize = [Normalization1DSelectionPeakLabelSize[0]+$
                                    d_L_L,$
                                    Normalization1DSelectionPeakLabelSize[1]]
Normalization1DSelectionPeakYminLabelTitle = 'Ymin'
Normalization1DSelectionPeakYminTextSize = [Normalization1DSelectionPeakYminLabelSize[0]+$
                                   d_L_T,$
                                   Normalization1DSelectionPeakYminLabelSize[1]-5,$
                                   Normalization1DSelectionBackgroundYminTextSize[2],$
                                   Normalization1DSelectionBackgroundYminTextSize[3]]
Normalization1DSelectionPeakYmaxLabelSize = [Normalization1DSelectionPeakYminTextSize[0]+$
                                    d_T_L,$
                                    Normalization1DSelectionPeakYminLabelSize[1]]
Normalization1DSelectionPeakYmaxLabelTitle = '..... Ymax'
Normalization1DSelectionPeakYmaxTextSize = [Normalization1DSelectionbackgroundYmaxLabelSize[0]+$
                                   d_L_T_2,$
                                   Normalization1DSelectionPeakYminTextSize[1],$
                                   Normalization1DSelectionPeakYminTextSize[2],$
                                   Normalization1DSelectionPeakYminTextSize[3]]


;Build 1D tab
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
Normalization1DselectionBase = widget_base(load_Normalization_D_tab_base,$
                                  uname='Normalization_1d_selection_base',$
                                  xoffset=Normalization1DSelectionBaseSize[0],$
                                  yoffset=Normalization1DSelectionBaseSize[1],$
                                  scr_xsize=Normalization1DSelectionBaseSize[2],$
                                  scr_ysize=Normalization1DSelectionBaseSize[3])

Normalization1DSelection = cw_bgroup(Normalization1DSelectionBase,$
                            Normalization1DSelectionList,$
                            /exclusive,$
                            /RETURN_NAME,$
                            XOFFSET=Normalization1DSelectionSize[0],$
                            YOFFSET=Normalization1DSelectionSize[1],$
                            SET_VALUE=0.0,$
                            row=1,$
                            UNAME='Normalization_1d_selection')


;background selection
Normalization_1d_selection_background_label = widget_label(Normalization1DSelectionBase,$
                                                  xoffset=Normalization1DSelectionBackgroundLabelSize[0],$
                                                  yoffset=Normalization1DSelectionBackgroundLabelSize[1],$
                                                  value=Normalization1DSelectionBackgroundLabelTitle)

Normalization_1d_selection_background_ymin_label = $
  widget_label(Normalization1DSelectionBase,$
               xoffset=Normalization1DSelectionBackgroundYminLabelSize[0],$
               yoffset=Normalization1DSelectionBackgroundYminLabelSize[1],$
               value=Normalization1DSelectionBackgroundYminLabelTitle)

Normalization_1d_selection_background_ymin_text = $
  widget_text(Normalization1DSelectionBase,$
              xoffset=Normalization1DSelectionBackgroundYminTextSize[0],$
              yoffset=Normalization1DSelectionBackgroundYminTextSize[1],$
              scr_xsize=Normalization1DSelectionBackgroundYminTextSize[2],$
              scr_ysize=Normalization1DSelectionBackgroundYminTextSize[3],$
              value='',$
              uname='Normalization_1d_selection_background_ymin_text',$
              /editable,$
              /align_left,$
              /all_events)


Normalization_1d_selection_background_ymax_label = $
  widget_label(Normalization1DSelectionBase,$
               xoffset=Normalization1DSelectionBackgroundYmaxLabelSize[0],$
               yoffset=Normalization1DSelectionBackgroundYmaxLabelSize[1],$
               value=Normalization1DSelectionBackgroundYmaxLabelTitle)

Normalization_1d_selection_background_ymax_text = $
  widget_text(Normalization1DSelectionBase,$
              xoffset=Normalization1DSelectionBackgroundYmaxTextSize[0],$
              yoffset=Normalization1DSelectionBackgroundYmaxTextSize[1],$
              scr_xsize=Normalization1DSelectionBackgroundYmaxTextSize[2],$
              scr_ysize=Normalization1DSelectionBackgroundYmaxTextSize[3],$
              value='',$
              uname='Normalization_1d_selection_background_ymax_text',$
              /editable,$
              /align_left,$
              /all_events)


;Peak exclusion
Normalization_1d_selection_peak_label = widget_label(Normalization1DSelectionBase,$
                                                  xoffset=Normalization1DSelectionPeakLabelSize[0],$
                                                  yoffset=Normalization1DSelectionPeakLabelSize[1],$
                                                  value=Normalization1DSelectionPeakLabelTitle)

Normalization_1d_selection_peak_ymin_label = $
  widget_label(Normalization1DSelectionBase,$
               xoffset=Normalization1DSelectionPeakYminLabelSize[0],$
               yoffset=Normalization1DSelectionPeakYminLabelSize[1],$
               value=Normalization1DSelectionPeakYminLabelTitle)

Normalization_1d_selection_peak_ymin_text = $
  widget_text(Normalization1DSelectionBase,$
              xoffset=Normalization1DSelectionPeakYminTextSize[0],$
              yoffset=Normalization1DSelectionPeakYminTextSize[1],$
              scr_xsize=Normalization1DSelectionPeakYminTextSize[2],$
              scr_ysize=Normalization1DSelectionPeakYminTextSize[3],$
              value='',$
              uname='Normalization_1d_selection_peak_ymin_text',$
              /editable,$
              /align_left,$
              /all_events)


Normalization_1d_selection_peak_ymax_label = $
  widget_label(Normalization1DSelectionBase,$
               xoffset=Normalization1DSelectionPeakYmaxLabelSize[0],$
               yoffset=Normalization1DSelectionPeakYmaxLabelSize[1],$
               value=Normalization1DSelectionPeakYmaxLabelTitle)

Normalization_1d_selection_peak_ymax_text = $
  widget_text(Normalization1DSelectionBase,$
              xoffset=Normalization1DSelectionPeakYmaxTextSize[0],$
              yoffset=Normalization1DSelectionPeakYmaxTextSize[1],$
              scr_xsize=Normalization1DSelectionPeakYmaxTextSize[2],$
              scr_ysize=Normalization1DSelectionPeakYmaxTextSize[3],$
              value='',$
              uname='Normalization_1d_selection_peak_ymax_text',$
              /editable,$
              /align_left,$
              /all_events)


END
