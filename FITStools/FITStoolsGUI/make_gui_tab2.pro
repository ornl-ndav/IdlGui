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

PRO make_gui_tab2, MAIN_TAB, global

  geometry = WIDGET_INFO(MAIN_TAB,/GEOMETRY)
  xsize = geometry.xsize
  ysize = geometry.ysize - 5
  
  wTab1Base = WIDGET_BASE(MAIN_TAB,$
    UNAME     = 'tab2_uname',$
    XOFFSET   = 0, $
    YOFFSET   = 0, $
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysize, $
    TITLE     = '  CREATE Intensity vs Time ASCII FILE  ')
    
  BaseCol = WIDGET_BASE(wTab1Base,$
    SCR_XSIZE = xsize,$
    /COLUMN,$
    /BASE_ALIGN_CENTER)
    
  ;space
  space = WIDGET_LABEL(BaseCol,$
    VALUE = ' ')
    
  ;row1
  row1 = WIDGET_BASE(BaseCol,$
    /ROW)
  label = WIDGET_LABEL(row1,$
  VALUE = 'Bin Size:')
  value = WIDGET_TEXT(row1,$
  VALUE = '300',$
  XSIZE = 7,$
  /ALL_EVENTS,$
  /EDITABLE,$
  UNAME = 'tab2_bin_size_value')
  units = WIDGET_LABEL(row1,$
    VALUE = 'microS      ')
  plot = WIDGET_BUTTON(row1,$
    VALUE = 'P L O T ...',$
    SENSITIVE = 0,$
    UNAME = 'tab2_bin_size_plot',$
    XSIZE = 200)
    
  ;space
  space = WIDGET_LABEL(BaseCol,$
    VALUE = ' ')
    
  ;row2
  row2 = WIDGET_BASE(BaseCol,$
    /COLUMN,$
    FRAME = 1)
    
  rowa = WIDGET_BASE(row2,$
    /ROW)
  label = WIDGET_LABEL(rowa,$
    VALUE = 'Where:')
  button = WIDGET_BUTTON(rowa,$
    VALUE = '~/results/',$
    SCR_XSIZE = 400,$
    UNAME = 'tab2_where_button')
    
  rowb = WIDGET_BASE(row2,$
    /ROW)
  label = WIDGET_LABEL(rowb,$
    VALUE = ' Name:')
  button = WIDGET_TEXT(rowb,$
    VALUE = '',$
    /ALL_EVENTS,$
    /EDITABLE,$
    SCR_XSIZE = 400,$
    UNAME = 'tab2_file_name')
    
  ;space
  space = WIDGET_LABEL(BaseCol,$
    VALUE = ' ')
    
  ;row3
  row3 = WIDGET_BASE(BaseCol,$
    /ROW)
;  space = WIDGET_LABEL(row3,$
;  VALUE = '                    ')
  preview = WIDGET_BUTTON(row3,$
  VALUE = 'PREVIEW ASCII FILE ...',$
  SCR_YSIZE = 30,$
  SENSITIVE = 0,$
  UNAME = 'tab2_preview_ascii_file_button')
  space = WIDGET_LABEL(row3,$
  VALUE = '                            ')
  create = WIDGET_BUTTON(row3,$
  VALUE = 'CREATE ASCII FILE',$
  SENSITIVE = 0,$
  UNAME = 'tab2_create_ascii_file_button')
  
END