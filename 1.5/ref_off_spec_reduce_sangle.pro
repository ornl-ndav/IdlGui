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
FUNCTION isClickInTofMinBox, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x = Event.x
  y = Event.y
  
  tof_sangle_device_range = (*global).tof_sangle_device_range
  tof_x_device = tof_sangle_device_range[0]
  xoffset = ABS(x - tof_x_device)
  
  IF (xoffset LE 50 AND $
    y LE 10) THEN RETURN, 1
  RETURN, 0
  
END

;------------------------------------------------------------------------------
FUNCTION isClickInTofMaxBox, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x = Event.x
  y = Event.y
  
  tof_sangle_device_range = (*global).tof_sangle_device_range
  tof_x_device = tof_sangle_device_range[1]
  
  x_coeff = (*global).sangle_main_plot_congrid_x_coeff
  xoffset = ABS(x - tof_x_device)
  yoffset = ABS(y - (*global).sangle_ysize_draw)
  
  IF (xoffset LE 50 AND $
    yoffset LE 10) THEN RETURN, 1
  RETURN, 0
  
END

;------------------------------------------------------------------------------
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
  
; Code change RCW (Feb 1, 2010): get intial value of RefPix from XML config file
  RefPix_InitialValue = (*global).RefPix_InitialValue
  
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
    putTextFieldValue, Event, 'reduce_sangle_base_dangle0_user_value', dangle0_text   
    
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
    putTextFieldValue, Event, 'reduce_sangle_base_sampledetdis_user_value', $
      SampleDetDistance
 ;   refpix = '200'
    refpix = RefPix_InitialValue
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
;tab1 and makes the corresponding spin states in the sangle base enabled
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
PRO display_reduce_step1_sangle_scale, $
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
  
  PLOT, RANDOMN(s,(*global).detector_pixels_y), $
    XRANGE        = xrange, $
    YRANGE        = [0L,(*global).detector_pixels_y],$
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
PRO plot_selected_data_in_sangle_base, Event, result

  result = 0
  
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
; Code change RCW (Feb 1, 2010): define y_coeff variable and set to 2.
  y_coeff = 2.
;  rtData = CONGRID(tData, x_coeff*x, 2*y)
  rtData = CONGRID(tData, x_coeff*x, y_coeff*y)
   
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  TVSCL, rtData, /DEVICE

  result = 1
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  TVSCL, rtData, /DEVICE
  
END

;------------------------------------------------------------------------------
PRO retrieve_tof_array_from_nexus, Event, result

  result = 0
  
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
  
  result = 1
  
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
 
   ; Code change RCW (Feb 1, 2010): set up SangleDone, RefPixSave variables
  SangleDone = (*(*global).SangleDone)
  RefPixSave = (*(*global).RefPixSave)
    
  xdevice_max = (*global).sangle_xsize_draw
  
  ;get sangle row selected, check to see if sangle has been calculated
   row_selected = getSangleRowSelected(Event)

   IF (SangleDone[row_selected] EQ 1) THEN BEGIN
        RefPix_device = 2*RefPixSave[row_selected]
        sRefPixSave = STRCOMPRESS(RefPixSave[row_selected],/REMOVE_ALL)

   ENDIF ELSE BEGIN
  ; else use the default, or value entered by user
  ;retrieve RefPix value (from text field)
       RefPix = getTextFieldValue(Event,'reduce_sangle_base_refpix_user_value')

       fix_RefPix = FIX(RefPix)
       RefPix_device = getSangleYDeviceValue(Event,fix_RefPix)
   ENDELSE 
  
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
;
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  device, decomposed=1
  
  Y = Event.y
  
  IF (Y LT 0) THEN Y = 0
  IF (Y GT (*global).sangle_ysize_draw) THEN Y = (*global).sangle_ysize_draw-1
  
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
  
  IF (Y LT 0) THEN Y = 0
  IF (Y GT (*global).sangle_ysize_draw) THEN Y = (*global).sangle_ysize_draw-1
  
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

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global

; Code change RCW (Feb 1, 2010): set up SangleDone variable
  SangleDone = (*(*global).SangleDone)
; Code change RCW (Feb 1, 2010): pass in szie of detector pixels in y direction (used for calculating Sangle
  detector_pixels_size_y = (*global).detector_pixels_size_y

  row_selected = getSangleRowSelected(Event)
  
  ;retrieve various parameters needed
  Dangle  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dangle_value'))
  Dangle0 = FLOAT(getTextFieldValue(Event,$
;    'reduce_sangle_base_dangle0_value'))
    'reduce_sangle_base_dangle0_user_value'))
  RefPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_refpix_user_value'))
  SDdist  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_sampledetdis_user_value'))
  DirPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dirpix_user_value'))
  print, "=== Sangle Calculations ==="
  print, "Dangle: ", Dangle
  print, "Dangle0: ", Dangle0
  print, "RefPix: ", RefPix
  print, "DirPix: ", DirPix     
  print, "SDdist: ", SDdist
  print, "detector_pixels_size_y: ", detector_pixels_size_y
  part1 = (Dangle - Dangle0 ) / 2.
;  part2 = (DirPix - RefPix) * 7.e-4
  part2_numer = (DirPix - RefPix) * detector_pixels_size_y
  part2_denom = 2. * SDdist
  part2 = part2_numer/part2_denom

  print, "part1: ", part1
  print, "part2_numer: ", part2_numer
  print, "part2_denom: ", part2_denom
  print, "part2: ", part2
  Sangle = part1 + part2 
  print, "Sangle: ", Sangle
  print, "============================"  
  s_Sangle_rad = STRCOMPRESS(Sangle,/REMOVE_ALL)
  s_Sangle_deg = STRCOMPRESS(convert_to_deg(Sangle),/REMOVE_ALL)
  
  sSangle = s_Sangle_rad + ' (' + s_Sangle_deg + ')'
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sSangle
  update_sangle_big_table, Event, sSangle

; set flag to indicate that sangle has been calculated
  SangleDone[row_selected] = 1
  (*(*global).SangleDone) = SangleDone
  
  RETURN
  
  error:
  sSangle = 'N/A (N/A)'
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sSangle
  update_sangle_big_table, Event, sSangle
  
  RETURN
  
END

;------------------------------------------------------------------------------
PRO update_sangle_big_table, Event, sSangle

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global

  SangleDone = (*(*global).SangleDone)

; Correction made (RC Ward, 30 Mar 2010): For single file, correctly mark file when Sangle calculation complete
  table = getTableValue(Event, 'reduce_sangle_tab_table_uname')
  IF ((size(table))(0) EQ 1) THEN BEGIN ;1d array
    table[1] = sSangle + '*'
  ENDIF ELSE BEGIN ;2d array
    ;get sangle row selected
    row_selected = getSangleRowSelected(Event)
    IF (SangleDone[row_selected] EQ 1) THEN BEGIN
       table[1,row_selected] =  sSangle + '*' 
    ENDIF ELSE BEGIN
       table[1,row_selected] = sSangle 
    ENDELSE
  ENDELSE
  putValueInTable, Event, 'reduce_sangle_tab_table_uname', table
  
END

;------------------------------------------------------------------------------
PRO determine_sangle_refpix_data_from_device_value, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
; Code change RCW (Feb 1, 2010): set up RefPixSave variable
  RefPixSave = (*(*global).RefPixSave)

  Y = Event.y
  
  IF (Y LT 0) THEN Y = 0
  IF (Y GT (*global).sangle_ysize_draw) THEN Y = (*global).sangle_ysize_draw-1
  
  RefPix_device = Y
  RefPix_data = getSangleYDataValue(Event,RefPix_device)
  sRefPix_data = STRCOMPRESS(RefPix_data,/REMOVE_ALL)
  putTextFieldValue, Event, $
    'reduce_sangle_base_refpix_user_value',$
    sRefPix_data
; Code change RCW (Feb 1, 2010): save RefPix for each data set for display to screen
  row_selected = getSangleRowSelected(Event)
  RefPixSave[row_selected] = sRefPix_data
  (*(*global).RefPixSave) = RefPixSave
  
; Code change RCW (Feb 15, 2010): Write values of RefPix to a file named for the first dataset
; Note this Rule: User should do SANGLE for first item on the list (lowest number also called Reference File)
; This is only to be used by magetism reflectometer data reduction process, so check for REF_M
; Code Change (RC Ward, 21 April 2010): Fix code to handle data files from the user directory (/results/)
  instrument = (*global).instrument
  RefPixLoad = (*global).RefPixLoad
  IF (instrument EQ 'REF_M') THEN BEGIN
; test added on 31 March 2010 - needs to be tested
    IF (RefPixLoad EQ 'yes') THEN BEGIN
     reduce_tab1_table = (*(*global).reduce_tab1_table)
     full_nexus_file_name = reduce_tab1_table[1, 0]
     parts = STR_SEP(full_nexus_file_name,'/')
; debug RefPix output filename
print, " parts_1: ",parts[1]
print, " parts_2: ",parts[2]
print, " parts_3: ",parts[3]
print, " parts_4: ",parts[4]
print, " parts_5: ",parts[5]
    IF (parts[2] EQ 'users') THEN BEGIN
    ; strip .nxs off parts[5]
       usethis = STR_SEP(parts[5],'.')
       print, "usethis_0: ",usethis[0]
       print, "usethis_1: ", usethis[1]
       output_file_name = (*global).ascii_path + usethis[0]+'_Off_Off_' + 'RefPix.txt'
    ENDIF ELSE BEGIN
     output_file_name = (*global).ascii_path + parts[2]+'_'+ parts[5]+'_Off_Off_' + 'RefPix.txt'
    ENDELSE
print, output_file_name
     OPENW, 1, output_file_name
     PRINTF, 1, RefPixSave
     CLOSE, 1
     FREE_LUN, 1
    ENDIF
  ENDIF
END

;------------------------------------------------------------------------------
PRO determine_sangle_dirpix_data_from_device_value, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  Y = Event.y
  
  IF (Y LT 0) THEN Y = 0
  IF (Y GT (*global).sangle_ysize_draw) THEN Y = (*global).sangle_ysize_draw-1
  
  DirPix_device = Y
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
  
  ; Code change RCW (Feb 1, 2010): set up SangleDone, RefPixSave variables
  SangleDone = (*(*global).SangleDone)
  RefPixSave = (*(*global).RefPixSave)
  
  tData = (*(*global).sangle_tData)
  tof_index = (*global).tof_sangle_index_range
  tof_max_possible = (size(tData))(1)-1
  
  tof1 = tof_index[0]
  tof2 = tof_index[1]

  IF (tof2 - tof1 EQ 1) THEN tof2++
  IF (tof2 - tof1 EQ 0) THEN BEGIN
  tof2 = (size(tData))(1)-1
  ENDIF
  IF (tof1 LT 0) THEN tof1=0
  IF (tof2 GT tof_max_possible) THEN tof2=tof_max_possible
  IF(tof1 + tof2 NE 0) THEN BEGIN
    tData = tData[tof1:tof2-1,*]
  ENDIF
  
  Data = TOTAL(tData,1)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='sangle_help_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  device, decomposed=1
  
  min_counts = MIN(Data,MAX=max_counts)
  
  sangle_current_zoom_para = (*global).sangle_current_zoom_para
  xmin = sangle_current_zoom_para[0]
  ymin = sangle_current_zoom_para[1]
  xmax = sangle_current_zoom_para[2]
  ymax = sangle_current_zoom_para[3]
  
  IF (xmin NE ymin AND $
    ymin NE ymax) THEN BEGIN ;there is a zoom
    IF (isButtonSelected(Event, 'reduce_sangle_log')) THEN BEGIN ;log
      min_counts = 0.1
      YRANGE = [min_counts, max_counts]
      PLOT, Data, XTITLE='Pixel', XRANGE = [xmin,xmax], $
        YRANGE = [ymin,ymax], YTITLE='Counts', /YLOG, XSTYLE=1, YSTYLE=1
    ENDIF ELSE BEGIN ;linear plot
      PLOT, Data, XTITLE='Pixel', XRANGE = [xmin,xmax], $
        YRANGE = [ymin,ymax], YTITLE='Counts', XSTYLE=1, YSTYLE=1
    ENDELSE
    
    ;plot DirPix
    DirPix  = FLOAT(getTextFieldValue(Event,$
      'reduce_sangle_base_dirpix_user_value'))
    PLOTS, DirPix, ymin, /DATA, COLOR=FSC_COLOR('white')
    PLOTS, DirPix, ymax, /DATA, COLOR=FSC_COLOR('white'), /CONTINUE
  
  ;plot RefPix
  ;get sangle row selected, check to see if sangle has been calculated
   row_selected = getSangleRowSelected(Event)
 
   IF (SangleDone[row_selected] EQ 1) THEN BEGIN
  ; if sangle has been calculated, use stored value of RefPix
     RefPix = RefPixSave[row_selected]      
   ENDIF ELSE BEGIN
  ; else use the default, or value entered by user
     RefPix  = FLOAT(getTextFieldValue(Event,$
      'reduce_sangle_base_refpix_user_value'))
   ENDELSE

    PLOTS, RefPix, ymin, /DATA, COLOR=FSC_COLOR('red')
    PLOTS, RefPix, ymax, /DATA, COLOR=FSC_COLOR('red'), /CONTINUE
    
  ENDIF ELSE BEGIN ;no zoom applied yet

    IF (isButtonSelected(Event, 'reduce_sangle_log')) THEN BEGIN ;log
      min_counts = 0.1
      YRANGE = [min_counts, max_counts]
      IF (max_counts LE min_counts) THEN BEGIN
      YRANGE = [min_counts, 1]
      ENDIF
      PLOT, Data, XTITLE='Pixel', YTITLE='Counts', /YLOG, XSTYLE=1, YSTYLE=1,$
        YRANGE=yrange
    ENDIF ELSE BEGIN ;linear plot
      PLOT, Data, XTITLE='Pixel', YTITLE='Counts', XSTYLE=1, YSTYLE=1
    ENDELSE

       
    ;plot DirPix
    DirPix  = FLOAT(getTextFieldValue(Event,$
      'reduce_sangle_base_dirpix_user_value'))
    PLOTS, DirPix, min_counts, /DATA, COLOR=FSC_COLOR('white')
    PLOTS, DirPix, max_counts, /DATA, COLOR=FSC_COLOR('white'), /CONTINUE

   
   ;plot RefPix
  ;get sangle row selected, check to see if sangle has been calculated
   row_selected = getSangleRowSelected(Event)

   IF (SangleDone[row_selected] EQ 1) THEN BEGIN
  ; if sangle has been calculated, use stored value of RefPix
     RefPix = RefPixSave[row_selected]      
   ENDIF ELSE BEGIN
  ; else use the default, or value entered by user
     RefPix  = FLOAT(getTextFieldValue(Event,$
      'reduce_sangle_base_refpix_user_value'))
   ENDELSE   
    
    PLOTS, RefPix, min_counts, /DATA, COLOR=FSC_COLOR('red')
    PLOTS, RefPix, max_counts, /DATA, COLOR=FSC_COLOR('red'), /CONTINUE
    
  ENDELSE
  
  device, decomposed=0
  
END

;------------------------------------------------------------------------------
PRO save_sangle_table, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  run_sangle_table = getTableValue(Event, 'reduce_sangle_tab_table_uname')
  (*(*global).reduce_run_sangle_table) = run_sangle_table
  
END

;------------------------------------------------------------------------------
PRO plot_tof_range_on_main_plot, Event

  plot_tof_min_range_on_main_plot, Event
  plot_tof_max_range_on_main_plot, Event
  
END

PRO plot_tof_min_range_on_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  DEVICE, decomposed=1
  
  tof_sangle_device_range = (*global).tof_sangle_device_range
  IF (tof_sangle_device_range[1] LT 1.0) THEN BEGIN ;first time
    tof_sangle_device_range[1] = (*global).sangle_xsize_draw
  ENDIF
  
  tof1 = tof_sangle_device_range[0]
  tof2 = tof_sangle_device_range[1]
  
  tof_min_device = MIN([tof1,tof2], MAX=tof_max_device)
  
  tof_sangle_device_range[0] = tof_min_device
  tof_sangle_device_range[1] = tof_max_device
  (*global).tof_sangle_device_range = tof_sangle_device_range

  xoff = 10
  yoff = 15
  
  PLOTS, tof_min_device, 0, /DEVICE, COLOR=FSC_COLOR('green')
  PLOTS, tof_min_device, (*global).sangle_ysize_draw, /DEVICE, $
    COLOR=FSC_COLOR('green'), /CONTINUE
  XYOUTS, tof_min_device+5,11, 'TOF min',/DEVICE
  PLOTS, tof_min_device-50, 0, /DEVICE, COLOR=FSC_COLOR('green')
  PLOTS, tof_min_device+50, 0, /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
  PLOTS, tof_min_device+50, 10, /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
  PLOTS, tof_min_device-50, 10, /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
  PLOTS, tof_min_device-50, 0, /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
    
  DEVICE, decomposed=0
  
END

PRO plot_tof_max_range_on_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  DEVICE, decomposed=1
  
  tof_sangle_device_range = (*global).tof_sangle_device_range
  IF (tof_sangle_device_range[1] LT 1.0) THEN BEGIN ;first time
    tof_sangle_device_range[1] = (*global).sangle_xsize_draw
  ENDIF
  
  tof1 = tof_sangle_device_range[0]
  tof2 = tof_sangle_device_range[1]
  
  tof_min_device = MIN([tof1,tof2], MAX=tof_max_device)
  
  tof_sangle_device_range[0] = tof_min_device
  tof_sangle_device_range[1] = tof_max_device
  (*global).tof_sangle_device_range = tof_sangle_device_range
  
  xoff = 10
  yoff = 15
  
  tof_max_device--
  
  PLOTS, tof_max_device, 0, /DEVICE, COLOR=FSC_COLOR('green')
  PLOTS, tof_max_device, (*global).sangle_ysize_draw, /DEVICE, $
    COLOR=FSC_COLOR('green'), /CONTINUE
  XYOUTS, tof_max_device-45,(*global).sangle_ysize_draw-21, $
    'TOF max',/DEVICE
  PLOTS, tof_max_device-50, (*global).sangle_ysize_draw-1, $
    /DEVICE, COLOR=FSC_COLOR('green')
  PLOTS, tof_max_device+50, (*global).sangle_ysize_draw-1, $
    /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
  PLOTS, tof_max_device+50, (*global).sangle_ysize_draw-10, $
    /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
  PLOTS, tof_max_device-50, (*global).sangle_ysize_draw-10, $
    /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
  PLOTS, tof_max_device-50, (*global).sangle_ysize_draw-1, $
    /DEVICE, COLOR=FSC_COLOR('green'), $
    /CONTINUE
    
  DEVICE, decomposed=0
  
END

;------------------------------------------------------------------------------
PRO retrieve_tof_data_range_from_device_values, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tof_sangle_device_range = (*global).tof_sangle_device_range
  
  tof1 = tof_sangle_device_range[0]
  tof2 = tof_sangle_device_range[1]
  
  xcoeff = (*global).sangle_main_plot_congrid_x_coeff
  tof1_index = FIX(tof1/xcoeff)
  tof2_index = FIX(tof2/xcoeff)
  
  (*global).tof_sangle_index_range = [tof1_index, tof2_index]
  
END

;------------------------------------------------------------------------------
PRO plot_sangle_zoom_selection, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  sangle_zoom_xy_minmax = (*global).sangle_zoom_xy_minmax
  
  x1 = sangle_zoom_xy_minmax[0]
  y1 = sangle_zoom_xy_minmax[1]
  x2 = sangle_zoom_xy_minmax[2]
  y2 = sangle_zoom_xy_minmax[3]
  
  ;display box
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='sangle_help_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  DEVICE, decomposed=1
  
  plot_counts_vs_pixel_help, Event
  
  PLOTS, x1, y1, /DATA, COLOR=FSC_COLOR('pink')
  PLOTS, x1, y2, /DATA, /CONTINUE, COLOR=FSC_COLOR('pink')
  PLOTS, x2, y2, /DATA, /CONTINUE, COLOR=FSC_COLOR('pink')
  PLOTS, x2, y1, /DATA, /CONTINUE, COLOR=FSC_COLOR('pink')
  PLOTS, x1, y1, /DATA, /CONTINUE, COLOR=FSC_COLOR('pink')
  
  DEVICE, decomposed=0
  
END

;------------------------------------------------------------------------------
PRO order_data, sangle_zoom_xy_minmax

  x1 = sangle_zoom_xy_minmax[0]
  y1 = sangle_zoom_xy_minmax[1]
  x2 = sangle_zoom_xy_minmax[2]
  y2 = sangle_zoom_xy_minmax[3]
  
  xmin = MIN([x1,x2],MAX=xmax)
  ymin = MIN([y1,y2],MAX=ymax)
  
  sangle_zoom_xy_minmax[0] = xmin
  sangle_zoom_xy_minmax[1] = ymin
  sangle_zoom_xy_minmax[2] = xmax
  sangle_zoom_xy_minmax[3] = ymax
  
END

