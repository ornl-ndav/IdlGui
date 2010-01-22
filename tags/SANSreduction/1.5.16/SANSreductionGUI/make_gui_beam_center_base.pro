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

PRO beam_center_base_gui, wBase, main_base_geometry

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 900
  ysize = 980
  
  xoffset = main_base_xoffset + main_base_xsize/2 - xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2 - ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Beam Center Calculation Tool',$
    UNAME        = 'beam_center_calculation_base',$
    SCR_XSIZE        = xsize, $
    SCR_YSIZE        = ysize, $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    GROUP_LEADER = ourGroup)
    
  ;big_base ==================================================
  big_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  ;row1 ......................................................
  row1 = WIDGET_BASE(big_base,$
    /ROW)
    
  xoffset = 50 ;xoffset of scale widget_draw
  yoffset = 50 ;yoffset of scale widget_draw
  xsize_main = 400 ;size of main plot
  ysize_main = 350 ;size of main plot
  main_xoffset = xsize/2 - xsize_main/2
  main_yoffset = yoffset
  scale_xsize = xsize_main+2*xoffset
  scale_ysize = ysize_main+2*yoffset
  
  ;left row1 ...................................................
  left_row1 = WIDGET_BASE(row1)
  
  main_plot = WIDGET_DRAW(left_row1,$
    XOFFSET = xoffset,$
    YOFFSET = main_yoffset,$
    SCR_XSIZE = xsize_main,$
    SCR_YSIZE = ysize_main,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    /MOTION_EVENTS,$
    UNAME = 'beam_center_main_draw')
    
  scale = WIDGET_DRAW(left_row1,$
    XOFFSET = 0,$
    YOFFSET = 0,$
    SCR_XSIZE = scale_xsize,$
    SCR_YSIZE = scale_ysize,$
    UNAME = 'beam_center_main_draw_scale')
    
  ;right row1 ......................................................
  right_row1 = WIDGET_BASE(row1,$
    /ALIGN_CENTER,$
    /COLUMN)
    
  ;title
  title = WIDGET_LABEL(right_row1,$
    VALUE = 'S E L E C T I O N     T O O L ')
    
  ;row1_right_row1
  row1_right_row1 = WIDGET_BASE(right_row1,$
    /ROW)
    
  ;button of selection tool
  xsize = 105
  ysize = 100
  space_value = ' '
  
  space = WIDGET_LABEL(row1_right_row1,$
    VALUE = '')
    
  button1 = WIDGET_DRAW(row1_right_row1,$
    XSIZE = xsize,$
    YSIZE = ysize,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    UNAME = 'beam_center_button1')
    
  space = WIDGET_LABEL(row1_right_row1,$
    VALUE = space_value)
    
  button2 = WIDGET_DRAW(row1_right_row1,$
    XSIZE = xsize,$
    YSIZE = ysize,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    UNAME = 'beam_center_button2')
    
  space = WIDGET_LABEL(row1_right_row1,$
    VALUE = space_value)
    
  button2 = WIDGET_DRAW(row1_right_row1,$
    XSIZE = xsize,$
    YSIZE = ysize,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    UNAME = 'beam_center_button3')
    
  ;second row (base) on the right
  row2_right_row1 = WIDGET_BASE(right_row1,$
    /COLUMN)
    
  tab_selection = WIDGET_TAB(row2_right_row1,$
    LOCATION  = 0,$
    SCR_XSIZE = 3*xsize+60,$
    SCR_YSIZE = 310,$
    SENSITIVE = 1,$
    UNAME = 'beam_center_tab',$
    /TRACKING_EVENTS)
    
  tab1 = WIDGET_BASE(tab_selection,$ ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    TITLE = ' Beam Stop Region ',$
    /COLUMN)
    
  vert_space = WIDGET_LABEL(tab1,$
    VALUE = ' ')
    
  space_value = '       '
  tab1_row1 = WIDGET_BASE(tab1,$
    /ROW)
  tube_left = WIDGET_LABEL(tab1_row1,$
    VALUE=space_value+'Tube left: ')
  value     = WIDGET_TEXT(tab1_row1,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_beam_stop_tube_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab1_row1,$
    VALUE = '       ')
  tube_right = WIDGET_LABEL(tab1_row1,$
    VALUE='Tube right: ')
  value     = WIDGET_TEXT(tab1_row1,$
    VALUE='N/A',$
    UNAME = 'beam_center_beam_stop_tube_right',$
    XSIZE = 3,$
    /EDITABLE)
    
  tab1_row2 = WIDGET_BASE(tab1,$
    /ROW)
  pixel_left = WIDGET_LABEL(tab1_row2,$
    VALUE=space_value+'Pixel top: ')
  value     = WIDGET_TEXT(tab1_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_beam_stop_pixel_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab1_row2,$
    VALUE = '     ')
  pixel_right = WIDGET_LABEL(tab1_row2,$
    VALUE='Pixel bottom: ')
  value     = WIDGET_TEXT(tab1_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_beam_stop_pixel_right',$
    /EDITABLE)
    
  FOR i=0,5 DO BEGIN
    space = WIDGET_LABEL(tab1,$
      VALUE = ' ')
  ENDFOR
  
  help_base = WIDGET_BASE(tab1,$
    /COLUMN,$
    FRAME=1)
  message = ['INFO : right click on the main plot to switch between     ',$
    'Selection and Moving selection']
  label = WIDGET_LABEL(help_base, $
    VALUE = message[0])
  label = WIDGET_LABEL(help_base, $
    /ALIGN_LEFT,$
    VALUE = message[1])
    
  tab2 = WIDGET_BASE(tab_selection,$ ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    TITLE = ' Calculation Range ',$
    /COLUMN)
    
  space_value = ''
  tab2_row1 = WIDGET_BASE(tab2,$
    /ROW,$
    FRAME=1)
  label = WIDGET_LABEL(tab2_row1,$
    VALUE = 'Mouse Infos    ')
  tube_left = WIDGET_LABEL(tab2_row1,$
    VALUE=space_value+'  Tube: ')
  value     = WIDGET_LABEL(tab2_row1,$
    VALUE='N/A',$
    SCR_XSIZE = 50,$
    /ALIGN_LEFT,$
    UNAME = 'beam_center_2d_plot_tube')
  space = WIDGET_LABEL(tab2_row1,$
    VALUE = '    ')
  tube_right = WIDGET_LABEL(tab2_row1,$
    VALUE='Pixel: ')
  value     = WIDGET_LABEL(tab2_row1,$
    VALUE='N/A',$
    SCR_XSIZE = 50,$
    /ALIGN_LEFT,$
    UNAME = 'beam_center_2d_plot_pixel')
  space = WIDGET_LABEL(tab2_row1,$
    VALUE = '  ')
    
  ;tube and pixel - left and right
  vert_space = WIDGET_LABEL(tab1,$
    VALUE = ' ')
    
  space_value = '       '
  tab2_row1 = WIDGET_BASE(tab2,$
    /ROW)
  tube_left = WIDGET_LABEL(tab2_row1,$
    VALUE=space_value+'Tube left: ')
  value     = WIDGET_TEXT(tab2_row1,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_calculation_range_tube_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab2_row1,$
    VALUE = '       ')
  tube_right = WIDGET_LABEL(tab2_row1,$
    VALUE='Tube right: ')
  value     = WIDGET_TEXT(tab2_row1,$
    VALUE='N/A',$
    UNAME = 'beam_center_calculation_range_tube_right',$
    XSIZE = 3,$
    /EDITABLE)
    
  tab2_row2 = WIDGET_BASE(tab2,$
    /ROW)
  pixel_left = WIDGET_LABEL(tab2_row2,$
    VALUE=space_value+'Pixel top: ')
  value     = WIDGET_TEXT(tab2_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_calculation_range_pixel_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab2_row2,$
    VALUE = '     ')
  pixel_right = WIDGET_LABEL(tab2_row2,$
    VALUE='Pixel bottom: ')
  value     = WIDGET_TEXT(tab2_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_calculation_range_pixel_right',$
    /EDITABLE)
    
  ;  xsize = 100
  ;  ysize = 30
  ;  tab2_row2 = WIDGET_BASE(tab2,$
  ;    /ROW)
  ;  button = WIDGET_DRAW(tab2_row2,$
  ;    XSIZE = xsize,$
  ;    /BUTTON_EVENTS,$
  ;    /TRACKING_EVENTS,$
  ;    UNAME = 'tube1_button_uname',$
  ;    YSIZE = ysize)
  ;  value = WIDGET_TEXT(tab2_row2,$
  ;    VALUE = 'N/A',$
  ;    UNAME = 'tube1_button_value',$
  ;    XSIZE = 3,$
  ;    /EDITABLE)
  ;
  ;  tab2_row3 = WIDGET_BASE(tab2,$
  ;    /ROW)
  ;  button = WIDGET_DRAW(tab2_row3,$
  ;    XSIZE = xsize,$
  ;    /BUTTON_EVENTS,$
  ;    /TRACKING_EVENTS,$
  ;    UNAME = 'tube2_button_uname',$
  ;    YSIZE = ysize)
  ;  value = WIDGET_TEXT(tab2_row3,$
  ;    VALUE = 'N/A',$
  ;    XSIZE = 3,$
  ;    UNAME = 'tube2_button_value',$
  ;    /EDITABLE)
  ;
  ;  tab2_row4 = WIDGET_BASE(tab2,$
  ;    /ROW)
  ;  button = WIDGET_DRAW(tab2_row4,$
  ;    XSIZE = xsize,$
  ;    /BUTTON_EVENTS,$
  ;    /TRACKING_EVENTS,$
  ;    UNAME = 'pixel1_button_uname',$
  ;    YSIZE = ysize)
  ;  value = WIDGET_TEXT(tab2_row4,$
  ;    VALUE = 'N/A',$
  ;    UNAME = 'pixel1_button_value',$
  ;    XSIZE = 3,$
  ;    /EDITABLE)
  ;
  ;  tab2_row5 = WIDGET_BASE(tab2,$
  ;    /ROW)
  ;  button = WIDGET_DRAW(tab2_row5,$
  ;    XSIZE = xsize,$
  ;    /BUTTON_EVENTS,$
  ;    /TRACKING_EVENTS,$
  ;    UNAME = 'pixel2_button_uname',$
  ;    YSIZE = ysize)
  ;  value = WIDGET_TEXT(tab2_row5,$
  ;    VALUE = 'N/A',$
  ;    UNAME = 'pixel2_button_value',$
  ;    XSIZE = 3,$
  ;    /EDITABLE)
  ;
  ;  tab2_row6_col1 = WIDGET_BASE(tab2,$ ;help text
  ;    FRAME = 1,$
  ;    /COLUMN)
  ;
  ;  message = ['-> Each left click on the main plot will automatically',$
  ;    'select the next button.', $
  ;    '-> Right click to move back to previous selection.']
  ;  help = WIDGET_LABEL(tab2_row6_col1,$
  ;    /ALIGN_LEFT,$
  ;    VALUE = message[0])
  ;  help = WIDGET_LABEL(tab2_row6_col1,$
  ;    /ALIGN_LEFT,$
  ;    VALUE = message[1])
  ;  help = WIDGET_LABEL(tab2_row6_col1,$
  ;    /ALIGN_LEFT,$
  ;    VALUE = message[2])
    
  tab3 = WIDGET_BASE(tab_selection,$ ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    TITLE = 'Cursor Information',$
    /COLUMN)
    
  tab3_rowa = WIDGET_BASE(tab3,$
    /ROW)
  label = WIDGET_LABEL(tab3_rowa,$
    VALUE = ' Live Infos:')
  base1 = WIDGET_BASE(tab3_rowa,$
    /ROW,$
    FRAME=1)
  value = WIDGET_LABEL(base1,$
    VALUE = 'Tube:')
  value = WIDGET_LABEL(base1,$
    VALUE = 'N/A',$
    SCR_XSIZE = 20,$
    UNAME = 'beam_center_cursor_live_tube_value',$
    /ALIGN_LEFT)
  space = WIDGET_LABEL(tab3_rowa,$
    VALUE = '')
  base1 = WIDGET_BASE(tab3_rowa,$
    /ROW,$
    FRAME=1)
  value = WIDGET_LABEL(base1,$
    VALUE = 'Pixel:')
  value = WIDGET_LABEL(base1,$
    VALUE = 'N/A',$
    SCR_XSIZE = 20,$
    UNAME = 'beam_center_cursor_live_pixel_value',$
    /ALIGN_LEFT)
  space = WIDGET_LABEL(tab3_rowa,$
    VALUE = '')
  base1 = WIDGET_BASE(tab3_rowa,$
    /ROW,$
    FRAME=1)
  value = WIDGET_LABEL(base1,$
    VALUE = 'Counts:')
  value = WIDGET_LABEL(base1,$
    VALUE = 'N/A',$
    SCR_XSIZE = 50,$
    UNAME = 'beam_center_cursor_live_counts_value',$
    /ALIGN_LEFT)
    
  vert_space = WIDGET_LABEL(tab3,$
    VALUE = ' ')
    
  label = WIDGET_LABEL(tab3,$
    VALUE = '    Information about the saved cursor position')
    
  vert_space = WIDGET_LABEL(tab3,$
    VALUE = ' ')
    
  tab3_row1 = WIDGET_BASE(tab3,$
    /ROW,$
    /ALIGN_CENTER)
  tube_left = WIDGET_LABEL(tab3_row1,$
    VALUE= '  Tube: ')
  value     = WIDGET_TEXT(tab3_row1,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_cursor_info_tube_value',$
    /EDITABLE)
    
  tab3_row2 = WIDGET_BASE(tab3,$
    /ROW,$
    /ALIGN_CENTER)
  tube_left = WIDGET_LABEL(tab3_row2,$
    VALUE=' Pixel: ')
  value     = WIDGET_TEXT(tab3_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_cursor_info_pixel_value',$
    /EDITABLE)
    
  tab3_row3 = WIDGET_BASE(tab3,$
    /ROW,$
    /ALIGN_CENTER)
  tube_left = WIDGET_LABEL(tab3_row3,$
    VALUE='     Counts:   ')
  value     = WIDGET_LABEL(tab3_row3,$
    VALUE='N/A',$
    SCR_XSIZE = 70,$
    /ALIGN_LEFT, $
    UNAME = 'beam_center_cursor_info_counts_value')
  ;------------------------------------------------------------------------
  tab4 = WIDGET_BASE(tab_selection,$ ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    TITLE = '?',$
    /COLUMN)
    
  tab4_row1 = WIDGET_BASE(tab4,$
    /ROW)
  label = WIDGET_LABEL(tab4_row1,$
    VALUE = '        Number of points to use in calculation:')
  text = WIDGET_TEXT(tab4_row1,$
    VALUE = '5',$
    XSIZE = 2,$
    UNAME = 'beam_center_nbr_points_to_use',$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  tab4_row2 = WIDGET_BASE(tab4,$
    /ROW)
  label = WIDGET_LABEL(tab4_row2,$
    VALUE = 'Offset from peak position to start calculation:')
  text = WIDGET_TEXT(tab4_row2,$
    VALUE = '3',$
    XSIZE = 2,$
    UNAME = 'beam_center_peak_offset',$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  tab4_row3 = WIDGET_BASE(tab4,$
    /ROW)
  label = WIDGET_LABEL(tab4_row3,$
    VALUE = 'Smooth coeff to use in Counts vs T/P functions:')
  text = WIDGET_TEXT(tab4_row3,$
    VALUE = '2',$
    XSIZE = 2,$
    UNAME = 'beam_center_smooth_parameter',$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  algo_base = WIDGET_BASE(tab4,$
    /COLUMN,$
    /ALIGN_LEFT,$
    FRAME = 1)
    
  algo_row1 = WIDGET_BASE(algo_base,$
    /ROW)
  label = WIDGET_LABEL(algo_row1,$
    VALUE = 'BC Algorithm:')
    
  col = WIDGET_BASE(algo_row1,$
    /COLUMN)
  row1 = WIDGET_BASE(col,$
    /ROW)
  label = WIDGET_LABEL(row1,$
    VALUE = 'Tube: ')
  row = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE)
  algo1 = WIDGET_BUTTON(row,$
    VALUE = '#1',$
    /NO_RELEASE,$
    UNAME = 'tube_algo_method_1')
  algo2 = WIDGET_BUTTON(row,$
    VALUE = '#2',$
    /NO_RELEASE,$
    UNAME = 'tube_algo_method_2')
  algo12 = WIDGET_BUTTON(row,$
    VALUE = '#1 and #2',$
    /NO_RELEASE,$
    UNAME = 'tube_algo_method_1_and_2')
  WIDGET_CONTROL,algo12, /SET_BUTTON
  
  row2 = WIDGET_BASE(col,$
    /ROW)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Pixel:')
  row = WIDGET_BASE(row2,$
    /ROW,$
    /EXCLUSIVE)
  algo1 = WIDGET_BUTTON(row,$
    VALUE = '#1',$
    /NO_RELEASE,$
    UNAME = 'pixel_algo_method_1')
  algo2 = WIDGET_BUTTON(row,$
    VALUE = '#2',$
    /NO_RELEASE,$
    UNAME = 'pixel_algo_method_2')
  algo12 = WIDGET_BUTTON(row,$
    VALUE = '#1 and #2',$
    /NO_RELEASE,$
    UNAME = 'pixel_algo_method_1_and_2')
  WIDGET_CONTROL,algo2, /SET_BUTTON
  
  
  help = WIDGET_LABEL(algo_base,$
    /ALIGN_LEFT,$
    VALUE = '#1: Calculate BC using left side of beam stop.')
  help = WIDGET_LABEL(algo_base,$
    /ALIGN_LEFT,$
    VALUE = '#2: Calculate BC using right side of beam stop.')
  help = WIDGET_LABEL(algo_base,$
    /ALIGN_LEFT,$
    VALUE = "#1 & #2: Calculate BC using both sides of beam stop.      ")
    
  ;row2 ......................................................
  row2 = WIDGET_BASE(big_base,$
    /ROW)
    
  plot_xsize = 440
  plot_ysize = 400
  
  ;counts vs tube
  plot1 = WIDGET_DRAW(row2,$
    XSIZE = plot_xsize,$
    YSIZE = plot_ysize,$
    UNAME = 'beam_center_calculation_counts_vs_tube_draw')
    
  ;counts vs pixel
  plot2 = WIDGET_DRAW(row2,$
    XSIZE = plot_xsize,$
    YSIZE = plot_ysize,$
    UNAME = 'beam_center_calculation_counts_vs_pixel_draw')
    
  ;row3 ...........................................................
  row3 = WIDGET_BASE(big_base,$
    /ROW)
    
  basea = WIDGET_BASE(row3)
  
  space = WIDGET_LABEL(row3,$
    VALUE = '     ')
    
  calculate_beam_center = WIDGET_BUTTON(row3,$
    VALUE = '  CALCULATE BEAM CENTER --->  ',$
    UNAME = 'beam_center_run_calculation_button',$
    FRAME = 0)
    
  ;right part of row3
  right_row3 = WIDGET_BASE(row3,$
    FRAME=5,$
    /ALIGN_CENTER,$
    /COLUMN)
    
  row2_right_row3 = WIDGET_BASE(right_row3,$
    /ROW)
    
  label = WIDGET_LABEL(row2_right_row3,$
    VALUE = 'Tube:')
  value = WIDGET_TEXT(row2_right_row3,$
    VALUE = 'N/A',$
    XSIZE = 10,$
    /EDITABLE, $
    UNAME = 'beam_center_tube_center_value')
  space = WIDGET_LABEL(row2_right_row3,$
    VALUE = '   ')
  label = WIDGET_LABEL(row2_right_row3,$
    VALUE = 'Pixel:')
  value = WIDGET_TEXT(row2_right_row3,$
    VALUE = 'N/A',$
    XSIZE = 10, $
    /EDITABLE, $
    UNAME = 'beam_center_pixel_center_value')
  space = WIDGET_LABEL(row2_right_row3,$
    VALUE = '   ')
  label = WIDGET_LABEL(row2_right_row3,$
    VALUE = 'Distance sample-detector:')
  value = WIDGET_TEXT(row2_right_row3,$
    VALUE = 'N/A',$
    XSIZE = 5, $
    UNAME = 'beam_center_z_offset_value',$
    /EDITABLE)
  label = WIDGET_LABEL(row2_right_row3,$
    SCR_XSIZE = 60,$
    /ALIGN_LEFT, $
    UNAME = 'beam_center_z_offset_units',$
    VALUE = 'N/A')
    
  ;row4 ...........................................................
  row4 = WIDGET_BASE(big_base,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row4,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 30,$
    UNAME = 'beam_stop_cancel_button',$
    VALUE = 'CANCEL')
    
  space_value = '                      '
  space = WIDGET_LABEL(row4, VALUE = space_value)
  
  refresh = WIDGET_BUTTON(row4,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 30,$
    VALUE = 'REFRESH DISPLAY',$
    UNAME = 'beam_stop_refresh_base')
    
  space = WIDGET_LABEL(row4, VALUE = space_value)
    
  ok = WIDGET_BUTTON(row4,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 30,$
    SENSITIVE = 0,$
    UNAME = 'beam_stop_ok_button',$
    VALUE = 'OK')
    
END