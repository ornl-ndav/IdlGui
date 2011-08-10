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

FUNCTION addTimeStamp, full_output_file_name
timeStamp = GenerateIsoTimeStamp()
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, full_output_file_name
ENDIF ELSE BEGIN
;remove extension
    file_array = STRSPLIT(full_output_file_name,'.',/EXTRACT)
    new_file_name = file_array[0] + '_' + timeStamp + '.' + file_array[1]
ENDELSE
RETURN, new_file_name
END

;------------------------------------------------------------------------------
FUNCTION AreAllFilesFound, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global
pMetadata       = (*(*global).pMetadata)
nbr_files       = N_ELEMENTS(*(*pMetadata)[index].files)
aMetadataValue  = (*(*(*global).pMetadataValue))
path            = aMetadataValue[index+1,7]
i = 0
all_found = 1
WHILE (i LT nbr_files) DO BEGIN
    file_name_full  = (*(*pMetadata)[index].files)[i]
    file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
    file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
    IF (~FILE_TEST(path + file_name)) THEN BEGIN
        all_found = 0
        BREAK
    ENDIF
    i++
ENDWHILE
RETURN, all_found
END

;------------------------------------------------------------------------------
FUNCTION determine_default_output_file_name, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global
pMetadata       = (*(*global).pMetadata)
file_name_full  = (*(*pMetadata)[index].files)[0]
file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
;keep only first part of file name (BSS_623_Q00.txt)
split_array     = STRSPLIT(file_name,'_',COUNT=nbr)
file_name       = STRMID(file_name,0,split_array[nbr-1])
;add time stamp
time_stamp = GenerateIsoTimeStamp()
file_name += time_stamp + '_'
;add new extension
file_name      += (*global).iter_dependent_back_ext
;file name only
short_file_name = FILE_BASENAME(file_name)
RETURN, short_file_name
END

;------------------------------------------------------------------------------
PRO create_job_status, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;if there is a config file
IF (FILE_TEST((*global).config_file_name)) THEN BEGIN 

    label = 'REFRESHING LIST OF JOBS ... '
    putButtonValue, Event, 'refresh_list_of_jobs_button', label

    text = '> Reading Log File (' + (*global).config_file_name + '):'
    AppendLogBookMessage, Event, text
    
    iJob = OBJ_NEW('IDLreadLogFile',Event)
    IF (OBJ_VALID(iJob)) THEN BEGIN

;        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING ;worked

        pMetadata = iJob->getStructure()
        (*(*global).pMetadata) = pMetadata
        pMetadataValue = iJob->getMetadata()
        (*(*global).pMetadataValue) = pMetadataValue

        text = '-> Create Tree ... ' + PROCESSING
        AppendLogBookMessage, Event, text
        iDesign = OBJ_NEW('IDLmakeTree', Event, pMetadata)
        IF (OBJ_VALID(iDesign)) THEN BEGIN
            putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING ;worked
            OBJ_DESTROY, iDesign
        ENDIF ELSE BEGIN
            putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING ;worked
        ENDELSE

;select the first one by default and display value of this one in table
        select_first_node, Event ;Gui
        display_contain_OF_job_status, Event, 0
        
;put time stamp
        updateRefreshButtonLabel, Event ;_GUI
        
;activate refresh button
        activate_refresh = 1
        
;keep record that the first node is selected
        (*global).igs_selected_index = 0
        
    ENDIF ELSE BEGIN ;error refreshing the config file (clear widget_tree)
        
;        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING ;worked

        label = 'NO MORE JOBS TO LIST !'
        putButtonValue, Event, 'refresh_list_of_jobs_button', label
        
;desactivate refresh button
        activate_refresh = 0
        
        error = 0
        CATCH, error
        IF (error NE 0) THEN BEGIN
            CATCH,/CANCEL
        ENDIF ELSE BEGIN
            WIDGET_CONTROL, (*global).TreeID, /DESTROY
        ENDELSE
        
    ENDELSE
    OBJ_DESTROY, iJob
    
;disable or not the REFRESH button and the remove button
    activate_button, Event, 'refresh_list_of_jobs_button', activate_refresh
    activate_button, Event, 'job_status_remove_folder', activate_refresh
    
;if no more files, cleanup table and disable output base
    IF (activate_refresh EQ 0) THEN BEGIN
        tableValue = getTableValue(Event,'job_status_table')
        column = (size(tableValue))(1)
        row    = (size(tableValue))(2)
        aTable = STRARR(column, row)
        putTableValue, Event, 'job_status_table', aTable
        SensitiveBase, Event, 'job_status_output_base', 0
    ENDIF

ENDIF ELSE BEGIN

;disable or not the REFRESH button and the remove button
    activate_button, Event, 'refresh_list_of_jobs_button', 0
    activate_button, Event, 'job_status_remove_folder', 0

ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO refresh_job_status, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

label = 'REFRESHING LIST OF JOBS ... '
putButtonValue, Event, 'refresh_list_of_jobs_button', label

pMetadata = (*(*global).pMetadata)
iDesign = OBJ_NEW('IDLrefreshTree', Event, pMetadata)
OBJ_DESTROY, iDesign

;put time stamp
updateRefreshButtonLabel, Event ;_GUI

END

;------------------------------------------------------------------------------
PRO display_contain_OF_job_status, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global

aMetadataValue = (*(*(*global).pMetadataValue))
Nbr_metadata  = (size(aMetadataValue))(2)
aTable = STRARR(2,Nbr_metadata)

aTable[0,*] = aMetadataValue[0,*]
aTable[1,*] = aMetadataValue[index+1,*]

putTableValue, Event, 'job_status_table', aTable
FileFoundStatus = AreAllFilesFound(Event, index)
updateJobStatusOutputBase, Event, FileFoundStatus ;Gui

;determine default output file name
default_output_file_name = determine_default_output_file_name(Event,index)
;put name in output text box
putTextinTextField, Event, $
  'job_status_output_file_name_text_field',$
  default_output_file_name

END

;------------------------------------------------------------------------------
PRO job_status_folder_button, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

title = 'Select a default folder name'
path  = (*global).output_plot_path

result = DIALOG_PICKFILE(TITLE = title,$
                         /DIRECTORY,$
                         /MUST_EXIST,$
                         PATH = path)

IF (result NE '') THEN BEGIN
    SetButton, event, 'job_status_output_path_button', result
    (*global).output_plot_path = result
ENDIF
END
                         
;------------------------------------------------------------------------------
PRO stitch_files, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;build command line
stitch_driver = (*global).stitch_driver

;retrieve list of files
index = (*global).igs_selected_index
pMetadata       = (*(*global).pMetadata)
aMetadataValue  = (*(*(*global).pMetadataValue))
path            = aMetadataValue[index+1,7]
nbr_files       = N_ELEMENTS(*(*pMetadata)[index].files)
str_OF_files    = ''
i = 0
WHILE (i LT nbr_files) DO BEGIN
    IF (i GT 0) THEN BEGIN
        str_OF_files += ' '
    ENDIF
    file_name_full  = (*(*pMetadata)[index].files)[i]
    file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
    file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
    str_OF_files += path+file_name 
    i++
ENDWHILE

cmd = stitch_driver
cmd += ' ' + str_OF_files

;add output folder/file name
output_path = getButtonValue(Event,'job_status_output_path_button')
output_file = getTextFieldValue(Event, $
                                'job_status_output_file_name_text_field')
full_output_file_name = output_path + output_file 

;;add time_stamp to file_name
;full_output_file_name = addTimeStamp(full_output_file_name)

(*global).job_status_full_output_file_name = full_output_file_name
cmd += ' --output=' + full_output_file_name

;check if there is a rescale factor added or not
aMetadata = (*(*(*global).pMetadataValue))
scaling_flag     = STRCOMPRESS(aMetadata[index+1,73],/REMOVE_ALL)
scaling_constant = STRCOMPRESS(aMetadata[index+1,74],/REMOVE_ALL)
IF (scaling_flag EQ 'ON') THEN BEGIN
    IF (scaling_constant NE 'N/A') THEN BEGIN
        cmd += ' --rescale=' + scaling_constant
        stitch_files_step2, Event, cmd
    ENDIF ELSE BEGIN ;popup base that ask for a scaling value
        title = 'Scaling flag is ON but no value attributed to the ' + $
          'scaling value'
        iScaling = OBJ_NEW('IDscalingGUI',Event, scaling_constant,title, cmd)
        OBJ_DESTROY, iScaling
    ENDELSE
ENDIF ELSE BEGIN
    title = 'Definned the Scaling Flag/Value:'
    iScaling = OBJ_NEW('IDLscalingGUI',Event, scaling_constant,title, cmd)
    OBJ_DESTROY, iScaling
ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO stitch_files_step2, Event, cmd
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

PROCESSING            = (*global).processing
OK                    = (*global).ok
FAILED                = (*global).failed
full_output_file_name = (*global).job_status_full_output_file_name

text = '> Stitching the files:'

AppendLogBookMessage, Event, text
cmd_text = '-> ' + cmd + ' ... ' + PROCESSING
AppendLogBookMessage, Event, cmd_text

spawn, cmd, listening, err_listening
IF (err_listening[0] NE '') THEN BEGIN
    putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
    AppendLogBookMessage, Event, listening
    AppendLogBookMessage, Event, err_listening
ENDIF ELSE BEGIN
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot data
    IF (FILE_TEST(full_output_file_name)) THEN BEGIN
        text = '-> Plotting ' + full_output_file_name
        AppendLogBookMessage, Event, text

;put name of file in text field 0f output tab
        putTextInTextField, Event, 'output_plot_file_name', $
          full_output_file_name
;display metadata of selected file
    display_metadata, Event, full_output_file_name
        
;select OUTPUT tab
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id, SET_TAB_CURRENT=3

    ENDIF ELSE BEGIN

        text = '-> File ' + full_output_file_name + ' can not be found !'
        AppendLogBookMessage, Event, text
        result = DIALOG_MESSAGE('ERROR PLOTTING ' + full_output_file_name,$
                                /ERROR,$
                                /CENTER)
    ENDELSE

ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO remove_job_status_folder, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='job_status_tree')
IF (WIDGET_INFO(id, /TREE_SELECT) EQ -1) THEN BEGIN
    result = DIALOG_MESSAGE('Please Select a Folder First!',$
                            /INFORMATION,$
                            /CENTER)
ENDIF ELSE BEGIN
    index_selected = (*global).igs_selected_index
;remove given folder from config file
    iRemove = OBJ_NEW('IDLremoveFolderFromConfig',Event,index_selected)
    OBJ_DESTROY, iRemove
;refresh widget_tree
    create_job_status, Event
ENDELSE
END

;------------------------------------------------------------------------------
PRO browse_list_OF_job, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

path  = (*global).output_plot_path
title = 'Select all the files you want to stitch'

list_OF_files = DIALOG_PICKFILE(TITLE  = title,$
                                PATH   = path,$
                                /MUST_EXIST,$
                                FILTER = '*.txt',$
                                /MULTIPLE_FILES)
IF (list_OF_files[0] NE '') THEN BEGIN ;add these files to config file
    iFile = OBJ_NEW('IDLaddBrowsedFilesToConfig', Event, list_OF_files)
    IF (OBJ_VALID(iFile)) THEN BEGIN
        create_job_status, Event
        OBJ_DESTROY, iFile
    ENDIF
ENDIF
END

;------------------------------------------------------------------------------
PRO getOutErrFile, Event, uname, leaf_index
WIDGET_CONTROL, Event.top, GET_UVALUE=global

pMetadata        = (*(*global).pMetadata)
job_status_uname = (*(*global).job_status_uname)

;get only the first part of the uname and find the folder index
split_array  = STRSPLIT(uname,'|',/EXTRACT)
folder_uname = STRCOMPRESS(split_array[0],/REMOVE_ALL)
leaf_uname   = split_array[1]

index = WHERE(folder_uname EQ job_status_uname, nbr)
IF (nbr GT 0) THEN BEGIN
;get output path
    aMetadataValue = (*(*(*global).pMetadataValue))
    path = aMetadataValue[index+1,7]
;get output path
    out_files = (*(*pMetadata)[index].out_files)

    out_files = out_files[leaf_index]
    out_file  = STRSPLIT(out_files,':',/EXTRACT)
    out_file  = STRCOMPRESS(out_file[1],/REMOVE_ALL)
    err_files = (*(*pMetadata)[index].err_files)
    err_files = err_files[leaf_index]
    err_file  = STRSPLIT(err_files,':',/EXTRACT)
    err_file  = STRCOMPRESS(err_file[1],/REMOVE_ALL)
    full_out_file = path + out_file
    full_err_file = path + err_file
;display file into widget_text
    display_file, Event, full_out_file, 'job_status_std_out_text'
    label = 'Stdout: ' + full_out_file
    putTextFieldValue, Event, 'job_status_std_out_label', label[0], 0
    display_file, Event, full_err_file, 'job_status_std_err_text'
    label = 'Stderr: ' + full_err_file
    putTextFieldValue, Event, 'job_status_std_err_label', label[0], 0
ENDIF
END

;------------------------------------------------------------------------------
PRO display_file, Event, file_name, uname
IF (FILE_TEST(file_name)) THEN BEGIN ;file exist
    file_size = FILE_LINES(file_name)
    IF (file_size GT 0) THEN BEGIN
        file_array = STRARR(file_size)
        OPENR, 1, file_name
        READF, 1, file_array
        CLOSE, 1
        putTextFieldValue, Event, uname, file_array, 0
    ENDIF ELSE BEGIN            ;end of empty file
        file_array = ['Empty File!']
        putTextFieldValue, Event, uname, file_array, 0
    ENDELSE
ENDIF ELSE BEGIN
    file_array = ['File Does not Exist!']
    putTextFieldValue, Event, uname, file_array, 0
ENDELSE
END

;------------------------------------------------------------------------------
PRO cleanup_err_out_widget_text, Event
;out file
putTextFieldValue, Event, $
  'job_status_std_out_text', $
  'No File Selected!',$
  0
label = 'Stdout: N/A'
putTextFieldValue, Event, 'job_status_std_out_label', label[0], 0
;err file
putTextFieldValue, Event, $
  'job_status_std_err_text',$
  'No File Selected!',$
  0
label = 'Stderr: N/A'
putTextFieldValue, Event, 'job_status_std_err_label', label[0], 0
END


