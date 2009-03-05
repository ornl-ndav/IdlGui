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
;This function creates the SF array when loading the batch file, and
;populate the angle values in the same time.
PRO create_SF_array, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global
BatchTable       = (*(*global).BatchTable)
NbrRowMax        = (size(batchTable))(2)
index            = 0
SF_array         = FLTARR(1)
angle_array      = FLTARR(1)
FOR i=0,(NbrRowMax-1) DO BEGIN
    IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
        IF (index EQ 0) THEN BEGIN
            SF_array[0] = BatchTable[8,i]
            angle_array[0] = BatchTable[4,i]
        ENDIF ELSE BEGIN
            SF_array = [SF_array,BatchTable[8,i]]
            angle_array = [angle_array,BatchTable[4,i]]
        ENDELSE
        index++
    ENDIF
ENDFOR
(*(*global).SF_array)    = SF_array
(*(*global).angle_array) = angle_array
END

;==============================================================================
PRO apply_sf_to_data, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global
BatchTable       = (*(*global).BatchTable)
NbrRowMax        = (size(batchTable))(2)
flt1_ptr         = (*global).flt1_ptr
flt2_ptr         = (*global).flt2_ptr
flt1_rescale_ptr = (*global).flt1_rescale_ptr
flt2_rescale_ptr = (*global).flt2_rescale_ptr
flt_index        = 0

FOR i=0,(NbrRowMax-1) DO BEGIN

    SF_value = BatchTable[8,i]
    IF (SF_value EQ '') THEN BEGIN
        CONTINUE
    ENDIF ELSE BEGIN
        SF = FLOAT(SF_value)
    ENDELSE
    flt1 = *flt1_ptr[flt_index]
    flt2 = *flt2_ptr[flt_index]

;rescale data
    flt1 = flt1 / SF
    flt2 = flt2 / SF
    
    *flt1_rescale_ptr[i] = flt1
    *flt2_rescale_ptr[i] = flt2
    
    flt_index++ ;move on to next data ploted
    
ENDFOR

(*global).flt1_rescale_ptr = flt1_rescale_ptr
(*global).flt2_rescale_ptr = flt2_rescale_ptr
    
END

;==============================================================================
FUNCTION retrieveDRfiles, Event, BatchTable
;Get Nbr of non-empty rows
NbrRow         = getGlobalVariable('NbrRow')
NbrRowNotEmpty = 0
NbrDrFiles     = 0
FOR i=0,(NbrRow-1) DO BEGIN
    IF (BatchTable[1,i] NE '') THEN BEGIN
        ++NbrRowNotEmpty
        IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
            ++NbrDrFiles
        ENDIF
    ENDIF
ENDFOR

;Create array of list of files
DRfiles = STRARR(NbrDrFiles)
;get for each row the path/output_file_name
j=0
FOR i=0,(NbrRowNotEmpty-1) DO BEGIN
    iRow = OBJ_NEW('idl_parse_command_line',BatchTable[9,i])
    IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
        outputPath     = iRow->getOutputPath()
        outputFileName = iRow->getOutputFileName()
        DRfiles[j++] = outputPath + outputFileName
    ENDIF
ENDFOR
RETURN,DRfiles
END

;==============================================================================
;This function put the BatchTable in the table of the Batch Tab
PRO DisplayBatchTable, Event, NewTable
;new BatchTable
NewBatchTable = NewTable
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='ref_scale_batch_table_widget')
WIDGET_CONTROL, id, SET_VALUE=NewBatchTable
END

;This function retrieves from the big BatchTable, only the information
;that will be displayed in the table of the Batch tab
;==============================================================================
PRO UpdateBatchTable, Event, BatchTable
;display information from column 2/3/8/7 (in this order)
NewTable = STRARR(5,20)
;help, BatchTable ;remove_me
;print, BatchTable ;remove_me
NewTable[0,*] = BatchTable[0,*] 
NewTable[1,*] = BatchTable[1,*] 
NewTable[2,*] = BatchTable[2,*] 
NewTable[3,*] = BatchTable[8,*]
NewTable[4,*] = BatchTable[7,*]
;repopulate Table
DisplayBatchTable, Event, NewTable
END

;==============================================================================
;This function reset the batch table
PRO ResetBatch, Event
NewTable = STRARR(5,20)
;repopulate Table
DisplayBatchTable, Event, NewTable
;reset batch file name loaded
putValueInTextField, Event, 'load_batch_file_text_field', ''
END

;==============================================================================
;This function checks if all the output data reduction file exist or not
FUNCTION CheckFilesExist, Event, DRfiles
sz = (size(DRfiles))(1)
LogText = '-> Check if all Intermediate files exist or not:'
idl_send_to_geek_addLogBookText, Event, LogText
file_status = 1
FOR i=0,(sz-1) DO BEGIN
    IF(FILE_TEST(DRfiles[i])) THEN BEGIN
        LogText = '--> ' + DRfiles[i] + ' ... FOUND'
    ENDIF ELSE BEGIN
        LogText = '--> ' + DRfiles[i] + ' ... NOT FOUND !!'
        file_status = 0
    ENDELSE
    idl_send_to_geek_addLogBookText, Event, LogText
ENDFOR
RETURN, file_status
END

;==============================================================================
FUNCTION batch_repopulate_gui, Event, DRfiles
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global
;retrieve parameters
(*global).NbrFilesLoaded = 0
loading_error            = 0
;Nbr of files to load
sz = (size(DRfiles))(1)

FOR i=0,(sz-1) DO BEGIN
    index = (*global).NbrFilesLoaded 
    SuccessStatus = StoreFlts(Event, DRfiles[i], i)
    IF (SuccessStatus) THEN BEGIN
        ShortFileName = get_file_name_only(DRfiles[i]) ;_get
        LongFileName  = DRfiles[i]
        AddNewFileToDroplist, Event, ShortFileName, LongFileName ;_Gui
    ENDIF ELSE BEGIN
        loading_error = 1
        BREAK ;leave the for loop
    ENDELSE
ENDFOR

IF (loading_error EQ 0) THEN BEGIN
;define color_array
    index_array = getIndexArrayOfActiveBatchRow(Event)
    sz          = (size(index_array))(1)
    color_array = (float(225)/sz)*indgen(sz)+25 
    (*(*global).color_array) = color_array
;reset Qmin and Qmax
    (*(*global).Qmin_array) = FLTARR(sz)
    (*(*global).Qmax_array) = FLTARR(sz)
;create SF_array
    create_SF_array, Event
;apply the SF to the data
    apply_sf_to_data, Event
;plot all loaded files
    PlotLoadedFiles, Event      ;_Plot
    plot_loaded_file, Event, 'all' ;_Plot
;activate step2
    (*global).force_activation_step2 = 1
;activate step3
    ActivateStep3_fromBatch, Event, 1
    RETURN, 1
ENDIF ELSE BEGIN
    (*global).force_activation_step2 = 0
    ActivateStep3_fromBatch, Event, 0
    reset_all_button, Event
    RETURN, 0
ENDELSE

END

;==============================================================================
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
;retrieve BatchTable
    iTable     = OBJ_NEW('idl_load_batch_file', BatchFileName, Event)
    BatchTable = iTable->getBatchTable()
    (*(*global).BatchTable) = BatchTable
;Update Batch Tab and put BatchTable there
    UpdateBatchTable, Event, BatchTable
;Retrieve List of Data Reduction files
    DRfiles = retrieveDRfiles(Event, BatchTable)
;Check that all the files exist
    FileStatus = CheckFilesExist(Event, DRfiles)
    IF (FileStatus EQ 1) THEN BEGIN ;continue loading process
;Repopulate GUI
        result = batch_repopulate_gui(Event, DRfiles)
        IF (result EQ 1) THEN BEGIN
            LogText = '> Loading Batch File ' + BatchFileName + ' ... OK'
            idl_send_to_geek_addLogBookText, Event, LogText
            refresh_bash_file_status = 1
        ENDIF ELSE BEGIN
            LogText = '> Loading Batch File ' + BatchFileName + ' ... FAILED'
            idl_send_to_geek_addLogBookText, Event, LogText
            LogText = '-> This can be due to the fact that 1 or more ' + $
              'of the DR files does not exist !'
            idl_send_to_geek_addLogBookText, Event, LogText
            refresh_bash_file_status = 0 ;enable REFRESH and SAVE AS Bash File
        ENDELSE
    ENDIF ELSE BEGIN            ;stop loading process
        LogText = '> Loading Batch File ' + BatchFileName + ' ... FAILED'
        idl_send_to_geek_addLogBookText, Event, LogText
        LogText = '-> This can be due to the fact that 1 or more of the ' + $
          ' DR files does not exist !'
        idl_send_to_geek_addLogBookText, Event, LogText
        refresh_bash_file_status = 0 ;enable REFRESH and SAVE AS Bash Fil
        reset_all_button, Event
    ENDELSE
ENDIF ELSE BEGIN
;disable REFRESH and SAVE AS Bash File
    refresh_bash_file_status = 0
ENDELSE
ActivateWidget, Event, 'ref_scale_refresh_batch_file', refresh_bash_file_status
ActivateWidget, Event, 'ref_scale_save_as_batch_file', refresh_bash_file_status
ActivateWidget, Event, 'batch_preview_button', refresh_bash_file_status
IF (refresh_bash_file_status) THEN BEGIN ;loading was successfull
;this function updates the output file name
    update_output_file_name_from_batch, Event ;_output
ENDIF ELSE BEGIN
    putValueInLabel, Event, 'output_file_name_label_dynmaic', ''; _put
    message = ['The loading of ' + BatchFileName + ' did not work !',$
               'Check the Log Book !']
    title   = 'Problem Loading the Batch File!'
    result = DIALOG_MESSAGE(message,TITLE=title,/ERROR)
ENDELSE
END

;==============================================================================
PRO ref_scale_PreviewBatchFile, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global
;retrieve BatchFileName
BatchFileName = getBatchFileName(Event)
XDISPLAYFILE, BatchFileName, TITLE='Preview of ' + BatchFileName
END

;==============================================================================
PRO ref_scale_refresh_batch_file, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global

LogText = '> Refresh Batch File:'
idl_send_to_geek_addLogBookText, Event, LogText
BatchFileName = (*global).BatchFileName
LogText = '-> Batch File Name: ' + BatchFileName
idl_send_to_geek_addLogBookText, Event, LogText

iFile = OBJ_NEW('idl_create_batch_file', $
                Event, $
                BatchFileName, $
                (*(*global).BatchTable))

END

;==============================================================================
PRO ref_scale_save_as_batch_file, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
WIDGET_CONTROL,id,GET_UVALUE=global

path            = (*global).BatchDefaultPath
filter          = (*global).BatchDefaultFileFilter
new_path        = ''
batch_extension = (*global).BatchExtension

BatchFileName   = DIALOG_PICKFILE(FILTER            = filter,$
                                  GET_PATH          = new_path,$
                                  PATH              = path,$
                                  DEFAULT_EXTENSION = batch_extension,$
                                  /OVERWRITE_PROMPT,$
                                  /WRITE)

IF (BatchFileName NE '') THEN BEGIN
    LogText = '> Save Batch File:'
    idl_send_to_geek_addLogBookText, Event, LogText
    (*global).BatchFileName = BatchFileName
    LogText = '-> Batch File Name: ' + BatchFileName
    idl_send_to_geek_addLogBookText, Event, LogText
;put new name of BatchFile in LoadBatchFile text field
    putValueInTextField, Event, 'load_batch_file_text_field', BatchFileName
;Create batch file    
    iFile = OBJ_NEW('idl_create_batch_file', $
                    Event, $
                    BatchFileName, $
                    (*(*global).BatchTable))
;reset the path
    (*global).BatchDefaultPath = new_path
ENDIF


END

;==============================================================================
PRO ref_scale_batch
END

;==============================================================================

