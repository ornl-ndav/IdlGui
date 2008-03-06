FUNCTION getMainDataNexusFileName
RETURN, ''
END

FUNCTION getMainDataRunNumber
RETURN, ''
END

FUNCTION getDataRoiFileName
RETURN, ''
END

FUNCTION getDataPeakExclYArray
RETURN, [0,0]
END

FUNCTION getMainNormNexusFileName
RETURN, ''
END

FUNCTION getMainNormRunNumber
RETURN, ''
END

FUNCTION getNormRoiFileName
RETURN, ''
END

FUNCTION getNormPeakExclYArray
RETURN, [0,0]
END

FUNCTION isWithDataBackgroundFlagOn
RETURN, 'yes'
END

FUNCTION isWithNormBackgroundFlagOn
RETURN, 'yes'
END

FUNCTION getQmin
RETURN, '0'
END

FUNCTION getQmax
RETURN, '0'
END

FUNCTION getQwidth
RETURN, '0'
END

FUNCTION getQtype
RETURN, 'linear'
END

FUNCTION getAngleValue
RETURN, '0'
END

FUNCTION getAngleError
RETURN, '0'
END

FUNCTION getAngleUnits
RETURN, 'degree'
END

FUNCTION isWithFilteringDataFlag
RETURN, 'yes'
END

FUNCTION isWithDeltaTOverT
RETURN, 'no'
END

FUNCTION isWithOverwriteDataInstrGeo
RETURN, 'no'
END

FUNCTION getDataInstrumentGeoFileName
RETURN, ''
END

FUNCTION isWithOverwriteNormInstrGeo
RETURN, 'no'
END

FUNCTION getNormInstrumentGeoFileName
RETURN, ''
END

FUNCTION getOutputPath
RETURN, ''
END

FUNCTION getOutputFileName
RETURN, ''
END

FUNCTION isWithDataCombinedSpec
RETURN, 'no'
END

FUNCTION isWithDataCombinedBack
RETURN, 'no'
END

FUNCTION isWithDataCombinedSub
RETURN, 'no'
END

FUNCTION isWithNormCombinedSpec
RETURN, 'no'
END

FUNCTION isWithNormCombinedBack
RETURN, 'no'
END

FUNCTION isWithNormCombinedSub
RETURN, 'no'
END

FUNCTION isWithRvsTOF
RETURN, 'no'
END

FUNCTION isWithRvsTOFcombined
RETURN, 'no'
END

;*******************************************************************************
FUNCTION IDLparseCommandLine::getMainDataNexusFileName
RETURN, self.MainDataNexusFileName
END

FUNCTION IDLparseCommandLine::getMainDataRunNumber
RETURN, self.MainDataRunNumber
END

FUNCTION IDLparseCommandLine::getDataRoiFileName
RETURN, self.DataRoiFileName
END

FUNCTION IDLparseCommandLine::geDataPeakExclYArray
RETURN, self.DataPeakExclYArray
END

FUNCTION IDLparseCommandLine::getMainNormNexusFileName
RETURN, self.MainNormNexusFileName
END

FUNCTION IDLparseCommandLine::getMainNormRunNumber
RETURN, self.MainNormRunNumber
END

FUNCTION IDLparseCommandLine::getNormRoiFileName
RETURN, self.NormRoiFileName
END

FUNCTION IDLparseCommandLine::getNormPeakExclYArray
RETURN, self.NormPeakExclYArray
END

FUNCTION IDLparseCommandLine::getDataBackgroundFalg
RETURN, self.DataBackgroundFlag
END

FUNCTION IDLparseCommandLine::getNormBackgroundFlag
RETURN, self.NormBackgroundFlag
END

FUNCTION IDLparseCommandLine::getQmin
RETURN, self.Qmin
END

FUNCTION IDLparseCommandLine::getQmax
RETURN, self.Qmax
END

FUNCTION IDLparseCommandLine::getQwidth
RETURN, self.Qwidth
END

FUNCTION IDLparseCommandLine::getQtype
RETURN, self.Qtype
END

FUNCTION IDLparseCommandLine::getAngValue
RETURN, self.AngleValue
END

FUNCTION IDLparseCommandLine::getAngError
RETURN, self.AngleError
END

FUNCTION IDLparseCommandLine::getAngUnits
RETURN, self.AngleUnits
END

FUNCTION IDLparseCommandLine::getFilteringDataFlag
RETURN, self.FilteringDataFlag
END

FUNCTION IDLparseCommandLine::getDeltaTOverT
RETURN, self.DeltaTOverT
END

FUNCTION IDLparseCommandLine::getOverwriteDataInstrGeo
RETURN, self.OverwriteDataInstrGeo
END

FUNCTION IDLparseCommandLine::getDataInstrGeoFileName
RETURN, self.DataInstrGeoFileName
END

FUNCTION IDLparseCommandLine::getOverwriteNormInstrGeo
RETURN, self.OverwriteNormInstrGeo
END

FUNCTION IDLparseCommandLine::getNormInstrGeoFileName
RETURN, self.NormInstrGeoFileName
END

FUNCTION IDLparseCommandLine::getOutputPath
RETURN, self.OutputPath
END

FUNCTION IDLparseCommandLine::getOutputFileName
RETURN, self.OutputFileName
END

FUNCTION IDLparseCommandLine::getDataCombinedSpecFlag
RETURN, self.DataCombinedSpecFlag
END

FUNCTION IDLparseCommandLine::getDataCombinedBackFlag
RETURN, self.DataCombinedBackFlag
END

FUNCTION IDLparseCommandLine::getDataCombinedSubFlag
RETURN, self.DataCombinedSubFlag
END

FUNCTION IDLparseCommandLine::getNormCombinedSpecFlag
RETURN, self.NormCombinedSpecFlag
END

FUNCTION IDLparseCommandLine::getNormCombinedBackFlag
RETURN, self.NormCombinedBackFlag
END

FUNCTION IDLparseCommandLine::getNormCombinedSubFlag
RETURN, self.NormCombinedSubFlag
END

FUNCTION IDLparseCommandLine::getRvsTOFFlag
RETURN, self.RvsTOFFlag
END

FUNCTION IDLparseCommandLine::getRvsTOFcombinedFlag
RETURN, self.RvsTOFcombinedFlag
END

;###############################################################################
;******  Class constructor *****************************************************
FUNCTION IDLparseCommandLine::init, cmd

self.cmd = cmd

;Work on Data
self.MainDataNexusFileName = getMainDataNexusFileName()
self.MainDataRunNUmber     = getMainDataRunNumber()
self.DataRoiFileName       = getDataRoiFileName()
self.DataPeakExclYArray    = getDataPeakExclYArray()

;Work on Normalization
self.MainNormNexusFileName = getMainNormNexusFileName()
self.MainNormRunNUmber     = getMainNormRunNumber()
self.NormRoiFileName       = getNormRoiFileName()
self.NormPeakExclYArray    = getNormPeakExclYArray()

;;Reduce Tab
;Background flags
self.DataBackgroundFlag    = isWithDataBackgroundFlagOn()
self.NormBackgroundFlag    = isWithNormBackgroundFlagOn()
;Q [Qmin,Qmax,Qwidth,linear/log]
self.Qmin                  = getQmin()
self.Qmax                  = getQmax()
self.Qwidth                = getQwidth()
self.Qtype                 = getQtype()
;Angle Offset
self.AngleValue            = getAngleValue()
self.AngleError            = getAngleError()
;filtering data
self.FilteringDataFlag     = isWithFilteringDataFlag()
;dt/t
self.DeltaTOverT           = isWithDeltaTOverT()
;overwrite data intrument geometry
self.OverwriteDataInstrGeo = isWithOverwriteDataInstrGeo()
;Data instrument geometry file name
self.DataInstrGeoFileName  = getDataInstrumentGeoFileName()
;overwrite norm intrument geometry
self.OverwriteNormInstrGeo = isWithOverwriteNormInstrGeo()
;Norm instrument geometry file name
self.NormInstrGeoFileName  = getNormInstrumentGeoFileName()
;output path
self.OutputPath            = getOutputPath()
;output file name
self.OutputFileName        = getOutputFileName()
;;Intermediate File Flags
self.DataCombinedSpecFlag  = isWithDataCombinedSpec()
self.DataCombinedBackFlag  = isWithDataCombinedBack()
self.DataCombinedSubFlag   = isWithDataCombinedSub()
self.NormCombinedSpecFlag  = isWithNormCombinedSpec()
self.NormCombinedBackFlag  = isWithNormCombinedBack()
self.NormCombinedSubFlag   = isWithNormCombinedSub()
self.RvsTOFFlag            = isWithRvsTOF()
self.RvsTOFcombinedFlag    = isWithRvsTOFcombined()                

END

;******  Class Define **** *****************************************************
PRO IDLparseCommandLine__define
STRUCT = {IDLparseCommandLine,$
          cmd                   : '',$
          MainDataNexusFileName : '',$
          MainDataRunNumber     : '',$
          DataRoiFileName       : '',$
          DataPeakExclYArray    : [0,0],$
          MainNormNexusFileName : '',$
          MainNormRunNumber     : '',$
          NormRoiFileName       : '',$
          NormPeakExclYArray    : [0,0],$
          DataBackgroundFlag    : 'yes',$
          NormBackgroundFlag    : 'yes',$
          Qmin                  : '',$
          Qmax                  : '',$
          Qwidth                : '',$
          Qtype                 : '',$
          AngleValue            : '',$
          AngleError            : '',$
          AngleUnits            : '',$
          FilteringDataFlag     : 'yes',$
          DeltaTOverT           : 'no',$
          OverwriteDataInstrGeo : 'no',$
          DataInstrGeoFileName  : '',$
          OverwriteNormInstrGeo : 'no',$
          NormInstrGeoFileName  : '',$
          OutputPath            : '',$
          OutputFileName        : '',$
          DataCombinedSpecFlag  : 'no',$
          DataCombinedBackFlag  : 'no',$
          DataCombinedSubFlag   : 'no',$
          NormCombinedSpecFlag  : 'no',$
          NormCombinedBackFlag  : 'no',$
          NormCombinedSubFlag   : 'no',$
          RvsTOFFlag            : 'no',$
          RvsTOFcombinedFlag    : 'no'}

END

