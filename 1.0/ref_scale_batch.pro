;===============================================================================
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
;===============================================================================

PRO ref_scale_LoadBatchFile, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global
;Retrieve global parameters
PROCESSING = (*global).processing
;pop-up dialog pickfile
BatchFileName = DIALOG_PICKFILE(TITLE    = 'Pick Batch File to Load ...',$
                                PATH     = (*global).BatchDefaultPath,$
                                FILTER   = (*global).BatchDefaultFileFilter,$
                                GET_PATH = new_path,$
                                /MUST_EXIST)

IF (BatchFileName NE '') THEN BEGIN
    (*global).BatchFileName = BatchFileName
    LogText = '> Loading Batch File:'
    idl_send_to_geek_addLogBookText, Event, LogText
    LogText = '-> File Name : ' + BatchFileName
    idl_send_to_geek_addLogBookText, Event, LogText
    (*global).BatchDefaultPath = new_path
    LogText = '-> Populate Batch Table ... ' + PROCESSING
    idl_send_to_geek_addLogBookText, Event, LogText
;put name of batch file in text field
    putValueInTextField, Event, 'load_batch_file_text_field', BatchFileName
;     BatchTable = PopulateBatchTable(Event, BatchFileName)
;     (*(*global).BatchTable) = BatchTable
;     DisplayBatchTable, Event, BatchTable
;     (*global).BatchFileName = BatchFileName
; ;this function updates the widgets (button) of the tab
;     UpdateBatchTabGui, Event
;     RowSelected = (*global).PrevBatchRowSelected
; ;Update info of selected row
;     DisplayInfoOfSelectedRow, Event, RowSelected
; ;display path and file name of file in SAVE AS widgets
;     FileArray = getFilePathAndName(BatchFileName)
;     FilePath  = FileArray[0]
;     FileName  = FileArray[1]
; ;put path in PATH button
;     (*global).BatchDefaultPath = FilePath
;     ;change name of button
;     putBatchFolderName, Event, FilePath
; ;put name of file in widget_text
;     putBatchFileName, Event, FileName
; ;enable or not the REPOPULATE Button
;     CheckRepopulateButton, Event
ENDIF 
END

;===============================================================================
PRO ref_scale_PreviewBatchFile, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global
;retrieve BatchFileName
BatchFileName = (*global).BatchFileName
XDISPLAYFILE, BatchFileName, TITLE='Preview of ' + BatchFileName
END

;===============================================================================
PRO ref_scale_batch
END

;===============================================================================

