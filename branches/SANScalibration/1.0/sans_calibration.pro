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

;************************************************************************
;************************************************************************
APPLICATION       = 'SANScalibration'
VERSION           = '1.0.7'
DEBUGGING         = 'yes' ;yes/no
TESTING           = 'no'  
CHECKING_PACKAGES = 'yes'
SCROLLING         = 'no' 
PACKAGE_REQUIRED_BASE = { driver:           '',$
                          version_required: '',$
                          found: 0,$
                          sub_pkg_version:   ''}
;sub_pkg_version: python program that gives pkg v. of common libraries...etc
my_package = REPLICATE(PACKAGE_REQUIRED_BASE,4)
my_package[0].driver           = 'findnexus'
my_package[0].version_required = '1.5'
my_package[1].driver           = 'sas_transmission'
my_package[1].version_required = '1.0'
my_package[1].sub_pkg_version  = './drversion'
my_package[2].driver           = 'sas_background'
my_package[2].version_required = '1.0'
my_package[3].driver           = 'tof_slicer'

;*************************************************************************
;*************************************************************************

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

;define global variables
global = PTR_NEW ({version:         VERSION,$
                   main_base_uname: 'MAIN_BASE',$
                   MainBaseSize:    INTARR(4),$
                   tof_ascii_path:  '~/',$
                   tof_ascii_path_backup:  '~/',$
                   tof_ascii_type:  '',$
                   package_required_base: ptr_new(0L),$
                   advancedToolId: 0,$
                   tof_slicer: 'tof_slicer',$
                   list_OF_files_to_send: ptr_new(0L),$
                   auto_output_file_name: 1,$
                   Xpixel: 80L,$     ;320 or 80
                   mouse_status: 0,$ ;0:nothing, 1:has been pressed
                   rectangle_XY0_mouse: [0,0],$
                   rectangle_XY1_mouse: [0,0],$
                   rectangle_selection_color: 50,$
                   current_output_file_name: '',$
                   MainBaseTitle: '',$
                   sys_color_face_3d: INTARR(3),$
                   DisplayR1:        0.,$
                   DisplayR2:        0.,$
                   there_is_a_selection: 0,$
                   exclusion_type_index: 0,$ ;0,1,2 or 3
                   TESTING:         TESTING,$
                   fitting_status:  1,$        ;0:succes, 1:failed
                   ascii_file_load_status: 0,$ ;1:success, 0:failed
                   txt_extension:   'bkg',$
                   txt_filter:      ['*.txt','*.bkg'],$
                   txt_title:       'Browse for an TXT file',$
                   txt_path:        '~/',$
                   application:     APPLICATION,$
                   ROIcolor:        250L,$
                   DrawXcoeff:      8,$
                   DrawYcoeff:      8,$
                   ucams:           ucams,$
                   DataArray:       ptr_new(0L),$
                   tof_array:       ptr_new(0L),$
                   tof_min:         0.0,$
                   tof_max:         0.0,$
                   pressed_stop:    0,$
                   img:             ptr_new(0L),$
                   X:               0L,$
                   Y:               0L,$
                   PrevTabSelect:   0,$
                   processing:      '(PROCESSING)',$
                   ok:              'OK',$
                   failed:          'FAILED',$
                   NOT_found:       'NOT_FOUND',$
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
                   selection_extension: 'dat',$
                   selection_filter: '*.dat',$
                   selection_title:  'Browse for a ROI file',$
                   selection_path:   '~/',$
                   RoiPixelArrayExcluded: ptr_new(0L),$
                   ascii_trans_extension: '.txt',$
                   ascii_back_extension: '.bkg',$
                   ascii_trans_filter: '*.txt',$
                   ascii_back_filter:  '*.bkg',$
                   ascii_path:      '~/',$
                   ascii_title:     'Browse for a Transmission ASCII File',$
                   data_nexus_file_name: '',$
                   short_data_nexus_file_name: '',$
                   path_data_nexus_file: '',$
                   inst_geom:       '',$
                   Xarray:           ptr_new(0L),$
                   Xarray_untouched: ptr_new(0L),$
                   Yarray:           ptr_new(0L),$
                   SigmaYarray:      ptr_new(0L),$
                   xaxis:            '',$
                   xaxis_units:      '',$
                   yaxis:            '',$
                   yaxis_units:      '',$
                   ReducePara: {transmission_driver_name: $
                                my_package[1].driver,$
                                background_driver_name: $
                                my_package[2].driver, $
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
                                acc_down_time: $
                                '--acc-down-time',$
                                min_lambda_cut_off:$
                                '--lambda-low-cut',$
                                max_lambda_cut_off:$
                                '--lambda-high-cut',$
                                monitor_rebin: $
                                '--mom-trans-bins',$
                                roi_file: $
                                '--roi-file'},$
                   CorrectPara: {transm_back: {title: $
                                               'Transmission Background',$
                                               flag: $
                                               '--back'},$
                                 roi:         {title: $
                                               'ROI File',$
                                               flag: $
                                               '--roi-file'},$
                                 sample_data_trans: {flag: $
                                                     '--data-trans'},$
                                 empty_can_trans: {flag: $
                                                   '--ecan-trans'},$
                                 wavelength_range: {title:$
                                                    'Wavelength Range',$
                                                    flag: $
                                                    '--lambda-bins'}},$
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

MainBaseTitle  = 'SANS Data Calibration GUI '
(*global).MainBaseTitle = MainBaseTitle
MainBaseTitle += '( Mode: Transmission ) '
MainBaseSize   = [30,25,695+320,550+320]
(*global).MainBaseSize = MainBaseSize
MainBaseTitle += ' - ' + VERSION

(*(*global).RoiPixelArrayExcluded) = INTARR(80,80)

;==============================================================================
;Build Main Base ==============================================================
IF (SCROLLING EQ 'yes') THEN BEGIN
    MAIN_BASE = WIDGET_BASE( GROUP_LEADER  = wGroup,$
                             UNAME         = (*global).main_base_uname,$
                             SCR_XSIZE     = MainBaseSize[2],$
                             XOFFSET       = MainBaseSize[0],$
                             YOFFSET       = MainBaseSize[1],$
                             TITLE         = MainBaseTitle,$
                             SPACE         = 0,$
                             XPAD          = 0,$
                             YPAD          = 2,$
;                             X_SCROLL_SIZE = 1100,$
                             Y_SCROLL_SIZE = 650,$
                             MBAR          = WID_BASE_0_MBAR)
    
ENDIF ELSE BEGIN
    MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
                             UNAME        = (*global).main_base_uname,$
                             SCR_XSIZE    = MainBaseSize[2],$
                             SCR_YSIZE    = MainBaseSize[3],$
                             XOFFSET      = MainBaseSize[0],$
                             YOFFSET      = MainBaseSize[1],$
                             TITLE        = MainBaseTitle,$
                             SPACE        = 0,$
                             XPAD         = 0,$
                             YPAD         = 2)
ENDELSE

;get the color of the GUI to hide the widget_draw that will label the draw
sys_color = WIDGET_INFO(MAIN_BASE,/SYSTEM_COLORS)
(*global).sys_color_face_3d = sys_color.face_3d

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, SET_UVALUE=global

;Build Tab1
make_gui_main_tab, MAIN_BASE, MainBaseSize, global

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='sans_calibration_cleanup' 

;give superpower to j35 and 2zr
IF (ucams EQ 'j35' OR $
    ucams EQ '2zr') THEN BEGIN
   id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='command_line_preview')
   WIDGET_CONTROL, id, /EDITABLE
ENDIF

;==============================================================================
;debugging version of program
IF (DEBUGGING EQ 'yes' AND $
    ucams EQ 'j35') THEN BEGIN
    nexus_path           = '~/SVN/IdlGui/branches/SANScalibration/1.0'
    (*global).nexus_path = nexus_path
    (*global).ascii_path = '~/SVN/IdlGui/branches/SANScalibration/1.0/'
    (*global).selection_path = '~/SVN/IdlGui/branches/SANScalibration/1.0/'
;populate the FITTING tab (ascii file name)
   id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='input_file_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='~/SVN/IdlGui/branches/SANScalibration/1.0/SANS_175_new.txt'

;min,max and width
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='alternate_wave_min_text_field')
    WIDGET_CONTROL, id, SET_VALUE='0'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='alternate_wave_max_text_field')
    WIDGET_CONTROL, id, SET_VALUE='25'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='alternate_wave_width_text_field')
    WIDGET_CONTROL, id, SET_VALUE='0.5'

;activate load button
   id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='input_file_load_button')
    WIDGET_CONTROL, id, $
      SENSITIVE = 1
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
;Wavlength range (Parameters)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='wave_min_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='0.1'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='wave_max_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='5'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='wave_width_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='0.1'

;exclusion tool
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='x_center_value')
    WIDGET_CONTROL, id, $
      SET_VALUE='37.25'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='y_center_value')
    WIDGET_CONTROL, id, $
      SET_VALUE='41.625'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='r1_radii')
    WIDGET_CONTROL, id, $
      SET_VALUE='5'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='r2_radii')
    WIDGET_CONTROL, id, $
      SET_VALUE='0'

;show main tab # ?
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0
;show tab inside REDUCE
;    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab')
;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1

ENDIF

;change color of background    
id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='label_draw_uname')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value
;ERASE, COLOR=convert_rgb(sys_color.face_3d) 

plot, randomn(s,80), $
  XRANGE     = [0,80],$
  YRANGE     = [0,80],$
  COLOR      = convert_rgb([0B,0B,255B]), $
  BACKGROUND = convert_rgb(sys_color.face_3d),$
  THICK      = 1, $
  TICKLEN    = -0.015, $
  XTICKLAYOUT = 0,$
  YTICKLAYOUT = 0,$
  XTICKS      = 8,$
  YTICKS      = 8,$
  XMARGIN     = [5,5],$
  /NODATA

;==============================================================================
; Date and Checking Packages routines =========================================
;==============================================================================
;Put date/time when user started application in first line of log book
time_stamp = GenerateIsoTimeStamp()
message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
  message

IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
;Check that the necessary packages are present
    message = '> Checking For Required Software: '
    IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
      message
    
    PROCESSING = (*global).processing
    OK         = (*global).ok
    FAILED     = (*global).failed
    NbrSpc     = 25             ;minimum value 4
    
    sz = (size(my_package))(1)
    
    IF (sz GT 0) THEN BEGIN
        max = 0                ;find the longer required software name
        pack_list = STRARR(sz)  ;initialize the list of driver
        missing_packages = STRARR(sz) ;initialize the list of missing packages
        nbr_missing_packages = 0
        FOR k=0,(sz-1) DO BEGIN
            pack_list[k] = my_package[k].driver
            length = STRLEN(pack_list[k])
            IF (length GT max) THEN max = length
        ENDFOR
        
        first_sub_packages_check = 1
        FOR i=0,(sz-1) DO BEGIN
            message = '-> ' + pack_list[i]
;this part is to make sure the PROCESSING string starts at the same column
            length = STRLEN(message)
            str_array = MAKE_ARRAY(NbrSpc+max-length,/STRING,VALUE='.')
            new_string = STRJOIN(str_array)
            message += ' ' + new_string + ' ' + PROCESSING
            
            IDLsendToGeek_addLogBookText_fromMainBase, $
              MAIN_BASE, $
              'log_book_text', $
              message

            cmd = pack_list[i] + ' --version'
            spawn, cmd, listening, err_listening
            IF (err_listening[0] EQ '') THEN BEGIN ;found
                IDLsendToGeek_ReplaceLogBookText_fromMainBase, $
                  MAIN_BASE, $
                  'log_book_text', $
                  PROCESSING,$
                  OK + ' (Current Version: ' + $
                  listening[N_ELEMENTS(listening)-1] + ')'
;              ' / Minimum Required Version: ' + $
;              my_package[i].version_required + ')'
                my_package[i].found = 1
                IF (my_package[i].sub_pkg_version NE '') THEN BEGIN
                    IF (first_sub_packages_check EQ 1) THEN BEGIN
                        first_sub_packages_check = 0
                        cmd = my_package[i].sub_pkg_version
                        spawn, cmd, listening, err_listening
                        IF (err_listening[0] EQ '') THEN BEGIN ;worked
                            cmd_txt = '-> ' + cmd + ' ... OK'
                            IDLsendToGeek_addLogBookText_fromMainBase, $
                              MAIN_BASE, $
                              'log_book_text', $
                              cmd_text
                            IDLsendToGeek_addLogBookText_fromMainBase, $
                              MAIN_BASE, $
                              'log_book_text', $
                              '--> ' + listening
;tell the structure that the correct version has been found
                            my_package[i].found = 1
                        ENDIF ELSE BEGIN
                            cmd_txt = '-> ' + cmd + ' ... FAILED'
                            IDLsendToGeek_addLogBookText_fromMainBase, $
                              MAIN_BASE, $
                              'log_book_text', $
                              cmd_text
;tell the structure that the correct version has been found
                            my_package[i].found = 0
                        ENDELSE
                    ENDIF
                ENDIF
            ENDIF ELSE BEGIN    ;missing program
                IDLsendToGeek_ReplaceLogBookText_fromMainBase, $
                  MAIN_BASE, $
                  'log_book_text', $
                  PROCESSING,$
                  FAILED
;              + ' (Minimum Required Version: ' + $
;              my_package[i].version_required + ')'
                missing_packages[i] = my_package[i].driver
;tell the structure that the correct version has been found
                my_package[i].found = 0
                ++nbr_missing_packages
             ENDELSE
        ENDFOR

        IF (nbr_missing_packages GT 0) THEN BEGIN
;pop up window that show that they are missing packages
            message = ['They are ' + $
                       STRCOMPRESS(nbr_missing_packages,/REMOVE_ALL) + $
                       ' missing package(s) you need to ' + $
                       'fully used this application.']
            message = [message,'Check Log Book For More Information !']
            result = DIALOG_MESSAGE(message, $
                                    /INFORMATION, $
                                    DIALOG_PARENT=MAIN_BASE)
            
            message = '=================================================' + $
              '========================'
            IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, $
               'log_book_text', message
         ENDIF
        
     ENDIF                      ;end of 'if (sz GT 0)'
    
 ENDIF

(*(*global).package_required_base) = my_package

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
PRO sans_calibration_cleanup, global
;if tof_base is active, close it here

END

;==============================================================================
; Empty stub procedure used for autoloading.
PRO sans_calibration, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





