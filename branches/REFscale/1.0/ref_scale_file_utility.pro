



;This function defines the new color and moves the slider if necessary
PRO defineColorIndex, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
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
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
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



















;This function reset various parameters when a new session is launched (full reset)
PRO ResetAllOtherParameters, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
(*global).FirstTimePlotting = 1 ;next load will be the first one
END





PRO populateColorLabel, Event, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
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

;-------------------------------------------------------------------------------
PRO ref_scale_file_utility
END
