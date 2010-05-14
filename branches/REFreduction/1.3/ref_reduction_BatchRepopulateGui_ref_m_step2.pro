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

pro RepopulateGui_ref_m_with_spin_states, event, spin_state_index=spin_state_index

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;indicate initialization with hourglass icon
  widget_control,/HOURGLASS
  
  ;get cmd of current selected row
  cmd = getTextFieldValue(Event,'cmd_status_preview')
  
  ;create array of command lines
  cmd_array = strsplit(cmd,';',/extract)
  
  if (n_elements(spin_state_index) eq 0) then begin
    spin_state_index = 0
  endif
  
  ;command line to parse
  cmd = cmd_array[spin_state_index]
  
  ClassInstance = obj_new('IDLparseCommandLine_ref_m',cmd)
  
  ;Add message in log book
  text = '> Repopulating GUI (via Batch Tab) with information of following ' + $
    'command line:'
  putLogBookMessage, Event, text, APPEND=1
  text = '-> cmd : ' + cmd
  putLogBookMessage, Event, text, APPEND=1
  
  ;Start retrieving information
  text = '------------------------------------------------------------------' + $
    '---------------------------------------------------------------'
  putLogBookMessage, Event, text, APPEND=1
  text = '-------------------------------------------- Informations ' + $
    'retrieved from cmd ----------------------------------------------------'
  putLogBookMessage, Event, text, APPEND=1
  text = '------------------------------------------------------------------' + $
    '---------------------------------------------------------------'
  putLogBookMessage, Event, text, APPEND=1
  
  MainDataNexusFileName = ClassInstance->getMainDataNexusFileName()
  text = '--> Main Data Nexus File Name (MainDataNexusFileName) ............' + $
    '..... ' + MainDataNexusFileName
  putLogBookMessage, Event, text, APPEND=1
  
  MainDataRunNumber = ClassInstance->getMainDataRunNumber()
  text = '--> Main Data Run Number (MainDataRunNumber) .....................' + $
    '..... ' + MainDataRunNumber
  putLogBookMessage, Event, text, APPEND=1
  
  text = '--> Data Spin State to plot ......................................' + $
  '..... ' +     (*global).data_spin_state_to_replot
  putLogBookMessage, Event, text, APPEND=1
  
  AllDataNexusFileName = ClassInstance->getAllDataNexusFileName()
  text = '--> List of All Data Nexus File Names (AllDataNexusFileName) .....' + $
    '..... ' + AllDataNexusFileName
  putLogBookMessage, Event, text, APPEND=1
  
  DataRoiFileName = ClassInstance->getDataRoiFileName()
  text = '--> Data ROI Full File Name (DataRoiFileName) ....................' + $
    '..... ' + DataRoiFileName
  putLogBookMessage, Event, text, APPEND=1
  
  DataPeakExclYArray = ClassInstance->getDataPeakExclYArray()
  text = '--> Data Peak Exclusion Ymin (DataPeakExclYArray[0]) .............' + $
    '..... ' + DataPeakExclYArray[0]
  putLogBookMessage, Event, text, APPEND=1
  text = '--> Data Peak Exclusion Ymax (DataPeakExclYArray[1]) .............' + $
    '..... ' + DataPeakExclYArray[1]
  putLogBookMessage, Event, text, APPEND=1
  
  DataBackFileName = ClassInstance->getDatabackFileName()
  text = '--> Data Back Full File Name (DataBackFileName) ..................' + $
    '..... ' + DataBackFileName
  putLogBookMessage, Event, text, APPEND=1
  
  MainNormNexusFileName = ClassInstance->getMainNormNexusFileName()
  text = '--> Main Normalization File Name (MainNormNexusFileName) .........' + $
    '..... ' + MainNormNexusFileName
  putLogBookMessage, Event, text, APPEND=1
  
  MainNormRunNumber = ClassInstance->getMainNormRunNumber()
  text = '--> Main Normalization Run Number (MainNormRunNumber) ............' + $
    '..... ' + MainNormRunNumber
  putLogBookMessage, Event, text, APPEND=1
  
  text = '--> Norm Spin State to plot ......................................' + $
  '..... ' +     (*global).norm_spin_state_to_replot
  putLogBookMessage, Event, text, APPEND=1
  
  AllNormNexusFileName = ClassInstance->getAllNormNexusFileName()
  text = '--> List of All Norm Nexus File Names (AllNormNexusFileName) .....' + $
    '..... ' + AllNormNexusFileName
  putLogBookMessage, Event, text, APPEND=1
  
  NormRoiFileName = ClassInstance->getNormRoiFileName()
  text = '--> Normalization ROI Full File Name (NormRoiFileName) ...........' + $
    '..... ' + NormRoiFileName
  putLogBookMessage, Event, text, APPEND=1
  
  NormPeakExclYArray = ClassInstance->getNormPeakExclYArray()
  text = '--> Norm Peak Exclusion Ymin (NormPeakExclYArray[0]) .............' + $
    '..... ' + NormPeakExclYArray[0]
  putLogBookMessage, Event, text, APPEND=1
  text = '--> Norm Peak Exclusion Ymax (NormPeakExclYArray[1]) .............' + $
    '..... ' + NormPeakExclYArray[1]
  putLogBookMessage, Event, text, APPEND=1
  
  NormBackFileName = ClassInstance->getNormBackFileName()
  text = '--> Normalization Back Full File Name (NormBackFileName) .........' + $
    '..... ' + NormBackFileName
  putLogBookMessage, Event, text, APPEND=1
  
  DataBackgroundFlag = ClassInstance->getDataBackgroundFlag()
  text = '--> With Data Background (DataBackgroundFlag) ? ..................' + $
    '..... ' + DataBackgroundFlag
  putLogBookMessage, Event, text, APPEND=1
  
  TOFcuttingMin = ClassInstance->getTofCuttingMin()
  text = '--> TOF cutting min ..............................................' + $
    '..... ' + TOFcuttingMin
  putLogBookMessage, Event, text, APPEND=1
  
  TOFcuttingMax = ClassInstance->getTofCuttingMax()
  text = '--> TOF cutting max ..............................................' + $
    '..... ' + TOFcuttingMax
  putLogBookMessage, Event, text, APPEND=1
  
  NormBackgroundFlag = ClassInstance->getNormBackgroundFlag()
  text = '--> With Normalization Background (NormBackgroundFlag) ? .........' + $
    '..... ' + NormBackgroundFlag
  putLogBookMessage, Event, text, APPEND=1
  
;  Qmin = ClassInstance->getQmin()
;  text = '--> Qmin (Qmin) ..................................................' + $
;    '..... ' + Qmin
;  putLogBookMessage, Event, text, APPEND=1
;  
;  Qmax = ClassInstance->getQmax()
;  text = '--> Qmax (Qmax) ..................................................' + $
;    '..... ' + Qmax
;  putLogBookMessage, Event, text, APPEND=1
;  
;  Qwidth = ClassInstance->getQwidth()
;  text = '--> Qwidth (Qwidth) ..............................................' + $
;    '..... ' + Qwidth
;  putLogBookMessage, Event, text, APPEND=1
;  
;  Qtype = ClassInstance->getQtype()
;  text = '--> Qtype (Qtype) ................................................' + $
;    '..... ' + Qtype
;  putLogBookMessage, Event, text, APPEND=1
  
  FilteringDataFlag = ClassInstance->getFilteringDataFlag()
  text = '--> With Filtering Data (FilteringDataFlag) ? ....................' + $
    '..... ' + FilteringDataFlag
  putLogBookMessage, Event, text, APPEND=1
  
  DeltaToverTFlag = ClassInstance->getDeltaTOverTFlag()
  text = '--> With dt/t (DeltaToverTFlag) ? ................................' + $
    '..... ' + DeltaToverTFlag
    
  OverwriteDataInstrGeoFlag = ClassInstance->getOverwriteDataInstrGeoFlag()
  text = '--> With Overwrite Data Instr. Geo. (OverwriteDataInstrGeoFlag) ..' + $
    '..... ' + OverwriteDataInstrGeoFlag
  putLogBookMessage, Event, text, APPEND=1
  
  DataInstrGeoFileName = ClassInstance->getDataInstrGeoFileName()
  text = '--> Data Instrument Geometry File Name (DataInstrGeoFileName) ....' + $
    '..... ' + DataInstrGeoFileName
  putLogBookMessage, Event, text, APPEND=1
  
  OverwriteNormInstrGeoFlag = ClassInstance->getOverwriteNormInstrGeoFlag()
  text = '--> With Overwrite Norm Instr. Geo. (OverwriteNormInstrGeoFlag) ..' + $
    '..... ' + OverwriteNormInstrGeoFlag
  putLogBookMessage, Event, text, APPEND=1
  
  NormInstrGeoFileName = ClassInstance->getNormInstrGeoFileName()
  text = '--> Norm Instrument Geometry File Name (NormInstrGeoFileName) ....' + $
    '..... ' + NormInstrGeoFileName
  putLogBookMessage, Event, text, APPEND=1
  
  OutputPath = ClassInstance->getOutputPath()
  text = '--> Output Path (OutputPath) .....................................' + $
    '..... ' + OutputPath
  putLogBookMessage, Event, text, APPEND=1
  
  OutputFileName = ClassInstance->getOutputFileName()
  text = '--> Output File Name (OutputFileName) ............................' + $
    '..... ' + OutputFileName
  putLogBookMessage, Event, text, APPEND=1
  
  DataNormCombinedSpecFlag = ClassInstance->getDataNormCombinedSpecFlag()
  text = '--> With Data/Norm. Comb. Spec. TOF plot ' + $
    '(DataNormCombinedSpecFlag) ... ' + DataNormCombinedSpecFlag
    
  putLogBookMessage, Event, text, APPEND=1
  DataNormCombinedBackFlag = ClassInstance->getDataNormCombinedBackFlag()
  text = '--> With Data/Norm. Comb. Back. TOF plot ' + $
    '(DataNormCombinedBackFlag) ... ' + DataNormCombinedBackFlag
  putLogBookMessage, Event, text, APPEND=1
  
  DataNormCombinedSubFlag = ClassInstance->getDataNormCombinedSubFlag()
  text = '--> With Data/Norm. Comb. Sub. TOF plot ' + $
    '(DataNormCombinedSubFlag) ..... ' + DataNormCombinedSubFlag
  putLogBookMessage, Event, text, APPEND=1
  
  RvsTOFFlag = ClassInstance->getRvsTOFFlag()
  text = '--> With R versus TOF plot (RvsTOFFlag) ..........................' + $
    '..... ' + RvsTOFFlag
  putLogBookMessage, Event, text, APPEND=1
  
  RvsTOFcombinedFlag = ClassInstance->getRvsTOFcombinedFlag()
  text = '--> With R versus TOF combined plot (RvsTOFcombinedFlag) .........' + $
    '..... ' + $
    RvsTOFcombinedFlag
  putLogBookMessage, Event, text, APPEND=1
  
  text = '-----------------------------------------------------------------' + $
    '---------------------------------------------------------------'
  putLogBookMessage, Event, text, APPEND=1
  
  ;Create a structure that will contain all the information
  sRepopulateGui = {Event                     : Event,$
    MainDataNexusFileName     : MainDataNexusFileName,$
    MainDataRunNumber         : MainDataRunNumber,$
    DataPath                  : (*global).data_spin_state_to_replot,$
    AllDataNexusFileName      : AllDataNexusFileName,$
    DataRoiFileName           : DataRoiFileName,$
    DataPeakExclYmin          : DataPeakExclYArray[0],$
    DataPeakExclYmax          : DataPeakExclYArray[1],$
    DataBackFileName          : DataBackFileName,$
    MainNormNexusFileName     : MainNormNexusFileName,$
    MainNormRunNumber         : MainNormRunNumber,$
    NormPath                  : (*global).norm_spin_state_to_replot,$
    AllNormNexusFileName      : AllNormNexusFileName,$
    NormRoiFileName           : NormRoiFileName,$
    NormPeakExclYmin          : NormPeakExclYArray[0],$
    NormPeakExclYmax          : NormPeakExclYArray[1],$
    NormBackFileName          : NormBackFileName,$
    TOFcuttingMin             : TOFcuttingMin,$
    TOFcuttingMax             : TOFcuttingMax,$
    DataBackgroundFlag        : DataBackgroundFlag,$
    NormBackgroundFlag        : NormBackgroundFlag,$
;    Qmin                      : Qmin,$
;    Qmax                      : Qmax,$
;    Qwidth                    : Qwidth,$
;    Qtype                     : Qtype,$
    FilteringDataFlag         : FilteringDataFlag,$
    DeltaToverTFlag           : DeltaToverTFlag,$
    OverwriteDataInstrGeoFlag : OverwriteDataInstrGeoFlag,$
    DataInstrGeoFileName      : DataInstrGeoFileName,$
    OverwriteNormInstrGeoFlag : OverwriteNormInstrGeoFlag,$
    NormInstrGeoFileName      : NormInstrGeoFileName,$
    OutputPath                : OutputPath,$
    OutputFileName            : OutputFileName,$
    DataNormCombinedSpecFlag  : DataNormCombinedSpecFlag,$
    DataNormCombinedBackFlag  : DataNormCombinedBackFlag,$
    DataNormCombinedSubFlag   : DataNormCombinedSubFlag,$
    RvsTOFFlag                : RvsTOFFlag,$
    RvsTOFcombinedFlag        : RvsTOFcombinedFlag}
    
  text = '-> Repopulating GUI ... START'
  putLogBookMessage, Event, text, APPEND=1
  
  populate_error = 0
  IF ((*global).debugging_version EQ 'no') THEN BEGIN
    CATCH, populate_error
  ENDIF
  IF (populate_error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    guiClassInstance = obj_new('IDLupdateGui_ref_m',sRepopulateGui)
    text = '-> Repopulating GUI ... END'
    putLogBookMessage, Event, text, APPEND=1
  ENDELSE
  
  MapBase, Event, 'processing_base', 0
  message = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
  putLabelValue, Event, 'pro_top_label', message
  
  ;Repopulated row becomes the active row
  RepopulatedRowBecomesWorkingRow_ref_m, Event
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
  ;Activate REPOPULATE GUI button
  RepopulateButtonStatus, Event, 1
  
end
