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

PRO miniMakeGuiLoadNormalization1DTab, D_DD_Tab, $
                                   D_DD_TabSize, $
                                   D_DD_TabTitle, $
                                   GlobalLoadGraphs, $
                                   loadctList

;define 3 tabs (Back/Signal Selection, Contrast and Rescale)

BackPeakRescaleTabSize = [4, $
                          310, $
                          310, $
                          242] 

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;define 3 tabs (Back/Signal Selection, Contrast and Rescale)
;Tab#1
BackPeakBaseSize       = [0,0,BackPeakRescaleTabSize[2],$
                          BackPeakRescaleTabSize[3]]
BackPeakBaseTitle      = 'ROI/Peak/Background'
;Tab#2
ContrastBaseSize       = BackPeakBaseSize
ContrastBaseTitle      = 'Contrast Editor'
;Tab#3
RescaleBaseSize        = BackPeakBaseSize
RescaleBaseTitle       = 'Scale/Range'  

;------------------------------------------------------------------------------
;-TAB #1 ----------------------------------------------------------------------
;------------------------------------------------------------------------------
;Ymin and Ymax working
sYMinMaxLabel = { size: [175,5],$
                  value: 'Working with -> Ymin',$
                  uname: 'norm_ymin_ymax_label'}

sTab = { size:  [5,5,D_DD_TabSize[2]-35,155],$
         list:  ['ROI',$
                 'Peak/Background',$
                 'ZOOM'],$
         uname: 'norm_roi_peak_background_tab'}

;;TAB ROI ---------------------------------------------------------------------
sRoiBase = { size: [0,0,D_DD_TabSize[2],160] }
             
XYoff = [0,10] ;Ymin cw_field
sRoiYmin = { size: [XYoff[0],$
                    XYoff[1],$
                    80,35],$
             base_uname: 'Data1SelectionBackgroundYminBase',$
             uname: 'norm_d_selection_roi_ymin_cw_field',$
             xsize: 3,$
             title: 'Ymin:'}

XYoff = [5,0] ;Ymax cw_field
sRoiYmax = { size: [sRoiYmin.size[0]+sRoiYmin.size[2]+XYoff[0],$
                    sRoiYmin.size[1]+XYoff[1],$
                    sRoiYmin.size[2:3]],$
             base_uname: 'Data1SelectionBackgroundYmaxBase',$
             uname: 'norm_d_selection_roi_ymax_cw_field',$
             xsize: 3,$
             title: 'Ymax:'}

XYoff = [0,10] ;OR label
sOrLabel = {size: [sRoiYmax.size[0]+sRoiYmax.size[2]+XYoff[0],$
                   sRoiYmax.size[1]+XYoff[1]],$
            value: 'OR'}
                  
XYoff = [18,-7] ;LOAD button
sLoadButton = {size: [sOrLabel.size[0]+XYoff[0],$
                      sOrLabel.size[1]+XYoff[1],$
                      100,$
                      30],$
               value: 'LOAD ROI FILE',$
               uname: 'norm_roi_load_button'}

XYoff = [3,48] ;ROI file Name label
sRoiFileLabel = {size:   [sRoiYmin.size[0]+XYoff[0],$
                          sRoiYmin.size[1]+XYoff[1]],$
                 value:  'ROI file:'}
                         
XYoff = [60,-8] ;roi file text
sRoiFileText = {size:     [sRoiFileLabel.size[0]+XYoff[0],$
                           sRoiFileLabel.size[1]+XYoff[1],$
                           220],$
                uname:    'norm_roi_selection_file_text_field',$
                sensitive: 0}

XYoff = [0,30] ;SAVE button
sSaveButton = {size:  [sRoiFileLabel.size[0]+XYoff[0],$
                       sRoiFileLabel.size[1]+XYoff[1],$
                       280,sLoadButton.size[3]],$
               value: 'SAVE ROI FILE',$
               uname: 'norm_roi_save_button'}
               
;TAB Peak/Back ---------------------------------------------------------------
sPeakBackBase = sRoiBase

XYoff = [0,0] ;Peak or Back cw_bgroup
sPeakBackGroup = {size:  [XYoff[0],$
                          XYoff[1]],$
                  uname: 'peak_norm_back_group',$
                  value: 0,$
                  list:  ['Peak','Background']}

XYoff = [0,28] ;PEAK base ----------------------------------------------------
sPeakBase = {size: [XYoff[0],$
                    XYoff[1],$
                    585,65],$
             frame: 0,$
             uname: 'peak_norm_base_uname',$
             map:   1}

XYoff = [40,10] ;Ymin cw_field
sPeakRoiYmin = { size:  [XYoff[0],$
                         XYoff[1],$
                         80,35],$
                 base_uname: 'Norm1SelectionPeakYminBase',$
                 uname: 'norm_d_selection_peak_ymin_cw_field',$
                 xsize: 3,$
                 title: 'Ymin:'}

XYoff = [15,0] ;Ymax cw_field
sPeakRoiYmax = { size:  [sPeakRoiYmin.size[0]+sPeakRoiYmin.size[2]+XYoff[0],$
                         sPeakRoiYmin.size[1]+XYoff[1],$
                         sPeakRoiYmin.size[2:3]],$
                 base_uname: 'Norm1SelectionPeakYmaxBase',$
                 uname: 'norm_d_selection_peak_ymax_cw_field',$
                 xsize: 3,$
                 title: 'Ymax:'}

XYoff = [0,28] ;Back base -----------------------------------------------------
sBackBase = {size: [XYoff[0],$
                    XYoff[1],$
                    585,100],$
             frame: 0,$
             uname: 'back_norm_base_uname',$
             map:   0}

XYoff = [0,0]                   ;Ymin cw_field
sBackRoiYmin = { size: [XYoff[0],$
                        XYoff[1],$
                        80,35],$
                 base_uname: 'refm_back_ymin_base',$
                 uname: 'norm_d_selection_background_ymin_cw_field',$
                 xsize: 3,$
                 title: 'Ymin:'}

XYoff = [5,0]                   ;Ymax cw_field
sBackRoiYmax = { size: [sBackRoiYmin.size[0]+sBackRoiYmin.size[2]+XYoff[0],$
                        sBackRoiYmin.size[1]+XYoff[1],$
                        sBackRoiYmin.size[2:3]],$
                 base_uname: 'refm_back_ymax_base',$
                 uname: 'norm_d_selection_background_ymax_cw_field',$
                 xsize: 3,$
                 title: 'Ymax:'}

XYoff = [0,8]                 ;OR label
sBackOrLabel = {size: [sBackRoiYmax.size[0]+sBackRoiYmax.size[2]+XYoff[0],$
                       sBackRoiYmax.size[1]+XYoff[1]],$
                value: 'OR'}

XYoff = [20,-5]                 ;LOAD button
sBackLoadButton = {size: [sBackOrLabel.size[0]+XYoff[0],$
                          sBackOrLabel.size[1]+XYoff[1],$
                          100,$
                          30],$
                   value: 'LOAD BACK. FILE',$
                   uname: 'norm_d_selection_norm_load_button'}

XYoff = [3,43]                  ;ROI file Name label
sBackRoiFileLabel = {size:   [sBackRoiYmin.size[0]+XYoff[0],$
                              sBackRoiYmin.size[1]+XYoff[1]],$
                     value:  'Back. File:'}

XYoff = [70,-8]                 ;roi file text
sBackRoiFileText = {size:     [sBackRoiFileLabel.size[0]+XYoff[0],$
                               sBackRoiFileLabel.size[1]+XYoff[1],$
                               212],$
                    uname:    'norm_back_d_selection_file_text_field',$
                    sensitive: 0}

XYoff = [0,26]                   ;SAVE button
sBackSaveButton = {size:  [sBackRoiFileLabel.size[0]+XYoff[0],$
                           sBackRoiFileLabel.size[1]+XYoff[1],$
                           283,sLoadButton.size[3]],$
                   value: 'SAVE BACKGROUND FILE',$
                   uname: 'norm_back_save_button'}

;TAB Zoom ---------------------------------------------------------------------
sZoomBase = sRoiBase
XYoff = [20,30]
sZoomLabel1 = { size: [XYoff[0],$
                      XYoff[1]],$
               value: 'Left click (without releasing) in the PLOT '}
XYoff = [15,30]
sZoomLabel2 = { size: [sZoomLabel1.size[0]+XYoff[0],$
                       sZoomLabel1.size[1]+XYoff[1]],$
               value: 'to zoom this part of the display. '}

;##############################################################################
;################################# Tab #2 #####################################

ContrastBaseSize       = BackPeakBaseSize
ContrastBaseTitle      = 'Contrast Editor'

;TAB #2 (Contrast Editor)
ContrastDropListSize      = [45,15,200,30]

ContrastBottomSliderSize  = [5,ContrastDropListsize[1]+40,290,60]
ContrastBottomSliderTitle = 'Left Range'
ContrastBottomSliderMin = 0
ContrastBottomSliderMax = 255
ContrastBottomSliderDefaultValue = ContrastBottomSliderMin

ContrastNumberSliderSize  = [5,ContrastBottomSliderSize[1]+55,290,60]
ContrastNumberSliderTitle = 'Number color' 
ContrastNumberSliderMin = 1
ContrastNumberSliderMax = 255
ContrastNumberSliderDefaultValue = ContrastNumberSliderMax

ResetContrastButtonSize  = [ContrastDropListSize[0]+10,$
                            ContrastNumberSliderSize[1]+65,$
                            175,$
                            30]
ResetContrastButtonTitle = ' RESET FULL CONTRAST SESSION '

;##############################################################################
;######################## Tab #3 ##############################################

RescaleBaseSize        = BackPeakBaseSize
RescaleBaseTitle       = 'Scale/Range'  

RescaleXBaseSize  = [1,8,300,35]
RescaleXLabelSize = [10,0]
RescaleXLabelTitle= 'X-axis' 

Y_base_offset = 60
RescaleYBaseSize  = [1,8+Y_base_offset,RescaleXBaseSize[2],35]
RescaleYLabelSize = [10,0+Y_base_offset]
RescaleYLabelTitle= 'Y-axis' 

RescaleZBaseSize  = [1,8+2*Y_base_offset,RescaleXBaseSize[2],35]
RescaleZLabelSize = [10,0+2*Y_base_offset]
RescaleZLabelTitle= 'Z-axis' 

RescaleMincwfieldBaseSize = [15,0,80,35]
RescaleMincwfieldSize = [4,1]
RescaleMincwfieldLabel = 'Min:'

RescaleMaxcwfieldBaseSize = [90,0,80,35]
RescaleMaxcwfieldSize = [4,1]
RescaleMaxcwfieldLabel = 'Max:'

RescaleScaleDroplistSize = [160,0]
RescaleScaleDropList     = ['linear','log'] 

ResetScaleButtonSize  = [245,3,50,30]
ResetXScaleButtonTitle = 'RESET'
ResetYScaleButtonTitle = 'RESET'
ResetZScaleButtonTitle = 'RESET'

;full reset
FullResetButtonSize = [8,180,290,30]
FullResetButtonTitle= 'FULL RESET'

;TAB #4 (output file)
OutputBaseTitle = 'ASCII File Settings'

OutputFileFolderButtonSize     = [5,5,115,30]
OutputFileFolderButtonTitle    = 'Output File Path:'
yoff = 5
OutputFileFolderTextFieldSize  = [OutputFileFolderButtonSize[0] + $
                                  OutputFileFolderButtonSize[2] + yoff,$
                                  OutputFileFolderButtonSize[1], $
                                  200, $
                                  30]
yoff_vertical = 35
OutputFileNameLabelSize        = [OutputFileFolderButtonSize[0] + 2,$
                                  OutputFileFolderButtonSize[1] + $
                                  yoff_vertical]
OutputFileNameLabelTitle       = 'Output File Name:'
                                  
;******************************************************************************
;Build 1D tab
;******************************************************************************
Load_Normalization_D_TAB_BASE = $
  WIDGET_BASE(D_DD_Tab,$
              UNAME     = 'load_normalization_d_tab_base',$
              TITLE     = D_DD_TabTitle[0],$
              XOFFSET   = D_DD_TabSize[0],$
              YOFFSET   = D_DD_TabSize[1],$
              SCR_XSIZE = D_DD_TabSize[2],$
              SCR_YSIZE = D_DD_TabSize[3])

load_normalization_D_draw = $
  WIDGET_DRAW(load_normalization_D_tab_base,$
              XOFFSET       = 0,$
              YOFFSET       = 0,$
;              X_SCROLL_SIZE = GlobalLoadGraphs[2]-20,$
;              Y_SCROLL_SIZE = GlobalLoadGraphs[3]-24,$
              XSIZE         = GlobalLoadGraphs[2],$
              YSIZE         = GlobalLoadGraphs[3],$
              UNAME         = 'load_normalization_D_draw',$
              RETAIN        = 2,$
              /KEYBOARD_EVENT,$
;              /SCROLL,$
              /BUTTON_EVENTS,$
              /MOTION_EVENTS)

;create the back/peak and rescale tab
BackPeakRescaleTab = $
  WIDGET_TAB(load_normalization_D_tab_base,$
             UNAME     = 'norm_back_peak_rescale_tab',$
             XOFFSET   = BackPeakRescaleTabSize[0],$
             YOFFSET   = BackPeakRescaleTabSize[1],$
             SCR_XSIZE = BackPeakRescaleTabSize[2],$
             SCR_YSIZE = BackPeakRescaleTabSize[3],$
             sensitive = 0,$
             LOCATION  = 0)

BackPeakBase = WIDGET_BASE(BackPeakRescaleTab,$
                           UNAME     = 'norm_back_peak_base',$
                           XOFFSET   = BackPeakBaseSize[0],$
                           YOFFSET   = BackPeakBaseSize[1],$
                           SCR_XSIZE = BackPeakBaseSize[2],$
                           SCR_YSIZE = BackPeakBaseSize[3],$
                           TITLE     = BackPeakBaseTitle)

;Ymin and Ymax working label
wYminMaxLabel = WIDGET_LABEL(BackPeakBase,$
                             XOFFSET = sYminMaxLabel.size[0],$
                             YOFFSET = sYminMaxLabel.size[1],$
                             VALUE   = sYminMaxLabel.value,$
                             UNAME   = sYminMaxLabel.uname)

;TAB #1-1 (ROI) ***************************************************************
wRoiTab = WIDGET_TAB(BackPeakBase,$
                      UNAME     = sTab.uname,$
                      XOFFSET   = sTab.size[0],$
                      YOFFSET   = sTab.size[1],$
                      SCR_XSIZE = sTab.size[2],$
                      SCR_YSIZE = sTab.size[3],$
                      FRAME     = 0)

;ROI base ====================================================================
wRoiBase = WIDGET_BASE(wRoiTab,$
                       XOFFSET   = sRoiBase.size[0],$
                       YOFFSET   = sRoiBase.size[1],$
                       SCR_XSIZE = sRoiBase.size[2],$
                       SCR_YSIZE = sRoiBase.size[3],$
                       TITLE     = sTab.list[0])

;Ymin
wRoiYminBase = WIDGET_BASE(wRoiBase,$
                           XOFFSET   = sRoiYmin.size[0],$
                           YOFFSET   = sRoiYmin.size[1],$
                           SCR_XSIZE = sRoiYmin.size[2],$
                           SCR_YSIZE = sRoiYmin.size[3],$
                           UNAME     = sRoiYmin.base_uname,$
                           TITLE     = sTab.list[0])

wRoiYminField = CW_FIELD(wRoiYminBase,$
                         XSIZE         = sRoiYmin.xsize,$
                         RETURN_EVENTS = 1,$
                         UNAME         = sRoiYmin.uname,$
                         TITLE         = sRoiYmin.title)

;Ymax
wRoiYmaxBase = WIDGET_BASE(wRoiBase,$
                           XOFFSET   = sRoiYmax.size[0],$
                           YOFFSET   = sRoiYmax.size[1],$
                           SCR_XSIZE = sRoiYmax.size[2],$
                           SCR_YSIZE = sRoiYmax.size[3],$
                           UNAME     = sRoiYmax.base_uname,$
                           TITLE     = sTab.list[0])

wRoiYmaxField = CW_FIELD(wRoiYmaxBase,$
                         XSIZE         = sRoiYmax.xsize,$
                         RETURN_EVENTS = 1,$
                         UNAME         = sRoiYmax.uname,$
                         TITLE         = sRoiYmax.title)

;OR label
wOrLabel = WIDGET_LABEL(wRoiBase,$
                        XOFFSET = sOrLabel.size[0],$
                        YOFFSET = sOrLabel.size[1],$
                        VALUE   = sOrLabel.value)

;LOAD ROI button
wLoadButton = WIDGET_BUTTON(wRoiBase,$
                            XOFFSET   = sLoadButton.size[0],$
                            YOFFSET   = sLoadButton.size[1],$
                            SCR_XSIZE = sLoadButton.size[2],$
                            SCR_YSIZE = sLoadButton.size[3],$
                            VALUE     = sLoadButton.value,$
                            UNAME     = sLoadButton.uname)

;Roi file label
wRoiFileLabel = WIDGET_LABEL(wRoiBase,$
                             XOFFSET = sRoiFileLabel.size[0],$
                             YOFFSET = sRoiFileLabel.size[1],$
                             VALUE   = sRoiFileLabel.value)

;ROI text file
wRoiFileText = WIDGET_TEXT(wRoiBase,$
                           XOFFSET   = sRoiFileText.size[0],$
                           YOFFSET   = sRoiFileText.size[1],$
                           SCR_XSIZE = sRoiFileText.size[2],$
                           UNAME     = sRoiFileText.uname,$
                           SENSITIVE = sRoiFileText.sensitive,$
                           /ALIGN_LEFT,$
                           /EDITABLE)
                           
;SAVE ROI button
wSaveButton = WIDGET_BUTTON(wRoiBase,$
                            XOFFSET   = sSaveButton.size[0],$
                            YOFFSET   = sSaveButton.size[1],$
                            SCR_XSIZE = sSaveButton.size[2],$
                            SCR_YSIZE = sSaveButton.size[3],$
                            VALUE     = sSaveButton.value,$
                            UNAME     = sSaveButton.uname)

;TAB #1-2 Peak/Back base ======================================================
wPeakBackBase = WIDGET_BASE(wRoiTab,$
                            XOFFSET   = sPeakBackBase.size[0],$
                            YOFFSET   = sPeakBackBase.size[1],$
                            SCR_XSIZE = sPeakBackBase.size[2],$
                            SCR_YSIZE = sPeakBackBase.size[3],$
                            TITLE     = sTab.list[1])

;Peak/Background CW_BGROUP
wPeakBackGroup = CW_BGROUP(wPeakBackBase,$
                           sPeakBackGroup.list,$
                           XOFFSET   = sPeakBackGroup.size[0],$
                           YOFFSET   = sPeakBackGroup.size[1],$
                           UNAME     = sPeakBackGroup.uname,$
                           SET_VALUE = sPeakBackGroup.value,$
                           ROW       = 1,$
                           /EXCLUSIVE,$
                           /RETURN_NAME,$
                           /NO_RELEASE)
                           
;PEAK base --------------------------------------------------------------------
wPeakBase = WIDGET_BASE(wPeakBackBase,$
                        XOFFSET   = sPeakBase.size[0],$
                        YOFFSET   = sPeakBase.size[1],$
                        SCR_XSIZE = sPeakBase.size[2],$
                        SCR_YSIZE = sPeakBase.size[3],$
                        UNAME     = sPeakBase.uname,$
                        FRAME     = sPeakBase.frame,$
                        MAP       = sPeakBase.map)

;Ymin
wPeakRoiYminBase = WIDGET_BASE(wPeakBase,$
                               XOFFSET   = sPeakRoiYmin.size[0],$
                               YOFFSET   = sPeakRoiYmin.size[1],$
                               SCR_XSIZE = sPeakRoiYmin.size[2],$
                               SCR_YSIZE = sPeakRoiYmin.size[3],$
                               UNAME     = sPeakRoiYmin.base_uname,$
                               TITLE     = sTab.list[0])

wPeakRoiYminField = CW_FIELD(wPeakRoiYminBase,$
                             XSIZE         = sPeakRoiYmin.xsize,$
                             RETURN_EVENTS = 1,$
                             UNAME         = sPeakRoiYmin.uname,$
                             TITLE         = sPeakRoiYmin.title)

;Ymax
wPeakRoiYmaxBase = WIDGET_BASE(wPeakBase,$
                               XOFFSET   = sPeakRoiYmax.size[0],$
                               YOFFSET   = sPeakRoiYmax.size[1],$
                               SCR_XSIZE = sPeakRoiYmax.size[2],$
                               SCR_YSIZE = sPeakRoiYmax.size[3],$
                               UNAME     = sPeakRoiYmax.base_uname,$
                               TITLE     = sTab.list[0])

wPeakRoiYmaxField = CW_FIELD(wPeakRoiYmaxBase,$
                             XSIZE         = sPeakRoiYmax.xsize,$
                             RETURN_EVENTS = 1,$
                             UNAME         = sPeakRoiYmax.uname,$
                             TITLE         = sPeakRoiYmax.title)

;BACK base --------------------------------------------------------------------
wBackBase = WIDGET_BASE(wPeakBackBase,$
                        XOFFSET   = sBackBase.size[0],$
                        YOFFSET   = sBackBase.size[1],$
                        SCR_XSIZE = sBackBase.size[2],$
                        SCR_YSIZE = sBackBase.size[3],$
                        UNAME     = sBackBase.uname,$
                        FRAME     = sBackBase.frame,$
                        MAP       = sBackBase.map)

;Ymin
wRoiYminBase = WIDGET_BASE(wBackBase,$
                           XOFFSET   = sBackRoiYmin.size[0],$
                           YOFFSET   = sBackRoiYmin.size[1],$
                           SCR_XSIZE = sBackRoiYmin.size[2],$
                           SCR_YSIZE = sBackRoiYmin.size[3],$
                           UNAME     = sBackRoiYmin.base_uname,$
                           TITLE     = sTab.list[0])

wRoiYminField = CW_FIELD(wRoiYminBase,$
                         XSIZE         = sBackRoiYmin.xsize,$
                         RETURN_EVENTS = 1,$
                         UNAME         = sBackRoiYmin.uname,$
                         TITLE         = sBackRoiYmin.title)

;Ymax
wRoiYmaxBase = WIDGET_BASE(wBackBase,$
                           XOFFSET   = sBackRoiYmax.size[0],$
                           YOFFSET   = sBackRoiYmax.size[1],$
                           SCR_XSIZE = sBackRoiYmax.size[2],$
                           SCR_YSIZE = sBackRoiYmax.size[3],$
                           UNAME     = sBackRoiYmax.base_uname,$
                           TITLE     = sTab.list[0])

wRoiYmaxField = CW_FIELD(wRoiYmaxBase,$
                         XSIZE         = sBackRoiYmax.xsize,$
                         RETURN_EVENTS = 1,$
                         UNAME         = sBackRoiYmax.uname,$
                         TITLE         = sBackRoiYmax.title)

;OR label
wBackOrLabel = WIDGET_LABEL(wBackBase,$
                            XOFFSET = sBackOrLabel.size[0],$
                            YOFFSET = sBackOrLabel.size[1],$
                            VALUE   = sbackOrLabel.value)

;LOAD ROI button
wLoadButton = WIDGET_BUTTON(wBackBase,$
                            XOFFSET   = sBackLoadButton.size[0],$
                            YOFFSET   = sBackLoadButton.size[1],$
                            SCR_XSIZE = sBackLoadButton.size[2],$
                            SCR_YSIZE = sBackLoadButton.size[3],$
                            VALUE     = sBackLoadButton.value,$
                            UNAME     = sBackLoadButton.uname)

;Roi file label
wRoiFileLabel = WIDGET_LABEL(wBackBase,$
                             XOFFSET = sBackRoiFileLabel.size[0],$
                             YOFFSET = sBackRoiFileLabel.size[1],$
                             VALUE   = sBackRoiFileLabel.value)

;ROI text file
wRoiFileText = WIDGET_TEXT(wBackBase,$
                           XOFFSET   = sBackRoiFileText.size[0],$
                           YOFFSET   = sBackRoiFileText.size[1],$
                           SCR_XSIZE = sBackRoiFileText.size[2],$
                           UNAME     = sBackRoiFileText.uname,$
                           SENSITIVE = sBackRoiFileText.sensitive,$
                           /ALIGN_LEFT,$
                           /EDITABLE)
                           
;SAVE ROI button
wSaveButton = WIDGET_BUTTON(wBackBase,$
                            XOFFSET   = sBackSaveButton.size[0],$
                            YOFFSET   = sBackSaveButton.size[1],$
                            SCR_XSIZE = sBackSaveButton.size[2],$
                            SCR_YSIZE = sBackSaveButton.size[3],$
                            VALUE     = sBackSaveButton.value,$
                            UNAME     = sBackSaveButton.uname)

;TAB #1-3 Zoom base ===========================================================
wZoomBase = WIDGET_BASE(wRoiTab,$
                        XOFFSET   = sZoomBase.size[0],$
                        YOFFSET   = sZoomBase.size[1],$
                        SCR_XSIZE = sZoomBase.size[2],$
                        SCR_YSIZE = sZoomBase.size[3],$
                        TITLE     = sTab.list[2])

wZoomLabel = WIDGET_LABEL(wZoomBase,$
                          XOFFSET = sZoomLabel1.size[0],$
                          YOFFSET = sZoomLabel1.size[1],$
                          VALUE   = sZoomLabel1.value)
wZoomLabel = WIDGET_LABEL(wZoomBase,$
                          XOFFSET = sZoomLabel2.size[0],$
                          YOFFSET = sZoomLabel2.size[1],$
                          VALUE   = sZoomLabel2.value)

;Tab #2 (contrast base)
ContrastBase = WIDGET_BASE(BackPeakRescaleTab,$
                           UNAME     = 'normalization_rescale_base',$
                           XOFFSET   = ContrastBaseSize[0],$
                           YOFFSET   = ContrastBaseSize[1],$
                           SCR_XSIZE = ContrastBaseSize[2],$
                           SCR_YSIZE = ContrastBaseSize[3],$
                           TITLE     = ContrastBaseTitle)

ContrastDropList = WIDGET_DROPLIST(ContrastBase,$
                                   VALUE     = LoadctList,$
                                   XOFFSET   = ContrastDropListSize[0],$
                                   YOFFSET   = ContrastDropListSize[1],$
                                   SCR_XSIZE = ContrastDropListSize[2],$
                                   SCR_YSIZE = ContrastDropListSize[3],$
                                   /TRACKING_EVENTS,$
                                   UNAME     = $
                                   'normalization_contrast_droplist',$
                                   SENSITIVE = 1)

ContrastBottomSlider = WIDGET_SLIDER(ContrastBase,$
                                     XOFFSET   = ContrastBottomSliderSize[0],$
                                     YOFFSET   = ContrastBottomSliderSize[1],$
                                     SCR_XSIZE = ContrastBottomSliderSize[2],$
                                     SCR_YSIZE = ContrastBottomSliderSize[3],$
                                     MINIMUM   = ContrastBottomSliderMin,$
                                     MAXIMUM   = ContrastBottomSliderMax,$
                                     UNAME     = $
                                     'normalization_contrast_bottom_slider',$
                                     /TRACKING_EVENTS,$
                                     TITLE     = ContrastBottomSliderTitle,$
                                     VALUE     = $
                                     ContrastBottomSliderDefaultValue,$
                                     SENSITIVE = 1)

ContrastNumberSlider = WIDGET_SLIDER(ContrastBase,$
                                     XOFFSET   = ContrastNumberSliderSize[0],$
                                     YOFFSET   = ContrastNumberSliderSize[1],$
                                     SCR_XSIZE = ContrastNumberSliderSize[2],$
                                     SCR_YSIZE = ContrastNumberSliderSize[3],$
                                     MINIMUM   = ContrastNumberSliderMin,$
                                     MAXIMUM   = ContrastNumberSliderMax,$
                                     UNAME     = $
                                     'normalization_contrast_number_slider',$
                                     /TRACKING_EVENTS,$
                                     TITLE     = ContrastNumberSliderTitle,$
                                     VALUE     = $
                                     ContrastNumberSliderDefaultValue,$
                                     SENSITIVE = 1)

ResetContrastButton = WIDGET_BUTTON(ContrastBase,$
                                    XOFFSET   = ResetContrastButtonSize[0],$
                                    YOFFSET   = ResetContrastButtonSize[1],$
                                    SCR_XSIZE = ResetContrastButtonSize[2],$
                                    SCR_YSIZE = ResetContrastButtonSize[3],$
                                    VALUE     = ResetContrastButtonTitle,$
                                    UNAME     = $
                                    'normalization_reset_contrast_button',$
                                    SENSITIVE = 1)


;Tab #3 (rescale base)
RescaleBase = WIDGET_BASE(BackPeakRescaleTab,$
                          UNAME     = 'normalization_rescale_base',$
                          XOFFSET   = RescaleBaseSize[0],$
                          YOFFSET   = RescaleBaseSize[1],$
                          SCR_XSIZE = RescaleBaseSize[2],$
                          SCR_YSIZE = RescaleBaseSize[3],$
                          TITLE     = RescaleBaseTitle)

;X base
RescaleXLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET = RescaleXLabelSize[0],$
                             YOFFSET = RescaleXLabelSize[1],$
                             VALUE   = RescaleXLabelTitle)

RescaleXBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'normalization_rescale_x_base',$
                           XOFFSET   = RescaleXBaseSize[0],$
                           YOFFSET   = RescaleXBaseSize[1],$
                           SCR_XSIZE = RescaleXBaseSize[2],$
                           SCR_YSIZE = RescaleXBaseSize[3],$
                           FRAME     = 1)

RescaleXMincwfieldBase = WIDGET_BASE(RescaleXBase,$
                                     XOFFSET   = RescaleMincwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMincwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMincwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMincwfieldBaseSize[3])

RescaleXMinCWField = CW_FIELD(RescaleXMincwfieldBase,$
                              XSIZE         = RescaleMincwfieldSize[0],$
                              YSIZE         = RescaleMincwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = $
                              'normalization_rescale_xmin_cwfield')

RescaleXMaxcwfieldBase = WIDGET_BASE(RescaleXBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleXMaxCWField = CW_FIELD(RescaleXMaxcwfieldBase,$
                             XSIZE         = RescaleMaxcwfieldSize[0],$
                             YSIZE         = RescaleMaxcwFieldSize[1],$
                             ROW           = 1,$
                             /FLOAT,$
                             RETURN_EVENTS = 1,$
                             TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         = $
                              'normalization_rescale_xmax_cwfield')

ResetXScaleButton = WIDGET_BUTTON(RescaleXBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetXScaleButtonTitle,$
                                  UNAME     = $
                                  'normalization_reset_xaxis_button',$
                                  SENSITIVE = 1)

;Y base
RescaleYLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET = RescaleYLabelSize[0],$
                             YOFFSET = RescaleYLabelSize[1],$
                             VALUE   = RescaleYLabelTitle)

RescaleYBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'normalization_rescale_Y_base',$
                           XOFFSET   = RescaleYBaseSize[0],$
                           YOFFSET   = RescaleYBaseSize[1],$
                           SCR_XSIZE = RescaleYBaseSize[2],$
                           SCR_YSIZE = RescaleYBaseSize[3],$
                           FRAME     = 1)

RescaleYMincwfieldBase = WIDGET_BASE(RescaleYBase,$
                                     XOFFSET   = RescaleMincwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMincwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMincwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMincwfieldBaseSize[3])

RescaleYMinCWField = CW_FIELD(RescaleYMincwfieldBase,$
                              XSIZE         = RescaleMincwfieldSize[0],$
                              YSIZE         = RescaleMincwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = $
                              'normalization_rescale_ymin_cwfield')
                             
RescaleYMaxcwfieldBase = WIDGET_BASE(RescaleYBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleYMaxCWField = CW_FIELD(RescaleYMaxcwfieldBase,$
                              XSIZE         = RescaleMaxcwfieldSize[0],$
                              YSIZE         = RescaleMaxcwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         = $
                              'normalization_rescale_ymax_cwfield')

ResetYScaleButton = WIDGET_BUTTON(RescaleYBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetYScaleButtonTitle,$
                                  UNAME     = $
                                  'normalization_reset_yaxis_button',$
                                  SENSITIVE = 1)

;Z base
RescaleZLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET = RescaleZLabelSize[0],$
                             YOFFSET = RescaleZLabelSize[1],$
                             VALUE   = RescaleZLabelTitle)

RescaleZBase = WIDGET_BASE(RescaleBase,$
                           UNAME     = 'normalization_rescale_Z_base',$
                           XOFFSET   = RescaleZBaseSize[0],$
                           YOFFSET   = RescaleZBaseSize[1],$
                           SCR_XSIZE = RescaleZBaseSize[2],$
                           SCR_YSIZE = RescaleZBaseSize[3],$
                           FRAME     = 1)

RescaleZMincwfieldBase = WIDGET_BASE(RescaleZBase,$
                                     XOFFSET   = RescaleMincwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMincwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMincwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMincwfieldBaseSize[3])

RescaleZMinCWField = CW_FIELD(RescaleZMincwfieldBase,$
                              XSIZE         = RescaleMincwfieldSize[0],$
                              YSIZE         = RescaleMincwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMincwfieldLabel,$
                              UNAME         = $
                              'normalization_rescale_zmin_cwfield')

RescaleZMaxcwfieldBase = WIDGET_BASE(RescaleZBase,$
                                     XOFFSET   = RescaleMaxcwfieldBaseSize[0],$
                                     YOFFSET   = RescaleMaxcwfieldBaseSize[1],$
                                     SCR_XSIZE = RescaleMaxcwfieldBaseSize[2],$
                                     SCR_YSIZE = RescaleMaxcwfieldBaseSize[3])

RescaleZMaxCWField = CW_FIELD(RescaleZMaxcwfieldBase,$
                              XSIZE         = RescaleMaxcwfieldSize[0],$
                              YSIZE         = RescaleMaxcwFieldSize[1],$
                              ROW           = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = RescaleMaxcwfieldLabel,$
                              UNAME         = $
                              'normalization_rescale_zmax_cwfield')

RescaleZScaleDroplist = WIDGET_DROPLIST(RescaleZBase,$
                                        VALUE     = RescaleScaleDroplist,$
                                        XOFFSET   = $
                                        RescaleScaleDroplistSize[0],$
                                        YOFFSET   = $
                                        RescaleScaleDroplistSize[1],$
                                        UNAME     = $
                                        'normalization_rescale_z_droplist',$
                                        SENSITIVE = 1)
widget_control, RescaleZScaleDroplist, set_droplist_select=1                                        

ResetZScaleButton = WIDGET_BUTTON(RescaleZBase,$
                                  XOFFSET   = ResetScaleButtonSize[0],$
                                  YOFFSET   = ResetScaleButtonSize[1],$
                                  SCR_XSIZE = ResetScaleButtonSize[2],$
                                  SCR_YSIZE = ResetScaleButtonSize[3],$
                                  VALUE     = ResetZScaleButtonTitle,$
                                  UNAME     = $
                                  'normalization_reset_zaxis_button',$
                                  SENSITIVE = 1)

;full reset
FullResetButton = WIDGET_BUTTON(RescaleBase,$
                                XOFFSET   = FullResetButtonSize[0],$
                                YOFFSET   = FullResetButtonSize[1],$
                                SCR_XSIZE = FullResetButtonSize[2],$
                                SCR_YSIZE = FullResetButtonSize[3],$
                                UNAME     = $
                                'normalization_full_reset_button',$
                                VALUE     = FullResetButtonTitle,$
                                SENSITIVE = 1)

END
