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
  
  file = OBJ_NEW('IDLxmlParser','FITStools.cfg')
  
  ;******************************************************************************
  ;******************************************************************************
  
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  SIMULATE_FITS_LOADING = file->getValue(tag=['configuration',$
    'simulate_fits_loading'])
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
  sDEBUGGING = { tab: {main_tab: 0},$  ;0:load, 1:ascii, 2: fits
    fits_path: '~/FITSfiles/'}
  ;******************************************************************************
  ;******************************************************************************
    
  ;ucams = GET_UCAMS()
    
  ;define global variables
  global = PTR_NEW ({fits_path: '~/results/',$
    SIMULATE_FITS_LOADING: SIMULATE_FITS_LOADING, $ ;yes/no
    
    tab1_selection: INTARR(2), $ ;top and bottom row selected
    tab1_base: 0L, $ ;id of plot base of tab1/tab2 (PvsC, YvsX, IvsC)
    tab3_base: 0L, $ ;id of plot base of tab3
    
    ;pointers that will contain the values x, y, p and c of the various files
    pXArray: PTR_NEW(0L), $     ;x array in the original file
    pYArray: PTR_NEW(0L), $     ;y array in the original file
    pPArray: PTR_NEW(0L), $     ;p in the original file
    pTimeArray: PTR_NEW(0L), $  ;c array in the original file
    
    time_resolution_microS: 25.*0.001, $ ;25ns for each tick marks in pTimeArray
    default_max_time_microS: 25*1000, $ ;default max time of file (25ms)
    
    p_rebinned_y_array: PTR_NEW(0L), $ ;PvsC rebinned and combined of step2
    p_rebinned_x_array: PTR_NEW(0L), $ ;x axis of PvsC
    need_to_recalculate_rebinned_step2: 1b, $ ;reset to 1b each time something
    ;change (file loaded, file_removed, bin size)
    
    output_path: '~/results/',$ ;where the various files will be created
    
    max_nbr_fits_files: 20,$    ;maximum number of fits files we can work on
    list_fits_file: PTR_NEW(0L),$ ;list of full fits files names
    list_fits_error_file: PTR_NEW(0L) }) ;list of file that can not be loaded
    
  max_nbr_fits_files = (*global).max_nbr_fits_files
  x_array    = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  y_array    = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  p_array    = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  time_array = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  (*(*global).pXArray) = x_array
  (*(*global).pYArray) = y_array
  (*(*global).pPArray) = p_array
  (*(*global).pTimeArray) = time_array
  
  (*(*global).list_fits_file)  = STRARR((*global).max_nbr_fits_files)
  (*(*global).list_fits_error_file) = STRARR((*global).max_nbr_fits_files)
  
  MainBaseSize   = [0,0,700,350]
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
    
  build_main_gui, MAIN_BASE, global
  
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;============================================================================
  ; Date Information
  ;============================================================================
  ;Put date/time when user started application in first line of log book
  ;time_stamp = GenerateReadableIsoTimeStamp()
  ;message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  ;IDLsendLogBook_putLogBookText_fromMainBase, MAIN_BASE, message
  
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    checking_packages_routine, MAIN_BASE, my_package, global
  ENDIF
  
  ;????????????????????????????????????????????????????????????????????????????
  IF (DEBUGGING EQ 'yes' ) THEN BEGIN
    (*global).fits_path = sDebugging.fits_path
    id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id, SET_TAB_CURRENT = sDebugging.tab.main_tab
  ENDIF
  ;????????????????????????????????????????????????????????????????????????????
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

;-----------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
PRO fits_tools, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





