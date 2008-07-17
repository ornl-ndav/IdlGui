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

APPLICATION = 'SANSreduction'
VERSION     = '1.0.2'
DEBUGGING   = 'no' ;yes/no
TESTING     = 'no'  
;works only on dev and pick up ~/bin/runenv before the command line

;define initial global values - these could be input via external
;file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

IF (!VERSION.os EQ 'darwin') THEN BEGIN
   ucams = 'j35'
ENDIF ELSE BEGIN
   ucams = get_ucams()
ENDELSE

wave_para_label = 'Comma-delimited List of Increasing Coefficients'
wave_para_help_label = '1 + 23*X + 456*X^2 + 7890*X^3   --->'
wave_para_help_value = '1,23,456,7890'
;define global variables
global = PTR_NEW ({version:         VERSION,$
                   ROIcolor:        250,$
                   DrawXcoeff:      4,$
                   DrawYcoeff:      4,$
                   TESTING:         TESTING,$
                   application:     APPLICATION,$
                   ucams:           ucams,$
                   DataArray:       ptr_new(0L),$
                   X:               0L,$
                   Y:               0L,$
                   PrevTabSelect:   0,$
                   processing:      '(PROCESSING)',$
                   ok:              'OK',$
                   failed:          'FAILED',$
                   roi_extension:   '.dat',$
                   roi_filter:      '*.dat',$
                   roi_path:        '~/',$
                   geo_extension:   'nxs',$
                   geo_filter:      '*.nxs',$
                   geo_path:        '/LENS/',$
                   nexus_extension: 'nxs',$
                   nexus_filter:    '*.nxs',$
                   nexus_title:     'Browse for a Data NeXus File',$
                   nexus_path:      '/LENS/',$
                   selection_extension: 'txt',$
                   selection_filter: '*.txt',$
                   selection_title:  'Browse for a ROI file',$
                   selection_path:   '~/',$
                   data_nexus_file_name: '',$
                   inst_geom:       '',$
                   wave_para_value: '',$
                   wave_para_label: wave_para_label,$               
                   wave_para_help_label: wave_para_help_label,$
                   wave_para_help_value: wave_para_help_value,$
                   ReducePara: {driver_name: $
                                'sas_reduction1',$
                                overwrite_geo: $
                                '--inst-geom',$
                                detect_time_offset: $
                                '--time-zero-offset-det',$
                                monitor_time_offset: $
                                '--time-zero-offset-mon',$
                                monitor_efficiency: {flag: $
                                                     '--mon-effc',$
                                                     default: $
                                                     1},$ ;on/OFF
                                monitor_efficiency_constant: $
                                '--mon-eff-const',$
                                verbose: $
                                '--verbose',$
                                min_lambda_cut_off:$
                                '--lambda-low_cut',$
                                max_lambda_cut_off:$
                                '--lambda-high_cut',$
                                monitor_rebin: $
                                '--mom-trans-bins',$
                                wave_dep_back_sub:$
                                '--bkg-coeff',$
                                roi_file: $
                                '--roi-file'},$
                   CorrectPara: {solv_buffer: {title: $
                                               'Solvant Buffer Only',$
                                               flag: $
                                               '--solv'},$
                                 roi:         {title: $
                                               'ROI File',$
                                               flag: $
                                               '--roi-file'},$
                                 empty_can:    {title: $
                                                'Empty Can',$
                                                flag: $
                                                '--ecan'},$
                                 open_beam:    {title: $
                                                'Open Beam (shutter open)',$
                                                flag: $
                                                '--open'},$
                                 dark_current: {title: $
                                                'Dark Current (shutter ' + $
                                                'closed)',$
                                                flag: $
                                                '--dkcur'},$
                                 sample_data_trans: {flag: $
                                                     '--data-trans'},$
                                 empty_can_trans: {flag: $
                                                   '--ecan-trans'}},$
                   IntermPara: {bmon_wave: {title: $
                                            'Beam Monitor after ' + $
                                            'Conversion to Wavelength',$
                                            flag: $
                                            '--dump-bmon-wave'},$
                                bmon_effc: {title: $
                                            'Beam Monitor in Wavelenght' + $
                                            ' after Efficiency correction',$
                                            flag: $
                                            '--dump-bmon-effc'},$
                                bmnon_wave: {title: $
                                             'Combined Spectrum of Data' + $
                                             ' after Beam Monitor ' + $
                                             'Normalization',$
                                             flag: $
                                             '--dump-wave-bmnom',$
                                             flag1: $
                                             '--lambda-bins'},$
                                wave:        {title: $
                                              'Data of Each Pixel after' + $
                                              ' Wavelength Conversion' + $
                                              ' (WARNING: HUGE FILE !)',$
                                              flag: $
                                              '--dump-wave'},$
                                fract_counts: {title: $
                                              'Fractional Counts and Area' + $
                                               ' after Q Rebinning (Two ' + $
                                               'Files)',$
                                              flag: $
                                              '--dump-frac-rebin'},$
                                bmon_rebin : {title: $
                                              'Monitor Spectrum after' + $
                                              ' Rebin to Detector' + $
                                              ' Wavelength Axis' + $
                                              ' (WARNING: HUGE FILE !)',$
                                              flag: $
                                              '--dump-bmon-rebin'}}$
                                 })

MainBaseTitle  = 'SANS Data Reduction GUI'
MainBaseSize   = [30,25,695,550]
MainBaseTitle += ' - ' + VERSION

;==============================================================================
;Build Main Base ==============================================================
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
widget_control, MAIN_BASE, SET_UVALUE=global

;Build Tab1
make_gui_main_tab, MAIN_BASE, MainBaseSize

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;==============================================================================
;debugging version of program
IF (DEBUGGING EQ 'yes' AND $
    ucams EQ 'j35') THEN BEGIN
    nexus_path           = '~/SVN/IdlGui/branches/SANSreduction/1.0'
    (*global).nexus_path = nexus_path
    (*global).selection_path = '~/SVN/IdlGui/branches/SANSreduction/1.0/'
;put run 45 in the Run Number Data (first tab)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='run_number_cw_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='45'
;populate the REDUCE tab to be able to run right away
;Data File text field (Load Files)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='data_file_name_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='/LENS/SANS/2008_01_COM/1/45/NeXus/SANS_45.nxs'
;Time Zero Offset (Parameters)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='time_zero_offset_detector_uname')
    WIDGET_CONTROL, id, $
      SET_VALUE='500'
    id = WIDGET_INFO(MAIN_BASE, $
                     FIND_BY_UNAME='time_zero_offset_beam_monitor_uname')
    WIDGET_CONTROL, id, $
      SET_VALUE='500'
;Q range (Parameters)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='qmin_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='0.1'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='qmax_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='5'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='qwidth_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='0.1'


;show tab #2 'REDUCE
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1
;show tab of the REDUCE tab
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 2 ;PARAMETERS

ENDIF
;==============================================================================

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

;==============================================================================
; Empty stub procedure used for autoloading.
PRO sans_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





