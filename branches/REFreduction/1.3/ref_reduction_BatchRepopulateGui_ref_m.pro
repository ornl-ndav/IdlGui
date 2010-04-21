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
PRO RepopulateGui_ref_m, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;desactivate REPOPULATE GUI button
  RepopulateButtonStatus, Event, 0
  
  message = 'REPOPULATING GUI using current selected Row ... (PROCESSING)'
  putLabelValue, Event, 'pro_top_label', message
  MapBase, Event, 'processing_base', 1
  
  ;get cmd of current selected row
  cmd = getTextFieldValue(Event,'cmd_status_preview')
  
  ;check how many spin states we have
  cmd_array = strsplit(cmd,';',/extract)
  ClassInstance = obj_new('IDLparseCommandLine_ref_m',cmd_array)
  DataPath = ClassInstance->getDataPath()
  data_spins = strsplit(DataPath,'/',/extract)
  (*(*global).list_of_data_spins) = data_spins
  NormPath = ClassInstance->getNormPath()
  norm_spins = strsplit(NormPath,'/',/extract)
  (*(*global).list_of_norm_spins) = norm_spins
  obj_destroy, ClassInstance
  
  nbr_data_spins = n_elements(data_spins)
  if (nbr_data_spins gt 1) then begin ;more than 1 command line
  
    ;ask user to select which spin state he wants to load
    batch_reload_spin_state_selection, Event=event, spin_states=data_spins
    
  endif else begin
  
    (*global).data_spin_state_to_replot = DataPath[0]
    (*global).norm_spin_state_to_replot = NormPath[0]
    RepopulateGui_ref_m_with_spin_states, event
    
  endelse
  
end
