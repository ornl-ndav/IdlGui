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

PRO make_gui_step2, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step2_tab_base',$
             title: TabTitles.step2}

XYoff = [5,5] ;Browse button --------------------------------------------------
sBrowseButton = { size: [XYoff[0],$
                         XYoff[1],$
                         150],$
                  value: 'BROWSE ASCII ...',$
                  tooltip: 'Select an ASCII file to load',$
                  uname: 'browse_ascii_file_button'}
                  
XYoff = [0,0] ;List of ascii files --------------------------------------------
sAsciiList = { size: [sBrowseButton.size[0]+$
                      sBrowseButton.size[2]+XYoff[0],$
                      sBrowseButton.size[1]+XYoff[1],$
                      700,110],$
               uname: 'ascii_file_list',$
               sensitive: 1,$
               value: ['']}

XYoff = [0,0] ;Preview button -------------------------------------------------
sPreviewButton = { size: [sAsciiList.size[0]+$
                          sAsciiList.size[2]+XYoff[0],$
                          sAsciiList.size[1]+XYoff[1],$
                          220],$
                   value: 'PREVIEW OF SELECTED ASCII FILE ...',$
                   uname: 'ascii_preview_button',$
                   tooltip: 'Preview of selected ASCII file',$
                   sensitive: 0}

XYoff = [0,30] ;Delete ascii file button --------------------------------------
sDeleteButton = { size: [sPreviewButton.size[0]+XYoff[0],$
                         sPreviewButton.size[1]+XYoff[1],$
                         sPreviewButton.size[2]],$
                  value: 'DELETE SELECTED ASCII FILE ...',$
                  uname: 'ascii_delete_button',$
                  tooltip: 'Delete Selected ASCII file',$
                  sensitive: 0}

XYOff = [43,30] ;Draw ---------------------------------------------------------
sDraw = { size: [XYoff[0],$
                 sAsciiList.size[1]+$
                 sAsciiList.size[3]+XYoff[1],$
                 tab_size[2]-125,$
; Change made: Replace 304 with detector_pixels_y obtained from XML fole (RCW, Feb 10, 2010)
                 (*global).detector_pixels_y*2],$
;                 304L*2],$
; Change made: Replace 304 with detector_pixels_y obtained from XML fole (RCW, Feb 10, 2010)
          scroll_size: [tab_size[2]-35-XYoff[0],$
; Change made: Replace 304 with detector_pixels_y obtained from XML fole (RCW, Feb 10, 2010)                    
                        (*global).detector_pixels_y*2+40],$
;                        304L*3+40],$
          uname: 'step2_draw'}
          
XYoff = [-7,-18] ;Scale of Draw ----------------------------------------------
sScale = { size: [XYoff[0],$
                  sDraw.size[1]+XYoff[1],$
                  tab_size[2]-75,$
                  sDraw.size[3]+57],$
           uname: 'scale_draw_step2'}

XYoff = [1,0] ;Color Scale ----------------------------------------------------
sColorScale = { size: [sScale.size[0]+$
                       sScale.size[2]+XYoff[0],$
                       sScale.size[1]+XYoff[1],$
                       75,$
                       sScale.size[3]],$
                uname: 'scale_color_draw'}


XYoff = [0,-30] ;z_max value
sZmax = { size: [sColorScale.size[0]+XYoff[0],$
                 sColorScale.size[1]+XYoff[1],$
                 75],$
          uname: 'step2_zmax',$
          sensitive: 0,$
          value: ''}

XYoff = [0,-25] ;z_reset
sZreset = { size: [sZmax.size[0]+XYoff[0],$
                   sZmax.size[1]+XYoff[1],$
                   sZmax.size[2]],$
            uname: 'step2_z_reset',$
            sensitive: 0,$
            value: 'R E S E T'}

XYoff = [0,0]
sZmin = { size: [sZmax.size[0]+XYoff[0],$
                 sColorScale.size[1]+$
                 sColorScale.size[3]+$
                 XYoff[1],$
                 sZmax.size[2]],$
          uname: 'step2_zmin',$
          sensitive: 0,$
          value: ''}

;X and Y of mouse over plot area ----------------------------------------------
XYoff = [-330,-30]
sXYdisplay = { size: [sColorScale.size[0]+$
                      XYoff[0],$
                      sColorScale.size[1]+$
                      XYoff[1],$
                      300],$
               value: 'x: ?  |  y: ?  |  counts: ?',$
               uname: 'xy_display_step2',$
               frame: 1}

;Refresh Plot Button
XYOff = [5,-30]
sRefreshPlot = { size: [sScale.size[0]+XYoff[0],$
                        sScale.size[1]+XYoff[1],$
                        100],$
                 uname: 'refresh_step2_plot',$
                 value: 'REFRESH',$
                 sensitive: 0}

;Transparency factor-----------------------------------------------------------
XYoff = [30,10]
sTransBase = { size: [XYoff[0],$
                      sScale.size[1]+$
                      sScale.size[3]+$
                      XYoff[1],$
                      650,35],$
               uname: 'transparency_base',$
               frame: 1,$
               sensitive: 0}
XYoff = [2,8] ;label of list of files
sTranLabel = { size: [XYoff[0],$
                      XYoff[1]],$
               value: 'File Name:'}
XYoff = [60,0] ;droplist of list of files
sTranList = { size: [XYoff[0],$
                     XYoff[1],$
                     300],$
              list: ['List of files loaded                  '],$
              uname: 'transparency_file_list'}
XYoff = [0,0]
sTLabel = { size: [sTranList.size[0]+$
                   sTranList.size[2]+$
                   XYoff[0],$
                   sTranLabel.size[1]+XYoff[1]],$
            value: 'Attenuator:'}

XYoff = [90,2] ;transparency percentage
sTranPercentage = { size: [sTLabel.size[0]+XYoff[0],$
                           sTranList.size[1]+$
                           XYoff[1],$
                           60],$
                    uname: 'transparency_coeff',$
                    value: 'N/A'}
XYoff = [0,0]
sTranCoeffLabel = { size: [sTranPercentage.size[0]+$
                           sTranPercentage.size[2]+$
                           XYoff[0],$
                           sTLabel.size[1]+$
                           XYoff[1]],$
                    value: '%'}
                    
XYoff = [25,3]
sFullReset = { size: [sTranCoeffLabel.size[0]+$
                      XYoff[0],$
                      sTranList.size[1]+XYoff[1],$
                      100],$
               value: 'FULL RESET',$
               uname: 'trans_full_reset'}

;Lin/Log z-axis ---------------------------------------------------------------
XYoff = [30,0]
sLinLog = { size: [sTransBase.size[0]+$
                   sTransBase.size[2]+XYoff[0],$
                   sTransBase.size[1]+XYoff[1]],$
            list: ['Linear','Log'],$
            label: 'Z-axis:',$
            uname: 'z_axis_linear_log',$
            value: 1.0}
                   
XYoff = [-290,10] ;+/- number of x-axis ticks ---------------------------------
sXaxisTicksBase = { size: [sScale.size[0]+$
                           sScale.size[2]+$
                           XYoff[0],$
                           sScale.size[1]+$
                           sScale.size[3]+$
                           XYoff[1],$
                           250,35],$
                    uname: 'x_axis_ticks_base',$
                    frame: 1,$
                    sensitive: 0}

XYoff= [2,8]                    ;label
sXaxisTicksLabel = { size: [XYoff[0],$
                            XYoff[1]],$
                     value: 'Xaxis Ticks #:'}
XYoff=[95,5]                    ;- ticks
sXaxisLessTicks = { size: [XYoff[0],$
                           XYoff[1],$
                           70],$
                    value: ' <<< ',$
                    uname: 'x_axis_less_ticks'}
XYoff=[5,0]                     ;+ ticks
sXaxisMoreTicks = { size: [sXaxisLessTicks.size[0]+$
                           sXaxisLessTicks.size[2]+XYoff[0],$
                           sXaxisLessTicks.size[1]+XYoff[1],$
                           sXaxisLessTicks.size[2]],$
                    value: ' >>> ',$
                    uname: 'x_axis_more_ticks'}
                    
XYoff= [15,60]   ; help label
sHelpLabel = { size: [sAsciiList.size[0]+$
                           sAsciiList.size[2]+XYoff[0],$
                           sAsciiList.size[1]+XYoff[1],$
                           50],$
                     value: 'GO TO SCALING STEP IF NO SHIFTING IS REQUIRED.',$
                     frame: 6}

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

;Browse button ----------------------------------------------------------------
wBrowseButton = WIDGET_BUTTON(BaseTab,$
                              XOFFSET   = sBrowseButton.size[0],$
                              YOFFSET   = sBrowseButton.size[1],$
                              SCR_XSIZE = sBrowseButton.size[2],$
                              VALUE     = sBrowseButton.value,$
                              TOOLTIP   = sBrowseButton.tooltip,$
                              UNAME     = sBrowseButton.uname)

;List of Ascii files ----------------------------------------------------------
wAsciiList = WIDGET_LIST(BaseTab,$
                         XOFFSET   = sAsciiList.size[0],$
                         YOFFSET   = sAsciiList.size[1],$
                         SCR_XSIZE = sAsciiList.size[2],$
                         SCR_YSIZE = sAsciiList.size[3],$
                         VALUE     = sAsciiList.value,$
                         UNAME     = sAsciiList.uname,$
                         SENSITIVE = sAsciiList.sensitive,$
                         /MULTIPLE)

;Preview Button ---------------------------------------------------------------
wPreviewButton = WIDGET_BUTTON(BaseTab,$
                               XOFFSET   = sPreviewButton.size[0],$
                               YOFFSET   = sPreviewButton.size[1],$
                               SCR_XSIZE = sPreviewButton.size[2],$
                               VALUE     = sPreviewButton.value,$
                               UNAME     = sPreviewButton.uname,$
                               SENSITIVE = sPreviewButton.sensitive,$
                               TOOLTIP   = sPreviewButton.tooltip)

;Delete Button ----------------------------------------------------------------
wDeleteButton = WIDGET_BUTTON(BaseTab,$
                              XOFFSET   = sDeleteButton.size[0],$
                              YOFFSET   = sDeleteButton.size[1],$
                              SCR_XSIZE = sDeleteButton.size[2],$
                              VALUE     = sDeleteButton.value,$
                              UNAME     = sDeleteButton.uname,$
                              SENSITIVE = sDeleteButton.sensitive,$
                              TOOLTIP   = sDeleteButton.tooltip)

;X and Y mouse over plot area information -------------------------------------
wXYdisplay = WIDGET_LABEL(BaseTab,$
                          XOFFSET   = sXYdisplay.size[0],$
                          YOFFSET   = sXYdisplay.size[1],$
                          SCR_XSIZE = sXYdisplay.size[2],$
                          VALUE     = sXYdisplay.value,$
                          FRAME     = sXYdisplay.frame,$
                          UNAME     = sXYdisplay.uname)

;Refresh Plot -----------------------------------------------------------------
wRefreshPlot = WIDGET_BUTTON(BaseTab,$
                             XOFFSET   = sRefreshPlot.size[0],$
                             YOFFSET   = sRefreshPlot.size[1],$
                             SCR_XSIZE = sRefreshPlot.size[2],$
                             VALUE     = sRefreshPlot.value,$
                             UNAME     = sRefreshPlot.uname,$
                             SENSITIVE = sRefreshPlot.sensitive)

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

index = WHERE((*global).ucams EQ (*global).super_users)
IF (index NE -1) THEN BEGIN ;for super users

;Transparency coeff -----------------------------------------------------------
    TransBase = WIDGET_BASE(BaseTab,$
                            XOFFSET   = sTransBase.size[0],$
                            YOFFSET   = sTransBase.size[1],$
                            SCR_XSIZE = sTransBase.size[2],$
                            SCR_YSIZE = sTransBase.size[3],$
                            UNAME     = sTransBase.uname,$
                            FRAME     = sTransBase.frame,$
                            SENSITIVE = sTransBase.sensitive)
;label
    label = WIDGET_LABEL(TransBase,$
                         XOFFSET = sTranLabel.size[0],$
                         YOFFSET = sTranLabel.size[1],$
                         VALUE   = sTranLabel.value)
;droplist
    droplist = WIDGET_DROPLIST(TransBase,$
                               VALUE   = sTranList.list,$
                               XOFFSET = sTranList.size[0],$
                               YOFFSET = sTranList.size[1],$
                               UNAME   = StranList.uname)
    
;label
    label = WIDGET_LABEL(TransBase,$
                         XOFFSET = sTLabel.size[0],$
                         YOFFSET = sTLabel.size[1],$
                         VALUE   = sTLabel.value)
;text
    text = WIDGET_TEXT(TransBase,$
                       XOFFSET   = sTranPercentage.size[0],$
                       YOFFSET   = sTranPercentage.size[1],$
                       SCR_XSIZE = sTranPercentage.size[2],$
                       UNAME     = sTranPercentage.uname,$
                       VALUE     = sTranPercentage.value,$
                       /EDITABLE,$
                       /ALIGN_LEFT)
;label
    label = WIDGET_LABEL(TransBase,$
                         XOFFSET = sTranCoeffLabel.size[0],$
                         YOFFSET = sTranCoeffLabel.size[1],$
                         VALUE   = sTranCoeffLabel.value)
    
;Full Reset Button
    button = WIDGET_BUTTON(TransBase,$
                           XOFFSET   = sFullReset.size[0],$
                           YOFFSET   = sFullReset.size[1],$
                           SCR_XSIZE = sFullReset.size[2],$
                           VALUE     = sFullReset.value,$
                           UNAME     = sFullReset.uname)

ENDIF

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

;More or Less number of ticks on the x-axis -----------------------------------
wTicksBase = WIDGET_BASE(BaseTab,$
                         XOFFSET   = sXaxisTicksBase.size[0],$
                         YOFFSET   = sXaxisTicksBase.size[1],$
                         SCR_XSIZE = sXaxisTicksBase.size[2],$
                         SCR_YSIZE = sXaxisTicksBase.size[3],$
                         UNAME     = sXaxisTicksBase.uname,$
                         SENSITIVE = sXaxisTicksBase.sensitive,$
                         FRAME     = sXaxisTicksBase.frame)

;More/Less number of ticks
label = WIDGET_LABEL(wTicksBase,$
                     XOFFSET = sXaxisTicksLabel.size[0],$
                     YOFFSET = sXaxisTicksLabel.size[1],$
                     VALUE   = sXaxisTicksLabel.value)

less = WIDGET_BUTTON(wTicksBase,$
                     XOFFSET   = sXaxisLessTicks.size[0],$
                     YOFFSET   = sXaxisLessTicks.size[1],$
                     SCR_XSIZE = sXaxisLessTicks.size[2],$
                     VALUE     = sXaxisLessTicks.value,$
                     UNAME     = sXaxisLessTicks.uname)

more = WIDGET_BUTTON(wTicksBase,$
                     XOFFSET   = sXaxisMoreTicks.size[0],$
                     YOFFSET   = sXaxisMoreTicks.size[1],$
                     SCR_XSIZE = sXaxisMoreTicks.size[2],$
                     VALUE     = sXaxisMoreTicks.value,$
                     UNAME     = sXaxisMoreTicks.uname)
                     
; Code Change (RC Ward, Mar 8, 2010):
; add a comment on the GUI for this step - "Skip to scaling step if no shifting is required"      
wHelpLabel = WIDGET_LABEL(BaseTab,$
                         XOFFSET   = sHelpLabel.size[0],$
                         YOFFSET   = sHelpLabel.size[1],$
                         VALUE     = sHelpLabel.value, $
                         FRAME     = sHelpLabel.frame)
              

END
