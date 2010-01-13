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

PRO fits_tools_tab3_plot_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  global = (*global_plot).global
  main_event = (*global_plot).main_event
  
  CASE Event.id OF
  
    ;plot base
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='fits_tools_tab3_plot_base_uname'): BEGIN
      
      id1 = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab3_plot_base_uname')
      WIDGET_CONTROL, id1, /REALIZE
      geometry = WIDGET_INFO(id1, /GEOMETRY)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      IF (new_xsize LT 400) THEN BEGIN
        new_xsize = 400
        new_ysize = 590
      ENDIF
      IF (new_ysize LT 590) THEN BEGIN
        new_xsize = 400
        new_ysize = 590
      ENDIF
      IF (new_xsize GE 400) THEN BEGIN
        new_ysize = new_xsize+190
      ENDIF
      
      WIDGET_CONTROL, id1, XSIZE= new_xsize
      WIDGET_CONTROL, id1, YSIZE= new_ysize
      
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
      WIDGET_CONTROL, id, DRAW_XSIZE= new_xsize-6
      WIDGET_CONTROL, id, DRAW_YSIZE= new_xsize-6
      
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab3_bin_slider')
      WIDGET_CONTROL, id, SCR_XSIZE = new_xsize-20
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab3_time_slider')
      WIDGET_CONTROL, id, SCR_XSIZE = new_xsize-20
      
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO  fits_tools_tab3_plot_base_gui, wBase=wBase, $
    main_base_geometry=main_base_geometry, $
    title=title
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  xBaseSize = 400
  yBaseSize = 590
  
  wBase = WIDGET_BASE(TITLE = title,$
    UNAME        = 'fits_tools_tab3_plot_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = yBaseSize,$
    SCR_XSIZE    = xBaseSize,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /TLB_MOVE_EVENTS, $
    /TLB_SIZE_EVENTS, $
    GROUP_LEADER = ourGroup)
    
  main_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  ;row1
  row1 = WIDGET_BASE(main_base,$
    /ALIGN_CENTER,$
    /ROW)
  x = WIDGET_LABEL(row1,$
    VALUE = 'X:')
  x_value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    SCR_XSIZE = 50,$
    /ALIGN_LEFT,$
    UNAME = 'fits_tools_tab3_plot_x_value')
  space = WIDGET_LABEL(row1,$
    VALUE = '    ')
  y = WIDGET_LABEL(row1,$
    VALUE = 'Y:')
  y_value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    SCR_XSIZE = 50,$
    UNAME = 'fits_tools_tab3_plot_y_value')
  space = WIDGET_LABEL(row1,$
    VALUE = '    ')
  i = WIDGET_LABEL(row1,$
    VALUE = 'Count:')
  i_value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    SCR_XSIZE = 50,$
    UNAME = 'fits_tools_tab3_plot_counts_value')
    
  draw = WIDGET_DRAW(main_base,$
    /ALIGN_CENTER,$
    SCR_XSIZE = xBaseSize-6,$
    SCR_YSIZE = xBaseSize-6,$
    ;    /BUTTON_EVENTS,$
    ;    /MOTION_EVENTS,$
    UNAME = 'fits_tools_tab3_plot_draw_uname')
    
  ;row3
  row3 = WIDGET_BASE(main_base,$
    /COLUMN)
    
  bin = WIDGET_SLIDER(row3,$
    TITLE = 'Bin #',$
    MINIMUM = 0,$
    MAXIMUM = 100,$
    SCR_XSIZE = 380,$
    UNAME = 'fits_tools_tab3_bin_slider')
    
  time = WIDGET_SLIDER(row3,$
    TITLE = 'Time ',$
    MINIMUM = 0,$
    MAXIMUM = 100,$
    SCR_XSIZE = 380,$
    UNAME = 'fits_tools_tab3_time_slider')
    
  ;row4
  row4 = WIDGET_BASE(main_base,$
    /ROW)
  label = WIDGET_LABEL(row4,$
    VALUE = 'Preview of file -> ')
  value = WIDGET_LABEL(row4,$
    VALUE = 'N/A',$
    SCR_XSIZE = 240,$
    frame=1,$
    /ALIGN_LEFT,$
    UNAME = 'fits_tools_tab3_current_fits_file')
    
END

;------------------------------------------------------------------------------
PRO plot_first_bin_for_tab3, base=base, global_plot=global_plot

  global = (*global_plot).global
  main_event = (*global_plot).main_event
  
  bin_size = getTextFieldValue(main_event, 'tab3_bin_size_value')
  bin_size = bin_size[0]
  
  xarray = (*(*global_plot).xarray)
  yarray = (*(*global_plot).yarray)
  timearray = (*(*global_plot).timearray)
  
  xsize = FIX(getTextFieldValue(main_event,'tab1_x_pixels'))
  ysize = FIX(getTextFieldValue(main_event,'tab1_y_pixels'))
  
  current_bin_array = LONARR(xsize,ysize)
  
  first_timearray = *timearray[0]
  first_xarray = *xarray[0]
  first_yarray = *yarray[0] 
  
  where_timearray = WHERE(first_timearray LT bin_size)
  xarray_bin0 = first_xarray[where_timearray]
  yarray_bin0 = first_yarray[where_timearray]
  
  sz = N_ELEMENTS(xarray_bin0)
  index = 0L
  WHILE (index LT sz) DO BEGIN
    x = xarray_bin0[index]
    y = yarray_bin0[index]
    ;make sure they are within the range specified in tab1
    IF (x LT xsize AND y LT ysize) THEN BEGIN
      current_bin_array[x,y]++
    ENDIF
    index++
  ENDWHILE

  id = WIDGET_INFO(base, $
    FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  draw_xsize = main_base_geometry.xsize
  draw_ysize = main_base_geometry.ysize
  
  congrid_current_bin_array = CONGRID(current_bin_array, $
  draw_xsize, draw_ysize)

  TVSCL, congrid_current_bin_array
  (*(*global_plot).current_bin_array) = current_bin_array
  
END

;------------------------------------------------------------------------------
PRO fits_tools_tab3_plot_base, main_base=main_base, $
    Event=Event, $
    title=title, $
    xtitle=xtitle, $
    ytitle=ytitle, $
    xarray=xarray, $
    yarray=yarray, $
    timearray=timearray
    
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
  wBase3 = ''
  fits_tools_tab3_plot_base_gui, wBase=wBase3, $
    main_base_geometry=main_base_geometry, $
    title=title
    
  (*global).tab3_base = wBase3
  
  WIDGET_CONTROL, wBase3, /REALIZE
  
  global_plot = PTR_NEW({ wbase: wbase3,$
    global: global, $
    
    current_bin_array: PTR_NEW(0L), $ ;current bin displayed
    
    xtitle: xtitle, $
    ytitle: ytitle, $
    xarray: PTR_NEW(0L), $
    yarray: PTR_NEW(0L), $
    timearray: PTR_NEW(0L), $
    main_event: Event})
    
  (*(*global_plot).xarray) = xarray
  (*(*global_plot).yarray) = yarray
  (*(*global_plot).timearray) = timearray
  
  WIDGET_CONTROL, wBase3, SET_UVALUE = global_plot
  
  XMANAGER, "fits_tools_tab3_plot_base", wBase3, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  plot_first_bin_for_tab3, base=wBase3, global_plot=global_plot
  
  
END
