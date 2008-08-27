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
PRO activate_widget, Event, uname, activate_status
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SENSITIVE=activate_status
END

;------------------------------------------------------------------------------
;- SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC 
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
PRO activate_browse_gui, Event, value
activate_widget, Event, 'x_axis_ticks_base', value
activate_widget, Event, 'selection_up', value
activate_widget, Event, 'selection_down', value
activate_widget, Event, 'ascii_preview_button', value
activate_widget, Event, 'transparency_base', value
activate_widget, Event, 'refresh_step2_plot', value
END

;------------------------------------------------------------------------------
PRO display_file_names_transparency, Event, ascii_file_name
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get list of files
list_OF_files = (*(*global).list_OF_ascii_files)
;get only short file name of all files
short_list_OF_files = getShortName(list_OF_files)
;put list of files in droplist of transparency
putListOfFilesTransparency, Event, short_list_OF_files 
END

;------------------------------------------------------------------------------
PRO update_transparency_coeff_display, Event
index_selected = getTranFileSelected(Event)
WIDGET_CONTROL,Event.top,GET_UVALUE=global
IF (index_selected EQ 0) THEN BEGIN
    value = 'N/A'
    putTextFieldValue, Event, 'transparency_coeff', value
ENDIF ELSE BEGIN
    trans_coeff_list = (*(*global).trans_coeff_list)
    coeff = trans_coeff_list[index_selected]
    coeff_percentage = 100.*coeff
    putTextFieldValue, Event, 'transparency_coeff', $
      STRCOMPRESS(FLOAT(coeff_percentage),/REMOVE_ALL)
ENDELSE
END

;------------------------------------------------------------------------------
PRO select_list, Event, index_selected
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='ascii_file_list')
WIDGET_CONTROL, id, SET_LIST_SELECT=index_selected
END

;------------------------------------------------------------------------------
PRO move_selection, Event, TYPE=type
WIDGET_CONTROL,Event.top,GET_UVALUE=global
;get list of files
list_OF_files  = (*(*global).list_OF_ascii_files)
NbrFiles       = N_ELEMENTS(list_OF_Files)
index_selected = getAsciiSelectedIndex(Event)
;get list of file selected
;list_OF_files_selected = list_OF_files[index_selected]
sz = N_ELEMENTS(index_selected)

CASE (type) OF
    'up': BEGIN
        i = 0
        WHILE (i LT sz) DO BEGIN
            IF (index_selected[i] GT 0) THEN BEGIN
                bPrevSelected = isThisIndexSelected(Event, $
                                                    index_selected, $
                                                    index_selected[i]-1)
                IF (~bPrevSelected) THEN BEGIN
                    prev_name = list_OF_files[index_selected[i]-1]
                    curr_name = list_OF_files[index_selected[i]]
                    list_OF_Files[index_selected[i]]   = prev_name
                    list_OF_Files[index_selected[i]-1] = curr_name
                    index_selected[i] = index_selected[i]-1
                ENDIF 
            ENDIF
            ++i
        ENDWHILE
    END
    'down': BEGIN
        i = sz-1
        WHILE (i GE 0) DO BEGIN
            IF (index_selected[i] LT NbrFiles-1) THEN BEGIN
                bPrevSelected = isThisIndexSelected(Event, $
                                                    index_selected, $
                                                    index_selected[i]+1)
                IF (~bPrevSelected) THEN BEGIN
                    next_name = list_OF_files[index_selected[i]+1]
                    curr_name = list_OF_files[index_selected[i]]
                    list_OF_Files[index_selected[i]]   = next_name
                    list_OF_Files[index_selected[i]+1] = curr_name
                    index_selected[i] = index_selected[i]+1
                ENDIF 
            ENDIF
            --i
        ENDWHILE
    END
    ELSE:
ENDCASE

;repopulate list
putAsciiFileList, Event, list_OF_files 
;save list of files
(*(*global).list_OF_ascii_files) = list_OF_Files
;reset selection
select_list, Event, index_selected

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
;display list of ascii_file_name in transparency percentage button
display_file_names_transparency, Event, ascii_file_name ;_gui
readAsciiData, Event ;read the ascii files and store value in a pointer
plotAsciiData, Event
;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO  InformLogBook, Event, min_array, max_array
WIDGET_CONTROL,Event.top,GET_UVALUE=global
list_OF_files = (*(*global).list_OF_ascii_files)
sz = N_ELEMENTS(list_OF_Files)
index = 0
text = ['> Information about loaded files:']
WHILE (index LT sz) DO BEGIN
    new_text  = '-> ' + list_OF_files[index]
    new_text += ' : MIN = ' + STRCOMPRESS(min_array[index],/REMOVE_ALL)
    new_text += ' : MAX = ' + STRCOMPRESS(max_array[index],/REMOVE_ALL)
    text = [text,new_text]
    ++index
ENDWHILE
IDLsendToGeek_addLogBookText, Event, text
END
