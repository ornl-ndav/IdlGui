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

PRO make_gui_scaling_step2, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step4_step1_tab_base',$
             title: TabTitles.scaling}

;Main draw of step 4 ----------------------------------------------------------
XYoff = [5,5]
sStep4Draw = { size: [XYoff[0],$
                      XYOff[1],$
                      700,700],$
               uname: 'draw_step4_step2'}

;Zoom base (x-axis and y_axis) ------------------------------------------------
; Change code (RC Ward, April 5, 2010): Change location of this box
;XYoff = [30,25]
XYoff = [710,-92]
; Change code (RC Ward, April 5, 2010): Decrease width of this box
sZoomBase = { size: [sStep4Draw.size[0]+XYoff[0],$
                     sStep4Draw.size[1]+$
                     sStep4Draw.size[3]+XYoff[1],$
;                     650,90],$
                      545,90],$
              uname: 'step4_2_zoom_base',$
              frame: 3}

;x-axis -----------------------------------------------------------------------
XYoff= [10,15]
sXaxisLabel = { size: [XYoff[0],$
                       XYoff[1]],$
                value: 'X-axis'}
                       
;min and max (base and cw_fields) ---------------------------------------------
XYoff = [50,-10]
sXMinBaseField = { size: [sXaxisLabel.size[0]+XYoff[0],$
                          sXaxisLabel.size[1]+XYoff[1],$
                          135,$
                          13],$
                   label_left: 'Min:',$
                   value: '',$
                   uname: 'step4_2_zoom_x_min'}
                  
XYoff = [10,0]
sXMaxBaseField = { size: [sXMinBaseField.size[0]+$
                          sXMinBaseField.size[2]+XYoff[0],$
                          sXMinBaseField.size[1]+XYoff[1],$
                          sXMinBaseField.size[2:3]],$
                   label_left: 'Max:',$
                   value: '',$
                   uname: 'step4_2_zoom_x_max'}
                  
;RESET x axis -----------------------------------------------------------------
; Change code (RC Ward, April 5, 2010): Move position of RESET button
;XYoff = [315,5]
XYoff = [155,5]
sResetXaxis = { size: [sXMaxBaseField.size[0]+$
                       XYoff[0],$
                       sXMaxBaseField.size[1]+$
                       XYoff[1],$
                       100],$
                value: 'FULL RESET',$
                uname: 'step4_2_zoom_reset_axis'}
                
;y-axis -----------------------------------------------------------------------
XYoff= [0,40]
sYaxisLabel = { size: [sXaxisLabel.size[0]+XYoff[0],$
                       sXaxisLabel.size[1]+XYoff[1]],$
                value: 'Y-axis'}
                      
;min and max (base and cw_fields) ---------------------------------------------
XYoff = [0,-10]
sYMinBaseField = { size: [sXMinBaseField.size[0]+XYoff[0],$
                          sYaxisLabel.size[1]+XYoff[1],$
                          sXMinBaseField.size[2:3]],$
                   label_left: 'Min:',$
                   value: '',$
                   uname: 'step4_2_zoom_y_min'}
                 
XYoff = [0,0]
sYMaxBaseField = { size: [sXMaxBaseField.size[0]+XYoff[0],$
                          sYminBaseField.size[1]+XYoff[1],$
                          sXMaxBaseField.size[2:3]],$
                   label_left: 'Max:',$
                   value: '',$
                   uname: 'step4_2_zoom_y_max'}
                  
;X lin/log plot ---------------------------------------------------------------
XYoff = [0,0]
sLinLog = { size: [sYmaxBaseField.size[0]+$
                   sYmaxBaseField.size[2]+XYoff[0],$
                   sYmaxBaseField.size[1]+XYoff[1]],$
            list: ['Linear','Log'],$
            label: '',$
            uname: 'step4_step2_z_axis_linear_log',$
            value: 1.0}

;tab of step4/step2 -----------------------------------------------------------

; Change code (RC Ward, April 5, 2010): Shorten vertical size of the SMainTab
XYoff = [5,5]
sMainTab = { size: [sStep4Draw.size[0]+$
                    sSTep4Draw.size[2]+$
                    XYoff[0],$
                    XYoff[1],$
;                    555,800],$
                    555,600],$
             uname: 'step4_step2_tab'}

;TabTitles
  ; Code change RCW (Dec 30, 2009): get ScalingTabNames from XML config file (via ref_off_spec)
  ; and populate TabTitlesLocal

ScalingLevel3TabNames = (*global).ScalingLevel3TabNames
TabTitles =  { all_files:       ScalingLevel3TabNames[0],$
               critical_edge:   ScalingLevel3TabNames[1],$
               other_files:     ScalingLevel3TabNames[2]}

;TabTitles = { critical_edge: 'Critical Edge',$
;              other_files: 'Scaling of Other Files',$
;              all_files: 'All Files'}



;******************************************************************************
;            BUILD GUI
;******************************************************************************

BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab.uname,$
                      XOFFSET   = sBaseTab.size[0],$
                      YOFFSET   = sBaseTab.size[1],$
                      SCR_XSIZE = sBaseTab.size[2],$
                      SCR_YSIZE = sBaseTab.size[3],$
                      TITLE     = sBaseTab.title)

;Main Draw of Step4 -----------------------------------------------------------
; Code Change (RC Ward Mar 8, 2010): Add parameters RETAIN=2 to force IDL to deal with retaining the window.
; This should fix the problem of windows going "black".
wStep4Draw = WIDGET_DRAW(BaseTab,$
                         XOFFSET   = sStep4Draw.size[0],$
                         YOFFSET   = sStep4Draw.size[1],$
                         SCR_XSIZE = sStep4Draw.size[2],$
                         SCR_YSIZE = sStep4Draw.size[3],$
                         UNAMe     = sStep4Draw.uname,$
                         RETAIN    =2,$
                         /BUTTON_EVENTS,$
                         /MOTION_EVENTS)

;Zoom base --------------------------------------------------------------------
wZoomBase = WIDGET_BASE(BaseTab,$
                        XOFFSET   = sZoomBase.size[0],$
                        YOFFSET   = sZoomBase.size[1],$
                        SCR_XSIZE = sZoomBase.size[2],$
                        SCR_YSIZE = sZoomBase.size[3],$
                        UNAME     = sZoomBase.uname,$
                        FRAME     = sZoomBase.frame)

;X-axis -----------------------------------------------------------------------
wXaxisLabel = WIDGET_LABEL(wZoomBase,$
                           XOFFSET = sXaxisLabel.size[0],$
                           YOFFSET = sXaxisLabel.size[1],$
                           VALUE   = sXaxisLabel.value)

;Min base/value ---------------------------------------------------------------
wXminBase = WIDGET_BASE(wZoomBase,$
                        XOFFSET   = sXMinBaseField.size[0],$
                        YOFFSET   = sXMinBaseField.size[1],$
                        SCR_XSIZE = sXMinBaseField.size[2])

wXminValue = CW_FIELD(wXminBase,$
                      VALUE = sXMinBaseField.value,$
                      TITLE = sXMinBaseField.label_left,$
                      XSIZE = sXMinBaseField.size[3],$
                      UNAME = sXMinBaseField.uname,$
                      /FLOATING,$
                      /RETURN_EVENTS,$
                      /ROW)
                       
;Max base/value ---------------------------------------------------------------
wXmaxBase = WIDGET_BASE(wZoomBase,$
                        XOFFSET   = sXMaxBaseField.size[0],$
                        YOFFSET   = sXMaxBaseField.size[1],$
                        SCR_XSIZE = sXMaxBaseField.size[2])

wXmaxValue = CW_FIELD(wXmaxBase,$
                      VALUE = sXMaxBaseField.value,$
                      TITLE = sXMaxBaseField.label_left,$
                      XSIZE = sXMaxBaseField.size[3],$
                      UNAME = sXMaxBaseField.uname,$
                      /FLOATING,$
                      /RETURN_EVENTS,$
                      /ROW)

;RESET x axis -----------------------------------------------------------------
wResetXaxis = WIDGET_BUTTON(wZoomBase,$
                            XOFFSET   = sResetXaxis.size[0],$
                            YOFFSET   = sResetXaxis.size[1],$
                            SCR_XSIZE = sResetXaxis.size[2],$
                            VALUE     = sResetXaxis.value,$
                            UNAME     = sResetXaxis.uname)

;Y-axis -----------------------------------------------------------------------
wYaxisLabel = WIDGET_LABEL(wZoomBase,$
                           XOFFSET = sYaxisLabel.size[0],$
                           YOFFSET = sYaxisLabel.size[1],$
                           VALUE   = sYaxisLabel.value)

;Min base/value ---------------------------------------------------------------
wYminBase = WIDGET_BASE(wZoomBase,$
                        XOFFSET   = sYMinBaseField.size[0],$
                        YOFFSET   = sYMinBaseField.size[1],$
                        SCR_XSIZE = sYMinBaseField.size[2])

wYminValue = CW_FIELD(wYminBase,$
                      VALUE = sYMinBaseField.value,$
                      TITLE = sYMinBaseField.label_left,$
                      XSIZE = sYMinBaseField.size[3],$
                      UNAME = sYMinBaseField.uname,$
                      /FLOATING,$
                      /RETURN_EVENTS,$
                      /ROW)
                       
;Max base/value ---------------------------------------------------------------
wYmaxBase = WIDGET_BASE(wZoomBase,$
                        XOFFSET   = sYMaxBaseField.size[0],$
                        YOFFSET   = sYMaxBaseField.size[1],$
                        SCR_XSIZE = sYMaxBaseField.size[2])

wYmaxValue = CW_FIELD(wYmaxBase,$
                      VALUE = sYMaxBaseField.value,$
                      TITLE = sYMaxBaseField.label_left,$
                      UNAME = sYMaxBaseField.uname,$
                      XSIZE = sYMaxBaseField.size[3],$
                      /FLOATING,$
                      /RETURN_EVENTS,$
                      /ROW)
                       
;Linear / Logarithmic ---------------------------------------------------------
wLinLog = CW_BGROUP(wZoomBase,$
                    sLinLog.list,$
                    XOFFSET    = sLinLog.size[0],$
                    YOFFSET    = sLinLog.size[1],$
                    SET_VALUE  = sLinLog.value,$
                    UNAME      = sLinLog.uname,$
                    LABEL_LEFT = sLinLog.label,$
                    /EXCLUSIVE,$
                    /ROW,$
                    /NO_RELEASE)

;step4/step2 tab (ce and SF of all other files) -------------------------------
MAIN_TAB = WIDGET_TAB(BaseTab,$
                      UNAME = sMainTab.uname,$
                      LOCATION = 0,$
                      XOFFSET = sMainTab.size[0],$
                      YOFFSET = sMainTab.size[1],$
                      SCR_XSIZE = sMainTab.size[2],$
                      SCR_YSIZE = sMainTab.size[3],$
                      SENSITIVE = 1,$
                      /TRACKING_EVENTS)

;All Files
make_gui_scaling_step2_step1, MAIN_TAB, sMainTab.size, TabTitles

;Critical Edge
make_gui_scaling_step2_step2, MAIN_TAB, sMainTab.size, TabTitles

;Other Files
make_gui_scaling_step2_step3, MAIN_TAB, sMainTab.size, TabTitles


END
