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
FUNCTION GenerateTimeStamp

dateUnformated = SYSTIME()    
DateArray      = STRSPLIT(dateUnformated,' ',/EXTRACT) 
DateIso        = STRCOMPRESS(DateArray[4]) + '/';year

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01m'
    'Feb':month='02m'
    'Mar':month='03m'
    'Apr':month='04m'
    'May':month='05m'
    'Jun':month='06m'
    'Jul':month='07m'
    'Aug':month='08m'
    'Sep':month='09m'
    'Oct':month='10m'
    'Nov':month='11m'
    'Dec':month='12m'
ENDCASE

DateIso += STRCOMPRESS(month,/REMOVE_ALL) + '/' ;month 
DateIso += STRCOMPRESS(DateArray[2],/REMOVE_ALL) + ' : ' ;day

;change format of time
time     = STRSPLIT(DateArray[3],':',/EXTRACT)
DateIso += STRCOMPRESS(time[0],/REMOVE_ALL) + 'h ';hour
DateIso += STRCOMPRESS(time[1],/REMOVE_ALL) + 'mn ';mn
DateIso += STRCOMPRESS(time[2],/REMOVE_ALL) + 's';s

RETURN, DateIso
END

;------------------------------------------------------------------------------
FUNCTION getVersion, listening
sz = N_ELEMENTS(listening)
i  = 0
WHILE (i LT sz) DO BEGIN
    version_str = STRCOMPRESS(listening[i],/REMOVE_ALL)
    IF (version_str NE '') THEN RETURN, listening[i]
    i++
ENDWHILE
RETURN, 'N/A'
END
   
;------------------------------------------------------------------------------
PRO checking_packages_routine, MAIN_BASE, my_package, global

;==============================================================================
; Date and Checking Packages routines =========================================
;==============================================================================
;Put date/time when user started application in first line of log book
time_stamp = GenerateTimeStamp()
message    = '>>>>>>  Application started date/time: ' + time_stamp + $
             ' <<<<<<'
IDLsendLogBook_putLogBookText_fromMainBase, MAIN_BASE, message

;Check that the necessary packages are present
message = '> Checking For Required Software: '
IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE, message

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
NbrSpc     = 25                 ;minimum value 4

sz = (SIZE(my_package))(1)

IF (sz GT 0) THEN BEGIN
   max = 0                            ;find the longer required software name
   pack_list = STRARR(sz)             ;initialize the list of driver
   missing_packages = STRARR(sz)      ;initialize the list of missing packages
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
       
       IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE, message
       
       cmd = pack_list[i] + ' --version'
       SPAWN, cmd, listening, err_listening
       IF (err_listening[0] EQ '') THEN BEGIN ;found
           VERSION = getVersion(listening)
           IDLsendLogBook_ReplaceLogBookText_fromMainBase, $
             MAIN_BASE, $
             PROCESSING,$
             OK + ' (Current Version: ' + $
             VERSION + ')'
;              ' / Minimum Required Version: ' + $
;              my_package[i].version_required + ')'
           my_package[i].found = 1
           IF (my_package[i].sub_pkg_version NE '') THEN BEGIN
               IF (first_sub_packages_check EQ 1) THEN BEGIN
                   first_sub_packages_check = 0
                   cmd = my_package[i].sub_pkg_version
                   SPAWN, cmd, listening, err_listening
                   IF (err_listening[0] EQ '') THEN BEGIN ;worked
                       cmd_txt = '-> ' + cmd + ' ... OK'
                       IDLsendLogBook_addLogBookText_fromMainBase, $
                         MAIN_BASE, cmd_text
                       IDLsendLogBook_addLogBookText_fromMainBase, $
                         MAIN_BASE, $
                         '--> ' + listening
;tell the structure that the correct version has been found
                       my_package[i].found = 1
                   ENDIF ELSE BEGIN
                       cmd_txt = '-> ' + cmd + ' ... FAILED'
                       IDLsendLogBook_addLogBookText_fromMainBase, $
                         MAIN_BASE, cmd_text
;tell the structure that the correct version has been found
                       my_package[i].found = 0
                   ENDELSE
               ENDIF
           ENDIF
       ENDIF ELSE BEGIN         ;missing program
           IDLsendLogBook_ReplaceLogBookText_fromMainBase, $
             MAIN_BASE, $
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
                               DIALOG_PARENT=MAIN_BASE,$
                               /center)
   ENDIF
   
ENDIF ELSE BEGIN                ;end of 'if (sz GT 0)'
    message= 'No packages required!'
    IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE, message
ENDELSE

message = '=================================================' + $
  '========================'
IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE, message

(*(*global).my_package) = my_package

END
