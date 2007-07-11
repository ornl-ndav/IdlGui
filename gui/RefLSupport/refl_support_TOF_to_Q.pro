;This function converts the TOF to Q 
PRO convert_TOF_to_Q, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

flt0 = (*(*global).flt0_xaxis)
flt1 = (*(*global).flt1_yaxis)
flt2 = (*(*global).flt2_yaxis_err)








END
