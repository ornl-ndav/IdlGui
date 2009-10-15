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
      
    dangle = iNexus->getDangle()
    s_dangle_rad = STRCOMPRESS(dangle,/REMOVE_ALL)
    s_dangle_deg = STRCOMPRESS(convert_to_deg(dangle),/REMOVE_ALL)
    dangle_text = s_dangle_rad + ' (' + s_dangle_deg + ')'
    putTextFieldValue, Event, 'reduce_sangle_base_dangle_value', dangle_text
    
    dangle0 = iNexus->getDangle0()
    s_dangle0_rad = STRCOMPRESS(dangle0,/REMOVE_ALL)
    s_dangle0_deg = STRCOMPRESS(convert_to_deg(dangle0),/REMOVE_ALL)
    dangle0_text = s_dangle0_rad + ' (' + s_dangle0_deg + ')'
    putTextFieldValue, Event, 'reduce_sangle_base_dangle0_value', dangle0_text
    
    sangle = iNexus->getSangle()
    s_sangle_rad = STRCOMPRESS(sangle,/REMOVE_ALL)
    s_sangle_deg = STRCOMPRESS(convert_to_deg(sangle),/REMOVE_ALL)
    sangle_text = s_sangle_rad + ' (' + s_sangle_deg + ')'
    putTextFieldValue, Event, 'reduce_sangle_base_sangle_value', sangle_text
    putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sangle_text
    
    dirpix = STRCOMPRESS(iNexus->getDirPix(),/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_sangle_base_dirpix_value', dirpix
    putTextFieldValue, Event, 'reduce_sangle_base_dirpix_user_value', dirpix
    
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
PRO  plot_sangle_arrows, Event, Y, color=color

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  xoffset = (*global).sangle_refpix_arrow_xoffset
  yoffset = (*global).sangle_refpix_arrow_yoffset
  
  ;plot left arrow
  PLOTS, 0, Y+yoffset, /DEVICE
  PLOTS, xoffset, Y, /DEVICE, /CONTINUE, COLOR=FSC_COLOR(color)
  PLOTS, 0, Y-yoffset, /DEVICE, /CONTINUE, COLOR=FSC_COLOR(color)
  PLOTS, 0, Y+yoffset,/DEVICE, /CONTINUE, COLOR=FSC_COLOR(color)
  
  ;plot right arrow
  xmax = (*global).sangle_xsize_draw - 1
  PLOTS, xmax, Y+yoffset, /DEVICE
  PLOTS, xmax-xoffset, Y, /DEVICE, /CONTINUE, COLOR=FSC_COLOR(color)
  PLOTS, xmax, Y-yoffset, /DEVICE, /CONTINUE, COLOR=FSC_COLOR(color)
  PLOTS, xmax, Y+yoffset,/DEVICE, /CONTINUE, COLOR=FSC_COLOR(color)
  
END

;------------------------------------------------------------------------------
;add legend
PRO plot_sangle_selection_legend, Event, string=string, color=color, x, y
  XYouts, x, y, string, /DEVICE, COLOR=FSC_COLOR(color)
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
  device, decomposed=1
  
  PLOTS, 0, RefPix_device, /DEVICE
  PLOTS, xdevice_max, RefPix_device, /DEVICE, /CONTINUE, $
    COLOR=FSC_COLOR('red')
    
  ;add legend
  plot_sangle_selection_legend, Event, string='RefPix', $
    color='red', xdevice_max - 100, RefPix_device + 10
    
  ;left and right arrows
  IF ((*global).sangle_mode EQ 'refpix') THEN BEGIN
    plot_sangle_arrows, Event, RefPix_device, color='red'
  ENDIF
  
  device, decomposed=0
  
  error:
  RETURN
  
END

;------------------------------------------------------------------------------
PRO plot_sangle_dirpix, Event


  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, error
  
  ;retrieve DirPix value (from text field)
  DirPix = getTextFieldValue(Event,'reduce_sangle_base_dirpix_user_value')
  fix_DirPix = FIX(DirPix)
  
  xdevice_max = (*global).sangle_xsize_draw
  
  DirPix_device = getSangleYDeviceValue(Event,fix_DirPix)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  device, decomposed=1
  
  PLOTS, 0, DirPix_device, /DEVICE
  PLOTS, xdevice_max, DirPix_device, /DEVICE, /CONTINUE, $
    COLOR=FSC_COLOR('white')
    
  ;add legend
  plot_sangle_selection_legend, Event, string='DirPix', $
    color='white', xdevice_max - 100, DirPix_device + 10
    
  ;left and right arrows
  IF ((*global).sangle_mode EQ 'dirpix') THEN BEGIN
    plot_sangle_arrows, Event, DirPix_device, color='white'
  ENDIF
  
  device, decomposed=0
  
  error:
  RETURN
  
END

;------------------------------------------------------------------------------
PRO plot_sangle_refpix_live, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  device, decomposed=1
  
  Y = Event.y
  
  PLOTS, 0, Y, /DEVICE
  PLOTS, (*global).sangle_xsize_draw, Y, /DEVICE, /CONTINUE, $
    COLOR=FSC_COLOR('red')
    
  ;add legend
  plot_sangle_selection_legend, Event, string='RefPix', $
    color='red', (*global).sangle_xsize_draw - 100, Y + 10
    
  ;left and right arrows
  plot_sangle_arrows, Event, Y, color='red'
  
  device, decomposed=0
  
END

;------------------------------------------------------------------------------
PRO plot_sangle_dirpix_live, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  device, decomposed=1
  
  Y = Event.y
  
  PLOTS, 0, Y, /DEVICE
  PLOTS, (*global).sangle_xsize_draw, Y, /DEVICE, /CONTINUE, $
    COLOR=FSC_COLOR('white')
    
  ;add legend
  plot_sangle_selection_legend, Event, string='DirPix', $
    color='white', (*global).sangle_xsize_draw - 100, Y + 10
    
  ;left and right arrows
  plot_sangle_arrows, Event, Y, color='white'
  
  device, decomposed=0
  
END

;------------------------------------------------------------------------------
PRO calculate_new_sangle_value, Event

  ON_IOERROR, error
  
  ;retrieve various parameters needed
  Dangle  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dangle_value'))
  Dangle0 = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dangle0_value'))
  RefPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_refpix_user_value'))
  SDdist  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_sampledetdis_value'))
  DirPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dirpix_user_value'))
    
  part1 = (Dangle - Dangle0 ) / 2.
  part2 = (DirPix - RefPix) * 7.e-4
  part3 = 2. * SDdist
  
  Sangle = part1 + part2 / part3
  
  s_Sangle_rad = STRCOMPRESS(Sangle,/REMOVE_ALL)
  s_Sangle_deg = STRCOMPRESS(convert_to_deg(Sangle),/REMOVE_ALL)
  
  sSangle = s_Sangle_rad + ' (' + s_Sangle_deg + ')'
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sSangle
  update_sangle_big_table, Event, sSangle
  
  RETURN
  
  error:
  sSangle = 'N/A (N/A)'
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sSangle
  update_sangle_big_table, Event, sSangle
  
  RETURN
  
END

;------------------------------------------------------------------------------
PRO update_sangle_big_table, Event, sSangle

  table = getTableValue(Event, 'reduce_sangle_tab_table_uname')
  IF ((size(table))(0) EQ 1) THEN BEGIN ;1d array
    table[1] = sSangle
  ENDIF ELSE BEGIN ;2d array
    ;get sangle row selected
    row_selected = getSangleRowSelected(Event)
    table[1,row_selected] = sSangle
  ENDELSE
  putValueInTable, Event, 'reduce_sangle_tab_table_uname', table
  
END

;------------------------------------------------------------------------------
PRO determine_sangle_refpix_data_from_device_value, Event

  RefPix_device = Event.y
  RefPix_data = getSangleYDataValue(Event,RefPix_device)
  sRefPix_data = STRCOMPRESS(RefPix_data,/REMOVE_ALL)
  putTextFieldValue, Event, $
    'reduce_sangle_base_refpix_user_value',$
    sRefPix_data
    
END

;------------------------------------------------------------------------------
PRO determine_sangle_dirpix_data_from_device_value, Event

  DirPix_device = Event.y
  DirPix_data = getSangleYDataValue(Event,DirPix_device)
  sDirPix_data = STRCOMPRESS(DirPix_data,/REMOVE_ALL)
  putTextFieldValue, Event, $
    'reduce_sangle_base_dirpix_user_value',$
    sDirPix_data
    
END

;------------------------------------------------------------------------------
PRO plot_counts_vs_pixel_help, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tData = (*(*global).sangle_tData)
  Data = TOTAL(tData,1)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='sangle_help_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  device, decomposed=1
  
  IF (isButtonSelected(Event, 'reduce_sangle_log')) THEN BEGIN ;log
    PLOT, Data, XTITLE='Pixel', YTITLE='Counts', /YLOG, XSTYLE=1
  ENDIF ELSE BEGIN ;linear plot
    PLOT, Data, XTITLE='Pixel', YTITLE='Counts', XSTYLE=1 
  ENDELSE
  
  device, decomposed=0
  
END
