;===============================================================================
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
;===============================================================================

PRO fMakeGuiStep2, STEPS_TAB,$
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
                   uname     : 'step2',$
                   sensitive : 0}

;***** Top label that present the name of the CE file **************************
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
                  value : 'Range of Q used to calculate the Scaling ' + $
                  'Factor (SF)'}

;***** Qmin base and cw_field **************************************************
XYoff  = [5,2]
sLQmin = { size : [XYoff[0],$
                   XYoff[1],$
                   115,35],$
           base_uname : 'step2_q1_base',$
           uname      : 'step2_q1_text_field',$
           title      : 'Qmin:',$
           value      : '',$
           xsize      : 9}

;***** Qselected ***************************************************************
XYoff   = [-3,8]
sLQminS = { size  : [sLQmin.size[0]+sLQmin.size[2]+XYoff[0],$
                     sLQmin.size[1]+XYoff[1],$
                     5],$
            uname : 'Qmin_select',$
            value : ' '}

;***** Qmin base and cw_field **************************************************
XYoff  = [20,0]
sLQmax = { size : [sLQminS.size[0]+XYoff[0],$
                   sLQmin.size[1]+XYoff[1],$
                   sLQmin.size[2:3]],$
           base_uname : 'step2_q2_base',$
           uname      : 'step2_q2_text_field',$
           title      : 'Qmax:',$
           value      : '',$
           xsize      : 9}

;***** Qselected ***************************************************************
XYoff   = [-3,8]
sLQmaxS = { size  : [sLQmax.size[0]+sLQmax.size[2]+XYoff[0],$
                     sLQmax.size[1]+XYoff[1],$
                     sLQminS.size[2]],$
            uname : 'Qmax_select',$
            value : ' '}

;***** Qmin/max message ********************************************************
XYoff      = [15,0]
sL_QMinMax = { size  : [sLQmaxS.size[0]+XYoff[0],$
                        sLQmaxS.size[1]+XYoff[1],$
                        220],$
               value : 'Enter or Select Qmin and Qmax',$
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

;***** Auto Fitting and Scalling button ****************************************
XYoff          = [5,5]
sB_AutoScalFit = { size      : [XYoff[0],$
                                XYoff[1],$
                                495,$
                                30],$
                   uname     : 'step2_button',$
                   sensitive : 0,$
                   value     : '>     >   >  > >> >>> AUTOMATIC ' + $
                   'FITTING and RESCALING <<< << <  <   <    <'}

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
                                 25],$
                        value : 'a',$
                        frame : 1,$
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
                        value : 'b',$
                        frame : 1,$
                        uname : 'step2_fitting_equation_b_text_field'}

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
                               80,25],$
                      value : '',$
                      frame : 1,$
                      uname : 'step2_y_before_text_field'}

;***** Average Y After *********************************************************
XYoff           = [0,35]
sAverageYAfter  = { size  : [sAverageYBefore.size[0]+XYoff[0],$
                             sAverageYBefore.size[1]+XYoff[1]],$
                    value : 'Average I[Qmin:Qmax] After :'}

;***** Average Y After value ***************************************************
XYoff            = [178,-6]
sAverYAfterValue = { size  : [sAverageYAfter.size[0]+XYoff[0],$
                              sAverageYAfter.size[1]+XYoff[1],$
                              80,25],$
                     value : '1',$
                     frame : 1,$
                     uname : 'step2_y_after_text_field'}

;***** SF base *****************************************************************
XYoff            = [40,-2]
sSFbase          = { size  : [sAverYAfterValue.size[0]+ $
                              sAverYAfterValue.size[2]+XYoff[0],$
                              sAverageYBefore.size[1]+XYoff[1],$
                              180,55],$
                     uname : 'step2_sf_base',$
                     frame : 5}

;***** SF label ****************************************************************
XYoff            = [35,0]
sSFlabel         = { size      : [XYoff[0],$
                                  XYoff[1]],$
                     sensitive : 0,$
                     value     : 'Scaling Factor (SF):'}

;***** SF text field ***********************************************************
XYoff            = [55,20]
sSFtextField     = { size      : [XYoff[0],$
                                  XYoff[1],$
                                  80,30],$
                     value     : '',$
                     sensitive : 1,$
                     uname     : 'step2_sf_text_field'}

;***** Manual Scaling Button ***************************************************
XYoff                = [45,32]
sManualScalingButton = { size      : [ sAverageYBefore.size[0]+XYoff[0],$
                                       sAverageYAfter.size[1]+XYoff[1],$
                                       400,30],$ $
                         sensitive : 1,$
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
                         SCR_YSIZE = sMainBase.size[3],$
                         SENSITIVE = sMainBase.sensitive)

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
                         
;***** Qmin Selection Label '<' ************************************************
wLQminS = WIDGET_LABEL(Step2QBase,$
                       XOFFSET = sLQminS.size[0],$
                       YOFFSET = sLQminS.size[1],$
                       VALUE   = sLQminS.value,$
                       UNAME   = sLQminS.uname)

;***** Qmin BASE and CW_FIELD **************************************************
wQmin = WIDGET_BASE(Step2QBase,$
                    XOFFSET   = sLQmin.size[0],$
                    YOFFSET   = sLQmin.size[1],$
                    SCR_XSIZE = sLQmin.size[2],$
                    SCR_YSIZE = sLQmin.size[3],$
                    UNAME     = sLQmin.base_uname)

wQminField = CW_FIELD(wQmin,$
                      UNAME = sLQmin.uname,$
                      XSIZE = sLQmin.xsize,$
                      TITLE = sLQmin.title,$
                      VALUE = sLQmin.value,$
                      /RETURN_EVENTS,$
                      /FLOAT)

;***** Qmax Selection Label '<' ************************************************
wLQmaxS = WIDGET_LABEL(Step2QBase,$
                       XOFFSET = sLQmaxS.size[0],$
                       YOFFSET = sLQmaxS.size[1],$
                       VALUE   = sLQmaxS.value,$
                       UNAME   = sLQmaxS.uname)

;***** Qmax BASE and CW_FIELD **************************************************
wQmax = WIDGET_BASE(Step2QBase,$
                    XOFFSET   = sLQmax.size[0],$
                    YOFFSET   = sLQmax.size[1],$
                    SCR_XSIZE = sLQmax.size[2],$
                    SCR_YSIZE = sLQmax.size[3],$
                    UNAME     = sLQmax.base_uname)

wQmaxField = CW_FIELD(wQmax,$
                      UNAME = sLQmax.uname,$
                      XSIZE = sLQmax.xsize,$
                      TITLE = sLQmax.title,$
                      VALUE = sLQmax.value,$
                      /RETURN_EVENTS,$
                      /FLOAT)

;***** Qmin Qmax Error Label ***************************************************
wL_QMinMax = WIDGET_LABEL(Step2QBase,$
                          XOFFSET   = sL_QMinMax.size[0],$
                          YOFFSET   = sL_QMinMax.size[1],$
                          SCR_XSIZE = sL_QMinMax.size[2],$
                          UNAME     = sL_QMinMax.uname,$
                          VALUE     = sL_QminMax.value)

;-------------------------------------------------------------------------------
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

;***** Auto Fitting and Scalling button ****************************************
wB_autoScaFit = WIDGET_BUTTON(wAutoBase,$
                              UNAME     = sB_AutoScalFit.uname,$
                              XOFFSET   = sB_AutoScalFit.size[0],$
                              YOFFSET   = sB_AutoScalFit.size[1],$
                              SCR_XSIZE = sB_AutoScalFit.size[2],$
                              SCR_YSIZE = sB_AutoScalFit.size[3],$
                              VALUE     = sB_AutoScalFit.value,$
                              SENSITIVE = sB_AutoScalFit.sensitive)
;-------------------------------------------------------------------------------

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
wManualFitting_a_TF = WIDGET_LABEL(wManualBase,$
                                   XOFFSET   = sManualFitting_a_TF.size[0],$
                                   YOFFSET   = sManualFitting_a_TF.size[1],$
                                   SCR_XSIZE = sManualFitting_a_TF.size[2],$
                                   SCR_YSIZE = sManualFitting_a_TF.size[3],$
                                   UNAME     = sManualFitting_a_TF.uname,$
                                   VALUE     = sManualFitting_a_TF.value,$
                                   FRAME     = sManualFitting_a_TF.frame,$
                                   /ALIGN_LEFT)

;***** Manual Fitting Equation b label *****************************************
wManualFitting_b_L = WIDGET_LABEL(wManualBase,$
                                  XOFFSET = sManualFitting_b_L.size[0],$
                                  YOFFSET = sManualFitting_b_L.size[1],$
                                  VALUE   = sManualFitting_b_L.value)

;***** Manual Fitting Equation b text field ************************************
wManualFitting_b_TF = WIDGET_LABEL(wManualBase,$
                                   XOFFSET   = sManualFitting_b_TF.size[0],$
                                   YOFFSET   = sManualFitting_b_TF.size[1],$
                                   SCR_XSIZE = sManualFitting_b_TF.size[2],$
                                   SCR_YSIZE = sManualFitting_b_TF.size[3],$
                                   UNAME     = sManualFitting_b_TF.uname,$
                                   VALUE     = sManualFitting_b_TF.value,$
                                   FRAME     = sManualFitting_b_TF.frame,$
                                   /ALIGN_LEFT)

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
                                    FRAME     = sAverYBeforeValue.frame,$
                                    /ALIGN_LEFT)

;***** Average Y After *********************************************************
wAverageYAfter = WIDGET_LABEL(wManualBase,$
                              XOFFSET = sAverageYAfter.size[0],$
                              YOFFSET = sAverageYAfter.size[1],$
                              VALUE   = sAverageYAfter.value)		

;***** Average Y After value ***************************************************
wAverageYAfterValue = WIDGET_LABEL(wManualBase,$
                                   XOFFSET   = sAverYAfterValue.size[0],$
                                   YOFFSET   = sAverYAfterValue.size[1],$
                                   SCR_XSIZE = sAverYAfterValue.size[2],$
                                   SCR_YSIZE = sAverYAfterValue.size[3],$
                                   VALUE     = sAverYAfterValue.value,$
                                   UNAME     = sAverYAfterValue.uname,$
                                   FRAME     = sAverYAfterValue.frame,$
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
                        XOFFSET   = sSFlabel.size[0],$
                        YOFFSET   = sSFlabel.size[1],$
                        VALUE     = sSFlabel.value)

;***** SF text field ***********************************************************
wSFtextField = WIDGET_TEXT(wSFbase,$
                           XOFFSET   = sSFtextField.size[0],$
                           YOFFSET   = sSFtextField.size[1],$
                           SCR_XSIZE = sSFtextField.size[2],$
                           SCR_YSIZE = sSFtextField.size[3],$
                           UNAME     = sSFtextField.uname,$
                           SENSITIVE = sSFtextField.sensitive,$
                           VALUE     = '',$
                           /ALL_EVENTS,$
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

;*******************************************************************************
PRO make_gui_step2
END
