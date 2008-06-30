Pro MakeGuiReduceInputTab5, ReduceInputTab, ReduceInputTabSettings

;******************************************************************************
;                           Define size arrays
;******************************************************************************
XYoff = [20,25]
sScaleConstant = { size: [XYoff[0],$
                          XYoff[1]],$
                   value: 'Scale Constant for Lambda Dependent Background'}
XYoff = [310,-5]
sScaleConstantInput = { size: [sScaleConstant.size[0]+XYoff[0],$
                               sScaleConstant.size[1]+XYoff[1],$
                               70],$
                        value: '4.345',$
                        uname: 'scale_constant_lambda_dependent_back_uname'}

;Input Base
XYoff = [10,60]
sInputBase = { size: [XYoff[0],$
                      XYoff[1],$
                      720,150],$
               frame: 0,$
               sensitive:   0,$
               uname: 'scale_constant_lambda_dependent_input_base'}

;Chopper Frequency
XYoff = [10,20]
sChopperFrequency = { size: [XYoff[0],$
                             XYoff[1]],$
                      value: 'Chopper Frequency                     ' + $
                      '     Hz'}
XYoff = [180,-5]
sChopperFrequencyValue = { size: [XYoff[0],$
                                  sChopperFrequency.size[1]+XYoff[1],$
                                  70],$
                           uname: 'chopper_frequency_value'}
                           
                           
;Chopper Wavelength
XYoff = [0,40]
sChopperWavelength = { size: [sChopperFrequency.size[0]+XYoff[0],$
                              sChopperFrequency.size[1]+XYoff[1]],$
                       value: 'Chopper Wavelength Center            ' + $
                       '      Angstroms'}
XYoff = [0,-5]
sChopperWavelengthValue = { size: [sChopperFrequencyValue.size[0]+XYoff[0],$
                                   sChopperWavelength.size[1]+XYoff[1],$
                                   sChopperFrequencyValue.size[2]],$
                           uname: 'chopper_wavelength_value'}
                           
;TOF least Background
XYoff = [0,40]
sTOFleast = { size: [sChopperFrequency.size[0]+XYoff[0],$
                     sChopperWavelength.size[1]+XYoff[1]],$
              value: 'TOF Least Background            ' + $
              '           microS'}
XYoff = [0,-5]
sTOFleastValue = { size: [sChopperFrequencyValue.size[0]+XYoff[0],$
                          sTOFleast.size[1]+XYoff[1],$
                          sChopperFrequencyValue.size[2]],$
                   uname: 'tof_least_background_value'}

;******************************************************************************
;                                Build GUI
;******************************************************************************
main_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[7])

wScaleConstant = WIDGET_LABEL(main_base,$
                              XOFFSET   = sScaleConstant.size[0],$
                              YOFFSET   = sScaleConstant.size[1],$ 
                              VALUE     = sScaleConstant.value)

wScaleConstantInput = WIDGET_TEXT(main_base,$
                                  XOFFSET   = sScaleConstantInput.size[0],$
                                  YOFFSET   = sScaleConstantInput.size[1],$
                                  SCR_XSIZE = sScaleConstantInput.size[2],$
                                  UNAME     = sScaleConstantInput.uname,$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

;Input Base
wInputBase = WIDGET_BASE(main_base,$
                         XOFFSET   = sInputBase.size[0],$
                         YOFFSET   = sInputBase.size[1],$
                         SCR_XSIZE = sInputBase.size[2],$
                         SCR_YSIZE = sInputBase.size[3],$
                         UNAME     = sInputBase.uname,$
                         SENSITIVE = sInputBase.sensitive,$
                         FRAME     = sInputBase.frame)

;Chopper Frequency
wChopperFrequencyValue = $
  WIDGET_TEXT(wInputBase,$
              XOFFSET   = sChopperFrequencyValue.size[0],$
              YOFFSET   = sChopperFrequencyValue.size[1],$
              SCR_XSIZE = sChopperFrequencyValue.size[2],$
              UNAME     = sChopperFrequencyValue.uname,$
              /EDITABLE,$
              /ALL_EVENTS,$
              /ALIGN_LEFT)

wChopperFrequency = WIDGET_LABEL(wInputBase,$
                                 XOFFSET = sChopperFrequency.size[0],$
                                 YOFFSET = sChopperFrequency.size[1],$
                                 VALUE   = sChopperFrequency.value)


;Chopper Wavelength
wChopperWavelengthValue = $
  WIDGET_TEXT(wInputBase,$
              XOFFSET   = sChopperWavelengthValue.size[0],$
              YOFFSET   = sChopperWavelengthValue.size[1],$
              SCR_XSIZE = sChopperWavelengthValue.size[2],$
              UNAME     = sChopperWavelengthValue.uname,$
              /EDITABLE,$
              /ALL_EVENTS,$
              /ALIGN_LEFT)

wChopperWavelength = WIDGET_LABEL(wInputBase,$
                                 XOFFSET = sChopperWavelength.size[0],$
                                 YOFFSET = sChopperWavelength.size[1],$
                                 VALUE   = sChopperWavelength.value)

;TOF least Background
wTOFleastValue = $
  WIDGET_TEXT(wInputBase,$
              XOFFSET   = sTOFleastValue.size[0],$
              YOFFSET   = sTOFleastValue.size[1],$
              SCR_XSIZE = sTOFleastValue.size[2],$
              UNAME     = sTOFleastValue.uname,$
              /EDITABLE,$
              /ALL_EVENTS,$
              /ALIGN_LEFT)

wTOFleast = WIDGET_LABEL(wInputBase,$
                                 XOFFSET = sTOFleast.size[0],$
                                 YOFFSET = sTOFleast.size[1],$
                                 VALUE   = sTOFleast.value)

END
