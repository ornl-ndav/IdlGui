PRO RepopulateGui, Event
;get cmd of current selected row
cmd = getTextFieldValue(Event,'cmd_status_preview')

;Create instance of the class
ClassInstance = obj_new('IDLparseCommandLine',cmd)

;Add message in log book
text = '> Repopulating GUI (via Batch Tab) with information of following ' + $
  'command line:'
putLogBookMessage, Event, text, APPEND=1
text = '-> cmd : ' + cmd
putLogBookMessage, Event, text, APPEND=1

;Start retrieving information
text = '------------------------------------------------------------------------' + $
  '---------------------------------------------------------'
putLogBookMessage, Event, text, APPEND=1
text = '-------------------------------------------- Informations retrieved from' + $
  ' cmd ----------------------------------------------------'
putLogBookMessage, Event, text, APPEND=1
text = '------------------------------------------------------------------------' + $
  '---------------------------------------------------------'
putLogBookMessage, Event, text, APPEND=1

MainDataNexusFileName = ClassInstance->getMainDataNexusFileName()
text = '--> Main Data Nexus File Name (MainDataNexusFileName) ................. ' + $
  MainDataNexusFileName
putLogBookMessage, Event, text, APPEND=1

MainDataRunNumber = ClassInstance->getMainDataRunNumber()
text = '--> Main Data Run Number (MainDataRunNumber) .......................... ' + $
  MainDataRunNumber
putLogBookMessage, Event, text, APPEND=1

AllDataNexusFileName = ClassInstance->getAllDataNexusFileName()
text = '--> List of All Data Nexus File Names (AllDataNexusFileName) .......... ' + $
  AllDataNexusFileName
putLogBookMessage, Event, text, APPEND=1

DataRoiFileName = ClassInstance->getDataRoiFileName()
text = '--> Data ROI Full File Name (DataRoiFileName) ......................... ' + $
  DataRoiFileName
putLogBookMessage, Event, text, APPEND=1

DataPeakExclYArray = ClassInstance->getDataPeakExclYArray()
text = '--> Data Peak Exclusion Ymin (DataPeakExclYArray[0]) .................. ' + $
  DataPeakExclYArray[0]
putLogBookMessage, Event, text, APPEND=1
text = '--> Data Peak Exclusion Ymax (DataPeakExclYArray[1]) .................. ' + $
  DataPeakExclYArray[1]
putLogBookMessage, Event, text, APPEND=1

MainNormNexusFileName = ClassInstance->getMainNormNexusFileName()
text = '--> Main Normalization File Name (MainNormNexusFileName) .............. ' + $
  MainNormNexusFileName
putLogBookMessage, Event, text, APPEND=1

MainNormRunNumber = ClassInstance->getMainNormRunNumber()
text = '--> Main Normalization Run Number (MainNormRunNumber) ................. ' + $
MainNormRunNumber
putLogBookMessage, Event, text, APPEND=1

AllNormNexusFileName = ClassInstance->getAllNormNexusFileName()
text = '--> List of All Norm Nexus File Names (AllNormNexusFileName) .......... ' + $
  AllNormNexusFileName
putLogBookMessage, Event, text, APPEND=1

NormRoiFileName = ClassInstance->getNormRoiFileName()
text = '--> Normalization ROI Full File Name (NormRoiFileName) ................ ' + $
  NormRoiFileName
putLogBookMessage, Event, text, APPEND=1

DataBackgroundFlag = ClassInstance->getDataBackgroundFlag()
text = '--> With Data Background (DataBackgroundFlag) ? ....................... ' + $
  DataBackgroundFlag
putLogBookMessage, Event, text, APPEND=1

NormBackgroundFlag = ClassInstance->getNormBackgroundFlag() 
text = '--> With Normalization Background (NormBackgroundFlag) ? .............. ' + $
  NormBackgroundFlag
putLogBookMessage, Event, text, APPEND=1

Qmin = ClassInstance->getQmin()
text = '--> Qmin (Qmin) ....................................................... ' + $
  Qmin
putLogBookMessage, Event, text, APPEND=1

Qmax = ClassInstance->getQmax()
text = '--> Qmax (Qmax) ....................................................... ' + $
  Qmax
putLogBookMessage, Event, text, APPEND=1

Qwidth = ClassInstance->getQwidth()
text = '--> Qwidth (Qwidth) ....................................................' + $
  Qwidth
putLogBookMessage, Event, text, APPEND=1

Qtype = ClassInstance->getQtype()
text = '--> Qtype (Qtype) ..................................................... ' + $
  Qtype
putLogBookMessage, Event, text, APPEND=1

AngleValue = ClassInstance->getAngleValue()                        
text = '--> Angle Value (AngleValue) .......................................... ' + $
  AngleValue
putLogBookMessage, Event, text, APPEND=1

AngleError = ClassInstance->getAngleError()
text = '--> Angle Error (AngleError) .......................................... ' + $
  AngleError
putLogBookMessage, Event, text, APPEND=1

AngleUnits = ClassInstance->getAngleUnits()
text = '--> Angle Units (AngleUnits) .......................................... ' + $
  AngleUnits
putLogBookMessage, Event, text, APPEND=1

FilteringDataFlag = ClassInstance->getFilteringDataFlag()
text = '--> With Filtering Data (FilteringDataFlag) ? ......................... ' + $
  FilteringDataFlag
putLogBookMessage, Event, text, APPEND=1

OverwriteDataInstrGeoFlag = ClassInstance->getOverwriteDataInstrGeoFlag()
text = '--> With Overwrite Data Instr. Geo. (OverwriteDataInstrGeoFlag) ....... ' + $
  OverwriteDataInstrGeoFlag
putLogBookMessage, Event, text, APPEND=1

DataInstrGeoFileName = ClassInstance->getDataInstrGeoFileName()
text = '--> Data Instrument Geometry File Name (DataInstrGeoFileName) ......... ' + $
  DataInstrGeoFileName
putLogBookMessage, Event, text, APPEND=1

OverwriteNormInstrGeoFlag = ClassInstance->getOverwriteNormInstrGeoFlag()
text = '--> With Overwrite Norm Instr. Geo. (OverwriteNormInstrGeoFlag) ....... ' + $
  OverwriteNormInstrGeoFlag
putLogBookMessage, Event, text, APPEND=1

NormInstrGeoFileName = ClassInstance->getNormInstrGeoFileName()
text = '--> Norm Instrument Geometry File Name (NormInstrGeoFileName) ......... ' + $
  NormInstrGeoFileName
putLogBookMessage, Event, text, APPEND=1

OutputPath = ClassInstance->getOutputPath()
text = '--> Output Path (OutputPath) .......................................... ' + $
  OutputPath
putLogBookMessage, Event, text, APPEND=1

OutputFileName = ClassInstance->getOutputFileName()
text = '--> Output File Name (OutputFileName) ................................. ' + $
  OutputFileName
putLogBookMessage, Event, text, APPEND=1

DataNormCombinedSpecFlag = ClassInstance->getDataNormCombinedSpecFlag()
text = '--> With Data/Norm. Comb. Spec. TOF plot (DataNormCombinedSpecFlag) ... ' + $
  DataNormCombinedSpecFlag

putLogBookMessage, Event, text, APPEND=1
DataNormCombinedBackFlag = ClassInstance->getDataNormCombinedBackFlag()
text = '--> With Data/Norm. Comb. Back. TOF plot (DataNormCombinedBackFlag) ... ' + $
  DataNormCombinedBackFlag
putLogBookMessage, Event, text, APPEND=1

DataNormCombinedSubFlag = ClassInstance->getDataNormCombinedSubFlag()
text = '--> With Data/Norm. Comb. Sub. TOF plot (DataNormCombinedSubFlag) ..... ' + $
  DataNormCombinedSubFlag
putLogBookMessage, Event, text, APPEND=1

text = '------------------------------------------------------------------------' + $
  '--------------------------------------------------------'
putLogBookMessage, Event, text, APPEND=1

;Create a structure that will contain all the information
sRepopulateGui = {Event                     : Event,$
                  MainDataNexusFileName     : MainDataNexusFileName,$
                  MainDataRunNumber         : MainDataRunNumber,$
                  AllDataNexusFileName      : AllDataNexusFileName,$
                  DataRoiFileName           : DataRoiFileName,$
                  DataPeakExclYmin          : DataPeakExclYArray[0],$
                  DataPeakExclYmax          : DataPeakExclYArray[1],$
                  MainNormNexusFileName     : MainNormNexusFileName,$
                  MainNormRunNumber         : MainNormRunNumber,$
                  AllNormNexusFileName      : AllNormNexusFileName,$
                  NormRoiFileName           : NormRoiFileName,$
                  DataBackgroundFlag        : DataBackgroundFlag,$
                  NormBackgroundFlag        : NormBackgroundFlag,$
                  Qmin                      : Qmin,$
                  Qmax                      : Qmax,$
                  Qwidth                    : Qwidth,$
                  Qtype                     : Qtype,$
                  AngleValue                : AngleValue,$
                  AngleError                : AngleError,$
                  AngleUnits                : AngleUnits,$
                  FilteringDataFlag         : FilteringDataFlag,$
                  OverwriteDataInstrGeoFlag : OverwriteDataInstrGeoFlag,$
                  DataInstrGeoFileName      : DataInstrGeoFileName,$
                  OverwriteNormInstrGeoFlag : OverwriteNormInstrGeoFlag,$
                  NormInstrGeoFileName      : NormInstrGeoFileName,$
                  OutputPath                : OutputPath,$
                  OutputFileName            : OutputFileName,$
                  DataNormCombinedSpecFlag  : DataNormCombinedSpecFlag,$
                  DataNormCombinedBackFlag  : DataNormCombinedBackFlag,$
                  DataNormCombinedSubFlag   : DataNormCombinedSubFlag}
                  
;guiClassInstance = obj_new('IDLupdateGui',sRepopulateGui)

END


