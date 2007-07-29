PRO MakeGuiStep3, STEPS_TAB,$
                  Step1Size,$
                  Step3Title,$
                  ListOfFiles

distance_L_TB        = 35
distance_L_L         = 125
distanceVertical_L_L = 35
 
;Define position and size of widgets
Step3WorkOnFileSize  = [5  , 5  , 300 , 30]
Step3GoButtonSize    = [310, 7  , 205 , 30 ]

Step3Q1LabelSize     = [5  , 55 , 30  , 30 ]
Step3Q1TextFieldSize = [Step3Q1LabelSize[0]+distance_L_TB, $
                        Step3Q1LabelSize[1],$
                        80,$
                        Step3Q1LabelSize[3]]
Step3Q2LabelSize     = [Step3Q1LabelSize[0]+distance_L_L, $
                        Step3Q1LabelSize[1],$
                        Step3Q1LabelSize[2],$
                        Step3Q1LabelSize[3]]
Step3Q2TextFieldSize = [Step3Q2LabelSize[0]+distance_L_TB, $
                        Step3Q1LabelSize[1],$
                        Step3Q1TextFieldSize[2],$
                        Step3Q1LabelSize[3]]

Step3RDrawSize      = [330,$
                       45,$
                       30,$
                       30]
Step3RTextFieldSize  = [Step3RDrawSize[0]+distance_L_TB, $
                        Step3RDrawSize[1], $
                        Step3Q1TextFieldSize[2],$
                        Step3Q1TextFieldSize[3]]

Step3DeltaRDrawSize      = [Step3RDrawSize[0], $
                            Step3RDrawSize[1]+distanceVertical_L_L, $
                            Step3RDrawSize[2],$
                            Step3RDrawSize[3]]
Step3DeltaRLabelSize  = [Step3RTextFieldSize[0],$
                         Step3DeltaRDrawSize[1], $
                         Step3Q1TextFieldSize[2],$
                         Step3Q1TextFieldSize[3]]

Step3SFDrawSize     = [Step3DeltaRDrawSize[0], $
                       Step3DeltaRDrawsize[1]+distanceVertical_L_L,$
                       Step3Q1LabelSize[2],$
                       Step3Q1LabelSize[3]]
Step3SFTextFieldSize = [Step3SFDrawSize[0]+distance_L_TB,$
                        Step3SFDrawSize[1],$
                        Step3Q1TextFieldSize[2],$
                        Step3Q1TextFieldSize[3]]


;Define titles
Step3WorkOnFileTitle = 'Work On:'
Step3GoButtonTitle = 'Rescale Work-on file'
ListOfFiles  = ['                            ']  
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

STEP3_WORK_ON_FILE_DROPLIST = WIDGET_DROPLIST(STEP3_BASE,$
                                           UNAME='step3_work_on_file_droplist',$
                                           XOFFSET=Step3WorkOnFileSize[0],$
                                           YOFFSET=Step3WorkOnFileSize[1],$
                                           SCR_XSIZE=Step3WorkOnFileSize[2],$
                                           SCR_YSIZE=Step3WorkOnFileSize[3],$
                                           VALUE=ListOfFiles,$
                                           TITLE=Step3WorkOnFileTitle)

STEP3_BUTTON = WIDGET_BUTTON(STEP3_BASE,$
                             UNAME='Step3_button',$
                             XOFFSET=Step3GoButtonSize[0],$
                             YOFFSET=Step3GoButtonSize[1],$
                             SCR_XSIZE=Step3GoButtonSize[2],$
                             SCR_YSIZE=Step3GoButtonSize[3],$
                             SENSITIVE=1,$
                             VALUE=Step3GoButtonTitle)

STEP3_Q1_LABEL = WIDGET_LABEL(STEP3_BASE,$
                              XOFFSET=Step3Q1LabelSize[0],$
                              YOFFSET=Step3Q1LabelSize[1],$
                              SCR_XSIZE=Step3Q1LabelSize[2],$
                              SCR_YSIZE=Step3Q1LabelSize[3],$
                              VALUE=Step2Q1LabelTitle)

STEP3_Q1_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
                                  UNAME='step3_q1_text_field',$
                                  XOFFSET=Step3Q1TextFieldSize[0],$
                                  YOFFSET=Step3Q1TextFieldSize[1],$
                                  SCR_XSIZE=Step3Q1TextFieldSize[2],$
                                  SCR_YSIZE=Step3Q1TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

STEP3_Q2_LABEL = WIDGET_LABEL(STEP3_BASE,$
                              XOFFSET=Step3Q2LabelSize[0],$
                              YOFFSET=Step3Q2LabelSize[1],$
                              SCR_XSIZE=Step3Q2LabelSize[2],$
                              SCR_YSIZE=Step3Q2LabelSize[3],$
                              VALUE=Step2Q2LabelTitle)

STEP3_Q2_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
                                  UNAME='step3_q2_text_field',$
                                  XOFFSET=Step3Q2TextFieldSize[0],$
                                  YOFFSET=Step3Q2TextFieldSize[1],$
                                  SCR_XSIZE=Step3Q2TextFieldSize[2],$
                                  SCR_YSIZE=Step3Q2TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

STEP3_SF_draw = WIDGET_draw(STEP3_BASE,$
                            uname='step3_sf_draw',$
                            XOFFSET=Step3SFdrawSize[0],$
                            YOFFSET=Step3SFdrawSize[1],$
                            SCR_XSIZE=Step3SFdrawSize[2],$
                            SCR_YSIZE=Step3SFdrawSize[3])


STEP3_SF_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
                                  UNAME='step3_sf_text_field',$
                                  XOFFSET=Step3SFTextFieldSize[0],$
                                  YOFFSET=Step3SFTextFieldSize[1],$
                                  SCR_XSIZE=Step3SFTextFieldSize[2],$
                                  SCR_YSIZE=Step3SFTextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

step3_ri_draw = WIDGET_DRAW(STEP3_BASE,$
                            uname='step3_ri_draw',$
                            XOFFSET=Step3RDrawSize[0],$
                            YOFFSET=Step3RDrawSize[1],$
                            SCR_XSIZE=Step3RDrawSize[2],$
                            SCR_YSIZE=Step3RDrawSize[3])

STEP3_R_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
                                 UNAME='step3_R_text_field',$
                                 XOFFSET=Step3RTextFieldSize[0],$
                                 YOFFSET=Step3RTextFieldSize[1],$
                                 SCR_XSIZE=Step3RTextFieldSize[2],$
                                 SCR_YSIZE=Step3RTextFieldSize[3],$
                                 VALUE='',$
                                 /EDITABLE,$
                                 /ALIGN_LEFT,$
                                 /ALL_EVENTS)

STEP3_delta_ri_draw = WIDGET_DRAW(STEP3_BASE,$
                                 uname='step3_delta_ri_draw',$
                                 XOFFSET=Step3DeltaRDrawSize[0],$
                                 YOFFSET=Step3DeltaRDrawSize[1],$
                                 SCR_XSIZE=Step3DeltaRDrawSize[2],$
                                 SCR_YSIZE=Step3DeltaRDrawSize[3])

STEP3_deltaR_label = WIDGET_LABEL(STEP3_BASE,$
                                  UNAME='step3_deltaR_label',$
                                  XOFFSET=Step3DeltaRLabelSize[0],$
                                  YOFFSET=Step3DeltaRLabelSize[1],$
                                  SCR_XSIZE=Step3DeltaRLabelSize[2],$
                                  SCR_YSIZE=Step3DeltaRLabelSize[3],$
                                  VALUE='',$
                                  /ALIGN_LEFT)



END
