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
;YLowQ and YHigh Q
Step3YLowQDrawSize       = [45, 200, 60, 40]
d_horizontal_draw_tf = 70
Step3YLowQTextFieldSize  = [Step3YLowQDrawSize[0] + d_horizontal_draw_tf,$
                            Step3YLowQDrawSize[1] + 5,$
                            80,30]
d_vertical_draw_draw = 55
Step3YHighQDrawSize       = [Step3YLowQDrawSize[0],$
                             Step3YLowQDrawSize[1]+ d_vertical_draw_draw,$
                             Step3YLowQDrawSize[2],$
                             Step3YLowQDrawSize[3]]
Step3YHighQTextFieldSize  = [Step3YHighQDrawSize[0] + d_horizontal_draw_tf,$
                             Step3YHighQDrawSize[1] + 5,$
                             Step3YLowQTextFieldSize[2],$
                             Step3YLowQTextFieldSize[3]]

;Before and After
Step3BeforeToAfterDrawSize = [Step3YLowQDrawSize[0]+162,$
                              Step3YLowQDrawSize[1]+7,$
                              40,90]

;SF
Step3SFDrawSize      = [260,220,40,40]
Step3SFTextFieldSize = [Step3SFDrawSize[0] + 50,$
                        Step3SFDrawSize[1] + 5,$
                        Step3YLowQTextFieldSize[2],$
                        Step3YLowQTextFieldSize[3]]

;Manual scaling
Step3ManualScalingButtonSize = [Step3SFTextFieldSize[0]+90,$
                                Step3SFTextFieldSize[1],$
                                100,30]





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
                                               SENSITIVE=1,$
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

;Y low Q
Step3YLowQDraw = widget_draw(STEP3_BASE,$
                             xoffset=Step3YLowQDrawSize[0],$
                             yoffset=Step3YLowQDrawSize[1],$
                             scr_xsize=Step3YLowQDrawSize[2],$
                             scr_ysize=Step3YLowQDrawSize[3],$
                             uname='Step3YLowQDraw')

Step3YLowQTextField = widget_text(STEP3_BASE,$
                                  xoffset=Step3YLowQTextFieldSize[0],$
                                  yoffset=Step3YLowQTextFieldSize[1],$
                                  scr_xsize=Step3YLowQTextFieldSize[2],$
                                  scr_ysize=Step3YLowQTextFieldSize[3],$
                                  uname='Step3YLowQTextField',$
                                  /editable,$
                                  /align_left)
                             
;Y high Q
Step3YHighQDraw = widget_draw(STEP3_BASE,$
                             xoffset=Step3YHighQDrawSize[0],$
                             yoffset=Step3YHighQDrawSize[1],$
                             scr_xsize=Step3YHighQDrawSize[2],$
                             scr_ysize=Step3YHighQDrawSize[3],$
                             uname='Step3YHighQDraw')

Step3YHighQTextField = widget_text(STEP3_BASE,$
                                  xoffset=Step3YHighQTextFieldSize[0],$
                                  yoffset=Step3YHighQTextFieldSize[1],$
                                  scr_xsize=Step3YHighQTextFieldSize[2],$
                                  scr_ysize=Step3YHighQTextFieldSize[3],$
                                  uname='Step3YHighQTextField',$
                                  /editable,$
                                  /align_left)

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
                               /align_left)

;Before to after arrow
Step3BeforeToAfterDraw = widget_draw(STEP3_BASE,$
                                     uname='Step3_before_to_after_draw',$
                                     xoffset=Step3BeforeToAfterDrawSize[0],$
                                     yoffset=Step3BeforeToAfterDrawSize[1],$
                                     scr_xsize=Step3BeforeToAfterDrawSize[2],$
                                     scr_ysize=Step3BeforeToAfterDrawSize[3])
;Manual scaling button
Step3ManualScalingButton = widget_button(STEP3_BASE,$
                                         uname='Step3ManualScalingButton',$
                                         xoffset=Step3ManualScalingButtonSize[0],$
                                         yoffset=Step3ManualScalingButtonSize[1],$
                                         scr_xsize=Step3ManualScalingButtonSize[2],$
                                         scr_ysize=Step3ManualScalingButtonSize[3],$
                                         value=Step3ManualScalingButtonTitle)



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










; STEP3_WORK_ON_FILE_DROPLIST = WIDGET_DROPLIST(STEP3_BASE,$
;                                            UNAME='step3_work_on_file_droplist',$
;                                            XOFFSET=Step3WorkOnFileSize[0],$
;                                            YOFFSET=Step3WorkOnFileSize[1],$
;                                            SCR_XSIZE=Step3WorkOnFileSize[2],$
;                                            SCR_YSIZE=Step3WorkOnFileSize[3],$
;                                            VALUE=ListOfFiles,$
;                                            TITLE=Step3WorkOnFileTitle)

; STEP3_BUTTON = WIDGET_BUTTON(STEP3_BASE,$
;                              UNAME='Step3_button',$
;                              XOFFSET=Step3GoButtonSize[0],$
;                              YOFFSET=Step3GoButtonSize[1],$
;                              SCR_XSIZE=Step3GoButtonSize[2],$
;                              SCR_YSIZE=Step3GoButtonSize[3],$
;                              SENSITIVE=1,$
;                              VALUE=Step3GoButtonTitle)

; STEP3_Q1_LABEL = WIDGET_LABEL(STEP3_BASE,$
;                               XOFFSET=Step3Q1LabelSize[0],$
;                               YOFFSET=Step3Q1LabelSize[1],$
;                               SCR_XSIZE=Step3Q1LabelSize[2],$
;                               SCR_YSIZE=Step3Q1LabelSize[3],$
;                               VALUE=Step2Q1LabelTitle)

; STEP3_Q1_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
;                                   UNAME='step3_q1_text_field',$
;                                   XOFFSET=Step3Q1TextFieldSize[0],$
;                                   YOFFSET=Step3Q1TextFieldSize[1],$
;                                   SCR_XSIZE=Step3Q1TextFieldSize[2],$
;                                   SCR_YSIZE=Step3Q1TextFieldSize[3],$
;                                   VALUE='',$
;                                   /EDITABLE,$
;                                   /ALIGN_LEFT,$
;                                   /ALL_EVENTS)

; STEP3_Q2_LABEL = WIDGET_LABEL(STEP3_BASE,$
;                               XOFFSET=Step3Q2LabelSize[0],$
;                               YOFFSET=Step3Q2LabelSize[1],$
;                               SCR_XSIZE=Step3Q2LabelSize[2],$
;                               SCR_YSIZE=Step3Q2LabelSize[3],$
;                               VALUE=Step2Q2LabelTitle)

; STEP3_Q2_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
;                                   UNAME='step3_q2_text_field',$
;                                   XOFFSET=Step3Q2TextFieldSize[0],$
;                                   YOFFSET=Step3Q2TextFieldSize[1],$
;                                   SCR_XSIZE=Step3Q2TextFieldSize[2],$
;                                   SCR_YSIZE=Step3Q2TextFieldSize[3],$
;                                   VALUE='',$
;                                   /EDITABLE,$
;                                   /ALIGN_LEFT,$
;                                   /ALL_EVENTS)

; STEP3_SF_draw = WIDGET_draw(STEP3_BASE,$
;                             uname='step3_sf_draw',$
;                             XOFFSET=Step3SFdrawSize[0],$
;                             YOFFSET=Step3SFdrawSize[1],$
;                             SCR_XSIZE=Step3SFdrawSize[2],$
;                             SCR_YSIZE=Step3SFdrawSize[3])


; STEP3_SF_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
;                                   UNAME='step3_sf_text_field',$
;                                   XOFFSET=Step3SFTextFieldSize[0],$
;                                   YOFFSET=Step3SFTextFieldSize[1],$
;                                   SCR_XSIZE=Step3SFTextFieldSize[2],$
;                                   SCR_YSIZE=Step3SFTextFieldSize[3],$
;                                   VALUE='',$
;                                   /EDITABLE,$
;                                   /ALIGN_LEFT,$
;                                   /ALL_EVENTS)

; step3_ri_draw = WIDGET_DRAW(STEP3_BASE,$
;                             uname='step3_ri_draw',$
;                             XOFFSET=Step3RDrawSize[0],$
;                             YOFFSET=Step3RDrawSize[1],$
;                             SCR_XSIZE=Step3RDrawSize[2],$
;                             SCR_YSIZE=Step3RDrawSize[3])

; STEP3_R_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
;                                  UNAME='step3_R_text_field',$
;                                  XOFFSET=Step3RTextFieldSize[0],$
;                                  YOFFSET=Step3RTextFieldSize[1],$
;                                  SCR_XSIZE=Step3RTextFieldSize[2],$
;                                  SCR_YSIZE=Step3RTextFieldSize[3],$
;                                  VALUE='',$
;                                  /EDITABLE,$
;                                  /ALIGN_LEFT,$
;                                  /ALL_EVENTS)

; STEP3_delta_ri_draw = WIDGET_DRAW(STEP3_BASE,$
;                                  uname='step3_delta_ri_draw',$
;                                  XOFFSET=Step3DeltaRDrawSize[0],$
;                                  YOFFSET=Step3DeltaRDrawSize[1],$
;                                  SCR_XSIZE=Step3DeltaRDrawSize[2],$
;                                  SCR_YSIZE=Step3DeltaRDrawSize[3])

; STEP3_deltaR_label = WIDGET_LABEL(STEP3_BASE,$
;                                   UNAME='step3_deltaR_label',$
;                                   XOFFSET=Step3DeltaRLabelSize[0],$
;                                   YOFFSET=Step3DeltaRLabelSize[1],$
;                                   SCR_XSIZE=Step3DeltaRLabelSize[2],$
;                                   SCR_YSIZE=Step3DeltaRLabelSize[3],$
;                                   VALUE='',$
;                                   /ALIGN_LEFT)



END
