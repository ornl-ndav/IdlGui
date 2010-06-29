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

PRO make_gui_reduce_jk_tab1, REDUCE_TAB, tab_size, tab_title

  ;= Build Widgets ==============================================================
  BaseTab = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = 'reduce_jk_tab1_base_uname',$
    XOFFSET   = tab_size[0],$
    YOFFSET   = tab_size[1],$
    SCR_XSIZE = tab_size[2],$
    SCR_YSIZE = tab_size[3],$
    TITLE     = tab_title)
    
  base = WIDGET_BASE(BaseTab,$
    /BASE_ALIGN_CENTER,$
    SCR_XSIZE = tab_size[2],$
    /COLUMN)
    
  space = WIDGET_LABEL(base,$
    VALUE = ' ')
    
  info_base = WIDGET_BASE(base,$
    /COLUMN,$
    FRAME = 1,$
    MAP = 1)
    
  row0 = WIDGET_BASE(info_base,$
    /ROW)
  label = WIDGET_LABEL(row0,$
    VALUE = '        Run Number:')
  value = WIDGET_LABEL(row0,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'reduce_jk_tab1_run_information_run_number',$
    FRAME = 1,$
    SCR_XSIZE = 50)
    
  rowa = WIDGET_BASE(info_base,$
    /ROW)
  label = WIDGET_LABEL(rowa,$
    VALUE = '         Run Title:')
  value = WIDGET_LABEL(rowa,$
    VALUE = ' N/A',$
    /ALIGN_LEFT,$
    UNAME = 'reduce_jk_tab1_run_information_run_title',$
    FRAME = 1,$
    SCR_XSIZE = 850)
    
  rowb = WIDGET_BASE(info_base,$
    /ROW)
  label = WIDGET_LABEL(rowb,$
    VALUE = '         Run Notes:')
  value = WIDGET_LABEL(rowb,$
    VALUE = ' N/A',$
    FRAME = 1,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_jk_tab1_run_information_run_notes',$
    SCR_XSIZE = 850)
    
  rowc = WIDGET_BASE(info_base,$
    /ROW)
  label = WIDGET_LABEL(rowc,$
    VALUE = '   Start Date/Time:')
  value = WIDGET_LABEL(rowc,$
    VALUE = ' N/A',$
    FRAME = 1,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_jk_tab1_run_information_start_time',$
    SCR_XSIZE = 200)
  label = WIDGET_LABEL(rowc,$
    VALUE = 'Total Run Time:')
  value = WIDGET_LABEL(rowc,$
    VALUE = ' N/A',$
    /ALIGN_LEFT,$
    UNAME = 'reduce_jk_tab1_run_information_total_time',$
    FRAME = 1,$
    SCR_XSIZE = 200)
    
  rowd = WIDGET_BASE(info_base,$
    /ROW)
  label = WIDGET_LABEL(rowd,$
    VALUE = 'Total Acc. Current:')
  value = WIDGET_LABEL(rowd,$
    VALUE = ' N/A',$
    FRAME = 1,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_jk_tab1_run_information_total_current',$
    SCR_XSIZE = 200)
  label = WIDGET_LABEL(rowd,$
    VALUE = 'Total Detector Counts:')
  value = WIDGET_LABEL(rowd,$
    VALUE = ' N/A',$
    FRAME = 1,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_jk_tab1_run_information_total_detector_counts', $
    SCR_XSIZE = 200)
  label = WIDGET_LABEL(rowd,$
    VALUE = 'Total Monitor Counts:')
  value = WIDGET_LABEL(rowd,$
    VALUE = ' N/A',$
    /ALIGN_LEFT,$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_total_monitor_counts', $
    SCR_XSIZE = 164)
    
  rowe = WIDGET_BASE(info_base,$
    /ROW)
  label = WIDGET_LABEL(rowe,$
    VALUE = 'Wavelength Range (band with pulse width of 20us/A):')
  value1 = WIDGET_LABEL(rowe,$
    VALUE = ' N/A',$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_wave_range_min',$
    SCR_XSIZE = 100)
  label = WIDGET_LABEL(rowe,$
    VALUE = '->')
  value = WIDGET_LABEL(rowe,$
    VALUE = ' N/A',$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_wave_range_max',$
    SCR_XSIZE = 100)
  units = WIDGET_LABEL(rowe,$
    VALUE = ' N/A',$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_wave_range_units',$
    SCR_XSIZE = 50)
        
  rowe2 = WIDGET_BASE(rowe,$
    /ROW,$
    UNAME = 'reduce_jk_tab1_run_information_wave_range2_base',$
    MAP = 0)
  label = WIDGET_LABEL(rowe2,$
    VALUE = ' + ')
  value1 = WIDGET_LABEL(rowe2,$
    VALUE = ' N/A',$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_wave_range2_min',$
    SCR_XSIZE = 100)
  label = WIDGET_LABEL(rowe2,$
    VALUE = '->')
  value = WIDGET_LABEL(rowe2,$
    VALUE = ' N/A',$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_wave_range2_max',$
    SCR_XSIZE = 100)
  units = WIDGET_LABEL(rowe2,$
    VALUE = ' N/A',$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_wave_range2_units',$
    SCR_XSIZE = 50)
    
  rowf = WIDGET_BASE(info_base,$
    /ROW)
  label = WIDGET_LABEL(rowf,$
    VALUE = 'Distance Sample-Detector:')
  value = WIDGET_LABEL(rowf,$
    VALUE = ' N/A',$
    FRAME = 1,$
    UNAME = 'reduce_jk_tab1_run_information_sample_detector',$
    SCR_XSIZE = 150,$
    /ALIGN_LEFT)
  label = WIDGET_LABEL(rowf,$
    VALUE = '<- (Go to ADVANCED/PART 1 to change this value)')
  space = WIDGET_LABEL(rowf,$
    VALUE = '                                   ')
  more = WIDGET_BUTTON(rowf,$
    VALUE = 'MORE INFOS ...',$
    SENSITIVE = 0,$
    UNAME = 'reduce_jk_tab1_run_more_infos',$
    SCR_XSIZE = 150)
    
  ;text box that will display run information
  text_base = WIDGET_BASE(base,$
    MAP=0,$
    UNAME = 'reduce_jk_tab1_run_information_base',$
    /COLUMN)
  text = WIDGET_TEXT(text_base,$
    VALUE = '',$
    UNAME = 'reduce_jk_tab1_run_information_text',$
    XSIZE = 140,$
    YSIZE = 29)
    
END
