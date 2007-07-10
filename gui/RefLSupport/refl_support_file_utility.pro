;This function returns 1 if the first button is validated
;and 0 if it's the second
FUNCTION getButtonValidated, Event, uname
TOFid = widget_info(Event.top,find_by_uname=uname)
widget_control, TOFid, get_value=value
return, value
END


;This function returns 1 if the input can be turned into
;a float, and 0 if it can't
FUNCTION isValueFloat, textString
error_plot_status = 0
catch, error_plot_status
;first remove spaces
textString = strcompress(textString,/remove_all)
if (error_plot_status NE 0) then begin
    return, 0
endif else begin
    b=float(textString)
endelse
RETURN, 1
END


;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = string
RETURN, string
END


;This function checks the Input File Format GUI
;and returns:
; - 0 if it's ok
; - 1 if data reduction is blank with TOF
; - 2 if angle is blank with TOF
; - 3 if data reduction value is wrong with TOF
; - 4 if angle value is wrong with TOF
FUNCTION InputParameterStatus, Event

isTOFselected = getButtonValidated(Event,'InputFileFormat')
if (isTOFselected EQ 0) then begin ;TOF is selected
  
    distanceTextFieldValue = $
      getTextFieldValue(Event,$
                        'ModeratorDetectorDistanceTextField')
    distanceTextFieldValue = strcompress(distanceTextFieldValue,/remove_all)
;distance text field is blank
    if (distanceTextFieldValue EQ '') then begin
        return, 1
    endif else begin
;distance text field can't be turned into a float
        if (isValueFloat(distanceTextFieldValue) NE 1) then begin
            return, 3
        endif
    endelse
    
    angleTextFieldValue = $
      getTextFieldValue(Event,$
                        'AngleTextField')
    angleTextFieldValue = strcompress(angleTextFieldValue,/remove_all)
;angle text field is blank
    if (angleTextFieldValue EQ '') then begin
        return, 2
    endif else begin
;angle text field can't be turned into a float
        if (isValueFloat(angleTextFieldValue) NE 1) then begin
            return, 4
        endif
    endelse
    return,0
endif else begin ;Q selected, so no need to check the GUI
    return,0
endelse
END




;This function returns the value found in the text field given
FUNCTION getValue, Event, uname
unameId = widget_info(Event.top,find_by_uname=uname)
widget_control,unameId,get_value=value
return, value
END


;This function returns Q1, Q2 and SF of the current selected tab
FUNCTION getQ1Q2SF, Event, TAB

IF (TAB EQ 'STEP2') then begin
    Q1 = getValue(Event, 'step2_q1_text_field')    
    Q2 = getValue(Event, 'step2_q2_text_field')
    SF = getValue(Event, 'step2_sf_text_field')
ENDIF ELSE BEGIN
    Q1 = getValue(Event, 'step3_q1_text_field')    
    Q2 = getValue(Event, 'step3_q2_text_field')
    SF = getValue(Event, 'step3_sf_text_field')
ENDELSE
Q1Q2SF = [float(Q1),float(Q2),float(SF)]
RETURN, Q1Q2SF
END


;This function gives the size of the array given
;as a parameter
FUNCTION getSizeOfArray, ListOfFiles
sizeArray = size(ListOfFiles)
return, sizeArray[1]
END


;This function returns the selected index of the 'uname'
;droplist given
FUNCTION getSelectedIndex, Event, uname
TextBoxId= widget_info(Event.top, find_by_uname=uname)
TextBoxIndex= widget_info(TextBoxId,/droplist_select)
return, TextBoxIndex
END


;This function sets the selected index of the 'uname'
;droplist
PRO SetSelectedIndex, Event, uname, index
droplistId= widget_info(Event.top, find_by_uname=uname)
widget_control, droplistId, set_droplist_select = index
END



;this function gives the long name of the file selected in the uname droplist
FUNCTION getLongFileNameSelected, Event, uname
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get the selected index of the load list droplist
TextBoxIndex = getSelectedIndex(Event, uname)
ListOfLongFileName = (*(*global).ListOfLongFileName)
LongFileName = ListOfLongFileName[TextBoxIndex]
return, LongFileName
END


;This functions gives the index of the color selected
FUNCTION getColorIndex, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
list_of_color_slider_id = widget_info(event.top,find_by_uname='list_of_color_slider')
widget_control, list_of_color_slider_id, get_value = colorIndex
return, colorIndex
END


;This function checks if the newly loaded file has alredy
;been loaded. Return 1 if yes and 0 if not
FUNCTION isFileAlreadyInList, ListOfFiles, file
sizeArray = size(ListOfFiles)
size = sizeArray[1]
for i=0, (size-1) do begin
    if (ListOfFiles[i] EQ file) then begin
        return, 1
    endif
endfor
return, 0
end


;this function return 1 if the ListOfFiles is empty (first load)
;otherwise it returns 0
FUNCTION isListOfFilesSize0, ListOfFiles
sizeArray = size(ListOfFiles)
if (sizeArray[1] EQ 1) then begin
    ;check if argument is empty string
    if (ListOfFiles[0] EQ '') then begin
        return, 1
    endif else begin
        return, 0
    endelse
endif else begin
    return, 0
endelse
end


;This function remove the short file name and keep
;the path and reset the default working path
Function DEFINE_NEW_DEFAULT_WORKING_PATH, Event, file
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
path = get_path_to_file_name(file)
(*global).input_path = path ;reset the default path
return, path
end


;this function display the OPEN FILE from IDL
;get global structure
Function OPEN_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
title    = 'Select file:'
filter   = '*' + (*global).file_extension
pid_path = (*global).input_path
;open file
FullFileName = dialog_pickfile(path=pid_path,$
                               get_path=path,$
                               title=title,$
                               filter=filter)
;redefine the working path
path = define_new_default_working_path(Event,FullFileName)
return, FullFileName
end


;This functions populate the various droplist boxes
;It also checks if the newly file loaded is not already 
;present in the list, in this case, it's not added
PRO add_new_file_to_droplist, Event, ShortFileName, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
ListOfFiles = (*(*global).list_of_files)
ListOfLongFileName = (*(*global).ListOfLongFileName)
;is is the first file loaded
if (isListOfFilesSize0(ListOfFiles) EQ 1) then begin
    ListOfFiles = [ShortFileName]
    ListOfLongFileName = [LongFileName]
    ActivateRescaleBase,Event,1
;if not
endif else begin
   ;is this file not already listed 
   if(isFileAlreadyInList(ListOfFiles,ShortFileName) EQ 0) then begin ;true newly file
          (*global).FirstTimePlotting = 0 ;next load won't be the first one anymore
          ListOfFiles = [ListOfFiles,ShortFileName]
          ListOfLongFileName = [ListOfLongFileName,LongFileName]
          CreateArrays,Event    ;if a file is added, the Q1,Q2,SF... arrays are updated
    endif
endelse
(*(*global).list_of_files) = ListOfFiles
(*(*global).ListOfLongFileName) = ListOfLongFileName
;update GUI
updateGUI,Event, ListOfFiles
end


;This function updates the GUI
;droplist, buttons...
PRO updateGUI, Event, ListOfFiles
updateDropList, Event, ListOfFiles
ArraySize = getSizeOfArray(ListOfFiles)
if (ArraySize EQ 0) then begin
   validate = 0
endif else begin
   validate = 1
endelse
EnableStep1ClearFile, Event, validate
SelectLastLoadedFile, Event
EnableMainBaseButtons, Event, validate
ActivateClearFileButton, Event, validate
ActivateColorSlider, Event, Validate
END


;This functions displays the first few lines of the newly loaded file
PRO display_info_about_selected_file, Event, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
no_file = 0
nbr_line = (*global).NbrInfoLineToDisplay
catch, no_file
if (no_file NE 0) then begin
    plot_file_found = 0    
endif else begin
    openr,u,LongFileName,/get
    fs = fstat(u)
;define an empty string variable to hold results from reading the file
    tmp = ''
    while (NOT eof(u)) do begin
        readu,u,onebyte         ;,format='(a1)'
        fs = fstat(u)
        if fs.cur_ptr EQ 0 then begin
            point_lun,u,0
        endif else begin
            point_lun,u,fs.cur_ptr - 4
        endelse
        info_array = strarr(nbr_line)
        for i=0,(nbr_line) do begin
            readf,u,tmp
            info_array[i] = tmp
        endfor
    endwhile
    close,u
    free_lun,u
endelse
;populate text box with array
TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_value=info_array[0]
for i=1,(nbr_line-1) do begin
    widget_control, TextBoxId, set_value=info_array[i],/append
endfor
end


;this function clear the info text box
PRO clear_info_about_selected_file, Event
TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_value=''
END


;this function creates and update the Q1, Q2, SF... arrays when a file is added
PRO CreateArrays, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
SF_array = (*(*global).SF_array)
color_array = (*(*global).color_array)
FileHistory = (*(*global).FileHistory)

Q1_array = [Q1_array,0]
Q2_array = [Q2_array,0]
SF_array = [SF_array,0]
colorIndex = getColorIndex(Event)
color_array = [color_array, colorIndex]
FileHistory = [FileHistory,'']

(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array
(*(*global).SF_array) = SF_array
(*(*global).color_array) = color_array
(*(*global).FileHistory) = FileHistory
END


;this function removes from the Q1,Q2,SF and List_of_files, the info at 
;given index iIndex
PRO RemoveIndexFromArray, Event, iIndex
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check size of array
ListOfFiles = (*(*global).list_of_files)
ListOfFilesSize = getSizeOfArray(ListOfFiles)

;if array contains only 1 element, reset all arrays
if (ListOfFilesSize EQ 1) then begin
   ResetArrays,Event
   ActivateRescaleBase, Event, 0
endif else begin
   RemoveIndexFromList, Event, iIndex
endelse
END


;This function reset all the arrays (Q1,Q2,SF,list_of_files and ListOfLongFileName)
PRO ResetArrays, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

list_of_files      = strarr(1)
Q1_array           = lonarr(1)
Q2_array           = lonarr(1)
SF_array           = lonarr(1)
color_array        = lonarr(1)
color_array[0]     = getColorIndex(Event)
ListOfLongFileName = strarr(1)
FileHistory        = strarr(1)

(*(*global).list_of_files)      = list_of_files
(*(*global).Q1_array)           = Q1_array
(*(*global).Q2_array)           = Q2_array
(*(*global).SF_array)           = SF_array
(*(*global).color_array)        = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
(*(*global).FileHistory)        = FileHistory

EnableMainBaseButtons, Event, 0
END


;this function does a full true reset of color index
;ie: is reset to 100/red
PRO ReinitializeColorArray, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

color_array               = lonarr(1)
color_array[0]            = (*global).ColorSliderDefaultValue
(*(*global).color_array)  = color_array
END


;This function remove the value at the index iIndex
PRO RemoveIndexFromList, Event, iIndex
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

FileHistory = (*(*global).FileHistory)
ListOfFiles = (*(*global).list_of_files)
Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
SF_array = (*(*global).SF_array)
color_array = (*(*global).color_array)
ListOfLongFileName = (*(*global).ListOfLongFileName)

FileHistory        = ArrayDelete(FileHistory,At=iIndex,Length=1)
ListOfFiles        = ArrayDelete(ListOfFiles,AT=iIndex,Length=1)
Q1_array           = ArrayDelete(Q1_array,AT=iIndex,Length=1)
Q2_array           = ArrayDelete(Q2_array,AT=iIndex,Length=1)
SF_array           = ArrayDelete(SF_array,AT=iIndex,Length=1)
color_array        = ArrayDelete(color_array,AT=iIndex,Length=1)
ListOfLongFileName = ArrayDelete(ListOfLongFileName,AT=iIndex,Length=1)

(*(*global).FileHistory)       = FileHistory
(*(*global).list_of_files)     = ListOfFiles
(*(*global).Q1_array)          = Q1_array
(*(*global).Q2_array)          = Q2_array
(*(*global).SF_array)          = SF_array
(*(*global).color_array)       = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
END


;This function save Q1, Q2 and SF of the Critical Edge file selected
PRO SaveQofCE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
SF_array = (*(*global).SF_array)
FileHistory = (*(*global).FileHistory)

;get name of selected CE file
base_file_droplist_id = widget_info(Event.top,find_by_uname='base_file_droplist')
widget_control,base_file_droplist_id, get_value=list
value = widget_info(base_file_droplist_id,/droplist_select)
FileHistory[0] = list[value]

;get Q1, Q2 and SF (float)
Q1Q2SF = getQ1Q2SF(Event,'STEP2')
Q1 = Q1Q2SF[0]
Q2 = Q1Q2SF[1]
SF = Q1Q2SF[2]

Q1_array[0] = Q1
Q2_array[0] = Q2
SF_array[0] = SF

(*(*global).Q1_array)    = Q1_array
(*(*global).Q2_array)    = Q2_array
(*(*global).SF_array)    = SF_array
(*(*global).FileHistory) = FileHistory

;fit current data file selected
LongFileName = getLongFileNameSelected(Event,'base_file_droplist')
FitFunction, Event, LongFileName, Q1, Q2
END


;This function assign to the current selected file the current
;selected color
PRO AssignColorToSelectedPlot, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
colorIndex = getColorIndex(Event)
fileIndex = getSelectedIndex(Event, 'list_of_files_droplist')
color_array = (*(*global).color_array)
color_array[fileIndex] = colorIndex
(*(*global).color_array) = color_array
END


;This function automatically selects the last loaded file
PRO SelectLastLoadedFile, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
ListOfFiles = (*(*global).list_of_files)
NbrOfFiles = getSizeOfArray(ListOfFiles)
SetSelectedIndex, Event, 'list_of_files_droplist', (NbrOfFiles-1)
END


;This function reset various parameters when a new session is launched (full reset)
PRO ResetAllOtherParameters, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
(*global).FirstTimePlotting = 1 ;next load will be the first one
END


;This function reinitialize the Rescale base
PRO ResetRescaleBase,Event
;reset X and Y, Min and Max text fields
XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
XYMinMax = [XminId, XmaxId, YminId, YmaxId]
for i=0,3 do begin
   widget_control, XYMinMax[i], set_value=''
endfor
;reset X and Y lin/log
XaxisLinLogId = widget_info(Event.top,find_by_uname='XaxisLinLog')
YaxisLinLogId = widget_info(Event.top,find_by_uname='YaxisLinLog')
widget_control, XaxisLinLogId, set_value=0
widget_control, YaxisLinLogId, set_value=0
END

;This function takes care of launching the plot function in the right mode
PRO DoPlot, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get index of current tab selected
steps_tab_id = widget_info(Event.top, find_by_uname='steps_tab')
CurrTabSelect = widget_info(steps_tab_id,/tab_current) ;current tab selected
CASE (CurrTabSelect) OF
   0: begin                     ;if the first tab is selected
      ListLongFileName = (*(*global).ListOfLongFileName)
      plot_loaded_file, Event, ListLongFileName
   end
   1: begin                     ;if the second tab is selected
      LongFileName = getLongFileNameSelected(Event,'base_file_droplist') 
      LongFileNameArray = strarr(1)
      LongFileNameArray[0]=LongFileName
      plot_loaded_file, Event,LongFileNameArray   
   end
   2: begin                     ;if the third tab is selected
      LongFileName1 = getLongFileNameSelected(Event,'step3_base_file_droplist')
      LongFileName2 = getLongFileNameSelected(Event,'step3_work_on_file_droplist')
      if (LongFileName1 NE LongFileName2) then begin
         ListLongFileName = [LongFileName1,LongFileName2]
      endif else begin
         ListLongFileName = [LongFileName1]
      endelse
   plot_loaded_file, Event, ListLongFileName
   end
ENDCASE
END


PRO populateColorLabel, Event, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
SelectedIndex = getSelectedIndex(Event,'list_of_files_droplist')
ListShortFileName = (*(*global).list_of_files)
fileName = ListShortFileName[SelectedIndex]
fileName = '(-> ' + fileName + ')'
ColorLabelIndex = widget_info(Event.top,find_by_uname='ColorFileLabel')
widget_control, ColorLabelIndex, set_value=fileName
END


;this function activate (if validateMap=1) or desactive-hide(if validateMap=0)
;the RescaleBase
PRO ActivateRescaleBase, Event, validateMap
RescaleBaseId = widget_info(Event.top,find_by_uname='RescaleBase')
widget_control, RescaleBaseId, map=validateMap
END


;This function activates or not the CLEAR file button
PRO ActivateClearFileButton, Event, ValidateButton
ClearButtonId = widget_info(Event.top,find_by_uname='clear_button')
widget_control, ClearButtonId, sensitive=ValidateButton
END


;This function clear the contain of the color label 
PRO ClearColorLabel, Event
ColorFileLabelId = widget_info(Event.top,find_by_uname='ColorFileLabel')
widget_control, ColorFileLabelId, set_value=''
END

