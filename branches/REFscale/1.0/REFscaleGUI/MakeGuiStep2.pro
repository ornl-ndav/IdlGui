PRO MakeGuiStep2, STEPS_TAB,$
                  Step1Size,$
                  Step2Title,$
                  distance_L_TB,$
                  distance_L_L,$
                  distanceVertical_L_L,$
                  ListOfFiles

;-----------------------------------
y_base_off = 35 ;Yoff between bases
;-----------------------------------

;Define position and size of widgets
sMainBase      = { size      : Step1Size,$
                   title     : Step2Title,$
                   uname     : 'step2' }

;***** Top label that presnt the name of the CE file ***************************
sBaseFileLabel = { size      : [10, 10],$
                   value     : 'Critical edge file:'}

;***** Top label that gives the name of the CE file ****************************
XYoff          = [130,10]
sBFceFile      = { size      : [sBaseFileLabel.size[0]+XYoff[0], $
                                sBaseFileLabel.size[1],$
                                370],$
                   value     : ' ',$
                   uname     : 'short_ce_file_name'}

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Base of Qmin and Qmax ***************************************************
sB1_QminQmaxInput = { size   : [5, $
                                50,$
                                505, $
                                40],$
                      uname  : 'step2QinputBase',$
                      frame  : 5}

;***** Q title frame ***********************************************************
sL_QBaseTitle = { size  : [sB1_QminQMaxInput.size[0]+15, $
                           sB1_QminQmaxInput.size[1]-8],$
                  value : 'Range of Q used to calculate the Scalling ' + $
                  'Factor (SF)'}

;***** Qmin label **************************************************************
sL_Qmin = { size   : [5,11],$
            value  : 'Qmin:'}

;***** Qmin text field *********************************************************
XYoff1  = [35,-5]
sT_Qmin = { size   : [sL_Qmin.size[0]+XYoff1[0],$
                      sL_Qmin.size[1]+XYoff1[1],$
                      80,30],$
            uname  : 'step2_q1_text_field',$
            value  : ''}

;***** Qmax label **************************************************************
XYoff   = [120,0]
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

;***** Qmin/max message ********************************************************
XYoff      = [10,0]
sL_QMinMax = { size  : [sT_Qmax.size[0]+sT_Qmax.size[1]+XYoff[0],$
                        sL_Qmax.size[1]+XYoff[1],$
                        350],$
               value : 'Select Qmin and Qmax',$
               uname : 'step2_qminqmax_error_label'}

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Auto Mode base **********************************************************
XYoff        = [0,Y_base_off]
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
                   uname     : 'step2_automatic_fitting_button',$
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
XYoff       = [0,y_base_off]
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

;***** Manual Fitting Button ***************************************************
XYoff         = [5,0]
sManualFittingButton = { size      : [sManualFitting_b_TF.size[0]+ $
                                      sManualFitting_b_TF.size[2]+XYoff[0],$
                                      sManualFitting_b_TF.size[1]+XYoff[1],$
                                      165,30],$
                         uname     : 'step2ManualGoButton',$
                         value     : 'Manual Fitting of CE',$
                         sensitive : 0}

;***** Manual Scalling *********************************************************

;***** Average Y Before ********************************************************
XYoff           = [0,35]
sAverageYBefore = { size  : [sManualFittingLabel.size[0]+XYoff[0],$
                             sManualFittingLabel.size[1]+XYoff[1]],$
                    value : 'Average I[Qmin:Qmax] Before:'}

;***** Average Y Before value **************************************************
XYoff             = [178,-8]
sAverYBeforeValue = { size  : [sAverageYBefore.size[0]+XYoff[0], $
                               sAverageYBefore.size[1]+XYoff[1],$
                               80,35],$
                      value : '',$
                      uname : 'step2_y_before_text_field'}

;***** Average Y After *********************************************************
XYoff           = [0,35]
sAverageYAfter  = { size  : [sAverageYBefore.size[0]+XYoff[0],$
                             sAverageYBefore.size[1]+XYoff[1]],$
                    value : 'Average I[Qmin:Qmax] After :'}

;***** Average Y After value ***************************************************
XYoff            = [178,-8]
sAverYAfterValue = { size  : [sAverageYAfter.size[0]+XYoff[0],$
                              sAverageYAfter.size[1]+XYoff[1],$
                              60,30],$
                     value : '1',$
                     uname : 'step2_y_after_text_field'}

;***** SF base *****************************************************************
XYoff            = [40,-2]
sSFbase          = { size  : [sAverYAfterValue.size[0]+ $
                              sAverYAfterValue.size[2]+XYoff[0],$
                              sAverageYBefore.size[1]+XYoff[1],$
                              200,55],$
                     uname : 'step2_sf_base',$
                     frame : 5}

;***** SF label ****************************************************************
XYoff            = [35,0]
sSFlabel         = { size  : [XYoff[0],$
                              XYoff[1]],$
                     value : 'Scaling Factor (SF):'}

;***** SF text field ***********************************************************
XYoff            = [55,20]
sSFtextField     = { size  : [XYoff[0],$
                              XYoff[1],$
                              80,30],$
                     value : '',$
                     uname : 'step2_sf_text_field'}

;***** Manual Scaling Button ***************************************************
XYoff                = [145,32]
sManualScalingButton = { size      : [ sAverageYBefore.size[0]+XYoff[0],$
                                       sAverageYAfter.size[1]+XYoff[1],$
                                       200,30],$ $
                         sensitive : 0,$
                         uname     : 'step2_manual_scaling_button',$
                         value     : 'Manual Scaling of CE'}

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

;***** Qmax text field *********************************************************
wT_Qmax = WIDGET_TEXT(Step2QBase,$
                      XOFFSET   = sT_Qmax.size[0],$
                      YOFFSET   = sT_Qmax.size[1],$
                      SCR_XSIZE = sT_Qmax.size[2],$
                      SCR_YSIZE = sT_Qmax.size[3],$
                      VALUE     = sT_Qmax.value,$
                      UNAME     = sT_Qmax.uname,$
                      /EDITABLE,$
                      /ALIGN_LEFT)

;***** Qmin Qmax Error Label ***************************************************
wL_QMinMax = WIDGET_LABEL(Step2QBase,$
                          XOFFSET   = sL_QMinMax.size[0],$
                          YOFFSET   = sL_QMinMax.size[1],$
                          SCR_XSIZE = sL_QMinMax.size[2],$
                          UNAME     = sL_QMinMax.uname,$
                          VALUE     = sL_QminMax.value)

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
                          UNAME     = sAutoFit.uname,$
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

;***** Manual Fitting Button ***************************************************
wManualFittingButton = WIDGET_BUTTON(wManualBase,$
                                     XOFFSET   = sManualFittingButton.size[0],$
                                     YOFFSET   = sManualFittingButton.size[1],$
                                     SCR_XSIZE = sManualFittingButton.size[2],$
                                     SCR_YSIZE = sManualFittingButton.size[3],$
                                     UNAME     = sManualFittingButton.uname,$
                                     VALUE     = sManualFittingButton.value,$
                                     SENSITIVE = sManualFittingButton.sensitive)

;***** Manual Scalling *********************************************************

;***** Average Y Before ********************************************************
wAverageYBefore = WIDGET_LABEL(wManualBase,$
                               XOFFSET = sAverageYBefore.size[0],$
                               YOFFSET = sAverageYBefore.size[1],$
                               VALUE   = sAverageYBefore.value)		

;***** Average Y Before value **************************************************
wAverageYBeforeValue = WIDGET_LABEL(wManualBase,$
                                    XOFFSET   = sAverYBeforeValue.size[0],$
                                    YOFFSET   = sAverYBeforeValue.size[1],$
                                    SCR_XSIZE = sAverYBeforeValue.size[2],$
                                    SCR_YSIZE = sAverYBeforeValue.size[3],$
                                    VALUE     = sAverYBeforeValue.value,$
                                    UNAME     = sAverYBeforeValue.uname,$
                                    /ALIGN_LEFT)

;***** Average Y After *********************************************************
wAverageYAfter = WIDGET_LABEL(wManualBase,$
                              XOFFSET = sAverageYAfter.size[0],$
                              YOFFSET = sAverageYAfter.size[1],$
                              VALUE   = sAverageYAfter.value)		

;***** Average Y After value ***************************************************
wAverageYAfterValue = WIDGET_TEXT(wManualBase,$
                                  XOFFSET   = sAverYAfterValue.size[0],$
                                  YOFFSET   = sAverYAfterValue.size[1],$
                                  SCR_XSIZE = sAverYAfterValue.size[2],$
                                  SCR_YSIZE = sAverYAfterValue.size[3],$
                                  VALUE     = sAverYAfterValue.value,$
                                  UNAME     = sAverYAfterValue.uname,$
                                  /EDITABLE,$
                                  /ALIGN_LEFT)

;***** SF base *****************************************************************
wSFbase = WIDGET_BASE(wManualBase,$
                      XOFFSET = sSFbase.size[0],$
                      YOFFSET = sSFbase.size[1],$
                      SCR_XSIZE = sSFbase.size[2],$
                      SCR_YSIZE = sSFbase.size[3],$
                      UNAME     = sSFbase.uname,$
                      FRAME     = sSFbase.frame)

;***** SF label ****************************************************************
wSFlabel = WIDGET_LABEL(wSFbase,$
                        XOFFSET = sSFlabel.size[0],$
                        YOFFSET = sSFlabel.size[1],$
                        VALUE   = sSFlabel.value)

;***** SF text field ***********************************************************
wSFtextField = WIDGET_TEXT(wSFbase,$
                           XOFFSET   = sSFtextField.size[0],$
                           YOFFSET   = sSFtextField.size[1],$
                           SCR_XSIZE = sSFtextField.size[2],$
                           SCR_YSIZE = sSFtextField.size[3],$
                           UNAME     = sSFtextField.uname,$
                           VALUE     = '',$
                           /EDITABLE)
                           
;***** Manual Scaling Button ***************************************************
wManualScalingButton = WIDGET_BUTTON(wManualBase,$
                                     XOFFSET   = sManualScalingButton.size[0],$
                                     YOFFSET   = sManualScalingButton.size[1],$
                                     SCR_XSIZE = sManualScalingButton.size[2],$
                                     SCR_YSIZE = sManualScalingButton.size[3],$
                                     UNAME     = sManualScalingButton.uname,$
                                     VALUE     = sManualScalingButton.value,$
                                     SENSITIVE = sManualScalingButton.sensitive)

END

