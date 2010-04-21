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

;+
; :Description:
;   This load and plot the data batch file
;
; :Params:
;    Event
;    DataRunNumber
;    currFullDataNexusName
;    data_path
;
; :Author: j35
;-
PRO open_and_plot_nexus_ref_m, Event, $
    DataRunNumber, $
    currFullDataNexusName, $
    data_path
    
  compile_opt idl2
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;Open That NeXus file
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just before OpenDataNexusFile_batch'
  ENDIF
  open_nexus_ref_m_batch, event, DataRunNumber, currFullDataNexusName, data_path
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just after OpenDataNexusFile_batch'
  ENDIF
  
  (*global).DataNexusFound  = 1
  
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just before REFreduction_Plot1D2DDataFile_batch'
  ENDIF
  ;then plot data file (1D and 2D)
  result = REFreduction_Plot1D2DDataFile_batch(Event)
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just after REFreduction_Plot1D2DDataFile_batch'
  ENDIF
  
  ;tell the user that the load and plot process is done
  InitialStrarr = getDataLogBookText(Event)
  putTextAtEndOfDataLogBookLastLine, $
    Event, $
    InitialStrarr, $
    ' Done', $
    (*global).processing_message
  ;display full path to NeXus in Norm log book
  full_nexus_name = (*global).data_full_nexus_name
  text = '(Nexus path: ' + strcompress(full_nexus_name,/remove_all) + ')'
  putDataLogBookMessage, Event, text, Append=1
  ;to see the last line of the data log book
  showLastDataLogBookLine, Event
END

;+
; :Description:
;   open the nexus ref_m file
;
; :Params:
;    Event
;    DataRunNumber
;    full_nexus_name
;    data_path
;
; :Author: j35
;-
PRO open_nexus_ref_m_batch, Event, DataRunNumber, full_nexus_name, data_path
  compile_opt idl2
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    PRINT, 'Entering OpenDataNexusFile_batch'
  ENDIF
  
  ;store run number of data file
  (*global).data_run_number = DataRunNumber
  
  ;store full path to NeXus
  (*global).data_full_nexus_name = full_nexus_name
  
  ;where to display the nxsummary data
  
  ;check format of NeXus file
  IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN
    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
      PRINT, '-> file is HDF5'
    ENDIF
    
    (*global).isHDF5format = 1
    ;dump binary data into local directory of user
    working_path = (*global).working_path
    
    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
      PRINT, '-> About to enter REFreduction_DumpBinaryData_batch'
    ENDIF
    retrieveBanksData_ref_m, Event, full_nexus_name, 'data', spin_state=data_path
    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
      PRINT, '-> About to leave REFreduction_DumpBinaryData_batch'
    ENDIF
    
    IF ((*global).isHDF5format) THEN BEGIN
      ;create name of BackgroundROIFile and put it in its box
      REFreduction_CreateDefaultDataBackgroundROIFileName, Event, $
        'REF_M', $
        working_path, $
        DataRunNumber
    ENDIF
  ENDIF ELSE BEGIN
    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
      PRINT, '-> file is not HDF5'
    ENDIF
    
    (*global).isHDF5format = 0
    ;tells the data log book that the format is wrong
    InitialStrarr = getDataLogBookText(Event)
    putTextAtEndOfDataLogBookLastLine, $
      Event, $
      InitialStrarr, $
      (*global).failed, $
      PROCESSING
  ENDELSE
  
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    PRINT, 'Leaving OpenDataNexusFile_batch'
  ENDIF
  
END


;+
; :Description:
;   This procedure retrieve the data from the REF_M nexus file
;
; :Params:
;    Event
;    FullNexusName
;    type
;
; :Keywords:
;    spin_state
;
; :Author: j35
;-
pro retrieveBanksData_ref_m, Event, FullNexusName, type, spin_state=spin_state
  compile_opt idl2
  
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
    RETURN
  ENDIF ELSE BEGIN
    fileID  = h5f_open(FullNexusName)
    (*global).isHDF5format = 1
    ;get bank data
    data_path = '/entry-' + spin_state + '/bank1/data'
    fieldID = h5d_open(fileID,data_path)
    data = h5d_read(fieldID)
    
    x = (size(data))[2]
    if (x ne 256) then begin
      using_wrong_version_of_ref_reduction, Event
      message, 'Wrong detector geometry'
    endif
    
    CASE (type) OF
      'data': (*(*global).bank1_data) = data
      'norm': (*(*global).bank1_norm) = data
      'empty_cell': (*(*global).bank1_empty_cell) = data
      ELSE: RETURN
    ENDCASE
    RETURN
  ENDELSE
END
