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
;This function cleans up the data array by removing the data that have
;error values GE to the data
PRO CleanupArray_1, y_array, y_error_array
index_array = WHERE(y_error_array GE y_array, nbr)
IF (nbr GE 1) THEN BEGIN
    y_array[index_array] = 0
ENDIF
END

;------------------------------------------------------------------------------
;This function return the index of the first non-zero value
FUNCTION RetrieveLdaMinIndex, array
sz          = N_ELEMENTS(array)
index_array = WHERE(array NE 0,nbr)
IF (nbr GT 0) THEN BEGIN
    RETURN, index_array[0]
ENDIF ELSE BEGIN
    RETURN, -1
ENDELSE
END

;------------------------------------------------------------------------------
;This function return the index of the last non-zero value
FUNCTION RetrieveLdaMaxIndex, array
sz          = N_ELEMENTS(array)
index_array = WHERE(array NE 0,nbr)
IF (nbr GT 0) THEN BEGIN
    RETURN, index_array[nbr-1]
ENDIF ELSE BEGIN
    RETURN, -1
ENDELSE
RETURN, -1
END

;------------------------------------------------------------------------------
PRO step4_2_3_auto_scaling, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

IdlSendToGeek_addLogBookText, Event, '> Automatic Rescaling :' 
nbr_plot    = getNbrFiles(Event) ;number of files
ListOfFiles = (*(*global).list_OF_ascii_files)

IvsLambda_selection       = (*(*global).IvsLambda_selection)
IvsLambda_selection_error = (*(*global).IvsLambda_selection_error)

auto_scale_status = 1 ;ok by default

no_error = 0
;CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IdlSendToGeek_addLogBookText, Event, '-> Automatic Rescaling FAILED' + $
      ' - Switch to Manual Mode!'
ENDIF ELSE BEGIN

    index = 1
    WHILE (index NE nbr_plot) DO BEGIN

;;get y and y_error of low and high lda data
        low_lda_y_array        = *IvsLambda_selection[index]
        low_lda_y_error_array  = *IvsLambda_selection_error[index]
        high_lda_y_array       = *IvsLambda_selection[index-1]
        high_lda_y_error_array = *IvsLambda_selection_error[index-1]

        IdlSendToGeek_addLogBookText, Event, '--> Reference File: ' + $
          ListOfFiles[index-1]
        IdlSendToGeek_addLogBookText, Event, '--> Working File  : ' + $
          ListOfFiles[index]
        
;determine what is the first non-zero data of the high lda file
;(reference file)        
        IdlSendToGeek_addLogBookText, Event, '---> Retrieve First ' + $
          'non-zero lda index of Reference File ... ' + PROCESSING
        lda_min_index = RetrieveLdaMinIndex(high_lda_y_array)
        IF (lda_min_index EQ -1) THEN BEGIN
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
            auto_scale_status = 0
            BREAK
        ENDIF ELSE BEGIN
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK + $
              ' (index: ' + STRCOMPRESS(lda_min_index,/REMOVE_ALL) + ')'
        ENDELSE


;determine what is the last non-zero data of the low lda file
;(working file)        
        IdlSendToGeek_addLogBookText, Event, '---> Retrieve Last ' + $
          'non-zero lda index of Working File ... ' + PROCESSING
        lda_max_index = RetrieveLdaMaxIndex(low_lda_y_array)
        IF (lda_max_index EQ -1) THEN BEGIN
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
            auto_scale_status = 0
            BREAK
        ENDIF ELSE BEGIN
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK + $
              ' (index: ' + STRCOMPRESS(lda_max_index,/REMOVE_ALL) + ')'
        ENDELSE

;remove points in calculation that have error GE than their values
        CleanupArray_1, low_lda_y_array[lda_min_index:lda_max_index], $
          low_lda_y_error_array[lda_min_index:lda_max_index]

        CleanupArray_1, high_lda_y_array[lda_min_index:lda_max_index], $
          high_lda_y_error_array[lda_min_index:lda_max_index]
        
;calculate the data total
        Total_low_lda_y = TOTAL(low_lda_y_array[lda_min_index:$
                                                lda_max_index])
        IdlSendToGeek_addLogBookText, Event, '---> Total of Working ' + $
          'File: ' + STRCOMPRESS(total_low_lda_y,/REMOVE_ALL)
        
        Total_high_lda_y = TOTAL(high_lda_y_array[lda_min_index:$
                                                  lda_max_index])
        IdlSendToGeek_addLogBookText, Event, '---> Total of Reference ' + $
          'File: ' + STRCOMPRESS(total_high_lda_y,/REMOVE_ALL)
        Total_low_lda_y = TOTAL(low_lda_y_array[lda_min_index:$
                                                lda_max_index])

;Determine scaling factor
        SF = FLOAT(total_low_lda_y) / FLOAT(total_high_lda_y)
        IdlSendToGeek_addLogBookText, Event, '---> SF is: ' + $
          STRCOMPRESS(SF,/REMOVE_ALL)
        
;Apply SF to working file (data and error)
        new_low_lda_y_array = low_lda_y_array / SF
        *IvsLambda_selection[index] = new_low_lda_y_array

        new_low_lda_y_error_array = low_lda_y_error_array / SF
        *IvsLambda_selection_error[index] = new_low_lda_y_error_array

        index++
    ENDWHILE

    IF (auto_scale_status) THEN BEGIN ;auto scaling worked
        re_display_step4_step2_step1_selection, Event ;scaling_step2
    ENDIF
    
ENDELSE

END

;------------------------------------------------------------------------------
PRO check_step4_2_3_gui, Event
;get value of SF from step4_2_2
sSF = getTextFieldValue(Event,'step2_sf_text_field')
list_OF_files = getDroplistValue(Event,'step4_2_3_work_on_file_droplist')
activate_status = 1
SWITCH (sSF) OF
    '-NaN':
    'NaN':
    '': activate_status = 0
    ELSE:
ENDSWITCH

;check if manual mode can be enabled or not
sz = (size(list_OF_files))(1)
IF (STRCOMPRESS(list_OF_files[0],/REMOVE_ALL) NE '') THEN BEGIN
    map_status = 1
ENDIF ELSE BEGIN
    map_status = 0
    activate_status = 0
ENDELSE

activate_widget, Event, 'step4_2_3_automatic_rescale_button', activate_status
activate_widget, Event, 'step4_2_3_manual_mode_frame', activate_status
MapBase, Event, 'step4_2_3_manual_hidden_frame', map_status

END

;------------------------------------------------------------------------------
PRO populate_step4_2_3_droplist, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get list of files
list_OF_files = (*(*global).short_list_OF_ascii_files)
sz = N_ELEMENTS(list_OF_files)
;put by default the first file from the list as the reference file
putTextFieldValue, Event, 'step4_2_3_manual_reference_value', list_OF_files[0]
CASE (sz) OF
    0: list = ['']
    1: list = list_OF_files[1]
    ELSE: list = list_OF_files[1:sz-1]
ENDCASE
SetDroplistValue, Event, 'step4_2_3_work_on_file_droplist', list
END
