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

PRO make_gui_main_tab, MAIN_BASE, MainBaseSize, global

  ;define widget variables
  ;[xoffset, yoffset, scr_xsize, scr_ysize]
  sMainTabSize = {size : [0,0,MainBaseSize[2],MainBaseSize[3]],$
    uname : 'main_tab'}
    
  ;Tab titles
  TabTitles = { tab1:     ' LOAD DATA ',$
    log_book: ' LOG BOOK ',$
    plot:     ' PLOT',$
    reduce:   ' REDUCE '}
    
  ;Use configure file or not
  id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  config_size = [200,80]
  config_offset = [(main_base_geometry.xsize - config_size[0])/2,$
    (main_base_geometry.ysize - config_size[1]) / 2]
  config_base = WIDGET_BASE(MAIN_BASE,$
    XOFFSET = config_offset[0],$
    YOFFSET = config_offset[1],$
    SCR_XSIZE = config_size[0],$
    SCR_YSIZE = config_size[1],$
    MAP       = 0,$
    UNAME     = 'config_base',$
    FRAME = 5,$
    /ALIGN_CENTER,$
    /COLUMN)
  label = WIDGET_LABEL(config_base,$
    VALUE = 'Do you want to load the')
  label = WIDGET_LABEL(config_base,$
    VALUE = 'configuration file ?')
  row = WIDGET_BASE(config_base,$
    /ROW,$
    /ALIGN_CENTER)
  yes = WIDGET_BUTTON(row,$
    VALUE = 'YES',$
    SCR_XSIZE = 60,$
    UNAME = 'config_base_yes')
  space = WIDGET_LABEL(row,$
    VALUE = '    ')
  no = WIDGET_BUTTON(row,$
    VALUE = 'NO',$
    SCR_XSIZE = 60,$
    UNAME = 'config_base_no')
    
  ;build widgets
  MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
    UNAME     = sMainTabSize.uname,$
    LOCATION  = 0,$
    XOFFSET   = sMainTabSize.size[0],$
    YOFFSET   = sMainTabSize.size[1],$
    SCR_XSIZE = sMainTabSize.size[2],$
    SCR_YSIZE = sMainTabSize.size[3],$
    SENSITIVE = 1,$
    /TRACKING_EVENTS)
    
  ;Build Load Data Tab
  make_gui_tab1, MAIN_TAB, sMainTabSize.size, TabTitles, global
  
  ;Build REDUCE tab
  make_gui_reduce_tab, MAIN_TAB, sMainTabSize.size, TabTitles
  
  ;Build PLOT tab
  make_gui_plot, MAIN_TAB, sMainTabSize.size, TabTitles
  
  ;Build LogBook
  make_gui_log_book, MAIN_TAB, sMainTabSize.size, TabTitles
  
END

