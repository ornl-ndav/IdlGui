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

PRO dgsnorm_events, event, dgsn_cmd

  WIDGET_CONTROL, event.id, GET_UVALUE=myUVALUE
  
  ; Check that we actually got something back in the UVALUE
  IF N_ELEMENTS(myUVALUE) EQ 0 THEN myUVALUE="NOTHING"
  
  CASE (myUVALUE) OF
    'DGSN_DATARUN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ;print, 'DGSN_DATARUN'
      dgsn_cmd->SetProperty, DataRun=myValue
    END
    'DGSN_EI': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, Ei=myValue
    END
    'DGSN_TZERO': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, Tzero=myValue
    END
    'DGSN_FINDNEXUS': BEGIN
      dgsn_cmd->GetProperty, Instrument=instrument
      dgsn_cmd->GetProperty, DataRun=run_number
    ; TODO: Sort out findnexus
    ;nxsfile = findnexus(RUN_NUMBER=run_number, INSTRUMENT=instrument)
    END
    'DGSN_DATAPATHS_LOWER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=lowerValue
      dgsn_cmd->SetProperty, LowerBank=lowerValue
    END
    'DGSN_DATAPATHS_UPPER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=upperValue
      dgsn_cmd->SetProperty, UpperBank=upperValue
    END
    'DGSN_ROI_FILENAME': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgsn_cmd->SetProperty, ROIfile=myValue
    END
    'DGSN_MAKE_COMBINED_TOF': BEGIN
      dgsn_cmd->SetProperty, DumpTOF=event.SELECT
    END
    'DGSN_MAKE_COMBINED_WAVE': BEGIN
      dgsn_cmd->SetProperty, DumpWave=event.SELECT
      ; Also make the wavelength range fields active (or inactive!)
      wavelengthRange_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_COMBINED_WAVELENGTH_RANGE')
      WIDGET_CONTROL, wavelengthRange_ID, SENSITIVE=event.SELECT
    END
    'DGSN_DUMP_TIB': BEGIN
      dgsn_cmd->SetProperty, DumpTIB=event.SELECT
    END
    'DGSN_WHITE_NORM': BEGIN
      dgsn_cmd->SetProperty, WhiteNorm=event.SELECT
      normLabel = WIDGET_INFO(event.top,FIND_BY_UNAME="DGSN_NORM-INT-RANGE_LABEL")
      IF (event.SELECT) THEN BEGIN
        WIDGET_CONTROL, normLabel, SET_VALUE=" Normalisation Integration Range (A)   "
      ENDIF ELSE BEGIN
        WIDGET_CONTROL, normLabel, SET_VALUE=" Normalisation Integration Range (meV) "
      ENDELSE
    END
    'DGSN_LAMBDA_MIN': BEGIN
      ; Minimum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, LambdaBins_Min=myValue
    END
    'DGSN_LAMBDA_MAX': BEGIN
      ; Maximum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, LambdaBins_Max=myValue
    END
    'DGSN_LAMBDA_STEP': BEGIN
      ; Wavelength Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, LambdaBins_Step=myValue
    END
    'DGSN_NO-MON-NORM': BEGIN
      dgsn_cmd->SetProperty, NoMonitorNorm=event.SELECT
      ; Also make the Proton Charge Norm active
      pcnorm_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_PC-NORM')
      WIDGET_CONTROL, pcnorm_ID, SENSITIVE=event.SELECT
    END
    'DGSN_PC-NORM': BEGIN
      dgsn_cmd->SetProperty, PCnorm=event.SELECT
    END
    'DGSN_USMON': BEGIN
      ; Upstream Monitor Number (usualy 1)
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, USmonPath=STRCOMPRESS(myValue, /REMOVE_ALL)
    END
    'DGSN_EMPTYCAN': BEGIN
      ; Empty Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, EmptyCan=myValue
    END
    'DGSN_BLACKCAN': BEGIN
      ; Black Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, BlackCan=myValue
    END
    'DGSN_DARK': BEGIN
      ; Dark Current Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, Dark=myValue
    END
    'DGSN_TIBCONST': BEGIN
      ; Time Independent Background Constant
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, TIBconst=myValue
    END
    'DGSN_TIB-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, TIBRange_Min=myValue
    END
    'DGSN_TIB-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, TIBRange_Max=myValue
    END
    'DGSN_NORM-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, NormRange_Min=myValue
    END
    'DGSN_NORM-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, NormRange_Max=myValue
    END
    'DGSN_MON-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, MonRange_Min=myValue
    END
    'DGSN_MON-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, MonRange_Max=myValue
    END
    'DGSN_TOF-CUT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, Tmin=myValue
    END
    'DGSN_TOF-CUT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, Tmax=myValue
    END
    'DGSN_NORM-TRANS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, NormTrans=myValue
    END
    'DGSN_DET-EFF': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsn_cmd->SetProperty, DetEff=myValue
    END
    'DGSN_LO_THRESHOLD':BEGIN
    WIDGET_CONTROL, event.ID, GET_VALUE=myValue
    dgsn_cmd->SetProperty, Lo_Threshold=myValue
  END
  'DGSN_HI_THRESHOLD':BEGIN
  WIDGET_CONTROL, event.ID, GET_VALUE=myValue
  dgsn_cmd->SetProperty, Hi_Threshold=myValue
END
'NOTHING': BEGIN
END
ELSE: begin
  ; Do nowt
  print, '*** UVALUE: ' + myUVALUE + ' not handled! ***'
END
ENDCASE

END