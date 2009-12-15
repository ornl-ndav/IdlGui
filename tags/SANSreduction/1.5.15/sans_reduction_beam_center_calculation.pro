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

PRO beam_center_calculation, EVENT=Event, BASE=base

  IF (N_ELEMENTS(Event) NE 0) THEN BEGIN
  
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    ;retrieve 2d array of data defined by calculation range
    data = retrieve_calculation_range(Event=event)
    
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH, /CANCEL
      title = 'Calculation of Beam Center ERROR !'
      text = [' Error in calculation of Pixel Beam Center.', $
        '',$
        'Please select a different Calculation Range',$
        '                  or', $
        'manually input the tube beam center value!']
      parent_id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='beam_center_calculation_base')
      result = DIALOG_MESSAGE(text, $
        title = title, $
        /ERROR, $
        DIALOG_PARENT = parent_id)
      putTextFieldValue, Event, 'beam_center_pixel_center_value', 'N/A'
    ENDIF ELSE BEGIN
      ;calculate beam center pixel
      beam_center_pixel_calculation, event=Event, DATA=data
      CATCH, /CANCEL
    ENDELSE
    
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH, /CANCEL
      title = 'Calculate of Beam Center ERROR !'
      text = [' Error in calculation of Tube Beam Center.', $
        '',$
        'Please select a different Calculation Range!', $
        '                  or', $
        'manually input the pixel beam center value!']
      parent_id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='beam_center_calculation_base')
      result = DIALOG_MESSAGE(text, $
        title = title, $
        /ERROR, $
        DIALOG_PARENT = parent_id)
      putTextFieldValue, Event, 'beam_center_tube_center_value', 'N/A'
    ENDIF ELSE BEGIN
      ;calculate beam center tube
      beam_center_tube_calculation, event=Event, DATA=data
      CATCH, /CANCEL
    ENDELSE
    
  ENDIF ELSE BEGIN
  
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
    
    ;retrieve 2d array of data defined by calculation range
    data = retrieve_calculation_range(base=base)
    
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH, /CANCEL
      title = 'Calculate Beam Center ERROR !'
      text = 'Please select a different Calculation Range!'
      parent_id = WIDGET_INFO(base, $
        FIND_BY_UNAME='beam_center_calculation_base')
      result = DIALOG_MESSAGE(text, $
        title = title, $
        /ERROR, $
        DIALOG_PARENT = parent_id)
      IF (N_ELEMENTS(event) NE 0) THEN BEGIN
        putTextFieldValue, Event, 'beam_center_tube_center_value', 'N/A'
      ENDIF ELSE BEGIN
        putTextFieldValueMainBase, base, $
          uname='beam_center_tube_center_value', $
          'N/A'
      ENDELSE
    ENDIF ELSE BEGIN
      ;calculate beam center pixel
      beam_center_pixel_calculation, base=base, DATA=data
      ;calculate beam center tube
      beam_center_tube_calculation, base=base, DATA=data
      CATCH, /CANCEL
    ENDELSE
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
;return array without -1 values
FUNCTION cleanup_bc_array, array
  index = WHERE(array GT -1)
  RETURN, array[index]
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;calculate beam center tube
PRO beam_center_tube_calculation, Event=event, base=base, DATA=data

  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
  
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    bc_up_tube_front = beam_center_tube_calculation_function (Event=event, $
      MODE='up', BANK='front', DATA=data)
      
    bc_up_tube_back = beam_center_tube_calculation_function (Event=event, $
      MODE='up', BANK='back', DATA=data)
      
    bc_down_tube_front = beam_center_tube_calculation_function (Event=event, $
      MODE='down', BANK='front', DATA=data)
      
    bc_down_tube_back = beam_center_tube_calculation_function (Event=event, $
      MODE='down', BANK='back', DATA=data)
      
    ;remove -1 value from up and down arrays
    bc_up_tube_front_array = cleanup_bc_array(bc_up_tube_front)
    bc_up_tube_back_array  = cleanup_bc_array(bc_up_tube_back)
    bc_down_tube_front_array = cleanup_bc_array(bc_down_tube_front)
    bc_down_tube_back_array  = cleanup_bc_array(bc_down_tube_back)
    
    algo_selected = getAlgoSelected(Event=event, type='tube') ;1, 10 or 100
    ;calculate average value of both arrays
    CASE (algo_selected) OF
      1: BEGIN
        big_front_array = bc_up_tube_front_array
        big_back_array = bc_up_tube_back_array
      END
      10: BEGIN
        big_front_array = bc_down_tube_front_array
        big_back_array = bc_down_tube_back_array
      END
      100: BEGIN
        big_front_array = [bc_up_tube_front_array, bc_down_tube_front_array]
        big_back_array  = [bc_up_tube_back_array, bc_down_tube_back_array]
      END
    ENDCASE
    
    bc_tube_front = MEAN(big_front_array) + (*global).calculation_range_offset.tube
    bc_tube_back = MEAN(big_back_array) + (*global).calculation_range_offset.tube
    
    ;put value in its box
    mean_value = MEAN([bc_tube_front, bc_tube_back])
    putTextFieldValue, Event, 'beam_center_tube_center_value', $
      STRCOMPRESS(mean_value,/REMOVE_ALL)
      
  ENDIF ELSE BEGIN
  
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
    
    bc_up_tube_front = beam_center_tube_calculation_function (base=base, $
      MODE='up', BANK='front', DATA=data)
      
    bc_up_tube_back = beam_center_tube_calculation_function (base=base, $
      MODE='up', BANK='back', DATA=data)
      
    bc_down_tube_front = beam_center_tube_calculation_function (base=base, $
      MODE='down', BANK='front', DATA=data)
      
    bc_down_tube_back = beam_center_tube_calculation_function (base=base, $
      MODE='down', BANK='back', DATA=data)
      
    ;  ;remove -1 value from up and down arrays
    bc_up_tube_front_array = cleanup_bc_array(bc_up_tube_front)
    bc_up_tube_back_array  = cleanup_bc_array(bc_up_tube_back)
    bc_down_tube_front_array = cleanup_bc_array(bc_down_tube_front)
    bc_down_tube_back_array  = cleanup_bc_array(bc_down_tube_back)
    
    algo_selected = getAlgoSelected(base=base, type='tube') ;1, 10 or 100
    ;calculate average value of both arrays
    CASE (algo_selected) OF
      1: BEGIN
        big_front_array = bc_up_tube_front_array
        big_back_array = bc_up_tube_back_array
      END
      10: BEGIN
        big_front_array = bc_down_tube_front_array
        big_back_array = bc_down_tube_back_array
      END
      100: BEGIN
        big_front_array = [bc_up_tube_front_array, bc_down_tube_front_array]
        big_back_array  = [bc_up_tube_back_array, bc_down_tube_back_array]
      END
    ENDCASE

    bc_tube_front = MEAN(big_front_array) + (*global).calculation_range_offset.tube
    bc_tube_back = MEAN(big_back_array) + (*global).calculation_range_offset.tube
    
    ;put value in its box
    mean_value = MEAN([bc_tube_front, bc_tube_back])
    putTextFieldValueMainBase, base, UNAME='beam_center_tube_center_value', $
      STRCOMPRESS(mean_value,/REMOVE_ALL)
      
  ENDELSE
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;Work on PIXELS
PRO beam_center_pixel_calculation, Event=event, base=base, DATA=data

  IF (N_ELEMENTS(event) NE 0) THEN BEGIN ;event
  
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    ;calculate beam center pixel starting at the bottom (pixel_min)
    bc_up_pixel = beam_center_pixel_calculation_function(Event=event, $
      MODE='up', DATA=data)
      
    ;calculate beam center pixel starting at the top (pixel_max)
    bc_down_pixel = beam_center_pixel_calculation_function(Event=event, $
      MODE='down', DATA=data)
      
    algo_selected = getAlgoSelected(Event=event, type='pixel') ;1, 10 or 100
    
  ENDIF ELSE BEGIN
  
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
    
    ;calculate beam center pixel starting at the bottom (pixel_min)
    bc_up_pixel = beam_center_pixel_calculation_function(base=base, $
      MODE='up', DATA=data)
      
    ;calculate beam center pixel starting at the top (pixel_max)
    bc_down_pixel = beam_center_pixel_calculation_function(base=base, $
      MODE='down', DATA=data)
      
    algo_selected = getAlgoSelected(base=base, type='pixel') ;1, 10 or 100
    
  ENDELSE
  
  ;remove -1 value from up and down arrays
  bc_up_pixel_array = cleanup_bc_array(bc_up_pixel)
  bc_down_pixel_array = cleanup_bc_array(bc_down_pixel)
  
  ;calculate average value of both arrays
  CASE (algo_selected) OF
    1: big_bc_array = bc_up_pixel_array
    10: big_bc_array = bc_down_pixel_array
    100: big_bc_array = [bc_up_pixel_array, bc_down_pixel_array]
  ENDCASE
  
  ;  big_bc_array = [bc_up_pixel_array,bc_down_pixel_array]
  ;big_bc_array = bc_down_pixel_array
  bc_pixel = MEAN(big_bc_array) + (*global).calculation_range_offset.pixel
  
  ;put value in its box
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
    putTextFieldValue, Event, 'beam_center_pixel_center_value', $
      STRCOMPRESS(bc_pixel,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    putTextFieldValueMainBase, base, uname='beam_center_pixel_center_value', $
      STRCOMPRESS(bc_pixel,/REMOVE_ALL)
  ENDELSE
  
END