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
  instrument = (*global).instrument
; Code change (RC Ward, Mar 2, 2010): pass TOF Cutoff min and max through global variable
; Code change (RC Ward, Mar 17, 2010): apply TOF cutoffs only if switch is yes
  apply_tof_cutoffs = (*global).apply_tof_cutoffs
  tof_cutoff_min = (*global).tof_cutoff_min
  tof_cutoff_max = (*global).tof_cutoff_max  
; DEBUG ========================================
;  print, "Apply Cutoffs: ", apply_tof_cutoffs
;  if (apply_tof_cutoffs EQ "yes") THEN BEGIN
;    print, "TOF Cutoff Min: ", tof_cutoff_min
;    print, "TOF Cutoff Max: ", tof_cutoff_max
;  ENDIF  
; DEBUG ========================================  
  ;get big table of step3
  big_table = getTableValue(Event, 'reduce_tab3_main_spin_state_table_uname')
  nbr_row = (SIZE(big_table))(2)
  cl_table = STRARR(nbr_row)
  
  CASE ((*global).am) OF
    'slurm': BEGIN
      SPAWN, 'hostname', listening
      CASE (listening[0]) OF
        'lrac' : cmd_srun = 'sbatch -p lracq '
        'mrac' : cmd_srun = 'sbatch -p mracq '
        ELSE: BEGIN
          cmd_srun = 'sbatch -p heaterq '
        END
      ENDCASE
    END
    'oic': BEGIN
      cmd_srun = 'amrun_dev -p oic --batch '
    END
    ELSE:
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
    
    cmd += ' --inst=' + instrument + ' '
    
    ;data full nexus name
    data = big_table[1,row]
    cmd += ' ' + data
    
    ;data path
    IF (instrument EQ 'REF_M') THEN BEGIN
      data_path = '/entry-' + big_table[3,row] + '/bank1,1'
    ENDIF ELSE BEGIN
      data_path = '/entry/bank1,1'
    ENDELSE
    cmd += ' ' + reduce_structure.data_paths + '=' + data_path
    
    ;sangle value (in radians)
    IF (instrument EQ 'REF_M') THEN BEGIN
      sangle_rad_deg = big_table[2,row]
      sangle_rad_deg_array = STRSPLIT(sangle_rad_deg,'(',/EXTRACT)
      sangle_rad = sangle_rad_deg_array[0]
      cmd += ' ' + reduce_structure.sangle + '=' + sangle_rad + $
        ',0.0,units=radians'
    ENDIF
    
    ;norm full nexus name
    IF (instrument EQ 'REF_M') THEN BEGIN
      col_index = 5
    ENDIF ELSE BEGIN
      col_index = 3
    ENDELSE
    norm = big_table[col_index,row]
    cmd += ' ' + reduce_structure.norm + '=' + norm
    
    ;norm path
    IF (instrument EQ 'REF_M') THEN BEGIN
      norm_path = '/entry-' + big_table[6,row] + '/bank1,1'
    ENDIF ELSE BEGIN
      norm_path = '/entry/bank1,1'
    ENDELSE
    cmd += ' ' + reduce_structure.norm_paths + '=' + norm_path
    
    ;norm roi file
    IF (instrument EQ 'REF_M') THEN BEGIN
      col_index = 7
    ENDIF ELSE BEGIN
      col_index = 4
    ENDELSE
    norm_roi = big_table[col_index,row]
    cmd += ' ' + reduce_structure.norm_roi + '=' + norm_roi

    ;tof_cutoff_min file
    IF (apply_tof_cutoffs EQ 'yes') THEN BEGIN
; apply TOF cutoffs only if apply_tof_cutoffs is yes (RC Ward, Mar 17, 2010)
     cmd += ' ' + reduce_structure.tof_cut_min + '=' + tof_cutoff_min
     cmd += ' ' + reduce_structure.tof_cut_max + '=' + tof_cutoff_max
    ENDIF
    print, 'cmd: ', cmd

    
    ;output_path
    IF (instrument EQ 'REF_M') THEN BEGIN
      col_index = 8
    ENDIF ELSE BEGIN
      col_index = 5
    ENDELSE

    output_file_name = output_path + big_table[col_index,row]
; Change code (RC Ward, 6 Aug 2010): create rmd file name
    file_parts = STRSPLIT(output_file_name,'.',/EXTRACT)
    file = file_parts[0]
;    print, "test: ", file
    rmd_file_name = file + '.rmd'
;    print, "test: ", rmd_file_name
;
;======================================    
; Change Code (RC Ward, 13 July, 2010): Delete the output file (ASCII file) before running batch job.
; This forces the code to wait until new files are written before putting up the message that user can proceed
    remove_output_file = 'rm ' + output_file_name
    print, "remove old output file ", remove_output_file
    SPAWN, remove_output_file
    remove_rmd_file = 'rm ' + rmd_file_name
    print, "remove old rmd file ", remove_rmd_file
    SPAWN, remove_rmd_file
    print, " "
;    list_output_file_name = 'ls -al ' + output_file_name
;    SPAWN, list_output_file_name
;======================================
    cmd += ' ' + reduce_structure.output + '=' + output_file_name
    
    cl_table[row] = cmd
    
  ENDFOR
  
  text = '> About to submit ' + STRCOMPRESS(nbr_jobs,/REMOVE_ALL) + ' jobs:'
  IDLsendLogBook_addLogBookText, Event, text
  
  CD, output_path, CURRENT = current
  
  index = 0
  WHILE (cl_table[index] NE '') DO BEGIN
    text = '-> Job # ' + STRCOMPRESS(index,/REMOVE_ALL) + ':'
    IDLsendLogBook_addLogBookText, Event, text
    text = '--> ' + cl_table[index]
    IDLsendLogBook_addLogBookText, Event, text
    SPAWN, cl_table[index]
    index++
  ENDWHILE
  
  CD, current
  
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
  
  ;display the base that ask for the working spin state
  IF ((*global).instrument EQ 'REF_M') THEN BEGIN
    working_spin_state, Event
  ENDIF ELSE BEGIN
    checking_spin_state, Event
  ENDELSE
  
END