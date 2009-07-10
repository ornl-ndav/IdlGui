PRO DGSN_UpdateGUI, tlb, dgsn_cmd

  ; Run Number
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_DATARUN')
  dgsn_cmd->GetProperty, DataRun=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; Detector Bank (lower)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_DATAPATHS_LOWER')
  dgsn_cmd->GetProperty,LowerBank =myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Detector Bank (higher)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_DATAPATHS_UPPER')
  dgsn_cmd->GetProperty, UpperBank=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue  

  ; Ei
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_EI')
  dgsn_cmd->GetProperty, Ei=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
    
  ; T0
    widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_TZERO')
  dgsn_cmd->GetProperty, Tzero=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; No monitor Normalisation
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_NO-MON-NORM')
  dgsn_cmd->GetProperty, NoMonitorNorm=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Store the state of this button
  NoMonitorNorm_State = myValue
    
  ; Proton Charge Normalisation
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_PC-NORM')
  dgsn_cmd->GetProperty, PCnorm=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue  
  ; Set the sensitivity of this button based on the value
  ; of the No-Monitor Normalisation button
  WIDGET_CONTROL, widget_ID, SENSITIVE=NoMonitorNorm_State

  ; Monitor Number
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_USMON')
  dgsn_cmd->GetProperty, USmonPath=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; Empty Can Run
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_EMPTYCAN')
  dgsn_cmd->GetProperty, EmptyCan=myValue
  ; Don't Load the default value
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Black Can Run
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_BLACKCAN')
  dgsn_cmd->GetProperty, BlackCan=myValue
  ; Don't Load the default value
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Dark Current
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_DARK')
  dgsn_cmd->GetProperty, Dark=myValue
  ; Don't Load the default value
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue  

  ; Monitor Integration Range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_MON-INT-MIN')
  dgsn_cmd->GetProperty, MonRange_Min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Monitor Integration Range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_MON-INT-MAX')
  dgsn_cmd->GetProperty, MonRange_Max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
    
  ; Normalisation Integration Range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_NORM-INT-MIN')
  dgsn_cmd->GetProperty, NormRange_Min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; Normalisation Integration Range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_NORM-INT-MAX')
  dgsn_cmd->GetProperty, NormRange_Max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; Norm Trans Coeff
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_NORM-TRANS')
  dgsn_cmd->GetProperty, NormTrans=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Detector Efficiency
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_DET-EFF')
  dgsn_cmd->GetProperty, DetEff=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; ROI 
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_ROI_FILENAME')
  dgsn_cmd->GetProperty, ROIfile=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; TOF Spectrum Cutting (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_TOF-CUT-MIN')
  dgsn_cmd->GetProperty, Tmin=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; TOF Spectrum Cutting (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_TOF-CUT-MAX')
  dgsn_cmd->GetProperty, Tmax=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue  

  ; TIB constant
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_TIBCONST')
  dgsn_cmd->GetProperty, TIBconst=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
    
  ; TIB range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_TIB-MIN')
  dgsn_cmd->GetProperty, TIBrange_min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  ; TIB range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_TIB-MAX')
  dgsn_cmd->GetProperty, TIBrange_max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; TIB const output
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_DUMP_TIB')
  dgsn_cmd->GetProperty, DumpTIB=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue

  ; Combined TOF
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_MAKE_COMBINED_TOF')
  dgsn_cmd->GetProperty, DumpTOF=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue

  ; Combined Norm
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_DUMP_NORM')
  dgsn_cmd->GetProperty, DumpNorm=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
    ; Combined Wavelength
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_MAKE_COMBINED_WAVE')
  dgsn_cmd->GetProperty, DumpWave=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Save the button state
  DumpWavelengthState = myValue

  ; Enable if DumpWavelength button is pressed  
  wavelengthRange_ID = WIDGET_INFO(tlb,FIND_BY_UNAME='DGSN_COMBINED_WAVELENGTH_RANGE')
  WIDGET_CONTROL, wavelengthRange_ID, SENSITIVE=DumpWavelengthState
  
  ; Combined Wavelength Range (min)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_LAMBDA_MIN')
  dgsn_cmd->GetProperty, LambdaBins_Min=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
 
  ; Combined Wavelength Range (max)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_LAMBDA_MAX')
  dgsn_cmd->GetProperty, LambdaBins_Max=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Combined Wavelength Range (step)
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_LAMBDA_STEP')
  dgsn_cmd->GetProperty, LambdaBins_Step=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue  

  ; Low Threshold
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_LO_THRESHOLD')
  dgsn_cmd->GetProperty, Lo_Threshold=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue  
  
  ; Hi Threshold
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_HI_THRESHOLD')
  dgsn_cmd->GetProperty, Hi_Threshold=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue  
END