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
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tools
  global = (*global_tools).global
  main_event = (*global_tools).main_event
  
  CASE Event.id OF
  
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO plot_ascii_load_base_gui, wBase, main_base_geometry

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'T O O L S',$
    UNAME        = 'plot_ascii_load_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = 485,$
    SCR_XSIZE    = 550,$
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
  
  ;table
  table = WIDGET_TABLE(main_base,$
    COLUMN_LABELS = ['Status',$
    'ASCII File Name'],$
    UNAME = 'plot_ascii_load_base_table',$
    /NO_ROW_HEADERS,$
    ;    /RESIZEABLE_COLUMNS,$
    ALIGNMENT = 0,$
    XSIZE = 2,$
    YSIZE = 20,$
    SCR_XSIZE = 545,$
    SCR_YSIZE = 380,$
    COLUMN_WIDTHS = [50,522],$
    ;/SCROLL,$
    /ALL_EVENTS)
  WIDGET_CONTROL, table, SET_TABLE_SELECT=[0,0,1,0]
  
  ;row2
  row2 = WIDGET_BASE(main_base,$
  /ROW)
  remove = WIDGET_BUTTON(row2,$
  VALUE = 'DELETE',$
  UNAME = 'plot_ascii_load_base_delete_button')

  ;row3
  row3 = WIDGET_BASE(main_base,$
  /ROW)
  space = WIDGET_LABEL(row3,$
  VALUE = '                                                             ')
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
    main_base_geometry
  (*global).load_base = wBase1
  
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_tools = PTR_NEW({ wbase: wbase1,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_tools
  
  XMANAGER, "plot_ascii_load_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END

