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

FUNCTION ReplaceExt, file_array, NEW=new

;file_array = *file_array

sz = N_ELEMENTS(file_array)
IF (sz GT 0) THEN BEGIN
    new_file_array = STRARR(sz)
    index = 0
    WHILE (index LT sz) DO BEGIN
;get only the short file name
        short_fn_array = STRSPLIT(file_array[index],'/',/EXTRACT, COUNT=nbr)
        IF (nbr GE 1) THEN BEGIN
            file_array[index] = short_fn_array[nbr-1]
        ENDIF ELSE BEGIN
            file_array[index] = short_fn_array[0]
        ENDELSE
        no_error = 0
        CATCH, no_error
        IF (no_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            new_file_array[index] = file_array[index] + '.' + new
        ENDIF ELSE BEGIN
            local_file_array = STRSPLIT(file_array[index],'.',/EXTRACT)
            new_file_array[index] = local_file_array[0] + '.' + new
            index++
        ENDELSE
    ENDWHILE
ENDIF
RETURN, new_file_array
END


FUNCTION IDLcreateLogFile::getListOfStdOutFiles
RETURN, self.file_name_array_out
END

;==============================================================================
FUNCTION IDLcreateLogFile::getListOfStdErrFiles
RETURN, self.file_name_array_err
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLcreateLogFile::init, Event, cmd
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;define current date
DateTime = GenerateIsoTimeStamp()

;retrieve name of all output files
nbr_jobs = N_ELEMENTS(cmd)
file_name_array = STRARR(nbr_jobs)
index = 0
WHILE (index LT nbr_jobs) DO BEGIN
   match1 = STREGEX(cmd[index],' --output=.*',/EXTRACT)
   match2 = STRSPLIT(match1,'=',/EXTRACT)
   file_name_array[index++] = STRCOMPRESS(match2[1],/REMOVE_ALL)
ENDWHILE

;create array of .err and .out files names
file_name_array_out = ReplaceExt(file_name_array, NEW='out')
file_name_array_err = ReplaceExt(file_name_array, NEW='err')

;force the location and name of .err and .out files
output_path = (*global).default_output_path
CD, '~', CURRENT=current_path
expand_path = FILE_EXPAND_PATH('~/results/')
CD, current_path
;;; remove ~/ from expand_path
expand_path = remove_tilda(expand_path)
;;; add expand_path to list of std out and err files
ListOfStdOutFiles = expand_path + file_name_array_out 
self.file_name_array_out = PTR_NEW(ListOfStdOutFiles)
shortListOfStdOutFiles = getBaseFileName(ListOfStdOutFiles)
ListOfStdErrFiles = expand_path + file_name_array_err
self.file_name_array_err = PTR_NEW(ListOfStdErrFiles)
shortListOfStdErrFiles = getBaseFileName(ListOfStdErrFiles)

;create string array of all information from this/these job(s) ----------------
nbr_structure_tags = N_TAGS(sReduce) 
final_array_size = 4 + Nbr_jobs + nbr_structure_tags
;Date 1
;start and end list of output files 3
;list of output files nbr_jobs
;number of metadata nbr_structure_tags
;'' 1

final_array = STRARR(final_array_size)

;write date -------------------------------------------------------------------
final_array[0] = 'Date: ' + DateTime
i = 0
final_array[1] = '***** Start List of Output Files *****'
offset = 2
WHILE (i LT nbr_jobs) DO BEGIN
    text  = 'Output File: ' + file_name_array[i]
    text += ' | Stderr File: ' + shortListOfStdErrFiles[i]
    text += ' | Stdout File: ' + shortListOfStdOutFiles[i]
    final_array[i+offset] = text
    i++
ENDWHILE
i+=offset
final_array[i++] = '***** End List of Output Files *****'

offset = i
FOR j=0,(nbr_structure_tags-1) DO BEGIN
   title = sReduce.(j).title
   value = sReduce.(j).value
   final_array[j+offset] = title + ': ' + value
ENDFOR

;check if config file already exists or not -----------------------------------
config_file_name = (*global).config_file_name

IF (FILE_TEST(config_file_name)) THEN BEGIN ;file already exists
;We gonna have to append the file from the top
    current_config_file_size = FILE_LINES(config_file_name)
    IF (current_config_file_size GT 20) THEN BEGIN
        current_config_file_array = STRARR(current_config_file_size)
        OPENR, 1, config_file_name
        READF, 1, current_config_file_array
        CLOSE, 1
        final_array = [final_array, current_config_file_array]
    ENDIF
ENDIF 

OPENW, 1, config_file_name
FOR i=0,(N_ELEMENTS(final_array)-1) DO BEGIN
    PRINTF, 1, final_array[i]
ENDFOR
CLOSE, 1
FREE_LUN, 1

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLcreateLogFile__define
struct = {IDLcreateLogFile,$
          file_name_array_out: PTR_NEW(0L),$
          file_name_array_err: PTR_NEW(0L),$
          var: ''}
END
;******************************************************************************
;******************************************************************************
