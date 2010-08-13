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

PRO make_gui_scaling_step2_step3, REDUCE_TAB, tab_size, TabTitles

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  [0,0,tab_size[2:3]],$
             uname: 'step4_step2_base',$
             title: TabTitles.other_files}
                       
;*** Automatic Rescaling Button **********************************************
XYoff              = [5,5]
sAutoRescaleButton = { size      : [XYoff[0],$
                                    XYoff[1],$
                                    450,30],$
                       value     : '>     >    >   >  > >> >>> AUTOMATIC ' + $
                       'RESCALING <<< << <  <   <    <     <',$
                       uname     : 'step4_2_3_automatic_rescale_button',$
                       sensitive : 0}

;**** Reset Scaling button ****************************************************
XYoff = [0,0]
sResetScaleButton = { size: [sAutoRescaleButton.size[0]+$
                             sAutoRescaleButton.size[2]+XYoff[0],$
                             sAutoRescaleButton.size[1]+XYoff[1],$
                             90,30],$
                      value: 'FULL RESET',$
                      sensitive: 1,$
                      uname: 'step4_2_3_reset_rescale_button'}

;------------------------------------------------------------------------------
;***** Manual Mode Hidden Base ************************************************
XYoff            = [10,45]
sStep3ManualBase = { size      : [XYoff[0],$
                                  sAutoRescaleButton.size[1]+ $
                                  XYoff[1],$
                                  tab_size[2]-3*XYoff[0],705],$
                     uname     : 'step4_2_3_manual_mode_frame',$
                     frame     : 1,$
                     sensitive : 0}

;**** Manual Mode Label *******************************************************
XYoff             = [20,-8]
sStep3ManualLabel = { size  : [sStep3ManualBase.size[0]+XYoff[0],$
                               sStep3ManualBase.size[1]+XYoff[1]],$
                      value : 'Manual Rescaling'}
                               
;**** Reference lda file Label ************************************************
; Change Code (RC Ward, 5 July 2010): Change label to "low Q" from "low lambda"
XYoff      = [10,20]
sLowLdaLabel = { size  : [XYoff[0],$
                          XYoff[1]],$
                 value : 'Low Q file (Reference):',$
                 uname : 'step4_2_3_manual_reference_label'}
; Change Code (RC Ward, 5 July 2010): Add button to produce plot in separate window
XYoff = [-40,90]
sSeparatePlotButton = { size: [sAutoRescaleButton.size[0]+$
                             sAutoRescaleButton.size[2]+XYoff[0],$
                             sAutoRescaleButton.size[1]+XYoff[1],$
                             90,30],$
                      value: 'SCALED PLOT',$
                      sensitive: 1,$
                      uname: 'step4_2_3_separate_window'}

;**** Refernce lda File Name value ********************************************
XYoff      = [180,0]
sLowLdaValue = { size  : [sLowLdaLabel.size[0]+XYoff[0],$
                          sLowLdaLabel.size[1]+XYoff[1],$
                          415],$
                 uname : 'step4_2_3_manual_reference_value',$
                 value : 'N/A'}

;***** active lda file Label **************************************************
XYoff      = [0,30]
sHighLdaLabel = { size  : [sLowLdaLabel.size[0]+XYoff[0], $
                           sLowLdaLabel.size[1]+XYoff[1]],$
                  value : 'High Q file:',$
                  uname : 'step4_2_3_manual_active_label'}

;***** active lda file Droplist ***********************************************
XYoff       = [67,-10]
ListOfFiles = ['                                         ']
sHighLdaValue = { size  : [sHighLdaLabel.size[0]+XYoff[0],$
                           sHighLdaLabel.size[1]+XYoff[1],$
                           365,30],$
                  uname : 'step4_2_3_work_on_file_droplist',$
                  list  : ListOfFiles}

;------------------------------------------------------------------------------
;***** Hidden Manual Base *****************************************************
XYoff       = [0,5]
sHiddenBase = { size  : [XYoff[0],$
                         sHighLdaValue.size[1]+sHighLdaValue.size[3]+XYoff[1],$
                         520,$
                         650],$
                frame : 0,$
                uname : 'step4_2_3_manual_hidden_frame',$
                map   : 0}

;------------------------------------------------------------------------------
;***** Scaling Factor Base ****************************************************
XYoff        = [5,10]
sScalingBase = { size  : [XYoff[0],$
                          XYoff[1],$
                          188,280],$
                 frame : 1}

;***** Scaling factor label ***************************************************
XYoff         = [50,-8]
sScalingLabel = { size  : [sScalingBase.size[0]+XYoff[0],$
                           sScalingBase.size[1]+XYoff[1]],$
                  value : 'SCALING FACTOR'}
                           
;------------------------------------------------------------------------------
;***** SF CW Field ************************************************************
XYoff           = [48,115]
sScalingCWField = { size  : [XYoff[0],$
                             XYoff[1],$
                             sScalingBase.size[2]-2*XYoff[0],$
                             40],$
                    xsize : 10,$
                    ysize : 7,$
                    uname : 'step4_2_3_sf_text_field',$
                    value : '1'}

;***** +++ Button *************************************************************
XYoff = [5,10]
sButton3Plus = { size  : [XYoff[0],$
                          XYoff[1],$
                          55,30],$
                 value : 'REFoffSpec_images/3increase.bmp',$
                 tooltip: 'Scale curve by factor of 5',$
                 uname : 'step4_2_3_3increase_button'}
; Change Code (RC Ward, 4 Aug 2010): Alter to show what scaling really is
;                 tooltip: 'Increase Scaling Factor by 100',$

;***** ++ Button **************************************************************
XYoff = [5,20]
Xreducer = 0
sButton2Plus = { size  : [sButton3Plus.size[0]+sButton3Plus.size[2]+XYoff[0],$
                          sButton3Plus.size[1]+XYoff[1],$
                          sButton3Plus.size[2]-Xreducer,30],$
                 value : 'REFoffSpec_images/2increase.bmp',$
                 tooltip: 'Scale curve by factor of 2',$
                 uname : 'step4_2_3_2increase_button'}
; Change Code (RC Ward, 4 Aug 2010): Alter to show what scaling really is
;                 tooltip: 'Increase Scaling Factor by 10',$

;***** + Button ***************************************************************
XYoff = [5,20]
sButton1Plus = { size  : [sButton2Plus.size[0]+sButton2Plus.size[2]+XYoff[0],$
                          sButton2Plus.size[1]+XYoff[1],$
                          sButton2Plus.size[2]-Xreducer,30],$
                 value : 'REFoffSpec_images/1increase.bmp',$
                 tooltip: 'Scale curve by factor of 1.5',$
                 uname : 'step4_2_3_1increase_button'}
; Change Code (RC Ward, 4 Aug 2010): Alter to show what scaling really is
;                 tooltip: 'Increase Scaling Factor by 2',$

;***** --- Button *************************************************************
XYoff = [0,160]
sButton3Less = { size  : [sButton3Plus.size[0]+XYoff[0],$
                          XYoff[1],$
                          55,30],$
                 value : 'REFoffSpec_images/3decrease.bmp',$
                 tooltip: 'Scale curve by factor of 0.2',$
                 uname : 'step4_2_3_3decrease_button'}
; Change Code (RC Ward, 4 Aug 2010): Alter to show what scaling really is                 
;                 tooltip: 'Decrease Scaling Factor by 100',$

;***** -- Button **************************************************************
XYoff = [0,0]
sButton2Less = { size  : [sButton2Plus.size[0]+XYoff[0],$
                          sButton3Less.size[1]+XYoff[1],$
                          sButton3Plus.size[2]-Xreducer,30],$
                 value : 'REFoffSpec_images/2decrease.bmp',$
                 tooltip: 'Scale curve by factor of 0.5',$
                 uname : 'step4_2_3_2decrease_button'}
; Change Code (RC Ward, 4 Aug 2010): Alter to show what scaling really is
;                 tooltip: 'Decrease Scaling Factor by 10',$
;***** - Button ***************************************************************
XYoff = [0,0]
sButton1Less = { size  : [sButton1Plus.size[0]+XYoff[0],$
                          sButton2Less.size[1]+XYoff[1],$
                          sButton2Plus.size[2]-Xreducer,30],$
                 value : 'REFoffSpec_images/1decrease.bmp',$
                 tooltip: 'Scale curve by factor of 0.6667',$
                 uname : 'step4_2_3_1decrease_button'}
; Change Code (RC Ward, 4 Aug 2010): Alter to show what scaling really is
;                 tooltip: 'Decrease Scaling Factor by 2',$
;------------------------------------------------------------------------------

;***** Display or not data ****************************************************
XYoff             = [35,40]
sDisplayDataLabel = { size  : [XYoff[0],$
                               sScalingBase.size[1]+ $
                               sScalingBase.size[3]+XYoff[1]],$
                      value : 'Display Data ? ------>'}

;***** Display data cw_bgroup *************************************************
XYoff             = [0,25]
SDisplayDataGroup = { size  : [sDisplayDataLabel.size[0]+XYoff[0],$
                               sDisplayDataLabel.size[1]+XYoff[1]],$
                      list  : [' Y E S ',' N O'],$
                      value : 1.0,$
                      uname : 'display_value_yes_no'}

;------------------------------------------------------------------------------
;***** flt0, flt1_low and flt1_high text field ********************************
XYoff       = [200,15]
sStep3FltTextField = { size  : [XYoff[0],$
                                XYoff[1],$
                                320,610],$
                       uname : 'step4_2_3_flt_text_field'}

;***** flt0, flt1_low and flt1_high label *************************************
XYoff          = [10,-17]
sStep3FltLabel = { size  : [sStep3FltTextField.size[0]+XYoff[0],$
                            sStep3FltTextField.size[1]+XYoff[1]],$
                   value : ' Lambda       Y(Reference)       Y(Active)'}
                          
;******************************************************************************
;            BUILD GUI
;******************************************************************************

;***** Main Base **************************************************************
wMainBase = WIDGET_BASE(REDUCE_TAB,$
                        UNAME     = sBaseTab.uname,$
                        XOFFSET   = sBaseTab.size[0],$
                        YOFFSET   = sBaseTab.size[1],$
                        SCR_XSIZE = sBaseTab.size[2],$
                        SCR_YSIZE = sBaseTab.size[3],$
                        TITLE     = sBaseTab.title)

;***** Automatic Rescaling Button *********************************************
wAutoRescaleButton = WIDGET_BUTTON(wMainBase,$
                                   UNAME     = sAutoRescaleButton.uname,$
                                   XOFFSET   = sAutoRescaleButton.size[0],$
                                   YOFFSET   = sAutoRescaleButton.size[1],$
                                   SCR_XSIZE = sAutoRescaleButton.size[2],$
                                   SCR_YSIZE = sAutoRescaleButton.size[3],$
                                   VALUE     = sAutoRescaleButton.value,$
                                   SENSITIVE = sAutoRescaleButton.sensitive)

;**** Reset Scaling button ****************************************************
wResetRescaleButton = WIDGET_BUTTON(wMainBase,$
                                    UNAME     = sResetScaleButton.uname,$
                                    XOFFSET   = sResetScaleButton.size[0],$
                                    YOFFSET   = sResetScaleButton.size[1],$
                                    SCR_XSIZE = sResetScaleButton.size[2],$
                                    SCR_YSIZE = sResetScaleButton.size[3],$
                                    VALUE     = sResetScaleButton.value,$
                                    SENSITIVE = sResetScaleButton.sensitive)

;**** Separate Plot button ****************************************************
wSeparatePlotButton = WIDGET_BUTTON(wMainBase,$
                                    UNAME     = sSeparatePlotButton.uname,$
                                    XOFFSET   = sSeparatePlotButton.size[0],$
                                    YOFFSET   = sSeparatePlotButton.size[1],$
                                    SCR_XSIZE = sSeparatePlotButton.size[2],$
                                    SCR_YSIZE = sSeparatePlotButton.size[3],$
                                    VALUE     = sSeparatePlotButton.value,$
                                    SENSITIVE = sSeparatePlotButton.sensitive)

;------------------------------------------------------------------------------
;***** Manual Mode Label ******************************************************
wStep3ManualLabel = WIDGET_LABEL(wMainBase,$
                                 XOFFSET = sStep3ManualLabel.size[0],$
                                 YOFFSET = sStep3ManualLabel.size[1],$
                                 VALUE   = sStep3ManualLabel.value)

;***** Manual Mode Base *******************************************************
wStep3ManualBase = WIDGET_BASE(wMainBase,$
                               UNAME     = sStep3ManualBase.uname,$
                               XOFFSET   = sStep3ManualBase.size[0],$
                               YOFFSET   = sStep3ManualBase.size[1],$
                               SCR_XSIZE = sStep3ManualBase.size[2],$
                               SCR_YSIZE = sStep3ManualBase.size[3],$
                               SENSITIVE = sStep3ManualBase.sensitive,$
                               FRAME     = sStep3ManualBase.frame)

;***** Low Q Label ************************************************************
wLowLdaLabel = WIDGET_LABEL(wStep3ManualBase,$
                          UNAME   = sLowLdaLabel.uname,$
                          XOFFSET = sLowLdaLabel.size[0],$
                          YOFFSET = sLowLdaLabel.size[1],$
                          VALUE   = sLowLdaLabel.value)
                          
;**** Low Q File Name Label ***************************************************
wLowLdaValue = WIDGET_LABEL(wStep3ManualBase,$
                          UNAME     = sLowLdaValue.uname,$
                          XOFFSET   = sLowLdaValue.size[0],$
                          YOFFSET   = sLowLdaValue.size[1],$
                          SCR_XSIZE = sLowLdaValue.size[2],$
                          VALUE     = sLowLdaValue.value,$
                          /ALIGN_LEFT)

;***** High Q Label ***********************************************************
wHighLdaLabel = WIDGET_LABEL(wStep3ManualBase,$
                          UNAME   = sHighLdaLabel.uname,$
                          XOFFSET = sHighLdaLabel.size[0],$
                          YOFFSET = sHighLdaLabel.size[1],$
                          VALUE   = sHighLdaLabel.value)

;***** High Q Droplist ********************************************************
wHighLdaValue = WIDGET_DROPLIST(wStep3ManualBase,$
                              UNAME = sHighLdaValue.uname,$
                              XOFFSET = sHighLdaValue.size[0],$
                              YOFFSET = sHighLdaValue.size[1],$
                              SCR_XSIZE = sHighLdaValue.size[2],$
                              SCR_YSIZE = sHighLdaValue.size[3],$
                              VALUE     = sHighLdaValue.list)

;------------------------------------------------------------------------------
;***** Hidden Manual Base *****************************************************
wHiddenBase = WIDGET_BASE(wStep3ManualBase,$
                          XOFFSET   = sHiddenBase.size[0],$
                          YOFFSET   = sHiddenBase.size[1],$
                          SCR_XSIZE = sHiddenBase.size[2],$
                          SCR_YSIZE = sHiddenBase.size[3],$
                          UNAME     = sHiddenBase.uname,$
                          FRAME     = sHiddenBase.frame,$
                          MAP       = sHiddenBase.map)

;------------------------------------------------------------------------------
;***** Scaling Factor Label ***************************************************
wScalingLabel = WIDGET_LABEL(wHiddenBase,$
                             XOFFSET = sScalingLabel.size[0],$
                             YOFFSET = sScalingLabel.size[1],$
                             VALUE   = sScalingLabel.value)

;***** Scaling Factor Base ****************************************************
wScalingBase = WIDGET_BASE(wHiddenBase,$
                           XOFFSET   = sScalingBase.size[0],$
                           YOFFSET   = sScalingBase.size[1],$
                           SCR_XSIZE = sScalingBase.size[2],$
                           SCR_YSIZE = sScalingBase.size[3],$
                           FRAME     = sScalingBase.frame)

;------------------------------------------------------------------------------
;***** SF base and cw_field****************************************************
wScalingInputBase = WIDGET_BASE(wScalingBase,$
                                XOFFSET   = sScalingCWField.size[0],$
                                YOFFSET   = sScalingCWField.size[1],$
                                SCR_XSIZE = sScalingCWField.size[2],$
                                SCR_YSIZE = sScalingCWField.size[3],$
                                ROW       = 1)

; Code Change (RC Ward, Mar 14, 2010): The value was missing in the following section of code.
; This caused problems in the step4_2_3_manual_scaling code in scaling and plotting the 2nd data set.
wScalingInput = CW_FIELD(wScalingInputBase,$
                         XSIZE = sScalingCWField.xsize,$
                         YSIZE = sScalingCWField.ysize,$
                         UNAME = sScalingCWField.uname,$
                         VALUE = sScalingCWField.value,$
                         TITLE = '',$
                         /RETURN_EVENTS,$
                         /FLOAT)

;***** +++ Button *************************************************************
wButton3Plus = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton3Plus.uname,$
                             XOFFSET   = sButton3Plus.size[0],$
                             YOFFSET   = sButton3Plus.size[1],$
                             VALUE     = sButton3Plus.value,$
                             TOOLTIP   = sButton3Plus.tooltip,$
                             /BITMAP,$
                             /NO_RELEASE)

;***** ++ Button **************************************************************
wButton2Plus = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton2Plus.uname,$
                             XOFFSET   = sButton2Plus.size[0],$
                             YOFFSET   = sButton2Plus.size[1],$
                             TOOLTIP   = sButton2Plus.tooltip,$
                             VALUE     = sButton2Plus.value,$
                             /BITMAP,$
                             /NO_RELEASE)

;***** + Button ***************************************************************
wButton1Plus = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton1Plus.uname,$
                             XOFFSET   = sButton1Plus.size[0],$
                             YOFFSET   = sButton1Plus.size[1],$
                             TOOLTIP   = sButton1Plus.tooltip,$
                             VALUE     = sButton1Plus.value,$
                             /BITMAP,$
                             /NO_RELEASE)
                             
;***** --- Button *************************************************************
wButton3Less = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton3Less.uname,$
                             XOFFSET   = sButton3Less.size[0],$
                             YOFFSET   = sButton3Less.size[1],$
                             VALUE     = sButton3Less.value,$
                             TOOLTIP   = sButton3Less.tooltip,$
                             /BITMAP,$
                             /NO_RELEASE)

;***** -- Button **************************************************************
wButton2Less = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton2Less.uname,$
                             XOFFSET   = sButton2Less.size[0],$
                             YOFFSET   = sButton2Less.size[1],$
                             VALUE     = sButton2Less.value,$
                             TOOLTIP   = sButton2Less.tooltip,$
                             /BITMAP,$
                             /NO_RELEASE)

;***** - Button ***************************************************************
wButton1Less = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton1Less.uname,$
                             XOFFSET   = sButton1Less.size[0],$
                             YOFFSET   = sButton1Less.size[1],$
                             VALUE     = sButton1Less.value,$
                             TOOLTIP   = sButton1Less.tooltip,$
                             /BITMAP,$
                             /NO_RELEASE)

;------------------------------------------------------------------------------

;;***** Display or not data ****************************************************
;wDisplayDataLabel = WIDGET_LABEL(wHiddenBase,$
;                                 XOFFSET = sDisplayDataLabel.size[0],$
;                                 YOFFSET = sDisplayDataLabel.size[1],$
;                                 VALUE   = sDisplayDataLabel.value)
;
;;***** Display data cw_bgroup *************************************************
;wDisplayDataGroup = CW_BGROUP(wHiddenBase,$
;                              sDisplayDataGroup.list,$
;                              XOFFSET   = sDisplayDataGroup.size[0],$
;                              YOFFSET   = sDisplayDataGroup.size[1],$
;                              SET_VALUE = sDisplayDataGroup.value,$
;                              UNAME     = sDisplayDataGroup.uname,$
;                              ROW       = 1,$
;                              /EXCLUSIVE)
;
;;***** flt0, flt1_low and flt1_high text field ********************************
;wStep3FltTextField = WIDGET_TEXT(wHiddenBase,$
;                                 UNAME     = sStep3FltTextField.uname,$
;                                 XOFFSET   = sStep3FltTextField.size[0],$
;                                 YOFFSET   = sStep3FltTextField.size[1],$
;                                 SCR_XSIZE = sStep3FltTextField.size[2],$
;                                 SCR_YSIZE = sStep3FltTextField.size[3],$
;                                 /SCROLL)
;
;;***** flt0, flt1_low and flt1_high label *************************************
;wStep3FltLabel = WIDGET_LABEL(wHiddenBase,$
;                              XOFFSET = sStep3FltLabel.size[0],$
;                              YOFFSET = sStep3FltLabel.size[1],$
;                              VALUE   = sStep3FltLabel.value)

END
