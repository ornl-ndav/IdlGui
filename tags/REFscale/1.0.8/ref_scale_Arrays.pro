;###############################################################################
;*******************************************************************************

;this function creates and update the Q1, Q2, SF... arrays when a file is added
PRO CreateArrays, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;number of files loaded
(*global).NbrFilesLoaded += 1

Qmin_array  = (*(*global).Qmin_array)
Qmax_array  = (*(*global).Qmax_array)
Q1_array    = (*(*global).Q1_array)
Q2_array    = (*(*global).Q2_array)
SF_array    = (*(*global).SF_array)
angle_array = (*(*global).angle_array)
color_array = (*(*global).color_array)
FileHistory = (*(*global).FileHistory)

Qmin_array = [Qmin_array,0]
Qmax_array = [Qmax_array,0]
Q1_array   = [Q1_array,0]
Q2_array   = [Q2_array,0]
SF_array   = [SF_array,0]

;get current angle value entered
angleValue  = (*global).angleValue
angle_array = [angle_array,angleValue]

colorIndex  = getColorIndex(Event)
color_array = [color_array, colorIndex]
FileHistory = [FileHistory,'']

(*(*global).Qmin_array)  = Qmin_array
(*(*global).Qmax_array)  = Qmax_array
(*(*global).Q1_array)    = Q1_array
(*(*global).Q2_array)    = Q2_array
(*(*global).SF_array)    = SF_array
(*(*global).angle_array) = angle_array
(*(*global).color_array) = color_array
(*(*global).FileHistory) = FileHistory

END

;###############################################################################
;*******************************************************************************
