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
;------ UTILITIES -------------------------------------------------------------
;This function parse the 'base_string'.
;#1 -> it splits the 'base_string' using the 'arg1' string and keeps
;the 'arg1Index' of the resulting array
;#2 -> it splits the result from step1 using 'arg2' and keeps
;the 'arg2Index' of the resulting array
FUNCTION ref_l_ValueBetweenArg1Arg2, base_string, $
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

;------------------------------------------------------------------------------
;This function parse the 'base_string' and returns the string found
;before the string 'arg1'
FUNCTION ref_l_ValueBeforeArg1, base_string, arg1
  Split = STRSPLIT(base_string, arg1,/EXTRACT,/REGEX)
  RETURN, Split[0]
END

;------------------------------------------------------------------------------
;This function parse the 'base_string' and returns the string found
;after the string 'arg1'
FUNCTION ref_l_ValueAfterArg1, base_string, arg1
  Split = STRSPLIT(base_string, arg1,/EXTRACT,/REGEX)
  RETURN, Split[1]
END

;------------------------------------------------------------------------------
;This function returns 1 if 'arg' has been found in 'base_string'
FUNCTION ref_l_isStringFound, base_string, arg
  RETURN, STRMATCH(base_string,'*'+arg+'*')
END

;------------------------------------------------------------------------------
;This function returns the full string up to the last 'arg' found
FUNCTION ref_l_ValueBeforeLastArg, base_string, arg
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

;------------------------------------------------------------------------------
;This function returns the full string after the last 'arg' found
FUNCTION ref_l_ValueAfterLastArg, base_string, arg
  Split = STRSPLIT(base_string,arg,/EXTRACT,/REGEX,COUNT=length)
  RETURN, Split[length-1]
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION ref_l_getMainDataNexusFileName, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, 'reflect_reduction', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getMainDataRunNumber, FullNexusName
  inst = obj_new('IDLgetMetadata',FullNexusName)
  RETURN, STRCOMPRESS(inst->getRunNumber(),/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getAllDataNexusFileName, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, $
    'reflect_reduction ',$
    1, $
    '--data-roi-file', $
    0)
  
  print, result
  
  IF (result EQ '') THEN RETURN, ''
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getDataRoiFileName, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--data-roi-file=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getDataPeakExclYArray, cmd
  Ymin = ref_l_ValueBetweenArg1Arg2(cmd, '--data-peak-excl=', 1, ' ', 0)
  IF (Ymin EQ '') THEN Ymin=''
  Ymax = ref_l_ValueBetweenArg1Arg2(cmd, '--data-peak-excl=', 1, ' ', 1)
  IF (Ymax EQ '') THEN Ymax=''
  RETURN, [STRCOMPRESS(Ymin),STRCOMPRESS(Ymax)]
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getDataBackFileName, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--dbkg-roi-file=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getTOFcuttingMin, cmd
 result = ref_l_ValueBetweenArg1Arg2(cmd, '--tof-cut-min=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END
 
;------------------------------------------------------------------------------
FUNCTION ref_l_getTOFcuttingMax, cmd
 result = ref_l_ValueBetweenArg1Arg2(cmd, '--tof-cut-max=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getMainNormNexusFileName, cmd
  result  = ref_l_ValueBetweenArg1Arg2(cmd, '--norm=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  result1 = ref_l_ValueBeforeArg1(result, ',')
  IF (result1 EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getMainNormRunNumber, FullNexusName
  inst = obj_new('IDLgetMetadata',FullNexusName)
  RETURN, STRCOMPRESS(inst->getRunNumber(),/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getAllNormNexusFileName, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd,$
    '--norm=',$
    1,$
    '--norm-roi-file=',$
    0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getNormRoiFileName, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--norm-roi-file=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getNormPeakExclYArray, cmd
  Ymin = ref_l_ValueBetweenArg1Arg2(cmd, '--norm-peak-excl=', 1, ' ', 0)
  IF (Ymin EQ '') THEN Ymin=''
  Ymax = ref_l_ValueBetweenArg1Arg2(cmd, '--norm-peak-excl=', 1, ' ', 1)
  IF (Ymax EQ '') THEN Ymax=''
  RETURN, [STRCOMPRESS(Ymin),STRCOMPRESS(Ymax)]
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getNormBackFileName, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--nbkg-roi-file=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithDataBackgroundFlagOn, cmd
  IF (ref_l_isStringFound(cmd,'--no-bkg')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithNormBackgroundFlagOn, cmd
  IF (ref_l_isStringFound(cmd,'--no-norm-bkg')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getQmin, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getQmax, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 1)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getQwidth, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 2)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getQtype, cmd
  result  = ref_l_ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 3)
  IF (result EQ '') THEN RETURN, ''
  result1 = ref_l_ValueBeforeArg1(result, ' ')
  IF (result1 EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getAngleValue, cmd
  IF (ref_l_isStringFound(cmd,'--angle-offset=')) THEN BEGIN
    result = ref_l_ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 0)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getAngleError, cmd
  IF (ref_l_isStringFound(cmd,'--angle-offset=')) THEN BEGIN
    result = ref_l_ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 1)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getAngleUnits, cmd
  units_error = 0
  CATCH, units_error
  IF (units_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    return, ''
  ENDIF ELSE BEGIN
    IF (ref_l_isStringFound(cmd,'--angle-offset=')) THEN BEGIN
      result  = ref_l_ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 2)
      IF (result EQ '') THEN RETURN, ''
      result1 = ref_l_ValueBeforeArg1(result,' ')
      IF (result1 EQ '') THEN RETURN, ''
      result2 = ref_l_ValueAfterArg1(result1,'=')
      IF (result2 EQ '') THEN RETURN, ''
      RETURN, STRCOMPRESS(result2,/REMOVE_ALL)
    ENDIF
    RETURN, ''
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithFilteringDataFlag, cmd
  IF (ref_l_isStringFound(cmd,'--no-filter=')) THEN BEGIN
    RETURN, 'no'
  ENDIF ELSE BEGIN
    RETURN, 'yes'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithDeltaTOverT, cmd
  IF (ref_l_isStringFound(cmd,'--store-dtot')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithOverwriteDataInstrGeo, cmd
  IF (ref_l_isStringFound(cmd,'--data-inst-geom=')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  END
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getDataInstrumentGeoFileName, cmd
  IF (ref_l_isStringFound(cmd,'--data-inst-geom=')) THEN BEGIN
    result = ref_l_ValueBetweenArg1Arg2(cmd, '--data-inst-geom=', 1, ' ', 0)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    RETURN, ''
  END
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithOverwriteNormInstrGeo, cmd
  IF (ref_l_isStringFound(cmd,'--norm-inst-geom=')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  END
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getNormInstrumentGeoFileName, cmd
  IF (ref_l_isStringFound(cmd,'--norm-inst-geom=')) THEN BEGIN
    result = ref_l_ValueBetweenArg1Arg2(cmd, '--norm-inst-geom=', 1, ' ', 0)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    RETURN, ''
  END
END

;------------------------------------------------------------------------------
FUNCTION ref_l_getOutputPath, cmd
  result = ref_l_ValueBetweenArg1Arg2(cmd, '--output=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  result1 = ref_l_ValueBeforeLastArg(result, '/')
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_class_getOutputFileName, cmd
  result  = ref_l_ValueBetweenArg1Arg2(cmd, '--output=', 1, ' ', 0)
  IF (result NE '') THEN BEGIN
    result1 = ref_l_ValueAfterLastArg(result, '/')
  ENDIF ELSE BEGIN
    result1 = ''
  ENDELSE
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithDataNormCombinedSpec, cmd
  IF (ref_l_isStringFound(cmd,'--dump-specular')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithDataNormCombinedBack, cmd
  IF (ref_l_isStringFound(cmd,'--dump-bkg')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithDataNormCombinedSub, cmd
  IF (ref_l_isStringFound(cmd,'--dump-sub')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithRvsTOF, cmd
  IF (ref_l_isStringFound(cmd,'--dump-rtof')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION ref_l_isWithRvsTOFcombined, cmd
  IF (ref_l_isStringFound(cmd,'--dump-rtof-comb')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;******************************************************************************
;******************************************************************************
FUNCTION IDLparseCommandLine::getMainDataNexusFileName
  RETURN, self.MainDataNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getMainDataRunNumber
  RETURN, self.MainDataRunNumber
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getAllDAtaNexusFileName
  RETURN, self.AllDataNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataRoiFileName
  RETURN, self.DataRoiFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataPeakExclYArray
  RETURN, self.DataPeakExclYArray
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataBackFileName
  RETURN, self.DataBackFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getTOFcuttingMin
  RETURN, self.TOFcuttingMin
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getTOFcuttingMax
  RETURN, self.TOFcuttingMax
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getMainNormNexusFileName
  RETURN, self.MainNormNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getMainNormRunNumber
  RETURN, self.MainNormRunNumber
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getAllNormNexusFileName
  RETURN, self.AllNormNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getNormRoiFileName
  RETURN, self.NormRoiFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getNormPeakExclYArray
  RETURN, self.NormPeakExclYArray
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getNormBackFileName
  RETURN, self.NormBackFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataBackgroundFlag
  RETURN, self.DataBackgroundFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getNormBackgroundFlag
  RETURN, self.NormBackgroundFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getQmin
  RETURN, self.Qmin
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getQmax
  RETURN, self.Qmax
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getQwidth
  RETURN, self.Qwidth
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getQtype
  RETURN, self.Qtype
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getAngleValue
  RETURN, self.AngleValue
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getAngleError
  RETURN, self.AngleError
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getAngleUnits
  RETURN, self.AngleUnits
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getFilteringDataFlag
  RETURN, self.FilteringDataFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDeltaTOverTFlag
  RETURN, self.DeltaTOverT
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getOverwriteDataInstrGeoFlag
  RETURN, self.OverwriteDataInstrGeo
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataInstrGeoFileName
  RETURN, self.DataInstrGeoFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getOverwriteNormInstrGeoFlag
  RETURN, self.OverwriteNormInstrGeo
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getNormInstrGeoFileName
  RETURN, self.NormInstrGeoFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getOutputPath
  RETURN, self.OutputPath
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getOutputFileName
  RETURN, self.OutputFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataNormCombinedSpecFlag
  RETURN, self.DataNormCombinedSpecFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataNormCombinedBackFlag
  RETURN, self.DataNormCombinedBackFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getDataNormCombinedSubFlag
  RETURN, self.DataNormCombinedSubFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getRvsTOFFlag
  RETURN, self.RvsTOFFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine::getRvsTOFcombinedFlag
  RETURN, self.RvsTOFcombinedFlag
END

;##############################################################################
;******  Class constructor ****************************************************
FUNCTION IDLparseCommandLine::init, cmd

  general_error = 0
  CATCH, general_error
  IF (general_error NE 0) THEN BEGIN
    RETURN, 0
  ENDIF ELSE BEGIN
    ;Work on Data
    self.MainDataNexusFileName  = ref_l_getMainDataNexusFileName(cmd)
    IF (self.MainDataNexusFileName NE '') THEN BEGIN
      self.MainDataRunNUmber      = $
        ref_l_getMainDataRunNumber(self.MainDataNexusFileName)
    ENDIF ELSE BEGIN
      self.MainDataRunNumber  = ''
    ENDELSE
    self.AllDataNexusFileName   = ref_l_getAllDataNexusFileName(cmd)
    self.DataRoiFileName        = ref_l_getDataRoiFileName(cmd)
    self.DataPeakExclYArray     = ref_l_getDataPeakExclYArray(cmd)
    self.DataBackFileName       = ref_l_getDataBackFileName(cmd)
    self.TOFcuttingMin          = ref_l_getTOFcuttingMin(cmd)
    self.TOFcuttingMax          = ref_l_getTOFcuttingMax(cmd)
    
    ;Work on Normalization
    self.MainNormNexusFileName = ref_l_getMainNormNexusFileName(cmd)
    IF (self.MainNormNexusFileName NE '') THEN BEGIN
      self.MainNormRunNUmber     = $
        ref_l_getMainNormRunNumber(self.MainNormNexusFileName)
    ENDIF ELSE BEGIN
      self.MainNormRunNumber = ''
    ENDELSE
    self.AllNormNexusFileName  = ref_l_getAllNormNexusFileName(cmd)
    self.NormRoiFileName       = ref_l_getNormRoiFileName(cmd)
    self.NormPeakExclYArray    = ref_l_getNormPeakExclYArray(cmd)
    self.NormBackFileName      = ref_l_getNormBackFileName(cmd)
    
    ;;Reduce Tab
    ;Background flags
    self.DataBackgroundFlag        = ref_l_isWithDataBackgroundFlagOn(cmd)
    self.NormBackgroundFlag        = ref_l_isWithNormBackgroundFlagOn(cmd)
    ;Q [Qmin,Qmax,Qwidth,linear/log]
    self.Qmin                      = ref_l_getQmin(cmd)
    self.Qmax                      = ref_l_getQmax(cmd)
    self.Qwidth                    = ref_l_getQwidth(cmd)
    self.Qtype                     = ref_l_getQtype(cmd)
    ;Angle Offset
    self.AngleValue                = ref_l_getAngleValue(cmd)
    self.AngleError                = ref_l_getAngleError(cmd)
    self.AngleUnits                = ref_l_getAngleUnits(cmd)
    ;filtering data
    self.FilteringDataFlag         = ref_l_isWithFilteringDataFlag(cmd)
    ;dt/t
    self.DeltaTOverT               = ref_l_isWithDeltaTOverT(cmd)
    ;overwrite data intrument geometry
    self.OverwriteDataInstrGeo     = ref_l_isWithOverwriteDataInstrGeo(cmd)
    ;Data instrument geometry file name
    self.DataInstrGeoFileName      = ref_l_getDataInstrumentGeoFileName(cmd)
    ;overwrite norm intrument geometry
    self.OverwriteNormInstrGeo     = ref_l_isWithOverwriteNormInstrGeo(cmd)
    ;Norm instrument geometry file name
    self.NormInstrGeoFileName      = ref_l_getNormInstrumentGeoFileName(cmd)
    ;output path
    self.OutputPath                = ref_l_getOutputPath(cmd)
    ;output file name
    self.OutputFileName            = ref_l_class_getOutputFileName(cmd)
    ;;Intermediate File Flags
    self.DataNormCombinedSpecFlag  = ref_l_isWithDataNormCombinedSpec(cmd)
    self.DataNormCombinedBackFlag  = ref_l_isWithDataNormCombinedBack(cmd)
    self.DataNormCombinedSubFlag   = ref_l_isWithDataNormCombinedSub(cmd)
    self.RvsTOFFlag                = ref_l_isWithRvsTOF(cmd)
    self.RvsTOFcombinedFlag        = ref_l_isWithRvsTOFcombined(cmd)
  ENDELSE
  RETURN, 1
END

;******************************************************************************
;****** Class Define **********************************************************
PRO IDLparseCommandLine__define
  STRUCT = {IDLparseCommandLine,$
    MainDataNexusFileName     : '',$
    MainDataRunNumber         : '',$
    AllDataNexusFileName      : '',$
    DataRoiFileName           : '',$
    DataPeakExclYArray        : ['',''],$
    DataBackFileName          : '',$
    
    TOFcuttingMin             : '',$
    TOFcuttingMax             : '',$
    
    MainNormNexusFileName     : '',$
    MainNormRunNumber         : '',$
    AllNormNexusFileName      : '',$
    NormRoiFileName           : '',$
    NormPeakExclYArray        : ['',''],$
    NormBackFileName          : '',$
    
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
;******************************************************************************
;******************************************************************************
