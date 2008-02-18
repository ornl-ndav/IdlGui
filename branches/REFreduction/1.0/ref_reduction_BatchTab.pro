;Procedure that will return all the global variables for this routine
FUNCTION getGlobalVariable, var
CASE (var) OF
    'NbrColumn' : RETURN, 7 ;number of columns in the Table (active/data/norm/s1/s2...)
ELSE:
ENDCASE
RETURN, 'NA'
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


PRO BatchTab_BrowsePath, Event
print, 'in browse for path'
END


PRO BatchTab_SaveCommands, Event
print, 'in save set of command lines'
END
