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
;This function retrieves the values from the various Reduce Tab
FUNCTION populateReduceStructure, Event

;---- tab1 ------------------------------------------------------------------
tab1Data = getTextFieldValue(Event,'rsdf_list_of_runs_text')
tab1Back = getTextFieldValue(Event,'bdf_list_of_runs_text')
tab1Norm = getTextFieldValue(Event,'ndf_list_of_runs_text')
tab1Empt = getTextFieldValue(Event,'ecdf_list_of_runs_text')
tab1Dire = getTextFieldValue(Event,'dsb_list_of_runs_text')

;---- tab2 ------------------------------------------------------------------
tab2Roi  = getTextFieldValue(Event,'proif_text')
tab2Alte = getTextFieldValue(Event,'aig_list_of_runs_text')
tab2path = getButtonValue(Event,'output_folder_name')
tab2name = getTextFieldValue(Event,'of_list_of_runs_text')

;---- tab3 ------------------------------------------------------------------
IF (getButtonValue(Event,'rmcnf_button')) THEN BEGIN
    tab3RunMc = 'ON'
ENDIF ELSE BEGIN
    tab3RunMc = 'OFF'
ENDELSE

IF (getButtonValue(Event,'verbose_button')) THEN BEGIN
    tab3Verbo = 'ON'
ENDIF ELSE BEGIN
    tab3Verbo = 'OFF'
ENDELSE

IF (getButtonValue(Event,'absm_button')) THEN BEGIN
    tab3AltBa = 'ON'
ENDIF ELSE BEGIN
    tab3AltBa = 'OFF'
ENDELSE

IF (getButtonValue(Event,'nmn_button')) THEN BEGIN
    tab3NoMor = 'ON'
ENDIF ELSE BEGIN
    tab3NoMor = 'OFF'
ENDELSE

IF (getButtonValue(Event,'nmec_button')) THEN BEGIN
    tab3NoMoE = 'ON'
ENDIF ELSE BEGIN
    tab3NoMoE = 'OFF'
ENDELSE

IF (getButtonValue(Event,'niw_button')) THEN BEGIN
    tab3NiwB = 'ON'
    tab3NiwS = getTextFieldValue(Event,'nisw_field')
    tab3NiwE = getTextFieldValue(Event,'niew_field')
ENDIF ELSE BEGIN
    tab3NiwB = 'OFF'
    tab3NiwS = 'N/A'
    tab3NiwE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'te_button')) THEN BEGIN
    tab3TeB = 'ON'
    tab3TeL = getTextFieldValue(Event,'te_low_field')
    tab3TeH = getTextFieldValue(Event,'te_high_field')
ENDIF ELSE BEGIN
    tab3TeB = 'OFF'
    tab3TeL = 'N/A'
    tab3TeH = 'N/A'
ENDELSE

;---- tab4 ------------------------------------------------------------------
IF (getButtonValue(Event,'tib_tof_button')) THEN BEGIN
    tab4Tof  = 'ON'
    tab4Tof1 = getTextFieldValue(Event,'tibtof_channel1_text')
    tab4Tof2 = getTextFieldValue(Event,'tibtof_channel2_text')
    tab4Tof3 = getTextFieldValue(Event,'tibtof_channel3_text')
    tab4Tof4 = getTextFieldValue(Event,'tibtof_channel4_text')
ENDIF ELSE BEGIN
    tab4Tof  = 'OFF'
    tab4Tof1 = 'N/A'
    tab4Tof2 = 'N/A'
    tab4Tof3 = 'N/A'
    tab4Tof4 = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_sd_button')) THEN BEGIN
    tab4TsdB = 'ON'
    tab4TsdV = getTextFieldValue(Event,'tibc_for_sd_value_text')
    tab4TsdE = getTextFieldValue(Event,'tibc_for_sd_error_text')
ENDIF ELSE BEGIN
    tab4TsdB = 'OFF'
    tab4TsdV = 'N/A'
    tab4TsdE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_bd_button')) THEN BEGIN
    tab4TbdB = 'ON'
    tab4TbdV = getTextFieldValue(Event,'tibc_for_bd_value_text')
    tab4TbdE = getTextFieldValue(Event,'tibc_for_bd_error_text')
ENDIF ELSE BEGIN
    tab4TbdB = 'OFF'
    tab4TbdV = 'N/A'
    tab4TbdE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_nd_button')) THEN BEGIN
    tab4TndB = 'ON'
    tab4TndV = getTextFieldValue(Event,'tibc_for_nd_value_text')
    tab4TndE = getTextFieldValue(Event,'tibc_for_nd_error_text')
ENDIF ELSE BEGIN
    tab4TndB = 'OFF'
    tab4TndV = 'N/A'
    tab4TndE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_ecd_button')) THEN BEGIN
    tab4TecdB = 'ON'
    tab4TecdV = getTextFieldValue(Event,'tibc_for_ecd_value_text')
    tab4TecdE = getTextFieldValue(Event,'tibc_for_ecd_error_text')
ENDIF ELSE BEGIN
    tab4TecdB = 'OFF'
    tab4TecdV = 'N/A'
    tab4TecdE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_scatd_button')) THEN BEGIN
    tab4TscatB = 'ON'
    tab4TscatV = getTextFieldValue(Event,'tibc_for_scatd_value_text')
    tab4TscatE = getTextFieldValue(Event,'tibc_for_scatd_error_text')
ENDIF ELSE BEGIN
    tab4TscatB = 'OFF'
    tab4TscatV = 'N/A'
    tab4TscatE = 'N/A'
ENDELSE

;---- tab5 ------------------------------------------------------------------
IF (getButtonValue(Event, $
                   'use_iterative_background_subtraction_cw_bgroup')) $
  THEN BEGIN

    tab5ibB = 'ON'
    tab5scl = 'N/A'
    tab5cf  = getTextFiledValue(Event, $
                                'chopper_frequency_value')
    tab5cwc = getTextFieldValue(Event, $
                                'chopper_wavelength_value')
    tab5tof = getTextFieldValue(Event, $
                                'tof_least_background_value')
    tab5PSmin  = getTextFieldValue(Event,'pte_min_text')
    tab5PSmax  = getTextFieldValue(Event,'pte_max_text')
    tab5PSbin  = getTextFieldValue(Event,'pte_bin_text')
    tab5Dbt    = getTextFieldValue(Event,'detailed_balance_temperature_value')
    tab5Rt     = getTextFieldValue(Event,'ratio_tolerance_value')
    tab5Ni     = getTextFieldValue(Event,'number_of_iteration')
    tab5MinWbc = getTextFieldValue(Event,'min_wave_dependent_back')
    tab5MaxWbc = getTextFieldValue(Event,'max_wave_dependent_back')
    tab5SmaWbc = getTextFieldValue(Event,'small_wave_dependent_back')

    IF (getButtonValue(Event, $
                       'amorphous_reduction_verbosity_cw_bgroup')) THEN BEGIN
        tab5Verbo = 'ON'
    ENDIF ELSE BEGIN
        tab5Verbo = 'OFF'
    ENDELSE

ENDIF ELSE BEGIN

    tab5ibB = 'OFF'
    tab5scl = getTextFieldValue(Event, $
                                'scale_constant_lambda_dependent_back_uname')
    IF (tab5scl NE '') THEN BEGIN
        tab5cf  = getTextFiledValue(Event, $
                                   'chopper_frequency_value')
        tab5cwc = getTextFieldValue(Event, $
                                    'chopper_wavelength_value')
        tab5tof = getTextFieldValue(Event, $
                                    'tof_least_background_value')
    ENDIF ELSE BEGIN
        tab5cf  = 'N/A'
        tab5cwc = 'N/A'
        tab5tof = 'N/A'
    ENDELSE

    tab5PSmin  = 'N/A'
    tab5PSmax  = 'N/A'
    tab5PSbin  = 'N/A'
    tab5Dbt    = 'N/A'
    tab5Rt     = 'N/A'
    tab5Ni     = 'N/A'
    tab5MinWbc = 'N/A'
    tab5MaxWbc = 'N/A'
    tab5SmaWbc = 'N/A'
    tab5Verbo  = 'N/A'

ENDELSE

;---- tab6 ------------------------------------------------------------------
IF (getButtonValue(Event, $
                   'csbss_button')) $
  THEN BEGIN
    tab6CsbssB = 'ON'
    tab6CsbssV = getTextFieldValue(Event,'csbss_value_text')
    tab6CsbssE = getTextFieldValue(Event,'csbss_error_text')
ENDIF ELSE BEGIN
    tab6CsbssB = 'OFF'
    tab6CsbssV = 'N/A'
    tab6CsbssE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'csn_button')) $
  THEN BEGIN
    tab6CsnB = 'ON'
    tab6CsnV = getTextFieldValue(Event,'csn_value_text')
    tab6CsnE = getTextFieldValue(Event,'csn_error_text')
ENDIF ELSE BEGIN
    tab6CsnB = 'OFF'
    tab6CsnV = 'N/A'
    tab6CsnE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'bcs_button')) $
  THEN BEGIN
    tab6BcsB = 'ON'
    tab6BcsV = getTextFieldValue(Event,'bcs_value_text')
    tab6BcsE = getTextFieldValue(Event,'bcs_error_text')
ENDIF ELSE BEGIN
    tab6BcsB = 'OFF'
    tab6BcsV = 'N/A'
    tab6BcsE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'bcn_button')) $
  THEN BEGIN
    tab6BcnB = 'ON'
    tab6BcnV = getTextFieldValue(Event,'bcn_value_text')
    tab6BcnE = getTextFieldValue(Event,'bcn_error_text')
ENDIF ELSE BEGIN
    tab6BcnB = 'OFF'
    tab6BcnV = 'N/A'
    tab6BcnE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'cs_button')) $
  THEN BEGIN
    tab6CsB = 'ON'
    tab6CsV = getTextFieldValue(Event,'cs_value_text')
    tab6CsE = getTextFieldValue(Event,'cs_error_text')
ENDIF ELSE BEGIN
    tab6CsB = 'OFF'
    tab6CsV = 'N/A'
    tab6CsE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'cn_button')) $
  THEN BEGIN
    tab6CnB = 'ON'
    tab6CnV = getTextFieldValue(Event,'cn_value_text')
    tab6CnE = getTextFieldValue(Event,'cn_error_text')
ENDIF ELSE BEGIN
    tab6CnB = 'OFF'
    tab6CnV = 'N/A'
    tab6CnE = 'N/A'
ENDELSE

;---- tab7 ------------------------------------------------------------------
IF (getButtonValue(Event,'csfds_button')) THEN BEGIN
    tab7CsfdsB = 'ON'
    tab7CsfdsV = getTextFieldValue(Event,'csfds_value_text')
ENDIF ELSE BEGIN
    tab7CsfdsB = 'OFF'
    tab7CsfdsV = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tzsp_button')) $
  THEN BEGIN
    tab7tzspB = 'ON'
    tab7tzspV = getTextFieldValue(Event,'tzsp_value_text')
    tab7tzspE = getTextFieldValue(Event,'tzsp_error_text')
ENDIF ELSE BEGIN
    tab7tzspB = 'OFF'
    tab7tzspV = 'N/A'
    tab7tzspE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tzop_button')) $
  THEN BEGIN
    tab7tzopB = 'ON'
    tab7tzopV = getTextFieldValue(Event,'tzop_value_text')
    tab7tzopE = getTextFieldValue(Event,'tzop_error_text')
ENDIF ELSE BEGIN
    tab7tzopB = 'OFF'
    tab7tzopV = 'N/A'
    tab7tzopE = 'N/A'
ENDELSE

tab7Emin = getTextFieldValue(Event,'eha_min_text')
tab7Emax = getTextFieldValue(Event,'eha_max_text')
tab7Ebin = getTextFieldValue(Event,'eha_bin_text')

IF (getButtonValue(Event,'mtha_button')) THEN BEGIN
    tab7mthaB1 = 'ON'
    tab7mthaB2 = 'OFF'
    tab7mthaB1min = getTextFieldValue(Event,'mtha_min_text')
    tab7mthaB1max = getTextFieldValue(Event,'mtha_max_text')
    tab7mthaB1bin = getTextFieldValue(Event,'mtha_bin_text')
    tab7mthaB2min = 'N/A'
    tab7mthaB2max = 'N/A'
    tab7mthaB2bin = 'N/A'
ENDIF ELSE BEGIN
    tab7mthaB1 = 'OFF'
    tab7mthaB2 = 'ON'
    tab7mthaB1min = 'N/A'
    tab7mthaB1max = 'N/A'
    tab7mthaB1bin = 'N/A'
    tab7mthaB2min = getTextFieldValue(Event,'mtha_min_text')
    tab7mthaB2max = getTextFieldValue(Event,'mtha_max_text')
    tab7mthaB2bin = getTextFieldValue(Event,'mtha_bin_text')
ENDELSE

IF (getButtonValue(Event,'gifw_button')) $
  THEN BEGIN
    tab7gifwB = 'ON'
    tab7gifwV = getTextFieldValue(Event,'gifw_value_text')
    tab7gifwE = getTextFieldValue(Event,'gifw_error_text')
ENDIF ELSE BEGIN
    tab7gifwB = 'OFF'
    tab7gifwV = 'N/A'
    tab7gifwE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tof_cutting_button')) $
  THEN BEGIN
    tab7tofCB = 'ON'
    tab7tofCMin = getTextFieldValue(Event,'tof_cutting_min_text')
    tab7tofCMax = getTextFieldValue(Event,'tof_cutting_max_text')
ENDIF ELSE BEGIN
    tab7tofCB = 'OFF'
    tab7tofCMin = 'N/A'
    tab7tofCMax = 'N/A'
ENDELSE

;---- tab8 ------------------------------------------------------------------
;check if use iterative background subtraction is active or not
ibs_value = getCWBgroupValue(Event, $
                         'use_iterative_background_subtraction_cw_bgroup')

IF (ibs_value EQ 1) THEN BEGIN ;if Iterative Background Subtraction is OFF
    IF (isButtonSelected(Event,'waio_button')) THEN BEGIN
        tab8Waio = 'ON'
    ENDIF ELSE BEGIN
        tab8Waio = 'OFF'
    ENDELSE

    IF (isButtonSelected(Event,'woctib_button') AND $
        isButtonSelected(Event,'tib_tof_button')) THEN BEGIN
        tab8woctib = 'ON'
    ENDIF ELSE BEGIN
        tab8woctib = 'OFF'
    ENDELSE

    IF (isButtonSelected(Event,'wopws_button')) THEN BEGIN
        tab8wopws = 'ON'
    ENDIF ELSE BEGIN
        tab8wopws = 'OFF'
    ENDELSE

    IF (isButtonSelected(Event,'womws_button') AND $
        isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
        tab8womws = 'ON'
    ENDIF ELSE BEGIN
        tab8womws = 'OFF'
    ENDELSE
    
    IF (isButtonSelected(Event,'womes_button') AND $
        isButtonUnselected(Event,'nmn_button') AND $
        isButtonUnselected(Event,'nmec_button')) THEN BEGIN
        tab8womes = 'ON'
    ENDIF ELSE BEGIN
        tab8womes = 'OFF'
    ENDELSE

    IF (isButtonSelected(Event,'worms_button') AND $
        isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
        tab8worms = 'ON'
    ENDIF ELSE BEGIN
        tab8worms = 'OFF'
    ENDELSE

    IF (isButtonSelected(Event,'wocpsamn_button') AND $
        isButtonUnSelected(Event,'nmn_button'))  THEN BEGIN
        tab8wocpsamn = 'ON'
        tab8waMin    = getTextFieldValue(Event,'wa_min_text')
        tab8waMax    = getTextFieldValue(Event,'wa_max_text')
        tab8waBin    = getTextFieldValue(Event,'wa_bin_text')
    ENDIF ELSE BEGIN
        tab8wocpsamn = 'OFF'
        tab8waMin    = 'N/A'
        tab8waMax    = 'N/A'
        tab8waBin    = 'N/A'
    ENDELSE

    IF (isButtonSelected(Event,'wolidsb_button')) THEN BEGIN
        tab8wolidsb = 'ON'
    ENDIF ELSE BEGIN
        tab8wolidsb = 'OFF'
    ENDELSE

    IF (isButtonSelected(Event,'pwsavn_button')) THEN BEGIN
        tab8pwsavn = 'ON'
    ENDIF ELSE BEGIN
        tab8pwsavn = 'OFF'
    ENDELSE

ENDIF ELSE BEGIN

    tab8Waio     = 'OFF'
    tab8woctib   = 'OFF'
    tab8wopws    = 'OFF'
    tab8womws    = 'OFF'
    tab8womes    = 'OFF'
    tab8worms    = 'OFF'
    tab8wocpsamn = 'OFF'
    tab8waMin    = 'N/A'
    tab8waMax    = 'N/A'
    tab8waBin    = 'N/A'
    tab8wolidsb  = 'OFF'
    tab8pwsavn   = 'OFF'
    
ENDELSE

;write value in structure
sStructure = { field1: { title: 'Raw Sample Data File',$
                         value: tab1Data},$
               field2: { title: 'Background Data File',$
                         value: tab1Back},$
               field3: { title: 'Normalization Data file',$
                         value: tab1Norm},$
               field4: { title: 'Empty Can Data File',$
                         value: tab1Empt},$
               field5: { title: 'Direct Scattering Background (Sample Data' + $
                         ' at Baseline T) File',$
                         value: tab1Dire},$
               field6: { title: 'Pixel Region of Interest File',$
                         value: tab2Roi},$
               field7: { title: 'Alternate Instrument Geometry',$
                         value: tab2Alte},$
               field8: { title: 'Output Path',$
                         value: tab2path},$
               field9: { title: 'Output File Name',$
                         value: tab2name},$
               field10: { title: 'Run McStas NeXus Files',$
                          value: tab3RunMc},$
               field11: { title: 'Verbose',$
                          value: tab3Verbo},$
               field12: { title: 'Alternate Background Subtraction Method',$
                          value: tab3AltBa},$
               field13: { title: 'No Monitor Normalization',$
                          value: tab3NoMor},$
               field14: { title: 'No Monitor Efficiency',$
                          value: tab3NoMoE},$
               field15: { title: 'Normalization Integration Start and ' + $
                          'End Wavelength',$
                          value: tab3NiwB},$
               field16: { title: '-> Start',$
                          value: tab3NiwS},$
               field17: { title: '-> End',$
                          value: tab3NiwE},$
               field18: { title: 'Low and High Time-of-Flight Values that' + $
                          ' Bracket the Elastic Peak (microSeconds)',$
                          value: tab3TeB},$
               field19: { title: '-> Low',$
                          value: tab3TeL},$
               field20: { title: '-> High',$
                          value: tab3TeH},$
               field21: { title: 'Time-Independent Background Time-of' + $
                          'Flight Channels (microSeconds)',$
                          value: tab4Tof},$
               field22: { title: '-> #1',$
                          value: tab4Tof1},$
               field23: { title: '-> #2',$
                          value: tab4Tof2},$
               field24: { title: '-> #3',$
                          value: tab4Tof3},$
               field25: { title: '-> #4',$
                          value: tab4Tof4},$
               field26: { title: 'Time-Independent Background Constant' + $
                          ' for Sample Data',$
                          value: tab4TsdB},$
               field27: { title: '-> Value',$
                          value: tab4TsdV},$
               field28: { title: '-> Error',$
                          value: tab4TsdE},$
               field29: { title: 'Time-Independent Background Constant' + $
                          ' for Background Data',$
                          value: tab4TbdB},$
               field30: { title: '-> Value',$
                          value: tab4TbdV},$
               field31: { title: '-> Error',$
                          value: tab4TbdE},$
               field32: { title: 'Time-Independent Background Constant' + $
                          ' for Normalization Data',$
                          value: tab4TndB},$
               field33: { title: '-> Value',$
                          value: tab4TndV},$
               field34: { title: '-> Error',$
                          value: tab4TndE},$
               field35: { title: 'Time-Independent Background Constant' + $
                          ' for Empty Can Data',$
                          value: tab4TecdB},$
               field36: { title: '-> Value',$
                          value: tab4TecdV},$
               field37: { title: '-> Error',$
                          value: tab4TecdE},$
               field38: { title: 'Time-Independent Background Constant' + $
                          ' for Scattering Data',$
                          value: tab4TscatB},$
               field39: { title: '-> Value',$
                          value: tab4TscatV},$
               field40: { title: '-> Error',$
                          value: tab4TscatE},$
               field41: { title: 'Use Iterative Background Subtraction',$
                          value: tab5ibB},$
               field42: { title: 'Scale Constant for Lambda Depedent' + $
                          ' Background',$
                          value: tab5scl},$
               field43: { title: 'Chopper Frequency (Hz)',$
                          value: tab5cf},$
               field44: { title: 'Chopper Wavelength Center (Angstroms)',$
                          value: tab5cwc},$
               field45: { title: 'TOF Least Background (microS)',$
                          value: tab5tof},$
               field50: { title: 'Min Positive Transverse Energy Integration',$
                          value: tab5PSmin},$
               field51: { title: 'Max Positive Transverse Energy Integration',$
                          value: tab5PSmax},$
               field52: { title: 'Positive Transverse Energy Integration' + $
                          ' Width',$
                          value: tab5PSbin},$
               field53: { title: 'Detailed Balance Temperature (K)',$
                          value: tab5Dbt},$
               field54: { title: 'Ratio Tolerance',$
                          value: tab5Rt},$
               field55: { title: 'Number of Iteration',$
                          value: tab5Ni},$
               field56: { title: 'Minimum Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: tab5MinWbc},$
               field57: { title: 'Maximum Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: tab5MaxWbc},$
               field58: { title: 'Small Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: tab5SmaWbc},$
               field59: { title: 'Amorphous Reduction Verbosity',$
                          value: tab5Verbo},$
               field60: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Sample Data Spectra',$
                          value: tab6CsbssB},$
               field61: { title: '-> Value:',$
                          value: tab6CsbssV},$
               field62: { title: '-> Error',$
                          value: tab6CsbssE},$
               field63: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Normalization Data' + $
                          ' Spectra',$
                          value: tab6CsnB},$
               field64: { title: '-> Value',$
                          value: tab6CsnV},$
               field65: { title: '-> Error',$
                          value: tab6CsnE},$
               field66: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Sample Data' + $
                          ' Associatied Empty Container Spectra',$
                          value: tab6BcsB},$
               field67: { title: '-> Value',$
                          value: tab6BcsV},$
               field68: { title: '-> Error',$
                          value: tab6BcsE},$
               field79: { title: 'Constant to Scale the Back. Spectra' + $
                          ' for Subtraction from the Normalizaiton Data' + $
                          ' Associated Empty Container Spectra',$
                          value: tab6BcnB},$
               field80: { title: '-> Value',$
                          value: tab6BcnV},$
               field81: { title: '-> Error',$
                          value: tab6BcnE},$
               field82: { title: 'Constant to Scale the Empty Container' + $
                          ' Spectra for Subtraction from the Sample Data',$
                          value: tab6CsB},$
               field83: { title: '-> Value',$
                          value: tab6CsV},$
               field84: { title: '-> Error',$
                          value: tab6CsE},$
               field85: { title: 'Constant to Scale the Empty Container' + $
                          ' Spectra for Subtraction from the Normalization' + $
                          ' Data',$
                          value: tab6CnB},$
               field86: { title: '-> Value',$
                          value: tab6CnV},$
               field87: { title: '-> Error',$
                          value: tab6CnE},$
               field88: { title: 'Constant for Scaling the Final Data' + $
                          ' Spectrum',$
                          value: tab7CsfdsB},$
               field89: { title: '-> Value',$
                          value: tab7CsfdsV},$
               field90: { title: 'Time Zero Slope Parameter (Angstroms' + $
                          '/microSeconds)',$
                          value: tab7tzspB},$
               field91: { title: '-> Value',$
                          value: tab7tzspV},$
               field92: { title: '-> Error',$
                          value: tab7tzspE},$
               field93: { title: 'Time Zero Offset Parameters (Angstroms)',$
                          value: tab7tzopB},$
               field94: { title: '-> Value',$
                          value: tab7tzopV},$
               field95: { title: '-> Error',$
                          value: tab7tzopE},$
               field96: { title: 'Minimum Energy Histogram Axis (micro-eV)',$
                          value: tab7Emin},$
               field97: { title: 'Maximum Energy Histogram Axis (micro-eV)',$
                          value: tab7Emax},$
               field98: { title: 'Energy Histogram Axis Width (micro-eV)',$
                          value: tab7Ebin},$
               field99: { title: 'Momentum Transfer Histogram Axis' + $
                          ' (1/Angstroms)',$
                          value: tab7mthaB1},$
               field100: { title: '-> Min',$
                           value: tab7mthaB1min},$
               field101: { title: '-> Max',$
                           value: tab7mthaB1max},$
               field102: { title: '-> Width',$
                           value: tab7mthaB1bin},$
               field103: { title: 'Negative Cosine Polar Axis',$
                           value: tab7mthaB2},$
               field104: { title: '-> Min',$
                           value: tab7mthaB2min},$
               field105: { title: '-> Max',$
                           value: tab7mthaB2max},$
               field106: { title: '-> Width',$
                           value: tab7mthaB2bin},$
               field107: { title: 'Global Instrument Final Wavelength' + $
                           ' (Angstroms)',$
                           value: tab7gifwB},$
               field108: { title: '-> Value',$
                           value: tab7gifwV},$
               field109: { title: '-> Error',$
                           value: tab7gifwE},$
               field110: { title: 'Time of Flight Range (microseconds)',$
                           value: tab7tofCB},$
               field111: { title: '-> Min',$
                           value: tab7tofCMin},$
               field112: { title: '-> Max',$
                           value: tab7tofCMax},$
               field113: { title: 'Write all Intermediate Output',$
                           value: tab8Waio},$
               field114: { title: 'Write Out Time-Independent Background',$
                           value: tab8woctib},$
               fiedl115: { title: 'Write Out Pixel Wavelength Spectra',$
                           value: tab8wopws},$
               field116: { title: 'Write Out Monitor Wavelength Spectrum',$
                           value: tab8womws},$
               field117: { title: 'Write Out Monitor Efficiency Spectrum',$
                           value: tab8womes},$
               field118: { title: 'Write Out Rebinned Monitor Spectra',$
                           value: tab8worms},$
               field119: { title: 'Write Out Combined Pixel Spectrum After' + $
                           ' Monitor Normalization',$
                           value: tab8wocpsamn},$
               field120: { title: '-> Min',$
                           value: tab8waMin},$
               field121: { title: '-> Max',$
                           value: tab8waMax},$
               field122: { title: '-> Width',$
                           value: tab8WaBin},$
               field123: { title: 'Write Out Linearly Interpolated Direct' + $
                           ' Scattering Background Information Summed' + $
                           ' over all Pixels',$
                           value: tab8wolidsb},$
               field124: { title: 'Write Out Pixel Wavelength Spectra ' + $
                           ' after Vanadium Normalization',$
                           value: tab8pwsavn}}
               
RETURN, sStructure
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLcreateLogFile::init, Event, cmd

;retrieve value of fields from REDUCE tabs
sReduce = populateReduceStructure(Event)

;define current date
DateTime = GenerateIsoTimeStamp()





RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLcreateLogFile__define
struct = {IDLcreateLogFile,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
