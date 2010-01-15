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

PRO MAIN_BASE_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    ;TAB1, TAB1, TAB1, TAB1, TAB1, TAB1, TAB1, TAB1, TAB1, TAB1, TAB1, TAB1
  
    ;browse button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_browse_fits_file_button'): BEGIN
      browse_fits_files, Event
      (*global).need_to_recalculate_rebinned_step2 = 1b
    END
    
    ;big table
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_fits_table'): BEGIN
      ;if right click
      IF (TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_CONTEXT') THEN BEGIN
        IF (tab1_table_not_empty(Event) EQ 1b AND $
          at_last_one_not_empty_selected_cell(Event) EQ 1b) THEN BEGIN
          id = WIDGET_info(eVENT.TOP, FIND_BY_UNAME='context_base')
          WIDGET_DISPLAYCONTEXTMENU, event.ID, event.X, $
            event.Y, id
        ENDIF
      ENDIF ElSE BEGIN ;left click
        top_sel    = Event.sel_top
        bottom_sel = Event.sel_bottom
        (*global).tab1_selection = [top_sel, bottom_sel]
      ENDELSE
    END
    
    ;plot button Y vs X (right click)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_right_click_plot_y_vs_x'): BEGIN
      title = 'Y vs X   ('
      list_fits_file = (*(*global).list_fits_file)
      tab1_selection = (*global).tab1_selection
      index = tab1_selection[0]
      file_name = list_fits_file[index]
      short_file_name = FILE_BASENAME(file_name)
      title += short_file_name[0] + ')'
      x_array = (*(*global).pXArray)
      y_array = (*(*global).pYArray)
      xarray  = *x_array[index]
      yarray  = *y_array[index]
     ; t0 = systime(/SECONDS)
      fits_tools_tab1_plot_base, Event=Event, $
        title=title, $
        xtitle='X',$
        ytitle='Y',$
        xarray=xarray, $
        yarray=yarray
      ;t1 = SYSTIME(/SECONDS)
      ;print, 't1-t0: ' + string(t1-t0)
    END
    
    ;plot button P vs C (right click)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_right_click_plot_p_vs_c'): BEGIN
      title = 'P vs time   ('
      list_fits_file = (*(*global).list_fits_file)
      tab1_selection = (*global).tab1_selection
      index = tab1_selection[0]
      file_name = list_fits_file[index]
      short_file_name = FILE_BASENAME(file_name)
      title += short_file_name[0] + ')'
      p_array    = (*(*global).pPArray)
      time_array = (*(*global).pTimeArray)
      ;each tick is 25ns wide (*0.001 to be in microS)
      xarray = *time_array[index] * (*global).time_resolution_microS
      yarray = *p_array[index]
      ;t0 = systime(/SECONDS)
      fits_tools_tab1_plot_base, Event=Event, $
        title=title, $
        xtitle='Time (microS)',$
        ytitle='P',$
        xarray=xarray, $
        yarray=yarray
      ;t1 = SYSTIME(/SECONDS)
      ;print, 't1-t0: ' + string(t1-t0)
    END
    
    ;preview [X,Y,P,C] of first 100 data
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_right_click_preview_data'): BEGIN
      tab1_right_click_data_preview, Event
    END
    
    ;delete button (right click)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_right_click_delete'): BEGIN
      remove_selected_tab1_fits_files, Event
      ;check widgets of tab2
      check_create_pvsc_button_status, Event
      check_tab2_plot_button_status, Event
      check_create_fits_button_status, Event
      check_tab3_plot_button_status, Event
      (*global).need_to_recalculate_rebinned_step2 = 1b
    END
    
    ;TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2
    
    ;bin size input text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_bin_size_value'): BEGIN
      (*global).need_to_recalculate_rebinned_step2 = 1b
      check_create_pvsc_button_status, Event, uname='tab2_bin_size_value'
      check_tab2_plot_button_status, Event
    END
    
    ;plot button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_bin_size_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
        message = ['I(t) of combined files failed!',$
          '',$
          'Please verify the max time you defined in step1!']
        result = dialog_message(message,$
          /ERROR,$
          /CENTER, $
          DIALOG_PARENT=id,$
          TITLE = 'Error plotting I vs Time')
      ENDIF ELSE BEGIN
        IF ((*global).need_to_recalculate_rebinned_step2) THEN BEGIN
          create_p_vs_c_combined_rebinned, Event
          (*global).need_to_recalculate_rebinned_step2 = 0b
        ENDIF
        title = 'Counts vs Time'
        fits_tools_tab1_plot_base, Event=Event, $
          title=title, $
          xtitle='Time (microS)',$
          ytitle='Counts',$
          xarray=(*(*global).p_rebinned_x_array), $
          yarray=(*(*global).p_rebinned_y_array)
      ENDELSE
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;where
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_where_button'): BEGIN
      define_path, Event, tab=2
    END
    
    ;file name input text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_file_name'): BEGIN
      check_create_pvsc_button_status, Event
    END
    
    ;Preview button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_preview_ascii_file_button'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      tab2_preview_button, Event
      WIDGET_CONTROL, HOURGLASS=0
      (*global).need_to_recalculate_rebinned_step2 = 0b
    END
    
    ;Create ASCII file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_create_ascii_file_button'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      tab2_create_ascii_button, Event
      WIDGET_CONTROL, HOURGLASS=0
      (*global).need_to_recalculate_rebinned_step2 = 0b
    END
    
    ;TAB3, TAB3, TAB3, TAB3, TAB3, TAB3, TAB3, TAB3, TAB3, TAB3, TAB3, TAB3
    
    ;bin size input text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab3_bin_size_value'): BEGIN
      (*global).need_to_recalculate_rebinned_step2 = 1b
      check_create_fits_button_status, Event, uname='tab3_bin_size_value'
      check_tab3_plot_button_status, Event
    END
    
    ;plot button of tab3
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab3_bin_size_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      title = 'Intensity of Y vs X (Relative Scale)'
      fits_tools_tab3_plot_base, Event=Event, $
        title=title, $
        xtitle='X',$
        ytitle='Y',$
        xarray=(*(*global).pXArray), $
        yarray=(*(*global).pYArray), $
        timearray = (*(*global).pTimeArray)
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;where
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab3_where_button'): BEGIN
      define_path, Event, tab=3
    END
    
    ;file name input text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab3_file_name'): BEGIN
      check_create_fits_button_status, Event
    END
    
    ;from and to time
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab3_from_time_microS'): BEGIN
      check_create_fits_button_status, Event, uname='tab3_from_time_microS'
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab3_to_time_microS'): BEGIN
      check_create_fits_button_status, Event, uname='tab3_to_time_microS'
    END
    
    ;Create FITS files
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab3_create_fits_files_button'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      create_fits_files_tab3, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ELSE:
    
  ENDCASE
  
END
