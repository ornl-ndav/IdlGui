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

PRO plot_ascii_load_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_load
  global = (*global_load).global
  main_event = (*global_load).main_event
  
  CASE Event.id OF
  
    ;Browse
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='plot_ascii_load_base_browse_button'): BEGIN
      browse_button, Event
    END
    
    ;ASCII table
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='plot_ascii_load_base_table'): BEGIN
      IF ((*global_load).table_click_status EQ 'click') THEN BEGIN
        id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_load_base_table')
        selection = WIDGET_INFO(id, /TABLE_SELECT)
        column_selected = selection[0]
        (*global_load).column_selected = column_selected
      ENDIF
      select_full_row, Event
      ;trigger status column if click in first column, and first column only
      IF ((*global_load).column_selected EQ 0) THEN BEGIN
        trigger_status_column, Event
        plotAsciiData, event_load=event
      ENDIF
      IF ((*global_load).table_click_status EQ 'click') THEN BEGIN
        (*global_load).table_click_status = 'release'
      ENDIF ELSE BEGIN
        (*global_load).table_click_status = 'click'
      ENDELSE
    END
    
    ;delete button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='plot_ascii_load_base_delete_button'): BEGIN
        ;xyminmax = FLTARR(4)
        ;(*global).xyminmax = xyminmax
      delete_plot_ascii_load_selected_row, Event
      plotAsciiData, event_load=event
    END
    
    ;CLOSE button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='plot_ascii_load_base_close_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME = 'plot_ascii_load_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO plot_ascii_load_base_gui, wBase, main_base_geometry, nbr_ascii_files

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'L O A D    A S C I I',$
    UNAME        = 'plot_ascii_load_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = 485,$
    SCR_XSIZE    = 850,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  main_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  ;row1
  row1 = WIDGET_BASE(main_base,$
    /ROW)
  browse = WIDGET_BUTTON(row1,$
    VALUE = 'BROWSE ...',$
    UNAME = 'plot_ascii_load_base_browse_button')
  space = WIDGET_LABEL(row1,$
    VALUE = '                ')
  help = WIDGET_LABEL(row1,$
    VALUE = 'Single click in STATUS column to enable/disable plot ' + $
    'of ascii file.')
    
  ;table
  alignement = INTARR(2,nbr_ascii_files)
  alignement[0,*] = 1
  table = WIDGET_TABLE(main_base,$
    COLUMN_LABELS = ['Status',$
    'ASCII File Name'],$
    UNAME = 'plot_ascii_load_base_table',$
    /NO_ROW_HEADERS,$
    ;    /RESIZEABLE_COLUMNS,$
    ALIGNMENT = alignement,$
    XSIZE = 2,$
    YSIZE = 50,$
    SCR_XSIZE = 845,$
    SCR_YSIZE = 380,$
    COLUMN_WIDTHS = [50,770],$
    ;/SCROLL,$
    /ALL_EVENTS)
  WIDGET_CONTROL, table, SET_TABLE_SELECT=[0,0,1,0]
  
  ;row2
  row2 = WIDGET_BASE(main_base,$
    /ROW)
  remove = WIDGET_BUTTON(row2,$
    VALUE = 'DELETE SELECTED ROW',$
    UNAME = 'plot_ascii_load_base_delete_button')
    
  ;row3
  row3 = WIDGET_BASE(main_base,$
    /ROW)
  space = WIDGET_LABEL(row3,$
    VALUE = '                                                           ' + $
    '                                    ')
  close_button = WIDGET_BUTTON(row3,$
    VALUE = 'CLOSE',$
    SCR_XSIZE = 150,$
    UNAME = 'plot_ascii_load_base_close_button')
    
END

;------------------------------------------------------------------------------
PRO plot_ascii_load_base, main_base=main_base, Event

  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase1 = ''
  plot_ascii_load_base_gui, wBase1, $
    main_base_geometry, $
    (*global).nbr_ascii_files
  (*global).load_base = wBase1
  
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_load = PTR_NEW({ wbase: wbase1,$
    global: global, $
    column_selected: 0,$
    table_click_status: 'click',$
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_load
  
  XMANAGER, "plot_ascii_load_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
   load_table = (*global).load_table
  putValueInTable_from_base, wBase1, 'plot_ascii_load_base_table', load_table
       
END

