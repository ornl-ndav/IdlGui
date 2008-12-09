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

PRO MakeGuiReduceInputTab5, ReduceInputTab, ReduceInputTabSettings

;******************************************************************************
;                           Define size arrays
;******************************************************************************

;Use or not Iterative Background Subtraction ----------------------------------
XYoff = [10,5]
sIBScwBgroup = { size: [XYoff[0],XYoff[1]],$
                 value: ['ON','OFF'],$
                 uname: 'use_iterative_background_subtraction_cw_bgroup',$
                 set_value: 1.0}
XYoff = [100,7]
sIBSlabel = { value: '-->  USE ITERATIVE BACKGROUND SUBTRACTION',$
              size: [sIBScwBgroup.size[0]+XYoff[0],$
                     sIBScwBgroup.size[1]+XYoff[1]]}
              
;base that will hold all the widgets ------------------------------------------
XYoff = [10,38]
sBase = { size: [XYoff[0],$
                 XYoff[1],$
                 725,$
                 130],$
          frame: 1,$
          sensitive: 1,$ ;REMOVE 1 and put 0
          uname: 'non_iterative_background_subtraction_base'}

;______________________________________________________________________________
;Scale constant for lambda dependent background -------------------------------
XYoff = [5,0]
sSCframe = { size: [XYoff[0],$
                    XYOff[1],$
                    730,130],$
             frame: 0}

;scale constant for lambda dependent background label and value
XYoff = [10,50]
sScaleConstant = { size: [XYoff[0],$
                          XYoff[1]],$
                   uname: 'scale_constant_lambda_depdendent_back_label',$
                   value: 'Scale Constant for Lambda Dependent Background'}
XYoff = [285,-7]
sScaleConstantInput = { size: [sScaleConstant.size[0]+XYoff[0],$
                               sScaleConstant.size[1]+XYoff[1],$
                               70],$
                        value: '4.345',$
                        uname: 'scale_constant_lambda_dependent_back_uname'}

;Input Base1
XYoff = [400,5]
sInputBase = { size: [sScaleConstant.size[0]+XYoff[0],$
                      XYoff[1],$
                      310,120],$
               frame: 0,$
               sensitive: 0,$
               uname: 'scale_constant_lambda_dependent_input_base'}

;Chopper Frequency
XYoff = [10,5]
sChopperFrequency = { size: [XYoff[0],$
                             XYoff[1]],$
                      value: 'Chopper Frequency              ' + $
                      '        Hz'}
XYoff = [155,-8]
sChopperFrequencyValue = { size: [sChopperFrequency.size[0]+XYoff[0],$
                                  sChopperFrequency.size[1]+XYoff[1],$
                                  70],$
                           uname: 'chopper_frequency_value'}
                           
                           
;Chopper Wavelength
XYoff = [0,40]
sChopperWavelength = { size: [sChopperFrequency.size[0]+XYoff[0],$
                              sChopperFrequency.size[1]+XYoff[1]],$
                       value: 'Chopper Wavelength Center            ' + $
                       '  Angstroms'}
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
              '       microS'}
XYoff = [0,-5]
sTOFleastValue = { size: [sChopperFrequencyValue.size[0]+XYoff[0],$
                          sTOFleast.size[1]+XYoff[1],$
                          sChopperFrequencyValue.size[2]],$
                   uname: 'tof_least_background_value'}

;------------------------------------------------------------------------------
;Base 2
XYoff = [0,10]
sBase2 = { size: [sBase.size[0]+XYoff[0],$
                  sBase.size[1]+$
                  sBase.size[3]+XYoff[1],$
                  ReduceInputTabSettings.size[2],$
                  530],$
           frame: 0,$
           sensitive: 0,$
           uname: 'iterative_background_subtraction_base'}
;______________________________________________________________________________
;Positive transverse energy integration range ---------------------------------
XYoff = [0, 10]
sPTEbase = { size: [XYoff[0],$
                    XYoff[1],$
                    725,$
                    55],$
             frame: 1}

XYoff = [15,-8]                 ;title
sPTEtitle = { size: [sPTEbase.size[0]+XYoff[0],$
                     sPTEbase.size[1]+XYoff[1]],$
              value: 'Positive Transverse Energy Integration Range'}

XYoff = [20,20]
sPTEminLabel = { size : [XYoff[0],$
                         XYoff[1]],$
                 value : 'Min:',$
                 uname : 'pte_min_text_label'}
XYoff3 = [40,-5]
sPTEminText  = { size : [sPTEminLabel.size[0]+XYoff3[0],$
                         sPTEminlabel.size[1]+XYoff3[1],$
                         100,30],$
                 uname : 'pte_min_text'}

XYoff4 = [180,0]
sPTEmaxLabel = { size : [sPTEminLabel.size[0]+XYoff4[0],$
                         sPTEminLabel.size[1]+XYoff4[1]],$
                 value : 'Max:',$
                 uname : 'pte_max_text_label'}
XYoff5 = [40,-5]
sPTEmaxText  = { size : [sPTEmaxLabel.size[0]+XYoff5[0],$
                         sPTEmaxLabel.size[1]+XYoff5[1],$
                         100,30],$
                 uname : 'pte_max_text'}
XYoff4 = [180,0]
sPTEbinLabel = { size : [sPTEmaxLabel.size[0]+XYoff4[0],$
                         sPTEmaxLabel.size[1]+XYoff4[1]],$
                 value : '  Width:',$
                 uname : 'pte_bin_text_label'}
XYoff5 = [65,-5]
sPTEbinText  = { size : [sPTEbinLabel.size[0]+XYoff5[0],$
                         sPTEbinLabel.size[1]+XYoff5[1],$
                         100,30],$
                 uname : 'pte_bin_text'}
XYoff = [210,0]
sPTEtypeLabel = { size: [sPTEbinLabel.size[0]+XYoff[0],$
                         sPTEbinLabel.size[1]+XYoff[1]],$
                  value: 'Scale: Linear'}

;______________________________________________________________________________
;other flags ------------------------------------------------------------------
XYoff = [0, 20]
sOtherBase = { size: [sPTEbase.size[0]+XYoff[0],$
                      sPTEbase.size[1]+$
                      sPTEbase.size[3]+XYoff[1],$
                      sPTEbase.size[2],$
                      260],$
               frame: 1}

XYoff = [15,-8]                 ;title
sOtherTitle = { size: [sOtherBase.size[0]+XYoff[0],$
                       sOtherBase.size[1]+XYoff[1]],$
                value: 'Iterative Background Subtration Flags'}

;Detailed balance temperature
XYoff = [20,20] ;label
sDBTlabel = { size: [XYoff[0],$
                     XYoff[1]],$
              value: 'Detailed Balance Temperature              K'}
XYoff = [200,-5]                ;value
sDBTvalue = { size: [XYoff[0],$
                     sDBTlabel.size[1]+XYoff[1],$
                     60],$
              value: '',$
              uname: 'detailed_balance_temperature_value'}
         
;Ratio Tolerance
XYoff = [0,35] ;label
sRTlabel = { size: [sDBTlabel.size[0]+XYoff[0],$
                    sDBTlabel.size[1]+XYoff[1]],$
              value: 'Ratio Tolerance'}
XYoff = [0,-5]                ;value
sRTvalue = { size: [sDBTvalue.size[0]+XYoff[0],$
                    sRTlabel.size[1]+XYoff[1],$
                    sDBTvalue.size[2]],$
             value: '',$
             uname: 'ratio_tolerance_value'}

;Number of iteration
XYoff = [0,35] ;label
sNIlabel = { size: [sDBTlabel.size[0]+XYoff[0],$
                    sRTlabel.size[1]+XYoff[1]],$
              value: 'Number of Iteration                     (20)'}
XYoff = [0,-5]                  ;value
sNIvalue = { size: [sDBTvalue.size[0]+XYoff[0],$
                    sNIlabel.size[1]+XYoff[1],$
                    sDBTvalue.size[2]],$
             value: '20',$
             uname: 'number_of_iteration'}

;minimum wavelength dependent background cst
XYoff = [0,35] ;label
sMinWDBlabel = { size: [sDBTlabel.size[0]+XYoff[0],$
                        sNIlabel.size[1]+XYoff[1]],$
                 value: 'Minimum Wavelength-Dependent Background Constant' + $
                 '                (0.0)'}
XYoff = [0,-5]                  ;value
sMinWDBvalue = { size: [325+XYoff[0],$
                        sMinWDBlabel.size[1]+XYoff[1],$
                        80],$
                 value: '0.0',$
                 uname: 'min_wave_dependent_back'}

;maximum wavelength dependent background cst
XYoff = [0,35] ;label
sMaxWDBlabel = { size: [sDBTlabel.size[0]+XYoff[0],$
                        sMinWDBlabel.size[1]+XYoff[1]],$
                 value: 'Maximum Wavelength-Dependent Background Constant'}
XYoff = [0,-5]                  ;value
sMaxWDBvalue = { size: [sMinWDBvalue.size[0]+XYoff[0],$
                        sMaxWDBlabel.size[1]+XYoff[1],$
                        80],$
                 value: '',$
                 uname: 'max_wave_dependent_back'}

;small wavelength dependent background cst
XYoff = [0,35] ;label
sSmallWDBlabel = { size: [sDBTlabel.size[0]+XYoff[0],$
                          sMaxWDBlabel.size[1]+XYoff[1]],$
                   value: 'Small Wavelength-Dependent Background Constant' + $
                   '                  (1.0E-14)'}
XYoff = [0,-5]                  ;value
sSmallWDBvalue = { size: [sMinWDBvalue.size[0]+XYoff[0],$
                          sSmallWDBlabel.size[1]+XYoff[1],$
                          80],$
                   value: '1.0E-14',$
                   uname: 'small_wave_dependent_back'}

;Amorphous Reduction Verbosity cw_bgroup
XYoff = [0,30]
sARVgroup = { size: [sDBTlabel.size[0]+XYoff[0],$
                     sSmallWDBlabel.size[1]+XYoff[1]],$
              value: ['Amorphous Reduction Verbosity'],$
              uname: 'amorphous_reduction_verbosity_cw_bgroup'}

;******************************************************************************
;                                Build GUI
;******************************************************************************
main_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[7])

;Use or not Iterative Background Subtraction ----------------------------------
cwbgroup = CW_BGROUP(main_base,$
                     sIBScwBgroup.value,$
                     XOFFSET   = sIBScwBgroup.size[0],$
                     YOFFSET   = sIBScwBgroup.size[1],$
                     SET_VALUE = sIBScwBgroup.set_value,$
                     UNAME     = sIBScwBgroup.uname,$
                     /EXCLUSIVE,$
                     /NO_RELEASE,$
                     /ROW)

label = WIDGET_LABEL(main_base,$
                     XOFFSET = sIBSlabel.size[0],$
                     YOFFSET = sIBSlabel.size[1],$
                     VALUE   = sIBSlabel.value)

;base that will hold all the widgets ------------------------------------------
base = WIDGET_BASE(main_base,$
                   XOFFSET   = sBase.size[0],$
                   YOFFSET   = sBase.size[1],$
                   SCR_XSIZE = sBase.size[2],$
                   SCR_YSIZE = sBase.size[3],$
                   UNAME     = sBase.uname,$
                   SENSITIVE = sBase.sensitive,$
                   FRAME     = sBase.frame)

;______________________________________________________________________________
;Scale constant for lambda dependent background -------------------------------

;scale constant for lambda dependent background label and value
wScaleConstant = WIDGET_LABEL(base,$
                              XOFFSET   = sScaleConstant.size[0],$
                              YOFFSET   = sScaleConstant.size[1],$ 
                              UNAME     = sScaleConstant.uname,$
                              VALUE     = sScaleConstant.value)

wScaleConstantInput = WIDGET_TEXT(base,$
                                  XOFFSET   = sScaleConstantInput.size[0],$
                                  YOFFSET   = sScaleConstantInput.size[1],$
                                  SCR_XSIZE = sScaleConstantInput.size[2],$
                                  UNAME     = sScaleConstantInput.uname,$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

;Input Base1
wInputBase = WIDGET_BASE(base,$
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

wSCframe = WIDGET_LABEL(base,$
                        XOFFSET   = sSCframe.size[0],$
                        YOFFSET   = sSCframe.size[1],$
                        SCR_XSIZE = sSCframe.size[2],$
                        SCR_YSIZE = sSCframe.size[3],$
                        FRAME     = sSCframe.frame,$
                        VALUE     = '')

;base that will hold all the second part of widgets ---------------------------
base2 = WIDGET_BASE(main_base,$
                    XOFFSET   = sBase2.size[0],$
                    YOFFSET   = sBase2.size[1],$
                    SCR_XSIZE = sBase2.size[2],$
                    SCR_YSIZE = sBase2.size[3],$
                    UNAME     = sBase2.uname,$
                    SENSITIVE = sBase2.sensitive,$
                    FRAME     = sBase2.frame)

;______________________________________________________________________________
;Positive transverse energy integration range ---------------------------------
;title
wPTEtitle = WIDGET_LABEL(base2,$
                         XOFFSET = sPTEtitle.size[0],$
                         YOFFSET = sPTEtitle.size[1],$
                         VALUE   = sPTEtitle.value)

;base
wPTEbase = WIDGET_BASE(base2,$
                       XOFFSET   = sPTEbase.size[0],$
                       YOFFSET   = sPTEbase.size[1],$
                       SCR_XSIZE = sPTEbase.size[2],$
                       SCR_YSIZE = sPTEbase.size[3],$
                       frame = 1)

;min                
label = WIDGET_LABEL(wPTEbase,$
                     XOFFSET   = sPTEminLabel.size[0],$
                     YOFFSET   = sPTEminLabel.size[1],$
                     VALUE     = sPTEminLabel.value,$
                     UNAME     = sPTEminLabel.uname)

text = WIDGET_TEXT(wPTEbase,$
                   XOFFSET   = sPTEminText.size[0],$
                   YOFFSET   = sPTEminText.size[1],$
                   SCR_XSIZE = sPTEminText.size[2],$
                   SCR_YSIZE = sPTEminText.size[3],$
                   UNAME     = sPTEminText.uname,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

;max
label = WIDGET_LABEL(wPTEbase,$
                     XOFFSET   = sPTEmaxLabel.size[0],$
                     YOFFSET   = sPTEmaxLabel.size[1],$
                     VALUE     = sPTEmaxLabel.value,$
                     UNAME     = sPTEmaxLabel.uname)

text = WIDGET_TEXT(wPTEbase,$
                   XOFFSET   = sPTEmaxText.size[0],$
                   YOFFSET   = sPTEmaxText.size[1],$
                   SCR_XSIZE = sPTEmaxText.size[2],$
                   SCR_YSIZE = sPTEmaxText.size[3],$
                   UNAME     = sPTEmaxText.uname,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

;width
label = WIDGET_LABEL(wPTEbase,$
                     XOFFSET   = sPTEbinLabel.size[0],$
                     YOFFSET   = sPTEbinLabel.size[1],$
                     VALUE     = sPTEbinLabel.value,$
                     UNAME     = sPTEbinLabel.uname)
                   
text = WIDGET_TEXT(wPTEbase,$
                   XOFFSET   = sPTEbinText.size[0],$
                   YOFFSET   = sPTEbinText.size[1],$
                   SCR_XSIZE = sPTEbinText.size[2],$
                   SCR_YSIZE = sPTEbinText.size[3],$
                   UNAME     = sPTEbinText.uname,$
                   /EDITABLE,$
                   /ALL_EVENTS,$
                   /ALIGN_LEFT)

;type (linear)
label = WIDGET_LABEL(wPTEbase,$
                     XOFFSET = sPTEtypeLabel.size[0],$
                     YOFFSET = sPTEtypeLabel.size[1],$
                     VALUE   = sPTEtypeLabel.value)

;______________________________________________________________________________
;other flags ------------------------------------------------------------------
;title
wOthertitle = WIDGET_LABEL(base2,$
                         XOFFSET = sOthertitle.size[0],$
                         YOFFSET = sOthertitle.size[1],$
                         VALUE   = sOthertitle.value)

;base
wOtherbase = WIDGET_BASE(base2,$
                       XOFFSET   = sOtherbase.size[0],$
                       YOFFSET   = sOtherbase.size[1],$
                       SCR_XSIZE = sOtherbase.size[2],$
                       SCR_YSIZE = sOtherbase.size[3],$
                       frame = 1)

;Detailed balance temperature
value = WIDGET_TEXT(wOtherBase,$
                    XOFFSET   = sDBTvalue.size[0],$
                    YOFFSET   = sDBTvalue.size[1],$
                    SCR_XSIZE = sDBTvalue.size[2],$
                    UNAME     = sDBTvalue.uname,$
                    VALUE     = sDBTvalue.value,$
                    /EDITABLE,$
                    /ALIGN_LEFT,$
                    /ALL_EVENTS)
label = WIDGET_LABEL(wOtherBase,$
                     XOFFSET = sDBTlabel.size[0],$
                     YOFFSET = sDBTlabel.size[1],$
                     VALUE   = sDBTlabel.value)
                     
;Radio Tolerance
value = WIDGET_TEXT(wOtherBase,$
                    XOFFSET   = sRTvalue.size[0],$
                    YOFFSET   = sRTvalue.size[1],$
                    SCR_XSIZE = sRTvalue.size[2],$
                    UNAME     = sRTvalue.uname,$
                    VALUE     = sRTvalue.value,$
                    /EDITABLE,$
                    /ALIGN_LEFT,$
                    /ALL_EVENTS)
label = WIDGET_LABEL(wOtherBase,$
                     XOFFSET = sRTlabel.size[0],$
                     YOFFSET = sRTlabel.size[1],$
                     VALUE   = sRTlabel.value)

;Number of iteration
value = WIDGET_TEXT(wOtherBase,$
                    XOFFSET   = sNIvalue.size[0],$
                    YOFFSET   = sNIvalue.size[1],$
                    SCR_XSIZE = sNIvalue.size[2],$
                    UNAME     = sNIvalue.uname,$
                    VALUE     = sNIvalue.value,$
                    /EDITABLE,$
                    /ALIGN_LEFT,$
                    /ALL_EVENTS)
label = WIDGET_LABEL(wOtherBase,$
                     XOFFSET = sNIlabel.size[0],$
                     YOFFSET = sNIlabel.size[1],$
                     VALUE   = sNIlabel.value)
                     
;minimum wavelength dependent background cst
value = WIDGET_TEXT(wOtherBase,$
                    XOFFSET   = sMinWDBvalue.size[0],$
                    YOFFSET   = sMinWDBvalue.size[1],$
                    SCR_XSIZE = sMinWDBvalue.size[2],$
                    UNAME     = sMinWDBvalue.uname,$
                    VALUE     = sMinWDBvalue.value,$
                    /EDITABLE,$
                    /ALIGN_LEFT,$
                    /ALL_EVENTS)
label = WIDGET_LABEL(wOtherBase,$
                     XOFFSET = sMinWDBlabel.size[0],$
                     YOFFSET = sMinWDBlabel.size[1],$
                     VALUE   = sMinWDBlabel.value)
                     
;maximum wavelength dependent background cst
value = WIDGET_TEXT(wOtherBase,$
                    XOFFSET   = sMaxWDBvalue.size[0],$
                    YOFFSET   = sMaxWDBvalue.size[1],$
                    SCR_XSIZE = sMaxWDBvalue.size[2],$
                    UNAME     = sMaxWDBvalue.uname,$
                    VALUE     = sMaxWDBvalue.value,$
                    /EDITABLE,$
                    /ALIGN_LEFT,$
                    /ALL_EVENTS)
label = WIDGET_LABEL(wOtherBase,$
                     XOFFSET = sMaxWDBlabel.size[0],$
                     YOFFSET = sMaxWDBlabel.size[1],$
                     VALUE   = sMaxWDBlabel.value)
                     
;small wavelength dependent background cst
value = WIDGET_TEXT(wOtherBase,$
                    XOFFSET   = sSmallWDBvalue.size[0],$
                    YOFFSET   = sSmallWDBvalue.size[1],$
                    SCR_XSIZE = sSmallWDBvalue.size[2],$
                    UNAME     = sSmallWDBvalue.uname,$
                    VALUE     = sSmallWDBvalue.value,$
                    /EDITABLE,$
                    /ALIGN_LEFT,$
                    /ALL_EVENTS)
label = WIDGET_LABEL(wOtherBase,$
                     XOFFSET = sSmallWDBlabel.size[0],$
                     YOFFSET = sSmallWDBlabel.size[1],$
                     VALUE   = sSmallWDBlabel.value)
                     
;Amorphous Reduction Verbosity cw_bgroup
group = CW_BGROUP(wOtherBase,$
                  sARVgroup.value,$
                  XOFFSET = sARVgroup.size[0],$
                  YOFFSET = sARVgroup.size[1],$
                  UNAME   = sARVgroup.uname,$
                  /NONEXCLUSIVE)


END
