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

PRO checking_spin_base_event, event

  COMPILE_OPT hidden
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_spin
  
  wWidget =  Event.top            ;widget id
  main_event = global_spin.event
  
  CASE Event.id OF
  
    ;check job manager
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab3_check_jobs'): BEGIN
      reduce_step3_job_mamager, main_event
      ;show base that inform the user that the job manager is going to show up
      job_base = job_manager_info_base(main_event)
      WAIT, 4
      WIDGET_CONTROL, job_base,/DESTROY
    END
    
    ;cancel button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME = 'reduce_step3_working_spin_state_cancel_button'): BEGIN
      WIDGET_CONTROL, global_spin.ourGroup,/DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO checking_spin_state, Event, working_spin_state = working_spin_state

  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;our_group = widget_base(
  checking_spin_base = WIDGET_BASE(GROUP_LEADER=id,$
    /MODAL,$
    /COLUMN,$
    /BASE_ALIGN_CENTER,$
    SCR_XSIZE = 540,$
    SCR_YSIZE = 400,$
    frame = 5,$
    title = 'Files of working spin state ' + working_spin_state)
    
  ;big table
  table_uname = WIDGET_TABLE(checking_spin_base,$
    scr_xsize = 535,$
    xsize = 2,$
    ysize = 11,$
    /resizeable_columns,$
    scr_ysize = 262,$
    column_labels = ['File Name','Status'],$
    column_widths = [450,80],$
    /no_row_headers,$
    uname = 'reduce_step3_working_spin_state_files')
    
  ;2rd row with checking job manager
  check = WIDGET_BUTTON(checking_spin_base,$
    VALUE = 'CHECK JOB MANAGER',$
    SCR_XSIZE = 535,$
    uname = 'reduce_tab3_check_jobs')
    
  ;3rd row with Refresh and ok buttons
  row3 = WIDGET_BASE(checking_spin_base,$
    /ROW)
    
  refresh = WIDGET_BUTTON(row3,$
    VALUE = 'R  E  F  R  E  S  H      S  T  A  T  U  S',$
    SCR_YSIZE = 35,$
    SCR_XSIZE = 400,$
    uname = 'reduce_step3_working_spin_state_refresh')
    
  ok = WIDGET_BUTTON(row3,$
    VALUE = 'Load Files in 2/',$
    UNAME = 'reduce_step3_working_spin_state_go_shift_scale',$
    SCR_XSIZE = 130,$
    SCR_YSIZE = 35,$
    SENSITIVE = 0)
    
  ;space
  space = WIDGET_LABEL(checking_spin_base,$
    VALUE = ' ')
    
  ;4th row (cancel button)
  row4 = WIDGET_BASE(checking_spin_base,$,$
    /ALIGN_LEFT,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row4,$
    VALUE = 'CANCEL',$
    SCR_XSIZE = 100,$
    UNAME = 'reduce_step3_working_spin_state_cancel_button')
    
  WIDGET_CONTROL, checking_spin_base, /realize
  
  global_spin = { global: global,$
    event: event,$
    ourGroup: checking_spin_base }
    
  ;this will populate the table
  populate_checking_spin_state_table, Event, $
    table_uname, $
    working_spin_state = working_spin_state
    
  WIDGET_CONTROL, checking_spin_base, SET_UVALUE=global_spin
  XMANAGER, "checking_spin_base", checking_spin_base, GROUP_LEADER = id
  
END

;==============================================================================
PRO populate_checking_spin_state_table, Event, table_uname, $
    working_spin_state = working_spin_state
    
    print, 'working_spin_state: ' + working_spin_state ;remove_me
    
  table = getTableValue(Event, 'reduce_tab3_main_spin_state_table_uname')
  d_spin_state = table[2,*]
  list_of_output_files = table[7,*]
  
  sz = N_ELEMENTS(d_spin_state)
  new_table = STRARR(2,sz)
  index = 0
  FOR i=0,(sz-1) DO BEGIN
    spin_state = d_spin_state[i]
    print, spin_state ;remove_me
    IF (spin_state NE '') THEN BEGIN
      IF (STRLOWCASE(spin_state) EQ working_spin_state) THEN BEGIN
      print, 'here'
        new_table[0,index] = list_of_output_files[i]
        new_table[1,index++] = 'NOT READY'
      ENDIF
    ENDIF ELSE BEGIN
      BREAK
    ENDELSE
  ENDFOR
  
  print, new_table
  
  WIDGET_CONTROL, table_uname, SET_VALUE=new_table
  
END