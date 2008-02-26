;**********************************************************************
;GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL
;**********************************************************************

;Procedure that will return all the global variables for this routine
FUNCTION getGlobalVariable, var
CASE (var) OF
;number of columns in the Table (active/data/norm/s1/s2...)
    'ColumnIndexes' : RETURN, 7 
    'RowIndexes'    : RETURN, 19
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



FUNCTION PopulateBatchTable, BatchFileName
NbrLine   = 0
FileArray = PopulateFileArray(BatchFileName, NbrLine)
BatchTable = strarr(8,20)
BatchIndex = -1 ;row index
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
            SplitArray = strsplit(FileArray[FileIndex],' : ',/extract)
            CASE (SplitArray[0]) OF
                '#Active'    : BatchTable[0,BatchIndex] = SplitArray[1]
                '#Data_Runs' : BatchTable[1,BatchIndex] = SplitArray[1]
                '#Norm_Runs' : BatchTable[2,BatchIndex] = SplitArray[1]
                '#Angle(deg)': BatchTable[3,BatchIndex] = SplitArray[1]
                '#S1(mm)'    : BatchTable[4,BatchIndex] = SplitArray[1]
                '#S2(mm)'    : BatchTable[5,BatchIndex] = SplitArray[1]
                '#Date'      : BatchTable[6,BatchIndex] = SplitArray[1]
                ELSE         : BEGIN
                    CommentArray= strsplit(SplitArray[0],'#',/extract, COUNT=nbr)
                    SplitArray[0]=CommentArray[0]
                    cmd = strjoin(SplitArray,' ')
                    BatchTable[7,BatchIndex] = cmd
                END
            ENDCASE
            ++FileIndex
        ENDELSE
    ENDELSE
ENDWHILE
RETURN, BatchTable
END


;This function takes the name of the output file to create
;and create the Batch output file
PRO CreateBatchFile, Event, FullFileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get Text To copy
BatchTable = (*(*global).BatchTable)

NbrRow    = (size(BatchTable))(2)
NbrColumn = (size(BatchTable))(1)

text    = STRARR(1)
text[0] = '#This Batch File has been produced by REFreduction ' + (*global).REFreductionVersion
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
    text    = [text,'#Angle(deg) : ' + BatchTable[k++,i]]
    text    = [text,'#S1(mm) : ' + BatchTable[k++,i]]
    text    = [text,'#S2(mm) : ' + BatchTable[k++,i]]
    text    = [text,'#Date : ' + BatchTable[k++,i]]
    text    = [text,FP+BatchTable[k++,i]]
    text    = [text,'']

ENDIF
ENDFOR

file_error = 0
CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    print, 'error'
ENDIF ELSE BEGIN
;create output file
    openw,1,FullFileName
    sz = (size(text))(1)
    FOR j=0,(sz-1) DO BEGIN
        printf, 1, text[j]
    ENDFOR
    close,1
    free_lun,1
ENDELSE
;give execute permission to file created
cmd = 'chmod 700 ' + FullFileName
spawn, cmd, listening
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


;Retrieves the Batch Path 
FUNCTION getBatchPath, Event
id = widget_info(Event.top,find_by_uname='save_as_path')
widget_control, id, get_value=path
RETURN, Path
END

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


PRO UpdateNormField, Event, value
putTextFieldValue, Event, 'batch_norm_run_field_status', value, 0
END


PRO UpdateAngleField, Event, value
IF (value EQ '') THEN value = '?'
text = 'Angle: ' + strcompress(value,/remove_all) + ' degrees'
putTextFieldValue, Event, 'angle_value_status', text, 0
END


PRO UpdateS1Field, Event, value
IF (value EQ '') THEN value = '?'
text = 'Slit 1: ' + strcompress(value,/remove_all) + ' mm'
putTextFieldValue, Event, 's1_value_status', text, 0
END


PRO UpdateS2Field, Event, value
IF (value EQ '') THEN value = '?'
text = 'Slit 2: ' + strcompress(value,/remove_all) + ' mm'
putTextFieldValue, Event, 's2_value_status', text, 0
END


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



FUNCTION isItCurrentWorkingRow, RowSelected, BatchTable
IF (BatchTable[0,RowSelected] EQ '> YES <' OR $
    BatchTable[0,RowSelected] EQ '> NO <') THEN RETURN, 1
RETURN, 0
END



FUNCTION IsAnyRowSelected, Event
id = widget_info(Event.top,find_by_uname='batch_table_widget')
Selection = widget_info(id,/table_select)
ColumnIndexes = getGlobalVariable('ColumnIndexes')
IF (Selection[2] EQ ColumnIndexes) THEN RETURN, 1
RETURN, 0
END



FUNCTION isThereAnyCmdDefined, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
BatchTable = (*(*global).BatchTable)
RowIndexes = getGlobalVariable('RowIndexes')
FOR i=0,RowIndexes DO BEGIN
    IF (BatchTable[7,i] NE 'N/A' AND $
        BatchTable[7,i] NE '') THEN BEGIN
        RETURN,1
    ENDIF
ENDFOR
RETURN,0
END


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


FUNCTION isThereAnyDataInBatchTable, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
BatchTable      = (*(*global).BatchTable)
BatchTableReset = strarr(8,20)
IF (ARRAY_EQUAL(BatchTable,BatchTableReset)) THEN RETURN, 0
RETURN,1
END



;**********************************************************************
;GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI
;**********************************************************************
;This function retrieves the row of the selected cell and select the
;full row
PRO SelectFullRow, Event, RowSelected
ColumnIndexes = getGlobalVariable('ColumnIndexes')
id = Widget_Info(Event.top,find_by_uname='batch_table_widget')
widget_control, id, set_table_select=[0,RowSelected,ColumnIndexes,RowSelected]
END


PRO ValidateActive, Event, value
id = widget_info(Event.top,find_by_uname='batch_run_active_status')
widget_control, id, set_value=value
END


FUNCTION ValueOfActive, Event
id = widget_info(Event.top,find_by_uname='batch_run_active_status')
widget_control, id, get_value=value
RETURN, value
END


PRO DisplayBatchTable, Event, BatchTable
id = widget_info(Event.top,find_by_uname='batch_table_widget')
widget_control, id, set_value=BatchTable
END


;This function reset all the structure fields of the current index
PRO ClearStructureFields, BatchTable, CurrentBatchTableIndex
resetArray = strarr(8)
BatchTable[*,CurrentBatchTableIndex] = resetArray
END


;This function activates or not the MOVE DOWN SELECTION button
PRO activateDownButton, Event, status
id = widget_info(Event.top,find_by_uname='move_down_selection_button')
widget_control, id, sensitive=status
END


;This function activates or not the MOVE UP SELECTION button
PRO activateUpButton, Event, status
id = widget_info(Event.top,find_by_uname='move_up_selection_button')
widget_control, id, sensitive=status
END


;This function activates or not the DELETE SELECTION button
PRO activateDeleteSelectionButton, Event, status
id = widget_info(Event.top,find_by_uname='delete_selection_button')
widget_control, id, sensitive=status
END


;This function activates or not the DELETE ACTIVE button
PRO activateDeleteActiveButton, Event, status
id = widget_info(Event.top,find_by_uname='delete_active_button')
widget_control, id, sensitive=status
END


;This function activates or not the RUN ACTIVE button
PRO activateRunActiveButton, Event, status
id = widget_info(Event.top,find_by_uname='run_active_button')
widget_control, id, sensitive=status
END


;This function activates or not the SAVE ACTIVE button
PRO activateSaveActiveButton, Event, status
id = widget_info(Event.top,find_by_uname='save_as_file_button')
widget_control, id, sensitive=status
END


;This function removes the given row from the BatchTable
PRO RemoveGivenRowInBatchTable, BatchTable, Row
RowIndexes = getGlobalVariable('RowIndexes')
FOR i = Row, (RowIndexes-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
ENDFOR
ClearStructureFields, BatchTable, RowIndexes
END


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


;This function changes the label of the Batch Folder button
PRO putBatchFolderName, Event, new_path
id = widget_info(Event.top,find_by_uname='save_as_path')
widget_control, id, set_value=new_path
END


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
TimeBatchFormat = GenerateDateStamp()
file_name += '_' + TimeBatchFormat

;add extension  (ex: REF_L_Batch_3454_2008y_02m_10d.txt)
file_name += '.txt'

putTextFieldValue, Event, 'save_as_file_name', file_name, 0
END


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
activateDeleteActiveButton, Event, activateStatus
activateSaveActiveButton, Event, activateStatus

;check if there is anything in the BatchTable
IF (isThereAnyDataInBatchTable(Event)) THEN BEGIN
    activateStatus = 1
ENDIF ELSE BEGIN
    activateStatus = 0
ENDELSE
activateDeleteSelectionButton, Event, activateStatus

END











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
    UpdateNormField,  Event, BatchTable[2,RowSelected]
    UpdateAngleField, Event, BatchTable[3,RowSelected]
    UpdateS1Field,    Event, BatchTable[4,RowSelected]
    UpdateS2Field,    Event, BatchTable[5,RowSelected]
;UpdateDateField,  Event, BatchTable[6,RowSelected]
    UpdateCMDField,   Event, BatchTable[7,RowSelected]

ENDELSE

END


;This function will use the instance of the class to populate the
;structure with angle, S1, S2 values
PRO PopulateBatchTableWithClassInfo, Table, instance 
Table[3,0] = strcompress(instance->getAngle(),/remove_all)
Table[4,0] = strcompress(instance->getS1(),/remove_all)
Table[5,0] = strcompress(instance->getS2(),/remove_all)
END


;This function get the info from the GUI (data run number and time) to
;update the new row (index 0) of BatchTable
PRO PopulateBatchTableWithGuiInfo, Event, BatchTable
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
DataRunNumber   = (*global).DataRunNumber
TimeBatch       = GenerateDateStamp()
BatchTable[1,0] = strcompress(DataRunNumber,/remove_all)
BatchTable[6,0] = strcompress(TimeBatch,/remove_all)
END


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
norm_run_number = (*global).norm_run_number
IF (norm_run_number EQ 0) THEN norm_run_number = ''
BatchTable[2,0] = strcompress(norm_run_number,/remove_all)
BatchTable[7,0] = 'N/A'
END


;This function populate the working row with the command line 
PRO PopulateBatchTableWithCMDinfo, Event, cmd
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
BatchTable = (*(*global).BatchTable)
workingRow = getCurrentWorkingRow(Event)
IF (workingRow NE -1) THEN BEGIN
    BatchTable[7,workingRow]=cmd
ENDIF
(*(*global).BatchTable) = BatchTable
END


;This function is reached by the all_events of the main table in the
;batch tab
PRO BatchTab_WidgetTable, Event
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

END



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
ActiveValue = ValueOfActive(Event)
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
END


PRO BatchTab_ChangeDataRunNumber, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve main table
BatchTable = (*(*global).BatchTable)
;current row selected
RowSelected = (*global).PrevBatchRowSelected
;get value of data status
dataStatus = getDataStatus(Event)
BatchTable[1,RowSelected]=dataStatus
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
END


PRO BatchTab_ChangeNormRunNumber, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve main table
BatchTable = (*(*global).BatchTable)
;current row selected
RowSelected = (*global).PrevBatchRowSelected
;get value of norm status
NormStatus = getNormStatus(Event)
BatchTable[2,RowSelected]=NormStatus
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
END


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

END


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

END



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
END



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
END


PRO BatchTab_RunActive, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

BatchTable = (*(*global).BatchTable)

NbrRow = getGlobalVariable('RowIndexes')

;turn on hourglass
widget_control,/hourglass
FOR i=0,NbrRow DO BEGIN
    IF (BatchTable[0,i] EQ '> YES <' OR $
        BatchTable[0,i] EQ 'YES') THEN BEGIN
        spawn, BatchTable[7,i], listening, err_listening
    ENDIF
ENDFOR
;turn off hourglass
widget_control,hourglass=0
END


PRO BatchTab_LoadBatchFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
BatchFileName = DIALOG_PICKFILE(TITLE    = 'Pick Batch File to load ...',$
                                PATH     = (*global).BatchDefaultPath,$
                                FILTER   = (*global).BatchDefaultFileFilter,$
                                GET_PATH = new_path,$
                                /MUST_EXIST)
IF (BatchFileName NE '') THEN BEGIN
    (*global).BatchDefaultPath = new_path
    ;change name of button
ENDIF 
BatchTable = PopulateBatchTable(BatchFileName)
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
END



PRO BatchTab_BrowsePath, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

new_path = DIALOG_PICKFILE(/DIRECTORY,$
                           TITLE = 'Pick output folder name ...',$
                           PATH  = (*global).BatchDefaultPath,$
                           /MUST_EXIST)

IF (new_path NE '') THEN BEGIN
    (*global).BatchDefaultPath = new_path
    ;change name of button
    putBatchFolderName, Event, new_path
ENDIF 

END



PRO BatchTab_SaveCommands, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve path of batch file name
MyBatchPath = getBatchPath(Event)
;retrieve batch file name
MyBatchFile = getBatchFile(Event)
;FullFileName
FullFileName = MyBatchPath + MyBatchFile
;Create the batch output file using the FullFileName
CreateBatchFile, Event, FullFileName

END


;-------------------------------------------------------------------------------
;This function is reached each time the Batch Tab is reached by the
;user. In this function, the table will be updated with info from the
;current run.
PRO UpdateBatchTable, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve path of batch file name
MyBatchPath = getBatchPath(Event)
;retrieve batch file name
MyBatchFile = getBatchFile(Event)
;FullFileName
FullFileName = MyBatchPath + MyBatchFile

;get Text To copy
BatchTable = (*(*global).BatchTable)
END



;-------------------------------------------------------------------------------
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
    DisplayInfoOfSelectedRow, Event, 0
    (*global).PrevBatchRowSelected = 0
ENDELSE

;check if there are any not 'N/A' command line, if yes, then activate 
;DELETE SELECTION, DELETE ACTIVE, RUN ACTIVE AND SAVE ACTIVE(S)
UpdateBatchTabGui, Event
END




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

(*(*global).BatchTable) = BatchTable
;display new BatchTable
DisplayBatchTable, Event, BatchTable

;This autogenerates the name of the batch file name
GenerateBatchFileName, Event

END
