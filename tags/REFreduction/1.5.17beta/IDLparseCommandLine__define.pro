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

;------------------------------------------------------------------------------
;This function parse the 'base_string' and returns the string found
;before the string 'arg1'
FUNCTION ValueBeforeArg1, base_string, arg1
  Split = STRSPLIT(base_string, arg1,/EXTRACT,/REGEX)
  RETURN, Split[0]
END

;------------------------------------------------------------------------------
;This function parse the 'base_string' and returns the string found
;after the string 'arg1'
FUNCTION ValueAfterArg1, base_string, arg1
  Split = STRSPLIT(base_string, arg1,/EXTRACT,/REGEX)
  RETURN, Split[1]
END

;------------------------------------------------------------------------------
;This function returns 1 if 'arg' has been found in 'base_string'
FUNCTION isStringFound, base_string, arg
  RETURN, STRMATCH(base_string,'*'+arg+'*')
END

;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
;This function returns the full string after the last 'arg' found
FUNCTION ValueAfterLastArg, base_string, arg
  Split = STRSPLIT(base_string,arg,/EXTRACT,/REGEX,COUNT=length)
  RETURN, Split[length-1]
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;+
; :Description:
;    Return the string placed just after the driver name. 
;
; :Params:
;    cmd
;
; :Returns:
;   data file (full name) or empty if any
;
; :Author: j35
;-
function getMainDataNexusFileName, cmd
  compile_opt idl2
  
  driver_list = ['reflect_reduction',$
    '/SNS/users/j35/bin/runenv specmh_reduction']
  index = 0
  nbr_driver = n_elements(driver_list)
  while (index lt nbr_driver) do begin
    driver_name = driver_list[index]
    result = ValueBetweenArg1Arg2(cmd, driver_name, 1, ' ', 0)
    if (result[0] ne '') then begin
    return, strcompress(result,/remove_all)
    endif
    index++
  endwhile
  return, ''
end

;------------------------------------------------------------------------------
FUNCTION getMainDataRunNumber, FullNexusName
  inst = obj_new('IDLgetMetadata',FullNexusName)
  RETURN, STRCOMPRESS(inst->getRunNumber(),/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getAllDataNexusFileName, cmd
  
  driver_list = ['reflect_reduction', $
  '/SNS/users/j35/bin/runenv specmh_reduction']
  index = 0
  nbr_driver = n_elements(driver_list)
  while (index lt nbr_driver) do begin
  driver_name = driver_list[index]
  result = ValueBetweenArg1Arg2(cmd, $
    driver_name + ' ',$
    1, $
    '--data-roi-file', $
    0)
  IF (result[0] ne '') THEN return, result
  index++
  endwhile
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION getDataRoiFileName, cmd
  result = ValueBetweenArg1Arg2(cmd, '--data-roi-file=', 1, $
    ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getDataPeakExclYArray, cmd
  Ymin = ValueBetweenArg1Arg2(cmd, '--data-peak-excl=', 1, ' ', 0)
  IF (Ymin EQ '') THEN Ymin=''
  Ymax = ValueBetweenArg1Arg2(cmd, '--data-peak-excl=', 1, ' ', 1)
  IF (Ymax EQ '') THEN Ymax=''
  RETURN, [STRCOMPRESS(Ymin),STRCOMPRESS(Ymax)]
END

;------------------------------------------------------------------------------
FUNCTION getDataBackFileName, cmd
  result = ValueBetweenArg1Arg2(cmd, '--dbkg-roi-file=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getTOFcuttingMin, cmd
  result = ValueBetweenArg1Arg2(cmd, '--tof-cut-min=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getTOFcuttingMax, cmd
  result = ValueBetweenArg1Arg2(cmd, '--tof-cut-max=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getMainNormNexusFileName, cmd
  result  = ValueBetweenArg1Arg2(cmd, '--norm=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  result1 = ValueBeforeArg1(result, ',')
  IF (result1 EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getMainNormRunNumber, FullNexusName
  inst = obj_new('IDLgetMetadata',FullNexusName)
  RETURN, STRCOMPRESS(inst->getRunNumber(),/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getAllNormNexusFileName, cmd
  result = ValueBetweenArg1Arg2(cmd,$
    '--norm=',$
    1,$
    '--norm-roi-file=',$
    0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getNormRoiFileName, cmd
  result = ValueBetweenArg1Arg2(cmd, '--norm-roi-file=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION getNormPeakExclYArray, cmd
  Ymin = ValueBetweenArg1Arg2(cmd, '--norm-peak-excl=', 1, ' ', 0)
  IF (Ymin EQ '') THEN Ymin=''
  Ymax = ValueBetweenArg1Arg2(cmd, '--norm-peak-excl=', 1, ' ', 1)
  IF (Ymax EQ '') THEN Ymax=''
  RETURN, [STRCOMPRESS(Ymin),STRCOMPRESS(Ymax)]
END

;------------------------------------------------------------------------------
FUNCTION getNormBackFileName, cmd
  result = ValueBetweenArg1Arg2(cmd, '--nbkg-roi-file=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION isWithDataBackgroundFlagOn, cmd
  IF (isStringFound(cmd,'--no-bkg')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION isWithNormBackgroundFlagOn, cmd
  IF (isStringFound(cmd,'--no-norm-bkg')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getQmin, cmd
  result = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getQmax, cmd
  result = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 1)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getQwidth, cmd
  result = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 2)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getQtype, cmd
  result  = ValueBetweenArg1Arg2(cmd, '--mom-trans-bins=', 1, ',', 3)
  IF (result EQ '') THEN RETURN, ''
  result1 = ValueBeforeArg1(result, ' ')
  IF (result1 EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getAngleValue, cmd
  IF (isStringFound(cmd,'--angle-offset=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 0)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION getAngleError, cmd
  IF (isStringFound(cmd,'--angle-offset=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 1)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION getAngleUnits, cmd
  units_error = 0
  CATCH, units_error
  IF (units_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    return, ''
  ENDIF ELSE BEGIN
    IF (isStringFound(cmd,'--angle-offset=')) THEN BEGIN
      result  = ValueBetweenArg1Arg2(cmd, '--angle-offset=', 1, ',', 2)
      IF (result EQ '') THEN RETURN, ''
      result1 = ValueBeforeArg1(result,' ')
      IF (result1 EQ '') THEN RETURN, ''
      result2 = ValueAfterArg1(result1,'=')
      IF (result2 EQ '') THEN RETURN, ''
      RETURN, STRCOMPRESS(result2,/REMOVE_ALL)
    ENDIF
    RETURN, ''
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION isWithFilteringDataFlag, cmd
  IF (isStringFound(cmd,'--no-filter=')) THEN BEGIN
    RETURN, 'no'
  ENDIF ELSE BEGIN
    RETURN, 'yes'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION isWithDeltaTOverT, cmd
  IF (isStringFound(cmd,'--store-dtot')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION isWithOverwriteDataInstrGeo, cmd
  IF (isStringFound(cmd,'--data-inst-geom=')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  END
END

;------------------------------------------------------------------------------
FUNCTION getDataInstrumentGeoFileName, cmd
  IF (isStringFound(cmd,'--data-inst-geom=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--data-inst-geom=', 1, ' ', 0)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    RETURN, ''
  END
END

;------------------------------------------------------------------------------
FUNCTION isWithOverwriteNormInstrGeo, cmd
  IF (isStringFound(cmd,'--norm-inst-geom=')) THEN BEGIN
    RETURN, 'yes'
  ENDIF ELSE BEGIN
    RETURN, 'no'
  END
END

;------------------------------------------------------------------------------
FUNCTION getNormInstrumentGeoFileName, cmd
  IF (isStringFound(cmd,'--norm-inst-geom=')) THEN BEGIN
    result = ValueBetweenArg1Arg2(cmd, '--norm-inst-geom=', 1, ' ', 0)
    IF (result EQ '') THEN RETURN, ''
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    RETURN, ''
  END
END

;------------------------------------------------------------------------------
FUNCTION getOutputPath, cmd
  result = ValueBetweenArg1Arg2(cmd, '--output=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  result1 = ValueBeforeLastArg(result, '/')
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION class_getOutputFileName, cmd
  result  = ValueBetweenArg1Arg2(cmd, '--output=', 1, ' ', 0)
  IF (result NE '') THEN BEGIN
    result1 = ValueAfterLastArg(result, '/')
  ENDIF ELSE BEGIN
    result1 = ''
  ENDELSE
  RETURN, STRCOMPRESS(result1,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION isWithDataNormCombinedSpec, cmd
  IF (isStringFound(cmd,'--dump-specular')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION isWithDataNormCombinedBack, cmd
  IF (isStringFound(cmd,'--dump-bkg')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION isWithDataNormCombinedSub, cmd
  IF (isStringFound(cmd,'--dump-sub')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION isWithRvsTOF, cmd
  IF (isStringFound(cmd,'--dump-rtof')) THEN RETURN, 'yes'
  RETURN, 'no'
END

;------------------------------------------------------------------------------
FUNCTION isWithRvsTOFcombined, cmd
  IF (isStringFound(cmd,'--dump-rtof-comb')) THEN RETURN, 'yes'
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
    self.MainDataNexusFileName  = getMainDataNexusFileName(cmd)
    IF (self.MainDataNexusFileName NE '') THEN BEGIN
      self.MainDataRunNUmber      = $
        getMainDataRunNumber(self.MainDataNexusFileName)
    ENDIF ELSE BEGIN
      self.MainDataRunNumber  = ''
    ENDELSE
    self.AllDataNexusFileName   = getAllDataNexusFileName(cmd)
    self.DataRoiFileName        = getDataRoiFileName(cmd)
    self.DataPeakExclYArray     = getDataPeakExclYArray(cmd)
    self.DataBackgroundFlag     = isWithDataBackgroundFlagOn(cmd)

    self.TOFcuttingMin          = getTOFcuttingMin(cmd)
    self.TOFcuttingMax          = getTOFcuttingMax(cmd)
    
    ;Work on Normalization
    self.MainNormNexusFileName = getMainNormNexusFileName(cmd)
    IF (self.MainNormNexusFileName NE '') THEN BEGIN
      self.MainNormRunNUmber     = $
        getMainNormRunNumber(self.MainNormNexusFileName)
    ENDIF ELSE BEGIN
      self.MainNormRunNumber = ''
    ENDELSE
    self.AllNormNexusFileName  = getAllNormNexusFileName(cmd)
    self.NormRoiFileName       = getNormRoiFileName(cmd)
    self.NormPeakExclYArray    = getNormPeakExclYArray(cmd)
    self.NormBackgroundFlag    = isWithNormBackgroundFlagOn(cmd)
    
    ;;Reduce Tab
    ;Q [Qmin,Qmax,Qwidth,linear/log]
    self.Qmin                      = getQmin(cmd)
    self.Qmax                      = getQmax(cmd)
    self.Qwidth                    = getQwidth(cmd)
    self.Qtype                     = getQtype(cmd)
    ;Angle Offset
    self.AngleValue                = getAngleValue(cmd)
    self.AngleError                = getAngleError(cmd)
    self.AngleUnits                = getAngleUnits(cmd)
    ;filtering data
    self.FilteringDataFlag         = isWithFilteringDataFlag(cmd)
    ;dt/t
    self.DeltaTOverT               = isWithDeltaTOverT(cmd)
    ;overwrite data intrument geometry
    self.OverwriteDataInstrGeo     = isWithOverwriteDataInstrGeo(cmd)
    ;Data instrument geometry file name
    self.DataInstrGeoFileName      = getDataInstrumentGeoFileName(cmd)
    ;overwrite norm intrument geometry
    self.OverwriteNormInstrGeo     = isWithOverwriteNormInstrGeo(cmd)
    ;Norm instrument geometry file name
    self.NormInstrGeoFileName      = getNormInstrumentGeoFileName(cmd)
    ;output path
    self.OutputPath                = getOutputPath(cmd)
    ;output file name
    self.OutputFileName            = class_getOutputFileName(cmd)
    ;;Intermediate File Flags
    self.DataNormCombinedSpecFlag  = isWithDataNormCombinedSpec(cmd)
    self.DataNormCombinedBackFlag  = isWithDataNormCombinedBack(cmd)
    self.DataNormCombinedSubFlag   = isWithDataNormCombinedSub(cmd)
    self.RvsTOFFlag                = isWithRvsTOF(cmd)
    self.RvsTOFcombinedFlag        = isWithRvsTOFcombined(cmd)
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
    
    TOFcuttingMin             : '',$
    TOFcuttingMax             : '',$
    
    MainNormNexusFileName     : '',$
    MainNormRunNumber         : '',$
    AllNormNexusFileName      : '',$
    NormRoiFileName           : '',$
    NormPeakExclYArray        : ['',''],$
    
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
