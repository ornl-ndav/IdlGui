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

;this function is going to retrive the data from bank1, bank2, bank3 and bank4
;
;and save them in (*(*global).bank1) and (*(*global).bank2) ....
PRO retrieveBanksData, Event, FullNexusName

  activate_base, event, 'loading_progress_base_uname', 1
  putValue, event, 'loading_progress_label', $
    'Loading in progress .... retrieving Bank1 !'
    
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  fileID  = h5f_open(FullNexusName)
  ;get bank1 data
  fieldID = h5d_open(fileID,(*global).nexus_bank1_path)
  bank1 = h5d_read(fieldID)
  h5d_close, fieldID
  
  ;  sz = size(bank1,/dim)
  ;  Nx = sz[2]
  ;  Ny = sz[1]
  ;  (*global).Nx = Nx
  ;  (*global).Ny = Ny
  
  putValue, event, 'loading_progress_label', $
    'Loading in progress .... retrieving Bank2 !'
    
  ;get bank2 data
  fieldID = h5d_open(fileID,(*global).nexus_bank2_path)
  bank2 = h5d_read(fieldID)
  h5d_close, fieldID
  
  (*(*global).bank1) = bank1
  (*(*global).bank2) = bank2
  
  _bank1 = total(bank1,1)
  _bank2 = total(bank2,1)
  
  (*(*global).bank1_raw_value) = _bank1
  (*(*global).bank2_raw_value) = _bank2
  
  ;this will work only for the new BSS nexus files
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    activate_button, event, 'banks_north_uname', 0
    activate_base, event, 'loading_progress_base_uname', 0
  endif else begin
  
    putValue, event, 'loading_progress_label', $
      'Loading in progress .... retrieving Bank3 !'
      
    fieldID = h5d_open(fileID,(*global).nexus_bank3_path)
    bank3 = h5d_read(fieldID)
    h5d_close, fieldID
    
    putValue, event, 'loading_progress_label', $
      'Loading in progress .... retrieving Bank4 !'
      
    fieldID = h5d_open(fileID,(*global).nexus_bank4_path)
    bank4 = h5d_read(fieldID)
    h5d_close, fieldID
    
    (*(*global).bank3) = bank3
    (*(*global).bank4) = bank4
    
    _bank3 = total(bank3,1)
    _bank4 = total(bank4,1)
    
    (*(*global).bank3_raw_value) = _bank3
    (*(*global).bank4_raw_value) = _bank4
    
    activate_button, event, 'banks_north_uname', 1
    
  endelse
  
  ;try to retrieve the diffraction bank
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    activate_button, event, 'diff_bank_uname', 0
    activate_base, event, 'loading_progress_base_uname', 0
  endif else begin
  
    nbr_diff_banks = 9
    
    list_banks = strcompress(indgen(nbr_diff_banks) + 5, /remove_all)
    path1 = '/entry-diff/bank'
    path = path1 +list_banks + '/data/'
    
    diff_bank_data = !null
    for i=0, (nbr_diff_banks-1) do begin
    
      putValue, event, 'loading_progress_label', $
        'Loading in progress .... retrieving diffraction Bank' + $
        strcompress(i+5,/remove_all) + ' !'
      fieldID = h5d_open(fileID, path[i])
      _bank = transpose(h5d_read(fieldID))
      diff_bank_data = [diff_bank_data, _bank]
      h5d_close, fieldID
      
    endfor
    
    (*(*global).diff_raw_data) = diff_bank_data
    
    activate_button, event, 'diff_bank_uname', 1
    
  endelse
  
  h5f_close, fileID
  
  activate_base, event, 'loading_progress_base_uname', 0
  
END

;------------------------------------------------------------------------------
PRO bss_reduction_LoadNexus, Event, config

  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  PROCESSING = (*global).processing
  OK = (*global).ok
  FAILED = (*global).failed
  
  isNeXusExist = 0 ;by default, NeXus does not exist
  
  ;get run number
  RunNumber           = getRunNumber(Event)
  (*global).RunNumber = RunNumber
  
  IF (RunNumber NE '') THEN BEGIN ;continue only if there is a run number
  
    message = 'Loading Run Number ' + strcompress(RunNumber,/remove_all) + ':'
    InitialLogBookMessage = getLogBookText(Event)
    IF (InitialLogBookMessage[0] EQ '') THEN BEGIN
      PutLogBookMessage, Event, message
    ENDIF ELSE BEGIN
      AppendLogBookMessage, Event, message
    ENDELSE
    
    text = 'Loading Run Number ' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
    text += ' ... (' + PROCESSING + ')'
    putMessageBoxInfo, Event, text
    
    message = '  -> Checking if run number exists ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    
    if (!VERSION.os EQ 'darwin') then begin
      NexusFullPath = (*global).nexus_full_path
      isNeXusExist = 1
    endif else begin
      NexusFullPath = find_full_nexus_name(Event, RunNumber, isNeXusExist)
    endelse
    
    IF (isNexusExist) THEN BEGIN
    
      value_north = '  Banks North (3 and 4)'
      value_south = '> Banks South (1 and 2)'
      putValue, event, 'banks_north_uname', value_north
      putValue, event, 'banks_south_uname', value_south
      (*global).banks_displayed = 'south_1_2'
      
      ;initialize pixeld_excluded
      ;(*(*global).pixel_excluded) = (*(*global).default_pixel_excluded)
      
      (*global).RunNumber = RunNumber
      
      putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
      
      ;move on to step2 of loading nexus
      BSSreduction_LoadNexus_step2, Event, NexusFullPath[0], isNexusExist
      
      NexusFullName = strcompress(NexusFullPath[0],/remove_all)
      (*global).NexusFullName = NexusFullName
      
      IF (N_ELEMENTS(config) EQ 0) THEN BEGIN
      
        ;put nexus file name in data text field (Reduce tab#1)
        ;putReduceRawSampleDatafile, Event, NexusFullName
        putTextFieldValue, event, 'rsdf_run_number_cw_field', $
          strcompress(RunNumber,/remove_all), 0
          
      ENDIF
      
    ENDIF ELSE BEGIN         ;tells that we didn't find the nexus file
    
      ;display full name of nexus in his label
      PutNexusNameInLabel, Event, 'N/A'
      putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
      
      text = 'Loading Run Number ' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
      text += ' ... FAILED'
      putMessageBoxInfo, Event, text
      
    ENDELSE
    
  ENDIF
  
  (*global).NeXusFound = isNexusExist
  
  IF ((*global).NeXusFound) THEN BEGIN
    ;turn off the NO MONITOR NORMALIZATION switch
    SetButton, event, 'nmn_button', 0
  ENDIF
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END

;------------------------------------------------------------------------------
PRO load_live_nexus, Event, full_nexus_file_name

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  message = '-> Loading Live Data NeXus file'
  InitialLogBookMessage = getLogBookText(Event)
  AppendLogBookMessage, Event, message
  
  text = message
  text += ' ... ' + PROCESSING
  putMessageBoxInfo, Event, text
  
  ;initialize pixeld_excluded
  (*(*global).pixel_excluded) = (*(*global).default_pixel_excluded)
  
  ;move on to step2 of loading nexus
  load_live_nexus_step2, Event, full_nexus_file_name
  (*global).NexusFullName = full_nexus_file_name
  
  IF (N_ELEMENTS(config) EQ 0) THEN BEGIN
  
    iNexus = OBJ_NEW('IDLgetMetadata', full_nexus_file_name)
    RunNumber = iNexus->getRunNumber()
    OBJ_DESTROY, iNexus
    putRunNumberValue, Event, RunNumber
  ;    putValue, event, 'rsdf_run_number_cw_field', $
  ;      strcompress(RunNumber,/remove_all)
    
  ENDIF
  
  (*global).NeXusFound = 1
  
  IF ((*global).NeXusFound) THEN BEGIN
    ;turn on the NO MONITOR NORMALIZATION switch
    SetButton, event, 'nmn_button', 1
  ENDIF ELSE BEGIN
    SetButton, event, 'nmn_button', 0
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO load_live_nexus_step2, Event, NexusFullName

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  message = '  -> NeXus file location: ' + NexusFullName
  AppendLogBookMessage, Event, message
  
  ;retrieve bank1 and bank2
  message = '  -> Retrieving bank1 and bank2 data ... ' + PROCESSING
  AppendLogBookMessage, Event, message
  
  ;check if file is hdf5
  nexus_file_name = sTRCOMPRESS(NeXusFullName,/REMOVE_ALL)
  IF (H5F_IS_HDF5(nexus_file_name)) THEN BEGIN
  
    retrieveBanksData, Event, strcompress(NexusFullName,/remove_all)
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
    ;plot bank1 and bank2
    message = '  -> Plot bank1 and bank2 ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    success = 0
    bss_reduction_PlotBanks, Event, success
  ENDIF ELSE BEGIN
    success = 0
  ENDELSE
  
  sRunNumber = STRCOMPRESS((*global).RunNumber,/REMOVE_ALL)
  IF (sRunNumber EQ '') THEN BEGIN
    sRunNumber = 'N/A'
  ENDIF
  
  IF (success EQ 0) THEN BEGIN
  
    putTextAtEndOfLogBookLastLine, Event, FAILED + $
      ' --> Wrong NeXus Format!', PROCESSING
    (*global).NeXusFound = 0
    (*global).NexusFormatWrong = 1 ;wrong format
    ;desactivate button
    activate_status = 0
    
    text = 'Loading Live NeXus file of run ' + sRunNumber
    text += ' ... FAILED'
    putMessageBoxInfo, Event, text
    
  ENDIF ELSE BEGIN
  
    (*global).NexusFormatWrong = 0 ;right format
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
    
    ;plot counts vs TOF of full selection
    message = '  -> Plot Counts vs TOF of full selection ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    
    IF ((*global).true_full_x_min EQ 0.0000001) THEN BEGIN
      BSSreduction_PlotCountsVsTofOfSelection, Event
    ENDIF ELSE BEGIN
      BSSreduction_PlotCountsVsTofOfSelection_Light, Event
      BSSreduction_DisplayLinLogFullCountsVsTof, Event
    ENDELSE
    
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
    
    ;populate ROI file name
    BSSreduction_CreateRoiFileName, Event
    
    ;plot ROI
    PlotIncludedPixels, Event
    
    ;activate button
    activate_status = 1
    
    text = 'Loading Live NeXus file of run ' + sRunNumber
    text += ' ... OK'
    putMessageBoxInfo, Event, text
    
    ;define default output file name
    ;    define_default_output_file_name, Event, TYPE='live' ;_eventcb
    
    (*global).lds_mode = 1
    
  ENDELSE
  
  ;activate or not 'save_roi_file_button', 'roi_path_button',
  ;'roi_file_name_generator', 'load_roi_file_button'
  ActivateArray = (*(*global).WidgetsToActivate)
  sz = (size(ActivateArray))(1)
  FOR i=0,(sz-1) DO BEGIN
    activate_button, event, ActivateArray[i], activate_status
  ENDFOR
  
END
