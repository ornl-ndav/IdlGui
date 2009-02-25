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

PRO create_step5_selection_data, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  WIDGET_CONTROL, /HOURGLASS
  
  base_array_untouched = (*(*global).total_array_untouched)
  base_array_error     = (*(*global).total_array_error)
  
  x0 = (*global).step5_x0 ;lambda
  y0 = (*global).step5_y0 ;pixel
  x1 = (*global).step5_x1 ;lambda
  y1 = (*global).step5_y1 ;pixel
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  ymin = FIX(ymin/2)
  ymax = FIX(ymax/2)
  
  array_selected = base_array_untouched[xmin:xmax,ymin:ymax]
  array_selected_total = TOTAL(array_selected,2)
  
  array_error_selected = base_array_error[xmin:xmax,ymin:ymax]
  y = (size(array_error_selected))(2)
  array_error_selected_total = TOTAL(array_error_selected,2)/FLOAT(y)
  
  x_axis = (*(*global).x_axis)
  
  x_axis_selected = x_axis[xmin:xmax]
  x_axis_in_Q = convert_from_lambda_to_Q(x_axis_selected)
  
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis = x_axis_in_Q
  ENDIF ELSE BEGIN
    x_axis = x_axis_selected
  ENDELSE
  
  (*(*global).step5_selection_x_array) = x_axis
  (*(*global).step5_selection_y_array) = array_selected_total
  (*(*global).step5_selection_y_error_array) = array_error_selected_total
  
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_plot, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;create array of data
  create_step5_selection_data, Event
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_label = 'Q(Angstroms^-1)'
  ENDIF ELSE BEGIN
    x_axis_label = 'Lambda_T (Angstroms)'
  ENDELSE
  
  y_axis_label = 'Intensity'
  
  x_axis = (*(*global).step5_selection_x_array)
  array_selected_total = (*(*global).step5_selection_y_array)
  array_error_selected_total = (*(*global).step5_selection_y_error_array)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_rescale_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  plot, x_axis, array_selected_total, XTITLE=x_axis_label, YTITLE=y_axis_label
    
END