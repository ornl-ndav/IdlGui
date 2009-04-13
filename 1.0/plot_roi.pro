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

  file = OBJ_NEW('idlxmlparser', 'plotROI.cfg')
  ;==============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING_VERSION = file->getValue(tag=['configuration','debugging_version'])
  
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  ;==============================================================================
  
  ;get the current folder
  ;cd, current=current_folder
  
  ;define initial global values - these could be input via external file or other
  ;means
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  
  if (!VERSION.os EQ 'darwin') then begin
    ucams = 'j35'
  endif else begin
    ucams = get_ucams()
  endelse
  
  ;get hostname
  SPAWN, 'hostname', hostname
  CASE (hostname) OF
    'heater'       : instrumentIndex = 0
    'bac.sns.gov'  : instrumentIndex = 1
    'bac2'         : instrumentIndex = 1
    'snap'         : instrumentIndex = 2
    'lrac'         : instrumentIndex = 3
    'mrac'         : instrumentIndex = 4
    'arcs1'        : instrumentIndex = 5
    'arcs2'        : instrumentIndex = 5
  ELSE           : instrumentIndex = 0
ENDCASE

ListOFInstruments = ['BSS',$
  'SNAP',$
  'REF_L',$
  'REF_M',$
  'ARCS',$
  'SANS']
  
;define global variables
global = ptr_new ({ ListOfInstruments     : ListOfInstruments,$
  LogBookPath           : '/SNS/users/LogBook/',$
  DeployedVersion       : 1,$
  InstrumentSelected    : instrumentIndex,$
  ucams                 : ucams,$
  application           : APPLICATION,$
  processing            : '(PROCESSING)',$
  ok                    : 'OK',$
  failed                : 'FAILED',$
  RunNumber             : '',$
  BrowseNexusDefaultExt : '.nxs',$
  BrowseDefaultPath     : '~/',$
  BrowseFilter          : '*.nxs',$
  BrowseROIExt          : '.dat',$
  BrowseROIPath         : '~/',$
  BrowseROIFilter       : '*.dat',$
  ValidNexus            : 0,$
  version               : VERSION })
  
IF (ucams EQ 'j35') THEN BEGIN
  MainBaseSize  = [30,25,540,700]
ENDIF ELSE BEGIN
  MainBaseSize  = [30,25,540,445]
ENDELSE

MainBaseTitle = 'Plot NeXus and ROI files'

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
WIDGET_CONTROL, MAIN_BASE, set_uvalue=global

;confirmation base
MakeGuiMainBase, MAIN_BASE, global

WIDGET_CONTROL, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

IF ((*global).DeployedVersion EQ 0) THEN BEGIN
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    instrumentIndex = 3    ;REMOVE_ME
    ;put default nexus name in 'nexus_file_text_field'
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='nexus_file_text_field')
    nexus = '/Users/j35/REF_L_4493.nxs'
    WIDGET_CONTROL, id, set_value=nexus
    ;put default nexus name of ROI file
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='roi_text_field')
    roi_file = '/Users/j35/REF_L_3000_data_roi.dat'
    WIDGET_CONTROL, id, set_value=roi_file
  ENDIF ELSE BEGIN
    instrumentIndex = 3     ;REMOVE_ME
    ;put default nexus name in 'nexus_file_text_field'
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='nexus_file_text_field')
    nexus = '/SNS/REF_L/IPTS-231/2/4000/NeXus/REF_L_4000.nxs'
    WIDGET_CONTROL, id, set_value=nexus
    ;put default nexus name of ROI file
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='roi_text_field')
    roi_file = '~/REF_L_2454_data_roi.dat'
    WIDGET_CONTROL, id, set_value=roi_file
  ENDELSE
ENDIF ELSE BEGIN

ENDELSE
id = WIDGET_INFO(MAIN_BASE,find_by_uname='list_of_instrument')
WIDGET_CONTROL, id, set_droplist_select=instrumentIndex

;send message to log current run of application
logger, global

END

;------------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
pro plot_roi, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





