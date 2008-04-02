;*******************************************************************************
;WORK ON DATA FILE =============================================================
FUNCTION UpdateMainDataRunNumber, Event, DataRunNumber
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
      lDataRunNumber,$
      0
ENDELSE
RETURN,1
END


;-------------------------------------------------------------------------------
PRO UpdateAllDataNexusFileName, Event, AllDataNexusFileName
putTextFieldValue, Event, $
  'reduce_data_runs_text_field',$
  AllDataNexusFileName,$
  0
END

;-------------------------------------------------------------------------------
PRO UpdateMainDataNexusFileName, Event, MainDataNexusFileName, DataRunNumber
REFreduction_OpenPlotDataNexus, Event, DataRunNumber, MainDataNexusFileName
END

;-------------------------------------------------------------------------------
PRO UpdateDataRoiFileName, Event, DataRoiFileName
putTextFieldValue, Event, $
  'data_background_selection_file_text_field',$
  DataRoiFileName,$
  0
REFreduction_LoadDataBackFile, Event, DataRoiFileName
END

;-------------------------------------------------------------------------------
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
FUNCTION UpdateMainNormRunNumber, Event, NormRunNumber
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
      lNormRunNumber,$
      0
ENDELSE
RETURN,1
END

;-------------------------------------------------------------------------------
PRO UpdateAllNormNexusFileName, Event, AllNormNexusFileName
putTextFieldValue, Event, $
  'reduce_normalization_runs_text_field',$
  AllNormNexusFileName,$
  0
END

;-------------------------------------------------------------------------------
PRO UpdateMainNormNexusFileName, Event, MainNormNexusFileName, NormRunNumber
REFreduction_OpenPlotNormNexus, Event, NormRunNumber, MainNormNexusFileName
END

;-------------------------------------------------------------------------------
PRO UpdateNormRoiFileName, Event, NormRoiFileName
putTextFieldValue, Event, $
  'normalization_background_selection_file_text_field',$
  NormRoiFileName,$
  0
REFreduction_LoadNormBackgroundFile, Event, NormRoiFileName
END

;-------------------------------------------------------------------------------
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

;Work on Output Path and output FileName =======================================
PRO UpdateOutputPath, Event, OutputPath
setButtonValue, Event, 'of_button', OutputPath
END

;-------------------------------------------------------------------------------
PRO UpdateOutputFileName, Event, OutputFileName
putTextFieldValue, Event, 'of_text', OutputFileName, 0
END

;Work on Intermediate files ====================================================
;DataNormCombinedSpecFlag
PRO UpdateIntermediateFiles, Event, $
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

;###############################################################################
;******  Class constructor *****************************************************
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
    status = UpdateMainDataRunNumber(Event, structure.MainDataRunNumber)
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
    UpdateAllDataNexusFileName, Event, structure.AllDataNexusFileName
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
    UpdateMainDataNexusFileName, Event, $
      structure.MainDataNexusFileName, $
      structure.MainDataRunNumber
    AppendReplaceLogBookMessage, Event, OK, PROCESSING
ENDELSE

;work on DataRoiFileName
text = '--> Load Data ROI File ....................................... ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
IF (structure.DataRoiFilename EQ '') THEN BEGIN
    AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ++NbrError
    ++DataError
ENDIF ELSE BEGIN
    UpdateDataRoiFileName, Event, structure.DataRoiFileName
    AppendReplaceLogBookMessage, Event, OK, PROCESSING
ENDELSE

;work on DataPeakExclYmin and DataPeakExclYmax
text = '--> Load Data Peak Exclusion Ymin and Ymax ................... ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateDataPeakExclY, Event, $
  structure.DataPeakExclYmin, $
  structure.DataPeakExclYmax
AppendReplaceLogBookMessage, Event, OK, PROCESSING

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

;Work on Normalization data files
IF (structure.MainNormRunNumber NE '') THEN BEGIN

    NormError  = 0
;work on MainNormRunNumber
    text = '--> Display Main Normalization Run Number .................... ' + $
      PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.MainNormRunNumber EQ '') THEN BEGIN
        AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ENDIF ELSE BEGIN
        status = UpdateMainNormRunNumber(Event, structure.MainNormRunNumber)
        IF (status EQ 0) THEN BEGIN
            AppendReplaceLogBookMessage, Event, FAILED, PROCESSING
            ++NbrError
            ++NormError
        ENDIF ELSE BEGIN
            AppendReplaceLogBookMessage, Event, OK, PROCESSING
        ENDELSE
    ENDELSE

;work on AllNormNexusFileName
    text = '--> Display List of All Normalization Run .................... ' + $
      PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.AllNormNexusFileName EQ '') THEN BEGIN
        AppendReplaceLogBookMessage, Event, NO, PROCESSING
    ENDIF ELSE BEGIN
        UpdateAllNormNexusFileName, Event, structure.AllNormNexusFileName
        AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE

;work on MainNormNexusFileName
    text = '--> Load and Plot Main Normalization Run Number .............. ' + $
      PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.MainNormNexusFileName EQ '' OR $
        structure.MainNormRunNumber EQ '') THEN BEGIN
        AppendReplaceLogBookMessage, Event, NO, PROCESSING
        ++NbrError
        ++NormError
    ENDIF ELSE BEGIN        
        UpdateMainNormNexusFileName, Event, $
          structure.MainNormNexusFileName, $
          structure.MainNormRunNumber
        AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE
    
;work on NormRoiFileName
    text = '--> Load Normalization ROI File .............................. ' + $
      PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    IF (structure.NormRoiFileName EQ '') THEN BEGIN
        AppendReplaceLogBookMessage, Event, NO, PROCESSING
        ++NbrError
        ++NormError
    ENDIF ELSE BEGIN
        UpdateNormRoiFileName, Event, structure.NormRoiFileName
        AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDELSE
    
;work on NormPeakExclYmin and NormPeakExclYmax
    text = '--> Load Normalizaion Peak Exclusion Ymin and Ymax ........... ' + $
      PROCESSING
    putLogBookMessage, Event, text, APPEND=1
    UpdateNormPeakExclY, Event, $
      structure.NormPeakExclYmin, $
      structure.NormPeakExclYmax
    AppendReplaceLogBookMessage, Event, OK, PROCESSING

ENDIF ELSE BEGIN
    (*global).NormNexusFound = 0
ENDELSE

;Work on Qmin, Qmax, Qwidth and Qtype
text = '--> Load Qmin, Qmax, Qwidth and Qtype ........................ ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateQ, Event, $
  structure.Qmin, $
  structure.Qmax, $
  structure.Qwidth, $
  structure.Qtype
AppendReplaceLogBookMessage, Event, OK, PROCESSING

;Work on AngleValue and AngleError
text = '--> Load Angle Value and Error ............................... ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateAngle, Event, $
  structure.AngleValue, $
  structure.AngleError, $
  structure.AngleUnits
AppendReplaceLogBookMessage, Event, OK, PROCESSING

;Work on filtering flag
text = '--> Load on Filtering Data Flag .............................. ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateFilteringDataFlag, Event, structure.FilteringDataFlag
AppendReplaceLogBookMessage, Event, OK, PROCESSING

;Work on dt/t flag
text = '--> Load on dt/t Flag ........................................ ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateDeltaToverTFlag, Event, structure.DeltaToverTFlag
AppendReplaceLogBookMessage, Event, OK, PROCESSING

;Work on OverwriteDataInstrGeoFlag and DataInstrGeoFilename 
text = '--> Load Overwrite Data Instrument Geometry Flag ............. ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateOverwriteDataInstrGeoFlag, Event, $
  structure.OverwriteDataInstrGeoFlag, $
  structure.DataInstrGeoFileName
AppendReplaceLogBookMessage, Event, OK, PROCESSING

;Work on OverwriteNormInstrGeoFlag and NormInstrGeoFileName
text = '--> Load Overwrite Normalization Instrument Geometry Flag .... ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateOverwriteNormInstrGeoFlag, Event, $
  structure.OverwriteNormInstrGeoFlag, $
  structure.NormInstrGeoFileName
AppendReplaceLogBookMessage, Event, OK, PROCESSING

;Work on Output Path and Output File Name
text = '--> Load Output Path ......................................... ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateOutputPath, Event, structure.OutputPath
AppendReplaceLogBookMessage, Event, OK, PROCESSING

text = '--> Load Output File Name .................................... ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateOutputFileName, Event, structure.OutputFileName
AppendReplaceLogBookMessage, Event, OK, PROCESSING

;Work Intermediate Files
;Data/Norm Combined Spec Flag
text = '--> Load Intermediate Files .................................. ' $
  + PROCESSING
putLogBookMessage, Event, text, APPEND=1
UpdateIntermediateFiles, Event, $
  structure.DataNormCombinedSpecFlag,$
  structure.DataNormCombinedBackFlag,$
  structure.DataNormCombinedSubFlag,$
  structure.RvsTOFFlag,$
  structure.RvsTOFcombinedFlag
AppendReplaceLogBookMessage, Event, OK, PROCESSING

IF (NbrError GT 0) THEN RETURN, 0
RETURN, 1

END

;*******************************************************************************
;******  Class Define **** *****************************************************
PRO IDLupdateGui__define
STRUCT = {IDLupdateGui,$
          var : ''}
END
;*******************************************************************************
;*******************************************************************************
