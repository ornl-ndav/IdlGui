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
;   select the full row. 
;
; :Params:
;    Event
;    RowSelected, row currently selected by the user
;
; :Author: j35
;-
PRO SelectFullRow_ref_m, Event, RowSelected
  ColumnIndexes = getGlobalVariable_ref_m('ColumnIndexes')
  id = Widget_Info(Event.top,find_by_uname='batch_table_widget')
  widget_control, id, set_table_select=[0,RowSelected,ColumnIndexes-1,RowSelected]
END


pro BatchTab_WidgetTable_ref_m, event

  ;get global structure
  widget_control,event.top,get_uvalue=global
  rowSelected = getCurrentRowSelected(Event)
  
  ;Select Full Row
  SelectFullRow_ref_m, Event, RowSelected
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
  
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  IF ((RowSelected) EQ RowIndexes) THEN BEGIN
    activateDownButtonStatus = 0
  ENDIF ELSE BEGIN
    activateDownButtonStatus = 1
  ENDELSE
  activateDownButton, Event, activateDownButtonStatus

  ;display info of selected row in INPUT base
  IF (rowSelected NE (*global).PrevBatchRowSelected) THEN BEGIN
    DisplayInfoOfSelectedRow_ref_m, Event, RowSelected
    (*global).PrevBatchRowSelected = rowSelected
  ENDIF
  
  ;enable or not the REPOPULATE Button
  CheckRepopulateButton_ref_m, Event
  ;SaveDataNormInputValues, Event  ;_batchDataNorm
  
end
