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

FUNCTION ReplaceExt, file_array, NEW=new

;file_array = *file_array

sz = N_ELEMENTS(file_array)
IF (sz GT 0) THEN BEGIN
    new_file_array = STRARR(sz)
    index = 0
    WHILE (index LT sz) DO BEGIN
;get only the short file name
        short_fn_array = STRSPLIT(file_array[index],'/',/EXTRACT, COUNT=nbr)
        IF (nbr GE 1) THEN BEGIN
            file_array[index] = short_fn_array[nbr-1]
        ENDIF ELSE BEGIN
            file_array[index] = short_fn_array[0]
        ENDELSE
        no_error = 0
        CATCH, no_error
        IF (no_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            new_file_array[index] = file_array[index] + '.' + new
        ENDIF ELSE BEGIN
            local_file_array = STRSPLIT(file_array[index],'.',/EXTRACT)
            new_file_array[index] = local_file_array[0] + '.' + new
            index++
        ENDELSE
    ENDWHILE
ENDIF
RETURN, new_file_array
END

;------------------------------------------------------------------------------
;This function retrieves the values from the various Reduce Tab
FUNCTION populateReduceStructure, Event

;---- tab1 ------------------------------------------------------------------
tab1Data = getTextFieldValueForConfig(Event,'rsdf_list_of_runs_text')
tab1Back = getTextFieldValueForConfig(Event,'bdf_list_of_runs_text')
tab1Norm = getTextFieldValueForConfig(Event,'ndf_list_of_runs_text')
tab1Empt = getTextFieldValueForConfig(Event,'ecdf_list_of_runs_text')
tab1Dire = getTextFieldValueForConfig(Event,'dsb_list_of_runs_text')

;---- tab2 ------------------------------------------------------------------
tab2Roi  = getTextFieldValueForConfig(Event,'proif_text')
tab2Alte = getTextFieldValueForConfig(Event,'aig_list_of_runs_text')
tab2path = getButtonValue(Event,'output_folder_name')
tab2name = getTextFieldValueForConfig(Event,'of_list_of_runs_text')

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
    tab3NiwS = getTextFieldValueForConfig(Event,'nisw_field')
    tab3NiwE = getTextFieldValueForConfig(Event,'niew_field')
ENDIF ELSE BEGIN
    tab3NiwB = 'OFF'
    tab3NiwS = 'N/A'
    tab3NiwE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'te_button')) THEN BEGIN
    tab3TeB = 'ON'
    tab3TeL = getTextFieldValueForConfig(Event,'te_low_field')
    tab3TeH = getTextFieldValueForConfig(Event,'te_high_field')
ENDIF ELSE BEGIN
    tab3TeB = 'OFF'
    tab3TeL = 'N/A'
    tab3TeH = 'N/A'
ENDELSE

;---- tab4 ------------------------------------------------------------------
IF (getButtonValue(Event,'tib_tof_button')) THEN BEGIN
    tab4Tof  = 'ON'
    tab4Tof1 = getTextFieldValueForConfig(Event,'tibtof_channel1_text')
    tab4Tof2 = getTextFieldValueForConfig(Event,'tibtof_channel2_text')
    tab4Tof3 = getTextFieldValueForConfig(Event,'tibtof_channel3_text')
    tab4Tof4 = getTextFieldValueForConfig(Event,'tibtof_channel4_text')
ENDIF ELSE BEGIN
    tab4Tof  = 'OFF'
    tab4Tof1 = 'N/A'
    tab4Tof2 = 'N/A'
    tab4Tof3 = 'N/A'
    tab4Tof4 = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_sd_button')) THEN BEGIN
    tab4TsdB = 'ON'
    tab4TsdV = getTextFieldValueForConfig(Event,'tibc_for_sd_value_text')
    tab4TsdE = getTextFieldValueForConfig(Event,'tibc_for_sd_error_text')
ENDIF ELSE BEGIN
    tab4TsdB = 'OFF'
    tab4TsdV = 'N/A'
    tab4TsdE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_bd_button')) THEN BEGIN
    tab4TbdB = 'ON'
    tab4TbdV = getTextFieldValueForConfig(Event,'tibc_for_bd_value_text')
    tab4TbdE = getTextFieldValueForConfig(Event,'tibc_for_bd_error_text')
ENDIF ELSE BEGIN
    tab4TbdB = 'OFF'
    tab4TbdV = 'N/A'
    tab4TbdE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_nd_button')) THEN BEGIN
    tab4TndB = 'ON'
    tab4TndV = getTextFieldValueForConfig(Event,'tibc_for_nd_value_text')
    tab4TndE = getTextFieldValueForConfig(Event,'tibc_for_nd_error_text')
ENDIF ELSE BEGIN
    tab4TndB = 'OFF'
    tab4TndV = 'N/A'
    tab4TndE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_ecd_button')) THEN BEGIN
    tab4TecdB = 'ON'
    tab4TecdV = getTextFieldValueForConfig(Event,'tibc_for_ecd_value_text')
    tab4TecdE = getTextFieldValueForConfig(Event,'tibc_for_ecd_error_text')
ENDIF ELSE BEGIN
    tab4TecdB = 'OFF'
    tab4TecdV = 'N/A'
    tab4TecdE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tibc_for_scatd_button')) THEN BEGIN
    tab4TscatB = 'ON'
    tab4TscatV = getTextFieldValueForConfig(Event,'tibc_for_scatd_value_text')
    tab4TscatE = getTextFieldValueForConfig(Event,'tibc_for_scatd_error_text')
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
    tab5cwc = getTextFieldValueForConfig(Event, $
                                'chopper_wavelength_value')
    tab5tof = getTextFieldValueForConfig(Event, $
                                'tof_least_background_value')
    tab5PSmin  = getTextFieldValueForConfig(Event,'pte_min_text')
    tab5PSmax  = getTextFieldValueForConfig(Event,'pte_max_text')
    tab5PSbin  = getTextFieldValueForConfig(Event,'pte_bin_text')
    tab5Dbt    = $
      getTextFieldValueForConfig(Event, $
                                 'detailed_balance_temperature_value')
    tab5Rt     = getTextFieldValueForConfig(Event,'ratio_tolerance_value')
    tab5Ni     = getTextFieldValueForConfig(Event,'number_of_iteration')
    tab5MinWbc = getTextFieldValueForConfig(Event,'min_wave_dependent_back')
    tab5MaxWbc = getTextFieldValueForConfig(Event,'max_wave_dependent_back')
    tab5SmaWbc = getTextFieldValueForConfig(Event,'small_wave_dependent_back')

    IF (getButtonValue(Event, $
                       'amorphous_reduction_verbosity_cw_bgroup')) THEN BEGIN
        tab5Verbo = 'ON'
    ENDIF ELSE BEGIN
        tab5Verbo = 'OFF'
    ENDELSE

ENDIF ELSE BEGIN

    tab5ibB = 'OFF'
    tab5scl = getTextFieldValueForConfig(Event, $
                                'scale_constant_lambda_dependent_back_uname')
    IF (tab5scl NE '') THEN BEGIN
        tab5cf  = getTextFieldValueForConfig(Event, $
                                   'chopper_frequency_value')
        tab5cwc = getTextFieldValueForConfig(Event, $
                                    'chopper_wavelength_value')
        tab5tof = getTextFieldValueForConfig(Event, $
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
    tab6CsbssV = getTextFieldValueForConfig(Event,'csbss_value_text')
    tab6CsbssE = getTextFieldValueForConfig(Event,'csbss_error_text')
ENDIF ELSE BEGIN
    tab6CsbssB = 'OFF'
    tab6CsbssV = 'N/A'
    tab6CsbssE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'csn_button')) $
  THEN BEGIN
    tab6CsnB = 'ON'
    tab6CsnV = getTextFieldValueForConfig(Event,'csn_value_text')
    tab6CsnE = getTextFieldValueForConfig(Event,'csn_error_text')
ENDIF ELSE BEGIN
    tab6CsnB = 'OFF'
    tab6CsnV = 'N/A'
    tab6CsnE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'bcs_button')) $
  THEN BEGIN
    tab6BcsB = 'ON'
    tab6BcsV = getTextFieldValueForConfig(Event,'bcs_value_text')
    tab6BcsE = getTextFieldValueForConfig(Event,'bcs_error_text')
ENDIF ELSE BEGIN
    tab6BcsB = 'OFF'
    tab6BcsV = 'N/A'
    tab6BcsE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'bcn_button')) $
  THEN BEGIN
    tab6BcnB = 'ON'
    tab6BcnV = getTextFieldValueForConfig(Event,'bcn_value_text')
    tab6BcnE = getTextFieldValueForConfig(Event,'bcn_error_text')
ENDIF ELSE BEGIN
    tab6BcnB = 'OFF'
    tab6BcnV = 'N/A'
    tab6BcnE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'cs_button')) $
  THEN BEGIN
    tab6CsB = 'ON'
    tab6CsV = getTextFieldValueForConfig(Event,'cs_value_text')
    tab6CsE = getTextFieldValueForConfig(Event,'cs_error_text')
ENDIF ELSE BEGIN
    tab6CsB = 'OFF'
    tab6CsV = 'N/A'
    tab6CsE = 'N/A'
ENDELSE

IF (getButtonValue(Event, $
                   'cn_button')) $
  THEN BEGIN
    tab6CnB = 'ON'
    tab6CnV = getTextFieldValueForConfig(Event,'cn_value_text')
    tab6CnE = getTextFieldValueForConfig(Event,'cn_error_text')
ENDIF ELSE BEGIN
    tab6CnB = 'OFF'
    tab6CnV = 'N/A'
    tab6CnE = 'N/A'
ENDELSE

;---- tab7 ------------------------------------------------------------------
IF (getButtonValue(Event,'csfds_button')) THEN BEGIN
    tab7CsfdsB = 'ON'
    tab7CsfdsV = getTextFieldValueForConfig(Event,'csfds_value_text')
ENDIF ELSE BEGIN
    tab7CsfdsB = 'OFF'
    tab7CsfdsV = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tzsp_button')) $
  THEN BEGIN
    tab7tzspB = 'ON'
    tab7tzspV = getTextFieldValueForConfig(Event,'tzsp_value_text')
    tab7tzspE = getTextFieldValueForConfig(Event,'tzsp_error_text')
ENDIF ELSE BEGIN
    tab7tzspB = 'OFF'
    tab7tzspV = 'N/A'
    tab7tzspE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tzop_button')) $
  THEN BEGIN
    tab7tzopB = 'ON'
    tab7tzopV = getTextFieldValueForConfig(Event,'tzop_value_text')
    tab7tzopE = getTextFieldValueForConfig(Event,'tzop_error_text')
ENDIF ELSE BEGIN
    tab7tzopB = 'OFF'
    tab7tzopV = 'N/A'
    tab7tzopE = 'N/A'
ENDELSE

tab7Emin = getTextFieldValueForConfig(Event,'eha_min_text')
tab7Emax = getTextFieldValueForConfig(Event,'eha_max_text')
tab7Ebin = getTextFieldValueForConfig(Event,'eha_bin_text')

IF (getButtonValue(Event,'mtha_button')) THEN BEGIN
    tab7mthaB1 = 'ON'
    tab7mthaB2 = 'OFF'
    tab7mthaB1min = getTextFieldValueForConfig(Event,'mtha_min_text')
    tab7mthaB1max = getTextFieldValueForConfig(Event,'mtha_max_text')
    tab7mthaB1bin = getTextFieldValueForConfig(Event,'mtha_bin_text')
    tab7mthaB2min = 'N/A'
    tab7mthaB2max = 'N/A'
    tab7mthaB2bin = 'N/A'
ENDIF ELSE BEGIN
    tab7mthaB1 = 'OFF'
    tab7mthaB2 = 'ON'
    tab7mthaB1min = 'N/A'
    tab7mthaB1max = 'N/A'
    tab7mthaB1bin = 'N/A'
    tab7mthaB2min = getTextFieldValueForConfig(Event,'mtha_min_text')
    tab7mthaB2max = getTextFieldValueForConfig(Event,'mtha_max_text')
    tab7mthaB2bin = getTextFieldValueForConfig(Event,'mtha_bin_text')
ENDELSE

IF (getButtonValue(Event,'gifw_button')) $
  THEN BEGIN
    tab7gifwB = 'ON'
    tab7gifwV = getTextFieldValueForConfig(Event,'gifw_value_text')
    tab7gifwE = getTextFieldValueForConfig(Event,'gifw_error_text')
ENDIF ELSE BEGIN
    tab7gifwB = 'OFF'
    tab7gifwV = 'N/A'
    tab7gifwE = 'N/A'
ENDELSE

IF (getButtonValue(Event,'tof_cutting_button')) $
  THEN BEGIN
    tab7tofCB = 'ON'
    tab7tofCMin = getTextFieldValueForConfig(Event,'tof_cutting_min_text')
    tab7tofCMax = getTextFieldValueForConfig(Event,'tof_cutting_max_text')
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
        tab8waMin    = getTextFieldValueForConfig(Event,'wa_min_text')
        tab8waMax    = getTextFieldValueForConfig(Event,'wa_max_text')
        tab8waBin    = getTextFieldValueForConfig(Event,'wa_bin_text')
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
               field46: { title: 'Min Positive Transverse Energy Integration',$
                          value: tab5PSmin},$
               field47: { title: 'Max Positive Transverse Energy Integration',$
                          value: tab5PSmax},$
               field48: { title: 'Positive Transverse Energy Integration' + $
                          ' Width',$
                          value: tab5PSbin},$
               field49: { title: 'Detailed Balance Temperature (K)',$
                          value: tab5Dbt},$
               field50: { title: 'Ratio Tolerance',$
                          value: tab5Rt},$
               field51: { title: 'Number of Iteration',$
                          value: tab5Ni},$
               field52: { title: 'Minimum Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: tab5MinWbc},$
               field53: { title: 'Maximum Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: tab5MaxWbc},$
               field54: { title: 'Small Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: tab5SmaWbc},$
               field55: { title: 'Amorphous Reduction Verbosity',$
                          value: tab5Verbo},$
               field56: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Sample Data Spectra',$
                          value: tab6CsbssB},$
               field57: { title: '-> Value:',$
                          value: tab6CsbssV},$
               field58: { title: '-> Error',$
                          value: tab6CsbssE},$
               field59: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Normalization Data' + $
                          ' Spectra',$
                          value: tab6CsnB},$
               field60: { title: '-> Value',$
                          value: tab6CsnV},$
               field61: { title: '-> Error',$
                          value: tab6CsnE},$
               field62: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Sample Data' + $
                          ' Associatied Empty Container Spectra',$
                          value: tab6BcsB},$
               field63: { title: '-> Value',$
                          value: tab6BcsV},$
               field64: { title: '-> Error',$
                          value: tab6BcsE},$
               field65: { title: 'Constant to Scale the Back. Spectra' + $
                          ' for Subtraction from the Normalizaiton Data' + $
                          ' Associated Empty Container Spectra',$
                          value: tab6BcnB},$
               field66: { title: '-> Value',$
                          value: tab6BcnV},$
               field67: { title: '-> Error',$
                          value: tab6BcnE},$
               field68: { title: 'Constant to Scale the Empty Container' + $
                          ' Spectra for Subtraction from the Sample Data',$
                          value: tab6CsB},$
               field69: { title: '-> Value',$
                          value: tab6CsV},$
               field70: { title: '-> Error',$
                          value: tab6CsE},$
               field71: { title: 'Constant to Scale the Empty Container' + $
                          ' Spectra for Subtraction from the Normalization' + $
                          ' Data',$
                          value: tab6CnB},$
               field72: { title: '-> Value',$
                          value: tab6CnV},$
               field73: { title: '-> Error',$
                          value: tab6CnE},$
               field74: { title: 'Constant for Scaling the Final Data' + $
                          ' Spectrum',$
                          value: tab7CsfdsB},$
               field75: { title: '-> Value',$
                          value: tab7CsfdsV},$
               field76: { title: 'Time Zero Slope Parameter (Angstroms' + $
                          '/microSeconds)',$
                          value: tab7tzspB},$
               field77: { title: '-> Value',$
                          value: tab7tzspV},$
               field78: { title: '-> Error',$
                          value: tab7tzspE},$
               field79: { title: 'Time Zero Offset Parameters (Angstroms)',$
                          value: tab7tzopB},$
               field80: { title: '-> Value',$
                          value: tab7tzopV},$
               field81: { title: '-> Error',$
                          value: tab7tzopE},$
               field82: { title: 'Minimum Energy Histogram Axis (micro-eV)',$
                          value: tab7Emin},$
               field83: { title: 'Maximum Energy Histogram Axis (micro-eV)',$
                          value: tab7Emax},$
               field84: { title: 'Energy Histogram Axis Width (micro-eV)',$
                          value: tab7Ebin},$
               field85: { title: 'Momentum Transfer Histogram Axis' + $
                          ' (1/Angstroms)',$
                          value: tab7mthaB1},$
               field86: { title: '-> Min',$
                          value: tab7mthaB1min},$
               field87: { title: '-> Max',$
                           value: tab7mthaB1max},$
               field88: { title: '-> Width',$
                           value: tab7mthaB1bin},$
               field89: { title: 'Negative Cosine Polar Axis',$
                           value: tab7mthaB2},$
               field90: { title: '-> Min',$
                           value: tab7mthaB2min},$
               field91: { title: '-> Max',$
                           value: tab7mthaB2max},$
               field92: { title: '-> Width',$
                           value: tab7mthaB2bin},$
               field93: { title: 'Global Instrument Final Wavelength' + $
                           ' (Angstroms)',$
                           value: tab7gifwB},$
               field94: { title: '-> Value',$
                           value: tab7gifwV},$
               field95: { title: '-> Error',$
                           value: tab7gifwE},$
               field96: { title: 'Time of Flight Range (microseconds)',$
                           value: tab7tofCB},$
               field97: { title: '-> Min',$
                           value: tab7tofCMin},$
               field98: { title: '-> Max',$
                           value: tab7tofCMax},$
               field99: { title: 'Write all Intermediate Output',$
                           value: tab8Waio},$
               field100: { title: 'Write Out Time-Independent Background',$
                           value: tab8woctib},$
               fiedl101: { title: 'Write Out Pixel Wavelength Spectra',$
                           value: tab8wopws},$
               field102: { title: 'Write Out Monitor Wavelength Spectrum',$
                           value: tab8womws},$
               field103: { title: 'Write Out Monitor Efficiency Spectrum',$
                           value: tab8womes},$
               field104: { title: 'Write Out Rebinned Monitor Spectra',$
                           value: tab8worms},$
               field105: { title: 'Write Out Combined Pixel Spectrum After' + $
                           ' Monitor Normalization',$
                           value: tab8wocpsamn},$
               field106: { title: '-> Min',$
                           value: tab8waMin},$
               field107: { title: '-> Max',$
                           value: tab8waMax},$
               field108: { title: '-> Width',$
                           value: tab8WaBin},$
               field109: { title: 'Write Out Linearly Interpolated Direct' + $
                           ' Scattering Background Information Summed' + $
                           ' over all Pixels',$
                           value: tab8wolidsb},$
               field110: { title: 'Write Out Pixel Wavelength Spectra ' + $
                           'after Vanadium Normalization',$
                           value: tab8pwsavn}}
               
RETURN, sStructure
END

;==============================================================================
FUNCTION IDLcreateLogFile::getListOfStdOutFiles
RETURN, self.file_name_array_out
END

;==============================================================================
FUNCTION IDLcreateLogFile::getListOfStdErrFiles
RETURN, self.file_name_array_err
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLcreateLogFile::init, Event, cmd
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;retrieve value of fields from REDUCE tabs
sReduce = populateReduceStructure(Event)

;define current date
DateTime = GenerateIsoTimeStamp()

;retrieve name of all output files
nbr_jobs = N_ELEMENTS(cmd)
file_name_array = STRARR(nbr_jobs)
index = 0
WHILE (index LT nbr_jobs) DO BEGIN
   match1 = STREGEX(cmd[index],' --output=.*',/EXTRACT)
   match2 = STRSPLIT(match1,'=',/EXTRACT)
   file_name_array[index++] = STRCOMPRESS(match2[1],/REMOVE_ALL)
ENDWHILE

;create array of .err and .out files names
file_name_array_out = ReplaceExt(file_name_array, NEW='out')
file_name_array_err = ReplaceExt(file_name_array, NEW='err')

;force the location and name of .err and .out files
output_path = (*global).default_output_path
CD, '~', CURRENT=current_path
expand_path = FILE_EXPAND_PATH('~/results/')
CD, current_path
;;; remove ~/ from expand_path
expand_path = remove_tilda(expand_path)
;;; add expand_path to list of std out and err files
ListOfStdOutFiles = expand_path + file_name_array_out 
self.file_name_array_out = PTR_NEW(ListOfStdOutFiles)
shortListOfStdOutFiles = getBaseFileName(ListOfStdOutFiles)
ListOfStdErrFiles = expand_path + file_name_array_err
self.file_name_array_err = PTR_NEW(ListOfStdErrFiles)
shortListOfStdErrFiles = getBaseFileName(ListOfStdErrFiles)

;create string array of all information from this/these job(s) ----------------
nbr_structure_tags = N_TAGS(sReduce) 
final_array_size = 4 + Nbr_jobs + nbr_structure_tags
;Date 1
;start and end list of output files 3
;list of output files nbr_jobs
;number of metadata nbr_structure_tags
;'' 1

final_array = STRARR(final_array_size)

;write date -------------------------------------------------------------------
final_array[0] = 'Date: ' + DateTime
i = 0
final_array[1] = '***** Start List of Output Files *****'
offset = 2
WHILE (i LT nbr_jobs) DO BEGIN
    text  = 'Output File: ' + file_name_array[i]
    text += ' | Stderr File: ' + shortListOfStdErrFiles[i]
    text += ' | Stdout File: ' + shortListOfStdOutFiles[i]
    final_array[i+offset] = text
    i++
ENDWHILE
i+=offset
final_array[i++] = '***** End List of Output Files *****'

offset = i
FOR j=0,(nbr_structure_tags-1) DO BEGIN
   title = sReduce.(j).title
   value = sReduce.(j).value
   final_array[j+offset] = title + ': ' + value
ENDFOR

;check if config file already exists or not -----------------------------------
config_file_name = (*global).config_file_name

IF (FILE_TEST(config_file_name)) THEN BEGIN ;file already exists
;We gonna have to append the file from the top
    current_config_file_size = FILE_LINES(config_file_name)
    IF (current_config_file_size GT 20) THEN BEGIN
        current_config_file_array = STRARR(current_config_file_size)
        OPENR, 1, config_file_name
        READF, 1, current_config_file_array
        CLOSE, 1
        final_array = [final_array, current_config_file_array]
    ENDIF
ENDIF 

OPENW, 1, config_file_name
FOR i=0,(N_ELEMENTS(final_array)-1) DO BEGIN
    PRINTF, 1, final_array[i]
ENDFOR
CLOSE, 1
FREE_LUN, 1

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLcreateLogFile__define
struct = {IDLcreateLogFile,$
          file_name_array_out: PTR_NEW(0L),$
          file_name_array_err: PTR_NEW(0L),$
          var: ''}
END
;******************************************************************************
;******************************************************************************
