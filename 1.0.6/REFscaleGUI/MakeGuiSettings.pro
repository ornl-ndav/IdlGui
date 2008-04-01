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
MinCrapDataLabelSize1        = [5,ShowErrorBarLabelSize[1]+d_line_to_line]
d_L_T = 80
MinCrapDataTextFieldSize     = [MinCrapDataLabelSize1[0] + d_L_T,$
                                MinCrapDataLabelSize1[1]-5,$
                                50,30]
;default number of data to remove
MinCrapDefaultValue = 1
MinCrapDataLabelSize2        = [140,MinCrapDataLabelSize1[1]]

;nbr of element to display
nbrDataLabelSize     = [5,minCrapDataLabelSize1[1]+d_line_to_line]
d_L_T_2 = 200
nbrDataTextFieldSize = [nbrDataLabelSize[0] + d_L_T_2,$
                        nbrDataLabelSize[1] -5,$
                        50,30]

;Define titles
SettingsTabTitle        = 'SETTINGS'
tof_to_Q_label_title    = 'TOF_to_Q algorithm:' 
MinCrapDataTitle1       = 'Remove the'
MinCrapDataTitle2       = 'first data for auto-scaling'
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
                              
MinCrapLabel1 = widget_label(settings_base,$
                             xoffset=MinCrapDataLabelSize1[0],$
                             yoffset=MinCrapDataLabelSize1[1],$
                             value=MinCrapDataTitle1)

MinCrapTextField = widget_text(settings_base,$
                               xoffset=MinCrapDataTextFieldSize[0],$
                               yoffset=MinCrapDataTextFieldSize[1],$
                               scr_xsize=MinCrapDataTextFieldSize[2],$
                               scr_ysize=MinCrapDataTextFieldSize[3],$
                               uname='min_crap_text_field',$
                               /editable,$
                               /align_left,$
                               value=strcompress(MinCrapDefaultValue))

MinCrapLabel2 = widget_label(settings_base,$
                             xoffset=MinCrapDataLabelSize2[0],$
                             yoffset=MinCrapDataLabelSize2[1],$
                             value=MinCrapDataTitle2)


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
