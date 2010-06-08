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

PRO make_gui_tab1, MAIN_TAB, MainTabSize, TabTitles, global

  ;- base ---------------------------------------------------------------------
  sTab1Base = { size  : MainTabSize,$
    title : TabTitles.tab1,$
    uname : 'base_tab1'}
    
  ;- label draw ---------------------------------------------------------------
  sLabelDraw = { size: [0,0,700,700],$
    uname: 'label_draw_uname'}
    
  ;- draw ---------------------------------------------------------------------
  IF ((*global).facility EQ 'LENS') THEN BEGIN
    XYoff = [30,20]
    xsize = 640L
    ysize = 640L
  ENDIF ELSE BEGIN
    XYoff = [0,0]
    xsize = 192L*3
    ysize = 256L*3
  ENDELSE
  sDraw = { size  : [XYoff[0], XYoff[1], xsize, ysize],$
    uname : 'draw_uname'}
    
  ;- nexus input --------------------------------------------------------------
  IF ((*global).facility EQ 'SNS') THEN BEGIN
    XYoff = [0,15]
  ENDIF ELSE BEGIN
    XYoff = [0,35]
  ENDELSE
  sNexus = { size : [10,$
    sDraw.size[1]+sDraw.size[3]+XYOff[1]]}
    
  ;- selection ----------------------------------------------------------------
  XYoff = [0,15]
  sSelection = { size: [sLabelDraw.size[0]+sLabelDraw.size[2]+XYoff[0],$
    XYoff[1],$
    305,$
    35],$
    value: 'ADVANCED SELECTION TOOL',$
    uname: 'selection_tool_button',$
    sensitive: 0}
    
  ;- Load Selection -----------------------------------------------------------
  XYoff = [0,15] ;frame
  sSelectionFrame = { size:  [sSelection.size[0]+XYoff[0],$
    sSelection.size[1]+sSelection.size[3]+XYoff[1],$
    sSelection.size[2],105],$
    frame: 1}
  XYoff = [10,-8] ;title
  sSelectionLabel = { size: [sSelectionFrame.size[0]+XYoff[0],$
    sSelectionFrame.size[1]+XYoff[1]],$
    value: 'Load Selection',$
    uname: 'load_selection_label',$
    sensitive: 1}
  XYoff = [5,10] ;browse button
  sSelectionBrowse = { size: [sSelectionFrame.size[0]+XYoff[0],$
    sSelectionFrame.size[1]+XYoff[1],$
    193],$
    value: 'BROWSE ...',$
    uname: 'selection_browse_button',$
    sensitive: 0}
  XYoff = [0,0] ;preview button
  sSelectionPreview = { size: [sSelectionBrowse.size[0]+$
    sSelectionBrowse.size[2]+XYoff[0],$
    sSelectionBrowse.size[1]+XYoff[1],$
    100],$
    value: 'PREVIEW',$
    uname: 'selection_preview_button',$
    sensitive: 0}
  XYoff = [0,30] ;file name text field
  sSelectionFileName = { size: [sSelectionBrowse.size[0]+XYoff[0],$
    sSelectionBrowse.size[1]+XYoff[1],$
    295],$
    value: '',$
    uname: 'selection_file_name_text_field'}
  XYoff = [0,35] ;load selection button
  sSelectionLoad = { size: [sSelectionBrowse.size[0]+XYoff[0],$
    sSelectionFileName.size[1]+XYoff[1],$
    sSelectionFileName.size[2]],$
    uname: 'selection_load_button',$
    value: 'L O A D  /  P L O T',$
    sensitive: 0 }
    
  ;Exclusion Region Selection tool --------------------------------------------
  XYoff = [0,20]
  sExclusionBase = { size: [sLabelDraw.size[0]+$
    sLabelDraw.size[2]+XYoff[0],$
    sSelectionFrame.size[1]+$
    sSelectionFrame.size[3]+XYoff[1],$
    300,310],$
    frame: 1,$
    sensitive: 0,$
    uname: 'exclusion_base'}
    
  XYoff = [10,-8]
  sExclusionTitle = { size: [sExclusionBase.size[0]+XYoff[0],$
    sExclusionBase.size[1]+XYoff[1]],$
    uname: 'exclusion_region_tool_title',$
    value: 'Exclusion Region (rectangle)'}
    
  XYoff = [8,10]                  ;PREVIEW button
  sPreviewExclusion = { size: [XYoff[0],$
    XYoff[1],$
    60],$
    value: 'PREVIEW',$
    uname: 'preview_exclusion_region',$
    sensitive: 0}
    
  XYoff = [0,0]                  ;PLOT button (Fast)
  sPlotExclusion = { size: [sPreviewExclusion.size[0]+$
    sPreviewExclusion.size[2]+XYoff[0],$
    sPreviewExclusion.size[1]+XYoff[1]],$
    value: 'SANSreduction_images/fast_selection.bmp',$
    tooltip: 'Fast Selection/Plot',$
    uname: 'plot_fast_exclusion_region'}
    
  XYoff = [67,0]                  ;PLOT button (Accurate)
  sPlotAccurateExclusion = { size: [sPlotExclusion.size[0]+XYoff[0],$
    sPlotExclusion.size[1]+XYoff[1]],$
    value: 'SANSreduction_images/accurate_selection.bmp',$
    tooltip: 'Accurate Selection/Plot',$
    uname: 'plot_accurate_exclusion_region'}
    
  XYoff = [135,0] ;CLEAR button
  sClearExclusion = { size: [sPlotExclusion.size[0]+$
    XYoff[0],$
    sPlotExclusion.size[1]+$
    XYoff[1],$
    90],$
    value: 'CLEAR INPUTS',$
    uname: 'clear_exclusion_input_boxes'}
    
  XYoff = [0,35] ;Center pixels title
  sCenterPixelTitle = { size: [sPreviewExclusion.size[0]+XYoff[0],$
    sPreviewExclusion.size[1]+XYoff[1]],$
    value: 'Center (Pix.)'}
  XYoff = [90,0] ;X: label
  sCenterXLabel = { size: [sCenterPixelTitle.size[0]+XYoff[0],$
    sCenterPixelTitle.size[1]+XYoff[1]],$
    value: 'X'}
  XYoff = [18,-6] ;X value
  sCenterXValue = { size: [sCenterXLabel.size[0]+XYoff[0],$
    sCenterXLabel.size[1]+XYoff[1],$
    60],$
    value: '',$
    uname: 'x_center_value'}
  XYoff = [20,0] ;Y: label
  sCenterYLabel = { size: [sCenterXValue.size[0]+$
    sCenterXValue.size[2]+XYoff[0],$
    sCenterPixelTitle.size[1]+XYoff[1]],$
    value: 'Y:'}
  XYoff = [15,-6]
  sCenterYValue = { size: [sCenterYLabel.size[0]+XYoff[0],$
    sCenterYLabel.size[1]+XYoff[1],$
    sCenterXValue.size[2]],$
    value: '',$
    uname: 'y_center_value'}
    
  ;Radii label ----------------------------------------------------------------
  XYoff = [0,35]
  sRadiiLabel = { size: [sCenterPixelTitle.size[0]+XYoff[0],$
    sCenterPixelTitle.size[1]+XYoff[1]],$
    value: 'Radii (Pix.)'}
  XYoff = [90,0] ;R1 label
  sRadiiR1Label = { size: [sRadiiLabel.size[0]+XYoff[0],$
    sRadiiLabel.size[1]+XYoff[1]],$
    value: 'R1'}
  XYoff = [18,-6] ;R1 value
  sRadiiR1Value = { size: [sRadiiR1Label.size[0]+XYoff[0],$
    sRadiiR1Label.size[1]+XYoff[1],$
    40],$
    value: '',$
    uname: 'r1_radii'}
  XYoff = [40,0] ;in/out base
  sRadiiR1Base = { size: [sRadiiR1Value.size[0]+XYoff[0],$
    sRadiiR1Value.size[1]+XYoff[1],$
    140,35],$
    frame: 0}
  XYoff = [0,0]
  sRadiiR1group = { size: [XYoff[0],$
    XYoff[1]],$
    list : ['Inside','Outside'],$
    uname: 'radii_r1_group',$
    value: 0.0}
    
  XYoff = [0,35] ;R2 label
  SradiiR2label = { size: [sRadiiR1Label.size[0]+XYoff[0],$
    sRadiiR1Label.size[1]+XYoff[1]],$
    value: 'R2'}
  XYoff = [18,-6] ;R2 value
  sRadiiR2Value = { size: [sRadiiR2Label.size[0]+XYoff[0],$
    sRadiiR2Label.size[1]+XYoff[1],$
    40],$
    value: '',$
    uname: 'r2_radii'}
  XYoff = [40,0] ;in/out base
  sRadiiR2Base = { size: [sRadiiR2Value.size[0]+XYoff[0],$
    sRadiiR2Value.size[1]+XYoff[1],$
    140,35],$
    frame: 0}
  XYoff = [0,0]
  sRadiiR2group = { size: [XYoff[0],$
    XYoff[1]],$
    list : ['Inside','Outside'],$
    uname: 'radii_r2_group',$
    value: 0.0}
    
  ;- Type of selection button -------------------------------------------------
  XYoff = [115,45]
  sExclusionTypeBase = { size: [sRadiiLabel.size[0]+XYoff[0],$
    sRadiiR2Value.size[1]+XYoff[1],$
    165],$
    uname: 'exclusion_type_base',$
    frame: 0}
    
  XYoff = [0,5]
  sTypeLabel = { size: [sradiiLabel.size[0]+XYoff[0],$
    sExclusionTypeBase.size[1]+XYoff[1]],$
    value: 'Type of Selection:'}
    
  XYoff = [-3,-9]
  SFrame = { size: [sRadiiLabel.size[0]+XYoff[0],$
    sTypeLabel.size[1]+XYoff[1],$
    285,35],$
    frame: 1,$
    value: ''}
    
  tooltip_array = ['A detector Pixel is part of the ' + $
    'selection if at least one Screen Pixel is touching ' + $
    'the selection',$
    'A detector Pixel is part of the ' + $
    'selection only if all the Screen Pixels are touching ' + $
    'the selection',$
    'A detector Pixel is part of the ' + $
    'selection if at least half of the Screen Pixels are ' + $
    'part of the selection.',$
    'A Detector Pixel is part of the ' + $
    'selection if more than half of the Screen Pixels are ' + $
    'part of the selection.']
    
  sButton1 = { uname:   'exclusion_half_in',$
    tooltip: tooltip_array[2],$
    value:   'SANSreduction_images/selection_half_in.bmp'}
    
  sButton2 = { uname:   'exclusion_half_out',$
    tooltip: tooltip_array[3],$
    value:   'SANSreduction_images/selection_half_out.bmp'}
    
  sButton3 = { uname:   'exclusion_outside_in',$
    tooltip: tooltip_array[0],$
    value:   'SANSreduction_images/selection_outside_in.bmp'}
    
  sButton4 = { uname:   'exclusion_outside_out',$
    tooltip: tooltip_array[1],$
    value:   'SANSreduction_images/selection_outside_out.bmp'}
    
  ;SAVE AS
  XYoff = [0,40]
  sSaveAsSelection = { size: [sPreviewExclusion.size[0]+XYoff[0],$
    sExclusionTypeBase.size[1]+XYoff[1],$
    140],$
    value: 'SAVE AS ...',$
    uname: 'save_as_roi_button',$
    sensitive: 1}
  ;SAVE
  XYoff = [5,0]
  sSaveSelection = { size: [sSaveAsSelection.size[0],$
    sSaveAsSelection.size[1],$
    285],$
    value: 'SAVE',$
    uname: 'save_roi_button',$
    sensitive: 1}
  ;SAVE folder button
  XYoff = [0,25]
  sSaveRoiFolderButton = { size: [sSaveAsSelection.size[0]+XYoff[0],$
    sSaveAsSelection.size[1]+XYoff[1],$
    285],$
    value: '~/',$
    uname: 'save_roi_folder_button',$
    sensitive: 1}
    
  ;SAVE text Field
  XYoff = [0,25]
  sSaveRoiTextField = { size: [sSaveRoiFolderButton.size[0]+XYoff[0],$
    sSaveRoiFolderButton.size[1]+XYoff[1],$
    285],$
    value: '',$
    uname: 'save_roi_text_field',$
    sensitive: 1}
    
  ;Preview Roi button
  XYoff = [0,35]
  sPreviewRoiButton = { size: [sSaveRoiTextField.size[0]+XYoff[0],$
    sSaveRoiTextField.size[1]+XYoff[1],$
    285],$
    value: 'PREVIEW ...',$
    uname: 'preview_roi_exclusion_file',$
    sensitive: 0}
    
  ;- Clear Selection ----------------------------------------------------------
  XYoff = [0,5]
  sClearSelection = { size: [sSelection.size[0]+XYoff[0],$
    sExclusionBase.size[1]+sExclusionBase.size[3]+ $
    XYoff[1],$
    152],$
    value: 'RESET SELECTION',$
    uname: 'clear_selection_button',$
    sensitive: 0}
    
  ;- REFRESH Plot -------------------------------------------------------------
  XYoff = [0,0]
  sRefreshPlot = { size: [sClearSelection.size[0]+XYoff[0]+$
    sClearSelection.size[2],$
    sClearSelection.size[1]+XYoff[1],$
    sClearSelection.size[2]],$
    value: 'REFRESH APPLICATION',$
    uname: 'refresh_plot_button',$
    sensitive: 0}
    
  ;- X and Y position of cursor -----------------------------------------------
  XYoff = [0,35]
  XYbase = { size: [sLabelDraw.size[0]+$
    sLabelDraw.size[2]+XYoff[0],$
    sRefreshPlot.size[1]+XYoff[1],$
    110,68],$  ;2:175, 3:68
    frame: 1,$
    uname: 'x_y_base'}
  XYoff = [5,3] ;x label
  
  IF ((*global).facility EQ 'LENS') THEN BEGIN
    x_value = 'X:'
    y_value = 'Y:'
  ENDIF ELSE BEGIN
    x_value = ' Tube #:'
    y_value = 'Pixel #:'
  ENDELSE
  
  xLabel = { size: [XYoff[0],$
    XYoff[1]],$
    value: x_value}
  XYoff = [27,0] ;x value
  xValue = { size: [xLabel.size[0]+XYoff[0],$
    xLabel.size[1]+XYoff[1]],$
    value: '           ',$
    uname: 'x_value'}
  XYoff = [0,20] ;y label
  yLabel = { size: [xLabel.size[0]+XYoff[0],$
    xLabel.size[1]+XYoff[1]],$
    value: y_value}
  XYoff = [0,0] ;y value
  yValue = { size: [xValue.size[0]+XYoff[0],$
    ylabel.size[1]+XYoff[1]],$
    value: '            ',$
    uname: 'y_value'}
    
  XYoff = [0,20]
  countsLabel = { size: [xLabel.size[0]+XYoff[0],$
    yValue.size[1]+XYoff[1]],$
    value: 'Counts :'}
  XYoff = [50,0]
  countsValue = { size: [countsLabel.size[0]+XYoff[0],$
    countsLabel.size[1]+XYoff[1]],$
    value: '          ',$
    uname: 'counts_value'}
    
  ;linear of log plot base and cw_bgroup
  XYoff = [0,5]
  sScaleTypeBase = { size: [XYbase.size[0]+XYoff[0],$
    XYbase.size[1]+XYbase.size[3]+XYoff[1]],$
    uname: 'z_axis_scale_base',$
    sensitive: 0}
    
  XYoff=[0,0]
  sScaleType = { size: [XYoff[0],$
    XYoff[1]],$
    title: 'Z-axis:',$
    value: 0.0,$
    list: ['linear','log'],$
    uname: 'z_axis_scale'}
    
  ;Selection and Plot color base ----------------------------------------------
  XYoff = [5,-2]
  sColorBase = { size: [XYbase.size[0]+XYbase.size[2]+XYoff[0],$
    XYbase.size[1]+XYoff[1],$
    240,50],$
    uname: 'color_base_uname',$
    frame: 0,$
    sensitive: 0}
  XYoff = [0,0]
  sSelectionColor = { size: [XYoff[0],$
    XYoff[1],$
    190],$
    value: 'Selection Color Tool ...',$
    uname: 'selection_color_button',$
    sensitive: 1}
    
  XYoff = [0,25]
  sPlotColor = { size: [sSelectionColor.size[0]+XYoff[0],$
    sSelectionColor.size[1]+XYoff[1],$
    sSelectionColor.size[2]],$
    value: 'Plot Color Tool ...',$
    uname: 'plot_color_button',$
    sensitive: 0}
    
  ;============================================================================
  ;= BUILD GUI ================================================================
  ;============================================================================
    
  ;- base ---------------------------------------------------------------------
  wTab1Base = WIDGET_BASE(MAIN_TAB,$
    UNAME     = sTab1Base.uname,$
    XOFFSET   = sTab1Base.size[0],$
    YOFFSET   = sTab1Base.size[1],$
    SCR_XSIZE = sTab1Base.size[2],$
    SCR_YSIZE = sTab1Base.size[3],$
    TITLE     = sTab1Base.title)
    
  IF ((*global).facility EQ 'SNS') THEN BEGIN
  
    circle_rectangle = WIDGET_BASE(wTab1Base,$
      UNAME = 'circle_rectangle_selection_shape_base',$
      XOFFSET = 895,$
      YOFFSET = 173,$
      FRAME = 0,$
      MAP = 0,$
      /ROW)
      
    rec = WIDGET_DRAW(circle_rectangle,$
      SCR_XSIZE = 30,$
      SCR_YSIZE = 30,$
      /BUTTON_EVENTS,$
      /TRACKING_EVENTS,$
      UNAME = 'tab1_rectangle_selection')
    cir = WIDGET_DRAW(circle_rectangle,$
      SCR_XSIZE = 30,$
      SCR_YSIZE = 30,$
      /BUTTON_EVENTS,$
      /TRACKING_EVENTS,$
      UNAME = 'tab1_circle_selection')
    sec = widget_draw(circle_rectangle, $
    scr_xsize = 30,$
    scr_ysize = 30,$
    /button_events, $
    /tracking_events,$
    uname = 'tab1_sector_selection')
      
    sector_base = widget_base(wTab1Base,$
      UNAME = 'tab1_sector_selection_base',$
      XOFFSET = 705,$
      YOFFSET = 209,$
      SCR_XSIZE = 290,$
      SCR_YSIZE = 175,$
      MAP = 0,$
      /COLUMN)
      
    circle_base = WIDGET_BASE(wTab1Base,$
      UNAME = 'tab1_circle_selection_base',$
      XOFFSET = 705,$
      YOFFSET = 209,$
      SCR_XSIZE = 290,$
      SCR_YSIZE = 175,$
      MAP = 0,$
      /COLUMN)
      
    row1 = WIDGET_BASE(circle_base,$
      /ROW)
    label = WIDGET_LABEL(row1,$
      VALUE  = '      Center')
    tube = WIDGET_LABEL(row1,$
      VALUE = '     Tube:')
    value = WIDGET_TEXT(row1,$
      VALUE = '',$
      XSIZE = 4,$
      /EDITABLE,$
      /ALIGN_LEFT,$
      UNAME = 'circle_tube_center')
    minus = WIDGET_BUTTON(row1,$
      VALUE = '-',$
      UNAME='circle_tube_center_minus')
    plus = WIDGET_BUTTON(row1,$
      VALUE='+',$
      UNAME = 'circle_tube_center_plus')
      
    row2 = WIDGET_BASE(circle_base,$
      /ROW)
    label = WIDGET_LABEL(row2,$
      VALUE  = '           ')
    tube = WIDGET_LABEL(row2,$
      VALUE = '     Pixel:')
    value = WIDGET_TEXT(row2,$
      VALUE = '',$
      XSIZE = 4,$
      /ALIGN_LEFT,$
      /EDITABLE,$
      UNAME = 'circle_pixel_center')
    minus = WIDGET_BUTTON(row2,$
      VALUE = '-',$
      UNAME='circle_pixel_center_minus')
    plus = WIDGET_BUTTON(row2,$
      VALUE='+',$
      UNAME = 'circle_pixel_center_plus')

    row3 = WIDGET_BASE(circle_base,$
      /ROW)
    label = WIDGET_LABEL(row3,$
      VALUE  = '    Radius  ')
    value = WIDGET_TEXT(row3,$
      VALUE = '',$
      XSIZE = 10,$
      /EDITABLE,$
      UNAME = 'circle_radius_value')
    units = WIDGET_LABEL(row3,$
      VALUE = 'mm')
    minus = WIDGET_BUTTON(row3,$
      VALUE = '--',$
      UNAME='circle_radius_center_2minus')
    minus = WIDGET_BUTTON(row3,$
      VALUE = '-',$
      UNAME='circle_radius_center_minus')
    plus = WIDGET_BUTTON(row3,$
      VALUE='+',$
      UNAME = 'circle_radius_center_plus')
    plus = WIDGET_BUTTON(row3,$
      VALUE='++',$
      UNAME = 'circle_radius_center_2plus')
    
   row4 = WIDGET_BASE(circle_base,$
   /ROW)
   help_button = WIDGET_BUTTON(row4,$
   VALUE = ' H E L P ',$
   UNAME = 'circle_exclusion_help')
   validate = WIDGET_BUTTON(row4,$
   VALUE = 'VALIDATE  SELECTION',$
   SCR_XSIZE = 215,$
   UNAME = 'circle_exclusion_validate') 

  ENDIF
  
  ;----------------------------------------------------------------------------
  ;- nexus input --------------------------------------------------------------
  sNexus = {MainBase:    wTab1Base,$
    xoffset:     sNexus.size[0],$
    yoffset:     sNexus.size[1],$
    instrument:  (*global).instrument,$
    facility:    (*global).facility}
  nexus_instance = OBJ_NEW('IDLloadNexus', sNexus)
  
  ;- draw ---------------------------------------------------------------------
  wDraw = WIDGET_DRAW(wTab1Base,$
    UNAME     = sDraw.uname,$
    XOFFSET   = sDraw.size[0],$
    YOFFSET   = sDraw.size[1],$
    SCR_XSIZE = sDraw.size[2],$
    SCR_YSIZE = sDraw.size[3],$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    /MOTION_EVENTS)
    
  IF ((*global).facility EQ 'LENS') THEN BEGIN
  
    ;- Label draw -------------------------------------------------------------
    wLabelDraw = WIDGET_DRAW(wTab1Base,$
      UNAME     = sLabelDraw.uname,$
      XOFFSET   = sLabelDraw.size[0],$
      YOFFSET   = sLabelDraw.size[1],$
      SCR_XSIZE = sLabelDraw.size[2],$
      SCR_YSIZE = sLabelDraw.size[3])
      
  ENDIF ELSE BEGIN
  
    bsBase = WIDGET_BASE(wTab1Base,$
      XOFFSET = 585,$
      YOFFSET = sDraw.size[1]+5,$
      SCR_XSIZE = 105,$
      /EXCLUSIVE, $
      /COLUMN,$
      FRAME = 1)
      
    front_bank = WIDGET_BUTTON(bsBase,$
      VALUE = 'FRONT PANEL',$
      /NO_RELEASE,$
      UNAME = 'show_front_bank_button')
      
    back_bank = WIDGET_BUTTON(bsBase,$
      VALUE = 'BACK PANEL',$
      /NO_RELEASE,$
      UNAME = 'show_back_bank_button')
      
    both_bank = WIDGET_BUTTON(bsBase,$
      VALUE = 'BOTH PANELS',$
      /NO_RELEASE,$
      UNAME = 'show_both_banks_button')
      
    WIDGET_CONTROL, both_bank, /SET_BUTTON
    
    ;linear/log scale
    wGroupBase = WIDGET_BASE(wTab1Base,$
      XOFFSET = 585,$
      YOFFSET = 103,$
      SCR_XSIZE = 105,$
      /ALIGN_CENTER,$
      FRAME = 1,$
      UNAME = sScaleTypeBase.uname,$
      SENSITIVE = sScaleTypeBase.sensitive,$
      /ROW)
      
    wGroup = CW_BGROUP(wGroupBase,$
      sScaleType.list,$
      ;    ROW         = 1,$
      SET_VALUE  = sScaleType.value,$
      UNAME      = sScaleType.uname,$
      LABEL_TOP = sScaleType.title,$
      /NO_RELEASE,$
      /EXCLUSIVE)
      
  ENDELSE
  
  IF ((*global).FACILITY EQ 'SNS') THEN BEGIN
  
    ;- X/Y base ---------------------------------------------------------------
    wXYbase = WIDGET_BASE(wTab1Base,$
      XOFFSET   = 585,$
      YOFFSET   = 205,$
      UNAME     = XYbase.uname,$
      /COLUMN,$
      FRAME     = XYbase.frame)
      
    label = WIDGET_LABEL(wXYbase,$
      VALUE = 'GLOBAL')
      
    ;bank number
    rowa = WIDGET_BASE(wXYbase,$
      /ROW)
    label = WIDGET_LABEL(rowa,$
      /ALIGN_LEFT,$
      VALUE = 'Bank #:')
    value = WIDGET_LABEL(rowa,$
      VALUE = 'N/A',$
      /ALIGN_LEFT,$
      UNAME = 'bank_number_value')
      
    ;row1 (Tube# or x#)
    row1 = WIDGET_BASE(wXYbase,$
      /ROW)
    wXlabel = WIDGET_LABEL(row1,$
      VALUE   = 'Tube #:',$
      /ALIGN_LEFT)
    wXvalue = WIDGET_LABEL(row1,$
      VALUE   = 'N/A',$
      /ALIGN_LEFT,$
      UNAME   = xValue.uname)
      
    label = WIDGET_LABEL(wXYbase,$
      VALUE = 'LOCAL')
      
    ;tube local
    rowb = WIDGET_BASE(wXYbase,$
      /ROW)
    label = WIDGET_LABEL(rowb,$
      VALUE = 'Tube  #:',$
      /ALIGN_LEFT)
    value = WIDGET_LABEL(rowb,$
      VALUE = 'N/A',$
      /ALIGN_LEFT,$
      UNAME = 'tube_local_number_value')
      
    ;row2 (Pixel# or y#)
    row2 = WIDGET_BASE(wXYbase,$
      /ROW)
    wYlabel = WIDGET_LABEL(row2,$
      VALUE   = 'Pixel #:',$
      /ALIGN_LEFT)
    wYvalue = WIDGET_LABEL(row2,$
      VALUE   = 'N/A',$
      /ALIGN_LEFT,$
      UNAME   = yValue.uname)
      
    ;row3 (Counts)
    wCountslabel = WIDGET_LABEL(wXYbase,$
      VALUE   = 'COUNTS')
    wCountsvalue = WIDGET_LABEL(wXYbase,$
      VALUE   = 'N/A',$
      SCR_XSIZE = 100,$
      UNAME   = countsValue.uname)
      
    ;Auto. Exclude Dead Tubes ;-----------------------------------
    auto_base = WIDGET_BASE(wTab1Base,$
      XOFFSET = 585,$
      YOFFSET = 403,$
      SCR_XSIZE = 105,$
      /COLUMN,$
      ;/BASE_ALIGN_CENTER, $
      /ALIGN_CENTER,$
      FRAME = 1)
      
    title = WIDGET_LABEL(auto_base,$
      VALUE = 'Automatically')
    title = WIDGET_LABEL(auto_base,$
      VALUE = 'exclude dead')
    title = WIDGET_LABEL(auto_base,$
      VALUE = 'tubes:')
      
    group = CW_BGROUP(auto_base,$
      ['Yes','No'],$
      /EXCLUSIVE,$
      /NO_RELEASE,$
      /ROW, $
      SET_VALUE = 0,$
      UNAME = 'exclude_dead_tube_auto')
      
  ENDIF
  
  ;TOF tools
  tof_tool = WIDGET_BUTTON(wTab1Base,$
    XOFFSET = 583,$
    YOFFSET = 505,$
    SCR_XSIZE = 117,$
    VALUE = 'TOF tools',$
    SENSITIVE = 0, $
    UNAME = 'tof_tools')
    
  ;  ;- Selection tool --------------------------------------------------------
  ;  wSelection = WIDGET_BUTTON(wTab1Base,$
  ;    XOFFSET   = sSelection.size[0],$
  ;    YOFFSET   = sSelection.size[1],$
  ;    SCR_XSIZE = sSelection.size[2],$
  ;    SCR_YSIZE = sSelection.size[3],$
  ;    VALUE     = sSelection.value,$
  ;    UNAME     = sSelection.uname,$
  ;    SENSITIVE = sSelection.sensitive)
    
  ;min and max value of main plot
  min_max_base = WIDGET_BASE(wTab1Base,$
    XOFFSET = sSelection.size[0],$
    YOFFSET = sSelection.size[1]-10,$
    SCR_XSIZE = 305,$
    SCR_YSIZE = 45,$
    /ROW,$
    UNAME = 'min_max_counts_displayed',$
    SENSITIVE = 0,$
    /BASE_ALIGN_CENTER,$
    FRAME = 1)
    
  label = WIDGET_LABEL(min_max_base,$
    VALUE = 'Counts:')
  min = WIDGET_LABEL(min_max_base,$
    VALUE = ' Min:')
  min_value = WIDGET_TEXT(min_max_base,$
    VALUE = 'N/A',$
    XSIZE = 7,$
    /EDITABLE, $
    UNAME = 'min_counts_displayed')
  max = WIDGET_LABEL(min_max_base,$
    VALUE = '  Max:')
  max_value = WIDGET_TEXT(min_max_base,$
    VALUE = 'N/A',$
    XSIZE = 7,$
    /EDITABLE, $
    UNAME = 'max_counts_displayed')
  reset = WIDGET_BUTTON(min_max_base,$
    VALUE = 'RESET',$
    UNAME = 'min_max_counts_reset_button')
    
  ;- Load Selection -----------------------------------------------------------
  ;Title
  wSelectionLabel = WIDGET_LABEL(wTab1Base,$
    XOFFSET   = sSelectionLabel.size[0],$
    YOFFSET   = sSelectionLabel.size[1],$
    VALUE     = sSelectionLabel.value,$
    SENSITIVE = sSelectionLabel.sensitive,$
    UNAME     = sSelectionLabel.uname)
    
  ;Browse button
  wSelectionBrowse = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sSelectionBrowse.size[0],$
    YOFFSET   = sSelectionBrowse.size[1],$
    SCR_XSIZE = sSelectionBrowse.size[2],$
    VALUE     = sSelectionBrowse.value,$
    UNAME     = sSelectionBrowse.uname,$
    SENSITIVE = sSelectionBrowse.sensitive)
    
  ;Preview button
  wSelectionPreview = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sSelectionPreview.size[0],$
    YOFFSET   = sSelectionPreview.size[1],$
    SCR_XSIZE = sSelectionPreview.size[2],$
    VALUE     = sSelectionPreview.value,$
    UNAME     = sSelectionPreview.uname,$
    SENSITIVE = sSelectionPreview.sensitive)
    
  ;Selection File Name
  wSelectionFileName = WIDGET_TEXT(wTab1Base,$
    XOFFSET   = sSelectionFileName.size[0],$
    YOFFSET   = sSelectionFileName.size[1],$
    SCR_XSIZE = sSelectionFileName.size[2],$
    UNAME     = sSelectionFileName.uname,$
    VALUE     = sSelectionFileName.value,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    /ALL_EVENTS)
    
  ;Load Button
  wSelectionLoad = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sSelectionLoad.size[0],$
    YOFFSET   = sSelectionLoad.size[1],$
    SCR_XSIZE = sSelectionLoad.size[2],$
    VALUE     = sSelectionLoad.value,$
    UNAME     = sSelectionLoad.uname,$
    SENSITIVE = sSelectionLoad.sensitive)
  ;Frame
  wSelectionFrame = WIDGET_LABEL(wTab1Base,$
    XOFFSET   = sSelectionFrame.size[0],$
    YOFFSET   = sSelectionFrame.size[1],$
    SCR_XSIZE = sSelectionFrame.size[2],$
    SCR_YSIZe = sSelectionFrame.size[3],$
    FRAME     = sSelectionFrame.frame,$
    VALUE     = '')
    
  ;Exclusion Region Label -----------------------------------------------------
  wExclusionTitle = WIDGET_LABEL(wTab1Base,$
    XOFFSET = sExclusionTitle.size[0],$
    YOFFSET = sExclusionTitle.size[1],$
    /ALIGN_LEFT,$
    UNAME   = sExclusionTitle.uname,$
    VALUE   = sExclusionTitle.value)
    
  ;Exclusion Region Base ------------------------------------------------------
  wExclusionBase = WIDGET_BASE(wTab1Base,$
    XOFFSET = sExclusionBase.size[0],$
    YOFFSET = sExclusionBase.size[1],$
    SCR_XSIZE = sExclusionBase.size[2],$
    SCR_YSIZE = sExclusionBase.size[3],$
    FRAME     = sExclusionBase.frame,$
    SENSITIVE = sExclusionBase.sensitive,$
    UNAME     = sExclusionBase.uname)
    
  IF ((*global).facility EQ 'LENS') THEN BEGIN
  
    ;PREVIEW Exclusion Button
    wPreviewExclusion = WIDGET_BUTTON(wExclusionBase,$
      XOFFSET   = sPreviewExclusion.size[0],$
      YOFFSET   = sPreviewExclusion.size[1],$
      SCR_XSIZE = sPreviewExclusion.size[2],$
      VALUE     = sPreviewExclusion.value,$
      UNAME     = sPreviewExclusion.uname,$
      SENSITIVE = sPreviewExclusion.sensitive)
    ;PLOT Fast Exclusion Button
    wPlotExclusion = WIDGET_BUTTON(wExclusionBase,$
      XOFFSET   = sPlotExclusion.size[0],$
      YOFFSET   = sPlotExclusion.size[1],$
      VALUE     = sPlotExclusion.value,$
      UNAME     = sPlotExclusion.uname,$
      TOOLTIP   = sPlotExclusion.tooltip,$
      /BITMAP,$
      /NO_RELEASE)
    ;PLOT Accurate Exclusion Button
    wPlotExclusion = WIDGET_BUTTON(wExclusionBase,$
      XOFFSET   = sPlotAccurateExclusion.size[0],$
      YOFFSET   = sPlotAccurateExclusion.size[1],$
      VALUE     = sPlotAccurateExclusion.value,$
      UNAME     = sPlotAccurateExclusion.uname,$
      TOOLTIP   = sPlotAccurateExclusion.tooltip,$
      /BITMAP,$
      /NO_RELEASE)
      
    ;CLEAR Exclusion Button
    wClearExclusion = WIDGET_BUTTON(wExclusionBase,$
      XOFFSET   = sClearExclusion.size[0],$
      YOFFSET   = sClearExclusion.size[1],$
      SCR_XSIZE = sClearExclusion.size[2],$
      VALUE     = sClearExclusion.value,$
      UNAME     = sClearExclusion.uname)
      
    ;Center (Pixels) label
    wCenterPixelTitle = WIDGET_LABEL(wExclusionBase,$
      XOFFSET = sCenterPixelTitle.size[0],$
      YOFFSET = sCenterPixelTitle.size[1],$
      VALUE   = sCenterPixelTitle.value)
      
    ;X label/value
    wCenterValue = WIDGET_TEXT(wExclusionBase,$
      XOFFSET   = sCenterXValue.size[0],$
      YOFFSET   = sCenterXValue.size[1],$
      SCR_XSIZE = sCenterXValue.size[2],$
      VALUE     = sCenterXValue.value,$
      UNAME     = sCenterXValue.uname,$
      /ALIGN_LEFT,$
      /EDITABLE)
    wCenterXLabel = WIDGET_LABEL(wExclusionBase,$
      XOFFSET = sCenterXLabel.size[0],$
      YOFFSET = sCenterXLabel.size[1],$
      VALUE   = sCenterXLabel.value)
      
    ;Y label/value
    wCenterValue = WIDGET_TEXT(wExclusionBase,$
      XOFFSET   = sCenterYValue.size[0],$
      YOFFSET   = sCenterYValue.size[1],$
      SCR_XSIZE = sCenterYValue.size[2],$
      VALUE     = sCenterYValue.value,$
      UNAME     = sCenterYValue.uname,$
      /ALIGN_LEFT,$
      /EDITABLE)
    wCenterYLabel = WIDGET_LABEL(wExclusionBase,$
      XOFFSET = sCenterYLabel.size[0],$
      YOFFSET = sCenterYLabel.size[1],$
      VALUE   = sCenterYLabel.value)
      
    ;Radii (Pixels) label
    wRadiiLabel = WIDGET_LABEL(wExclusionBase,$
      XOFFSET = sRadiiLabel.size[0],$
      YOFFSET = sRadiiLabel.size[1],$
      VALUE   = sRadiiLabel.value)
      
    ;R1 label/value
    wRadiiR1Value = WIDGET_TEXT(wExclusionBase,$
      XOFFSET   = sRadiiR1Value.size[0],$
      YOFFSET   = sRadiiR1Value.size[1],$
      SCR_XSIZE = sRadiiR1Value.size[2],$
      VALUE     = sRadiiR1Value.value,$
      UNAME     = sRadiiR1Value.uname,$
      /ALIGN_LEFT,$
      /EDITABLE)
    wRadiiR1Label = WIDGET_LABEL(wExclusionBase,$
      XOFFSET = sRadiiR1Label.size[0],$
      YOFFSET = sRadiiR1Label.size[1],$
      VALUE   = sRadiiR1Label.value)
      
    ;R1 IN/OUT base/group
    wRadiiR1Base = WIDGET_BASE(wExclusionBase,$
      XOFFSET   = sRadiiR1Base.size[0],$
      YOFFSET   = sRadiiR1Base.size[1],$
      SCR_XSIZE = sRadiiR1Base.size[2],$
      SCR_YSIZE = sRadiiR1Base.size[3],$
      FRAME     = sRadiiR1Base.frame)
    wRadiiR1Group = CW_BGROUP(wRadiiR1Base,$
      sRadiiR1group.list,$
      XOFFSET   = sRadiiR1group.size[0],$
      YOFFSET   = sRadiiR1group.size[1],$
      ROW       = 1,$
      SET_VALUE = sRadiiR1group.value,$
      UNAME     = sRadiiR1group.uname,$
      /NO_RELEASE,$
      /EXCLUSIVE)
      
    ;R2 label/value
    wRadiiR2Value = WIDGET_TEXT(wExclusionBase,$
      XOFFSET   = sRadiiR2Value.size[0],$
      YOFFSET   = sRadiiR2Value.size[1],$
      SCR_XSIZE = sRadiiR2Value.size[2],$
      VALUE     = sRadiiR2Value.value,$
      UNAME     = sRadiiR2Value.uname,$
      /ALIGN_LEFT,$
      /EDITABLE)
    wRadiiR2Label = WIDGET_LABEL(wExclusionBase,$
      XOFFSET = sRadiiR2Label.size[0],$
      YOFFSET = sRadiiR2Label.size[1],$
      VALUE   = sRadiiR2Label.value)
      
    ;R2 IN/OUT base/group
    wRadiiR2Base = WIDGET_BASE(wExclusionBase,$
      XOFFSET   = sRadiiR2Base.size[0],$
      YOFFSET   = sRadiiR2Base.size[1],$
      SCR_XSIZE = sRadiiR2Base.size[2],$
      SCR_YSIZE = sRadiiR2Base.size[3],$
      FRAME     = sRadiiR2Base.frame)
    wRadiiR2Group = CW_BGROUP(wRadiiR2Base,$
      sRadiiR2group.list,$
      XOFFSET   = sRadiiR2group.size[0],$
      YOFFSET   = sRadiiR2group.size[1],$
      ROW       = 1,$
      SET_VALUE = sRadiiR2group.value,$
      UNAME     = sRadiiR2group.uname,$
      /NO_RELEASE,$
      /EXCLUSIVE)
      
    ;Type of selection base and buttons ---------------------------------------
    wSelectionTypeBase = WIDGET_BASE(wExclusionBase,$
      SPACE     = 20,$
      UNAME     = sExclusionTypeBase.uname,$
      XOFFSET   = sExclusionTypeBase.size[0],$
      YOFFSET   = sExclusionTypeBase.size[1],$
      SCR_XSIZE = sExclusionTypeBase.size[2],$
      FRAME     = sExclusionTypeBase.frame,$
      /EXCLUSIVE,$
      /TOOLBAR,$
      /ROW)
      
    ;label
    wTypeLabel = WIDGET_LABEL(wExclusionBase,$
      XOFFSET = sTypeLabel.size[0],$
      YOFFSET = sTypeLabel.size[1],$
      VALUE   = sTypeLabel.value)
      
    wButton1 = WIDGET_BUTTON(wSelectionTypeBase,$
      VALUE   = sButton1.value,$
      TOOLTIP = sButton1.tooltip,$
      UNAME   = sButton1.uname,$
      /BITMAP,$
      /NO_RELEASE)
    wButton2 = WIDGET_BUTTON(wSelectionTypeBase,$
      VALUE   = sButton2.value,$
      TOOLTIP = sButton2.tooltip,$
      UNAME   = sButton2.uname,$
      /BITMAP,$
      /NO_RELEASE)
    wButton3 = WIDGET_BUTTON(wSelectionTypeBase,$
      VALUE   = sButton3.value,$
      TOOLTIP = sButton3.tooltip,$
      UNAME   = sButton3.uname,$
      /BITMAP,$
      /NO_RELEASE)
    wButton4 = WIDGET_BUTTON(wSelectionTypeBase,$
      VALUE   = sButton4.value,$
      TOOLTIP = sButton4.tooltip,$
      UNAME   = sButton4.uname,$
      /BITMAP,$
      /NO_RELEASE)
      
    WIDGET_CONTROL,  WIDGET_INFO(wSelectionTypeBase, /CHILD), /SET_BUTTON
    
    ;frame
    wFrame = WIDGET_LABEL(wExclusionBase,$
      XOFFSET   = sFrame.size[0],$
      YOFFSET   = sFrame.size[1],$
      SCR_XSIZE = sFrame.size[2],$
      SCR_YSIZE = sFrame.size[3],$
      VALUE     = sFrame.value,$
      FRAME     = sFrame.frame)
      
  ENDIF ELSE BEGIN
  
    xsize = 60
    ysize = 40
    xoff = 220
    yoff = 100
    
    frame = WIDGET_BASE(wExclusionBase,$
      XOFFSET = xoff -5,$
      YOFFSET = yoff -5,$
      SCR_XSIZE = xsize + 7,$
      SCR_YSIZE = 2*ysize + 12,$
      UNAME = 'selection_inside_outside_base_uname', $
      MAP = 0, $
      FRAME = 1)
      
    select_inside = WIDGET_DRAW(frame,$
      UNAME = 'selection_inside_draw_uname', $
      XOFFSET = 3,$
      YOFFSET = 3,$
      SCR_XSIZE = xsize,$
      SCR_YSIZE = ysize, $
      /BUTTON_EVENTS,$
      /TRACKING_EVENTS)
      
    select_outside = WIDGET_DRAW(frame,$
      UNAME = 'selection_outside_draw_uname', $
      XOFFSET = 3,$
      YOFFSET = 3 + ysize + 5,$
      SCR_XSIZE = xsize,$
      SCR_YSIZE = ysize, $
      /BUTTON_EVENTS,$
      /TRACKING_EVENTS)
      
    base = WIDGET_BASE(wExclusionBase,$
      /COLUMN)
      
    space = WIDGET_LABEL(base,$
      VALUE = '')
      
    row1 = WIDGET_BASE(base,$
      /ROW)
    value = CW_FIELD(row1,$
      VALUE = '1',$
      TITLE = '  Tube # of 1st corner : ',$
      XSIZE = 4,$
      /RETURN_EVENTS,$
      UNAME = 'corner_pixel_x0',$
      /INTEGER)
    label = WIDGET_LABEL(row1,$
      VALUE = '(1-192)')
      
    row2= WIDGET_BASE(base,$
      /ROW)
    value = CW_FIELD(row2,$
      VALUE = '0',$
      XSIZE = 4,$
      /RETURN_EVENTS,$
      TITLE = '  Pixel # of 1st corner: ',$
      UNAME = 'corner_pixel_y0',$
      /INTEGER)
    value = WIDGET_LABEL(row2,$
      VALUE = '(0-255)')
      
    value = CW_FIELD(base,$
      VALUE = '1',$
      XSIZE = 4,$
      /RETURN_EVENTS,$
      TITLE = '  Width (# of tubes)  : ',$
      UNAME = 'corner_pixel_width',$
      /INTEGER)
      
    value = CW_FIELD(base,$
      VALUE = '1',$
      XSIZE = 4,$
      /RETURN_EVENTS,$
      TITLE = '  Height (# of pixels): ',$
      UNAME = 'corner_pixel_height',$
      /INTEGER)
      
  ENDELSE
  
  ;SAVE AS
  ;  wSaveAsSelection = WIDGET_BUTTON(wExclusionBase,$
  ;    XOFFSET   = sSaveAsSelection.size[0],$
  ;    YOFFSET   = sSaveAsSelection.size[1],$
  ;    SCR_XSIZE = sSaveAsSelection.size[2],$
  ;    VALUE     = sSaveAsSelection.value,$
  ;    UNAME     = sSaveAsSelection.uname,$
  ;   SENSITIVE = sSaveAsSelection.sensitive)
  
  ;SAVE
  wSaveSelection = WIDGET_BUTTON(wExclusionBase,$
    XOFFSET   = sSaveSelection.size[0],$
    YOFFSET   = sSaveSelection.size[1],$
    SCR_XSIZE = sSaveSelection.size[2],$
    VALUE     = sSaveSelection.value,$
    UNAME     = sSaveSelection.uname,$
    SENSITIVE = sSaveSelection.sensitive)
  ;SAVE Folder
  wSaveroifolderbutton = WIDGET_BUTTON(wExclusionBase,$
    XOFFSET   = sSaveroifolderbutton.size[0],$
    YOFFSET   = sSaveroifolderbutton.size[1],$
    SCR_XSIZE = sSaveroifolderbutton.size[2],$
    VALUE     = sSaveroifolderbutton.value,$
    UNAME     = sSaveroifolderbutton.uname,$
    SENSITIVE = sSaveroifolderbutton.sensitive)
    
  ;Filename
  wSaveFileName = WIDGET_TEXT(wExclusionBase,$
    XOFFSET = sSaveRoiTextField.size[0],$
    YOFFSET = sSaveRoiTextField.size[1],$
    SCR_XSIZE = sSaveRoiTextField.size[2],$
    VALUE     = sSaveRoiTextfield.value,$
    UNAME     = sSaveRoiTextField.uname,$
    SENSITIVE = sSaveRoiTextField.sensitive,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    /ALL_EVENTS)
    
  ;Preview
  wPreviewRoiButton = WIDGET_BUTTON(wExclusionBase,$
    XOFFSET   = spreviewroibutton.size[0],$
    YOFFSET   = spreviewroibutton.size[1],$
    SCR_XSIZE = spreviewroibutton.size[2],$
    VALUE     = spreviewroibutton.value,$
    UNAME     = spreviewroibutton.uname,$
    SENSITIVE = spreviewroibutton.sensitive)
    
  ;- Clear Selection ----------------------------------------------------------
  wClearSelection = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sClearSelection.size[0],$
    YOFFSET   = sClearSelection.size[1],$
    SCR_XSIZE = sClearSelection.size[2],$
    VALUE     = sClearSelection.value,$
    UNAME     = sClearSelection.uname,$
    SENSITIVE = sClearSelection.sensitive)
    
  ;- Refresh Plot -------------------------------------------------------------
  wRefreshplot = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sRefreshplot.size[0],$
    YOFFSET   = sRefreshplot.size[1],$
    SCR_XSIZE = sRefreshplot.size[2],$
    VALUE     = sRefreshplot.value,$
    UNAME     = sRefreshplot.uname,$
    SENSITIVE = sRefreshplot.sensitive)
    
  IF ((*global).FACILITY EQ 'LENS') THEN BEGIN
  
    ;- X/Y base ---------------------------------------------------------------
    wXYbase = WIDGET_BASE(wTab1Base,$
      XOFFSET   = 710,$
      YOFFSET   = 587,$
      ;    SCR_XSIZE = 80,$
      UNAME     = XYbase.uname,$
      /COLUMN,$
      FRAME     = XYbase.frame)
      
    ;row1 (Tube# or x#)
    row1 = WIDGET_BASE(wXYbase,$
      /ROW)
    wXlabel = WIDGET_LABEL(row1,$
      VALUE   = 'Tube (global):')
    wXvalue = WIDGET_LABEL(row1,$
      VALUE   = 'N/A',$
      /ALIGN_LEFT,$
      UNAME   = xValue.uname)
      
    ;row2 (Pixel# or y#)
    row2 = WIDGET_BASE(wXYbase,$
      /ROW)
    wYlabel = WIDGET_LABEL(row2,$
      VALUE   = 'Pixel #:')
    wYvalue = WIDGET_LABEL(row2,$
      VALUE   = 'N/A',$
      /ALIGN_LEFT,$
      UNAME   = yValue.uname)
      
    ;row3 (Counts)
    row3 = WIDGET_BASE(wXYbase,$
      /ROW)
    wCountslabel = WIDGET_LABEL(row3,$
      VALUE   = 'Counts: ')
    wCountsvalue = WIDGET_LABEL(row3,$
      VALUE   = 'N/A          ',$
      UNAME   = countsValue.uname,$
      /ALIGN_LEFT)
      
  ENDIF
  
  ;Transmission and beam center calculation buttons
  IF ((*global).facility EQ 'SNS') THEN BEGIN
  
    ;counts vs tof preview plot
    IvsTOF = WIDGET_DRAW(wTab1Base,$
      XOFFSET = 585,$
      YOFFSET = 535,$
      SCR_XSIZE = 420,$
      SCR_YSIZE = 190,$
      ;    /TRACKING_EVENTS, $
      /MOTION_EVENTS, $
      UNAME = 'counts_vs_tof_preview_plot')
      
    Tran_BC_base = WIDGET_BASE(wTab1Base,$
      XOFFSET = 585,$
      YOFFSET = 730,$
      UNAME = 'transmission_launcher_base',$
      MAP = 0, $
      /ROW)
      
    ;Transmission calculation button
    xsize = 200
    ysize = 40
    button1 = WIDGET_DRAW(Tran_BC_base,$
      SCR_XSIZE = xsize,$
      SCR_YSIZE = ysize,$
      TOOLTIP = 'Launch the Transmission Calculation Program ...',$
      SENSITIVE = 1,$
      /BUTTON_EVENTS,$
      /TRACKING_EVENTS,$
      UNAME = 'transmission_calculation_button')
      
    space = WIDGET_LABEL(Tran_BC_base,$
      VALUE = '')
      
    ;beam center calculation
    button2 = WIDGET_DRAW(Tran_BC_base,$
      SCR_XSIZE = xsize,$
      SCR_YSIZE = ysize,$
      SENSITIVE = 1,$
      /BUTTON_EVENTS,$
      /TRACKING_EVENTS,$
      UNAME = 'beam_center_calculation_button')
      
    ;linear/log scale
    wGroupBase = WIDGET_BASE(wTab1Base,$
      XOFFSET = 890,$
      YOFFSET = 585,$
      UNAME = sScaleTypeBase.uname,$
      SENSITIVE = sScaleTypeBase.sensitive,$
      /COLUMN)
      
    wGroup = CW_BGROUP(wGroupBase,$
      sScaleType.list,$
      SET_VALUE  = sScaleType.value,$
      UNAME      = sScaleType.uname,$
      LABEL_TOP = sScaleType.title,$
      /NO_RELEASE,$
      /EXCLUSIVE)
      
  ENDIF
  
;  ;Selection Color Tool
;  wColorBase = WIDGET_BASE(wTab1Base,$
;    XOFFSET   = sColorBase.size[0]-63,$
;    YOFFSET   = sColorBase.size[1],$
;    FRAME     = sColorBase.frame,$
;    SENSITIVE = sColorBase.sensitive,$
;    UNAME     = sColorBase.uname,$
;    /COLUMN)
;
;  wSelectionColor = WIDGET_BUTTON(wcolorBase,$
;    SCR_XSIZE = sSelectionColor.size[2]+58,$
;    UNAME     = sSelectionColor.uname,$
;    VALUE     = sSelectionColor.value)
  
END
