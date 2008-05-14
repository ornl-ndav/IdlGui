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
CD, CURRENT=current_folder

APPLICATION = 'MakeNeXus'
VERSION     = '1.0.8'

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

IF (!VERSION.os EQ 'darwin') THEN BEGIN
   ucams = 'j35'
ENDIF ELSE BEGIN
   ucams = get_ucams()
ENDELSE

ucams = 'pf9'

;Check if users can archived
ArchivedUser = 0
SWITCH (ucams) OF
    'j35':
    'mid':
    'vl2':
    'ha9':
    '1qg': ArchivedUser = 1
    ELSE:
ENDSWITCH

;get hostname
spawn, 'hostname', hostname
CASE (hostname) OF
    'heater'      : instrumentIndex = 0
    'lrac'        : instrumentIndex = 2
    'mrac'        : instrumentIndex = 3
    'bac.sns.gov' : instrumentIndex = 1
    'bac2'        : instrumentIndex = 1
    'arcs1'       : instrumentIndex = 4
    'arcs2'       : instrumentIndex = 4
    'cncs'        : instrumentIndex = 5
    else          : instrumentIndex = 0
ENDCASE 

;define global variables
global = ptr_new ({ program_name:           'MakeNeXus',$
                    branch:                 '1.0',$
                    ArchivedCommand:        '/usr/local/bin/sns-nexus-live-catalog',$
                    archivedUser:           archivedUser,$
                    NbrPolaStates:          1,$
                    binType:                'linear',$
                    BinOffset:              0.0,$
                    BinMax:                 0L,$
                    BinWidth:               200L,$
                    prenexus_found_nbr:     0,$
                    validate_go:            0,$
                    RunNumber:              '',$
                    RunNumberArray:         ptr_new(0L),$
                    RunsToArchived:         ptr_new(0L),$
                    Instrument:             '',$
                    MainBaseXoffset:        0,$
                    MainBaseYoffset:        0,$
                    Event_to_Histo_Mapped:  'Event_to_Histo_Mapped',$
                    mac : { prenexus_path:  '/REF_L-DAS-FS/2008_1_2_SCI/REF_L_2000/',$
                            mapping_file:   '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_TS_2006_08_08.dat',$
                            geometry_file:  '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_2006_geom.nxs',$
                            translation_file: '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_2007_08_08.nxt'},$
                    instrumentShortList:  ptr_new(0L),$
                    LogBookPath:          '/SNS/users/LogBook/',$
                    hostname:             hostname,$
                    ucams:                ucams,$
                    geek:                 ['j35','pf9','2zr','mid'],$
                    prenexus_path:        '',$
                    prenexus_path_array:  ptr_new(0L),$
                    RunNumber_array:      ptr_new(0L),$
                    output_path_1:        '~/local',$
                    staging_folder:       '~/local/.makenexus_staging',$
                    processing:           '(PROCESSING)',$
                    ok:                   'OK',$
                    failed:               'FAILED',$
                    NbrPhase:             0,$
                    runinfo_ext:          '_runinfo.xml',$
                    version:              VERSION })


(*(*global).prenexus_path_array) = strarr(1)
(*(*global).RunNumber_array)     = strarr(1)

InstrumentList = ['Select your instrument...',$
                  'Backscattering',$
                  'Liquids Reflectometer',$
                  'Magnetism Reflectometer',$
                  'ARCS',$
                  'CNCS']

instrumentShortList = ['',$
                       'BSS',$
                       'REF_L',$
                       'REF_M',$
                       'ARCS',$
                       'CNCS']
(*(*global).instrumentShortList) = instrumentShortList

IF (WHERE(ucams EQ (*global).geek) EQ -1) THEN BEGIN ;normal user
    MainBaseSize  = [700,500,450,422]
    MainBaseTitle = 'Make NeXus - ' + VERSION
ENDIF ELSE BEGIN
    MainBaseSize  = [100,50,850,630]
    IF (WHERE(ucams EQ ['j35','mid']) NE -1) THEN BEGIN
        MainBaseTitle = 'Make NeXus (Super_Extra_Power Mode) - ' + VERSION
    ENDIF ELSE BEGIN
        MainBaseTitle = 'Make NeXus (SuperPower Mode) - ' + VERSION
    ENDELSE
ENDELSE


(*global).MainBaseXoffset = MainBaseSize[0]
(*global).MainBaseYoffset = MainBaseSize[1]
        
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
                         YPAD         = 2,$
                         MBAR         = WID_BASE_0_MBAR)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;HELP MENU in Menu Bar
HELP_MENU = WIDGET_BUTTON(WID_BASE_0_MBAR,$
                          UNAME = 'help_menu',$
                          VALUE = 'HELP',$
                          /MENU)
                          
HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
                            VALUE = 'HELP',$
                            UNAME = 'help_button')

IF (ucams EQ 'j35') THEN BEGIN
    MY_HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
                                   VALUE = 'LOCAL_HELP',$
                                   UNAME = 'my_help_button')
ENDIF

MakeGui, MAIN_BASE, MainBaseSize, InstrumentList, InstrumentIndex, ArchivedUser

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='makenexus_Cleanup' 

;set the instrument droplist
id = widget_info(MAIN_BASE,find_by_uname='instrument_droplist')
widget_control, id, set_droplist_select=InstrumentIndex

;if on mac, instrument is REF_L and run number is 2000
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    id = widget_info(MAIN_BASE,find_by_uname='instrument_droplist')
    widget_control, id, set_droplist_select=2
    id = widget_info(MAIN_BASE,find_by_uname='run_number_cw_field')
    widget_control,id,set_value='2000'   
ENDIF 

;;REMOVE ME
;;set the instrument droplist
;id = widget_info(MAIN_BASE,find_by_uname='instrument_droplist')
;widget_control, id, set_droplist_select=3
;id = widget_info(MAIN_BASE,find_by_uname='run_number_cw_field')
;widget_control,id,set_value='2968'
;id = widget_info(MAIN_BASE,find_by_uname='create_nexus_button')
;widget_control, id, sensitive=1
;(*global).prenexus_path = '/REF_M-DAS-FS/2008_1_4A_SCI/REF_M_2968/'
;END OF REMOVE

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
pro makenexus, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





