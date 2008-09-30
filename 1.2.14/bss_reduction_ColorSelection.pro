PRO BSSreduction_ColorSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get DroplistValue
DropListValue = getColorDropListSelectedIndex(Event)

CASE (DropListValue) OF
    0: BEGIN                    ;Grid: Vertical Lines
        SliderMap = 1
        LoadctMap = 0
        SelectedIndex = (*global).ColorVerticalGrid
    END
    1: BEGIN                    ;Grid: Horizontal Lines
        SliderMap = 1
        LoadctMap = 0
        SelectedIndex = (*global).ColorHorizontalGrid
    END
    2: BEGIN                    ;Excluded pixels
        SliderMap = 1
        LoadctMap = 0
        SelectedIndex = (*global).ColorExcludedPixels
    END
    3: BEGIN
        SliderMap = 0
        LoadctMap = 1
        SelectedIndex = (*global).LoadctMainPlot
    END
ENDCASE
   
activate_base, Event, 'color_slider_base', SliderMap
activate_base, Event, 'Loadct_base', LoadctMap

SWITCH (DropListValue) OF
    0:
    1:
    2: BEGIN
;reset slider position
        SetColorSliderValue, Event, SelectedIndex
        BREAK
    END
    3: BEGIN
        SetDropListIndex, Event, SelectedIndex
    END
ENDSWITCH

END


PRO  BSSreduction_ColorSlider, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DropListValue = getColorDropListSelectedIndex(Event)
ColorValue = getColorSliderValue(Event)

CASE (DropListValue) OF
    0: BEGIN
        (*global).ColorVerticalGrid = ColorValue
        (*global).Configuration.Input.ColorVerticalGrid = ColorValue
    END
    1: BEGIN
        (*global).ColorHorizontalGrid = ColorValue
        (*global).Configuration.Input.ColorHorizontalGrid = ColorValue
    END
    2: BEGIN
        (*global).ColorExcludedPixels = ColorValue
        (*global).Configuration.Input.ColorExcludedPixels = ColorValue
    END
    else:
ENDCASE

;replot everything
IF ((*global).NeXusFound) THEN BEGIN
    PlotIncludedPixels, Event        
ENDIF

END


PRO BSSreduction_ColorLoadctDropList, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

LoadctIndex = getLoadctDropListSelectedIndex(Event)
(*global).LoadctMainPlot = LoadctIndex

;replot everything
IF ((*global).NeXusFound) THEN BEGIN
    PlotIncludedPixels, Event
ENDIF

END



PRO BSSreduction_ColorSliderReset, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get DroplistValue
DropListValue = getColorDropListSelectedIndex(Event)

CASE (DropListValue) OF
    0: BEGIN                    ;Grid: Vertical Lines
        SelectedIndex = (*global).DefaultColorVerticalGrid
        (*global).ColorVerticalGrid = SelectedIndex
        (*global).Configuration.Input.ColorVerticalGrid = SelectedIndex
        SetColorSliderValue, Event, Selectedindex
    END
    1: BEGIN                    ;Grid: Horizontal Lines
        SelectedIndex = (*global).DefaultColorHorizontalGrid
        (*global).ColorHorizontalGrid = SelectedIndex
        (*global).Configuration.Input.ColorHorizontalGrid = SelectedIndex
        SetColorSliderValue, Event, Selectedindex
    END
    2: BEGIN                    ;Excluded pixels
        SelectedIndex = (*global).DefaultColorExcludedPixels
        (*global).ColorExcludedPixels = SelectedIndex
        (*global).Configuration.Input.ColorExcludedPixels = SelectedIndex
        SetColorSliderValue, Event, Selectedindex
    END
    3: BEGIN
        SelectedIndex = (*global).DefaultLoadctMainPlot
        (*global).LoadctMainPlot = SelectedIndex
        (*global).Configuration.Input.Loadct_droplist = SelectedIndex
        SetDropListIndex, Event, Selectedindex
    END
ENDCASE

;replot everything
IF ((*global).NeXusFound) THEN BEGIN
    PlotIncludedPixels, Event        
ENDIF

END



PRO BSSreduction_ColorSliderFullReset, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get DroplistValue
DropListValue = getColorDropListSelectedIndex(Event)

(*global).ColorVerticalGrid   = (*global).DefaultColorVerticalGrid
(*global).ColorHorizontalGrid = (*global).DefaultColorHorizontalGrid
(*global).ColorExcludedPixels = (*global).DefaultColorExcludedPixels
(*global).LoadctMainPlot      = (*global).DefaultLoadctMainPlot

(*global).Configuration.Input.ColorVerticalGrid   = (*global).DefaultColorVerticalGrid
(*global).Configuration.Input.ColorHorizontalGrid = (*global).DefaultColorHorizontalGrid
(*global).Configuration.Input.ColorExcludedPixels = (*global).DefaultColorExcludedPixels
(*global).Configuration.Input.Loadct_droplist     = (*global).DefaultLoadctMainPlot

CASE (DropListValue) OF
    0: BEGIN                    ;Grid: Vertical Lines
        SelectedIndex = (*global).DefaultColorVerticalGrid
        SetColorSliderValue, Event, Selectedindex
    END
    1: BEGIN                    ;Grid: Horizontal Lines
        SelectedIndex = (*global).DefaultColorHorizontalGrid
        SetColorSliderValue, Event, Selectedindex
    END
    2: BEGIN                    ;Excluded pixels
        SelectedIndex = (*global).DefaultColorExcludedPixels
        SetColorSliderValue, Event, Selectedindex
    END
    3: BEGIN                    ;Loadct
        SelectedIndex = (*global).DefaultLoadctMainPlot
        SetDropListIndex, Event, Selectedindex
    END
ENDCASE

;replot everything
IF ((*global).NeXusFound) THEN BEGIN
    PlotIncludedPixels, Event        
ENDIF

END

