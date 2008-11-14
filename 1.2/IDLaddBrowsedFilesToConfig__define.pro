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
tab1Data = 'N/A'
tab1Back = 'N/A'
tab1Norm = 'N/A'
tab1Empt = 'N/A'
tab1Dire = 'N/A'

;---- tab2 ------------------------------------------------------------------
tab2Roi  = 'N/A'
tab2Alte = 'N/A'
tab2path = 'N/A'
tab2name = 'N/A'

;---- tab3 ------------------------------------------------------------------
tab3RunMc = 'ON'
tab3Verbo = 'ON'
tab3AltBa = 'ON'
tab3NoMor = 'ON'
tab3NoMoE = 'ON'
tab3NiwB = 'ON'
tab3NiwS = 'N/A'
tab3NiwE = 'N/A'
tab3TeB = 'OFF'
tab3TeL = 'N/A'
tab3TeH = 'N/A'
tab4Tof  = 'OFF'
tab4Tof1 = 'N/A'
tab4Tof2 = 'N/A'
tab4Tof3 = 'N/A'
tab4Tof4 = 'N/A'
tab4TsdB = 'OFF'
tab4TsdV = 'N/A'
tab4TsdE = 'N/A'
tab4TbdB = 'OFF'
tab4TbdV = 'N/A'
tab4TbdE = 'N/A'
tab4TndB = 'OFF'
tab4TndV = 'N/A'
tab4TndE = 'N/A'
tab4TecdB = 'OFF'
tab4TecdV = 'N/A'
tab4TecdE = 'N/A'
tab4TscatB = 'OFF'
tab4TscatV = 'N/A'
tab4TscatE = 'N/A'
tab5ibB = 'OFF'
tab5scl = 'N/A'
tab5cf  = 'N/A'
tab5cwc = 'N/A'
tab5tof = 'N/A'
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
tab6CsbssB = 'OFF'
tab6CsbssV = 'N/A'
tab6CsbssE = 'N/A'
tab6CsnB = 'OFF'
tab6CsnV = 'N/A'
tab6CsnE = 'N/A'
tab6BcsB = 'OFF'
tab6BcsV = 'N/A'
tab6BcsE = 'N/A'
tab6BcnB = 'OFF'
tab6BcnV = 'N/A'
tab6BcnE = 'N/A'
tab6CsB = 'OFF'
tab6CsV = 'N/A'
tab6CsE = 'N/A'
tab6CnB = 'OFF'
tab6CnV = 'N/A'
tab6CnE = 'N/A'
tab7CsfdsB = 'OFF'
tab7CsfdsV = 'N/A'
tab7tzspB = 'OFF'
tab7tzspV = 'N/A'
tab7tzspE = 'N/A'
tab7tzopB = 'OFF'
tab7tzopV = 'N/A'
tab7tzopE = 'N/A'
tab7emin = 'N/A'
tab7emax = 'N/A'
tab7ebin = 'N/A'
tab7mthaB1 = 'OFF'
tab7mthaB2 = 'ON'
tab7mthaB1min = 'N/A'
tab7mthaB1max = 'N/A'
tab7mthaB1bin = 'N/A'
tab7mthaB2min = 'N/A'
tab7mthaB2max = 'N/A'
tab7mthaB2bin = 'N/A'
tab7gifwB = 'OFF'
tab7gifwV = 'N/A'
tab7gifwE = 'N/A'
tab7tofCB = 'OFF'
tab7tofCMin = 'N/A'
tab7tofCMax = 'N/A'
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

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLaddBrowsedFilesToConfig::init, Event, list_OF_files
WIDGET_CONTROL,Event.top,GET_UVALUE=global

Nbr_jobs = N_ELEMENTS(list_OF_files)

;retrieve value of fields from REDUCE tabs
sReduce = populateReduceStructure(Event)

;define current date
DateTime = GenerateIsoTimeStamp()

;retrieve name of all output files
file_name_array = list_OF_files

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
   final_array[i+offset] = 'Output File: ' + file_name_array[i]
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
PRO IDLaddBrowsedFilesToConfig__define
struct = {IDLaddBrowsedFilesToConfig,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
