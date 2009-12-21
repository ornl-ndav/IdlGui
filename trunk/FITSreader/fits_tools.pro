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
  
  file = OBJ_NEW('IDLxmlParser','.FITStools.cfg')
  
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
  my_package[0].driver           = ''
  my_package[0].version_required = ''
  
  ;*************************************************************************
  ;*************************************************************************
  
  ;DEBUGGING
  sDEBUGGING = { tab: {main_tab: 0},$  ;0:step1, 1:logBook
    path: '~/SVN/IdlGui/trunk/plotASCII/'}
  ;******************************************************************************
  ;******************************************************************************
    
;    ucams = GET_UCAMS()
  
  ;define global variables
  global = PTR_NEW ()

  MainBaseSize   = [0,0,300,300]		
  MainBaseTitle  = 'FITS tools application'
  MainBaseTitle += ' - ' + VERSION
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
    UNAME        = 'MAIN_BASE',$
    SCR_XSIZE    = MainBaseSize[2],$
    SCR_YSIZE    = MainBaseSize[3],$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    TITLE        = MainBaseTitle,$
    /COLUMN, $
    /TLB_MOVE_EVENTS, $
    /TLB_SIZE_EVENTS)
  
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;==============================================================================
  ; Date Information
  ;==============================================================================
  ;Put date/time when user started application in first line of log book
  ;time_stamp = GenerateReadableIsoTimeStamp()
  ;message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  ;IDLsendLogBook_putLogBookText_fromMainBase, MAIN_BASE, message
  
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    checking_packages_routine, MAIN_BASE, my_package, global
  ENDIF
  
  ;??????????????????????????????????????????????????????????????????????????????
  IF (DEBUGGING EQ 'yes' ) THEN BEGIN
    (*global).path = '~/IDLWorkspace/plotASCII'
  ;(*global).path = '~/results/'
  ENDIF
  ;??????????????????????????????????????????????????????????????????????????????
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

;-----------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
PRO fits_tools, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





