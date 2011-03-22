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
  
  run_job_status = 1 ;ok to activate run jobs button by default
  instrument = (*global).instrument
  
  IF (instrument EQ 'REF_M') THEN BEGIN
    ysize = 11
  ENDIF ELSE BEGIN
    ysize = 6
  ENDELSE
  step3_big_table = STRARR(40,ysize)
  
  tab1_table = (*(*global).reduce_tab1_table)
  ;retrieve list of Data Runs
  data_run_number = tab1_table[0,*] ;array[1,18]
  short_data_run_number = RemoveEmptyElement(data_run_number[0,*])
  nbr_data = N_ELEMENTS(short_data_run_number)
  
  IF (short_data_run_number[0] EQ '') THEN BEGIN
    run_job_status = 0
    update_reduce_step3_jobs_button, Event, run_job_status
    RETURN ;stop right away if no data
  ENDIF
  
  ;retrieve data full file name
  data_nexus_file_name = tab1_table[1,*] ;array[1,18]
  short_data_nexus_file_name = RemoveEmptyElement(data_nexus_file_name[0,*])
  
  IF (instrument EQ 'REF_M') THEN BEGIN
    ;ex: [1,1,0,0] -> Off_Off and Off_On only
    data_spin_states = getListOfDataSpinStates(Event)
    ;list_data_spin = ['Off_Off','Off_On',...]
    list_data_spin = (*global).list_of_data_spin
  ENDIF
  
  short_norm_file_list = (*(*global).reduce_tab2_nexus_file_list)
  norm_run_number = (*global).nexus_norm_list_run_number
  short_norm_run_number = RemoveEmptyElement(norm_run_number[0,*])
  
  IF (instrument EQ 'REF_M') THEN BEGIN ;REF_M
  
    run_sangle_table = (*(*global).reduce_run_sangle_table)
    
    table_index = 0
    ;loop over all the working pola state to populate big table
    FOR pola_index=0,3 DO BEGIN
    
      ;we want this data spin state
      IF (data_spin_states[pola_index] EQ 1) THEN BEGIN
      
        data_index = 0
        WHILE (data_index LT nbr_data) DO BEGIN
        
          data_run     = short_data_run_number[data_index]
          sangle       = STRCOMPRESS(run_sangle_table[1,data_index],/REMOVE_ALL)
          data_nexus   = short_data_nexus_file_name[data_index]
          d_spin_state = list_data_spin[pola_index]
          
          IF ((SIZE(short_norm_file_list))(0) EQ 0) THEN BEGIN
            norm_run     = 'N/A'
            norm_nexus   = 'N/A'
            n_spin_state = 'N/A'
            roi_file     = 'N/A'
            back_file    = 'N/A'
            run_job_status = 0
          ENDIF ELSE BEGIN
            norm_run     = getReduceStep2NormOfRow(Event, row=data_index)
            norm_nexus   = getNormNexusOfIndex(Event, $
              data_index,$
              short_norm_file_list)
            n_spin_state = getReduceStep2SpinStateRow(Event, $
              Row = data_index,$
              data_spin_state = d_spin_state)
              
            roi_file     = getNormRoiFileOfIndex(Event, row=data_index,$
              base_name=d_spin_state)
            IF (STRCOMPRESS(roi_file,/REMOVE_ALL) EQ '') THEN BEGIN
              roi_file = 'N/A'
              run_job_status = 0
            ENDIF
            
            IF (roi_file EQ 'N/A') THEN BEGIN
              run_job_status = 0
            ENDIF
            
            back_roi_file     = getNormBackRoiFileOfIndex(Event, $
              row=data_index,$
              base_name=d_spin_state)
            IF (STRCOMPRESS(back_roi_file,/REMOVE_ALL) EQ '') THEN BEGIN
              back_roi_file = 'N/A'
              run_job_status = 0
            ENDIF
            
          ;            IF (roi_file EQ 'N/A') THEN BEGIN
          ;              run_job_status = 0
          ;           ENDIF
            
          ENDELSE
          
          ;populate Recap. Big table
          step3_big_table[table_index,0] = data_run
          step3_big_table[table_index,1] = data_nexus
          step3_big_table[table_index,2] = sangle
          step3_big_table[table_index,3] = d_spin_state
          step3_big_table[table_index,4] = norm_run
          step3_big_table[table_index,5] = norm_nexus
          step3_big_table[table_index,6] = n_spin_state
          step3_big_table[table_index,7] = roi_file
          step3_big_table[table_index,8] = back_roi_file
          
          ;define the output file name
          output_file_name = 'REF_M_' + data_run
          output_file_name += '_' + d_spin_state + '.txt'
          step3_big_table[table_index,10] = output_file_name
          
          data_index++
          table_index++
          
        ENDWHILE
        
      ENDIF
      
    ENDFOR
    
  ENDIF ELSE BEGIN ;REF_L
  
    table_index = 0
    WHILE (table_index LT nbr_data) DO BEGIN
    
      data_run     = short_data_run_number[table_index]
      data_nexus   = short_data_nexus_file_name[table_index]
      
      IF ((SIZE(short_norm_file_list))(0) EQ 0) THEN BEGIN
        norm_run     = 'N/A'
        norm_nexus   = 'N/A'
        roi_file     = 'N/A'
        run_job_status = 0
      ENDIF ELSE BEGIN
        norm_run     = getReduceStep2NormOfRow(Event, row=table_index)
        norm_nexus   = getNormNexusOfIndex(Event, $
          table_index,$
          short_norm_file_list)
        roi_file     = getNormRoiFileOfIndex(Event, row=table_index)
        
        IF (STRCOMPRESS(roi_file,/REMOVE_ALL) EQ '') THEN BEGIN
          roi_file = 'N/A'
          run_job_status = 0
        ENDIF
        
        IF (roi_file EQ 'N/A') THEN BEGIN
          run_job_status = 0
        ENDIF
        
      ENDELSE
      
      ;populate Recap. Big table
      step3_big_table[table_index,0] = data_run
      step3_big_table[table_index,1] = data_nexus
      step3_big_table[table_index,2] = norm_run
      step3_big_table[table_index,3] = norm_nexus
      step3_big_table[table_index,4] = roi_file
      
      ;define the output file name
      output_file_name = 'REF_L_' + data_run
      output_file_name += '.txt'
      step3_big_table[table_index,5] = output_file_name
      
      table_index++
      
    ENDWHILE
    
  ENDELSE
  
  ;update big table
  putValueInTable, Event,$
    'reduce_tab3_main_spin_state_table_uname',$
    TRANSPOSE(step3_big_table)
    
  update_reduce_step3_jobs_button, Event, run_job_status
  
END

;------------------------------------------------------------------------------
PRO reduces_step3_output_folder, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  
  path = (*global).ascii_path
  title = 'Select the output folder'
  
  folder = DIALOG_PICKFILE(/DIRECTORY,$
    DIALOG_PARENT=id,$
    /MUST_EXIST,$
    TITLE = title,$
    PATH = path)
    
  IF (folder NE '') THEN BEGIN
    (*global).ascii_path = folder
    putButtonValue, Event, 'reduce_tab3_output_folder_button', folder
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO reduce_step3_job_manager, Event

  ; Code change RCW (Dec 28, 2009): Typo corrected (mamager replaced by manager in routine name)
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  WIDGET_CONTROL,/HOURGLASS
  ; Code change RCW (Dec 28, 2009): firefox replaced by browser obtained from XML config file
  ;firefox       = (*global).firefox
  browser = (*global).browser
  srun_web_page = (*global).srun_web_page
  ;SPAWN, firefox + ' ' + srun_web_page + ' &'
  cmd = browser + ' ' + srun_web_page + ' &'
  SPAWN, cmd
  message = '> Reduce - Step3: Spawn ' + cmd
  IDLsendToGeek_addLogBookText, Event, $
    message
  WIDGET_CONTROL,HOURGLASS=0
  
END

;------------------------------------------------------------------------------
PRO update_reduce_step3_jobs_button, Event, run_job_status
  activate_widget, Event, 'reduce_tab3_run_jobs', run_job_status
  activate_widget, Event, 'reduce_tab3_run_jobs_and_plot', run_job_status
END

;------------------------------------------------------------------------------
PRO check_status_of_reduce_step3_run_jobs_button, Event

  run_job_status = 1
  
  ;get big table
  Table = getTableValue(Event, 'reduce_tab3_main_spin_state_table_uname')
  
  IF (Table[0,0] NE '') THEN BEGIN
  
    nbr_lines = (SIZE(Table))(2)
    index = 0
    WHILE (index LT nbr_lines) DO BEGIN
    
      ;check line only if there is something to check
      norm_run = Table[2,index]
      IF (norm_run NE '') THEN BEGIN
      
        ;normalization run number
        IF (norm_run EQ 'N/A' OR $
          STRCOMPRESS(norm_run,/REMOVE_ALL) EQ '') THEN BEGIN
          run_job_status = 0
          BREAK
        ENDIF
        
        ;normalization nexus file
        IF (Table[3,index] EQ 'N/A' OR $
          STRCOMPRESS(Table[4,index],/REMOVE_ALL) EQ '') THEN BEGIN
          run_job_status = 0
          BREAK
        ENDIF
        
        ;ROI
        IF (Table[4,index] EQ 'N/A' OR $
          STRCOMPRESS(Table[4,index],/REMOVE_ALL) EQ '') THEN BEGIN
          run_job_status = 0
          BREAK
        ENDIF
        
      ENDIF
      
      index++
    ENDWHILE
    
  ENDIF ELSE BEGIN
    run_job_status = 0
  ENDELSE
  
  update_reduce_step3_jobs_button, Event, run_job_status
  
END