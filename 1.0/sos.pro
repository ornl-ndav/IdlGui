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

pro main_base, BatchMode, BatchFile, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

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
  auto_cleaning_data = file->getValue(tag=['configuration','auto_cleaning'])
  scaled_specular = file->getValue(tag=['configuration','plot','scaled_specular'])
  hide_tab_2 = file->getValue(tag=['configuration','hide_tab_2'])
  max_nbr_data_nexus = file->getValue(tag=['configuration','max_nbr_data_nexus'])
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
  
  global = ptr_new({ $
  
    applicaiton: APPLICATION, $
    version: VERSION, $
    debugger: debugger, $
    scaled_specular: scaled_specular, $
    hide_tab_2: hide_tab_2, $
    max_nbr_data_nexus: max_nbr_data_nexus, $
    
    ;where all the parameters are defined
    instrument_config_file: './SOS_instruments.cfg', $
    
    instrument: 'REF_L',$ ;so far, only REF_L is supported
    PrevTabSelect: 0, $
    
    SD_d: 0., $ ;distance sample detector
    MD_d: 0., $ ;distance moderator detector
    
    list_data_runs: ptr_new(0L),$  ;[2000,2010,2011,2013,2020]
    list_data_nexus: ptr_new(0L), $ ;['/SNS/..../REF_L_3454.nxs','/SNS/...']
    norm_nexus: '',$
    
    style_plot_lines: ptr_new(0L), $
    
    ;id of log book window
    view_log_book_id : 0L, $
    
    new_log_book_message: ptr_new(0L), $
    full_log_book: ptr_new(0L), $
    
    bFindnexus: 0b, $
    
    ;input and output files path
    output_path: '~/results/',$ ;used in the output tab
    input_path: '~/results/' })
    
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
  
  MainBaseSize  = [50 , 50]
  MainTitle   = "SNS Off Specular - " + VERSION
  
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE(GROUP_LEADER = BatchMode, $
    UNAME        = 'main_base',$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    ;    SCR_XSIZE    = MainBaseSize[2], $
    ;    SCR_YSIZE    = MainBaseSize[3], $
    mbar = bar,$
    /column, $
    TITLE        = MainTitle)
    
  bFindnexus = is_findnexus_there()
  ;REMOVE_ME
  bFindnexus = 1
  (*global).bFindnexus = bFindnexus
  
  ;  design_menu, bar, global
  design_tabs, MAIN_BASE, global
  design_menu, bar, global
  
  ;Realize the widgets, set the user value of the top-level
  ;base, and call XMANAGER to manage everything.
  WIDGET_CONTROL, main_base, /REALIZE
  WIDGET_CONTROL, main_base, SET_UVALUE=global
  xmanager, 'main_base', main_base, /NO_BLOCK, cleanup = 'sos_cleanup'
  
  if (strlowcase(debugger) eq 'yes') then begin
  
    if (!version.os eq 'darwin') then begin
      input_path = '/Users/j35/IDLWorkspace80/SOS 1.0/Files/'
    endif else begin
      input_path = "/SNS/users/j35/IDLWorkspace80/SOS 1.0/Files/"
    endelse
    (*global).input_path = input_path
    
    list_data_nexus = input_path + ['REF_L_34432.nxs',$
      'REF_L_34433.nxs',$
      'REF_L_34434.nxs',$
      'REF_L_34435.nxs',$
      'REF_L_34436.nxs']
    (*(*global).list_data_nexus) = list_data_nexus
    
    norm_nexus = input_path + 'REF_L_34394.nxs'
    (*global).norm_nexus = norm_nexus
    
    retrieve_data_nexus_distances, main_base=main_base
    
    ;activate go button
    activate_button, main_base=main_base, uname='go_button', status=1
    
    if ((*global).hide_tab_2 eq 'no') then begin
    
      rtof_file = input_path + 'REF_L_33043#8_33044#8_33045#7_33046#7_33047#6_Off_Off_scaled.rtof'
      putvalue, base=main_base, 'rtof_file_text_field_uname', rtof_file
      
      ;tab to show by default
      tab_to_show = 0
      id = widget_info(main_base, find_by_uname='tab_uname')
      widget_control, id, set_tab_current=tab_to_show
      
    endif
    
  endif
  
  
  
  ;=============================================================================
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

;
; Empty stub procedure used for autoloading.
;
PRO sos, BatchMode    = BatchMode, $
    BatchFile    = BatchFile, $
    GROUP_LEADER = wGroup, $
    _EXTRA       = _VWBExtra_
  IF (N_ELEMENTS(BatchMode) EQ 0) THEN BEGIN
    BatchMode = ''
    BatchFile = ''
  ENDIF ELSE BEGIN
    BatchMode = BatchMode
  ENDELSE
  main_base, BatchMode, BatchFile, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
END
