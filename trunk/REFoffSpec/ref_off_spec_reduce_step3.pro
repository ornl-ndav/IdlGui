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

PRO refresh_reduce_step3_table, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  step3_big_table = STRARR(40,9)
  
  tab1_table = (*(*global).reduce_tab1_table)
  ;retrieve list of Data Runs
  data_run_number = tab1_table[0,*] ;array[1,18]
  short_data_run_number = RemoveEmptyElement(data_run_number[0,*])
  HELP, short_data_run_number
  PRINT, short_data_run_number
  PRINT
  
  ;retrieve data full file name
  data_nexus_file_name = tab1_table[1,*] ;array[1,18]
  HELP, data_nexus_file_name
  HELP, data_nexus_file_name[0,*]
  short_data_nexus_file_name = RemoveEmptyElement(data_nexus_file_name[0,*])
  HELP, short_data_nexus_file_name
  PRINT, short_data_nexus_file_name
  PRINT
  
  ;retrieve working polarization state
  data_working_spin_state = $ ;'Off_Off'
    getDataWorkingSpinState((*global).reduce_tab1_working_pola_state)
  HELP, data_working_spin_state
  PRINT, data_working_spin_state
  PRINT
  
  ;retrieve list of other polarization states
  list_of_other_pola_state = getListOfDataSpinStates(Event)
  HELP, list_of_other_pola_state
  PRINT, list_of_other_pola_state
  PRINT
  
  ;push working pola state into list_of_other_pola_state
  full_list_of_pola_state = push_array(ARRAY=list_of_other_pola_state,$
    NEW_ELEMENT=data_working_spin_state)
    
  ;get full number of polarization states
  nbr_pola_state = getNbrWorkingPolaState(full_list_of_pola_state)
  PRINT, 'nbr_pola_state: ' + STRCOMPRESS(nbr_pola_state)
  PRINT
  
  ;loop over all the working pola state to populate big table
  index = 0 
  WHILE (index LT nbr_pola_state) DO BEGIN
  
  
    index++
  ENDWHILE
  
  
  
  
  
END