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




;excluse pixel that have value less or equal to X
PRO  BSSreduction_ExcludedPixelCounts, Event

;retrieve counts value
low_counts  = getCountsToExcludeValue_lowrange(Event)
high_counts = getCountsToExcludeValue_highrange(Event)

;remove pixel that have value <= counts
AddPixelsToExcludedList, Event, low_counts, high_counts

;replot
PlotIncludedPixels, Event

END
