;Pixelid
PRO BSSselection_ExcludePixelid, Event
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
END

PRO BSSselection_IncludePixelid, Event
END


;Pixel Row
PRO BSSselection_ExcludePixelRow, Event
END

PRO BSSselection_IncludePixelRow, Event
END


;Tube
PRO BSSselection_ExcludeTube, Event
END

PRO BSSselection_IncludeTube, Event
END
