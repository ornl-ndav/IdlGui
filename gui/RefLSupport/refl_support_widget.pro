PRO EnableStep1ClearFile, Event, validate
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ClearFileId = widget_info(Event.top, find_by_uname='clear_button')
widget_control, ClearFileId, sensitive=validate
END


;This function clears the contain of all the droplists
PRO ClearAllDropLists, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear off list of file in droplist of step1
list_of_files_droplist_id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, list_of_files_droplist_id, set_value=['']
;clear off list of file in droplist of step2
base_file_droplist_id = widget_info(Event.top,find_by_uname='base_file_droplist')
widget_control, base_file_droplist_id, set_value=['']
;clear off list of file in droplists of step3
step3_base_file_droplist_id = widget_info(Event.top,find_by_uname='step3_base_file_droplist')
widget_control, step3_base_file_droplist_id, set_value=['']
step3_work_on_file_droplist_id = widget_info(Event.top,find_by_uname='step3_work_on_file_droplist')
widget_control, step3_work_on_file_droplist_id, set_value=['']
END


;This function clears the contain of all the text boxes
PRO ClearAllTextBoxes, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear step2 
step2_q1_text_field_id = Widget_info(Event.top,find_by_uname='step2_q1_text_field')
Widget_control, step2_q1_text_field_id, set_value=''
step2_q2_text_field_id = Widget_info(Event.top,find_by_uname='step2_q2_text_field')
Widget_control, step2_q2_text_field_id, set_value=''
step2_SF_text_field_id = Widget_info(Event.top,find_by_uname='step2_sf_text_field')
Widget_control, step2_SF_text_field_id, set_value=''
;clear step3
step3_q1_text_field_id = Widget_info(Event.top,find_by_uname='step3_q1_text_field')
Widget_control, step3_q1_text_field_id, set_value=''
step3_q2_text_field_id = Widget_info(Event.top,find_by_uname='step3_q2_text_field')
Widget_control, step3_q2_text_field_id, set_value=''
step3_SF_text_field_id = Widget_info(Event.top,find_by_uname='step3_sf_text_field')
Widget_control, step3_SF_text_field_id, set_value=''

END


;This function removes the contain of the info file found in Step1
PRO ClearFileInfoStep1, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_Value=''
END



;clear main plot window
PRO ClearMainPlot, Event   
draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id
erase
END
