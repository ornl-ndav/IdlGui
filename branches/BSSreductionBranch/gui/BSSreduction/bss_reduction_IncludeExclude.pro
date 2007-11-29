;######################## CHECK - IN UTILITY #######################
;check if it's worth validating exclude and include buttons
PRO BSSreduction_IncludeExcludeCheckPixelField, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve text
PixelidText = getSelectionBasePixelidText(Event)
IF (PixelidText[0] NE '' AND (*global).NeXusFound EQ 1) THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activate_button, Event, 'exclude_pixelid', activate_status
activate_button, Event, 'include_pixelid', activate_status
END



PRO BSSreduction_IncludeExcludeCheckPixelRowField, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve text
RowText = getSelectionBaseRowText(Event)
IF (RowText[0] NE '' AND (*global).NeXusFound EQ 1) THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activate_button, Event, 'exclude_pixel_row', activate_status
activate_button, Event, 'include_pixel_row', activate_status
END



PRO BSSreduction_IncludeExcludeCheckTubeField, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve text
TubeText = getSelectionBaseTubeText(Event)
IF (TubeText[0] NE '' AND (*global).NeXusFound EQ 1) THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activate_button, Event, 'exclude_tube', activate_status
activate_button, Event, 'include_tube', activate_status
END





;Exclude Pixelid
PRO BSSreduction_ExcludePixelid, Event

;retrieve text
PixelidText = getSelectionBasePixelidText(Event)

;create list of pixelids
PixelidList = RetrieveList(PixelidText)

;convert list to integer
PixelidListInt = ConvertListToInt(PixelidList)

;add list of pixels to exclude list
AddListToExcludeList, Event, PixelidListInt

;add excluded pixel to bank1 and bank2
PlotExcludedPixels, Event

;remove contents of cw_field
ResetSelectionBasePixelidText, Event

;disable include and exclude buttons
BSSreduction_IncludeExcludeCheckPixelField, Event

END



;Include Pixelid
PRO BSSreduction_IncludePixelid, Event

;retrieve text
PixelidText = getSelectionBasePixelidText(Event)

;create list of pixelids
PixelidList = RetrieveList(PixelidText)

;convert list to integer
PixelidListInt = ConvertListToInt(PixelidList)

;Remove list of pixels to exclude list
RemoveListToExcludeList, Event, PixelidListInt

;remove pixel to list of excluded pixels for bank1 and bank2
PlotIncludedPixels, Event

;remove contents of cw_field
ResetSelectionBasePixelidText, Event

;disable include and exclude buttons
BSSreduction_IncludeExcludeCheckPixelField, Event

END



;Exclude Pixel Row
PRO BSSreduction_ExcludePixelRow, Event

;retrieve text
RowText = getSelectionBaseRowText(Event)

;create list of row
RowList = RetrieveList(RowText)
print, RowList
;convert list to integer
RowListInt = ConvertListToInt(RowList)

;Add list of pixels to exclude list
AddRowToExcludeList, Event, RowListInt

;remove pixel to list of excluded pixels for bank1 and bank2
PlotExcludedPixels, Event

;remove contents of cw_field
ResetSelectionBaseRowText, Event

;disable include and exclude buttons
BSSreduction_IncludeExcludeCheckPixelRowField, Event

END



PRO BSSreduction_IncludePixelRow, Event

;retrieve text
RowText = getSelectionBaseRowText(Event)

;create list of row
RowList = RetrieveList(RowText)

;convert list to integer
RowListInt = ConvertListToInt(RowList)

;Remove list of pixels to exclude list
RemoveRowToExcludeList, Event, RowListInt

;remove pixel to list of excluded pixels for bank1 and bank2
PlotIncludedPixels, Event

;remove contents of cw_field
ResetSelectionBaseRowText, Event

;disable include and exclude buttons
BSSreduction_IncludeExcludeCheckPixelRowField, Event

END





;Exclude Tube
PRO BSSreduction_ExcludeTube, Event

;retrieve text
TubeText = getSelectionBaseTubeText(Event)

;create list of tubes
TubeList = RetrieveList(TubeText)

;convert list to integer
TubeListInt = ConvertListToInt(TubeList)

;Add list of pixels to exclude list
AddTubeToExcludeList, Event, TubeListInt

;remove pixel to list of excluded pixels for bank1 and bank2
PlotExcludedPixels, Event

;remove contents of cw_field
ResetSelectionBaseTubeText, Event

;disable include and exclude buttons
BSSreduction_IncludeExcludeCheckTubeField, Event

END



;include tube
PRO BSSreduction_IncludeTube, Event

;retrieve text
TubeText = getSelectionBaseTubeText(Event)

;create list of tubes
TubeList = RetrieveList(TubeText)

;convert list to integer
TubeListInt = ConvertListToInt(TubeList)

;Remove list of pixels to exclude list
RemoveTubeToExcludeList, Event, TubeListInt

;remove pixel to list of excluded pixels for bank1 and bank2
PlotIncludedPixels, Event

;remove contents of cw_field
ResetSelectionBaseTubeText, Event

;disable include and exclude buttons
BSSreduction_IncludeExcludeCheckTubeField, Event

END
