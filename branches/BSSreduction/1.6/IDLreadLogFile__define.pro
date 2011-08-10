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

;------------------------------------------------------------------------------
FUNCTION IDLreadLogFile::getMetadata
RETURN, self.aMetadata
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLreadLogFile::init, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

AppendLogBookMessage, Event, '--> Entering IDLreadLogFile'

no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
ENDIF ELSE BEGIN
    config_file_name = (*global).config_file_name
    
    AppendLogBookMessage, Event, '--> Config file name: ' + config_file_name

    IF (FILE_TEST(config_file_name)) THEN BEGIN

        AppendLogBookMessage, Event, '---> Checking if file exist ... YES'
        
;read file --------------------------------------------------------------------
        AppendLogBookMessage, Event, '--> Checking size of file:'

        file_size  = FILE_LINES(config_file_name)
        AppendLogBookMessage, Event, '---> Number of lines: ' + $
          STRCOMPRESS(file_size,/REMOVE_ALL)
        IF (file_size LT 10) THEN RETURN, 0
        AppendLogBookMessage, Event, '--> Create file_array ' + $
          '(STARR(file_size)) ... (START)'
        file_array = STRARR(file_size)
        OPENR, 1, config_file_name
        READF, 1, file_array
        CLOSE, 1
        AppendLogBookMessage, Event, '--> Create file_array ' + $
          '(STARR(file_size)) ... (END)'
        
;determine the number of global jobs (result gives where they were ------------
;found!)
        result = WHERE(file_array EQ '', nbr_input)
        
        start_point = WHERE(file_array EQ $
                            '***** Start List of Output Files *****',count)
        end_point   = WHERE(file_array EQ $
                            '***** End List of Output Files *****')
        
;start and end points for the metadata
        start_point_metadata = end_point
        end_point_metadata   = result
        
;populate the structure -------------------------------------------------------
        
; sStructure = { info, date:'', files:PTR_NEW(0L)}
; mStructure = REPLICATE({info}, nbr_empty_space+1)
;-----------------------------------------------------
; mStructure[0].date = '200811m10_125147'
; *mStructure[0].files = ['~/results/BSS_0_Q00.txt',$
;                         '~/results/BSS_0_Q01.txt']
;-----------------------------------------------------
        sInfo = { info, $
                  date:      '', $
                  files:     PTR_NEW(),$
                  out_files: PTR_NEW(),$
                  err_files: PTR_NEW()}
        sLocalInfo = REPLICATE({info}, count)
        
;create big array aMetadata = STRARR(nbr of metadata, nbr folder + 1)
;+1: because the first column will be for the NAME of the value
        nbr_metadata = end_point_metadata[0] - start_point_metadata[0]
        aMetadata    = STRARR(count+1,nbr_metadata-1) ;final array of metadata
        
        index = 0
        WHILE (index LT count) DO BEGIN
                    
            AppendLogBookMessage, Event, '--> Working with set of data #' + $
              STRCOMPRESS(index,/REMOVE_ALL) + ':'

;retrieve date
            AppendLogBookMessage, Event, '---> Retrieve Data'
            sLocalInfo[index].date = file_array[start_point[index]-1]
            
;retrieve list of output files
            AppendLogBookMessage, Event, '---> Retrieve List of Output Files'
            str_index = start_point[index]+1
            end_index = end_point[index]
            nbr_files = end_index - str_index
            i = 0
            list_OF_files     = STRARR(nbr_files)
            list_OF_files_err = STRARR(nbr_files)
            list_OF_files_out = STRARR(nbr_files)
            WHILE (i LT nbr_files) DO BEGIN
                list_array = STRSPLIT(file_array[str_index+i],'|',/EXTRACT)
                list_OF_files[i]     = list_array[0]
                list_OF_files_err[i] = list_array[1]
                list_OF_files_out[i] = list_array[2]
                i++
            ENDWHILE
;put list of files into structure
            AppendLogBookMessage, Event, '---> Put list into structure'
            sLocalInfo[index].files = PTR_NEW(list_OF_files)
            sLocalInfo[index].err_files = PTR_NEW(list_OF_files_err)
            sLocalInfo[index].out_files = PTR_NEW(list_OF_files_out)

;retrieve metadata
            AppendLogBookMessage, Event, '---> Retrieve Metadata'
            j = 0
            offset = start_point_metadata[index] + 1
            WHILE (j LT nbr_metadata-1) DO BEGIN
                metadata_array = STRSPLIT(file_array[j+offset],': ', $
                                          /REGEX, $
                                          /EXTRACT)
;keep record of name of field for the first index only
                IF (index EQ 0) THEN BEGIN
                    aMetadata[index,j] = metadata_array[0]
                ENDIF
                aMetadata[index+1,j] = metadata_array[1]
                j++
            ENDWHILE
            
            index++
        ENDWHILE
        
        self.sStructure = PTR_NEW(sLocalInfo)
        self.aMetadata  = PTR_NEW(aMetadata)
        
    ENDIF ELSE BEGIN
        
        AppendLogBookMessage, Event, '---> Checking if file exist ... NO'

    ENDELSE

ENDELSE

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLreadLogFile__define
struct = {IDLreadLogFile,$
          sStructure: PTR_NEW(0L),$
          aMetadata:  PTR_NEW(0L),$
          var: ''}
END
;******************************************************************************
;******************************************************************************
