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
  compile_opt idl2
  
  ;return the global structure
  global = getGlobal()
  
  MainBaseSize  = [50 , 50]
  MainTitle   = "SNS Off Specular - " + (*global).version
  
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE(GROUP_LEADER = BatchMode, $
    UNAME        = 'main_base',$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    /tlb_size_events, $
    mbar = bar,$
    /column, $
    TITLE        = MainTitle)
      
  ;design_menu, bar, global
  design_tabs, MAIN_BASE, global
  design_menu, bar, global
  
  ;Realize the widgets, set the user value of the top-level
  ;base, and call XMANAGER to manage everything.
  WIDGET_CONTROL, main_base, /REALIZE
  WIDGET_CONTROL, main_base, SET_UVALUE=global
  xmanager, 'main_base', main_base, /NO_BLOCK, cleanup = 'sos_cleanup'
  
  if (strlowcase((*global).debugger) eq 'yes') then begin
  
    if (!version.os eq 'darwin') then begin
      ;if (instrument EQ 'REF_M') then begin
        input_path = '/Users/j35/IDLWorkspace80/SOS 1.0/Files/'
      ;endif else begin
      ;  input_path = '/Users/j35/results/'
      ;endelse
    endif else begin
      input_path = "/SNS/users/j35/IDLWorkspace80/SOS 1.0/Files/"
    endelse
    (*global).input_path = input_path
    
    selected_list_norm_file = (*global).selected_list_norm_file
    
    if (instrument EQ 'REF_L') then begin ;REF_L instrument
            list_data_nexus = input_path + ['REF_L_34432.nxs',$
              'REF_L_34433.nxs', $
              'REF_L_34434.nxs', $
              'REF_L_34435.nxs', $
              'REF_L_34436.nxs']
;      list_data_nexus = input_path + ['REF_L_38327.nxs',$
;        'REF_L_38328.nxs', $
;        'REF_L_38329.nxs', $
;        'REF_L_38330.nxs']
      (*(*global).list_data_nexus) = list_data_nexus
            list_norm_nexus = input_path + ['REF_L_34394.nxs',$
              'REF_L_34394.nxs', $
              'REF_L_34394.nxs', $
              'REF_L_34394.nxs', $
              'REF_L_34394.nxs']
;      list_norm_nexus = input_path + ['REF_L_38340.nxs',$
;        'REF_L_38340.nxs', $
;        'REF_L_38340.nxs', $
;        'REF_L_38340.nxs']
      (*(*global).list_norm_nexus) = list_norm_nexus
    endif else begin ;REF_M instrument
      list_data_nexus = input_path + ['REF_M_8451.nxs',$
        'REF_M_8452.nxs']
      (*(*global).list_data_nexus) = list_data_nexus + ' (' + $
        default_spin_state + ')'
      list_norm_nexus = input_path + ['REF_M_8454.nxs',$
        'REF_M_8455.nxs']
      (*(*global).list_norm_nexus) = list_norm_nexus + ' (' + $
        default_spin_state + ')'
      selected_list_norm_file[0:1] = list_norm_nexus
    endelse
    
    (*global).selected_list_norm_file = selected_list_norm_file
    
    ;activate go button
    activate_button, main_base=main_base, uname='go_button', status=1
    
    ;    if ((*global).hide_tab_2 eq 'no') then begin
    
    rtof_file = input_path + $
      'REF_L_33043#8_33044#8_33045#7_33046#7_33047#6_Off_Off_scaled.rtof'
    putvalue, base=main_base, 'rtof_file_text_field_uname', rtof_file
    
    ;tab to show by default
    ;id = widget_info(main_base, find_by_uname='tab_uname')
    
    nexus_tab_to_show = 0
    id = widget_info(main_base, find_by_uname='nexus_tab_uname')
    widget_control, id, set_tab_current=nexus_tab_to_show
    (*global).NexusPrevTabSelect = nexus_tab_to_show
    
    ;    endif
    
    create_big_table_tab1, main_base=main_base
    select_entire_row, base=main_base, uname='tab1_table'
    refresh_big_table, base=main_base
    retrieve_data_nexus_distances, main_base=main_base
    retrieve_detector_configuration, main_base=main_base
    refresh_configuration_table, base=main_base
    select_entire_row, base=main_base, uname='ref_m_metadata_table'
    
    file_name = input_path + 'REF_L_34435.nxs'
    putValue, base=main_base, 'rtof_nexus_geometry_file', file_name
    
    ;add config table for REF_M
    update_main_interface, main_base=main_base
    
    check_go_button, base=main_base
    
  endif
  
  ;sample button of output tab
  display_output_sample_button, main_base=main_base, status=0
  
  ;============================================================================
  ;send message to log current run of application
  logger, APPLICATION=(*global).application, $
  VERSION=(*global).version, $
  UCAMS=(*global).ucams
  
  ;save the current xsize of the main application
  id = widget_info(main_base, find_by_uname='main_base')
  geometry = widget_info(id,/geometry)
  xsize = geometry.scr_xsize
  ysize = geometry.scr_ysize
  (*global).main_base_xsize = xsize
  (*global).main_base_ysize = ysize
  id = widget_info(main_base,find_by_uname='tab1_table')
  geometry_table = widget_info(id,/geometry)
  ysize_table = geometry_table.scr_ysize
  xsize_table = geometry_table.scr_xsize
  (*global).table_ysize = ysize_table
  (*global).table_xsize = xsize_table
  
  if ((*global).instrument eq 'REF_M') then begin
    id = widget_info(main_base,find_by_uname='ref_m_metadata_table')
    geometry_table = widget_info(id,/geometry)
    ysize_table = geometry_table.scr_ysize
    xsize_table = geometry_table.scr_xsize
    (*global).table_metadata_ysize = ysize_table
    (*global).table_metadata_xsize = xsize_table
  endif
  
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
