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
  
  file = OBJ_NEW('IDLxmlParser','.plotASCII.cfg')
  
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
    path: '~/IDLWorkspace/plotASCII 1.0/'}
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
  
    ;id of main_base
    main_base: 0L,$
    
    ;tools base
    tools_base: 0L, $
    lin_log_yaxis: 'lin',$
    yaxis_type: 'Y',$
    left_click: 0b, $
    
    ;style of plot
    line_style: 0,$ ;(+)
    symbol_style: 0, $ ;(solid)
    
    ;load base
    load_base: 0L, $
    nbr_ascii_files: 50L,$
    ascii_file_list: STRARR(50),$
    load_table: STRARR(2,50), $
    x0y0x1y1: FLTARR(4),$
    
    input_ascii_file: './REF_L_ascii_file.txt',$
    xaxis: '',$
    xaxis_units: '',$
    yaxis: '',$
    yaxis_units: '',$
    xyminmax: FLTARR(4), $
    
    ascii_color: STRARR(50), $ ;list of plot colors
    
    pXarray: PTR_NEW(0L),$
    pYarray: PTR_NEW(0L), $
    pSigmaYarray: PTR_NEW(0L), $
    
    pXaxis: PTR_NEW(0L), $
    pXaxis_units: PTR_NEW(0L), $
    pYaxis: PTR_NEW(0L), $
    pYaxis_units: PTR_NEW(0L), $
    
    pXarray_new: PTR_NEW(0L),$
    pYarray_new: PTR_NEW(0L), $
    pSigmaYarray_new: PTR_NEW(0L), $
    
    pXaxis_new: PTR_NEW(0L), $
    pXaxis_units_new: PTR_NEW(0L), $
    pYaxis_new: PTR_NEW(0L), $
    pYaxis_units_new: PTR_NEW(0L), $
    
    Xarray: PTR_NEW(0L), $
    Xarray_untouched: PTR_NEW(0L), $
    Yarray: PTR_NEW(0L), $
    SigmaYarray: PTR_NEW(0L), $
    
    path: '~/results/',$
    debugging:    debugging,$ ;yes or no
    debugging_structure: sDebugging,$
    ucams:        ucams,$
    application:  APPLICATION,$
    processing:   '(PROCESSING)',$
    ok:           'OK',$
    failed:       'FAILED',$
    version:      VERSION,$
    MainBaseSize: [30,25,400,400]})
    
  plot_color = ['white','yellow','red','blue','green','purple','pink',$
    'orange', 'brown','olive']
  ascii_color = [plot_color,plot_color,plot_color,plot_color,plot_color]
  (*global).ascii_color = ascii_color
  
  nbr_ascii_files = (*global).nbr_ascii_files
  pXarray = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pYarray = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pSigmaYarray = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  (*(*global).pXarray) = pXarray
  (*(*global).pYarray) = pYarray
  (*(*global).pSigmaYarray) = pSigmaYarray
  
  pXaxis = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pXaxis_units = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pYaxis = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pYaxis_units = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  (*(*global).pXaxis) = pXaxis
  (*(*global).pXaxis_units) = pXaxis_units
  (*(*global).pYaxis) = pYaxis
  (*(*global).pYaxis_units) = pYaxis_units
  
  pXarray_new = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pYarray_new = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pSigmaYarray_new = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  (*(*global).pXarray_new) = pXarray_new
  (*(*global).pYarray_new) = pYarray_new
  (*(*global).pSigmaYarray_new) = pSigmaYarray_new
  
  pXaxis_new = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pXaxis_units_new = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pYaxis_new = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  pYaxis_units_new = PTRARR(nbr_ascii_files,/AlLOCATE_HEAP)
  (*(*global).pXaxis_new) = pXaxis_new
  (*(*global).pXaxis_units_new) = pXaxis_units_new
  (*(*global).pYaxis_new) = pYaxis_new
  (*(*global).pYaxis_units_new) = pYaxis_units_new
  
  MainBaseSize   = (*global).MainBaseSize
  MainBaseTitle  = 'plot ASCII'
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
  (*global).main_base = MAIN_BASE
  
  button_base = WIDGET_BASE(MAIN_BASE,$
    /ROW)
    
  value = FILEPATH('open.bmp',SUBDIRECTORY=['resource','bitmaps'])
  load = WIDGET_BUTTON(button_base,$
    VALUE = value,$
    /BITMAP,$
    UNAME = 'load_button_uname')
    
  value = FILEPATH('plot.bmp',SUBDIRECTORY=['resource','bitmaps'])
  tools = WIDGET_BUTTON(button_base,$
    VALUE = value,$
    /BITMAP,$
    UNAME = 'tools_button_uname')
    
  zoom_help = WIDGET_LABEL(button_base,$
    VALUE = '             Double click to reset zoom')
    
  plot = WIDGET_DRAW(MAIN_BASE,$
    UNAME = 'main_draw',$
    /BUTTON_EVENTS, $
    /MOTION_EVENTS, $
    SCR_XSIZE    = MainBaseSize[2],$
    SCR_YSIZE    = MainBaseSize[3]-36)
    
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
    (*global).path = sDEBUGGING.path
  ENDIF
  ;??????????????????????????????????????????????????????????????????????????????
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

;-----------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
PRO plot_ascii, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





