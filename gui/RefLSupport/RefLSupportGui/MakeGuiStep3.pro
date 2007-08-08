PRO MakeGuiStep3, STEPS_TAB,$
                  Step1Size,$
                  Step3Title,$
                  ListOfFiles

distance_L_TB        = 35
distance_L_L         = 125
distanceVertical_L_L = 35
 
;Define position and size of widgets
;**automatic mode
Step3AutomaticRescaleButtonSize      = [5, 5, 515, 30]

;**manual mode
;main frame
Step3ManualModeLabelSize             = [15, 42]
Step3ManualModeFrameSize             = [8, 50, 504, 300]

;low and Hight Q file names
Step3ManualModeLowQFileLabelSize     = [25, 65]
Step3ManualModeLowQFileNameSize      = [105, 60, 100, 30]
Step3ManualModeHighQFileLabelSize    = [230, 65]
Step3ManualModeHighQFileDroplistSize = [305, 55, 60, 30]

;frame that will hide all the widgets of the manual scaling box
Step3ManualModeHiddenFrameSize = [20,90,490,240]

;Qmin and Qmax
Step3ManualQMinLabelSize              = [25, 120]
d_L_T = 120
Step3ManualQMinTextFieldSize         = [Step3ManualQMinLabelSize[0] + d_L_T ,$
                                        Step3ManualQMinLabelSize[1] - 5,$
                                        80,30]
d_L_L = 250
Step3ManualQMaxLabelSize             = [Step3ManualQMinLabelSize[0] + d_L_L,$
                                        Step3ManualQMinLabelSize[1]]
Step3ManualQMaxTextFieldSize         = [Step3ManualQMaxLabelSize[0] + d_L_T,$
                                        Step3ManualQMinTextFieldSize[1],$
                                        80,30]

;Low Q file name
Step3LowQLabelSize = [10, 200, 100, 30]
d_L_L = 80
Step3LowQFileNameLabelSize = [Step3LowQLabelSize[0] + d_L_L,$
                              Step3LowQLabelSize[1],$
                              150,30]
d_vertical_L_L = 50
Step3HighQLabelSize = [Step3LowQLabelSize[0],$
                       Step3LowQLabelSize[1]+d_vertical_L_L,$
                       Step3LowQLabelSize[2],$
                       Step3LowQLabelSize[3]]
Step3HighQFileNameLabelSize = [Step3LowQFileNameLabelSize[0],$
                               Step3LowQFileNameLabelSize[1] + d_vertical_L_L,$
                               Step3LowQFileNameLabelSize[2],$
                               Step3LowQFileNameLabelSize[3]]
                             

;Before and After
Step3BeforeToAfterDrawSize = [Step3LowQLabelSize[0]+250,$
                              Step3LowQLabelSize[1]+7,$
                              40,90]

;SF
Step3SFDrawSize      = [320,220,40,40]
Step3SFTextFieldSize = [Step3SFDrawSize[0] + 50,$
                        Step3SFDrawSize[1] + 5,$
                        125,$
                        30]


;increase SF 
Step3_3IncreaseButtonSize = [Step3SFTextFieldSize[0],$
                             Step3SFTextFieldSize[1]-40,$
                             40,40]
d_B_B = 40
Step3_2IncreaseButtonSize = [Step3_3IncreaseButtonSize[0] + d_B_B,$
                             Step3_3IncreaseButtonSize[1],$
                             Step3_3IncreaseButtonSize[2],$
                             Step3_3IncreaseButtonSize[3]]
Step3_1IncreaseButtonSize = [Step3_2IncreaseButtonSize[0] + d_B_B,$
                             Step3_2IncreaseButtonSize[1],$
                             Step3_2IncreaseButtonSize[2],$
                             Step3_2IncreaseButtonSize[3]]

;decrease SF 
Step3_3DecreaseButtonSize = [Step3SFTextFieldSize[0],$
                             Step3SFTextFieldSize[1]+30,$
                             40,40]
d_B_B = 40
Step3_2DecreaseButtonSize = [Step3_3DecreaseButtonSize[0] + d_B_B,$
                             Step3_3DecreaseButtonSize[1],$
                             Step3_3DecreaseButtonSize[2],$
                             Step3_3DecreaseButtonSize[3]]
Step3_1DecreaseButtonSize = [Step3_2DecreaseButtonSize[0] + d_B_B,$
                             Step3_2DecreaseButtonSize[1],$
                             Step3_2DecreaseButtonSize[2],$
                             Step3_2DecreaseButtonSize[3]]


;;Manual scaling
;Step3ManualScalingButtonSize = [Step3SFTextFieldSize[0]+90,$
;                                Step3SFTextFieldSize[1],$
;                                100,30]





;Define titles
Step3AutomaticRescaleButtonTitle  = 'Automatic rescaling'
Step3ManualModeLabelTitle         = 'Manual rescaling'
Step3ManualModeLowQFileLabelTitle = 'Low Q file:'
Step3ManualModeHighQFileLabelTitle = 'High Q file:'
Step3ManualQMinLabelTitle            = 'Qmin of high Q file'
Step3ManualQMaxLabelTitle            = 'Qmax of low Q file'
Step3ManualScalingButtonTitle        = 'Manual scaling'


Step3WorkOnFileTitle = 'File name:'
Step3GoButtonTitle = 'Rescale Work-on file'
ListOfFiles  = ['                          ']  
Step2Q1LabelTitle = 'Qmin:'
Step2Q2LabelTitle = 'Qmax:'

;Build GUI
STEP3_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step3',$
                         TITLE=Step3Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

;automatic rescaling button
STEP3_automatic_rescale_button = WIDGET_BUTTON(STEP3_BASE,$
                                               UNAME='Step3_automatic_rescale_button',$
                                               XOFFSET=Step3AutomaticRescaleButtonSize[0],$
                                               YOFFSET=Step3AutomaticRescaleButtonSize[1],$
                                               SCR_XSIZE=Step3AutomaticRescaleButtonSize[2],$
                                               SCR_YSIZE=Step3AutomaticRescaleButtonSize[3],$
                                               SENSITIVE=0,$
                                               VALUE=Step3AutomaticRescaleButtonTitle)



;manual mode
;low Q label
Step3ManualModeLowQFileLabel = widget_label(STEP3_BASE,$
                                            uname='Step3ManualModeLowQFileLabel',$
                                            xoffset=Step3ManualModeLowQFileLabelSize[0],$
                                            yoffset=Step3ManualModeLowQFileLabelSize[1],$
                                            value=Step3ManualModeLowQFileLabelTitle)

;low Q field name
Step3ManualModeLowQFileName = widget_label(STEP3_BASE,$
                                           uname='Step3ManualModeLowQFileName',$
                                           xoffset=Step3ManualModeLowQFileNameSize[0],$
                                           yoffset=Step3ManualModeLowQFileNameSize[1],$
                                           scr_xsize=Step3ManualModeLowQFileNameSize[2],$
                                           scr_ysize=Step3ManualModeLowQFileNameSize[3],$
                                           value='')

;high Q label
Step3ManualModeHighQFileLabel = widget_label(STEP3_BASE,$
                                             uname='Step3ManualModeHighQFileLabel',$
                                             xoffset=Step3ManualModeHighQFileLabelSize[0],$
                                             yoffset=Step3ManualModeHighQFileLabelSize[1],$
                                             value=Step3ManualModeHighQFileLabelTitle)

;high Q droplist
Step3ManualModeHighQFileDroplist = WIDGET_DROPLIST(STEP3_BASE,$
                                                   UNAME='step3_work_on_file_droplist',$
                                                   XOFFSET=Step3ManualModeHighQFileDroplistSize[0],$
                                                   YOFFSET=Step3ManualModeHighQFileDroplistSize[1],$
                                                   SCR_XSIZE=Step3ManualModeHighQFileDroplistSize[2],$
                                                   SCR_YSIZE=Step3ManualModeHighQFileDroplistSize[3],$
                                                   VALUE=ListOfFiles)

;Manual Mode Hidden Frame
Step3ManualModeHiddenFrame = widget_base(STEP3_BASE,$
                                   uname='Step3ManualModeHiddenFrame',$
                                   xoffset=Step3ManualModeHiddenFrameSize[0],$
                                   yoffset=Step3ManualModeHiddenFrameSize[1],$
                                   scr_xsize=Step3ManualModeHiddenFrameSize[2],$
                                   scr_ysize=Step3ManualModeHiddenFrameSize[3],$
                                   map=1)

;Qmin label
Step3ManualQMinLabel = widget_label(STEP3_BASE,$
                                    xoffset=Step3ManualQMinLabelSize[0],$
                                    yoffset=Step3ManualQMinLabelSize[1],$
                                    value=Step3ManualQMinLabelTitle)

;Qmin value
Step3ManualQMinTextField = widget_text(STEP3_BASE,$
                                       xoffset=Step3ManualQMinTextFieldSize[0],$
                                       yoffset=Step3ManualQMinTextFieldSize[1],$
                                       scr_xsize=Step3ManualQMinTextFieldSize[2],$
                                       scr_ysize=Step3ManualQMinTextFieldSize[3],$
                                       /editable,$
                                       /align_left,$
                                       uname='Step3ManualQMinTextField')

;Qmax label
Step3ManualQMaxLabel = widget_label(STEP3_BASE,$
                                    xoffset=Step3ManualQMaxLabelSize[0],$
                                    yoffset=Step3ManualQMaxLabelSize[1],$
                                    value=Step3ManualQMaxLabelTitle)

;Qmax text field
Step3ManualQMaxTextField = widget_text(STEP3_BASE,$
                                       xoffset=Step3ManualQMaxTextFieldSize[0],$
                                       yoffset=Step3ManualQMaxTextFieldSize[1],$
                                       scr_xsize=Step3ManualQMaxTextFieldSize[2],$
                                       scr_ysize=Step3ManualQMaxTextFieldSize[3],$
                                       /editable,$
                                       /align_left,$
                                       uname='Step3ManualQMaxTextField')

;Low Q file name
Step3LowQLabel = widget_label(STEP3_BASE,$
                              xoffset=Step3LowQLabelSize[0],$
                              yoffset=Step3LowQLabelSize[1],$
                              scr_xsize=Step3LowQLabelSize[2],$
                              scr_ysize=Step3LowQLabelSize[3],$
                              uname='Step3ManualModeLowQFileLabel',$
                              value=Step3ManualModeLowQFileLabelTitle)

Step3LowQFileNameLabel = widget_label(STEP3_BASE,$
                                      uname='Step3LowQFileNameLabel',$
                                      xoffset=Step3LowQFileNameLabelSize[0],$
                                      yoffset=Step3LowQFileNameLabelSize[1],$
                                      scr_xsize=Step3LowQFileNameLabelSize[2],$
                                      scr_ysize=Step3LowQFileNameLabelSize[3],$
                                      value='')
                              
;High Q file name
Step3HighQLabel = widget_label(STEP3_BASE,$
                              xoffset=Step3HighQLabelSize[0],$
                              yoffset=Step3HighQLabelSize[1],$
                              scr_xsize=Step3HighQLabelSize[2],$
                              scr_ysize=Step3HighQLabelSize[3],$
                              uname='Step3ManualModeHighQFileLabel',$
                              value=Step3ManualModeHighQFileLabelTitle)

Step3HighQFileNameLabel = widget_label(STEP3_BASE,$
                                       uname='Step3HighQFileNameLabel',$
                                       xoffset=Step3HighQFileNameLabelSize[0],$
                                       yoffset=Step3HighQFileNameLabelSize[1],$
                                       scr_xsize=Step3HighQFileNameLabelSize[2],$
                                       scr_ysize=Step3HighQFileNameLabelSize[3],$
                                       value='')
                              



;SF
Step3SFDraw = widget_draw(STEP3_BASE,$
                          xoffset=Step3SFDrawSize[0],$
                          yoffset=Step3SFDrawSize[1],$
                          scr_xsize=Step3SFDrawSize[2],$
                          scr_ysize=Step3SFDrawSize[3],$
                          uname='Step3SFDraw')

Step3SFTextField = widget_text(STEP3_BASE,$
                               xoffset=Step3SFTextFieldSize[0],$
                               yoffset=Step3SFTextFieldSize[1],$
                               scr_xsize=Step3SFTextFieldSize[2],$
                               scr_ysize=Step3SFTextFieldSize[3],$
                               uname='Step3SFTextField',$
                               /editable,$
                               /align_left,$
                               value='1')

;Before to after arrow
Step3BeforeToAfterDraw = widget_draw(STEP3_BASE,$
                                     uname='Step3_before_to_after_draw',$
                                     xoffset=Step3BeforeToAfterDrawSize[0],$
                                     yoffset=Step3BeforeToAfterDrawSize[1],$
                                     scr_xsize=Step3BeforeToAfterDrawSize[2],$
                                     scr_ysize=Step3BeforeToAfterDrawSize[3])

;Increase buttons
Step3_3IncreaseButton = widget_button(STEP3_BASE,$
                                      uname='step3_3increase_button',$
                                      xoffset=Step3_3IncreaseButtonSize[0],$
                                      yoffset=Step3_3IncreaseButtonSize[1],$
                                      scr_xsize=Step3_3IncreaseButtonSize[2],$
                                      scr_ysize=Step3_3IncreaseButtonSize[3],$
                                      value='+++')

Step3_2IncreaseButton = widget_button(STEP3_BASE,$
                                      uname='step3_2increase_button',$
                                      xoffset=Step3_2IncreaseButtonSize[0],$
                                      yoffset=Step3_2IncreaseButtonSize[1],$
                                      scr_xsize=Step3_2IncreaseButtonSize[2],$
                                      scr_ysize=Step3_2IncreaseButtonSize[3],$
                                      value='++')

Step3_1IncreaseButton = widget_button(STEP3_BASE,$
                                      uname='step3_1increase_button',$
                                      xoffset=Step3_1IncreaseButtonSize[0],$
                                      yoffset=Step3_1IncreaseButtonSize[1],$
                                      scr_xsize=Step3_1IncreaseButtonSize[2],$
                                      scr_ysize=Step3_1IncreaseButtonSize[3],$
                                      value='+')


;Decrease buttons
Step3_3DecreaseButton = widget_button(STEP3_BASE,$
                                      uname='step3_3decrease_button',$
                                      xoffset=Step3_3DecreaseButtonSize[0],$
                                      yoffset=Step3_3DecreaseButtonSize[1],$
                                      scr_xsize=Step3_3DecreaseButtonSize[2],$
                                      scr_ysize=Step3_3DecreaseButtonSize[3],$
                                      value='---')

Step3_2DecreaseButton = widget_button(STEP3_BASE,$
                                      uname='step3_2decrease_button',$
                                      xoffset=Step3_2DecreaseButtonSize[0],$
                                      yoffset=Step3_2DecreaseButtonSize[1],$
                                      scr_xsize=Step3_2DecreaseButtonSize[2],$
                                      scr_ysize=Step3_2DecreaseButtonSize[3],$
                                      value='--')

Step3_1DecreaseButton = widget_button(STEP3_BASE,$
                                      uname='step3_1decrease_button',$
                                      xoffset=Step3_1DecreaseButtonSize[0],$
                                      yoffset=Step3_1DecreaseButtonSize[1],$
                                      scr_xsize=Step3_1DecreaseButtonSize[2],$
                                      scr_ysize=Step3_1DecreaseButtonSize[3],$
                                      value='-')


STEP3_Manual_mode_label = widget_label(STEP3_BASE,$
                                       xoffset=Step3ManualModeLabelSize[0],$
                                       yoffset=Step3ManualModeLabelSize[1],$
                                       value=Step3ManualModeLabelTitle)

STEP3_Manual_mode_frame = widget_label(STEP3_BASE,$
                                       xoffset=Step3ManualModeFrameSize[0],$
                                       yoffset=Step3ManualModeFrameSize[1],$
                                       scr_xsize=Step3ManualModeFrameSize[2],$
                                       scr_ysize=Step3ManualModeFrameSize[3],$
                                       value='',$
                                       frame=1)













END
