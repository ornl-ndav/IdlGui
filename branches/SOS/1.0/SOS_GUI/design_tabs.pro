;===============================================================================
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
;===============================================================================

pro design_tabs, MAIN_BASE, global
  compile_opt idl2
  
  bFindnexus = (*global).bFindnexus
  
  tabs = widget_tab(MAIN_BASE,$
    /tracking_events, $
    uname = 'tab_uname')
    
  ;********* tab 1 ***********************************************************
  base1 = widget_base(tabs,$
    uname = 'tab0',$
    title = '    WORKING WITH NEXUS    ')
    
  nexus_tab = widget_tab(base1,$
    /tracking_events,$
    uname= 'nexus_tab_uname')
    
  ;tab0 of nexus ------------------------------------------------------------
  nexus_tab0 = widget_base(nexus_tab,$
    uname='nexus_tab0',$
    title = '  Input Files  ')
    
  _base1 = widget_base(nexus_tab0,$
    /column)
    
  ;DATA
  data_box = widget_base(_base1,$
    frame = 1,$
    /align_center,$
    /base_align_center,$
    /column)
    
  ;display those widgets if findnexus is in the path
  if (bFindnexus) then begin
  
    row1 = widget_base(data_box,/row)
    label = widget_label(row1,$
      value = ' Data run numbers:')
    text = widget_text(row1,$
      value = '',$
      /editable,$
      uname = 'data_run_numbers_text_field',$
      xsize = 100)
    ex = widget_label(row1,$
      value = '(ex: 200,2004-2006)')
      
    row2 = widget_label(data_box,$
      value = 'OR')
      
  endif
  
  row3 = widget_button(data_box,$
    value = 'Browse for data NeXus files ...',$
    uname = 'data_browse_button',$
    scr_xsize = 575)
    
  space = widget_label(_base1,$
    value = ' ')
    
  ;NORMALIZATION
  norm_box = widget_base(_base1,$
    frame = 1,$
    /align_center,$
    /base_align_center,$
    /column)
    
  ;display those widgets if findnexus is in the path
  if (bFindnexus) then begin
  
    row1 = widget_base(norm_box,/row)
    label = widget_label(row1,$
      value = 'Norm. run numbers:')
    text = widget_text(row1,$
      value = '',$
      /editable,$
      uname = 'norm_run_numbers_text_field',$
      xsize = 100)
      
    ex = widget_label(row1,$
      value = '(ex: 200,2004-2006)')
      
    row2 = widget_label(norm_box,$
      value = 'OR')
      
  endif
  
  norm_row = widget_base(norm_box,$
    /row)
  button = widget_button(norm_row,$
    uname = 'norm_browse_button',$
    value = 'Browse for a normalization NeXus file ...',$
    scr_xsize = 575)
    
  space = widget_label(_base1,$
    value = ' ')
    
  ;big table of data and norm files loaded
  max_nbr_data_nexus = (*global).max_nbr_data_nexus
  table = widget_table(_base1,$
    uname = 'tab1_table',$
    xsize = 2,$
    ysize = max_nbr_data_nexus,$
    column_labels = ['Data','Normalization'],$
    /no_row_headers,$
    /row_major,$
    /scroll,$
    /context_events,$
    column_widths = [425,425],$
    /all_events)
    
  ;context_menu
  contextBase = widget_base(table,$
    /context_menu,$
    uname = 'context_base')
  norm = widget_button(contextBase,$
    value = 'Select a different normalization file...',$
    uname = 'select_another_norm_file')
  delete = widget_button(contextBase,$
    value = 'Delete row(s)',$
    uname = 'table_delete_row',$
    /separator)
    
  ;tab0 of nexus ------------------------------------------------------------
  nexus_tab1 = widget_base(nexus_tab,$
    uname='nexus_tab1',$
    title = '  Configuration  ')
    
  _base = widget_base(nexus_tab1,$
    xoffset = 100,$
    yoffset = 20,$
    /column)
    
  ;PARAMETERS
    
  ;read xml instrument config file
  config_file = (*global).instrument_config_file
  file = OBJ_NEW('IDLxmlParser', config_file)
  instrument = (*global).instrument
  
  para_box = widget_base(_base,$
    frame = 1,$
    /align_center,$
    /base_align_center,$
    /column)
    
  row1 = widget_base(para_box,$
    /row)
    
  row1col2 = widget_base(row1,$
    /column)
    
  ranges_qx_min = file->getValue(tag=['instruments',instrument,$
    'ranges_qx','minqx'])
  field1 = cw_field(row1col2,$
    /floating,$
    xsize = 8,$
    uname = 'ranges_qx_min',$
    value = ranges_qx_min,$
    title = 'Ranges:  Qx')
    
  ranges_qz_min = file->getValue(tag=['instruments',instrument,$
    'ranges_qz','minqz'])
  field2 = cw_field(row1col2,$
    xsize = 8,$
    /floating,$
    value = ranges_qz_min,$
    uname = 'ranges_qz_min',$
    title = '         Qz')
    
  tof_min = file->getValue(tag=['instruments',instrument,$
    'tof','mintof'])
  field3 = cw_field(row1col2,$
    xsize = 8,$
    /floating,$
    value = tof_min,$
    uname = 'tof_min',$
    title = '   TOF (ms)')
    
  row1col3 = widget_base(row1,$
    /column)
  ranges_qx_max = file->getValue(tag=['instruments',instrument,$
    'ranges_qx','maxqx'])
  field1 = cw_field(row1col3,$
    /floating,$
    xsize = 8,$
    uname = 'ranges_qx_max',$
    value = ranges_qx_max,$
    title = 'to  ')
    
  ranges_qz_max = file->getValue(tag=['instruments',instrument,$
    'ranges_qz','maxqz'])
  field21 = cw_field(row1col3,$
    xsize = 8,$
    /floating,$
    uname = 'ranges_qz_max',$
    value = ranges_qz_max,$
    title = 'to  ')
    
  tof_max = file->getValue(tag=['instruments',instrument,$
    'tof','maxtof'])
  field3 = cw_field(row1col3,$
    xsize = 8,$
    /floating,$
    uname = 'tof_max',$
    value = tof_max,$
    title = 'to  ')
    
  space = widget_label(row1,$
    value = '                                   ')
    
  row1col4 = widget_base(row1,$
    /column)
    
  center_pixel = file->getValue(tag=['instruments',instrument,$
    'center_pixel'])
  field1 = cw_field(row1col4,$
    /floating,$
    xsize = 8,$
    value = center_pixel,$
    uname = 'center_pixel',$
    title = '   Center pixel')
    
  pixel_size = file->getValue(tag=['instruments',instrument,$
    'pixel_size'])
  field2 = cw_field(row1col4,$
    xsize = 8,$
    /floating,$
    value = pixel_size,$
    uname = 'pixel_size',$
    title = 'Pixel size (mm)')
    
  row2 = widget_base(para_box,$
    /align_left,$
    /row)
  row2col1 = widget_base(row2,$
    /column)
    
  pixel_min = file->getValue(tag=['instruments',instrument,$
    'pixel_range','minpx'])
  field1 = cw_field(row2col1,$
    /integer,$
    xsize = 3,$
    value =  pixel_min,$
    uname = 'pixel_min',$
    title = 'Pixels:   min')
    
  pixel_max = file->getValue(tag=['instruments',instrument,$
    'pixel_range','maxpx'])
  field2 = cw_field(row2col1,$
    xsize = 3,$
    /integer,$
    value = pixel_max,$
    uname = 'pixel_max',$
    title = '          max')
    
  space = widget_label(row2,$
    value = '                                 ')
    
  row2col2 = widget_base(row2,$
    /column)
  field1 = cw_field(row2col2,$
    xsize = 10,$
    value = '',$
    uname = 'd_sd_uname',$
    title = '   Distance sample to detector (mm) ')
  field2 = cw_field(row2col2,$
    xsize = 10,$
    value = '',$
    uname = 'd_md_uname',$
    title = 'Distance moderator to detector (mm) ')
        
  if ((*global).hide_tab_2 eq 'no') then begin
  
    ;********* tab 2 ***********************************************************
    base1 = widget_base(tabs,$
      uname = 'tab1',$
      title = '    WORKING WITH RTOF    ')
      
    _base1 = widget_base(base1,$
      /column)
      
    ;input base
    row1 = widget_base(_base1, $
      /row,$
      frame = 1)
    button = widget_button(row1, $
      value = 'Browse ...',$
      event_pro = 'browse_for_rtof_file_button', $
      scr_xsize = 100)
    value = widget_text(row1, $
      value = '', $
      xsize = 102, $
      /all_events, $
      /editable, $
      uname = 'rtof_file_text_field_uname')
    load = widget_button(row1,$
      value = 'Load',$
      uname = 'load_rtof_file_button',$
      sensitive = 0)
    preview = widget_button(row1, $
      value = 'Preview...', $
      uname = 'rtof_file_preview_button',$
      event_pro = 'rtof_file_preview_button_eventcb', $
      sensitive = 0, $
      scr_xsize = 80)
      
    ;SPACE - Parametrs coming from loaded file
    space = widget_label(_base1,$
      value = ' ')
      
    ;nexus file that will be used
    row2 = widget_base(_base1,$
      uname = 'rtof_nexus_base',$
      map = 0,$
      /row)
      
    label = widget_label(row2, $
      value = 'Geometry file:  ')
    value = widget_text(row2, $
      value = '', $
      xsize = 93, $
      /all_events, $
      /editable,$
      uname = 'rtof_nexus_geometry_file')
    status = widget_draw(row2,$
      retain = 2,$
      uname = 'rtof_nexus_file_status_uname',$
      scr_ysize = 30,$
      scr_xsize = 60)
    label = widget_label(row2,$
      value = ' OR ')
    button = widget_button(row2,$
      value = ' Browse ... ',$
      uname = 'rtof_nexus_geometry_button')
      
    ;SPACE - User defined parameters
    space = widget_label(_base1,$
      value = ' ')
      
  ;PARAMETERS
    
  ;read xml instrument config file
  config_file = (*global).instrument_config_file
  file = OBJ_NEW('IDLxmlParser', config_file)
  instrument = (*global).instrument
  
  para_box = widget_base(_base1,$
    frame = 1,$
    /align_center, $
    uname = 'rtof_configuration_base',$
    map = 0,$
    /base_align_center,$
    /column)
    
  row1 = widget_base(para_box,$
    /row)
    
  row1col2 = widget_base(row1,$
    /column)
    
  ranges_qx_min = file->getValue(tag=['instruments',instrument,$
    'ranges_qx','minqx'])
  field1 = cw_field(row1col2,$
    /floating,$
    xsize = 8,$
    uname = 'rtof_ranges_qx_min',$
    value = ranges_qx_min,$
    title = 'Ranges:  Qx')
    
  ranges_qz_min = file->getValue(tag=['instruments',instrument,$
    'ranges_qz','minqz'])
  field2 = cw_field(row1col2,$
    xsize = 8,$
    /floating,$
    value = ranges_qz_min,$
    uname = 'rtof_ranges_qz_min',$
    title = '         Qz')
    
  tof_min = file->getValue(tag=['instruments',instrument,$
    'tof','mintof'])
  field3 = cw_field(row1col2,$
    xsize = 8,$
    /floating,$
    value = tof_min,$
    uname = 'rtof_tof_min',$
    title = '   TOF (ms)')
    
  row1col3 = widget_base(row1,$
    /column)
  ranges_qx_max = file->getValue(tag=['instruments',instrument,$
    'ranges_qx','maxqx'])
  field1 = cw_field(row1col3,$
    /floating,$
    xsize = 8,$
    uname = 'rtof_ranges_qx_max',$
    value = ranges_qx_max,$
    title = 'to  ')
    
  ranges_qz_max = file->getValue(tag=['instruments',instrument,$
    'ranges_qz','maxqz'])
  field21 = cw_field(row1col3,$
    xsize = 8,$
    /floating,$
    uname = 'rtof_ranges_qz_max',$
    value = ranges_qz_max,$
    title = 'to  ')
    
  tof_max = file->getValue(tag=['instruments',instrument,$
    'tof','maxtof'])
  field3 = cw_field(row1col3,$
    xsize = 8,$
    /floating,$
    uname = 'rtof_tof_max',$
    value = tof_max,$
    title = 'to  ')
    
  space = widget_label(row1,$
    value = '                             ')
    
  row1col4 = widget_base(row1,$
    /column)
    
  center_pixel = file->getValue(tag=['instruments',instrument,$
    'center_pixel'])
  field1 = cw_field(row1col4,$
    /floating,$
    xsize = 8,$
    value = center_pixel,$
    uname = 'rtof_center_pixel',$
    title = '   Center pixel')
    
  pixel_size = file->getValue(tag=['instruments',instrument,$
    'pixel_size'])
  field2 = cw_field(row1col4,$
    xsize = 8,$
    /floating,$
    value = pixel_size,$
    uname = 'rtof_pixel_size',$
    title = 'Pixel size (mm)')
    
  row2 = widget_base(para_box,$
    /align_left,$
    /row)
  row2col1 = widget_base(row2,$
    /column)
    
  pixel_min = file->getValue(tag=['instruments',instrument,$
    'pixel_range','minpx'])
  field1 = cw_field(row2col1,$
    /integer,$
    xsize = 3,$
    value =  pixel_min,$
    uname = 'rtof_pixel_min',$
    title = 'Pixels:   min')
    
  pixel_max = file->getValue(tag=['instruments',instrument,$
    'pixel_range','maxpx'])
  field2 = cw_field(row2col1,$
    xsize = 3,$
    /integer,$
    value = pixel_max,$
    uname = 'rtof_pixel_max',$
    title = '          max')
    
  space = widget_label(row2,$
    value = '                                ')
    
  row2col2 = widget_base(row2,$
    /column)
  field1 = cw_field(row2col2,$
    xsize = 10,$
    value = '',$
    uname = 'rtof_d_sd_uname',$
    title = '   Distance sample to detector (mm) ')
  field2 = cw_field(row2col2,$
    xsize = 10,$
    value = '',$
    uname = 'rtof_d_md_uname',$
    title = 'Distance moderator to detector (mm) ')
      
  endif
  
  ;***** general configuration tab *******************************************
  
      base1 = widget_base(tabs,$
      uname = 'tab2',$
      title = '    GENERAL CONFIGURATION    ')
      
    _base1 = widget_base(base1,$
    xoffset= 160,$
    yoffset= 40,$
      /column)
  
    ;read xml instrument config file
  config_file = (*global).instrument_config_file
  file = OBJ_NEW('IDLxmlParser', config_file)
  instrument = (*global).instrument
  
  para_box = widget_base(_base1,$
    frame = 1,$
    /base_align_center,$
    /column)
    
  row1 = widget_base(para_box,$
    /row)
  row1col1 = widget_base(row1,$
    /column)
    
  bins_qx = file->getValue(tag=['instruments',instrument,'bins_qx'])
  field1 = cw_field(row1col1,$
    /integer,$
    xsize = 6,$
    value = bins_qx,$
    uname = 'bins_qx',$
    ;    title = 'Bins:  Qx (' + string("305B) + ')')
    title = 'Bins:  Qx')
  ;     title = 'Bins:  Qx (' + angstrom + ')')
    
  bins_qz = file->getValue(tag=['instruments',instrument,'bins_qz'])
  field2 = cw_field(row1col1,$
    xsize = 6,$
    /integer,$
    value = bins_qz,$
    uname = 'bins_qz',$
    title = '       Qz')
    
  space = widget_label(row1,$
    value = '              ')
    
  row1col2 = widget_base(row1,$
    /column)
        
  ;specular reflexion parameters
  row1col2 = widget_base(row1,$
    /column)
    
  specular_qxwidth = file->getValue(tag=['instruments',instrument,$
    'specular_reflection','qxwidth'])
  field1 = cw_field(row1col2,$
    /floating,$
    xsize = 10,$
    value = specular_qxwidth,$
    uname = 'qxwidth_uname',$
    title = '       Specular reflection    QxWidth')
    
  tnum = file->getValue(tag=['instruments',instrument,$
    'specular_reflection','tnum'])
  field2 = cw_field(row1col2,$
    /integer,$
    xsize = 5,$
    value = tnum,$
    uname = 'tnum_uname',$
    title = '                                 tnum')
  

  ;******* bottom part of GUI ************************************************
  
  ;progress bar and go button
  bottom_box = widget_base(main_base,$
    /align_center,$
    /row)
    
  full_reset = widget_button(bottom_box,$
    value = 'FULL RESET',$
    uname = 'full_reset')
    
  space = widget_label(bottom_box,$
    value = '           ')
    
  progress_base = widget_base(bottom_box,$
    uname = 'progress_bar_base',$
    map = 0)
  progress_bar = widget_draw(progress_base,$
    scr_xsize = 400,$
    uname = 'progress_bar_uname',$
    scr_ysize = 15)
    
  space = widget_label(bottom_box,$
    value = '           ')
    
  ok = widget_button(bottom_box,$
    uname = 'go_button',$
    sensitive = 0,$
    value = '>   >  > >> G O << <  <   <')
    
end
