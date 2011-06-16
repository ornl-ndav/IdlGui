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
    scr_ysize = 220,$
    column_labels = ['Data','Normalization'],$
    /no_row_headers,$
    /row_major,$
    /scroll,$
    /context_events,$
    column_widths = [525,525],$
    /all_events)
    
  ;context_menu
  contextBase = widget_base(table,$
    /context_menu,$
    uname = 'context_base')
  plot2d = widget_button(contextBase,$
  value = 'Display 2D plots (Pixel vs TOF)...',$
  uname = 'display_pixel_vs_tof_of_input_files')

  norm = widget_button(contextBase,$
    value = 'Select a different normalization file...',$
    uname = 'select_another_norm_file',$
    /separator)
  delete = widget_button(contextBase,$
    value = 'Delete row(s)',$
    uname = 'table_delete_row',$
    /separator)
  off_off = widget_button(contextBase,$
    value = 'Off_Off for all data files',$
    uname = 'data_off_off',$
    /separator,$
    sensitive = 0)
  off_on = widget_button(contextBase,$
    value = 'Off_On for all data files',$
    uname = 'data_off_on',$
    sensitive = 0)
  on_off = widget_button(contextBase,$
    value = 'On_Off for all data files',$
    uname = 'data_on_off',$
    sensitive = 0)
  on_on = widget_button(contextBase,$
    value = 'On_On for all data files',$
    uname = 'data_on_on',$
    sensitive = 1)
    
  off_off = widget_button(contextBase,$
    value = 'Off_Off for selected normalization file',$
    uname = 'norm_off_off',$
    /separator,$
    sensitive = 0)
  off_on = widget_button(contextBase,$
    value = 'Off_On for selected normalization file',$
    uname = 'norm_off_on',$
    sensitive = 0)
  on_off = widget_button(contextBase,$
    value = 'On_Off for selected normalization file',$
    uname = 'norm_on_off',$
    sensitive = 0)
  on_on = widget_button(contextBase,$
    value = 'On_On for selected normalization file',$
    uname = 'norm_on_on',$
    sensitive = 0)
    
  ;tab0 of nexus ------------------------------------------------------------
  nexus_tab1 = widget_base(nexus_tab,$
    uname='nexus_tab1',$
    title = '  Settings  ')
    
;  ;for REF_M only, spin state selection and metadata table
;  if ((*global).instrument eq 'REF_M') then begin
  
    other_spins = widget_base(nexus_tab1,$
      xoffset = 700,$
      map = 0,$
      uname = 'ref_m_list_of_spins',$
      yoffset = 115,$
      /row)
    label = widget_label(other_spins,$
      value = 'Spins:')
    buttons = widget_base(other_spins,$
      /row,$
      /nonexclusive)
    spin1 = widget_button(buttons,$
      uname = 'config_spin_off_off',$
      sensitive = 0,$
      value = 'Off_Off')
    spin2 = widget_button(buttons,$
      uname = 'config_spin_off_on',$
      value = 'Off_On')
    spin3 = widget_button(buttons,$
      uname = 'config_spin_on_off',$
      value = 'On_Off')
    spin4 = widget_button(buttons,$
      uname = 'config_spin_on_on',$
      value = 'On_On')
    widget_control, spin1, /set_button
    ;widget_control, spin2, /set_button
    widget_control, spin3, /set_button  
    ;widget_control, spin4, /set_button  
      
;  endif
  
  _base = widget_base(nexus_tab1,$
    xoffset = 10,$
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
    value = '        ')
    
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
    
  ;size of detector
  _detector_base = widget_base(row1col4,$
    /row)
  field3 = widget_label(_detector_base,$
    value = 'Detector dimension (X*Y): ')
  pixel_x = widget_label(_detector_base,$
    value = 'N/A',$
    scr_xsize = 30,$
    /align_left, $
    uname = 'detector_dimension_x')
  field4 = widget_label(_detector_base,$
    value = 'x')
  pixel_x = widget_label(_detector_base,$
    value = 'N/A',$
    scr_xsize = 30,$
    /align_left, $
    uname = 'detector_dimension_y')
    
  space = widget_label(row1,$
    value = '     ')
    
  row1col5 = widget_base(row1,$
    /column)
    
  pixel_min = file->getValue(tag=['instruments',instrument,$
    'pixel_range','minpx'])
  field1 = cw_field(row1col5,$
    /integer,$
    xsize = 3,$
    value =  pixel_min,$
    uname = 'pixel_min',$
    title = 'Pixels:   min')
    
  pixel_max = file->getValue(tag=['instruments',instrument,$
    'pixel_range','maxpx'])
  field2 = cw_field(row1col5,$
    xsize = 3,$
    /integer,$
    value = pixel_max,$
    uname = 'pixel_max',$
    title = '          max')
    
  space = widget_label(row1,$
    value = '        ')
    
  row1col6 = widget_base(row1,$
    /column)
    
  field1 = cw_field(row1col6,$
    xsize = 10,$
    value = '',$
    uname = 'd_sd_uname',$
    title = '   Distance sample to detector (mm) ')
  field2 = cw_field(row1col6,$
    xsize = 10,$
    value = '',$
    uname = 'd_md_uname',$
    title = 'Distance moderator to detector (mm) ')
    
    
;  ;for REF_M only, spin state selection and metadata table
;  if ((*global).instrument eq 'REF_M') then begin
  
    row2 = widget_base(para_box,$
    uname = 'ref_m_metadata_table_base',$
    map = 0,$
      /row)
      
    row_array = [0,0,1,1,1,1,1]
    editable_array = intarr(7,max_nbr_data_nexus)
    for i=0,(max_nbr_data_nexus-1) do begin
      editable_array[*,i] = row_array
    endfor
    
    widths = [250,80,50,50,200,200,200]
    metadata_table = widget_table(row2,$
      uname = 'ref_m_metadata_table',$
      editable = editable_array, $
      xsize = 7,$
      ysize = max_nbr_data_nexus, $
      column_labels=$
      ['File','Spin','dirpix','refpix','dangle [deg(rad)]',$
      'dangle0 [deg(rad])','sangle [deg(rad)]'],$
      column_widths=widths,$
      scr_xsize = 1050,$
      scr_ysize = 300,$
      /no_row_headers, $
      /row_major,$
      /scroll,$
      /context_events, $
      /all_events)
      
    ;context_menu
    contextBase = widget_base(metadata_table,$
      /context_menu,$
      uname = 'metadata_context_base')
    refpix_button = widget_button(contextBase,$
      value = 'Set refpix ...',$
      uname = 'set_refpix_button')
      
;  endif
  
  if ((*global).hide_tab_2 eq 'no') then begin
  
    ;********* tab 2 **********************************************************
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
      uname = 'rtof_browse_data_file',$
      scr_xsize = 100)
    value = widget_text(row1, $
      value = '', $
      xsize = 132, $
      /all_events, $
      /editable, $
      uname = 'rtof_file_text_field_uname')
    load = widget_button(row1,$
      value = ' Load ',$
      uname = 'load_rtof_file_button',$
      sensitive = 0)
    preview = widget_button(row1, $
      value = ' Preview ', $
      uname = 'rtof_file_preview_button',$
      event_pro = 'rtof_file_preview_button_eventcb', $
      sensitive = 0)
    ;      scr_xsize = 80)
    plot = widget_button(row1,$
      value = ' Plot ',$
      uname = 'rtof_file_plot_button',$
      event_pro = 'rtof_file_plot_button_eventcb',$
      sensitive = 0)
      
    ;SPACE - Parametrs coming from loaded file
    space = widget_label(_base1,$
      value = ' ')
      
    ;nexus file that will be used
    row2 = widget_base(_base1,$
      uname = 'rtof_nexus_base',$
      map = 0,$
      /row)
      
    label = widget_label(row2, $
      value = 'NeXus file:  ')
    value = widget_text(row2, $
      value = '', $
      xsize = 130, $
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
      
    rowc = widget_base(row1col2,$
      /row)
    label = widget_label(rowc,$
      /align_left,$
      value = '   TOF (ms):')
    value = widget_label(rowc,$
      value = 'N/A',$
      /align_left,$
      uname = 'rtof_tof_min',$
      scr_xsize =60)
      
    ;  tof_min = file->getValue(tag=['instruments',instrument,$
    ;    'tof','mintof'])
    ;  field3 = cw_field(row1col2,$
    ;    xsize = 8,$
    ;    /floating,$
    ;    value = tof_min,$
    ;    uname = 'rtof_tof_min',$
    ;    title = '   TOF (ms)')
      
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
      
    rowc = widget_base(row1col3,$
      /row)
    label = widget_label(rowc,$
      /align_left,$
      value = 'to   ')
    value = widget_label(rowc,$
      value = 'N/A',$
      /align_left,$
      uname = 'rtof_tof_max',$
      scr_xsize =100)
      
    space = widget_label(row1,$
      value = '       ')
      
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
      
    space = widget_label(row1,$
      value = '     ')
      
    row1col5 = widget_base(row1,$
      /column)
    rowa = widget_base(row1col5,$
      /row)
    field1 = cw_field(rowa,$
      /floating,$
      xsize = 10,$
      value = ' ',$
      uname = 'rtof_theta_value',$
      title = '       Theta')
    label = widget_label(rowa,$
      value = ' ',$
      uname = 'rtof_theta_units',$
      scr_xsize = 50)
      
    rowa = widget_base(row1col5,$
      /row)
    field1 = cw_field(rowa,$
      /floating,$
      xsize = 10,$
      value = ' ',$
      uname = 'rtof_twotheta_value',$
      title = '   Two Theta')
    label = widget_label(rowa,$
      value = ' ',$
      uname = 'rtof_twotheta_units',$
      scr_xsize = 50)
      
    row2 = widget_base(para_box,$
      /align_left,$
      /row)
    row2col1 = widget_base(row2,$
      /column)
      
    ;  pixel_min = file->getValue(tag=['instruments',instrument,$
    ;    'pixel_range','minpx'])
    rowa = widget_base(row2col1,$
      /row)
    label = widget_label(rowa,$
      value = 'Pixels:   min: ')
    label = widget_label(rowa,$
      value = 'N/A',$
      /align_left, $
      scr_xsize = 50,$
      uname = 'rtof_pixel_min')
      
    ;  pixel_max = file->getValue(tag=['instruments',instrument,$
    ;    'pixel_range','maxpx'])
    rowb = widget_base(row2col1,$
      /row)
    label = widget_label(rowb,$
      value = '          max: ')
    label = widget_label(rowb,$
      /align_left, $
      value = 'N/A',$
      scr_xsize = 50,$
      uname = 'rtof_pixel_max')
      
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
    title = '    GENERAL SETTINGS    ')
    
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
    
  ;********* tab 4 - OUTPUT **************************************************
  base3 = widget_base(tabs,$
    uname = 'tab3',$
    title = '    CREATE OUTPUT     ')
    
  base = widget_base(base3,$
    /column)
    
  ;where
  row1 = widget_base(base,$
    /row)
  label = widget_label(row1,$
    value = 'Where:')
  button = widget_button(row1,$
    value = (*global).output_path, $
    uname = 'output_path_button',$
    scr_xsize = 1020)
    
  ;file name
  row2 = widget_base(base,$
    /row)
  label = widget_label(row2,$
    value = 'File Name:')
  value = widget_text(row2,$
    value = '',$
    /editable, $
    /all_events, $
    xsize = 125,$
    uname = 'output_file_name')
  label = widget_label(row2,$
    value = '_<extension>.txt    ')
  preview = widget_button(row2,$
    value = '  PREVIEW...  ',$
    sensitive = 0,$
    uname = 'preview_output_file')
    
  space = widget_label(base,$
    value = ' ')
    
  label_base = widget_base(base,$
    /row,$
    /align_left)
  label = widget_label(label_base,$
    value = 'Create output(s) of:')
  ;which plot to output
  row3 = widget_base(base,$
    /column,$
    /nonexclusive)
  nexus_button = widget_button(row3,$
    value = 'Last data set created in WORKING WITH NEXUS' + $
    ' (ext: ' + (*global).nexus_ext + ')', $
    uname = 'output_working_with_nexus_plot', $
    sensitive = 0)
  rtof_button = widget_button(row3,$
    value = 'Last data set created in WORKING WITH RTOF' + $
    ' (ext: ' + (*global).rtof_ext + ')', $
    uname = 'output_working_with_rtof_plot', $
    sensitive = 0)
    
  space = widget_label(base,$
    value = ' ')
    
  ;output format
  row4 = widget_base(base,$
    /row)
  label = widget_label(row4,$
    value = 'Output Format:')
  format = widget_droplist(row4,$
    value = [' xy Many z '],$
    uname = 'output_format',$
    scr_xsize = 100)
  space = widget_label(row4,$
    value = '   ')
  draw_base = widget_base(row4)
  example = widget_draw(draw_base,$
    yoffset = 5, $
    scr_xsize = 50,$
    scr_ysize = 25,$
    /tracking_events, $
    retain=2,$
    uname = 'example_of_output_format_draw')
    
  space = widget_label(base,$
    value = ' ')
    
  ;send by email
  row5 = widget_base(base,$
    /row)
  button_base = widget_base(row5,$
    /row,$
    /nonexclusive)
  button = widget_button(button_base,$
    uname = 'email_switch_uname',$
    value = 'Email file(s)')
  email_base = widget_base(row5,$
    uname = 'email_base',$
    map=0,$
    /row)
  to = widget_text(email_base,$
    value ='',$
    /editable,$
    /all_events, $
    uname = 'email_to_uname',$
    xsize = 50)
  label = widget_label(email_base,$
    value = 'Subject:')
  subject = widget_text(email_base,$
    /editable,$
    uname = 'email_subject_uname',$
    value = '',$
    xsize = 90)
    
  space = widget_label(base,$
    value = ' ')
  space = widget_label(base,$
    value = ' ')
  space = widget_label(base,$
    value = ' ')
    
  ;create output button
  create_base = widget_base(base,$
    /row,$
    /align_center)
  button = widget_button(create_base,$
    uname = 'create_output_button',$
    sensitive = 0,$
    scr_xsize = 1020,$
    value = 'Create File')
    
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
