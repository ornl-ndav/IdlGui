;+
; :Copyright:
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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Author: scu (campbellsi@ornl.gov)
;-

pro load_parameters, widgetBase, Filename=filename

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ; Now put the info structure back for consistency
    WIDGET_CONTROL, widgetBase, SET_UVALUE=info, /NO_COPY
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  ; Get the info structure
  WIDGET_CONTROL, widgetBase, GET_UVALUE=info, /NO_COPY
  
  IF N_ELEMENTS(filename) EQ 0 THEN BEGIN
    filename = DIALOG_PICKFILE(PATH=info.workingDir, Filter='*.par', GET_PATH=path)
  ENDIF
  
  ; Check that we haven't pressed cancel
  IF filename EQ '' THEN BEGIN
    ; Put info back
    WIDGET_CONTROL, widgetBase, SET_UVALUE=info, /NO_COPY
    RETURN
  ENDIF
  
  print, 'Loading ALL parameters from ' + filename
  
  ; Set the current working directory to wherever we have loaded this file from.
  IF STRLEN(path) GT 1 THEN info.workingDir = path
  print, 'Saving Working Directory to be ' + info.workingDir
  
  RESTORE, FILENAME=filename, /RELAXED_STRUCTURE_ASSIGNMENT
  
  ; Set the mask to be always on.
  dgsr_cmd->SetProperty, Mask=1
  
  info.dgsr_cmd = dgsr_cmd
  
  ; Check that the 'version' variable exists
  IF N_ELEMENTS(version) EQ 0 THEN version='0.0'
  
  ; Do the right thing for old par files...
  ; (Which is basically, get the value from the dgsn_cmd object and set the
  ; new property in the dgsr_cmd object)
  IF (STRMID(VERSION,0,3) NE '2.0') AND (N_ELEMENTS(dgsn_cmd) GT 0) THEN BEGIN
    ; Vanadium Runs
    dgsn_cmd->GetProperty, datarun=normalisation
    dgsr_cmd->SetProperty, Normalisation=normalisation
    ; Vanadium Empty Can
    dgsn_cmd->GetProperty, EmptyCan=NormEmptyCan
    dgsr_cmd->setProperty, NormEmptyCan=NormEmptyCan
    ; Normalisation Location
    dgsn_cmd->GetProperty, NormLocation=NormLocation
    dgsr_cmd->SetProperty, NormLocation=NormLocation
    ; Low threshold
    dgsn_cmd->GetProperty, lo_threshold=lo_threshold
    dgsr_cmd->SetProperty, lo_threshold=lo_threshold
    ; High threshold
    dgsn_cmd->GetProperty, hi_threshold=hi_threshold
    dgsr_cmd->SetProperty, hi_threshold=hi_threshold
    ; normtrans
    dgsn_cmd->GetProperty, normtrans=normtrans
    dgsr_cmd->SetProperty, normtrans=normtrans
    ; Normalisation integration range (min)
    dgsn_cmd->GetProperty, normrange_min=normrange_min
    dgsr_cmd->SetProperty, normrange_min=normrange_min
    ; Normalisation integration range (max)
    dgsn_cmd->GetProperty, normrange_max=normrange_max
    dgsr_cmd->SetProperty, normrange_max=normrange_max
    ; White Beam Vanadium Flag
    dgsn_cmd->GetProperty, whitenorm=whitenorm
    dgsr_cmd->SetProperty, whitenorm=whitenorm
  ENDIF
  
  
  ; Find the output window (DGS)
  dgsr_cmd_outputID = WIDGET_INFO(widgetBase,FIND_BY_UNAME='DGSR_CMD_TEXT')
  ; Update the output command window
  WIDGET_CONTROL, dgsr_cmd_outputID, SET_VALUE=dgsr_cmd->generate()
  
  ; Find the output window (DGSN)
  dgsn_cmd_outputID = WIDGET_INFO(widgetBase,FIND_BY_UNAME='DGSN_CMD_TEXT')
  ; Update the output command window
  WIDGET_CONTROL, dgsn_cmd_outputID, SET_VALUE=dgsr_cmd->generateNorm()
  
  ; Put info back
  WIDGET_CONTROL, widgetBase, SET_UVALUE=info, /NO_COPY
  
  ; Now lets update the GUI
  DGSreduction_UpdateGUI, widgetBase
  
end
