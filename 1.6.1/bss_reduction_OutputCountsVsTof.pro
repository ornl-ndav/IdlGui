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

PRO BSSreduction_UpdatePreviewText, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get message to add
message = getgetCountsVsTofMessageToAdd(Event)

IF (message NE '') THEN BEGIN
    PreviewCountsVsTofAsciiArray = (*(*global).PreviewCountsVsTofAsciiArray)
    message = '#Notes: ' + string(message)
    (*global).OutputMessageToAdd = message
    NewPreview = [message,PreviewCountsVsTofAsciiArray]
;display preview
    putPreviewCountsVsTofArray, Event, NewPreview
ENDIF

END

;this function is going to retrive the tof array
FUNCTION retrieveTOF, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

FullNexusName = (*global).NexusFullName
fileID  = h5f_open(FullNexusName)

;get tof
fieldID = h5d_open(fileID,(*global).tof_path)
RETURN, h5d_read(fieldID)
END


PRO BSSreduction_CreatePreviewOfCountsVsTofData, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get tof array (column #1)
tof_array = retrieveTOF(Event)

;counts (column #2)
full_counts_vs_tof_data = (*(*global).full_counts_vs_tof_data)

;err (column #3)
err_full_counts_vs_tof_data = SQRT(full_counts_vs_tof_data)

;size of array 
sz = (*global).NbTOF

;array to create
CountsVsTofAsciiArray = strarr(sz)
CountsVsTofAsciiArray[0] = (*global).output_full_counts_vs_tof_legend

FOR i=0,(sz-1) DO BEGIN
    line =  strcompress(tof_array[i],/remove_all) + ' '
    line += strcompress(full_counts_vs_tof_data[i],/remove_all) + ' '
    line += strcompress(err_full_counts_vs_tof_data[i],/remove_all)
    CountsVsTofAsciiArray[i] = line
ENDFOR

;add legend
CountsVsTofAsciiArray = [(*global).output_full_counts_vs_tof_legend , $
                         CountsVsTofAsciiArray]

(*(*global).CountsVsTofAsciiArray) = CountsVsTofAsciiArray

;create preview file
IF (sz GT 20) THEN BEGIN
    PreviewCountsVsTofAscii = CountsVsTofAsciiArray[0:10]
    PreviewCountsVsTofAscii = [PreviewCountsVsTofAscii,'...']
    PreviewCountsVsTofAscii = [PreviewCountsVsTofAscii,CountsVsTofAsciiArray[sz-11:sz-1]]
ENDIF ELSE BEGIN
    PreviewCountsVsTofAscii = CountsVsTofAsciiArray[0:sz-1]
ENDELSE

(*(*global).PreviewCountsVsTofAsciiArray) = PreviewCountsVsTofAscii

;display preview
putPreviewCountsVsTofArray, Event, PreviewCountsVsTofAscii

END



PRO BSSreduction_GetNewPath, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get value of button
current_path = (*global).counts_vs_tof_path

new_path = dialog_pickfile(PATH = current_path,$
                           TITLE = 'Select Counts vs TOF output ASCII file destination folder',$
                           /DIRECTORY)

IF (new_path NE '') THEN BEGIN
    
    (*global).counts_vs_tof_path = new_path
    
    path_to_display = new_path
    putCountsVsTofPathButtonValue, Event, path_to_display

;gives new Counts vs tof output path in LogBook
    LogBookText = 'A new output path for the Counts vs TOF ASCII file has been set:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> Path was    : ' + current_path
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> Path is now : ' + new_path
    AppendLogBookMessage, Event, LogBookText

;put new path and file name in Counts vs tof ascii file text
    BSSreduction_CreateOutputCountsVsTofFileName, Event

ENDIF
END



PRO BSSreduction_CreateOutputCountsVsTofFileName, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path = (*global).Counts_vs_tof_path
first_part = 'BASIS_'

RunNumber = (*global).RunNumber
IF (RunNumber NE '') THEN BEGIN
    first_part += strcompress(RunNumber,/remove_all) + '_'
ENDIF

get_iso8601, second_part
ext_part = (*global).counts_vs_tof_ext

name = path + first_part + second_part + ext_part

;put new name into field
putCountsVsTofFileName, Event, name

END



PRO BSSreduction_OuputCoutsVsTofInitialization, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create output counts vs tof file name
BSSreduction_CreateOutputCountsVsTofFileName, Event

;populate preview text
BSSreduction_CreatePreviewOfCountsVsTofData, Event

;activate Output counts vs tof base
activate_output_couts_vs_tof_base, Event, 1
END



PRO BSSreduction_CreateOutputCountsVsTofFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

messageToAdd = (*global).OutputMessageToAdd
CountsVsTofAsciiArray = (*(*global).CountsVsTofAsciiArray)
OutputArray = [messageToAdd,CountsVsTofAsciiArray]
sz = (size(OutputArray))(1)

;get output file name
OutputFileName = getOuptoutAsciiFileName(Event)

error = 0
CATCH, error

IF (error NE 0) then begin

    CATCH, /CANCEL
    LogBookText = 'ERROR: Counts vs TOF ASCII file has not been saved:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> Counts vs TOF file name: ' + OutputFileName
    AppendLogBookMessage, Event, LogBookText
    MessageBox = 'Counts vs TOF ASCII File Creation -> ERROR !'

ENDIF ELSE BEGIN
    
;open output file
    openw, 1, OutputFileName
    
    FOR i=0,(sz-1) DO BEGIN
        
        text = OutputArray[i]
        printf, 1, text
        
    ENDFOR

    MessageBox = 'Counts vs TOF ASCII File creation -> OK !'

    LogBookText = 'ASCII file of the Counts vs TOF of all the included pixels has been created: '
    LogBookText += OutputFileName
    AppendLogBookMessage, Event, LogBookText
    
ENDELSE

close, 1
free_lun, 1

putMessageBoxInfo, Event, MessageBox

END






