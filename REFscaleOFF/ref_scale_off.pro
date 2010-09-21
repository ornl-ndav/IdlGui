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
  
  file = OBJ_NEW('idlxmlparser', '.REFscaleOFF.cfg')
  ;============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION  = file->getValue(tag=['configuration','version'])
  DEBUGGER = file->getValue(tag=['configuration','debugging'])
  auto_cleaning_data = file->getValue(tag=['configuration','auto_cleaning'])
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  ;============================================================================
  
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
  
  global = ptr_new({ $
  
    ;used to bring back data from load_crtof_file procedure to load_files
    tmp_pData_x: ptr_new(0L),$
    tmp_pData_y: ptr_new(0L),$
    tmp_pData_y_error: ptr_new(0L),$
    
    pData_x: ptrarr(20,/allocate_heap),$
    pData_y: ptrarr(20,/allocate_heap),$
    pData_y_error: ptrarr(20,/allocate_heap),$
    
    files_SF_list: strarr(2,20),$ ;LOAD and SCALE table (column1:Files, column2:SF)
    
    input_path: '~/results/' })
    
  MainBaseSize  = [50 , 50, 600, 535]
  MainTitle   = "REFLECTOMETER OFF SPECULAR SCALING - " + VERSION
  
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE(GROUP_LEADER = BatchMode, $
    UNAME        = 'main_base',$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    SCR_XSIZE    = MainBaseSize[2], $
    SCR_YSIZE    = MainBaseSize[3], $
    TITLE        = MainTitle)
    
  design_tabs, MAIN_BASE, global
  
  ;Realize the widgets, set the user value of the top-level
  ;base, and call XMANAGER to manage everything.
  WIDGET_CONTROL, main_base, /REALIZE
  WIDGET_CONTROL, main_base, SET_UVALUE=global
  XMANAGER, 'main_base', main_base, /NO_BLOCK, $
    cleanup = 'ref_off_scale_cleanup'
    
  ;------------------------------------------------------------------------------
  ;- BATCH MODE ONLY ------------------------------------------------------------
  ;Show BATCH Tab if Batch Mode is used
  IF (BatchMode NE '') THEN BEGIN
    IF (BatchFile NE '') THEN BEGIN
      id = WIDGET_INFO(MAIN_BASE_ref_scale, $
        FIND_BY_UNAME='load_batch_file_text_field')
      WIDGET_CONTROL, id, SET_VALUE=BatchFile
    ENDIF
    ;Show defined tab
    id1 = WIDGET_INFO(MAIN_BASE_ref_scale, FIND_BY_UNAME='steps_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 3 ;batch tab
  ENDIF
  ;- END OF BATCH MODE ONLY -----------------------------------------------------
  ;------------------------------------------------------------------------------
  
  
  ;------------------------------------------------------------------------------
  ;- DEBUGGER MODE ONLY ---------------------------------------------------------
  IF (DEBUGGER EQ 'yes') THEN BEGIN
    ;default tab
    id1 = WIDGET_INFO(MAIN_BASE_ref_scale, FIND_BY_UNAME='steps_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0 ;output_file
  ENDIF
  ;- END OF DEBUGGER MODE ONLY --------------------------------------------------
  ;------------------------------------------------------------------------------
  
  ;=============================================================================
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

;
; Empty stub procedure used for autoloading.
;
PRO ref_scale_off, BatchMode    = BatchMode, $
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
