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

FUNCTION IDLreadLogFile::getStructure
RETURN, self.sStructure
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLreadLogFile::init, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

config_file_name = (*global).config_file_name

IF (FILE_TEST(config_file_name)) THEN BEGIN

;read file --------------------------------------------------------------------
    file_size  = FILE_LINES(config_file_name)
    file_array = STRARR(file_size)
    OPENR, 1, config_file_name
    READF, 1, file_array
    CLOSE, 1

;determine the number of global jobs (result gives where they were ------------
;found!)
    result = WHERE(file_array EQ '', nbr_input)
    
    start_point = WHERE(file_array EQ $
                        '***** Start List of Output Files *****',count)
    end_point   = WHERE(file_array EQ $
                        '***** End List of Output Files *****')
    
;populate the structure -------------------------------------------------------

; sStructure = { info, date:'', files:PTR_NEW(0L)}
; mStructure = REPLICATE({info}, nbr_empty_space+1)
;-----------------------------------------------------
; mStructure[0].date = '200811m10_125147'
; *mStructure[0].files = ['~/results/BSS_0_Q00.txt',$
;                         '~/results/BSS_0_Q01.txt']
;-----------------------------------------------------

    sInfo = { info, $
              date: '', $
              files: PTR_NEW()}
    sLocalInfo = REPLICATE({info}, count)
    
    index = 0
    WHILE (index LT count) DO BEGIN
;retrieve date
        sLocalInfo[index].date = file_array[start_point[index]-1]
;retrieve list of output files
        str_index = start_point[index]+1
        end_index = end_point[index]
        nbr_files = end_index - str_index
        i = 0
        list_OF_files = STRARR(nbr_files)
        WHILE (i LT nbr_files) DO BEGIN
            list_OF_files[i] = file_array[str_index+i]
            i++
        ENDWHILE
;put list of files into structure
        sLocalInfo[index].files = PTR_NEW(list_OF_files)
        index++
    ENDWHILE

    self.sStructure = PTR_NEW(sLocalInfo)

;retrieve list of metadata



ENDIF

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLreadLogFile__define
struct = {IDLreadLogFile,$
          sStructure: ptr_new(0L),$
          var: ''}
END
;******************************************************************************
;******************************************************************************
