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

;+
; :Description:
;   Triggered by the manual button fo step2 (Critical Edge)
;   Simply rescale the CE data according to the argument given
;
; :Params:
;    event

; :Author: j35
;-
pro manual_ce_scaling, event
  compile_opt idl2

  widget_control, event.top, get_uvalue=global
  
  SF = getTextFieldValue(event, 'step2_sf_text_field')
  sf_num = isNumeric(SF)
  
  ;SF is not numeric
  if (~sf_num) then return
  
  (*global).CE_scaling_factor = float(SF)
  ;replot CE data with new scale
  plot_rescale_CE_file, Event ;_Plot
  
    ;update the BatchTable if any
    if ((*global).BatchFileName ne '') then begin
      index_array = getIndexArrayOfActiveBatchRow(Event)
      BatchTable      = (*(*global).BatchTable)
      BatchTable[8,index_array[0]] = STRCOMPRESS(SF,/REMOVE_ALL)
      (*(*global).BatchTable) = BatchTable
      UpdateBatchTable, Event, BatchTable ;_batch
    endif
  
end