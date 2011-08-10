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

FUNCTION create_command_line, Event

;check if use iterative background subtraction is active or not
ibs_value = $
  getCWBgroupValue(Event, $
                   'use_iterative_background_subtraction_cw_bgroup')

;add called to SLURM
;check instrument here
spawn, 'hostname',listening
CASE (listening) OF
    'bac.sns.gov': srun = 'bac1q'
    'bac2':        srun = 'bac2q'
    ELSE:          srun = 'bss'
ENDCASE

;get command line to generate
cmd      = getTextFieldValue(Event,'command_line_generator_text')
nbr_jobs = N_ELEMENTS(cmd)
index    = 0
WHILE (index LT nbr_jobs) DO BEGIN
    cmd1  = 'srun --batch -p ' + srun
    cmd[index] = cmd1 + ' ' + cmd[index]
    index++
ENDWHILE

RETURN, cmd
END

;------------------------------------------------------------------------------

PRO command_line_path, Event

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

output_path = (*global).CL_output_path
title       = 'Select where you want to create the Command Line File'

new_path = DIALOG_PICKFILE(/DIRECTORY,$
                           /MUST_EXIST,$
                           PATH  = output_path,$
                           TITLE = title)

IF (new_path NE '') THEN BEGIN
    (*global).CL_output_path = new_path
    putButtonValue, Event, 'command_line_path_button', new_path
ENDIF

END

;------------------------------------------------------------------------------

PRO generate_command_line_file_name, Event

suffix = 'CL_'
time   = GenerateIsoTimeStamp()
prefix = '.txt'

file_name = suffix + time + prefix

putTextInTextField, Event, 'command_line_file_text_field', file_name

END

;------------------------------------------------------------------------------

PRO create_cl_file, Event

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

text = '> Create File of the Command Line:'
IDLsendLogBook_addLogBookText, Event, text

;get full output file name
path = getButtonValue(Event,'command_line_path_button')
file = getTextFieldValue(Event,'command_line_file_text_field')
full_file_name = path + file

text = '-> Full File Name: ' + full_file_name
IDLsendLogBook_addLogBookText, Event, text

;get command line to run
command_line = create_command_line(Event)

IDLsendLogBook_addLogBookText, Event, '-> Write File ... ' + PROCESSING

no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
;write command line in file
    OPENW, 1, full_file_name
    nbs   = N_ELEMENTS(command_line)
    index = 0
    WHILE (index LT nbs) DO BEGIN
        cmd = command_line[index]
        PRINTF, 1, cmd
        index++
    ENDWHILE
    CLOSE, 1
    FREE_LUN, 1
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END
