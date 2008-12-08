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

PRO make_gui_scaling_step1, REDUCE_TAB, tab_size, TabTitles

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step4_step1_tab_base',$
             title: TabTitles.range_selection}
                         
;x/y and counts values --------------------------------------------------------
XYoff = [10,5]
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
            uname: 'x_value_scaling_step1'}
;Y value
XYoff = [100,0]
sYlabel = { size: [sXlabel.size[0]+XYoff[0],$
                   sXlabel.size[1]+XYoff[1],$
                   sXlabel.size[2]],$
            value: 'Y: ?',$
            uname: 'y_value_scaling_step1'}
;Counts value
XYoff = [100,0]
sCountsLabel = { size: [sYlabel.size[0]+XYoff[0],$
                        sYlabel.size[1]+XYoff[1],$
                        sYlabel.size[2]],$
                 value: 'Counts: ?',$
                 uname: 'counts_value_scaling_step1'}

;Lin/Log z-axis ---------------------------------------------------------------
XYoff = [-175,0]
sLinLog = { size: [sBaseTab.size[2]+XYoff[0],$
                   XYoff[1]],$
            list: ['Linear','Log'],$
            label: 'Z-axis:',$
            uname: 'z_axis_linear_log_scaling_step1',$
            value: 1.0}

XYOff = [43,50] ;Draw ---------------------------------------------------------
sDraw = { size: [XYoff[0],$
                 XYoff[1],$
                 tab_size[2]-125,$
                 304L*2],$
          scroll_size: [tab_size[2]-35-XYoff[0],$
                        304L*2+40],$
          uname: 'step4_step1_draw'}

XYoff = [0,-18] ;Scale of Draw ------------------------------------------------
sScale = { size: [XYoff[0],$
                  sDraw.size[1]+XYoff[1],$
                  tab_size[2]-80,$
                  sDraw.size[3]+57],$
           uname: 'scale_draw_step4_step1'}

XYoff = [5,0] ;Color Scale ----------------------------------------------------
sColorScale = { size: [sScale.size[0]+$
                       sScale.size[2]+XYoff[0],$
                       sScale.size[1]+XYoff[1],$
                       70,$
                       sScale.size[3]],$
                uname: 'scale_color_draw_step4_step1'}

;Selection Info ---------------------------------------------------------------
XYoff = [10,15]
sSelectionInfoBase = { size: [XYoff[0],$
                              sScale.size[1]+sScale.size[3]+XYoff[1],$
                              300,80],$
                       uname: 'step4_step1_selection_info_base',$
                       frame: 1}
XYoff = [20,-8]
sSelectionInfoTitle = { size: [sSelectionInfoBase.size[0]+XYoff[0],$
                               sSelectionInfoBase.size[1]+XYoff[1]],$
                        value: 'SELECTION INFO'}

;Xmin (label/value)
XYoff = [10,15]
sSelectionInfoXminLabel = { size: [XYoff[0],$
                                   XYoff[1]],$
                            value: 'Xmin'}
XYoff = [30,-6]
sSelectionInfoXminValue = { size: [sSelectionInfoXminLabel.size[0]+$
                                   XYoff[0],$
                                   sSelectionInfoXminLabel.size[1]+$
                                   XYoff[1],$
                                   10],$
                            value: '',$
                            uname: 'selection_info_xmin_value'}
;Xmax (label/value)
XYoff = [150,0]
sSelectionInfoXmaxLabel = { size: [XYoff[0],$
                                   sSelectionInfoXminLabel.size[1]+XYoff[1]],$
                            value: 'Xmax'}
XYoff = [30,0]
sSelectionInfoXmaxValue = { size: [sSelectionInfoXmaxLabel.size[0]+ $
                                   XYoff[0],$
                                   sSelectionInfoXminValue.size[1]+XYoff[1],$
                                   sSelectionInfoXminValue.size[2]],$
                            value: '',$
                            uname: 'selection_info_xmax_value'}
                                

;Ymin (label/value)
XYoff = [0,40]
sSelectionInfoYminLabel = { size: [sSelectionInfoXminLabel.size[0]+ $
                                   XYoff[0],$
                                   sSelectionInfoXminValue.size[1]+ $
                                   XYoff[1]],$
                            value: 'Ymin'}
XYoff = [0,-6]
sSelectionInfoYminValue = { size: [sSelectionInfoXminValue.size[0]+$
                                   XYoff[0],$
                                   sSelectionInfoYminLabel.size[1]+$
                                   XYoff[1],$
                                   3],$
                            value: '',$
                            uname: 'selection_info_ymin_value'}
;Ymax (label/value)
XYoff = [0,0]
sSelectionInfoYmaxLabel = { size: [sSelectionInfoXmaxLabel.size[0]+XYoff[0],$
                                   sSelectionInfoYminLabel.size[1]+XYoff[1]],$
                            value: 'Ymax'}
XYoff = [0,0]
sSelectionInfoYmaxValue = { size: [sSelectionInfoXmaxValue.size[0]+ $
                                   XYoff[0],$
                                   sSelectionInfoYminValue.size[1]+XYoff[1],$
                                   sSelectionInfoYminValue.size[2]],$
                            value: '',$
                            uname: 'selection_info_ymax_value'}

;Move Selection ---------------------------------------------------------------
XYoff = [15,0]
sSelectionMoveBase = { size: [sSelectionInfoBase.size[0]+$
                              sSelectionInfoBase.size[2]+$
                              XYoff[0],$
                              sSelectionInfoBase.size[1]+$
                              XYoff[1],$
                              165,$
                              135],$
                       uname: 'step4_step1_selection_move_base',$
                       frame: 1}
XYoff = [20,-8]
sSelectionMoveTitle = { size: [sSelectionMoveBase.size[0]+XYoff[0],$
                               sSelectionMoveBase.size[1]+XYoff[1]],$
                        value: 'MOVE SELECTION'}

;button left
XYoff = [10,40]
sSelectionMoveLeft = { size: [XYoff[0],$
                              XYoff[1]],$
                       value: 'REFoffSpec_images/move_selection_left.bmp',$
                       tooltip: 'Move the selection to the left',$
                       uname: 'step4_step1_move_selection_left'}

;Button up
XYoff = [50,8]
sSelectionMoveUp = { size: [XYoff[0],$
                            XYoff[1]],$
                     value: 'REFoffSpec_images/move_selection_up.bmp',$
                     tooltip: 'Move up the selection',$
                     uname: 'step4_step1_move_selection_up'}

;button right
XYoff = [115,0]
sSelectionMoveRight = { size: [XYoff[0],$
                               sSelectionMoveLeft.size[1]+XYoff[1]],$
                        value: 'REFoffSpec_images/move_selection_right.bmp',$
                        tooltip: 'Move the selection to the right',$
                        uname: 'step4_step1_move_selection_right'}

;Button down
XYoff = [0,95]
sSelectionMoveDown = { size: [sSelectionMoveUp.size[0]+XYoff[0],$
                              XYoff[1]],$
                       value: 'REFoffSpec_images/move_selection_down.bmp',$
                       tooltip: 'Move down the selection',$
                       uname: 'step4_step1_move_selection_down'}

;Step label/value
XYoff = [15,5]
sSelectionStepLabel = { size: [sSelectionMoveUp.size[0]+XYoff[0],$
                               sSelectionMoveLeft.size[1]+XYoff[1]],$
                        value: 'STEP'}
XYoff = [-6,18]
sSelectionStepValue = { size: [sSelectionStepLabel.size[0]+XYoff[0],$
                               sSelectionStepLabel.size[1]+XYoff[1],$
                               4],$
                        value: '10',$
                        uname: 'step4_step1_move_selection_step_value'}

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

;Selection Info ---------------------------------------------------------------

;title
wSelectionTitle = WIDGET_LABEL(BaseTab,$
                               XOFFSET = sSelectionInfoTitle.size[0],$
                               YOFFSET = sSelectionInfoTitle.size[1],$
                               VALUE   = sSelectionInfoTitle.value)

;Base
wSelectionInfoBase = WIDGET_BASE(BaseTab,$
                                 XOFFSET   = sSelectionInfoBase.size[0],$
                                 YOFFSET   = sSelectionInfoBase.size[1],$
                                 SCR_XSIZE = sSelectionInfoBase.size[2],$
                                 SCR_YSIZE = sSelectionInfoBase.size[3],$
                                 FRAME     = sSelectionInfoBase.frame,$
                                 UNAME     = sSelectionInfoBase.uname)

;Xmin (label/value)
wXminLabel = WIDGET_LABEL(wSelectionInfoBase,$
                          XOFFSET = sSelectionInfoXminLabel.size[0],$
                          YOFFSET = sSelectionInfoXminLabel.size[1],$
                          VALUE   = sSelectionInfoXminLabel.value)

wXminValue = WIDGET_TEXT(wSelectionInfoBase,$
                         XOFFSET = sSelectionInfoXminValue.size[0],$
                         YOFFSET = sSelectionInfoXminValue.size[1],$
                         XSIZE   = sSelectionInfoXminValue.size[2],$
                         UNAME   = sSelectionInfoXminValue.uname,$
                         VALUE   = sSelectionInfoXminValue.value,$
                         /EDITABLE,$
                         /ALIGN_LEFT)
                                 
;Xmax (label/value)
wXmaxLabel = WIDGET_LABEL(wSelectionInfoBase,$
                          XOFFSET = sSelectionInfoXmaxLabel.size[0],$
                          YOFFSET = sSelectionInfoXmaxLabel.size[1],$
                          VALUE   = sSelectionInfoXmaxLabel.value)

wXmaxValue = WIDGET_TEXT(wSelectionInfoBase,$
                         XOFFSET = sSelectionInfoXmaxValue.size[0],$
                         YOFFSET = sSelectionInfoXmaxValue.size[1],$
                         XSIZE   = sSelectionInfoXmaxValue.size[2],$
                         UNAME   = sSelectionInfoXmaxValue.uname,$
                         VALUE   = sSelectionInfoXmaxValue.value,$
                         /EDITABLE,$
                         /ALIGN_LEFT)

;Ymin (label/value)
wYminLabel = WIDGET_LABEL(wSelectionInfoBase,$
                          XOFFSET = sSelectionInfoYminLabel.size[0],$
                          YOFFSET = sSelectionInfoYminLabel.size[1],$
                          VALUE   = sSelectionInfoYminLabel.value)

wYminValue = WIDGET_TEXT(wSelectionInfoBase,$
                         XOFFSET = sSelectionInfoYminValue.size[0],$
                         YOFFSET = sSelectionInfoYminValue.size[1],$
                         XSIZE   = sSelectionInfoYminValue.size[2],$
                         UNAME   = sSelectionInfoYminValue.uname,$
                         VALUE   = sSelectionInfoYminValue.value,$
                         /EDITABLE,$
                         /ALIGN_LEFT)

;Ymax (label/value)
wYmaxLabel = WIDGET_LABEL(wSelectionInfoBase,$
                          XOFFSET = sSelectionInfoYmaxLabel.size[0],$
                          YOFFSET = sSelectionInfoYmaxLabel.size[1],$
                          VALUE   = sSelectionInfoYmaxLabel.value)

wYmaxValue = WIDGET_TEXT(wSelectionInfoBase,$
                         XOFFSET = sSelectionInfoYmaxValue.size[0],$
                         YOFFSET = sSelectionInfoYmaxValue.size[1],$
                         XSIZE   = sSelectionInfoYmaxValue.size[2],$
                         UNAME   = sSelectionInfoYmaxValue.uname,$
                         VALUE   = sSelectionInfoYmaxValue.value,$
                         /EDITABLE,$
                         /ALIGN_LEFT)

;Move Selection Info ----------------------------------------------------------

;title
wSelectionTitle = WIDGET_LABEL(BaseTab,$
                               XOFFSET = sSelectionMoveTitle.size[0],$
                               YOFFSET = sSelectionMoveTitle.size[1],$
                               VALUE   = sSelectionMoveTitle.value)

;Base
wSelectionMoveBase = WIDGET_BASE(BaseTab,$
                                 XOFFSET   = sSelectionMoveBase.size[0],$
                                 YOFFSET   = sSelectionMoveBase.size[1],$
                                 SCR_XSIZE = sSelectionMoveBase.size[2],$
                                 SCR_YSIZE = sSelectionMoveBase.size[3],$
                                 FRAME     = sSelectionMoveBase.frame,$
                                 UNAME     = sSelectionMoveBase.uname)

;move left
wSelectionMoveLeft = WIDGET_BUTTON(wSelectionMoveBase,$
                                   XOFFSET   = sSelectionMoveLeft.size[0],$
                                   YOFFSET   = sSelectionMoveLeft.size[1],$
                                   VALUE     = sSelectionMoveLeft.value,$
                                   UNAME     = sSelectionMoveLeft.uname,$
                                   TOOLTIP   = sSelectionMoveLeft.tooltip,$
                                   /BITMAP)

;move up
wSelectionMoveUp = WIDGET_BUTTON(wSelectionMoveBase,$
                                   XOFFSET   = sSelectionMoveUp.size[0],$
                                   YOFFSET   = sSelectionMoveUp.size[1],$
                                   VALUE     = sSelectionMoveUp.value,$
                                   UNAME     = sSelectionMoveUp.uname,$
                                   TOOLTIP   = sSelectionMoveUp.tooltip,$
                                   /BITMAP)

;move right
wSelectionMoveRight = WIDGET_BUTTON(wSelectionMoveBase,$
                                   XOFFSET   = sSelectionMoveRight.size[0],$
                                   YOFFSET   = sSelectionMoveRight.size[1],$
                                   VALUE     = sSelectionMoveRight.value,$
                                   UNAME     = sSelectionMoveRight.uname,$
                                   TOOLTIP   = sSelectionMoveRight.tooltip,$
                                   /BITMAP)

;move down
wSelectionMoveDown = WIDGET_BUTTON(wSelectionMoveBase,$
                                   XOFFSET   = sSelectionMoveDown.size[0],$
                                   YOFFSET   = sSelectionMoveDown.size[1],$
                                   VALUE     = sSelectionMoveDown.value,$
                                   UNAME     = sSelectionMoveDown.uname,$
                                   TOOLTIP   = sSelectionMoveDown.tooltip,$
                                   /BITMAP)

;Step Label/value
wSelectionStepLabel = WIDGET_LABEL(wSelectionMoveBase,$
                                   XOFFSET = sSelectionStepLabel.size[0],$
                                   YOFFSET = sSelectionStepLabel.size[1],$
                                   VALUE   = sSelectionStepLabel.value)

wSelectionStepValue = WIDGET_TEXT(wSelectionMoveBase,$
                                  XOFFSET = sSelectionStepValue.size[0],$
                                  YOFFSET = sSelectionStepValue.size[1],$
                                  XSIZE   = sSelectionStepValue.size[2],$
                                  VALUE   = sSelectionStepValue.value,$
                                  UNAME   = sSelectionStepValue.uname,$
                                  /EDITABLE,$
                                  /ALIGN_LEFT)


END
