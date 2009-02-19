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
  
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    print, 'Entering refresh_recap_plot'
  ENDIF
  
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
  
  trans_coeff_list = (*(*global).trans_coeff_list)
  
  index = 0                ;loop variable (nbr of array to add/plot
  WHILE (index LT nbr_plot) DO BEGIN
  
    local_tfpData       = *tfpData[index]
    local_tfpData_error = *tfpData_error[index]
    scaling_factor      = scaling_factor_array[index]
    
    ;get only the central part of the data (when it's not the first one)
    IF (index NE 0) THEN BEGIN
      local_tfpData      = FLOAT(local_tfpData[*,304L:2*304L-1])
      local_tfpData_eror = FLOAT(local_tfpData_error[*,304L:2*304L-1])
    ENDIF
    
    ;applied scaling factor
    local_tfpData       /= scaling_factor
    local_tfpData_error /= scaling_factor
    ;
    ;    IF (N_ELEMENTS(RESCALE) NE 0) THEN BEGIN
    ;
    ;      Max  = (*global).zmax_g_recap
    ;      fMax = DOUBLE(Max)
    ;      ;      fMax = -1e15
    ;      ;      print, 'fMax: ' + strcompress(fMax) ;remove_me
    ;
    ;      index_GT = WHERE(local_tfpData GT fMax, nbr)
    ;      IF (nbr GT 0) THEN BEGIN
    ;        local_tfpData[index_GT]       = !VALUES.D_NAN
    ;        local_tfpData_error[index_GT] = !VALUES.D_NAN
    ;      ENDIF
    ;
    ;      Min  = (*global).zmin_g_recap
    ;      fMin = DOUBLE(Min)
    ;      index_LT = WHERE(local_tfpData LT fMin, nbr1)
    ;      IF (nbr1 GT 0) THEN BEGIN
    ;        tmp = local_tfpData
    ;        tmp[index_LT] = !VALUeS.D_NAN
    ;        local_min = MIN(tmp,/NAN)
    ;        local_tfpData[index_LT] = DOUBLE(0)
    ;        local_tfpData_error[index_LT] = DOUBLE(0)
    ;      ENDIF ELSE BEGIN
    ;        local_min = MIN(local_tfpData,/NAN)
    ;      ENDELSE
    ;    ENDIF ;end of N_ELEMENTS(RESCALE)
    ;
    
    ;array that will be used to display counts
    local_tfpdata_untouched = local_tfpdata
    
    ;check if user wants linear or logarithmic plot
    bLogPlot = isLogZaxisStep5Selected(Event)
    IF (bLogPlot) THEN BEGIN
    
      zero_index = WHERE(local_tfpData EQ 0)
      local_tfpdata[zero_index] = !VALUES.F_NAN
      
      local_min = MIN(local_tfpData,/NAN)
      local_max = MAX(local_tfpData,/NAN)
      ;      min_array[index] = local_min
      ;      max_array[index] = local_max
      
      local_tfpData = ALOG10(local_tfpData)
      
    ;      print, 'before cleanup data'
    ;      help, local_tfpData
    ;      print, local_tfpData[100:250,300] ;remove_me
    ;
    ;      cleanup_array, local_tfpDAta ;_plot
    ;      print, 'after cleanup data'
    ;      help, local_tfpData
    ;      print, local_tfpData[100:250,300] ;remove_me
      
    ENDIF ELSE BEGIN
    
      local_min = MIN(local_tfpData,/NAN)
      local_max = MAX(local_tfpData,/NAN)
    ;      min_array[index] = local_min
    ;      max_array[index] = local_max
      
    ENDELSE
    
    ;     if (index eq 0) THEN begin
    ;          window,0, title='index 0'
    ;        endif else begin
    ;          window,1, title='index 1'
    ;        endelse
    ;        print, 'index: ' + strcompress(index)
    ;        help, local_tfpdata
    ;        cleanup_array, local_tfpdata
    ;        tvscl, local_tfpdata,/device
    ;        print
    ;
    IF (index EQ 0) THEN BEGIN
      ;array that will serve as the background
      base_array           = local_tfpData
      base_array_error     = local_tfpData_error
    ;      base_array_untouched = local_tfpData_untouched
    ;      ;size       = (size(total_array,/DIMENSIONS))[0]
    ;      ;max_size   = (size GT max_size) ? size : max_size
    ;      ;give master_min and master_max the values of local min and max
    ;      master_min = local_min
    ;      master_max = local_max
    ENDIF ELSE BEGIN
      index_no_null = WHERE((local_tfpData NE 0) AND $
        (FINITE(local_tfpDAta)), nbr)
      IF (nbr NE 0) THEN BEGIN
        dims = SIZE(local_tfpdata,/DIMENSIONS)
        x_size = (size(local_tfpdata))(1)
        y_size = (size(local_tfpdata))(2)
        array_dimension = [x_size, y_size]
        index_indices = ARRAY_INDICES(dims,index_no_null,/DIMENSIONS)
        sz = (size(index_indices,/DIMENSION))[1]
        i=0
        WHILE (i LT sz-1) DO BEGIN
          value_new = local_tfpdata[index_indices[0,i],index_indices[1,i]]
          value_old = base_array[index_indices[0,i],index_indices[1,i]]
          IF (value_old EQ 0) THEN BEGIN
            base_array[index_indices[0,i],index_indices[1,i]] = value_new
          ENDIF ELSE BEGIN
            IF (~FINITE(value_old)) THEN BEGIN
              base_array[index_indices[0,i],index_indices[1,i]] = value_new
            ENDIF ELSE BEGIN
              IF (value_new GT value_old) THEN BEGIN
                base_array[index_indices[0,i],index_indices[1,i]] = value_new
              ENDIF
            ENDELSE
          ENDELSE
          i++
        ENDWHILE
      ENDIF
    ENDELSE
    
    ;        ;loop through all the not null values and add them to the background
    ;        ;array if their value is greater than the background one
    ;        i = 0L
    ;
    ;        ;        print, local_tfpdata[50:200,150] ;remove_me
    ;        ;        help, local_tfpdata
    ;        ;        print
    ;        ;        print, base_array[50:200,150]
    ;        ;        help, base_array
    ;
    ;        WHILE(i LT sz) DO BEGIN
    ;          x = index_indices[0,i]
    ;          y = index_indices[1,i]
    ;          ;  print, 'x:' + strcompress(x) + ' y:' + strcompress(y) ;remove_me
    ;          value_new           = local_tfpData(x,y)
    ;          value_new_untouched = local_tfpData_untouched(x,y)
    ;          value_old           = base_array(x,y)
    ;          value_old_untouched = base_array_untouched(x,y)
    ;          print, 'value_new:' + string(value_new) + $
    ;            ' value_old:' + string(value_old)
    ;
    ;          IF (value_new GT value_old) THEN BEGIN
    ;            print, 'in thererererer'
    ;            base_array(x,y)           = value_new
    ;            base_array_error(x,y)     = local_tfpData_error(x,y)
    ;            base_array_untouched(x,y) = value_new_untouched
    ;
    ;
    ;
    ;    ;store x-axis end value
    ;    x_axis[index] = (size(local_tfpData,/DIMENSION))[0]
    ;
    ;    ;determine max and min value of y (over all the data arrays)
    ;    master_min = (local_min LT master_min) ? local_min : master_min
    ;    master_max = (local_max GT master_max) ? local_max : master_max
    ;
    ;    IF (index NE 0) THEN BEGIN
    ;      index_no_null = WHERE(local_tfpData NE 0,nbr)
    ;      IF (nbr NE 0) THEN BEGIN
    ;        index_indices = ARRAY_INDICES(local_tfpData,index_no_null)
    ;        sz = (size(index_indices,/DIMENSION))[1]
    ;        ;loop through all the not null values and add them to the background
    ;        ;array if their value is greater than the background one
    ;        i = 0L
    ;
    ;        ;        print, local_tfpdata[50:200,150] ;remove_me
    ;        ;        help, local_tfpdata
    ;        ;        print
    ;        ;        print, base_array[50:200,150]
    ;        ;        help, base_array
    ;
    ;        WHILE(i LT sz) DO BEGIN
    ;          x = index_indices[0,i]
    ;          y = index_indices[1,i]
    ;          ;  print, 'x:' + strcompress(x) + ' y:' + strcompress(y) ;remove_me
    ;          value_new           = local_tfpData(x,y)
    ;          value_new_untouched = local_tfpData_untouched(x,y)
    ;          value_old           = base_array(x,y)
    ;          value_old_untouched = base_array_untouched(x,y)
    ;          print, 'value_new:' + string(value_new) + $
    ;            ' value_old:' + string(value_old)
    ;
    ;          IF (value_new GT value_old) THEN BEGIN
    ;            print, 'in thererererer'
    ;            base_array(x,y)           = value_new
    ;            base_array_error(x,y)     = local_tfpData_error(x,y)
    ;            base_array_untouched(x,y) = value_new_untouched
    ;          ENDIF
    ;          ++i
    ;        ENDWHILE
    ;      ENDIF
    ;    ENDIF
    ;
    ++index
    
  ENDWHILE
  
  ;  print, 'leaving while loop' ;remove_me
  ;
  ;  ;  print, 'total array leaving the for loop' ;remove_me
  ;  ;  print, base_array[50:200,300] ;remove_me
  ;  ;  help, base_array
  ;
  ;rebin by 2 in y-axis final array
  rData = REBIN(base_array, $
    (size(base_array))(1)*x_coeff, $
    (size(base_array))(2)*y_coeff,/SAMPLE)
    
  cleanup_array, rData
  ;
  ;  rData_error = REBIN(base_array_error, $
  ;    (size(base_array_error))(1)*x_coeff, $
  ;    (size(base_array_error))(2)*y_coeff,/SAMPLE)
  ;
  total_array = rData
  ;
  ;  (*(*global).total_array_error) = base_array_error
  ;  (*(*global).total_array_untouched) = base_array_untouched
  ;
  ;  (*global).zmax_g_recap = master_max
  ;  (*global).zmin_g_recap = master_min
  ;
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  ;
  ;  print, '#1'
  ;
  ;  putTextFieldValue, Event, 'step5_zmax', (*global).zmax_g_recap, FORMAT='(e8.1)'
  ;  putTextFieldValue, Event, 'step5_zmin', (*global).zmin_g_recap, FORMAT='(e8.1)'
  ;
  ;  print, '#11'
  ;
  ;  ;plot color scale
  ;  ;plotColorScale_step5, Event, master_min, master_max ;_gui
  ;
  ;  print, '#2'
  ;
  ;select plot
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  ;
  ;  print, '#3'
  ;
  cleanup_array, total_array ;_plot
  ;
  ;  print, '#4'
  ;
  ;plot main plot
  TVSCL, total_array, /DEVICE
;  ;  print, 'Total Array:' ;remove_me
;  ;  print, total_array[50:200,150] ;remove_me
;  ;
;  xrange   = (*global).xscale.xrange
;  xticks   = (*global).xscale.xticks
;  position = (*global).xscale.position
;
;  print, '#5'
;
;  refresh_plot_scale_step5, $
;    EVENT    = Event, $
;    XSCALE   = xrange, $
;    XTICKS   = xticks, $
;    POSITION = position
;
;  print, '#6'
;
;  print, 'leaving refresh_recap_plot' ;remove_me
  
END
