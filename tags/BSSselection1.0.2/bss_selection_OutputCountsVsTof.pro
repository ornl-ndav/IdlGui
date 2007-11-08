PRO BSSselection_UpdatePreviewText, Event

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


PRO BSSselection_CreatePreviewOfCountsVsTofData, Event
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



PRO BSSselection_GetNewPath, Event
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
    BSSselection_CreateOutputCountsVsTofFileName, Event

ENDIF
END



PRO BSSselection_CreateOutputCountsVsTofFileName, Event
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



PRO BSSselection_OuputCoutsVsTofInitialization, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create output counts vs tof file name
BSSselection_CreateOutputCountsVsTofFileName, Event

;populate preview text
BSSselection_CreatePreviewOfCountsVsTofData, Event

;activate Output counts vs tof base
activate_output_couts_vs_tof_base, Event, 1
END



PRO BSSselection_CreateOutputCountsVsTofFile, Event
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






