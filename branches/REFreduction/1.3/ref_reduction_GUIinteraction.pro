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

PRO ActivateWidget, Event, uname, ActivateStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus
END

;------------------------------------------------------------------------------
PRO MapBase, Event, uname, MapStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, map=MapStatus
END

;------------------------------------------------------------------------------
PRO SetCWBgroup, Event, uname, value
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=value
END

;------------------------------------------------------------------------------
PRO SetButtonValue, Event, uname, text
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=text
END

;------------------------------------------------------------------------------
PRO SetTabCurrent, Event, uname, TabIndex
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_tab_current=TabIndex
END

;------------------------------------------------------------------------------
PRO SetDropListValue, Event, uname, index
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_droplist_select=index
END

;------------------------------------------------------------------------------
PRO SetSliderValue, Event, uname, index
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=index
END

;------------------------------------------------------------------------------
;This procedure allows the text to show the last 2 lines of the Data
;log book
PRO showLastDataLogBookLine, Event
dataLogBook = getDataLogBookText(Event)
sz = (size(dataLogBook))(1)
id = widget_info(Event.top,find_by_uname='data_log_book_text_field')
widget_control, id, set_text_top_line=(sz-2)
END

;------------------------------------------------------------------------------
;This procedure allows the text to show the last 2 lines of the Norm
;log book
PRO showLastNormLogBookLine, Event
NormLogBook = getNormalizationLogBookText(Event)
sz = (size(NormLogBook))(1)
id = widget_info(Event.top,find_by_uname='normalization_log_book_text_field')
widget_control, id, set_text_top_line=(sz-2)
END

;------------------------------------------------------------------------------
PRO SetBaseYSize, Event, uname, y_size
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, YSIZE = y_size
END

;------------------------------------------------------------------------------
;This function hide or not the Normalization base of the REDUCE tab
PRO NormReducePartGuiStatus, Event, status
id_group = WIDGET_INFO(Event.top,FIND_BY_UNAME='yes_no_normalization_bgroup')
id_base  = WIDGET_INFO(Event.top,FIND_BY_UNAME='normalization_base')

CASE (status) OF
    'show': BEGIN
        group_value = 0
        base_value  = 1
    END
    'hide': BEGIN
        group_value = 1
        base_value  = 0
    END
ELSE:
ENDCASE

WIDGET_CONTROL, id_group, SET_VALUE=group_value
WIDGET_CONTROL, id_base, MAP=base_value

END

;------------------------------------------------------------------------------
;This function activates or not the REPOPULATE GUI button
PRO RepopulateButtonStatus, Event, status
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='repopulate_gui')
WIDGET_CONTROL, id, sensitive=status
END

;------------------------------------------------------------------------------
;This function switch the Peak and background bases of the data 1D data tab
;according to the status of the cw_bgroup
PRO SwitchPeakBackgroundDataBase, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_data_back_group')
WIDGET_CONTROL, id, GET_VALUE=value
IF (value EQ 0) THEN BEGIN ;show peak base
   peak_base_status = 1
   back_base_status = 0
ENDIF ELSE BEGIN
   peak_base_status = 0
   back_base_status = 1
ENDELSE
MapBase, Event, 'peak_data_base_uname', peak_base_status
MapBase, Event, 'back_data_base_uname', back_base_status
END

;------------------------------------------------------------------------------
;This function switch the Peak and background bases of the Data Reduce tab
;according to the status of the cw_bgroup
PRO SwitchPeakBackgroundReduceDataBase, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_data_back_group')
WIDGET_CONTROL, id, GET_VALUE=value
IF (value EQ 0) THEN BEGIN ;show peak base
   peak_base_status = 1
   back_base_status = 0
ENDIF ELSE BEGIN
   peak_base_status = 0
   back_base_status = 1
ENDELSE
MapBase, Event, 'data_peak_base', peak_base_status
MapBase, Event, 'data_background_base', back_base_status
END

;------------------------------------------------------------------------------
;This function switch the Peak and background bases of the norm. 1D norm tab
;according to the status of the cw_bgroup
PRO SwitchPeakBackgroundNormBase, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_norm_back_group')
WIDGET_CONTROL, id, GET_VALUE=value
IF (value EQ 0) THEN BEGIN ;show peak base
   peak_base_status = 1
   back_base_status = 0
ENDIF ELSE BEGIN
   peak_base_status = 0
   back_base_status = 1
ENDELSE
MapBase, Event, 'peak_norm_base_uname', peak_base_status
MapBase, Event, 'back_norm_base_uname', back_base_status
END

;------------------------------------------------------------------------------
;This function switch the Peak and background bases of the Reduce tab
;according to the status of the cw_bgroup
PRO SwitchPeakBackgroundReduceNormBase, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='peak_norm_back_group')
WIDGET_CONTROL, id, GET_VALUE=value
IF (value EQ 0) THEN BEGIN ;show peak base
   peak_base_status = 1
   back_base_status = 0
ENDIF ELSE BEGIN
   peak_base_status = 0
   back_base_status = 1
ENDELSE
MapBase, Event, 'norm_peak_base', peak_base_status
MapBase, Event, 'norm_background_base', back_base_status
END

;------------------------------------------------------------------------------
;This function switches the data Ymin and Ymax labels
PRO SwitchDataYminYmaxLabel, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='data_ymin_ymax_label')
WIDGET_CONTROL, id, GET_VALUE = value
IF ((*global).miniVersion EQ 0) THEN BEGIN
    IF (value EQ 'Current working selection -> Ymin') THEN BEGIN
        value = 'Current working selection -> Ymax'
    ENDIF ELSE BEGIN
        value = 'Current working selection -> Ymin'
    ENDELSE
ENDIF ELSE BEGIN
    IF (value EQ 'Working with -> Ymin') THEN BEGIN
        value = 'Working with -> Ymax'
    ENDIF ELSE BEGIN
        value = 'Working with -> Ymin'
    ENDELSE
ENDELSE
WIDGET_CONTROL, id, SET_VALUE = value
END

;------------------------------------------------------------------------------
;This function switches the normalization Ymin and Ymax labels
PRO SwitchNormYminYmaxLabel, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='norm_ymin_ymax_label')
WIDGET_CONTROL, id, GET_VALUE = value
IF ((*global).miniVersion EQ 0) THEN BEGIN
    IF (value EQ 'Current working selection -> Ymin') THEN BEGIN
        value = 'Current working selection -> Ymax'
    ENDIF ELSE BEGIN
        value = 'Current working selection -> Ymin'
    ENDELSE
ENDIF ELSE BEGIN
    IF (value EQ 'Working with -> Ymin') THEN BEGIN
        value = 'Working with -> Ymax'
    ENDIF ELSE BEGIN
        value = 'Working with -> Ymin'
    ENDELSE
ENDELSE
WIDGET_CONTROL, id, SET_VALUE = value
END

;------------------------------------------------------------------------------
;This function activate or not the Q manual base
PRO ActivateOrNotAutoQmode, Event 
;get value of auto/manual mode
AutoModeStatus = getCWBgroupValue(Event,'q_mode_group')
IF (AutoModeStatus EQ 0) THEN BEGIN
;auto mode
    ManualBaseStatus = 0
ENDIF ELSE BEGIN
;manual mode
    ManualBaseStatus = 1
ENDELSE
ActivateWidget, Event, 'q_manual_base', ManualBaseStatus
END

;------------------------------------------------------------------------------
;This procedure changes the size of the top and bottom progress bar in
;the batch tab and reset the color of these ones.
PRO ChangeSizeOfDraw, Event, uname, x2, color
;fill base with Color
id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
wset,id_value
WIDGET_CONTROL, id_draw, DRAW_XSIZE=x2
;get xsize of widget_draw
geometry = WIDGET_INFO(id_draw, /GEOMETRY)
;xsize = geometry.xsize
ysize = geometry.ysize
polyfill, [0,0,x2,x2,0], $
  [0,ysize,ysize,0,0], $
  /Device, $
  Color= color
END
   
;------------------------------------------------------------------------------
PRO update_select_polarization_state_gui, Event, list_pola_state
uname= ['pola_state1_uname',$
        'pola_state2_uname',$
        'pola_state3_uname',$
        'pola_state4_uname']
sz    = N_ELEMENTS(list_pola_state)
index = 0
first_pola = 1
FOR index=0,3 DO BEGIN
    IF (index GT sz) THEN BEGIN ;unselect
        select_value = 0
    ENDIF ELSE BEGIN
        value  = STRSPLIT(list_pola_state[index],'/',/EXTRACT)
        value1 = STRSPLIT(value[0],'-',/EXTRACT)
        SetButtonValue, Event, uname[index], value1[1]
        select_value = 1
        IF (first_pola) THEN BEGIN
            id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname[index])
            WIDGET_CONTROL, id, /SET_BUTTON 
            first_pola = 0
        ENDIF
    ENDELSE
    ActivateWidget, Event, uname[index], select_value
ENDFOR
END

;------------------------------------------------------------------------------
PRO show_empty_cell_OR_data_background_base, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

base_global = { event: event,$
                global: global}

;determine position of base
xsize = 300
ysize = 400

geometry = WIDGET_INFO((*global).main_base,/GEOMETRY)
xoffset  = geometry.xoffset + FIX((geometry.xsize - xsize)/2)
yoffset  = geometry.yoffset + FIX((geometry.ysize - ysize)/2)

sBase = { size: [xoffset,$
                 yoffset,$
                 xsize,$
                 ysize],$
          uname: 'empty_cell_or_data_background_base',$
          title: 'CONFLICT IN YOUR SELECTION!',$
          map: 1 }

wBase = WIDGET_BASE(GROUP_LEADER = (*global).main_base,$
                    XOFFSET      = sBase.size[0],$
                    YOFFSET      = sBase.size[1],$
                    SCR_XSIZE    = sBase.size[2],$
                    SCR_YSIZE    = sBase.size[3],$
                    MAP          = sBase.map,$
                    TITLE        = sBase.title,$
                    UNAME        = sBase.uname,$
                    /COLUMN,$
                    /MODAL)

WIDGET_CONTROL, wBase, SET_UVALUE = base_global

label  = WIDGET_LABEL(wBase,$
                     VALUE = '')
label1 = WIDGET_LABEL(wBase,$
                      VALUE = "You can't run the data reduction")
label2 = WIDGET_LABEL(wBase,$
                      VALUE = " using Data Background AND Empty Cell")







WIDGET_CONTROL, /REALIZE, wBase
XMANAGER, 'wBase', wBase, /NO_BLOCK


END
