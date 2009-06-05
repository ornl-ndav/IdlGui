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

PRO MakeGuiMainPlot, wBase

  ;****************************************************************************
  ;                           Define size arrays
  ;****************************************************************************

  xsize = 1867L
  ;MainPlotBase = { size  : [200,50,1938,268],$
  MainPlotBase = { size  : [200,50,xsize,4*128L+1],$  ;1885
    uname : 'main_plot_base',$
    title : 'Real View of Instrument (Y vs X integrated over TOF)'}
    
  MainDraw     = { size  : [0,0,MainPlotBase.size[2],$
    MainPlotBase.size[3]],$
    uname : 'main_plot'}
    
  PSbutton     = { uname : 'plot_selection_button_mbar',$
    value : 'PLOT SELECTION'}
    
  PDVbutton    = { uname : 'plot_das_view_button_mbar',$
    value : 'DAS view (Y vs X integrated over TOF)'}
    
  PtofVbutton  = { uname : 'plot_tof_view_button_mbar',$
    value : 'TOF view (tof vs X integrated over Y)'}
    
  PtofScaleButton = { value     : 'TOF scale (* 1)',$
    uname     : 'tof_scale_button',$
    sensitive : 0}
  PtofScale      = { uname : ['tof_scale_d9',$
    'tof_scale_d8',$
    'tof_scale_d7',$
    'tof_scale_d6',$
    'tof_scale_d5',$
    'tof_scale_d4',$
    'tof_scale_d3',$
    'tof_scale_d2',$
    'tof_scale_reset',$
    'tof_scale_m2',$
    'tof_scale_m3',$
    'tof_scale_m4',$
    'tof_scale_m5',$
    'tof_scale_m6',$
    'tof_scale_m7',$
    'tof_scale_m8',$
    'tof_scale_m9'],$
    value : ['   / 9   ',$
    '   / 8   ',$
    '   / 7   ',$
    '   / 6   ',$
    '   / 5   ',$
    '   / 4   ',$
    '   / 3   ',$
    '   / 2   ',$
    '  Reset  ',$
    '   * 2   ', $
    '   * 3   ', $
    '   * 4   ', $
    '   * 5   ', $
    '   * 6   ', $
    '   * 7   ', $
    '   * 8   ', $
    '   * 9   ']}
    
  ;****************************************************************************
  ;                                Build GUI
  ;****************************************************************************
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = MainPlotBase.title,$
    UNAME        = MainPlotBase.uname,$
    XOFFSET      = MainPlotBase.size[0],$
    YOFFSET      = MainPlotBase.size[1],$
    MAP          = 1,$
    GROUP_LEADER = ourGroup,$
    /COLUMN)
    
  row1 = WIDGET_BASE(wBase,$ ;row1 --------------------------------------
    /ROW)
    
  row1a = WIDGET_BASE(row1,$
    /ROW,$
    /FRAME)
    
  title = WIDGET_LABEL(row1a,$
    VALUE = 'Counts:  ')
    
  min_value = CW_FIELD(row1a,$
    VALUE = '',$
    UNAME= 'main_base_min_value',$
    /INTEGER,$
    /RETURN_EVENTS,$
    TITLE = 'Min:',$
    XSIZE = 6,$
    /ROW)
    
  max_value = CW_FIELD(row1a,$
    VALUE = '',$
    UNAME= 'main_base_max_value',$
    /INTEGER,$
    /RETURN_EVENTS,$
    XSIZE = 6,$
    TITLE = '   Max:',$
    /ROW)
    
  space = WIDGET_LABEL(row1a,$
    VALUE = '  ')
    
  reset = WIDGET_BUTTON(row1a,$
    VALUE = 'RESET SCALE',$
    UNAME = 'reset_scale')
    
  space = WIDGET_LABEL(row1,$
    VALUE = '  ')
    
  row1b = WIDGET_BASE(row1,$ ;-----------------------------------------------
    /ROW,$
    FRAME=1)
    
  bank = WIDGET_LABEL(row1b,$
    VALUE = 'Bank')
  value = WIDGET_TEXT(row1b,$
    VALUE = 'N/A',$
    UNAME = 'bank_value',$
    SCR_XSIZE = 50)
    
  tube = WIDGET_LABEL(row1b,$
    VALUE = 'Tube')
  value = WIDGET_TEXT(row1b,$
    VALUE = 'N/A',$
    UNAME = 'tube_value',$
    SCR_XSIZE = 50)
    
  row = WIDGET_LABEL(row1b,$
    VALUE = 'Row')
  value = WIDGET_TEXT(row1b,$
    VALUE = 'N/A',$
    UNAME = 'row_value',$
    SCR_XSIZE = 50)
    
  pixelid = WIDGET_LABEL(row1b,$
    VALUE = 'PixelID')
  value = WIDGET_TEXT(row1b,$
    VALUE = 'N/A',$
    UNAME = 'pixelid_value',$
    SCR_XSIZE = 60)
    
  counts = WIDGET_LABEL(row1b,$
    VALUE = 'Counts')
  value = WIDGET_TEXT(row1b,$
    VALUE = 'N/A',$
    UNAME = 'counts_value',$
    SCR_XSIZE = 50)
    
  angle = WIDGET_LABEL(row1b,$
    VALUE = 'Tube Angle')
  value = WIDGET_TEXT(row1b,$
    VALUE = 'N/A',$
    UNAME = 'angle_value',$
    SCR_XSIZE = 90)
  degrees = WIDGET_LABEL(row1b,$
    VALUE = 'degrees')
    
  ;produce counts vs tof of full detector
  button = WIDGET_BUTTON(row1,$
    VALUE = 'Counts vs TOF of full detector',$
    UNAME = 'counts_vs_tof_full_detector',$
    /NO_RELEASE)
    
  ;space
  space = WIDGET_LABEL(row1,$
    VALUE = '                                                              ' + $
    '                      ')
    
  ;lin/log cw_bgroup
  row1c = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE,$
    FRAME = 0)
    
  lin = WIDGET_BUTTON(row1c,$
    VALUE = 'Linear',$
    UNAME = 'main_plot_linear_plot',$
    /NO_RELEASE)
    
  log = WIDGET_BUTTON(row1c,$
    VALUE = 'Logarithmic',$
    UNAME = 'main_plot_log_plot',$
    /NO_RELEASE)
    
  WIDGET_CONTROL, lin, /SET_BUTTON
  
  row2 = WIDGET_BASE(wBase,$ ;row2 ----------------------------------------
    /ROW)
    
  scale = WIDGET_DRAW(row2,$
    SCR_XSIZE = 90,$
    SCR_YSIZE = MainDraw.size[3],$
    UNAME = 'main_plot_scale')
    
  wMainDraw = WIDGET_DRAW(row2,$
    SCR_XSIZE = MainDraw.size[2],$
    SCR_YSIZE = MainDraw.size[3],$
    UNAME     = MainDraw.uname,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS)
    
  ;---------------------------------------------------------------------------
  message = 'LEFT click to select region of interest for Counts vs TOF plot'
  message += ' - RIGHT click to zoom in into selected bank'
  row3 = WIDGET_LABEL(wBase,$ ;explain how the selection works
    VALUE = message)
    
  ;--------------------------------------------------------------------------
    
  row4 = WIDGET_BASE(wBase,$
    /ROW)
    
  space = WIDGET_LABEL(row4,$
    VALUE =  '   ')
    
  row4a = WIDGET_BASE(row4,$ ;play/pause/next.... buttons ----------------
    FRAME = 1)
    
  pause = WIDGET_DRAW(row4a,$
    uname = 'pause_button',$
    scr_xsize = 34,$
    FRAME = 0,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    TOOLTIP = 'Pause',$
    scr_ysize = 27,$
    xoffset = 56,$
    yoffset= 82)
    
  stop =  WIDGET_DRAW(row4a,$
    uname = 'stop_button',$
    scr_xsize = 32,$
    FRAME = 0,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    scr_ysize = 25,$
    TOOLTIP = 'Return to intilal plot with all TOF integrated',$
    xoffset = 120,$
    yoffset= 82)
    
  previous =  WIDGET_DRAW(row4a,$
    uname = 'previous_button',$
    scr_xsize = 47,$
    FRAME = 0,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    scr_ysize = 41,$
    TOOLTIP = 'Display previous frame',$
    xoffset = 12,$
    yoffset= 35)
    
  play =  WIDGET_DRAW(row4a,$
    uname = 'play_button',$
    scr_xsize = 75,$
    FRAME = 0,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    scr_ysize = 60,$
    TOOLTIP = 'Play',$
    xoffset = 65,$
    yoffset= 7)
    
  next =  WIDGET_DRAW(row4a,$
    uname = 'next_button',$
    scr_xsize = 47,$
    FRAME = 0,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    scr_ysize = 45,$
    TOOLTIP = 'Display next frame',$
    xoffset = 148,$
    yoffset= 33)
    
  play_buttons = WIDGET_DRAW(row4a,$
    UNAME = 'play_buttons',$
    SCR_XSIZE = 205,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    SCR_YSIZE = 125)
    
  ;---------------------------------------------------------------------------
    
  row4b = WIDGET_BASE(row4,$ ;column b of row4 ..............................
    /COLUMN,$
    FRAME = 1)
    
  row4b1 = WIDGET_BASE(row4b,$ ;row 1 of column b of row 4 ..................
    /ROW)
    
  row4b1a = WIDGET_BASE(row4b1, $ ;column 1 of row 1 of column b of row 4....
    /COLUMN)
    
  row4b1a1 = WIDGET_BASE(row4b1a,$ ;-------------------------------------------
    UNAME = 'play_tof_row',$
    /ROW)
    
  label = WIDGET_LABEL(row4b1a1,$
    VALUE = 'TOF')
    
  label = WIDGET_LABEL(row4b1a1,$
    VALUE = '   Min:')
    
  label = WIDGET_LABEL(row4b1a1,$
    VALUE = 'N/A',$
    SCR_XSIZE = 60,$
    /ALIGN_LEFT,$
    FRAME = 1,$
    UNAME = 'min_tof_value')
    
  label = WIDGET_LABEL(row4b1a1,$
    VALUE = 'microS     ')
    
  label = WIDGET_LABEL(row4b1a1,$
    VALUE = 'Max:')
    
  label = WIDGET_LABEL(row4b1a1,$
    VALUE = 'N/A',$
    FRAME = 1,$
    SCR_XSIZE = 60,$
    /ALIGN_LEFT,$
    UNAME = 'max_tof_value')
    
  label = WIDGET_LABEL(row4b1a1,$
    VALUE = 'microS')
    
  row4b1a2 = WIDGET_BASE(row4b1a,$ ;-------------------------------------------
    /ROW)
    
  label = WIDGET_LABEL(row4b1a2,$
    VALUE = 'Bin #')
    
  label = WIDGET_LABEL(row4b1a2,$
    VALUE = ' Min:')
    
  label = WIDGET_LABEL(row4b1a2,$
    VALUE = 'N/A',$
    SCR_XSIZE = 60,$
    /ALIGN_LEFT,$
    FRAME = 1,$
    UNAME = 'min_bin_value')
    
  label = WIDGET_LABEL(row4b1a2,$
    VALUE = '            Max:')
    
  label = WIDGET_LABEL(row4b1a2,$
    VALUE = 'N/A',$
    FRAME = 1,$
    SCR_XSIZE = 60,$
    /ALIGN_LEFT,$
    UNAME = 'max_bin_value')
    
  button = WIDGET_BUTTON(row4b1,$; --------------------------------------------
    VALUE = 'View full TOF axis',$
    SCR_XSIZE = 150,$
    UNAME = 'tof_preview')
    
  row4b2 = WIDGET_BASE(row4b,$ ;row2 of column b of row4 ....................
    /ROW)
    
  value = CW_FIELD(row4b2,$
    VALUE = '5',$
    XSIZE = 10,$
    TITLE = 'Nbr bins per frame:',$
    UNAME = 'nbr_bins_per_frame_tof',$
    /LONG,$
    /RETURN_EVENTS)
    
  value = CW_FIELD(row4b2,$
    VALUE = '1',$
    XSIZE = 4,$
    TITLE = '     Display time of each frame:',$
    UNAME = 'time_per_frame_tof',$
    /FLOATING,$
    /RETURN_EVENTS)
    
  label = WIDGET_LABEL(row4b2,$
    VALUE = 's')
    
  ;-----------------------------------------------------------------------------
  ;plot that will display counts vs tof of central row
  draw = WIDGET_DRAW(row4,$
    SCR_XSIZE = 600,$
    SCR_YSIZE = 130,$
    UNAME = 'play_counts_vs_tof_plot')
    
    
    
    
    
    
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END
