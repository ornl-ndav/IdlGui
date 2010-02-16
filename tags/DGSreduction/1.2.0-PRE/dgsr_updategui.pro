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

PRO DGSR_UpdateGUI, tlb, dgsr_cmd

  ; Run Number
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DATARUN')
  dgsr_cmd->GetProperty, DataRun=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Detector Bank (lower)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DATAPATHS_LOWER')
  dgsr_cmd->GetProperty,LowerBank =myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Detector Bank (higher)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DATAPATHS_UPPER')
  dgsr_cmd->GetProperty, UpperBank=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Ei
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_EI')
  dgsr_cmd->GetProperty, Ei=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; T0
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_TZERO')
  dgsr_cmd->GetProperty, Tzero=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Energy Transfer Range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_ET_MIN')
  dgsr_cmd->GetProperty, EnergyBins_Min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Energy Transfer Range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_ET_MAX')
  dgsr_cmd->GetProperty, EnergyBins_Max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Energy Transfer Range (step)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_ET_STEP')
  dgsr_cmd->GetProperty, EnergyBins_Step=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Q Range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_Q_MIN')
  dgsr_cmd->GetProperty, QBins_Min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Q Range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_Q_MAX')
  dgsr_cmd->GetProperty, QBins_Max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Q Range (step)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_Q_STEP')
  dgsr_cmd->GetProperty, QBins_Step=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; No monitor Normalisation
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_NO-MON-NORM')
  dgsr_cmd->GetProperty, NoMonitorNorm=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Store the state of this button
  NoMonitorNorm_State = myValue
  
  ; Proton Charge Normalisation
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_PC-NORM')
  dgsr_cmd->GetProperty, PCnorm=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Set the sensitivity of this button based on the value
  ; of the No-Monitor Normalisation button
  WIDGET_CONTROL, widget_ID, SENSITIVE=NoMonitorNorm_State
  
  ; Lambda Scaling
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_LAMBDA-RATIO')
  dgsr_cmd->GetProperty, LambdaRatio=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Monitor Number
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_USMON')
  dgsr_cmd->GetProperty, USmonPath=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Normalisation Run
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_NORMRUN')
  dgsr_cmd->GetProperty, Normalisation=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ;  IF (LONG(myValue) LE 0) THEN WIDGET_CONTROL, widget_ID, SET_VALUE=NULL
  
  ; Empty Can Run
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_EMPTYCAN')
  dgsr_cmd->GetProperty, EmptyCan=myValue
  ; Don't Load the default value
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Black Can Run
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_BLACKCAN')
  dgsr_cmd->GetProperty, BlackCan=myValue
  ; Don't Load the default value
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Dark Current
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DARK')
  dgsr_cmd->GetProperty, Dark=myValue
  ; Don't Load the default value
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  
  ; Monitor Integration Range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MON-INT-MIN')
  dgsr_cmd->GetProperty, MonRange_Min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Monitor Integration Range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MON-INT-MAX')
  dgsr_cmd->GetProperty, MonRange_Max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Normalisation Integration Range (min)
  ;  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_NORM-INT-MIN')
  ;  dgsr_cmd->GetProperty, NormRange_Min=myValue
  ;  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Normalisation Integration Range (max)
  ;  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_NORM-INT-MAX')
  ;  dgsr_cmd->GetProperty, NormRange_Max=myValue
  ;  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Data Trans Coeff
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DATA-TRANS')
  dgsr_cmd->GetProperty, DataTrans=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Norm Trans Coeff
  ;  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_NORM-TRANS')
  ;  dgsr_cmd->GetProperty, NormTrans=myValue
  ;  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Detector Efficiency
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DET-EFF')
  dgsr_cmd->GetProperty, DetEff=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Vanadium Mask Flag
  ;  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MASK')
  ;  dgsr_cmd->GetProperty, Mask=myValue
  ;  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Hard Mask Flag
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_HARD_MASK')
  dgsr_cmd->GetProperty, HardMask=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; ROI
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_ROI_FILENAME')
  dgsr_cmd->GetProperty, ROIfile=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; TOF Spectrum Cutting (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_TOF-CUT-MIN')
  dgsr_cmd->GetProperty, Tmin=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; TOF Spectrum Cutting (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_TOF-CUT-MAX')
  dgsr_cmd->GetProperty, Tmax=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; TIB constant
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_TIBCONST')
  dgsr_cmd->GetProperty, TIBconst=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; TIB range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_TIB-MIN')
  dgsr_cmd->GetProperty, TIBrange_min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; TIB range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_TIB-MAX')
  dgsr_cmd->GetProperty, TIBrange_max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; SPE output
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MAKE_SPE')
  dgsr_cmd->GetProperty, SPE=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Qvector output
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MAKE_QVECTOR')
  dgsr_cmd->GetProperty, Qvector=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Store the state of this button
  QvectorState = myValue
  
  ; Fixed Grid
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MAKE_FIXED')
  dgsr_cmd->GetProperty, Fixed=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Set the sensitvity based on the value of the Qvector button
  WIDGET_CONTROL, widget_ID, SENSITIVE=QvectorState
  
  ; TIB const output
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DUMP_TIB')
  dgsr_cmd->GetProperty, DumpTIB=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Combined Et
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MAKE_COMBINED_ET')
  dgsr_cmd->GetProperty, DumpEt=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Combined TOF
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MAKE_COMBINED_TOF')
  dgsr_cmd->GetProperty, DumpTOF=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Combined Norm
  ;  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DUMP_NORM')
  ;  dgsr_cmd->GetProperty, DumpNorm=myValue
  ;  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Combined Wavelength
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_MAKE_COMBINED_WAVE')
  dgsr_cmd->GetProperty, DumpWave=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Save the button state
  DumpWavelengthState = myValue
  
  ; Enable if DumpWavelength button is pressed
  wavelengthRange_ID = WIDGET_INFO(tlb,FIND_BY_UNAME='DGSR_COMBINED_WAVELENGTH_RANGE')
  WIDGET_CONTROL, wavelengthRange_ID, SENSITIVE=DumpWavelengthState
  
  ; Combined Wavelength Range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_LAMBDA_MIN')
  dgsr_cmd->GetProperty, LambdaBins_Min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Combined Wavelength Range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_LAMBDA_MAX')
  dgsr_cmd->GetProperty, LambdaBins_Max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Combined Wavelength Range (step)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_LAMBDA_STEP')
  dgsr_cmd->GetProperty, LambdaBins_Step=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Phonon D-O-S
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_PHONON_DOS')
  dgsr_cmd->GetProperty, DOS=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Debye Waller Factor
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DWF')
  dgsr_cmd->GetProperty, DebyeWaller=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Wandering Phase Correction
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_CWP')
  dgsr_cmd->GetProperty, CWP=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; SEBlock
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_SEBLOCK')
  dgsr_cmd->GetProperty, SEBlock=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Angle Offset
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_ANGLE_OFFSET')
  dgsr_cmd->GetProperty, RotationAngle=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Output directory label
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_USER_LABEL')
  dgsr_cmd->GetProperty, UserLabel=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
END