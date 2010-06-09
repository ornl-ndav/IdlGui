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

PRO plot_ascii_file, event_load=event_load, main_event=main_event

  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    widget_control, event_load.top, get_uvalue=global
    global = (*global).global
  ENDIF ELSE BEGIN
    widget_control, main_event.top, get_uvalue=global
  ENDELSE
  load_ascii_file, event_load=event_load, main_event=main_event
  ;to get initial xmin, xmax, ymin and ymax
  get_initial_plot_range, event_load=event_load, main_event=main_event
  PlotAsciiData, event_load=event_load, main_event=main_event
  
END

;==============================================================================
;This method parse the 1 column string array into 3 columns string array
PRO ParseDataStringArray, global, DataStringArray, Xarray, Yarray, SigmaYarray
  Nbr = N_ELEMENTS(DataStringArray)
  j=0
  i=0
  WHILE (i LE Nbr-1) DO BEGIN
    CASE j OF
      0: BEGIN
        Xarray[j]      = DataStringArray[i++]
        Yarray[j]      = DataStringArray[i++]
        SigmaYarray[j] = DataStringArray[i++]
      END
      ELSE: BEGIN
        Xarray      = [Xarray,DataStringArray[i++]]
        Yarray      = [Yarray,DataStringArray[i++]]
        SigmaYarray = [SigmaYarray,DataStringArray[i++]]
      END
    ENDCASE
    j++
  ENDWHILE
  
  (*(*global).Xarray_untouched) = Xarray
  ;remove last element of each array
  sz = N_ELEMENTS(Xarray)
  Xarray = Xarray[0:sz-2]
  Yarray = Yarray[0:sz-2]
  SigmaYarray = SigmaYarray[0:sz-2]
END

;------------------------------------------------------------------------------
PRO CleanUpData, Xarray, Yarray, SigmaYarray
  ;remove -Inf, Inf and NaN
  RealMinIndex = WHERE(FINITE(Yarray),nbr)
  IF (nbr GT 0) THEN BEGIN
    Xarray = Xarray(RealMinIndex)
    Yarray = Yarray(RealMinIndex)
    SigmaYarray = SigmaYarray(RealMinIndex)
  ENDIF
END

;------------------------------------------------------------------------------
;Load data
PRO load_ascii_file, event_load=event_load, main_event=main_event

  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  list_ascii_files = get_list_of_input_file(Event, event_load=event_load, $
    main_event=main_event)
  nbr_ascii = N_ELEMENTS(list_ascii_files)
  
  pXarray = (*(*global).pXarray)
  pYarray = (* (*global).pYarray)
  pSigmaYArray = (*(*global).pSigmaYArray)
  
  pXaxis = (*(*global).pXaxis)
  pXaxis_units = (*(*global).pXaxis_units)
  pYaxis = (*(*global).pYaxis)
  pYaxis_units = (*(*global).pYaxis_units)
  
  ;  xyminmax = (*global).xyminmax
  ;  global_xmax = xyminmax[2]
  ;  global_ymax = xyminmax[3]
  
  index = 0
  WHILE (index LT nbr_ascii) DO BEGIN
  
    ;simple ascii file
    iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', list_ascii_files[index])
    IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
      sAscii = iAsciiFile->getData()
      local_pXaxis = sAscii.xaxis
      local_pXaxis_units = sAscii.xaxis_units
      local_pYaxis = sAscii.yaxis
      local_pYaxis_units = sAscii.yaxis_units
      
      DataStringArray = *(*sAscii.data)[0].data
      ;this method will creates a 3 columns array (x,y,sigma_y)
      Nbr = N_ELEMENTS(DataStringArray)
      IF (Nbr GT 1) THEN BEGIN
        Xarray      = STRARR(1)
        Yarray      = STRARR(1)
        SigmaYarray = STRARR(1)
        ParseDataStringArray, global, $
          DataStringArray,$
          Xarray,$
          Yarray,$
          SigmaYarray
        ;Remove all rows with NaN, -inf, +inf ...
        CleanUpData, Xarray, Yarray, SigmaYarray
        ;Change format of array (string -> float)
        Xarray      = FLOAT(Xarray)
        Yarray      = FLOAT(Yarray)
        SigmaYarray = FLOAT(SigmaYarray)
        
        ;        local_xmax = MAX(Xarray)
        ;        local_ymax = MAX(Yarray)
        ;        IF (local_xmax GT global_xmax) THEN global_xmax = local_xmax
        ;        IF (local_ymax GT global_ymax) THEN global_ymax = local_ymax
        
        *pXarray[index] = Xarray
        *pYarray[index] = Yarray
        *pSigmaYarray[index] = SigmaYarray
        
      ENDIF
      
      *pXaxis[index] = local_pXaxis
      *pXaxis_units[index] = local_pXaxis_units
      *pYaxis[index] = local_pYaxis
      *pYaxis_units[index] = local_pYaxis_units
      
    ENDIF
    OBJ_DESTROY, iAsciiFile
    
    index++
  ENDWHILE
  
  ;  xymax = FLTARR(4)
  ;  xymax[2] = global_xmax
  ;  xymax[3] = global_ymax
  ;  (*global).xyminmax = xymax
  
  (*(*global).pXarray) = pXarray
  (*(*global).pYarray) = pYarray
  (*(*global).pSigmaYArray) = pSigmaYArray
  
  (*(*global).pXaxis) = pXaxis
  (*(*global).pXaxis_units) = pXaxis_units
  (*(*global).pYaxis) = pYaxis
  (*(*global).pYaxis_units) = pYaxis_units
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END

;==============================================================================
;to get initial xmin, xmax, ymin and ymax
PRO get_initial_plot_range, event_load=event_load, main_event=main_event

  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  pXarray = (*(*global).pXarray)
  pYarray = (*(*global).pYarray)
  pSigmaYarray = (*(*global).pSigmaYArray)
  
  global_xmin = 0
  global_xmax = 0
  global_ymin = 0
  global_ymax = 0
  
  nbr_ascii = get_number_of_files_loaded(event_load=event_load, $
    main_event=main_event)
    
  index = 0
  WHILE (index LT nbr_ascii) DO BEGIN
  
  
  
    ;work on xarray
    local_xmin = MIN(*pXarray[index], MAX=local_xmax)
    global_xmin = (local_xmin LT global_xmin) ? local_xmin : global_xmin
    global_xmax = (local_xmax GT global_xmax) ? local_xmax : global_xmax
    
    ;work on yarray
    Yarray = *pYarray[index]
    sigmaYarray = *pSigmaYarray[index]
    Yarray_plus_sigma = Yarray + sigmaYarray
    local_ymin = MIN(Yarray_plus_sigma, MAX=local_ymax)
    global_ymin = (local_ymin LT global_ymin) ? local_ymin : global_ymin
    global_ymax = (local_ymax GT global_ymax) ? local_ymax : global_ymax
    
    index++
  ENDWHILE
  
  (*global).xyminmax = [global_xmin, global_ymin, $
    global_xmax, global_ymax]
    
  id = (*global).tools_base
  IF (WIDGET_INFO(id, /VALID_ID) NE 0) THEN BEGIN
    wBase1 = (*global).tools_base
    putValue_from_base, wBase1, 'plot_ascii_tools_x1' , global_xmin
    putValue_from_base, wBase1, 'plot_ascii_tools_y1' , global_ymin
    putValue_from_base, wBase1, 'plot_ascii_tools_x2' , global_xmax
    putValue_from_base, wBase1, 'plot_ascii_tools_y2' , global_ymax
  ENDIF
  
END

;+
; :Description:
;   This function produces the YX4 yaxis type
;
; :Params:
;    Xarray
;    Yarray
;
; :Returns:
;   Yarray * Xarray^4
;
; :Author: j35
;-
function getYX4, Xarray, Yarray
  compile_opt idl2
  
  new_Yarray = float(Yarray) * float(Xarray) ^ 4
  return, new_Yarray
  
end

;+
; :Description:
;   This function produces the SigmaYX4 axis
;
; :Params:
;    Xarray
;    sigmaYarray
;
; :Returns;
;   SigmaYarray = SigmaYarray * Xarray^4
;
; :Author: j35
;-
function getSigmaYX4, Xarray, sigmaYarray
compile_opt idl2

  new_sigmaYarray = float(sigmaYarray) * float(Xarray) ^ 4
  return, new_sigmaYarray

end

;+
; :Description:
;   Plot data in widget draw
;
;
;
; :Keywords:
;    event_load
;    main_event
;
; :Author: j35
;-
pro plotAsciiData, event_load=event_load, main_event=main_event

  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  main_base_id = (*global).main_base
  
  draw_id = WIDGET_INFO(main_base_id, FIND_BY_UNAME='main_draw')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  WSET,view_plot_id
  
  DEVICE, DECOMPOSED = 1
  loadct,5,/SILENT
  
  pXarray      = (*(*global).pXarray)
  pYarray      = (*(*global).pYarray)
  pSigmaYarray = (*(*global).pSigmaYarray)
  
  pXaxis = (*(*global).pXaxis)
  pXaxis_units = (*(*global).pXaxis_units)
  pYaxis = (*(*global).pYaxis)
  pYaxis_units = (*(*global).pYaxis_units)
  
  nbr_ascii = get_number_of_files_loaded(event_load=event_load, $
    main_event=main_event)
    
  ascii_color = (*global).ascii_color
  
  load_table = getTableValue(event_load=event_load, main_event=main_event, $
    'plot_ascii_load_base_table')
  activate_file_column = load_table[0,*]
  
  index = 0
  first_file_plotted_index  = 0  ;plot xaxis, yaxis for first plot only
  WHILE (index LT nbr_ascii) DO BEGIN
  
    IF (activate_file_column[index] EQ 'X') THEN BEGIN
    
      Xarray = *pXarray[index]
      Yarray = *pYarray[index]
      sigmaYarray = *pSigmaYarray[index]
      
      xAxis = *pXaxis[0]
      xAxis_units = *pXaxis_units[0]
      yAxis = *pYaxis[0]
      yAxis_units = *pYaxis_units[0]
      xLabel = xaxis + ' (' + xaxis_units + ')'
      yLabel = yaxis + ' (' + yaxis_units + ')'
      
      CASE (isYaxisLin(Event)) OF
        'lin': yaxis = 'lin'
        'log': yaxis = 'log'
        ELSE: yaxis = (*global).lin_log_yaxis
      ENDCASE
      
      case (isYaxisType(event)) of
        'Y': ;nothing to do here
        'YX4': begin
          Yarray = getYX4(Xarray, Yarray)
          sigmaYarray = getSigmaYX4(Xarray, sigmaYarray)
        end
        else: begin
          yaxis_type = (*global).yaxis_type
          if (yaxis_type eq 'YX4') then begin
            Yarray = getYX4(Xarray, Yarray)
            sigmaYarray = getSigmaYX4(Xarray, sigmaYarray)
          end
        end
      endcase
      
      color = ascii_color[index]
      
      IF (first_file_plotted_index EQ 0) THEN BEGIN
      
        xyminmax = (*global).xyminmax
        xmin = xyminmax[0]
        ymin = xyminmax[1]
        xmax = xyminmax[2]
        ymax = xyminmax[3]
        
        IF (yaxis EQ 'lin') THEN BEGIN
          plot, Xarray, $
            Yarray, $
            XRANGE = [xmin,xmax],$
            YRANGE = [ymin,ymax],$
            color=FSC_COLOR(color), $
            PSYM=2, $
            XSTYLE = 1,$
            YSTYLE = 1,$
            XTITLE=xLabel, $
            YTITLE=yLabel
        ENDIF ELSE BEGIN
          plot, Xarray, $
            Yarray, $
            XRANGE = [xmin,xmax],$
            YRANGE = [ymin,ymax],$
            XSTYLE = 1,$
            YSTYLE = 1,$
            color=FSC_COLOR(color), $
            PSYM=2, $
            /YLOG, $
            XTITLE=xLabel, $
            YTITLE=yLabel
        ENDELSE
        first_file_plotted_index++
      ENDIF ELSE BEGIN
        IF (yaxis EQ 'lin') THEN BEGIN
          OPLOT, Xarray, $
            Yarray, $
            color=FSC_COLOR(color), $
            PSYM=2
        ENDIF ELSE BEGIN
          oplot, Xarray, $
            Yarray, $
            color=FSC_COLOR(color), $
            PSYM=2
        ENDELSE
      ENDELSE
          errplot, Xarray,Yarray-SigmaYarray,Yarray+SigmaYarray,$
            color=FSC_COLOR(color)
      
    ENDIF ;end of if plot activated
    index++
  ENDWHILE
  
  IF (first_file_plotted_index EQ 0) THEN BEGIN
    ERASE
  ENDIF
  
  DEVICE, DECOMPOSED = 0
  
END

;------------------------------------------------------------------------------
PRO plot_zoom_selection, Event

  draw_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_draw')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  WSET,view_plot_id
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  DEVICE, DECOMPOSED = 1
  loadct,5,/SILENT
  
  x0y0x1y1 = (*global).x0y0x1y1
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  PLOTS, x0, y0, /DATA
  PLOTS, x0, y1, /DATA, /CONTINUE, COLOR=FSC_COLOR('purple'), LINESTYLE=2
  PLOTS, x1, y1, /DATA, /CONTINUE, COLOR=FSC_COLOR('blue'), LINESTYLE=2
  PLOTS, x1, y0, /DATA, /CONTINUE, COLOR=FSC_COLOR('red'), LINESTYLE=2
  PLOTS, x0, y0, /DATA, /CONTINUE, COLOR=FSC_COLOR('green'), LINESTYLE=2
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO sort_x0y0x1y1, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x0y0x1y1 = (*global).x0y0x1y1
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  
  xyminmax = [xmin, ymin, xmax, ymax]
  (*global).xyminmax = xyminmax
  
END

;------------------------------------------------------------------------------
;This procedure populates the x1, x2, y1 and y2 zoom widgets
PRO populate_tools_zoom, Event, x1=x1, y1=y1, x2=x2, y2=y2, ALL=all

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  id = (*global).tools_base
  IF (WIDGET_INFO(id, /VALID_ID) EQ 0) THEN RETURN
  
  IF (N_ELEMENTS(all) NE 0) THEN BEGIN
    xyminmax = (*global).xyminmax
    x1 = xyminmax[0]
    y1 = xyminmax[1]
    x2 = xyminmax[2]
    y2 = xyminmax[3]
    putValue_from_base, id, 'plot_ascii_tools_x1', x1
    putValue_from_base, id, 'plot_ascii_tools_x2', x2
    putValue_from_base, id, 'plot_ascii_tools_y1', y1
    putValue_from_base, id, 'plot_ascii_tools_y2', y2
    RETURN
  ENDIF
  
  IF (N_ELEMENTS(x1) NE 0) THEN putValue_from_base, id, $
    'plot_ascii_tools_x1', x1
  IF (N_ELEMENTS(x2) NE 0) THEN putValue_from_base, id, $
    'plot_ascii_tools_x2', x2
  IF (N_ELEMENTS(y1) NE 0) THEN putValue_from_base, id, $
    'plot_ascii_tools_y1', y1
  IF (N_ELEMENTS(y2) NE 0) THEN putValue_from_base, id, $
    'plot_ascii_tools_y2', y2
    
END