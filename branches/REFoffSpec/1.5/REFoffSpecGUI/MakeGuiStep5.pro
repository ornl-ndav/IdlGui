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

  ;*****************************************************************************
  ;            DEFINE STRUCTURE
  ;*****************************************************************************

  sBaseTab = { size:  tab_size,$
    uname: 'step5_tab_base',$
    title: TabTitles.step5}
    
  ;=============================================================================
  ;Rescale base
  XYoff = [5,5]
; Code Change (RC Ward, April 10, 2010): Change size of window
; Note that the first two elements of size are the XOFFSET and YOFFSET
;    and the last two elements are the size of the button in pixels, SCR_XSIZE, SCRYSIZE.
   sRescaleBase = { size: [tab_size[0],$
                          tab_size[1],$
                          tab_size[2],$
                          730],$
                    uname: 'step5_rescale_base',$
                    map: 0}                         
                          
;  Code Change (RC Ward, April 10, 2010): Eventually remove these buttons from the screen.
;  Control of scaling will be as in Scaling Step 1D plot 
  ;buttons zoom or selection
  XYoff = [0,0]
  sZoomSelectionBase = { size: [XYoff[0],$
                                XYoff[1],$
                                145]}
    
  sZoomButton = { value: 'ZOOM',$
                  uname: 'step5_rescale_zoom_button'}
                  sSelectionButton = { value: 'SELECTION',$
                  uname: 'step5_rescale_selection_button'}
    
  ;draw
;  Code Change (RC Ward, April 10, 2010): Change size of plot to that of SCALING 1D plot
;  XYoff = [0,35]
;  sRescaleDraw = { size: [XYoff[0],$
;                          XYoff[1],$
;                          tab_size[2],$
;                          700],$
;                   uname: 'step5_rescale_draw'}
  XYoff = [5,35]
  sRescaleDraw = { size: [XYoff[0],$
                          XYoff[1],$
                          700, 700],$
                   uname: 'step5_rescale_draw'}
   
;  Code Change (RC Ward, April 10, 2010): Remove these buttons from the screen
;  Control of scaling will be as in  Step 4 1D plot 
  ;FUll reset of scale
  XYoff = [300,5]
  sFullReset = { size: [XYoff[0],$
                        XYoff[1],$
                        200],$
                        uname: 'step5_rescale_full_reset',$
                        value: 'RESET ZOOM'}
    
  ;Scale data
  XYoff = [5,0]
  sScaleButton = { size: [sFullReset.size[0]+$
                          sFullReset.size[2]+XYoff[0],$
                          sFullReset.size[1]+XYoff[1],$
                          sFullReset.size[2]],$
                  uname: 'step5_rescale_scale_to_1',$
                  sensitive: 0,$
                  value: 'SCALE TO 1 SELECTION'}
    
  ;Reset Scale
    XYoff = [5,0]
    sResetScaleButton = { size: [sScaleButton.size[0]+$
                                 sScaleButton.size[2]+$
                                 XYoff[0],$
                                 sScaleButton.size[1]+XYoff[1],$
                                 sScaleButton.size[2]],$
                          uname: 'step5_rescale_scale_to_1_reset',$
                          sensitive: 0,$
                          value: 'RESET SCALE'}
    
  ;lin/log plot
   XYoff = [45,-2]
   sLinLog1 = { size: [sResetScaleButton.size[0]+$   
                       sResetScaleButton.size[2]+$
                       XYoff[0],$
                       sResetScaleButton.size[1]+$
                       XYoff[1]],$
                value: ['Lin','Log'],$
                uname: 'step5_rescale_lin_log_plot',$
                default_value: 1} ; default is log
    
  ;go back to recap plot button
  XYoff = [1110,5]
  sRescaleButton = { size: [XYoff[0],$
                            XYoff[1],$
                            150],$
                    uname: 'step5_rescale_go_back_button',$
                    value: 'Select New Data Range'}
; Change code (RC Ward, 16 April 2010): Add buttons to control scale as in Step 4
;Zoom base (x-axis and y_axis) ------------------------------------------------
XYoff = [710, -92]
sZoomBase = { size: [sRescaleBase.size[0]+XYoff[0],$
                     sRescaleBase.size[1]+$
                     sRescaleBase.size[3]+XYoff[1],$
                     545,90],$
             uname: 'step5_new_zoom_base',$
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
                   uname: 'step5_new_zoom_x_min'}

XYoff = [10,0]
sXMaxBaseField = { size: [sXMinBaseField.size[0]+$
                          sXMinBaseField.size[2]+XYoff[0],$
                          sXMinBaseField.size[1]+XYoff[1],$
                          sXMinBaseField.size[2:3]],$
                   label_left: 'Max:',$
                   value: '',$
                   uname: 'step5_new_zoom_x_max'}
 ;RESET x axis -----------------------------------------------------------------
XYoff = [155,5]
sResetXaxis = { size: [sXMaxBaseField.size[0]+$
                       XYoff[0],$
                       sXMaxBaseField.size[1]+$
                       XYoff[1],$
                       100],$
                value: 'FULL RESET',$
                uname: 'step5_new_zoom_reset_axis'}

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
                   uname: 'step5_new_zoom_y_min'}

XYoff = [0,0]
sYMaxBaseField = { size: [sXMaxBaseField.size[0]+XYoff[0],$
                          sYminBaseField.size[1]+XYoff[1],$
                          sXMaxBaseField.size[2:3]],$
                   label_left: 'Max:',$
                   value: '',$
                   uname: 'step5_new_zoom_y_max'}

; Section above is new code to add scaling like in Step 4   
  ;============================================================================
    
  ;-----------------------------------------------------------------------------
  ;Shifting base ---------------------------------------------------------------
  XYoff = [400,250]
  sShiftBase = { size: [XYoff[0],$
                        XYoff[1],$
                        300,50],$
                uname: 'shifting_base_step5',$
                frame: 3,$
                map: 1}
    
  ;shifting button -------------------------------------------------------------
  sShiftingDraw = { size: [0,0,300,50],$
                   uname: 'step5_shifting_draw'}
    
;  ;Scaling base ----------------------------------------------------------------
;  XYoff = [0,70]
;  sScalebase = { size: [sShiftBase.size[0]+XYoff[0],$
;                        sShiftBase.size[1]+$
;                        sShiftBase.size[3]+XYoff[1],$
;                        300,50],$
;                uname: 'scaling_base_step5',$
;                frame: 3,$
;                  map: 1}
;    
  ;scaling button --------------------------------------------------------------
  sScalingDraw = { size: [0,0,300,50],$
                  uname: 'step5_scaling_draw'}
  ;x/y and counts values -------------------------------------------------------
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
    
  ;Lin/Log z-axis for 2D plot--------------------------------------------------------------
  XYoff = [750,0]
  sLinLog = { size: [XYoff[0],$
                     XYoff[1]],$
              list: ['Linear','Log'],$
             label: 'Z-axis:',$
             uname: 'z_axis_linear_log_step5',$
             value: 1.0}
    
  XYOff = [43,50] ;Draw --------------------------------------------------------
  sDraw = { size: [XYoff[0],$
    XYoff[1],$
    tab_size[2]-125,$
    304L*2],$
    scroll_size: [tab_size[2]-35-XYoff[0],$
    304L*2+40],$
    uname: 'step5_draw'}
    
  XYoff = [0,-18] ;Scale of Draw -----------------------------------------------
  sScale = { size: [XYoff[0],$
    sDraw.size[1]+XYoff[1],$
    tab_size[2]-80,$
    sDraw.size[3]+57],$
    uname: 'scale_draw_step5'}
    
  XYoff = [5,0] ;Color Scale ---------------------------------------------------
  sColorScale = { size: [sScale.size[0]+$
    sScale.size[2]+XYoff[0],$
    sScale.size[1]+XYoff[1],$
    70,$
    sScale.size[3]],$
    uname: 'scale_color_draw_step5'}
    
  XYoff = [-5,-30] ;z_max value ------------------------------------------------
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
    
  ;cw_bgroup of
  ;selection to make (none, counts vs Q .... etc) -----------------
  XYoff = [10,5]
  sSelectionGroupBase = { size: [sScale.size[0]+XYoff[0],$
    sScale.size[1]+$
    sScale.size[3]+$
    XYoff[1],$
    800,40],$
    frame: 0,$
    sensitive: 1,$
    uname: 'step5_selection_group' }
   
    sSelectionGroup = { value: [' None ', $
    ' Counts vs Q ',$
    ' Counts vs Lambda Perpendicular '],$
    set_value: 0,$
    label: 'Selection Type:  ',$
    uname: 'step5_selection_group_uname' }
    
  ;counts vs Q base ------------------------------------------------------------
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
    
  ;*****************************************************************************
  ;            BUILD GUI
  ;*****************************************************************************
    
; Code Change (RC Ward, May 31, 2010): Add SCROLL capability to the WIDGET_BASE BaseTab

  BaseTab = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBaseTab.uname,$
    XOFFSET   = sBaseTab.size[0],$
    YOFFSET   = sBaseTab.size[1],$
    SCR_XSIZE = sBaseTab.size[2],$
    SCR_YSIZE = sBaseTab.size[3],$
    TITLE     = sBaseTab.title, $
    /SCROLL)
    
  ;-----------------------------------------------------------------------------
  ;Rescale base ----------------------------------------------------------------
  RescaleBase = WIDGET_BASE(BaseTab,$
    XOFFSET = sRescaleBase.size[0],$
    YOFFSET = sRescaleBase.size[1],$
    SCR_XSIZE = sRescaleBase.size[2],$
    SCR_YSIZE = sRescaleBase.size[3],$
    UNAME = sRescaleBase.uname,$
    MAP = sRescaleBase.map)

;  Code Change (RC Ward, April 10, 2010): Remove these buttons from the screen
;  Control of scaling will be as in Step 4 1D plot     
  ;zoom and selection base ---------------------------------------------------
;  wZoomSelectionBase = WIDGET_BASE(RescaleBase,$
;    XOFFSET = sZoomSelectionBase.size[0],$
;    YOFFSET = sZoomSelectionBase.size[1],$
;    SCR_XSIZE = sZoomSelectionBase.size[2],$
;    /EXCLUSIVE,$
;    /ROW)
    
  ;Zoom button
;  wZoomButton = WIDGET_BUTTON(wZoomSelectionBase,$
;    VALUE = sZoomButton.value,$
;    UNAME = sZoomButton.uname)
    
  ;Selection button
;  wSelectionButton = WIDGET_BUTTON(wZoomSelectionBase,$
;    VALUE = sSelectionButton.value,$
;    UNAME = sSelectionButton.uname)
    
  ;WIDGET_CONTROL, wZoomButton, /SET_BUTTON (was already commented out - RC Ward)
;  WIDGET_CONTROL, wSelectionButton, /SET_BUTTON
  
  ;full reset ----------------------------------------------------------------
;  wButton = WIDGET_BUTTON(RescaleBase,$
;    XOFFSET = sFullReset.size[0],$
;    YOFFSET = sFullReset.size[1],$
;    SCR_XSIZE = sFullReset.size[2],$
;    UNAME = sFullReset.uname,$
;    VALUE = sFullReset.value)
    
  ;Scale to 1 selection
;  wScaleButton = WIDGET_BUTTON(RescaleBase,$
;    XOFFSET = sScaleButton.size[0],$
;    YOFFSET = sScaleButton.size[1],$
;    SCR_XSIZE = sScaleButton.size[2],$
;    UNAME = sScaleButton.uname,$
;    VALUE = sScaleButton.value,$
;    SENSITIVE = sScaleButton.sensitive)
    
    ;Reset scale to 1
;    wResetScaleButton = WIDGET_BUTTON(RescaleBase,$
;    XOFFSET = sResetScaleButton.size[0],$
;    YOFFSET = sResetScaleButton.size[1],$
;    SCR_XSIZE = sResetScaleButton.size[2],$
;    VALUE = sResetScaleButton.value,$
;    UNAME = sResetScaleButton.uname,$
;    SENSITIVE = sResetScaleButton.sensitive)

; for 1D plot lin/log    
    wGroup = CW_BGROUP(RescaleBase,$
    sLinLog1.value,$
    XOFFSET = sLinLog1.size[0],$
    YOFFSET = sLinLog1.size[1],$
    /EXCLUSIVE,$
    /NO_RELEASE,$
    SET_VALUE = sLinLog1.default_value,$
    /ROW,$
    UNAME = sLinLog1.uname)
    
;go back button ------------------------------------------------------------
  wButton = WIDGET_BUTTON(RescaleBase,$
    XOFFSET = sRescaleButton.size[0],$
    YOFFSET = sRescaleButton.size[1],$
    SCR_XSIZE = sRescaleButton.size[2],$
    UNAME = sRescaleButton.uname,$
    VALUE = sRescaleButton.value)
; Change code (RC Ward, 16 April 2010): Add buttons to control scale as in Step 4
;Zoom base --------------------------------------------------------------------
;wZoomBase = WIDGET_BASE(BaseTab,$
wZoomBase = WIDGET_BASE(RescaleBase,$
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
                       
  ;draw ------------------------------------------------------------------------
; Code Change (RC Ward Mar 8, 2010): Add parameters RETAIN=2 to force IDL to deal with retaining the window.
; This should fix the problem of windows going "black".

  wDraw = WIDGET_DRAW(RescaleBase,$
    XOFFSET = sRescaleDraw.size[0],$
    YOFFSET = sRescaleDraw.size[1],$
    SCR_XSIZE = sRescaleDraw.size[2],$
    SCR_YSIZE = sRescaleDraw.size[3],$
    UNAME = sRescaleDraw.uname,$
    RETAIN = 2,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS)
    
  ;-----------------------------------------------------------------------------
  ;Scaling base ----------------------------------------------------------------
  wShiftbase = WIDGET_BASE(BaseTab,$
    XOFFSET   = sShiftBase.size[0],$
    YOFFSET   = sShiftBase.size[1],$
    SCR_XSIZE = sShiftBase.size[2],$
    SCR_YSIZE = sShiftBase.size[3],$
    UNAME     = sShiftBase.uname,$
    FRAME     = sShiftBase.frame)
    
  ;Shifting button -------------------------------------------------------------
  wShiftingDraw = WIDGET_DRAW(wShiftBase,$
    XOFFSET   = sShiftingDraw.size[0],$
    YOFFSET   = sShiftingDraw.size[1],$
    SCR_XSIZE = sShiftingDraw.size[2],$
    SCR_YSIZE = sShiftingDraw.size[3],$
    UNAME     = sShiftingDraw.uname,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS)
    
;  ;Shifting base ---------------------------------------------------------------
;  wScalebase = WIDGET_BASE(BaseTab,$
;    XOFFSET   = sScaleBase.size[0],$
;    YOFFSET   = sScaleBase.size[1],$
;    SCR_XSIZE = sScaleBase.size[2],$
;    SCR_YSIZE = sScaleBase.size[3],$
;    UNAME     = sScaleBase.uname,$
;    FRAME     = sScaleBase.frame)
;    
;  ;Scaling button --------------------------------------------------------------
;  wScalingDraw = WIDGET_DRAW(wScalebase,$
;    XOFFSET   = sScalingDraw.size[0],$
;    YOFFSET   = sScalingDraw.size[1],$
;    SCR_XSIZE = sScalingDraw.size[2],$
;    SCR_YSIZE = sScalingDraw.size[3],$
;    UNAME     = sScalingDraw.uname)
;    
  ;x/y and counts values -------------------------------------------------------
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
    
  ;More or Less number of ticks on the x-axis ----------------------------------
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
    
  ;Draw ------------------------------------------------------------------------
; Code Change (RC Ward Mar 8, 2010): Add parameters RETAIN=2 to force IDL to deal with retaining the window.
; This should fix the problem of windows going "black".

  wDraw = WIDGET_DRAW(BaseTab,$
    XOFFSET       = sDraw.size[0],$
    YOFFSET       = sDraw.size[1],$
    XSIZE         = sDraw.size[2],$
    YSIZE         = sDraw.size[3],$
    UNAME         = sDraw.uname,$
    RETAIN        = 2, $
    /BUTTON_EVENTS,$
    /MOTION_EVENTS)
    
  ;Scale Draw ------------------------------------------------------------------
  wScale = WIDGET_DRAW(BaseTab,$
    XOFFSET       = sScale.size[0],$
    YOFFSET       = sScale.size[1],$
    SCR_XSIZE     = sScale.size[2],$
    SCR_YSIZE     = sScale.size[3],$
    UNAME         = sScale.uname)
    
  ;Z range widgets -------------------------------------------------------------
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
    
  ;Color Scale Draw ------------------------------------------------------------
  wColorScale = WIDGET_DRAW(BaseTab,$
    XOFFSET   = sColorScale.size[0],$
    YOFFSET   = sColorScale.size[1],$
    SCR_XSIZE = sColorScale.size[2],$
    SCR_YSIZE = sColorScale.size[3],$
    UNAME     = sColorScale.uname)
    
  ;Linear / Logarithmic for 2D plot --------------------------------------------------------
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
    
  ;cw_bgroup of selection to make (none, counts vs Q .... etc) -----------------
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
    SET_VALUE = sSelectionGroup.set_value,$
    /NO_RELEASE,$
    /ROW)
    
  ;counts vs Q base ------------------------------------------------------------
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
