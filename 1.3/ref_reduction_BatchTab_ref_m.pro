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

function isThereAnyCmdDefined_ref_m, Event
  widget_control,event.top,get_uvalue=global
  
  BatchTable = (*(*global).BatchTable_ref_m)
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[8,i] NE 'N/A' AND $
      BatchTable[8,i] NE '') THEN BEGIN
      RETURN,1
    ENDIF
  ENDFOR
  RETURN,0
END

;------------------------------------------------------------------------------
FUNCTION isThereAnyDataActivate_ref_m, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable = (*(*global).BatchTable_ref_m)
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[0,i] EQ 'YES' OR $
      BatchTable[0,i] EQ '> YES <') THEN RETURN, 1
  ENDFOR
  RETURN,0
END

;------------------------------------------------------------------------------
FUNCTION isThereAnyDataInBatchTable_ref_m, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable      = (*(*global).BatchTable_ref_m)
  BatchTableReset = strarr(9,20)
  IF (ARRAY_EQUAL(BatchTable,BatchTableReset)) THEN RETURN, 0
  RETURN,1
END


;+
; :Description:
;   Check if the current row is active or not
;
; :Params:
;    RowSelected
;    BatchTable
;
; :Author: j35
;-
function IsRowSelectedActive_ref_m, RowSelected, BatchTable
  compile_opt idl2
  IF (BatchTable[0,RowSelected] EQ 'YES' OR $
    BatchTable[0,RowSelected] EQ '> YES <') THEN RETURN, 1
  return, 0
end


function can_we_activate_batch_save_button, event

  widget_control, event.top, get_uvalue=global
  
  BatchTable = (*(*global).BatchTable_ref_m)
  if (BatchTable[0,0] eq '') then return, 0
  
  file_name = getTextFieldValue(event,'save_as_file_name')
  if (strcompress(file_name[0],/remove_all) eq '') then return, 0
  
  return,1
  
end

;+
; :Description:
;   Check if a row has already been selected or not
;
; :Params:
;    event
;
; :Author: j35
;-
function IsAnyRowSelected_ref_m, event
  id = widget_info(Event.top,find_by_uname='batch_table_widget')
  Selection = widget_info(id,/table_select)
  ColumnIndexes = getGlobalVariable_ref_m('ColumnIndexes')
  IF (Selection[2] EQ ColumnIndexes) THEN RETURN, 1
  RETURN, 0
end

;+
; :Description:
;   reach each time the user select the Batch tab
;
; :Params:
;    Event
;
; :Author: j35
;-
PRO UpdateBatchTable_ref_m, Event

  ;get global structure
  widget_control,event.top,get_uvalue=global
  
  BatchTable = (*(*global).BatchTable_ref_m)
  
  ;check if a row has been already selected, if no, select first row
  IF (IsAnyRowSelected_ref_m(Event) NE 1) THEN BEGIN
    SelectFullRow_ref_m, Event, 0
  ENDIF ELSE BEGIN
    CurrentWorkingRow = getCurrentRowSelected(Event)
    DisplayInfoOfSelectedRow_ref_m, Event, CurrentWorkingRow
  ENDELSE
  
;check if there are any not 'N/A' command line, if yes, then activate
;DELETE SELECTION, DELETE ACTIVE, RUN ACTIVE AND SAVE ACTIVE(S)
; UpdateBatchTabGui, Event
;enable or not the REPOPULATE Button
; CheckRepopulateButton, Event
END

;+
; :Description:
;   This function displays all the fields of the current selected row
;   in the INPUT base below the main batch table
;
; :Params:
;    Event
;    RowSelected
;
;
;
; :Author: j35
;-
PRO DisplayInfoOfSelectedRow_ref_m, Event, RowSelected

  ;get global structure
  widget_control,event.top,get_uvalue=global
  
  ;get BatchTable value
  BatchTable = (*(*global).BatchTable_ref_m)
  
  IF (RowSelected EQ -1) THEN BEGIN ;clear input base
  
    UpdateDataField,  Event, ''
    UpdateDataSpinStateField, Event, ''
    UpdateNormField,  Event, ''
    UpdateNormSpinStateField, Event, ''
    UpdateAngleField, Event, ''
    UpdateCMDField,   Event, ''
    
  ENDIF ELSE BEGIN
  
    IF (isRowSelectedActive_ref_m(RowSelected,BatchTable)) THEN BEGIN
      ValidateActive, Event, 0
    ENDIF ELSE BEGIN
      ValidateActive, Event, 1
    ENDELSE
    
    ;if BatchTable empty, then clear info widgets
    if (BatchTable[0,RowSelected] eq '') then begin
      UpdateDataField,  Event, ''
      UpdateDataSpinStateField, Event, ''
      UpdateNormField,  Event, ''
      UpdateNormSpinStateField, Event, ''
      UpdateAngleField, Event, ''
      UpdateCMDField,   Event, ''
    endif
    
    UpdateDataField,  Event, BatchTable[1,RowSelected]
    UpdateDataSpinStateField, Event, BatchTable[2,RowSelected]
    UpdateNormField,  Event, BatchTable[3,RowSelected]
    UpdateNormSpinStateField, Event, BatchTable[4,RowSelected]
    UpdateAngleField, Event, BatchTable[5,RowSelected]
    UpdateCMDField,   Event, BatchTable[8,RowSelected]
    
  ENDELSE
  
END

;+
; :Description:
;   Populates the droplist of the information box with the spin states of the
;   selected row
;
; :Params:
;    Event
;    data_spins
;
; :Author: j35
;-
pro UpdateDataSpinStateField, Event, data_spins
  compile_opt idl2
  
  data_spins_split = strsplit(data_spins,'/',/extract,count=nbr)
  id = widget_info(Event.top,find_by_uname='bash_data_spin_state_droplist')
  if (nbr ge 1) then begin
    widget_control, id, set_value=data_spins_split
  endif else begin
    widget_control, id, set_value=['']
  endelse
  
end

;+
; :Description:
;   Populates the norm spin state label with the corresponding spin state
;   according to the spin state selected in the data droplist spin state
;
; :Params:
;    Event
;    norm_spins
;
; :Author: j35
;-
pro UpdateNormSpinStateField, Event, norm_spins
  compile_opt idl2
  
  norm_spins_split = strsplit(norm_spins,'/',/extract,count=nbr)
  spin = norm_spins_split[0]
  putTextFieldValue, event, 'bash_norm_spin_state_label', spin
  
end




pro populate_ref_m_batch_table, event, cmd_array
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global
  
  ;retrieve current Batch Table
  BatchTable = (*(*global).BatchTable_ref_m)
  
  ;check if there is a row in the BatchTable where the Command Line is
  ;still undefined. If yes, remove this row, if not, remove last row and
  ;move up everything
  RowIndexes    = getGlobalVariable_ref_m('RowIndexes')
  ColumnIndexes = getglobalVariable_ref_m('ColumnIndexes')
  for i=0,RowIndexes do begin
    if (BatchTable[ColumnIndexes,i] EQ 'N/A') then begin
      RemoveGivenRowInBatchTable_ref_m, BatchTable, i
      break
    endif
  endfor
  
  ;move down everything to make room for new load data and insert blank
  ;data
  AddBlankRowInBatchTable_ref_m, BatchTable
  
  ;Create instance of the class that will collect the various infos
  ClassInstance = obj_new('IDLparseCommandLine_ref_m',cmd_array)
  
  MainDataRunNumber = ClassInstance->getMainDataRunNumber()
  
  print, 'MaindDataRunNumber: ' ,  MainDataRunNumber
  
  DataSpinStates = ClassInstance->getDataPath()
  MainNormRunNumber = ClassInstance->getMainNormRunNumber()
  NormSpinStates = ClassInstance->getNormPath()
  Sangle = ClassInstance->getSangleValue()
  cmd = ClassInstance->getCmd()
  
  BatchTable[1,0] = MainDataRunNumber
  BatchTable[2,0] = DataSpinStates
  BatchTable[3,0] = MainNormRunNumber
  BatchTable[4,0] = NormSpinStates
  BatchTable[5,0] = Sangle
  BatchTable[6,0] = GenerateShortReadableIsoTimeStamp()
  BatchTable[8,0] = cmd
  active_batch_new_line, event, BatchTable
  
  ;populate table of batch tab
  VisualBatchTable = BatchTable[0:8,*]
  id = widget_info(Event.top,find_by_uname='batch_table_widget')
  widget_control, id, set_value=VisualBatchTable
  
  (*(*global).BatchTable_ref_m) = BatchTable
  
end

;+
; :Description:
;   This will activate the new batch line that was just added
;
; :Params:
;    event
;    BatchTable
;
; :Author: j35
;-
PRO active_batch_new_line, event, BatchTable
  ;get global structure
  widget_control,event.top,get_uvalue=global
  ;remove old current working row
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  FOR i=0,RowIndexes DO BEGIN
    CASE (BatchTable[0,i]) OF
      '> YES <': BEGIN
        BatchTable[0,i]='YES'
        BREAK
      END
      '> NO <': BEGIN
        BatchTable[0,i]='NO'
        BREAK
      END
      ELSE:
    ENDCASE
  ENDFOR
  BatchTable[0,0] = '> YES <'
END


;------------------------------------------------------------------------------
;This function insert a clear row on top of batchTable and move
;everything else down
PRO AddBlankRowInBatchTable_ref_m, BatchTable
  RowIndexes = getglobalVariable_ref_m('RowIndexes')
  FOR i = 0, RowIndexes-1 DO BEGIN
    k=(RowIndexes-i)
    BatchTable[*,k]=BatchTable[*,k-1]
  ENDFOR
  ClearStructureFields_ref_m, BatchTable, 0
END

;------------------------------------------------------------------------------
;This function removes the given row from the BatchTable
PRO RemoveGivenRowInBatchTable_ref_m, BatchTable, Row
  RowIndexes = getGlobalVariable('RowIndexes')
  FOR i = Row, (RowIndexes-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
  ENDFOR
  ClearStructureFields_ref_m, BatchTable, RowIndexes
END

;------------------------------------------------------------------------------
;This function reset all the structure fields of the current index
PRO ClearStructureFields_ref_m, BatchTable, CurrentBatchTableIndex
  nbr_column = getGlobalVariable_ref_m('NbrColumn')
  resetArray = strarr(nbr_column)
  BatchTable[*,CurrentBatchTableIndex] = resetArray
END

;------------------------------------------------------------------------------
PRO GenerateBatchFileName_ref_m, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get first part (ex: REF_L_Batch_ )
  file_name = (*global).instrument
  file_name += '_Batch_'
  
  ;add first run number loaded (first row)
  ;(ex: REF_L_Batch_Run3454 )
  MainRunNumber = GetMajorRunNumber_ref_m(Event)
  file_name += 'Run' + strcompress(MainRunNumber,/remove_all)
  
  ;add time stamp (ex: REF_L_Batch_3454_2008y_02m_10d )
  TimeBatchFormat = RefReduction_GenerateIsoTimeStamp()
  file_name += '_' + TimeBatchFormat
  
  ;add extension  (ex: REF_L_Batch_3454_2008y_02m_10d.txt)
  file_name += '.txt'
  
  putTextFieldValue, Event, 'save_as_file_name', file_name, 0
END

;+
; :Description:
;   this checks if the bash_table is not empty, if there is a batch file
;   name defined and then activate the save batch button
;
; :Params:
;    event
;
; :Author: j35
;-
pro activate_or_not_save_batch_button, event
  compile_opt idl2
  
  if (can_we_activate_batch_save_button(event)) then begin
    status = 1
  endif else begin
    status = 0
  endelse
  ActivateWidget, Event, 'save_as_file_button', status
  
  
end

;+
; :Description:
;   This procedure retrieves the contain of the batch file
;
; :Params:
;    BatchFileName
;    NbrLine
;
;
;
; :Author: j35
;-
FUNCTION PopulateFileArray_ref_m, BatchFileName, NbrLine
  compile_opt idl2
  
  openr, u, BatchFileName, /get
  onebyte = 0b
  tmp = ''
  i = 0
  NbrLine = getNbrLines(BatchFileName)
  FileArray = strarr(NbrLine)
  
  WHILE (NOT eof(u)) DO BEGIN
  
    readu,u,onebyte
    fs = fstat(u)
    
    IF (fs.cur_ptr EQ 0) THEN BEGIN
      point_lun,u,0
    ENDIF ELSE BEGIN
      point_lun,u,fs.cur_ptr - 1
    ENDELSE
    
    readf,u,tmp
    FileArray[i++] = tmp
    
  ENDWHILE
  
  close, u
  free_lun,u
  NbrElement = i                  ;nbr of lines
  
  RETURN, FileArray
END


;+
; :Description:
;   This procedure retrieves the information from the batch file to populate
;   the BatchTable_ref_m
;
; :Params:
;    Event
;    BatchFileName
;
; :Author: j35
;-
FUNCTION PopulateBatchTable_ref_m, Event, BatchFileName

  widget_control,event.top,get_uvalue=global
  
  populate_error = 0
  ;CATCH, populate_error
  NbrColumn = getGlobalVariable_ref_m('NbrColumn')
  NbrRow    = getGlobalVariable_ref_m('NbrRow')
  
  BatchTable = strarr(NbrColumn,NbrRow)
  FileArray = strarr(1)
  IF (populate_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    AppendReplaceLogBookMessage, Event, $
      (*global).FAILED, $
      (*global).processing_message
    LogText = '-> FileArray:'
    putLogBookMessage, Event, LogText, APPEND=1
    putLogBookMessage, Event, FileArray, APPEND=1
  ENDIF ELSE BEGIN
    NbrLine   = 0
    FileArray = PopulateFileArray_ref_m(BatchFileName, NbrLine)
    BatchIndex = -1             ;row index
    FileIndex  = 0
    NbrHeadingLines = getGlobalVariable_ref_m('BatchFileHeadingLines')
    WHILE (FileIndex LT NbrLine) DO BEGIN
      IF (FileIndex LT NbrHeadingLines) THEN BEGIN
        ;add work on header here
        ++FileIndex
      ENDIF ELSE BEGIN
        IF (FileArray[FileIndex] EQ '') THEN BEGIN
          ++BatchIndex
          ++FileIndex
        ENDIF ELSE BEGIN
          SplitArray = strsplit(FileArray[FileIndex],' : ', $
            /extract,$
            COUNT=length)
          CASE (SplitArray[0]) OF
            '#Active'    : BatchTable[0,BatchIndex] = SplitArray[1]
            '#Data_Runs' : BatchTable[1,BatchIndex] = SplitArray[1]
            '#Data_Spin_States': BatchTable[2,BatchIndex] = SplitArray[1]
            '#Norm_Runs' : BEGIN
              norm_error = 0
              CATCH,norm_error
              IF (norm_error NE 0) THEN BEGIN
                CATCH,/CANCEL
                BatchTable[3,BatchIndex] = ''
              ENDIF ELSE BEGIN
                BatchTable[3,BatchIndex] = SplitArray[1]
              ENDELSE
            END
            '#Norm_Spin_States' : BEGIN
              norm_error = 0
              CATCH,norm_error
              IF (norm_error NE 0) THEN BEGIN
                CATCH,/CANCEL
                BatchTable[4,BatchIndex] = ''
              ENDIF ELSE BEGIN
                BatchTable[4,BatchIndex] = SplitArray[1]
              ENDELSE
            END
            '#Angle(deg)': BEGIN
              angle_error = 0
              catch, angle_error
              if (angle_error ne 0) then begin
                catch,/cancel
                BatchTable[5,BatchIndex] = ''
              endif else begin
                BatchTable[5,BatchIndex] = SplitArray[1]
              endelse
            end
            '#Date'      : BatchTable[6,BatchIndex] = SplitArray[1]
            ;              STRJOIN(SplitArray[1:length-1],':')
            '#SF'        : BEGIN
              sz = (size(SplitArray))(1)
              IF (sz GT 1) THEN BEGIN
                BatchTable[7,BatchIndex] = SplitArray[1]
              ENDIF ELSE BEGIN
                BatchTable[7,BatchIndex] = ''
              ENDELSE
            END
          ELSE         : BEGIN
            if (splitArray[0] ne '') then begin
              cmd           = strjoin(SplitArray,' ')
              ;            CommentArray= strsplit(SplitArray[0],'#', $
              ;             /extract, $
              ;            COUNT=nbr)
              ;if (nbr gt 0) then begin
              BatchTable[8,BatchIndex] = cmd
            ;endif
            endif
          ;            SplitArray[0] =CommentArray[0]
          ;            cmd           = strjoin(SplitArray,' ')
          ;            ;check if "-o none" is there or not
          ;            IF (STRMATCH(cmd,'*-o none*')) THEN BEGIN
          ;              string_split = ' --batch -o none'
          ;            ENDIF ELSE BEGIN
          ;              string_split = ' --batch'
          ;            ENDELSE
          ;            cmd_array     = STRSPLIT(cmd, $
          ;              string_split, $
          ;              /EXTRACT, $
          ;              /REGEX,$
          ;              COUNT = length)
          ;            IF (length NE 0) THEN BEGIN
          ;              cmd = cmd_array[0] + ' ' + cmd_array[1]
          ;            ENDIF
          ;            BatchTable[8,BatchIndex] = cmd
          END
        ENDCASE
        ++FileIndex
      ENDELSE
    ENDELSE
  ENDWHILE
  AppendReplaceLogBookMessage, Event, 'OK', (*global).processing_message
ENDELSE
RETURN, BatchTable
END

;+
; :Description:
;   Loading Batch button
;
; :Params:
;    Event
;    BatchFileName
;    new_path
;
; :Author: j35
;-
PRO BatchTab_LoadBatchFile_ref_m_step2, Event, BatchFileName, new_path

  widget_control,event.top,get_uvalue=global
  
  IF (BatchFileName NE '') THEN BEGIN
    batch_error = 0
    CATCH, batch_error
    IF (batch_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      LogText = '> Application was unable to open the batch file '
      LogText += BatchFileName
      putLogBookMessage, Event, LogText, APPEND=1
      spawn, 'ls -l ' + BatchFileName, listening
      putLogBookMessage, Event, listening, APPEND=1
    ENDIF ELSE BEGIN
      LogText = '> Loading Batch File:'
      putLogBookMessage, Event, LogText, APPEND=1
      LogText = '-> File Name : ' + BatchFileName
      putLogBookMessage, Event, LogText, APPEND=1
      IF (new_path NE '') THEN BEGIN
        (*global).BatchDefaultPath = new_path
      ENDIF
      
      LogText = '-> Populate Batch Table ... ' + (*global).processing_message
      putLogBookMessage, Event, LogText, APPEND=1
      BatchTable = PopulateBatchTable_ref_m(Event, BatchFileName)
      (*(*global).BatchTable_ref_m) = BatchTable
      DisplayBatchTable_ref_M, Event, BatchTable
      (*global).BatchFileName = BatchFileName
      ;this function updates the widgets (button) of the tab

      command_line_generator_for_ref_m, event
      
      UpdateBatchTabGui_ref_m, Event
      RowSelected = (*global).PrevBatchRowSelected
      ;Update info of selected row
      DisplayInfoOfSelectedRow_ref_m, Event, RowSelected
      ;display path and file name of file in SAVE AS widgets
      FileArray = getFilePathAndName(BatchFileName)
      FilePath  = FileArray[0]
      FileName  = FileArray[1]
      ;put path in PATH button
      (*global).BatchDefaultPath = FilePath
      ;change name of button
      putBatchFolderName, Event, FilePath
      ;put name of file in widget_text
      putBatchFileName, Event, FileName
      ;put name of file in Refresh label
      putTextFieldValue, event, 'loaded_batch_file_name', BatchFileName, 0
;      ;enable or not the REPOPULATE Button
;      CheckRepopulateButton, Event
      ;enable or not the REFRESH Button
      CheckRefreshButton, Event

    ENDELSE
  ENDIF
END

;+
; :Description:
;   procedures that display the BatchTable in the Basch table
;
; :Params:
;    Event
;    BatchTable
;
;
;
; :Author: j35
;-
pro DisplayBatchTable_ref_m, Event, BatchTable
  live_BatchTable = BatchTable[0:8,*]
  NewBatchTable = BatchTable
  id = widget_info(Event.top,find_by_uname='batch_table_widget')
  widget_control, id, set_value=NewBatchTable
end

;+
; :Description:
;   remove the row selected
;
; :Params:
;    Event
;
; :Author: j35
;-
pro BatchTab_DeleteSelection_ref_m, Event

  widget_control,event.top,get_uvalue=global
  
  ;retrieve main table
  BatchTable = (*(*global).BatchTable_ref_m)
  ;current row selected
  RowSelected = (*global).PrevBatchRowSelected
  if (BatchTable[0,RowSelected] eq '') then return
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  FOR i = RowSelected, (RowIndexes-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
  ENDFOR
  ClearStructureFields_ref_m, BatchTable, RowIndexes
  (*(*global).BatchTable_ref_m) = BatchTable
  DisplayBatchTable_ref_m, Event, BatchTable
  ;this function updates the widgets (button) of the tab
  UpdateBatchTabGui_ref_m, Event
  DisplayInfoOfSelectedRow_ref_m, Event, RowSelected
  ;generate a new batch file name
  GenerateBatchFileName_ref_m, Event
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton_ref_m, Event
END

;+
; :Description:
;   cleanup the selected row and replace it with empty string array
;
; :Params:
;    BatchTable
;    CurrentBatchTableIndex
;
;
;
; :Author: j35
;-
pro ClearStructureFields_ref_m, BatchTable, CurrentBatchTableIndex
  compile_opt idl2
  
  resetArray = strarr(9)
  BatchTable[*,CurrentBatchTableIndex] = resetArray
END

;+
; :Description:
;   Check if the repopulate GUI can be validated or not
;
; :Params:
;    Event
;
; :Author: j35
;-
pro CheckRepopulateButton_ref_m, Event
  compile_opt idl2
  
  widget_control,event.top,get_uvalue=global
  BatchTable  = (*(*global).BatchTable_ref_m)
  SelectedRow = getCurrentRowSelected(Event)
  cmd         = BatchTable[8,SelectedRow]
  IF (cmd NE '') THEN BEGIN
    activateButtonStatus = 1
  ENDIF ELSE BEGIN
    activateButtonStatus = 0
  ENDELSE
  id = widget_info(Event.top,find_by_uname='repopulate_gui')
  widget_control, id, sensitive=activateButtonStatus
END

;+
; :Description:
;   check if there are any not 'N/A' command line, if yes, then activate
;   DELETE SELECTION, DELETE ACTIVE, RUN ACTIVE AND SAVE ACTIVE(S)
;
; :Params:
;    Event
;
; :Author: j35
;-
pro UpdateBatchTabGui_ref_m, Event
  compile_opt idl2
  
  ;check if delete active and save activte can be
  ;validated or not
  IF (isThereAnyDataActivate_ref_m(Event)) THEN BEGIN
    activateStatus = 1
    ;check if run active can be validated or not
    IF (isThereAnyCmdDefined_ref_m(Event)) THEN BEGIN
      activateStatus2 = 1
    ENDIF ELSE BEGIN
      activateStatus2 = 0
    ENDELSE
    activateRunActiveButton, Event, activateStatus2
  ENDIF ELSE BEGIN
    activateStatus = 0
    activateRunActiveButton, Event, activateStatus
  ENDELSE
  activateSaveActiveButton, Event, activateStatus
  activateSortrowsButton, event, activateStatus
  activateClearAllButton, event, activateStatus
  
  ;check if there is anything in the BatchTable
  IF (isThereAnyDataInBatchTable_ref_m(Event)) THEN BEGIN
    activateStatus = 1
  ENDIF ELSE BEGIN
    activateStatus = 0
  ENDELSE
  activateDeleteSelectionButton, Event, activateStatus
  
end


;+
; :Description:
;   This functions checks if the repopulate button can be enabled or not
;
; :Params:
;    Event
;
; :Author: j35
;-
PRO CheckRepopulateButton, Event
  compile_opt idl2
  
  widget_control,event.top,get_uvalue=global
  
  BatchTable  = (*(*global).BatchTable_ref_m)
  SelectedRow = getCurrentRowSelected(Event)
  cmd         = BatchTable[8,SelectedRow]
  IF (cmd NE '') THEN BEGIN
    activateButtonStatus = 1
  ENDIF ELSE BEGIN
    activateButtonStatus = 0
  ENDELSE
  id = widget_info(Event.top,find_by_uname='repopulate_gui')
  widget_control, id, sensitive=activateButtonStatus
END

;------------------------------------------------------------------------------
;This function gives the index of the current running batch row
;+
; :Description:
;   return the current working row of the REF_M batch table
;
; :Params:
;    Event
;
; :Author: j35
;-
function getCurrentWorkingRow_ref_m, Event
  ;get global structure
  widget_control,event.top,get_uvalue=global
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  BatchTable = (*(*global).BatchTable_ref_m)
  FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[0,i] EQ '> YES <' OR $
      BatchTable[0,i] EQ '> NO <') THEN RETURN, i
  ENDFOR
  RETURN, -1
end

;------------------------------------------------------------------------------
;This function gets the index of the row used to repopulate the GUI
;and makes this row as the current working row
PRO RepopulatedRowBecomesWorkingRow_ref_m, Event
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  BatchTable = (*(*global).BatchTable_ref_m)
  ;get current working row and change its status
  CurrentWorkingRow = getCurrentWorkingRow_ref_m(Event)
  IF (CurrentWorkingRow NE -1) THEN BEGIN
    CASE (BatchTable[0,CurrentWorkingRow]) OF
      '> YES <' : BatchTable[0,CurrentWorkingRow]='YES'
      '> NO <'  : BatchTable[0,CurrentWorkingRow]='NO'
      ELSE:
    ENDCASE
  ENDIF
  ;get current selected row
  CurrentSelectedRow = getCurrentRowSelected(Event)
  BatchTable[0,CurrentSelectedRow] = '> YES <'
  (*(*global).BatchTable_ref_m) = BatchTable
  ;This function updates the Batch tab GUI
  UpdateBatchTabGui_ref_m, Event
  ;This function repopulates the batch table with BatchTable
  DisplayBatchTable_ref_m, Event, BatchTable
  ;generate a new batch file name
  GenerateBatchFileName_ref_m, Event
END

