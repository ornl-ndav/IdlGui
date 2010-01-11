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

PRO fits_tools_tab1_plot_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  global = (*global_plot).global
  main_event = (*global_plot).main_event
  
  CASE Event.id OF
  
    ;plot base
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='fits_tools_tab1_plot_base_uname'): BEGIN
      
      id1 = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab1_plot_base_uname')
      WIDGET_CONTROL, id1, /REALIZE
      geometry = WIDGET_INFO(id1, /GEOMETRY)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      WIDGET_CONTROL, id1, XSIZE= new_xsize
      WIDGET_CONTROL, id1, YSIZE= new_ysize
      
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab1_plot_draw_uname')
      WIDGET_CONTROL, id, DRAW_XSIZE= new_xsize-6
      WIDGET_CONTROL, id, DRAW_YSIZE= new_ysize-6
      
      replot, Event
      
    END
    
    ;plot
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='fits_tools_tab1_plot_draw_uname'): BEGIN
      
      IF (Event.release EQ 1b) THEN BEGIN ;release button
        (*global_plot).button_pressed = 0b
        x0y0x1y1 = (*global_plot).x0y0x1y1
        x0 = x0y0x1y1[0]
        x1 = x0y0x1y1[1]
        y0 = x0y0x1y1[2]
        y1 = x0y0x1y1[3]
        IF (x0 EQ x1) THEN BEGIN
        replot, Event
        RETURN
        ENDIF
        IF (y0 EQ y1) THEN BEGIN
        replot, Event
        RETURN
        ENDIF
        IF ((*global_plot).moving_mouse EQ 0b) THEN BEGIN
        replot, Event
        RETURN
        ENDIF
        replot, Event, ZOOM=1b
        (*global_plot).moving_mouse = 0b
      ENDIF
      
      IF (Event.press EQ 0) THEN BEGIN
        IF ((*global_plot).button_pressed EQ 1b) THEN BEGIN ;moving mouse
          (*global_plot).moving_mouse = 1b
          CURSOR, X, Y, /DATA, /NOWAIT
          x0y0x1y1 = (*global_plot).x0y0x1y1
          x0y0x1y1[2] = X
          x0y0x1y1[3] = Y
          (*global_plot).x0y0x1y1 = x0y0x1y1
        ENDIF
      ENDIF
      
      IF (Event.press EQ 1) THEN BEGIN ;left button pressed
        (*global_plot).button_pressed = 1b
        CURSOR, X, Y, /DATA
        (*global_plot).x0y0x1y1 = [X, Y, 0, 0]
      ENDIF
      
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO replot, Event, ZOOM=zoom

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  
  xarray = (*(*global_plot).xarray)
  yarray = (*(*global_plot).yarray)
  
  id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='fits_tools_tab1_plot_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  IF (N_ELEMENTS(ZOOM) NE 0) THEN BEGIN
  
    x0y0x1y1 = (*global_plot).x0y0x1y1
    x0 = x0y0x1y1[0]
    y0 = x0y0x1y1[1]
    x1 = x0y0x1y1[2]
    y1 = x0y0x1y1[3]
    xmin = MIN([x0,x1],MAX=xmax)
    ymin = MIN([y0,y1],MAX=ymax)
    
    PLOT, xarray, $
      yarray, $
      XRANGE = [xmin, xmax], $
      YRANGE = [ymin, ymax], $
      psym=1, $
      XSTYLE=1, $
      YSTYLE=1
      
  ENDIF ELSE BEGIN
  
    PLOT, xarray, $
      yarray, $
      psym=1, $
      XSTYLE=1, $
      YSTYLE=1
      
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO  fits_tools_tab1_plot_base_gui, wBase=wBase, $
    main_base_geometry=main_base_geometry, $
    title=title
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = title,$
    UNAME        = 'fits_tools_tab1_plot_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = 300,$
    SCR_XSIZE    = 300,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /TLB_MOVE_EVENTS, $
    /TLB_SIZE_EVENTS, $
    GROUP_LEADER = ourGroup)
    
  main_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  draw = WIDGET_DRAW(main_base,$
    SCR_XSIZE = 300-6,$
    SCR_YSIZE = 300-6,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    UNAME = 'fits_tools_tab1_plot_draw_uname')
    
END

;------------------------------------------------------------------------------
PRO fits_tools_tab1_plot_base, main_base=main_base, $
    Event=Event, $
    title=title, $
    xarray=xarray, $
    yarray=yarray
    
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
  fits_tools_tab1_plot_base_gui, wBase=wBase1, $
    main_base_geometry=main_base_geometry, $
    title=title
    
  (*global).tab1_base = wBase1
  
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_plot = PTR_NEW({ wbase: wbase1,$
    global: global, $
    
    button_pressed: 0b, $ ;status of button on main plot
    moving_mouse: 0b,$
    x0y0x1y1: LONARR(4), $
    
    xarray: PTR_NEW(0L), $
    yarray: PTR_NEW(0L), $
    main_event: Event})
    
  (*(*global_plot).xarray) = xarray
  (*(*global_plot).yarray) = yarray
  
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_plot
  
  XMANAGER, "fits_tools_tab1_plot_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  WIDGET_CONTROL, /HOURGLASS
  PLOT, xarray, yarray, psym=1, XSTYLE=1, YSTYLE=1
  WIDGET_CONTROL, HOURGLASS=0
  
END

