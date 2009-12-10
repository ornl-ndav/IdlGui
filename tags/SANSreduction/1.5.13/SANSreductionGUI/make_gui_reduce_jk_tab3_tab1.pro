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

PRO make_gui_reduce_jk_tab3_tab1, advanced_base, tab_size, tab_title

  ;= Build Widgets ==============================================================
  BaseTab = WIDGET_BASE(advanced_base,$
    UNAME     = 'reduce_jk_tab3_tab1_base_uname',$
    XOFFSET   = tab_size[0],$
    YOFFSET   = tab_size[1],$
    SCR_XSIZE = tab_size[2],$
    SCR_YSIZE = tab_size[3],$
    TITLE     = tab_title)
    
  ;Distances title
  xoff = 20
  yoff = 80
  label = WIDGET_LABEL(BaseTab,$
    VALUE = 'Distances',$
    XOFFSET = xoff,$
    YOFFSET = 55+yoff)
  label = WIDGET_LABEL(BaseTab,$
    VALUE = 'Pixels',$
    XOFFSET = xoff,$
    YOFFSET = 205+yoff)
  label = WIDGET_LABEL(BaseTab,$
    VALUE = 'Spectrum Center',$
    XOFFSET = xoff,$
    YOFFSET = 395+yoff)
    
  base = WIDGET_BASE(BaseTab,$
    /COLUMN)
    
  rowa = WIDGET_BASE(base,$
    /ROW)
  label = WIDGET_LABEL(rowa,$
    VALUE = 'Dark Current/Blocked beam run number ')
  value = WIDGET_TEXT(rowa,$
    UNAME = 'reduce_jk_tab3_tab1_dark_current',$
    VALUE = '',$
    XSIZE = 6,$
    /EDITABLE,$
    /ALL_EVENTS)
  label = WIDGET_LABEL(rowa,$
    VALUE = '(Subtracted from the data before any other normalization)')
    
  rowb = WIDGET_BASE(base,$
    /ROW)
  label = WIDGET_LABEL(rowb,$
    VALUE = 'Vanadium/Water run number')
  value = WIDGET_TEXT(rowb,$
    VALUE = '',$
    UNAME = 'reduce_jk_tab3_tab1_vanadium',$
    XSIZE = 6,$
    /EDITABLE,$
    /ALL_EVENTS)
  label = WIDGET_LABEL(rowb,$
    VALUE = '(Normalize data by Vanadium/Water)')
    
  row1 = WIDGET_BASE(base,$
    /ROW)
  yesno = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE)
  yes = WIDGET_BUTTON(yesno,$
    UNAME = 'reduce_jk_tab3_tab1_normalize_data_yes',$
    VALUE = 'Yes')
  no = WIDGET_BUTTON(yesno,$
    UNAME = 'reduce_jk_tab3_tab1_normalize_data_no',$
    VALUE = 'No')
  WIDGET_CONTROL, yes, /SET_BUTTON
  label = WIDGET_LABEL(row1,$
    VALUE = 'Normalize data (divide I(Q) by total monitor counts)')
    
  space = WIDGET_LABEL(base,$
    VALUE = ' ')
    
  ;distances
  frame1 = WIDGET_BASE(base,$
    /COLUMN,$
    FRAME = 1)
  space_value = '        '
  row1 = WIDGET_BASE(frame1,$
    /ROW)
  space = WIDGET_LABEL(row1,$
    VALUE = space_value)
  label = WIDGET_LABEL(row1,$
    VALUE = 'Sample - Detector  ')
  value = WIDGET_TEXT(row1,$
    VALUE = '',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_sample_detector_distance',$
    XSIZE = 8)
  label = WIDGET_LABEL(row1,$
    VALUE = 'm')
  row2 = WIDGET_BASE(frame1,$
    /ROW)
  space = WIDGET_LABEL(row2,$
    VALUE = space_value)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Sample - Source    ')
  value = WIDGET_TEXT(row2,$
    VALUE = '14.0',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_sample_source_distance',$
    XSIZE = 8)
  label = WIDGET_LABEL(row2,$
    VALUE = 'm')
  row3 = WIDGET_BASE(frame1,$
    /ROW)
  space = WIDGET_LABEL(row3,$
    VALUE = space_value)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Monitor - Detector ')
  value = WIDGET_TEXT(row3,$
    VALUE = '10.001',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_monitor_detector_distance',$
    XSIZE = 8)
  label = WIDGET_LABEL(row3,$
    VALUE = 'm')
    
  space = WIDGET_LABEL(base,$
    VALUE = ' ')
    
  ;Pixels
  frame1 = WIDGET_BASE(base,$
    /COLUMN,$
    FRAME = 1)
  space_value = '        '
  row1 = WIDGET_BASE(frame1,$
    /ROW)
  space = WIDGET_LABEL(row1,$
    VALUE = space_value)
  label = WIDGET_LABEL(row1,$
    VALUE = 'Number of pixels in X direction ')
  value = WIDGET_TEXT(row1,$
    VALUE = '192',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_number_of_x_pixels',$
    XSIZE = 3)
  row2 = WIDGET_BASE(frame1,$
    /ROW)
  space = WIDGET_LABEL(row2,$
    VALUE = space_value)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Number of pixels in Y direction ')
  value = WIDGET_TEXT(row2,$
    VALUE = '256',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_number_of_y_pixels',$
    XSIZE = 3)
  row3 = WIDGET_BASE(frame1,$
    /ROW)
  space = WIDGET_LABEL(row3,$
    VALUE = space_value)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Detector pixel size in X direction ')
  value = WIDGET_TEXT(row3,$
    VALUE = '5.5',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_x_size',$
    XSIZE = 7)
  label = WIDGET_LABEL(row3,$
    VALUE = 'mm')
  row4 = WIDGET_BASE(frame1,$
    /ROW)
  space = WIDGET_LABEL(row4,$
    VALUE = space_value)
  label = WIDGET_LABEL(row4,$
    VALUE = 'Detector pixel size in Y direction ')
  value = WIDGET_TEXT(row4,$
    VALUE = '4.0467',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_y_size',$
    XSIZE = 7)
  label = WIDGET_LABEL(row4,$
    VALUE = 'mm')
    
  space = WIDGET_LABEL(base,$
    VALUE = ' ')
    
  ;Spectrum center
  frame3 = WIDGET_BASE(base,$
    FRAME = 1,$
    /COLUMN)
  row1 = WIDGET_BASE(frame3,$
    /ROW)
  yesno = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE)
  yes = WIDGET_BUTTON(yesno,$
    UNAME = 'reduce_jk_tab3_tab1_auto_center_yes',$
    /NO_RELEASE,$
    VALUE = 'Yes')
  no = WIDGET_BUTTON(yesno,$
    UNAME = 'reduce_jk_tab3_tab1_auto_center_no',$
    /NO_RELEASE,$
    VALUE = 'No')
  WIDGET_CONTROL, no, /SET_BUTTON
  label = WIDGET_LABEL(row1,$
    VALUE = 'Auto find Spectrum center')
  space_value = '        '
  row1 = WIDGET_BASE(frame3,$
    SENSITIVE = 1,$
    UNAME = 'reduce_jk_tab3_tab1_auto_center_x_base',$
    /ROW)
  space = WIDGET_LABEL(row1,$
    VALUE = space_value)
  label = WIDGET_LABEL(row1,$
    VALUE = 'Spectrum X center ')
  value = WIDGET_TEXT(row1,$
    VALUE = '',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_spectrum_x_center',$
    XSIZE = 9)
  label = WIDGET_LABEL(row1,$
    VALUE = 'pixels')
  row2 = WIDGET_BASE(frame3,$
    UNAME = 'reduce_jk_tab3_tab1_auto_center_y_base',$
    SENSITIVE = 1,$
    /ROW)
  space = WIDGET_LABEL(row2,$
    VALUE = space_value)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Spectrum Y center ')
  value = WIDGET_TEXT(row2,$
    VALUE = '',$
    /ALL_EVENTS,$
    /EDITABLE,$
    UNAME = 'reduce_jk_tab3_tab1_spectrum_y_center',$
    XSIZE = 9)
  label = WIDGET_LABEL(row2,$
    VALUE = 'pixels')
    
END
