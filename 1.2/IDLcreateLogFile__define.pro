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
    tab7tofCV = getTextFieldValue(Event,'tof_cutting_min_text')
    tab7tofCE = getTextFieldValue(Event,'tof_cutting_max_text')
ENDIF ELSE BEGIN
    tab7tofCB = 'OFF'
    tab7tofCV = 'N/A'
    tab7tofCE = 'N/A'
ENDELSE

;---- tab8 ------------------------------------------------------------------




RETURN, ''
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLcreateLogFile::init, Event, cmd

;retrieve value of fields from REDUCE tabs
sReduce = populateReduceStructure(Event)

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
