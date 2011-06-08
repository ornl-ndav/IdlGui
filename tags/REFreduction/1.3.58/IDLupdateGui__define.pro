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
;WORK ON DATA FILE ============================================================
FUNCTION ref_l_UpdateMainDataRunNumber, Event, DataRunNumber
  no_error = 0
  CATCH,no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    io_error:
    RETURN,0
  ENDIF ELSE BEGIN
    ON_IOERROR, io_error
    lDataRunNumber = LONG(DataRunNumber)
    putTextFieldValue, Event, $
      'load_data_run_number_text_field', $
      STRCOMPRESS(lDataRunNumber,/REMOVE_ALL),$
      0
  ENDELSE
  RETURN,1
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateAllDataNexusFileName, Event, AllDataNexusFileName
  putTextFieldValue, Event, $
    'reduce_data_runs_text_field',$
    AllDataNexusFileName,$
    0
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateMainDataNexusFileName, Event, MainDataNexusFileName, DataRunNumber
  REFreduction_OpenPlotDataNexus,Event, DataRunNumber, MainDataNexusFileName
END

;------------------------------------------------------------------------------
PRO ref_l_ClearDataRoiFields, Event
  putTextFieldValue, Event, $
    'data_d_selection_roi_ymin_cw_field',$
    '',$
    0
  putTextFieldValue, Event, $
    'data_d_selection_roi_ymax_cw_field',$
    '',$
    0
  REFreduction_NormBackgroundPeakSelection, Event, ''
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateDataRoiFileName, Event, DataRoiFileName
  REFreduction_LoadDataROIFile, Event, DataRoiFileName
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateDataPeakExclY, Event, Ymin, Ymax
  putTextFieldValue, Event, $
    'data_d_selection_peak_ymin_cw_field',$
    Ymin,$
    0
  putTextFieldValue, Event, $
    'data_d_selection_peak_ymax_cw_field',$
    Ymax,$
    0
END

;------------------------------------------------------------------------------
PRO ref_l_ClearDataBackFields, Event
  putTextFieldValue, Event, $
    'data_d_selection_background_ymin_cw_field',$
    '',$
    0
  putTextFieldValue, Event, $
    'data_d_selection_background_ymax_cw_field',$
    '',$
    0
  REFreduction_NormBackgroundPeakSelection, Event, ''
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateDataBackFileName, Event, DataBackFileName
  REFreduction_LoadDataBackFile, Event, DataBackFileName
END

;WORK ON NORMALIZATION FILE ===================================================
FUNCTION ref_l_UpdateMainNormRunNumber, Event, NormRunNumber
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    io_error:
    RETURN,0
  ENDIF ELSE BEGIN
    ON_IOERROR, io_error
    lNormRunNumber = LONG(NormRunNumber)
    putTextFieldValue, Event, $
      'load_normalization_run_number_text_field', $
      STRCOMPRESS(lNormRunNumber,/REMOVE_ALL),$
      0
  ENDELSE
  RETURN,1
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateAllNormNexusFileName, Event, AllNormNexusFileName
  putTextFieldValue, Event, $
    'reduce_normalization_runs_text_field',$
    AllNormNexusFileName,$
    0
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateMainNormNexusFileName, Event, MainNormNexusFileName, NormRunNumber
  REFreduction_OpenPlotNormNexus, Event, NormRunNumber, MainNormNexusFileName
END

;------------------------------------------------------------------------------
PRO ref_l_ClearNormRoiFields, Event
  putTextFieldValue, Event, $
    'norm_d_selection_roi_ymin_cw_field',$
    '',$
    0
  putTextFieldValue, Event, $
    'norm_d_selection_roi_ymax_cw_field',$
    '',$
    0
  REFreduction_NormBackgroundPeakSelection, Event, ''
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateNormRoiFileName, Event, NormRoiFileName
  REFreduction_LoadNormROIFile, Event, NormRoiFileName
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateNormPeakExclY, Event, Ymin, Ymax
  putTextFieldValue, Event, $
    'norm_d_selection_peak_ymin_cw_field',$
    Ymin,$
    0
  putTextFieldValue, Event, $
    'norm_d_selection_peak_ymax_cw_field',$
    Ymax,$
    0
  REFreduction_NormBackgroundPeakSelection, Event, ''
END

;------------------------------------------------------------------------------
PRO ref_l_ClearNormBackFields, Event
  putTextFieldValue, Event, $
    'norm_d_selection_background_ymin_cw_field',$
    '',$
    0
  putTextFieldValue, Event, $
    'norm_d_selection_background_ymax_cw_field',$
    '',$
    0
  REFreduction_NormBackgroundPeakSelection, Event, ''
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateNormBackFileName, Event, NormBackFileName
  REFreduction_LoadNormBackFile, Event, NormBackFileName
END

;WORK ON Qmin, Qmax, Qwidth and Qtype ;========================================
PRO ref_l_UpdateQ, Event, Qmin, Qmax, Qwidth, Qtype
  putTextFieldValue, Event, 'q_min_text_field', Qmin, 0
  putTextFieldValue, Event, 'q_max_text_field', Qmax, 0
  putTextFieldValue, Event, 'q_width_text_field', Qwidth, 0
  IF (Qtype EQ 'lin') THEN BEGIN
    group_value = 0
  ENDIF ELSE BEGIN
    group_value = 1
  ENDELSE
  SetCWBgroup, Event, 'q_scale_b_group', group_value
END

;WORK on TOF cutting ----------------------------------------------------------
PRO ref_l_UpdateTOFcutting, Event, TOFmin, TOFmax
  ;check status of tof units
  if(isTOFcuttingUnits_microS(Event)) then begin
    putTextFieldValue, Event, 'tof_cutting_min', STRCOMPRESS(TOFmin,/REMOVE_ALL)
    putTextFieldValue, Event, 'tof_cutting_max', STRCOMPRESS(TOFmax,/REMOVE_ALL)
  endif else begin
    TOFmin = FLOAT(temporary(TOFmin))/1000.
    TOFmax = FLOAT(temporary(TOFmax))/1000.
    putTextFieldValue, Event, 'tof_cutting_min', STRCOMPRESS(TOFmin,/REMOVE_ALL)
    putTextFieldValue, Event, 'tof_cutting_max', STRCOMPRESS(TOFmax,/REMOVE_ALL)
  endelse
END

;WORK ON EMPTY CELL FILE ======================================================
FUNCTION ref_l_UpdateEmptyCellRunNumber, Event, RunNumber
  no_error = 0
  ;CATCH,no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    io_error:
    RETURN,0
  ENDIF ELSE BEGIN
    ON_IOERROR, io_error
    ;    lEmptyCellRunNumber = LONG(EmptyCellRunNumber)
    putTextFieldValue, Event, $
      'empty_cell_nexus_run_number', $
      STRCOMPRESS(RunNumber,/REMOVE_ALL),$
      0
  ENDELSE
  RETURN,1
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateEmptyCellNexusFileName, Event, full_name, run_number
  OpenPlotEmptyCell, Event, run_number, full_name
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateEmptyCellCoefficient, Event, A, B, C, D

  putTextFieldValue, Event, 'empty_cell_substrate_a', $
    STRCOMPRESS(A,/REMOVE_ALL), 0
  putTextFieldValue, Event, 'empty_cell_substrate_b', $
    STRCOMPRESS(B,/REMOVE_ALL), 0
  putTextFieldValue, Event, 'empty_cell_scaling_factor',$
    STRCOMPRESS(C,/REMOVE_ALL), 0
  putTextFieldValue, Event, 'empty_cell_diameter',$
    STRCOMPRESS(D,/REMOVE_ALL), 0
    
  ;refresh the plot
  update_substrate_equation, Event ;_empty_cell
  
END

;WORK ON AngleValue and AngleError ============================================
PRO ref_l_UpdateAngle, Event, Value, Error, units
  putTextFieldValue, Event, 'detector_value_text_field', Value, 0
  putTextFieldValue, Event, 'detector_error_text_field', Error, 0
  IF (units EQ 'degrees') THEN BEGIN
    group_value = 0
  ENDIF ELSE BEGIN
    group_value = 1
  ENDELSE
  SetCWBgroup, Event, 'detector_units_b_group', group_value
END

;WORK on Filtering Data Flag ==================================================
PRO ref_l_UpdateFilteringDataFlag, Event, FlagStatus
  IF (FlagStatus EQ 'yes') THEN BEGIN
    buttonValue = 0
  ENDIF ELSE BEGIN
    buttonValue = 1
  ENDELSE
  SetCWBgroup, Event, 'filtering_data_cwbgroup', buttonValue
END

;WORK on dt/t Flag ============================================================
PRO ref_l_UpdateDeltaToverTFlag, Event, DeltaToverTFlag
  IF (DeltaToverTFlag EQ 'yes') THEN BEGIN
    buttonValue = 0
  ENDIF ELSE BEGIN
    buttonValue = 1
  ENDELSE
  SetCWBgroup, Event, 'delta_t_over_t_cwbgroup', buttonValue
END

;Work on OverwriteDataInstrumentGeometry ======================================
PRO ref_l_UpdateOverwriteDataInstrGeoFlag, $
    Event, $
    OverwriteDataInstrGeoFlag, $
    DataInstrGeoFileName
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IF (OverwriteDataInstrGeoFlag EQ 'yes') THEN BEGIN
    buttonValue = 0
  ENDIF ELSE BEGIN
    buttonValue = 1
  ENDELSE
  SetCWBgroup, Event, 'overwrite_data_instrument_geometry_cwbgroup', buttonValue
  IF (buttonValue EQ 0) THEN BEGIN ;there is a data geometry file
    ;display short name of geo file
    ShortDataGeoName = ValueAfterLastArg(DataInstrGeoFileName,'/')
    (*global).InstrumentDataGeometryFileName = DataInstrGeoFileName
    putTextFieldValue, $
      Event, $
      'overwrite_data_intrument_geometry_button',$
      ShortDataGeoName,$
      0
    ;show button
    MapBaseStatus = 1
  ENDIF ELSE BEGIN
    MapBaseStatus = 0
  ENDELSE
  MapBase, Event, 'overwrite_data_instrument_geometry_base', MapBaseStatus
END

;Work on OverwriteNormInstrumentGeometry ======================================
PRO ref_l_UpdateOverwriteNormInstrGeoFlag, $
    Event, $
    OverwriteNormInstrGeoFlag, $
    NormInstrGeoFileName
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IF (OverwriteNormInstrGeoFlag EQ 'yes') THEN BEGIN
    buttonValue = 0
  ENDIF ELSE BEGIN
    buttonValue = 1
  ENDELSE
  SetCWBgroup, Event, 'overwrite_norm_instrument_geometry_cwbgroup', buttonValue
  IF (buttonValue EQ 0) THEN BEGIN ;there is a norm geometry file
    ;display short name of geo file
    ShortNormGeoName = ValueAfterLastArg(NormInstrGeoFileName,'/')
    (*global).InstrumentNormGeometryFileName = NormInstrGeoFileName
    putTextFieldValue, $
      Event, $
      'overwrite_norm_instrument_geometry_button',$
      ShortDataGeoName,$
      0
    ;show button
    MapBaseStatus = 1
  ENDIF ELSE BEGIN
    MapBaseStatus = 0
  ENDELSE
  MapBase, Event, 'overwrite_norm_instrument_geometry_base',MapBaseStatus
END

;Work on Output Path and output FileName ======================================
PRO ref_l_UpdateOutputPath, Event, OutputPath
  setButtonValue, Event, 'of_button', OutputPath
    widget_control, event.top, get_uvalue=global
  (*global).dr_output_path = OutputPath
END

;------------------------------------------------------------------------------
PRO ref_l_UpdateOutputFileName, Event, OutputFileName
  putTextFieldValue, Event, 'of_text', OutputFileName, 0
END

;Work on Intermediate files ===================================================
;DataNormCombinedSpecFlag
PRO ref_l_UpdateIntermediateFiles, Event, $
    DataNormCombinedSpecFlag,$
    DataNormCombinedBackFlag,$
    DataNormCombinedSubFlag,$
    RvsTOFFlag,$
    RvsTOFcombinedFlag
    
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IntermPlots = intarr((*global).nbrIntermediateFiles)
  
  IF (DataNormCombinedSpecFlag EQ 'yes') THEN BEGIN
    IntermPlots[0] = 1
    IntermPlots[3] = 1
  ENDIF ELSE BEGIN
    IntermPlots[0] = 0
    IntermPlots[3] = 0
  ENDELSE
  
  IF (DataNormCombinedBackFlag EQ 'yes') THEN BEGIN
    IntermPlots[1] = 1
    IntermPlots[4] = 1
  ENDIF ELSE BEGIN
    IntermPlots[1] = 0
    IntermPlots[4] = 0
  ENDELSE
  
  IF (DataNormCombinedSubFlag EQ 'yes') THEN BEGIN
    IntermPlots[2] = 1
    IntermPlots[5] = 1
  ENDIF ELSE BEGIN
    IntermPlots[2] = 0
    IntermPlots[5] = 0
  ENDELSE
  
  IF (RvsTOFFlag EQ 'yes') THEN BEGIN
    IntermPlots[6] = 1
  ENDIF ELSE BEGIN
    IntermPlots[6] = 0
  ENDELSE
  
  IF (RvsTOFcombinedFlag EQ 'yes') THEN BEGIN
    IntermPlots[7] = 1
  ENDIF ELSE BEGIN
    IntermPlots[7] = 0
  ENDELSE
  
  setCWBgroup, Event, 'intermediate_plot_list', IntermPlots
  
END

;##############################################################################
;******  Class constructor ****************************************************
FUNCTION IDLupdateGui::init, structure

  event = structure.Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  PROCESSING = (*global).processing_message
  OK         = 'OK'
  NO         = '!! NO !!'
  FAILED     = 'FAILED'
  NbrError   = 0
  DataError  = 0
  
  
  ;work on MainDataRunNumber
  text = '--> Display Main Data Run Number ............................. ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  IF (structure.MainDataRunNumber EQ '') THEN BEGIN
    AppendReplaceLogBookMessage, Event, NO, PROCESSING
  ENDIF ELSE BEGIN
    status = ref_l_UpdateMainDataRunNumber(Event, structure.MainDataRunNumber)
    IF (status EQ 0) THEN BEGIN
      AppendReplaceLogBookMessage, Event, FAILED, PROCESSING
      ++NbrError
      ++DataError
    ENDIF ELSE BEGIN
      AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE
  ENDELSE
  
  ;work on AllDataNexusFileName
  text = '--> Display List of All Data Runs (full nexus name) .......... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  IF (structure.AllDataNexusFileName EQ '') THEN BEGIN
    AppendReplaceLogBookMessage, Event, NO, PROCESSING
  ENDIF ELSE BEGIN
    ref_l_UpdateAllDataNexusFileName, Event, structure.AllDataNexusFileName
    AppendReplaceLogBookMessage, Event, OK, PROCESSING
  ENDELSE
  
  ;work on MainDataNexusFileName (Load This Run)
  text = '--> Load and Plot Main Data Run Number ....................... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  IF (structure.MainDataNexusFileName EQ '' OR $
    structure.MainDataRunNumber EQ '') THEN BEGIN
    AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ++NbrError
    ++DataError
  ENDIF ELSE BEGIN
    ref_l_UpdateMainDataNexusFileName, Event, $
      structure.MainDataNexusFileName, $
      structure.MainDataRunNumber
    AppendReplaceLogBookMessage, Event, OK, PROCESSING
  ENDELSE
  
  ;Activate Data Widgets
  text = '--> Activate Data Widgets .................................... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  IF (DataError EQ 0) THEN BEGIN
    updateDataWidget, Event, 1
    AppendReplaceLogBookMessage, Event, OK, PROCESSING
  ENDIF ELSE BEGIN
    updateDataWidget, Event, 0
    AppendReplaceLogBookMessage, Event, NO, PROCESSING
  ENDELSE
  
  ;work on DataRoiFileName
  text = '--> Load Data ROI File ....................................... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  IF (structure.DataRoiFilename EQ '' OR $
    FILE_TEST(structure.DataRoiFilename) NE 1) THEN BEGIN
    AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ++NbrError
    ++DataError
    ref_l_ClearDataRoiFields, Event
  ENDIF ELSE BEGIN
    ref_l_UpdateDataRoiFileName, Event, structure.DataRoiFileName
    AppendReplaceLogBookMessage, Event, OK, PROCESSING
  ENDELSE
  
  ;Activate LOAD DATA ROI file
  ActivateWidget, Event, 'data_roi_load_button', 1
  
  ;check if user wanted peak exclusion or background file
  text = '--> Check status of PEAK or BACKGROUND ?'
  putLogBookMessage, Event, text, APPEND=1
  IF (structure.DataPeakExclYmin EQ '') THEN BEGIN
    text = '---> BACKGROUND'
    dataPeakStatus = 1
  ENDIF ELSE BEGIN
    text = '---> PEAK EXCLUSION'
    dataPeakStatus = 0
  ENDELSE
  putLogBookMessage, Event, text, APPEND=1
  
  ;activate peak or background cw_bgroup
  SetCWBgroup, Event, 'peak_data_back_group', dataPeakStatus
  SwitchPeakBackgroundDataBase, Event
   
  IF (dataPeakStatus EQ 0) THEN BEGIN
    ;work on DataPeakExclYmin and DataPeakExclYmax
    text = '--> Load Data Peak Exclusion Ymin and Ymax ................... ' $
      + PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    ref_l_UpdateDataPeakExclY, Event, $
      structure.DataPeakExclYmin, $
      structure.DataPeakExclYmax
    AppendReplaceLogBookMessage, Event, OK, PROCESSING
  ENDIF ELSE BEGIN
    text = '--> Load Data BACK File ...................................... ' $
      + PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.DataBackFilename EQ '' OR $
      FILE_TEST(structure.DataBackFilename) NE 1) THEN BEGIN
      AppendReplaceLogBookMessage, Event, NO, PROCESSING
      ++NbrError
      ++DataError
      ref_l_ClearDataBackFields, Event
    ENDIF ELSE BEGIN
      ref_l_UpdateDataBackFileName, Event, structure.DataBackFileName
      AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE
  ENDELSE
  ;replot Data (main and selections)
  REFreduction_DataBackgroundPeakSelection, Event, ''
  
  ;TOF cutting
  text = '--> Load TOF cutting min and max ............................. ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateTOFcutting, Event, $
    structure.TOFcuttingMin, $
    structure.TOFcuttingMax
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work on Normalization data files
  IF (structure.MainNormRunNumber NE '') THEN BEGIN
  
    NormError  = 0
    ;work on MainNormRunNumber
    text = '--> Display Main Normalization Run Number .................' + $
      '... ' + PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.MainNormRunNumber EQ '') THEN BEGIN
      AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ENDIF ELSE BEGIN
      status = ref_l_UpdateMainNormRunNumber(Event, structure.MainNormRunNumber)
      IF (status EQ 0) THEN BEGIN
        AppendReplaceLogBookMessage, Event, FAILED, PROCESSING
        ++NbrError
        ++NormError
      ENDIF ELSE BEGIN
        AppendReplaceLogBookMessage, Event, OK, PROCESSING
      ENDELSE
    ENDELSE
    
    ;work on AllNormNexusFileName
    text = '--> Display List of All Normalization Run .................' + $
      '... ' + PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.AllNormNexusFileName EQ '') THEN BEGIN
      AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ENDIF ELSE BEGIN
      ref_l_UpdateAllNormNexusFileName, Event, structure.AllNormNexusFileName
      AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE
    
    ;work on MainNormNexusFileName
    text = '--> Load and Plot Main Normalization Run Number ..........' + $
      '.... ' + PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.MainNormNexusFileName EQ '' OR $
      structure.MainNormRunNumber EQ '') THEN BEGIN
      AppendReplaceLogBookMessage, Event, NO, PROCESSING
      ++NbrError
      ++NormError
    ENDIF ELSE BEGIN
      ref_l_UpdateMainNormNexusFileName, Event, $
        structure.MainNormNexusFileName, $
        structure.MainNormRunNumber
      AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE
    
    ;Activate Norm Widgets
    text = '--> Activate Norm Widgets .................................... ' $
      + PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (NormError EQ 0) THEN BEGIN
      updateNormWidget, Event, 1
      AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDIF ELSE BEGIN
      updateNormWidget, Event, 0
      AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ENDELSE
    
    ;work on NormRoiFileName
    text = '--> Load Normalization ROI File ..........................' + $
      '.... ' + PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.NormRoiFileName EQ '' OR $
      FILE_TEST(structure.NormRoiFilename) NE 1) THEN BEGIN
      AppendReplaceLogBookMessage, Event, NO, PROCESSING
      ++NbrError
      ++NormError
      ref_l_ClearNormRoiFields, Event
    ENDIF ELSE BEGIN
      ref_l_UpdateNormRoiFileName, Event, structure.NormRoiFileName
      AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE
    
    ;Activate LOAD Normalization ROI file
    ActivateWidget, Event, 'norm_roi_load_button', 1
    
    ;check if user wanted peak exclusion or background file
    text = '--> Check status of PEAK or BACKGROUND ?'
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.NormPeakExclYmin EQ '') THEN BEGIN
      text = '---> BACKGROUND'
      normPeakStatus = 1
    ENDIF ELSE BEGIN
      text = '---> PEAK EXCLUSION'
      normPeakStatus = 0
    ENDELSE
    putLogBookMessage, Event, text, APPEND=1
    
    ;activate peak or background cw_bgroup
    SetCWBgroup, Event, 'peak_norm_back_group', normPeakStatus
    SwitchPeakBackgroundNormBase, Event
    
    IF (normPeakStatus EQ 0) THEN BEGIN
      ;work on NormPeakExclYmin and NormPeakExclYmax
      text = '--> Load Normalizaion Peak Exclusion Ymin and Ymax .......' + $
        '.... ' + PROCESSING
      putLogBookMessage, Event, text, APPEND=1
      ref_l_UpdateNormPeakExclY, Event, $
        structure.NormPeakExclYmin, $
        structure.NormPeakExclYmax
      AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDIF ELSE BEGIN
      text = '--> Load Norm. BACK File ................................' + $
        '..... ' + PROCESSING
      putLogBookMessage, Event, text, APPEND=1
      IF (structure.NormBackFilename EQ '' OR $
        FILE_TEST(structure.NormBackFilename) NE 1) THEN BEGIN
        AppendReplaceLogBookMessage, Event, NO, PROCESSING
        ++NbrError
        ++NormError
        ClearNormBackFields, Event
      ENDIF ELSE BEGIN
        ref_l_UpdateNormBackFileName, Event, structure.NormBackFileName
        AppendReplaceLogBookMessage, Event, OK, PROCESSING
      ENDELSE
    ENDELSE
    ;replot Data (main and selections)
    REFreduction_NormBackgroundPeakSelection, Event, ''
    
    ;show the norm step within the REUDCE tab
    NormReducePartGuiStatus, Event, 'show'
    
  ENDIF ELSE BEGIN
  
    (*global).NormNexusFound = 0
    ;hide the norm step within the REUDCE tab
    NormReducePartGuiStatus, Event, 'hide'
    
  ENDELSE
    
  ;Work on Qmin, Qmax, Qwidth and Qtype
  text = '--> Load Qmin, Qmax, Qwidth and Qtype ........................ ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateQ, Event, $
    structure.Qmin, $
    structure.Qmax, $
    structure.Qwidth, $
    structure.Qtype
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work on AngleValue and AngleError
  text = '--> Load Angle Value and Error ............................... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateAngle, Event, $
    structure.AngleValue, $
    structure.AngleError, $
    structure.AngleUnits
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work on filtering flag
  text = '--> Load on Filtering Data Flag .............................. ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateFilteringDataFlag, Event, structure.FilteringDataFlag
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work on dt/t flag
  text = '--> Load on dt/t Flag ........................................ ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateDeltaToverTFlag, Event, structure.DeltaToverTFlag
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work on OverwriteDataInstrGeoFlag and DataInstrGeoFilename
  text = '--> Load Overwrite Data Instrument Geometry Flag ............. ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateOverwriteDataInstrGeoFlag, Event, $
    structure.OverwriteDataInstrGeoFlag, $
    structure.DataInstrGeoFileName
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work on OverwriteNormInstrGeoFlag and NormInstrGeoFileName
  text = '--> Load Overwrite Normalization Instrument Geometry Flag .... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateOverwriteNormInstrGeoFlag, Event, $
    structure.OverwriteNormInstrGeoFlag, $
    structure.NormInstrGeoFileName
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work on Output Path and Output File Name
  text = '--> Load Output Path ......................................... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateOutputPath, Event, structure.OutputPath
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  text = '--> Load Output File Name .................................... ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateOutputFileName, Event, structure.OutputFileName
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  ;Work Intermediate Files
  ;Data/Norm Combined Spec Flag
  text = '--> Load Intermediate Files .................................. ' $
    + PROCESSING
  putLogBookMessage, Event, text, APPEND=1
  ref_l_UpdateIntermediateFiles, Event, $
    structure.DataNormCombinedSpecFlag,$
    structure.DataNormCombinedBackFlag,$
    structure.DataNormCombinedSubFlag,$
    structure.RvsTOFFlag,$
    structure.RvsTOFcombinedFlag
  AppendReplaceLogBookMessage, Event, OK, PROCESSING
  
  IF (NbrError GT 0) THEN RETURN, 0
  RETURN, 1
  
END

;******************************************************************************
;*****  Class Define **** *****************************************************
PRO IDLupdateGui__define
  STRUCT = {IDLupdateGui,$
    var : ''}
END
;******************************************************************************
;******************************************************************************
