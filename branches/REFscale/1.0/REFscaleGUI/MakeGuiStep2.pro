PRO MakeGuiStep2, STEPS_TAB,$
                  Step1Size,$
                  Step2Title,$
                  distance_L_TB,$
                  distance_L_L,$
                  distanceVertical_L_L,$
                  ListOfFiles

;Define position and size of widgets
sMainBase      = { size      : Step1Size,$
                   title     : Step2Title,$
                   uname     : 'step2' }

;***** Top label that presnt the name of the CE file ***************************
sBaseFileLabel = { size      : [10, 10],$
                   value     : 'Critical edge file:'}

;***** Top label that gives the name of the CE file ****************************
sBFceFile      = { size      : [5, 5, 150, 30],$
                   value     : '',$
                   uname     : 'short_ce_file_name'}

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Base of Qmin and Qmax ***************************************************
sB1_QminQmaxInput = { size   : [5,50,505,40],$
                      uname  : 'step2QinputBase',$
                      frame  : 5}

;***** Q title frame ***********************************************************
sL_QBaseTitle = { size  : [sB1_QminQMaxInput.size[0]+15, $
                           sB1_QminQmaxInput.size[1]-8],$
                  value : 'Range of Q used to calculate the Scalling ' + $
                  'Factor (SF)'}

;***** Qmin label **************************************************************
sL_Qmin = { size   : [55,11],$
            value  : 'Qmin:'}

;***** Qmin text field *********************************************************
XYoff1  = [50,-5]
sT_Qmin = { size   : [sL_Qmin.size[0]+XYoff1[0],$
                      sL_Qmin.size[1]+XYoff1[1],$
                      100,30],$
            uname  : 'step2_q1_text_field',$
            value  : ''}

;***** Qmax label **************************************************************
XYoff   = [200,0]
sL_Qmax = { size  : [sL_Qmin.size[0]+XYoff[0],$
                     sL_Qmin.size[1]+XYoff[1]],$
            value : 'Qmax:'}

;***** Qmax text field *********************************************************
sT_Qmax = { size   : [sL_Qmax.size[0]+XYoff1[0],$
                      sL_Qmax.size[1]+XYoff1[1],$
                      sT_Qmin.size[2],$
                      sT_Qmin.size[3]],$
            uname  : 'step2_q2_text_field',$
            value  : ''}

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Auto Mode base **********************************************************
XYoff        = [0,20]
sAutoBase    = { size   : [sB1_QminQmaxInput.size[0]+XYoff[0],$
                           sB1_QminQmaxInput.size[1]+ $
                           sB1_QminQmaxInput.size[3]+XYoff[1],$
                           sB1_QminQmaxInput.size[2],40],$
                 uname  : 'auto_mode_base',$
                 frame  : 5}

;***** Auto mode base title ****************************************************
sAutoBaseTitle = { size  : [sAutoBase.size[0]+15, $
                            sAutoBase.size[1]-8],$
                   value : 'Automatic Mode'} 

;***** Auto Fitting Button *****************************************************
sAutoFit       = { size      : [5, 5, 125, 30],$
                   value     : 'Automatic Fitting',$
                   sensitive : 1 }

;***** & label *****************************************************************
XYoff          = [126,5]
sStep2Label    = { size      : [sAutoFit.size[0]+XYoff[0],$
                                sAutoFit.size[1]+XYoff[1]],$
                   value     : '&'}

;***** Auto Scalling ***********************************************************
XYoff          = [137,0]
sAutoScal      = { size      : [sAutoFit.size[0]+XYoff[0],$
                                sAutoFit.size[1]+XYoff[1],$
                                sAutoFit.size[2],$
                                sAutoFit.size[3]],$
                   uname     : 'step2_automatic_scaling_button',$
                   value     : 'Automatic Scaling',$
                   sensitive : 0}

;***** OR label ****************************************************************
XYoff          = [128,6.]
sStep2Or       = { size      : [sAutoScal.size[0]+XYoff[0],$
                                sAutoScal.size[1]+XYoff[1]],$
                   value     : 'OR'}

;***** Auto Fitting and Scalling button ****************************************
XYoff          = [146,0]
sB_AutoScalFit = { size      : [sAutoScal.size[0]+XYoff[0],$
                                sAutoScal.size[1]+XYoff[1],$
                                210,$
                                sAutoScal.size[3]],$
                   uname     : 'step2_button',$
                   sensitive : 1,$
                   value     : 'Automatic Fitting / Rescaling'}

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Manual ******************************************************************
XYoff       = [0,20]
sManualBase =  { size   : [sAutoBase.size[0]+XYoff[0],$
                           sAutoBase.size[1]+ $
                           sAutoBase.size[3]+XYoff[1],$
                           sAutoBase.size[2],$
                           150],$
                 uname  : 'manual_mode_base',$
                 frame  : 5}

;***** Manual title ************************************************************
sManualBaseTitle = { size  : [sManualBase.size[0]+15,$
                              sManualBase.size[1]-8],$
                     value : 'Manual Mode'}

;***** Manual Fitting Equation Label *******************************************
sManualFittingLabel = { size  : [5,10],$
                        value : 'Fitting equation:  Y='}

;***** Manual Fitting a text field *********************************************
XYoff               = [135,-8]
sManualFitting_a_TF = { size  : [sManualFittingLabel.size[0]+XYoff[0],$
                                 sManualFittingLabel.size[1]+XYoff[1],$
                                 80,$
                                 30],$
                        value : '',$
                        uname : 'step2_fitting_equation_a_text_field'}

;***** Manual Fitting Equation b label *****************************************
XYoff              = [5,0]
sManualFitting_b_L = { size  : [sManualFitting_a_TF.size[0]+ $
                                sManualFitting_a_TF.size[2]+XYoff[0],$
                                sManualFittingLabel.size[1]],$
                       value : 'X +'}

;***** Manual Fitting Equation b text field ************************************
XYoff               = [25,0]
sManualFitting_b_TF = { size  : [sManualFitting_b_L.size[0]+XYoff[0],$
                                 sManualFitting_a_TF.size[1:3]],$
                        value : '',$
                        uname : 'step2_fitting_equation_b_text_field'}


; d_b2_b3 = 143
; Step2GoButtonSize    = [Step2AutomaticScalingSize[0]+d_b2_b3,$
;                         Step2AutomaticScalingSize[1],$
;                         Step2AutomaticScalingSize[2]+97,$
;                         Step2AutomaticScalingSize[3]]





; BaseFileCEFileName   = [155, 5  , 150 , 30 ]





; distance_L_L_2 = distance_L_L - 15
; Step2Q1Q2ErrorLabelSize = [Step2Q2LabelSize[0]+distance_L_L_2,$
;                            Step2Q2Labelsize[1],$
;                            250,$
;                            Step2Q1LabelSize[3]]

; Step2YLabelSize     = [Step2XLabelSize[0]+distance_L_L, $
;                        Step2XLabelSize[1],$
;                        Step2XLabelSize[2],$
;                        Step2XLabelSize[3]]
; Step2YTextFieldSize = [Step2YLabelSize[0]+distance_L_TB, $
;                        Step2XLabelSize[1],$
;                        Step2XTextFieldSize[2],$
;                        Step2XLabelSize[3]]

; ;automatic go button



; ;manual label
; Step2ManualFittingFrameSize = [5, Step2GoButtonSize[1]+40, 500, 180]
; Step2ManualFittingFrameLabelSize = [20, Step2GoButtonSize[1]+33]

; ;fitting equation label
; step2FittingEquationLabelSize = [10, Step2GoButtonSize[1]+58]
; distance_1 = 130
; step2FittingEquationATextFieldSize = [step2FittingEquationLabelSize[0]+distance_1,$
;                                       step2FittingEquationLabelSize[1]-5,$
;                                       100,$
;                                       30]
; distance_2 = 100
; step2FittingEquationXLabelSize = [step2FittingEquationATextFieldSize[0]+distance_2,$
;                                   step2FittingEquationLabelSize[1]]
; distance_3 = 17
; step2FittingEquationBTextFieldSize = [step2FittingEquationXLabelSize[0]+distance_3,$
;                                       step2FittingEquationLabelSize[1]-5,$
;                                       100,30]
; distance_4 = 100
; Step2ManualGoButtonSize = [step2FittingEquationBTextFieldSize[0]+distance_4,$
;                            step2FittingEquationLabelSize[1]-5,$
;                            145,30]

; ;Average Y before and after
; Step2YBeforeDrawSize = [ 25, 245, 60, 40]
; Step2YAfterDrawSize  = [ 25, Step2YBeforeDrawSize[1]+50, 60, 40]

; Step2YBeforeTextField = [Step2YBeforeDrawSize[0]+70,$
;                          Step2YBeforeDrawSize[1]+5,$
;                          80, 30]
; Step2YAfterTextField  = [Step2YAfterDrawSize[0]+70,$
;                          Step2YAfterDrawSize[1]+5,$
;                          80, 30]

; ;From before to after
; Step2BeforeToAfterDrawSize = [185, Step2YBeforeDrawSize[1]-3,$
;                               40, 100]


; ;SF
; Step2SFdrawSize      = [225,Step2YBeforeDrawSize[1]+25,40,40]
; d1=50
; Step2SFTextFieldSize = [Step2SFdrawSize[0]+d1,$
;                         Step2SFdrawSize[1]+5,80,30]

; ;Manual scalling of CE file
; Step2ManualScalingButtonSize = [Step2ManualGoButtonSize[0],$
;                                 Step2SFTextFieldSize[1],$
;                                 Step2ManualGoButtonSize[2],$
;                                 STep2ManualGoButtonSize[3]]

;Define titles
BaseFileTitle      = 'Critical edge file:'





Step2ManualGoButtonTitle = 'Manual Fitting of CE'
Step2ManualScalingButtonTitle = 'Manual Scaling of CE'

Step2Q2LabelTitle  = 'Qmax:'
Step2SFLabelTitle  = 'SF:'
Step2XLabelTitle = 'X:'
Step2YLabelTitle = 'Y:'

Step2YAfterValue = strcompress(1,/remove_all)

Step2FittingEquationXLabel = 'X+'



;===============================================================================
;+++++++++++++++++++++++++++; Build GUI ++++++++++++++++++++++++++++++++++++++++
;===============================================================================
STEP2_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME     = sMainBase.uname,$
                         TITLE     = sMainBase.title,$
                         XOFFSET   = sMainBase.size[0],$
                         YOFFSET   = sMainBase.size[1],$
                         SCR_XSIZE = sMainBase.size[2],$
                         SCR_YSIZE = sMainBase.size[3])

;***** Top label that presnt the name of the CE file ***************************
wBaseFile  = WIDGET_LABEL(STEP2_BASE,$
                          XOFFSET   = sBaseFileLabel.size[0],$
                          YOFFSET   = sBaseFileLabel.size[1],$
                          VALUE     = sBaseFileLabel.value)

;***** Top label that gives the name of the CE file ****************************
wBFceFile  = WIDGET_LABEL(STEP2_BASE,$
                          UNAME     = sBFceFile.uname,$
                          XOFFSET   = sBFceFile.size[0],$
                          YOFFSET   = sBFceFile.size[1],$
                          SCR_XSIZE = sBFceFile.size[2],$
                          SCR_YSIZE = sBFceFile.size[3],$
                          VALUE     = sBFceFile.value,$
                          /ALIGN_LEFT)
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Q base title ************************************************************
wL_QBaseTitle = WIDGET_LABEL(STEP2_BASE,$
                             XOFFSET = sL_QBaseTitle.size[0],$
                             YOFFSET = sL_QBaseTitle.size[1],$
                             VALUE   = sL_QBaseTitle.value)

;***** Base of Qmin and Qmax ***************************************************
Step2QBase = WIDGET_BASE(STEP2_BASE,$
                         UNAME     = sB1_QminQmaxInput.uname,$
                         XOFFSET   = sB1_QminQmaxInput.size[0],$
                         YOFFSET   = sB1_QminQmaxInput.size[1],$
                         SCR_XSIZE = sB1_QminQmaxInput.size[2],$
                         SCR_YSIZE = sB1_QminQmaxInput.size[3],$
                         FRAME     = sB1_QminQmaxInput.frame)
                         
;***** Qmin label **************************************************************
wL_Qmin = WIDGET_LABEL(Step2QBase,$
                       XOFFSET = sL_Qmin.size[0],$
                       YOFFSET = sL_Qmin.size[1],$
                       VALUE   = sL_Qmin.value)

;*** Qmin text field ***********************************************************
wT_Qmin = WIDGET_TEXT(Step2QBase,$
                      XOFFSET   = sT_Qmin.size[0],$
                      YOFFSET   = sT_Qmin.size[1],$
                      SCR_XSIZE = sT_Qmin.size[2],$
                      SCR_YSIZE = sT_Qmin.size[3],$
                      VALUE     = sT_Qmin.value,$
                      UNAME     = sT_Qmin.uname,$
                      /EDITABLE,$
                      /ALIGN_LEFT)

;***** Qmax label **************************************************************
wL_Qmax = WIDGET_LABEL(Step2QBase,$
                       XOFFSET = sL_Qmax.size[0],$
                       YOFFSET = sL_Qmax.size[1],$
                       VALUE   = sL_Qmax.value)

;*** Qmax text field ***********************************************************
wT_Qmax = WIDGET_TEXT(Step2QBase,$
                      XOFFSET   = sT_Qmax.size[0],$
                      YOFFSET   = sT_Qmax.size[1],$
                      SCR_XSIZE = sT_Qmax.size[2],$
                      SCR_YSIZE = sT_Qmax.size[3],$
                      VALUE     = sT_Qmax.value,$
                      UNAME     = sT_Qmax.uname,$
                      /EDITABLE,$
                      /ALIGN_LEFT)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Auto ********************************************************************
wAutoBaseTitle = WIDGET_LABEL(STEP2_BASE,$
                              XOFFSET = sAutoBaseTitle.size[0],$
                              YOFFSET = sAutoBaseTitle.size[1],$
                              VALUE   = sAutoBaseTitle.value)

;***** Auto Mode Base **********************************************************
wAutoBase = WIDGET_BASE(STEP2_BASE,$
                        UNAME     = sAutoBase.uname,$
                        XOFFSET   = sAutoBase.size[0],$
                        YOFFSET   = sAutoBase.size[1],$
                        SCR_XSIZE = sAutoBase.size[2],$
                        SCR_YSIZE = sAutoBase.size[3],$
                        FRAME     = sAutoBase.frame)

;***** Auto Fitting Button *****************************************************
wAutoFit  = WIDGET_BUTTON(wAutoBase,$
                          XOFFSET   = sAutoFit.size[0],$
                          YOFFSET   = sAutoFit.size[1],$
                          SCR_XSIZE = sAutoFit.size[2],$
                          SCR_YSIZE = sAutoFit.size[3],$
                          VALUE     = sAutoFit.value,$
                          SENSITIVE = sAutoFit.sensitive)

;***** & label *****************************************************************
wStep2And = WIDGET_LABEL(wAutoBase,$
                         XOFFSET    = sStep2Label.size[0],$
                         YOFFSET    = sStep2Label.size[1],$
                         VALUE      = sStep2Label.value)

;***** Auto Scalling ***********************************************************
wStep2Auto = WIDGET_BUTTON(wAutoBase,$
                           UNAME     = sAutoScal.uname,$
                           XOFFSET   = sAutoScal.size[0],$
                           YOFFSET   = sAutoScal.size[1],$
                           SCR_XSIZE = sAutoScal.size[2],$
                           SCR_YSIZE = sAutoScal.size[3],$
                           VALUE     = sAutoScal.value,$
                           SENSITIVE = sAutoScal.sensitive)

;***** OR label ****************************************************************
wStep2Or  = WIDGET_LABEL(wAutoBase,$
                         XOFFSET    = sStep2Or.size[0],$
                         YOFFSET    = sStep2Or.size[1],$
                         VALUE      = sStep2Or.value)

;***** Auto Fitting and Scalling button ****************************************
wB_autoScaFit = WIDGET_BUTTON(wAutoBase,$
                              UNAME     = sB_AutoScalFit.uname,$
                              XOFFSET   = sB_AutoScalFit.size[0],$
                              YOFFSET   = sB_AutoScalFit.size[1],$
                              SCR_XSIZE = sB_AutoScalFit.size[2],$
                              SCR_YSIZE = sB_AutoScalFit.size[3],$
                              VALUE     = sB_AutoScalFit.value,$
                              SENSITIVE = sB_AutoScalFit.sensitive)
                           
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Manual Mode Title *******************************************************
wManualBaseTitle = WIDGET_LABEL(STEP2_BASE,$
                                XOFFSET = sManualBaseTitle.size[0],$
                                YOFFSET = sManualBaseTitle.size[1],$
                                VALUE   = sManualBaseTitle.value)

;***** Manual Mode *************************************************************
wManualBase = WIDGET_BASE(STEP2_BASE,$
                          XOFFSET   = sManualBase.size[0],$
                          YOFFSET   = sManualBase.size[1],$
                          SCR_XSIZE = sManualBase.size[2],$
                          SCR_YSIZE = sManualBase.size[3],$
                          UNAME     = sManualBase.uname,$
                          FRAME     = sManualBase.frame)

;***** Manual Fitting Equation Label *******************************************
wManualFittingLabel = WIDGET_LABEL(wManualBase,$
                                   XOFFSET = sManualFittingLabel.size[0],$
                                   YOFFSET = sManualFittingLabel.size[1],$
                                   VALUE   = sManualFittingLabel.value)

;***** Manual Fitting a text field *********************************************
wManualFitting_a_TF = WIDGET_TEXT(wManualBase,$
                                  XOFFSET   = sManualFitting_a_TF.size[0],$
                                  YOFFSET   = sManualFitting_a_TF.size[1],$
                                  SCR_XSIZE = sManualFitting_a_TF.size[2],$
                                  SCR_YSIZE = sManualFitting_a_TF.size[3],$
                                  UNAME     = sManualFitting_a_TF.uname,$
                                  VALUE     = sManualFitting_a_TF.value,$
                                  /EDITABLE,$
                                  /ALIGN_LEFT)

;***** Manual Fitting Equation b label *****************************************
wManualFitting_b_L = WIDGET_LABEL(wManualBase,$
                                  XOFFSET = sManualFitting_b_L.size[0],$
                                  YOFFSET = sManualFitting_b_L.size[1],$
                                  VALUE   = sManualFitting_b_L.value)

;***** Manual Fitting Equation b text field ************************************
wManualFitting_b_TF = WIDGET_TEXT(wManualBase,$
                                  XOFFSET   = sManualFitting_b_TF.size[0],$
                                  YOFFSET   = sManualFitting_b_TF.size[1],$
                                  SCR_XSIZE = sManualFitting_b_TF.size[2],$
                                  SCR_YSIZE = sManualFitting_b_TF.size[3],$
                                  UNAME     = sManualFitting_b_TF.uname,$
                                  VALUE     = sManualFitting_b_TF.value,$
                                  /EDITABLE,$
                                  /ALIGN_LEFT)


END



                       
PRO tmp













;--tab 1 of step 2

Step2Q1Q2ErrorLabel = widget_label(step2tab1base,$
                                   uname='step2_q1q1_error_label',$
                                   xoffset=Step2Q1Q2ErrorLabelSize[0],$
                                   yoffset=Step2Q1Q2ErrorLabelSize[1],$
                                   scr_xsize=Step2Q1Q2ErrorLabelSize[2],$
                                   scr_ysize=Step2Q1Q2ErrorLabelSize[3],$
                                   value='')




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
