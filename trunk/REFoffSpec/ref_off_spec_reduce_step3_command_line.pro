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

PRO  reduce_step3_run_jobs, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;get big table of step3
  big_table = getTableValue(Event, 'reduce_tab3_main_spin_state_table_uname')
  nbr_row = (SIZE(big_table))(2)
  cl_table = STRARR(nbr_row)
  
  SPAWN, 'hostname', listening
  CASE (listening[0]) OF
    'lrac' : cmd_srun = 'srun --batch -p lracq '
    'mrac' : cmd_srun = 'srun --batch -p mracq '
    ELSE: BEGIN
      cmd_srun = 'srun --batch -p heaterq '
    END
  ENDCASE
  
  ;get path
  output_path = getButtonValue(Event, 'reduce_tab3_output_folder_button')
  
  ;get driver structure
  reduce_structure = (*global).reduce_structure
  
  nbr_jobs = 0
  FOR row=0,(nbr_row-1) DO BEGIN
  
    cmd = ''
  
    IF (big_table[0,row] EQ '') THEN BREAK ;stop if there is no more data file
    
    ;add 1 to the list of jobs
    nbr_jobs++
    
    ;driver
    cmd = cmd_srun + reduce_structure.driver
    
    ;data full nexus name
    data = big_table[1,row]
    cmd += ' ' + data
    
    ;data path
    data_path = '/entry-' + big_table[2,row] + '/bank1,1'
    cmd += ' ' + reduce_structure.data_paths + '=' + data_path
    
    ;norm full nexus name
    norm = big_table[4,row]
    cmd += ' ' + reduce_structure.norm + '=' + norm
    
    ;norm path
    norm_path = '/entry-' + big_table[5,row] + '/bank1,1'
    cmd += ' ' + reduce_structure.norm_paths + '=' + norm_path
    
    ;norm roi file
    norm_roi = big_table[6,row]
    cmd += ' ' + reduce_structure.norm_roi + '=' + norm_roi
    
    ;output_path
    output_file_name = output_path + big_table[7,row]
    cmd += ' ' + reduce_structure.output + '=' + output_file_name
    
    cl_table[row] = cmd
    
  ENDFOR
  
  text = '> About to submit ' + STRCOMPRESS(nbr_jobs,/REMOVE_ALL) + ' jobs:'
  IDLsendLogBook_addLogBookText, Event, text
  
  index = 0
  WHILE (cl_table[index] NE '') DO BEGIN
    text = '-> Job # ' + STRCOMPRESS(index,/REMOVE_ALL) + ':'
    IDLsendLogBook_addLogBookText, Event, text
    text = '--> ' + cl_table[index]
    IDLsendLogBook_addLogBookText, Event, text
    SPAWN, cl_table[index]
    index++
  ENDWHILE
  
  message = ['Your ' + STRCOMPRESS(nbr_jobs,/REMOVE_ALL) + ' jobs have ' + $
    'submited','','Click CHECK JOB MANAGER to check the status of your jobs!']
  title = 'Jobs Submission Message'
  id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
  result = DIALOG_MESSAGE(message,$
    /INFORMATION,$
    TITLE = title,$
    DIALOG_PARENT = id)
    
END

;------------------------------------------------------------------------------
;this procdure will pop up a box that will ask for the spin state to plot
PRO reduce_step3_plot_jobs, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  
END