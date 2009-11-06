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

PRO populate_tof_tools_base, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tof_counts = (*(*global).tof_counts)
  tof_tof = (*(*global).array_of_tof_bins)
  
  sz = N_ELEMENTS(tof_tof)
  
  tof_base = (*global).tof_tools_base
  
  ;populate 'display a predefined tof range'
  ;select everything by default
  default_from_tof = tof_tof[0]
  default_from_bin = 0
  default_to_tof = tof_tof[sz-1]
  default_to_bin = sz-1
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_from_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_to_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_from_bin
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_to_bin
  
  ;populate 'play tofs'
  ;select first 10 bins by default
  default_from_tof = tof_tof[0]
  default_from_bin = 0
  default_to_tof = tof_tof[sz-1]
  default_to_bin = sz-1
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_from_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_to_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_from_bin
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_to_bin
  
  ;populate min and max values the user can input
  ;Display a predefined TOF range and play tofs
  
  minstring = '(min: '
  maxstring = '(max: '
  
  tof_min_value = minstring + STRCOMPRESS(default_from_tof,/REMOVE_ALL) + ')'
  tof_max_value = maxstring + STRCOMPRESS(default_to_tof,/REMOVE_ALL) + ')'
  bin_min_value = minstring + $
    STRCOMPRESS(FIX(default_from_bin),/REMOVE_ALL) + ')'
  bin_max_value = maxstring + STRCOMPRESS(FIX(default_to_bin),/REMOVE_ALL) + ')'
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_max_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_max_value
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_max_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_max_value
  
END

;------------------------------------------------------------------------------
PRO turn_on_tof_mode, Event, MODE=mode
  IF (MODE EQ 1) THEN BEGIN ;mode1
    base1_status=1
    base2_status=0
  ENDIF ELSE BEGIN ;mode2
    base1_status=0
    base2_status=1
  ENDELSE
  map_base, Event, 'display_tof_range_base', base1_status
  map_base, Event, 'play_tof_range_base', base2_status
END

;------------------------------------------------------------------------------
PRO save_tof_min_max, Event, MODE=mode
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  IF (MODE EQ 1) THEN BEGIN ;mode1
    xmin = getTextFieldValue(Event,'mode1_from_tof_micros')
    xmax = getTextFieldValue(Event,'mode1_to_tof_micros')
  ENDIF ELSE BEGIN
    xmin = getTextFieldValue(Event,'mode2_from_tof_micros')
    xwidth = getTextFieldValue(Event,'tof_bin_size')
    tof_tof = (*(*global).array_of_tof_bins)
    xmax = tof_tof[xmin+xwidth]
  ENDELSE
  tof_range = (*global).tof_range
  tof_range.min = xmin
  tof_range.max = xmax
  (*global).tof_range = tof_range
END

;------------------------------------------------------------------------------
;This procedures takes the given argument form (from/to) (mode1/2) (bin/micros),
;calculates the equivalent in the other units (bin<->micros) and repopulates
;the other field from the same mode and type
PRO update_other_tof_field, Event, $
    MODE=mode, $  ;1 or 2
    AXIS=axis,$ ;'micros' or 'bin'
    TYPE=type ;'from' or 'to'

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
    
  CASE (MODE) OF
    1: mode_base = 'mode1_'
    2: mode_base = 'mode2_'
  ENDCASE
  
  CASE (TYPE) OF
    'from': BEGIN ;from
      CASE (AXIS) OF
        'micros': BEGIN ;micros
          micros = getTextFieldValue(Event,mode_base+'from_tof_micros')
          bin = convert_micros_to_bin(Event,micros)
          IF (bin EQ -1) THEN BEGIN ;outside of range
            micro_min = getTextFieldValue(Event,mode_base+'from_tof_micros_help')
            micro_max = getTextFieldValue(Event,mode_base+'to_tof_micros_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(micros,/REMOVE_ALL) + ' is outside of range',$
              micro_min + ' - ' + micro_max]
            id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_tools_widget_base')
            result = DIALOG_MESSAGE(text, $
              /CENTER, $
              DIALOG_PARENT=id,$
              /ERROR)
          ENDIF ELSE BEGIN
            sbin = STRCOMPRESS(bin,/REMOVE_ALL)
            putTextFieldValue, Event,mode_base+'from_tof_bin', sbin
            xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
            xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
          ENDELSE
        END
        'bin': BEGIN ;bin
          bin = getTextFieldValue(Event,mode_base+'from_tof_bin')
          micros = convert_bin_to_micros(Event,bin)
          IF (micros EQ -1) THEN BEGIN ;outside of range
            bin_min = getTextFieldValue(Event,mode_base+'from_tof_bin_help')
            bin_max = getTextFieldValue(Event,mode_base+'to_tof_bin_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(bin,/REMOVE_ALL) + ' is outside of range',$
              bin_min + ' - ' + bin_max]
            id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_tools_widget_base')
            result = DIALOG_MESSAGE(text, $
              /CENTER,$
              DIALOG_PARENT=id,$
              /ERROR)
          ENDIF ELSE BEGIN
            smicros = STRCOMPRESS(micros,/REMOVE_ALL)
            putTextFieldValue, Event,mode_base+'from_tof_micros', smicros
            xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
            xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
          ENDELSE
        END
      ENDCASE
    END
    'to': BEGIN ;to
      CASE (AXIS) OF
        'micros': BEGIN
          micros = getTextFieldValue(Event,mode_base+'to_tof_micros')
          bin = convert_micros_to_bin(Event,micros)
          IF (bin EQ -1) THEN BEGIN ;outside of range
            micro_min = getTextFieldValue(Event,mode_base+'from_tof_micros_help')
            micro_max = getTextFieldValue(Event,mode_base+'to_tof_micros_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(micros,/REMOVE_ALL) + ' is outside of range',$
              micro_min + ' - ' + micro_max]
            id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_tools_widget_base')
            result = DIALOG_MESSAGE(text, $
              /CENTER, $
              DIALOG_PARENT=id,$
              /ERROR)
          ENDIF ELSE BEGIN
            sbin = STRCOMPRESS(bin,/REMOVE_ALL)
            putTextFieldValue, Event,mode_base+'to_tof_bin', sbin
            xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
            xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
          ENDELSE
        END
        'bin': BEGIN
          bin = getTextFieldValue(Event,mode_base+'to_tof_bin')
          micros = convert_bin_to_micros(Event,bin)
          IF (micros EQ -1) THEN BEGIN ;outside of range
            bin_min = getTextFieldValue(Event,mode_base+'from_tof_bin_help')
            bin_max = getTextFieldValue(Event,mode_base+'to_tof_bin_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(bin,/REMOVE_ALL) + ' is outside of range',$
              bin_min + ' - ' + bin_max]
            id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_tools_widget_base')
            result = DIALOG_MESSAGE(text, $
              /CENTER,$
              DIALOG_PARENT=id,$
              /ERROR)
          ENDIF ELSE BEGIN
            smicros = STRCOMPRESS(micros,/REMOVE_ALL)
            putTextFieldValue, Event,mode_base+'to_tof_micros', smicros
            xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
            xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
          ENDELSE
        END
      ENDCASE
    END
  ENDCASE
  
  tof_range = (*global).tof_range
  tof_range.min = xmin
  tof_range.max = xmax
  (*global).tof_range = tof_range
  main_event = (*global_tof).main_event
  replot_counts_vs_tof, main_event
  
END

