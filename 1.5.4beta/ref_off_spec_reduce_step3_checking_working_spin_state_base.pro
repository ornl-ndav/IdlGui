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

FUNCTIOn getStep3ListOfFiles, table

  list_of_files = table[0,*]
  sz = N_ELEMENTS(list_of_files)
  a = WHERE(list_of_files NE '', nbr)
  final_list_of_files = STRARR(nbr)
  
  index = 0
  WHILE (index LT nbr) DO BEGIN
    file_name = list_of_files[index]
    final_list_of_files[index] = file_name
    index++
  ENDWHILE
  
  RETURN, final_list_of_files
END

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
      ; Code change RCW (Dec 28, 2009): Typo corrected (mamager replaced by manager in called routine name)
      reduce_step3_job_manager, main_event
      ;show base that inform the user that the job manager is going to show up
      job_base = job_manager_info_base(main_event)
      WAIT, 4
      WIDGET_CONTROL, job_base,/DESTROY
    END
    
    ;refresh table button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step3_working_spin_state_refresh'): BEGIN
      global = global_spin.global
      refresh_checking_spin_table, Event, global
    END
    
    ;move on to next step widget_draw
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step3_working_spin_state_go_shift_scale'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          table = getTableValue(Event,'reduce_step3_working_spin_state_files')
          list_of_files = getStep3ListOfFiles(table)
          global = global_spin.global
          (*(*global).list_of_files_to_load_in_step2) = list_of_files
          WIDGET_CONTROL, global_spin.ourGroup,/DESTROY
          id_tab = WIDGET_INFO(main_event.top, FIND_BY_UNAME='main_tab')
          WIDGET_CONTROL, id_tab, SET_TAB_CURRENT = 1
          load_step2_files_from_reduce_step3, main_event, list_of_files
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          standard = 58
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        draw_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step3_working_spin_state_go_shift_scale')
        WIDGET_CONTROL, draw_id, GET_VALUE=id
        WSET, id
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE
    END
    
    ;Load Files in 2/ button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step3_working_spin_state_go_shift_scale'): BEGIN
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
  instrument = (*global).instrument
  
  IF (instrument EQ 'REF_M') THEN BEGIN
    title = 'Files of working spin state ' + working_spin_state
  ENDIF ELSE BEGIN
    title = 'Files to plot'
  ENDELSE
  ;our_group = widget_base(
  checking_spin_base = WIDGET_BASE(GROUP_LEADER=id,$
    /MODAL,$
    /COLUMN,$
    /BASE_ALIGN_CENTER,$
    SCR_XSIZE = 540,$
    SCR_YSIZE = 400,$
    frame = 5,$
    title = title)
    
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
    
  refresh = WIDGET_BUTTON(checking_spin_base,$
    VALUE = 'R  E  F  R  E  S  H      S  T  A  T  U  S',$
    SCR_YSIZE = 35,$
    SCR_XSIZE = 535,$
    uname = 'reduce_step3_working_spin_state_refresh')
    
  ;4th row (cancel button)
  row4 = WIDGET_BASE(checking_spin_base,$
    /ROW,$
    frame=0)
    
  cancel = WIDGET_BUTTON(row4,$
    VALUE = 'CANCEL',$
    SCR_XSIZE = 100,$
    UNAME = 'reduce_step3_working_spin_state_cancel_button')
    
  ;space
  space = WIDGET_LABEL(row4,$
    VALUE = '  ')
    
  base2 = WIDGET_BASE(row4,$
    MAP = 0,$
    UNAME = 'reduce_step2_working_spin_state_go_shift_base')
    
  ;3rd row
  ok = WIDGET_DRAW(base2,$
    UNAME = 'reduce_step3_working_spin_state_go_shift_scale',$
    SCR_XSIZE = 405,$
    SCR_YSIZE = 55,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    SENSITIVE = 1)
    
  WIDGET_CONTROL, checking_spin_base, /realize
  
  global_spin = { global: global,$
    event: event,$
    output_path: (*global).ascii_path,$
    ourGroup: checking_spin_base }
    
  ;this will populate the table
  populate_checking_spin_state_table, Event, $
    table_uname, $
    working_spin_state = working_spin_state
    
  WIDGET_CONTROL, checking_spin_base, SET_UVALUE=global_spin
  XMANAGER, "checking_spin_base", checking_spin_base, GROUP_LEADER = id
  
END

;==============================================================================
PRO populate_checking_spin_state_table, Event, $
    table_uname, $
    working_spin_state = working_spin_state
    
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  instrument = (*global).instrument
  
  table = getTableValue(Event, 'reduce_tab3_main_spin_state_table_uname')
  IF (instrument EQ 'REF_M') THEN BEGIN
    d_spin_state = table[3,*]
    list_of_output_files = table[10,*]
  ENDIF ELSE BEGIN
    list_of_output_files = table[7,*]
  ENDELSE
  
  ;add path
  path = (*global).ascii_path
  list_of_output_files = path + list_of_output_files
  
  IF (instrument EQ 'REF_M') THEN BEGIN
    sz = N_ELEMENTS(d_spin_state)
    new_table = STRARR(2,sz)
    index = 0
    FOR i=0,(sz-1) DO BEGIN
      spin_state = d_spin_state[i]
      IF (spin_state NE '') THEN BEGIN
        IF (STRLOWCASE(spin_state) EQ STRLOWCASE(working_spin_state)) THEN BEGIN
          new_table[0,index] = list_of_output_files[i]
          new_table[1,index++] = 'NOT READY'
        ENDIF
      ENDIF ELSE BEGIN
        BREAK
      ENDELSE
    ENDFOR
  ENDIF ELSE BEGIN
  
    sz = N_ELEMENTS(list_of_output_files)
    new_table = STRARR(2,sz)
    index = 0
    FOR i=0,(sz-1) DO BEGIN
      IF (table[0,index] NE '') THEN BEGIN
        new_table[0,index] = list_of_output_files[i]
        new_table[1,index++] = 'NOT READY'
      ENDIF ELSE BEGIN
        break
      ENDELSE
    ENDFOR
    
  ENDELSE
  
  WIDGET_CONTROL, table_uname, SET_VALUE=new_table
  
END

;------------------------------------------------------------------------------
PRO refresh_checking_spin_table, Event, global

  COMPILE_OPT hidden
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_spin
  
  path = global_spin.output_path
  
  ;get table value
  table = getTableValue(Event,'reduce_step3_working_spin_state_files')
  
  list_of_files = table[0,*]
  sz = N_ELEMENTS(list_of_files)
  button_status = 1
  FOR i=0,(sz-1) DO BEGIN
    file_name = list_of_files[i]
    IF (file_name NE '') THEN BEGIN
      full_file_name = path + file_name
      IF (FILE_TEST(full_file_name)) THEN BEGIN
        table[1,i] = 'READY'
      ENDIF ELSE BEGIN
        table[1,i] = 'NOT READY'
        button_status = 0
      ENDELSE
    ENDIF ELSE BEGIN
      BREAK
    ENDELSE
  ENDFOR
  
  ;repopulate table
  id = WIDGET_INFO(Event.top,$
    FIND_BY_UNAME='reduce_step3_working_spin_state_files')
  WIDGET_CONTROL, id, SET_VALUE=table
  
  IF (button_status) THEN BEGIN
  
    ;map base first
    MapBase, Event, 'reduce_step2_working_spin_state_go_shift_base', 1
    
    ;validate or not go button
    mode_id = WIDGET_INFO(Event.top,$
      FIND_BY_UNAME='reduce_step3_working_spin_state_go_shift_scale')
    mode = READ_PNG((*global).go_shift_scale)
    WIDGET_CONTROL, mode_id, GET_VALUE=id
    WSET, id
    TV, mode, 0,0,/true
    
  ENDIF
  
END