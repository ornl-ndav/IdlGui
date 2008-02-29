



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






;This function remove the short file name and keep
;the path and reset the default working path
Function DEFINE_NEW_DEFAULT_WORKING_PATH, Event, file
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
path = get_path_to_file_name(file)
(*global).input_path = path ;reset the default path
return, path
end






; This function updates the GUI
; droplist, buttons...
; PRO updateGUI, Event, ListOfFiles
; ReflSupportWidget_updateDropList, Event, ListOfFiles
; ArraySize = getSizeOfArray(ListOfFiles)
; if (ArraySize EQ 0) then begin
;    validate = 0
; endif else begin
;    if (ListOfFiles[0] EQ '') then begin
;       validate = 0
;    endif else begin
;       validate = 1
;    endelse
; endelse
; EnableStep1ClearFile, Event, validate
; SelectLastLoadedFile, Event
; EnableMainBaseButtons, Event, validate
; ActivateClearFileButton, Event, validate
; ActivateColorSlider, Event, Validate
; ActivatePrintFileButton, Event, Validate
; EnableMainBaseButtons, Event, validate
; END

; c
















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



