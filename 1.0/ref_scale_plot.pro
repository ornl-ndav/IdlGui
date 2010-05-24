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

;##############################################################################
;******************************************************************************

;This function plots the selected file
PRO plot_loaded_file, Event, index

  ;retrieve global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,get_uvalue=global
  
  ;0 means that the fitting plot won't be seen
  ;1 means that the fitting plot will be seen
  show_error_plot=0
  
  draw_id = WIDGET_INFO(Event.top, find_by_uname='plot_window')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  WSET,view_plot_id
  
  IsXlin = getScale(Event,'X') ;_get
  IsYlin = getScale(Event,'Y') ;_get
  ClearPlot = 0      ;by default, the display does not have to be erased
  
  nbr_elements = $        ;check that there is at least one file to plot
    getNbrElementsInDropList(Event, $
    'step3_work_on_file_droplist') ;_get
    
  IF (nbr_elements GT 0) THEN BEGIN
    CASE (index) OF
    
      'CE': BEGIN             ;plot CE
        index_to_plot = [0]
      END
      
      'all': BEGIN            ;plot all the plots
        nbr_elements = $
          getNbrElementsInDropList(Event,'step3_work_on_file_droplist')
        ;_get
        index_to_plot = INDGEN(nbr_elements)
      END
      
      '2plots': BEGIN         ;plot index and (index-1) in tab 3
        nbr_elements = $
          getNbrElementsInDropList(Event, $
          'step3_work_on_file_droplist') ;_get
        IF (nbr_elements EQ 1) THEN BEGIN ;if only 1 file, must be CE file
          index_to_plot = [0]
        ENDIF ELSE BEGIN    ;more than 1 file
          index_to_plot = $
            getSelectedIndex(Event, 'step3_work_on_file_droplist') ;_get
          IF (index_to_plot EQ 0) THEN BEGIN
            index_to_plot = [0]
          ENDIF ELSE BEGIN
            index_to_plot = [index_to_plot-1,index_to_plot]
          ENDELSE
        ENDELSE
      END
      
      'clear': BEGIN          ;no files to plot, just erase display
        ClearPlot = 1
      END
    ENDCASE
  ENDIF ELSE BEGIN
    ClearPlot = 1
  ENDELSE
  
  DEVICE, DECOMPOSED = 0
  loadct,5,/SILENT
  
  ;check if plot will be with error bars or not
  ErrorBarStatus = (*global).settings_show_error_bar_flag
  
  IF (ClearPlot EQ 1) THEN BEGIN  ;no plot to plot, erase display
  
    ERASE
    
  ENDIF ELSE BEGIN                ;at least one file has to be ploted
  
    ;retrieve flt0, flt1 and flt2
    flt0_ptr = (*global).flt0_rescale_ptr
    flt1_ptr = (*global).flt1_rescale_ptr
    flt2_ptr = (*global).flt2_rescale_ptr
    
    index_size = (SIZE(index_to_plot))(1)
    FOR i=0,(index_size-1) DO BEGIN
    
      ;color index of main plot
      IF (i EQ 0) THEN BEGIN
        MainPlotColor = 0
      ENDIF ELSE BEGIN
        MainPlotColor = 255
      ENDELSE
      
      spin_index = (*global).current_spin_index
      if (spin_index ne -1) then begin
        flt0 = *flt0_ptr[index_to_plot[i],spin_index]
        flt1 = *flt1_ptr[index_to_plot[i],spin_index]
        flt2 = *flt2_ptr[index_to_plot[i],spin_index]
      endif else begin
        ;retrieve particular flt0, flt1 and flt2
        flt0 = *flt0_ptr[index_to_plot[i]]
        flt1 = *flt1_ptr[index_to_plot[i]]
        flt2 = *flt2_ptr[index_to_plot[i]]
      endelse
      
      color_array = (*(*global).color_array)
      colorIndex = color_array[index_to_plot[i]]
      IF (ErrorBarStatus EQ 0) THEN BEGIN
        IF (i EQ 0) THEN BEGIN
          MainPlotColor = 100
        ENDIF ELSE BEGIN
          MainPlotColor = 255
        ENDELSE
      ENDIF ELSE BEGIN
        MainPlotColor = colorIndex
      ENDELSE
      
      XYMinMax = retrieveXYMinMax(Event)
      xmin = FLOAT(XYMinMax[0])
      xmax = FLOAT(XYMinMax[1])
      ymin = FLOAT(XYMinMax[2])
      ymax = FLOAT(XYMinMax[3])
      
      IF (i EQ 0) THEN BEGIN
      
        CASE (IsXlin) OF
        
          0: BEGIN
          
            CASE (IsYlin) OF
            
              0: BEGIN
                PLOT, $
                  flt0, $
                  flt1, $
                  /nodata,$
                  xrange=[xmin,xmax], $
                  XSTYLE = 1,$
                  color = 0,$
                  yrange=[ymin,ymax]
                oPLOT, $
                  flt0, $
                  flt1, $
                  color=MainPlotColor
              END
              
              1: BEGIN
                PLOT, $
                  flt0, $
                  flt1, $
                  /ylog, $
                  XSTYLE = 1,$
                  /nodata,$
                  color = 0,$
                  xrange=[xmin,xmax], $
                  yrange=[ymin,ymax]
                oPLOT, $
                  flt0, $
                  flt1, $
                  color=MainPlotColor
              END
            ENDCASE
            
          END
          
          1: BEGIN
          
            CASE (IsYlin) OF
            
              0: BEGIN
                PLOT, $
                  flt0, $
                  flt1, $
                  /xlog, $
                  XSTYLE = 1,$
                  /nodata,$
                  xrange=[xmin,xmax], $
                  yrange=[ymin,ymax]
                oPLOT, $
                  flt0, $
                  flt1, $
                  color=MainPlotColor
              END
              
              1: BEGIN
                PLOT, $
                  flt0, $
                  flt1, $
                  /xlog, $
                  /ylog, $
                  /nodata,$
                  XSTYLE = 1,$
                  xrange=[xmin,xmax], $
                  yrange=[ymin,ymax]
                oPLOT, $
                  flt0, $
                  flt1, $
                  color=MainPlotColor
              END
            ENDCASE
          END
        ENDCASE
        
        IF (ErrorBarStatus EQ 1) THEN BEGIN
          errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
        ENDIF
        
      ENDIF ELSE BEGIN
      
        XYMinMax = retrieveXYMinMax(Event) ;_get
        xmin = FLOAT(XYMinMax[0])
        xmax = FLOAT(XYMinMax[1])
        ymin = FLOAT(XYMinMax[2])
        ymax = FLOAT(XYMinMax[3])
        
        CASE (IsXlin) OF
        
          0:BEGIN
          
          CASE (IsYlin) OF
          
            0: BEGIN
              oPLOT, $
                flt0, $
                flt1, $
                color=MainPlotColor
            END
            
            1: BEGIN
              oPLOT, $
                flt0, $
                flt1, $
                color=MainPlotColor
            END
          ENDCASE
        END
        
        1: BEGIN
          CASE (IsYlin) OF
          
            0: BEGIN
              oPLOT, $
                flt0, $
                flt1, $
                color=MainPlotColor
            END
            1: BEGIN
              oPLOT, $
                flt0, $
                flt1, $
                color=MainPlotColor
            END
          ENDCASE
        END
      ENDCASE
      
    ENDELSE
    
    IF (ErrorBarStatus EQ 1) THEN BEGIN
      errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
    ENDIF
    
  ENDFOR
  
ENDELSE

END

;##############################################################################
;******************************************************************************

PRO replot_main_plot, Event

  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,get_uvalue=global
  
  IF (((*global).replot_me) EQ 1) THEN BEGIN
    steps_tab, Event, 1   ;_Tab
    ;plot_loaded_file, Event, 'CE' ;_Plot
    (*global).replot_me = 0
  ENDIF
  
end

;##############################################################################
;******************************************************************************

;This function plots the selected file
PRO plot_rescale_CE_file, Event

  ;retrieve global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,get_uvalue=global
  
  draw_id = WIDGET_INFO(Event.top, find_by_uname='plot_window')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  WSET,view_plot_id
  
  IsXlin = getScale(Event,'X') ;_get
  IsYlin = getScale(Event,'Y') ;_get
  
  color_array = (*(*global).color_array)
  
  DEVICE, DECOMPOSED = 0
  loadct,5,/SILENT
  
  flt0_ptr = (*global).flt0_ptr
  flt1_ptr = (*global).flt1_ptr
  flt2_ptr = (*global).flt2_ptr
  
  ;rescale the other spin states as well
  spin_index = (*global).current_spin_index
  if (spin_index ne -1) then begin
  
    flt0 = *flt0_ptr[0,spin_index]
    flt1 = *flt1_ptr[0,spin_index]
    flt2 = *flt2_ptr[0,spin_index]
    
  endif else begin
  
    ;retrieve particular flt0, flt1 and flt2
    flt0 = *flt0_ptr[0]
    flt1 = *flt1_ptr[0]
    flt2 = *flt2_ptr[0]
    
  endelse
  
  ;divide by scaling factor
  CE_scaling_factor = (*global).CE_scaling_factor
  putTextFieldValue, Event, 'step2_sf_text_field', $
    strcompress(CE_scaling_factor,/remove_all)
  flt1              = flt1/CE_scaling_factor
  flt2              = flt2/CE_scaling_factor
  
  cooef = (*(*global).CEcooef)
  IF (cooef[0] NE 0 AND $
    cooef[1] NE 0) THEN BEGIN
    cooef[0] /= CE_scaling_factor
    Cooef[1] /= CE_scaling_Factor
  ENDIF
  
  colorIndex = color_array[0]
  
  XYMinMax = getXYMinMax(Event) ;_get
  xmin     = FLOAT(XYMinMax[0])
  xmax     = FLOAT(XYMinMax[1])
  ymin     = FLOAT(XYMinMax[2])
  ymax     = FLOAT(XYMinMax[3])
  
  CASE (IsXlin) OF
    0: BEGIN
      CASE (IsYlin) OF
        0: BEGIN
          PLOT,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax]
        END
        1: BEGIN
          PLOT,flt0,flt1,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax]
        END
      ENDCASE
    END
    1: BEGIN
      CASE (IsYlin) OF
        0: BEGIN
          PLOT,flt0,flt1,/xlog,xrange=[xmin,xmax],yrange=[ymin,ymax]
        END
        1: BEGIN
          PLOT,flt0,flt1,/xlog,/ylog,xrange=[xmin,xmax], $
            yrange=[ymin,ymax]
        END
      ENDCASE
    END
  ENDCASE
  
  errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
  
  ;polynome of degree 1 for CE
  IF (cooef[0] NE 0 AND $
    cooef[1] NE 0) THEN BEGIN
    show_error_plot=1
    flt0_new = (*(*global).flt0_CE_range)
    y_new = cooef(1)*flt0_new + cooef(0)
    OPLOT,flt0_new,y_new,color=400,thick=1.5
  ENDIF
  
  ;repeat scaling for other spin states (if any)
  
  flt1_rescale_ptr = (*global).flt1_rescale_ptr
  flt2_rescale_ptr = (*global).flt2_rescale_ptr
  
  DRfiles = (*(*global).DRfiles)
  nbr_spin = (size(DRfiles))[1]
  ;current_spin_index = (*global).current_spin_index
  current_spin_index = get_current_spin_index(event)
  if (nbr_spin gt 1) then begin
  
    spin_index = 0
    while (spin_index lt nbr_spin) do begin
    
      if (spin_index ne current_spin_index) then begin
        flt1 = *flt1_ptr[0,spin_index]
        flt2 = *flt2_ptr[0,spin_index]
        flt1 = flt1/CE_scaling_factor
        flt2 = flt2/CE_scaling_factor
      endif
      
      *flt1_rescale_ptr[0,spin_index] = flt1
      *flt2_rescale_ptr[0,spin_index] = flt2
      
      spin_index++
    endwhile
    
  endif else begin
  
    *flt1_rescale_ptr[0]       = flt1
    *flt2_rescale_ptr[0]       = flt2
    
  endelse
  
  (*global).flt1_rescale_ptr = flt1_rescale_ptr
  (*global).flt2_rescale_ptr = flt2_rescale_ptr
  
END

;##############################################################################
;******************************************************************************

;This function takes care of launching the plot function in the right mode
PRO DoPlot, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,get_uvalue=global
  ;get index of current tab selected
  steps_tab_id = WIDGET_INFO(Event.top, find_by_uname='steps_tab')
  CurrTabSelect = WIDGET_INFO(steps_tab_id,/tab_current) ;current tab selected
  
  CASE (CurrTabSelect) OF
    0: BEGIN                     ;if the first tab is selected
      plot_loaded_file, Event, 'all' ;_Plot
    END
    1: BEGIN   ;if the second tab is selected, plot index 0 (CE file)
      plot_loaded_file, Event, 'CE' ;_Plot
    END
    2: BEGIN       ;if the third tab is selected plot index and index-1
      plot_loaded_file, Event, '2plots' ;_Plot
    END
    ELSE: plot_loaded_file, Event, 'all' ;_Plot
  ENDCASE
END

;##############################################################################
;******************************************************************************
;Plot Qmin and Qmax
PRO PlotQs, Event, Q1, Q2
  WIDGET_CONTROL,event.top,get_uvalue=global
  XMinMax = getXYMinMax(Event)
  xmin = DOUBLE(XMinMax[0])
  xmax = DOUBLE(XMinMax[1])
  ymin = DOUBLE(XMinMax[2])
  ymax = DOUBLE(XMinMax[3])
  
  IF (Q1 GT xmin AND $
    Q1 LT xmax) THEN BEGIN
    ;plot Q1
    PLOTS, Q1, ymin, /data, color=200
    PLOTS, Q1, ymax, /data, /continue, color=200
  ENDIF
  IF (Q2 GT xmin AND $
    Q2 LT xmax) THEN BEGIN
    ;plot Q2
    PLOTS, Q2, ymin, /data, color=200
    PLOTS, Q2, ymax, /data, /continue, color=200
  ENDIF
END

;##############################################################################
;******************************************************************************
;Plot Qmin or Qmax
PRO PlotQ, Event, X1
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,get_uvalue=global
  XMinMax = getXYMinMax(Event)
  xmin = DOUBLE(XMinMax[0])
  xmax = DOUBLE(XMinMax[1])
  ymin = DOUBLE(XMinMax[2])
  ymax = DOUBLE(XMinMax[3])
  
  ;  ymin = (*global).draw_ymin
  ;  ymax = (*global).draw_ymax
  ;  xmin = (*global).draw_xmin
  ;  xmax = (*global).draw_xmax
  
  IF (X1 GE xmin AND $
    X1 LE xmax) THEN BEGIN
    ;plot Q
    ;PLOTS, X1, ymin, /device, color=200
    ;PLOTS, X1, ymax, /device, /continue, color=200
    PLOTS, X1, ymin, /data, color=200
    PLOTS, X1, ymax, /data, /continue, color=200
  ENDIF
END

