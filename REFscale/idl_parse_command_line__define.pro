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

;******************************************************************************
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION idl_parse_command_line::getOutputPath
RETURN, self.OutputPath
END

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION idl_parse_command_line::getOutputFileName
RETURN, self.OutputFileName
END

;##############################################################################
;******  Class constructor ****************************************************
FUNCTION idl_parse_command_line::init, cmd
general_error = 0
CATCH, general_error 
IF (general_error NE 0) THEN BEGIN
    RETURN, 0
ENDIF ELSE BEGIN
;output path
    self.OutputPath                = getOutputPath(cmd)
;output file name
    self.OutputFileName            = class_getOutputFileName(cmd)
ENDELSE
RETURN, 1
END

;******************************************************************************
;****** Class Define **********************************************************
PRO idl_parse_command_line__define
STRUCT = {idl_parse_command_line,$
          OutputPath                : '',$
          OutputFileName            : ''}
END
;******************************************************************************
;******************************************************************************
