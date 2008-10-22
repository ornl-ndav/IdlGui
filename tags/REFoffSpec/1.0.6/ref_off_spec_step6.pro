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
WIDGET_CONTROL, Event.top, GET_UVALUE=global
first_file_loaded = list_OF_files[0]
;get path
path = FILE_DIRNAME(first_file_loaded,/MARK_DIRECTORY)
putTextFieldValue, Event, 'create_output_file_path_button', path
;get short file name
short_file_name = FILE_BASENAME(first_file_loaded,'.txt')
time_stamp = GenerateIsoTimeStamp()
(*global).time_stamp = time_stamp
short_file_name += '_' + time_stamp
short_file_name += '_scaling.txt'
putTextFieldValue, Event, 'create_output_file_name_text_field', $
  short_file_name
END

;------------------------------------------------------------------------------
;this also defined the default output file name
PRO CreateDefaultOutputFileNameForOtherStates, Event, $
                                               base_file_name, $
                                               uname
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get short file name
short_file_name = FILE_BASENAME(base_file_name,'.txt')
time_stamp      = (*global).time_stamp
short_file_name += '_' + time_stamp
short_file_name += '_scaling.txt'
IF (time_stamp EQ '') THEN BEGIN
    short_file_name = ''
ENDIF
putTextFieldValue, Event, uname, short_file_name
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

;populate output file name for each polarization state
CreateDefaultOutputFileNameForOtherStates, Event, $
  short_list_OF_ascii_files_p1[0],$
  'pola2_output_file_name_value'
CreateDefaultOutputFileNameForOtherStates, Event, $
  short_list_OF_ascii_files_p2[0],$
  'pola3_output_file_name_value'
CreateDefaultOutputFileNameForOtherStates, Event, $
  short_list_OF_ascii_files_p3[0],$
  'pola4_output_file_name_value'
END

;------------------------------------------------------------------------------
PRO CheckValidationOfCreateOutputButton, Event
working_table = getTableValue(Event,'output_file_summary_table')
IF (working_table[0,0] NE '') THEN BEGIN
    validate_status = 1
ENDIF ELSE BEGIN
    validate_status = 0
ENDELSE
activate_widget, Event,'create_output_file_create_button',validate_status
END

;------------------------------------------------------------------------------
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
;check if we can validate or not the CREATE OUTPUT FILE button
CheckValidationOfCreateOutputButton, Event
END

;------------------------------------------------------------------------------
PRO create_output_file, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;create the final array
create_final_array, Event
;write out final array
create_output_array, Event


END


;------------------------------------------------------------------------------
PRO create_final_array, Event, final_array, final_error_array
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

nbr_plot             = getNbrFiles(Event) ;number of files
scaling_factor_array = (*(*global).scaling_factor)
tfpData              = (*(*global).realign_pData_y)
tfpData_error        = (*(*global).realign_pData_y_error)

index      = 0                ;loop variable (nbr of array to add/plot
WHILE (index LT nbr_plot) DO BEGIN
    
    local_tfpData       = *tfpData[index]
    local_tfpData_error = *tfpData_error[index]
    scaling_factor      = scaling_factor_array[index]
    
;get only the central part of the data (when it's not the first one)
    IF (index NE 0) THEN BEGIN
        local_tfpData      = local_tfpData[*,304L:2*304L-1]
        local_tfpData_eror = local_tfpData_error[*,304L:2*304L-1] 
    ENDIF
    
;applied scaling factor
    local_tfpData       /= scaling_factor
    local_tfpData_error /= scaling_factor
    
    IF (index EQ 0) THEN BEGIN
;array that will serve as the background 
        base_array       = local_tfpData
        base_error_array = local_tfpData_error
        size             = (size(total_array,/DIMENSIONS))[0]
    ENDIF ELSE BEGIN
        index_no_null = WHERE(local_tfpData NE 0,nbr)
        IF (nbr NE 0) THEN BEGIN
            index_indices = ARRAY_INDICES(local_tfpData,index_no_null)
            sz = (size(index_indices,/DIMENSION))[1]
;loop through all the not null values and add them to the background
;array if their value is greater than the background one
            i = 0L
            WHILE(i LT sz) DO BEGIN
                x = index_indices[0,i]
                y = index_indices[1,i]
                value_new       = local_tfpData(x,y)
                value_old = base_array(x,y)
                IF (value_new GT value_old) THEN BEGIN
                    base_array(x,y)       = value_new
                    base_error_array(x,y) = local_tfpData_error(x,y)
                ENDIF
                ++i
            ENDWHILE
        ENDIF
    ENDELSE
    
    ++index
    
ENDWHILE

;final_array is base_array
final_array       = base_array
final_error_array = base_error_array
END

;------------------------------------------------------------------------------
PRO create_output_array, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

LogMessage = '> Working on Initial Polarization State'
putMessageInCreateStatus, Event, LogMessage

LogMessage = '    Create output data (shifting/scaling) ... ' + PROCESSING 
addMessageInCreateStatus, Event, LogMessage

activate_status_pola1 = 0
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
ENDIF ELSE BEGIN
;retrieve x-axis
    xaxis = (*(*global).x_axis)
;get final array
    create_final_array, Event, final_array, final_error_array
    ReplaceTextInCreateStatus, Event, PROCESSING, OK

    LogMessage = '    Write data to file ...................... ' + PROCESSING
    addMessageInCreateStatus, Event, LogMessage

    error1 = 0
    CATCH, error1
    IF (error1 NE 0) THEN BEGIN
        CATCH,/CANCEL
        ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
    ENDIF ELSE BEGIN
        nbr_x = DOUBLE(N_ELEMENTS(xaxis)) ;nbr of tof
        nbr_y = DOUBLE((size(final_array))(2)) ;nbr of pixels
        
        index = 0L
        output_strarray = STRARR(DOUBLE(2+DOUBLE(nbr_y)*DOUBLE((nbr_x+4))))
        output_strarray[index++] = $
          '#F Scaling Data File created with REFoffSpec'
        
        FOR i=0,(nbr_y-1) DO BEGIN
            output_strarray[index++] = ''
            output_strarray[index++] = "#S 1 Spectrum ID ('bank1', (" + $
              STRCOMPRESS(i,/REMOVE_ALL) + $
              ", 127))"
            output_strarray[index++] = '#N 3'
            output_strarray[index++] = "#L lambda_T(Angstroms)  " + $
              "Intensity(Counts/A)  Sigma(Counts/A)"
            FOR j=0,(nbr_x-1) DO BEGIN
                text = STRCOMPRESS(xaxis[j],/REMOVE_ALL)
                text += '   ' + STRCOMPRESS(final_array[j,i],/REMOVE_ALL)
                text += '   ' + STRCOMPRESS(final_error_array[j,i],/REMOVE_ALL)
                output_strarray[index++] = text
            ENDFOR
        ENDFOR
        
;recover name of output file
        full_output_file_name = $
          getTextFieldValue(Event, $
                            'create_output_full_file_name_preview_value')
        
;write output file
;        full_output_file_name = '~/remove_me.txt' ;remove_me
        OPENW, 1, full_output_file_name
        index = 0L
        WHILE (index LT N_ELEMENTS(output_strarray)) DO BEGIN
            PRINTF, 1, output_strarray[index++]
        ENDWHILE
        CLOSE, 1
        FREE_LUN, 1
        
;enable preview button of working pola state
        activate_status_pola1 = 1
        ReplaceTextInCreateStatus, Event, PROCESSING, OK

    ENDELSE
ENDELSE
    
activate_widget, Event, 'step6_preview_pola_state1', activate_status_pola1

LogMessage = ''
addMessageInCreateStatus, Event, LogMessage
LogMessage = '**** Create Output File process .... DONE ****'
addMessageInCreateStatus, Event, LogMessage

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO preview_OF_step6_file, Event, POLA_STATE=pola_state
;get path
path = getTextFieldValue(Event,'create_output_file_path_button')
;get filename
CASE (pola_state) OF
    'p0': uname = 'summary_output_file_name_value'
    'p1': uname = 'pola2_output_file_name_value'
    'p2': uname = 'pola3_output_file_name_value'
    'p3': uname = 'pola4_output_file_name_value'
ENDCASE
file_name = getTextFieldvalue(Event,uname)
full_file_name = path + file_name
XDISPLAYFILE, full_file_name
END

;------------------------------------------------------------------------------

