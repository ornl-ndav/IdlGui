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
FUNCTION retrieve_information_from_rmd, file_name
;remove .txt and put .rmd instead
file    = STRSPLIT(file_name, '.', /EXTRACT)
rmdFile = file[0] + '.rmd'
;retrieve various metadata from xml file
IF (FILE_TEST(rmdFile)) THEN BEGIN
    iXML = OBJ_NEW('IDLxmlParser',rmdFile)
    IF (OBJ_VALID(iXML)) THEN BEGIN
;create structure
        sStructure = { field42: iXML->getValue(tag= $
                                               ['config','ldb_const', $
                                                    'value']),$
                       field86: iXML->getValue(tag= $
                                               ['config','Q_bins','min']),$
                       field87: iXML->getValue(tag= $
                                               ['config','Q_bins','max']),$
                       field88: iXML->getValue(tag= $
                                               ['config','Q_bins','delta']),$
                       field82: iXML->getValue(tag= $
                                               ['config','E_bins','min']),$
                       field83: iXML->getValue(tag= $
                                               ['config','E_bins','max']),$
                       field84: iXML->getValue(tag= $
                                               ['config','E_bins','delta']),$
                       field16: iXML->getValue(tag= $
                                               ['config','norm_start']),$
                       field17: iXML->getValue(tag= $
                                               ['config','norm_end']),$
                       field8:  iXML->getValue(tag= $
                                               ['config', $
                                                'path_replacement']) + '/',$
                       field49: iXML->getValue(tag= $
                                               ['config','detbal_temp']),$
                       field50: iXML->getValue(tag= $
                                               ['config','tol']),$
                       field45: iXML->getValue(tag= $
                                               ['config','tof_least', $
                                                    'value']),$
                       field46: iXML->getValue(tag= $
                                               ['config','et_int_range', $
                                                    'min']),$
                       field47: iXML->getValue(tag= $
                                               ['config','et_int_range', $
                                                    'max']),$
                       field48: iXML->getValue(tag= $
                                               ['config','et_int_range', $
                                                    'delta']),$
                       field1:  iXML->getValue(tag= $
                                               ['config','data']),$
                       field6:  iXML->getValue(tag= $
                                               ['config','roi_file']),$
                       field51: iXML->getValue(tag= $
                                               ['config','niter']),$
                       field52: iXML->getValue(tag= $
                                               ['config','cwdb_min']),$
                       field53: iXML->getValue(tag= $
                                               ['config','cwdb_max']),$
                       field44: iXML->getValue(tag= $
                                               ['config','chopper_lambda', $
                                                    'value']),$
                       field43: iXML->getValue(tag=['config','chopper_freq',$
                                                    'value']),$
                       field54: iXML->getValue(tag=['config','cwdb_small']),$
                       field9: ''}
        
        full_output_file_name = iXML->getValue(tag=['config','output'])
        output_file_name = FILE_BASENAME(full_output_file_name)
        sStructure.field9 = output_file_name
        OBJ_DESTROY, iXML
        
    ENDIF ELSE BEGIN
        
        path = FILE_DIRNAME(file_name) + '/'
        sStructure = { field42: 'N/A',$
                       field86: 'N/A',$
                       field87: 'N/A',$
                       field88: 'N/A',$
                       field82: 'N/A',$
                       field83: 'N/A',$
                       field84: 'N/A',$
                       field16: 'N/A',$
                       field17: 'N/A',$
                       field8:  path,$
                       field49: 'N/A',$
                       field50: 'N/A',$
                       field45: 'N/A',$
                       field46: 'N/A',$
                       field47: 'N/A',$
                       field48: 'N/A',$
                       field1:  'N/A',$
                       field6:  'N/A',$
                       field51: 'N/A',$
                       field52: 'N/A',$
                       field53: 'N/A',$
                       field44: 'N/A',$
                       field43: 'N/A',$
                       field54: 'N/A',$
                       field9:  'N/A'}
        
    ENDELSE
ENDIF ELSE BEGIN
    
    path = FILE_DIRNAME(file_name) + '/'
    sStructure = { field42: 'N/A',$
                   field86: 'N/A',$
                   field87: 'N/A',$
                   field88: 'N/A',$
                   field82: 'N/A',$
                   field83: 'N/A',$
                   field84: 'N/A',$
                   field16: 'N/A',$
                   field17: 'N/A',$
                   field8:  path,$
                   field49: 'N/A',$
                   field50: 'N/A',$
                   field45: 'N/A',$
                   field46: 'N/A',$
                   field47: 'N/A',$
                   field48: 'N/A',$
                   field1:  'N/A',$
                   field6:  'N/A',$
                   field51: 'N/A',$
                   field52: 'N/A',$
                   field53: 'N/A',$
                   field44: 'N/A',$
                   field43: 'N/A',$
                   field54: 'N/A',$
                   field9:  'N/A'}
    
ENDELSE

RETURN, sStructure
END

;------------------------------------------------------------------------------
;This function retrieves the values from the various Reduce Tab
FUNCTION populateReduceStructureFromBrowse, sValue

;write value in structure
sStructure = { field1: { title: 'Raw Sample Data File',$
                         value: sValue.field1},$
               field2: { title: 'Background Data File',$
                         value: 'N/A'},$
               field3: { title: 'Normalization Data file',$
                         value: 'N/A'},$
               field4: { title: 'Empty Can Data File',$
                         value: 'N/A'},$
               field5: { title: 'Direct Scattering Background (Sample Data' + $
                         ' at Baseline T) File',$
                         value: 'N/A'},$
               field6: { title: 'Pixel Region of Interest File',$
                         value: sValue.field6},$
               field7: { title: 'Alternate Instrument Geometry',$
                         value: 'N/A'},$
               field8: { title: 'Output Path',$
                         value: sValue.field8},$
               field9: { title: 'Output File Name',$
                         value: sValue.field9},$
               field10: { title: 'Run McStas NeXus Files',$
                          value: 'N/A'},$
               field11: { title: 'Verbose',$
                          value: 'N/A'},$
               field12: { title: 'Alternate Background Subtraction Method',$
                          value: 'N/A'},$
               field13: { title: 'No Monitor Normalization',$
                          value: 'N/A'},$
               field14: { title: 'No Monitor Efficiency',$
                          value: 'N/A'},$
               field15: { title: 'Normalization Integration Start and ' + $
                          'End Wavelength',$
                          value: 'N/A'},$
               field16: { title: '-> Start',$
                          value: sValue.field16},$
               field17: { title: '-> End',$
                          value: sValue.field17},$
               field18: { title: 'Low and High Time-of-Flight Values that' + $
                          ' Bracket the Elastic Peak (microSeconds)',$
                          value: 'N/A'},$
               field19: { title: '-> Low',$
                          value: 'N/A'},$
               field20: { title: '-> High',$
                          value: 'N/A'},$
               field21: { title: 'Time-Independent Background Time-of' + $
                          'Flight Channels (microSeconds)',$
                          value: 'N/A'},$
               field22: { title: '-> #1',$
                          value: 'N/A'},$
               field23: { title: '-> #2',$
                          value: 'N/A'},$
               field24: { title: '-> #3',$
                          value: 'N/A'},$
               field25: { title: '-> #4',$
                          value: 'N/A'},$
               field26: { title: 'Time-Independent Background Constant' + $
                          ' for Sample Data',$
                          value: 'N/A'},$
               field27: { title: '-> Value',$
                          value: 'N/A'},$
               field28: { title: '-> Error',$
                          value: 'N/A'},$
               field29: { title: 'Time-Independent Background Constant' + $
                          ' for Background Data',$
                          value: 'N/A'},$
               field30: { title: '-> Value',$
                          value: 'N/A'},$
               field31: { title: '-> Error',$
                          value: 'N/A'},$
               field32: { title: 'Time-Independent Background Constant' + $
                          ' for Normalization Data',$
                          value: 'N/A'},$
               field33: { title: '-> Value',$
                          value: 'N/A'},$
               field34: { title: '-> Error',$
                          value: 'N/A'},$
               field35: { title: 'Time-Independent Background Constant' + $
                          ' for Empty Can Data',$
                          value: 'N/A'},$
               field36: { title: '-> Value',$
                          value: 'N/A'},$
               field37: { title: '-> Error',$
                          value: 'N/A'},$
               field38: { title: 'Time-Independent Background Constant' + $
                          ' for Scattering Data',$
                          value: 'N/A'},$
               field39: { title: '-> Value',$
                          value: 'N/A'},$
               field40: { title: '-> Error',$
                          value: 'N/A'},$
               field41: { title: 'Use Iterative Background Subtraction',$
                          value: 'N/A'},$
               field42: { title: 'Scale Constant for Lambda Dependent' + $
                          ' Background',$
                          value: sValue.field42},$
               field43: { title: 'Chopper Frequency (Hz)',$
                          value: sValue.field43},$
               field44: { title: 'Chopper Wavelength Center (Angstroms)',$
                          value: sValue.field44},$
               field45: { title: 'TOF Least Background (microS)',$
                          value: sValue.field45},$
               field46: { title: 'Min Positive Transverse Energy Integration',$
                          value: sValue.field46},$
               field47: { title: 'Max Positive Transverse Energy Integration',$
                          value: sValue.field47},$
               field48: { title: 'Positive Transverse Energy Integration' + $
                          ' Width',$
                          value: sValue.field48},$
               field49: { title: 'Detailed Balance Temperature (K)',$
                          value: sValue.field49},$
               field50: { title: 'Ratio Tolerance',$
                          value: sValue.field50},$
               field51: { title: 'Number of Iteration',$
                          value: sValue.field51},$
               field52: { title: 'Minimum Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: sValue.field52},$
               field53: { title: 'Maximum Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: sValue.field53},$
               field54: { title: 'Small Wavelength-Dependent Background' + $
                          ' Constant',$
                          value: sValue.field54},$
               field55: { title: 'Amorphous Reduction Verbosity',$
                          value: 'N/A'},$
               field56: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Sample Data Spectra',$
                          value: 'N/A'},$
               field57: { title: '-> Value:',$
                          value: 'N/A'},$
               field58: { title: '-> Error',$
                          value: 'N/A'},$
               field59: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Normalization Data' + $
                          ' Spectra',$
                          value: 'N/A'},$
               field60: { title: '-> Value',$
                          value: 'N/A'},$
               field61: { title: '-> Error',$
                          value: 'N/A'},$
               field62: { title: 'Constant to Scale the Background Spectra' + $
                          ' for Subtraction from the Sample Data' + $
                          ' Associatied Empty Container Spectra',$
                          value: 'N/A'},$
               field63: { title: '-> Value',$
                          value: 'N/A'},$
               field64: { title: '-> Error',$
                          value: 'N/A'},$
               field65: { title: 'Constant to Scale the Back. Spectra' + $
                          ' for Subtraction from the Normalizaiton Data' + $
                          ' Associated Empty Container Spectra',$
                          value: 'N/A'},$
               field66: { title: '-> Value',$
                          value: 'N/A'},$
               field67: { title: '-> Error',$
                          value: 'N/A'},$
               field68: { title: 'Constant to Scale the Empty Container' + $
                          ' Spectra for Subtraction from the Sample Data',$
                          value: 'N/A'},$
               field69: { title: '-> Value',$
                          value: 'N/A'},$
               field70: { title: '-> Error',$
                          value: 'N/A'},$
               field71: { title: 'Constant to Scale the Empty Container' + $
                          ' Spectra for Subtraction from the Normalization' + $
                          ' Data',$
                          value: 'N/A'},$
               field72: { title: '-> Value',$
                          value: 'N/A'},$
               field73: { title: '-> Error',$
                          value: 'N/A'},$
               field74: { title: 'Constant for Scaling the Final Data' + $
                          ' Spectrum',$
                          value: 'N/A'},$
               field75: { title: '-> Value',$
                          value: 'N/A'},$
               field76: { title: 'Time Zero Slope Parameter (Angstroms' + $
                          '/microSeconds)',$
                          value: 'N/A'},$
               field77: { title: '-> Value',$
                          value: 'N/A'},$
               field78: { title: '-> Error',$
                          value: 'N/A'},$
               field79: { title: 'Time Zero Offset Parameters (Angstroms)',$
                          value: 'N/A'},$
               field80: { title: '-> Value',$
                          value: 'N/A'},$
               field81: { title: '-> Error',$
                          value: 'N/A'},$
               field82: { title: 'Minimum Energy Histogram Axis (micro-eV)',$
                          value: sValue.field82},$
               field83: { title: 'Maximum Energy Histogram Axis (micro-eV)',$
                          value: sValue.field83},$
               field84: { title: 'Energy Histogram Axis Width (micro-eV)',$
                          value: sValue.field84},$
               field85: { title: 'Momentum Transfer Histogram Axis' + $
                          ' (1/Angstroms)',$
                          value: 'N/A'},$
               field86: { title: '-> Min',$
                          value: sValue.field86},$
               field87: { title: '-> Max',$
                           value: sValue.field87},$
               field88: { title: '-> Width',$
                           value: sValue.field88},$
               field89: { title: 'Negative Cosine Polar Axis',$
                           value: 'N/A'},$
               field90: { title: '-> Min',$
                           value: 'N/A'},$
               field91: { title: '-> Max',$
                           value: 'N/A'},$
               field92: { title: '-> Width',$
                           value: 'N/A'},$
               field93: { title: 'Global Instrument Final Wavelength' + $
                           ' (Angstroms)',$
                           value: 'N/A'},$
               field94: { title: '-> Value',$
                           value: 'N/A'},$
               field95: { title: '-> Error',$
                           value: 'N/A'},$
               field96: { title: 'Time of Flight Range (microseconds)',$
                           value: 'N/A'},$
               field97: { title: '-> Min',$
                           value: 'N/A'},$
               field98: { title: '-> Max',$
                           value: 'N/A'},$
               field99: { title: 'Write all Intermediate Output',$
                           value: 'N/A'},$
               field100: { title: 'Write Out Time-Independent Background',$
                           value: 'N/A'},$
               fiedl101: { title: 'Write Out Pixel Wavelength Spectra',$
                           value: 'N/A'},$
               field102: { title: 'Write Out Monitor Wavelength Spectrum',$
                           value: 'N/A'},$
               field103: { title: 'Write Out Monitor Efficiency Spectrum',$
                           value: 'N/A'},$
               field104: { title: 'Write Out Rebinned Monitor Spectra',$
                           value: 'N/A'},$
               field105: { title: 'Write Out Combined Pixel Spectrum After' + $
                           ' Monitor Normalization',$
                           value: 'N/A'},$
               field106: { title: '-> Min',$
                           value: 'N/A'},$
               field107: { title: '-> Max',$
                           value: 'N/A'},$
               field108: { title: '-> Width',$
                           value: 'N/A'},$
               field109: { title: 'Write Out Linearly Interpolated Direct' + $
                           ' Scattering Background Information Summed' + $
                           ' over all Pixels',$
                           value: 'N/A'},$
               field110: { title: 'Write Out Pixel Wavelength Spectra ' + $
                           'after Vanadium Normalization',$
                           value: 'N/A'}}
               
RETURN, sStructure
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLaddBrowsedFilesToConfig::init, Event, list_OF_files
WIDGET_CONTROL,Event.top,GET_UVALUE=global

Nbr_jobs = N_ELEMENTS(list_OF_files)

;try to get information from first .rmd file
sStructure = retrieve_information_from_rmd(list_OF_files[0])

;retrieve value of fields from REDUCE tabs
sReduce = populateReduceStructureFromBrowse(sStructure)

;define current date
DateTime = GenerateIsoTimeStamp()

;;retrieve name of all output files
file_name_array = list_OF_files

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
PRO IDLaddBrowsedFilesToConfig__define
struct = {IDLaddBrowsedFilesToConfig,$
          file_name_array_out: PTR_NEW(0L),$
          file_name_array_err: PTR_NEW(0L),$
          var: ''}
END
;******************************************************************************
;******************************************************************************
