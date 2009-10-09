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

FUNCTION getSangleRowSelected, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_tab_table_uname')
  selection = WIDGET_INFO(id, /TABLE_SELECT)
  RETURN, selection[1]
END

;------------------------------------------------------------------------------
PRO display_data_run_in_sangle_base, Event
  row = getSangleRowSelected(Event)
  select_sangle_row, Event, row
END

;------------------------------------------------------------------------------
PRO select_sangle_first_run_number_by_default, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_tab_table_uname')
  WIDGET_CONTROL, id, SET_TABLE_SELECT=[0,0,1,1]
END

;------------------------------------------------------------------------------
PRO select_sangle_row, Event, row
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_tab_table_uname')
  WIDGET_CONTROL, id, SET_TABLE_SELECT=[0,row,1,row]
END

;------------------------------------------------------------------------------
PRO display_metatada_of_sangle_selected_row, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  reduce_run_sangle_table = (*(*global).reduce_run_sangle_table)
  reduce_tab1_table = (*(*global).reduce_tab1_table)
  
  ;get sangle row selected
  row_selected = getSangleRowSelected(Event)
  
  ;retrieve full nexus name of run selected
  full_nexus_file_name = reduce_tab1_table[1,row_selected]
  putTextFieldValue, Event, 'reduce_sangle_base_full_file_name', $
    full_nexus_file_name
    
  iNexus = OBJ_NEW('IDLgetMetadata_REF_M', full_nexus_file_name)
  dangle = STRCOMPRESS(iNexus->getDangle(),/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_sangle_base_dangle_value', dangle
  dangle0 = STRCOMPRESS(iNexus->getDangle0(),/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_sangle_base_dangle0_value', dangle0
  sangle = STRCOMPRESS(iNexus->getSangle(),/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_value', sangle
  dirpix = STRCOMPRESS(iNexus->getDirPix(),/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_sangle_base_dirpix_value', dirpix
  SampleDetDistance = STRCOMPRESS(iNexus->getSampleDetDist(),/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_sangle_base_sampledetdis_value', $
    SampleDetDistance
  refpix = '200'
  putTextFieldValue, event, 'reduce_sangle_base_refpix_value', refpix

  OBJ_DESTROY, iNexus
  
  
END

;------------------------------------------------------------------------------
;This procedures checks the working polarization states defined in the reduce
;tab1 and make the corresponding spin states in the sangle base enabled
PRO check_sangle_spin_state_buttons, Event

  spin_state_to_check = ['reduce_tab1_pola_1', $
    'reduce_tab1_pola_2',$
    'reduce_tab1_pola_3',$
    'reduce_tab1_pola_4']
    
  spin_state_to_change = ['reduce_sangle_1',$
    'reduce_sangle_2',$
    'reduce_sangle_3',$
    'reduce_sangle_4']
    
  nbr_spin_states = N_ELEMENTS(spin_state_to_check)
  
  ;will be 1 as soon as a sangle spin state has been selected
  sangle_spin_state_selected = 0
  FOR i=0,(nbr_spin_states-1) DO BEGIN
    IF (isButtonSelected(Event,spin_state_to_check[i])) THEN BEGIN
      enabled_status = 1
      IF (sangle_spin_state_selected EQ 0) THEN BEGIN
        id = WIDGET_INFO(Event.top, FIND_BY_UNAME=spin_state_to_change[i])
        WIDGET_CONTROL, id, /SET_BUTTON
        sangle_spin_state_selected = 1
      ENDIF
    ENDIF ELSE BEGIN
      enabled_status = 0
    ENDELSE
    activate_widget, Event, spin_state_to_change[i], enabled_status
  ENDFOR
  
END

;------------------------------------------------------------------------------
PRO   display_reduce_step1_sangle_scale, $
    MAIN_BASE=main_base, $
    EVENT=event, $
    global
    
  uname = 'reduce_sangle_y_scale'
  IF (N_ELEMENTS(EVENT) NE 0) THEN BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global
    id_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME=uname)
  ENDELSE
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  LOADCT, 0,/SILENT
  
  ;  IF (N_ELEMENTS(XSCALE) EQ 0) THEN xscale = [0,80]
  ;  IF (N_ELEMENTS(XTICKS) EQ 0) THEN xticks = 8
  ;  IF (N_ELEMENTS(POSITION) EQ 0) THEN BEGIN
  ;    sDraw = WIDGET_INFO(id,/GEOMETRY)
  position = [42,40,0,0]
  ;  ENDIF
  
  PLOT, RANDOMN(s,303L), $
    ;    XRANGE        = xscale,$
    YRANGE        = [0L,303L],$
    COLOR         = convert_rgb([0B,0B,255B]), $
    BACKGROUND    = convert_rgb((*global).sys_color_face_3d),$
    THICK         = 1, $
    TICKLEN       = -0.015, $
    ;    XTICKLAYOUT   = 0,$
    YTICKLAYOUT   = 0,$
    ;    XTICKS        = xticks,$
    YTICKS        = 25,$
    YSTYLE        = 1,$
    ;    XSTYLE        = 1,$
    YTICKINTERVAL = 10,$
    POSITION      = position,$
    NOCLIP        = 0,$
    /NODATA,$
    /DEVICE
    
    
    
    
    
END