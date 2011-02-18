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

FUNCTION create_output_file_name, Event, $
                                  INDEX       = index, $
                                  OUTPUT_PATH = output_path, $
                                  OUTPUT_NAME = output_name

WIDGET_CONTROL,Event.top,GET_UVALUE=global
IF (index LT 10) THEN BEGIN
    sindex = '0' + STRCOMPRESS(index,/REMOVE_ALL)
ENDIF ELSE BEGIN
    sindex = STRCOMPRESS(index,/REMOVE_ALL)
ENDELSE

IF (output_name EQ '') THEN BEGIN
    file_name = 'BSS'
    run_number = (*global).RunNumber
    IF (STRCOMPRESS(run_number,/REMOVE_ALL) NE '') THEN BEGIN
        file_name += '_' + STRCOMPRESS(run_number,/REMOVE_ALL)
    ENDIF
    file_name += '_Q' + sindex + '.txt'
ENDIF ELSE BEGIN ;default name already provided
;remove ext and put _Q## instead
    name_split = STRSPLIT(output_name,'.',/EXTRACT,COUNT=nbr)
    IF (nbr GT 1) THEN BEGIN
        file_name = name_split[0] + '_Q' + sindex + '.' + name_split[1]
    ENDIF ELSE BEGIN
        file_name = output_name + '_Q' + sindex + '.txt'
    ENDELSE
ENDELSE
RETURN, output_path + file_name
END

;------------------------------------------------------------------------------
FUNCTION CreateArrayOfJobs, Event,$
                            cmd, $
                            Qaxis       = Qaxis, $
                            Qbin        = Qbin,$
                            NBR_JOBS    = nbr_jobs, $
                            FLAG        = flag,$
                            output_flag = output_flag,$
                            _EXTRA      = _extra

index = 0
WHILE (index LT NBR_JOBS) DO BEGIN
;create command line
    new_cmd  = cmd + flag
    new_cmd += STRCOMPRESS(Qaxis[index],/REMOVE_ALL) 
    new_cmd += ',' + STRCOMPRESS(Qaxis[index+1],/REMOVE_ALL)
    new_cmd += ',' + STRCOMPRESS(Qbin,/REMOVE_ALL)
;create name of output file
    full_output_file_name = create_output_file_name(Event, $
                                                    index = index, $
                                                    _EXTRA = _extra)
;final new cmd is
    new_cmd += output_flag + full_output_file_name
    IF (index EQ 0) THEN BEGIN
        cmd_array = [new_cmd]
    ENDIF ELSE BEGIN
        cmd_array = [cmd_array,new_cmd]
    ENDELSE
    index++
ENDWHILE
RETURN, cmd_array
END



