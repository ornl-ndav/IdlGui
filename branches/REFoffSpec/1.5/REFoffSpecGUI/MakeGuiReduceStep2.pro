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

PRO make_gui_Reduce_step2, REDUCE_TAB, sTab, TabTitles, global

  ; Define variable instrument (RCW, Feb 1, 2010)
  instrument = (*global).instrument
  
  ;****************************************************************************
  ;            DEFINE STRUCTURE
  ;****************************************************************************
  
  tab_title = TabTitles.step2
  sBase = { size:  stab.size,$
    uname: 'reduce_step2_tab_base',$
    title: tab_title}
    
  ;****************************************************************************
  ;            BUILD GUI
  ;****************************************************************************
  ; Code Change (RC Ward, 27 March 2010): Extensive redsign of the GUI was implemented
  ; Shrink vertical screen size for viewing on laptop or reduced resolution monitor
    
  Base = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBase.uname,$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = sBase.title)
    
  ;Create/Modify/Visualize base ===============================================
    
  ModifyBase = WIDGET_BASE(Base,$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sbase.size[3],$
    UNAME     = 'reduce_step2_create_roi_base',$
    MAP       = 0)
    
  ;show_plot = widget_button(ModifyBase,$
  ;xoffset = 980,$
  ;yoffset = 120,$
  ;value = 'Show counts vs pixel plot',$
  ;uname = 'reduce_step2_show_counts_vs_pixel_plot')
  show_plot = widget_draw(ModifyBase,$
    xoffset = 980,$
    yoffset = 80,$
    scr_xsize = 160,$
    scr_ysize = 110,$
    retain=2,$
    /button_events,$
    /tracking_events, $
    frame=1,$
    uname = 'reduce_step2_show_counts_vs_pixel_plot')
    
  ;select range of tof base
  tof_range = widget_base(ModifyBase,$
    /column,$
    frame=5,$
    xoffset = 115,$
    yoffset = 770)
  tof_row1 = widget_base(tof_range,$
    /row)
  tof1 = widget_label(tof_row1,$
    value = 'Plot from TOF1 (ms):')
  tof1_value = widget_text(tof_row1,$
    value = 'N/A',$
    xsize=8,$
    /editable,$
    uname = 'reduce_step2_tof1')
  tof1 = widget_label(tof_row1,$
    value = ' to TOF2 (ms):')
  tof1_value = widget_text(tof_row1,$
    value = 'N/A',$
    /editable,$
    xsize = 8,$
    uname = 'reduce_step2_tof2')
  space = widget_label(tof_row1,$
    value = '  ')
  full_range = widget_button(tof_row1,$
    value = 'Plot range',$
    scr_xsize = 110,$
    uname = 'reduce_step2_tof_plot_only_range')
  space = widget_label(tof_row1,$
    value = '     ')
  full_range = widget_button(tof_row1,$
    value = 'Plot full',$
    scr_xsize = 110,$
    uname = 'reduce_step2_tof_plot_full_range')
  tof_row2 = widget_label(tof_range,$
    value = 'Left click TOF range to select TOF1, right' + $
    ' click to switch to TOF2.')
    
  big_base = WIDGET_BASE(ModifyBase,$
    /COLUMN)
    
  ;first row --------------------------------
  row1_base = WIDGET_BASE(big_base,$
    /row)
    
  space = WIDGET_LABEL(row1_base,$
    VALUE = ' ')
    
  data_label = WIDGET_LABEL(row1_base,$
    VAlUE = '  Data Run:')
    
  data_value = WIDGET_LABEL(row1_base,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_create_roi_data_value',$
    FRAME = 0,$
    SCR_XSIZE = 100)
    
  norm_label = WIDGET_LABEL(row1_base,$
    VAlUE = '  Normalization Run:')
    
  norm_value = WIDGET_LABEL(row1_base,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_create_roi_norm_value',$
    FRAME = 1,$
    SCR_XSIZE = 100)
  ; use predefined instrument (RWD, Feb 1, 2010)
  IF (instrument EQ 'REF_M') THEN BEGIN
  
    spin_label = WIDGET_LABEL(row1_base,$
      VALUE = '     Spin State:')
      
    spin_value = WIDGET_LABEL(row1_base,$
      VALUE = 'Off_Off',$
      FRAME = 1,$
      UNAME = 'reduce_step2_create_roi_pola_value',$
      SCR_XSIZE = 50)
      
    xsize = 500
    
  roi_label = WIDGET_LABEL(row1_base,$
    VALUE = '     Peak ROI File Name:')
    
  roi_value = WIDGET_LABEL(row1_base,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    SCR_XSIZE = xsize,$
    UNAME = 'reduce_step2_create_roi_file_name_label',$
    FRAME = 1)
    
  row1b_base = widget_base(big_base,/row)
  space = widget_label(row1b_base,$
    value = ' ',$
    scr_xsize = 593)
    
  back_roi_label = widget_label(row1b_base,$
    value = ' Back. ROI File Name:')
  back_roi_value = widget_label(row1b_base,$
    value = 'N/A',$
    /align_left,$
    scr_xsize = xsize, $
    uname = 'reduce_step2_create_back_roi_file_name_label',$
    frame=1)
    
  ENDIF ELSE BEGIN
  
    space = WIDGET_LABEL(row1_base,$
      VALUE = '      ')
      
    xsize = 550
    
  roi_label = WIDGET_LABEL(row1_base,$
    VALUE = '     Peak ROI File Name:')
    
  roi_value = WIDGET_LABEL(row1_base,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    SCR_XSIZE = xsize,$
    UNAME = 'reduce_step2_create_roi_file_name_label',$
    FRAME = 1)
    
  row1b_base = widget_base(big_base,/row)
  space = widget_label(row1b_base,$
    value = ' ',$
    scr_xsize = 479)
    
  back_roi_label = widget_label(row1b_base,$
    value = ' Back. ROI File Name:')
  back_roi_value = widget_label(row1b_base,$
    value = 'N/A',$
    /align_left,$
    scr_xsize = xsize, $
    uname = 'reduce_step2_create_back_roi_file_name_label',$
    frame=1)
    
  ENDELSE
  
  ;space
  space = widget_label(big_base,$
    value = ' ')
    
  ;second row --------------------------
  row2_base = WIDGET_BASE(big_base)
  
  ; column 1
  row2col1 = WIDGET_BASE(row2_base)
  
  colorbar_xsize = 100
  xoffset = 40
  yoffset = 40
  
  _colorbar = widget_draw(row2col1,$
    xoffset =  0, $
    yoffset = yoffset, $
    scr_xsize = colorbar_xsize, $
    retain=2,$
    scr_ysize = 2*(*global).detector_pixels_y, $
    uname = 'reduce_step2_colorbar_uname')
    
  draw = WIDGET_DRAW(row2col1,$
    xoffset = xoffset + colorbar_xsize,$
    yoffset = yoffset, $
    SCR_XSIZE = (*global).sangle_xsize_draw, $
    SCR_YSIZE = 2 * (*global).detector_pixels_y,$
    UNAME = 'reduce_step2_create_roi_draw_uname',$
    ;/tracking_events,$
    /motion_events,$
    /button_events,$
    retain=2,$
    /KEYBOARD_EVENT)
    
  scales = widget_draw(row2col1,$
    xoffset = colorbar_xsize, $
    scr_xsize = (*global).sangle_xsize_draw + 2*xoffset,$
    scr_ysize = 2*(*global).detector_pixels_y + 2*yoffset,$
    retain=2,$
    /button_events, $
    /motion_events, $
    uname = 'reduce_step2_scale_uname')
    
  ; column 2
  row2col2 = WIDGET_BASE(row2_base,$ ;...................................
    xoffset = 700 + colorbar_xsize,$
    /COLUMN)
    
  ;lin/log cwbgroup
  value = ['Lin ','Log ']
  group = CW_BGROUP(row2col2,$
    value,$
    COLUMN=1,$
    SET_VALUE = 1,$
    LABEL_TOP='Z-axis type',$
    /NO_RELEASE,$
    FRAME = 0,$
    SPACE = 5,$
    UNAME = 'reduce_step2_create_roi_lin_log',$
    /EXCLUSIVE)
    
  space = widget_label(row2col2,$
    value = ' ')
  space = widget_label(row2col2,$
    value = ' ')
    
  peak_back_base = widget_base(row2col2,$
    /exclusive,$
    frame=5,$
    /row)
  peak = widget_button(peak_back_base,$
    value = 'Select PEAK ROI',$
    /no_release,$
    uname = 'working_with_peak')
  back = widget_button(peak_back_base,$
    value = 'Select BACKGROUND ROI',$
    /no_release,$
    uname = 'working_with_back')
  widget_control, peak,/set_button
  
  space = widget_label(row2col2,$
    value = ' ')
    
  ;first inside row (browse button)
  browse_button = WIDGET_BUTTON(row2col2,$
    VALUE = 'B R O W S E   F O R   A   P E A K  R O I . . .',$
    SCR_XSIZE = 320,$
    TOOLTIP = 'Click to browse for a ROI file and plot it',$
    UNAME = 'reduce_step2_create_roi_browse_roi_button')
    
  row3col2_base2 = WIDGET_BASE(row2col2,$
    /ROW)
    
  y1_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = '>>',$
    /ALIGN_LEFT, $
    UNAME = 'reduce_step2_create_roi_y1_l_status')
  y1_label = WIDGET_LABEL(row3col2_base2,$
    /ALIGN_LEFT, $
    VALUE = 'Y1:')
  y1_value = WIDGET_TEXT(row3col2_base2,$
    VALUE = ' ',$
    XSIZE = 3,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_create_roi_y1_value')
  y1_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = '<<',$
    /ALIGN_LEFT, $
    UNAME = 'reduce_step2_create_roi_y1_r_status')
    
  space = WIDGET_LABEL(row3col2_base2,$
    value = '  ')
    
    
  y2_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = ' ',$
    UNAME = 'reduce_step2_create_roi_y2_l_status')
  y2_label = WIDGET_LABEL(row3col2_base2,$
    VALUE = 'Y2:')
  y2_value = WIDGET_TEXT(row3col2_base2,$
    VALUE = ' ',$
    XSIZE = 3,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_create_roi_y2_value')
  y2_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = ' ',$
    UNAME = 'reduce_step2_create_roi_y2_r_status')
  space = widget_label(row3col2_base2,$
    value = '   ')
  reset = widget_button(row3col2_base2,$
    value = 'Reset',$
    uname = 'reset_peak_roi_inputs')
    
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
    
  ;first inside row (browse button)
  browse_button = WIDGET_BUTTON(row2col2,$
    VALUE = 'B R O W S E   F O R   A   B A C K.  R O I . . .',$
    SCR_XSIZE = 320,$
    TOOLTIP = 'Click to browse for a background ROI file and plot it',$
    UNAME = 'reduce_step2_create_roi_browse_back_roi_button')
    
  row3col2_base2 = WIDGET_BASE(row2col2,$
    /ROW)
    
  y1_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = '  ',$
    /ALIGN_LEFT, $
    UNAME = 'reduce_step2_create_back_roi_y1_l_status')
  y1_label = WIDGET_LABEL(row3col2_base2,$
    /ALIGN_LEFT, $
    VALUE = 'Y1:')
  y1_value = WIDGET_TEXT(row3col2_base2,$
    VALUE = ' ',$
    XSIZE = 3,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_create_back_roi_y1_value')
  y1_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = '  ',$
    /ALIGN_LEFT, $
    UNAME = 'reduce_step2_create_back_roi_y1_r_status')
    
  space = WIDGET_LABEL(row3col2_base2,$
    value = '  ')
    
    
  y2_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = ' ',$
    UNAME = 'reduce_step2_create_back_roi_y2_l_status')
  y2_label = WIDGET_LABEL(row3col2_base2,$
    VALUE = 'Y2:')
  y2_value = WIDGET_TEXT(row3col2_base2,$
    VALUE = ' ',$
    XSIZE = 3,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_create_back_roi_y2_value')
  y2_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = ' ',$
    UNAME = 'reduce_step2_create_back_roi_y2_r_status')
  space = widget_label(row3col2_base2,$
    value = '   ')
  reset = widget_button(row3col2_base2,$
    value = 'Reset',$
    uname = 'reset_back_roi_inputs')
    
    
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
    
  info = WIDGET_LABEL(row2col2,$
    VALUE = ' HELP: Left click on the plot to select first Y, right ')
  info = WIDGET_LABEL(row2col2,$
    VALUE = 'click to switch to next Y, or manually input Y1 and Y2. ')
  ;  info = WIDGET_LABEL(row2col2,$
  ;    VALUE = 'or use up and down arrows to move selection.')
    
  ;  ;third row (save button)
  ;  save_roi = WIDGET_BUTTON(row2col2,$
  ;    VALUE = 'S A V E   P E A K  and  B A C K.  R O Is',$
  ;    SCR_XSIZE = 320,$
  ;    TOOLTIP = 'Click to Save the peak and background ROI you created',$
  ;    UNAME = 'reduce_step2_create_roi_save_roi',$
  ;    SENSITIVE = 1)
  ;
  ;  ;save and quit base
  ;  save_quit_roi = WIDGET_BUTTON(row2col2,$
  ;    VALUE = 'SAVE PEAK and BACK. ROIs and RETURN TO TABLE',$
  ;    SCR_XSIZE = 320,$
  ;    ;    TOOLTIP = 'Click to Save the ROI and Return to the table',$
  ;    uname = 'reduce_step2_create_roi_save_roi_quit',$
  ;    SENSITIVE = 1)
    
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
  space = WIDGET_LABEL(row2col2,$
    value = '    ')
    
  ReturnButton = WIDGET_BUTTON(row2col2,$
    SCR_XSIZE = 120,$
    SCR_YSIZE = 30,$
    VALUE = '  RETURN TO TABLE  ',$
    UNAME = 'reduce_step2_return_to_table_button')
    
  ;end of Create/modify/visualize base =========================================
    
  ;Main base --------------------------------------------------------------------
  xoff = 30
  
  ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = xoff+9,$
    YOFFSET = 5,$
    VALUE = 'Normalization File(s) Input')
    
  x_norm = 595
  hidden_base = WIDGET_BASE(Base,$
    xoffset = x_norm+xoff,$
    yoffset = 5,$
    map = 1,$
    frame = 0,$
    xsize = 130,$
    ysize = 15,$
    uname = 'reduce_step2_list_of_normalization_file_hidden_base')
    
  ;title of list of normaliation file
  label = WIDGET_LABEL(Base,$
    XOFFSET = x_norm+xoff,$
    YOFFSET = 5,$
    VALUE = 'Normalization File(s)')
    
  x2 = 795
  hidden_base = WIDGET_BASE(Base,$
    xoffset = x2+xoff,$
    yoffset = 5,$
    map = 1,$
    frame = 0,$
    xsize = 130,$
    ysize = 15,$
    uname = 'reduce_step2_polarization_mode_hidden_base')
    
  ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = 25+x2+xoff,$
    YOFFSET = 5,$
    VALUE = 'Polarization Mode')
    
  ;############################################################################
  ;first Row
  main_row1 = WIDGET_BASE(Base,$
    XOFFSET = 0,$
    YOFFSET = 20,$
    /ROW)
    
  ;space
  space = WIDGET_LABEL(main_row1,$
    VALUE = '   ')
    
  ;Loand normalization
  base_row1 = WIDGET_BASE(main_row1,$
    /ROW,$
    SCR_YSIZE = 150,$
    FRAME = 5)
    
  col1 = WIDGET_BASE(base_row1,$
    /COLUMN)
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  browse_button = WIDGET_BUTTON(col1,$
    UNAME = 'reduce_step2_browse_button',$
    VALUE = '     B R O W S E  ...    ')
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  value = WIDGET_LABEL(col1,$
    VALUE = 'OR')
    
  value = WIDGET_LABEL(col1,$idl
  VALUE = '')
  
  row2 = WIDGET_BASE(col1,$
    /ROW)
    
  value = WIDGET_LABEL(row2,$
    VALUE = 'Run(s) #:')
    
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    value = (*global).sDebugging.reduce_tab2_cw_field
  ENDIF ELSE BEGIN
    value = ''
  ENDELSE
  
  ; For debugging, set the value to desired run numbers (RCW, Dec 31, 2009, Modified Feb 1, 2010)
  ; Commented out for release of Ver 1.5.0 on 16 June 2010
  ; IF (instrument EQ 'REF_L') THEN BEGIN
  ;    value = '24580'
  ;  ENDIF ELSE BEGIN
  ;    value = '5392-5394'
  ;  ENDELSE
  
  text = WIDGET_TEXT(row2,$
    VALUE = value,$
    UNAME = 'reduce_step2_normalization_text_field',$
    /EDITABLE,$
    XSIZE = 40)
    
    
  value = WIDGET_LABEL(row2,$
    VALUE = '(ex: 1245,1345-1347,1349)')
    
  ;label = WIDGET_LABEL(row2,$
  ;  VALUE = '     List of Proposal:')
  ;ComboBox = WIDGET_COMBOBOX(Row2,$
  ;                           VALUE = '                          ',$
  ;  UNAME = 'reduce_tab2_list_of_proposal')
    
  space_value = '            '
  ;space between base of first row
  space = WIDGET_LABEL(main_row1,$
    VALUE = space_value)
    
  ;list of normalization file loaded base ------------------------------------
  list_norm_base = WIDGET_BASE(main_row1,$
    uname = 'reduce_step2_list_of_norm_files_base',$
    ;    scr_xsize = 200,$
    /column,$
    map=0,$
    FRAME=5)
    
  table = WIDGET_TABLE(list_norm_base,$
    scr_xsize = 65,$
    xsize = 1,$
    ysize = 11,$
    scr_ysize = 120,$
    column_widths = 110,$
    /no_headers,$
    /no_row_headers,$
    /disjoint_selection,$
    uname = 'reduce_step2_list_of_norm_files_table')
    
  button = WIDGET_BUTTON(list_norm_base,$
    value = 'Remove Selected File',$
    uname = 'reduce_step2_list_of_norm_files_remove_button')
    
    
  ;-------------- second part of tab ------------------------------------------
  ; use predefined instrument (RCW, Feb 1, 2010)
  IF (instrument EQ 'REF_M') THEN BEGIN
    value = 'Data Run#     Normalization Run#'
    xsize = 200
  ENDIF ELSE BEGIN
    value = 'Data Run#     Normalization Run#                   ' + $
      '      Peak ROI                   ' + $
      '                     Background ROI                                ' + $
      '    Selection of ROIs'
    xsize = 800
  ENDELSE
  
  xyoff = [27,218]
  sLabel = { size: [XYoff[0],$
    XYoff[1]],$
    value: value}
    
  label_base = WIDGET_BASE(Base,$
    xoffset = sLabel.size[0],$
    yoffset = slabel.size[1],$
    scr_xsize = xsize,$
    scr_ysize = 30,$
    map = 0,$
    uname = 'reduce_step2_label_table_base')
    
  label = WIDGET_LABEL(label_base,$
    XOFFSET = 0,$
    YOFFSET = 0,$
    /align_left, $
    VALUE   = sLabel.value)
    
  ;----------------------------------------------------------------------------
  ;Big table
  ;----------------------------------------------------------------------------
  IF ((*global).instrument EQ 'REF_L') THEN BEGIN
  
    offset = 35
    xoff = 50
    yoff = offset + sLabel.size[1]+5
    label_offset = 4
    FOR i=0,10 DO BEGIN
    
      uname = 'reduce_tab2_data_recap_base_#' + STRCOMPRESS(i,/REMOVE_ALL)
      row_base = WIDGET_BASE(Base,$
        uname = uname,$
        xoffset = XYoff[0],$
        yoffset = yoff,$
        scr_ysize = 30,$
        scr_xsize = 1210,$
        map = 0,$
        frame = 0)
        
      uname = 'reduce_tab2_data_value' + STRCOMPRESS(i,/REMOVE_ALL)
      value1 = WIDGET_LABEL(row_Base,$
        value   = '1',$
        xoffset = 0,$
        yoffset = label_offset,$
        SCR_XSIZE = 50,$
        uname   = uname)
        
      uname = 'reduce_tab2_norm_base'
      combo_base = WIDGET_BASE(row_Base,$
        XOFFSET = xyoff[0]+50,$
        YOFFSET = 0,$
        uname = uname+ STRCOMPRESS(i,/REMOVE_ALL),$
        map = 1)
        
      uname = 'reduce_tab2_norm_combo'
      combo = WIDGET_COMBOBOX(combo_base,$
        value = ['1','2'],$
        uname = uname + STRCOMPRESS(i,/REMOVE_ALL))
        
      uname = 'reduce_tab2_norm_value' + STRCOMPRESS(i,/REMOVE_ALL)
      value2 = WIDGET_LABEL(row_Base,$
        XOFFSET = XYoff[0]+85,$
        YOFFSET = label_offset,$
        /align_left,$
        value = '1',$
        SCR_XSIZE = 50,$
        uname = uname)
        
      ;roi widgets
      ;peak ROI widgets
      ;Browse button
      big_off = 80
      uname = 'reduce_tab2_roi_browse_button' + strcompress(i,/remove_all)
      browse = WIDGET_BUTTON(row_base,$
        Xoffset = xyoff[0]+130 + big_off,$
        yoffset = 2,$
        value = 'Browse peak ROI ...',$
        uname = uname)
      label = widget_label(row_base,$
        value='File:',$
        yoffset=7,$
        xoffset=xyoff[0]+340)
      uname = 'reduce_tab2_roi_peak_status' + strcompress(i,/remove_all)
      result = widget_label(row_base,$
        value='None!',$
        /align_left,$
        yoffset=7,$
        xoffset=xyoff[0]+375,$
        scr_xsize = 40,$
        uname=uname)
        
      ;background ROI widgets
      uname = 'reduce_tab2_back_roi_browse_button' + strcompress(i,/remove_all)
      browse = WIDGET_BUTTON(row_base,$
        Xoffset = xyoff[0]+520,$
        yoffset = 2,$
        value = 'Browse back. ROI ...',$
        uname = uname)
      label = widget_label(row_base,$
        value='File:',$
        yoffset=7,$
        xoffset=xyoff[0]+655)
      uname = 'reduce_tab2_back_roi_status' + strcompress(i,/remove_all)
      result = widget_label(row_base,$
        value='None!',$
        /align_left,$
        yoffset=7,$
        xoffset=xyoff[0]+690,$
        scr_xsize = 40,$
        uname=uname)
        
      ;Create/modify ROI
      uname = 'reduce_tab2_roi_modify_button' + strcompress(i,/remove_all)
      modify = WIDGET_BUTTON(row_base,$
        xoffset = xyoff[0]+800,$
        yoffset = 2,$
        uname = uname,$
        scr_xsize = 330,$
        value = 'Create/Modify/Visualize Peak/Back ROI files')
        
      yoff += offset
    ENDFOR
    
  ENDIF ELSE BEGIN
  
    offset = 35
    xoff = 50
    yoff = offset + sLabel.size[1]+5
    label_offset = 4
    FOR i=0,10 DO BEGIN
    
      uname = 'reduce_tab2_data_recap_base_#' + STRCOMPRESS(i,/REMOVE_ALL)
      row_base = WIDGET_BASE(Base,$
        uname = uname,$
        xoffset = XYoff[0],$
        yoffset = yoff,$
        scr_ysize = 30,$
        scr_xsize = 190,$
        map = 0,$
        frame = 0)
        
      uname = 'reduce_tab2_data_value' + STRCOMPRESS(i,/REMOVE_ALL)
      value1 = WIDGET_LABEL(row_Base,$
        value   = '5001',$
        xoffset = 0,$
        yoffset = label_offset,$
        SCR_XSIZE = 50,$
        uname   = uname)
        
      uname = 'reduce_tab2_norm_base'
      combo_base = WIDGET_BASE(row_Base,$
        XOFFSET = xyoff[0]+50,$
        YOFFSET = 0,$
        uname = uname+ STRCOMPRESS(i,/REMOVE_ALL),$
        map = 1)
        
      uname = 'reduce_tab2_norm_combo'
      combo = WIDGET_COMBOBOX(combo_base,$
        value = ['6000','6001'],$
        uname = uname + STRCOMPRESS(i,/REMOVE_ALL))
        
      uname = 'reduce_tab2_norm_value' + STRCOMPRESS(i,/REMOVE_ALL)
      value2 = WIDGET_LABEL(row_Base,$
        XOFFSET = XYoff[0]+85,$
        YOFFSET = label_offset,$
        /align_left,$
        value = '6000',$
        SCR_XSIZE = 50,$
        uname = uname)
        
      yoff += offset
    ENDFOR
    
    ;table base
    Table_base = WIDGET_BASE(Base,$
      XOFFSET = 230,$
      YOFFSET = 207-15,$
      SCR_XSIZE = 1005,$
      SCR_YSIZE = 430+20,$
      UNAME = 'reduce_step2_data_spin_states_table_base',$
      MAP = 0)
      
    ;title of big data spin states table
    label = WIDGET_LABEL(Table_base,$
      XOFFSET = 850-280,$
      YOFFSET = 2,$
      VALUE = '<<-- D A T A   S p i n   S t a t e s',$
      FRAME = 0,$
      FONT = '15x13',$
      UNAME = 'reduce_step2_d-ata_spin_states_table_title')
      
    ;big widget_tab
    tab = WIDGET_TAB(Table_base,$
      XOFFSET = 0,$
      YOFFSET = 0,$
      UNAME = 'reduce_step2_data_spin_state_tab_uname',$
      /TRACKING_EVENTS,$
      SCR_XSIZE = 1000,$
      SCR_YSIZE = 430+15)
      
    space = '    '
    
    ;data_Off_Off
    off_off = WIDGET_BASE(tab,$
      title = space + ' O f f _ O f f ' + space)
      
    add_widgets_reduce_step2_tab, $
      base_id = off_off,$
      base_name = 'off_off'
      
    ;data_Off_On
    off_on = WIDGET_BASE(tab,$
      title = space + ' O f f _ O n ' + space)
      
    add_widgets_reduce_step2_tab, $
      base_id = off_on,$
      base_name = 'off_on'
      
    ;data_On_Off
    on_off = WIDGET_BASE(tab,$
      title = space + ' O n _ O f f ' + space)
      
    add_widgets_reduce_step2_tab, $
      base_id = on_off,$
      base_name = 'on_off'
      
    ;data_On_On
    on_on = WIDGET_BASE(tab,$
      title = space + ' O n _ O n ' + space)
      
    add_widgets_reduce_step2_tab, $
      base_id = on_on,$
      base_name = 'on_on'
      
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO   add_widgets_reduce_step2_tab, $
    base_id = base_id,$
    base_name = base_name
    
  uname = 'reduce_tab2_data_spin_hidden_base_' + base_name
  hidden_base = WIDGET_BASE(base_id,$
    UNAME = uname,$
    SCR_XSIZE = 1000,$
    SCR_YSIZE = 430+15,$
    MAP = 0)
    
  uname = 'reduce_tab2_data_spin_hidden_draw_' + base_name
  draw = WIDGET_DRAW(hidden_base,$
    UNAME = uname, $
    SCR_XSIZE = 1000,$
    SCR_YSIZE = 430+15)
    
  XYoff = [30,5]
  ;title = 'NORM. Spin State                 R e g i o n   O f  ' + $
  ;  ' I n t e r e s t   ( R O I ) '
  title = 'NORM. Spin State             Peak ROI                   ' + $
    '           Background ROI                                ' + $
    '    Selection of ROIs'
  label = WIDGET_LABEL(base_id,$
    VALUE = title,$
    xoffset = XYoff[0],$
    yoffset = XYoff[1])
    
  yoffset = 0
  XYoff = [40,41]
  FOR i=0,10 DO BEGIN
  
    iS = STRCOMPRESS(i,/REMOVE_ALL)
    
    uname = 'reduce_tab2_data_spin_row_base_' + base_name + iS
    row_base = WIDGET_BASE(base_id,$
      uname = uname,$
      xoffset = 0,$
      yoffset = XYoff[1] + yoffset,$
      scr_ysize = 30,$
      scr_xsize = 1000,$
      map = 0,$
      frame = 0)
      
    ;spin state widget_base and widget_combobox
    uname = 'reduce_tab2_spin_combo_base_' + base_name + iS
    combo_base = WIDGET_BASE(row_base,$
      XOFFSET = 25,$
      YOFFSET = 2,$
      uname = uname,$
      map = 0)
      
    uname = 'reduce_tab2_spin_combo_' + base_name + iS
    combo = WIDGET_COMBOBOX(combo_base,$
      value = ['Off_Off','Off_On','On_Off','On_On'],$
      uname = uname)
      
    ;spin state widget_label
    uname = 'reduce_tab2_spin_value_' + base_name + iS
    spin = WIDGET_LABEL(row_base,$
      XOFFSET = 50,$
      YOFFSET = 5,$
      SCR_XSIZE = 50,$
      value = 'Off_Off',$
      /align_left,$
      uname = uname)
      
    ;peak ROI widgets
    ;Browse button
    uname = 'reduce_tab2_roi_browse_button_' + base_name + iS
    browse = WIDGET_BUTTON(row_base,$
      Xoffset = xyoff[0]+130,$
      yoffset = 2,$
      ;      scr_xsize = 150,$
      value = 'Browse peak ROI ...',$
      uname = uname)
    label = widget_label(row_base,$
      value='File:',$
      yoffset=7,$
      xoffset=xyoff[0]+260)
    uname = 'reduce_tab2_roi_peak_status_' + base_name + iS
    result = widget_label(row_base,$
      value='None!',$
      /align_left,$
      yoffset=7,$
      xoffset=xyoff[0]+295,$
      scr_xsize = 40,$
      uname=uname)
      
    ;background ROI widgets
    uname = 'reduce_tab2_back_roi_browse_button_' + base_name + iS
    browse = WIDGET_BUTTON(row_base,$
      Xoffset = xyoff[0]+370,$
      yoffset = 2,$
      value = 'Browse back. ROI ...',$
      uname = uname)
    label = widget_label(row_base,$
      value='File:',$
      yoffset=7,$
      xoffset=xyoff[0]+505)
    uname = 'reduce_tab2_back_roi_status_' + base_name + iS
    result = widget_label(row_base,$
      value='None!',$
      /align_left,$
      yoffset=7,$
      xoffset=xyoff[0]+540,$
      scr_xsize = 40,$
      uname=uname)
      
    ;Create/modify ROI
    uname = 'reduce_tab2_roi_modify_button_' + base_name + iS
    modify = WIDGET_BUTTON(row_base,$
      xoffset = xyoff[0]+620,$
      yoffset = 2,$
      uname = uname,$
      scr_xsize = 330,$
      value = 'Create/Modify/Visualize Peak/Back ROI files')
      
    ;    uname = 'reduce_tab2_roi_label_' + base_name + iS
    ;    roi = WIDGET_LABEL(row_Base,$
    ;      XOFFSET = XYoff[0]+815,$
    ;      YOFFSET = 7,$
    ;      /ALIGN_LEFT,$
    ;      frame=0,$
    ;      value = 'File:',$
    ;      uname = uname)
    ;
    ;    uname = 'reduce_tab2_roi_value_' + base_name + iS
    ;    roi = WIDGET_LABEL(row_Base,$
    ;      XOFFSET = XYoff[0]+550,$
    ;      YOFFSET = 7,$
    ;      SCR_XSIZE = 400,$
    ;      /ALIGN_LEFT,$
    ;      frame=0,$
    ;      value = 'N/A',$
    ;      uname = uname)
      
    yoffset += 35
    
  ENDFOR
  
  
END
