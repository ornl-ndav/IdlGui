PRO dgsreduction_events, event, dgsr_cmd
  
  WIDGET_CONTROL, event.id, GET_UVALUE=myUVALUE
  
  ; Check that we actually got something back in the UVALUE
  IF N_ELEMENTS(myUVALUE) EQ 0 THEN myUVALUE="NOTHING"
  

  CASE (myUVALUE) OF
    'NOTHING': BEGIN
    END
    'DGSR_DATARUN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, DataRun=myValue
    END
    'DGSR_EI': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Ei=myValue
    END
    'DGSR_TZERO': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Tzero=myValue      
    END
    'DGSR_DATAPATHS_LOWER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=lowerValue
      dgsr_cmd->SetProperty, LowerBank=lowerValue
    END
    'DGSR_DATAPATHS_UPPER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=upperValue
      dgsr_cmd->SetProperty, UpperBank=upperValue
    END
    'DGSR_ROI_FILENAME': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgsr_cmd->SetProperty, ROIfile=myValue
    END
    'DGSR_MASK': BEGIN
      ;WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgsr_cmd->SetProperty, Mask=event.SELECT
    END
    'DGSR_HARD_MASK': BEGIN
      ;WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgsr_cmd->SetProperty, HardMask=event.SELECT
    END
    'DGSR_MAKE_SPE': BEGIN
      dgsr_cmd->SetProperty, SPE=event.SELECT
    END
    'DGSR_MAKE_QVECTOR': BEGIN
      dgsr_cmd->SetProperty, Qvector=event.SELECT
      fixedGrid_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_MAKE_FIXED')
      ; Make the Fixed Grid output selection active if Qvector is selected.
      WIDGET_CONTROL, fixedGrid_ID, SENSITIVE=event.SELECT
    END
    'DGSR_MAKE_FIXED': BEGIN
      dgsr_cmd->SetProperty, Fixed=event.SELECT
    END
    'DGSR_MAKE_COMBINED_ET': BEGIN
      dgsr_cmd->SetProperty, DumpEt=event.SELECT
    END
    'DGSR_MAKE_COMBINED_TOF': BEGIN
      dgsr_cmd->SetProperty, DumpTOF=event.SELECT
    END
    'DGSR_MAKE_COMBINED_WAVE': BEGIN
      dgsr_cmd->SetProperty, DumpWave=event.SELECT
      ; Also make the wavelength range fields active (or inactive!)
      wavelengthRange_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_COMBINED_WAVELENGTH_RANGE')
      WIDGET_CONTROL, wavelengthRange_ID, SENSITIVE=event.SELECT
    END
    'DGSR_DUMP_TIB': BEGIN
      dgsr_cmd->SetProperty, DumpTIB=event.SELECT
    END
    'DGSR_DUMP_NORM': BEGIN
      dgsr_cmd->SetProperty, DumpNorm=event.SELECT
    END
    'DGSR_ET_MIN': BEGIN
      ; Minimum Energy Transfer
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EnergyBins_Min=myValue
    END
    'DGSR_ET_MAX': BEGIN
      ; Maximum Energy Transfer
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EnergyBins_Max=myValue
    END
    'DGSR_ET_STEP': BEGIN
      ; Energy Transfer Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EnergyBins_Step=myValue
    END
    'DGSR_LAMBDA_MIN': BEGIN
      ; Minimum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, LambdaBins_Min=myValue
    END
    'DGSR_LAMBDA_MAX': BEGIN
      ; Maximum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, LambdaBins_Max=myValue
    END
    'DGSR_LAMBDA_STEP': BEGIN
      ; Wavelength Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, LambdaBins_Step=myValue
    END
    'DGSR_Q_MIN': BEGIN
      ; Minimum Q
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, QBins_Min=myValue
    END
    'DGSR_Q_MAX': BEGIN
      ; Maximum Q
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, QBins_Max=myValue
    END
    'DGSR_Q_STEP': BEGIN
      ; Q Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, QBins_Step=myValue
    END
    'DGSR_NO-MON-NORM': BEGIN
      dgsr_cmd->SetProperty, NoMonitorNorm=event.SELECT
      ; Also make the Proton Charge Norm active
      pcnorm_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_PC-NORM')
      WIDGET_CONTROL, pcnorm_ID, SENSITIVE=event.SELECT
    END
    'DGSR_PC-NORM': BEGIN
      dgsr_cmd->SetProperty, PCnorm=event.SELECT
    END
    'DGSR_LAMBDA-RATIO': BEGIN
      dgsr_cmd->SetProperty, LambdaRatio=event.SELECT
    END
    'DGSR_USMON': BEGIN
      ; Upstream Monitor Number (usualy 1)
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, USmonPath=STRCOMPRESS(myValue, /REMOVE_ALL)
    END
    'DGSR_NORMRUN': BEGIN
      ; Norm Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Normalisation=myValue  
          
    END    
    'DGSR_EMPTYCAN': BEGIN
      ; Empty Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EmptyCan=myValue      
    END    
    'DGSR_BLACKCAN': BEGIN
      ; Black Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, BlackCan=myValue      
    END    
    'DGSR_DARK': BEGIN
      ; Dark Current Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Dark=myValue      
    END
    'DGSR_TIBCONST': BEGIN
      ; Time Independent Background Constant
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, TIBconst=myValue
    END
    'DGSR_TIB-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, TIBRange_Min=myValue
    END
    'DGSR_TIB-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, TIBRange_Max=myValue
    END
    'DGSR_NORM-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, NormRange_Min=myValue
    END
    'DGSR_NORM-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, NormRange_Max=myValue
    END
    'DGSR_MON-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, MonRange_Min=myValue
    END
    'DGSR_MON-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, MonRange_Max=myValue
    END
    'DGSR_TOF-CUT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Tmin=myValue
    END
    'DGSR_TOF-CUT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Tmax=myValue
    END
    'DGSR_DATA-TRANS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, DataTrans=myValue
    END
    'DGSR_NORM-TRANS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, NormTrans=myValue
    END
    'DGSR_DET-EFF': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, DetEff=myValue
    END
    ELSE: begin
    ; Do nowt
      print, '*** UVALUE: ' + myUVALUE + ' not handled! ***' 
    END
  ENDCASE
  
END