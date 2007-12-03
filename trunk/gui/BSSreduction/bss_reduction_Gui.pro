PRO activate_button, event, uname, activate_status
id = widget_info(event.top,find_by_uname=uname)
widget_control, id, sensitive=activate_status
END

PRO activate_base, event, uname, activate_status
id = widget_info(event.top,find_by_uname=uname)
widget_control, id, map=activate_status
END

PRO SetButton, event, uname, valueStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=valueStatus
END


PRO SetColorSliderValue, Event, index
id = widget_info(Event.top,find_by_uname='color_slider')
widget_control, id, set_value=index
END


PRO SetDropListIndex, Event, index
id = widget_info(Event.top,find_by_uname='loadct_droplist')
widget_control, id, set_droplist_select = index
END


PRO ActivateRefreshButton, event, activate_status
id = widget_info(event.top,find_by_uname='full_counts_vs_tof_refresh_button')
widget_control, id, sensitive=activate_status
END


PRO activate_output_couts_vs_tof_base, Event, activate_status
id = widget_info(event.top,find_by_uname='output_couts_vs_tof_base')
widget_control, id, map=activate_status
END

