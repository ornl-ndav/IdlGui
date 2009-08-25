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

;------------------------------------------------------------------------------
PRO plot_default_beam_center_selections, BASE=base, GLOBAL=global

  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(base,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, DECOMPOSED=1
  
  ;  ;Calibration Range ..........................................................
  ;  tube_min_data = (*global).calibration_range_default_selection.tube_min
  ;  tube_max_data = (*global).calibration_range_default_selection.tube_max
  ;  pixel_min_data = (*global).calibration_range_default_selection.pixel_min
  ;  pixel_max_data = (*global).calibration_range_default_selection.pixel_max
  ;
  ;  ;adding +1 for max to have the all tube/pixel included in the selection
  ;  x_min = getBeamCenterTubeDevice_from_data(tube_min_data, global)
  ;  x_max = getBeamCenterTubeDevice_from_data(tube_max_data+1, global)
  ;  y_min = getBeamCenterPixelDevice_from_data(pixel_min_data, global)
  ;  y_max = getBeamCenterPixelDevice_from_data(pixel_max_data+1, global)
  ;
  ;  color = (*global).calibration_range_default_selection.color
  ;  thick = (*global).calibration_range_default_selection.thick
  ;  color = convert_rgb(color)
  ;
  ;  PLOTS, x_min, y_min, /DEVICE, COLOR=color
  ;  PLOTS, x_min, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  ;  PLOTS, x_max, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  ;  PLOTS, x_max, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  ;  PLOTS, x_min, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  
  ;Beam stop region ...........................................................
  tube_min_data = (*global).beam_stop_default_selection.tube_min
  tube_max_data = (*global).beam_stop_default_selection.tube_max
  pixel_min_data = (*global).beam_stop_default_selection.pixel_min
  pixel_max_data = (*global).beam_stop_default_selection.pixel_max
  
  ;adding +1 for max to have the all tube/pixel included in the selection
  x_min = getBeamCenterTubeDevice_from_data(tube_min_data, global)
  x_max = getBeamCenterTubeDevice_from_data(tube_max_data+1, global)
  y_min = getBeamCenterPixelDevice_from_data(pixel_min_data, global)
  y_max = getBeamCenterPixelDevice_from_data(pixel_max_data+1, global)
  
  color = (*global).beam_stop_default_selection.color
  thick = (*global).beam_stop_default_selection.thick
  color = convert_rgb(color)
  
  PLOTS, x_min, y_min, /DEVICE, COLOR=color
  PLOTS, x_min, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  PLOTS, x_max, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  PLOTS, x_max, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  PLOTS, x_min, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, THICK=thick
  
  ;  ;calculation range.........................................................
  ;  tube_data  = (*global).calculation_range_default.tube
  ;  pixel_data = (*global).calculation_range_default.pixel
  ;  tube  = getBeamCenterTubeDevice_from_data(tube_data, global)
  ;  pixel = getBeamCenterPixelDevice_from_data(pixel_data, global)
  ;
  ;  color = (*global).calculation_range_default.color
  ;  thick = (*global).calculation_range_default.thick
  ;
  ;  IF ((*global).calculation_range_tab_mode EQ 'tube1' OR $
  ;    (*global).calculation_range_tab_mode EQ 'tube2') THEN BEGIN
  ;    tube_linestyle = (*global).calculation_range_default.working_linestyle
  ;    pixel_linestyle = (*global).calculation_range_default.not_working_linestyle
  ;  ENDIF ELSE BEGIN
  ;    tube_linestyle = (*global).calculation_range_default.not_working_linestyle
  ;    pixel_linestyle = (*global).calculation_range_default.working_linestyle
  ;  ENDELSE
  ;  color = convert_rgb(color)
  ;
  ;  x_min = 0
  ;  y_min = 0
  ;  x_max = (*global).main_draw_xsize
  ;  y_max = (*global).main_draw_ysize
  ;
  ;  PLOTS, 0, pixel, /DEVICE, COLOR=color
  ;  PLOTS, x_max, pixel, /DEVICE, COLOR=color, /CONTINUE, $
  ;    LINESTYLE=tube_linestyle, $
  ;    THICK=thick
  ;
  ;  PLOTS, tube, 0, /DEVICE, COLOR=color
  ;  PLOTS, tube, y_max, /DEVICE, COLOR=color, /CONTINUE, $
  ;    LINESTYLE=pixel_linestyle, $
  ;    THICK=thick
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO plot_calculation_range_selection, Event

  Tube1 = getTextFieldValue(Event,'tube1_button_value')
  Tube2 = getTextFieldValue(Event,'tube2_button_value')
  Pixel1 = getTextFieldValue(Event,'pixel1_button_value')
  Pixel2 = getTextFieldValue(Event,'pixel2_button_value')
  
  ON_IOERROR, leave
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x_min = 0
  y_min = 0
  x_max = (*global).main_draw_xsize
  y_max = (*global).main_draw_ysize
  
  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, DECOMPOSED=1
  
  color = (*global).calibration_range_default_selection.color_selected
  thick = (*global).calibration_range_default_selection.thick_selected
  linestyle = (*global).calibration_range_default_selection.linestyle
  color = convert_rgb(color)
  
  IF (Tube1 NE 'N/A') THEN BEGIN ;plot Tube1
    iTube1 = FIX(Tube1)
    x = getBeamCenterTubeDevice_from_data(iTube1, global)
    PLOTS, x, y_min, /DEVICE, COLOR=color
    PLOTS, x, y_max, /DEVICE, COLOR=color, /CONTINUE, $
      LINESTYLE=linestyle, THICK=thick
  ENDIF
  
  IF (Tube1 NE 'N/A') THEN BEGIN ;plot Tube2
    iTube2 = FIX(Tube2)
    x = getBeamCenterTubeDevice_from_data(iTube2, global)
    PLOTS, x, y_min, /DEVICE, COLOR=color
    PLOTS, x, y_max, /DEVICE, COLOR=color, /CONTINUE, $
      LINESTYLE=linestyle, THICK=thick
  ENDIF
 
  IF (Pixel1 NE 'N/A') THEN BEGIN ;plot Pixel1
    iPixel1 = FIX(Pixel1)
    y = getBeamCenterPixelDevice_from_data(iPixel1, global)
    PLOTS, x_min, y, /DEVICE, COLOR=color
    PLOTS, x_max, y, /DEVICE, COLOR=color, /CONTINUE, $
      LINESTYLE=linestyle, THICK=thick
  ENDIF

  IF (Pixel2 NE 'N/A') THEN BEGIN ;plot Pixel2
    iPixel2 = FIX(Pixel2)
    y = getBeamCenterPixelDevice_from_data(iPixel2, global)
    PLOTS, x_min, y, /DEVICE, COLOR=color
    PLOTS, x_max, y, /DEVICE, COLOR=color, /CONTINUE, $
      LINESTYLE=linestyle, THICK=thick
  ENDIF

  leave:
  
  DEVICE, DECOMPOSED=0
  
END

