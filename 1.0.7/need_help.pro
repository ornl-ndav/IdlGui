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

PRO need_help_cleanup, tlb

  WIDGET_CONTROL, tlb, GET_UVALUE=global, /NO_COPY
  IF N_ELEMENTS(global) EQ 0 THEN RETURN
  
  ; Free up the pointers
  ;  PTR_FREE, (*global).old_input_text
  PTR_FREE, global
  
END

;------------------------------------------------------------------------------
PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  CD, CURRENT = current_folder
  
  file = OBJ_NEW('IDLxmlParser','.NeedHelp.cfg')
  ;============================================================================
  ;****************************************************************************
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  TESTING = file->getValue(tag=['configuration','testing'])
  ;****************************************************************************
  ;============================================================================
  obj_destroy, file
  
  ;define global variables
  global = PTR_NEW ({ path: '~/',$
    firefox: '/usr/bin/firefox',$
    ;firefox: '/Applications/Firefox.app/Contents/MacOS/firefox-bin',$
    default_path: '~/results/',$
    
    debugging:    debugging,$ ;yes or no
    application:  APPLICATION,$
    version:      VERSION,$
    
    list_of_files: ptr_new(0L),$  ;list of files to add to message (tab2)
    
    ;structure that contains various infos about the system
    general_infos: {ucams: '',$
    version: version, $
    hostname: '',$
    home: ''}, $
    
    ;size and position of application
    MainBaseSize: [30,25,1010,400]})
    
  ;(*(*global).list_of_files) = strarr(1)
    
  MainBaseSize   = (*global).MainBaseSize
  MainBaseTitle  = 'Need Help'
  MainBaseTitle += ' - ' + VERSION
  ;Build Main Base
  MAIN_BASE = Widget_Base( GROUP_LEADER = wGroup,$
    UNAME        = 'MAIN_BASE',$
    SCR_XSIZE    = MainBaseSize[2],$
    SCR_YSIZE    = MainBaseSize[3],$
    XOFFSET      = MainBaseSize[0],$w
  YOFFSET      = MainBaseSize[1],$
    TITLE        = MainBaseTitle,$
    SPACE        = 0,$
    XPAD         = 0,$
    YPAD         = 2)
    
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  get_general_infos, global
  
  ;confirmation base
  MakeGuiMainBase, MAIN_BASE, global
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='need_help_cleanup'
  
  ;=============================================================================
  ; Date Information
  ;=============================================================================
  ;Put date/time when user started application in first line of log book
  ;time_stamp = GenerateReadableIsoTimeStamp()
  ;message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  ;IDLsendLogBook_putLogBookText_fromMainBase, MAIN_BASE, message
  
  ;??????????????????????????????????????????????????????????????????????????????
  IF (DEBUGGING EQ 'yes' ) THEN BEGIN
  ;  id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
  ;  WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.main_tab
  ;  id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='input_text_field')
  ; WIDGET_CONTROL, id, SET_VALUE=sDebugging.input_text
  ENDIF
  ;??????????????????????????????????????????????????????????????????????????????
  
  ;display buttons
  display_buttons, MAIN_BASE=main_base, button='faq', status='off'
  display_buttons, MAIN_BASE=main_base, button='orbiter', status='off'
  display_buttons, MAIN_BASE=main_base, button='slurm', status='off'
  display_buttons, MAIN_BASE=main_base, button='ldp', status='off'
  display_buttons, MAIN_BASE=main_base, button='neutronsr_us', status='off'
  display_buttons, MAIN_BASE=main_base, button='sns', status='off'
  display_buttons, MAIN_BASE=main_base, button='portal', status='off'
  display_buttons, MAIN_BASE=main_base, button='translation', status='off'
  display_buttons, MAIN_BASE=main_base, button='sns_tools', status='off'
  display_buttons, MAIN_BASE=main_base, button='systems_status', status='off'
  display_buttons, MAIN_BASE=main_base, button='faq_admin', status='off'
  display_buttons, MAIN_BASE=main_base, button='faq_users', status='off'
  display_buttons, MAIN_BASE=main_base, button='links_for_admins', status='off'
  display_buttons, MAIN_BASE=main_base, button='links_for_users', status='off'
  
  display_buttons_tab3, MAIN_BASE=main_base, button='fix_firefox', status='off'
  display_buttons_tab3, MAIN_BASE=main_base, button='fix_gnome', status='off'
  display_buttons_tab3, MAIN_BASE=main_base, button='fix_isaw', status='off'
  display_buttons_tab3, MAIN_BASE=main_base, button='fix_data_link', status='off'  
    
  ;send message to log current run of application
  ucams = (*global).general_infos.ucams
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

;-----------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
PRO need_help, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





