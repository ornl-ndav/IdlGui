PRO RepopulateGui, Event
;get cmd of current selected row
cmd = getTextFieldValue(Event,'cmd_status_preview')

;Create instance of the class
ClassInstance = obj_new('IDLparseCommandLine',cmd)

;Add message in log book
text = '> Repopulating GUI (via Batch Tab) with information of following ' + $
  'command line:'
putLogBookMessage, Event, text, APPEND=1
print, 'cmd : ' + cmd ;REMOVE_ME
text = '-> cmd : ' + cmd
putLogBookMessage, Event, text, APPEND=1

;Start retrieving information
text = '-> Informations retrieved from cmd:'
putLogBookMessage, Event, text, APPEND=1

MainDataNexusFileName = ClassInstance->getMainDataNexusFileName()
text = '--> Main Data Nexus File Name (MainDataNexusFileName) ................. ' + $
  MainDataNexusFileName

MainDataRunNumber = ClassInstance->getMainDataRunNumber()
text = '--> Main Data Run Number (MainDataRunNumber) .......................... ' + $
  MainDataRunNumber

DataRoiFileName = ClassInstance->getDataRoiFileName()
text = '--> Data ROI Full File Name (DataRoiFileName) ......................... ' + $
  DataRoiFileName

DataPeakExclYArray = ClassInstance->getDataPeakExclYArray()
text = '--> Data Peak Exclusion Ymin (DataPeakExclYArray[0]) .................. ' + $
  DataPeakExclYArray[0]
text = '--> Data Peak Exclusion Ymax (DataPeakExclYArray[1]) .................. ' + $
  DataPeakExclYArray[1]

MainNormNexusFileName = ClassInstance->getMainNormNexusFileName()
text = '--> Main Normalization File Name (MainNormNexusFileName) .............. ' + $
  MainNormNexusFileName

MainNormRunNumber = ClassInstance->getMainNormRunNumber()
text = '--> Main Normalization Run Number (MainNormRunNumber) ................. ' + $
MainNormRunNumber

NormRoiFileName = ClassInstance->getNormRoiFileName()
text = '--> Normalization ROI Full File Name (NormRoiFileName) ................ ' + $
  NormRoiFileName

DataBackgroundFlag = ClassInstance->getDataBackgroundFlag()
text = '--> With Data Background (DataBackgroundFlag) ? ....................... ' + $
  DataBackgroundFlag

NormBackgroundFlag = ClassInstance->getNormBackgroundFlag() 
text = '--> With Normalization Background (NormBackgroundFlag) ? .............. ' + $
  NormBackgroundFlag

Qmin = ClassInstance->getQmin()
text = '--> Qmin (Qmin) ....................................................... ' + $
  Qmin

Qmax = ClassInstance->getQmax()
text = '--> Qmax (Qmax) ....................................................... ' + $
  Qmax

Qwidth = ClassInstance->getQwidth()
text = '--> Qwidth (Qwidth) ....................................................' + $
  Qwidth

Qtype = ClassInstance->getQtype()
text = '--> Qtype (Qtype) ..................................................... ' + $
  Qtype

AngleValue = ClassInstance->getAngleValue()                        
text = '--> Angle Value (AngleValue) .......................................... ' + $
  AngleValue

AngleError = ClassInstance->getAngleError()
text = '--> Angle Error (AngleError) .......................................... ' + $
  AngleError

AngleUnits = ClassInstance->getAngleUnits()
text = '--> Angle Units (AngleUnits) .......................................... ' + $
  AngleUnits

FilteringDataFlag = ClassInstance->getFilteringDataFlag()
text = '--> With Filtering Data (FilteringDataFlag) ? ......................... ' + $
  FilteringDataFlag

OverwriteDataInstrGeoFlag = ClassInstance->getOverwriteDataInstrGeoFlag()
text = '--> With Overwrite Data Instr. Geo. (OverwriteDataInstrGeoFlag) ....... ' + $
  OverwriteDataInstrGeoFlag

DataInstrGeoFileName = ClassInstance->getDataInstrGeoFileName()
text = '--> Data Instrument Geometry File Name (DataInstrGeoFileName) ......... ' + $
  DataInstrGeoFileName

OverwriteNormInstrGeoFlag = ClassInstance->getOverwriteNormInstrGeoFlag()
text = '--> With Overwrite Norm Instr. Geo. (OverwriteNormInstrGeoFlag) ....... ' + $
  OverwriteNormInstrGeoFlag

NormInstrGeoFileName = ClassInstance->getNormInstrGeoFileName()
text = '--> Norm Instrument Geometry File Name (NormInstrGeoFileName) ......... ' + $
  NormInstrGeoFileName

OutputPath = ClassInstance->getOutputPath()
text = '--> Output Path (OutputPath) .......................................... ' + $
  OutputPath

OutputFileName = ClassInstance->GetOutputFileName()
text = '--> Output File Name (OutputFileName) ................................. ' + $
  OutputFileName

END


