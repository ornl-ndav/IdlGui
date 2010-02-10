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

PRO MakeGuiLoadData1DTab, D_DD_Tab, $
                          D_DD_TabSize, $
                          D_DD_TabTitle, $
                          GlobalLoadGraphs, $
                          LoadctList

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;define 3 tabs (Back/Signal Selection, Contrast and Rescale)
;Tab#1
BackPeakRescaleTabSize = [4,615,D_DD_TabSize[2]-20,D_DD_TabSize[3]-645]
BackPeakBaseSize       = [0,0,BackPeakRescaleTabSize[2],$
                          BackPeakRescaleTabSize[3]]
BackPeakBaseTitle      = 'ROI and Peak/Background Selection  '
;Tab#2
ContrastBaseSize       = BackPeakBaseSize
ContrastBaseTitle      = '  Contrast Editor  '
;Tab#3
RescaleBaseSize        = BackPeakBaseSize
RescaleBaseTitle       = '   Range Displayed   '  

;------------------------------------------------------------------------------
;-TAB #1 ----------------------------------------------------------------------
;------------------------------------------------------------------------------

;Ymin and Ymax working
sYMinMaxLabel = { size: [360,5],$
                  value: 'Current working selection -> Ymin',$
                  uname: 'data_ymin_ymax_label'}

sTab = { size:  [5,5,D_DD_TabSize[2]-35,120],$
         list:  ['Region Of Interest (ROI)',$
                 'Peak / Background',$
                 'ZOOM mode'],$
         uname: 'data_roi_peak_background_tab'}

;;TAB ROI ---------------------------------------------------------------------
sRoiBase = { size: [0,0,D_DD_TabSize[2],100] }
             
XYoff = [0,10] ;Ymin cw_field
sRoiYmin = { size: [XYoff[0],$
                    XYoff[1],$
                    80,35],$
             base_uname: 'Data1SelectionROIYminBase',$
             uname: 'data_d_selection_roi_ymin_cw_field',$
             xsize: 3,$
             title: 'Ymin:'}

XYoff = [5,0] ;Ymax cw_field
sRoiYmax = { size: [sRoiYmin.size[0]+sRoiYmin.size[2]+XYoff[0],$
                    sRoiYmin.size[1]+XYoff[1],$
                    sRoiYmin.size[2:3]],$
             base_uname: 'Data1SelectionROIYmaxBase',$
             uname: 'data_d_selection_roi_ymax_cw_field',$
             xsize: 3,$
             title: 'Ymax:'}

XYoff = [10,10] ;OR label
sOrLabel = {size: [sRoiYmax.size[0]+sRoiYmax.size[2]+XYoff[0],$
                   sRoiYmax.size[1]+XYoff[1]],$
            value: 'OR'}
                  
XYoff = [30,-7] ;LOAD button
sLoadButton = {size: [sOrLabel.size[0]+XYoff[0],$
                      sOrLabel.size[1]+XYoff[1],$
                      380,$
                      30],$
               value: 'L O A D    R O I    F I L E',$
               uname: 'data_roi_load_button'}

XYoff = [3,48] ;ROI file Name label
sRoiFileLabel = {size:   [sRoiYmin.size[0]+XYoff[0],$
                          sRoiYmin.size[1]+XYoff[1]],$
                 value:  'ROI file Name:'}
                         
XYoff = [90,-8] ;roi file text
sRoiFileText = {size:     [sRoiFileLabel.size[0]+XYoff[0],$
                           sRoiFileLabel.size[1]+XYoff[1],$
                           350],$
                uname:    'data_roi_selection_file_text_field',$
                sensitive: 0}

XYoff = [2,0] ;SAVE button
sSaveButton = {size:  [sRoiFileText.size[0]+sRoiFileText.size[2]+XYoff[0],$
                       sRoiFileText.size[1]+XYoff[1],$
                       140,sLoadButton.size[3]],$
               value: 'SAVE ROI FILE',$
               uname: 'data_roi_save_button'}
               
;TAB Peak/Back ---------------------------------------------------------------
sPeakBackBase = sRoiBase

XYoff = [0,0] ;Peak or Back cw_bgroup
sPeakBackGroup = {size:  [XYoff[0],$
                          XYoff[1]],$
                  uname: 'peak_data_back_group',$
                  value: 0,$
                  list:  ['Peak','Background']}

XYoff = [0,28] ;PEAK base ----------------------------------------------------
sPeakBase = {size: [XYoff[0],$
                    XYoff[1],$
                    585,65],$
             frame: 0,$
             uname: 'peak_data_base_uname',$
             map:   1}

XYoff = [40,10] ;Ymin cw_field
sPeakRoiYmin = { size:  [XYoff[0],$
                         XYoff[1],$
                         80,35],$
                 base_uname: 'Data1SelectionPeakYminBase',$
                 uname: 'data_d_selection_peak_ymin_cw_field',$
                 xsize: 3,$
                 title: 'Ymin:'}

XYoff = [15,0] ;Ymax cw_field
sPeakRoiYmax = { size:  [sPeakRoiYmin.size[0]+sPeakRoiYmin.size[2]+XYoff[0],$
                         sPeakRoiYmin.size[1]+XYoff[1],$
                         sPeakRoiYmin.size[2:3]],$
                 base_uname: 'Data1SelectionPeakYmaxBase',$
                 uname: 'data_d_selection_peak_ymax_cw_field',$
                 xsize: 3,$
                 title: 'Ymax:'}

XYoff = [0,28] ;Back base -----------------------------------------------------
sBackBase = {size: [XYoff[0],$
                    XYoff[1],$
                    585,65],$
             frame: 0,$
             uname: 'back_data_base_uname',$
             map:   0}

XYoff = [0,0]                   ;Ymin cw_field
sBackRoiYmin = { size: [XYoff[0],$
                        XYoff[1],$
                        80,35],$
                 base_uname: 'refm_back_ymin_base',$
                 uname: 'data_d_selection_background_ymin_cw_field',$
                 xsize: 3,$
                 title: 'Ymin:'}

XYoff = [5,0]                   ;Ymax cw_field
sBackRoiYmax = { size: [sBackRoiYmin.size[0]+sBackRoiYmin.size[2]+XYoff[0],$
                        sBackRoiYmin.size[1]+XYoff[1],$
                        sBackRoiYmin.size[2:3]],$
                 base_uname: 'refm_back_ymax_base',$
                 uname: 'data_d_selection_background_ymax_cw_field',$
                 xsize: 3,$
                 title: 'Ymax:'}

XYoff = [5,8]                 ;OR label
sBackOrLabel = {size: [sBackRoiYmax.size[0]+sBackRoiYmax.size[2]+XYoff[0],$
                       sBackRoiYmax.size[1]+XYoff[1]],$
                value: 'OR'}

XYoff = [25,-5]                 ;LOAD button
sBackLoadButton = {size: [sBackOrLabel.size[0]+XYoff[0],$
                          sBackOrLabel.size[1]+XYoff[1],$
                          390,$
                          30],$
                   value: 'LOAD BACKGROUND SELECTION FILE',$
                   uname: 'data_d_selection_back_load_button'}

XYoff = [3,43]                  ;ROI file Name label
sBackRoiFileLabel = {size:   [sBackRoiYmin.size[0]+XYoff[0],$
                              sBackRoiYmin.size[1]+XYoff[1]],$
                     value:  'Back. File Name:'}

XYoff = [100,-8]                 ;roi file text
sBackRoiFileText = {size:     [sBackRoiFileLabel.size[0]+XYoff[0],$
                               sBackRoiFileLabel.size[1]+XYoff[1],$
                               350],$
                    uname:    'data_back_d_selection_file_text_field',$
                    sensitive: 0}

XYoff = [2,0]                   ;SAVE button
sBackSaveButton = {size:  [sBackRoiFileText.size[0]+ $
                           sBackRoiFileText.size[2]+XYoff[0],$
                           sBackRoiFileText.size[1]+XYoff[1],$
                           130,sLoadButton.size[3]],$
                   value: 'SAVE BACK. FILE',$
                   uname: 'data_back_save_button'}

;TAB Zoom ---------------------------------------------------------------------
sZoomBase = sRoiBase
XYoff = [70,40]
sZoomLabel = { size: [XYoff[0],$
                      XYoff[1]],$
               value: 'Left click (without releasing) in the PLOT to zoom ' + $
               'this part of the display. '}

;------------------------------------------------------------------------------
;-TAB #2 (Contrast Editor) ----------------------------------------------------
;------------------------------------------------------------------------------

ContrastDropListSize      = [5,13,200,30]

ContrastBottomSliderSize  = [220,0,370,60]
ContrastBottomSliderTitle = 'Left Range'
ContrastBottomSliderMin = 0
ContrastBottomSliderMax = 255
ContrastBottomSliderDefaultValue = ContrastBottomSliderMin

ContrastNumberSliderSize  = [220,65,370,60]
ContrastNumberSliderTitle = 'Number color' 
ContrastNumberSliderMin = 1
ContrastNumberSliderMax = 255
ContrastNumberSliderDefaultValue = ContrastNumberSliderMax

ResetContrastButtonSize  = [ContrastDropListSize[0]+10,$
                            80,$
                            175,$
                            30]
ResetContrastButtonTitle = ' RESET FULL CONTRAST SESSION '

;------------------------------------------------------------------------------
;TAB #3 (Rescale Base) --------------------------------------------------------
;------------------------------------------------------------------------------
yoff = 10
RescaleXBaseSize  = [5,8,500,35]
RescaleXLabelSize = [10,yoff]
RescaleXLabelTitle= 'X-axis' 

Y_base_offset = 40
RescaleYBaseSize  = [5,8+Y_base_offset,RescaleXBaseSize[2],35]
RescaleYLabelSize = [10,0+Y_base_offset+yoff]
RescaleYLabelTitle= 'Y-axis' 

RescaleZBaseSize  = [5,8+2*Y_base_offset,RescaleXBaseSize[2],35]
RescaleZLabelSize = [10,0+2*Y_base_offset+yoff]
RescaleZLabelTitle= 'Z-axis' 

xoff = 10
RescaleMincwfieldBaseSize = [35+xoff,0,100,35]
RescaleMincwfieldSize = [8,1]
RescaleMincwfieldLabel = 'Min:'

RescaleMaxcwfieldBaseSize = [135+xoff,0,100,35]
RescaleMaxcwfieldSize = [8,1]
RescaleMaxcwfieldLabel = 'Max:'

RescaleScaleDroplistSize = [235+xoff,0]
RescaleScaleDropList     = [' linear ',' log '] 

ResetScaleButtonSize  = [345+xoff,3,140,30]
ResetXScaleButtonTitle = 'RESET X-AXIS'
ResetYScaleButtonTitle = 'RESET Y-AXIS'
ResetZScaleButtonTitle = 'RESET Z-AXIS'

;full reset
FullResetButtonSize = [515,5,85,122]
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
OutputFileNameLabelSize        = $
  [OutputFileFolderButtonSize[0] + 2,$
   OutputFileFolderButtonSize[1] + yoff_vertical]
OutputFileNameLabelTitle       = 'Output File Name:'

;******************************************************************************
;Build 1D tab
;******************************************************************************
load_data_D_tab_base = WIDGET_BASE(D_DD_Tab,$
                                   UNAME     = 'load_data_d_tab_base',$
                                   TITLE     = D_DD_TabTitle[0],$
                                   XOFFSET   = D_DD_TabSize[0],$
                                   YOFFSET   = D_DD_TabSize[1],$
                                   SCR_XSIZE = D_DD_TabSize[2],$
                                   SCR_YSIZE = D_DD_TabSize[3])

load_data_D_draw = WIDGET_DRAW(load_data_D_tab_base,$
                               XOFFSET       = 0,$
                               YOFFSET       = 0,$
                               X_SCROLL_SIZE = GlobalLoadGraphs[2]-20,$
                               Y_SCROLL_SIZE = GlobalLoadGraphs[3],$
                               ;Y_SCROLL_SIZE = GlobalLoadGraphs[3]-24,$
                               XSIZE         = GlobalLoadGraphs[2]-20,$
                               ;YSIZE         = GlobalLoadGraphs[3]-24,$
                               YSIZE         = GlobalLoadGraphs[3],$
                               UNAME         = 'load_data_D_draw',$
                               RETAIN        = 2,$
                               /KEYBOARD_EVENT,$
                               /BUTTON_EVENTS,$
                               /SCROLL,$
                               /MOTION_EVENTS)

;create the back/peak and rescale tab
BackPeakRescaleTab = WIDGET_TAB(load_data_D_tab_base,$
                                UNAME     = 'data_back_peak_rescale_tab',$
                                XOFFSET   = BackPeakRescaleTabSize[0],$
                                YOFFSET   = BackPeakRescaleTabSize[1],$
                                SCR_XSIZE = BackPeakRescaleTabSize[2],$
                                SCR_YSIZE = BackPeakRescaleTabSize[3],$
                                SENSITIVE = 0,$
                                LOCATION  = 0)

;TAB #1 (ROI and Peak/Background Selection) -----------------------------------
BackPeakBase = WIDGET_BASE(BackPeakRescaleTab,$
                            UNAME     = 'data_back_peak_base',$
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
                          XOFFSET = sZoomLabel.size[0],$
                          YOFFSET = sZoomLabel.size[1],$
                          VALUE   = sZoomLabel.value)

;Tab #2 (contrast base) -------------------------------------------------------
ContrastBase = widget_base(BackPeakRescaleTab,$
                          uname='data_contrast_base',$
                          xoffset=ContrastBaseSize[0],$
                          yoffset=ContrastBaseSize[1],$
                          scr_xsize=ContrastBaseSize[2],$
                          scr_ysize=ContrastBaseSize[3],$
                          title=ContrastBaseTitle)

ContrastDropList = widget_droplist(ContrastBase,$
                                   value=LoadctList,$
                                   xoffset=ContrastDropListSize[0],$
                                   yoffset=ContrastDropListSize[1],$
                                   scr_xsize=ContrastDropListSize[2],$
                                   scr_ysize=ContrastDropListSize[3],$
                                   /tracking_events,$
                                   uname='data_contrast_droplist')

ContrastBottomSlider = widget_slider(ContrastBase,$
                                     xoffset=ContrastBottomSliderSize[0],$
                                     yoffset=ContrastBottomSliderSize[1],$
                                     scr_xsize=ContrastBottomSliderSize[2],$
                                     scr_ysize=ContrastBottomSliderSize[3],$
                                     minimum=ContrastBottomSliderMin,$
                                     maximum=ContrastBottomSliderMax,$
                                     uname='data_contrast_bottom_slider',$
                                     /tracking_events,$
                                     title=ContrastBottomSliderTitle,$
                                     value=ContrastBottomSliderDefaultValue)

ContrastNumberSlider = widget_slider(ContrastBase,$
                                     xoffset=ContrastNumberSliderSize[0],$
                                     yoffset=ContrastNumberSliderSize[1],$
                                     scr_xsize=ContrastNumberSliderSize[2],$
                                     scr_ysize=ContrastNumberSliderSize[3],$
                                     minimum=ContrastNumberSliderMin,$
                                     maximum=ContrastNumberSliderMax,$
                                     uname='data_contrast_number_slider',$
                                     /tracking_events,$
                                     title=ContrastNumberSliderTitle,$
                                     value=ContrastNumberSliderDefaultValue)

ResetContrastButton = widget_button(ContrastBase,$
                                    xoffset=ResetContrastButtonSize[0],$
                                    yoffset=ResetContrastButtonSize[1],$
                                    scr_xsize=ResetContrastButtonSize[2],$
                                    scr_ysize=ResetContrastButtonSize[3],$
                                    value=ResetContrastButtonTitle,$
                                    uname='data_reset_contrast_button')


;Tab #3 (rescale base)
RescaleBase = widget_base(BackPeakRescaleTab,$
                          uname='data_rescale_base',$
                          xoffset=RescaleBaseSize[0],$
                          yoffset=RescaleBaseSize[1],$
                          scr_xsize=RescaleBaseSize[2],$
                          scr_ysize=RescaleBaseSize[3],$
                          title=RescaleBaseTitle)

;X base
RescaleXLabel = widget_label(RescaleBase,$
                             xoffset=RescaleXLabelSize[0],$
                             yoffset=RescaleXLabelSize[1],$
                             value=RescaleXLabelTitle)

RescaleXBase = widget_base(RescaleBase,$
                           uname='data_rescale_x_base',$
                           xoffset=RescaleXBaseSize[0],$
                           yoffset=RescaleXBaseSize[1],$
                           scr_xsize=RescaleXBaseSize[2],$
                           scr_ysize=RescaleXBaseSize[3],$
                           frame=1)

RescaleXMincwfieldBase = widget_base(RescaleXBase,$
                                     xoffset=RescaleMincwfieldBaseSize[0],$
                                     yoffset=RescaleMincwfieldBaseSize[1],$
                                     scr_xsize=RescaleMincwfieldBaseSize[2],$
                                     scr_ysize=RescaleMincwfieldBaseSize[3])

RescaleXMinCWField = cw_field(RescaleXMincwfieldBase,$
                              xsize=RescaleMincwfieldSize[0],$
                              ysize=RescaleMincwFieldSize[1],$
                              row=1,$
                              /float,$
                              return_events=1,$
                              title=RescaleMincwfieldLabel,$
                              uname='data_rescale_xmin_cwfield')

RescaleXMaxcwfieldBase = widget_base(RescaleXBase,$
                                     xoffset=RescaleMaxcwfieldBaseSize[0],$
                                     yoffset=RescaleMaxcwfieldBaseSize[1],$
                                     scr_xsize=RescaleMaxcwfieldBaseSize[2],$
                                     scr_ysize=RescaleMaxcwfieldBaseSize[3])

RescaleXMaxCWField = cw_field(RescaleXMaxcwfieldBase,$
                              xsize=RescaleMaxcwfieldSize[0],$
                              ysize=RescaleMaxcwFieldSize[1],$
                              row=1,$
                              /float,$
                              return_events=1,$
                              title=RescaleMaxcwfieldLabel,$
                              uname='data_rescale_xmax_cwfield')

;RescaleXScaleDroplist = widget_droplist(RescaleXBase,$
;                                       value=RescaleScaleDroplist,$
;                                       xoffset=RescaleScaleDroplistSize[0],$
;                                       yoffset=RescaleScaleDroplistSize[1],$
;                                       uname='data_rescale_x_droplist')

ResetXScaleButton = widget_button(RescaleXBase,$
                                  xoffset=ResetScaleButtonSize[0],$
                                  yoffset=ResetScaleButtonSize[1],$
                                  scr_xsize=ResetScaleButtonSize[2],$
                                  scr_ysize=ResetScaleButtonSize[3],$
                                  value=ResetXScaleButtonTitle,$
                                  uname='data_reset_xaxis_button')

;Y base
RescaleYLabel = widget_label(RescaleBase,$
                             xoffset=RescaleYLabelSize[0],$
                             yoffset=RescaleYLabelSize[1],$
                             value=RescaleYLabelTitle)

RescaleYBase = widget_base(RescaleBase,$
                           uname='data_rescale_Y_base',$
                           xoffset=RescaleYBaseSize[0],$
                           yoffset=RescaleYBaseSize[1],$
                           scr_xsize=RescaleYBaseSize[2],$
                           scr_ysize=RescaleYBaseSize[3],$
                           frame=1)

RescaleYMincwfieldBase = widget_base(RescaleYBase,$
                                     xoffset=RescaleMincwfieldBaseSize[0],$
                                     yoffset=RescaleMincwfieldBaseSize[1],$
                                     scr_xsize=RescaleMincwfieldBaseSize[2],$
                                     scr_ysize=RescaleMincwfieldBaseSize[3])

RescaleYMinCWField = cw_field(RescaleYMincwfieldBase,$
                              xsize=RescaleMincwfieldSize[0],$
                              ysize=RescaleMincwFieldSize[1],$
                              row=1,$
                              /float,$
                              return_events=1,$
                              title=RescaleMincwfieldLabel,$
                              uname='data_rescale_ymin_cwfield')

RescaleYMaxcwfieldBase = widget_base(RescaleYBase,$
                                     xoffset=RescaleMaxcwfieldBaseSize[0],$
                                     yoffset=RescaleMaxcwfieldBaseSize[1],$
                                     scr_xsize=RescaleMaxcwfieldBaseSize[2],$
                                     scr_ysize=RescaleMaxcwfieldBaseSize[3])

RescaleYMaxCWField = cw_field(RescaleYMaxcwfieldBase,$
                              xsize=RescaleMaxcwfieldSize[0],$
                              ysize=RescaleMaxcwFieldSize[1],$
                              row=1,$
                              /float,$
                              return_events=1,$
                              title=RescaleMaxcwfieldLabel,$
                              uname='data_rescale_ymax_cwfield')

ResetYScaleButton = widget_button(RescaleYBase,$
                                  xoffset=ResetScaleButtonSize[0],$
                                  yoffset=ResetScaleButtonSize[1],$
                                  scr_xsize=ResetScaleButtonSize[2],$
                                  scr_ysize=ResetScaleButtonSize[3],$
                                  value=ResetYScaleButtonTitle,$
                                  uname='data_reset_yaxis_button')

;Z base
RescaleZLabel = widget_label(RescaleBase,$
                             xoffset=RescaleZLabelSize[0],$
                             yoffset=RescaleZLabelSize[1],$
                             value=RescaleZLabelTitle)

RescaleZBase = widget_base(RescaleBase,$
                           uname='data_rescale_Z_base',$
                           xoffset=RescaleZBaseSize[0],$
                           yoffset=RescaleZBaseSize[1],$
                           scr_xsize=RescaleZBaseSize[2],$
                           scr_ysize=RescaleZBaseSize[3],$
                           frame=1)

RescaleZMincwfieldBase = widget_base(RescaleZBase,$
                                     xoffset=RescaleMincwfieldBaseSize[0],$
                                     yoffset=RescaleMincwfieldBaseSize[1],$
                                     scr_xsize=RescaleMincwfieldBaseSize[2],$
                                     scr_ysize=RescaleMincwfieldBaseSize[3])

RescaleZMinCWField = cw_field(RescaleZMincwfieldBase,$
                              xsize=RescaleMincwfieldSize[0],$
                              ysize=RescaleMincwFieldSize[1],$
                              row=1,$
                              /float,$
                              return_events=1,$
                              title=RescaleMincwfieldLabel,$
                              uname='data_rescale_zmin_cwfield')

RescaleZMaxcwfieldBase = widget_base(RescaleZBase,$
                                     xoffset=RescaleMaxcwfieldBaseSize[0],$
                                     yoffset=RescaleMaxcwfieldBaseSize[1],$
                                     scr_xsize=RescaleMaxcwfieldBaseSize[2],$
                                     scr_ysize=RescaleMaxcwfieldBaseSize[3])

RescaleZMaxCWField = cw_field(RescaleZMaxcwfieldBase,$
                              xsize=RescaleMaxcwfieldSize[0],$
                              ysize=RescaleMaxcwFieldSize[1],$
                              row=1,$
                              /float,$
                              return_events=1,$
                              title=RescaleMaxcwfieldLabel,$
                              uname='data_rescale_zmax_cwfield')


RescaleZScaleDroplist = widget_droplist(RescaleZBase,$
                                        value=RescaleScaleDroplist,$
                                        xoffset=RescaleScaleDroplistSize[0],$
                                        yoffset=RescaleScaleDroplistSize[1],$
                                        uname='data_rescale_z_droplist')

ResetZScaleButton = widget_button(RescaleZBase,$
                                  xoffset=ResetScaleButtonSize[0],$
                                  yoffset=ResetScaleButtonSize[1],$
                                  scr_xsize=ResetScaleButtonSize[2],$
                                  scr_ysize=ResetScaleButtonSize[3],$
                                  value=ResetZScaleButtonTitle,$
                                  uname='data_reset_zaxis_button')

;full reset
FullResetButton = widget_button(RescaleBase,$
                                xoffset=FullResetButtonSize[0],$
                                yoffset=FullResetButtonSize[1],$
                                scr_xsize=FullResetButtonSize[2],$
                                scr_ysize=FullResetButtonSize[3],$
                                uname='data_full_reset_button',$
                                value=FullResetButtonTitle)

END

