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





;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
;This procedure is reached by the CALCULATE SF button of the empty cell
PRO start_sf_scaling_factor_calculation_mode, Event 

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

widget_id = WIDGET_INFO(Event.top, $
                        FIND_BY_UNAME='empty_cell_scaling_factor_button')

;check that there are data and empty cell nexus file loaded
data_nexus_file       = (*global).data_full_nexus_name
empty_cell_nexus_file = (*global).empty_cell_full_nexus_name
;IF (data_nexus_file EQ '' AND $                ;REMOVE_COMMENTS
;    empty_cell_nexus_file EQ '') THEN BEGIN    ;REMOVE_COMMENTS

IF (data_nexus_file EQ '') THEN BEGIN

    text   = ['Data and/or Empty Cell NeXus file is/are missing!',$
              'Please load the missing NeXus file(s)']
    title  = 'NeXus File Missing!'

    result = DIALOG_MESSAGE(text,$
                            /INFORMATION,$
                            /CENTER,$
                            TITLE = title,$
                            DIALOG_PARENT = widget_id)
    RETURN
ENDIF

;check that they both have the same binning


;load the data file
plot_data_file_in_sf_calculation_base, Event, FILE_NAME=data_nexus_file

;copy SF value into sf_calculation base
SFvalue = getTextFieldValue(Event,'empty_cell_scaling_factor')
putTextFieldValue, Event, 'scaling_factor_equation_value', $
  STRCOMPRESS(SFvalue,/REMOVE_ALL), 0

;show up calculation base
MapBase, Event, 'empty_cell_scaling_factor_calculation_base', 1

;refresh the equation plot (widget_draw)
RefreshEquationDraw, Event
END
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

;load the data into the widget_draw uname specified
PRO plot_file_in_sf_calculation_base, Event,$
                                      FILE_NAME  = file_name,$
                                      TYPE       = type,$
                                      draw_uname = draw_uname

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

CASE (TYPE) OF
    'data': data = (*(*global).DATA_D_TOTAL_ptr)
    'empty_cell': data = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
ENDCASE

DEVICE, DECOMPOSED = 0
id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME=draw_uname)
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

Ntof_size = (size(data))(1)
WIDGET_CONTROL, id_draw, DRAW_XSIZE=Ntof_size

TVSCL, data, /DEVICE

END

;..............................................................................
;load the data file
PRO plot_data_file_in_sf_calculation_base, Event, FILE_NAME=file_name
draw_uname = 'empty_cell_scaling_factor_base_data_draw'
plot_file_in_sf_calculation_base, $
  Event, $
  FILE_NAME = file_name, $
  TYPE      = 'data',$
 DRAW_UNAME = draw_uname
END

;..............................................................................
;load the empty cell file
PRO plot_empty_cell_file_in_sf_calculation_base, Event, FILE_NAME=file_name
draw_uname = 'empty_cell_scaling_factor_base_empty_cell_draw'
plot_file_in_sf_calculation_base, $
  Event, $
  FILE_NAME  = file_name, $
  TYPE       = 'empty_cell',$
  DRAW_UNAME = draw_uname
END

;------------------------------------------------------------------------------
