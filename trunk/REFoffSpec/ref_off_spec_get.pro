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

;------------------------------------------------------------------------------
;- GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
RETURN, WIDGET_INFO(id, /DROPLIST_SELECT)
END

;------------------------------------------------------------------------------
FUNCTION getTextFieldValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value[0]
END

;------------------------------------------------------------------------------
;This function gives the value of the index selected
FUNCTION getDropListSelectedValue, Event, uname
index_selected = getDropListSelectedIndex(Event,uname)
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=list
RETURN, list[index_selected]
END

;------------------------------------------------------------------------------
;This function gives the value of the index selected
FUNCTION getComboListSelectedValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
RETURN, WIDGET_INFO(id, /COMBOBOX_GETTEXT)
END

;------------------------------------------------------------------------------
FUNCTION getCWBgroupValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getDroplistValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=list
RETURN, list
END

;------------------------------------------------------------------------------
FUNCTION getTableValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
;- SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC 
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;Return the index of the ascii file selected in the first tab (step1)
FUNCTION getAsciiSelectedIndex, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='ascii_file_list')
index = WIDGET_INFO(id,/LIST_SELECT)
RETURN, [index]
END

;------------------------------------------------------------------------------
;This function returns the number of plot loaded
FUNCTION getNbrFiles, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
list_OF_files = (*(*global).list_OF_ascii_files)
sz = N_ELEMENTS(list_OF_files)
RETURN, sz
END

;------------------------------------------------------------------------------
FUNCTION getTranFileSelected, Event
index = getDropListSelectedIndex(Event,'transparency_file_list')
RETURN, index
END

;------------------------------------------------------------------------------
FUNCTION getShortName, list_OF_files
sz = N_ELEMENTS(list_OF_files)
IF (sz GT 0) THEN BEGIN
    new_list_OF_files = STRARR(sz)
    index = 0
    WHILE (index LT sz) DO BEGIN
        file_name  = list_OF_files[index]
        short_name = FILE_BASENAME(file_name)
        new_list_OF_files[index] = short_name
        ++index
    ENDWHILE
ENDIF ELSE BEGIN
    new_list_OF_files = ['']
ENDELSE
RETURN, new_list_OF_files
END

;------------------------------------------------------------------------------
;This function returns the attenuator coefficient defined in the
;OPTIONS tab
FUNCTION getShiftingAttenuatorCoeff, Event
percentage_value = getTextFieldValue(Event, 'transparency_shifting_options')
RETURN, percentage_value/100.
END

;------------------------------------------------------------------------------
;This function returns the attenuator coefficient in percentage
;OPTIONS tab
FUNCTION getShiftingAttenuatorPercentage, Event
percentage_value = getTextFieldValue(Event, 'transparency_shifting_options')
RETURN, percentage_value
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1XminValue, Event
RETURN, getTextFieldValue(Event, 'selection_info_xmin_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1YminValue, Event
RETURN, getTextFieldValue(Event, 'selection_info_ymin_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1XmaxValue, Event
RETURN, getTextFieldValue(Event, 'selection_info_xmax_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1YmaxValue, Event
RETURN, getTextFieldValue(Event, 'selection_info_ymax_value')
END

;------------------------------------------------------------------------------
FUNCTION get_step4_step2_step2_lambda, Event
lambda_left  = getTextFieldValue(Event,'step4_2_2_lambda1_text_field')
lambda_right = getTextFieldValue(Event,'step4_2_2_lambda2_text_field')
RETURN,[lambda_left,lambda_right]
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1SelectionPixelRange, Event
value = getTextFieldValue(Event,'selection_coverage_step4_step1')
RETURN, FIX(value)
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step2PSYMselected, Event
value = getCWBgroupValue(Event,'plot_2d_symbol')
RETURN, value+1
END

;------------------------------------------------------------------------------
;This function takes array as an argument and will
;return the first index  >= lda1 and the last one <=lda2
;To determine in which order the search should be done (increasing
;or decreasing order) the first and last argument will be checked first
FUNCTION getArrayRangeFromlda1lda2, data, lda1, lda2

FirstValue = data[0]
data_size  = (size(data))[1]
LastValue  = data[data_size-1]

left_index  = 0
right_index = (data_size-1)

found_left_index = 0
IF (FirstValue LT LastValue) THEN BEGIN ;increasing order
    FOR i=0,(data_size-1) DO BEGIN
        IF (found_left_index EQ 0) THEN BEGIN
            IF (data[i] GE lda1) THEN BEGIN
                left_index       = i
                found_left_index = 1
            ENDIF
        ENDIF ELSE BEGIN
            IF (data[i] GT lda2) THEN BEGIN
                right_index = i-1
                BREAK
            ENDIF
        ENDELSE
    ENDFOR
ENDIF ELSE BEGIN                ;decreasing order
    FOR i=0,(data_size-1) DO BEGIN
        IF (found_left_index EQ 0) THEN BEGIN
            IF (data[i] LE lda2) THEN BEGIN
                left_index       = i
                found_left_index = 1
            ENDIF
        ENDIF ELSE BEGIN
            IF (data[i] LT lda1) THEN BEGIN
                right_index = i-1
                BREAK
            ENDIF
        ENDELSE
    ENDFOR
ENDELSE          
returnArray = [left_index, right_index]
RETURN, returnArray
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step2PlotType, Event
RETURN, getCWBgroupValue(Event,'step4_step2_z_axis_linear_log')
END

;------------------------------------------------------------------------------
FUNCTION getPolarizationState, file_name
pola_states = ['p0','p1','p2','p3']
FOR i=0,3 DO BEGIN
    IF (STRPOS(file_name,'_' + pola_states[i]) NE -1) THEN $
      RETURN, pola_states[i]
ENDFOR
RETURN, 'N/A'
END

;------------------------------------------------------------------------------
FUNCTION getTableRowSelected, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
array_selected = WIDGET_INFO(id, /TABLE_SELECT)
return, array_selected[1]
END

;------------------------------------------------------------------------------
FUNCTION getOnlyDefineRunNumber, array

sz = N_ELEMENTS(array)
new_array = STRARR(1)
index = 0
WHILE (index LT sz) DO BEGIN
    IF (array[index] NE '') THEN BEGIN
        run_number = STRCOMPRESS(array[index],/REMOVE_ALL)
        IF (index EQ 0) THEN BEGIN
            new_array[0] = run_number
        ENDIF ELSE BEGIN
            new_array = [new_array,run_number]
        ENDELSE
    ENDIF
    index++
ENDWHILE
RETURN, new_array
END

;-----------------------------------------------------------------------------


