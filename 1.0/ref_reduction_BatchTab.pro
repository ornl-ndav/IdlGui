;Procedure that will return all the global variables for this routine
FUNCTION getGlobalVariable, var
CASE (var) OF
    'NbrColumn' : RETURN, 7 ;number of columns in the Table (active/data/norm/s1/s2...)
ELSE:
ENDCASE
RETURN, 'NA'
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
    IF (CurrentBatchTableIndex EQ 20) THEN BEGIN
        CurrentBatchTableIndex = 0
        (*global).CurrentBatchTableIndex = CurrentBatchTableIndex
    ENDIF ELSE BEGIN
        (*global).CurrentBatchTableIndex = CurrentBatchTableIndex
    ENDELSE
ENDIF
RETURN, CurrentBatchTableIndex
END

;This function reset all the structure fields of the current index
PRO ClearStructureFields, BatchTable, CurrentBatchTableIndex
BatchTable[CurrentBatchTableIndex] = { BT,$
                                       index    :  0,$
                                       active   : 1,$
                                       data     : '',$
                                       norm     : '',$
                                       angle    : '',$
                                       s1       : '',$
                                       s2       : '',$
                                       date     : '',$
                                       cmd_line :''}
END


;This function will use the instance of the class to populate the
;structure with angle, S1, S2 values
PRO PopulateClassWithInfo, Event, instance, Table, index
Table[index].angle = instance->getAngle()
Table[index].s1    = instance->getS1()
Table[index].s2    = instance->getS2()
END


;This function retrieves the row of the selected cell and select the
;full row
PRO SelectFullRow, Event, RowSelected
;retrieve row number of selected element
id = Widget_Info(Event.top,find_by_uname='batch_table_widget')
SelectedCell = widget_Info(id,/table_select)
RowSelected  = SelectedCell[1]
;force selection of full row
NbrColumn = getGlobalVariable('NbrColumn')
widget_control, id, set_table_select=[0,RowSelected,NbrColumn,RowSelected]
END


PRO BatchTab_WidgetTable, Event
row = 0 ;default selected row is 0
;Select Full Row
SelectFullRow, Event, row
;display info of selected row in INPUT base
;;FIX_ME
END


PRO BatchTab_ActivateRow, Event
print, 'activate or not row'
END


PRO BatchTab_ChangeDataRunNumber, Event
print, 'change Data run number'
END


PRO BatchTab_ChangeNormRunNumber, Event
print, 'change Norm run number'
END


PRO BatchTab_MoveUpActive, Event
print, 'in move up Active'
END


PRO BatchTab_MoveDownActive, Event
print, 'in move down Active'
END



;This method will remove from the main table all the row that have
;been activated
PRO BatchTab_DeleteActive, Event
print, 'in delete active'
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

print, BatchTable[CurrentBatchTableIndex].angle 


END
