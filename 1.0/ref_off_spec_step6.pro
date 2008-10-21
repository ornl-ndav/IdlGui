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
FUNCTION determine_other_pola_states, Event
working_pola_state = getTextFieldValue(Event,'summary_working_polar_value')
working_pola_state = STRCOMPRESS(working_pola_state,/REMOVE_ALL)
CASE (working_pola_state) OF
    'p0': RETURN, ['p1','p2','p3']
    'p1': RETURN, ['p0','p2','p3']
    'p2': RETURN, ['p0','p1','p3']
    'p3': RETURN, ['p0','p1','p2']
    ELSE: RETURN, ['','','']
ENDCASE
END

;------------------------------------------------------------------------------
;This function keeps only the file base name of the list of file given
FUNCTION determine_short_list_OF_ascii_files, long_list_OF_files
sz = N_ELEMENTS(long_list_OF_files)
short_list_OF_files = STRARR(sz)
index = 0
WHILE (index LT sz) DO BEGIN
    IF (long_list_OF_files[index] NE 'N/A') THEN BEGIN
        short_list_OF_files[index] = FILE_BASENAME(long_list_OF_files[index])
    ENDIF ELSE BEGIN
        short_list_OF_files[index] = 'N/A'
    ENDELSE
    ++index
ENDWHILE
RETURN, short_list_OF_files
END

;------------------------------------------------------------------------------
PRO populate_array, TableArray, List, COLUMN=column
sz = N_ELEMENTS(list)
index = 0
IF (STRCOMPRESS(List[index],/REMOVE_ALL) NE '0') THEN BEGIN
    WHILE (index LT sz) DO BEGIN
        TableArray[COLUMN,index] = STRCOMPRESS(List[index],/REMOVE_ALL)
        ++index
    ENDWHILE
ENDIF
END

;------------------------------------------------------------------------------
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
;put file name (short) into summary output file name
putTextfieldValue, Event, 'summary_output_file_name_value', file_name
END

;------------------------------------------------------------------------------
;This procedure is reached when the user click to define the output
;file path
PRO OutputFilePathButton, Event
;get path (label of this button)
path = getTextFieldValue(Event,'create_output_file_path_button')
new_path = DIALOG_PICKFILE(/DIRECTORY,$
                           PATH     = path,$
                           GET_PATH = new_path,$
                           /MUST_EXIST)

IF (new_path NE '') THEN BEGIN
    putTextFieldValue, Event, 'create_output_file_path_button', new_path
    RefreshOutputFileName, Event
ENDIF
END

;------------------------------------------------------------------------------
PRO PopulateWorkingFileTable, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
TableArray = STRARR(3,6)
;get list of files
ShortFileNameList = (*(*global).short_list_OF_ascii_files)
populate_array, TableArray, ShortFileNameList, COLUMN=0
;get shifting parameters found
ref_pixel_offset_list = (*(*global).ref_pixel_offset_list)
populate_array, TableArray, ref_pixel_offset_list, COLUMN=1
;get scaling paremeters found
scaling_factor = (*(*global).scaling_factor)
populate_array, TableArray, scaling_factor, COLUMN=2
;repopulate working file table
putValueInTable, Event, 'output_file_summary_table', TableArray
END

;------------------------------------------------------------------------------
PRO PopulateWorkingFileFields, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
list_OF_ascii_files = (*(*global).list_OF_ascii_files)
file0 = list_OF_ascii_files[0]
IF (file0 NE '') THEN BEGIN
    path = FILE_DIRNAME(file0,/MARK_DIRECTORY)
ENDIF ELSE BEGIN
    path = 'N/A'
ENDELSE
putTextFieldValue,Event,'summary_input_path_name_value',path
;determine the polarization state used according to name of input file
IF (file0 NE '') THEN BEGIN
    polarization_state = getPolarizationState(file0)
ENDIF ELSE BEGIN
    polarization_state = 'N/A'
ENDELSE
(*global).working_pola_state = polarization_state
putTextFieldValue, Event,'summary_working_polar_value', polarization_state
END

;------------------------------------------------------------------------------
PRO populateTableArray, Event, $
                        working_array, $
                        short_list_OF_files, $
                        POLA_STATE=pola_state
temp_array = working_array
sz = N_ELEMENTS(short_list_OF_files)
i = 0
WHILE (i LT sz) DO BEGIN
    temp_array[0,i] = short_list_OF_files[i]
    ++i
ENDWHILE

CASE (POLA_STATE) OF
    'p#2': uname = 'polarization_state2_summary_table'
    'p#3': uname = 'polarization_state3_summary_table'
    'p#4': uname = 'polarization_state4_summary_table'
ENDCASE
putValueInTable, Event, uname, temp_array
END

;------------------------------------------------------------------------------
PRO PopulateOtherPolaStates, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
other_pola_states = determine_other_pola_states(Event)
uname_list        = ['summary_polar2_value',$
                     'summary_polar3_value',$
                     'summary_polar4_value']
FOR i=0,2 DO BEGIN
    putTextFieldValue, Event, uname_list[i], other_pola_states[i]
ENDFOR
;determine list of files for other polarization states
list_OF_files = (*(*global).list_OF_ascii_files)
sz = N_ELEMENTS(list_OF_files)
list_OF_ascii_files_p1 = STRARR(sz)
list_OF_ascii_files_p2 = STRARR(sz)
list_OF_ascii_files_p3 = STRARR(sz)
IF (list_OF_files[0] NE '') THEN BEGIN
    working_pola_state = (*global).working_pola_state
    i = 0
    WHILE (i LT sz) DO BEGIN
        split_array = STRSPLIT(list_OF_files[i], $
                               working_pola_state, $
                               /EXTRACT,$
                               /REGEX,$
                               COUNT=nbr)
        IF (nbr GT 1) THEN BEGIN
            list_OF_ascii_files_p1[i] = split_array[0]+$
              other_pola_states[0] + split_array[1]
            list_OF_ascii_files_p2[i] = split_array[0]+$
              other_pola_states[1] + split_array[1]
            list_OF_ascii_files_p3[i] = split_array[0]+$
              other_pola_states[2] + split_array[1]
        ENDIF ELSE BEGIN
            list_OF_ascii_files_p1[i] = 'N/A'
            list_OF_ascii_files_p2[i] = 'N/A'
            list_OF_ascii_files_p3[i] = 'N/A'
        ENDELSE
        ++i
    ENDWHILE
ENDIF
(*(*global).list_OF_ascii_files_p1) = list_OF_ascii_files_p1
(*(*global).list_OF_ascii_files_p2) = list_OF_ascii_files_p2
(*(*global).list_OF_ascii_files_p3) = list_OF_ascii_files_p3
;get short list of ascii files
short_list_OF_ascii_files_p1 = $
  determine_short_list_OF_ascii_files(list_OF_ascii_files_p1)
short_list_OF_ascii_files_p2 = $
  determine_short_list_OF_ascii_files(list_OF_ascii_files_p2)
short_list_OF_ascii_files_p3 = $
  determine_short_list_OF_ascii_files(list_OF_ascii_files_p3)
;populate table of the various polarization state
working_table_array = getTableValue(Event,'output_file_summary_table')
populateTableArray, Event, $
  working_table_array, $
  short_list_OF_ascii_files_p1, $
  POLA_STATE='p#2'
populateTableArray, Event, $
  working_table_array,$
  short_list_OF_ascii_files_p2, $
  POLA_STATE='p#3'
populateTableArray, Event, $
  working_table_array,$
  short_list_OF_ascii_files_p3, $
  POLA_STATE='p#4'
END

;------------------------------------------------------------------------------
PRO UpdateStep6Gui, Event
;refresh the name of the default output file name
RefreshOutputFileName, Event
;refresh the list of files loaded and parameters determined
PopulateWorkingFileTable, Event
;refresh the other paremeters of the working files frame
PopulateWorkingFileFields, Event
;work on other polarization states -------
;determine other polarization states
PopulateOtherPolaStates, Event



END


