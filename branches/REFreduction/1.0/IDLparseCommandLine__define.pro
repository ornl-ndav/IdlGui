;This function parse the 'base_string'. 
;#1 -> it splits the 'base_string' using the 'arg1' string and keeps
;the 'arg1Index' of the resulting array
;#2 -> it splits the result from step1 using 'arg2' and keeps
;the 'arg2Index' of the resulting array
FUNCTION ValueBetweenArg1Arg2, base_string, $
                               arg1, arg1Index, $
                               arg2, arg2Index
Split1 = STRSPLIT(base_string,arg1,/EXTRACT,/REGEX,COUNT=length)
IF (length GT 1) THEN BEGIN
    Split2 = STRSPLIT(Split1[arg1Index],arg2,/EXTRACT,/REGEX)
    RETURN, Split2[arg2Index]
ENDIF ELSE BEGIN
    RETURN, ''
ENDELSE 
END

;This function parse the 'base_string' and returns the string found
;before the string 'arg1'
FUNCTION ValueBeforeArg1, base_string, arg1
Split = STRSPLIT(base_string, arg1,/EXTRACT,/REGEX)
RETURN, Split[0]
END

;This function parse the 'base_string' and returns the string found
;after the string 'arg1'
FUNCTION ValueAfterArg1, base_string, arg1
Split = STRSPLIT(base_string, arg1,/EXTRACT,/REGEX)
RETURN, Split[1]
END

;This function returns 1 if 'arg' has been found in 'base_string'
FUNCTION isStringFound, base_string, arg
RETURN, STRMATCH(base_string,'*'+arg+'*')
END

;This function returns the full string up to the last 'arg' found
FUNCTION ValueBeforeLastArg, base_string, arg
Split = STRSPLIT(base_string,arg,/EXTRACT,/REGEX,COUNT=length)
IF (length GT 1) THEN BEGIN
    result = STRJOIN(Split[0:length-2],arg)
    ArgIndex = STRSPLIT(base_string,arg,/REGEX,COUNT=length)
    IF (ArgIndex[0] EQ 1) THEN BEGIN
        RETURN, (arg + result + arg)
    ENDIF 
    RETURN, (result + arg)
ENDIF ELSE BEGIN
    RETURN, ''
ENDELSE
END

;This function returns the full string after the last 'arg' found
FUNCTION ValueAfterLastArg, base_string, arg
Split = STRSPLIT(base_string,arg,/EXTRACT,/REGEX,COUNT=length)
RETURN, Split[length-1]
END


;*******************************************************************************
;***** UTILITIES ***************************************************************

FUNCTION getMainDataNexusFileName, cmd
result = ValueBetweenArg1Arg2(cmd, 'reflect_reduction', 1, ' ', 0)
RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

FUNCTION getMainDataRunNumber, FullNexusName
inst = obj_new('IDLgetMetadata',FullNexusName)
RETURN, STRCOMPRESS(inst->getRunNumber(),/REMOVE_ALL)
END

FUNCTION getAllDataNexusFileName, cmd
result = ValueBetweenArg1Arg2(cmd, $
                              'reflect_reduction',$
                              1, $
                              '--data-roi-file', $
                              0)
RETURN, result
END

FUNCTION getDataRoiFileName, cmd
result = ValueBetweenArg1Arg2(cmd, '--data-roi-file=', 1, ' ', 0)
RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

FUNCTION getDataPeakExclYArray, cmd
Ymin = ValueBetweenArg1Arg2(cmd, '--data-peak-excl=', 1, ' ', 0)
Ymax = ValueBetweenArg1Arg2(cmd, '--data-peak-excl=', 1, ' ', 1)
RETURN, [STRCOMPRESS(Ymin),STRCOMPRESS(Ymax)]
END

FUNCTION getMainNormNexusFileName, cmd
result  = ValueBetweenArg1Arg2(cmd, '--norm=', 1, ' ', 0)
result1 = ValueBeforeArg1(result, ',')
RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

FUNCTION getMainNormRunNumber, FullNexusName
inst = obj_new('IDLgetMetadata',FullNexusName)
RETURN, STRCOMPRESS(inst->getRunNumber(),/REMOVE_ALL)
END

FUNCTION getAllNormNexusFileName, cmd
result = ValueBetweenArg1Arg2(cmd,$
                              '--norm=',$
                              1,$
                              '--norm-roi-file=',$
                              0)
RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END
   
FUNCTION getNormRoiFileName, cmd
result = ValueBetweenArg1Arg2(cmd, '--norm-roi-file=', 1, ' ', 0)
RETURN, result
END

FUNCTION getNormPeakExclYArray, cmd
Ymin = ValueBetweenArg1Arg2(cmd, '--norm-peak-excl=', 1, ' ', 0)
Ymax = ValueBetweenArg1Arg2(cmd, '--norm-peak-excl=', 1, ' ', 1)
RETURN, [STRCOMPRESS(Ymin),STRCOMPRESS(Ymax)]
END

FUNCTION isWithDataBackgroundFlagOn, cmd
IF (isStringFound(cmd,'--no-bkg')) THEN BEGIN
    RETURN, 'yes'
ENDIF ELSE BEGIN
    RETURN, 'no'
ENDELSE
END

FUNCTION isWithNormBackgroundFlagOn, cmd
IF (isStringFound(cmd,'--no-norm-bkg')) THEN BEGIN
    RETURN, 'yes'
ENDIF ELSE BEGIN
    RETURN, 'no'
ENDELSE
END

FUNCTION getQmin, cmd
result = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 0)
RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

FUNCTION getQmax, cmd
result = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 1)
RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

FUNCTION getQwidth, cmd
result = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 2)
RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

FUNCTION getQtype, cmd
result  = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 3)
result1 = ValueBeforeArg1(result, ' ')
RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

FUNCTION getAngleValue, cmd
IF (isStringFound(cmd,'--angle-offset=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 0)
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
ENDIF
RETURN, ''
END

FUNCTION getAngleError, cmd
IF (isStringFound(cmd,'--angle-offset=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 1)
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
ENDIF
RETURN, ''
END

FUNCTION getAngleUnits, cmd
IF (isStringFound(cmd,'--angle-offset=')) THEN BEGIN
    result  = ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 2)
    result1 = ValueBeforeArg1(result,' ')
    result2 = ValueAfterArg1(result1,'=')
    RETURN, STRCOMPRESS(result2,/REMOVE_ALL)
ENDIF
RETURN, ''
END

FUNCTION isWithFilteringDataFlag, cmd
IF (isStringFound(cmd,'--no-filter=')) THEN BEGIN
    RETURN, 'no'
ENDIF ELSE BEGIN
    RETURN, 'yes'
ENDELSE
END

FUNCTION isWithDeltaTOverT, cmd
IF (isStringFound(cmd,'--store-dtot')) THEN BEGIN
    RETURN, 'yes'
ENDIF ELSE BEGIN
    RETURN, 'no'
ENDELSE
END

FUNCTION isWithOverwriteDataInstrGeo, cmd
IF (isStringFound(cmd,'--data-inst-geom=')) THEN BEGIN
    RETURN, 'yes'
ENDIF ELSE BEGIN
    RETURN, 'no'
END
END

FUNCTION getDataInstrumentGeoFileName, cmd
IF (isStringFound(cmd,'--data-inst-geom=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--data-inst-geom=', 1, ' ', 0)
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
ENDIF ELSE BEGIN
    RETURN, ''
END
END

FUNCTION isWithOverwriteNormInstrGeo, cmd
IF (isStringFound(cmd,'--norm-inst-geom=')) THEN BEGIN
    RETURN, 'yes'
ENDIF ELSE BEGIN
    RETURN, 'no'
END
END

FUNCTION getNormInstrumentGeoFileName, cmd
IF (isStringFound(cmd,'--norm-inst-geom=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--norm-inst-geom=', 1, ' ', 0)
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
ENDIF ELSE BEGIN
    RETURN, ''
END
END

FUNCTION getOutputPath, cmd
result = ValueBetweenArg1Arg2(cmd, '--output=', 1, ' ', 0)
result1 = ValueBeforeLastArg(result, '/')
RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

FUNCTION class_getOutputFileName, cmd
result  = ValueBetweenArg1Arg2(cmd, '--output=', 1, ' ', 0)
result1 = ValueAfterLastArg(result, '/')
RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

FUNCTION isWithDataNormCombinedSpec, cmd
IF (isStringFound(cmd,'--dump-specular')) THEN RETURN, 'yes'
RETURN, 'no'
END

FUNCTION isWithDataNormCombinedBack, cmd
IF (isStringFound(cmd,'--dump-bkg')) THEN RETURN, 'yes'
RETURN, 'no'
END

FUNCTION isWithDataNormCombinedSub, cmd
IF (isStringFound(cmd,'--dump-sub')) THEN RETURN, 'yes'
RETURN, 'no'
END

FUNCTION isWithRvsTOF, cmd
IF (isStringFound(cmd,'--dump-rtof')) THEN RETURN, 'yes'
RETURN, 'no'
END

FUNCTION isWithRvsTOFcombined, cmd
IF (isStringFound(cmd,'--dump-rtof-comb')) THEN RETURN, 'yes'
RETURN, 'no'
END

;*******************************************************************************
FUNCTION IDLparseCommandLine::getMainDataNexusFileName
RETURN, self.MainDataNexusFileName
END

FUNCTION IDLparseCommandLine::getMainDataRunNumber
RETURN, self.MainDataRunNumber
END

FUNCTION IDLparseCommandLine::getAllDAtaNexusFileName
RETURN, self.AllDataNexusFileName
END

FUNCTION IDLparseCommandLine::getDataRoiFileName
RETURN, self.DataRoiFileName
END

FUNCTION IDLparseCommandLine::getDataPeakExclYArray
RETURN, self.DataPeakExclYArray
END

FUNCTION IDLparseCommandLine::getMainNormNexusFileName
RETURN, self.MainNormNexusFileName
END

FUNCTION IDLparseCommandLine::getMainNormRunNumber
RETURN, self.MainNormRunNumber
END

FUNCTION IDLparseCommandLine::getAllNormNexusFileName
RETURN, self.AllNormNexusFileName
END

FUNCTION IDLparseCommandLine::getNormRoiFileName
RETURN, self.NormRoiFileName
END

FUNCTION IDLparseCommandLine::getNormPeakExclYArray
RETURN, self.NormPeakExclYArray
END

FUNCTION IDLparseCommandLine::getDataBackgroundFlag
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

FUNCTION IDLparseCommandLine::getAngleValue
RETURN, self.AngleValue
END

FUNCTION IDLparseCommandLine::getAngleError
RETURN, self.AngleError
END

FUNCTION IDLparseCommandLine::getAngleUnits
RETURN, self.AngleUnits
END

FUNCTION IDLparseCommandLine::getFilteringDataFlag
RETURN, self.FilteringDataFlag
END

FUNCTION IDLparseCommandLine::getDeltaTOverTFlag
RETURN, self.DeltaTOverT
END

FUNCTION IDLparseCommandLine::getOverwriteDataInstrGeoFlag
RETURN, self.OverwriteDataInstrGeo
END

FUNCTION IDLparseCommandLine::getDataInstrGeoFileName
RETURN, self.DataInstrGeoFileName
END

FUNCTION IDLparseCommandLine::getOverwriteNormInstrGeoFlag
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

FUNCTION IDLparseCommandLine::getDataNormCombinedSpecFlag
RETURN, self.DataNormCombinedSpecFlag
END

FUNCTION IDLparseCommandLine::getDataNormCombinedBackFlag
RETURN, self.DataNormCombinedBackFlag
END

FUNCTION IDLparseCommandLine::getDataNormCombinedSubFlag
RETURN, self.DataNormCombinedSubFlag
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

;Work on Data
self.MainDataNexusFileName  = getMainDataNexusFileName(cmd)
self.MainDataRunNUmber      = $
  getMainDataRunNumber(self.MainDataNexusFileName)
self.AllDataNexusFileName   = getAllDataNexusFileName(cmd)
self.DataRoiFileName        = getDataRoiFileName(cmd)
self.DataPeakExclYArray     = getDataPeakExclYArray(cmd)

;Work on Normalization
self.MainNormNexusFileName = getMainNormNexusFileName(cmd)
self.MainNormRunNUmber     = $
  getMainNormRunNumber(self.MainNormNexusFileName)
self.AllNormNexusFileName  = getAllNormNexusFileName(cmd)
self.NormRoiFileName       = getNormRoiFileName(cmd)
self.NormPeakExclYArray    = getNormPeakExclYArray(cmd)

;;Reduce Tab
;Background flags
self.DataBackgroundFlag    = isWithDataBackgroundFlagOn(cmd)
self.NormBackgroundFlag    = isWithNormBackgroundFlagOn(cmd)
;Q [Qmin,Qmax,Qwidth,linear/log]
self.Qmin                  = getQmin(cmd)
self.Qmax                  = getQmax(cmd)
self.Qwidth                = getQwidth(cmd)
self.Qtype                 = getQtype(cmd)
;Angle Offset
self.AngleValue            = getAngleValue(cmd)
self.AngleError            = getAngleError(cmd)
self.AngleUnits            = getAngleUnits(cmd)
;filtering data
self.FilteringDataFlag     = isWithFilteringDataFlag(cmd)
;dt/t
self.DeltaTOverT           = isWithDeltaTOverT(cmd)
;overwrite data intrument geometry
self.OverwriteDataInstrGeo = isWithOverwriteDataInstrGeo(cmd)
;Data instrument geometry file name
self.DataInstrGeoFileName  = getDataInstrumentGeoFileName(cmd)
;overwrite norm intrument geometry
self.OverwriteNormInstrGeo = isWithOverwriteNormInstrGeo(cmd)
;Norm instrument geometry file name
self.NormInstrGeoFileName  = getNormInstrumentGeoFileName(cmd)
;output path
self.OutputPath            = getOutputPath(cmd)
;output file name
self.OutputFileName        = class_getOutputFileName(cmd)
;;Intermediate File Flags
self.DataNormCombinedSpecFlag  = isWithDataNormCombinedSpec(cmd)
self.DataNormCombinedBackFlag  = isWithDataNormCombinedBack(cmd)
self.DataNormCombinedSubFlag   = isWithDataNormCombinedSub(cmd)
self.RvsTOFFlag                = isWithRvsTOF(cmd)
self.RvsTOFcombinedFlag        = isWithRvsTOFcombined(cmd)                

RETURN, 1
END

;******  Class Define **** *****************************************************

PRO IDLparseCommandLine__define
STRUCT = {IDLparseCommandLine,$
          MainDataNexusFileName     : '',$
          MainDataRunNumber         : '',$
          AllDataNexusFileName      : '',$
          DataRoiFileName           : '',$
          DataPeakExclYArray        : ['',''],$
          MainNormNexusFileName     : '',$
          MainNormRunNumber         : '',$
          AllNormNexusFileName      : '',$
          NormRoiFileName           : '',$
          NormPeakExclYArray        : [0,0],$
          DataBackgroundFlag        : 'yes',$
          NormBackgroundFlag        : 'yes',$
          Qmin                      : '',$
          Qmax                      : '',$
          Qwidth                    : '',$
          Qtype                     : '',$
          AngleValue                : '',$
          AngleError                : '',$
          AngleUnits                : '',$
          FilteringDataFlag         : 'yes',$
          DeltaTOverT               : 'no',$
          OverwriteDataInstrGeo     : 'no',$
          DataInstrGeoFileName      : '',$
          OverwriteNormInstrGeo     : 'no',$
          NormInstrGeoFileName      : '',$
          OutputPath                : '',$
          OutputFileName            : '',$
          DataNormCombinedSpecFlag  : 'no',$
          DataNormCombinedBackFlag  : 'no',$
          DataNormCombinedSubFlag   : 'no',$
          RvsTOFFlag                : 'no',$
          RvsTOFcombinedFlag        : 'no'}

END

;*******************************************************************************
;*******************************************************************************
