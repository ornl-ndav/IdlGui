PRO BSSselection_ColorSelection, Event

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

;reset slider position
SetColorSliderValue, Event, SelectedIndex

END


PRO  BSSselection_ColorSlider, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DropListValue = getColorDropListSelectedIndex(Event)
ColorValue = getColorSliderValue(Event)

CASE (DropListValue) OF
    0: (*global).ColorVerticalGrid = ColorValue
    1: (*global).ColorHorizontalGrid = ColorValue
    2: (*global).ColorExcludedPixels = ColorValue
    else:
ENDCASE

;replot everything
PlotIncludedPixels, Event        

END


PRO BSSselection_ColorLoadctDropList, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

LoadctIndex = getLoadctDropListSelectedIndex(Event)
(*global).LoadctMainPlot = LoadctIndex

;replot everything

END
