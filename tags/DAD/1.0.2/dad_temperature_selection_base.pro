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

PRO es_temperature_selection_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;retrieve main global
  main_global = (*global).global
  
  CASE Event.id OF
  
    ;CANCEL button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='es_temperature_base_cancel'): BEGIN
      (*main_global).continue_to_run_divisions = 0
      id = WIDGET_INFO(Event.top, FIND_BY_UNAME='es_temperature_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ;OK button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='es_temperature_base_ok'): BEGIN
      index = getDroplistSelect(Event, 'es_temperature_droplist')
      (*main_global).es_temp_index = index
      (*main_global).continue_to_run_divisions = 1
      id = WIDGET_INFO(Event.top, FIND_BY_UNAME='es_temperature_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO es_temperature_selection_base_gui, main_base_id, wBase, $
    main_base_geometry, $
    TRange
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 500 ;width of various steps of manual mode
  ysize = 140 ;height of various steps of manual mode
  
  xoffset = main_base_xoffset + main_base_xsize/2-xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ;ourGroup = WIDGET_BASE()
  ourGroup = main_base_id
  
  title = 'Elastic Scan ASCII file contains more than 1 set of data'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'es_temperature_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    /MODAL, $
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /BASE_ALIGN_CENTER,$
    /COLUMN, $
    /ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  space = WIDGET_LABEL(wBase, $
    VALUE = ' ')
    
  row1 = WIDGET_BASE(wBase,$
    /ROW)
  label = WIDGET_LABEL(row1, $
    VALUE = ' PLEASE SELECT TEMPERATURE TO USE! ---> ')
  droplist = WIDGET_DROPLIST(row1,$
    /DYNAMIC_RESIZE, $
    UNAME = 'es_temperature_droplist', $
    VALUE = TRange)
  units = WIDGET_LABEL(row1,$
    VALUE = '  Kelvin')
    
  space = WIDGET_LABEL(wBase,$
    VALUE = ' ')
    
  row2 = WIDGET_BASE(wBase,$
    /ROW)
  cancel = WIDGET_BUTTON(row2,$
    VALUE = ' CANCEL ',$
    SCR_XSIZE = 150,$
    UNAME = 'es_temperature_base_cancel')
  space = WIDGET_LABEL(row2,$
    VALUE = '                ')
  ok = WIDGET_BUTTON(row2,$
    VALUE = ' OK ',$
    SCR_XSIZE = 150,$
    UNAME = 'es_temperature_base_ok')
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO es_temperature_selection_base, Event, TRange

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  es_temperature_selection_base_gui, id, wBase, main_base_geometry, TRange
  
  local_global = PTR_NEW({ wbase: wbase, $
    global: global, $
    TRange: PTR_NEW(0L), $
    main_event: Event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = local_global
  XMANAGER, "es_temperature_selection_base", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK, $
    CLEANUP='es_temperature_selection_base_cleanup'
    
END

;------------------------------------------------------------------------------
PRO es_temperature_selection_base_cleanup, tlb

  WIDGET_CONTROL, tlb, GET_UVALUE=global, /NO_COPY
  IF N_ELEMENTS(global) EQ 0 THEN RETURN
  
  ; Free up the pointers
  PTR_FREE, (*global).TRange
  PTR_FREE, global
  
END
