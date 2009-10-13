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

FUNCTION retrieve_nexus_data, FullNexusName, spin_state, data

  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
  ENDIF ELSE BEGIN
    fileID    = H5F_OPEN(FullNexusName)
    data_path = '/entry-' + spin_state + '/bank1/data'
    fieldID = H5D_OPEN(fileID,data_path)
    data = H5D_READ(fieldID)
    RETURN, 1
  ENDELSE
  
END

;------------------------------------------------------------------------------
FUNCTION retrieve_tof_from_nexus_data, FullNexusName, spin_state, tof

  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
  ENDIF ELSE BEGIN
    fileID    = H5F_OPEN(FullNexusName)
    tof_path = '/entry-' + spin_state + '/bank1/time_of_flight'
    fieldID = H5D_OPEN(fileID,tof_path)
    tof = H5D_READ(fieldID)
    RETURN, 1
  ENDELSE
  
END

;------------------------------------------------------------------------------
FUNCTION getSangleRowSelected, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_tab_table_uname')
  selection = WIDGET_INFO(id, /TABLE_SELECT)
  RETURN, selection[1]
END

;------------------------------------------------------------------------------
PRO select_full_line_of_selected_row, Event
  row = getSangleRowSelected(Event)
  select_sangle_row, Event, row
END

;------------------------------------------------------------------------------
PRO select_sangle_first_run_number_by_default, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_tab_table_uname')
  WIDGET_CONTROL, id, SET_TABLE_SELECT=[0,0,1,0]
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
  
  iNexus = OBJ_NEW('IDLgetMetadata_REF_M', full_nexus_file_name)
  IF (OBJ_VALID(iNexus)) THEN BEGIN
  
    run_number = reduce_tab1_table[0,row_selected]
    run_number = 'Run Number: ' + STRCOMPRESS(run_number,/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_sangle_info_title_base', run_number
    putTextFieldValue, Event, 'reduce_sangle_base_full_file_name', $
      full_nexus_file_name
    dangle = STRCOMPRESS(iNexus->getDangle(),/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_sangle_base_dangle_value', dangle
    dangle0 = STRCOMPRESS(iNexus->getDangle0(),/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_sangle_base_dangle0_value', dangle0
    sangle = STRCOMPRESS(iNexus->getSangle(),/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_sangle_base_sangle_value', sangle
    putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sangle
    dirpix = STRCOMPRESS(iNexus->getDirPix(),/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_sangle_base_dirpix_value', dirpix
    SampleDetDistance = STRCOMPRESS(iNexus->getSampleDetDist(),/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_sangle_base_sampledetdis_value', $
      SampleDetDistance
    refpix = '200'
    putTextFieldValue, event, 'reduce_sangle_base_refpix_value', refpix
    putTextFieldValue, Event, 'reduce_sangle_base_refpix_user_value', refpix
    
    OBJ_DESTROY, iNexus
    
  ENDIF ELSE BEGIN
  
    putTextFieldValue, Event, 'reduce_sangle_info_title_base', $
      'Run Number: N/A'
    putTextFieldValue, Event, 'reduce_sangle_base_full_file_name', 'N/A'
    putTextFieldValue, Event, 'reduce_sangle_base_dangle_value', 'N/A'
    putTextFieldValue, Event, 'reduce_sangle_base_dangle0_value', 'N/A'
    putTextFieldValue, Event, 'reduce_sangle_base_sangle_value', 'N/A'
    putTextFieldValue, Event, 'reduce_sangle_base_dirpix_value', 'N/A'
    putTextFieldValue, Event, 'reduce_sangle_base_sampledetdis_value', 'N/A'
    putTextFieldValue, event, 'reduce_sangle_base_refpix_value', 'N/A'
    
  ENDELSE
  
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
    EVENT=event
    
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
  
  position = [40,26,(*global).sangle_xsize_draw+40,$
    (*global).sangle_ysize_draw+25]
    
  tof = (*(*global).sangle_tof)
  delta_tof = tof[1]-tof[0]
  sz = N_ELEMENTS(tof)
  XRANGE = [tof[0], tof[sz-1]+delta_tof]
  
  PLOT, RANDOMN(s,304L), $
    XRANGE        = xrange, $
    YRANGE        = [0L,304L],$
    COLOR         = convert_rgb([0B,0B,255B]), $
    BACKGROUND    = convert_rgb((*global).sys_color_face_3d),$
    THICK         = 1, $
    TICKLEN       = -0.015, $
    XTICKLAYOUT   = 0,$
    YTICKLAYOUT   = 0,$
    XTICKS        = 10,$ ;number of ticks on x-axis
    YTICKS        = 25,$
    YSTYLE        = 1,$
    XSTYLE        = 1,$
    YTICKINTERVAL = 10,$
    POSITION      = position,$
    NOCLIP        = 0,$
    /NODATA,$
    /DEVICE
    
END

;-----------------------------------------------------------------------------
PRO plot_selected_data_in_sangle_base, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  reduce_tab1_table = (*(*global).reduce_tab1_table)
  
  ;get sangle row selected
  row_selected = getSangleRowSelected(Event)
  
  ;retrieve full nexus name of run selected
  full_nexus_file_name = reduce_tab1_table[1,row_selected]
  s_full_nexus_file_name = STRCOMPRESS(full_nexus_file_name,/REMOVE_ALL)
  IF (s_full_nexus_file_name EQ '') THEN RETURN
  
  ;get spin state selected
  sangle_spin_state_selected = getSangleSpinStateSelected(Event)
  IF (sangle_spin_state_selected EQ '') THEN RETURN
  
  ;retrieve data of run and spin state selected
  result = retrieve_nexus_data(s_full_nexus_file_name, $
    sangle_spin_state_selected, $
    data)
  IF (result EQ 0) THEN RETURN
  
  tData = TOTAL(data,2)
  (*(*global).sangle_tData) = tData
  x = (size(tdata))(1)
  y = (size(tdata))(2)
  IF (isButtonSelected(Event, 'reduce_sangle_log')) THEN BEGIN ;log
    index = WHERE(tData EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      tData[index] = !VALUES.D_NAN
    ENDIF
    tData = ALOG10(tData)
    tData = BYTSCL(tData,/NAN)
  ENDIF
  
  x_coeff = FLOAT((*global).sangle_xsize_draw / FLOAT(x))
  (*global).sangle_main_plot_congrid_x_coeff = x_coeff
  rtData = CONGRID(tData, x_coeff*x, 2*y)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  TVSCL, rtData, /DEVICE
  
END

;-----------------------------------------------------------------------------
PRO replot_selected_data_in_sangle_base, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tData = (*(*global).sangle_tData)
  x = (size(tdata))(1)
  y = (size(tdata))(2)
  IF (isButtonSelected(Event, 'reduce_sangle_log')) THEN BEGIN ;log
    index = WHERE(tData EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      tData[index] = !VALUES.D_NAN
    ENDIF
    tData = ALOG10(tData)
    tData = BYTSCL(tData,/NAN)
  ENDIF
  
  x_coeff = FLOAT((*global).sangle_xsize_draw / FLOAT(x))
  rtData = CONGRID(tData, x_coeff*x, 2*y)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  TVSCL, rtData, /DEVICE
  
END

;------------------------------------------------------------------------------
PRO retrieve_tof_array_from_nexus, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;retrieve full nexus name of run selected
  full_nexus_file_name = getTextFieldValue(Event,$
    'reduce_sangle_base_full_file_name')
  s_full_nexus_file_name = STRCOMPRESS(full_nexus_file_name,/REMOVE_ALL)
  IF (s_full_nexus_file_name EQ 'N/A') THEN RETURN
  
  ;get spin state selected
  sangle_spin_state_selected = getSangleSpinStateSelected(Event)
  IF (sangle_spin_state_selected EQ '') THEN RETURN
  
  ;retrieve data of run and spin state selected
  result = retrieve_tof_from_nexus_data(s_full_nexus_file_name, $
    sangle_spin_state_selected, $
    tof)
  IF (result EQ 0) THEN RETURN
  sz = N_ELEMENTS(tof)
  tof = tof[0:sz-2] ;remove last element
  (*(*global).sangle_tof) = tof
  
END

;------------------------------------------------------------------------------
PRO plot_sangle_refpix, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, error
  
  ;retrieve RefPix value (from text field)
  RefPix = getTextFieldValue(Event,'reduce_sangle_base_refpix_user_value')
  fix_RefPix = FIX(RefPix)
  
  xdevice_max = (*global).sangle_xsize_draw
  
  RefPix_device = getSangleYDeviceValue(Event,fix_RefPix)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  PLOTS, 0, RefPix_device, /DEVICE
  PLOTS, xdevice_max, RefPix_device, /DEVICE, /CONTINUE, COLOR=[255,255,0]
  
  error:
  RETURN
  
END

;------------------------------------------------------------------------------
PRO calculate_new_sangle_value, Event

  ON_IOERROR, error
  
  ;retrieve various parameters needed
  Dangle  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dangle_value'))
  Dangle0 = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dangle0_value'))
  DirPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dirpix_value'))
  RefPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_refpix_user_value'))
  SDdist  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_sampledetdis_value'))
    
  part1 = (Dangle - Dangle0 ) / 2.
  part2 = (DirPix - RefPix) * 7.e-4
  part3 = 2. * SDdist
  
  Sangle = part1 + part2 / part3
  sSangle = STRCOMPRESS(Sangle,/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sSangle
  RETURN
  
  error:
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', 'N/A'
  RETURN
  
END