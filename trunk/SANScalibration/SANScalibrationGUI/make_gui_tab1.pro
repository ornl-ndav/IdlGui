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
    
  ;- nexus input --------------------------------------------------------------
  XYoff = [0,60]
  sNexus = { size : [10,$
    sLabelDraw.size[1]+sLabelDraw.size[3]+XYOff[1]]}
    
  ;- draw ---------------------------------------------------------------------
  XYoff = [30,10]
  sDraw = { size  : [XYoff[0],XYoff[1],640,640],$
    uname : 'draw_uname'}
    
  ;range of tof plotted -------------------------------------------------------
  XYoff = [10,5]
  sTofRangeBase = { size: [sLabelDraw.size[0]+XYoff[0],$
    sLabelDraw.size[1]+$
    sLabelDraw.size[3]+XYoff[1],$
    MainTabSize[2]-25,$
    40],$
    frame: 1,$
    sensitive: 0,$
    uname: 'tof_range_base'}
  XYoff = [20,-8]
  sTofRangeLabel = { size: [sTofRangeBase.size[0]+XYoff[0],$
    sTofRangeBase.size[1]+XYoff[1]],$
    value: 'Range of TOF displayed (microseconds)'}
    
  ;automatic or user defined mode ---------------------------------------------
  XYoff = [10,5]
  sTofCwbgroup = { size: [XYoff[0],$
    XYoff[1]],$
    list: ['Full Range',$
    'User Defined Range'],$
    uname: 'tof_range_cwbgroup',$
    value: 0}
    
  ;manual tof mode base -------------------------------------------------------
  XYoff = [245,1]
  sTofManualBase = { size: [XYoff[0],$
    XYoff[1],$
    335,35],$
    uname: 'tof_manual_base',$
    sensitive: 0,$
    frame: 1}
    
  ;min tof (label/value)
  XYoff = [0,0]
  sTofMinCwfield = { xsize: 6,$
    uname: 'tof_range_min_cw_field',$
    label: 'Min TOF',$
    base: { size: [XYoff[0],$
    XYoff[1]]}}
    
  ;max tof (label/value)
  XYoff = [110,0]
  sTofMaxCwfield = { xsize: 6,$
    uname: 'tof_range_max_cw_field',$
    label: 'Max TOF',$
    base: { size: [sTofMinCwfield.base.size[0]+XYoff[0],$
    XYoff[1]]}}
    
  ;reset button
  XYoff = [115,5]
  sTofReset = { size: [XYoff[0],$
    XYoff[1],$
    100],$
    value: 'RESET RANGE',$
    uname: 'tof_reset_range'}
    
  ;play button
  XYoff = [10,0]
  sPlayButton = { size: [sTofManualBase.size[0]+$
    sTofManualBase.size[2]+$
    XYoff[0],$
    XYoff[1],$
    40,40],$
    value: 'SANScalibration_images/play_button.bmp',$
    uname: 'tof_play_button'}
    
  ;time/frame label/value
  XYoff = [5,0]
  sTpFlabel = { size: [sTofManualBase.size[0]+$
    sTofManualBase.size[2]+$
    XYoff[0],$
    sTofManualBase.size[1]+$
    XYoff[1]],$
    value: ' Time/Frame'}
  XYoff = [10,10]
  sTpFvalue = { size: [sTpFlabel.size[0]+XYoff[0],$
    sTpFlabel.size[1]+XYoff[1],$
    60],$
    value: '0.5',$
    uname: 'tof_time_per_frame_value'}
    
  ;bin/frame label/value
  XYoff = [90,0]
  sBpFlabel = { size: [sTpFlabel.size[0]+$
    XYoff[0],$
    sTpFlabel.size[1]+$
    XYoff[1]],$
    value: 'Bin/Frame'}
  XYoff = [0,0]
  sBpFvalue = { size: [sBpFlabel.size[0]+XYoff[0],$
    sTpFvalue.size[1]+XYoff[1],$
    60],$
    value: '50',$
    uname: 'tof_bin_per_frame_value'}
    
  ;Max Nbr bin
  XYoff = [75,0]
  sMaxBinLabel = { size: [sBpFlabel.size[0]+$
    XYoff[0],$
    sBpFlabel.size[1]+$
    XYoff[1]],$
    value: 'Max Bin'}
  XYoff = [0,7]
  sMaxBinValue = { size: [sMaxBinLabel.size[0]+$
    XYoff[0],$
    sBpFvalue.size[1]+$
    XYoff[1]],$
    uname: 'tof_max_value',$
    frame: 1,$
    value: '      '}
    
  ;bin# (label/value)
  XYoff = [60,0]
  sBinNbr = { size: [sMaxBinLabel.size[0]+XYoff[0],$
    sMaxBinLabel.size[1]+XYoff[1]],$
    value: 'Bins:'}
  XYoff = [35,0]
  sBinNbrValue = { size: [sBinNbr.size[0]+XYoff[0],$
    sBinNbr.size[1]+XYoff[1],$
    145],$
    value: 'N/A       ',$
    frame: 0,$
    uname: 'bin_range_value'}
    
  ;tof range (label/value)
  XYoff = [0,20]
  sTOFrange = { size: [sBinNbr.size[0]+XYoff[0],$
    sBinNbr.size[1]+XYoff[1]],$
    value: 'TOFs:'}
  XYoff = [0,0]
  sTOFrangeValue = { size: [sBinNbrValue.size[0]+XYoff[0],$
    sTOFrange.size[1]+XYoff[1],$
    sBinNbrValue.size[2]],$
    value: 'N/A           ',$
    frame: 0,$
    uname: 'tof_range_value'}
    
  ;----------------------------------------------------------------------------
  ;Transmission or Background mode --------------------------------------------
  XYoff = [0,10]
  sModeBase = { size: [sLabelDraw.size[0]+sLabelDraw.size[2]+XYoff[0],$
    XYoff[1],$
    300,45],$
    frame: 4}
  XYoff = [0,5] ;cw_bgroup
  sModeGroup = { size: [XYoff[0],$
    XYoff[1]],$
    value: 0.0,$
    uname: 'mode_group_uname',$
    title: 'Operation Mode:',$
    list:  ['Transmission','Background']}
    
  ;- selection ----------------------------------------------------------------
  XYoff = [0,15]
  sSelection = { size: [sModeBase.size[0]+XYoff[0],$
    sModeBase.size[1]+sModeBase.size[3]+XYoff[1],$
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
    value: 'Exclusion Region Selection Tool'}
    
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
    value: 'SANScalibration_images/fast_selection.bmp',$
    tooltip: 'Fast Selection/Plot',$
    uname: 'plot_fast_exclusion_region'}
    
  XYoff = [67,0]                  ;PLOT button (Accurate)
  sPlotAccurateExclusion = { size: [sPlotExclusion.size[0]+XYoff[0],$
    sPlotExclusion.size[1]+XYoff[1]],$
    value: 'SANScalibration_images/accurate_selection.bmp',$
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
    
  ;- Rectangle Selection tool -------------------------------------------------
  XYoff = [83,30]
  sRectangleBase1 = { size: [sPreviewExclusion.size[0]+XYoff[0],$
    sPreviewExclusion.size[1]+XYoff[1],$
    200,105],$
    frame: 0,$
    uname: 'rectangle_base_part_1',$
    map:   0}
  XYoff = [0,0] ;label of rectangle selection
  message = 'Left click first corner of rectangle and whithout releasing' + $
    ' the mouse, move mouse to opposite corner.'
  sRectangleText = { size: [XYoff[0],$
    XYoff[1],$
    200,$
    70],$
    value: message}
  XYoff = [20,0]
  sRectangleInOutBase = { size: [sRectangleText.size[0]+XYoff[0],$
    sRectangleText.size[1]+$
    sRectangleText.size[3]+XYoff[1],$
    150,30],$
    frame: 0}
    
  sRectangleInOutGroup =  {list: ['Inside','Outside'],$
    uname: 'rectangle_in_out_group',$
    value: 0.0}
    
  XYoff = [0,30]
  sRectangleBase2 = { size: [sPreviewExclusion.size[0]+XYoff[0],$
    sPreviewExclusion.size[1]+XYoff[1],$
    80,60],$
    frame: 0,$
    uname: 'rectangle_base_part_2',$
    map:   0}
  XYoff = [20,20]
  sRectangleHelp = { size: [XYoff[0],$
    XYoff[1]],$
    value: 'HELP ->'}
    
  ;- Circle selection tool ----------------------------------------------------
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
    
  ;Rectangle or Circle selection ----------------------------------------------
  XYoff = [0,-5]
  sRectCircleBase = { size: [sRadiiLabel.size[0]+XYoff[0],$
    sRadiiR2Value.size[1]+XYoff[1],$
    77,35],$
    frame: 1}
  sCircleButton = { value: 'SANScalibration_images/circle_in_out.bmp',$
    uname: 'circle_in_out_button',$
    tooltip: 'Circle Selection Tool'}
    
  sRectButton = { value: 'SANScalibration_images/rectangle_in_out.bmp',$
    uname: 'rectangle_in_out_button',$
    tooltip: 'Rectangle Selection Tool'}
    
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
    value:   'SANScalibration_images/selection_half_in.bmp'}
    
  sButton2 = { uname:   'exclusion_half_out',$
    tooltip: tooltip_array[3],$
    value:   'SANScalibration_images/selection_half_out.bmp'}
    
  sButton3 = { uname:   'exclusion_outside_in',$
    tooltip: tooltip_array[0],$
    value:   'SANScalibration_images/selection_outside_in.bmp'}
    
  sButton4 = { uname:   'exclusion_outside_out',$
    tooltip: tooltip_array[1],$
    value:   'SANScalibration_images/selection_outside_out.bmp'}
    
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
  sSaveSelection = { size: [sSaveAsSelection.size[0]+$
    sSaveAsSelection.size[2]+XYoff[0],$
    sSaveAsSelection.size[1]+XYoff[1],$
    sSaveAsSelection.size[2]],$
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
  XYoff = [-1,10]
  sClearSelection = { size: [sSelection.size[0]+XYoff[0],$
    sExclusionBase.size[1]+sExclusionBase.size[3]+ $
    XYoff[1],$
    153],$
    value: 'RESET SELECTION',$
    uname: 'clear_selection_button',$
    sensitive: 1}
    
  ;- REFRESH Plot -------------------------------------------------------------
  XYoff = [0,0]
  sRefreshPlot = { size: [sClearSelection.size[0]+$
    sClearSelection.size[2]+XYoff[0],$
    sClearSelection.size[1]+XYoff[1],$
    sClearSelection.size[2]],$
    value: 'REFRESH PLOT',$
    uname: 'refresh_plot_button',$
    sensitive: 1}
    
  ;- X and Y position of cursor -----------------------------------------------
  XYoff = [0,30]
  XYbase = { size: [sLabelDraw.size[0]+$
    sLabelDraw.size[2]+XYoff[0],$
    sClearSelection.size[1]+XYoff[1],$
    110,70],$  ;68
    frame: 1,$
    uname: 'x_y_base'}
  XYoff = [5,3] ;x label
  xLabel = { size: [XYoff[0],$
    XYoff[1]],$
    value: 'X:'}
  XYoff = [20,3] ;x value
  xValue = { size: [XYoff[0],$
    XYoff[1]],$
    value: '   ',$
    uname: 'x_value'}
  XYoff = [0,20] ;y label
  yLabel = { size: [xLabel.size[0]+XYoff[0],$
    xLabel.size[1]+XYoff[1]],$
    value: 'Y:'}
  XYoff = [0,0] ;y value
  yValue = { size: [xValue.size[0]+XYoff[0],$
    ylabel.size[1]+XYoff[1]],$
    value: '   ',$
    uname: 'y_value'}
    
  XYoff = [0,20]
  countsLabel = { size: [xLabel.size[0]+XYoff[0],$
    yValue.size[1]+XYoff[1]],$
    value: 'Counts:'}
  XYoff = [50,0]
  countsValue = { size: [countsLabel.size[0]+XYoff[0],$
    countsLabel.size[1]+XYoff[1]],$
    value: '          ',$
    uname: 'counts_value'}
    
  ;- Counts vs tof button -----------------------------------------------------
  XYoff = [5,-1]
  sCountsTofButton1 = { size: [XYbase.size[0]+$
    XYbase.size[2]+$
    XYoff[0],$
    XYbase.size[1]+XYoff[1],$
    190],$
    sensitive: 0,$
    value: 'COUNTS VS TOF (full detector)',$
    uname: 'counts_vs_tof_full_detector_button'}
    
  XYoff = [0,25]
  sCountsTofButton2 = { size: [sCountsTofButton1.size[0]+XYoff[0],$
    sCountsTofButton1.size[1]+XYoff[1],$
    sCountsTofButton1.size[2]],$
    sensitive: 0,$
    value: 'COUNTS VS TOF (selection)',$
    uname: 'counts_vs_tof_selection_button'}
    
  sCountsTofButton3 = { size: [sCountsTofButton1.size[0]+XYoff[0],$
    sCountsTofButton2.size[1]+XYoff[1],$
    sCountsTofButton1.size[2]],$
    sensitive: 0,$
    value: 'COUNTS VS TOF (monitor)',$
    uname: 'counts_vs_tof_monitor_button'}
    
  ;============================================================================
  ;play, pause, stop base -----------------------------------------------------
  XYoff = [0,3]
  sPlayBase = { size: [XYbase.size[0]+XYoff[0],$
    XYbase.size[1]+XYbase.size[3]+XYoff[1],$
    140,30],$
    uname: 'play_base',$
    map: 0,$
    frame: 0}
    
  ;previous green (draw)
  sAdvancedPreviousButton = { uname: 'previous_button',$
    size: [0,0,30,30],$
    tooltip: 'Move to previous frame'}
  ;play button (draw)
  sAdvancedPlayButton = { uname: 'play_button',$
    size: [0,0,29,30],$
    tooltip: 'Play the movie'}
  ;pause button (draw)q
  sAdvancedPauseButton = { uname: 'pause_button',$
    size: [0,0,29,30],$
    tooltip: 'Pause the movie'}
  ;stop button (draw)
  sAdvancedStopButton = { uname: 'stop_button',$
    size: [0,0,29,30],$
    tooltip: 'Stop the movie'}
  ;next green (draw)
  sAdvancedNextButton = { uname: 'next_button',$
    size: [0,0,30,30],$
    tooltip: 'Move to next frame'}
    
  ;============================================================================
    
  ;linear of log plot base and cw_bgroup
  XYoff = [158,0]
  sScaleTypeBase = { size: [XYbase.size[0]+XYoff[0],$
    XYbase.size[1]+XYbase.size[3]+XYoff[1]],$
    uname: 'z_axis_scale_base',$
    sensitive: 0}
    
  XYoff=[0,0]
  sScaleType = { size: [XYoff[0],$
    XYoff[1]],$
    title: 'Z-axis:',$
    value: 0.0,$
    list: ['lin','log'],$
    uname: 'z_axis_scale'}
    
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
    
  ;----------------------------------------------------------------------------
  ;- nexus input --------------------------------------------------------------
  sNexus = {MainBase:    wTab1Base,$
    xoffset:     sNexus.size[0],$
    yoffset:     sNexus.size[1],$
    instrument:  'SANS',$
    facility:    'LENS'}
  nexus_instance = OBJ_NEW('IDLloadNexus', sNexus)
  
  ;- draw ---------------------------------------------------------------------
  wDraw = WIDGET_DRAW(wTab1Base,$
    UNAME     = sDraw.uname,$
    XOFFSET   = sDraw.size[0],$
    YOFFSET   = sDraw.size[1],$
    SCR_XSIZE = sDraw.size[2],$
    SCR_YSIZE = sDraw.size[3],$
    /BUTTON_EVENTS,$
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
      XOFFSET = sDraw.size[0],$
      YOFFSET = sDraw.size[1]+sDraw.size[3]+5,$
      /EXCLUSIVE, $
      /ROW,$
      FRAME = 1)
      
    front_bank = WIDGET_BUTTON(bsBase,$
      VALUE = 'Show Front Bank   ',$
      UNAME = 'show_front_bank_button')
      
    back_bank = WIDGET_BUTTON(bsBase,$
      VALUE = 'Show Back Bank   ',$
      UNAME = 'show_back_bank_button')
      
    both_bank = WIDGET_BUTTON(bsBase,$
      VALUE = 'Show Front and Back Banks',$
      UNAME = 'show_both_banks_button')
      
    WIDGET_CONTROL, both_bank, /SET_BUTTON
    
  ENDELSE
  
  ;range of tof plotted -------------------------------------------------------
  wTofRangeLabel = WIDGET_LABEL(wTab1Base,$
    XOFFSET = sTofRangeLabel.size[0],$
    YOFFSET = sTofRangeLabel.size[1],$
    VALUE   = sTofRangeLabel.value)
    
  wTofRangeBase = WIDGET_BASE(wTab1Base,$
    XOFFSET   = sTofRangeBase.size[0],$
    YOFFSET   = sTofRangeBase.size[1],$
    SCR_XSIZE = sTofRangeBase.size[2],$
    SCR_YSIZE = sTofRangeBase.size[3],$
    FRAME     = sTofRangeBase.frame,$
    SENSITIVE = sTOFRangeBase.sensitive,$
    UNAME     = sTofRangeBase.uname)
    
  wTofCwbGroup = CW_BGROUP(wTofRangeBase,$
    sTofCwbGroup.list,$
    XOFFSET    = sTofCwbGroup.size[0],$
    YOFFSET    = sTofCwbGroup.size[1],$
    ROW        = 1,$
    SET_VALUE  = sTofCwbGroup.value,$
    UNAME      = sTofCwbGroup.uname,$
    /NO_RELEASE,$
    /EXCLUSIVE)
    
  ;manual tof mode base -------------------------------------------------------
  wTofManualBase = WIDGET_BASE(wTofRangeBase,$
    XOFFSET   = sTofManualBase.size[0],$
    YOFFSET   = sTofManualBase.size[1],$
    SCR_XSIZE = sTofManualBase.size[2],$
    SCR_YSIZE = sTofManualBase.size[3],$
    UNAME     = sTofManualBase.uname,$
    SENSITIVE = sTofManualBase.sensitive,$
    FRAME     = sTofManualBase.frame)
    
  ;min tof (base/cw_field)
  wTofMinBase = WIDGET_BASE(wTofManualBase,$
    XOFFSET = sTofMinCwfield.base.size[0],$
    YOFFSET = sTofMinCwfield.base.size[1])
    
  wTofMinCwfield = CW_FIELD(wTofMinBase,$
    TITLE = sTofMinCwfield.label,$
    XSIZE = sTofMinCwfield.xsize,$
    VALUE = '',$
    UNAME = sTofMinCwfield.uname,$
    /LONG,$
    /RETURN_EVENTS)
    
  ;max tof (base/cw_field)
  wTofMaxBase = WIDGET_BASE(wTofManualBase,$
    XOFFSET = sTofMaxCwfield.base.size[0],$
    YOFFSET = sTofMaxCwfield.base.size[1])
    
  wTofMaxCwfield = CW_FIELD(wTofMaxBase,$
    TITLE = sTofMaxCwfield.label,$
    XSIZE = sTofMaxCwfield.xsize,$
    VALUE = '',$
    UNAME = sTofMaxCwfield.uname,$
    /LONG,$
    /RETURN_EVENTS)
    
  ;reset range of tof
  wTofReset = WIDGET_BUTTON(wTofMaxBase,$
    XOFFSET   = sTofReset.size[0],$
    YOFFSET   = sTofReset.size[1],$
    SCR_XSIZE = sTofReset.size[2],$
    VALUE     = sTofReset.value,$
    UNAME     = sTofReset.uname)
    
  ;play button
  ;  wPlayButton = WIDGET_BUTTON(wTofRangeBase,$
  ;    XOFFSET   = sPlayButton.size[0],$
  ;    YOFFSET   = sPlayButton.size[1],$
  ;    SCR_XSIZE = sPlayButton.size[2],$
  ;    SCR_YSIZE = sPlayButton.size[3],$
  ;    VALUE     = sPlayButton.value,$
  ;    UNAME     = sPlayButton.uname,$
  ;    /BITMAP)
    
  ;time/frame label and value
  wTpFlabel = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET = sTpFlabel.size[0],$
    YOFFSET = sTpFlabel.size[1],$
    VALUE   = sTpFlabel.value)
    
  wTpFvalue = WIDGET_TEXT(wTofRangeBase,$
    XOFFSET   = sTpFvalue.size[0],$
    YOFFSET   = sTpFvalue.size[1],$
    SCR_XSIZE = sTpFvalue.size[2],$
    VALUE     = sTpFvalue.value,$
    UNAME     = sTpFvalue.uname,$
    /EDITABLE)
    
  ;bin/frame label and value
  wBpFlabel = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET = sBpFlabel.size[0],$
    YOFFSET = sBpFlabel.size[1],$
    VALUE   = sBpFlabel.value)
    
  wBpFvalue = WIDGET_TEXT(wTofRangeBase,$
    XOFFSET   = sBpFvalue.size[0],$
    YOFFSET   = sBpFvalue.size[1],$
    SCR_XSIZE = sBpFvalue.size[2],$
    VALUE     = sBpFvalue.value,$
    UNAME     = sBpFvalue.uname,$
    /EDITABLE)
    
  ;Max Nbr bin
  wMaxBinLabel = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET = sMaxBinLabel.size[0],$
    YOFFSET = sMaxBinLabel.size[1],$
    VALUE   = sMaxBinLabel.value)
    
  wMaxBinValue = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET = sMaxBinValue.size[0],$
    YOFFSET = sMaxBinValue.size[1],$
    VALUE   = sMaxBinValue.value,$
    UNAME   = sMaxBinValue.uname,$
    FRAME   = sMaxBinValue.frame)
    
  ;bin # (label/value)
  wBinNbr = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET = sBinNbr.size[0],$
    YOFFSET = sBinNbr.size[1],$
    VALUE   = sBinNbr.value)
    
  wBinNbrValue = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET   = sBinNbrValue.size[0],$
    YOFFSET   = sBinNbrValue.size[1],$
    SCR_XSIZE = sBinNbrValue.size[2],$
    VALUE     = sBinNbrValue.value,$
    FRAME     = sBinNbrValue.frame,$
    UNAME     = sBinNbrValue.uname,$
    /ALIGN_LEFT)
    
  ;tof range (label/value)
  wTOFrange = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET = sTOFrange.size[0],$
    YOFFSET = sTOFrange.size[1],$
    VALUE   = sTOFrange.value)
    
  wTOFrangeValue = WIDGET_LABEL(wTofRangeBase,$
    XOFFSET   = sTOFrangeValue.size[0],$
    YOFFSET   = sTOFrangeValue.size[1],$
    SCR_XSIZE = sTOFrangeValue.size[2],$
    VALUE     = sTOFrangeValue.value,$
    FRAME     = sTOFrangeValue.frame,$
    UNAME     = sTOFrangeValue.uname,$
    /ALIGN_LEFT)
    
  ;Transmission or Background mode --------------------------------------------
  wTBase = WIDGET_BASE(wTab1Base,$
    XOFFSET   = sModeBase.size[0],$
    YOFFSET   = sModeBase.size[1],$
    SCR_XSIZE = sModeBase.size[2],$
    SCR_YSIZE = sModeBase.size[3],$
    FRAME     = sModeBase.frame)
    
  wModeGroup = CW_BGROUP(wTBase,$ ;cw_bgroup
    sModeGroup.list,$
    XOFFSET    = sModeGroup.size[0],$
    YOFFSET    = sModeGroup.size[1],$
    ROW        = 1,$
    SET_VALUE  = sModeGroup.value,$
    UNAME      = sModeGroup.uname,$
    LABEL_LEFT = sModeGroup.title,$
    /NO_RELEASE,$
    /EXCLUSIVE)
    
  ;- Selection tool -----------------------------------------------------------
  wSelection = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sSelection.size[0],$
    YOFFSET   = sSelection.size[1],$
    SCR_XSIZE = sSelection.size[2],$
    SCR_YSIZE = sSelection.size[3],$
    VALUE     = sSelection.value,$
    UNAME     = sSelection.uname,$
    SENSITIVE = sSelection.sensitive)
    
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
    
    
  ;Circle and Rectangle Buttons
  wCircleRectBase = WIDGET_BASE(wExclusionBase,$
    SPACE     = 15,$
    XOFFSET   = sRectCircleBase.size[0],$
    YOFFSET   = sRectCircleBase.size[1],$
    SCR_XSIZE = sRectCircleBase.size[2],$
    SCR_YSIZE = sRectCircleBase.size[3],$
    FRAME     = sRectCircleBase.frame,$
    /EXCLUSIVE,$
    /TOOLBAR,$
    /ROW)
    
  ;Circle
  wButton1 = WIDGET_BUTTON(wCircleRectBase,$
    VALUE   = sCircleButton.value,$
    TOOLTIP = sCircleButton.tooltip,$
    UNAME   = sCircleButton.uname,$
    /BITMAP,$
    /NO_RELEASE)
    
  ;Rect
  wButton2 = WIDGET_BUTTON(wCircleRectBase,$
    VALUE   = sRectButton.value,$
    TOOLTIP = sRectButton.tooltip,$
    UNAME   = sRectButton.uname,$
    /BITMAP,$
    /NO_RELEASE)
    
  WIDGET_CONTROL,  WIDGET_INFO(wCircleRectBase, /CHILD), /SET_BUTTON
  
  ;- Rectangle Selection tool -------------------------------------------------
  wRectangleBase1 = WIDGET_BASE(wExclusionBase,$
    XOFFSET   = sRectangleBase1.size[0],$
    YOFFSET   = sRectangleBase1.size[1],$
    SCR_XSIZE = sRectangleBase1.size[2],$
    SCR_YSIZE = sRectangleBase1.size[3],$
    FRAME     = sRectangleBase1.frame,$
    UNAME     = sRectangleBase1.uname,$
    MAP       = sRectangleBase1.map)
    
  ;label
  wLabel = WIDGET_TEXT(wRectangleBase1,$
    XOFFSET   = sRectangleText.size[0],$
    YOFFSET   = sRectangleText.size[1],$
    SCR_XSIZE = sRectangleText.size[2],$
    SCR_YSIZE = sRectangleText.size[3],$
    VALUE     = sRectangleText.value,$
    /WRAP,$
    /SCROLL)
    
  ;group base
  wRectGroupBase = WIDGET_BASE(wRectangleBase1,$
    XOFFSET   = sRectangleInOutBase.size[0],$
    YOFFSET   = sRectangleInOutBase.size[1],$
    SCR_XSIZE = sRectangleInOutBase.size[2],$
    SCR_YSIZE = sRectangleInOutBase.size[3],$
    FRAME     = sRectangleInOutBase.frame)
  wRectGroup = CW_BGROUP(wRectGroupBase,$
    sRectangleInOutGroup.list,$
    ROW       = 1,$
    SET_VALUE = sRectangleInOutGroup.value,$
    UNAME     = sRectangleInOutGroup.uname,$
    /NO_RELEASE,$
    /EXCLUSIVE)
    
  wRectangleBase2 = WIDGET_BASE(wExclusionBase,$
    XOFFSET   = sRectangleBase2.size[0],$
    YOFFSET   = sRectangleBase2.size[1],$
    SCR_XSIZE = sRectangleBase2.size[2],$
    SCR_YSIZE = sRectangleBase2.size[3],$
    FRAME     = sRectangleBase2.frame,$
    UNAME     = sRectangleBase2.uname,$
    MAP       = sRectangleBase2.map)
    
  ;help label
  wRectangleHelp = WIDGET_LABEL(wRectangleBase2,$
    XOFFSET = sRectangleHelp.size[0],$
    YOFFSET = sRectangleHelp.size[1],$
    VALUE   = sRectangleHelp.value)
    
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
    
  ;Type of selection base and buttons -----------------------------------------
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
    
  ;SAVE AS
  wSaveAsSelection = WIDGET_BUTTON(wExclusionBase,$
    XOFFSET   = sSaveAsSelection.size[0],$
    YOFFSET   = sSaveAsSelection.size[1],$
    SCR_XSIZE = sSaveAsSelection.size[2],$
    VALUE     = sSaveAsSelection.value,$
    UNAME     = sSaveAsSelection.uname,$
    SENSITIVE = sSaveAsSelection.sensitive)
    
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
    
  ;- X/Y base -----------------------------------------------------------------
  wXYbase = WIDGET_BASE(wTab1Base,$
    XOFFSET   = XYbase.size[0],$
    YOFFSET   = XYbase.size[1],$
    SCR_XSIZE = XYbase.size[2],$
    SCR_YSIZE = XYbase.size[3],$
    UNAME     = XYbase.uname,$
    FRAME     = XYbase.frame)
    
  ;x (label and value)
  wXlabel = WIDGET_LABEL(wXYbase,$
    XOFFSET = xLabel.size[0],$
    YOFFSET = xLabel.size[1],$
    VALUE   = xLabel.value)
  wXvalue = WIDGET_LABEL(wXYbase,$
    XOFFSET = xValue.size[0],$
    YOFFSET = xValue.size[1],$
    VALUE   = xValue.value,$
    UNAME   = xValue.uname)
    
  ;y (label and value)
  wYlabel = WIDGET_LABEL(wXYbase,$
    XOFFSET = yLabel.size[0],$
    YOFFSET = yLabel.size[1],$
    VALUE   = yLabel.value)
  wYvalue = WIDGET_LABEL(wXYbase,$
    XOFFSET = yValue.size[0],$
    YOFFSET = yValue.size[1],$
    VALUE   = yValue.value,$
    UNAME   = yValue.uname)
    
  ;Counts (label and value)
  wCountslabel = WIDGET_LABEL(wXYbase,$
    XOFFSET = countsLabel.size[0],$
    YOFFSET = countsLabel.size[1],$
    VALUE   = countsLabel.value)
  wCountsvalue = WIDGET_LABEL(wXYbase,$
    XOFFSET = countsValue.size[0],$
    YOFFSET = countsValue.size[1],$
    VALUE   = countsValue.value,$
    UNAME   = countsValue.uname,$
    /ALIGN_LEFT)
    
  ;- Counts vs tof button (everything) ----------------------------------------
  wCountsTofButton = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sCountsTofButton1.size[0],$
    YOFFSET   = sCountsTofButton1.size[1],$
    SCR_XSIZE = sCountsTofButton1.size[2],$
    SENSITIVE = sCountsTofButton1.sensitive,$
    VALUE     = sCountsTofButton1.value,$
    UNAME     = sCountsTofButton1.uname)
    
  ;- Counts vs tof button (selection) -----------------------------------------
  wCountsTofButton = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sCountsTofButton2.size[0],$
    YOFFSET   = sCountsTofButton2.size[1],$
    SCR_XSIZE = sCountsTofButton2.size[2],$
    VALUE     = sCountsTofButton2.value,$
    SENSITIVE = sCountsTofButton2.sensitive,$
    UNAME     = sCountsTofButton2.uname)
    
  ;- Counts vs tof button (monitor) -------------------------------------------
  wCountsTofButton = WIDGET_BUTTON(wTab1Base,$
    XOFFSET   = sCountsTofButton3.size[0],$
    YOFFSET   = sCountsTofButton3.size[1],$
    SCR_XSIZE = sCountsTofButton3.size[2],$
    VALUE     = sCountsTofButton3.value,$
    SENSITIVE = sCountsTofButton3.sensitive,$
    UNAME     = sCountsTofButton3.uname)
    
  ;play, pause, stop base
  wPlayBase = WIDGET_BASE(wTab1Base,$
    XOFFSET = sPlayBase.size[0],$
    YOFFSET = sPlayBase.size[1],$
    FRAME = sPlayBase.frame,$
    UNAME = sPlayBase.uname,$
    MAP = sPlayBase.map,$
    /ROW)
    
  wPreviousButton = WIDGET_DRAW(wPlayBase,$
    SCR_XSIZE = sAdvancedPreviousButton.size[2],$
    SCR_YSIZE = sAdvancedPreviousButton.size[3],$
    UNAME     = sAdvancedPreviousButton.uname,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    TOOLTIP = sAdvancedPreviousButton.tooltip)
    
  wPlayButton = WIDGET_DRAW(wPlayBase,$
    SCR_XSIZE = sAdvancedPlayButton.size[2],$
    SCR_YSIZE = sAdvancedPlayButton.size[3],$
    UNAME     = sAdvancedPlayButton.uname,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    TOOLTIP = sAdvancedPlayButton.tooltip)
    
  wPauseButton = WIDGET_DRAW(wPlayBase,$
    SCR_XSIZE = sAdvancedPauseButton.size[2],$
    SCR_YSIZE = sAdvancedPauseButton.size[3],$
    UNAME     = sAdvancedPauseButton.uname,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    TOOLTIP = sAdvancedPauseButton.tooltip)
    
  wStopButton = WIDGET_DRAW(wPlayBase,$
    SCR_XSIZE = sAdvancedStopButton.size[2],$
    SCR_YSIZE = sAdvancedStopButton.size[3],$
    UNAME     = sAdvancedStopButton.uname,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    TOOLTIP = sAdvancedStopButton.tooltip)
    
  wNextButton = WIDGET_DRAW(wPlayBase,$
    SCR_XSIZE = sAdvancedNextButton.size[2],$
    SCR_YSIZE = sAdvancedNextButton.size[3],$
    UNAME     = sAdvancedNextButton.uname,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    TOOLTIP = sAdvancedNextButton.tooltip)
    
  ;linear/log scale
  wGroupBase = WIDGET_BASE(wTab1Base,$
    XOFFSET = sScaleTypeBase.size[0],$
    YOFFSET = sScaleTypeBase.size[1],$
    UNAME = sScaleTypeBase.uname,$
    SENSITIVE = sScaleTypeBase.sensitive,$
    /ROW)
    
  wGroup = CW_BGROUP(wGroupBase,$
    sScaleType.list,$
    ROW        = 1,$
    SET_VALUE  = sScaleType.value,$
    UNAME      = sScaleType.uname,$
    LABEL_LEFT = sScaleType.title,$
    /NO_RELEASE,$
    /EXCLUSIVE)
    
    
END
