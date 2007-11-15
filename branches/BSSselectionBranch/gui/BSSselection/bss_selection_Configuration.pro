PRO RetrieveSelectionParameters, Event, SelectionParameters

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

SelectionParameters.RunNumber           = getRunNumber(Event)
SelectionParameters.RoiFile             = (*global).SavedRoiFullFileName
SelectionParameters.ColorVerticalGrid   = (*global).ColorVerticalGrid
SelectionParameters.ColorHorizontalGrid = (*global).ColorHorizontalGrid
SelectionParameters.ColorExcludedPixels = (*global).ColorExcludedPixels
SelectionParameters.ColorSelectedPixels = (*global).ColorSelectedPixels
SelectionParameters.ExcludedPixelSymbol = getExcludedPixelSymbol(Event)
print, SelectionParameters.ExcludedPixelSymbol


END
