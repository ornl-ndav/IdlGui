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

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;refresh the name of the default output file name
  RefreshOutputFileName, Event
  ;refresh the list of files loaded and parameters determined
  PopulateWorkingFileTable, Event
  ;refresh the other paremeters of the working files frame
  PopulateWorkingFileFields, Event
  ;work on other polarization states -------
  ;determine other polarization states
  IF ((*global).instrument EQ 'REF_M') THEN BEGIN
    PopulateOtherPolaStates, Event
  ENDIF
  
  ;hide spin state base that have not been selected in reduce step1
  
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
      size             = (SIZE(total_array,/DIMENSIONS))[0]
    ENDIF ELSE BEGIN
      index_no_null = WHERE(local_tfpData NE 0,nbr)
      IF (nbr NE 0) THEN BEGIN
        index_indices = ARRAY_INDICES(local_tfpData,index_no_null)
        sz = (SIZE(index_indices,/DIMENSION))[1]
        ;loop through all the not null values and add them to the background
        ;array if their value is greater than the background one
        i = 0L
        WHILE(i LT sz) DO BEGIN
          x = index_indices[0,i]
          y = index_indices[1,i]
          value_new = local_tfpData(x,y)
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
;loop over the three other polarization states
PRO run_full_process_with_other_pola, Event, sStructure
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  pola_state = getTextFieldValue(Event,sStructure.pola_state_uname)
  LogMessage = '> Working on polarization state ' + $
    STRCOMPRESS(pola_state,/REMOVE_ALL)
  addMessageInCreateStatus, Event, LogMessage
  LogMessage = '    Checking list of files .................. ' + PROCESSING
  addMessageInCreateStatus, Event, LogMessage
  ;start recovering the name of the input files
  Table = getTableValue(Event, sStructure.summary_table_uname)
  nbr_plot = getNbrFiles(Event)
  ListOfInputFiles = Table[0,0:nbr_plot-1]
  path             = getTextFieldValue(Event,'create_output_file_path_button')
  ListOfInputFiles = path + ListOfInputFiles
  
  ;print, ListOfInputFiles ;remove_me
  
  ;check that all the file exist
  result = FIX(FILE_TEST(ListOfInputFiles,/READ))
  
  ;print, TOTAL(result)
  ;print, nbr_plot
  
  
  IF (TOTAL(result) NE nbr_plot) THEN BEGIN
    ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
    RETURN
  ENDIF ELSE BEGIN
    ReplaceTextInCreateStatus, Event, PROCESSING, OK
  ENDELSE
  
  LogMessage = '    Read data from input files .............. ' + PROCESSING
  addMessageInCreateStatus, Event, LogMessage
  error2 = 0
  CATCH, error2
  IF (error2 NE 0) THEN BEGIN
    CATCH,/CANCEL
    ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
    RETURN
  ENDIF ELSE BEGIN
    ReadData, Event, ListOfInputFiles, pData_y, pData_y_error
    ReplaceTextInCreateStatus, Event, PROCESSING, OK
  ENDELSE
  CATCH,/CANCEL
  
  LogMessage = '    Reformat (rebin) data ................... ' + PROCESSING
  addMessageInCreateStatus, Event, LogMessage
  error4 = 0
  CATCH, error4
  IF (error4 NE 0) THEN BEGIN
    CATCH,/CANCEL
    ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
    RETURN
  ENDIF ELSE BEGIN
    ReformatData, Event, pData_y, pData_y_error
    ReplaceTextInCreateStatus, Event, PROCESSING, OK
  ENDELSE
  CATCH,/CANCEL
  
  LogMessage = '    Shift Data .............................. ' + PROCESSING
  addMessageInCreateStatus, Event, LogMessage
  error3 = 0
  CATCH, error3
  IF (error3 NE 0) THEN BEGIN
    CATCH,/CANCEL
    ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
    RETURN
  ENDIF ELSE BEGIN
    step6_realign_data, Event, $
      pData_y, $
      pData_y_error,$
      realign_tfpData,$
      realign_tfpData_error
    ReplaceTextInCreateStatus, Event, PROCESSING, OK
  ENDELSE
  CATCH,/CANCEL
  
  LogMessage = '    Scale Data .............................. ' + PROCESSING
  addMessageInCreateStatus, Event, LogMessage
  error5 = 0
  CATCH, error5
  IF (error5 NE 0) THEN BEGIN
    CATCH,/CANCEL
    ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
    RETURN
  ENDIF ELSE BEGIN
    step6_scale_data, Event, $
      realign_tfpData, $
      realign_tfpData_error, $
      final_array, $
      final_error_array
      
    ReplaceTextInCreateStatus, Event, PROCESSING, OK
  ENDELSE
  CATCH,/CANCEL
  
  ;create output file
  step6_create_output_file_other_pola, Event, $
    sStructure, $
    final_array, $
    final_error_array
    
END

;------------------------------------------------------------------------------
PRO step6_create_output_file_other_pola, Event, $
    sStructure, $
    final_array, $
    final_error_array
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  instrument = (*global).instrument
  
  LogMessage = '    Create output file ...................... ' + PROCESSING
  addMessageInCreateStatus, Event, LogMessage
  error7 = 0
  CATCH, error7
  IF (error7 NE 0) THEN BEGIN
    CATCH,/CANCEL
    ReplaceTextInCreateStatus, Event, PROCESSING, FAILED
    RETURN
  ENDIF ELSE BEGIN
    ;get path
    path = getTextFieldValue(Event,'create_output_file_path_button')
    ;output file name
    file_name = getTextFieldValue(Event,sStructure.output_file_uname)
    ;full output file name
    full_file_name = path + file_name
    ;x-axis
    xaxis = (*(*global).x_axis)
    
    nbr_x = DOUBLE(N_ELEMENTS(xaxis)) ;nbr of tof
    nbr_y = DOUBLE((SIZE(final_array))(2)) ;nbr of pixels
    
    index = 0L
    output_strarray = STRARR(DOUBLE(2+DOUBLE(nbr_y)*DOUBLE((nbr_x+4))))
    output_strarray[index++] = $
      '#F Scaling Data File created with REFoffSpec'
      
    FOR i=0,(nbr_y-1) DO BEGIN
      output_strarray[index++] = ''
      IF (instrument EQ 'REF_M') THEN BEGIN
        output_strarray[index++] = "#S 1 Spectrum ID ('bank1', (" + $
          STRCOMPRESS(i,/REMOVE_ALL) + $
          ", 127))"
      ENDIF ELSE BEGIN
        output_strarray[index++] = "#S 1 Spectrum ID ('bank1', (127, " + $
          STRCOMPRESS(i,/REMOVE_ALL) + "))"
      ENDELSE
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
    full_output_file_name = full_file_name
    
    ;write output file
    OPENW, 1, full_output_file_name
    index = 0L
    WHILE (index LT N_ELEMENTS(output_strarray)) DO BEGIN
      PRINTF, 1, output_strarray[index++]
    ENDWHILE
    CLOSE, 1
    FREE_LUN, 1
    
    ReplaceTextInCreateStatus, Event, PROCESSING, OK
    ;enable preview button of working pola state
    sStructure.activate_status_pola= 1
  ENDELSE
  CATCH,/CANCEL
  
END

;------------------------------------------------------------------------------
PRO  ReformatData, Event,pData_y, pData_y_error
  step6_cleanup_data, Event, pData_y, pData_y_error
  step6_congrid_data, Event, pData_y, pData_y_error
END

;------------------------------------------------------------------------------
PRO step6_realign_data, Event, tfpData, $
    tfpData_error, $
    realign_tfpData, $
    realign_tfpData_error
    
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;array of realign data
  Nbr_array             = (SIZE(tfpData))(1)
  realign_tfpData       = PTRARR(Nbr_array,/ALLOCATE_HEAP)
  realign_tfpData_error = PTRARR(Nbr_array,/ALLOCATE_HEAP)
  pixel_offset_array    = INTARR(Nbr_array)
  
  ;retrieve pixel offset
  ref_pixel_list        = (*(*global).ref_pixel_list)
  ref_pixel_offset_list = (*(*global).ref_pixel_offset_list)
  
  nbr = N_ELEMENTS(ref_pixel_list)
  IF (nbr GT 1) THEN BEGIN
    ;copy the first array
    realign_tfpData[0]       = tfpData[0]
    realign_tfpData_error[0] = tfpData_error[0]
    index = 1
    WHILE (index LT nbr) DO BEGIN
      pixel_offset = ref_pixel_list[0]-ref_pixel_list[index]
      pixel_offset_array[index] = pixel_offset ;save pixel_offset
      ref_pixel_offset_list[index] += pixel_offset
      array        = *tfpData[index]
      array        = array[*,304L:2*304L-1]
      array_error  = *tfpData_error[index]
      array_error  = array_error[*,304L:2*304L-1]
      IF (pixel_offset EQ 0 OR $
        ref_pixel_list[index] EQ 0) THEN BEGIN ;if no offset
        realign_tfpData[index]       = tfpData[index]
        realign_tfpData_error[index] = tfpData_error[index]
      ENDIF ELSE BEGIN
        IF (pixel_offset GT 0) THEN BEGIN ;needs to move up
          ;move up each row by pixel_offset
          ;needs to start from the top when the offset is positive
          FOR i=303,pixel_offset,-1 DO BEGIN
            array[*,i]       = array[*,i-pixel_offset]
            array_error[*,i] = array_error[*,i-pixel_offset]
          ENDFOR
          ;bottom pixel_offset number of row are initialized to 0
          FOR j=0,pixel_offset DO BEGIN
            array[*,j]       = 0
            array_error[*,j] = 0
          ENDFOR
        ENDIF ELSE BEGIN    ;needs to move down
          pixel_offset = ABS(pixel_offset)
          FOR i=0,(303-pixel_offset) DO BEGIN
            array[*,i]       = array[*,i+pixel_offset]
            array_error[*,i] = array_error[*,i+pixel_offset]
          ENDFOR
          FOR j=303,303-pixel_offset,-1 DO BEGIN
            array[*,j]       = 0
            array_error[*,j] = 0
          ENDFOR
        ENDELSE
      ENDELSE
      
      local_data       = array
      local_data_error = array_error
      dim2         = (SIZE(local_data))(1)
      big_array    = STRARR(dim2,3*304L)
      big_array[*,304L:2*304L-1] = local_data
      *realign_tfpData[index] = big_array
      
      big_array_error    = STRARR(dim2,3*304L)
      big_array_error[*,304L:2*304L-1] = local_data_error
      *realign_tfpData_error[index] = big_array_error
      
      
      ;change reference pixel from old to neatew position
      ref_pixel_list[index] = ref_pixel_list[0]
      ++index
    ENDWHILE
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO ReadData, Event, list_OF_files, pData_y, pData_y_error
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  i = 0
  nbr = N_ELEMENTS(list_OF_files)
  final_new_pData         = PTRARR(nbr,/ALLOCATE_HEAP)
  final_new_pData_y_error = PTRARR(nbr,/ALLOCATE_HEAP)
  WHILE (i LT nbr) DO BEGIN
    iClass = OBJ_NEW('IDL3columnsASCIIparser',list_OF_files[i])
    pData = iClass->getDataQuickly()
    OBJ_DESTROY, iClass
    ;keep only the second column
    ;    new_pData_x       = STRARR((SIZE(*pData[0]))(2))
    ;    new_pData_x[*]    = (*pData[i])[0,*] ;retrieve x-array
    new_pData         = STRARR(N_ELEMENTS(pData),(SIZE(*pData[0]))(2))
    new_pData_y_error = FLTARR(N_ELEMENTS(pData),(SIZE(*pData[0]))(2))
    FOR j=0,(N_ELEMENTS(pData)-1) DO BEGIN ;retrieve y_array and error_y_array
      new_pData[j,*]         = (*pData[j])[1,*]
      new_pData_y_error[j,*] = (*pData[j])[2,*]
    ENDFOR
    *final_new_pData[i]         = new_pData
    *final_new_pData_y_error[i] = new_pData_y_error
    ;    *final_new_pData_x[i]       = new_pData_x
    ++i
  ENDWHILE
  pData_y       = final_new_pData
  pData_y_error = final_new_pData_y_error
;(*(*global).pData_x)         = final_new_pData_x
;(*global).plot_realign_data = 0
  
END

;------------------------------------------------------------------------------
PRO step6_cleanup_data, Event, pData, pData_error
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;get number of files loaded
  nbr_plot = getNbrFiles(Event)
  ;retrieve data
  j = 0
  WHILE (j  LT nbr_plot) DO BEGIN
    fpData        = FLOAT(*pData[j])
    tfpData       = TRANSPOSE(fpData)
    tfpData_error = TRANSPOSE(*pData_error[j])
    ;remove undefined values
    index = WHERE(~FINITE(tfpData),Nindex)
    IF (Nindex GT 0) THEN BEGIN
      tfpData[index] = 0
    ENDIF
    *pData[j]       = tfpData
    *pData_error[j] = tfpData_error
    ++j
  ENDWHILE
END

;------------------------------------------------------------------------------
PRO step6_congrid_data, Event, pData_y, pData_y_error
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  pData_x        = (*(*global).pData_x)
  
  ;determine the delta_x of each set of data
  sz      = (SIZE(pData_y))(1)
  delta_x = FLTARR(sz)
  determine_delta_x, sz, pData_x, delta_x
  
  ;get min delta_x and index
  min_delta_x = MIN(delta_x)
  min_index   = WHERE(delta_x EQ min_delta_x)
  
  ;work on all the data that have delta_x GT than the delta_x found
  congrid_coeff_array = (*(*global).congrid_coeff_array)
  
  ;congrid all data
  index       = 0
  max_x_size  = 0                 ;max number of elements
  max_x_value = 0                 ;maximum x value
  WHILE (index LT sz) DO BEGIN
    coeff = congrid_coeff_array[index]
    current_x_max_size  = (SIZE(*pData_x[index]))(1)
    current_max_x_value = MAX(FLOAT(*pData_x[index]))
    IF (current_max_x_value GT max_x_value) THEN BEGIN
      max_x_value = current_max_x_value
    ENDIF
    IF (current_x_max_size GT max_x_size) THEN BEGIN
      max_x_size = current_x_max_size
    ENDIF
    IF (coeff NE 1) THEN BEGIN
      congrid_x_coeff = current_x_max_size * congrid_coeff_array[index]
      ;work on y
      congrid_y_coeff = (SIZE(*pData_y[index]))(2)
      new_y_array = CONGRID((*pData_y[index]), $
        FIX(congrid_x_coeff),$
        congrid_y_coeff)
      *pData_y[index] = new_y_array
      ;work on y_error
      congrid_y_error_coeff = congrid_y_coeff
      new_y_error_array = CONGRID((*pData_y_error[index]), $
        FIX(congrid_x_coeff),$
        congrid_y_error_coeff)
      *pData_y_error[index] = new_y_error_array
    ENDIF
    ++index
  ENDWHILE
  
  ;triple the size of each array (except the first one)
  list_OF_files         = (*(*global).list_OF_ascii_files)
  nbr                   = N_ELEMENTS(list_OF_files)
  realign_pData_y       = PTRARR(nbr,/ALLOCATE_HEAP)
  realign_pData_y_error = PTRARR(nbr,/ALLOCATE_HEAP)
  
  index  = 0
  WHILE(index LT sz) DO BEGIN
    IF (index EQ 0) THEN BEGIN
      *realign_pData_y[index] = *pData_y[index]
      *realign_pData_y_error[index] = *pData_y_error[index]
    ENDIF ELSE BEGIN
      local_data       = *pData_y[index]
      local_data_error = *pData_y_error[index]
      dim2             = (SIZE(local_data))(1)
      big_array        = STRARR(dim2,3*304L)
      big_array_error  = STRARR(dim2,3*304L)
      big_array[*,304L:2*304L-1]       = local_data
      big_array_error[*,304L:2*304L-1] = local_data_error
      *realign_pData_y[index]          = big_array
      *realign_pData_y_error[index]    = big_array_error
    ENDELSE
    ++index
  ENDWHILE
  
  pData_y       = realign_pData_y
  pData_y_error = realign_pData_y_error
  
END

;------------------------------------------------------------------------------
PRO  step6_scale_data, Event, tfpData, tfpData_error, $
    final_array, final_error_array
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  nbr_plot             = getNbrFiles(Event) ;number of files
  scaling_factor_array = (*(*global).scaling_factor)
  
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
      size             = (SIZE(total_array,/DIMENSIONS))[0]
    ENDIF ELSE BEGIN
      index_no_null = WHERE(local_tfpData NE 0,nbr)
      IF (nbr NE 0) THEN BEGIN
        index_indices = ARRAY_INDICES(local_tfpData,index_no_null)
        sz = (SIZE(index_indices,/DIMENSION))[1]
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
  instrument = (*global).instrument
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  IF (instrument EQ 'REF_M') THEN BEGIN
    pola_state = getTextFieldValue(Event,'summary_working_polar_value')
    LogMessage = '> Working on Initial Polarization State (' + $
      STRCOMPRESS(pola_state,/REMOVE_ALL) + ')'
    putMessageInCreateStatus, Event, LogMessage
    LogMessage = '    Create output data (shifting/scaling) ... ' + PROCESSING
    addMessageInCreateStatus, Event, LogMessage
  ENDIF ELSE BEGIN
    LogMessage = '> Working on creating output files:'
    putMessageInCreateStatus, Event, LogMessage
    LogMessage = '    Create output data (shifting/scaling) ... ' + PROCESSING
    addMessageInCreateStatus, Event, LogMessage
  ENDELSE
  
  activate_status_pola1 = 0
  activate_status_pola2 = 0
  activate_status_pola3 = 0
  activate_status_pola4 = 0
  
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
      nbr_y = DOUBLE((SIZE(final_array))(2)) ;nbr of pixels
      
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
      
      IF (instrument EQ 'REF_M') THEN BEGIN
      
        value = getButtonStatus(Event,'exclude_polarization_state2')
        IF (value EQ 0) THEN BEGIN ;we want this pola state
          ;loop over the three other polarization states
          ;pola#2
          sStructure = { summary_table_uname: $
            'polarization_state2_summary_table',$
            pola_state_uname: $
            'summary_polar2_value',$
            activate_status_pola: 0,$
            output_file_uname:$
            'pola2_output_file_name_value'}
          run_full_process_with_other_pola, Event, sStructure
          activate_status_pola2 = sStructure.activate_status_pola
        ENDIF
        
        ;pola#3
        value = getButtonStatus(Event,'exclude_polarization_state3')
        IF (value EQ 0) THEN BEGIN ;we want this pola state
          sStructure = { summary_table_uname: $
            'polarization_state3_summary_table',$
            pola_state_uname: $
            'summary_polar3_value',$
            activate_status_pola: 0,$
            output_file_uname:$
            'pola3_output_file_name_value'}
          run_full_process_with_other_pola, Event, sStructure
          activate_status_pola3 = sStructure.activate_status_pola
        ENDIF
        
        ;pola#4
        value = getButtonStatus(Event,'exclude_polarization_state4')
        IF (value EQ 0) THEN BEGIN ;we want this pola state
          sStructure = { summary_table_uname: $
            'polarization_state4_summary_table',$
            pola_state_uname: $
            'summary_polar4_value',$
            activate_status_pola: 0,$
            output_file_uname:$
            'pola4_output_file_name_value'}
          run_full_process_with_other_pola, Event, sStructure
          activate_status_pola4 = sStructure.activate_status_pola
        ENDIF
        
      ENDIF
      
    ENDELSE
    CATCH,/CANCEL
  ENDELSE
  
  ;activate preview widgets
  activate_widget, Event, 'step6_preview_pola_state1', activate_status_pola1
  IF (instrument EQ 'REF_M') THEN BEGIN
    activate_widget, Event, 'step6_preview_pola_state2', activate_status_pola2
    activate_widget, Event, 'step6_preview_pola_state3', activate_status_pola3
    activate_widget, Event, 'step6_preview_pola_state4', activate_status_pola4
  ENDIF
  
  LogMessage = ''
  addMessageInCreateStatus, Event, LogMessage
  LogMessage = '**** Create Output File process .... DONE ****'
  addMessageInCreateStatus, Event, LogMessage
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END
