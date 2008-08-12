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
APPLICATION       = 'REFoffSpec'
VERSION           = '1.0.0'
DEBUGGING         = 'no' ;yes/no
TESTING           = 'no' 
SCROLLING         = 'no' 
CHECKING_PACKAGES = 'no'

PACKAGE_REQUIRED_BASE = { driver:           '',$
                          version_required: ''}
my_package = REPLICATE(PACKAGE_REQUIRED_BASE,1)
my_package[0].driver           = 'findnexus'
my_package[0].version_required = '1.5'

;************************************************************************
;************************************************************************

;define initial global values - these could be input via external file or other
;means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

IF (!VERSION.os EQ 'darwin') THEN BEGIN
   ucams = 'j35'
ENDIF ELSE BEGIN
   ucams = GET_UCAMS()
ENDELSE

;define global variables
global = ptr_new ({ ucams:       ucams,$
                    processing:  '(PROCESSING)',$
                    ok:          'OK',$
                    failed:      'FAILED',$
                    version:     VERSION })

MainBaseSize   = [30,25,1276,901]
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

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;confirmation base
MakeGuiMainBase, MAIN_BASE, global

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;==============================================================================
; Date and Checking Packages routines =========================================
;==============================================================================
;Put date/time when user started application in first line of log book
;time_stamp = GenerateIsoTimeStamp()
;message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
;IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
;  message

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
            ENDIF ELSE BEGIN    ;missing program
                IDLsendToGeek_ReplaceLogBookText_fromMainBase, $
                  MAIN_BASE, $
                  'log_book_text', $
                  PROCESSING,$
                  FAILED
;              + ' (Minimum Required Version: ' + $
;              my_package[i].version_required + ')'
                missing_packages[i] = my_package[i].driver
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
            
    ENDIF                       ;end of 'if (sz GT 0)'

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





