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

  file = OBJ_NEW('IDLxmlParser','.plotcncs.cfg')
  
  ;******************************************************************************
  ;******************************************************************************
  
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  
  ;******************************************************************************
  ;******************************************************************************
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  if (!VERSION.os EQ 'darwin') then begin
    ucams = 'j35'
  endif else begin
    ucams = get_ucams()
  endelse
  
  ;get hostname
  SPAWN, 'hostname', hostname
  
  ;define global variables
  global = ptr_new ({ ucams                   : ucams,$
    HistoNexusTabSelected   : 0,$
    browse_nexus_path       : '/SNS/CNCS/',$
    browse_OR_list_all_flag : 0,$
    bin_width               : '200',$
    runinfoFileName         : '',$
    img                     : PTR_NEW(0L),$
    nbr_pixel               : 51200L,$
    version                 : VERSION,$
    LogBookPath             : '/SNS/users/LogBook/',$
    staging_folder          : '~/.plotCNCS_tmp/',$
    mapping_list_mac        : ['./mapping/CNCS_TS_2007_10_10.dat'],$
    event_file_filter       : '*_neutron_event.dat',$
    histo_map_filter        : '*_neutron_histo_mapped.dat',$
    default_extension       : '.dat',$
    event_filter            : '*neutron_event.dat',$
    mac_CNCS_folder         : './MAC-DAS-FS/CNCS_1/',$
    ;for mac use only
    processing              : '(PROCESSING)',$
    ok                      : 'OK',$
    failed                  : 'FAILED',$
    status                  : 'STATUS: ',$
    neutron_event_dat_ext   : '_neutron_event.dat',$
    debugger                : 'j35'})
    
  IF (ucams EQ (*global).debugger) THEN BEGIN
    MainBaseSize  = [30,25,700,740]
  ENDIF ELSE BEGIN
    MainBaseSize  = [30,25,700,560]
  ENDELSE
  MainBaseTitle = 'Plot CNCS'
  MainBaseTitle += ' - ' + VERSION
  
  IF (DEBUGGING EQ 'yes') THEN BEGIN
    MainBaseTitle += ' (DEBUGGING MODE)'
  ENDIF
  
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
  WIDGET_CONTROL, MAIN_BASE, set_uvalue=global
  
  ;Create main base
  MakeGuiInputBase, MAIN_BASE, MainBaseSize
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  ;XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='gg_Cleanup'
  
  ;if it's on mac, fill up run number with 1
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    id = WIDGET_INFO(Main_base,find_by_uname='run_number')
    WIDGET_CONTROL, id, set_value = '1'
  ENDIF
  
  ;populate mapping droplist
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    MapArray = (*global).mapping_list_mac
  ENDIF ELSE BEGIN
    MapArray = getMappingFileList()
  ENDELSE
  id = WIDGET_INFO(MAIN_BASE, find_by_uname='mapping_droplist')
  WIDGET_CONTROL, id, set_value=MapArray
  
  IF (DEBUGGING EQ 'yes') THEN BEGIN
    ;(*global).browse_nexus_path = '~/402/NeXus/'
    (*global).browse_nexus_path = '~/402/'
  ENDIF
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END


; Empty stub procedure used for autoloading.
pro plot_cncs, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





