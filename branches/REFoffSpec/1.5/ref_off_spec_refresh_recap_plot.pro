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

PRO refresh_recap_plot, Event, RESCALE=rescale
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
print, "refresh_recap_plot"  
  nbr_plot    = getNbrFiles(Event) ;number of files
  
  scaling_factor_array = (*(*global).scaling_factor)
  tfpData              = (*(*global).realign_pData_y)
  tfpData_error        = (*(*global).realign_pData_y_error)
  xData                = (*(*global).pData_x)
  xaxis                = (*(*global).x_axis)
  congrid_coeff_array  = (*(*global).congrid_coeff_array)
  xmax                 = 0L
  x_axis               = LONARR(nbr_plot)
  y_coeff              = 2
  x_coeff              = 1
  
  master_min           = !VALUES.D_NAN
  master_max           = !VALUES.D_NAN
  
  trans_coeff_list = (*(*global).trans_coeff_list)
  
  index = 0                ;loop variable (nbr of array to add/plot)
  WHILE (index LT nbr_plot) DO BEGIN
  
    local_tfpData       = *tfpData[index]
    local_tfpData_error = *tfpData_error[index]
    scaling_factor      = scaling_factor_array[index]
    
    ;get only the central part of the data (when it's not the first one)
    IF (index NE 0) THEN BEGIN
;      local_tfpData      = FLOAT(local_tfpData[*,304L:2*304L-1])
;      local_tfpData_error = FLOAT(local_tfpData_error[*,304L:2*304L-1])
      local_tfpData      = FLOAT(local_tfpData[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1])
      local_tfpData_error = FLOAT(local_tfpData_error[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1])

    ENDIF
    
    ;apply scaling factor
    local_tfpData       /= scaling_factor
    local_tfpData_error /= scaling_factor
    
    IF (N_ELEMENTS(RESCALE) NE 0) THEN BEGIN
    
      Max  = (*global).zmax_g_recap
      ;        Max  = (*global).zmax_g
      fMax = DOUBLE(Max)
      
      index_GT = WHERE(local_tfpData GT fMax, nbr)
      IF (nbr GT 0) THEN BEGIN
        local_tfpData[index_GT]       = !VALUES.D_NAN
      ;        local_tfpData_error[index_GT] = !VALUES.D_NAN
      ENDIF
      
      Min  = (*global).zmin_g_recap
      ;      Min  = (*global).zmin_g
      fMin = DOUBLE(Min)
      
      index_LT = WHERE((local_tfpData LT fMin) AND $
        (FINITE(local_tfpDAta)), nbr1)
      IF (nbr1 GT 0) THEN BEGIN
        tmp = local_tfpData
        tmp[index_LT] = !VALUeS.D_NAN
        local_min = MIN(tmp,/NAN)
        local_tfpData[index_LT] = DOUBLE(0)
      ;       local_tfpData_error[index_LT] = DOUBLE(0)
      ENDIF ELSE BEGIN
        local_min = MIN(local_tfpData,/NAN)
      ENDELSE
      
    ENDIF ELSE BEGIN
    
      ;determine max and min
      local_max = MAX(local_tfpData,/NAN)
      local_min = MIN(local_tfpdata,/NAN)
      
    ENDELSE ;end of N_ELEMENTS(RESCALE)
    
    ;array that will be used to display counts
    local_tfpdata_untouched = local_tfpdata
    local_tfpdata_error_untouched = local_tfpdata_error
    
    ;check if user wants linear or logarithmic plot
    bLogPlot = isLogZaxisStep5Selected(Event)
    IF (bLogPlot) THEN BEGIN
    
      zero_index = WHERE(local_tfpData EQ 0, counts)
      IF (counts GT 0) THEN BEGIN
        local_tfpdata[zero_index] = !VALUES.D_NAN
      ENDIF
      
      local_min = MIN(local_tfpData,/NAN)
      local_max = MAX(local_tfpData,/NAN)
      
      local_tfpData = ALOG10(local_tfpData)
      
    ENDIF
    
    IF (index EQ 0) THEN BEGIN
      master_min = local_min
      master_max = local_max
    ENDIF ELSE BEGIN
      IF (local_min LT master_min) THEN master_min = local_min
      IF (local_max GT master_max) THEN master_max = local_max
    ENDELSE
    
    IF (index EQ 0) THEN BEGIN
    
      ;array that will serve as the background
      base_array           = local_tfpData
      base_array_error     = local_tfpData_error
      base_array_untouched = local_tfpData_untouched
      base_array_error_untouched = local_tfpDAta_error_untouched
      
    ENDIF ELSE BEGIN
      index_no_null = WHERE((local_tfpData NE 0) AND $
        (FINITE(local_tfpDAta)), nbr)
      IF (nbr NE 0) THEN BEGIN
      
        ;we will work only where the data are defined and not 0
        dims = SIZE(local_tfpdata,/DIMENSIONS)
        x_size = (size(local_tfpdata))(1)
        y_size = (size(local_tfpdata))(2)
        array_dimension = [x_size, y_size]
        index_indices = ARRAY_INDICES(dims,index_no_null,/DIMENSIONS)
        sz = (size(index_indices,/DIMENSION))[1]
; Code Change (RC Ward, 28 April, 2010): Define i as LONG or 32-bit integer. It was going beyond  32767 and
; going negative. So needed to be a LONG integer   
        i= LONG(0)
        WHILE (i LT sz-1) DO BEGIN       
          value_new = local_tfpdata[index_indices[0,i],index_indices[1,i]]
          value_old = base_array[index_indices[0,i],index_indices[1,i]]
          value_new_untouched = local_tfpdata_untouched[index_indices[0,i],$
            index_indices[1,i]]
            
          value_error_new = local_tfpdata_error[index_indices[0,i],index_indices[1,i]]
          value_error_old = base_array_error[index_indices[0,i],index_indices[1,i]]
          value_error_new_untouched = local_tfpdata_error_untouched[index_indices[0,i],$
            index_indices[1,i]]
               
          IF (value_old EQ 0) THEN BEGIN
          
            base_array[index_indices[0,i],index_indices[1,i]] = value_new
            base_array_untouched[index_indices[0,i],index_indices[1,i]] = $
              value_new_untouched
              
            base_array_error[index_indices[0,i],index_indices[1,i]] = $
              value_error_new
            base_array_error_untouched[index_indices[0,i],index_indices[1,i]] = $
              value_error_new_untouched
              
          ENDIF ELSE BEGIN
            IF (~FINITE(value_old)) THEN BEGIN
            
              base_array[index_indices[0,i],index_indices[1,i]] = value_new
              base_array_untouched[index_indices[0,i],index_indices[1,i]] = $
                value_new_untouched
                
              base_array_error[index_indices[0,i],index_indices[1,i]] = $
                value_error_new
              base_array_error_untouched[index_indices[0,i],index_indices[1,i]] = $
                value_error_new_untouched
                
            ENDIF ELSE BEGIN
              IF (value_new GT value_old) THEN BEGIN
              
                base_array[index_indices[0,i],index_indices[1,i]] = value_new
                base_array_untouched[index_indices[0,i],index_indices[1,i]] = $
                  value_new_untouched
                  
                base_array_error[index_indices[0,i],index_indices[1,i]] = $
                  value_error_new
                base_array_error_untouched[index_indices[0,i],index_indices[1,i]] = $
                  value_error_new_untouched
                  
              ENDIF
            ENDELSE
          ENDELSE
          i++
        ENDWHILE
      ENDIF
    ENDELSE
    
    ++index
    
  ENDWHILE
  
  (*global).zmax_g_recap = master_max
  (*global).zmin_g_recap = master_min
  ;  (*global).zmax_g = master_max
  ;  (*global).zmin_g = master_min
  
  ;rebin by 2 in y-axis final array
  rData = REBIN(base_array, $
    (size(base_array))(1)*x_coeff, $
    (size(base_array))(2)*y_coeff,/SAMPLE)
    
  ;  rData_error = REBIN(base_array_error, $
  ;    (size(base_array_error))(1)*x_coeff, $
  ;    (size(base_array_error))(2)*y_coeff,/SAMPLE)
    
  cleanup_array, rData
  total_array = rData
  
  (*(*global).total_array_error_untouched) = base_array_error_untouched
  (*(*global).total_array_untouched) = base_array_untouched
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  putTextFieldValue, Event, 'step5_zmax', (*global).zmax_g_recap, FORMAT='(e8.1)'
  putTextFieldValue, Event, 'step5_zmin', (*global).zmin_g_recap, FORMAT='(e8.1)'
  
  ;plot color scale
  plotColorScale_step5, Event, master_min, master_max ;_gui
  
  ;select plot
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  ;plot main plot
  TVSCL, total_array, /DEVICE
  
  xrange   = (*global).xscale.xrange
  xticks   = (*global).xscale.xticks
  position = (*global).xscale.position
  
  refresh_plot_scale_step5, $
    EVENT    = Event, $
    XSCALE   = xrange, $
    XTICKS   = xticks, $
    POSITION = position
    
END
; Change Code (RC Ward, 3 Jun 2010): Add rountine to plot the selection box on the plot for Step 5

PRO refresh_plotStep5Selection, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
print, "refresh_plotStep5Selection"

  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
xy_position = (*global).step5_selection_savefor_step4
xmin = xy_position[0]
ymin = xy_position[1]
xmax = xy_position[2]
ymax = xy_position[3]
print, " inside refresh_plotStep5Selection: xmin,xmax, ymin, ymax: ", xmin,xmax, ymin, ymax
ymin_plot = 2 * ymin
ymax_plot = 2* ymax
;IF (xmin + xmax NE 0) THEN BEGIN
    color = 200
    PLOTS, [xmin, xmin, xmax, xmax, xmin],$
      [ymin_plot,ymax_plot, ymax_plot, ymin_plot, ymin_plot],$
      /DEVICE,$
      COLOR = color
;ENDIF
END
; 
; Change Code (RC Ward, 3 Jun 2010): These routines added to implement the xmin,ymin, xmax,ymax
; control of the plot in STEP 5
;------------------------------------------------------------------------------
;This procedure is reached each time the user hits enter in one of the
;four text field xmin, ymin, xmax and ymax
  PRO move_selection_manually_step5, Event
    WIDGET_CONTROL, Event.top, GET_UVALUE=global

;work on Min values
    xmin = FIX(getStep5XminValue(Event))
    ymin = FIX(getStep5YminValue(Event))
;    ymin_to_test = 2*ymin
     ymin_to_test = ymin

;this make sure that we are not outside the window
;    physical_x_y, Event, xmin, ymin_to_test
;    ymin = ymin_to_test / 2

;work on Max values
    xmax = getStep5XmaxValue(Event)
    ymax = getStep5YmaxValue(Event)
;    ymax_to_test = 2*ymax
    ymax_to_test = ymax

;this make sure that we are not outside the window
;    physical_x_y, Event, xmax, ymax_to_test
;    ymax = ymax_to_test / 2

    xmin = MIN([xmin,xmax],MAX=xmax)
    ymin = MIN([ymin,ymax],MAX=ymax)

    (*global).step5_selection_savefor_step4 = [xmin, ymin_to_test, xmax, ymax_to_test]     

;refresh Step 5 plot
    refresh_recap_plot, Event, RESCALE=1  
;refresh selection plot
    refresh_plotStep5Selection, Event   

;put back the right values of xmin, ymin, xmax and ymax
    putXminStep5Value, Event, xmin
    putYminStep5Value, Event, ymin
    putXmaxStep5Value, Event, xmax
    putYmaxStep5Value, Event, ymax
END
; Change Code (RC Ward, 3 Jun 2010): These routines added to implement the xmin,ymin, xmax,ymax
; control of the plot in STEP 5
;PRO display_x_y_min_max_step5, Event, TYPE=type
;   WIDGET_CONTROL, Event.top, GET_UVALUE=global
;   IF (TYPE EQ 'left_click') THEN BEGIN
   ; type is left_click, display only xmin,ymin
;    selection_position = (*global).step4_step1_move_selection_position   
;      x0 = (*global).step5_x0
;      y0 = (*global).step5_y0
;      xmin = x0
;      ymin = y0/2
;      xmax = 'N/A'
;      ymax = 'N/A'
;  ENDIF ELSE BEGIN
  ; type is move, display xmin,xmax,ymin,ymax
  ;    xy_position = (*global).step4_step1_selection 
;      x0 = (*global).step5_x0
;      y0 = (*global).step5_y0
;      xmin = x0
;      ymin = y0/2
;      x1 = (*global).step5_x1
;      y1 = (*global).step5_y1
;      xmax = x1
;      ymax = y1/2
;      xmin = MIN([xmin,xmax],MAX=xmax)
;      ymin = MIN([ymin,ymax],MAX=ymax)

;  ENDELSE
; print, "test xmin, xmax, ymin, ymax: ", xmin, xmax, ymin, ymax
;  sxmin = STRCOMPRESS(xmin,/REMOVE_ALL)
;  symin = STRCOMPRESS(ymin,/REMOVE_ALL)
;  sxmax = STRCOMPRESS(xmax,/REMOVE_ALL)
;  symax = STRCOMPRESS(ymax,/REMOVE_ALL)

;  putTextfieldValue, Event, 'step5_selection_info_xmin_value', sxmin
;  putTextfieldValue, Event, 'step5_selection_info_ymin_value', symin
;  putTextfieldValue, Event, 'step5_selection_info_xmax_value', sxmax
;  putTextfieldValue, Event, 'step5_selection_info_ymax_value', symax

;END
; =============== END CHANGE  3 June 2010 ===============================================
