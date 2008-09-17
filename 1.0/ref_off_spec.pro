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

;******************************************************************************
;******************************************************************************
APPLICATION       = 'REFoffSpec'
VERSION           = '1.0.3'
DEBUGGING         = 'yes' ;yes/no
TESTING           = 'no' 
SCROLLING         = 'no' 
CHECKING_PACKAGES = 'yes'
SUPER_USERS       = ['j35']

;DEBUGGING (enter the tab you want to see)
;main_tab: 0:Reduction, 1:Loading, 2: Shifting, 3:Scaling, 4:Options,
;5:Log Book 
;scaling_tab: 0: pixel range selection, 1: scaling
sDEBUGGING = { tab: {main_tab: 3,$
                     scaling_tab: 0},$ 
               ascii_path: '~/SVN/IdlGui/branches/REFoffSpec/1.0/'}
;PACKAGES
PACKAGE_REQUIRED_BASE = { driver:           '',$
                          version_required: ''}
my_package = REPLICATE(PACKAGE_REQUIRED_BASE,1)
my_package[0].driver           = 'findnexus'
my_package[0].version_required = '1.5'

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
global = ptr_new ({ ucams:               ucams,$
                    left_mouse_pressed:  0,$
                    step4_step1_left_mouse_pressed: 0,$
                    plot_realign_data:   0,$
                    ref_pixel_list:      ptr_new(0L),$
                    ref_pixel_offset_list: ptr_new(0L),$
                    ref_pixel_list_original: ptr_new(0L),$
                    ref_x_list:          ptr_new(0L),$
                    super_users:         SUPER_USERS,$
                    delta_x:             0.,$
                    something_to_plot:   0,$
                    first_load:          0,$
                    congrid_coeff_array: ptr_new(0L),$
                    application:         APPLICATION,$
                    box_color:           [50,75,100,125,150,175,200,225,250],$
                    processing:          '(PROCESSING)',$
                    ok:                  'OK',$
                    failed:              'FAILED',$                    
                    version:             VERSION,$
                    MainBaseSize:        [30,25,1276,901],$
                    ascii_extension:     'txt',$
                    ascii_filter:        '*.txt',$
                    ascii_path:          '~/',$
                    sys_color_face_3d:   INTARR(3),$
                    list_OF_ascii_files: ptr_new(0L),$
                    trans_coeff_list:    ptr_new(0L),$
                    pData:               ptr_new(0L),$
                    pData_y:             ptr_new(0L),$
                    realign_pData_y:     ptr_new(0L),$
                    untouched_realign_pData_y: ptr_new(0L),$
                    first_realign:       1,$
                    manual_ref_pixel:    0,$
                    pData_x:             ptr_new(0L),$
                    x_axis:              ptr_new(0L),$
                    total_array:         ptr_new(0L),$
                    xscale:              {xrange: FLTARR(2),$
                                          xticks: 1L,$
                                          position: INTARR(4)},$
                    PrevTabSelect:       0,$
                    PrevScalingTabSelect: 0,$
                    step4_step1_selection: [0,0,0,0],$
                    plot2d_x_left:       0,$
                    plot2d_y_left:       0,$
                    plot2d_x_right:      0,$
                    plot2d_y_right:      0,$
                    w_shifting_plot2d_draw_uname: '',$
                    w_shifting_plot2d_id: 0$ ;id of plot2D widget_base
                  })

;initialize variables
(*(*global).list_OF_ascii_files) = STRARR(1)

MainBaseSize   = (*global).MainBaseSize
MainBaseTitle  = 'Reflectometer Off Specular Application'
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

;get the color of the GUI to hide the widget_draw that will draw the label
sys_color = WIDGET_INFO(MAIN_BASE,/SYSTEM_COLORS)
(*global).sys_color_face_3d = sys_color.face_3d

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

label = Widget_label(MAIN_BASe,$
                     xoffset = 0,$
                     yoffset = 0,$
                     value = '')

;confirmation base
MakeGuiMainBase, MAIN_BASE, global

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;change color of background    
id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scale_draw_step2')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

;LOADCT, 0,/SILENT

;??????????????????????????????????????????????????????????????????????????????
IF (DEBUGGING EQ 'yes' ) THEN BEGIN
;tab to show (main_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')    
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.main_tab
;tab to show (scaling_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='scaling_main_tab')    
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.scaling_tab
;ascii default path
    (*global).ascii_path = sDEBUGGING.ascii_path
ENDIF
;??????????????????????????????????????????????????????????????????????????????

;refresh_plot_scale, MAIN_BASE=MAIN_BASE ;_plot    ;rmeove comments

;==============================================================================
; Date and Checking Packages routines =========================================
;==============================================================================
;Put date/time when user started application in first line of log book
time_stamp = GenerateIsoTimeStamp()
message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
  message

IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    CheckPackages, MAIN_BASE, global, my_package;_CheckPackages
ENDIF

;==============================================================================
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


; Empty stub procedure used for autoloading.
PRO ref_off_spec, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





