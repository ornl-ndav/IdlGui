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

PRO DAD_cleanup, tlb

  WIDGET_CONTROL, tlb, GET_UVALUE=global, /NO_COPY
  IF N_ELEMENTS(global) EQ 0 THEN RETURN
  
  ; Free up the pointers
  ;  PTR_FREE, (*global).background
  ;  PTR_FREE, (*global).BankArray
  ;  PTR_FREE, (*global).TubeArray
  ;  PTR_FREE, (*global).PixelArray
  ;  PTR_FREE, (*global).PixelArray_of_DeadTubes
  ;  PTR_FREE, (*global).dead_tube_nbr
  ;  PTR_FREE, (*global).back_bank
  ;  PTR_FREE, (*global).front_bank
  ;  PTR_FREE, (*global).both_banks
  ;  PTR_FREE, (*global).package_required_base
  ;  PTR_FREE, (*global).list_OF_files_to_send
  ;  PTR_FREE, (*global).Xarray
  ;  PTR_FREE, (*global).Xarray_untouched
  ;  PTR_FREE, (*global).Yarray
  ;  PTR_FREE, (*global).SigmaYarray
  ;  PTR_FREE, (*global).rtDataXY
  ;  PTR_FREE, (*global).DataArray
  ;  PTR_FREE, (*global).img
  ;  PTR_FREE, (*global).RoiPixelArrayExcluded
  PTR_FREE, global
  
END

;------------------------------------------------------------------------------
PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  CD, CURRENT = current_folder
  
  file = OBJ_NEW('IDLxmlParser','.DAD.cfg')
  ;============================================================================
  ;****************************************************************************
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  TESTING = file->getValue(tag=['configuration','testing'])
  ;CHECKING_PACKAGES = file->getValue(tag=['configuration','checking_packages'])
  ;****************************************************************************
  ;============================================================================
  
  ;PACKAGE_REQUIRED_BASE = { driver:           '',$
  ;  version_required: '',$
  ;  found: 0,$
  ;  sub_pkg_version:   ''}
  ;;sub_pkg_version: python program that gives pkg v.
  ;my_package = REPLICATE(PACKAGE_REQUIRED_BASE,3)
  ;my_package[0].driver           = 'findnexus'
  ;my_package[0].version_required = '1.5'
  ;my_package[1].driver           = 'sas_reduction'
  ;my_package[1].version_required = ''
  ;my_package[1].sub_pkg_version  = './drversion'
  ;my_package[2].driver           = 'findcalib'
  ;************************************************************************
  ;************************************************************************
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = GET_UCAMS()
  ENDELSE
  
  ;define global variables
  global = PTR_NEW ({ path: '~/',$
    firefox: '/usr/bin/firefox',$
    srun_web_page: 'https://neutronsr.us/applications/jobmonitor/'+$
    'squeue.php?view=all',$
    srun_driver: 'srun',$
    sbatch_driver: 'sbatch',$
    
    default_path: '~/results/',$
    
    debugging:    debugging,$ ;yes or no
    ucams:        ucams,$
    application:  APPLICATION,$

    processing:   '(PROCESSING)',$
    ok:           'OK',$
    failed:       'FAILED',$
    version:      VERSION,$
    MainBaseSize: [30,25,800,650]})
    
  MainBaseSize   = (*global).MainBaseSize
  MainBaseTitle  = 'Dave Ascii Division (DAD)'
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
  
  ;confirmation base
  MakeGuiMainBase, MAIN_BASE, global
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='DAD_cleanup'
  
  ;==============================================================================
  ; Date Information
  ;==============================================================================
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
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

;-----------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
PRO dad, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





