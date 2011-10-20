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

PRO launch_jobs, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  text = '> Launching jobs:'
  IDLsendLogBook_addLogBookText, Event, ALT=alt, text
  
  table = getTableValue(Event,'runs_table')
  cl_array = table[3,*]
  sz = N_ELEMENTS(cl_array)
  
  tab2_table = STRARR(3,sz+1)
    
  ;output folder
  CD, (*global).step1_output_path, CURRENT=old_path

  ;create file of jobs to submit and run file
  cl_file_name = (*global).step1_output_path + '/cl_jobs.txt'
  openw, 1, cl_file_name

  index = 0
  WHILE (index LT sz) DO BEGIN
  
    cmd = cl_array[index]
    cmd_text = '-> Job #' + STRCOMPRESS(index,/REMOVE_ALL)
    cmd_text += ': ' + cmd
    IDLsendLogBook_addLogBookText, Event, ALT=alt, cmd_text
    
    printf, 1, cmd

;    SPAWN, cmd
    
    ;get output file
    parse_array = split_string(cl_array[index], PATTERN='--output=')
    IF (N_ELEMENTS(parse_array) NE 2) THEN BEGIN
      output_file = 'N/A'
    ENDIF ELSE BEGIN
      output_file = parse_array[1]
    ENDELSE
    tab2_table[0,index] = output_file
    tab2_table[1,index] = 'NOT READY'
    
    index++
  ENDWHILE

  close, 1
  free_lun, 1
  
  ;run job
  spawn, 'chmod 700 ' + cl_file_name
  spawn, cl_file_name

  CD, old_path
  (*(*global).tab2_table) = tab2_table
  
END

