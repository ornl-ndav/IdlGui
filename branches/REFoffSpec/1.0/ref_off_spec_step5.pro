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
;this also defined the default output file name
PRO CreateDefaultOutputFileName, Event, list_OF_files ;_output_file

first_file_loaded = list_OF_files[0]
;get path
path = FILE_DIRNAME(first_file_loaded,/MARK_DIRECTORY)
putTextFieldValue, Event, 'create_output_file_path_button', path

;get short file name
short_file_name = FILE_BASENAME(first_file_loaded,'.txt')
time_stamp = GenerateIsoTimeStamp()
short_file_name += '_' + time_stamp
short_file_name += '_scaling.txt'
putTextFieldValue, Event, 'create_output_file_name_text_field', $
  short_file_name

END

;------------------------------------------------------------------------------
;this is triggered each time the CREATE OUTPUT tab is reached
PRO RefreshOutputFileName, Event

;get path
path = getTextFieldValue(Event,'create_output_file_path_button')
;get base name
file_name = getTextFieldValue(Event,'create_output_file_name_text_field')
;create full file name
full_file_name = path + file_name
putTextfieldValue, Event, 'create_output_full_file_name_preview_value',$
  full_file_name

END
