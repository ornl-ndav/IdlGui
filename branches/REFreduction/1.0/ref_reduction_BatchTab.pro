;**********************************************************************
;GET - GET - GET - GET - GET - GET - GET - GET - GET - GET - GET - GET
;**********************************************************************

;Procedure that will return all the global variables for this routine
FUNCTION getGlobalVariable, var
CASE (var) OF
;number of columns in the Table (active/data/norm/s1/s2...)
    'NbrColumn' : RETURN, 7 
    'NbrRow'    : RETURN, 19
ELSE:
ENDCASE
RETURN, 'NA'
END


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
CurrentBatchTableIndex = (*global).CurrentBatchTableIndex
;Move to next index only if previous GO DATA REDUCTION button has been
;validated
IF ((*global).PreviousRunReductionValidated EQ 1) THEN BEGIN
    ++CurrentBatchTableIndex
;move up position of all other indexes in array (position)

;FIX_ME

    IF (CurrentBatchTableIndex EQ 20) THEN BEGIN
        CurrentBatchTableIndex = 0
        (*global).CurrentBatchTableIndex = CurrentBatchTableIndex
    ENDIF ELSE BEGIN
        (*global).CurrentBatchTableIndex = CurrentBatchTableIndex
    ENDELSE
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
text = 'Angle: ' + strcompress(value,/remove_all) + ' degrees'
putTextFieldValue, Event, 'angle_value_status', text, 0
END


PRO UpdateS1Field, Event, value
text = 'Slit 1: ' + strcompress(value,/remove_all) + ' mm'
putTextFieldValue, Event, 's1_value_status', text, 0
END


PRO UpdateS2Field, Event, value
text = 'Slit 2: ' + strcompress(value,/remove_all) + ' mm'
putTextFieldValue, Event, 's2_value_status', text, 0
END


;PRO UpdateDateField, Event, value
;putTextFieldValue, Event, '


PRO UpdateCMDField, Event, value
putTextFieldValue, Event, 'cmd_status_preview', value, 0
END


;**********************************************************************
;IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS - IS
;**********************************************************************
FUNCTION IsRowSelectedActive, RowSelected, BatchTable
IF (BatchTable[0,RowSelected] EQ 'YES') THEN RETURN, 1
RETURN, 0
END


;**********************************************************************
;GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI - GUI
;**********************************************************************
;This function retrieves the row of the selected cell and select the
;full row
PRO SelectFullRow, Event, RowSelected
NbrColumn = getGlobalVariable('NbrColumn')
id = Widget_Info(Event.top,find_by_uname='batch_table_widget')
widget_control, id, set_table_select=[0,RowSelected,NbrColumn,RowSelected]
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
BatchTable[*,CurrentBatchTableIndex] = strarr(8)
END


;This function activate or not the MOVE DOWN SELECTION button
PRO activateDownButton, Event, status
id = widget_info(Event.top,find_by_uname='move_down_selection_button')
widget_control, id, sensitive=status
END


;This function activate or not the MOVE UP SELECTION button
PRO activateUpButton, Event, status
id = widget_info(Event.top,find_by_uname='move_up_selection_button')
widget_control, id, sensitive=status
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
    UpdateAngleField, Event, '?'
    UpdateS1Field,    Event, '?'
    UpdateS2Field,    Event, '?'
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
PRO PopulateClassWithInfo, Event, instance, Table, index
Table[index].angle = instance->getAngle()
Table[index].s1    = instance->getS1()
Table[index].s2    = instance->getS2()
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

;validate or not UP and DOWN buttons
IF ((RowSelected) EQ 0) THEN BEGIN
    activateUpButtonStatus = 0
ENDIF ELSE BEGIN
    activateUpButtonStatus = 1
ENDELSE
activateUpButton, Event, activateUpButtonStatus

IF ((RowSelected) EQ 19) THEN BEGIN
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
ActiveValue = ValueOfActive(Event)
;get status of active or not (from BatchTable)
ActiveSelection = isRowSelectedActive(RowSelected,BatchTable)
IF (ABS(activeValue - ActiveSelection) NE 1) THEN BEGIN
    IF (activeValue EQ 0) THEN BEGIN
        BatchTable[0,RowSelected]='YES'
    ENDIF ELSE BEGIN
        BatchTable[0,RowSelected]='NO'
    ENDELSE
    (*(*global).BatchTable) = BatchTable
    DisplayBatchTable, Event, BatchTable
ENDIF

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
IF (RowSelected NE 19) THEN BEGIN ;move down
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

IF ((RowSelected+1) EQ 19) THEN BEGIN
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
NbrRow = getGlobalVariable('NbrRow')
FOR i = RowSelected, (NbrRow-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
ENDFOR
ClearStructureFields, BatchTable, NbrRow
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
END


;This method will remove from the main table all the row that have
;been activated
PRO BatchTab_DeleteActive, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve main table
BatchTable = (*(*global).BatchTable)
;current row selected
RowSelected = (*global).PrevBatchRowSelected
NbrRow = getGlobalVariable('NbrRow')
FOR i = RowSelected, (NbrRow-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
ENDFOR
ClearStructureFields, BatchTable, NbrRow
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
END


PRO BatchTab_RunActive, Event
print, 'in run active'
END


PRO BatchTab_LoadBatchFile, Event
print, 'in load batch file'
END

PRO BatchTab_BrowsePath, Event
print, 'in browse for path'
END


PRO BatchTab_SaveCommands, Event
print, 'in save set of command lines'
END



;-------------------------------------------------------------------------------
;This function is reached each time the Batch Tab is reached by the
;user. In this function, the table will be updated with info from the
;current run.
PRO UpdateBatchTable, Event
print, 'here'
END


PRO RetrieveBatchInfoAtLoading, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get current index in Batch table
CurrentBatchTableIndex = getCurrentBatchTableIndex(Event)
;get current data NeXus file name
Nexus_full_name = (*global).data_full_nexus_name
;retrieve current Batch Table
BatchTable = (*(*global).BatchTable)
;clear fields of current structure index
ClearStructureFields, BatchTable, CurrentBatchTableIndex
;create instance of a class to retrieve info
ClassInstance = obj_new('IDLgetMetadata',Nexus_full_name)
;populate current index with info from class
PopulateClassWithInfo, Event, ClassInstance, BatchTable, CurrentBatchTableIndex


END
