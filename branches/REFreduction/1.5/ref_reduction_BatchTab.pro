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
;**********************************************************************
;GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL
;**********************************************************************

;Procedure that will return all the global variables for this routine
FUNCTION getGlobalVariable, var
  CASE (var) OF
    ;number of columns in the Table (active/data/norm/s1/s2...)
    'ColumnIndexes' : RETURN, 9
    'NbrColumn'     : RETURN, 10
    'RowIndexes'    : RETURN, 19
    'NbrRow'        : RETURN, 20
    'BatchFileHeadingLines' : RETURN, 3
    ELSE:
  ENDCASE
  RETURN, 'NA'
END

;**********************************************************************
;UTILS - UTILS - UTILS - UTILS - UTILS - UTILS - UTILS - UTILS - UTILS
;**********************************************************************
FUNCTION PopulateFileArray, BatchFileName, NbrLine
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

;------------------------------------------------------------------------------
FUNCTION PopulateBatchTable, Event, BatchFileName
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  populate_error = 0
  CATCH, populate_error
  NbrColumn = getGlobalVariable('NbrColumn')
  NbrRow    = getGlobalVariable('NbrRow')
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
    FileArray = PopulateFileArray(BatchFileName, NbrLine)
    BatchIndex = -1             ;row index
    FileIndex  = 0
    NbrHeadingLines = getGlobalVariable('BatchFileHeadingLines')
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
            '#Norm_Runs' : BEGIN
              norm_error = 0
              CATCH,norm_error
              IF (norm_error NE 0) THEN BEGIN
                CATCH,/CANCEL
                BatchTable[2,BatchIndex] = ''
              ENDIF ELSE BEGIN
                BatchTable[2,BatchIndex] = SplitArray[1]
              ENDELSE
            END
            '#EC_Runs'   : BEGIN
              ec_error = 0
              CATCH, ec_error
              IF (ec_error NE 0) THEN BEGIN
                CATCH,/CANCEL
                BatchTable[3,BatchIndex] = ''
              ENDIF ELSE BEGIN
                BatchTable[3,BatchIndex] = SplitArray[1]
              ENDELSE
            END
            '#Angle(deg)': BatchTable[4,BatchIndex] = SplitArray[1]
            '#S1(mm)'    : BatchTable[5,BatchIndex] = SplitArray[1]
            '#S2(mm)'    : BatchTable[6,BatchIndex] = SplitArray[1]
            '#Date'      : BatchTable[7,BatchIndex] = $
              STRJOIN(SplitArray[1:length-1],':')
            '#SF'        : BEGIN
              sz = (size(SplitArray))(1)
              IF (sz GT 1) THEN BEGIN
                BatchTable[8,BatchIndex] = SplitArray[1]
              ENDIF ELSE BEGIN
                BatchTable[8,BatchIndex] = ''
              ENDELSE
            END
          ELSE         : BEGIN
            CommentArray= strsplit(SplitArray[0],'#', $
              /extract, $
              COUNT=nbr)
            SplitArray[0] =CommentArray[0]
            cmd           = strjoin(SplitArray,' ')
            ;check if "-o none" is there or not
            IF (STRMATCH(cmd,'*-o none*')) THEN BEGIN
              string_split = ' --batch -o none'
            ENDIF ELSE BEGIN
              string_split = ' --batch'
            ENDELSE
            cmd_array     = STRSPLIT(cmd, $
              string_split, $
              /EXTRACT, $
              /REGEX,$
              COUNT = length)
            IF (length NE 0) THEN BEGIN
              cmd = cmd_array[0] + ' ' + cmd_array[1]
            ENDIF
            BatchTable[9,BatchIndex] = cmd
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

;------------------------------------------------------------------------------
;This function takes the name of the output file to create
;and create the Batch output file
PRO CreateBatchFile, Event, FullFileName
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;get Text To copy
  BatchTable = (*(*global).BatchTable)
  NbrRow    = (size(BatchTable))(2)
  NbrColumn = (size(BatchTable))(1)
  text    = STRARR(1)
  text[0] = '#This Batch File has been produced by REFreduction ' + $
    (*global).REFreductionVersion
  text    = [text,'#Date : ' + RefReduction_GenerateIsoTimeStamp()]
  text    = [text,'#Ucams : ' + (*global).ucams]
  text    = [text,'']
  
  FOR i=0,(NbrRow-1) DO BEGIN
    ;add information only if row is not blank
    IF (BatchTable[0,i] NE '') THEN BEGIN
    
      IF (BatchTable[0,i] EQ 'NO' OR $
        BatchTable[0,i] EQ '> NO <') THEN BEGIN
        FP     = '#'
        active = 'NO'
      ENDIF ELSE BEGIN
        FP     = ''
        active = 'YES'
      ENDELSE
      
      text    = [text,'#Active : ' + active]
      k=1
      text    = [text,'#Data_Runs : ' + BatchTable[k++,i]]
      text    = [text,'#Norm_Runs : ' + BatchTable[k++,i]]
      text    = [text,'#EC_Runs : ' + BatchTable[k++,i]]
      text    = [text,'#Angle(deg) : ' + BatchTable[k++,i]]
      text    = [text,'#S1(mm) : ' + BatchTable[k++,i]]
      text    = [text,'#S2(mm) : ' + BatchTable[k++,i]]
      text    = [text,'#Date : ' + BatchTable[k++,i]]
      text    = [text,'#SF : ' + BatchTable[k++,i]]
      ;add --batch flag to command line
      cmd_array = strsplit(BatchTable[k++,i], 'srun ', /EXTRACT, /REGEX)
;      cmd       = 'srun --batch -o none' + cmd_array[0]
      text    = [text, FP+ cmd_array[0]]
      text    = [text, '']
      
    ENDIF
  ENDFOR
  file_error = 0
  CATCH, file_error
  IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    AppendReplaceLogBookMessage, Event, $
      (*global).FAILED, $
      (*global).processing_message
  ENDIF ELSE BEGIN
    ;create output file
    openw,1,FullFileName
    sz = (size(text))(1)
    FOR j=0,(sz-1) DO BEGIN
      printf, 1, text[j]
    ENDFOR
    close,1
    free_lun,1
    AppendReplaceLogBookMessage, Event, 'OK', (*global).processing_message
  ENDELSE
  
  IF (file_error EQ 0) THEN BEGIN
    permission_error = 0
    CATCH, permission_error
    IF (permission_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      LogText = '-> Give execute permission to file created ... FAILED'
    ENDIF ELSE BEGIN
      ;give execute permission to file created
      cmd = 'chmod 755 ' + FullFileName
      spawn, cmd, listening
      LogText = '-> Give execute permission to file created ... OK'
      (*global).BatchFileName = FullFileName
    ENDELSE
    putLogBookMessage, Event, LogText, APPEND=1
    ;Show contain of file
    LogText = '------------- BATCH FILE : ' + FullFileName + ' --------------'
    putLogBookMessage, Event, LogText, APPEND=1
    putLogBookMessage, Event, text, APPEND=1
  ENDIF
END

;------------------------------------------------------------------------------
FUNCTION UpdateOutputFlag, Event, new_cmd, DataRun
  split1      = '--output='
  ArraySplit1 = STRSPLIT(new_cmd,split1,/EXTRACT,/REGEX)
  part1       = ArraySplit1[0] + split1
  ;get path of output file name
  ArrayPath   = STRSPLIT(ArraySplit1[1],'/',/EXTRACT,COUNT=length)
  indexPath   = strsplit(ArraySplit1[1],'/', count=length_index)
  
  IF (length GT 1) THEN BEGIN
    path  = STRJOIN(ArrayPath[0:length-2],'/')
    if (indexPath[0] eq 1) then begin
    path = '/' + path
    endif
  ENDIF ELSE BEGIN
    path  = ArrayPath[0]
  ENDELSE

  ;create new output file name
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  NewFileName  = path + '/'
  instrument   = (*global).instrument
  NewFileName += instrument
  NewfileName += '_' + STRCOMPRESS(DataRun,/REMOVE_ALL)
  DateStamp    = GenerateDateStamp()
  NewfileName += '_' + DateStamp
  NewfileName += '.txt'
  
  ;recreate the cmd
  new_cmd = part1 + NewFileName
  RETURN, new_cmd
END


;**********************************************************************
;GET - GET - GET - GET - GET - GET - GET - GET - GET - GET - GET - GET
;**********************************************************************

;Return the current row selected
FUNCTION getCurrentRowSelected, Event
  id = Widget_Info(Event.top,find_by_uname='batch_table_widget')
  SelectedCell = widget_Info(id,/table_select)
  RowSelected  = SelectedCell[1]
  RETURN, RowSelected
END

;------------------------------------------------------------------------------
;This function determines the current table index
;It's +1 each time a new data is loaded and if the previous
;GO REDUCTION has been validated
FUNCTION getCurrentBatchTableIndex, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  CurrentBatchTableIndex = 0
  
  ;Move to next index only if previous GO DATA REDUCTION button has been
  ;validated
  IF ((*global).PreviousRunReductionValidated EQ 1) THEN BEGIN
  
    ;move up position of all other indexes in array (position)
    RowIndexes = getGlobalVariable('RowIndexes')
    FOR i=1,RowIndexes DO BEGIN
      k=(RowIndexes-i)
      BatchTable[*,k]=BatchTable[*,k-1]
      IF (CurrentBatchTableIndex EQ 20) THEN BEGIN
        CurrentBatchTableIndex = 0
        (*global).CurrentBatchTableIndex = CurrentBatchTableIndex
      ENDIF ELSE BEGIN
        (*global).CurrentBatchTableIndex = CurrentBatchTableIndex
      ENDELSE
    ENDFOR
  ENDIF
  RETURN, CurrentBatchTableIndex
END

;------------------------------------------------------------------------------
;This function returns the value of the status of the data run
FUNCTION getDataStatus, Event
  value = getTextFieldValue(Event,'batch_data_run_field_status')
  RETURN, value
END

;This function returns the value of the status of the norm run
FUNCTION getNormStatus, Event
  value = getTextFieldValue(Event,'batch_norm_run_field_status')
  RETURN, value
END

;------------------------------------------------------------------------------
;This function gives the index of the current running batch row
FUNCTION getCurrentWorkingRow, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  RowIndexes = getGlobalVariable('RowIndexes')
  BatchTable = (*(*global).BatchTable)
  FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[0,i] EQ '> YES <' OR $
      BatchTable[0,i] EQ '> NO <') THEN RETURN, i
  ENDFOR
  RETURN, -1
END

;------------------------------------------------------------------------------
;This function retrives the first run number of the top row input
FUNCTION GetMajorRunNumber, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  BatchTable = (*(*global).BatchTable)
  MajorRuns = BatchTable[1,0]
  MajorRunsArray = strsplit(MajorRuns,',',/extract)
  MajorRun = MajorRunsArray[0]
  RETURN, MajorRun
END

;------------------------------------------------------------------------------
;Retrieves the Batch Path
FUNCTION getBatchPath, Event
  id = widget_info(Event.top,find_by_uname='save_as_path')
  widget_control, id, get_value=path
  RETURN, Path
END

;------------------------------------------------------------------------------
;Retrieves the Batch File
FUNCTION getBatchFile, Event
  id = widget_info(Event.top,find_by_uname='save_as_file_name')
  widget_control, id, get_value=file
  RETURN, file
END

;**********************************************************************
;PUT - PUT - PUT - PUT - PUT - PUT - PUT - PUT - PUT - PUT - PUT - PUT
;**********************************************************************
PRO UpdateDataField, Event, value
  putTextFieldValue, Event, 'batch_data_run_field_status', value, 0
END

;------------------------------------------------------------------------------
PRO UpdateNormField, Event, value
  putTextFieldValue, Event, 'batch_norm_run_field_status', value, 0
END

;------------------------------------------------------------------------------
PRO UpdateAngleField, Event, value
  IF (value EQ '') THEN value = '?'
  text = 'Angle: ' + strcompress(value,/remove_all) + ' degrees'
  putTextFieldValue, Event, 'angle_value_status', text, 0
END

;------------------------------------------------------------------------------
PRO UpdateS1Field, Event, value
  IF (value EQ '') THEN value = '?'
  text = 'Slit 1: ' + strcompress(value,/remove_all) + ' mm'
  putTextFieldValue, Event, 's1_value_status', text, 0
END

;------------------------------------------------------------------------------
PRO UpdateS2Field, Event, value
  IF (value EQ '') THEN value = '?'
  text = 'Slit 2: ' + strcompress(value,/remove_all) + ' mm'
  putTextFieldValue, Event, 's2_value_status', text, 0
END

;------------------------------------------------------------------------------
PRO UpdateCMDField, Event, value
  putTextFieldValue, Event, 'cmd_status_preview', value, 0
END


;**********************************************************************
;IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS
;**********************************************************************
FUNCTION IsRowSelectedActive, RowSelected, BatchTable
  IF (BatchTable[0,RowSelected] EQ 'YES' OR $
    BatchTable[0,RowSelected] EQ '> YES <') THEN RETURN, 1
  RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION isItCurrentWorkingRow, RowSelected, BatchTable
  IF (BatchTable[0,RowSelected] EQ '> YES <' OR $
    BatchTable[0,RowSelected] EQ '> NO <') THEN RETURN, 1
  RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION IsAnyRowSelected, Event
  id = widget_info(Event.top,find_by_uname='batch_table_widget')
  Selection = widget_info(id,/table_select)
  ColumnIndexes = getGlobalVariable('ColumnIndexes')
  IF (Selection[2] EQ ColumnIndexes) THEN RETURN, 1
  RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION isThereAnyCmdDefined, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable = (*(*global).BatchTable)
  RowIndexes = getGlobalVariable('RowIndexes')
  FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[9,i] NE 'N/A' AND $
      BatchTable[9,i] NE '') THEN BEGIN
      RETURN,1
    ENDIF
  ENDFOR
  RETURN,0
END

;------------------------------------------------------------------------------
FUNCTION isThereAnyDataActivate, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable = (*(*global).BatchTable)
  RowIndexes = getGlobalVariable('RowIndexes')
  FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[0,i] EQ 'YES' OR $
      BatchTable[0,i] EQ '> YES <') THEN RETURN, 1
  ENDFOR
  RETURN,0
END

;------------------------------------------------------------------------------
FUNCTION isThereAnyDataInBatchTable, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable      = (*(*global).BatchTable)
  BatchTableReset = strarr(9,20)
  IF (ARRAY_EQUAL(BatchTable,BatchTableReset)) THEN RETURN, 0
  RETURN,1
END

;------------------------------------------------------------------------------
FUNCTION areDataIdentical, Event, DataArray
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  PercentError = (*global).batch_percent_error
  process_error = 0
  CATCH, process_error
  IF (process_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    bad_io:
    RETURN, 0
  ENDIF ELSE BEGIN
    sz = (size(DataArray))(1)
    FOR i=0,(sz-1) DO BEGIN
      ON_IOError, bad_io
      base_value = float(DataArray[i])
      FOR j=1,(sz-1) DO BEGIN
        comp_value = FLOAT(DataArray[j])
        diff       = ABS(comp_value - base_value)
        IF (diff GT PercentError) THEN BEGIN
          RETURN, 0
        ENDIF
      ENDFOR
    ENDFOR
  ENDELSE
  RETURN, 1
END

;**********************************************************************
;GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI
;**********************************************************************
;This function enables or not the REPOPULATE GUI button
PRO CheckRepopulateButton, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable  = (*(*global).BatchTable)
  SelectedRow = getCurrentRowSelected(Event)
  cmd         = BatchTable[9,SelectedRow]
  IF (cmd NE '') THEN BEGIN
    activateButtonStatus = 1
  ENDIF ELSE BEGIN
    activateButtonStatus = 0
  ENDELSE
  id = widget_info(Event.top,find_by_uname='repopulate_gui')
  widget_control, id, sensitive=activateButtonStatus
END

;-----------------------------------------------------------------------------
;This function check if the Batch file (from the text field) exist and
;if it does, make the refresh button enabled
PRO  CheckRefreshButton, Event
  BatchFileName = getTextFieldValue(Event,'loaded_batch_file_name')
  IF (FILE_TEST(BatchFileName) AND $
    BatchFileName NE '') THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  MapBase, Event, 'refresh_bash_base', status
END

;-----------------------------------------------------------------------------
;This function retrieves the row of the selected cell and select the
;full row
PRO SelectFullRow, Event, RowSelected
  ColumnIndexes = getGlobalVariable('ColumnIndexes')
  id = Widget_Info(Event.top,find_by_uname='batch_table_widget')
  widget_control, id, set_table_select=[0,RowSelected,ColumnIndexes,RowSelected]
END

;-----------------------------------------------------------------------------
PRO ValidateActive, Event, value
  id = widget_info(Event.top,find_by_uname='batch_run_active_status')
  widget_control, id, set_value=value
END

;-----------------------------------------------------------------------------
FUNCTION ValueOfActive, Event
  id = widget_info(Event.top,find_by_uname='batch_run_active_status')
  widget_control, id, get_value=value
  RETURN, value
END

;------------------------------------------------------------------------------
PRO DisplayBatchTable, Event, BatchTable
  ;get global structure
  widget_control,Event.top,get_uvalue=global
  ;new BatchTable
  NewBatchTable = BatchTable
  id = widget_info(Event.top,find_by_uname='batch_table_widget')
  ;display only the first part of the cmd line
  NbrRow = getGlobalVariable('NbrRow')
  length = (*global).cmd_batch_length
  FOR i=0,(NbrRow-1) DO BEGIN
    sz = STRLEN(BatchTable[9,i])
    IF (sz GT length) THEN BEGIN
      NewBatchTable[9,i] = STRMID(BatchTable[9,i],0,length) + '  (...) '
    ENDIF
  ENDFOR
  widget_control, id, set_value=NewBatchTable
END

;------------------------------------------------------------------------------
;This function reset all the structure fields of the current index
PRO ClearStructureFields, BatchTable, CurrentBatchTableIndex
  resetArray = strarr(10)
  BatchTable[*,CurrentBatchTableIndex] = resetArray
END

;------------------------------------------------------------------------------
;This function activates or not the MOVE DOWN SELECTION button
PRO activateDownButton, Event, status
  id = widget_info(Event.top,find_by_uname='move_down_selection_button')
  widget_control, id, sensitive=status
END

;------------------------------------------------------------------------------
;This function activates or not the MOVE UP SELECTION button
PRO activateUpButton, Event, status
  id = widget_info(Event.top,find_by_uname='move_up_selection_button')
  widget_control, id, sensitive=status
END

;------------------------------------------------------------------------------
;This function activates or not the DELETE SELECTION button
PRO activateDeleteSelectionButton, Event, status
  id = widget_info(Event.top,find_by_uname='delete_selection_button')
  widget_control, id, sensitive=status
END

pro activateClearAllButton, event, status
  id = widget_info(Event.top,find_by_uname='batch_clear_all')
  widget_control, id, sensitive=status
end

pro activateSortrowsButton, event, status
  id = widget_info(Event.top,find_by_uname='batch_sort_rows')
  widget_control, id, sensitive=status
end

;------------------------------------------------------------------------------
;This function activates or not the DELETE ACTIVE button
PRO activateDeleteActiveButton, Event, status
  id = widget_info(Event.top,find_by_uname='delete_active_button')
  widget_control, id, sensitive=status
END

;------------------------------------------------------------------------------
;This function activates or not the RUN ACTIVE buttons
PRO activateRunActiveButton, Event, status
  id = widget_info(Event.top,find_by_uname='run_active_button')
  widget_control, id, sensitive=status
  id = widget_info(Event.top,find_by_uname='run_active_background_button')
  widget_control, id, sensitive=status
END

;------------------------------------------------------------------------------
;This function activates or not the SAVE ACTIVE button
PRO activateSaveActiveButton, Event, status
  id = widget_info(Event.top,find_by_uname='save_as_file_button')
  widget_control, id, sensitive=status
END

;------------------------------------------------------------------------------
;This function removes the given row from the BatchTable
PRO RemoveGivenRowInBatchTable, BatchTable, Row
  RowIndexes = getGlobalVariable('RowIndexes')
  FOR i = Row, (RowIndexes-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
  ENDFOR
  ClearStructureFields, BatchTable, RowIndexes
END

;------------------------------------------------------------------------------
;This function insert a clear row on top of batchTable and move
;everything else down
PRO AddBlankRowInBatchTable, BatchTable
  RowIndexes = getglobalVariable('RowIndexes')
  FOR i = 0, RowIndexes-1 DO BEGIN
    k=(RowIndexes-i)
    BatchTable[*,k]=BatchTable[*,k-1]
  ENDFOR
  ClearStructureFields, BatchTable, 0
END

;------------------------------------------------------------------------------
;This function changes the label of the Batch Folder button
PRO putBatchFolderName, Event, new_path
  id = widget_info(Event.top,find_by_uname='save_as_path')
  widget_control, id, set_value=new_path
END

;------------------------------------------------------------------------------
PRO GenerateBatchFileName, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get first part (ex: REF_L_Batch_ )
  file_name = (*global).instrument
  file_name += '_Batch_'
  
  ;add first run number loaded (first row)
  ;(ex: REF_L_Batch_Run3454 )
  MainRunNumber = GetMajorRunNumber(Event)
  file_name += 'Run' + strcompress(MainRunNumber,/remove_all)
  
  ;add time stamp (ex: REF_L_Batch_3454_2008y_02m_10d )
  TimeBatchFormat = RefReduction_GenerateIsoTimeStamp()
  file_name += '_' + TimeBatchFormat
  
  ;add extension  (ex: REF_L_Batch_3454_2008y_02m_10d.txt)
  file_name += '.txt'
  
  putTextFieldValue, Event, 'save_as_file_name', file_name, 0
END

;------------------------------------------------------------------------------
;check if there are any not 'N/A' command line, if yes, then activate
;DELETE SELECTION, DELETE ACTIVE, RUN ACTIVE AND SAVE ACTIVE(S)
PRO UpdateBatchTabGui, Event

  ;check if delete active and save activte can be
  ;validated or not
  IF (isThereAnyDataActivate(Event)) THEN BEGIN
    activateStatus = 1
    ;check if run active can be validated or not
    IF (isThereAnyCmdDefined(Event)) THEN BEGIN
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
  
  ;check if there is anything in the BatchTable
  IF (isThereAnyDataInBatchTable(Event)) THEN BEGIN
    activateStatus = 1
  ENDIF ELSE BEGIN
    activateStatus = 0
  ENDELSE
  activateDeleteSelectionButton, Event, activateStatus
  activateClearAllButton, event, activateStatus
  activateSortRowsButton, event, activateStatus
  
END

;------------------------------------------------------------------------------
;This function displays all the fields of the current selected row
;in the INPUT base below the main batch table
PRO DisplayInfoOfSelectedRow, Event, RowSelected

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get BatchTable value
  BatchTable = (*(*global).BatchTable)
  
  IF (RowSelected EQ -1) THEN BEGIN ;clear input base
  
    UpdateDataField,  Event, ''
    UpdateNormField,  Event, ''
    UpdateAngleField, Event, ''
    UpdateS1Field,    Event, ''
    UpdateS2Field,    Event, ''
    ;UpdateDateField,  Event, BatchTable[6,RowSelected]
    UpdateCMDField,   Event, ''
    
  ENDIF ELSE BEGIN
  
    IF (isRowSelectedActive(RowSelected,BatchTable)) THEN BEGIN
      ValidateActive, Event, 0
    ENDIF ELSE BEGIN
      ValidateActive, Event, 1
    ENDELSE
    
    UpdateDataField,  Event, BatchTable[1,RowSelected]
    id = WIDGET_INFO(Event.top,find_by_uname='batch_norm_run_base_status')
    IF (BatchTable[2,RowSelected] EQ '') THEN BEGIN ;remove norm widgets
      map_status = 0
    ENDIF ELSE BEGIN ;add norm widgets
      map_status = 1
    ENDELSE
    WIDGET_CONTROL, id, MAP=map_status
    
    UpdateNormField,  Event, BatchTable[2,RowSelected]
    UpdateAngleField, Event, BatchTable[4,RowSelected]
    UpdateS1Field,    Event, BatchTable[5,RowSelected]
    UpdateS2Field,    Event, BatchTable[6,RowSelected]
    ;UpdateDateField,  Event, BatchTable[7,RowSelected]
    UpdateCMDField,   Event, BatchTable[9,RowSelected]
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
;This function will use the instance of the class to populate the
;structure with angle, S1, S2 values
PRO PopulateBatchTableWithClassInfo, Table, instance
  Table[4,0] = strcompress(instance->getAngle(),/remove_all)
  Table[5,0] = strcompress(instance->getS1(),/remove_all)
  Table[6,0] = strcompress(instance->getS2(),/remove_all)
  Table[1,0] = strcompress(instance->getRunNumber(),/REMOVE_ALL)
END

;------------------------------------------------------------------------------
;This function get the info from the GUI (data run number and time) to
;update the new row (index 0) of BatchTable
PRO PopulateBatchTableWithGuiInfo, Event, BatchTable
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  DataRunNumber   = (*global).DataRunNumber
  TimeBatch       = GenerateDateStamp()
  BatchTable[7,0] = strcompress(TimeBatch,/remove_all)
END

;------------------------------------------------------------------------------
;This function populates the index 0 with others infos (NORM and command line)
PRO PopulateBatchTableWithOthersInfo, Event, BatchTable
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;remove old current working row
  RowIndexes = getGlobalVariable('RowIndexes')
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
  BatchTable[9,0] = 'N/A'  ;cmd
END

;------------------------------------------------------------------------------
;This function gets the index of the row used to repopulate the GUI
;and makes this row as the current working row
PRO RepopulatedRowBecomesWorkingRow, Event
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  RowIndexes = getGlobalVariable('RowIndexes')
  BatchTable = (*(*global).BatchTable)
  ;get current working row and change its status
  CurrentWorkingRow = getCurrentWorkingRow(Event)
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
  (*(*global).BatchTable) = BatchTable
  ;This function updates the Batch tab GUI
  UpdateBatchTabGui, Event
  ;This function repopulates the batch table with BatchTable
  DisplayBatchTable, Event, BatchTable
  ;generate a new batch file name
  GenerateBatchFileName, Event
END

;------------------------------------------------------------------------------
;This function populate the working row with the command line
PRO PopulateBatchTableWithCMDinfo, Event, cmd
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable = (*(*global).BatchTable)
  workingRow = getCurrentWorkingRow(Event)
  IF (workingRow NE -1) THEN BEGIN
    BatchTable[9,workingRow]=cmd
  ENDIF
  (*(*global).BatchTable) = BatchTable
END

;------------------------------------------------------------------------------
;This function takes a strarr and return a string list of runs comma
;separated
FUNCTION create_list_OF_runs, run_array
  result = STRJOIN(run_array,',')
  RETURN, result
END
;------------------------------------------------------------------------------
;populate index 0 with all Data and Norm run numbers
PRO PopulateBatchTableWithDataNormRunNumbers, Event, BatchTable
  ;get Data Nexus files
  DataRuns        = getTextFieldValue(Event,'reduce_data_runs_text_field')
  IF (DataRuns NE '') THEN BEGIN
    DataRunsArray   = get_runs_from_NeXus_full_path(DataRuns, 'data')
    DataRunsString  = create_list_OF_runs(DataRunsArray)
    BatchTable[1,0] = STRCOMPRESS(DataRunsString,/REMOVE_ALL)
  ENDIF
  
  ;get Norm Nexus Files
  NormRuns        = getTextFieldValue(Event, $
    'reduce_normalization_runs_text_field')
  IF (NormRuns NE '') THEN BEGIN
    NormRunsArray   = get_runs_from_NeXus_full_path(NormRuns, 'norm')
    NormRunsString  = create_list_OF_runs(NormRunsArray)
    BatchTable[2,0] = STRCOMPRESS(NormRunsString,/REMOVE_ALL)
  ENDIF
END

;------------------------------------------------------------------------------
;This function is reached by the all_events of the main table in the
;batch tab
PRO BatchTab_WidgetTable, Event

  ;print, 'Entering BatchTab_WidgetTable'

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  rowSelected = getCurrentRowSelected(Event)
  ;Select Full Row
  SelectFullRow, Event, RowSelected
  IF (RowSelected LT 10) THEN BEGIN
    id = widget_info(Event.top,find_by_uname='batch_table_widget')
    widget_control, id, set_table_view=[0,0]
  ENDIF
  ;validate or not UP and DOWN buttons
  IF ((RowSelected) EQ 0) THEN BEGIN
    activateUpButtonStatus = 0
  ENDIF ELSE BEGIN
    activateUpButtonStatus = 1
  ENDELSE
  activateUpButton, Event, activateUpButtonStatus
  RowIndexes = getGlobalVariable('RowIndexes')
  IF ((RowSelected) EQ RowIndexes) THEN BEGIN
    activateDownButtonStatus = 0
  ENDIF ELSE BEGIN
    activateDownButtonStatus = 1
  ENDELSE
  activateDownButton, Event, activateDownButtonStatus
  ;display info of selected row in INPUT base
  IF (rowSelected NE (*global).PrevBatchRowSelected) THEN BEGIN
    DisplayInfoOfSelectedRow, Event, RowSelected
    (*global).PrevBatchRowSelected = rowSelected
  ENDIF
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton, Event
  SaveDataNormInputValues, Event  ;_batchDataNorm
  
;print, 'Leaving BatchTab_WidgetTable'
  
END

;------------------------------------------------------------------------------
PRO BatchTab_ActivateRow, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve main table
  BatchTable = (*(*global).BatchTable)
  ;current row selected
  RowSelected = (*global).PrevBatchRowSelected
  ;get value of active_button
  isCurrentWorking = isItCurrentWorkingRow(RowSelected,BatchTable)
  ActiveValue      = ValueOfActive(Event)
  
  ;if empty row
  if (strcompress(BatchTable[0,RowSelected],/remove_all) eq '') then return
  ;get status of active or not (from BatchTable)
  ActiveSelection = isRowSelectedActive(RowSelected,BatchTable)
  
  ;get status of active or not (from BatchTable)
  ActiveSelection = isRowSelectedActive(RowSelected,BatchTable)
  IF (ABS(activeValue - ActiveSelection) NE 1) THEN BEGIN
    IF (activeValue EQ 0) THEN BEGIN
      IF (isCurrentWorking) THEN BEGIN
        BatchTable[0,RowSelected]='> YES <'
      ENDIF ELSE BEGIN
        BatchTable[0,RowSelected]='YES'
      ENDELSE
    ENDIF ELSE BEGIN
      IF (isCurrentWorking) THEN BEGIN
        BatchTable[0,RowSelected]='> NO <'
      ENDIF ELSE BEGIN
        BatchTable[0,RowSelected]='NO'
      ENDELSE
    ENDELSE
    (*(*global).BatchTable) = BatchTable
    DisplayBatchTable, Event, BatchTable
  ENDIF
  UpdateBatchTabGui, Event
  ;generate a new batch file name
  GenerateBatchFileName, Event
END

;------------------------------------------------------------------------------
PRO BatchTab_MoveUpSelection, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve main table
  BatchTable = (*(*global).BatchTable)
  ;current row selected
  RowSelected = (*global).PrevBatchRowSelected
  IF (RowSelected NE 0) THEN BEGIN ;move up
    ;get current array at row selected
    ArrayFrom = BatchTable[*,RowSelected]
    ;get array at (row-1) selected
    ArrayTo   = BatchTable[*,RowSelected-1]
    ;switch values between row selected and previous row
    BatchTable[*,RowSelected]   = ArrayTo
    BatchTable[*,RowSelected-1] = ArrayFrom
    ;display new table and save it
    DisplayBatchTable, Event, BatchTable
    (*(*global).BatchTable) = BatchTable
    ;select previous row and save it as new selection
    SelectFullRow, Event, (RowSelected-1)
    (*global).PrevBatchRowSelected = (RowSelected-1)
    ;activate down selection button
    activateDownButton, Event, 1
  ENDIF
  IF ((RowSelected-1) EQ 0) THEN BEGIN
    activateUpButtonStatus = 0
  ENDIF ELSE BEGIN
    activateUpButtonStatus = 1
  ENDELSE
  activateUpButton, Event, activateUpButtonStatus
  ;generate a new batch file name
  GenerateBatchFileName, Event
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton, Event
END

;------------------------------------------------------------------------------
PRO BatchTab_MoveDownSelection, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve main table
  BatchTable = (*(*global).BatchTable)
  ;current row selected
  RowSelected = (*global).PrevBatchRowSelected
  RowIndexes = getGlobalVariable('RowIndexes')
  IF (RowSelected NE RowIndexes) THEN BEGIN ;move down
    ;get current array at row selected
    ArrayFrom = BatchTable[*,RowSelected]
    ;get array at (row+1) selected
    ArrayTo   = BatchTable[*,RowSelected+1]
    ;switch values between row selected and previous row
    BatchTable[*,RowSelected]   = ArrayTo
    BatchTable[*,RowSelected+1] = ArrayFrom
    ;display new table and save it
    DisplayBatchTable, Event, BatchTable
    (*(*global).BatchTable) = BatchTable
    ;select previous row and save it as new selection
    SelectFullRow, Event, (RowSelected+1)
    (*global).PrevBatchRowSelected = (RowSelected+1)
    ;activate up selection button
    activateUpButton, Event, 1
  ENDIF
  IF ((RowSelected+1) EQ RowIndexes) THEN BEGIN
    activateDownButtonStatus = 0
  ENDIF ELSE BEGIN
    activateDownButtonStatus = 1
  ENDELSE
  activateDownButton, Event, activateDownButtonStatus
  ;generate a new batch file name
  GenerateBatchFileName, Event
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton, Event
END

;------------------------------------------------------------------------------
;This method will remove from the main table all the info of the
;current selected element
PRO BatchTab_DeleteSelection, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve main table
  BatchTable = (*(*global).BatchTable)
  ;current row selected
  RowSelected = (*global).PrevBatchRowSelected
  RowIndexes = getGlobalVariable('RowIndexes')
  FOR i = RowSelected, (RowIndexes-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
  ENDFOR
  ClearStructureFields, BatchTable, RowIndexes
  (*(*global).BatchTable) = BatchTable
  DisplayBatchTable, Event, BatchTable
  ;this function updates the widgets (button) of the tab
  UpdateBatchTabGui, Event
  DisplayInfoOfSelectedRow, Event, RowSelected
  ;generate a new batch file name
  GenerateBatchFileName, Event
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton, Event
END

;------------------------------------------------------------------------------
;Display a warning banner that inform the user that he is about to
;clear all the active fields
PRO BatchTab_WarningDeleteActive, Event
  message = 'Do you really want to remove all the ACTIVE rows ?'
  title   = 'DELETE ACTIVE ROWS WARNING !'
  result = DIALOG_MESSAGE(message,$
    /QUESTION,$
    TITLE = title)
  IF (result EQ 'Yes') THEN BEGIN
    BatchTab_DeleteActive, Event
  ENDIF
END

;------------------------------------------------------------------------------
;This method will remove from the main table all the row that have
;been activated
PRO BatchTab_DeleteActive, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve main table
  BatchTable = (*(*global).BatchTable)
  RowIndexes = getGlobalVariable('RowIndexes')
  FOR i = 0,(RowIndexes) DO BEGIN
    k = (RowIndexes-i)
    IF (BatchTable[0,k] EQ 'YES' OR $
      BatchTable[0,k] EQ '> YES <') THEN BEGIN
      
      IF (k EQ RowIndexes) THEN BEGIN
        ClearStructureFields, BatchTable, k
      ENDIF ELSE BEGIN
        FOR j = k, (RowIndexes-1) DO BEGIN
          BatchTable[*,j]=BatchTable[*,j+1]
        ENDFOR
      ENDELSE
    ENDIF
  ENDFOR
  (*(*global).BatchTable) = BatchTable
  DisplayBatchTable, Event, BatchTable
  RowSelected = (*global).PrevBatchRowSelected
  DisplayInfoOfSelectedRow, Event, RowSelected
  ;this function updates the widgets (button) of the tab
  UpdateBatchTabGui, Event
  ;generate a new batch file name
  GenerateBatchFileName, Event
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton, Event
END

;------------------------------------------------------------------------------
PRO BatchTab_RunActive, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;Parameters --------------------------
  progress_bar_1_color = long(0.75 * !D.N_COLORS) ;blue bright
  progress_bar_2_color = long(0.5 * !D.N_COLORS)  ;blue dark
  ;-------------------------------------
  
  LogText = '> Running Active Fields of Batch Table: '
  putLogBookMessage, Event, LogText, APPEND=1
  
  BatchTable = (*(*global).BatchTable)
  NbrRow = getGlobalVariable('RowIndexes')
  ;select progress bar widget_draw
  ;background of previous work
  id_draw = widget_info(Event.top, find_by_uname='progress_bar_draw_1')
  widget_control, id_draw, get_value=id_value
  
  ;background of current work
  id_draw2 = widget_info(Event.top, find_by_uname='progress_bar_draw_2')
  widget_control, id_draw2, get_value=id_value2
  
  ;display Progress Bar base
  MapBase, Event, 'progress_bar_base',1
  
  ;turn on hourglass
  widget_control,/hourglass
  ;change label of RUN ACTIVE button
  PutTextFieldValue, Event, 'run_active_button', $
    (*global).processing_message + $
    ' ... ', 0
  ActivateWidget, Event, 'run_active_button', 0
  ;determine the number of process to run
  NbrProcess = 0
  FOR i=0,NbrRow DO BEGIN
    IF (BatchTable[0,i] EQ '> YES <' OR $
      BatchTable[0,i] EQ 'YES') THEN BEGIN
      ++NbrProcess
    ENDIF
  ENDFOR
  ProcessToRun = 1 ;++1 for only the active processes
  IF (NbrProcess NE 0) THEN BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='progress_bar_draw')
    geometry = WIDGET_INFO(id, /GEOMETRY)
    xmax     = geometry.xsize
    x_step   = (xmax/float(NbrProcess))
    x2       = (x_step)
    ChangeSizeOfDraw, Event, $
      'progress_bar_draw_1', $
      1,$
      progress_bar_1_color
      
    ;middle progress bar
    ChangeSizeOfDraw, Event, $
      'progress_bar_draw_2', $
      x2,$
      progress_bar_2_color
      
    FOR i=0,NbrRow DO BEGIN
      IF (BatchTable[0,i] EQ '> YES <' OR $
        BatchTable[0,i] EQ 'YES') THEN BEGIN
        
        info = 'Working on ' + strcompress(ProcessToRun,/remove_all) + $
          '/' + strcompress(NbrProcess,/remove_all)
        putTextFieldValue, Event, 'progress_bar_label', info, 0
        
        LogText = '-> Running command ' + $
          strcompress(ProcessToRun,/remove_all) $
          + '/' + strcompress(NbrProcess,/remove_all)
        putLogBookMessage, Event, LogText, APPEND=1
        LogText = '--> Command is: ' + BatchTable[9,i]
        putLogBookMessage, Event, LogText, APPEND=1
        LogText = '--> Running ... ' + (*global).processing_message
        putLogBookMessage, Event, LogText, APPEND=1
        run_error = 0
        CATCH, run_error
        IF (run_error NE 0) THEN BEGIN
          CATCH,/CANCEL
          AppendReplaceLogBookMessage, Event, (*global).FAILED, $
            (*global).processing_message
        ENDIF ELSE BEGIN
          spawn, BatchTable[9,i], listening, err_listening
          IF (err_listening[0] NE '') THEN BEGIN
            AppendReplaceLogBookMessage, Event, (*global).FAILED, $
              (*global).processing_message
            LogText = '--> ERROR MESSAGE:'
            putLogBookMessage, Event, LogText, APPEND=1
            putLogBookMessage, Event, err_listening, APPEND=1
          ENDIF ELSE BEGIN
            AppendReplaceLogBookMessage, Event, 'OK', $
              (*global).processing_message
          ENDELSE
        ENDELSE
        
        ;top progress bar
        x2 = (ProcessToRun)*(x_step)
        ChangeSizeOfDraw, Event, $
          'progress_bar_draw_1', $
          x2,$
          progress_bar_1_color
          
        ++ProcessToRun
        
        ;middle progress bar
        x2 = (ProcessToRun)*(x_step)
        ChangeSizeOfDraw, Event, $
          'progress_bar_draw_2', $
          x2,$
          progress_bar_2_color
          
      ENDIF
    ENDFOR
    ;turn off hourglass
    widget_control,hourglass=0
    ActivateWidget, Event, 'run_active_button', 1
    PutTextFieldValue, Event, 'run_active_button', 'RUN ACTIVE', 0
  ENDIF
  ;display Progress Bar base
  MapBase, Event, 'progress_bar_base',0 ;change to 0
END

;------------------------------------------------------------------------------
;This function is reached by the [RUN ACTIVE in BACKGROUND] button
PRO BatchTab_RunActiveBackground, Event
  ActivateWidget, Event, 'run_active_background_button', 0
  
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  BatchTable = (*(*global).BatchTable)
  NbrRow     = getGlobalVariable('RowIndexes')
  PROCESSING = (*global).processing_message
  FAILED     = (*global).failed
  OK         = (*global).ok
  
  IF ((*global).with_job_manager EQ 'yes') THEN BEGIN
    LogText = '> Running Active Fields of Batch Table in Background using JOB' + $
      ' Manager: '
    putLogBookMessage, Event, LogText, APPEND=1
    ;retrieve parameters
    ucams             = (*global).ucams
    application       = (*global).application
    instrument        = (*global).instrument
    xml_file_location = (*global).xml_file_location
    job_manager_cmd   = (*global).job_manager_cmd
    ;display parameters
    LogText = '-> ucams            : ' + ucams
    putLogBookMessage, Event, LogText, APPEND=1
    LogText = '-> application      : ' + application
    putLogBookMessage, Event, LogText, APPEND=1
    LogText = '-> instrument       : ' +  instrument
    putLogBookMessage, Event, LogText, APPEND=1
    LogText = '-> xml_file_location: ' + xml_file_location
    putLogBookMessage, Event, LogText, APPEND=1
    LogText = '-> job_manager_cmd  : ' + job_manager_cmd
    putLogBookMessage, Event, LogText, APPEND=1
  ENDIF ELSE BEGIN
    LogText = '> Running Active Fields of Batch Table in Background using SLURM: '
    putLogBookMessage, Event, LogText, APPEND=1
  ENDELSE
  
  ;turn on hourglass
  WIDGET_CONTROL,/HOURGLASS
  
  ;determine the number of process to run (nbr of job to launch)
  NbrProcess = 0
  FOR i=0,NbrRow DO BEGIN
    IF (BatchTable[0,i] EQ '> YES <' OR $
      BatchTable[0,i] EQ 'YES') THEN BEGIN
      ++NbrProcess
    ENDIF
  ENDFOR
  ProcessToRun = 1
  IF (NbrProcess NE 0) THEN BEGIN
    FOR i=0,NbrRow DO BEGIN
      IF (BatchTable[0,i] EQ '> YES <' OR $
        BatchTable[0,i] EQ 'YES') THEN BEGIN
        
        ;Using Job Manager
        IF ((*global).with_job_manager EQ 'yes') THEN BEGIN
        
          LogText = '-> Create XML file OF ' + $
            STRCOMPRESS(ProcessToRun,/REMOVE_ALL) + $
            '/' + STRCOMPRESS(NbrProcess,/REMOVE_ALL) + $
            ' ... ' + PROCESSING
          putLogBookMessage, Event, LogText, APPEND=1
          run_error = 0
          ;               CATCH, run_error
          IF (run_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            AppendReplaceLogBookMessage, Event, FAILED, PROCESSING
          ENDIF ELSE BEGIN
            ;create the XML file
            oXML = OBJ_NEW('IDLcreateXMLJobFile',$
              APPLICATION       = application,$
              INSTRUMENT        = instrument,$
              UCAMS             = ucams,$
              XML_FILE_LOCATION = xml_file_location,$
              COMMAND_LINE      = BatchTable[9,i])
            AppendReplaceLogBookMessage, Event, OK, PROCESSING
            xml_file_name = oXML->getFullXmlFileName()
            LogText = '-> XML file is : ' + xml_file_name
            putLogBookMessage, Event, LogText, APPEND=1
            ;Launch the job
            cmd = job_manager_cmd + xml_file_name + ' 2> /dev/null'
            LogText = '--> Launch job using cmd : ' + cmd
            putLogBookMessage, Event, LogText, APPEND=1
            LogText = '---> Launching cmd ... ' + PROCESSING
            putLogBookMessage, Event, LogText, APPEND=1
            spawn, cmd, listening, err_listening
            IF (err_listening[0] NE '') THEN BEGIN
              AppendReplaceLogBookMessage, Event, FAILED, PROCESSING
            ENDIF ELSE BEGIN
              AppendReplaceLogBookMessage, Event, OK, PROCESSING
            ENDELSE
          ENDELSE
          
        ENDIF ELSE BEGIN
        
          LogText = '-> Launching command ' + $
            strcompress(ProcessToRun,/remove_all) $
            + '/' + strcompress(NbrProcess,/remove_all)
          putLogBookMessage, Event, LogText, APPEND=1
          run_error = 0
          CATCH, run_error
          IF (run_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            AppendReplaceLogBookMessage, Event, (*global).FAILED, $
              (*global).processing_message
          ENDIF ELSE BEGIN ;add --batch just after srun
            cmd       = BatchTable[9,i] + ' &'
;            cmd_array = STRSPLIT(cmd,'srun',/extract,/regex)
;            cmd       = 'srun --batch -o none' + cmd_array[0]
            LogText = '--> Command is: ' + cmd
            putLogBookMessage, Event, LogText, APPEND=1
            spawn, cmd, listening, err_listening
            IF (err_listening[0] NE '') THEN BEGIN
            ENDIF ELSE BEGIN
            ENDELSE
          ENDELSE
          ++ProcessToRun
          
        ENDELSE
      ENDIF
    ENDFOR
    
    ;turn off hourglass
    widget_control,hourglass=0
    ActivateWidget, Event, 'run_active_background_button', 1
  ENDIF
END

;------------------------------------------------------------------------------
PRO BatchTab_LoadBatchFile, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchFileName = DIALOG_PICKFILE(TITLE    = 'Pick Batch File to load ...',$
    PATH     = (*global).BatchDefaultPath,$
    dialog_parent = id,$
    FILTER   = (*global).BatchDefaultFileFilter,$
    GET_PATH = new_path,$
    /MUST_EXIST)
  BatchTab_LoadBatchFile_step2, Event, $
    BatchFileName, $
    new_path
END

;------------------------------------------------------------------------------
PRO BatchTab_ReloadBatchFile, Event
  BatchFileName = getTextFieldValue(Event,'loaded_batch_file_name')
  BatchTab_LoadBatchFile_step2, Event, BatchFileName, ''
END

;------------------------------------------------------------------------------
PRO BatchTab_LoadBatchFile_step2, Event, BatchFileName, new_path
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
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
      BatchTable = PopulateBatchTable(Event, BatchFileName)
      (*(*global).BatchTable) = BatchTable
      DisplayBatchTable, Event, BatchTable
      (*global).BatchFileName = BatchFileName
      ;this function updates the widgets (button) of the tab
      UpdateBatchTabGui, Event
      RowSelected = (*global).PrevBatchRowSelected
      ;Update info of selected row
      DisplayInfoOfSelectedRow, Event, RowSelected
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
      ;enable or not the REPOPULATE Button
      CheckRepopulateButton, Event
      ;enable or not the REFRESH Button
      CheckRefreshButton, Event
    ENDELSE
  ENDIF
END

;------------------------------------------------------------------------------
;Define where the Batch File will be created
PRO BatchTab_BrowsePath, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  new_path = DIALOG_PICKFILE(/DIRECTORY,$
    TITLE = 'Pick output folder name ...',$
    dialog_parent = id,$
    PATH  = (*global).BatchDefaultPath,$
    /MUST_EXIST)
    
  IF (new_path NE '') THEN BEGIN
    (*global).BatchDefaultPath = new_path
    ;change name of button
    putBatchFolderName, Event, new_path
  ENDIF
END

;------------------------------------------------------------------------------
PRO BatchTab_SaveCommands, Event
  ;get global structure
  widget_control,Event.top,get_uvalue=global
  
  ;retrieve path of batch file name
  MyBatchPath = getBatchPath(Event)
  ;retrieve batch file name
  MyBatchFile = getBatchFile(Event)
  ;FullFileName
  FullFileName = MyBatchPath + MyBatchFile
  ;Add information in log book
  LogText = '> Saving Batch File:'
  putLogBookMessage, Event, LogText, APPEND=1
  LogText = '-> Batch File Name : ' + FullFileName
  putLogBookMessage, Event, LogText, APPEND=1
  LogText = '-> Create Batch File Name ... ' + (*global).processing_message
  putLogBookMessage, Event, LogText, APPEND=1
  ;Create the batch output file using the FullFileName
  CreateBatchFile, Event, FullFileName
END

;------------------------------------------------------------------------------
;This function is reached each time the Batch Tab is reached by the
;user. In this function, the table will be updated with info from the
;current run.
PRO UpdateBatchTable, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable = (*(*global).BatchTable)
  ;display new BatchTable
  DisplayBatchTable, Event, BatchTable
  ;check if a row has been already selected, if no, select first row
  IF (IsAnyRowSelected(Event) NE 1) THEN BEGIN
    SelectFullRow, Event, 0
  ENDIF ELSE BEGIN
    CurrentWorkingRow = getCurrentRowSelected(Event)
    DisplayInfoOfSelectedRow, Event, CurrentWorkingRow
  ENDELSE
  ;check if there are any not 'N/A' command line, if yes, then activate
  ;DELETE SELECTION, DELETE ACTIVE, RUN ACTIVE AND SAVE ACTIVE(S)
  UpdateBatchTabGui, Event
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton, Event
END

;------------------------------------------------------------------------------
;This function is reached each time the user has loaded a new
;Normalization run
PRO AddNormRunToBatchTable, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  BatchTable = (*(*global).BatchTable)
  NormRun    = (*global).NormRunNumber
  ;get current working row
  WorkingRow = getCurrentWorkingRow(Event)
  ;add norm_run_number into BatchTable
  IF (WorkingRow NE -1) THEN BEGIN
    BatchTable[2,WorkingRow] = strcompress(NormRun,/remove_all)
  ENDIF
  (*(*global).BatchTable) = BatchTable
END

;------------------------------------------------------------------------------
PRO RetrieveBatchInfoAtLoading, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve current Batch Table
  BatchTable = (*(*global).BatchTable)
  ;check if there is a row in the BatchTable where the Command Line is
  ;still undefined. If yes, remove this row, if not, remove last row and
  ;move up everything
  RowIndexes    = getGlobalVariable('RowIndexes')
  ColumnIndexes = getglobalVariable('ColumnIndexes')
  FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[ColumnIndexes,i] EQ 'N/A') THEN BEGIN
      RemoveGivenRowInBatchTable, BatchTable, i
      break
    ENDIF
  ENDFOR
  ;move down everything to make room for new load data and insert blank
  ;data
  AddBlankRowInBatchTable, BatchTable
  ;Get info from NeXus into first row
  ;get current data NeXus file name
  Nexus_full_name = (*global).data_full_nexus_name
  ;create instance of a class to retrieve info
  ClassInstance = obj_new('IDLgetMetadata',Nexus_full_name)
  ;populate index 0 with info from class
  PopulateBatchTableWithClassInfo, BatchTable, ClassInstance
  ;populate index 0 with info form GUI (DATA run and date)
  PopulateBatchTableWithGuiInfo, Event, BatchTable
  ;populate index 0 with missing infos (NORM and command line)
  PopulateBatchTableWithOthersInfo, Event, BatchTable
  ;populate index 0 with all Data and Norm run numbers
  PopulateBatchTableWithDataNormRunNumbers, Event, BatchTable
    
  (*(*global).BatchTable) = BatchTable
  ;display new BatchTable
  DisplayBatchTable, Event, BatchTable
  
  ;This autogenerates the name of the batch file name
  GenerateBatchFileName, Event
END

;------------------------------------------------------------------------------
;This function will retrieves the DATA run numbers and add them to the
;Batch File
PRO BatchRetrieveDataRuns, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve current Batch Table
  BatchTable = (*(*global).BatchTable)
  ;retrieve DATA_runs text field
  DataRunsField = getTextFieldValue(Event,'reduce_data_runs_text_field')
  DataArray = strsplit(DataRunsField,',',/extract,count=nbr)
  NewBatchData = ''
  FOR i=0,(Nbr-1) DO BEGIN
    ;if there is a full path in it, do not add it
    tmp = strsplit(DataArray[i],'/',/extract,count=nbr1)
    IF (nbr1 EQ 1) THEN BEGIN
      NewBatchData += ',' + strcompress(DataArray[i],/remove_all)
    ENDIF
  ENDFOR
  IF (NewBatchData NE '') THEN BEGIN
    DataRunNumber = strcompress((*global).data_run_number,/remove_all) + $
      NewBatchData
    (*global).DataRunNumber = DataRunNumber
  ENDIF ELSE BEGIN
    DataRunNumber = strcompress((*global).data_run_number,/remove_all)
  ENDELSE
  ;put info in BatchTable
  WorkingRow = getCurrentWorkingRow(Event)
  IF (WorkingRow NE -1) THEN BEGIN
    BatchTable[1,WorkingRow] = DataRunNumber
    (*(*global).BatchTable)  = BatchTable
  ENDIF
  ;generate a new batch file name
  GenerateBatchFileName, Event
END

;------------------------------------------------------------------------------
;This function will retrieves the NORM run numbers and add them to the
;Batch File
PRO BatchRetrieveNormRuns, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve current Batch Table
  BatchTable = (*(*global).BatchTable)
  ;retrieve NORM_runs text field
  NormRunsField = getTextFieldValue(Event,'reduce_normalization_runs_text_field')
  NormArray = strsplit(NormRunsField,',',/extract,count=nbr)
  NewBatchNorm = ''
  FOR i=0,(Nbr-1) DO BEGIN
    ;if there is a full path in it, do not add it
    tmp = strsplit(NormArray[i],'/',/extract,count=nbr1)
    IF (nbr1 EQ 1) THEN BEGIN
      NewBatchNorm += ',' + strcompress(NormArray[i],/remove_all)
    ENDIF
  ENDFOR
  IF (NewBatchNorm NE '') THEN BEGIN
    NormRunNumber = strcompress((*global).norm_run_number,/remove_all) + $
      NewBatchNorm
    (*global).NormRunNumber = NormRunNumber
  ENDIF ELSE BEGIN
    NormRunNumber = strcompress((*global).norm_run_number,/remove_all)
  ENDELSE
  ;put info in BatchTable
  WorkingRow = getCurrentWorkingRow(Event)
  IF (WorkingRow NE -1) THEN BEGIN
    BatchTable[2,WorkingRow] = NormRunNumber
    (*(*global).BatchTable)  = BatchTable
  ENDIF
  ;generate a new batch file name
  GenerateBatchFileName, Event
END

;------------------------------------------------------------------------------
PRO BatchTab_LaunchREFscale, Event ;_Batch
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  CurrentFolder = '~/SVN/IdlGui/branches/REFscale/1.0/'
  IdlUtilitiesPath = 'utilities'
  
  ;Makefile that automatically compile the necessary modules
  ;and create the VM file.
  cd, CurrentFolder + IdlUtilitiesPath
  system_utilities
  
  ;Build REFscale GUI
  cd, CurrentFolder + '/REFscaleGUI/'
  make_gui_step1
  make_gui_step2
  make_gui_step3
  make_gui_output_file
  make_gui_batch
  make_gui_main_base_components
  make_gui_log_book
  
  ;Build main procedures
  cd, CurrentFolder
  ref_scale_get
  procedure_array_delete
  procedure_ref_scale_arrays
  procedure_number_formatter
  procedure_get_numeric
  ref_scale_put
  ref_scale_is
  procedure_idl_send_to_geek
  idl_get_metadata__define
  
  procedure_main_base_event
  ref_scale_utility
  procedure_ref_scale_gui
  ref_scale_fit
  procedure_ref_scale_step3
  ref_scale_math
  ref_scale_file_utility
  procedure_ref_scale_tof_to_q
  idl_load_batch_file__define
  idl_create_batch_file__define
  idl_parse_command_line__define
  
  procedure_ref_scale_openfile
  procedure_ref_scale_plot
  procedure_ref_scale_load
  procedure_ref_scale_step2
  ref_scale_produce_output
  ref_scale_batch
  procedure_ref_scale_tabs
  ref_scale_eventcb
  
  ;get name of batch file
  ref_scale, BatchMode=(*global).main_base, BatchFile=(*global).BatchFileName
  
END
