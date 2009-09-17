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
  ;CATCH, error ;REMOVE_ME
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
FUNCTION retrieve_data_from_ascii_file, Event, FILE_NAME=file_name, QRANGE, iData

  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  error = 0
  ;CATCH, error ;REMOVE_ME
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
  
  iData = iASCII->getDataQuickly(TRange, QRange)
  
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
  nbr_files = (size(table))(2)
  index_file = 0
  WHILE (index_file LT nbr_files) DO BEGIN
  
    ;current input working file
    input_ascii_file = table[0,index_file]
    ;current output ascii file
    output_ascii_file = table[2,index_file]
    status = retrieve_data_from_ascii_file(Event, $
      FILE_NAME=input_ascii_file, $
      Qrange, $
      iData)
    IF (status EQ 0) THEN BEGIN
      table[3,index_file] = FAILED
      CONTINUE
    ENDIF
    
  ;check that the Q matches
  
    
    
    
    index_file++
  ENDWHILE
  
  
END

