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
pro save_parameters, event, Filename=filename

  ; Get the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  
  ; extract the command object into a separate
  dgsr_cmd = info.dgsr_cmd    ; ReductionCMD object
  dgsn_cmd = info.dgsn_cmd    ; NormCMD object
  version =  info.version     ; DGSreduction version
  
  print, "Using Working Directory of " + info.WorkingDir
  
  IF N_ELEMENTS(filename) EQ 0 THEN BEGIN
    filename = DIALOG_PICKFILE(PATH=info.workingDir, Filter='*.par')
  ENDIF
  
  ; Check that we haven't pressed cancel
  IF filename EQ '' THEN BEGIN
    ; Put info back
    WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
    RETURN
  ENDIF
  
  SAVE, dgsr_cmd, dgsn_cmd, version, FILENAME=filename
  
  print, 'Saving ALL parameters to ... ' + filename
  
  ; Put info back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  
;openw, unit, /GET_LUN
  
;  uname_list = ['DGSR_DATARUN', $
;                'DGSR_MAKE_SPE', $
;                'DGSR_DATAPATHS_LOWER', $
;                'DGSR_DATAPATHS_UPPER', $
;                'DGSR_EI', $
;                'DGSR_TZERO', $
;                'DGSR_ET_MIN', $
;                'DGSR_ET_MAX', $
;                'DGSR_ET_STEP', $
;                'DGSR_Q_MIN', $
;                'DGSR_Q_MAX', $
;                'DGSR_Q_STEP', $
;                'DGSR_TOF-CUT-MIN', $
;                'DGSR_TOF-CUT-MAX', $
;                'DGSR_NO-MON-NORM', $
;                'DGSR_PC-NORM', $
;                'DGSR_LAMBDA-RATIO', $
;                'DGSR_USMON', $
;                'DGSR_NORMRUN', $
;                'DGSR_EMPTYCAN', $
;                'DGSR_BLACKCAN', $
;                'DGSR_DARK', $
;                '', $
;                '', $
;                '', $
;                '', $
;                '', $
;                '', $
;                '', $
;                '', $
;                '', $
;                '', $
;                ]
  
  
;
;  length = N_ELEMENTS(uname_list)
;  for index = 0L, length-1 do begin
;    widget_ID = WIDGET_INFO(event.top,FIND_BY_UNAME=uname_list[index])
;    WIDGET_CONTROL, widget_ID, GET_VALUE=myValue
;
;  endfor
  
;FREE_LUN, unit
  
end

;    UNAME="", VALUE=1, /INTEGER, /ALL_EVENTS, XSIZE=5)
;    UNAME="", /LONG)
;    UNAME="", /LONG)
;    UNAME="", /LONG)
;    UNAME="", /LONG)
;    UNAME="DGSR_DATA-TRANS", XSIZE=10)
;    UNAME="DGSR_NORM-TRANS", XSIZE=10)
;    UNAME="DGSR_DET-EFF", XSIZE=10)
;    UNAME="DGSR_MON-INT-MIN", XSIZE=10)
;    UNAME="DGSR_MON-INT-MAX", XSIZE=10)
;  normRangeBase = WIDGET_BASE(normOptionsBaseRow1, UNAME="DGSR_NORM-INT-RANGE", /ALIGN_BOTTOM)
;    UNAME="DGSR_NORM-INT-MIN", XSIZE=10)
;    UNAME="DGSR_NORM-INT-MAX", XSIZE=10)
;  maskID = WIDGET_BUTTON(maskRow, VALUE='Vanadium Mask', UVALUE='DGSR_MASK', UNAME='DGSR_MASK')
;  hardMaskID = WIDGET_BUTTON(maskRow, VALUE=' HARD Mask', UVALUE='DGSR_HARD_MASK', UNAME='DGSR_HARD_MASK')
;    UNAME='DGSR_ROI_FILENAME', /ALL_EVENTS, XSIZE=20)
;    UNAME="DGSR_TIBCONST", /ALL_EVENTS)
;    UNAME="DGSR_TIB-MIN", XSIZE=20)
;    UNAME="DGSR_TIB-MAX", XSIZE=20)
;  speButton = Widget_Button(outputBaseCol1, Value='SPE/PHX', UVALUE='DGSR_MAKE_SPE', UNAME='DGSR_MAKE_SPE')
;  qvectorButton = Widget_Button(outputBaseCol1, Value='Qvector', UVALUE='DGSR_MAKE_QVECTOR', UNAME='DGSR_MAKE_QVECTOR')
;  fixedButton = Widget_Button(outputBaseCol1, Value='Fixed Grid', UVALUE='DGSR_MAKE_FIXED', UNAME='DGSR_MAKE_FIXED')
;  tibButton = WIDGET_BUTTON(outputBaseCol1, VALUE='TIB const', UVALUE='DGSR_DUMP_TIB', UNAME='DGSR_DUMP_TIB')
;    UNAME='DGSR_MAKE_COMBINED_ET')
;    UNAME='DGSR_MAKE_COMBINED_TOF')
;    UNAME='DGSR_DUMP_NORM')
;    UNAME='DGSR_MAKE_COMBINED_WAVE')
;    UNAME="DGSR_COMBINED_WAVELENGTH_RANGE")
;        XSIZE=7, UVALUE="DGSR_LAMBDA_MIN", UNAME="DGSR_LAMBDA_MIN", /ALL_EVENTS)
;        XSIZE=7, UVALUE="DGSR_LAMBDA_MAX", UNAME="DGSR_LAMBDA_MAX", /ALL_EVENTS)
;        XSIZE=7, UVALUE="DGSR_LAMBDA_STEP", UNAME="DGSR_LAMBDA_STEP", /ALL_EVENTS)
;
;    VALUE=dgsr_cmd->generate(), UNAME='DGSR_CMD_TEXT')
;    'DGSR_LAUNCH_COLLECTOR_BUTTON', $
;    'DGSR_EXECUTE_BUTTON'
