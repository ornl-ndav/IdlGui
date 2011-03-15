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

PRO inverse_y_selection, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  y_roi_status = (*global).norm_roi_y_selected
  IF (y_roi_status EQ 'left') THEN BEGIN
    (*global).norm_roi_y_selected = 'right'
    y1_l = '  '
    y1_r = '  '
    y2_l = '>>'
    y2_r = '<<'
  ENDIF ElSE BEGIN
    (*global).norm_roi_y_selected = 'left'
    y2_l = '  '
    y2_r = '  '
    y1_l = '>>'
    y1_r = '<<'
  ENDELSE
  
  putTextFieldValue, event, 'reduce_step2_create_roi_y1_l_status', y1_l
  putTextFieldValue, event, 'reduce_step2_create_roi_y1_r_status', y1_r
  putTextFieldValue, event, 'reduce_step2_create_roi_y2_l_status', y2_l
  putTextFieldValue, event, 'reduce_step2_create_roi_y2_r_status', y2_r
  
END

;------------------------------------------------------------------------------
PRO plot_reduce_step2_roi, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, error
  
  y_rebin_value = (*global).reduce_rebin_roi_rebin_y
  y_roi_status = (*global).norm_roi_y_selected
  
  case (y_roi_status) OF
    'left': BEGIN ;changing Y1 and replot Y2 (if any)
      Y1 = EVENT.y
      IF (y1 GE 0 AND $
        ;        y1 LE 303L*y_rebin_value) THEN BEGIN
        y1 LE ((*global).detector_pixels_y-1)*y_rebin_value) THEN BEGIN
        plot_reduce_step2_roi_y, Event, Y1
        y1 = FIX(DOUBLE(Y1)/DOUBLE(y_rebin_value))
        putTextFieldValue, Event, 'reduce_step2_create_roi_y1_value', $
          STRCOMPRESS(y1,/REMOVE_ALL)
      ENDIF
      
      plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y2_value'
      
    END
    'right': BEGIN ;changing Y2 and replot Y1 (if any)
      Y2 = EVENT.y
      plot_reduce_step2_roi_y, Event, Y2
      IF (y2 GE 0 AND $
        ;        y2 LE 303*y_rebin_value) THEN BEGIN
        y2 LE ((*global).detector_pixels_y-1)*y_rebin_value) THEN BEGIN
        y2 = FIX(DOUBLE(Y2)/DOUBLE(y_rebin_value))
        putTextFieldValue, Event, 'reduce_step2_create_roi_y2_value', $
          STRCOMPRESS(y2,/REMOVE_ALL)
      ENDIF
      
      plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y1_value'
      
    END
    ELSE:
  ENDCASE
  
  error:
  
END

;------------------------------------------------------------------------------
PRO plot_reduce_step2_roi_y, Event, rY

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  color = (*global).reduce_step2_roi_color
  
  PLOTS, 0, ry, /device, color=color
  PLOTS, ((*global).reduce_step2_norm_tof-1), ry, /device, /continue, color=color
  
END

;------------------------------------------------------------------------------
PRO plot_reduce_step2_y, event, uname=uname

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  y_rebin_value = (*global).reduce_rebin_roi_rebin_y
  
  ON_IOERROR, error
  
  Y2 = getTextFieldValue(Event,uname)
  IF (Y2 NE '') THEN BEGIN
    y2 = FIX(y2)
    ;    IF (y2 GT 303) THEN RETURN
    IF (y2 GT (*global).detector_pixels_y-1) THEN RETURN
    plot_reduce_step2_roi_y, Event, Y2*(y_rebin_value)
  ENDIF
  
  error:
  
END

;------------------------------------------------------------------------------
PRO reduce_step2_manual_move, Event, key=key

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  y_roi_status = (*global).norm_roi_y_selected
  CASE (y_roi_status) OF
    'left': BEGIN
      Y1 = getTextFieldValue(Event,'reduce_step2_create_roi_y1_value')
      y1 = FIX(Y1)
      ;      IF (key EQ 'up') THEN BEGIN
      ;        y1++
      ;      ENDIF ELSE BEGIN
      ;        y1--
      ;      ENDELSE
      IF (y1 GE 0 AND $
        ;        y1 LE 303) THEN BEGIN
        y1 LE (*global).detector_pixels_y-1) THEN BEGIN
        sY1 = STRCOMPRESS(y1,/REMOVE_ALL)
        putTextFieldValue, Event, 'reduce_step2_create_roi_y1_value', sY1
      ENDIF
      plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y1_value'
      plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y2_value'
    END
    
    'right': BEGIN
      Y2 = getTextFieldValue(Event,'reduce_step2_create_roi_y2_value')
      y2 = FIX(Y2)
      ;      IF (key EQ 'up') THEN BEGIN
      ;        y2++
      ;      ENDIF ELSE BEGIN
      ;        y2--
      ;      ENDELSE
      IF (y2 GE 0 AND $
        ;        y2 LE 303) THEN BEGIN
        y2 LE (*global).detector_pixels_y-1) THEN BEGIN
        
        sY2 = STRCOMPRESS(y2,/REMOVE_ALL)
        putTextFieldValue, Event, 'reduce_step2_create_roi_y2_value', sY2
      ENDIF
      plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y1_value'
      plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y2_value'
    END
    
    'all':BEGIN
    
    ON_IOERROR, y1_error
    
    Y1 = getTextFieldValue(Event,'reduce_step2_create_roi_y1_value')
    y1 = FIX(Y1)
    plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y1_value'
    
    y1_error:
    
    ON_IOERROR, y2_error
    
    Y2 = getTextFieldValue(Event,'reduce_step2_create_roi_y2_value')
    y2 = FIX(Y2)
    plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y2_value'
    
    y2_error:
    
  END
  ELSE:
ENDCASE

END

pro reduce_step2_plot_rois, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;peak
  peak_y1 = getTextFieldValue(event,'reduce_step2_create_roi_y1_value')
  peak_y2 = getTextFieldValue(event,'reduce_step2_create_roi_y2_value')
  back_y1 = getTextFieldValue(event,'reduce_step2_create_back_roi_y1_value')
  back_y2 = getTextFieldValue(event,'reduce_step2_create_back_roi_y2_value')
  
  ymin = 0
  ymax = (*global).detector_pixels_y-1
  y_rebin_value = (*global).reduce_rebin_roi_rebin_y
  
  
  if (peak_y1 ne '' && peak_y2 ne '') then begin
  
    peak_y1 = fix(peak_y1)
    peak_y2 = fix(peak_y2)
    
    peak_y1 = (peak_y1 gt ymax) ? ymax : peak_y1
    peak_y2 = (peak_y2 gt ymax) ? ymax : peak_y2
    peak_y1 = (peak_y1 lt ymin) ? ymin : peak_y1
    peak_y2 = (peak_y2 lt ymin) ? ymin : peak_y2
    
    ;peak
    PLOTS, 0, y_rebin_value * peak_y1, /device, color=color
    PLOTS, ((*global).reduce_step2_norm_tof-1), y_rebin_value * peak_y1, $
      /device, $
      /continue, color=fsc_color('white')
      
    PLOTS, 0, y_rebin_value * peak_y2, /device, color=color
    PLOTS, ((*global).reduce_step2_norm_tof-1), y_rebin_value * peak_y2, $
      /device, $
      /continue, color=fsc_color('white')
      
  endif
  
  help, back_y1
  help, back_y2
  print, back_y1
  print, back_y2
  
  if (strcompress(back_y1,/remove_all) ne '' and $
  strcompress(back_y2,/remove_all) ne '') then begin
  
    back_y1 = fix(back_y1)
    back_y2 = fix(back_y2)
    
    back_y1 = (back_y1 gt ymax) ? ymax : back_y1
    back_y2 = (back_y2 gt ymax) ? ymax : back_y2
    back_y1 = (back_y1 lt ymin) ? ymin : back_y1
    back_y2 = (back_y2 lt ymin) ? ymin : back_y2
    
    ;back
    PLOTS, 0, y_rebin_value * back_y1, /device, color=color
    PLOTS, ((*global).reduce_step2_norm_tof-1), y_rebin_value * back_y1, $
      /device, $
      /continue, color=fsc_color('red')
      
    PLOTS, 0, y_rebin_value * back_y2, /device, color=color
    PLOTS, ((*global).reduce_step2_norm_tof-1), y_rebin_value * back_y2, $
      /device, $
      /continue, color=fsc_color('red')
      
  endif
  
  
end








