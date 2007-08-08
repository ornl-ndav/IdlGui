PRO MakeGuiSettings, STEPS_TAB

;Define position and size of widgets
SettingsTabSize      = [5  , 5  , 500 , 200 ]
tof_to_Q_label_size  = [5  , 5  , 150 , 30 ]
tof_to_Q_size        = [160, 5]

;polynomial fitting order 
polyFitOrderLabelSize   = [5, 45]
d_L_T = 110
polyFitOrderTextBoxSize = [polyFitOrderLabelSize[0] + d_L_T,$
                           polyFitOrderLabelSize[1]-5,$
                           50,30]
;Define titles
SettingsTabTitle       = 'Settings'
tof_to_Q_label_title   = 'TOF_to_Q algorithm:' 
polyFitOrderLabelTitle = 'Fitting order n:' 
polyFitOrderTextBoxDefaultValue = '3'

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


END
