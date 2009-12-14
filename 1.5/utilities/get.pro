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
FUNCTION getBankNumber, tube
  local_tube = tube - 1
  bank = local_tube / 8
  IF ((tube MOD 2) EQ 0) THEN bank += 24 ;even tube
  RETURN, bank+1
END

;------------------------------------------------------------------------------
FUNCTION getTubeLocal, tube
  local_tube = tube - 1
  IF (local_tube mod 2 EQ 1) THEN BEGIN ;odd
    local_tube--
  ENDIF
  real_local_tube = local_tube MOD 8
  real_local_tube = real_local_tube / 2
  RETURN, real_local_tube
END

;------------------------------------------------------------------------------
;Input bank and tube (bank starts at 1)
;bank      1 25  1 25  1 25  1 25  2 26  2 26 ...
;tube      0  0  1  1  2  2  3  3  0  0  1  1 ...
;real_tube 0  1  2  3  4  5  6  7  8  9 10 11
;output real tube number (starting at 0)
FUNCTION getTubeGlobal, bank, tube
  IF (bank LT 25) THEN BEGIN ;front panel
    RETURN, (bank - 1) * 8 + 2 * tube - 1
  ENDIF ELSE BEGIN ;back panel
    RETURN, (bank - 25) * 8 + 2*tube
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getTextFieldValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value[0]
END

FUNCTION getTextFieldValue_from_base, base, uname
  id = WIDGET_INFO(base,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value[0]
END
;------------------------------------------------------------------------------
;This function retrieves the run number of the First tab
FUNCTION getRunNumber, Event
  RETURN, getTextFieldValue(Event,'run_number_cw_field')
END

;------------------------------------------------------------------------------
FUNCTION getProposalIndex, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='proposal_droplist')
  index = WIDGET_INFO(id, /droplist_select)
  RETURN, index
END

;------------------------------------------------------------------------------
FUNCTION getProposalSelected, Event, index
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='proposal_droplist')
  index = WIDGET_INFO(id, /droplist_select)
  WIDGET_CONTROL, id, GET_VALUE=list
  RETURN, list[index]
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getPanelSelected, Event

  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
  value = WIDGET_INFO(id, /BUTTON_SET)
  IF (value EQ 1) THEN RETURN, 'both'
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_front_bank_button')
  value = WIDGET_INFO(id, /BUTTON_SET)
  IF (value EQ 1) THEN RETURN, 'front'
  
  RETURN, 'back'
  
END

;------------------------------------------------------------------------------
PRO getXYposition, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x = Event.x
  y = Event.y
  IF ((*global).facility EQ 'LENS') THEN BEGIN
  
    IF ((*global).Xpixel  EQ 80L) THEN BEGIN
      Xcoeff = 8
    ENDIF ELSE BEGIN
      Xcoeff = 2
    ENDELSE
    ScreenX = x / Xcoeff
    ScreenY = y / Xcoeff
    
  ENDIF ELSE BEGIN ;SNS
  
    ;check if both panels are plotted
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
    value = WIDGET_INFO(id, /BUTTON_SET)
    coeff = 0.5
    IF (value EQ 1) THEN coeff = 1
    ScreenX = FIX(FLOAT(x) / (*global).congrid_x_coeff * coeff)
    ScreenY = FIX(FLOAT(y) / (*global).congrid_y_coeff)
    
    panel_selected = getPanelSelected(Event)
    CASE (panel_selected) OF
      'front': BEGIN
        ScreenX *= 2
      END
      'back': BEGIN
        ScreenX = ScreenX * 2 + 1
      END
      ELSE:
    ENDCASE
    
  ENDELSE
  putTextFieldValue, Event, 'x_value', STRCOMPRESS(ScreenX,/REMOVE_ALL)
  putTextFieldValue, Event, 'y_value', STRCOMPRESS(ScreenY,/REMOVE_ALL)
  
  IF ((*global).facility EQ 'SNS') THEN BEGIN
  
    bank = getBankNumber(ScreenX+1)
    tube_local = getTubeLocal(ScreenX+1)
    
    putTextFieldValue, Event, 'bank_number_value', STRCOMPRESS(bank,/REMOVE_ALL)
    putTextFieldValue, Event, 'tube_local_number_value', $
      STRCOMPRESS(tube_local,/REMOVE_ALL)
      
  ENDIF
END

;------------------------------------------------------------------------------
FUNCTION getDefaultReduceFileName, Event, FullFileName, RunNumber = RunNumber
  IF (N_ELEMENTS(RunNumber) EQ 0) THEN BEGIN
    iObject = OBJ_NEW('IDLgetMetadata',FullFileName)
    IF (OBJ_VALID(iObject)) THEN BEGIN
      RunNumber = iObject->getRunNumber()
    ENDIF ELSE BEGIN
      RunNumber = ''
    ENDELSE
  ENDIF
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  IF ((*global).facility EQ 'SNS') THEN BEGIN
    default_name = 'EQSANS'
  ENDIF ELSE BEGIN
    default_name = 'SANS'
  ENDELSE
  IF (RunNumber NE '') THEN BEGIN
    default_name += '_' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
  ENDIF
  DateIso = GenerateIsoTimeStamp()
  default_name += '_' + DateIso
  default_name += '.txt'
  RETURN, default_name
END

;------------------------------------------------------------------------------
FUNCTION getDefaultROIFileName, Event, FullFileName, RunNumber = RunNumber
  IF (N_ELEMENTS(RunNumber) EQ 0) THEN BEGIN
    iObject = OBJ_NEW('IDLgetMetadata',FullFileName)
    IF (OBJ_VALID(iObject)) THEN BEGIN
      RunNumber = iObject->getRunNumber()
    ENDIF ELSE BEGIN
      RunNumber = ''
    ENDELSE
  ENDIF
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  IF ((*global).facility EQ 'SNS') THEN BEGIN
    default_name = 'EQSANS'
  ENDIF ELSE BEGIN
    default_name = 'SANS'
  ENDELSE
  IF (RunNumber NE '') THEN BEGIN
    default_name += '_' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
  ENDIF
  DateIso = GenerateIsoTimeStamp()
  default_name += '_' + DateIso
  default_name += '_ROI.dat'
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  roi_path = (*global).selection_path
  default_name = roi_path + default_name
  
  RETURN, default_name
END

;------------------------------------------------------------------------------
FUNCTION getRoiFileName, Event
  FileName = getTextFieldValue(Event,'roi_file_name_text_field')
  RETURN, FileName
END

;------------------------------------------------------------------------------
FUNCTION  getRealDataX, Event, x0_data

  ;go 2 by 2 for front and back panels only
  ;start at 1 if back panel
  panel_selected = getPanelSelected(Event)
  CASE (panel_selected) OF
    'front': BEGIN
      x0_data /= 2
    END
    'back': BEGIN
      x0_data = (x0_data - 1 ) / 2
    END
    ELSE:
  ENDCASE
  
END

;------------------------------------------------------------------------------
FUNCTION getTransManualStep1Tube, event_x
  x_data = FIX(event_x/14.0625)+80
  RETURN, x_data
END

;------------------------------------------------------------------------------
FUNCTION getTransManualStep1Pixel, event_y
  y_data = FIX(event_y/10+112)
  RETURN, y_data
END

;------------------------------------------------------------------------------
FUNCTION getTransManualStep1Counts, Event, tube, pixel
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  new_tube = tube - (*global).xoffset_plot
  new_pixel = pixel - (*global).yoffset_plot
  
  tt_zoom_data = (*(*global).tt_zoom_data)
  counts = tt_zoom_data[new_tube,new_pixel]
  RETURN, FIX(counts)
END

;------------------------------------------------------------------------------
FUNCTION getTransManualStep3Tube, Event
  event_x = Event.x
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  draw_xsize = 400.
  tube_min =  (*global).step3_tube_min
  tube_max = (*global).step3_tube_max + 1
  coeff = draw_xsize / FLOAT(tube_max - tube_min)
  x_data = FIX(FLOAT(event_x)/coeff + FLOAT(tube_min))
  RETURN, x_data
END

;------------------------------------------------------------------------------
FUNCTION getTransManualStep3Pixel, Event
  event_y = Event.y
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  draw_ysize = 300.
  pixel_min = (*global).step3_pixel_min
  pixel_max = (*global).step3_pixel_max + 1
  coeff = draw_ysize / FLOAT(pixel_max - pixel_min)
  y_data = FIX(FLOAT(event_y)/coeff + FLOAT(pixel_min))
  RETURN, y_data
END

;------------------------------------------------------------------------------
FUNCTION getTransManualStep3Counts, Event, tube, pixel
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN RETURN, 'N/A'
  
  new_tube = tube - (*global).step3_tube_min
  new_pixel = pixel - (*global).step3_pixel_min
  
  tt_zoom_data = (*(*global).step3_tt_zoom_data)
  counts = tt_zoom_data[new_tube,new_pixel]
  
  RETURN, FIX(counts)
END

;------------------------------------------------------------------------------
FUNCTION getStep3TubeDeviceFromData, Event, tube_data

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  tube_min = (*global).step3_tube_min
  tube_max = (*global).step3_tube_max + 1
  
  offset_tube = tube_data - tube_min
  xsize = 400.
  
  coeff_x = xsize / (FLOAT(tube_max) - FLOAT(tube_min))
  
  tube_device = FIX((offset_tube) * coeff_x)
  
  RETURN, tube_device
END

;------------------------------------------------------------------------------
FUNCTION getStep3PixelDeviceFromData, Event, pixel_data

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  pixel_max = (*global).step3_pixel_max + 1
  pixel_min = (*global).step3_pixel_min
  
  offset_pixel = pixel_data - pixel_min
  
  ysize = 300.
  
  coeff_y = ysize / (FLOAT(pixel_max) - FLOAT(pixel_min))
  
  pixel_device = FIX((offset_pixel) * coeff_y)
  
  RETURN, pixel_device
END

;------------------------------------------------------------------------------
FUNCTION retrieve_distance_moderator_sample, NexusFileName
  path    = '/entry/instrument/moderator/distance/'
  fileID  = H5F_OPEN(NexusFileName)
  fieldID = H5D_OPEN(fileID, path)
  distance = H5D_READ(fieldID)
  RETURN, ABS(distance)
END

;------------------------------------------------------------------------------
FUNCTION retrieve_distance_bc_pixel_sample, NexusFileName, bank, tube, pixel
  path = '/entry/instrument/bank' + STRCOMPRESS(bank,/REMOVE_ALL)
  path += '/distance/'
  fileID  = H5F_OPEN(NexusFileName)
  fieldID = H5D_OPEN(fileID, path)
  distance_array = H5D_READ(fieldID)
  
  ;get local_tube value within bank
  tube_local = getTubeLocal(tube+1) ;+1 because tube 1 is supposed to be the 1st tube
  
  RETURN, ABS(distance_array[pixel,tube_local])
END

;------------------------------------------------------------------------------
FUNCTION getTOFarray, Event, NexusFileName
  path = '/entry/bank1/time_of_flight/'
  fileID  = H5F_OPEN(NexusFileName)
  fieldID = H5D_OPEN(fileID, path)
  tof_array = H5D_READ(fieldID)
  RETURN, tof_array
END

;------------------------------------------------------------------------------
FUNCTION getNexusRunNumber, nexus_file_name
  fileID = h5f_open(nexus_file_name)
  run_number_path = '/entry/run_number/'
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
  ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID, run_number_path)
    run_number = h5d_read(pathID)
    h5d_close, pathID
    RETURN, run_number
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getTransAutoCounts, wBase=wBase, Event=event, tube, pixel

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN RETURN, 'N/A'
  
  new_tube = tube - (*global).tube_min
  new_pixel = pixel - (*global).pixel_min
  
  tt_zoom_data = (*(*global).tt_zoom_data)
  
  counts = tt_zoom_data[new_tube,new_pixel]
  
  RETURN, FIX(counts)
END

;------------------------------------------------------------------------------
FUNCTION getAutoTubeDeviceFromData, wBase=wBase, Event=event, tube_data

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  
  tube_min = (*global).tube_min
  tube_max = (*global).tube_max + 1
  
  offset_tube = tube_data - tube_min
  xsize = 350.
  
  coeff_x = xsize / (FLOAT(tube_max) - FLOAT(tube_min))
  
  tube_device = FIX((offset_tube) * coeff_x)
  
  RETURN, tube_device
END

;------------------------------------------------------------------------------
FUNCTION getAutoPixelDeviceFromData, wBase=wBase, Event=event, pixel_data

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  
  pixel_max = (*global).pixel_max + 1
  pixel_min = (*global).pixel_min
  
  offset_pixel = pixel_data - pixel_min
  
  ysize = 300.
  
  coeff_y = ysize / (FLOAT(pixel_max) - FLOAT(pixel_min))
  
  pixel_device = FIX((offset_pixel) * coeff_y)
  
  RETURN, pixel_device
END

;------------------------------------------------------------------------------
FUNCTION getCurrentTabSelect, Event, uname
  tab_id = widget_info(Event.top,FIND_BY_UNAME=uname)
  CurrTabSelect = widget_info(tab_id,/TAB_CURRENT)
  RETURN, CurrTabSelect
END

;------------------------------------------------------------------------------
FUNCTION getBeamCenterTubeDevice_from_data, data_value, global

  draw_xsize = (*global).main_draw_xsize
  tube_max   = (*global).max_tube_plotted+1
  tube_min   = (*global).min_tube_plotted
  
  offset_tube = data_value - tube_min
  coeff_x = FLOAT(draw_xsize) / (FLOAT(tube_max) - FLOAT(tube_min))
  tube_device = FIX((offset_tube * coeff_x))
  RETURN, tube_device
END

;..............................................................................
FUNCTION getBeamCenterTubeData_from_device, device_value, global

  draw_xsize = FLOAT((*global).main_draw_xsize)
  tube_max   = FLOAT((*global).max_tube_plotted+1)
  tube_min   = FLOAT((*global).min_tube_plotted)
  
  data = FLOAT(device_value) * (tube_max + 1 - tube_min)
  data /= draw_xsize
  data += tube_min
  
  RETURN, FIX(data)
END

;------------------------------------------------------------------------------
FUNCTION getBeamCenterPixelDevice_from_data, data_value, global

  draw_ysize  = (*global).main_draw_ysize
  pixel_max   = (*global).max_pixel_plotted+1
  pixel_min   = (*global).min_pixel_plotted
  
  offset_pixel = data_value - pixel_min
  coeff_x = FLOAT(draw_ysize) / (FLOAT(pixel_max) - FLOAT(pixel_min))
  pixel_device = FIX((offset_pixel * coeff_x))
  RETURN, pixel_device
END

;..............................................................................
FUNCTION getBeamCenterPixelData_from_device, device_value, global

  draw_ysize = FLOAT((*global).main_draw_ysize)
  pixel_max   = FLOAT((*global).max_pixel_plotted+1)
  pixel_min   = FLOAT((*global).min_pixel_plotted)
  
  data = FLOAT(device_value) * (pixel_max + 1 - pixel_min)
  data /= draw_ysize
  data += pixel_min
  
  RETURN, FIX(data)
END

;----------------------------------------------------------------------------
FUNCTION getBeamCenterCounts, Event, tube, pixel
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 'N/A'
  ENDIF
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  tt_zoom_data = (*(*global).tt_zoom_data)
  min_pixel_plotted = (*global).min_pixel_plotted
  min_tube_plotted  = (*global).min_tube_plotted
  tube_offset = tube - min_tube_plotted
  pixel_offset = pixel - min_pixel_plotted
  counts = tt_zoom_data[tube_offset, pixel_offset]
  RETURN, LONG(counts)
END

;-----------------------------------------------------------------------------
;returns [geometry file,translation file,mapping file]
FUNCTION get_up_to_date_geo_tran_map_file, instrument=instrument
  IF (N_ELEMENTS(instrument) EQ 0) THEN instrument = 'EQSANS'
  cmd = 'findcalib -i' + instrument
  spawn, cmd, listening, err_listening
  IF (err_listening[0] NE '') THEN BEGIN
    RETURN = STRARR(3)
  ENDIF ELSE BEGIN
    RETURN, listening
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION get_up_to_date_geo_file, instrument=instrument
  IF (N_ELEMENTS(instrument) EQ 0) THEN instrument = 'EQSANS'
  cmd = 'findcalib -g -i' + instrument
  spawn, cmd, listening, err_listening
  IF (err_listening[0] NE '') THEN BEGIN
    RETURN = ''
  ENDIF ELSE BEGIN
    RETURN, listening[0]
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION isButtonSelected, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  result = WIDGET_INFO(id, /BUTTON_SET)
  RETURN, result
END

FUNCTION getPlotTabYaxisScale, Event
  ;linear
  uname = 'plot_tab_y_axis_lin'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'lin'
  ;log
  uname = 'plot_tab_y_axis_log'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'log'
  ;log(Q.I(Q))
  uname = 'plot_tab_y_axis_log_Q_IQ'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'log_Q_IQ'
  ;log(Q^2.I(Q))
  uname = 'plot_tab_y_axis_log_Q2_IQ'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'log_Q2_IQ'
  RETURN, ''
END

FUNCTION getPlotTabXaxisScale, Event
  ;linear
  uname = 'plot_tab_x_axis_lin'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'lin'
  ;log
  uname = 'plot_tab_x_axis_log'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'log'
  ;log(Q.I(Q))
  uname = 'plot_tab_x_axis_Q2'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'Q2'
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION getFittingEquationToShow, Event

  xaxis = getPlotTabXaxisScale(Event)
  yaxis = getPlotTabYaxisScale(Event)
  
  IF( xaxis NE 'Q2') THEN RETURN, 'no'
  
  IF (yaxis EQ 'log') THEN RETURN, 'rg'
  IF (yaxis EQ 'log_Q_IQ') THEN RETURN, 'rc'
  IF (yaxis EQ 'log_Q2_IQ') THEN RETURN, 'rt'
  
  RETURN, 'no'
  
END

;------------------------------------------------------------------------------
FUNCTION get_data_run_number, nexus_file_name

  iNexus = OBJ_NEW('IDLgetNexusRunNumber',nexus_file_name[0])
  run_number = iNexus->getIDLnexusRunNumber()
  RETURN, run_number
  
END

