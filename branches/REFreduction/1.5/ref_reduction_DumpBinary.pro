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
;this function is going to retrive the data from bank1
;and save them in (*(*global).bank)
FUNCTION retrieveBanksData, Event, $
    FullNexusName, $
    type, $
    _EXTRA=_extra
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    (*global).isHDF5format = 0
    ;display message about invalid file format
    putDataLogBookMessage, Event, $
      'Nexus formt not supported by this application', APPEND=1
    RETURN,0
  ENDIF ELSE BEGIN
    fileID  = h5f_open(FullNexusName)
    (*global).isHDF5format = 1
    ;get bank data
    IF (N_ELEMENTS(_EXTRA) NE 0) THEN BEGIN
      IF (N_ELEMENTS(_EXTRA.POLA_STATE) NE 0) THEN BEGIN
        CASE (_EXTRA.POLA_STATE) OF
          0: data_path = (*global).nexus_bank1_path_pola0
          1: data_path = (*global).nexus_bank1_path_pola1
          2: data_path = (*global).nexus_bank1_path_pola2
          3: data_path = (*global).nexus_bank1_path_pola3
        ENDCASE
      ENDIF ELSE BEGIN
        data_path = (*global).nexus_bank1_path
      ENDELSE
    ENDIF ELSE BEGIN
      data_path = (*global).nexus_bank1_path
    ENDELSE
    fieldID = h5d_open(fileID,data_path)
    simulate_rotated_detector = (*global).simulate_rotated_detector
    CASE (type) OF
      'data': BEGIN
        data = h5d_read(fieldID)
        IF (simulate_rotated_detector EQ 'yes') THEN BEGIN
          simulate_REF_L_rotated_angle, data
        ENDIF
        x = (size(data))(2)
        if (x ne 256) then begin
          using_wrong_version_of_ref_reduction, Event
          message, 'wrong nexus file format'
          return, 0
        endif
        (*(*global).bank1_data) = data
        (*(*global).new_rescale_tvimg) = data
        
        iNexus = obj_new('IDLnexusUtilities', fullNexusName)
        tof_axis = iNexus.get_tof_data()
        obj_destroy, iNexus
        (*(*global).tof_axis_ms) = tof_axis
      END
      'norm': BEGIN
        data = h5d_read(fieldID)
        IF (simulate_rotated_detector EQ 'yes') THEN BEGIN
          simulate_REF_L_rotated_angle, data
        ENDIF
        x = (size(data))(2)
        if (x ne 256) then begin
          using_wrong_version_of_ref_reduction, Event
          message, 'wrong nexus file format'
          return, 0
        endif
        (*(*global).bank1_norm) = data
        (*(*global).new_rescale_norm_tvimg) = data

      END
      'empty_cell': BEGIN
        data = h5d_read(fieldID)
        IF (simulate_rotated_detector EQ 'yes') THEN BEGIN
          simulate_REF_L_rotated_angle, data
        ENDIF
        x = (size(data))(2)
        if (x ne 256) then begin
          using_wrong_version_of_ref_reduction, Event
          message, 'wrong nexus file format'
          return, 0
        endif
        (*(*global).bank1_empty_cell) = data
      END
      ELSE: RETURN, 0
    ENDCASE
    RETURN, 1
  ENDELSE
END

;**********************************************************************
;DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA  *
;**********************************************************************
;This function dumps the binary data of the given full nexus name
FUNCTION RefReduction_DumpBinaryData, Event, $
    full_nexus_name, $
    destination_folder, $
    _EXTRA=_extra
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;tmp_file_name = (*global).data_tmp_dat_file
  RefReduction_DumpBinary, $
    Event, $
    full_nexus_name, $
    'data', $
    dump_status, $
    _EXTRA=_extra
  RETURN, dump_status
  
END

;------------------------------------------------------------------------------
;This function dumps the binary data of the given full nexus name
FUNCTION RefReduction_DumpBinaryEmptyCell, Event, $
    full_nexus_name, $
    destination_folder, $
    _EXTRA=_extra
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;tmp_file_name = (*global).data_tmp_dat_file
  RefReduction_DumpBinary, $
    Event, $
    full_nexus_name, $
    'empty_cell', $
    dump_status, $
    _EXTRA=_extra
  RETURN, dump_status
END

;------------------------------------------------------------------------------
;This function dumps the binary data of the given full nexus name
FUNCTION RefReduction_DumpBinaryEmptyCell_batch, Event, $
    full_nexus_name, $
    destination_folder, $
    _EXTRA=_extra
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;tmp_file_name = (*global).data_tmp_dat_file
  RefReduction_DumpBinary_batch, Event, full_nexus_name, 'empty_cell'
  RETURN, 1
END

;------------------------------------------------------------------------------
;This function dumps the binary data of the given full nexus name for
;batch run only
PRO RefReduction_DumpBinaryData_batch, Event, $
    full_nexus_name, $
    destination_folder
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, '--> Entering RefReduction_DumpBinaryData_batch'
  ENDIF
  
  tmp_file_name = (*global).data_tmp_dat_file
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, '--> About to enter RefReduction_DumpBinary_batch'
  ENDIF
  RefReduction_DumpBinary_batch, $
    Event, $
    full_nexus_name, $
    'data'
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, '--> About to leave RefReduction_DumpBinary_batch'
  ENDIF
  
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, '--> Leaving RefReduction_DumpBinaryData_batch'
  ENDIF
  
END

;**********************************************************************
;NORMALIZATION - NORMALIZATION - NORMALIZATION - NORMALIZATION        *
;**********************************************************************
;This function dumps the binary data of the given full nexus name
FUNCTION RefReduction_DumpBinaryNormalization, Event, $
    full_nexus_name, $
    destination_folder, $
    _EXTRA=_extra
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;tmp_file_name = (*global).norm_tmp_dat_file
  RefReduction_DumpBinary, $
    Event, $
    full_nexus_name, $
    'norm', $
    dump_status, $
    _EXTRA=_extra
  RETURN, 1
END

;------------------------------------------------------------------------------
;This function dumps the binary data of the given full nexus name
;Batch mode only
PRO RefReduction_DumpBinaryNormalization_batch, Event, $
    full_nexus_name, $
    destination_folder
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  tmp_file_name = (*global).norm_tmp_dat_file
  RefReduction_DumpBinary_batch, $
    Event, $
    full_nexus_name, $
    'norm'
END

;**********************************************************************
;DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA*
;**********************************************************************
;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinary, Event, $
    full_nexus_name, $
    type, $
    dumb_status,$
    _EXTRA=_extra
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing_message ;processing message
  ;display in log book what is going on
  cmd_text = '-> Retrieving data ... ' + PROCESSING
  putLogBookMessage, Event, cmd_text, Append=1
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, (*global).failed
    dumb_status = 0
  ENDIF ELSE BEGIN
    status = retrieveBanksData(Event, full_nexus_name, type, _EXTRA=_extra)
    IF (status EQ 0) THEN BEGIN
      LogBookText = getLogBookText(Event)
      Message = (*global).failed
      putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
      dumb_status = 0
    ENDIF ELSE BEGIN
      ;tells user that dump is done
      LogBookText = getLogBookText(Event)
      Message = 'OK'
      putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
      dumb_status = 1
    ENDELSE
  ENDELSE
END

;------------------------------------------------------------------------------
;This function dumps the binary data of the given full nexus name for
;batch mode only
PRO RefReduction_DumpBinary_batch, Event, full_nexus_name, type
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;IF ((*global).debugging_version EQ 'yes') THEN BEGIN
  ;    print, '---> Enter RefReduction_Dumpbinary_batch'
  ;ENDIF
  result = retrieveBanksData(Event, full_nexus_name, type)
;IF ((*global).debugging_version EQ 'yes') THEN BEGIN
;    print, '---> Leaving RefReduction_Dumpbinary_batch'
;ENDIF
END
