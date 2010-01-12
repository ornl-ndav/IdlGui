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
    
    ;delete button (right click)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_right_click_delete'): BEGIN
      remove_selected_tab1_fits_files, Event
      ;check widgets of tab2
      check_create_pvsc_button_status, Event
      check_tab2_plot_button_status, Event
      (*global).need_to_recalculate_rebinned_step2 = 1b
    END
    
    ;plot button Y vs X (right click)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_right_click_plot_y_vs_x'): BEGIN
      title = 'Y vs X'
      tab1_selection = (*global).tab1_selection
      index = tab1_selection[0]
      x_array = (*(*global).pXArray)
      y_array = (*(*global).pYArray)
      xarray  = *x_array[index]
      yarray  = *y_array[index]
      fits_tools_tab1_plot_base, Event=Event, $
        title=title, $
        xtitle='X',$
        ytitle='Y',$
        xarray=xarray, $
        yarray=yarray
    END
    
    ;plot button P vs C (right click)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab1_right_click_plot_p_vs_c'): BEGIN
      title = 'P vs C'
      tab1_selection = (*global).tab1_selection
      index = tab1_selection[0]
      p_array    = (*(*global).pPArray)
      time_array = (*(*global).pTimeArray)
      xarray = *time_array[index]
      yarray = *p_array[index]
      fits_tools_tab1_plot_base, Event=Event, $
        title=title, $
        xtitle='Time (microS)',$
        ytitle='P',$
        xarray=xarray, $
        yarray=yarray
    END
    
    ;TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2, TAB2
    
    ;bin size input text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_bin_size_value'): BEGIN
      (*global).need_to_recalculate_rebinned_step2 = 1b
      check_create_pvsc_button_status, Event
      check_tab2_plot_button_status, Event
    END
    
    ;plot button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_bin_size_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      IF ((*global).need_to_recalculate_rebinned_step2) THEN BEGIN
        create_p_vs_c_combined_rebinned, Event
        (*global).need_to_recalculate_rebinned_step2 = 0b
      ENDIF
      title = 'P vs C'
      fits_tools_tab1_plot_base, Event=Event, $
        title=title, $
        xtitle='Bins #',$
        ytitle='P',$
        xarray=(*(*global).p_rebinned_x_array), $
        yarray=(*(*global).p_rebinned_y_array)
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;where
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_where_button'): BEGIN
      define_path_of_tab2, Event
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
    
    ELSE:
    
  ENDCASE
  
END
