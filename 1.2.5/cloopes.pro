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

PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  CD, CURRENT = current_folder
  
  file = OBJ_NEW('IDLxmlParser','.cloopes.cfg')
  
  ;******************************************************************************
  ;******************************************************************************
  
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  TESTING = file->getValue(tag=['configuration','testing'])
  CHECKING_PACKAGES = file->getValue(tag=['configuration','checking_packages'])
  
  ;******************************************************************************
  ;******************************************************************************
  
  PACKAGE_REQUIRED_BASE = { driver:           '',$
    version_required: '',$
    found: 0,$
    sub_pkg_version:   ''}
  ;sub_pkg_version: python program that gives pkg v. of common libraries...etc
  my_package = REPLICATE(PACKAGE_REQUIRED_BASE,1)
  my_package[0].driver           = 'elastic_scan'
  my_package[0].version_required = ''
  
  ;*************************************************************************
  ;*************************************************************************
  
  ;DEBUGGING
  sDEBUGGING = { tab: {main_tab: 0},$  ;0:step1, 1:logBook
    ;    path: '~/results/',$ ;path to CL file
    path: '~/IDLWorkspace71/CLoopES 1.2/',$
    input_text: '639-641'}
  ;******************************************************************************
  ;******************************************************************************
    
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = GET_UCAMS()
  ENDELSE
  
  ;define global variables
  global = PTR_NEW ({ $
    PrevReduceTabSelect: 0,$
    
    path: '~/results/',$
    old_input_text: PTR_NEW(0L),$
    old_help_text1: '',$
    old_help_text2: '',$
    cl_with_fields: '', $
    
    entering_cl_tab1: 0b, $ ;boolean that is 1 when mouse is in cl tab1 region
    
    selection_in_progress: 'SELECTION IN PROGRESS  . . .',$
    sequence_field1: PTR_NEW(0L), $
    sequence_field2: PTR_NEW(0L), $
    sequence_field3: PTR_NEW(0L), $
    tab1_activate_run_widgets: 0b,$
    
    es_driver: my_package[0].driver,$
    
    job_manager_splash_draw: $
    'CLoopES_images/job_manager_is_coming.png',$
    ascii_path: '~/results/',$
    ascii_input_path: '~/results/',$
    step1_output_path: '',$
    
    firefox: '/usr/bin/firefox',$
    srun_web_page: 'https://neutronsr.us/applications/jobmonitor/'+$
    'squeue.php?view=all',$
    srun_driver: 'srun',$
    sbatch_driver: 'sbatch',$
    
    column_sequence: PTR_NEW(0L),$
    column_cl: PTR_NEW(0L),$
    cl_array: STRARR(2),$
    output_suffix: 'BASIS_',$
    output_prefix: '.dat',$
    
    tab2_table: PTR_NEW(0L),$
    column_file_name_tab2: PTR_NEW(0L),$
    column_sequence_tab2: PTR_NEW(0L),$
    
    temperature_path: '~/results/',$
    temperature_array: PTR_NEW(0L),$
    
    package_required_base: PTR_NEW(0L),$
    debugging:    debugging,$ ;yes or no
    debugging_structure: sDebugging,$
    ucams:        ucams,$
    application:  APPLICATION,$
    processing:   '(PROCESSING)',$
    ok:           'OK',$
    failed:       'FAILED',$
    version:      VERSION,$
    MainBaseSize: [30,25,800,770]})
    
  MainBaseSize   = (*global).MainBaseSize
  MainBaseTitle  = 'Command Line Looper for Elastic Scan (CLoopES)'
  MainBaseTitle += ' - ' + VERSION
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
    UNAME        = 'MAIN_BASE',$
    SCR_XSIZE    = MainBaseSize[2],$
    SCR_YSIZE    = MainBaseSize[3],$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    TITLE        = MainBaseTitle,$
    SPACE        = 0,$
    XPAD         = 0,$
    YPAD         = 2)
    
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  ;confirmation base
  MakeGuiMainBase, MAIN_BASE, global
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;==============================================================================
  ; Date Information
  ;==============================================================================
  ;Put date/time when user started application in first line of log book
  time_stamp = GenerateReadableIsoTimeStamp()
  message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  IDLsendLogBook_putLogBookText_fromMainBase, MAIN_BASE, message
  
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    checking_packages_routine, MAIN_BASE, my_package, global
  ENDIF
  
  ;??????????????????????????????????????????????????????????????????????????????
  IF (DEBUGGING EQ 'yes' ) THEN BEGIN
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.main_tab
  ;  id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='input_text_field')
  ;  WIDGET_CONTROL, id, SET_VALUE=sDebugging.input_text
  ENDIF
  ;??????????????????????????????????????????????????????????????????????????????
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
;display_tab1_error, MAIN_BASE=main_base
  
END

;-----------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
PRO cloopes, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





