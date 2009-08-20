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
  
  wBase = WIDGET_BASE(TITLE = 'Transmission Calculation Mode',$
    UNAME        = 'transmission_mode_launcher_base',$
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
    VALUE = ' ')
    
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
    TITLE = ' Calculation Range ',$
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
    UNAME = 'beam_center_calculation_tube_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab1_row1,$
    VALUE = '     ')
  tube_right = WIDGET_LABEL(tab1_row1,$
    VALUE='Tube right: ')
  value     = WIDGET_TEXT(tab1_row1,$
    VALUE='N/A',$
    UNAME = 'beam_center_calculation_tube_right',$
    XSIZE = 3,$
    /EDITABLE)
    
  tab1_row2 = WIDGET_BASE(tab1,$
    /ROW)
  pixel_left = WIDGET_LABEL(tab1_row2,$
    VALUE=space_value+'Pixel left:')
  value     = WIDGET_TEXT(tab1_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_calculation_pixel_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab1_row2,$
    VALUE = '     ')
  pixel_right = WIDGET_LABEL(tab1_row2,$
    VALUE='Pixel right:')
  value     = WIDGET_TEXT(tab1_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_calculation_pixel_right',$
    /EDITABLE)
    
  tab2 = WIDGET_BASE(tab_selection,$ ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    TITLE = '  Beam Stop Region ',$
    /COLUMN)
    
  vert_space = WIDGET_LABEL(tab2,$
    VALUE = ' ')
    
  space_value = '       '
  tab2_row1 = WIDGET_BASE(tab2,$
    /ROW)
  tube_left = WIDGET_LABEL(tab2_row1,$
    VALUE=space_value+'Tube left: ')
  value     = WIDGET_TEXT(tab2_row1,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_beam_stop_tube_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab2_row1,$
    VALUE = '     ')
  tube_right = WIDGET_LABEL(tab2_row1,$
    VALUE='Tube right: ')
  value     = WIDGET_TEXT(tab2_row1,$
    VALUE='N/A',$
    UNAME = 'beam_center_beam_stop_tube_right',$
    XSIZE = 3,$
    /EDITABLE)
    
  tab2_row2 = WIDGET_BASE(tab2,$
    /ROW)
  pixel_left = WIDGET_LABEL(tab2_row2,$
    VALUE=space_value+'Pixel left:')
  value     = WIDGET_TEXT(tab2_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_beam_stop_pixel_left',$
    /EDITABLE)
  space = WIDGET_LABEL(tab2_row2,$
    VALUE = '     ')
  pixel_right = WIDGET_LABEL(tab2_row2,$
    VALUE='Pixel right:')
  value     = WIDGET_TEXT(tab2_row2,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_beam_stop_pixel_right',$
    /EDITABLE)
    
  tab3 = WIDGET_BASE(tab_selection,$ ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    TITLE = '      2D plots     ',$
    /COLUMN)
    
  vert_space = WIDGET_LABEL(tab3,$
    VALUE = ' ')
    
  space_value = '       '
  tab3_row1 = WIDGET_BASE(tab3,$
    /ROW)
  tube_left = WIDGET_LABEL(tab3_row1,$
    VALUE=space_value+'Tube: ')
  value     = WIDGET_TEXT(tab3_row1,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_2d_plot_tube',$
    /EDITABLE)
  space = WIDGET_LABEL(tab3_row1,$
    VALUE = '        ')
  tube_right = WIDGET_LABEL(tab3_row1,$
    VALUE='Pixel: ')
  value     = WIDGET_TEXT(tab3_row1,$
    VALUE='N/A',$
    XSIZE = 3,$
    UNAME = 'beam_center_2d_plot_pixel',$
    /EDITABLE)
    
  ;row2 ......................................................
  row2 = WIDGET_BASE(big_base,$
    /ROW)
    
  plot_xsize = 440
  plot_ysize = 400
  
  ;counts vs tube
  plot1 = WIDGET_DRAW(row2,$
    XSIZE = plot_xsize,$
    YSIZE = plot_ysize)
    
  ;counts vs pixel
  plot2 = WIDGET_DRAW(row2,$
    XSIZE = plot_xsize,$
    YSIZE = plot_ysize)
    
  ;row3 ...........................................................
  row3 = WIDGET_BASE(big_base,$
    /ROW)
    
  basea = WIDGET_BASE(row3)
  
  label = WIDGET_LABEL(basea,$
    yoffset = 5,$
    VALUE = 'Number of point to use in calculation:')
  text = WIDGET_TEXT(basea,$
    xoffset= 235,$
    yoffset= 0,$
    VALUE = '3',$
    XSIZE = 2,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  space = WIDGET_LABEL(row3,$
    VALUE = '             ')
    
  ;right part of row3
  right_row3 = WIDGET_BASE(row3,$
    FRAME=5,$
    /ALIGN_CENTER,$
    /COLUMN)
    
  title = WIDGET_LABEL(right_row3,$
    VALUE = 'BEAM CENTER')
    
  row2_right_row3 = WIDGET_BASE(right_row3,$
    /ROW)
    
  label = WIDGET_LABEL(row2_right_row3,$
    VALUE = 'Tube:')
  value = WIDGET_LABEL(row2_right_row3,$
    VALUE = 'N/A',$
    /ALIGN_LEFT)
  space = WIDGET_LABEL(row2_right_row3,$
    VALUE = '   ')
  label = WIDGET_LABEL(row2_right_row3,$
    VALUE = 'Pixel:')
  value = WIDGET_LABEL(row2_right_row3,$
    VALUE = 'N/A',$
    /ALIGN_LEFT)
    
  ;row4 ...........................................................
  row4 = WIDGET_BASE(big_base,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row4,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 30,$
    UNAME = 'beam_stop_cancel_button',$
    VALUE = 'CANCEL')
    
  space = WIDGET_LABEL(row4,$
    VALUE = '                                                        ' + $
    '                       ')
    
  ok = WIDGET_BUTTON(row4,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 30,$
    VALUE = 'OK')
    
END