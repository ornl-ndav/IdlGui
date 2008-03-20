PRO MakeGuiStep2, STEPS_TAB,$
                  Step1Size,$
                  Step2Title,$
                  distance_L_TB,$
                  distance_L_L,$
                  distanceVertical_L_L,$
                  ListOfFiles

;Define position and size of widgets
BaseFileSize         = [5  , 5  , 250 , 30 ]

BaseFileCELabel      = [5  , 5  , 150  , 30 ]
BaseFileCEFileName   = [155, 5  , 150 , 30 ]

Step2TabSize         = [5  , 50 , 500 , 70 ]
Step2Tab1Base        = [0  , 0  , Step2TabSize[2] , Step2TabSize[3]]
Step2Tab2Base        = Step2Tab1Base
Step2Q1LabelSize     = [5  , 5 , 30  , 30 ]
Step2Q1TextFieldSize = [Step2Q1LabelSize[0]+distance_L_TB, $
                        Step2Q1LabelSize[1],$
                        80,$
                        Step2Q1LabelSize[3]]

Step2Q2LabelSize     = [Step2Q1LabelSize[0]+distance_L_L, $
                        Step2Q1LabelSize[1],$
                        Step2Q1LabelSize[2],$
                        Step2Q1LabelSize[3]]
Step2Q2TextFieldSize = [Step2Q2LabelSize[0]+distance_L_TB, $
                        Step2Q1LabelSize[1],$
                        Step2Q1TextFieldSize[2],$
                        Step2Q1LabelSize[3]]

distance_L_L_2 = distance_L_L - 15
Step2Q1Q2ErrorLabelSize = [Step2Q2LabelSize[0]+distance_L_L_2,$
                           Step2Q2Labelsize[1],$
                           250,$
                           Step2Q1LabelSize[3]]

Step2XLabelSize     = [5  , 5 , 30  , 30 ]
Step2XTextFieldSize = [Step2XLabelSize[0]+distance_L_TB, $
                       Step2XLabelSize[1],$
                       80,$
                       Step2XLabelSize[3]]
Step2YLabelSize     = [Step2XLabelSize[0]+distance_L_L, $
                       Step2XLabelSize[1],$
                       Step2XLabelSize[2],$
                       Step2XLabelSize[3]]
Step2YTextFieldSize = [Step2YLabelSize[0]+distance_L_TB, $
                       Step2XLabelSize[1],$
                       Step2XTextFieldSize[2],$
                       Step2XLabelSize[3]]

;automatic go button
Step2AutomaticFittingSize = [5, 130, 125, 30]
d11 = 126
Step2ANDlabel = [Step2AutomaticFittingSize[0]+d11,$
                 Step2AutomaticFittingSize[1]+5]
d_b1_b2 = 137
Step2AutomaticScalingsize = [Step2AutomaticFittingSize[0]+d_b1_b2,$
                             Step2AutomaticFittingSize[1],$
                             Step2AutomaticFittingSize[2],$
                             Step2AutomaticFittingSize[3]]
Step2ORlabel = [Step2AutomaticScalingSize[0]+d11,$
                Step2AutomaticScalingSize[1]+5]
d_b2_b3 = 143
Step2GoButtonSize    = [Step2AutomaticScalingSize[0]+d_b2_b3,$
                        Step2AutomaticScalingSize[1],$
                        Step2AutomaticScalingSize[2]+97,$
                        Step2AutomaticScalingSize[3]]

;manual label
Step2ManualFittingFrameSize = [5, Step2GoButtonSize[1]+40, 500, 180]
Step2ManualFittingFrameLabelSize = [20, Step2GoButtonSize[1]+33]

;fitting equation label
step2FittingEquationLabelSize = [10, Step2GoButtonSize[1]+58]
distance_1 = 130
step2FittingEquationATextFieldSize = [step2FittingEquationLabelSize[0]+distance_1,$
                                      step2FittingEquationLabelSize[1]-5,$
                                      100,$
                                      30]
distance_2 = 100
step2FittingEquationXLabelSize = [step2FittingEquationATextFieldSize[0]+distance_2,$
                                  step2FittingEquationLabelSize[1]]
distance_3 = 17
step2FittingEquationBTextFieldSize = [step2FittingEquationXLabelSize[0]+distance_3,$
                                      step2FittingEquationLabelSize[1]-5,$
                                      100,30]
distance_4 = 100
Step2ManualGoButtonSize = [step2FittingEquationBTextFieldSize[0]+distance_4,$
                           step2FittingEquationLabelSize[1]-5,$
                           145,30]

;Average Y before and after
Step2YBeforeDrawSize = [ 25, 245, 60, 40]
Step2YAfterDrawSize  = [ 25, Step2YBeforeDrawSize[1]+50, 60, 40]

Step2YBeforeTextField = [Step2YBeforeDrawSize[0]+70,$
                         Step2YBeforeDrawSize[1]+5,$
                         80, 30]
Step2YAfterTextField  = [Step2YAfterDrawSize[0]+70,$
                         Step2YAfterDrawSize[1]+5,$
                         80, 30]

;From before to after
Step2BeforeToAfterDrawSize = [185, Step2YBeforeDrawSize[1]-3,$
                              40, 100]


;SF
Step2SFdrawSize      = [225,Step2YBeforeDrawSize[1]+25,40,40]
d1=50
Step2SFTextFieldSize = [Step2SFdrawSize[0]+d1,$
                        Step2SFdrawSize[1]+5,80,30]

;Manual scalling of CE file
Step2ManualScalingButtonSize = [Step2ManualGoButtonSize[0],$
                                Step2SFTextFieldSize[1],$
                                Step2ManualGoButtonSize[2],$
                                STep2ManualGoButtonSize[3]]

;Define titles
BaseFileTitle      = 'Critical edge file:'
Step2Tab1Title     = 'Determine SF using Q range'
Step2Tab2Title     = 'Deternine SF using mouse'
Step2AutomaticFittingButtonTitle = 'Automatic Fitting'
Step2AutomaticScalingButtonTitle = 'Automatic Scaling'
Step2GoButtonTitle = 'Automatic Fitting/Rescaling of CE'
Step2ManualGoButtonTitle = 'Manual Fitting of CE'
Step2ManualScalingButtonTitle = 'Manual Scaling of CE'
Step2Q1LabelTitle  = 'Qmin:'
Step2Q2LabelTitle  = 'Qmax:'
Step2SFLabelTitle  = 'SF:'
Step2XLabelTitle = 'X:'
Step2YLabelTitle = 'Y:'

Step2YAfterValue = strcompress(1,/remove_all)

Step2FittingEquationLabel = 'Fitting equation:  Y='
Step2FittingEquationXLabel = 'X+'


;Build GUI
STEP2_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step2',$
                         TITLE=Step2Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

BASE_FILE_Label = widget_label(STEP2_BASE,$
                               xoffset=BaseFileCELabel[0],$
                               yoffset=BaseFileCELabel[1],$
                               scr_xsize=BaseFileCELabel[2],$
                               scr_ysize=BaseFileCELabel[3],$
                               value=BaseFileTitle)

BASE_FILE_CE_file_name = widget_label(STEP2_BASE,$
                                      UNAME='short_ce_file_name',$
                                      xoffset=BaseFileCEFileName[0],$
                                      yoffset=BaseFileCEFileName[1],$
                                      scr_xsize=BaseFileCEFileName[2],$
                                      scr_ysize=BaseFileCEFileName[3],$
                                      value='',$
                                      /align_left)

STEP2_automatic_fitting_button = WIDGET_BUTTON(STEP2_BASE,$
                                           UNAME='step2_automatic_fitting_button',$
                                           XOFFSET=Step2automaticFittingSize[0],$
                                           YOFFSET=Step2automaticFittingSize[1],$
                                           SCR_XSIZE=Step2automaticFittingSize[2],$
                                           SCR_YSIZE=Step2automaticFittingSize[3],$
                                           SENSITIVE=1,$
                                           VALUE=Step2AutomaticFittingButtonTitle)

Step2_and_label = widget_label(STEP2_BASE,$
                               xoffset=Step2ANDlabel[0],$
                               yoffset=Step2ANDlabel[1],$
                               value='&')

STEP2_automatic_scaling_button = WIDGET_BUTTON(STEP2_BASE,$
                                               UNAME='step2_automatic_scaling_button',$
                                               XOFFSET=Step2automaticScalingSize[0],$
                                               YOFFSET=Step2automaticScalingSize[1],$
                                               SCR_XSIZE=Step2automaticScalingSize[2],$
                                               SCR_YSIZE=Step2automaticScalingSize[3],$
                                               SENSITIVE=0,$
                                               VALUE=Step2AutomaticScalingButtonTitle)

Step2_or_label = widget_label(STEP2_BASE,$
                              xoffset=Step2ORlabel[0],$
                              yoffset=Step2ORlabel[1],$
                              value='or')

STEP2_BUTTON = WIDGET_BUTTON(STEP2_BASE,$
                             UNAME='Step2_button',$
                             XOFFSET=Step2GoButtonSize[0],$
                             YOFFSET=Step2GoButtonSize[1],$
                             SCR_XSIZE=Step2GoButtonSize[2],$
                             SCR_YSIZE=Step2GoButtonSize[3],$
                             SENSITIVE=1,$
                             VALUE=Step2GoButtonTitle)

;--tabs of step2
STEP2TAB = WIDGET_TAB(step2_base,$
                      UNAME='step2tab',$
                      LOCATION=0,$
                      XOFFSET=Step2TabSize[0],$
                      YOFFSET=Step2TabSize[1],$
                      SCR_XSIZE=Step2TabSize[2],$
                      SCR_YSIZE=Step2TabSize[3],$
                      /TRACKING_EVENTS)

;--tab 1 of step 2
step2tab1base = widget_base(step2tab,$
                            uname='step2tab1base',$
                            xoffset=Step2Tab1Base[0],$
                            yoffset=Step2Tab1Base[1],$
                            scr_xsize=Step2Tab1Base[2],$
                            scr_ysize=Step2Tab1Base[3],$
                            title=step2Tab1Title)

STEP2_Q1_LABEL = WIDGET_LABEL(step2tab1base,$
                              XOFFSET=Step2Q1LabelSize[0],$
                              YOFFSET=Step2Q1LabelSize[1],$
                              SCR_XSIZE=Step2Q1LabelSize[2],$
                              SCR_YSIZE=Step2Q1LabelSize[3],$
                              VALUE=Step2Q1LabelTitle)

STEP2_Q1_TEXT_FIELD = WIDGET_TEXT(step2tab1base,$
                                  UNAME='step2_q1_text_field',$
                                  XOFFSET=Step2Q1TextFieldSize[0],$
                                  YOFFSET=Step2Q1TextFieldSize[1],$
                                  SCR_XSIZE=Step2Q1TextFieldSize[2],$
                                  SCR_YSIZE=Step2Q1TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

STEP2_Q2_LABEL = WIDGET_LABEL(step2tab1base,$
                              XOFFSET=Step2Q2LabelSize[0],$
                              YOFFSET=Step2Q2LabelSize[1],$
                              SCR_XSIZE=Step2Q2LabelSize[2],$
                              SCR_YSIZE=Step2Q2LabelSize[3],$
                              VALUE=Step2Q2LabelTitle)

STEP2_Q2_TEXT_FIELD = WIDGET_TEXT(step2tab1base,$
                                  UNAME='step2_q2_text_field',$
                                  XOFFSET=Step2Q2TextFieldSize[0],$
                                  YOFFSET=Step2Q2TextFieldSize[1],$
                                  SCR_XSIZE=Step2Q2TextFieldSize[2],$
                                  SCR_YSIZE=Step2Q2TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)
Step2Q1Q2ErrorLabel = widget_label(step2tab1base,$
                                   uname='step2_q1q1_error_label',$
                                   xoffset=Step2Q1Q2ErrorLabelSize[0],$
                                   yoffset=Step2Q1Q2ErrorLabelSize[1],$
                                   scr_xsize=Step2Q1Q2ErrorLabelSize[2],$
                                   scr_ysize=Step2Q1Q2ErrorLabelSize[3],$
                                   value='')
;;--tab #2 of step 2
step2tab2base = widget_base(step2tab,$
                            uname='step2tab2base',$
                            xoffset=Step2Tab2Base[0],$
                            yoffset=Step2Tab2Base[1],$
                            scr_xsize=Step2Tab2Base[2],$
                            scr_ysize=Step2Tab2Base[3],$
                            title=step2Tab2Title)

STEP2_X_LABEL = WIDGET_LABEL(step2tab2base,$
                             XOFFSET=Step2XLabelSize[0],$
                             YOFFSET=Step2XLabelSize[1],$
                             SCR_XSIZE=Step2XLabelSize[2],$
                             SCR_YSIZE=Step2XLabelSize[3],$
                             VALUE=Step2XLabelTitle)

STEP2_X_TEXT_FIELD = WIDGET_TEXT(step2tab2base,$
                                 UNAME='step2_x_text_field',$
                                 XOFFSET=Step2XTextFieldSize[0],$
                                 YOFFSET=Step2XTextFieldSize[1],$
                                 SCR_XSIZE=Step2XTextFieldSize[2],$
                                 SCR_YSIZE=Step2XTextFieldSize[3],$
                                 VALUE='',$
                                 /EDITABLE,$
                                 /ALIGN_LEFT,$
                                 /ALL_EVENTS)

STEP2_Y_LABEL = WIDGET_LABEL(step2tab2base,$
                             XOFFSET=Step2YLabelSize[0],$
                             YOFFSET=Step2YLabelSize[1],$
                             SCR_XSIZE=Step2YLabelSize[2],$
                             SCR_YSIZE=Step2YLabelSize[3],$
                             VALUE=Step2YLabelTitle)

STEP2_Y_TEXT_FIELD = WIDGET_TEXT(step2tab2base,$
                                 UNAME='step2_Y_text_field',$
                                 XOFFSET=Step2YTextFieldSize[0],$
                                 YOFFSET=Step2YTextFieldSize[1],$
                                 SCR_XSIZE=Step2YTextFieldSize[2],$
                                 SCR_YSIZE=Step2YTextFieldSize[3],$
                                 VALUE='',$
                                 /EDITABLE,$
                                 /ALIGN_LEFT,$
                                 /ALL_EVENTS)

;Manual fitting equation label outside tab of step2
step2FittingEquationLabel = widget_label(STEP2_BASE,$
                                         value=Step2FittingEquationLabel,$
                                         xoffset=step2FittingEquationLabelSize[0],$
                                         yoffset=step2FittingEquationLabelSize[1])

step2FittingEquationATextField = widget_text(STEP2_BASE,$
                                             uname='step2_fitting_equation_a_text_field',$
                                             xoffset=step2FittingEquationATextFieldSize[0],$
                                             yoffset=step2FittingEquationATextFieldSize[1],$
                                             scr_xsize=step2FittingEquationATextFieldSize[2],$
                                             scr_ysize=step2FittingEquationATextFieldSize[3],$
                                             value='',$
                                             /editable,$
                                             /align_left)

step2FittingEquationXLabel = widget_label(STEP2_BASE,$
                                          value=Step2FittingEquationXLabel,$
                                          xoffset=step2FittingEquationXLabelSize[0],$
                                          yoffset=step2FittingEquationXLabelSize[1])

step2FittingEquationBTextField = widget_text(STEP2_BASE,$
                                             uname='step2_fitting_equation_b_text_field',$
                                             xoffset=step2FittingEquationBTextFieldSize[0],$
                                             yoffset=step2FittingEquationBTextFieldSize[1],$
                                             scr_xsize=step2FittingEquationBTextFieldSize[2],$
                                             scr_ysize=step2FittingEquationBTextFieldSize[3],$
                                             value='',$
                                             /editable,$
                                             /align_left)


Step2ManualGoButton = widget_button(STEP2_BASE,$
                                    uname='step2ManualGoButton',$
                                    xoffset=Step2ManualGoButtonSize[0],$
                                    yoffset=Step2ManualGoButtonSize[1],$
                                    scr_xsize=Step2ManualGoButtonSize[2],$
                                    scr_ysize=Step2ManualGoButtonSize[3],$
                                    value=Step2ManualGoButtonTitle)



;Average Y before and after
Step2YBeforeDraw = widget_draw(STEP2_BASE,$
                               uname='step2_y_before_draw',$
                               xoffset=Step2YBeforeDrawSize[0],$
                               yoffset=Step2YBeforeDrawSize[1],$
                               scr_xsize=Step2YBeforeDrawSize[2],$
                               scr_ysize=Step2YBeforeDrawSize[3])

Step2YBeforeTextField = widget_text(STEP2_BASE,$
                                    uname='step2_y_before_text_field',$
                                    xoffset=Step2YBeforeTextField[0],$
                                    yoffset=Step2YBeforeTextField[1],$
                                    scr_xsize=Step2YBeforeTextField[2],$
                                    scr_ysize=Step2YBeforeTextField[3],$
                                    value='',$
                                    /align_left)

Step2YAfterDraw = widget_draw(STEP2_BASE,$
                               uname='step2_y_after_draw',$
                               xoffset=Step2YAfterDrawSize[0],$
                               yoffset=Step2YAfterDrawSize[1],$
                               scr_xsize=Step2YAfterDrawSize[2],$
                               scr_ysize=Step2YAfterDrawSize[3])

Step2YAfterTextField = widget_text(STEP2_BASE,$
                                    uname='step2_y_after_text_field',$
                                    xoffset=Step2YAfterTextField[0],$
                                    yoffset=Step2YAfterTextField[1],$
                                    scr_xsize=Step2YAfterTextField[2],$
                                    scr_ysize=Step2YAfterTextField[3],$
                                    value=Step2YAfterValue,$
                                    /editable,$
                                    /align_left)

Step2BeforeToAfterDraw = widget_draw(STEP2_BASE,$
                                     uname='step2_before_to_after_draw',$
                                     xoffset=Step2BeforeToAfterDrawSize[0],$
                                     yoffset=Step2BeforeToAfterDrawSize[1],$
                                     scr_xsize=Step2BeforeToAfterDrawSize[2],$
                                     scr_ysize=Step2BeforeToAfterDrawSize[3])



;; --outside tab of step2
 STEP2_SF_draw = WIDGET_draw(STEP2_BASE,$
                             uname='step2_sf_draw',$
                             XOFFSET=Step2SFdrawSize[0],$
                             YOFFSET=Step2SFdrawSize[1],$
                             SCR_XSIZE=Step2SFdrawSize[2],$
                             SCR_YSIZE=Step2SFdrawSize[3])


 STEP2_SF_TEXT_FIELD = WIDGET_TEXT(STEP2_BASE,$
                                   UNAME='step2_sf_text_field',$
                                   XOFFSET=Step2SFTextFieldSize[0],$
                                   YOFFSET=Step2SFTextFieldSize[1],$
                                   SCR_XSIZE=Step2SFTextFieldSize[2],$
                                   SCR_YSIZE=Step2SFTextFieldSize[3],$
                                   VALUE='',$
                                   /EDITABLE,$
                                   /ALIGN_LEFT)

Step2ManualScalingButton = widget_button(STEP2_BASE,$
                                          uname='step2_manual_scaling_button',$
                                          xoffset=Step2ManualScalingButtonSize[0],$
                                          yoffset=Step2ManualScalingButtonSize[1],$
                                          scr_xsize=Step2ManualScalingButtonSize[2],$
                                          scr_ysize=Step2ManualScalingButtonSize[3],$
                                          value=Step2ManualScalingButtonTitle)


 Step2ManualFittingFrameLabel = widget_label(STEP2_BASE,$
                                             xoffset=Step2ManualFittingFrameLabelSize[0],$
                                             yoffset=Step2ManualFittingFrameLabelSize[1],$
                                             value='Manual fitting')
 
 
 Step2ManualFittingFrame = widget_label(STEP2_BASE,$
                                        xoffset=Step2ManualFittingFrameSize[0],$
                                        yoffset=Step2ManualFittingFrameSize[1],$
                                        scr_xsize=Step2ManualFittingFrameSize[2],$
                                        scr_ysize=Step2ManualFittingFrameSize[3],$
                                        frame=1,$
                                        value='')
 

END
