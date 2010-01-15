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

PRO make_gui_tab1, MAIN_TAB, global

  geometry = WIDGET_INFO(MAIN_TAB,/GEOMETRY)
  xsize = geometry.xsize
  ysize = geometry.ysize - 5
  
  wTab1Base = WIDGET_BASE(MAIN_TAB,$
    UNAME     = 'tab1_uname',$
    XOFFSET   = 0, $
    YOFFSET   = 0, $
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysize, $
    TITLE     = '  LOAD FITS FILE(S)  ')
    
  ;Base that will inform the user of the current file loaded
  loaded_xsize = 400
  loaded_ysize = 50
  loaded_xoffset = (xsize - loaded_xsize) / 2
  loaded_yoffset = (ysize - loaded_ysize) / 2
  
  loaded_base = WIDGET_BASE(wTab1Base,$
    XOFFSET = loaded_xoffset,$
    YOFFSET = loaded_yoffset, $
    SCR_XSIZE = loaded_xsize, $
    SCR_YSIZE = loaded_ysize, $
    UNAME = 'tab1_loaded_base_info',$
    MAP = 0, $
    /COLUMN, $
    FRAME = 5)
    
  value = WIDGET_LABEL(loaded_base,$
    VALUE = 'LOADING ...',$
    SCR_XSIZE = loaded_xsize-25,$
    FRAME = 1)
    
  rowb = WIDGET_BASE(loaded_base,$
    /ALIGN_LEFT,$
    /ROW)
  title = WIDGET_LABEL(rowb,$
    VALUE = 'Working on file: ')
  value = WIDGET_LABEL(rowb,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    SCR_XSIZE = 350,$
    UNAME = 'tab1_loaded_info_file')
    
  ;title to detector infos (x and y)
  det_title = WIDGET_LABEL(wTab1Base,$
    XOFFSET = 15,$
    YOFFSET = 252,$
    VALUE   = 'Detector/Files Infos')
    
  tab1_base = WIDGET_BASE(wTab1Base,$
    SCR_XSIZE = xsize-10,$
    /COLUMN)
    
  row1 = WIDGET_BUTTON(tab1_base,$
    VALUE = 'Browse for FITS file(s) ...',$
    UNAME = 'tab1_browse_fits_file_button')
    
  table_base_base = WIDGET_BASE(tab1_base,$
    /ROW)
  table = WIDGET_TABLE(table_base_base,$
    SCR_XSIZE = xsize-15,$
    SCR_YSIZE = 200,$
    XSIZE     = 1,$
    YSIZE     = (*global).max_nbr_fits_files,$
    SENSITIVE = 1,$
    COLUMN_WIDTHS = [660],$
    /NO_ROW_HEADERS,$
    COLUMN_LABELS = ['Full file name (nbr of events)'],$
    /SCROLL,$
    /CONTEXT_EVENTS,$
    /ALL_EVENTS,$
    UNAME = 'tab1_fits_table')
  space = WIDGET_LABEL(table_base_base,$
    VALUE = ' ')
    
  ;context menu
  contextBase = WIDGET_BASE(table,/CONTEXT_MENU,$
    UNAME = 'context_base')
  plot1 = WIDGET_BUTTON(contextBase,$
    VALUE = 'Plot Y vs X ...',$
    UNAME = 'tab1_right_click_plot_y_vs_x')
  plot2 = WIDGET_BUTTON(contextBase,$
    VALUE = 'Plot P vs time ...',$
    UNAME = 'tab1_right_click_plot_p_vs_c')
  data = WIDGET_BUTTON(contextBase,$
    /SEPARATOR, $
    VALUE = 'Save/Preview [X,Y,P,C] of first 5000 data ...',$
    UNAME = 'tab1_right_click_preview_data')
  delete = WIDGET_BUTTON(contextBase, $
    /SEPARATOR, $
    VALUE='Delete file(s)',$
    UNAME = 'tab1_right_click_delete')
    
  space = WIDGET_LABEL(tab1_base,$
    VALUE  = ' ')
    
  ;detector infos
  base_base = WIDGET_BASE(tab1_base,$
    /ROW)
    
  det_base = WIDGET_BASE(base_base,$
    FRAME = 1,$
    SCR_XSIZE = xsize-20,$
    /ROW)
  space_value = '      '
  label = WIDGET_LABEL(det_base,$
    VALUE = space_value + 'Number of X pixels ')
  value = WIDGET_TEXT(det_base,$
    VALUE = '4000',$
    XSIZE = 4,$
    /EDITABLE,$
    UNAME = 'tab1_x_pixels')
  label = WIDGET_LABEL(det_base,$
    VALUE = space_value + '       Number of Y pixels ')
  value = WIDGET_TEXT(det_base,$
    VALUE = '4000',$
    XSIZE = 4,$
    /EDITABLE,$
    UNAME = 'tab1_y_pixels')
  label = WIDGET_LABEL(det_base,$
    VALUE = space_value + '      Max Time ')
  max_time = STRCOMPRESS((*global).default_max_time_microS * 0.001,/REMOVE_ALL)
  value = WIDGET_TEXT(det_base,$
    VALUE = '25',$
    XSIZE = 5,$
    /EDITABLE,$
    UNAME = 'tab1_max_time')
  label = WIDGET_LABEL(det_base,$
    VALUE = 'ms')
    
  space = WIDGET_LABEL(base_base,$
    VALUE = ' ')
    
END