PRO validateCreateNexusButton, Event, validate_status
id = widget_info(event.top,find_by_uname='create_nexus_button')
widget_control, id, sensitive=validate_status
END

PRO validateSendToGeek, Event, validate_status
uname_array = ['send_to_geek_button',$
               'send_to_geek_label',$
               'send_to_geek_text']
sz = (size(uname_array))(1)
FOR i=0,(sz-1) DO BEGIN
    id = widget_info(event.top,find_by_uname=uname_array[i])
    widget_control, id, sensitive=validate_status
ENDFOR
END

PRO resetRunNumberField, Event
id = widget_info(event.top,find_by_uname='run_number_cw_field')
widget_control, id, set_value=''
END

