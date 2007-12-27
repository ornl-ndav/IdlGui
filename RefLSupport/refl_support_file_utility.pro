;This function sets the selected index of the 'uname'
;droplist
PRO SetSelectedIndex, Event, uname, index
droplistId= widget_info(Event.top, find_by_uname=uname)
widget_control, droplistId, set_droplist_select = index
END




;This function defines the new color and moves the slider if necessary
PRO defineColorIndex, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
list_of_color_slider_id = widget_info(event.top,find_by_uname='list_of_color_slider')
widget_control, list_of_color_slider_id, get_value = ColorIndex

PreviousColorIndex = (*global).PreviousColorIndex
if (ColorIndex EQ (PreviouscolorIndex)) Then begin
    ColorIndex += 25
    MoveColorIndex,Event,ColorIndex
    (*global).PreviousColorIndex = ColorIndex
endif 
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






;This function updates the GUI
;droplist, buttons...
PRO updateGUI, Event, ListOfFiles
ReflSupportWidget_updateDropList, Event, ListOfFiles
ArraySize = getSizeOfArray(ListOfFiles)
if (ArraySize EQ 0) then begin
   validate = 0
endif else begin
   if (ListOfFiles[0] EQ '') then begin
      validate = 0
   endif else begin
      validate = 1
   endelse
endelse
EnableStep1ClearFile, Event, validate
SelectLastLoadedFile, Event
EnableMainBaseButtons, Event, validate
ActivateClearFileButton, Event, validate
ActivateColorSlider, Event, Validate
ActivatePrintFileButton, Event, Validate
EnableMainBaseButtons, Event, validate
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
    info_array = strarr(nbr_line)
    for i=0,(nbr_line-1) do begin
        readf,u,tmp
        info_array[i] = tmp
    endfor
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
PRO ReflSupportFileUtility_CreateArrays, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;number of files loaded
(*global).NbrFilesLoaded += 1

Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)
Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
SF_array = (*(*global).SF_array)
angle_array = (*(*global).angle_array)
color_array = (*(*global).color_array)
FileHistory = (*(*global).FileHistory)

Qmin_array = [Qmin_array,0]
Qmax_array = [Qmax_array,0]
Q1_array = [Q1_array,0]
Q2_array = [Q2_array,0]
SF_array = [SF_array,0]

;get current angle value entered
angleValue = (*global).angleValue
angle_array = [angle_array,angleValue]

colorIndex = getColorIndex(Event)
color_array = [color_array, colorIndex]
FileHistory = [FileHistory,'']

(*(*global).Qmin_array) = Qmin_array
(*(*global).Qmax_array) = Qmax_array
(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array
(*(*global).SF_array) = SF_array
(*(*global).angle_array) = angle_array
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
   (*global).NbrFilesLoaded = 0
endif else begin
   RemoveIndexFromList, Event, iIndex
   (*global).NbrFilesLoaded -= 1
endelse
END


;This function reset all the arrays (Q1,Q2,SF,list_of_files and ListOfLongFileName)
PRO ResetArrays, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

list_of_files      = strarr(1)
Qmin_array         = fltarr(1)
Qmax_array         = fltarr(1)
Q1_array           = lonarr(1)
Q2_array           = lonarr(1)
SF_array           = lonarr(1)
angle_array        = fltarr(1)
color_array        = lonarr(1)
color_array[0]     = getColorIndex(Event)
ListOfLongFileName = strarr(1)
FileHistory        = strarr(1)

(*(*global).list_of_files)      = list_of_files
(*(*global).Qmin_array)         = Qmin_array
(*(*global).Qmax_array)         = Qmax_array
(*(*global).Q1_array)           = Q1_array
(*(*global).Q2_array)           = Q2_array
(*(*global).SF_array)           = SF_array
(*(*global).angle_array)        = angle_array
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
Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)
Q1_array = (*(*global).Q1_array)
Q2_array = (*(*global).Q2_array)
SF_array = (*(*global).SF_array)
angle_array = (*(*global).angle_array)
color_array = (*(*global).color_array)
ListOfLongFileName = (*(*global).ListOfLongFileName)

FileHistory        = ArrayDelete(FileHistory,At=iIndex,Length=1)
ListOfFiles        = ArrayDelete(ListOfFiles,AT=iIndex,Length=1)
Qmin_array         = ArrayDelete(Qmin_array,AT=iIndex,Length=1)
Qmax_array         = ArrayDelete(Qmax_array,AT=iIndex,Length=1)
Q1_array           = ArrayDelete(Q1_array,AT=iIndex,Length=1)
Q2_array           = ArrayDelete(Q2_array,AT=iIndex,Length=1)
SF_array           = ArrayDelete(SF_array,AT=iIndex,Length=1)
angle_array        = ArrayDelete(angle_array,AT=iIndex,Length=1)
color_array        = ArrayDelete(color_array,AT=iIndex,Length=1)
ListOfLongFileName = ArrayDelete(ListOfLongFileName,AT=iIndex,Length=1)

(*(*global).FileHistory)       = FileHistory
(*(*global).list_of_files)     = ListOfFiles
(*(*global).Qmin_array)        = Qmin_array
(*(*global).Qmax_array)        = Qmax_array
(*(*global).Q1_array)          = Q1_array
(*(*global).Q2_array)          = Q2_array
(*(*global).SF_array)          = SF_array
(*(*global).angle_array)       = angle_array
(*(*global).color_array)       = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
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
       plot_loaded_file, Event, 'all'
   end
   1: begin               ;if the second tab is selected, plot index 0 (CE file)
       plot_loaded_file, Event, 'CE'
   end
   2: begin       ;if the third tab is selected plot index and index-1

       plot_loaded_file, Event, '2plots'
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

