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

PRO MakeGuiMainBaseComponents, MAIN_BASE, StepsTabSize

;Define position and size of widgets
yoff = 5
ResetAllButtonSize   = [StepsTabSize[0]-2,$
                        StepsTabSize[3]+yoff,$
                        177,$
                        30]
RefreshPlotSize      = [StepsTabSize[0]+ResetAllButtonSize[2],$
                        StepsTabSize[3]+yoff,$
                        ResetAllButtonSize[2],$
                        ResetAllButtonSize[3]]

PrintButtonSize      = [RefreshPlotSize[0] + RefreshPlotSize[2],$
                        ResetAllButtonSize[1],$
                        ResetAllButtonSize[2],$
                        ResetAllButtonsize[3]]

;--RESCALE 
yoff = 40
xoff = 5
RescaleBaseSize      = [StepsTabSize[0],$
                        StepsTabSize[3]+yoff,$
                        StepsTabSize[2]-xoff,$
                        80]
d12 = 50                        ;distance between 'x-axis:' and 'min:'
d23 = 35                        ;distance between 'min' and text field
d34 = 80                        ;distance between text field and 'max'
d45 = d23                       ;distance between 'max' and text field
d56 = 80                      ;distance between text field and lin/log
d67 = 95                 ;distance between lin/log and validate button
d78 = 70            ;distance between validate button and reset button
axis_lin_log = ['lin','log']
LabelSize    = [35,30]          ;scr_xsize and scr_ysize
TextBoxSize  = [70,30]          ;scr_xsize and scr_ysize
ResetButton  = [140,65]         ;scr_xsize and scr_ysize

;xaxis
XaxisLabelSize       = [5,$
                        5,$
                        LabelSize[0],$
                        LabelSize[1]]
XaxisMinLabelSize    = [XaxisLabelSize[0]+d12,$
                        XaxisLabelSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
XaxisMinTextFieldSize= [XaxisMinLabelSize[0]+d23,$
                        XaxisMinLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
XaxisMaxLabelSize    = [XaxisMinTextFieldSize[0]+d34,$
                        XaxisMinTextFieldSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
XaxisMaxTextFieldSize= [XaxisMaxLabelSize[0]+d45,$
                        XaxisMaxLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
XaxisLinLogSize      = [XaxisMaxTextFieldSize[0]+d56,$
                        XaxisMaxTextFieldSize[1]]
ResetButtonSize     = [XAxisLinLogsize[0]+d67,$
                       XAxisLinLogSize[1],$
                       ResetButton[0],$
                       ResetButton[1]]                                
;yaxis
yoff= 35
YaxisLabelSize       = [5,$
                        5+yoff,$
                        LabelSize[0],$
                        LabelSize[1]]
YaxisMinLabelSize    = [YaxisLabelSize[0]+d12,$
                        YaxisLabelSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
YaxisMinTextFieldSize= [YaxisMinLabelSize[0]+d23,$
                        YaxisMinLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
YaxisMaxLabelSize    = [YaxisMinTextFieldSize[0]+d34,$
                        YaxisMinTextFieldSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
YaxisMaxTextFieldSize= [YaxisMaxLabelSize[0]+d45,$
                        YaxisMaxLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
YaxisLinLogSize      = [YaxisMaxTextFieldSize[0]+d56,$
                        YaxisMaxTextFieldSize[1]]

;Define title variables
RefreshPlotButtonTitle = 'REFRESH PLOT'
printButtonTitle = 'CREATE OUTPUT FILE'

;------------------------------------------------------------------------------
;Settings Base
;------------------------------------------------------------------------------
XYoff = [660,525]
sSettingsBase = { size  : [XYoff[0],$
                           XYoff[1],$
                           StepsTabSize[2]-5,$
                           65],$
                  frame : 1,$
                  uname : 'settings_base',$
                  map   : 0}

;Settings Label ---------------------------------------------------------------
XYoff = [320,38]
sSettingsLabel = { size  : [XYoff[0],$
                            XYoff[1]],$
                   value : 'S   E   T   T   I   N   G   S ',$
                   frame : 2}

;Show Error Bars --------------------------------------------------------------
XYoff = [5,0]
sShowError = { size  : [XYoff[0],$
                        XYoff[1]],$
               title : 'Show Error Bars:',$
               uname : 'show_error_bar_group',$
               list  : ['Yes','No']}

;Data to display --------------------------------------------------------------
XYoff = [245,8]
sDataToDisplayLabel = { size  : [XYoff[0],$
                                sShowError.size[1]+XYoff[1]],$
                       value : 'Nbr of data to display (Step 3): '}
XYoff = [450,-8]
sDataToDisplayText = { size  : [XYoff[0],$
                                XYoff[1],$
                                50],$
                       value : STRCOMPRESS(100,/REMOVE_ALL),$
                       uname : 'nbrDataTextField' }

;Data to Remove ---------------------------------------------------------------
XYoff = [8,40]
sDataToRemoveLabel = { size  : [XYoff[0],$
                                XYoff[1]],$
                       value : 'Nbr of data to remove (Auto. Scaling): '}
XYoff = [248,-8]
sDataToRemoveText = { size  : [XYoff[0],$
                               sDataToRemoveLabel.size[1]+XYoff[1],$
                               50],$
                      value : STRCOMPRESS(1,/REMOVE_ALL),$
                      uname : 'min_crap_text_field'}
                      
;//////////////////////////////////////////////////////////////////////////////
;                               Build GUI
;//////////////////////////////////////////////////////////////////////////////

RESET_ALL_BUTTON = WIDGET_BUTTON(MAIN_BASE,$
                                 UNAME     = 'reset_all_button',$
                                 XOFFSET   = ResetAllButtonSize[0],$
                                 YOFFSET   = ResetAllButtonSize[1],$
                                 SCR_XSIZE = ResetAllButtonSize[2],$
                                 SCR_YSIZE = ResetAllButtonSize[3],$
                                 VALUE     = 'RESET FULL SESSION',$
                                 SENSITIVE = 0)

REFRESH_PLOT_BUTTON = WIDGET_BUTTON(MAIN_BASE,$
                                    UNAME     = 'refresh_plot_button',$
                                    XOFFSET   = RefreshPlotSize[0],$
                                    YOFFSET   = RefreshPlotSize[1],$
                                    SCR_XSIZE = RefreshPlotSize[2],$
                                    SCR_YSIZE = RefreshPlotSize[3],$
                                    VALUE     = RefreshPlotButtonTitle,$
                                    SENSITIVE = 0)

PRINT_BUTTON = WIDGET_BUTTON(MAIN_BASE,$
                             UNAME     = 'print_button',$
                             XOFFSET   = PrintButtonSize[0],$
                             YOFFSET   = PrintButtonSize[1],$
                             SCR_XSIZE = PrintButtonSize[2],$
                             SCR_YSIZE = PrintButtonSize[3],$
                             VALUE     = printButtonTitle,$
                             SENSITIVE = 0)

;--rescale base
RescaleBase = WIDGET_BASE(MAIN_BASE,$
                          UNAME     = 'RescaleBase',$
                          XOFFSET   = RescaleBaseSize[0],$
                          YOFFSET   = RescaleBaseSize[1],$
                          SCR_XSIZE = RescaleBaseSize[2],$
                          SCR_YSIZE = RescaleBaseSize[3],$
                          FRAME     = 1,$
                          MAP       = 0)

;xaxis
XaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET   = XaxisLabelSize[0],$
                          YOFFSET   = XaxisLabelSize[1],$
                          SCR_XSIZE = XaxisLabelSize[2],$
                          SCR_YSIZE = XaxisLabelSize[3],$
                          VALUE     = 'X-axis')

XaxisMinLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET   = XaxisMinLabelSize[0],$
                             YOFFSET   = XaxisMinLabelSize[1],$
                             SCR_XSIZE = XaxisMinLabelSize[2],$
                             SCR_YSIZE = XaxisMinLabelSize[3],$
                             VALUE     = 'min:')

XaxisMinTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME     = 'XaxisMinTextField',$
                                XOFFSET   = XaxisMinTextFieldSize[0],$
                                YOFFSET   = XaxisMinTextFieldSize[1],$
                                SCR_XSIZE = XaxisMinTextFieldSize[2],$
                                SCR_YSIZE = XaxisMinTextFieldSize[3],$
                                VALUE     = '',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)
            
XaxisMaxLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET   = XaxisMaxLabelSize[0],$
                             YOFFSET   = XaxisMaxLabelSize[1],$
                             SCR_XSIZE = XaxisMaxLabelSize[2],$
                             SCR_YSIZE = XaxisMaxLabelSize[3],$
                             VALUE     = 'max:')

XaxisMaxTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME     = 'XaxisMaxTextField',$
                                XOFFSET   = XaxisMaxTextFieldSize[0],$
                                YOFFSET   = XaxisMaxTextFieldSize[1],$
                                SCR_XSIZE = XaxisMaxTextFieldSize[2],$
                                SCR_YSIZE = XaxisMaxTextFieldSize[3],$
                                VALUE     = '',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)    

ResetButton = WIDGET_BUTTON(RescaleBase,$
                            XOFFSET   = ResetButtonSize[0],$
                            YOFFSET   = ResetButtonSize[1],$
                            SCR_XSIZE = ResetButtonSize[2],$
                            SCR_YSIZE = ResetButtonSize[3],$
                            UNAME     = 'ResetButton',$
                            VALUE     = 'Reset X/Y')

;yaxis
YaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET   = YaxisLabelSize[0],$
                          YOFFSET   = YaxisLabelSize[1],$
                          SCR_XSIZE = YaxisLabelSize[2],$
                          SCR_YSIZE = YaxisLabelSize[3],$
                          VALUE     = 'Y-axis')

YaxisMinLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET   = YaxisMinLabelSize[0],$
                             YOFFSET   = YaxisMinLabelSize[1],$
                             SCR_XSIZE = YaxisMinLabelSize[2],$
                             SCR_YSIZE = YaxisMinLabelSize[3],$
                             VALUE     = 'min:')

YaxisMinTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME     = 'YaxisMinTextField',$
                                XOFFSET   = YaxisMinTextFieldSize[0],$
                                YOFFSET   = YaxisMinTextFieldSize[1],$
                                SCR_XSIZE = YaxisMinTextFieldSize[2],$
                                SCR_YSIZE = YaxisMinTextFieldSize[3],$
                                VALUE     = '',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)
            
YaxisMaxLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET   = YaxisMaxLabelSize[0],$
                             YOFFSET   = YaxisMaxLabelSize[1],$
                             SCR_XSIZE = YaxisMaxLabelSize[2],$
                             SCR_YSIZE = YaxisMaxLabelSize[3],$
                             VALUE     = 'max:')

YaxisMaxTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME     = 'YaxisMaxTextField',$
                                XOFFSET   = YaxisMaxTextFieldSize[0],$
                                YOFFSET   = YaxisMaxTextFieldSize[1],$
                                SCR_XSIZE = YaxisMaxTextFieldSize[2],$
                                SCR_YSIZE = YaxisMaxTextFieldSize[3],$
                                VALUE     = '',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)                     

YaxisLinLog = CW_BGROUP(RescaleBase,$ 
                        axis_lin_log,$
                        XOFFSET   = YaxisLinLogSize[0],$
                        YOFFSET   = YaxisLinLogSize[1],$
                        SET_VALUE = 0.0,$
                        ROW       = 1,$
                        UNAME     = 'YaxisLinLog',$
                        /EXCLUSIVE,$
                        /RETURN_NAME)

;------------------------------------------------------------------------------
;Settings Base
;------------------------------------------------------------------------------
wSettingsBase = WIDGET_BASE(MAIN_BASE,$
                            UNAME     = sSettingsBase.uname,$
                            XOFFSET   = sSettingsBase.size[0],$
                            YOFFSET   = sSettingsBase.size[1],$
                            SCR_XSIZE = sSettingsBase.size[2],$
                            SCR_YSIZE = sSettingsBase.size[3],$
                            FRAME     = sSettingsBase.frame,$
                            MAP       = sSettingsBase.map)
                        
;Settings Label ---------------------------------------------------------------
wSettingsLabel = WIDGET_LABEL(wSettingsBase,$
                              XOFFSET = sSettingsLabel.size[0],$
                              YOFFSET = sSettingsLabel.size[1],$
                              VALUE   = sSettingsLabel.value,$
                              FRAME   = sSettingsLabel.frame)

;Show Error Bars --------------------------------------------------------------
wShowErrorBarGroup = CW_BGROUP(wSettingsBase,$
                               sShowError.list,$
                               XOFFSET    = sShowError.size[0],$
                               YOFFSET    = sShowError.size[1],$
                               SET_VALUE  = 0.0,$
                               ROW        = 1,$
                               UNAME      = sShowError.uname,$
                               LABEL_LEFT = sShowError.title,$
                               /EXCLUSIVE,$
                               /NO_RELEASE)

;Data to display --------------------------------------------------------------
wDataToDisplayLabel = WIDGET_LABEL(wSettingsBase,$
                                  XOFFSET = sDataToDisplayLabel.size[0],$
                                  YOFFSET = sDataToDisplayLabel.size[1],$
                                  VALUE   = sDataToDisplayLabel.value)
wDataToDisplayText = WIDGET_TEXT(wSettingsBase,$
                                UNAME     = sDataToDisplayText.uname,$
                                XOFFSET   = sDataToDisplayText.size[0],$
                                YOFFSET   = sDataToDisplayText.size[1],$
                                SCR_XSIZE = sDataToDisplayText.size[2],$
                                VALUE     = sDataToDisplayText.value,$
                                /EDITABLE,$
                                /ALIGN_LEFT)

;Data to Remove ---------------------------------------------------------------
wDataToRemoveLabel = WIDGET_LABEL(wSettingsBase,$
                                  XOFFSET = sDataToRemoveLabel.size[0],$
                                  YOFFSET = sDataToRemoveLabel.size[1],$
                                  VALUE   = sDataToRemoveLabel.value)
wDataToRemoveText = WIDGET_TEXT(wSettingsBase,$
                                UNAME     = sDataToRemoveText.uname,$
                                XOFFSET   = sDataToRemoveText.size[0],$
                                YOFFSET   = sDataToRemoveText.size[1],$
                                SCR_XSIZE = sDataToRemoveText.size[2],$
                                VALUE     = sDataToRemoveText.value,$
                                /EDITABLE,$
                                /ALIGN_LEFT)

END

;******************************************************************************
PRO make_gui_main_base_components
END
