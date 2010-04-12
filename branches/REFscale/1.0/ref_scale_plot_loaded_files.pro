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

;This function plot all the files loaded
;This function is only reached by the LOAD button
PRO PlotLoadedFiles, Event

  ;retrieve global structure
  WIDGET_CONTROL, Event.top, get_uvalue=global
  
  ListLongFileName = (*(*global).ListOfLongFileName)
  
  ;1 if first load, 0 otherwise
  XYMinMax = retrieveXYMinMax(Event)
  xmin = XYMinMax[0]
  xmax = XYMinMax[1]
  ymin = XYMinMax[2]
  ymax = XYMinMax[3]
  IF  (xmin EQ '' AND $
    xmax EQ '' AND $
    ymin EQ '' AND $
    ymax EQ '') THEN BEGIN
    FirstTimePlotting = 1
  ENDIF ELSE BEGIN
    FirstTimePlotting = 0
  ENDELSE
  
  Qmin_array = (*(*global).Qmin_array)
  Qmax_array = (*(*global).Qmax_array)
  
  size = getSizeOfArray(ListLongFileName)

  draw_id = WIDGET_INFO(Event.top, find_by_uname='plot_window')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  WSET,view_plot_id
  
  ;get scale
  IsYlin = getScale(Event,'Y')

  ;check if plot will be with error bars or not
  ErrorBarStatus = (*global).settings_show_error_bar_flag
  
  IF (size EQ 1 AND $
    ListLongFileName[0] EQ '') THEN BEGIN ;no more files loaded so erase plot
    ERASE
    RETURN
  ENDIF
  
  flt0_ptr = (*global).flt0_rescale_ptr
  flt1_ptr = (*global).flt1_rescale_ptr
  flt2_ptr = (*global).flt2_rescale_ptr
  
  error_plot_status = 0
  ;CATCH, error_plot_status
  IF (error_plot_status NE 0) THEN BEGIN
    CATCH,/CANCEL
    text = 'ERROR plotting data'
    displayErrorMessage, Event, text
  ENDIF ELSE BEGIN
  
    FOR i=0,(size-1) DO BEGIN
    
      color_array = (*(*global).color_array)
      colorIndex  = color_array[i]
      IF (ErrorBarStatus EQ 0) THEN BEGIN ;with error bars
        IF (i EQ 0) THEN BEGIN
          MainPlotColor = 100
        ENDIF ELSE BEGIN
          MainPlotColor = 255
        ENDELSE
      ENDIF ELSE BEGIN
        MainPlotColor = colorIndex
      ENDELSE
      
      flt0 = *flt0_ptr[i]
      flt1 = *flt1_ptr[i]
      flt2 = *flt2_ptr[i]
      
      DEVICE, DECOMPOSED = 0
      loadct, 5, /SILENT
      
      IF (FirstTimePlotting EQ 1) THEN BEGIN ;no axis defined yet
      
        populate_min_max_axis, Event, $
          flt0, $
          flt1
          
        draw_id = WIDGET_INFO(Event.top, find_by_uname='plot_window')
        WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
        WSET,view_plot_id
        
        CASE (IsYlin) OF
          0: BEGIN
;            IF (firstTimePlotting) THEN BEGIN
;              PLOT, $
;                flt0, $
;                flt1, $
;                XSTYLE = 1,$
;                color=MainPlotColor
;            ENDIF ELSE BEGIN
              PLOT, $
                flt0, $
                flt1, $
                xrange = [xmin,xmax],$
                yrange = [ymin,ymax],$
                /nodata,$
                XSTYLE = 1
                ;                YSTYLE = 1,$
                ;color=MainPlotColor
              oPLOT, $
                flt0, $
                flt1, $
;                xrange = [xmin,xmax],$
;                yrange = [ymin,ymax],$
;                XSTYLE = 1,$
                ;                YSTYLE = 1,$
                color=MainPlotColor
;            ENDELSE
          END
          1: BEGIN
 ;           IF (firstTimePlotting) THEN BEGIN
 ;             PLOT, $
 ;               flt0, $
 ;               flt1, $
 ;               /ylog, $
 ;               color=MainPlotColor
 ;           ENDIF ELSE BEGIN
              PLOT, $
                flt0, $
                flt1, $
                XSTYLE = 1,$
                /nodata,$
                xrange = [xmin,xmax]
;                /ylog
                oplot, $
                flt0, $
                flt1, $
;                XSTYLE = 1,$
;                xrange = [xmin,xmax],$
                /ylog, $
                color=MainPlotColor
  ;          ENDELSE
          END
        ENDCASE
        
        IF (ErrorBarStatus EQ 1) THEN BEGIN ;if we want error bars
          errplot, $
            flt0, $
            flt1-flt2, $
            flt1+flt2, $
            color=colorIndex
        ENDIF
        
      ENDIF ELSE BEGIN ;axis defined by first file loaded
      
        CASE (IsYlin) OF
          0: BEGIN
;            PLOT, $
;              flt0, $
;              flt1, $
;              xrange = [xmin,xmax],$
;              yrange = [ymin,ymax],$
;              XSTYLE = 1,$
;              /NOERASE,$
;              color=MainPlotColor
            oPLOT, $
              flt0, $
              flt1, $
  ;            xrange = [xmin,xmax],$
  ;            yrange = [ymin,ymax],$
  ;            XSTYLE = 1,$
              ;/NOERASE,$
              color=MainPlotColor
          END
          1: BEGIN
            oPLOT, $
              flt0, $
              flt1, $
;              /ylog, $
   ;           xrange = [xmin,xmax],$
   ;           yrange = [ymin,ymax],$
   ;           XSTYLE = 1,$
              color=MainPlotColor
          END
        ENDCASE
        
        IF (ErrorBarStatus EQ 1) THEN BEGIN
          errplot, flt0, $
            flt1-flt2, $
            flt1+flt2, $
            color=colorIndex
        ENDIF
        
      ENDELSE
      
      ;        XYMinMax = retrieveXYMinMax(Event) ;_get
      ;        xmin = FLOAT(XYMinMax[0])
      ;        xmax = FLOAT(XYMinMax[1])
      ;        ymin = FLOAT(XYMinMax[2])
      ;        ymax = FLOAT(XYMinMax[3])
      
      ;determine Qmin and Qmax
      
      QminQmax = getQminQmaxValue(flt0, flt1) ;_get
      Qmin = QminQmax[0]
      Qmax = QminQmax[1]
      Qmin_array[i] = Qmin
      Qmax_array[i] = Qmax
      
    ENDFOR
    
  ENDELSE
  
  ;store back the array of all the Qmin of the functions loaded
  (*(*global).Qmin_array) = Qmin_array
  (*(*global).Qmax_array) = Qmax_array
  
;PRINT, 'Leaving PlotLoadedFiles'
;PRINT
  
END
