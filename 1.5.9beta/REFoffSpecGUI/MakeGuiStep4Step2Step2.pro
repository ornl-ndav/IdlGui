;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO make_gui_scaling_step2_step2, MAIN_TAB, tab_size, TabTitles

!P.FONT = 0

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBase = { size:  [10,10,tab_size[2:3]],$
          uname: 'step4_step2_base',$
          title: TabTitles.critical_edge}

;***** Top label that present the name of the CE file *************************
sBaseFileLabel = { size      : [10, 10],$
                   value     : 'Critical edge file:'}

;-----------------------------------
y_base_off = 45 ;Yoff between bases
;-----------------------------------

;***** Top label that gives the name of the CE file ***************************
XYoff          = [130,0]
sBFceFile      = { size      : [sBaseFileLabel.size[0]+XYoff[0], $
                                sBaseFileLabel.size[1]+XYoff[1],$
                                370],$
                   value     : 'N/A',$
                   uname     : 'short_ce_file_name'}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Base of Lambda min and Lambda max **************************************
sB1_LambdaminLambdamaxInput = { size   : [5, $
                                y_base_off+15,$
                                505, $
                                40],$
                      uname  : 'step2LambdainputBase',$
                      frame  : 5}

;***** Lambda title frame *****************************************************
sL_LambdaBaseTitle = { size  : [sB1_LambdaminLambdaMaxInput.size[0]+15, $
                                sB1_LambdaminLambdamaxInput.size[1]-8],$
                       value : 'Range of Lambda used to calculate ' + $
                       'the Scaling ' + $
                       'Factor (SF)'}

;***** Lambda min base and cw_field *******************************************
XYoff  = [5,2]
sLLambdamin = { size : [XYoff[0],$
                        XYoff[1],$
                        133,35],$
                base_uname : 'step2_lambda1_base',$
                uname      : 'step4_2_2_lambda1_text_field',$
                title      : 'Lda Min:',$
                value      : '',$
                xsize      : 9}

;***** Lambdaselected *********************************************************
XYoff   = [-3,8]
sLLambdaminS = { size  : [sLLambdamin.size[0]+sLLambdamin.size[2]+XYoff[0],$
                          sLLambdamin.size[1]+XYoff[1],$
                          5],$
                 uname : 'Lambda_min_select',$
                 value : '<'}

;***** Lambdamin base and cw_field ********************************************
XYoff  = [15,0]
sLLambdamax = { size : [sLLambdaminS.size[0]+XYoff[0],$
                        sLLambdamin.size[1]+XYoff[1],$
                        sLLambdamin.size[2:3]],$
                base_uname : 'step2_lambda2_base',$
                uname      : 'step4_2_2_lambda2_text_field',$
                title      : 'Lda Max:',$
                value      : '',$
                xsize      : 9}

;***** Lambdaselected *********************************************************
XYoff   = [-3,8]
sLLambdamaxS = { size  : [sLLambdamax.size[0]+sLLambdamax.size[2]+XYoff[0],$
                          sLLambdamax.size[1]+XYoff[1],$
                          sLLambdaminS.size[2]],$
                 uname : 'Lambda_max_select',$
                 value : ' '}

;***** Lambdamin/max message **************************************************
XYoff      = [5,3]
sL_LambdaMinMax = { size  : [sLLambdamaxS.size[0]+XYoff[0],$
                             sLLambdamaxS.size[1]+XYoff[1],$
                             220],$
                    value : 'Enter or Select Lda min and max.',$
                    uname : 'step2_lambda_min_lambda_max_error_label'}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Auto Mode base *********************************************************
XYoff        = [0,Y_base_off]
sAutoBase    = { size   : [sB1_LambdaminLambdamaxInput.size[0]+XYoff[0],$
                           sB1_LambdaminLambdamaxInput.size[1]+ $
                           sB1_LambdaminLambdamaxInput.size[3]+XYoff[1],$
                           sB1_LambdaminLambdamaxInput.size[2],45],$
                 uname  : 'auto_mode_base',$
                 sensitive: 0,$
                 frame  : 5}

;***** Auto mode base title ***************************************************
sAutoBaseTitle = { size  : [sAutoBase.size[0]+15, $
                            sAutoBase.size[1]-8],$
                   value : 'Automatic Mode'} 

;***** Auto Fitting and Scalling button
XYoff          = [5,5]
sB_AutoScalFit = { size      : [XYoff[0],$
                                XYoff[1],$
                                495,$
                                30],$
                   uname     : 'step4_2_2_auto_button',$
                   value     : '>     >   >  > >> >>> AUTOMATIC ' + $
                   'FITTING and RESCALING <<< << <  <   <    <'}

;;***** with error bars or not
;XYoff = [0,-5]
;sError = { size: [sB_AutoScalFit.size[0]+XYoff[0],$
;                  sB_AutoScalFit.size[1]+$
;                  sB_AutoScalFit.size[3]+$
;                  XYoff[1]],$
;           list: ['YES','NO'],$
;           title: 'Calculation taking into account error bars:',$
;           value: 0.0,$
;           uname: 'step4_step2_step2_with_error_bars_cw_bgroup'}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Manual *****************************************************************
XYoff       = [0,y_base_off]
sManualBase =  { size   : [sAutoBase.size[0]+XYoff[0],$
                           sAutoBase.size[1]+ $
                           sAutoBase.size[3]+XYoff[1],$
                           sAutoBase.size[2],$
                           120],$
                 uname  : 'manual_mode_base',$
                 frame  : 5}

;***** Manual title ***********************************************************
sManualBaseTitle = { size  : [sManualBase.size[0]+15,$
                              sManualBase.size[1]-8],$
                     value : 'Manual Mode'}
; Code commented out has been removed here - RC Ward, April 5, 2010

;***** Average Y Before *******************************************************
XYoff           = [5,15]
sAverageYBefore = { size  : [XYoff[0],$
                             XYoff[1]],$
                    value : 'Average I[Lda_min:Lda_max] Before:'}

;***** Average Y Before value *************************************************
XYoff             = [210,-8]
sAverYBeforeValue = { size  : [sAverageYBefore.size[0]+XYoff[0], $
                               sAverageYBefore.size[1]+XYoff[1],$
                               80,25],$
                      value : '',$
                      frame : 1,$
                      uname : 'step2_y_before_text_field'}

;***** Average Y After ********************************************************
XYoff           = [0,35]
sAverageYAfter  = { size  : [sAverageYBefore.size[0]+XYoff[0],$
                             sAverageYBefore.size[1]+XYoff[1]],$
                    value : 'Average I[Lda_min:Lda_max] After :'}

;***** Average Y After value **************************************************
XYoff            = [210,-6]
sAverYAfterValue = { size  : [sAverageYAfter.size[0]+XYoff[0],$
                              sAverageYAfter.size[1]+XYoff[1],$
                              80,25],$
                     value : '1',$
                     frame : 1,$
                     uname : 'step2_y_after_text_field'}

;***** SF base ****************************************************************
XYoff            = [10,-8]
sSFbase          = { size  : [sAverYAfterValue.size[0]+ $
                              sAverYAfterValue.size[2]+XYoff[0],$
                              sAverageYBefore.size[1]+XYoff[1],$
                              180,55],$
                     uname : 'step2_sf_base',$
                     frame : 5}

;***** SF label ***************************************************************
XYoff            = [35,0]
sSFlabel         = { size      : [XYoff[0],$
                                  XYoff[1]],$
                     sensitive : 0,$
                     value     : 'Scaling Factor (SF):'}

;***** SF text field **********************************************************
XYoff            = [55,20]
sSFtextField     = { size      : [XYoff[0],$
                                  XYoff[1],$
                                  80,30],$
                     value     : '',$
                     sensitive : 0,$
                     uname     : 'step2_sf_text_field'}

;***** Manual Scaling Button **************************************************
XYoff                = [45,32]
sManualScalingButton = { size      : [ sAverageYBefore.size[0]+XYoff[0],$
                                       sAverageYAfter.size[1]+XYoff[1],$
                                       300,30],$ $
                         sensitive : 0,$
                         uname     : 'step2_manual_scaling_button',$
                         value     : 'Manual Scaling of CE'}

;***** Reset Scaling **********************************************************
XYoff               = [5,0]
sResetManualScaling = { size: [sManualScalingButton.size[0]+$
                               sManualScalingButton.size[2]+XYoff[0],$
                               sManualScalingButton.size[1]+XYoff[1],$
                               100,$
                               sManualScalingButton.size[3]],$
                        sensitive: 0,$
                        uname: 'step4_2_2_reset_scaling_button',$
                        value: 'RESET SCALING'}

;**** Lambda shortcut name used ***********************************************
; Change code (RC Ward, April 5, 2010): Move this label up on the screen
XYoff = [-200,-220]
sLambdaShortcut = { size: [tab_size[2]+XYoff[0],$
                           tab_size[3]+XYoff[1]],$
                    value: 'Lda = Lambda',$
                    frame: 2}

;******************************************************************************
;            BUILD GUI
;******************************************************************************

STEP_BASE = WIDGET_BASE(MAIN_TAB,$
                         UNAME     = sBase.uname,$
                         XOFFSET   = sBase.size[0],$
                         YOFFSET   = sBase.size[1],$
                         SCR_XSIZE = sBase.size[2],$
                         SCR_YSIZE = sBase.size[3],$
                         TITLE     = sBase.title)

;***** Top label that presnt the name of the CE file **************************
wBaseFile  = WIDGET_LABEL(STEP_BASE,$
                          XOFFSET   = sBaseFileLabel.size[0],$
                          YOFFSET   = sBaseFileLabel.size[1],$
                          VALUE     = sBaseFileLabel.value)

;***** Top label that gives the name of the CE file ***************************
wBFceFile  = WIDGET_LABEL(STEP_BASE,$
                          UNAME     = sBFceFile.uname,$
                          XOFFSET   = sBFceFile.size[0],$
                          YOFFSET   = sBFceFile.size[1],$
                          SCR_XSIZE = sBFceFile.size[2],$
                          VALUE     = sBFceFile.value,$
                          /ALIGN_LEFT)

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Lambda base title ******************************************************
wL_LambdaBaseTitle = WIDGET_LABEL(STEP_BASE,$
                             XOFFSET = sL_LambdaBaseTitle.size[0],$
                             YOFFSET = sL_LambdaBaseTitle.size[1],$
                             VALUE   = sL_LambdaBaseTitle.value)

;***** Base of Lambdamin and Lambdamax ****************************************
Step2LambdaBase = WIDGET_BASE(STEP_BASE,$
                         UNAME     = sB1_LambdaminLambdamaxInput.uname,$
                         XOFFSET   = sB1_LambdaminLambdamaxInput.size[0],$
                         YOFFSET   = sB1_LambdaminLambdamaxInput.size[1],$
                         SCR_XSIZE = sB1_LambdaminLambdamaxInput.size[2],$
                         SCR_YSIZE = sB1_LambdaminLambdamaxInput.size[3],$
                         FRAME     = sB1_LambdaminLambdamaxInput.frame)
                         
;***** Lambdamin Selection Label '<' ******************************************
wLLambdaminS = WIDGET_LABEL(Step2LambdaBase,$
                            XOFFSET = sLLambdaminS.size[0],$
                            YOFFSET = sLLambdaminS.size[1],$
                            VALUE   = sLLambdaminS.value,$
                            UNAME   = sLLambdaminS.uname)

;***** Lambdamin BASE and CW_FIELD ********************************************
wLambdamin = WIDGET_BASE(Step2LambdaBase,$
                         XOFFSET   = sLLambdamin.size[0],$
                         YOFFSET   = sLLambdamin.size[1],$
                         SCR_XSIZE = sLLambdamin.size[2],$
                         SCR_YSIZE = sLLambdamin.size[3],$
                         UNAME     = sLLambdamin.base_uname)

wLambdaminField = CW_FIELD(wLambdamin,$
                           UNAME = sLLambdamin.uname,$
                           XSIZE = sLLambdamin.xsize,$
                           TITLE = sLLambdamin.title,$
                           VALUE = sLLambdamin.value,$
                           /RETURN_EVENTS,$
                           /FLOAT)

;***** Lambdamax Selection Label '<' ******************************************
wLLambdamaxS = WIDGET_LABEL(Step2LambdaBase,$
                       XOFFSET = sLLambdamaxS.size[0],$
                       YOFFSET = sLLambdamaxS.size[1],$
                       VALUE   = sLLambdamaxS.value,$
                       UNAME   = sLLambdamaxS.uname)

;***** Lambdamax BASE and CW_FIELD ********************************************
wLambdamax = WIDGET_BASE(Step2LambdaBase,$
                    XOFFSET   = sLLambdamax.size[0],$
                    YOFFSET   = sLLambdamax.size[1],$
                    SCR_XSIZE = sLLambdamax.size[2],$
                    SCR_YSIZE = sLLambdamax.size[3],$
                    UNAME     = sLLambdamax.base_uname)

wLambdamaxField = CW_FIELD(wLambdamax,$
                      UNAME = sLLambdamax.uname,$
                      XSIZE = sLLambdamax.xsize,$
                      TITLE = sLLambdamax.title,$
                      VALUE = sLLambdamax.value,$
                      /RETURN_EVENTS,$
                      /FLOAT)

;***** Lambdamin Lambdamax Error Label ****************************************
wL_LambdaMinMax = WIDGET_LABEL(Step2LambdaBase,$
                          XOFFSET   = sL_LambdaMinMax.size[0],$
                          YOFFSET   = sL_LambdaMinMax.size[1],$
                          SCR_XSIZE = sL_LambdaMinMax.size[2],$
                          UNAME     = sL_LambdaMinMax.uname,$
                          VALUE     = sL_LambdaminMax.value)

;------------------------------------------------------------------------------
;***** Auto *******************************************************************
wAutoBaseTitle = WIDGET_LABEL(STEP_BASE,$
                              XOFFSET = sAutoBaseTitle.size[0],$
                              YOFFSET = sAutoBaseTitle.size[1],$
                              VALUE   = sAutoBaseTitle.value)

;***** Auto Mode Base *********************************************************
wAutoBase = WIDGET_BASE(STEP_BASE,$
                        UNAME     = sAutoBase.uname,$
                        XOFFSET   = sAutoBase.size[0],$
                        YOFFSET   = sAutoBase.size[1],$
                        SCR_XSIZE = sAutoBase.size[2],$
                        SCR_YSIZE = sAutoBase.size[3],$
                        SENSITIVE = sAutoBase.sensitive,$
                        FRAME     = sAutoBase.frame)

;***** Auto Fitting and Scalling button ***************************************
wB_autoScaFit = WIDGET_BUTTON(wAutoBase,$
                              UNAME     = sB_AutoScalFit.uname,$
                              XOFFSET   = sB_AutoScalFit.size[0],$
                              YOFFSET   = sB_AutoScalFit.size[1],$
                              SCR_XSIZE = sB_AutoScalFit.size[2],$
                              SCR_YSIZE = sB_AutoScalFit.size[3],$
                              VALUE     = sB_AutoScalFit.value)

;wError = CW_BGROUP(wAutoBase,$
;                   sError.list,$
;                   XOFFSET    = sError.size[0],$
;                   YOFFSET    = sError.size[1],$
;                   LABEL_LEFT = sError.title,$
;                   UNAME      = sError.uname,$
;                   SET_VALUE  = sError.value,$
;                   /EXCLUSIVE,$
;                   /ROW,$
;                   /NO_RELEASE)

;------------------------------------------------------------------------------
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** Manual Mode Title ******************************************************
wManualBaseTitle = WIDGET_LABEL(STEP_BASE,$
                                XOFFSET = sManualBaseTitle.size[0],$
                                YOFFSET = sManualBaseTitle.size[1],$
                                VALUE   = sManualBaseTitle.value)

;***** Manual Mode ************************************************************
wManualBase = WIDGET_BASE(STEP_BASE,$
                          XOFFSET   = sManualBase.size[0],$
                          YOFFSET   = sManualBase.size[1],$
                          SCR_XSIZE = sManualBase.size[2],$
                          SCR_YSIZE = sManualBase.size[3],$
                          UNAME     = sManualBase.uname,$
                          FRAME     = sManualBase.frame)
; Code commented out has been removed here - RC Ward, April 5, 2010

;***** Average Y Before *******************************************************
wAverageYBefore = WIDGET_LABEL(wManualBase,$
                               XOFFSET = sAverageYBefore.size[0],$
                               YOFFSET = sAverageYBefore.size[1],$
                               VALUE   = sAverageYBefore.value)		

;***** Average Y Before value *************************************************
wAverageYBeforeValue = WIDGET_LABEL(wManualBase,$
                                    XOFFSET   = sAverYBeforeValue.size[0],$
                                    YOFFSET   = sAverYBeforeValue.size[1],$
                                    SCR_XSIZE = sAverYBeforeValue.size[2],$
                                    SCR_YSIZE = sAverYBeforeValue.size[3],$
                                    VALUE     = sAverYBeforeValue.value,$
                                    UNAME     = sAverYBeforeValue.uname,$
                                    FRAME     = sAverYBeforeValue.frame,$
                                    /ALIGN_LEFT)

;***** Average Y After ********************************************************
wAverageYAfter = WIDGET_LABEL(wManualBase,$
                              XOFFSET = sAverageYAfter.size[0],$
                              YOFFSET = sAverageYAfter.size[1],$
                              VALUE   = sAverageYAfter.value)		

;***** Average Y After value **************************************************
wAverageYAfterValue = WIDGET_LABEL(wManualBase,$
                                   XOFFSET   = sAverYAfterValue.size[0],$
                                   YOFFSET   = sAverYAfterValue.size[1],$
                                   SCR_XSIZE = sAverYAfterValue.size[2],$
                                   SCR_YSIZE = sAverYAfterValue.size[3],$
                                   VALUE     = sAverYAfterValue.value,$
                                   UNAME     = sAverYAfterValue.uname,$
                                   FRAME     = sAverYAfterValue.frame,$
                                   /ALIGN_LEFT)

;***** SF base ****************************************************************
wSFbase = WIDGET_BASE(wManualBase,$
                      XOFFSET = sSFbase.size[0],$
                      YOFFSET = sSFbase.size[1],$
                      SCR_XSIZE = sSFbase.size[2],$
                      SCR_YSIZE = sSFbase.size[3],$
                      UNAME     = sSFbase.uname,$
                      FRAME     = sSFbase.frame)

;***** SF label ***************************************************************
wSFlabel = WIDGET_LABEL(wSFbase,$
                        XOFFSET   = sSFlabel.size[0],$
                        YOFFSET   = sSFlabel.size[1],$
                        VALUE     = sSFlabel.value)

;***** SF text field **********************************************************
wSFtextField = WIDGET_TEXT(wSFbase,$
                           XOFFSET   = sSFtextField.size[0],$
                           YOFFSET   = sSFtextField.size[1],$
                           SCR_XSIZE = sSFtextField.size[2],$
                           SCR_YSIZE = sSFtextField.size[3],$
                           UNAME     = sSFtextField.uname,$
                           SENSITIVE = sSFtextField.sensitive,$
                           VALUE     = '',$
                           /EDITABLE)
                           
;***** Manual Scaling Button **************************************************
wManualScalingButton = WIDGET_BUTTON(wManualBase,$
                                     XOFFSET   = sManualScalingButton.size[0],$
                                     YOFFSET   = sManualScalingButton.size[1],$
                                     SCR_XSIZE = sManualScalingButton.size[2],$
                                     SCR_YSIZE = sManualScalingButton.size[3],$
                                     UNAME     = sManualScalingButton.uname,$
                                     VALUE     = sManualScalingButton.value,$
                                     SENSITIVE = $
                                     sManualScalingButton.sensitive)

;***** RESET SCALING Button ***************************************************
wResetManualScaling = WIDGET_BUTTON(wManualBase,$
                                     XOFFSET   = sResetManualScaling.size[0],$
                                     YOFFSET   = sResetManualScaling.size[1],$
                                     SCR_XSIZE = sResetManualScaling.size[2],$
                                     SCR_YSIZE = sResetManualScaling.size[3],$
                                     UNAME     = sResetManualScaling.uname,$
                                     VALUE     = sResetManualScaling.value,$
                                     SENSITIVE = $
                                     sResetManualScaling.sensitive)




;***** Lambda Shortcut name used **********************************************
wLambdsShortcut = WIDGET_LABEL(STEP_BASE,$
                               XOFFSET = sLambdaShortcut.size[0],$
                               YOFFSET = sLambdaShortcut.size[1],$
                               VALUE   = sLambdaShortcut.value,$
                               FRAME   = sLambdaShortcut.frame)
                               

END
