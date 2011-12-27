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
   
  ;find first if string is there or not
  _match = strmatch(base_string,'*'+arg1+'*')
  if (~_match) then return, ''

  Split1 = STRSPLIT(base_string,arg1,/EXTRACT,/REGEX,COUNT=length)
  IF (length GT 1) THEN BEGIN
    Split2 = STRSPLIT(Split1[arg1Index],arg2,/EXTRACT,/REGEX)
    RETURN, Split2[arg2Index]
  ENDIF ELSE BEGIN
    if (length eq 1) then begin
      split2 = strsplit(split1[0],arg2, /extract, /regex)
      return, split2[0]
    endif else begin
    RETURN, ''
  ENDELSE
  endelse
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
FUNCTION getMainDataNexusFileName, cmd
  print, 'cmd: ' , cmd
  result = ValueBetweenArg1Arg2(cmd, 'specmh_reduction', 1, ' ', 0)
  print, 'in getMainDataNexusfileName'
  print, result
  help, result
  IF (result EQ '') then begin
    result = ValueBetweenArg1Arg2(cmd, 'reflect_reduction', 1, ' ', 0)
    if (result eq '') then return, ''
    return, strcompress(result,/remove_all)
  endif else begin
    RETURN, STRCOMPRESS(result,/REMOVE_ALL)
  endelse
END

;------------------------------------------------------------------------------
FUNCTION getMainDataRunNumber_ref, FullNexusName, instrument=instrument
  if (n_elements(instrument) ne 0) then begin
    run_number = get_ref_run_number(FullNexusName, instrument=instrument)
    print, 'run_number: ' , run_number
  endif else begin
    run_number = get_ref_run_number(FullNexusName, instrument='REF_L')
  endelse
  RETURN, strcompress(run_number,/remove_all)
END

;------------------------------------------------------------------------------
FUNCTION getAllDataNexusFileName, cmd
  result = ValueBetweenArg1Arg2(cmd, $
    'specmh_reduction ',$
    1, $
    '--data-paths', $
    0)
  IF (result EQ '') THEN begin
    result = ValueBetweenArg1Arg2(cmd, $
    'reflect_reduction ',$
    1, $
    '--data-paths', $
    0)
  if (result eq '') then RETURN, ''
  return, result
  endif else begin
  RETURN, result
  endelse
END

;------------------------------------------------------------------------------
function getDataPath, cmd
  result = ValueBetweenArg1Arg2(cmd, '--data-paths=', 1, ' ', 0)
  if (result EQ '') THEN RETURN, ''
  if (result ne '') then begin
    parse_result = strsplit(result[0],'/',/extract)
    parse_result2 = strsplit(parse_result[0],'-',/extract)
  endif
  return, strcompress(parse_result2[1],/remove_all)
end

;------------------------------------------------------------------------------
FUNCTION getDataRoiFileName, cmd
  result = ValueBetweenArg1Arg2(cmd, '--data-roi-file=', 1, ' ', 0)
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
    '--norm-data-paths=',$
    0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
function getNormPath, cmd
  result = ValueBetweenArg1Arg2(cmd, '--norm-data-paths=', 1, ' ', 0)
  if (result EQ '') THEN RETURN, getDataPath(cmd)
  if (result ne '') then begin
    parse_result = strsplit(result[0],'/',/extract)
    parse_result2 = strsplit(parse_result[0],'-',/extract)
  endif
  return, strcompress(parse_result2[1],/remove_all)
end

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
FUNCTION getEmptyCellFileName, cmd
  result = ValueBetweenArg1Arg2(cmd, '--ecell=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getEmptyCellRunNumber, fullNexusName
  inst = obj_new('IDLgetMetadata',FullNexusName)
  RunNumber = inst->getRunNumber()
  OBJ_DESTROY, inst
  RETURN, STRCOMPRESS(RunNumber,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getEmptyCellAB, cmd
  part2 = ValueAfterArg1(cmd, '--subtrans-coeff=')
  IF (part2 NE '') THEN BEGIN
    split = STRSPLIT(part2[0],' ',/EXTRACT)
    A = split[0]
    B = split[1]
    RETURN, [A,B]
  ENDIF ElSE BEGIN
    RETURN, ['','']
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getEmptyCellC, cmd
  result = ValueBetweenArg1Arg2(cmd, '--scale-ecell=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getEmptyCellD, cmd
  result = ValueBetweenArg1Arg2(cmd, '--substrate-diam=', 1, ' ', 0)
  IF (result EQ '') THEN RETURN, ''
  RETURN, STRCOMPRESS(result,/REMOVE_ALL)
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
FUNCTION getSAngleValue, nexus_full_path

  error_file = 0
  CATCH, error_file
  IF (error_file NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
  ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
  ENDELSE
  
  sangle_path = '/entry-Off_Off/sample/SANGLE/value'
  
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    h5f_close, fileID
    RETURN, ''
  ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID, sangle_path)
    sangle = h5d_read(pathID)
    h5d_close, pathID
    RETURN, sangle
  endelse
  
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
function IDLparseCommandLine_ref_m::getCmd
  return, self.cmd
end

FUNCTION IDLparseCommandLine_ref_m::getMainDataNexusFileName
  RETURN, self.MainDataNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getMainDataRunNumber
  RETURN, self.MainDataRunNumber
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getAllDAtaNexusFileName
  RETURN, self.AllDataNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataPath
  RETURN, self.DataPath
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataRoiFileName
  RETURN, self.DataRoiFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataPeakExclYArray
  RETURN, self.DataPeakExclYArray
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataBackFileName
  RETURN, self.DataBackFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getTOFcuttingMin
  RETURN, self.TOFcuttingMin
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getTOFcuttingMax
  RETURN, self.TOFcuttingMax
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getMainNormNexusFileName
  RETURN, self.MainNormNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getMainNormRunNumber
  RETURN, self.MainNormRunNumber
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getAllNormNexusFileName
  RETURN, self.AllNormNexusFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getNormPath
  RETURN, self.NormPath
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getNormRoiFileName
  RETURN, self.NormRoiFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getNormPeakExclYArray
  RETURN, self.NormPeakExclYArray
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getNormBackFileName
  RETURN, self.NormBackFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getEmptyCellNexusFileName
  RETURN, self.EmptyCellFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getEmptyCellRunNumber
  RETURN, self.EmptyCellRunNumber
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getEmptyCellA
  RETURN, self.EmptyCellA
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getEmptyCellB
  RETURN, self.EmptyCellB
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getEmptyCellC
  RETURN, self.EmptyCellC
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getEmptyCellD
  RETURN, self.EmptyCellD
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getEmptyCellReduceFlag
  RETURN, self.EmptyCellReduceFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataBackgroundFlag
  RETURN, self.DataBackgroundFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getNormBackgroundFlag
  RETURN, self.NormBackgroundFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getQmin
  RETURN, self.Qmin
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getQmax
  RETURN, self.Qmax
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getQwidth
  RETURN, self.Qwidth
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getQtype
  RETURN, self.Qtype
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getSangleValue
  RETURN, self.SangleValue
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getAngleError
  RETURN, self.AngleError
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getAngleUnits
  RETURN, self.AngleUnits
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getFilteringDataFlag
  RETURN, self.FilteringDataFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDeltaTOverTFlag
  RETURN, self.DeltaTOverT
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getOverwriteDataInstrGeoFlag
  RETURN, self.OverwriteDataInstrGeo
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataInstrGeoFileName
  RETURN, self.DataInstrGeoFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getOverwriteNormInstrGeoFlag
  RETURN, self.OverwriteNormInstrGeo
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getNormInstrGeoFileName
  RETURN, self.NormInstrGeoFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getOutputPath
  RETURN, self.OutputPath
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getOutputFileName
  RETURN, self.OutputFileName
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataNormCombinedSpecFlag
  RETURN, self.DataNormCombinedSpecFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataNormCombinedBackFlag
  RETURN, self.DataNormCombinedBackFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getDataNormCombinedSubFlag
  RETURN, self.DataNormCombinedSubFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getRvsTOFFlag
  RETURN, self.RvsTOFFlag
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLparseCommandLine_ref_m::getRvsTOFcombinedFlag
  RETURN, self.RvsTOFcombinedFlag
END

;##############################################################################
;******  Class constructor ****************************************************
FUNCTION IDLparseCommandLine_ref_m::init, cmd_array

  general_error = 0
  ;CATCH, general_error
  IF (general_error NE 0) THEN BEGIN
    catch,/cancel
    RETURN, 0
  ENDIF ELSE BEGIN
  
    nbr_cmd = n_elements(cmd_array)
    index_nbr_cmd = 0
    first_non_empty_cmd = 1b
    while (index_nbr_cmd lt nbr_cmd) do begin
    
      ;check if the cmd is empty (means did it work)
      cmd = cmd_array[index_nbr_cmd]
      if (cmd ne '') then begin ;cmd ran with success
      
        if (first_non_empty_cmd eq 1b) then begin
        
          self.cmd = cmd
          
          ;Work on Data
          self.MainDataNexusFileName  = getMainDataNexusFileName(cmd)
          IF (self.MainDataNexusFileName NE '') THEN BEGIN
            self.MainDataRunNumber      = $
              getMainDataRunNumber_ref(self.MainDataNexusFileName, $
              instrument='REF_M')
          ENDIF ELSE BEGIN
            self.MainDataRunNumber  = ''
          ENDELSE
          
          self.AllDataNexusFileName   = getAllDataNexusFileName(cmd)
          self.DataPath               = getDataPath(cmd)
          self.DataRoiFileName        = getDataRoiFileName(cmd)
          self.DataPeakExclYArray     = getDataPeakExclYArray(cmd)
          self.DataBackFileName       = getDataBackFileName(cmd)
          self.TOFcuttingMin          = getTOFcuttingMin(cmd)
          self.TOFcuttingMax          = getTOFcuttingMax(cmd)
          
          ;Work on Normalization
          self.MainNormNexusFileName = getMainNormNexusFileName(cmd)
          print, 'self.MainNormNexusfileName: ' , self.MainNormNexusFileName


          IF (self.MainNormNexusFileName NE '') THEN BEGIN
            self.MainNormRunNUmber     = $
              getMainDataRunNumber_ref(self.MainNormNexusFileName, $
              instrument='REF_M')
            self.AllNormNexusFileName  = getAllNormNexusFileName(cmd)
            self.NormPath              = getNormPath(cmd)
            self.NormRoiFileName       = getNormRoiFileName(cmd)
            self.NormPeakExclYArray    = getNormPeakExclYArray(cmd)
            self.NormBackFileName      = getNormBackFileName(cmd)
          ENDIF ELSE BEGIN
            self.MainNormRunNumber = ''
            self.AllNormNexusFileName  = ''
            self.NormPath              = ''
            self.NormRoiFileName       = ''
            self.NormPeakExclYArray    = ''
            self.NormBackFileName      = ''
          ENDELSE
          
          ;Work on Emtpy Cell
          self.EmptyCellFileName = getEmptyCellFileName(cmd)
          IF (self.EmptyCellFileName NE '') THEN BEGIN
            self.EmptyCellRunNumber = $
              getEmptyCellRunNumber(self.EmptyCellFileName)
            AB = getEmptyCellAB(cmd)
            self.EmptyCellA = STRCOMPRESS(AB[0],/REMOVE_ALL)
            self.EmptyCellB = STRCOMPRESS(AB[1],/REMOVE_ALL)
            self.EmptyCellC = getEmptyCellC(cmd)
            self.EmptyCellD = getEmptyCellD(cmd)
            self.EmptyCellReduceFlag = 'yes'
          ENDIF
          
          ;;Reduce Tab
          ;Background flags
          self.DataBackgroundFlag        = isWithDataBackgroundFlagOn(cmd)
          self.NormBackgroundFlag        = isWithNormBackgroundFlagOn(cmd)
          
          ;          ;Q [Qmin,Qmax,Qwidth,linear/log]
          ;          self.Qmin                      = getQmin(cmd)
          ;          self.Qmax                      = getQmax(cmd)
          ;          self.Qwidth                    = getQwidth(cmd)
          ;          self.Qtype                     = getQtype(cmd)
          
          ;Angle Offset
          self.SangleValue                = getSangleValue(cmd)
          ;self.AngleError                = getAngleError(cmd)
          ;self.AngleUnits                = getAngleUnits(cmd)
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
          
          first_non_empty_cmd = 0b
        endif else begin
        
          data_path              = getDataPath(cmd)
          self.DataPath += '/' + data_path
          if (self.MainNormRunNumber ne '') then begin
            norm_path              = getNormPath(cmd)
            self.NormPath += '/' + norm_path
          endif
          self.cmd += ' ; ' + cmd
          
        endelse
        
      endif
      
      index_nbr_cmd++
    endwhile
    
  endelse
  return,1
end

;******************************************************************************
;****** Class Define **********************************************************
PRO IDLparseCommandLine_ref_m__define
  STRUCT = {IDLparseCommandLine_ref_m,$
  
    cmd                       : '',$
    
    MainDataNexusFileName     : '',$
    MainDataRunNumber         : '',$
    AllDataNexusFileName      : '',$
    DataPath                  : '',$
    DataRoiFileName           : '',$
    DataPeakExclYArray        : ['',''],$
    DataBackFileName          : '',$
    
    TOFcuttingMin             : '',$
    TOFcuttingMax             : '',$
    
    MainNormNexusFileName     : '',$
    MainNormRunNumber         : '',$
    AllNormNexusFileName      : '',$
    NormPath                  : '',$
    NormRoiFileName           : '',$
    NormPeakExclYArray        : ['',''],$
    NormBackFileName          : '',$
    
    EmptyCellFileName         : '',$
    EmptyCellRunNumber        : '',$
    EmptyCellA                : '',$
    EmptyCellB                : '',$
    EmptyCellD                : '',$
    EmptyCellC                : '',$
    EmptyCellReduceFlag       : 'no',$
    
    DataBackgroundFlag        : 'yes',$
    NormBackgroundFlag        : 'yes',$
    ;    Qmin                      : '',$
    ;    Qmax                      : '',$
    ;    Qwidth                    : '',$
    ;    Qtype                     : '',$
    SangleValue                : '',$
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
