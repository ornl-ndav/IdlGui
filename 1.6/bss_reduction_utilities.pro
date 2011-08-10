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

FUNCTION getBaseFileName, file_name_array
sz                  = N_ELEMENTS(file_name_array)
new_file_name_array = STRARR(sz)
index = 0
WHILE (index LT sz) DO BEGIN
    new_file_name_array[index] = FILE_BASENAME(file_name_array[index])
index++
ENDWHILE
RETURN, new_file_name_array
END

;------------------------------------------------------------------------------
FUNCTION remove_tilda, expand_path
split_array = STRSPLIT(expand_path,'/',/EXTRACT,COUNT=nbr)
index_array = WHERE(STRCOMPRESS(split_array,/REMOVE_ALL) EQ '~')
IF (index_array[0] NE -1) THEN BEGIN
    index = 0
    expand_path = '/'
    WHILE (index LT nbr) DO BEGIN
        IF (index NE index_array[0]) THEN BEGIN
            expand_path += split_array[index] + '/'
        ENDIF
        index++
    ENDWHILE
ENDIF
RETURN, expand_path
END

;------------------------------------------------------------------------------
FUNCTION ConvertListToInt, list
list_size = (size(list))(1)
j=0
FOR i=0,(list_size-1) DO BEGIN

    ON_IOERROR, L1     ;in case one of the variable can't be converted
    val = Fix(list[i])

    IF (j EQ 0) THEN BEGIN
        FinalList = [val]
        j++
    ENDIF ELSE BEGIN
        FinalList = [FinalList, val]
    ENDELSE

    L1: continue

ENDFOR
RETURN, FinalList
END

;------------------------------------------------------------------------------
