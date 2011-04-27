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

FUNCTION fMakeGuiStep1, StepsTabSize, $
                        STEPS_TAB, $
                        distanceMD, $
                        angleValue, $
                        ListOfFiles, $
                        Step1Title

;===============================================================================
;+++++++++++++++++++++++++ Define Structures +++++++++++++++++++++++++++++++++++
;===============================================================================

;***** Main Base ***************************************************************
sStep1Base = { size  : [0,0,StepsTabSize[2:3]],$
               uname : 'step1',$
               title : Step1Title}
Step1Size = sStep1Base.size                       

;***** Load Button *************************************************************
XYoff       = [5,5]
sLoadButton = { size      : [XYoff[0],$
                             XYoff[1],$
                             65,30],$
                uname     : 'load_button',$
                sensitive : 1,$
                value     : 'L O A D'}

;**** Clear Button *************************************************************
XYOff        = [5,0]
sClearButton = { size      : [sLoadButton.size[0]+ $
                              sLoadButton.size[2]+XYoff[0],$
                              sLoadButton.size[1],$
                              sLoadButton.size[2]-15,$
                              sLoadButton.size[3]],$
                 uname     : 'clear_button',$
                 value     : 'CLEAR',$
                 sensitive : 0}

;***** List Of Files ***********************************************************
XYoff        = [5,0]
sListOfFiles = { size  : [sClearButton.size[0]+ $
                          sClearButton.size[2]+XYoff[0],$
                          sClearButton.size[1]+XYoff[1],$
                          250,30],$
                 uname : 'list_of_files_droplist',$
                 list  : ListOfFiles,$
                 title : 'File:'}

;***** Input File Format (TOF or Q) ********************************************
XYoff            = [5,45]
sInputFileFormat = { size  : [XYoff[0],$
                              XYoff[1]],$
                     title : 'Input File Format:',$
                     list  : ['TOF','Q'],$
                     value : 1.0,$
                     uname : 'InputFileFormat'}
                              
;***** Angle and dMD info box **************************************************
XYoff              = [210,0]
sAngleDistanceInfo = { size  : [sInputFileFormat.size[0]+XYoff[0],$
                                sInputFileFormat.size[1]+XYoff[1],$
                                295,30],$
                       value : '',$
                       frame : 1,$
                       uname : 'dMD_angle_info_label'}

;***** File Information ********************************************************
XYoff     = [5,82]
sFileInfo = { size  : [XYoff[0],$
                       XYoff[1],$
                       510,240],$
              uname : 'file_info'}

;***** Color Label *************************************************************
XYoff       = [5,15]
sColorLabel = { size  : [sFileInfo.size[0]+XYoff[0],$
                         sFileInfo.size[1]+sFileInfo.size[3]+XYoff[1]],$
                value : 'Color:'}
                         
;***** Color Slider ************************************************************
XYoff     = [50,-15]
sColorSlider = { size         : [sFileInfo.size[0]+XYoff[0],$
                                 sColorLabel.size[1]+XYoff[1],$
                                 210,35],$
                 uname        : 'list_of_color_slider',$
                 minimum      : 0,$
                 maximum      : 255,$
                 defaultValue : 25,$
                 sensitive    : 1}

;***** List of Colors **********************************************************
XYoff         = [0,35]
sListOfColors = { size  : [sColorSlider.size[0]+XYoff[0],$
                           sColorSlider.size[1]+XYoff[1]],$
                  value : 'Black  Blue  Red  Oran.  Yel.  Whit.'}
                           
;***** Current File displayed Name *********************************************
XYoff          = [10,15]
sColorFileName = { size  : [sColorSlider.size[0]+ $
                            sColorSlider.size[2]+XYoff[0],$
                            sColorSlider.size[1]+XYoff[1],$
                            240],$
                   value : ' ',$
                   uname : 'ColorFileLabel'}

;***** TOF Base ****************************************************************
sTOFbase   = { size  : [5,5,StepsTabSize[2]-20,105],$
               uname : 'dMD_angle_base',$
               frame : 1,$
               map   : 0}

;***** Main Label of TOF base **************************************************
sMainLabel = { size  : [5,5],$
               value : 'To go from TOF to Q, the file you are about to' + $
               ' load will use:'}

;***** Distance Moderator-Detector Label ***************************************
sDistanceMDLabel = { size  : [5,35],$
                     value : 'Distance Moderator-Detector:              ' + $
                     '     metres'}

;***** Distance Moderator-Detector Text Field **********************************
XYoff           = [175,-6]
sDistanceMDtext = { size  : [sDistanceMDLabel.size[0]+XYoff[0],$
                             sDistanceMDLabel.size[1]+XYoff[1],$
                             100,30],$
                    uname : 'ModeratorDetectorDistanceTextField',$
                    value : distanceMD}

;***** Angle Label *************************************************************
XYoff       = [0,35]
sAngleLabel = { size  : [sDistanceMDLabel.size[0]+XYoff[0],$
                         sDistanceMDLabel.size[1]+XYoff[1]],$
                value : 'Polar Angle:'}

;***** Angle Value *************************************************************
XYoff       = [80,-6]
sAngleValue = { size  : [sAngleLabel.size[0]+XYoff[0],$
                         sAngleLabel.size[1]+XYoff[1],$
                         sDistanceMDtext.size[2:3]],$
                value : '',$
                uname : 'AngleTextField'}

;***** Angle Units *************************************************************
XYoff       = [5,-6]
sAngleUnits = { size  : [sAngleValue.size[0]+sAngleValue.size[2]+XYoff[0],$
                         sAngleLabel.size[1]+XYoff[1]],$
                value : 1,$
                uname : 'AngleUnits',$
                list  : ['radians','degrees']}

;***** TOF error base **********************************************************
XYoff             = [50,-8]
sErrorMessageBase = { size  : [sDistanceMDtext.size[0]+ $
                               sDistanceMDtext.size[2]+XYoff[0],$
                               sDistanceMDlabel.size[1]+XYoff[1],$
                               170,30],$
                      uname : 'ErrorMessageBase',$
                      frame : 1,$
                      map   : 1}

;***** TOF error label  ********************************************************
XYoff              = [0,0]
sErrorMessageLabel = { size  : [XYoff[0],$
                                XYoff[1],$
                                166,26],$
                       uname : 'ErrorMessageLabel',$
                       value : ' '}
                       
;***** TOF Ok Load Button ******************************************************
XYoff         = [335,0]
sOkLoadButton = { size      : [XYoff[0],$
                               sAngleValue.size[1]+XYoff[1],$
                               80,30],$
                  uname     : 'ok_load_button',$
                  value     : 'OK',$
                  sensitive : 0}
                           
;***** TOF Cancel Load Button **************************************************
XYoff         = [5,0]
sCancelLoadButton = { size      : [sOkLoadButton.size[0]+ $
                               sOkLoadButton.size[2]+XYoff[0],$
                               sOkLoadButton.size[1]+XYoff[1],$
                               sOkLoadButton.size[2:3]],$
                  uname     : 'cancel_load_button',$
                  value     : 'CANCEL',$
                  sensitive : 1}
                           
;===============================================================================
;+++++++++++++++++++++++++++; Build GUI ++++++++++++++++++++++++++++++++++++++++
;===============================================================================

;***** Main Base of Step1 ******************************************************
STEP1_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME     = sStep1Base.uname,$
                         XOFFSET   = sStep1Base.size[0],$
                         YOFFSET   = sStep1Base.size[1],$
                         SCR_XSIZE = sStep1Base.size[2],$
                         SCR_YSIZE = sStep1Base.size[3],$
                         TITLE     = sStep1Base.title)

;***** Load Button *************************************************************
LoadButton = WIDGET_BUTTON(STEP1_BASE,$
                           UNAME     = sLoadButton.uname,$
                           XOFFSET   = sLoadButton.size[0],$
                           YOFFSET   = sLoadButton.size[1],$
                           SCR_XSIZE = sLoadButton.size[2],$
                           SCR_YSIZE = sLoadButton.size[3],$
                           VALUE     = sLoadButton.value,$
                           SENSITIVE = sLoadButton.sensitive)

;***** Clear Button ************************************************************
ClearButton = WIDGET_BUTTON(STEP1_BASE,$
                           UNAME     = sClearButton.uname,$
                           XOFFSET   = sClearButton.size[0],$
                           YOFFSET   = sClearButton.size[1],$
                           SCR_XSIZE = sClearButton.size[2],$
                           SCR_YSIZE = sClearButton.size[3],$
                           VALUE     = sClearButton.value,$
                           SENSITIVE = sClearButton.sensitive)

;***** List of Files ***********************************************************
ListOfFiles = WIDGET_DROPLIST(STEP1_BASE,$
                              UNAME = sListOfFiles.uname,$
                              XOFFSET = sListOfFiles.size[0],$
                              YOFFSET = sListOfFiles.size[1],$
                              SCR_XSIZE = sListOfFiles.size[2],$
                              SCR_YSIZE = sListOfFiles.size[3],$
                              VALUE     = sListOfFiles.list,$
                              TITLE     = sListOfFiles.title)

;***** Input File Format (TOF or Q) ********************************************
InputFileFormat = CW_BGROUP(STEP1_BASE,$ 
                            sInputFileFormat.list,$
                            UNAME      = sInputFileFormat.uname,$
                            XOFFSET    = sInputFileFormat.size[0],$
                            YOFFSET    = sInputFileFormat.size[1],$
                            SET_VALUE  = sInputFileFormat.value,$
                            LABEL_LEFT = sInputFileFormat.title,$
                            ROW        = 1,$
                            /EXCLUSIVE,$
                            /RETURN_NAME)

;***** Angle and dMD info box **************************************************
dMDAngleInfoLabel = WIDGET_LABEL(STEP1_BASE,$
                                 UNAME     = sAngleDistanceInfo.uname,$
                                 XOFFSET   = sAngleDistanceInfo.size[0],$
                                 YOFFSET   = sAngleDistanceInfo.size[1],$
                                 SCR_XSIZE = sAngleDistanceInfo.size[2],$
                                 SCR_YSIZE = sAngleDistanceInfo.size[3],$
                                 VALUE     = sAngleDistanceInfo.value,$
                                 FRAME     = sAngleDistanceInfo.frame)

;***** File Information ********************************************************
wFileInfo = WIDGET_TEXT(STEP1_BASE,$
                        UNAME     = sFileInfo.uname,$
                        XOFFSET   = sFileInfo.size[0],$
                        YOFFSET   = sFileInfo.size[1],$
                        SCR_XSIZE = sFileInfo.size[2],$
                        SCR_YSIZE = sFileInfo.size[3],$
                        /SCROLL,$
                        /WRAP)

;***** Color Label *************************************************************
wColorLabel = WIDGET_LABEL(STEP1_BASE,$
                           XOFFSET = sColorLabel.size[0],$
                           YOFFSET = sColorLabel.size[1],$
                           VALUE   = sColorLabel.value)

;***** Color Slider ************************************************************
wColorSlider = WIDGET_SLIDER(STEP1_BASE,$
                             UNAME     = sColorSlider.uname,$
                             MINIMUM   = sColorSlider.minimum,$
                             MAXIMUM   = sColorSlider.maximum,$
                             XOFFSET   = sColorSlider.size[0],$
                             YOFFSET   = sColorSlider.size[1],$
                             SCR_XSIZE = sColorSlider.size[2],$
                             SCR_YSIZE = sColorSlider.size[3],$
                             VALUE     = sColorSlider.defaultValue,$
                             SENSITIVE = sColorSlider.sensitive)

;***** List of Colors **********************************************************
wListOfColors = WIDGET_LABEL(STEP1_BASE,$
                             XOFFSET = sListOfColors.size[0],$
                             YOFFSET = sListOfColors.size[1],$
                             VALUE   = sListOfColors.value)

;***** Current File Displayed Name *********************************************
wColorFileName = WIDGET_LABEL(STEP1_BASE,$
                              XOFFSET   = sColorFileName.size[0],$
                              YOFFSET   = sColorFileName.size[1],$
                              SCR_XSIZE = sColorFileName.size[2],$
                              UNAME     = sColorFileName.uname,$
                              VALUE     = sColorFileName.value)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** TOF files base **********************************************************
dMDAngleBase = WIDGET_BASE(STEP1_BASE,$
                           UNAME     = sTOFbase.uname,$
                           XOFFSET   = sTOFbase.size[0],$
                           YOFFSET   = sTOFbase.size[1],$
                           SCR_XSIZE = sTOFbase.size[2],$
                           SCR_YSIZE = sTOFbase.size[3],$
                           FRAME     = sTOFbase.frame,$
                           MAP       = sTOFbase.map)

;***** Main Label of TOF base **************************************************
wMainLabel = WIDGET_LABEL(dMDAngleBase,$
                          XOFFSET = sMainLabel.size[0],$
                          YOFFSET = sMainLabel.size[1],$
                          VALUE   = sMainLabel.value)

;***** Distance Moderator-Detector Text Field **********************************
wDistanceMDtext = WIDGET_TEXT(dMDAngleBase,$
                              XOFFSET   = sDistanceMDtext.size[0],$
                              YOFFSET   = sDistanceMDtext.size[1],$
                              SCR_XSIZE = sDistanceMDtext.size[2],$
                              SCR_YSIZE = sDistanceMDtext.size[3],$
                              UNAME     = sDistanceMDtext.uname,$
                              VALUE     = sDistanceMDtext.value,$
                              /EDITABLE,$
                              /ALIGN_LEFT,$
                              /ALL_EVENTS)

;***** Distance Moderator-Detector Label ***************************************
wDistanceMDLabel = WIDGET_LABEL(dMDAngleBase,$
                                XOFFSET = sDistanceMDLabel.size[0],$
                                YOFFSET = sDistanceMDLabel.size[1],$
                                VALUE   = sDistanceMDLabel.value)

;***** Angle Label *************************************************************
wAngleLabel = WIDGET_LABEL(dMDAngleBase,$
                           XOFFSET = sAngleLabel.size[0],$
                           YOFFSET = sAngleLabel.size[1],$
                           VALUE   = sAngleLabel.value)

;***** Angle Value *************************************************************
wAngleValue = WIDGET_TEXT(dMDAngleBase,$
                          UNAME = sAngleValue.uname,$
                          XOFFSET = sAngleValue.size[0],$
                          YOFFSET = sAngleValue.size[1],$
                          SCR_XSIZE = sAngleValue.size[2],$
                          SCR_YSIZE = sAngleValue.size[3],$
                          VALUE     = sAngleValue.value,$
                          /EDITABLE,$
                          /ALIGN_LEFT,$
                          /ALL_EVENTS)

;***** Angle Units *************************************************************
wAngleUnits = CW_BGROUP(dMDAngleBase,$
                        sAngleUnits.list,$
                        XOFFSET   = sAngleUnits.size[0],$
                        YOFFSET   = sAngleUnits.size[1],$
                        UNAME     = sAngleUnits.uname,$
                        SET_VALUE = sAngleUnits.value,$
                        ROW       = 1,$
                        /EXCLUSIVE,$
                        /RETURN_NAME)

;++++++++++++++ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;***** TOF error base **********************************************************
ErrorMessageBase = WIDGET_BASE(dMDAngleBase,$
                               XOFFSET   = sErrorMessageBase.size[0],$
                               YOFFSET   = sErrorMessageBase.size[1],$
                               SCR_XSIZE = sErrorMessageBase.size[2],$
                               SCR_YSIZE = sErrorMessageBase.size[3],$
                               UNAME     = sErrorMessageBase.uname,$
                               FRAME     = sErrorMessageBase.frame,$
                               MAP       = sErrorMessageBase.map)
;***** TOF error label *********************************************************
ErrorMessageLabel = WIDGET_LABEL(ErrorMessageBase,$
                                 UNAME     = sErrorMessageLabel.uname,$
                                 XOFFSET   = sErrorMessageLabel.size[0],$
                                 YOFFSET   = sErrorMessageLabel.size[1],$
                                 SCR_XSIZE = sErrorMessageLabel.size[2],$
                                 SCR_YSIZE = sErrorMessageLabel.size[3],$
                                 VALUE     = sErrormessageLabel.value)

;***** TOF Ok Load Button ******************************************************
OkLoadButton = WIDGET_BUTTON(dMDAngleBase,$
                             UNAME     = sOkLoadButton.uname,$
                             XOFFSET   = sOkLoadButton.size[0],$
                             YOFFSET   = sOkLoadButton.size[1],$
                             SCR_XSIZE = sOkLoadButton.size[2],$
                             SCR_YSIZE = sOkLoadButton.size[3],$
                             SENSITIVE = sOkLoadButton.sensitive,$
                             VALUE     = sOkLoadButton.value)

;***** TOF Cancel Load Button **************************************************
CancelLoadButton = WIDGET_BUTTON(dMDAngleBase,$
                             UNAME     = sCancelLoadButton.uname,$
                             XOFFSET   = sCancelLoadButton.size[0],$
                             YOFFSET   = sCancelLoadButton.size[1],$
                             SCR_XSIZE = sCancelLoadButton.size[2],$
                             SCR_YSIZE = sCancelLoadButton.size[3],$
                             SENSITIVE = sCancelLoadButton.sensitive,$
                             VALUE     = sCancelLoadButton.value)

;***** END of TOF error base ;***************************************************
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RETURN, Step1Size
END
