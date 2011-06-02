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

PRO display_step4_step2_step1_selection, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;first check that there is something to plot (that a selection of
  ;step1 of scaling has been done). If not, display a message asking for
  ;a selection first.
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  xy_position = (*global).step4_step1_selection
  IF (xy_position[0]+xy_position[2] NE 0 AND $
    xy_position[1]+xy_position[3] NE 0) THEN BEGIN ;valid selection
    
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='draw_step4_step2')
    WIDGET_CONTROL, id_draw, GET_VALUE=id_value
    WSET,id_value
    
    nbr_plot = getNbrFiles(Event)
    ;array that will contain the counts vs wavelenght of each data file
    IvsLambda_selection = (*(*global).IvsLambda_selection)
    
    index = 0
    box_color     = (*global).box_color
    
    ymin_value = getTextFieldValue(Event,'step4_2_zoom_y_min')
    ymax_value = getTextFieldValue(Event,'step4_2_zoom_y_max')
    
    WHILE (index LT nbr_plot) DO BEGIN
    
      t_data_to_plot = *IvsLambda_selection[index]
      color          = box_color[index]
      psym = getStep4Step2PSYMselected(Event)
      
      scaling_factor = (*(*global).scaling_factor)
      SF = scaling_factor[index]
      t_data_to_plot /= SF
      
      isLog = getStep4Step2PlotType(Event)
   ; Code change RCW (Feb 8, 2010): Get Background color from XML file
        PlotBackground = (*global).BackgroundCurvePlot

      IF (index EQ 0) THEN BEGIN
        xrange = (*(*global).step4_step2_step1_xrange)
        xtitle = 'Wavelength'
        ytitle = 'Counts'
        ;        ymax_value = (*global).step4_step1_ymax_value

        IF (isLog) THEN BEGIN
          plot, xrange, $
            t_data_to_plot, $
            XTITLE = xtitle, $
            YTITLE = ytitle,$
            COLOR  = color,$
                BACKGROUND = FSC_COLOR(PlotBackground),$
            ;YRANGE = [(*global).ymin_log_mode,ymax_value],$
            YRANGE = [ymin_value, ymax_value], $
          XSTYLE = 1,$
            PSYM   = psym,$
            /YLOG
        ENDIF ELSE BEGIN
          plot, xrange, $
            t_data_to_plot, $
            XTITLE = xtitle, $
            YTITLE = ytitle,$
            COLOR  = color,$
                BACKGROUND = FSC_COLOR(PlotBackground),$
;            BACKGROUND = convert_rgb(PlotBackground),$
            YRANGE = [ymin_value, ymax_value],$
            ;            YRANGE = [0, ymax_value],$
            XSTYLE = 1,$
            PSYM   = psym
        ENDELSE
      ENDIF ELSE BEGIN
        oplot, xrange,$
          t_data_to_plot, $
          COLOR  = color,$
          PSYM   = psym
      ENDELSE
      index++
    ENDWHILE
  ENDIF
  
END

;------------------------------------------------------------------------------
