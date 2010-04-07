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
  
  ;get second column of table
  column_cl = (*(*global).column_cl)
  column_sequence = (*(*global).column_sequence)
  
  sz = N_ELEMENTS(column_cl)
  index = 0
  WHILE (index LT sz) DO BEGIN
    runs_array = STRSPLIT(column_sequence[index],',',/EXTRACT,count=nbr)
    ;    runs = STRJOIN(runs_array,'_')
    runs = STRCOMPRESS(runs_array[0],/REMOVE_ALL)
    runs += '_' + STRCOMPRESS(nbr,/REMOVE_ALL) + 'runs'
    column_cl[index]+= runs + (*global).output_prefix
    index++
  ENDWHILE
  
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    cmd = column_cl[index]
    cmd_text = '-> Job #' + STRCOMPRESS(index,/REMOVE_ALL)
    cmd_text += ': ' + cmd
    IDLsendLogBook_addLogBookText, Event, ALT=alt, cmd_text
    SPAWN, cmd
    
    index++
  ENDWHILE
  
END
