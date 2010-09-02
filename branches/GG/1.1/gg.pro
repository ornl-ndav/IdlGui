;===============================================================================
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
;===============================================================================

PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
cd, current=current_folder

APPLICATION = 'GeometryGenerator'
VERSION     = '1.1.7'

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;Which version to load
;1 is for version that never shows the base #2. It only allows user to
;load the xml files and create the geometry file
versionLight = 0
;0 is for full version that displays the base #2.

;get hostname
spawn, 'hostname', hostname
CASE (hostname) OF
    'heater.sns.gov': instrumentIndex = 0
    'lrac.sns.gov'  : instrumentIndex = 2
    'mrac.sns.gov'  : instrumentIndex = 3
    'bac.sns.gov'  : instrumentIndex = 1
    'bac2.sns.gov'  : instrumentIndex = 1
    else    : instrumentIndex = 0
ENDCASE 

;define global variables
global = ptr_new ({ instrumentShortList   : ptr_new(0L),$
                    stringFoundIteration  : 1,$
                    geom_xml_file_title   : 'Geometry.xml file: ',$
                    new_geo_xml_filename  : '',$
                    TCompileMessage       : '*processing modified jar*',$
                    error_log_book        : '',$
                    error_list            : ['Failed',$ ;list of error found in SNSproblem_log
                                             'Fatal error',$
                                             'Error'],$
                    ucams                 : ucams,$
                    processing            : '(PROCESSING)',$
                    ok                    : 'OK',$
                    failed                : 'FAILED',$
                    ts_geom_calc_path     : 'TS_geom_calc.sh',$
                    tmp_xml_file          : '~/local/tmp_gg_xml_file.xml',$
                    leaf_array            : ptr_new(0L),$
                    setpointStatus        : 'S',$
                    userStatus            : 'U',$
                    readbackStatus        : 'R',$
                    cmd_command           : 'TS_geom_calc.sh ',$
                    geek                  : 'j35',$
                    output_default_geometry_path : '~/local',$
                    RunNumber             : '',$
                    output_geometry_ext   : '_geom',$
                    cvinfo_default_path   : '~/',$
                    geometry_default_path : '~/',$
                    geometry_xml_filtering: '*.xml',$
                    cvinfo_xml_filtering  : '*_cvinfo.xml',$
                    default_extension     : 'nxs',$
                    version_light         : versionLight,$
                    motors                : ptr_new(0L),$   ;full xml
                    untouched_motors      : ptr_new(0L),$   ;full untouched xml
                    motor_group           : ptr_new(0L),$   ;xml of selected group only
                    group_leader          : 0L,$
                    version : VERSION })

(*(*global).leaf_array) = { uname : ['leaf1',$
                                     'leaf2',$
                                     'leaf3',$
                                     'leaf4',$
                                     'leaf5'],$
                            name : ['number',$
                                    'angle',$
                                    'length',$
                                    'wavelength',$
                                    'other']}

InstrumentList = ['',$
                  'Backscattering',$
                  'Liquids Reflectometer',$
                  'Magnetism Reflectometer',$
                  'ARCS']
                  
instrumentShortList = ['',$
                       'BSS',$
                       'REF_L',$
                       'REF_M',$
                       'ARCS']
(*(*global).instrumentShortList) = instrumentShortList

images_structure = { images_path : [current_folder,$
                                    'images'],$
                     images : ['numbers.bmp',$
                               'angles.bmp',$
                               'lengths.bmp',$
                               'wavelength.bmp',$
                               'other.bmp']}

IF (versionLight) THEN BEGIN
    MainBaseTitle = 'Geometry Generator (version light)'
    IF (ucams EQ (*global).geek) THEN BEGIN
        MainBaseSize  = [30,25,700,700]
    ENDIF ELSE BEGIN
        MainBaseSize  = [30,25,700,530]
    ENDELSE
ENDIF ELSE BEGIN
    MainBaseTitle = 'Geometry Generator'
    MainBaseSize  = [30,25,700,500]
ENDELSE
        
MainBaseTitle += ' - ' + VERSION
;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER = wGroup,$
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
widget_control, MAIN_BASE, set_uvalue=global

;confirmation base
MakeGuiConfirmationBase, MAIN_BASE
;final status base
MakeGuiFinalResultBase, MAIN_BASE

;BASE #2
MakeGuiInputGeometry, $ 
  MAIN_BASE, $
  MainBaseSize, $
  images_structure

;BASE #1
MakeGuiLoadingGeometry, $
  MAIN_BASE, $
  MainBaseSize, $
  InstrumentList, $
  InstrumentIndex, $
  versionLight

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', $
  MAIN_BASE, $
  /NO_BLOCK, $
  CLEANUP='gg_Cleanup', $
  GROUP_LEADER=wGroup 

(*global).group_leader = MAIN_BASE

;populate geometry droplist
GeoArray = getGeometryList(instrumentShortList(instrumentIndex))
id = widget_info(MAIN_BASE, find_by_uname='geometry_droplist')
widget_control, id, set_value=GeoArray
id = widget_info(MAIN_BASE, find_by_uname='geometry_text_field')
widget_control, id, set_value=GeoArray[0]

;show selected instrument
id = widget_info(MAIN_BASE, find_by_uname='instrument_droplist')
widget_control, id, set_droplist_select=instrumentIndex

;logger message
logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
ENDIF ELSE BEGIN
    spawn, logger_message
ENDELSE

END


; Empty stub procedure used for autoloading.
pro gg, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





