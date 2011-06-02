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

PRO make_gui_step3, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step3_tab_base',$
             title: TabTitles.step3}

;x/y and counts values --------------------------------------------------------
XYoff = [5,5]
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
            uname: 'x_value_shifting'}
;Y value
XYoff = [100,0]
sYlabel = { size: [sXlabel.size[0]+XYoff[0],$
                   sXlabel.size[1]+XYoff[1],$
                   sXlabel.size[2]],$
            value: 'Y: ?',$
            uname: 'y_value_shifting'}
;Counts value
XYoff = [100,0]
sCountsLabel = { size: [sYlabel.size[0]+XYoff[0],$
                        sYlabel.size[1]+XYoff[1],$
                        sYlabel.size[2]],$
                 value: 'Counts: ?',$
                 uname: 'counts_value_shifting'}

;Selection or 2D plot modes ---------------------------------------------------
XYoff = [30,5]
sModeLabel = { size: [sXYIFrame.size[0]+$
                      sXYIFrame.size[2]+XYoff[0],$
                      XYoff[1]],$
               uname: 'selection_mode_base_label',$
               value: 'Mouse Mode:'}

XYoff = [70,0]
sMode = { size: [sModeLabel.size[0]+$
                 XYoff[0],$
                 XYoff[1],$
                 150,25],$
          uname: 'selection_mode_base'}

XYoff = [50,0]
sSelectionMode = { uname: 'selection_mode',$
                   value: 'REFoffSpec_images/selection_mode.bmp',$
                   tooltip: 'Reference Pixel Selection Mode'}
XYoff = [50,0]
s2DplotMode = { uname: 'two_d_selection_plot_mode',$
                value: 'REFoffSpec_images/twoD_selection_mode.bmp',$
                tooltip: '2D Plot Selection Mode'}
                         
;More or Less axis ticks number ----------------------------------------------
XYoff = [360,5]
sXaxisTicksLabel = { size: [sCountsLabel.size[0]+XYoff[0],$
                            XYoff[1]],$
                     uname: 'x_axis_less_more_label',$
                     value: 'Xaxis Ticks Nbr:'}
XYoff=[110,3]                    ;- ticks
sXaxisLessTicks = { size: [sXaxisTicksLabel.size[0]+XYoff[0],$
                           XYoff[1],$
                           60],$
                    value: ' <<< ',$
                    uname: 'x_axis_less_ticks_shifting'}
XYoff=[5,0]                     ;+ ticks
sXaxisMoreTicks = { size: [sXaxisLessTicks.size[0]+$
                           sXaxisLessTicks.size[2]+XYoff[0],$
                           sXaxisLessTicks.size[1]+XYoff[1],$
                           sXaxisLessTicks.size[2]],$
                    value: ' >>> ',$
                    uname: 'x_axis_more_ticks_shifting'}

;Lin/Log z-axis ---------------------------------------------------------------
XYoff = [-395,0]
sLinLog = { size: [sBaseTab.size[2]+XYoff[0],$
                   XYoff[1]],$
            list: ['Linear','Log'],$
            label: 'Z-axis:',$
            uname: 'z_axis_linear_log_shifting',$
            value: 1.0}

XYOff = [43,50] ;Draw ---------------------------------------------------------
sDraw = { size: [XYoff[0],$
                 XYoff[1],$
                 tab_size[2]-125,$
; Change made: Replace 304 with detector_pixels_y obtained from XML fole (RCW, Feb 10, 2010)
                 (*global).detector_pixels_y*2],$
;                 304L*2],$
          scroll_size: [tab_size[2]-35-XYoff[0],$
; Change made: Replace 304 with detector_pixels_y obtained from XML fole (RCW, Feb 10, 2010)
                 (*global).detector_pixels_y*2+40],$
;                 304L*2+40],$
          uname: 'step3_draw'}

XYoff = [0,-18] ;Scale of Draw ------------------------------------------------
sScale = { size: [XYoff[0],$
                  sDraw.size[1]+XYoff[1],$
                  tab_size[2]-80,$
                  sDraw.size[3]+57],$
           uname: 'scale_draw_step3'}

XYoff = [5,0] ;Color Scale ----------------------------------------------------
sColorScale = { size: [sScale.size[0]+$
                       sScale.size[2]+XYoff[0],$
                       sScale.size[1]+XYoff[1],$
                       70,$
                       sScale.size[3]],$
                uname: 'scale_color_draw_step3'}

XYoff = [-5,-30] ;z_max value -------------------------------------------------
sZmax = { size: [sColorScale.size[0]+XYoff[0],$
                 sColorScale.size[1]+XYoff[1],$
                 75],$
          uname: 'step3_zmax',$
          sensitive: 0,$
          value: ''}

XYoff = [-80,0] ;z_reset
sZreset = { size: [sZmax.size[0]+XYoff[0],$
                   sZmax.size[1]+XYoff[1],$
                   sZmax.size[2]],$
            uname: 'step3_z_reset',$
            sensitive: 0,$
            value: 'R E S E T'}

XYoff = [0,0]
sZmin = { size: [sZmax.size[0]+XYoff[0],$
                 sColorScale.size[1]+$
                 sColorScale.size[3]+$
                 XYoff[1],$
                 sZmax.size[2]],$
          uname: 'step3_zmin',$
          sensitive: 0,$
          value: ''}

;Reference and active File Base -----------------------------------------------
XYoff = [5,5]
sRefBase = { size: [XYoff[0],$
                    sScale.size[1]+$
                    sScale.size[3]+$
                    XYoff[1],$
                    1180,$
                    42],$
             uname: 'reference_base_shifting',$
             sensitive: 0,$
             frame: 1}
main_yoff = 5
XYoff = [0,5]
sRefLabelHelp = { size: [XYoff[0],$
                         XYOff[1],$
                         15],$
                  value: '?',$
                  uname: 'reference_file_name_shifting_help'}

XYoff = [20,8+main_yoff]
sRefLabel = { size: [sRefLabelHelp.size[0]+XYoff[0],$
                     XYoff[1]],$
              value: 'Reference File :'}

XYoff = [105,0]
sRefFileName = { size: [sRefLabel.size[0]+XYoff[0],$
                        sRefLabel.size[1]+XYoff[1],$
                        200],$
                 value: 'N/A',$
                 uname: 'reference_file_name_shifting'}

XYoff = [0,5] ;help of ACTIVE FILE
sActiveDroplistHelp = { size: [sRefFileName.size[0]+$
                               sRefFileName.size[2]+XYoff[0],$
                               sRefLabelHelp.size[1],$
                               sRefLabelHelp.size[2]],$
                        value: '?',$
                        uname: 'active_file_droplist_shifting_help'}

XYoff = [5,0]
sActiveLabel = { size: [sActiveDroplistHelp.size[0]+$
                        sActiveDroplistHelp.size[2]+XYoff[0],$
                        sRefFileName.size[1]+XYoff[1]],$
                 value: 'Active File :'}
XYoff = [80,3]
sActiveDroplist = { size: [sActiveLabel.size[0]+XYoff[0],$
                           XYoff[1]],$
                    value: ['N/A                                         '],$
                    uname: 'active_file_droplist_shifting'}

; CHANGES MADE HERE 6 JAN 2011 TO ALLOW LARGER TEXT BOX FOR RefPix
;XYoff = [350,0]
XYoff = [280,0]
sRefPixelLabel = { size: [sActiveDroplist.size[0]+$
                          XYoff[0],$
                          sRefLabel.size[1]+$
                          XYoff[1]],$
                   value: 'Reference Pixel:'}
XYoff = [sRefPixelLabel.size[0] - 20,$
         sRefLabelHelp.size[1] + 2] ;help for REFERENCE PIXEL
sRefPixelHelp = { size: [XYoff[0],$
                         XYOff[1],$
                         sRefLabelHelp.size[2]],$
                  value: '?',$
                  uname: 'reference_pixel_help'}

XYoff = [100,-8]
sRefPixelValue = { size: [sRefPixelLabel.size[0]+$
                          XYoff[0],$
                          sRefPixelLabel.size[1]+$
                          XYoff[1],$
                          65],$
                   value: '',$
                   uname: 'reference_pixel_value_shifting'}
XYoff = [20,0]
sPixelDwButton = { size: [sRefPixelValue.size[0]+$
                          sRefPixelValue.size[2]+$
                          XYoff[0],$
                          XYoff[1]],$
                   uname: 'pixel_down_selection_shifting',$
                   tooltip: 'To decrease reference pixel by x pixel',$
                   value: 'REFoffSpec_images/reference_down.bmp'}

XYOff = [42,0] ;Help on down and up buttons
sPixelDwUpHelp = { size: [sPixelDwButton.size[0]+$
                          XYoff[0],$
                          sRefPixelHelp.size[1]+XYoff[1],$
                          sRefPixelHelp.size[2]],$
                   value: '?',$
                   uname: 'pixel_down_up_help'}

XYoff = [57,0]
sPixelUpButton = { size: [sPixelDwButton.size[0]+$
                          XYoff[0],$
                          sPixelDwButton.size[1]+$
                          XYoff[1]],$
                   tooltip: 'To increase reference pixel by x pixel',$
                   uname: 'pixel_up_selection_shifting',$
                   value: 'REFoffSpec_images/reference_up.bmp'}
                         
XYoff = [50,0]
sMoveByLabel = { size: [sPixelUpButton.size[0]+$
                        XYoff[0],$
                        sRefPixelLabel.size[1]+$
                        XYoff[1]],$
                 value: 'Move by      pixel(s)'}
XYoff = [48,0]
sMoveByValue = { size: [sMoveByLabel.size[0]+$
                        XYoff[0],$
                        sRefPixelValue.size[1]+$
                        XYoff[1],$
                        30],$
                 uname: 'move_by_x_pixel_value_shifting',$
                 value: '1'}
                         
;Help text field
XYoff = [0,20]
sHelpBase = { size: [sRefBase.size[0]+XYOff[0],$
                     sRefBase.size[1]+$
                     sRefBase.size[3]+XYoff[1],$
                     500,100],$
              frame: 1,$
              uname: 'help_base_shifting'}

XYoff = [15,-8]
sHelpLabel = { size: [sHelpBase.size[0]+XYoff[0],$
                      sHelpBase.size[1]+XYoff[1]],$
               value: 'H E L P'}
XYoff = [5,7]
sHelpTextField = { size: [XYOff[0],$
                          XYoff[1],$
                          sHelpBase.size[2]-2*XYoff[0],$
                          sHelpBase.size[3]-2*XYoff[1]],$
                   value: '',$
                   uname: 'help_text_field_shifting'}

;Auto base mode ---------------------------------------------------------------
XYOff = [10,0]
sAutoMode = { size: [sHelpBase.size[0]+$
                     sHelpBase.size[2]+$
                     XYoff[0],$
                     sHelpBase.size[1]+$
                     XYoff[1],$
                     163,100],$
              uname: 'auto_shifting_mode',$
              frame: 1,$
              sensitive: 0}

;Automatic mode label ---------------------------------------------------------
XYoff = [15,-8]
sAutoModeLabel = { size: [sAutoMode.size[0]+$
                           XYoff[0],$
                           sAutoMode.size[1]+$
                           XYoff[1]],$
                   value: 'Automatic Mode'}

;Realign Data button ----------------------------------------------------------
XYoff = [0,10]
sRealignButton = { size: [XYoff[0],$
                          XYoff[1]],$
                   uname: 'realign_data_button',$
                   value: 'REFoffSpec_images/realign_data.bmp',$
                   tooltip: 'Realign all the data according to the' + $
                   ' refrence pixels defined',$
                   sensitive: 1}

;Cancel Realign Data button ---------------------------------------------------
XYoff = [0,45]
sCancelRealignButton = { size: [sRealignButton.size[0]+$
                                XYoff[0],$
                                sRealignButton.size[1]+$
                                XYoff[1]],$
                         uname: 'cancel_realign_data_button',$
                         value: 'REFoffSpec_images/cancel_realign_data.bmp',$
                         tooltip: 'Cancel the realign process',$
                         sensitive: 1}

;Manual Mode ------------------------------------------------------------------
XYoff = [10,0]
sManualModeBase = { size: [sAutoMode.size[0]+$
                           sAutoMode.size[2]+$
                           XYoff[0],$
                           sAutoMode.size[1]+$
                           XYoff[1],$
                           250,$
                           sAutoMode.size[3]],$
                    uname: 'manual_shifting_mode_base',$
                    frame: 1,$
                    sensitive: 0}

;Manual Mode Label ------------------------------------------------------------
XYoff = [15,-8]
sManualModeLabel = { size: [sManualModeBase.size[0]+XYoff[0],$
                            sManualModeBase.size[1]+XYoff[1]],$
                     value: 'Manual Mode'}
                            

;Current working file label and value
XYoff = [5,15]
sManualModeFileLabel = { size: [XYoff[0],$
                                XYoff[1]],$
                         value: '-> '}
XYoff = [25,0]
sManualModeFileValue = { size: [XYoff[0],$
                                sManualModeFileLabel.size[1]+XYoff[1],$
                                300],$
                         value: 'N/A                                     ',$
                         uname: 'manual_mode_file_value_shifting'}

;Buttons Up and Down
XYoff = [5,30]
sManualDownButton = { size: [XYoff[0],$
                             sManualModeFileValue.size[1]+XYoff[1]],$
                      tooltip: 'To move down the active file by x pixel',$
                      uname: 'data_down_shifting',$
                      value: 'REFoffSpec_images/selection_down.bmp'}


XYoff = [50,0]
sManualUpButton = { size: [sManualDownButton.size[0]+XYoff[0],$
                           sManualDownButton.size[1]+XYoff[1]],$
                    tooltip: 'To move up the active file by x pixel',$
                    uname: 'data_up_shifting',$
                    value: 'REFoffSpec_images/selection_up.bmp'}

XYoff = [50,12]
sMoveByManualLabel = { size: [sManualUpButton.size[0]+$
                              XYoff[0],$
                              sManualUpButton.size[1]+$
                              XYoff[1]],$
                       value: 'Move by      pixel(s)'}
XYoff = [48,-7]
sMoveByManualValue = { size: [sMoveByManualLabel.size[0]+$
                              XYoff[0],$
                              sMoveByManualLabel.size[1]+$
                              XYoff[1],$
                              30],$
                       uname: 'move_by_x_pixel_value_manual_shifting',$
                       value: '1'}
                         
;******************************************************************************
;            BUILD GUI
;******************************************************************************
; Code Change (RC Ward, Mar 31, 2010): Add SCROLL capability to the WIDGET_BASE BaseTab
BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab.uname,$
                      XOFFSET   = sBaseTab.size[0],$
                      YOFFSET   = sBaseTab.size[1],$
                      SCR_XSIZE = sBaseTab.size[2],$
                      SCR_YSIZE = sBaseTab.size[3],$
                      TITLE     = sBaseTab.title, $
                      /SCROLL)

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

;Selection or 2D plot modes ---------------------------------------------------
wMode = WIDGET_BASE(BaseTab,$
                    SPACE   = 15,$
                    UNAME   = sMode.uname,$
                    XOFFSET = sMode.size[0],$
                    YOFFSET = sMode.size[1],$
                    SCR_XSIZE = sMode.size[2],$
                    /EXCLUSIVE,$
                    /ROW)

wLabel = WIDGET_LABEL(BaseTab,$
                      XOFFSET = sModeLabel.size[0],$
                      YOFFSET = sModeLabel.size[1],$
                      UNAME   = sModeLabel.uname,$
                      VALUE   = sModeLabel.value)

wButton1 = WIDGET_BUTTON(wMode,$
                         VALUE   = sSelectionMode.value,$
                         TOOLTIP = sSelectionMode.tooltip,$
                         UNAME   = sSelectionMode.uname,$
                         /BITMAP,$
                         /NO_RELEASE)

wButton2 = WIDGET_BUTTON(wMode,$
                         VALUE   = s2DplotMode.value,$
                         TOOLTIP = s2DplotMode.tooltip,$
                         UNAME   = s2DplotMode.uname,$
                         /BITMAP,$
                         /NO_RELEASE)

WIDGET_CONTROL,  WIDGET_INFO(wMode, /CHILD), /SET_BUTTON

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

;Reference File Base ----------------------------------------------------------
wRefBase = WIDGET_BASE(BaseTab,$
                       XOFFSET   = sRefBase.size[0],$
                       YOFFSET   = sRefBase.size[1],$
                       SCR_XSIZE = sRefBase.size[2],$
                       SCR_YSIZE = sRefBase.size[3],$
                       FRAME     = sRefBase.frame,$
                       SENSITIVE = sRefBase.sensitive,$
                       UNAME     = sRefBase.uname)

;reference file value help
wRefHelp = WIDGET_BUTTON(wRefBase,$
                         XOFFSET   = sRefLabelHelp.size[0],$
                         YOFFSET   = sRefLabelHelp.size[1],$
                         SCR_XSIZE = sRefLabelHelp.size[2],$
                         VALUE     = sRefLabelHelp.value,$
                         UNAME     = sRefLabelHelp.uname,$
                         /PUSHBUTTON)

;reference file label
wRefLabel = WIDGET_LABEL(wRefBase,$
                         XOFFSET = sRefLabel.size[0],$
                         YOFFSET = sRefLabel.size[1],$
                         VALUE   = sRefLabel.value)

;reference file value
wRefFileName = WIDGET_LABEL(wRefBase,$
                            XOFFSET   = sRefFileName.size[0],$
                            YOFFSET   = sRefFileName.size[1],$
                            SCR_XSIZE = sRefFileName.size[2],$
                            VALUE     = sRefFileName.value,$
                            UNAME     = sRefFileName.uname,$
                            /ALIGN_LEFT)

;active file help
wActiveHelp = WIDGET_BUTTON(wRefBase,$
                            XOFFSET   = sActiveDroplistHelp.size[0],$
                            YOFFSET   = sActiveDroplistHelp.size[1],$
                            SCR_XSIZE = sActiveDroplistHelp.size[2],$
                            VALUE     = sActiveDroplistHelp.value,$
                            UNAME     = sActiveDroplistHelp.uname,$
                            /PUSHBUTTON)
;active label
wActiveLabel = WIDGET_LABEL(wRefBase,$
                            XOFFSET = sActiveLabel.size[0],$
                            YOFFSET = sActiveLabel.size[1],$
                            VALUE   = sActiveLabel.value)

;active droplist
wActiveDroplist = WIDGET_DROPLIST(wRefBase,$
                                  XOFFSET = sActiveDroplist.size[0],$
                                  YOFFSET = sActiveDroplist.size[1],$
                                  VALUE   = sActiveDroplist.value,$
                                  UNAME   = sActiveDroplist.uname,$
                                  /DYNAMIC_RESIZE)

;Reference pixel help button
wRefPixelHelp = WIDGET_BUTTON(wRefBase,$
                              XOFFSET   = sRefPixelHelp.size[0],$
                              YOFFSET   = sRefPixelHelp.size[1],$
                              SCR_XSIZE = sRefPixelHelp.size[2],$
                              VALUE     = sRefPixelHelp.value,$
                              UNAME     = sRefPixelHelp.uname)

;reference pixel label
wRefPixelLabel = WIDGET_LABEL(wRefBase,$
                              XOFFSET = sRefPixelLabel.size[0],$
                              YOFFSET = sRefPixelLabel.size[1],$
                              VALUE   = sRefPixelLabel.value)
                      
;reference pixel value        
wRefPixelValue = WIDGET_TEXT(wRefBase,$
                             XOFFSET   = sRefPixelValue.size[0],$
                             YOFFSET   = sRefPixelValue.size[1],$
                             SCR_XSIZE = sRefPixelValue.size[2],$
                             VALUE     = sRefPixelValue.value,$
                             UNAME     = sRefPixelValue.uname,$
                             /EDITABLE,$
                             /ALIGN_LEFT)

;selection down button
wPixelDown = WIDGET_BUTTON(wRefBase,$
                           XOFFSET   = sPixelDwButton.size[0],$
                           YOFFSET   = sPixelDwButton.size[1],$
                           VALUE     = sPixelDwButton.value,$
                           UNAME     = sPixelDwButton.uname,$
                           TOOLTIP   = sPixelDwButton.tooltip,$
                           /BITMAP)

;Help button
wPixelHelp = WIDGET_BUTTON(wRefBase,$
                           XOFFSET   = sPixelDwUpHelp.size[0],$
                           YOFFSET   = sPixelDwUpHelp.size[1],$
                           SCR_XSIZE = sPixelDwUpHelp.size[2],$
                           VALUE     = sPixelDwUpHelp.value,$
                           UNAME     = sPixelDwUpHelp.uname)

;selection down button
wPixelUp = WIDGET_BUTTON(wRefBase,$
                         XOFFSET   = sPixelUpButton.size[0],$
                         YOFFSET   = sPixelUpButton.size[1],$
                         VALUE     = sPixelUpButton.value,$
                         UNAME     = sPixelUpButton.uname,$
                         TOOLTIP   = sPixelUpButton.tooltip,$
                         /BITMAP)

;move by label and value
wMoveByValue = WIDGET_TEXT(wRefBase,$
                           XOFFSET   = sMoveByValue.size[0],$
                           YOFFSET   = sMoveByValue.size[1],$
                           SCR_XSIZE = sMoveByValue.size[2],$
                           UNAME     = sMoveByValue.uname,$
                           VALUE     = sMoveByValue.value,$
                           /ALIGN_LEFT,$
                           /EDITABLE)

wMoveByLabel = WIDGET_LABEL(wRefBase,$
                            XOFFSET = sMoveByLabel.size[0],$
                            YOFFSET = sMoveByLabel.size[1],$
                            VALUE   = sMoveByLabel.value)

;help label
wHelpLabel = WIDGET_LABEL(BaseTab,$
                          XOFFSET = sHelpLabel.size[0],$
                          YOFFSET = sHelpLabel.size[1],$
                          VALUE   = sHelpLabel.value)
;Help base
wHelpBase = WIDGET_BASE(BaseTab,$
                        XOFFSET   = sHelpBase.size[0],$
                        YOFFSET   = sHelpBase.size[1],$
                        SCR_XSIZE = sHelpBase.size[2],$
                        SCR_YSIZE = sHelpBase.size[3],$
                        FRAME     = sHelpBase.frame,$
                        UNAME     = sHelpBase.uname)

;Help text field
wHelpTextField = WIDGET_TEXT(wHelpBase,$
                             XOFFSET   = sHelpTextField.size[0],$
                             YOFFSET   = sHelpTextField.size[1],$
                             SCR_XSIZE = sHelpTextField.size[2],$
                             SCR_YSIZE = sHelpTextField.size[3],$
                             VALUE     = sHelpTextField.value,$
                             UNAME     = sHelpTextField.uname,$
                             /WRAP,$
                             /SCROLL)

;Auto mode base ---------------------------------------------------------------
;label
wAutoModeLabel = WIDGET_LABEL(BaseTab,$
                              XOFFSET = sAutoModeLabel.size[0],$
                              YOFFSET = sAutoModeLabel.size[1],$
                              VALUE   = sAutoModeLabel.value)

wAutoModeBase = WIDGET_BASE(BaseTab,$
                            XOFFSET   = sAutoMode.size[0],$
                            YOFFSET   = sAutoMode.size[1],$
                            SCR_XSIZE = sAutoMode.size[2],$
                            SCR_YSIZE = sAutoMode.size[3],$
                            UNAME     = sAutoMode.uname,$
                            FRAME     = sAutoMode.frame,$
                            SENSITIVE = sAutoMode.sensitive)

;Realign Data
wRealignData = WIDGET_BUTTON(wAutoModeBase,$
                             XOFFSET   = sRealignButton.size[0],$
                             YOFFSET   = sRealignButton.size[1],$
                             VALUE     = sRealignButton.value,$
                             UNAME     = sRealignButton.uname,$
                             TOOLTIP   = sRealignButton.tooltip,$
                             SENSITIVE = sRealignButton.sensitive,$
                             /BITMAP)

;Cancel Realign Data
wCancelRealignData = WIDGET_BUTTON(wAutoModeBase,$
                                   XOFFSET   = sCancelRealignButton.size[0],$
                                   YOFFSET   = sCancelRealignButton.size[1],$
                                   VALUE     = sCancelRealignButton.value,$
                                   UNAME     = sCancelRealignButton.uname,$
                                   TOOLTIP   = sCancelRealignButton.tooltip,$
                                   SENSITIVE = sCancelRealignButton.sensitive,$
                                   /BITMAP)

;Manual Mode Label ------------------------------------------------------------
wManualModeLabel = WIDGET_LABEL(BaseTab,$
                                XOFFSET = sManualModeLabel.size[0],$
                                YOFFSET = sManualModeLabel.size[1],$
                                VALUE   = sManualModeLabel.value)

;Manual Mode Base -------------------------------------------------------------
wManualModeBase = WIDGET_BASE(BaseTab,$
                              XOFFSET   = sManualModeBase.size[0],$
                              YOFFSET   = sManualModeBase.size[1],$
                              SCR_XSIZE = sManualModeBase.size[2],$
                              SCR_YSIZE = sManualModeBase.size[3],$
                              UNAME     = sManualModeBase.uname,$
                              FRAME     = sManualModeBase.frame,$
                              SENSITIVE = sManualModeBase.sensitive)

;Current working file label and value
wManualModeFileLabel = WIDGET_LABEL(wManualModeBase,$
                                    XOFFSET = sManualModeFileLabel.size[0],$
                                    YOFFSET = sManualModeFileLabel.size[1],$
                                    VALUE   = sManualModeFileLabel.value)

wManualModeFileValue = WIDGET_LABEL(wManualModeBase,$
                                    XOFFSET = sManualModeFileValue.size[0],$
                                    YOFFSET = sManualModeFileValue.size[1],$
                                    VALUE   = sManualModeFileValue.value,$
                                    UNAME   = sManualModeFileValue.uname,$
                                    /ALIGN_LEFT)

;data down button
wDataDown = WIDGET_BUTTON(wManualModeBase,$
                          XOFFSET   = sManualDownButton.size[0],$
                          YOFFSET   = sManualDownButton.size[1],$
                          VALUE     = sManualDownButton.value,$
                          UNAME     = sManualDownButton.uname,$
                          TOOLTIP   = sManualDownButton.tooltip,$
                          /BITMAP)

;data up button
wDataUp = WIDGET_BUTTON(wManualModeBase,$
                          XOFFSET   = sManualUpButton.size[0],$
                          YOFFSET   = sManualUpButton.size[1],$
                          VALUE     = sManualUpButton.value,$
                          UNAME     = sManualUpButton.uname,$
                          TOOLTIP   = sManualUpButton.tooltip,$
                          /BITMAP)

;move by label and value
wMoveByManualValue = WIDGET_TEXT(wManualModeBase,$
                                 XOFFSET   = sMoveByManualValue.size[0],$
                                 YOFFSET   = sMoveByManualValue.size[1],$
                                 SCR_XSIZE = sMoveByManualValue.size[2],$
                                 UNAME     = sMoveByManualValue.uname,$
                                 VALUE     = sMoveByManualValue.value,$
                                 /ALIGN_LEFT,$
                                 /EDITABLE)

wMoveByManualLabel = WIDGET_LABEL(wManualModeBase,$
                            XOFFSET = sMoveByManualLabel.size[0],$
                            YOFFSET = sMoveByManualLabel.size[1],$
                            VALUE   = sMoveByManualLabel.value)

END
