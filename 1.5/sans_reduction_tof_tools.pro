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

PRO tof_tools_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  
  CASE Event.id OF
  
    ;display a predefined TOF range
    WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_mode_predefined_range'): BEGIN
      map_base, Event, 'display_tof_range_base', 1
      map_base, Event, 'play_tof_range_base', 0
      xmin = getTextFieldValue(Event,'mode1_from_tof_micros')
      xmax = getTextFieldValue(Event,'mode1_to_tof_micros')
      tof_range = (*global).tof_range
      tof_range.min = xmin
      tof_range.max = xmax
      (*global).tof_range = tof_range
      main_event = (*global_tof).main_event
      replot_counts_vs_tof, main_event
    END
    
    ;play TOFs
    WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_mode_play_tof'): BEGIN
      map_base, Event, 'display_tof_range_base', 0
      map_base, Event, 'play_tof_range_base', 1
      xmin = getTextFieldValue(Event,'mode2_from_tof_micros')
      xwidth = getTextFieldValue(Event,'tof_bin_size')
      tof_tof = (*(*global).array_of_tof_bins)
      xmax = tof_tof[xmin+xwidth]
      tof_range = (*global).tof_range
      tof_range.min = xmin
      tof_range.max = xmax
      (*global).tof_range = tof_range
      main_event = (*global_tof).main_event
      replot_counts_vs_tof, main_event
    END
    
    ;mode1: Display a predefined TOF range
    ;from tof
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode1_from_tof_micros'): BEGIN
      micros = getTextFieldValue(Event,'mode1_from_tof_micros')
      bin = convert_micros_to_bin(Event,micros)
      IF (bin EQ -1) THEN BEGIN ;outside of range
        micro_min = getTextFieldValue(Event,'mode1_from_tof_micros_help')
        micro_max = getTextFieldValue(Event,'mode1_to_tof_micros_help')
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
        putTextFieldValue, Event,'mode1_from_tof_bin', sbin
        xmin = getTextFieldValue(Event,'mode1_from_tof_micros')
        xmax = getTextFieldValue(Event,'mode1_to_tof_micros')
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
        
      ENDELSE
    END
    
    ;to tof
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode1_to_tof_micros'): BEGIN
      micros = getTextFieldValue(Event,'mode1_to_tof_micros')
      bin = convert_micros_to_bin(Event,micros)
      IF (bin EQ -1) THEN BEGIN ;outside of range
        micro_min = getTextFieldValue(Event,'mode1_from_tof_micros_help')
        micro_max = getTextFieldValue(Event,'mode1_to_tof_micros_help')
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
        putTextFieldValue, Event,'mode1_to_tof_bin', sbin
        xmin = getTextFieldValue(Event,'mode1_from_tof_micros')
        xmax = getTextFieldValue(Event,'mode1_to_tof_micros')
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
      ENDELSE
    END
    
    ;from bin
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode1_from_tof_bin'): BEGIN
      bin = getTextFieldValue(Event,'mode1_from_tof_bin')
      micros = convert_bin_to_micros(Event,bin)
      IF (micros EQ -1) THEN BEGIN ;outside of range
        bin_min = getTextFieldValue(Event,'mode1_from_tof_bin_help')
        bin_max = getTextFieldValue(Event,'mode1_to_tof_bin_help')
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
        putTextFieldValue, Event,'mode1_from_tof_micros', smicros
        xmin = getTextFieldValue(Event,'mode1_from_tof_micros')
        xmax = getTextFieldValue(Event,'mode1_to_tof_micros')
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
      ENDELSE
    END
    
    ;to bin
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode1_to_tof_bin'): BEGIN
      bin = getTextFieldValue(Event,'mode1_to_tof_bin')
      micros = convert_bin_to_micros(Event,bin)
      IF (micros EQ -1) THEN BEGIN ;outside of range
        bin_min = getTextFieldValue(Event,'mode1_from_tof_bin_help')
        bin_max = getTextFieldValue(Event,'mode1_to_tof_bin_help')
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
        putTextFieldValue, Event,'mode1_to_tof_micros', smicros
        xmin = getTextFieldValue(Event,'mode1_from_tof_micros')
        xmax = getTextFieldValue(Event,'mode1_to_tof_micros')
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
      ENDELSE
    END
    
    ;mode2: play tofs
    ;from tof
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode2_from_tof_micros'): BEGIN
      micros = getTextFieldValue(Event,'mode2_from_tof_micros')
      bin = convert_micros_to_bin(Event,micros)
      IF (bin EQ -1) THEN BEGIN ;outside of range
        micro_min = getTextFieldValue(Event,'mode2_from_tof_micros_help')
        micro_max = getTextFieldValue(Event,'mode2_to_tof_micros_help')
        text = ['INPUT ERROR',$
          STRCOMPRESS(micros,/REMOVE_ALL) + ' is outside of range',$
          micro_min + ' - ' + micro_max]
        id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_tools_widget_base')
        result = DIALOG_MESSAGE(text, $
          /CENTER,$
          DIALOG_PARENT=id,$
          /ERROR)
      ENDIF ELSE BEGIN
        sbin = STRCOMPRESS(bin,/REMOVE_ALL)
        putTextFieldValue, Event,'mode2_from_tof_bin', sbin
        xmin = getTextFieldValue(Event,'mode2_from_tof_micros')
        xwidth = getTextFieldValue(Event,'tof_bin_size')
        tof_tof = (*(*global).array_of_tof_bins)
        xmax = tof_tof[xmin+xwidth]
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
      ENDELSE
    END
    
    ;to tof
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode2_to_tof_micros'): BEGIN
      micros = getTextFieldValue(Event,'mode2_to_tof_micros')
      bin = convert_micros_to_bin(Event,micros)
      IF (bin EQ -1) THEN BEGIN ;outside of range
        micro_min = getTextFieldValue(Event,'mode2_from_tof_micros_help')
        micro_max = getTextFieldValue(Event,'mode2_to_tof_micros_help')
        text = ['INPUT ERROR',$
          STRCOMPRESS(micros,/REMOVE_ALL) + ' is outside of range',$
          micro_min + ' - ' + micro_max]
        id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_tools_widget_base')
        result = DIALOG_MESSAGE(text, $
          /CENTER,$
          DIALOG_PARENT=id,$
          /ERROR)
      ENDIF ELSE BEGIN
        sbin = STRCOMPRESS(bin,/REMOVE_ALL)
        putTextFieldValue, Event,'mode2_to_tof_bin', sbin
        xmin = getTextFieldValue(Event,'mode2_from_tof_micros')
        xwidth = getTextFieldValue(Event,'tof_bin_size')
        tof_tof = (*(*global).array_of_tof_bins)
        xmax = tof_tof[xmin+xwidth]
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
      ENDELSE
    END
    
    ;from bin
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode2_from_tof_bin'): BEGIN
      bin = getTextFieldValue(Event,'mode2_from_tof_bin')
      micros = convert_bin_to_micros(Event,bin)
      IF (micros EQ -1) THEN BEGIN ;outside of range
        bin_min = getTextFieldValue(Event,'mode2_from_tof_bin_help')
        bin_max = getTextFieldValue(Event,'mode2_to_tof_bin_help')
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
        putTextFieldValue, Event,'mode2_from_tof_micros', smicros
        xmin = getTextFieldValue(Event,'mode2_from_tof_micros')
        xwidth = getTextFieldValue(Event,'tof_bin_size')
        tof_tof = (*(*global).array_of_tof_bins)
        xmax = tof_tof[xmin+xwidth]
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
      ENDELSE
    END
    
    ;to bin
    WIDGET_INFO(Event.top, FIND_BY_UNAME='mode2_to_tof_bin'): BEGIN
      bin = getTextFieldValue(Event,'mode2_to_tof_bin')
      micros = convert_bin_to_micros(Event,bin)
      IF (micros EQ -1) THEN BEGIN ;outside of range
        bin_min = getTextFieldValue(Event,'mode2_from_tof_bin_help')
        bin_max = getTextFieldValue(Event,'mode2_to_tof_bin_help')
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
        putTextFieldValue, Event,'mode2_to_tof_micros', smicros
        xmin = getTextFieldValue(Event,'mode2_from_tof_micros')
        xwidth = getTextFieldValue(Event,'tof_bin_size')
        tof_tof = (*(*global).array_of_tof_bins)
        xmax = tof_tof[xmin+xwidth]
        tof_range = (*global).tof_range
        tof_range.min = xmin
        tof_range.max = xmax
        (*global).tof_range = tof_range
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
      ENDELSE
    END
    
    ;CLOSE button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_base_close_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='tof_tools_widget_base')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO tof_tools_launcher_base_gui, wBase, main_base_geometry

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset + 440
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'TOF tools',$
    UNAME        = 'tof_tools_widget_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE = 491,$
    SCR_XSIZE = 320,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  wBase1 = WIDGET_BASE(wBase,$
    SCR_YSIZE = 55,$
    /COLUMN)
    
  ;tof mode
  tof_mode = WIDGET_BASE(wBase1,$
    /COLUMN,$
    /EXCLUSIVE)
  button1 = WIDGET_BUTTON(tof_mode,$
    VALUE = 'Display a predefined TOF range',$
    /NO_RELEASE,$
    UNAME = 'tof_mode_predefined_range')
  button2 = WIDGET_BUTTON(tof_mode,$
    VALUE = 'Play TOFs',$
    /NO_RELEASE,$
    UNAME = 'tof_mode_play_tof')
  WIDGET_CONTROL, button1, /SET_BUTTON
  
  ;mode1 base (display a predefined tof range) -------------------------------
  mode11 = WIDGET_BASE(wBase,$
    XOFFSET = 10,$
    YOFFSET = 65,$
    UNAME = 'display_tof_range_base',$
    MAP = 1,$
    FRAME = 0)
    
  ;from label
  from = WIDGET_LABEL(mode11,$
    VALUE = 'FROM          OR',$
    XOFFSET = 5,$
    YOFFSET = 55)
    
  ;to label
  from = WIDGET_LABEL(mode11,$
    VALUE = 'TO           OR',$
    XOFFSET = 12,$
    YOFFSET = 185)
    
  mode1 = WIDGET_BASE(mode11,$
    /COLUMN)
  ;from
  row1 = WIDGET_BASE(mode1,$
    /ROW)
  space = WIDGET_LABEL(row1,$
    VALUE = ' ')
  from_base = WIDGET_BASE(row1,$
    FRAME = 1,$
    /COLUMN)
  row11 = WIDGET_BASE(from_base,$
    /ROW)
  label = WIDGET_LABEL(row11,$
    VALUE = '  TOF')
  text = CW_FIELD(row11,$
    TITLE= '',$
    /RETURN_EVENTS, $
    VALUE = '0.',$
    /FLOAT,$
    XSIZE = 7,$
    UNAME = 'mode1_from_tof_micros')
  label = WIDGET_LABEL(row11,$
    VALUE = 'microS')
  minhelp = WIDGET_LABEL(row11,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE =110,$
    UNAME = 'mode1_from_tof_micros_help')
    
  space = WIDGET_LABEL(from_base,$
    VALUE = ' ')
    
  row12 = WIDGET_BASE(from_base,$
    /ROW)
  label = WIDGET_LABEL(row12,$
    VALUE = 'Bin #')
  text = CW_FIELD(row12,$
    TITLE= '',$
    /RETURN_EVENTS, $
    VALUE = '0.',$
    /INTEGER,$
    XSIZE = 7,$
    UNAME = 'mode1_from_tof_bin')
  minhelp = WIDGET_LABEL(row12,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE = 110,$
    UNAME = 'mode1_from_tof_bin_help')
    
  ;TO
  row1 = WIDGET_BASE(mode1,$
    /ROW)
  space = WIDGET_LABEL(row1,$
    VALUE = ' ')
  to_base = WIDGET_BASE(row1,$
    FRAME = 1,$
    /COLUMN)
  row11 = WIDGET_BASE(to_base,$
    /ROW)
  label = WIDGET_LABEL(row11,$
    VALUE = '  TOF')
  text = CW_FIELD(row11,$
    TITLE= '',$
    /RETURN_EVENTS, $
    VALUE = '0.',$
    /FLOAT,$
    XSIZE = 7,$
    UNAME = 'mode1_to_tof_micros')
  label = WIDGET_LABEL(row11,$
    VALUE = 'microS')
  minhelp = WIDGET_LABEL(row11,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE = 110,$
    UNAME = 'mode1_to_tof_micros_help')
    
  space = WIDGET_LABEL(to_base,$
    VALUE = ' ')
    
  row12 = WIDGET_BASE(to_base,$
    /ROW)
  label = WIDGET_LABEL(row12,$
    VALUE = 'Bin #')
  text = CW_FIELD(row12,$
    TITLE= '',$
    /RETURN_EVENTS, $
    VALUE = '0.',$
    /INTEGER,$
    XSIZE = 7,$
    UNAME = 'mode1_to_tof_bin')
  minhelp = WIDGET_LABEL(row12,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE = 110,$
    UNAME = 'mode1_to_tof_bin_help')
    
  ;mode2 base (play tof) ;-----------------------------------------------------
  mode22 = WIDGET_BASE(wBase,$
    XOFFSET = 10,$
    YOFFSET = 65,$
    UNAME = 'play_tof_range_base',$
    MAP = 0,$
    FRAME = 0)
    
  ;from label
  from = WIDGET_LABEL(mode22,$
    VALUE = 'FROM          OR',$
    XOFFSET = 5,$
    YOFFSET = 55)
    
  ;to label
  from = WIDGET_LABEL(mode22,$
    VALUE = 'TO           OR',$
    XOFFSET = 12,$
    YOFFSET = 185)
    
  mode2 = WIDGET_BASE(mode22,$
    /COLUMN)
  ;from
  row1 = WIDGET_BASE(mode2,$
    /ROW)
  space = WIDGET_LABEL(row1,$
    VALUE = ' ')
  from_base = WIDGET_BASE(row1,$
    FRAME = 1,$
    /COLUMN)
  row11 = WIDGET_BASE(from_base,$
    /ROW)
  label = WIDGET_LABEL(row11,$
    VALUE = '  TOF')
  text = CW_FIELD(row11,$
    TITLE= '',$
    /RETURN_EVENTS, $
    VALUE = '0.',$
    /FLOAT,$
    XSIZE = 7,$
    UNAME = 'mode2_from_tof_micros')
  label = WIDGET_LABEL(row11,$
    VALUE = 'microS')
  minhelp = WIDGET_LABEL(row11,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE = 110,$
    UNAME = 'mode2_from_tof_micros_help')
    
  space = WIDGET_LABEL(from_base,$
    VALUE = ' ')
    
  row12 = WIDGET_BASE(from_base,$
    /ROW)
  label = WIDGET_LABEL(row12,$
    VALUE = 'Bin #')
  text = CW_FIELD(row12,$
    TITLE= '',$
    /RETURN_EVENTS, $
    VALUE = '0.',$
    /INTEGER,$
    XSIZE = 7,$
    UNAME = 'mode2_from_tof_bin')
  minhelp = WIDGET_LABEL(row12,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE = 110,$
    UNAME = 'mode2_from_tof_bin_help')
    
  ;TO
  row1 = WIDGET_BASE(mode2,$
    /ROW)
  space = WIDGET_LABEL(row1,$
    VALUE = ' ')
  to_base = WIDGET_BASE(row1,$
    FRAME = 1,$
    /COLUMN)
  row11 = WIDGET_BASE(to_base,$
    /ROW)
  label = WIDGET_LABEL(row11,$
    VALUE = '  TOF')
  text = CW_FIELD(row11,$
    TITLE= '',$
    VALUE = '0.',$
    /RETURN_EVENTS, $
    /FLOAT,$
    XSIZE = 7,$
    UNAME = 'mode2_to_tof_micros')
  label = WIDGET_LABEL(row11,$
    VALUE = 'microS')
  minhelp = WIDGET_LABEL(row11,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE = 110,$
    UNAME = 'mode2_to_tof_micros_help')
    
  space = WIDGET_LABEL(to_base,$
    VALUE = ' ')
    
  row12 = WIDGET_BASE(to_base,$
    /ROW)
  label = WIDGET_LABEL(row12,$
    VALUE = 'Bin #')
  text = CW_FIELD(row12,$
    /RETURN_EVENTS, $
    TITLE= '',$
    VALUE = '0.',$
    /INTEGER,$
    XSIZE = 7,$
    UNAME = 'mode2_to_tof_bin')
  minhelp = WIDGET_LABEL(row12,$ ;give minimum value to use
    VALUE = 'N/A',$
    SCR_XSIZE = 110,$
    UNAME = 'mode2_to_tof_bin_help')
    
  ;bins display size
  field = CW_FIELD(mode2,$
    VALUE = '10',$
    /INTEGER,$
    /RETURN_EVENTS, $
    UNAME = 'tof_bin_size',$
    XSIZE = 5,$
    TITLE = 'Nbr. of bins per frame:')
    
  ;time frame
  row = WIDGET_BASE(mode2,$
    /ROW)
  field = CW_FIELD(row,$
    VALUE = '1',$
    /FLOAT,$
    /RETURN_EVENTS, $
    UNAME = 'tof_bin_time',$
    XSIZE = 3,$
    TITLE = 'Displaying time of each frame: ')
  label = WIDGET_LABEL(row,$
    VALUE = 'seconds')
    
  ;new row for play, pause and stop buttons
  row = WIDGET_BASE(mode2,$
    /ROW)
  xsize = 92
  play = WIDGET_BUTTON(row,$
    VALUE = 'PLAY',$
    SCR_XSIZE = xsize,$
    UNAME = 'play_tof_button')
  pause = WIDGET_BUTTON(row,$
    VALUE = 'PAUSE',$
    SCR_XSIZE = xsize,$
    UNAME = 'pause_tof_button')
  stop = WIDGET_BUTTON(row,$
    VALUE = 'STOP',$
    SCR_XSIZE = xsize,$
    UNAME = 'stop_tof_button')
    
  ;close button
  close = WIDGET_BUTTON(wBase,$
    VALUE = ' CLOSE ',$
    SCR_XSIZE = 200,$
    UNAME = 'tof_base_close_button',$
    XOFFSET = 65,$
    YOFFSET = 455)
    
END

;------------------------------------------------------------------------------
PRO tof_tools_base, main_base=main_base, Event

  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase1 = ''
  tof_tools_launcher_base_gui, wBase1, $
    main_base_geometry
  (*global).tof_tools_base = wBase1
  
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_tof = PTR_NEW({ wbase: wbase1,$
    global: global,$
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_tof
  
  ;display_auto_base_launcher_images, main_base=wBase1, mode='off'
  
  XMANAGER, "tof_tools_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END

