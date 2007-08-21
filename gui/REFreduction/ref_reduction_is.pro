Function isDataPeakSelectionSelected, Event
id = widget_info(Event.top,find_by_uname='data_1d_selection')
widget_control, id, get_value=isPeakSelected
return, isPeakSelected
END


Function isNormPeakSelectionSelected, Event
id = widget_info(Event.top,find_by_uname='normalization_1d_selection')
widget_control, id, get_value=isPeakSelected
return, isPeakSelected
END
