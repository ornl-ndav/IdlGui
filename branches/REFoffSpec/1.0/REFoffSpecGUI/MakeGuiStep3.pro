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
XYoff = [50,10] ;X value
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
       
;More or Less axis ticks number ----------------------------------------------
XYoff = [300,10]
sXaxisTicksLabel = { size: [sCountsLabel.size[0]+XYoff[0],$
                            XYoff[1]],$
                     value: 'Xaxis Ticks Nbr:'}
XYoff=[110,5]                    ;- ticks
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
XYoff = [-175,0]
sLinLog = { size: [sBaseTab.size[2]+XYoff[0],$
                   XYoff[1]],$
            list: ['Linear','Log'],$
            label: 'Z-axis:',$
            uname: 'z_axis_linear_log_shifting',$
            value: 0.0}

XYOff = [43,50] ;Draw ---------------------------------------------------------
sDraw = { size: [XYoff[0],$
                 XYoff[1],$
                 tab_size[2]-125,$
                 304L*2],$
          scroll_size: [tab_size[2]-35-XYoff[0],$
                        304L*2+40],$
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

;Reference and active File Base -----------------------------------------------
XYoff = [5,5]
sRefBase = { size: [XYoff[0],$
                    sScale.size[1]+$
                    sScale.size[3]+$
                    XYoff[1],$
                    1258,$
                    42],$
             uname: 'reference_base_shifting',$
             frame: 1}
main_yoff = 5
XYoff = [0,8+main_yoff]
sRefLabel = { size: [XYoff[0],$
                     XYoff[1]],$
              value: 'Reference File :'}
XYoff = [105,0]
sRefFileName = { size: [sRefLabel.size[0]+XYoff[0],$
                        sRefLabel.size[1]+XYoff[1],$
                        200],$
                 value: 'N/A',$
                 uname: 'reference_file_name_shifting'}
XYoff = [0,0]
sActiveLabel = { size: [sRefFileName.size[0]+$
                        sRefFileName.size[2]+XYoff[0],$
                        sRefLabel.size[1]+XYoff[1]],$
                 value: 'Active File :'}
XYoff = [80,3]
sActiveDroplist = { size: [sActiveLabel.size[0]+XYoff[0],$
                           XYoff[1]],$
                    value: ['N/A                                         '],$
                    uname: 'active_file_droplist_shifting'}

XYoff = [390,0]
sRefPixelLabel = { size: [sActiveDroplist.size[0]+$
                          XYoff[0],$
                          sRefLabel.size[1]+$
                          XYoff[1]],$
                   value: 'Reference Pixel:'}
XYoff = [100,-8]
sRefPixelValue = { size: [sRefPixelLabel.size[0]+$
                          XYoff[0],$
                          sRefPixelLabel.size[1]+$
                          XYoff[1],$
                          40],$
                   value: '',$
                   uname: 'reference_pixel_value_shifting'}
XYoff = [50,0]
sPixelDwButton = { size: [sRefPixelValue.size[0]+$
                          sRefPixelValue.size[2]+$
                          XYoff[0],$
                          XYoff[1]],$
                   uname: 'pixel_down_selection_shifting',$
                   tooltip: 'To decrease reference pixel by 1 pixel',$
                   value: 'images/selection_down.bmp'}
XYoff = [50,0]
sPixelUpButton = { size: [sPixelDwButton.size[0]+$
                          XYoff[0],$
                          sPixelDwButton.size[1]+$
                          XYoff[1]],$
                   tooltip: 'To increase reference pixel by 1 pixel',$
                   uname: 'pixel_up_selection_shifting',$
                   value: 'images/selection_up.bmp'}
                         
XYoff = [60,0]
sMoveByLabel = { size: [sPixelUpButton.size[0]+$
                        XYoff[0],$
                        sRefPixelLabel.size[1]+$
                        XYoff[1]],$
                 value: 'Move by      pixels'}
XYoff = [48,0]
sMoveByValue = { size: [sMoveByLabel.size[0]+$
                        XYoff[0],$
                        sRefPixelValue.size[1]+$
                        XYoff[1],$
                        30],$
                 uname: 'move_by_x_pixel_value_shifting',$
                 value: '1'}
                         
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

;More or Less number of ticks on the x-axis -----------------------------------
label = WIDGET_LABEL(BaseTab,$
                     XOFFSET = sXaxisTicksLabel.size[0],$
                     YOFFSET = sXaxisTicksLabel.size[1],$
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

;Reference File Base ----------------------------------------------------------
wRefBase = WIDGET_BASE(BaseTab,$
                       XOFFSET   = sRefBase.size[0],$
                       YOFFSET   = sRefBase.size[1],$
                       SCR_XSIZE = sRefBase.size[2],$
                       SCR_YSIZE = sRefBase.size[3],$
                       FRAME     = sRefBase.frame,$
                       UNAME     = sRefBase.uname)

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


END
