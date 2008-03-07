;*******************************************************************************

;WORK ON DATA FILE =============================================================

PRO UpdateMainDataRunNumber, Event, DataRunNumber
putTextFieldValue, Event, $
  'load_data_run_number_text_field', $
  LONG(DataRunNumber),$
  0
END

PRO UpdateAllDataNexusFileName, Event, AllDataNexusFileName
putTextFieldValue, Event, $
  'reduce_data_runs_text_field',$
  AllDataNexusFileName,$
  0
END

PRO UpdateMainDataNexusFileName, Event, MainDataNexusFileName, DataRunNumber
REFreduction_OpenPlotDataNexus, Event, DataRunNumber, MainDataNexusFileName
END

PRO UpdateDataRoiFileName, Event, DataRoiFileName
putTextFieldValue, Event, $
  'data_background_selection_file_text_field',$
  DataRoiFileName,$
  0
REFreduction_LoadDataBackFile, Event, DataRoiFileName
END

PRO UpdateDataPeakExclY, Event, Ymin, Ymax
putTextFieldValue, Event, $
  'data_d_selection_peak_ymin_cw_field',$
  Ymin,$
  0
putTextFieldValue, Event, $
  'data_d_selection_peak_ymax_cw_field',$
  Ymax,$
  0
REFreduction_DataBackgroundPeakSelection, Event, ''
END

;WORK ON NORMALIZATION FILE ====================================================

PRO UpdateMainNormRunNumber, Event, NormRunNumber
putTextFieldValue, Event, $
  'load_normalization_run_number_text_field', $
  LONG(NormRunNumber),$
  0
END

PRO UpdateAllNormNexusFileName, Event, AllNormNexusFileName
putTextFieldValue, Event, $
  'reduce_normalization_runs_text_field',$
  AllNormNexusFileName,$
  0
END

PRO UpdateMainNormNexusFileName, Event, MainNormNexusFileName, NormRunNumber
REFreduction_OpenPlotNormNexus, Event, NormRunNumber, MainNormNexusFileName
END

PRO UpdateNormRoiFileName, Event, NormRoiFileName
putTextFieldValue, Event, $
  'normalization_background_selection_file_text_field',$
  NormRoiFileName,$
  0
REFreduction_LoadNormBackgroundFile, Event, NormRoiFileName
END

PRO UpdateNormPeakExclY, Event, Ymin, Ymax
putTextFieldValue, Event, $
  'normalization_d_selection_peak_ymin_cw_field',$
  Ymin,$
  0
putTextFieldValue, Event, $
  'normalization_d_selection_peak_ymax_cw_field',$
  Ymax,$
  0
REFreduction_NormBackgroundPeakSelection, Event, ''
END

;WORK ON Qmin, Qmax, Qwidth and Qtype ;=========================================
PRO UpdateQ, Event, Qmin, Qmax, Qwidth, Qtype
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

;WORK ON AngleValue and AngleError =============================================
PRO UpdateAngle, Event, Value, Error, units
putTextFieldValue, Event, 'detector_value_text_field', Value, 0
putTextFieldValue, Event, 'detector_error_text_field', Error, 0
IF (units EQ 'degrees') THEN BEGIN
    group_value = 0
ENDIF ELSE BEGIN
    group_value = 1
ENDELSE
SetCWBgroup, Event, 'detector_units_b_group', group_value
END

;WORK on Filtering Data Flag ===================================================
PRO UpdateFilteringDataFlag, Event, FlagStatus
IF (FlagStatus EQ 'yes') THEN BEGIN
    buttonValue = 0
ENDIF ELSE BEGIN
    buttonValue = 1
ENDELSE
SetCWBgroup, Event, 'filtering_data_cwbgroup', buttonValue
END

;WORK on dt/t Flag =============================================================
PRO UpdateDeltaToverTFlag, Event, DeltaToverTFlag
IF (DeltaToverTFlag EQ 'yes') THEN BEGIN
    buttonValue = 0
ENDIF ELSE BEGIN
    buttonValue = 1
ENDELSE
SetCWBgroup, Event, 'delta_t_over_t_cwbgroup', buttonValue
END

;Work on OverwriteDataInstrumentGeometry =======================================
PRO UpdateOverwriteDataInstrGeoFlag, $
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

;Work on OverwriteNormInstrumentGeometry =======================================
PRO UpdateOverwriteNormInstrGeoFlag, $
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

;###############################################################################
;******  Class constructor *****************************************************
FUNCTION IDLupdateGui::init, structure

event = structure.Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;Activate Data Widgets
updateDataWidget, Event, 1
;work on MainDataRunNumber
UpdateMainDataRunNumber, Event, structure.MainDataRunNumber
;work on AllDataNexusFileName
UpdateAllDataNexusFileName, Event, structure.AllDataNexusFileName
;work on MainDataNexusFileName (Load This Run)
UpdateMainDataNexusFileName, Event, $
  structure.MainDataNexusFileName, $
  structure.MainDataRunNumber
;work on DataRoiFileName
UpdateDataRoiFileName, Event, structure.DataRoiFileName
;work on DataPeakExclYmin and DataPeakExclYmax
UpdateDataPeakExclY, Event, $
  structure.DataPeakExclYmin, $
  structure.DataPeakExclYmax

;Work on Normalization data files
IF (structure.MainNormRunNumber NE '') THEN BEGIN
;work on MainNormRunNumber
    UpdateMainNormRunNumber, Event, structure.MainNormRunNumber
;work on AllNormNexusFileName
    UpdateAllNormNexusFileName, Event, AllNormNexusFileName
;work on MainNormNexusFileName
    UpdateMainNormNexusFileName, Event, $
      structure.MainNormNexusFileName, $
      structure.MainNormRunNumber
;work on NormRoiFileName
    UpdateNormRoiFileName, Event, structure.NormRoiFileName
;work on NormPeakExclYmin and NormPeakExclYmax
    UpdateNormPeakExclY, Event, $
      structure.NormPeakExclYmin, $
      structure.NormPeakExclYmax
ENDIF ELSE BEGIN
    (*global).NormNexusFound = 0
ENDELSE

;Work on Qmin, Qmax, Qwidth and Qtype
UpdateQ, Event, $
  structure.Qmin, $
  structure.Qmax, $
  structure.Qwidth, $
  structure.Qtype

;Work on AngleValue and AngleError
UpdateAngle, Event, $
  structure.AngleValue, $
  structure.AngleError, $
  structure.AngleUnits

;Work on Flags
UpdateFilteringDataFlag, Event, structure.FilteringDataFlag

;Work on dt/t
UpdateDeltaToverTFlag, Event, structure.DeltaToverTFlag

;Work on OverwriteDataInstrGeoFlag and DataInstrGeoFilename
UpdateOverwriteDataInstrGeoFlag, Event, $
  structure.OverwriteDataInstrGeoFlag, $
  structure.DataInstrGeoFileName

;Work on OverwriteNormInstrGeoFlag and NormInstrGeoFileName
UpdateOverwriteNormInstrGeoFlag, Event, $
  structure.OverwriteNormInstrGeoFlag, $
  structure.NormInstrGeoFileName

;Work on Output Path and FileName

RETURN, 1
END

;******  Class Define **** *****************************************************

PRO IDLupdateGui__define
STRUCT = {IDLupdateGui,$
          var : ''}

END

;*******************************************************************************
;*******************************************************************************
