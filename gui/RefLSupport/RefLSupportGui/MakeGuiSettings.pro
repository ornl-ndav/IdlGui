PRO MakeGuiSettings, STEPS_TAB

;Define position and size of widgets
SettingsTabSize      = [5  , 5  , 500 , 200 ]
tof_to_Q_label_size  = [5  , 5  , 150 , 30 ]
tof_to_Q_size        = [160, 5]

d_line_to_line = 40
;Show or not error bars
ShowErrorBarLabelSize = [5, tof_to_Q_label_size[1]+ d_line_to_line, 100, 30]
ShowErrorBarGroupSize = [ShowErrorBarLabelSize[0]+ 155,$
                         ShowErrorBarLabelSize[1]]

;polynomial fitting order 
polyFitOrderLabelSize   = [5, ShowErrorBarLabelSize[1]+ d_line_to_line]
d_L_T = 160
polyFitOrderTextBoxSize = [polyFitOrderLabelSize[0] + d_L_T,$
                           polyFitOrderLabelSize[1]-5,$
                           50,30]

;nbr of element to display
nbrDataLabelSize     = [5,polyFitOrderLabelSize[1]+d_line_to_line]
d_L_T_2 = 200
nbrDataTextFieldSize = [nbrDataLabelSize[0] + d_L_T_2,$
                        nbrDataLabelSize[1] -5,$
                        50,30]

;Define titles
SettingsTabTitle        = 'Settings'
tof_to_Q_label_title    = 'TOF_to_Q algorithm:' 
polyFitOrderLabelTitle  = 'Fitting order n:' 
polyFitOrderTextBoxDefaultValue = '3'
ShowErrorBarLabelTitle  = 'Show error bars'
nbrDataLabelTitle       = 'Nbr of data to display in Step3'

;Build GUI
SETTINGS_BASE = WIDGET_BASE(STEPS_TAB,$
                            UNAME='settings_base',$
                            TITLE=SettingsTabTitle,$
                            XOFFSET=SettingsTabSize[0],$
                            YOFFSET=SettingsTabSize[1],$
                            SCR_XSIZE=SettingsTabSize[2],$
                            SCR_YSIZE=SettingsTabSize[3])

TOF_to_Q_label = widget_label(settings_base,$
                              value=TOF_to_Q_label_title,$
                              xoffset=TOF_to_Q_label_size[0],$
                              yoffset=TOF_to_Q_label_size[1],$
                              scr_xsize=TOF_to_Q_label_size[2],$
                              scr_ysize=TOF_to_Q_label_size[3],$
                              /align_left)

TOF_to_Q_algorithm = ['(4*PI*sin(theta)*m*L)/(h.TOF)   ','Jacobian']
TOF_to_Q_algorithm = CW_BGROUP(settings_base,$
                               TOF_to_Q_algorithm,$
                               /exclusive,$
                               /return_name,$
                               XOFFSET=tof_to_Q_size[0],$
                               YOFFSET=tof_to_Q_size[1],$
                               SET_VALUE=0.0,$
                               row=1,$
                               uname='tof_to_Q_algorithm')                 
;show or not the error bars
ShowErrorBarLabel = widget_label(settings_base,$
                                 xoffset=ShowErrorBarLabelSize[0],$
                                 yoffset=ShowErrorBarLabelSize[1],$
                                 scr_xsize=ShowErrorBarLabelSize[2],$
                                 scr_ysize=ShowErrorbarLabelSize[3],$
                                 value=ShowErrorBarLabelTitle)

ShowErrorBarChoice = ['yes','no']
ShowErrorBarGroup = cw_bgroup(settings_base,$
                              ShowErrorBarChoice,$
                              /exclusive,$
                              xoffset=ShowErrorBarGroupSize[0],$
                              yoffset=ShowErrorBarGroupSize[1],$
                              set_value=0.0,$
                              row=1,$
                              uname='show_error_bar_group')
                              
;order of fitting function
PolyFitOrderLabel = widget_label(settings_base,$
                                 xoffset=polyFitOrderLabelSize[0],$
                                 yoffset=polyFitOrderLabelSize[1],$
                                 value=PolyFitOrderLabelTitle)

PolyFitOrderTextBox = widget_text(settings_base,$
                                  xoffset=PolyFitOrderTextBoxSize[0],$
                                  yoffset=PolyFitOrderTextBoxSize[1],$
                                  scr_xsize=PolyFitOrderTextBoxSize[2],$
                                  scr_ysize=PolyFitOrderTextBoxSize[3],$
                                  uname='poly_fit_order_text_box',$
                                  /editable,$
                                  /align_left,$
                                  value=polyFitOrdertextBoxDefaultValue)

;nbr of elements to display
nbrDataLabel = widget_label(settings_base,$
                            xoffset=nbrDataLabelSize[0],$
                            yoffset=nbrDataLabelSize[1],$
                            value=nbrDataLabelTitle)

nbrDataTextField = widget_text(settings_base,$
                               xoffset=nbrDataTextFieldSize[0],$
                               yoffset=nbrDataTextFieldSize[1],$
                               scr_xsize=nbrDataTextFieldSize[2],$
                               scr_ysize=nbrDataTextFieldSize[3],$
                               value=strcompress(100),$
                               uname='nbrDataTextField',$
                               /editable,$
                               /align_left)

END
