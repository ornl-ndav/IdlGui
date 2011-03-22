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

function getPreviousSangleRowSelected, event
widget_control, event.top, get_uvalue=global
return, (*global).last_sangle_tab_table_row_selected
end

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
    ; Change code (RC Ward, 6 Sept 2010): Add capability to enter Dangle
    putTextFieldValue, Event, 'reduce_sangle_base_dangle_user_value', dangle_text
    
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
    
    ; Change code (RC Ward, 13 July 2010): pick up intial values of tof_cutoff_min and tof_cutoff_max
    
    apply_tof_cutoffs = (*global).apply_tof_cutoffs
    putTextFieldValue, event, 'reduce_sangle_base_apply_tof_cutoffs_value', apply_tof_cutoffs
    
    ; Change code (RC Ward, 16 June 2010): pick up intial values of tof_cutoff_min and tof_cutoff_max
    tof_cutoff_min = (*global).tof_cutoff_min
    tof_cutoff_max = (*global).tof_cutoff_max
    
    putTextFieldValue, event, 'reduce_sangle_base_tof_cutoff_min_value', tof_cutoff_min
    ;    putTextFieldValue, Event, 'reduce_sangle_base_tof_cutoff_min_user_value', tof_cutoff_min
    putTextFieldValue, event, 'reduce_sangle_base_tof_cutoff_max_value', tof_cutoff_max
    ;    putTextFieldValue, Event, 'reduce_sangle_base_tof_cutoff_max_user_value', tof_cutoff_max
    
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
    putTextFieldValue, event, 'reduce_sangle_base_apply_tof_cutoffs_value', 'N/A'
    putTextFieldValue, event, 'reduce_sangle_base_tof_cutoff_min_value', 'N/A'
    putTextFieldValue, event, 'reduce_sangle_base_tof_cutoff_max_value', 'N/A'
    
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
  (*(*global).sangle_tof) = tof/1000. ;to be in ms
  
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
  RefPix_InitialValue = (*global).RefPix_InitialValue
  
  xdevice_max = (*global).sangle_xsize_draw
  
  ;get sangle row selected, check to see if sangle has been calculated
  row_selected = getSangleRowSelected(Event)
  
  IF (SangleDone[row_selected] EQ 1) THEN BEGIN
    RefPix_device = 2*RefPixSave[row_selected]
    sRefPixSave = STRCOMPRESS(RefPixSave[row_selected],/REMOVE_ALL)
    ;Change Code (RC Ward, 20 Oct 2010): Put RefPix value into text box
    putTextFieldValue, Event, 'reduce_sangle_base_refpix_user_value', sRefPixSave
  ENDIF ELSE BEGIN
    ; else use the default, or value entered by user
    ;retrieve RefPix value (from text field)
    RefPix = getTextFieldValue(Event,'reduce_sangle_base_refpix_user_value')
    ; Change Code (11 Jan 2011): RefPix float not integer
    ;       fix_RefPix = FIX(RefPix)
    ;       RefPix_device = getSangleYDeviceValue(Event,fix_RefPix)
    RefPix_device = getSangleYDeviceValue(Event,RefPix)
    ; Change Code (RC Ward, 24 Oct 2010) ====================================================\
    ; if value differs from the default, assume user has entered it and save this value of RefPix
    IF (RefPix NE RefPix_InitialValue) THEN BEGIN
      ; save the value
      RefPixSave[row_selected] = RefPix
      (*(*global).RefPixSave) = RefPixSave
      calculate_new_sangle_value, Event
      plot_counts_vs_pixel_help, Event
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
          ; Change code (RC Ward 30 June 2010): STR_SEP is obsolete. Replace with IDL routine STRSPLIT
          ;     parts = STR_SEP(full_nexus_file_name,'/')
          parts = STRSPLIT(full_nexus_file_name,'/',/EXTRACT)
          ; DEBUG ========================================
          ; debug RefPix output filename
          ;    print, " parts_0: ",parts[0]
          ;    print, " parts_1: ",parts[1]
          ;    print, " parts_2: ",parts[2]
          ;    print, " parts_3: ",parts[3]
          ;    print, " parts_4: ",parts[4]
          ;    print, " parts_5: ",parts[5]
          ; DEBUG ========================================
          IF (parts[1] EQ 'users') THEN BEGIN
            ; strip .nxs off parts[5]
            ; Change code (RC Ward 30 June 2010): STR_SEP is obsolte. Replace with IDL routine STRSPLIT
            ;       usethis = STR_SEP(parts[5],'.')
            usethis = STRSPLIT(parts[5],'.',/EXTRACT)
            ; DEBUG ========================================
            ;       print, "usethis_0: ",usethis[0]
            ;       print, "usethis_1: ", usethis[1]
            ; DEBUG ========================================
            ; Change code (RC Ward 30 June 2010): Had to write out a RefPix file for each spin state
            ; CHANGED THIS Jan 2011 - Only one RefPix file created for all spin states
            ; Change code (RC Ward, 23 July 2010): Path to reduce step files (ascii_path) now specified by user
            RefPix_file_stub = (*global).ascii_path + usethis[0]
          ENDIF ELSE BEGIN
            RefPix_file_stub = (*global).ascii_path  + parts[1] + '_' + parts[4]
            
          ;   print, "RefPix RefPix_file_stub: ", RefPix_file_stub
          ENDELSE
          ;    RefPix_file_name = RefPix_file_stub + '_Off_Off_' + 'RefPix.txt'
          RefPix_file_name = RefPix_file_stub + '_RefPix.txt'
          
          ; DEBUG ========================================
          ;    print, "RefPix filename: ", RefPix_file_name
          ; DEBUG ========================================
          OPENW, 1, RefPix_file_name
          PRINTF, 1, RefPixSave
          CLOSE, 1
          FREE_LUN, 1
          
        ENDIF
      ENDIF
    ENDIF
  ; Change Code (RC Ward, 24 Oct 2010) ====================================================/
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

  ;  ON_IOERROR, error

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ; Code change RCW (Feb 1, 2010): set up SangleDone variable
  SangleDone = (*(*global).SangleDone)
  ; Code change RCW (Feb 1, 2010): pass in szie of detector pixels in y direction (used for calculating Sangle
  detector_pixels_size_y = (*global).detector_pixels_size_y
  
  row_selected = getSangleRowSelected(Event)
  
  ; Change code (RC Ward, 6 Sept 2010): Add capability for user to enter Dangle
  ;retrieve various parameters needed
  Dangle  = FLOAT(getTextFieldValue(Event,$
    ;    'reduce_sangle_base_dangle_value'))
    'reduce_sangle_base_dangle_user_value'))
  Dangle0 = FLOAT(getTextFieldValue(Event,$
    ;    'reduce_sangle_base_dangle0_value'))
    'reduce_sangle_base_dangle0_user_value'))
  RefPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_refpix_user_value'))
  SDdist  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_sampledetdis_user_value'))
  DirPix  = FLOAT(getTextFieldValue(Event,$
    'reduce_sangle_base_dirpix_user_value'))
  ApplyTOFCuttoffs = getTextFieldValue(Event,$
    'reduce_sangle_base_apply_tof_cutoffs_value')
  ;  sApplyTOFCuttoffs = STRCOMPRESS(ApplyTOFCuttoffs,/REMOVE_ALL)
  (*global).apply_tof_cutoffs = ApplyTOFCuttoffs
  TOFCutoffMin = FIX(getTextFieldValue(Event,$
    'reduce_sangle_base_tof_cutoff_min_value'))
  TOFCutoffMax = FIX(getTextFieldValue(Event,$
    'reduce_sangle_base_tof_cutoff_max_value'))
  sTOFCutoffMin = STRCOMPRESS(TOFCutoffMin,/REMOVE_ALL)
  sTOFCutoffMax = STRCOMPRESS(TOFCutoffMax,/REMOVE_ALL)
  (*global).tof_cutoff_min = sTOFCutoffMin
  (*global).tof_cutoff_max = sTOFCutoffMax
  ; DEBUG ========================================
  ;    print, "=== Sangle Calculations ==="
  ;    print, "Dangle: ", Dangle
  ;    print, "Dangle0: ", Dangle0
  ;    print, "RefPix: ", RefPix
  ;    print, "DirPix: ", DirPix
  ;    print, "SDdist: ", SDdist
  ;    print, "ApplyTOFCuttoffs: ", ApplyTOFCuttoffs
  LogMessage = 'NO TOF Cutoffs Applied'
  if (ApplyTOFCuttoffs EQ 'yes') THEN BEGIN
    LogMessage = 'TOF Cutoffs Applied'
  ;      print, "TOF_cutoff_min: ", TOFCutoffMin
  ;      print, "TOF_cutoff_max: ", TOFCutoffMax
  ENDIF
  IDLsendToGeek_addLogBookText, Event, LogMessage
  ;    print, "detector_pixels_size_y: ", detector_pixels_size_y
  ; DEBUG ========================================
  part1 = (Dangle - Dangle0 ) / 2.
  part2_numer = (DirPix - RefPix) * detector_pixels_size_y
  part2_denom = 2. * SDdist
  part2 = part2_numer/part2_denom
  Sangle = part1 + part2
  ; DEBUG ========================================
  ;    print, "part1: ", part1
  ;    print, "part2_numer: ", part2_numer
  ;    print, "part2_denom: ", part2_denom
  ;    print, "part2: ", part2
  ;    print, "Sangle: ", Sangle
  ;    print, "============================"
  ; DEBUG ========================================
  s_Sangle_rad = STRCOMPRESS(Sangle,/REMOVE_ALL)
  s_Sangle_deg = STRCOMPRESS(convert_to_deg(Sangle),/REMOVE_ALL)
  
  sSangle = s_Sangle_rad + ' (' + s_Sangle_deg + ')'
  putTextFieldValue, Event, 'reduce_sangle_base_sangle_user_value', sSangle
  ;  update_sangle_big_table, Event, sSangle
  
  ; set flag to indicate that sangle has been calculated
  SangleDone[row_selected] = 1
  (*(*global).SangleDone) = SangleDone
  ; Change made (RC Ward, 25 Oct 2010): move this call down after setting SangleDone
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
  
  return
  
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
      ; Change code (RC Ward 30 June 2010): STR_SEP is obsolete. Replace with IDL routine STRSPLIT
      ;     parts = STR_SEP(full_nexus_file_name,'/')
      parts = STRSPLIT(full_nexus_file_name,'/',/EXTRACT)
      
      help, parts
      print, full_nexus_file_name
      print
      
      ; DEBUG ========================================
      ; debug RefPix output filename
      ;    print, " parts_0: ",parts[0]
      ;    print, " parts_1: ",parts[1]
      ;    print, " parts_2: ",parts[2]
      ;    print, " parts_3: ",parts[3]
      ;    print, " parts_4: ",parts[4]
      ;    print, " parts_5: ",parts[5]
      ; DEBUG ========================================
      IF (parts[1] EQ 'users') THEN BEGIN
        ; strip .nxs off parts[5]
        ; Change code (RC Ward 30 June 2010): STR_SEP is obsolte. Replace with IDL routine STRSPLIT
        ;       usethis = STR_SEP(parts[5],'.')
        usethis = STRSPLIT(parts[5],'.',/EXTRACT)
        ; DEBUG ========================================
        ;        print, "usethis_0: ", usethis[0]
        ;        print, "usethis_1: ", usethis[1]
        ; DEBUG ========================================
        ; Change code (RC Ward 30 June 2010): Had to write out a RefPix file for each spins state
        ; Change code (RC Ward, 23 July 2010): Path to reduce step files (ascii_path) now specified by user
        RefPix_file_stub = (*global).ascii_path + usethis[0]
      ;        print, "Case 1: RefPix RefPix_file_stub: ", RefPix_file_stub
      ENDIF ELSE BEGIN
        RefPix_file_stub = (*global).ascii_path  + parts[1] + '_' + parts[4]
      ;        print, "Case 2: RefPix RefPix_file_stub: ", RefPix_file_stub
      ENDELSE
      
      ;    print, "RefPix RefPix_file_stub: ", RefPix_file_stub
      ;    RefPix_file_name = RefPix_file_stub + '_Off_Off_' + 'RefPix.txt'
      RefPix_file_name = RefPix_file_stub + '_RefPix.txt'
      ; DEBUG ========================================
      ;    print, "RefPix filename: ", RefPix_file_name
      ; DEBUG ========================================
      
      OPENW, 1, RefPix_file_name
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
    
    ;plot background
    y1 = fix(getTextFieldvalue(event,'reduce_step1_create_back_roi_y1_value'))
    if (y1 ne 0) then begin
      plots, y1, ymin, /data, color=fsc_color('pink')
      plots, y1, ymax, /data, color=fsc_color('pink'), /continue
    endif
    
    y2 = fix(getTextFieldvalue(event,'reduce_step1_create_back_roi_y2_value'))
    if (y2 ne 0) then begin
      plots, y2, ymin, /data, color=fsc_color('pink')
      plots, y2, ymax, /data, color=fsc_color('pink'), /continue
    endif
    
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
    
    _y1 = strcompress(getTextFieldValue(event, $
      'reduce_step1_create_back_roi_y1_value'),/remove_all)
    if (_y1 ne '') then begin
      ;plot background
      y1 = fix(_y1)
      if (y1 ne 0) then begin
        plots, y1, min_counts, /data, color=fsc_color('pink')
        plots, y1, max_counts, /data, color=fsc_color('pink'), /continue
      endif
    endif
    
    _y2 = strcompress(getTextFieldValue(event, $
      'reduce_step1_create_back_roi_y2_value'),/remove_all)
    if (_y2 ne '') then begin
      y2 = fix(_y2)
      if (y2 ne 0) then begin
        plots, y2, min_counts, /data, color=fsc_color('pink')
        plots, y2, max_counts, /data, color=fsc_color('pink'), /continue
      endif
    endif
    
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
PRO reset_sangle_calculation, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ; get SangleDone
  SangleDone = (*(*global).SangleDone)
  
  ; get table
  table = getTableValue(Event, 'reduce_sangle_tab_table_uname')
  ; get row_selected
  row_selected = getSangleRowSelected(Event)
  IF ((size(table))(0) EQ 1) THEN BEGIN ;1d array
    len = STRLEN(table[1])
    table[1] = STRMID(table[1],0, len-1)
  ENDIF ELSE BEGIN ;2d array
    len = STRLEN(table[1,row_selected])
    table[1,row_selected] = STRMID(table[1,row_selected],0, len-1)
  ENDELSE
  ; zero our SangleDone
  SangleDone[row_selected] = 0
  (*(*global).SangleDone) = SangleDone
  ;print, "SangleDone: ", SangleDone
  putValueInTable, Event, 'reduce_sangle_tab_table_uname', table
;   plot_sangle_refpix, Event
  
END

;+
; :Description:
;    Browse for a background roi file in the reduce/tab1
;
; :Params:
;    Event
;
;
;
; :Author: j35
;-
PRO browse_reduce_step1_back_roi_file, Event
  compile_opt idl2
  
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve infos
  extension  = 'dat'
  filter     = ['*_back_ROI.dat','*_back_ROI.txt']
  path = (*global).ascii_path
  title      = 'Browsing for a background ROI file'
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    GET_PATH          = new_path,$
    PATH              = path,$
    dialog_parent = id, $
    TITLE             = title,$
    /READ,$
    /MUST_EXIST)
    
  IF (file_name NE '') THEN BEGIN
  
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/hourglass
    
    catch,error
    if (error ne 0) then begin
      catch,/cancel
      widget_control, hourglass=0
      LogText = '> Loading data Back. ROI ' + file_name + ' FAILED!'
      IDLsendToGeek_addLogBookText, Event, LogText
      
      message_text = 'Problem loading data Back. ROI file name: ' + file_name
      id = widget_info(event.top, find_by_uname='MAIN_BASE')
      result = dialog_message(message_text,$
        /center, $
        dialog_parent=id,$
        /ERROR, $
        title = 'Problem loading data back ROI!')
        
      return
    endif
    
    (*global).roi_path = new_path
    ; Change code (RC Ward, 17 July 2010): See if this updates the location of output files
    (*global).ascii_path = new_path
    
    ;    ;Load ROI button (Load, extract and plot)
    ;    load_roi_selection, Event, file_name
    
    Yarray = retrieveYminMaxFromFile(event,file_name)
    Y1 = Yarray[0]
    Y2 = Yarray[1]
    putTextFieldValue, Event, 'reduce_step1_create_back_roi_y1_value', $
      STRCOMPRESS(Y1,/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_step1_create_back_roi_y2_value', $
      STRCOMPRESS(Y2,/REMOVE_ALL)
      
    return
    
    plot_reduce_step2_norm, Event ;refresh plot
    reduce_step2_plot_rois, event
    
    putTextFieldValue, Event, $
      'reduce_step2_create_back_roi_file_name_label',$
      file_name
      
    nexus_spin_state_back_roi_table = (*(*global).nexus_spin_state_back_roi_table)
    data_spin_state = (*global).tmp_reduce_step2_data_spin_state
    row = (*global).tmp_reduce_step2_row
    column = getReduceStep2SpinStateColumn(Event, row=row,$
      data_spin_state=data_spin_state)
      
    ;get Norm file selected
    norm_table = (*global).reduce_step2_big_table_norm_index
    nexus_spin_state_back_roi_table[column,norm_table[row]] = file_name
    (*(*global).nexus_spin_state_back_roi_table) = nexus_spin_state_back_roi_table
    
    ;turn off hourglass
    WIDGET_CONTROL,hourglass=0
    
  ENDIF ELSE BEGIN
  ;    IDLsendToGeek_addLogBookText, Event, '-> Operation CANCELED'
  ENDELSE
  
END


;+
; :Description:
;    plot the y1 and y2 of background selected
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro reduce_step1_plot_rois, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id_draw = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='reduce_sangle_plot')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  geometry = WIDGET_INFO(id_draw,/GEOMETRY)
  WSET,id_value
  
  xsize = geometry.xsize
  ysize = geometry.ysize
  
  back_y1 = getTextFieldValue(event,'reduce_step1_create_back_roi_y1_value')
  back_y2 = getTextFieldValue(event,'reduce_step1_create_back_roi_y2_value')
  
  ymin = 0
  ;ymax = (*global).sangle_ysize_draw
  ymax = ysize
  y_rebin_value = (*global).sangle_main_plot_congrid_y_coeff
  xmax = xsize
  
  if (strcompress(back_y1,/remove_all) ne '') then begin
  
    back_y1 = fix(back_y1)
    back_y1 = (back_y1 gt ymax) ? ymax : back_y1
    back_y1 = (back_y1 lt ymin) ? ymin : back_y1
    
    ;back
    PLOTS, 0, y_rebin_value * back_y1, /device, color=color
    PLOTS, xmax, y_rebin_value * back_y1, $
      /device, $
      /continue, color=fsc_color('pink')
      
  endif
  
  if (strcompress(back_y2,/remove_all) ne '') then begin
  
    back_y2 = fix(back_y2)
    back_y2 = (back_y2 gt ymax) ? ymax : back_y2
    back_y2 = (back_y2 lt ymin) ? ymin : back_y2
    
    PLOTS, 0, y_rebin_value * back_y2, /device, color=color
    PLOTS, xmax, y_rebin_value * back_y2, $
      /device, $
      /continue, color=fsc_color('pink')
      
  endif
  
end

;+
; :Description:
;    Create the data background ROI file in reduce/step1
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro create_data_background_roi_file, event
  compile_opt idl2
  
  back_y1 = getTextFieldValue(event,'reduce_step1_create_back_roi_y1_value')
  back_y2 = getTextFieldValue(event,'reduce_step1_create_back_roi_y2_value')
  
  ;continue only if there is something to create
  if (strcompress(back_y1,/remove_all) eq '' or $
    strcompress(back_y2,/remove_all) eq '') then return
    
  back_file_name = getDefaultReduceStep1BackRoiFileName(event)
  
  widget_control, event.top, get_uvalue=global
  
  save_data_roi_base, event, $
    path = (*global).ascii_path, $
    back_file_name = back_file_name
    
end


;+
; :Description:
;    create the background ROI file for the data nexus file
;
; :Params:
;    event
;
; :Keywords:
;    roi_file_name
;    y1
;    y2
;
; :Author: j35
;-
pro create_data_back_roi, event, $
    roi_file_name=roi_file_name, $
    y1=y1, $
    y2=y2
  compile_opt idl2
  
  ;ON_IOERROR, error
  
  widget_control, event.top, get_uvalue=global
  instrument = (*global).instrument
  
  ;get integer values
  Y1 = FIX(Y1)
  Y2 = FIX(Y2)
  
  ;get min and max values
  Ymin = MIN([Y1,Y2],MAX=Ymax)
  nbr_y = (Ymax-Ymin+1)
  
  ;open output file
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    message = 'ERROR: Error creating the data back. ROI ' + roi_file_name
    IDLsendToGeek_addLogBookText, Event, message
  ENDIF ELSE BEGIN
    OPENW, 1, roi_file_name
    i     = 0L
    NyMax = 256L
    OutputArray = STRARR((NyMax)*nbr_y)
    
    IF (instrument EQ 'REF_M') THEN BEGIN
    
      FOR y=(Ymin),(Ymax) DO BEGIN
        FOR x=0,(NyMax-1) DO BEGIN
          text  = 'bank1_' + STRCOMPRESS(y,/REMOVE_ALL)
          text += '_' + STRCOMPRESS(x,/REMOVE_ALL)
          PRINTF,1,text
          OutputArray[i] = text
          i++
        ENDFOR
      ENDFOR
      
    ENDIF ELSE BEGIN
    
      FOR x=0,(NyMax-1) DO BEGIN
        FOR y=(Ymin),(Ymax) DO BEGIN
          text  = 'bank1_' + STRCOMPRESS(x,/REMOVE_ALL)
          text += '_' + STRCOMPRESS(y,/REMOVE_ALL)
          PRINTF,1,text
          OutputArray[i] = text
          i++
        ENDFOR
      ENDFOR
    ENDELSE
    
    CLOSE, 1
    FREE_LUN, 1
  ENDELSE ;end of (Ynbr LE 1)
  
  ERROR:
  
END

;+
; :Description:
;    Create the roi file each time the user change the data/spin state or the
;    roi y1 and/or y2
;
; :Params:
;    Event
;
; :Author: j35
;-
PRO reduce_step1_save_back_roi, event
  compile_opt idl2
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  _y1 = strcompress(getTextFieldValue(event,$
    'reduce_step1_create_back_roi_y1_value'),/remove_all)
    
  _y2 = strcompress(getTextFieldValue(event,$
    'reduce_step1_create_back_roi_y2_value'),/remove_all)
    
  if (_y1 eq '' or _y2 eq '') then return
  
  y1 = fix(_y1)
  y2 = fix(_y2)
  
  path = (*global).ascii_path
  ; print, "In reduce_step2_save_roi_step2 - path: ",path
  
  back_file = getDefaultReduceStep1BackRoiFileName(event)
  back_file_name = path + back_file
  
  create_data_back_roi, Event, $
    roi_file_name=back_file_name, $
    y1=y1, $
    y2=y2
    
  ;save data back roi file name in table
  nexus_spin_state_data_back_roi_table = $
    (*(*global).nexus_spin_state_data_back_roi_table)
    
  row = getPreviousSangleRowSelected(Event)
  index_spin = 0
  case (strlowcase(getSangleSpinStateSelected(Event))) of
    'off_off': index_spin=0
    'off_on': index_spin=1
    'on_off': index_spin=2
    'on_on': index_spin=3
  endcase
  
  nexus_spin_state_data_back_roi_table[index_spin,row] = back_file_name
  (*(*global).nexus_spin_state_data_back_roi_table) = $
    nexus_spin_state_data_back_roi_table
    
END


;+
; :Description:
;    This populate the y1 and y2 data back widgets with the values
;    reported in the data background file loaded for that particular
;    data run / spin state
;
; :Params:
;    event
;
; :Author: j35
;-
pro load_step1_data_back_roi, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;save data back roi file name in table
  nexus_spin_state_data_back_roi_table = $
    (*(*global).nexus_spin_state_data_back_roi_table)
    
  row = getSangleRowSelected(Event)
  print, 'row selected is : ' , row
  index_spin = 0
  case (strlowcase(getSangleSpinStateSelected(Event))) of
    'off_off': index_spin=0
    'off_on': index_spin=1
    'on_off': index_spin=2
    'on_on': index_spin=3
  endcase
  
  back_file_name = nexus_spin_state_data_back_roi_table[index_spin,row]

  if (file_test(back_file_name)) then begin
  
    Yarray = retrieveYminMaxFromFile(event,back_file_name)
    Y1 = Yarray[0]
    Y2 = Yarray[1]
    
  endif else begin
  
    Y1 = ''
    Y2 = ''
    
  endelse
  
  putTextFieldValue, Event, 'reduce_step1_create_back_roi_y1_value', $
    STRCOMPRESS(Y1,/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_step1_create_back_roi_y2_value', $
    STRCOMPRESS(Y2,/REMOVE_ALL)
    
end

