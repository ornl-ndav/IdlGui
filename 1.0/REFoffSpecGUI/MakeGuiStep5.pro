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

PRO make_gui_step5, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step5_tab_base',$
             title: TabTitles.step5}
                         
;------------------------------------------------------------------------------
;Scaling and Shifting buttons/base --------------------------------------------
XYoff = [300,200]
sSSbase = { size: [XYoff[0],$
                   XYoff[1],$
                   300,60],$
            uname: 'shifting_scaling_base_step5',$
            frame: 3,$
            map: 1}

;shifting button --------------------------------------------------------------
sShiftingButton = { uname: 'step5_shifting_button',$
                    sensitive: 1,$
                    value: 'images/step5_shifting.bmp'}

;scaling button --------------------------------------------------------------
sScalingButton = { uname: 'step5_scaling_button',$
                    sensitive: 1,$
                    value: 'images/step5_scaling.bmp'}

;x/y and counts values --------------------------------------------------------
XYoff = [45,5]
sXYIFrame = { size: [XYoff[0],$
                     XYoff[1],$
                     350,$
                     20],$
              frame: 1}

XYoff = [50,8] ;X value
sXlabel = { size: [XYoff[0],$
                   XYOff[1],$
                   100],$
            value: 'X: ?',$
            uname: 'x_value_step5'}
;Y value
XYoff = [100,0]
sYlabel = { size: [sXlabel.size[0]+XYoff[0],$
                   sXlabel.size[1]+XYoff[1],$
                   sXlabel.size[2]],$
            value: 'Y: ?',$
            uname: 'y_value_step5'}
;Counts value
XYoff = [100,0]
sCountsLabel = { size: [sYlabel.size[0]+XYoff[0],$
                        sYlabel.size[1]+XYoff[1],$
                        sYlabel.size[2]],$
                 value: 'Counts: ?',$
                 uname: 'counts_value_step5'}

;More or Less axis ticks number ----------------------------------------------
XYoff = [550,5]
sXaxisTicksLabel = { size: [sCountsLabel.size[0]+XYoff[0],$
                            XYoff[1]],$
                     uname: 'x_axis_less_more_label_step5',$
                     value: 'Xaxis Ticks Nbr:'}
XYoff=[110,3]                    ;- ticks
sXaxisLessTicks = { size: [sXaxisTicksLabel.size[0]+XYoff[0],$
                           XYoff[1],$
                           60],$
                    value: ' <<< ',$
                    uname: 'x_axis_less_ticks_step5'}
XYoff=[5,0]                     ;+ ticks
sXaxisMoreTicks = { size: [sXaxisLessTicks.size[0]+$
                           sXaxisLessTicks.size[2]+XYoff[0],$
                           sXaxisLessTicks.size[1]+XYoff[1],$
                           sXaxisLessTicks.size[2]],$
                    value: ' >>> ',$
                    uname: 'x_axis_more_ticks_step5'}

;Lin/Log z-axis ---------------------------------------------------------------
XYoff = [-175,0]
sLinLog = { size: [sBaseTab.size[2]+XYoff[0],$
                   XYoff[1]],$
            list: ['Linear','Log'],$
            label: 'Z-axis:',$
            uname: 'z_axis_linear_log_step5',$
            value: 1.0}

XYOff = [43,50] ;Draw ---------------------------------------------------------
sDraw = { size: [XYoff[0],$
                 XYoff[1],$
                 tab_size[2]-125,$
                 304L*2],$
          scroll_size: [tab_size[2]-35-XYoff[0],$
                        304L*2+40],$
          uname: 'step5_draw'}

XYoff = [0,-18] ;Scale of Draw ------------------------------------------------
sScale = { size: [XYoff[0],$
                  sDraw.size[1]+XYoff[1],$
                  tab_size[2]-80,$
                  sDraw.size[3]+57],$
           uname: 'scale_draw_step5'}

XYoff = [5,0] ;Color Scale ----------------------------------------------------
sColorScale = { size: [sScale.size[0]+$
                       sScale.size[2]+XYoff[0],$
                       sScale.size[1]+XYoff[1],$
                       70,$
                       sScale.size[3]],$
                uname: 'scale_color_draw_step5'}

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

;------------------------------------------------------------------------------
;Scaling and Shifting buttons/base --------------------------------------------
wSSbase = WIDGET_BASE(BaseTab,$
                      XOFFSET   = sSSbase.size[0],$
                      YOFFSET   = sSSbase.size[1],$
                      SCR_XSIZE = sSSbase.size[2],$
                      SCR_YSIZE = sSSbase.size[3],$
                      UNAME     = sSSbase.uname,$
                      FRAME     = sSSbase.frame,$
                      /COLUMN)
                      
;Shifting button --------------------------------------------------------------
wShiftingButton = WIDGET_BUTTON(wSSbase,$
                                UNAME     = sShiftingButton.uname,$
                                VALUE     = sShiftingButton.value,$
                                SENSITIVE = sShiftingButton.sensitive)

;Scaling button --------------------------------------------------------------
wScalingButton = WIDGET_BUTTON(wSSbase,$
                               UNAME     = sScalingButton.uname,$
                                VALUE     = sScalingButton.value,$
                                SENSITIVE = sScalingButton.sensitive)

;x/y and counts values --------------------------------------------------------
wXLabel = WIDGET_LABEL(BaseTab,$
                       XOFFSET   = sXlabel.size[0],$
                       YOFFSET   = sXlabel.size[1],$
                       SCR_XSIZE = sXlabel.size[2],$
                       VALUE     = sXlabel.value,$
                       UNAME     = sXlabel.uname,$
                       /ALIGN_LEFT)
wXLabel = WIDGET_LABEL(BaseTab,$
                       XOFFSET   = sYLabel.size[0],$
                       YOFFSET   = sYLabel.size[1],$
                       SCR_XSIZE = sYLabel.size[2],$
                       VALUE     = sYLabel.value,$
                       UNAME     = sYLabel.uname,$
                       /ALIGN_LEFT)
wCountsLabel = WIDGET_LABEL(BaseTab,$
                       XOFFSET   = sCountsLabel.size[0],$
                       YOFFSET   = sCountsLabel.size[1],$
                       SCR_XSIZE = sCountsLabel.size[2],$
                       VALUE     = sCountsLabel.value,$
                       UNAME     = sCountsLabel.uname,$
                       /ALIGN_LEFT)

;X, Y, Intensity frame
wXYIFrame = WIDGET_LABEL(BaseTab,$
                         XOFFSET   = sXYIFrame.size[0],$
                         YOFFSET   = sXYIFrame.size[1],$
                         SCR_XSIZE = sXYIFrame.size[2],$
                         SCR_YSIZE = sXYIFrame.size[3],$
                         FRAME     = sXYIFrame.frame,$
                         VALUE     = '')

;More or Less number of ticks on the x-axis -----------------------------------
label = WIDGET_LABEL(BaseTab,$
                     XOFFSET = sXaxisTicksLabel.size[0],$
                     YOFFSET = sXaxisTicksLabel.size[1],$
                     UNAME   = sXaxisTicksLabel.uname,$
                     VALUE   = sXaxisTicksLabel.value)

less = WIDGET_BUTTON(BaseTab,$
                     XOFFSET   = sXaxisLessTicks.size[0],$
                     YOFFSET   = sXaxisLessTicks.size[1],$
                     SCR_XSIZE = sXaxisLessTicks.size[2],$
                     VALUE     = sXaxisLessTicks.value,$
                     UNAME     = sXaxisLessTicks.uname)

more = WIDGET_BUTTON(BaseTab,$
                     XOFFSET   = sXaxisMoreTicks.size[0],$
                     YOFFSET   = sXaxisMoreTicks.size[1],$
                     SCR_XSIZE = sXaxisMoreTicks.size[2],$
                     VALUE     = sXaxisMoreTicks.value,$
                     UNAME     = sXaxisMoreTicks.uname)

;Draw -------------------------------------------------------------------------
wDraw = WIDGET_DRAW(BaseTab,$
                    XOFFSET       = sDraw.size[0],$
                    YOFFSET       = sDraw.size[1],$
                    XSIZE         = sDraw.size[2],$
                    YSIZE         = sDraw.size[3],$
                    UNAME         = sDraw.uname,$
                    /BUTTON_EVENTS,$
                    /MOTION_EVENTS)

;Scale Draw -------------------------------------------------------------------
wScale = WIDGET_DRAW(BaseTab,$
                     XOFFSET       = sScale.size[0],$
                     YOFFSET       = sScale.size[1],$
                     SCR_XSIZE     = sScale.size[2],$
                     SCR_YSIZE     = sScale.size[3],$
                     UNAME         = sScale.uname)

;Color Scale Draw -------------------------------------------------------------
wColorScale = WIDGET_DRAW(BaseTab,$
                          XOFFSET   = sColorScale.size[0],$
                          YOFFSET   = sColorScale.size[1],$
                          SCR_XSIZE = sColorScale.size[2],$
                          SCR_YSIZE = sColorScale.size[3],$
                          UNAME     = sColorScale.uname)

;Linear / Logarithmic ---------------------------------------------------------
wLinLog = CW_BGROUP(BaseTab,$
                    sLinLog.list,$
                    XOFFSET    = sLinLog.size[0],$
                    YOFFSET    = sLinLog.size[1],$
                    SET_VALUE  = sLinLog.value,$
                    UNAME      = sLinLog.uname,$
                    LABEL_LEFT = sLinLog.label,$
                    /EXCLUSIVE,$
                    /ROW,$
                    /NO_RELEASE)

END
