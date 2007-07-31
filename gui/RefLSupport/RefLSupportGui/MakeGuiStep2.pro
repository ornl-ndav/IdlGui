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

Step2GoButtonSize    = [350, 7  , 170 , 30 ]
Step2TabSize         = [5  , 60 , 320 , 70 ]
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

Step2RDrawSize      = [330,$
                       45,$
                       30,$
                       30]
Step2RTextFieldSize  = [Step2RDrawSize[0]+distance_L_TB, $
                        Step2RDrawSize[1], $
                        Step2Q1TextFieldSize[2],$
                        Step2Q1TextFieldSize[3]]

Step2DeltaRDrawSize      = [Step2RDrawSize[0], $
                            Step2RDrawSize[1]+distanceVertical_L_L, $
                            Step2RDrawSize[2],$
                            Step2RDrawSize[3]]
Step2DeltaRLabelSize  = [Step2RTextFieldSize[0],$
                         Step2DeltaRDrawSize[1], $
                         Step2Q1TextFieldSize[2],$
                         Step2Q1TextFieldSize[3]]

Step2SFDrawSize     = [Step2DeltaRDrawSize[0], $
                       Step2DeltaRDrawsize[1]+distanceVertical_L_L,$
                       Step2Q1LabelSize[2],$
                       Step2Q1LabelSize[3]]
Step2SFTextFieldSize = [Step2SFDrawSize[0]+distance_L_TB,$
                        Step2SFDrawSize[1],$
                        Step2Q1TextFieldSize[2],$
                        Step2Q1TextFieldSize[3]]

;Define titles
BaseFileTitle      = 'Critical edge file:'
Step2Tab1Title     = 'Determine SF using Q range'
Step2Tab2Title     = 'Deternine SF using mouse'
Step2GoButtonTitle = 'Rescale Critical Edge'
Step2Q1LabelTitle  = 'Qmin:'
Step2Q2LabelTitle  = 'Qmax:'
Step2SFLabelTitle  = 'SF:'
Step2XLabelTitle = 'X:'
Step2YLabelTitle = 'Y:'
Step2RLabelTitle = 'r :'

;Build GUI
STEP2_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step2',$
                         TITLE=Step2Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

;removed droplist in first version of program
;;BASE_FILE_DROPLIST = WIDGET_DROPLIST(STEPS_TAB,$
;;                                      UNAME='base_file_droplist',$
;;                                      XOFFSET=BaseFileSize[0],$
;;                                      YOFFSET=BaseFileSize[1],$
;;                                      SCR_XSIZE=BaseFileSize[2],$
;;                                      SCR_YSIZE=BaseFileSize[3],$
;;                                      VALUE=ListOfFiles,$
;;                                      TITLE=BaseFileTitle)

BASE_FILE_Label = widget_label(STEP2_BASE,$
                               xoffset=BaseFileCELabel[0],$
                               yoffset=BaseFileCELabel[1],$
                               scr_xsize=BaseFileCELabel[2],$
                               scr_ysize=BaseFileCELabel[3],$
                               value=BaseFileTitle)

BASE_FILE_CE_file_name = widget_label(STEP2_BASE,$
                                      UNAME='bas_file_ce_file_name',$
                                      xoffset=BaseFileCEFileName[0],$
                                      yoffset=BaseFileCEFileName[1],$
                                      scr_xsize=BaseFileCEFileName[2],$
                                      scr_ysize=BaseFileCEFileName[3],$
                                      value='',$
                                      /align_left)

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



;--tab #2 of step 2
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

;--outside tab of step2
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
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

step2_ri_draw = WIDGET_DRAW(STEP2_BASE,$
                            uname='step2_ri_draw',$
                            XOFFSET=Step2RDrawSize[0],$
                            YOFFSET=Step2RDrawSize[1],$
                            SCR_XSIZE=Step2RDrawSize[2],$
                            SCR_YSIZE=Step2RDrawSize[3])

STEP2_R_TEXT_FIELD = WIDGET_TEXT(STEP2_BASE,$
                                 UNAME='step2_R_text_field',$
                                 XOFFSET=Step2RTextFieldSize[0],$
                                 YOFFSET=Step2RTextFieldSize[1],$
                                 SCR_XSIZE=Step2RTextFieldSize[2],$
                                 SCR_YSIZE=Step2RTextFieldSize[3],$
                                 VALUE='',$
                                 /EDITABLE,$
                                 /ALIGN_LEFT,$
                                 /ALL_EVENTS)

STEP2_delta_ri_draw = WIDGET_DRAW(STEP2_BASE,$
                                 uname='step2_delta_ri_draw',$
                                 XOFFSET=Step2DeltaRDrawSize[0],$
                                 YOFFSET=Step2DeltaRDrawSize[1],$
                                 SCR_XSIZE=Step2DeltaRDrawSize[2],$
                                 SCR_YSIZE=Step2DeltaRDrawSize[3])

STEP2_deltaR_label = WIDGET_LABEL(STEP2_BASE,$
                                  UNAME='step2_deltaR_label',$
                                  XOFFSET=Step2DeltaRLabelSize[0],$
                                  YOFFSET=Step2DeltaRLabelSize[1],$
                                  SCR_XSIZE=Step2DeltaRLabelSize[2],$
                                  SCR_YSIZE=Step2DeltaRLabelSize[3],$
                                  VALUE='',$
                                  /ALIGN_LEFT)



END
