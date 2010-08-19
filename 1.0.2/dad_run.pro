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

FUNCTION retrieve_info_from_es_file, Event, FILE_NAME = file_name

  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  error = 0
  CATCH, error ;REMOVE_ME
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    message = 'ERROR in the parsing of the Elascic Scan File!'
    result = DIALOG_MESSAGE(message,$
      /ERROR, $
      /CENTER, $
      DIALOG_PARENT = widget_id)
    RETURN, 0
  ENDIF
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  iASCII = OBJ_NEW('IDL3columnsASCIIparser', file_name, TYPE='Sq(E)')
  iData = iASCII->getDataQuickly(TRange, QRange)
  ;if there is more than 1 temperature, ask user to select which temperature
  ;he wants to use
  nbr_t = (size(TRange))(1)
  IF (nbr_t GT 1) THEN BEGIN
    es_temperature_selection_base, Event, TRange
    IF ((*global).continue_to_run_divisions) THEN BEGIN
    ENDIF ELSE BEGIN
      RETURN, 0
    ENDELSE
  ENDIF ELSE BEGIN
    (*global).es_temp_index = 0
  ENDELSE
  ;[nbr_T, nbr_Q] where each element is [value error_value]
  (*(*global).iESdata) = iData
  ;[nbr_Q]
  (*(*global).esQrange) = QRange
  
  ;create 3d Arrays [Q, scaling_factor, scaling_factor_error]
  ;index of temperature to look for scaling in each Q data set
  temp_index = (*global).es_temp_index
  nbr_Q = (size(Qrange))(1)
  
  es_Q_sf_sferror = DBLARR(3,nbr_Q)
  index = 0
  WHILE (index LT nbr_Q) DO BEGIN
    T_of_interest = iData[temp_index,index]
    T_of_interest = STRCOMPRESS(T_of_interest)
    value_error_array = STRSPLIT(T_of_interest,' ',/EXTRACT)
    es_Q_sf_sferror[0,index] = DOUBLE(Qrange[index])
    es_Q_sf_sferror[1,index] = DOUBLE(value_error_array[0])
    es_Q_sf_sferror[2,index] = DOUBLE(value_error_array[1])
    index++
  ENDWHILE
  
  ;[Q, scaling_factor, scaling_factor_error]
  (*(*global).es_Q_sf_sferror) = es_Q_sf_sferror ;
  
  RETURN, 1
  
END

;------------------------------------------------------------------------------
FUNCTION retrieve_data_from_ascii_file, Event, FILE_NAME=file_name, $
    Erange, $
    QRANGE, $
    iData, $
    Metadata
    
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    message = 'ERROR in the parsing of the Elascic Scan File!'
    result = DIALOG_MESSAGE(message,$
      /ERROR, $
      /CENTER, $
      DIALOG_PARENT = widget_id)
    RETURN, 0
  ENDIF
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  iASCII = OBJ_NEW('IDL3columnsASCIIparser', file_name, TYPE='Sq(E)')
  IF (~OBJ_VALID(iASCII)) THEN RETURN, 0
  
  ;[E,Q]
  iData = iASCII->getDataQuickly(ERange, QRange, Metadata)
  
  RETURN, 1
END

;------------------------------------------------------------------------------
FUNCTION QrangeMatch, esQrange=esQrange, daveQrange=daveQrange
  RETURN, ARRAY_EQUAL(esQrange, daveQrange)
END

;------------------------------------------------------------------------------
;This function create the big array of the dave ascii file
;input is [value value_error]
;ouput will be [value],[value_error]
FUNCTION create_value_value_error, iDAta, dave_value_valueerror

  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN, 0
  ENDIF
  
  nbr_row = (size(iDAta))(1) ;E
  nbr_Q   = (size(iData))(2) ;Q
  
  ;dave_value_valueerror = [nbr_Q, nbr_row, 2]
  dave_value_valueerror = DBLARR(nbr_Q, nbr_row, 2)
  
  FOR i=0,(nbr_Q-1) DO BEGIN
    index = 0
    WHILE (index LT nbr_row) DO BEGIN
      line_compressed = STRCOMPRESS(iData[index,i])
      split_array = STRSPLIT(line_compressed, ' ', /EXTRACT)
      dave_value_valueerror[i,index,0] = DOUBLE(split_array[0])
      dave_value_valueerror[i,index,1] = DOUBLE(split_array[1])
      index++
    ENDWHILE
  ENDFOR
  
  RETURN, 1
  
END

;------------------------------------------------------------------------------
FUNCTION perform_division, Event, $
    ES_DATA = es_data, $
    DAVE_DATA = dave_data, $
    DIVIDED_DAVE_DATA = divided_dave_data
    
  nbr_Q = (size(dave_data))(1)
  nbr_row = (size(dave_data))(2)
  
  divided_dave_data = DBLARR(nbr_Q, nbr_row, 2)
  
  FOR i=0,(nbr_Q-1) DO BEGIN
  
    FOR j=0,(nbr_row-1) DO BEGIN
    
      A = dave_data[i,j,0]
      B = ES_DATA[0,i]
      
      sigmaA = dave_data[i,j,1]
      sigmaB = ES_DATA[1,i]
      
      value = A / B
      
      error_term1 = ((A^2) / (B^4)) * sigmaB^2
      error_term2 = sigmaA^2 / (B^2)
      value_error_2 = error_term1 + error_term2
      value_error   = SQRT(value_error_2)
      
      divided_dave_data[i,j,0] = value
      divided_dave_data[i,j,1] = value_error
      
    ENDFOR
    
  ENDFOR
  
  RETURN, 1
  
END

;==============================================================================
;==============================================================================
PRO run_divisions, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;get ES file name
  es_file_name = getTextFieldValue(event, 'es_file_name')
  status = retrieve_info_from_es_file(Event, FILE_NAME=es_file_name)
  IF (status EQ 0) THEN RETURN ;quit run divisions
  
  ;get big_table
  table = getTableValue(Event, 'table_uname')
  dim = (size(table))(0)
  if (dim eq 1) then begin
    nbr_files = 1
  endif else begin
    nbr_files = (size(table))(2)
  endelse
  
  index_file = 0
  WHILE (index_file LT nbr_files) DO BEGIN
  
    ;current output ascii file
    output_ascii_file = table[2,index_file]
    IF (FILE_TEST(output_ascii_file)) THEN BEGIN ;file exists already
      message = 'Do you want to overwrite ' + output_ascii_file
      title = 'File with same name was found!'
      widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
      result = DIALOG_MESSAGE(message, $
        TITLE = title, $
        /QUESTION, $
        /CENTER, $
        DIALOG_PARENT = widget_id)
      IF (result EQ 'No') THEN BEGIN
        table[3,index_file] = 'NO OVERWRITE'
        putValue, Event,'table_uname', table
        index_file++
        CONTINUE
      ENDIF
    ENDIF
    
    ;current input working file
    input_ascii_file = table[0,index_file]
    
    status = retrieve_data_from_ascii_file(Event, $
      FILE_NAME=input_ascii_file, $
      Erange, $
      Qrange, $
      iData, $
      Metadata)
      
    IF (status EQ 0) THEN BEGIN
      table[3,index_file] = 'FAILED'
      putValue, Event,'table_uname', table
      index_file++
      CONTINUE
    ENDIF
    
    ;check that the Q matches
    es_Q_sf_sferror = (*(*global).es_Q_sf_sferror)
    nbr_q_esQrange = (size(es_Q_sf_sferror[0,*]))(2)
    esQrange = FLTARR(nbr_q_esQrange)
    esQrange[*] = es_Q_sf_sferror[0,*]
    ;if Q range axes do not match
    IF (~QrangeMatch(esQrange=esQrange, daveQrange=Qrange)) THEN BEGIN
      table[3,index_file] = 'FAILED'
      putValue, Event,'table_uname', table
      index_file++
      CONTINUE
    ENDIF
    
    ;split value and value_error of dave data
    status = create_value_value_error(iDAta, dave_value_valueerror)
    IF (status EQ 0) THEN BEGIN
      table[3,index_file] = 'FAILED'
      putValue, Event,'table_uname', table
      index_file++
      CONTINUE
    ENDIF
    
    ;perform division
    es_sf_sferror = FLTARR(2,nbr_q_esQrange)
    es_sf_sferror[0,*] = es_Q_sf_sferror[1,*]
    es_sf_sferror[1,*] = es_Q_sf_sferror[2,*]
    
    status = perform_division( Event, $
      ES_DATA = es_sf_sferror, $
      DAVE_DATA = dave_value_valueerror, $
      DIVIDED_DAVE_DATA = divided_dave_data)
      
    ;create output ascii file
    status = create_output_ascii_file(Event, $
      output_ascii_file, $
      Erange, $
      Qrange, $
      divided_dave_data, $
      metadata)
    IF (status EQ 0) THEN BEGIN
      table[3,index_file] = 'FAILED'
      putValue, Event,'table_uname', table
      index_file++
      CONTINUE
    ENDIF
    
    table[3,index_file] = 'DONE'
    putValue, Event,'table_uname', table
    index_file++
    
  ENDWHILE
  
  
END

;------------------------------------------------------------------------------