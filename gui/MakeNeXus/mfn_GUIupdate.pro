PRO validateCreateNexusButton, Event, validate_status
id = widget_info(event.top,find_by_uname='create_nexus_button')
widget_control, id, sensitive=validate_status
END

PRO validateOuputPath2, Event, validate_status
id = widget_info(event.top,find_by_uname='output_button2')
widget_control, id, sensitive=validate_status
id = widget_info(event.top,find_by_uname='output_path_text2')
widget_control, id, sensitive=validate_status

END

PRO resetRunNumberField, Event
id = widget_info(event.top,find_by_uname='run_number_cw_field')
widget_control, id, set_value=''
END

