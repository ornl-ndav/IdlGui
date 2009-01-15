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

;RECAP base
PRO make_gui_step5, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step5_tab_base',$
             title: TabTitles.step5}
                         
;------------------------------------------------------------------------------
;Shifting base ----------------------------------------------------------------
XYoff = [400,250]
sShiftBase = { size: [XYoff[0],$
                      XYoff[1],$
                      300,50],$
               uname: 'shifting_base_step5',$
               frame: 3,$
               map: 1}

;shifting button --------------------------------------------------------------
sShiftingDraw = { size: [0,0,300,50],$
                  uname: 'step5_shifting_draw'}

;Scaling base ----------------------------------------------------------------
XYoff = [0,70]
sScalebase = { size: [sShiftBase.size[0]+XYoff[0],$
                      sShiftBase.size[1]+$
                      sShiftBase.size[3]+XYoff[1],$
                      300,50],$
               uname: 'scaling_base_step5',$
               frame: 3,$
               map: 1}

;scaling button --------------------------------------------------------------
sScalingDraw = { size: [0,0,300,50],$
                 uname: 'step5_scaling_draw'}
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
XYoff = [20,5]
sXaxisTicksLabel = { size: [sXYIFrame.size[0]+$
                            sXYIFrame.size[2]+XYoff[0],$
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
XYoff = [750,0]
sLinLog = { size: [XYoff[0],$
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

XYoff = [-5,-30] ;z_max value -------------------------------------------------
sZmax = { size: [sColorScale.size[0]+XYoff[0],$
                 sColorScale.size[1]+XYoff[1],$
                 75],$
          uname: 'step5_zmax',$
          sensitive: 0,$
          value: ''}

XYoff = [-80,0] ;z_reset
sZreset = { size: [sZmax.size[0]+XYoff[0],$
                   sZmax.size[1]+XYoff[1],$
                   sZmax.size[2]],$
            uname: 'step5_z_reset',$
            sensitive: 0,$
            value: 'R E S E T'}

XYoff = [0,0]
sZmin = { size: [sZmax.size[0]+XYoff[0],$
                 sColorScale.size[1]+$
                 sColorScale.size[3]+$
                 XYoff[1],$
                 sZmax.size[2]],$
          uname: 'step5_zmin',$
          sensitive: 0,$
          value: ''}

;cw_bgroup of selection to make (none, counts vs Q .... etc) ------------------
XYoff = [10,10]
sSelectionGroupBase = { size: [sScale.size[0]+XYoff[0],$
                               sScale.size[1]+$
                               sScale.size[3]+$
                               XYoff[1],$
                               800,40],$
                        frame: 0,$
                        sensitive: 1,$
                        uname: 'step5_selection_group' }

sSelectionGroup = { value: [' None ',' Counts vs Q '],$
                    set_value: 0,$
                    label: 'Selection Type:  ',$
                    uname: 'step5_selection_group_uname' }

;counts vs Q base -------------------------------------------------------------
XYoff = [0,5]
sIvsQbase = { size: [sSelectionGroupBase.size[0]+XYoff[0],$
                     sSelectionGroupBase.size[1]+$
                     sSelectionGroupBase.size[3]+$
                     XYoff[1],$
                     1250,60],$
              frame: 0,$
              uname: 'step5_counts_vs_q_base_uname',$
              map: 0}

XYoff = [10,10] ;inside frame
sInsideFrame = { size: [XYoff[0],$
                        XYoff[1],$
                        sIvsQbase.size[2]-2*XYoff[0],$
                        sIvsQbase.size[3]-2*XYoff[1]],$
                 frame: 1}
           
XYoff = [15,-8] ;title
sTitle = { size: [sInsideFrame.size[0]+XYoff[0],$
                  sInsideFrame.size[1]+XYoff[1]],$
           value: 'Selection: I vs Q'}

XYoff = [5,8] ;folder button
sFolderButton = { size: [XYoff[0],$
                         XYoff[1],$
                         550,30],$
                  uname: 'step5_browse_button_i_vs_q',$
                  value: (*global).working_path }

XYoff = [0,0] ;file name text field
sFileName = { size: [sFolderButton.size[0]+$
                     sFolderButton.size[2]+$
                     XYoff[0],$
                     sFolderButton.size[1]+$
                     XYoff[1],$
                     400],$
              uname: 'step5_file_name_i_vs_q',$
              value: '' }

XYoff = [0,0] ;create button
sCreateButton = { size: [sFileName.size[0]+$
                         sFileName.size[2]+$
                         XYoff[0],$
                         sFileName.size[1]+$
                         XYoff[0],$
                         140,$
                         sFolderButton.size[3]],$
                  uname: 'step5_create_button_i_vs_q',$
                  value: 'CREATE ASCII FILE',$
                  sensitive: 0}
                        
XYoff = [0,0] ;preview button
sPreviewButton = { size: [sCreateButton.size[0]+$
                          sCreateButton.size[2]+$
                          XYoff[0],$
                          sCreateButton.size[1]+$
                          XYoff[1],$
                          130,$
                          sCreateButton.size[3]],$
                   value: 'PREVIEW',$
                   uname: 'preview_button_i_vs_q',$
                   sensitive: 0}

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
;Scaling base -----------------------------------------------------------------
wShiftbase = WIDGET_BASE(BaseTab,$
                         XOFFSET   = sShiftBase.size[0],$
                         YOFFSET   = sShiftBase.size[1],$
                         SCR_XSIZE = sShiftBase.size[2],$
                         SCR_YSIZE = sShiftBase.size[3],$
                         UNAME     = sShiftBase.uname,$
                         FRAME     = sShiftBase.frame)

;Shifting button --------------------------------------------------------------
wShiftingDraw = WIDGET_DRAW(wShiftBase,$
                            XOFFSET   = sShiftingDraw.size[0],$
                            YOFFSET   = sShiftingDraw.size[1],$
                            SCR_XSIZE = sShiftingDraw.size[2],$
                            SCR_YSIZE = sShiftingDraw.size[3],$
                            UNAME     = sShiftingDraw.uname)

;Shifting base ----------------------------------------------------------------
wScalebase = WIDGET_BASE(BaseTab,$
                      XOFFSET   = sScaleBase.size[0],$
                      YOFFSET   = sScaleBase.size[1],$
                      SCR_XSIZE = sScaleBase.size[2],$
                      SCR_YSIZE = sScaleBase.size[3],$
                      UNAME     = sScaleBase.uname,$
                      FRAME     = sScaleBase.frame)

;Scaling button --------------------------------------------------------------
wScalingDraw = WIDGET_DRAW(wScalebase,$
                           XOFFSET   = sScalingDraw.size[0],$
                           YOFFSET   = sScalingDraw.size[1],$
                           SCR_XSIZE = sScalingDraw.size[2],$
                           SCR_YSIZE = sScalingDraw.size[3],$
                           UNAME     = sScalingDraw.uname)

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

;Z range widgets --------------------------------------------------------------
wZreset = WIDGET_BUTTON(BaseTab,$
                        XOFFSET   = sZreset.size[0],$
                        YOFFSET   = sZreset.size[1],$
                        SCR_XSIZE = sZreset.size[2],$
                        VALUE     = sZreset.value,$
                        SENSITIVE = sZreset.sensitive,$
                        UNAME     = sZreset.uname)

wZmax = WIDGET_TEXT(BaseTab,$
                    XOFFSET   = sZmax.size[0],$
                    YOFFSET   = sZmax.size[1],$
                    SCR_XSIZE = sZmax.size[2],$
                    UNAME     = sZmax.uname,$
                    SENSITIVE = sZmax.sensitive,$
                    VALUE     = sZmax.value,$
                    /EDITABLE,$
                    /ALIGN_LEFT)

wZmin = WIDGET_TEXT(BaseTab,$
                    XOFFSET   = sZmin.size[0],$
                    YOFFSET   = sZmin.size[1],$
                    SCR_XSIZE = sZmin.size[2],$
                    UNAME     = sZmin.uname,$
                    VALUE     = sZmin.value,$
                    SENSITIVE = sZmin.sensitive,$
                    /EDITABLE,$
                    /ALIGN_LEFT)

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

;cw_bgroup of selection to make (none, counts vs Q .... etc) ------------------
wSelectionGroupBase = WIDGET_BASE(BaseTab,$
                                  XOFFSET   = sSelectionGroupBase.size[0],$
                                  YOFFSET   = sSelectionGroupBase.size[1],$
                                  SCR_XSIZE = sSelectionGroupBase.size[2],$
                                  SCR_YSIZE = sSelectionGroupBase.size[3],$
                                  UNAME     = sSelectionGroupBase.uname,$
                                  FRAME     = sSelectionGroupBase.frame,$
                                  SENSITIVE = sSelectionGroupBase.sensitive,$
                                  /ROW)

wSelectionGroup = CW_BGROUP(wSelectionGroupBase,$
                            sSelectionGroup.value,$
                            LABEL_LEFT = sSelectionGroup.label,$
                            UNAME      = sSelectionGroup.uname,$
                            /EXCLUSIVE,$
                            SET_VALUE = 0,$
                            /NO_RELEASE,$
                            /ROW)

;counts vs Q base -------------------------------------------------------------
wQbase = WIDGET_BASE(BaseTab,$
                     XOFFSET   = sIvsQbase.size[0],$
                     YOFFSET   = sIvsQbase.size[1],$
                     SCR_XSIZE = sIvsQbase.size[2],$
                     SCR_YSIZE = sIvsQbase.size[3],$
                     UNAME     = sIvsQbase.uname,$
                     MAP       = sIvsQbase.map,$
                     FRAME     = sIvsQbase.frame)
                     
;title
wTitle = WIDGET_LABEL(wQbase,$
                      XOFFSET = sTitle.size[0],$
                      YOFFSET = sTitle.size[1],$
                      VALUE   = sTitle.value)

;inside frame
wInsideBase = WIDGET_BASE(wQbase,$
                          XOFFSET   = sInsideFrame.size[0],$
                          YOFFSET   = sInsideFrame.size[1],$
                          SCR_XSIZE = sInsideFrame.size[2],$
                          SCR_YSIZE = sInsideFrame.size[3],$
                          FRAME     = sInsideFrame.frame)                     
;folder button
button = WIDGET_BUTTON(wInsideBase,$
                       VALUE     = sFolderButton.value,$
                       XOFFSET   = sFolderButton.size[0],$
                       YOFFSET   = sFolderButton.size[1],$
                       SCR_XSIZE = sFolderButton.size[2],$
                       SCR_YSIZE = sFolderButton.size[3],$
                       UNAME     = sFolderButton.uname)
                       
;file name
text = WIDGET_TEXT(wInsideBase,$
                   XOFFSET = sFileName.size[0],$
                   YOFFSET = sFileName.size[1],$
                   SCR_XSIZE = sFileName.size[2],$
                   VALUE     = sFileName.value,$
                   UNAME     = sFileName.uname,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

;create button
button = WIDGET_BUTTON(wInsideBase,$
                       XOFFSET   = sCreateButton.size[0],$
                       YOFFSET   = sCreateButton.size[1],$
                       SCR_XSIZE = sCreateButton.size[2],$
                       SCR_YSIZE = sCreateButton.size[3],$
                       VALUE     = sCreateButton.value,$
                       SENSITIVE = sCreateButton.sensitive,$
                       UNAME     = sCreateButton.uname)

;preview button
button = WIDGET_BUTTON(wInsideBase,$
                       XOFFSET   = sPreviewButton.size[0],$
                       YOFFSET   = sPreviewButton.size[1],$
                       SCR_XSIZE = sPreviewButton.size[2],$
                       SCR_YSIZE = sPreviewButton.size[3],$
                       VALUE     = sPreviewButton.value,$
                       SENSITIVE = sPreviewButton.sensitive,$
                       UNAME     = sPreviewButton.uname)

END
