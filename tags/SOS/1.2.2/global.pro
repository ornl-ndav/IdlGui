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

;+
; :Description:
;    this function creates and return the global structure
;
; :Author: j35
;-
function getGlobal
  compile_opt idl2
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = get_ucams()
  ENDELSE
  
  file = OBJ_NEW('IDLxmlParser', '.SOS.cfg')
  ;============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION  = file->getValue(tag=['configuration','version'])
  DEBUGGER = file->getValue(tag=['configuration','debugging'])
  help = file->getValue(tag=['configuration','help'])
  debugging_instrument = file->getValue(tag=['configuration','instrument'])
  auto_cleaning_data = file->getValue(tag=['configuration','auto_cleaning'])
  scaled_specular = file->getValue(tag=['configuration','plot',$
    'scaled_specular'])
  hide_tab_2 = file->getValue(tag=['configuration','hide_tab_2'])
  max_nbr_data_nexus = file->getValue(tag=['configuration',$
    'max_nbr_data_nexus'])
  default_spin_state = file->getValue(tag=['configuration',$
    'default_spin_state'])
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  ;============================================================================
  obj_destroy, file
  
  StrArray      = strsplit(VERSION,'.',/extract)
  VerArray      = StrArray[0]
  TagArray      = StrArray[1]
  BranchArray   = StrArray[2]
  CurrentBranch =  VerArray + '.' + TagArray
  
  if (auto_cleaning_data eq 'yes') then begin
    auto_cleaning = 1b
  endif else begin
    auto_cleaning = 0b
  endelse
  
  date = GenerateReadableIsoTimeStamp()
  
  if (strlowcase(debugger) eq 'yes') then begin
    instrument = 'REF_L'
  endif else begin
    instrument = getInstrument()
  endelse
  
  global = ptr_new({ $
  
    config_path: '~/',$ ;where the config file will be created/load from
  
    help_to_use: help, $ ;'local' or 'deployed'
    myHelp: '/Users/j35/IDLWorkspace80/SOS 1.0/help/index.html', $
    Help: '/SNS/software/idltools/help/SOS/index.html', $
    
    list_spins: ['Off_Off','Off_On','On_Off','On_On'], $
    
    application: APPLICATION, $
    ucams: ucams, $
    version: VERSION, $
    debugger: debugger, $
    scaled_specular: scaled_specular, $
    hide_tab_2: hide_tab_2, $
    max_nbr_data_nexus: max_nbr_data_nexus, $
    main_base_xsize: 0L, $ ;scr_xsize of application
    main_base_ysize: 0L, $
    
    table_ysize: 0L, $
    table_xsize: 0L, $
    table_metadata_ysize: 0L, $
    table_metadata_xsize: 0L, $
    
    ;create output tab
    sample_info_base: 0L, $  ;base that will show the sample output
    nexus_ext: '_fromNeXus.txt', $
    rtof_ext: '_fromRTOF.txt', $
    
    ;data and normalization files
    big_table: strarr(2,max_nbr_data_nexus), $
    
    ;where all the parameters are defined
    instrument_config_file: './SOS_instruments.cfg', $
    
    ;structure of data from NeXus and rtof tabs
    structure_data_working_with_nexus: ptr_new({ data:ptr_new(0L), $
    xaxis: ptr_new(0L), $
    yaxis: ptr_new(0L)}), $
    structure_data_working_with_rtof: ptr_new({ data:ptr_new(0L), $
    xaxis: ptr_new(0L), $
    yaxis: ptr_new(0L)}), $
    
    create_output_status_rtof: 0b, $   ;status of rtof button
    create_output_status_nexus: 0b, $  ;status of nexus button
    
    ;default spin state to use when just loading a file
    default_spin_state: default_spin_state, $
    
    instrument: instrument,$ ;name of instrument
    PrevTabSelect: 0, $
    NexusPrevTabSelect: 0, $
    
    SD_d: 0., $ ;distance sample detector
    MD_d: 0., $ ;distance moderator detector
    
    list_data_runs: ptr_new(0L),$  ;[2000,2010,2011,2013,2020]
    list_data_nexus: ptr_new(0L), $ ;['/SNS/..../REF_L_3454.nxs','/SNS/...']
    list_norm_runs: ptr_new(0L), $
    list_norm_nexus: ptr_new(0L), $
    
    ;list of norm files
    selected_list_norm_file: strarr(max_nbr_data_nexus), $
    
    style_plot_lines: ptr_new(0L), $
    
    ;id of log book window
    view_log_book_id : 0L, $
    
    new_log_book_message: ptr_new(0L), $
    full_log_book: ptr_new(0L), $
    
    ;RTOF section
    ;flag that shows if a rtof nexus geometry file exists or not
    rtof_nexus_geometry_exist: 0b, $
    rtof_data: ptr_new(0L), $
    
    bFindnexus: 0b, $
    
    ;input and output files path
    output_path: '~/results/',$ ;used in the output tab
    input_path: '~/results/' })
    
  ;initialize structure data
  structure_data_working_with_nexus = $
    (*global).structure_data_working_with_nexus
  (*(*structure_data_working_with_nexus).data) = !null
  structure_data_working_with_rtof = $
    (*global).structure_data_working_with_rtof
  (*(*structure_data_working_with_rtof).data) = !null
  
  plot_symbol = ['+','*','.','D','tu','s','X','tu','td','H','S','o']
  plot_color = ['b','r','g','c','m','y','k']
  plot_linestyle = ['-',':','--','-.','-:','__']
  
  sz1 = n_elements(plot_symbol)
  sz2 = n_elements(plot_color)
  sz3 = n_elements(plot_linestyle)
  
  style_plot_lines = strarr(sz1*sz2*sz3)
  index=0
  for i=0,sz1-1 do begin
    for j=0,sz3-1 do begin
      for k=0,sz2-1 do begin
        style_plot_lines[index] = plot_symbol[i] + $
          plot_color[k] + $
          plot_linestyle[j]
        index++
      endfor
    endfor
  endfor
  (*(*global).style_plot_lines) = style_plot_lines
  
  log_book = ['------------------------------------------------------------',$
    'Log Book of SNS_offpsec',' Application started at: ' + date]
  (*(*global).full_log_book) = log_book
  
    if (strlowcase(debugger) eq 'yes') then begin
    bFindnexus = 1
  endif else begin
    bFindnexus = is_findnexus_there()
  endelse
  (*global).bFindnexus = bFindnexus
  
  return, global
  
end
