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
PRO determine_delta_x, sz, pData_x, delta_x
index = 0
WHILE (index LT sz) DO BEGIN
    x0 = (*pData_x[index])[0]
    x1 = (*pData_x[index])[1]
    delta_x[index] = FLOAT(x1) - FLOAT(x0)
    ++index
ENDWHILE
END

;------------------------------------------------------------------------------
;create new x-axis and new pData_y
PRO congrid_data, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

pData_x        = (*(*global).pData_x)
pData_y        = (*(*global).pData_y)
pData_y_error  = (*(*global).pData_y_error)

;determine the delta_x of each set of data
sz      = (size(pData_y))(1)
delta_x = FLTARR(sz)
determine_delta_x, sz, pData_x, delta_x

;get min delta_x and index
min_delta_x = MIN(delta_x)
min_index   = WHERE(delta_x EQ min_delta_x)

min_index = min_index[0]

;work on all the data that have delta_x GT than the delta_x found
index = 0
congrid_coeff_array = FLTARR(sz)
WHILE(index LT sz) DO BEGIN
    IF (index EQ min_index) THEN BEGIN
        congrid_coeff_array[index] = 1
        ++index
        CONTINUE
    ENDIF
    congrid_coeff_array[index] = delta_x(index)/delta_x[min_index]
    ++index
ENDWHILE
(*(*global).congrid_coeff_array) = congrid_coeff_array

;congrid all data
index       = 0
max_x_size  = 0                 ;max number of elements
max_x_value = 0                 ;maximum x value
WHILE (index LT sz) DO BEGIN
    coeff = congrid_coeff_array[index]
    current_x_max_size  = (size(*pData_x[index]))(1)
    current_max_x_value = MAX(FLOAT(*pData_x[index]))
    IF (current_max_x_value GT max_x_value) THEN BEGIN
        max_x_value = current_max_x_value
    ENDIF
    IF (current_x_max_size GT max_x_size) THEN BEGIN
        max_x_size = current_x_max_size
    ENDIF
    IF (coeff NE 1) THEN BEGIN
        congrid_x_coeff = current_x_max_size * congrid_coeff_array[index]
;work on y
        congrid_y_coeff = (size(*pData_y[index]))(2)
        new_y_array = CONGRID((*pData_y[index]), $
                              FIX(congrid_x_coeff),$
                              congrid_y_coeff)
        *pData_y[index] = new_y_array        
;work on y_error
        congrid_y_error_coeff = congrid_y_coeff
        new_y_error_array = CONGRID((*pData_y_error[index]), $
                                    FIX(congrid_x_coeff),$
                                    congrid_y_error_coeff)
        *pData_y_error[index] = new_y_error_array        
    ENDIF
    ++index
ENDWHILE

;triple the size of each array (except the first one)
list_OF_files         = (*(*global).list_OF_ascii_files)
nbr                   = N_ELEMENTS(list_OF_files)
realign_pData_y       = PTRARR(nbr,/ALLOCATE_HEAP)
realign_pData_y_error = PTRARR(nbr,/ALLOCATE_HEAP)

index  = 0
WHILE(index LT sz) DO BEGIN
    IF (index EQ 0) THEN BEGIN
        *realign_pData_y[index] = *pData_y[index]
        *realign_pData_y_error[index] = *pData_y_error[index]
    ENDIF ELSE BEGIN
        local_data       = *pData_y[index]
        local_data_error = *pData_y_error[index]
        dim2             = (size(local_data))(1)

;        big_array        = STRARR(dim2,3*304L)
;        big_array_error  = STRARR(dim2,3*304L)
;        big_array[*,(*global).detector_pixels_y:2*304L-1]       = local_data
;        big_array_error[*,(*global).detector_pixels_y:2*304L-1] = local_data_error
        
        big_array        = STRARR(dim2,3*(*global).detector_pixels_y)
        big_array_error  = STRARR(dim2,3*(*global).detector_pixels_y)
        big_array[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1]       = local_data
        big_array_error[*,(*global).detector_pixels_y:2*(*global).detector_pixels_y-1] = local_data_error

        *realign_pData_y[index]          = big_array
        *realign_pData_y_error[index]    = big_array_error
    ENDELSE
    ++index
ENDWHILE

;each new array pData_y (with congrid in x direction to share the same
;x-axis are store in pData_y
(*(*global).pData_y)       = pData_y
(*(*global).pData_y_error) = pData_y_error

;define new x-axis
x_size = FLOAT(max_x_value) / FLOAT(min_delta_x)
x_axis = FINDGEN(FIX(x_size+1)) * min_delta_x

(*(*global).x_axis) = x_axis
(*global).delta_x = x_axis[1]-x_axis[0]
(*(*global).realign_pData_y)       = realign_pData_y
(*(*global).realign_pData_y_error) = realign_pData_y_error
(*(*global).untouched_realign_pData_y)       = realign_pData_y
(*(*global).untouched_realign_pData_y_error) = realign_pData_y_error

END
