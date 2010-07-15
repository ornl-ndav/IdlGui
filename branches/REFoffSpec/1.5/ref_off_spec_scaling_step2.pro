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

PRO populate_zoom_widgets, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;check that xmax is not empty or equal to 0
  xmax_value = getTextFieldValue(Event,'step4_2_zoom_x_max')
  
  no_data = 0
  CATCH, no_data
  IF (no_data NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    IF (xmax_value EQ '' OR $
      xmax_value EQ FLOAT(0)) THEN BEGIN
      
      xrange = (*(*global).step4_step2_step1_xrange)
      sz = (size(xrange))(1)
      sxmin = STRCOMPRESS(xrange[0],/REMOVE_ALL)
      sxmax = STRCOMPRESS(xrange[sz-1],/REMOVE_ALL)
      ;symin = STRCOMPRESS((*global).ymin_log_mode ,/REMOVE_ALL)
      ;symax = STRCOMPRESS((*global).step4_step1_ymax_value,/REMOVE_ALL)
      
      ymin_ymax = (*global).scaling_step2_ymin_ymax
      symin = STRCOMPRESS(ymin_ymax[0],/REMOVE_ALL)
      symax = STRCOMPRESS(ymin_ymax[1],/REMOVE_ALL)
      
      (*global).X_Y_min_max_backup = [sxmin, symin, sxmax, symax]
      
      putTextFieldValue, Event, 'step4_2_zoom_x_min', sxmin
      putTextFieldValue, Event, 'step4_2_zoom_x_max', sxmax
      putTextFieldValue, Event, 'step4_2_zoom_y_min', symin
      putTextFieldValue, Event, 'step4_2_zoom_y_max', symax
      
    ENDIF
  ENDELSE
  
END

;------------------------------------------------------------------------------
;When RESET zoom button is used
PRO  reset_zoom_widgets, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;check that xmax is not empty or equal to 0
  xmax_value = getTextFieldValue(Event,'step4_2_zoom_x_max')
  no_data = 0
  CATCH, no_data
  IF (no_data NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    X_Y_min_max_array = (*global).X_Y_min_max_backup
    sXmin = X_Y_min_max_array[0]
    sYmin = X_Y_min_max_array[1]
    sXmax = X_Y_min_max_array[2]
    sYmax = X_Y_min_max_array[3]
    
    symin = STRCOMPRESS((*global).step4_ymin_global_value,/REMOVE_ALL)
    
    putTextFieldValue, Event, 'step4_2_zoom_x_min', sxmin
    putTextFieldValue, Event, 'step4_2_zoom_x_max', sxmax
    putTextFieldValue, Event, 'step4_2_zoom_y_min', symin
    putTextFieldValue, Event, 'step4_2_zoom_y_max', symax
    
  ENDELSE
  
END

; TEST (RC Ward, June 28, 2010): Add this to set base/draw and launch XMANAGER for scaling 1D plot
PRO step4_step3_plot2d, Event, GROUP_LEADER=group
  WIDGET_CONTROL, Event.top,GET_UVALUE=global
  COMPILE_OPT idl2, hidden
  
  ; Check if already created.  If so, return.
;  IF (WIDGET_INFO((*global).w_scaling_plot2d_id, /VALID_ID) NE 0) THEN BEGIN
;    WIDGET_CONTROL,(*global).w_scaling_plot2d_id, /SHOW
;    RETURN
;  ENDIF

  xsize = 642
  ysize = 642
  
  ;Build base
  title = 'Counts vs Pixels for Selection'
  wBase = WIDGET_BASE(TITLE        = title,$
    XOFFSET      = 900,$
    YOFFSET      = 500,$
    GROUP_LEADER = group,$
    UNAME = 'plot_2d_scaling_base',$
    /TLB_KILL_REQUEST_EVENTS)
    
  wDraw = WIDGET_DRAW(wBase,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    RETAIN    = 2, $
    UNAME     = 'plot_2d_scaling_draw')
    
  (*global).w_scaling_plot2d_id = wBase
  uname = WIDGET_INFO(wDraw,/UNAME)
  (*global).w_scaling_plot2d_draw_uname = uname
  
  WIDGET_CONTROL, wBase, /REALIZE
  XMANAGER, "ref_off_spec_scaling_plot2d", wBase, /NO_BLOCK
END
; END TEST ==============================================================================
;------------------------------------------------------------------------------
PRO re_display_step4_step2_step1_selection, Event, MODE=mode
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;first check that there is something to plot (that a selection of
  ;step1 of scaling has been done). If not, display a message asking for
  ;a selection first.
  
  ; Code change RCW (Feb 8, 2010): Get Background color from XML file
     PlotBackground = (*global).BackgroundCurvePlot
       ref_pixel_list = (*(*global).ref_pixel_list)
  
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
    ;array that will contain the counts vs wavelenghth of each data file
; just checks to see if mode is set to anything, if it is (say 'AUTOSCALE') then use new
; RC Ward does not understand this - 1 July 2010
    IF (N_ELEMENTS(MODE) EQ 0) THEN BEGIN
      IvsLambda_selection = (*(*global).IvsLambda_selection)
    ENDIF ELSE BEGIN
      IvsLambda_selection = (*(*global).new_IvsLambda_selection)
    ENDELSE
    
    xmin = getTextFieldValue(Event,'step4_2_zoom_x_min')
    xmax = getTextFieldValue(Event,'step4_2_zoom_x_max')
    ymin = getTextFieldValue(Event,'step4_2_zoom_y_min')
    ymax = getTextFieldValue(Event,'step4_2_zoom_y_max')
    
    (*global).step4_step1_ymax_value = FLOAT(ymax)
    
    tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
    CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
    CASE (CurrTabSelect) OF
      0: BEGIN ;all_files
        index = 0
        box_color     = (*global).box_color
        WHILE (index LT nbr_plot) DO BEGIN
        
          IF (N_ELEMENTS(MODE) EQ 0) THEN BEGIN
            t_data_to_plot = *IvsLambda_selection[index]
          ENDIF ELSE BEGIN
            t_data_to_plot = IvsLambda_selection[index,*]
          ENDELSE
          
          color = box_color[index]
          psym  = getStep4Step2PSYMselected(Event)
          
          isLog = getStep4Step2PlotType(Event)
          
          IF (index EQ 0) THEN BEGIN
          
            xrange = (*(*global).step4_step2_step1_xrange)
            xtitle = 'Wavelength'
            ytitle = 'Counts'
            
            IF (isLog) THEN BEGIN
              plot, xrange, $
                t_data_to_plot, $
                XTITLE = xtitle, $
                YTITLE = ytitle,$
                COLOR  = color,$
                BACKGROUND = FSC_COLOR(PlotBackground),$
                XRANGE = [xmin,xmax],$
                YRANGE = [ymin,ymax],$
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
                XRANGE = [xmin,xmax],$
                YRANGE = [ymin,ymax],$
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
      END                     ;end of 0:
      
      1: BEGIN ;CE file only
        index = 0
        box_color     = (*global).box_color
        IF (N_ELEMENTS(MODE) EQ 0) THEN BEGIN
          t_data_to_plot = *IvsLambda_selection[index]
        ENDIF ELSE BEGIN
          t_data_to_plot = IvsLambda_selection[index,*]
        ENDELSE
        color = box_color[index]
        psym  = getStep4Step2PSYMselected(Event)
        isLog = getStep4Step2PlotType(Event)
        
        xrange = (*(*global).step4_step2_step1_xrange)
        xtitle = 'Wavelength'
        ytitle = 'Counts'
        
        IF (isLog) THEN BEGIN
          plot, xrange, $
            t_data_to_plot, $
            XTITLE = xtitle, $
            YTITLE = ytitle,$
            COLOR  = color,$
            BACKGROUND = FSC_COLOR(PlotBackground),$
            XRANGE = [xmin,xmax],$
            YRANGE = [ymin,ymax],$
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
            XRANGE = [xmin,xmax],$
            YRANGE = [ymin,ymax],$
            XSTYLE = 1,$
            PSYM   = psym
        ENDELSE
      END ;end of 1:
      
      2: BEGIN ;all files or only two files selected
        index = 0
        box_color     = (*global).box_color
        WHILE (index LT nbr_plot) DO BEGIN
; I GOT A ERROR IN THIS ROUTINE - POSSIBLY AT THIS LOCATION - 25 JAN 2010 - RCW 
; MODE maybe miss interpretted here. MODE is not set sometimes and set to 'AUTOMATIC' sometimes       
          IF (N_ELEMENTS(MODE) EQ 0) THEN BEGIN
            t_data_to_plot = *IvsLambda_selection[index]
          ENDIF ELSE BEGIN
            t_data_to_plot = IvsLambda_selection[index,*]
          ENDELSE
          
          color = box_color[index]
          psym  = getStep4Step2PSYMselected(Event)
          
          isLog = getStep4Step2PlotType(Event)
          
          IF (index EQ 0) THEN BEGIN
          
            xrange = (*(*global).step4_step2_step1_xrange)
            xtitle = 'Wavelength'
            ytitle = 'Counts'
            
            IF (isLog) THEN BEGIN
              plot, xrange, $
                t_data_to_plot, $
                XTITLE = xtitle, $
                YTITLE = ytitle,$
                COLOR  = color,$
                BACKGROUND = FSC_COLOR(PlotBackground),$
                XRANGE = [xmin,xmax],$
                YRANGE = [ymin,ymax],$
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
                XRANGE = [xmin,xmax],$
                YRANGE = [ymin,ymax],$
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

      END                     ;end of 0:
     
    ENDCASE
  ENDIF
  
END

; Change code (RC Ward, 5 July 2010): ADD A SEPARATE ROUTINE THAT IS ACTIVITED WHEN BUTTON "SCALED PLOT" IS CLIKCED
PRO re_display_step4_step2_step1_separate_window, Event, MODE=mode
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ; Code change RCW (Feb 8, 2010): Get Background color from XML file
     PlotBackground = (*global).BackgroundCurvePlot
       ref_pixel_list = (*(*global).ref_pixel_list)
  
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
    ;array that will contain the counts vs wavelenghth of each data file
; just checks to see if mode is set to anything, if it is (say 'AUTOSCALE') then use new
; RC Ward does not understand this - 1 July 2010
    IF (N_ELEMENTS(MODE) EQ 0) THEN BEGIN
      IvsLambda_selection = (*(*global).IvsLambda_selection)
    ENDIF ELSE BEGIN
      IvsLambda_selection = (*(*global).new_IvsLambda_selection)
    ENDELSE
    
    xmin = getTextFieldValue(Event,'step4_2_zoom_x_min')
    xmax = getTextFieldValue(Event,'step4_2_zoom_x_max')
    ymin = getTextFieldValue(Event,'step4_2_zoom_y_min')
    ymax = getTextFieldValue(Event,'step4_2_zoom_y_max')
    
    (*global).step4_step1_ymax_value = FLOAT(ymax)

        step4_step3_plot2d, $
           Event, $
           GROUP_LEADER=Event.top
; now do the plot
       index = 0
        box_color     = (*global).box_color
        WHILE (index LT nbr_plot) DO BEGIN
; I GOT A ERROR IN THIS ROUTINE - POSSIBLY AT THIS LOCATION - 25 JAN 2010 - RCW        
          IF (N_ELEMENTS(MODE) EQ 0) THEN BEGIN
            t_data_to_plot = *IvsLambda_selection[index]
          ENDIF ELSE BEGIN
            t_data_to_plot = IvsLambda_selection[index,*]
          ENDELSE
          color = box_color[index]
          psym  = getStep4Step2PSYMselected(Event)
          
          isLog = getStep4Step2PlotType(Event)
          
          IF (index EQ 0) THEN BEGIN
          
            xrange = (*(*global).step4_step2_step1_xrange)
            xtitle = 'Wavelength'
            ytitle = 'Counts'
            
            IF (isLog) THEN BEGIN
              plot, xrange, $
                t_data_to_plot, $
                XTITLE = xtitle, $
                YTITLE = ytitle,$
                COLOR  = color,$
                BACKGROUND = FSC_COLOR(PlotBackground),$
                XRANGE = [xmin,xmax],$
                YRANGE = [ymin,ymax],$
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
                XRANGE = [xmin,xmax],$
                YRANGE = [ymin,ymax],$
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
PRO re_plot_lambda_selected, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
; Code change RCW (Feb 9, 2010: pass CE selection vertical line color in global
   ceselect_vertical_line_color = (*global).ceselect_vertical_line_color 

  ;Lambda
  sLdaMin   = getTextFieldValue(Event,'step4_2_2_lambda1_text_field')
  sLdaMax   = getTextFieldValue(Event,'step4_2_2_lambda2_text_field')
  f_Lda_min = FLOAT(sLdaMin)
  f_lda_max = FLOAT(sLdaMax)
  
  ;xmin/xmax (new)
  xmin_now   = getTextFieldValue(Event,'step4_2_zoom_x_min')
  xmax_now   = getTextFieldValue(Event,'step4_2_zoom_x_max')
  f_xmin_now = FLOAT(xmin_now)
  f_xmax_now = FLOAT(xmax_now)
  
  device_xmin = (*global).step4_2_2_draw_xmin
  device_xmax = (*global).step4_2_2_draw_xmax
  ratio       = (device_xmax - device_xmin)
  ratio      /= (f_xmax_now - f_xmin_now)
  
  device_ymin = (*global).step4_2_2_draw_ymin
  device_ymax = (*global).step4_2_2_draw_ymax
  
  ;check if f_lda_min is inside the zoom region requested)
  IF (f_Lda_min GE f_xmin_now AND $
    f_Lda_min LE f_xmax_now) THEN BEGIN
    
    device_lda  = device_xmax - ratio * (f_xmax_now - f_Lda_min)

; Code change RCW (Feb 9, 2010): ceselect_vertical_line_color is set in XML config file, was set to 200.
    plots, device_lda, device_ymin, /DEVICE, COLOR=FSC_COLOR(ceselect_vertical_line_color)
    plots, device_lda, device_ymax, /DEVICE, /CONTINUE, COLOR=FSC_COLOR(ceselect_vertical_line_color)
    
  ENDIF
  
  ;check if f_lda_max is inside the zoom region requested)
  IF (f_Lda_max GE f_xmin_now AND $
    f_Lda_max LE f_xmax_now) THEN BEGIN
    
    device_lda  = device_xmax - ratio * (f_xmax_now - f_Lda_max)

; Code change RCW (Feb 9, 2010): ceselect_vertical_line_color is set in XML config file, was set to 200.
    plots, device_lda, device_ymin, /DEVICE, COLOR=FSC_COLOR(ceselect_vertical_line_color)
    plots, device_lda, device_ymax, /DEVICE, /CONTINUE, COLOR=FSC_COLOR(ceselect_vertical_line_color)
    
  ENDIF
  
END

