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

PRO BSSreduction_CommandLineGenerator, Event

  ;get global structure
  id=WIDGET_INFO(EVENT.TOP, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;this function update all the reduce widgets (validate or not)
  BSSreduction_ReduceUpdateGui, Event
  
  StatusMessage = 0 ;will increase by 1 each time a field is missing
  
  ;check if use iterative background subtraction is active or not
  ibs_value = getCWBgroupValue(Event, $
    'use_iterative_background_subtraction_cw_bgroup')
    
  ;****TAB1****
    
  TabName = 'Tab#1 - INPUT DATA SETUP (1)'
  tab1    = 0
  ;get Raw Sample Data Files
  ;RSDFiles = getTextFieldValue(Event, 'FIXME')  ;FIXME
  RSDFiles = (*(*global).list_of_data_nexus)
  nbr_individual_runs = n_elements(RSDFiles)
  
  ;cmd_array = strarr(nbr_individual_runs)
  cmd_array = !null
  
  index_run = 0
  while (index_run lt nbr_individual_runs) do begin
  
    IF (ibs_value EQ 1) THEN BEGIN ;if Iterative Background Subtraction is OFF
      cmd = (*global).DriverName + ' ' ;name of function to call
    ENDIF ELSE BEGIN
      cmd = (*global).iterative_background_DriverName + ' '
    ENDELSE
    
    IF (RSDFiles[0] NE '') THEN BEGIN
      cmd += ' ' + strcompress(RSDFiles[index_run],/remove_all)
      IF (StatusMessage EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, '', 0
      ENDIF
    ENDIF ELSE BEGIN
      cmd += ' ?'
      putInfoInCommandLineStatus, Event, TabName, 0
      status_text = '   -Please provide at least one Raw Sample Data File'
      putInfoInCommandLineStatus, Event, status_text, 1
      StatusMessage += 1
      ++tab1
    ENDELSE
    
    ;get Background Data File
    BDFiles = getTextFieldValue(Event,'bdf_run_number_cw_field')
    IF (BDFiles NE '') THEN BEGIN
      cmd += ' --back=' + BDFiles
    ENDIF
    
    ;get Normalization Data File
    NDFiles = getTextFieldValue(Event,'ndf_run_number_cw_field')
    IF (NDFiles NE '') THEN BEGIN
      cmd += ' --norm=' + NDFiles
    ENDIF
    
    ;get Empty Can Data File
    ECDFiles = getTextFieldValue(Event,'ecdf_run_number_cw_field')
    IF (ECDFiles NE '') THEN BEGIN
      cmd += ' --ecan=' + ECDFiles
    ENDIF
    
    ;get Direct Scattering Background
    DSBFiles = getTextFieldValue(Event,'dsb_run_number_cw_field')
    IF (DSBFiles NE '') THEN BEGIN
      cmd += ' --dsback=' + DSBFiles
      na_base_status = 0
    ENDIF ELSE BEGIN
      na_base_status = 1
    ENDELSE
    activate_base, event, 'na_wolidsbbase', na_base_status
    
    ;*****TAB2*****
    TabName = 'Tab#2 - INPUT DATA SETUP (2)'
    tab2    = 0
    
    ;get Pixel Region of Interest File
    PRoIFile = getTextFieldValue(Event,'proif_text')
    cmd += ' --roi-file='
    IF (PRoIFile NE '') THEN BEGIN
      cmd += strcompress(PRoIFile,/remove_all)
      IF (StatusMessage EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, '', 0
      ENDIF
    ENDIF ELSE BEGIN
      cmd += '?'
      status_text = '   -Please provide a Pixel Region of Interest File'
      IF (tab2 EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, '', 1
        putInfoInCommandLineStatus, Event, '', 1
      ENDIF
      IF (tab2 EQ 0 AND $
        StatusMessage EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 0
      ENDIF
      IF (tab2 EQ 0 AND $
        StatusMessage NE 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 1
      ENDIF
      putInfoInCommandLineStatus, Event, status_text, 1
      StatusMessage += 1
      ++tab2
    ENDELSE
    
    ;get Alternate Instrument Geometry
    
    IF ((*global).lds_mode EQ 1) THEN BEGIN  ;mandatory for live data streaming
      cmd += ' --inst-geom='
      AIGFile = getTextFieldValue(Event,'aig_list_of_runs_text')
      IF (FILE_TEST(AIGFile) EQ 0) THEN BEGIN
        AIGFile = '?'
        IF (tab2 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        status_text = '   -Please provide a Valid Alternate Instrument' + $
          ' Geometry'
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab2
      ENDIF
      cmd += AIGFile
    ENDIF ELSE BEGIN
      AIGFile = getTextFieldValue(Event,'aig_list_of_runs_text')
      IF (AIGFile NE '') THEN BEGIN
        cmd += ' --inst-geom='
        IF (FILE_TEST(AIGFile) EQ 0) THEN BEGIN
          AIGFile = '?'
          IF (tab2 EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, '', 1
            putInfoInCommandLineStatus, Event, '', 1
          ENDIF
          IF (tab2 EQ 0 AND $
            StatusMessage EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 0
          ENDIF
          IF (tab2 EQ 0 AND $
            StatusMessage NE 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 1
          ENDIF
          status_text = '   -Please provide a Valid Alternate Instrument' + $
            ' Geometry'
          putInfoInCommandLineStatus, Event, status_text, 1
          StatusMessage += 1
          ++tab2
        ENDIF
        cmd += AIGFIle
      ENDIF
    ENDELSE
    
    ;****TAB3****
    
    TabName = 'Tab#3 - PROCESS SETUP'
    tab3 = 0
    ;get Run McStas NeXus Files status
    IF (isButtonSelected(Event,'rmcnf_button')) THEN BEGIN
      cmd += ' --mc'
    ENDIF
    
    ;get Verbose status
    IF (isButtonSelected(Event,'verbose_button')) THEN BEGIN
      cmd += ' --verbose'
    ENDIF
    
    ;get Alternate Background Subtraction Method
    IF (isButtonSelected(Event,'absm_button')) THEN BEGIN
      cmd += ' --hwfix'
    ENDIF
    
    ;get No Monitor Normalization
    IF (isButtonSelected(Event,'nmn_button')) THEN BEGIN
      na_base_status = 1
      cmd += ' --no-mon-norm'
    ENDIF ELSE BEGIN
      na_base_status = 0
      
      ;check if the file is using the Translation Service deployed on 03/2010
      ;if yes, the following flag is necessary
      ; --mon-path=/entry/monitor1,1
      if (is_monitor_named_monitor1(RSDFiles)) then begin
        cmd += ' --mon-path=/entry/monitor1,1'
      endif else begin
        cmd += ' --mon-path=/entry/monitor,1'
      endelse
      
    ENDELSE
    activate_base, event, 'na_womwsbase', na_base_status
    activate_base, event, 'na_wormsbase', na_base_status
    activate_base, event, 'na_wocpsamnbase', na_base_status
    activate_base, event, 'na_womesbase', na_base_status
    
    IF (na_base_status) then begin
      BSSreduction_EnableOrNotFields, Event, 'wocpsamn_button', 0
    endif else begin
      BSSreduction_EnableOrNotFields, Event, 'wocpsamn_button'
    endelse
    
    ;get No Monitor Efficiency Correction
    IF (isButtonSelected(Event,'nmec_button')) THEN BEGIN
      cmd += ' --no-mon-effc'
    ENDIF
    
    ;if --no-mon-norm is not set or
    ;   --no-mon-effc is not set then validate --mon-effc
    IF (isButtonSelected(Event,'nmn_button') EQ 0 AND $
      isButtonSelected(Event,'nmec_button') EQ 0) THEN BEGIN
      na_base_status = 0
    ENDIF ELSE BEGIN
      na_base_status = 1
    ENDELSE
    activate_base, event, 'na_womesbase', na_base_status
    
    ;get Normalization Integration Wavelength
    ;  IF (isButtonSelected(Event,'niw_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    
    IF (isButtonSelected(Event,'niw_button') AND $
      NDFiles NE '') THEN BEGIN
      
      ;get Normalization Integration Start Wavelength
      NISW = getTextFieldValue(Event,'nisw_field')
      IF(NISW NE '') THEN BEGIN
        cmd += ' --norm-start=' + strcompress(NISW,/remove_all)
      ENDIF
      
      ;get Normalization Integration End Wavelength
      NIEW = getTextFieldValue(Event,'niew_field')
      IF(NIEW NE '') THEN BEGIN
        cmd += ' --norm-end=' + strcompress(NIEW,/remove_all)
      ENDIF
    ENDIF
    
    ;  IF (isButtonSelected(Event,'te_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    
    IF (isButtonSelected(Event,'te_button') AND $
      DSBFiles NE '') THEN BEGIN
      
      ;sample data file
      TEL = getTextFieldValue(Event,'te_low_field')
      TEH = getTextFieldValue(Event,'te_high_field')
      
      cmd += ' --tof-elastic='
      
      IF (TEL EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Low Value that Bracket the ' + $
          'Elastic Peak'
        IF (tab3 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab3 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab3 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab3
      ENDIF ELSE BEGIN
        cmd += strcompress(TEL,/remove_all)
      ENDELSE
      
      IF (TEH EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a High Value that Bracket the ' + $
          'Elastic Peak'
        IF (tab3 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab3 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab3 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab3
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TEH,/remove_all)
      ENDELSE
      
    ENDIF
    
    ;****TAB4****
    
    TabName = 'Tab#4 - TIME-INDEPENDENT BACKGROUND'
    tab4    = 0
    
    ;  IF (isButtonSelected(Event,'tib_tof_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    
    ;get Time-Independent Background TOF channels
    IF (isButtonSelected(Event,'tib_tof_button')) THEN BEGIN
    
      TIBTOF1 = getTextFieldValue(Event,'tibtof_channel1_text')
      TIBTOF2 = getTextFieldValue(Event,'tibtof_channel2_text')
      TIBTOF3 = getTextFieldValue(Event,'tibtof_channel3_text')
      TIBTOF4 = getTextFieldValue(Event,'tibtof_channel4_text')
      
      cmd += ' --tib-tofs='
      
      IF (TIBTOF1 EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a TOF Channel #1'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBTOF1,/remove_all)
      ENDELSE
      
      IF (TIBTOF2 EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a TOF Channel #2'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBTOF2,/remove_all)
      ENDELSE
      
      IF (TIBTOF3 EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a TOF Channel #3'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBTOF3,/remove_all)
      ENDELSE
      
      IF (TIBTOF4 EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a TOF Channel #4'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBTOF4,/remove_all)
      ENDELSE
      
      ip_base_activate_status = 0
    ENDIF ELSE BEGIN
      ip_base_activate_status = 1
    ENDELSE
    activate_base, event, 'na_woctibbase', ip_base_activate_status
    
    ;get Time-independent Background Constant for Sample Data
    ;  IF (isButtonSelected(Event,'tibc_for_sd_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    
    IF (isButtonSelected(Event,'tibc_for_sd_button')) THEN BEGIN
      cmd += ' --tib-data-const='
      
      TIBCV = getTextFieldValue(Event,'tibc_for_sd_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Value for'
        status_text += ' Sample Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'tibc_for_sd_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background ' + $
          'Constant Error for'
        status_text += ' Sample Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
    ENDIF
    
    ;get Time-independent Background Constant for Background Data
    ;  IF (isButtonSelected(Event,'tibc_for_bd_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    IF (isButtonSelected(Event,'tibc_for_bd_button')) THEN BEGIN
      cmd += ' --tib-back-const='
      
      TIBCV = getTextFieldValue(Event,'tibc_for_bd_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Value for'
        status_text += ' Background Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'tibc_for_bd_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Error for'
        status_text += ' Background Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
      
    ENDIF
    
    ;get Time-independent Background Constant for Normalization Data
    ;  IF (isButtonSelected(Event,'tibc_for_nd_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    IF (isButtonSelected(Event,'tibc_for_nd_button')) THEN BEGIN
      cmd += ' --tib-norm-const='
      
      TIBCV = getTextFieldValue(Event,'tibc_for_nd_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Value for'
        status_text += ' Normalization Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'tibc_for_nd_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Error for'
        status_text += ' Normalization Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
    ENDIF
    
    ;get Time-independent Background Constant for Empty Can Data
    ;  IF (isButtonSelected(Event,'tibc_for_ecd_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    IF (isButtonSelected(Event,'tibc_for_ecd_button')) THEN BEGIN
      cmd += ' --tib-ecan-const='
      
      TIBCV = getTextFieldValue(Event,'tibc_for_ecd_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Value for'
        status_text += ' Empty Can Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'tibc_for_ecd_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Error for'
        status_text += ' Empty Can Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
    ENDIF
    
    
    ;get Time-independent Background Constant for Empty Can Data
    ;  IF (isButtonSelected(Event,'tibc_for_scatd_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    IF (isButtonSelected(Event,'tibc_for_scatd_button')) THEN BEGIN
      cmd += ' --tib-dsback-const='
      
      TIBCV = getTextFieldValue(Event,'tibc_for_scatd_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Value for'
        status_text += ' Scattering Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'tibc_for_scatd_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background' + $
          ' Constant Error for'
        status_text += ' Scattering Data'
        IF (tab4 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab4 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab4
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
    ENDIF
    
    ;;add a white space
    ;putInfoInCommandLineStatus, Event, '', 1
    
    ;*************TAB5*************************************************************
    TabName = 'Tab#5 - LAMBDA DEPENDENT BACKGROUND SUBTRACTION'
    tab5    = 0
    
    ;check if use iterative background subtraction is active or not
    ibs_value = getCWBgroupValue(Event, $
      'use_iterative_background_subtraction_cw_bgroup')
      
    IF (ibs_value EQ 1) THEN BEGIN ;if Iterative Background Subtraction is OFF
      scale_constant = $
        getTextFieldValue(Event, $
        'scale_constant_lambda_dependent_back_uname')
      IF (scale_constant NE '') THEN BEGIN
        activate_base = 1
        cmd += ' --ldb-const=' + STRCOMPRESS(scale_constant,/REMOVE_ALL) + $
          ',0.0'
      ENDIF ELSE BEGIN
        activate_base = 0
      ENDELSE
      SensitiveBase, Event, $
        'scale_constant_lambda_dependent_input_base', $
        activate_base
        
      IF (activate_base) THEN BEGIN ;need the input information
      
        ;Chopper Frequency
        value = getTextFieldValue(Event,'chopper_frequency_value')
        cmd += ' --chopper-freq='
        IF (Value EQ '') THEN BEGIN
          cmd += '?,0.0'
          status_text = '   -Please provide a Chopper Frequency'
          IF (tab5 EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, '', 1
            putInfoInCommandLineStatus, Event, '', 1
          ENDIF
          IF (tab5 EQ 0 AND $
            StatusMessage EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 0
          ENDIF
          IF (tab5 EQ 0 AND $
            StatusMessage NE 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 1
          ENDIF
          putInfoInCommandLineStatus, Event, status_text, 1
          StatusMessage += 1
          ++tab5
        ENDIF ELSE BEGIN
          cmd += strcompress(Value,/remove_all) + ',0.0'
        ENDELSE
        
        ;Chopper Wavelength Center
        value = getTextFieldValue(Event,'chopper_wavelength_value')
        cmd += ' --chopper-lambda-cent='
        IF (Value EQ '') THEN BEGIN
          cmd += '?,0.0'
          status_text = '   -Please provide a Chopper Wavelength Center'
          IF (tab5 EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, '', 1
            putInfoInCommandLineStatus, Event, '', 1
          ENDIF
          IF (tab5 EQ 0 AND $
            StatusMessage EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 0
          ENDIF
          IF (tab5 EQ 0 AND $
            StatusMessage NE 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 1
          ENDIF
          putInfoInCommandLineStatus, Event, status_text, 1
          StatusMessage += 1
          ++tab5
        ENDIF ELSE BEGIN
          cmd += strcompress(Value,/remove_all) + ',0.0'
        ENDELSE
        
        ;TOF Least Background
        value = getTextFieldValue(Event,'tof_least_background_value')
        cmd += ' --tof-least-bkg='
        IF (Value EQ '') THEN BEGIN
          cmd += '?,0.0'
          status_text = '   -Please provide a TOF Least Background'
          IF (tab5 EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, '', 1
            putInfoInCommandLineStatus, Event, '', 1
          ENDIF
          IF (tab5 EQ 0 AND $
            StatusMessage EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 0
          ENDIF
          IF (tab5 EQ 0 AND $
            StatusMessage NE 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 1
          ENDIF
          putInfoInCommandLineStatus, Event, status_text, 1
          StatusMessage += 1
          ++tab5
        ENDIF ELSE BEGIN
          cmd += strcompress(Value,/remove_all) + ',0.0'
        ENDELSE
        
      ENDIF
      
    ENDIF ELSE BEGIN ;if Iterative Background Subtraction is ON
    
      ;Chopper Frequency
      value = getTextFieldValue(Event,'chopper_frequency_value')
      cmd += ' --chopper-freq='
      IF (Value EQ '') THEN BEGIN
        cmd += '?,0.0'
        status_text = '   -Please provide a Chopper Frequency'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all) + ',0.0'
      ENDELSE
      
      ;Chopper Wavelength Center
      value = getTextFieldValue(Event,'chopper_wavelength_value')
      cmd += ' --chopper-lambda-cent='
      IF (Value EQ '') THEN BEGIN
        cmd += '?,0.0'
        status_text = '   -Please provide a Chopper Wavelength Center'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all) + ',0.0'
      ENDELSE
      
      ;TOF Least Background
      value = getTextFieldValue(Event,'tof_least_background_value')
      cmd += ' --tof-least-bkg='
      IF (Value EQ '') THEN BEGIN
        cmd += '?,0.0'
        status_text = '   -Please provide a TOF Least Background'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all) + ',0.0'
      ENDELSE
      
      ;positive transverse energy integration range .................................
      cmd += ' --et-int-range='
      ;min value
      min_value = getTextFieldValue(Event,'pte_min_text')
      IF (min_value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Minimum Transverse Energy' + $
          ' Integration Value'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += strcompress(min_value,/remove_all)
      ENDELSE
      
      ;max value
      max_value = getTextFieldValue(Event,'pte_max_text')
      IF (max_value EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Maximum Transverse Energy' + $
          ' Integration Value'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(max_value,/remove_all)
      ENDELSE
      
      ;width value
      width_value = getTextFieldValue(Event,'pte_bin_text')
      IF (width_value EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Width Transverse Energy' + $
          ' Integration Value'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(width_value,/remove_all)
      ENDELSE
      
      cmd += ',linear'
      
      ;detailed balance temperature .................................................
      cmd += ' --detbal-temp='
      temp_value = getTextFieldValue(Event,'detailed_balance_temperature_value')
      IF (temp_value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Detailed Balance Temperature ' + $
          'Value'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += strcompress(temp_value,/remove_all)
      ENDELSE
      
      ;Ratio Tolerance ..............................................................
      cmd += ' --tol='
      ratio_value = getTextFieldValue(Event,'ratio_tolerance_value')
      IF (ratio_value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Ratio Tolerance Value'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += strcompress(ratio_value,/remove_all)
      ENDELSE
      
      ;Number of Iteration ..........................................................
      ni_value = getTextFieldValue(Event,'number_of_iteration')
      IF (STRCOMPRESS(ni_value,/REMOVE_ALL) NE '20') THEN BEGIN
        cmd += ' --niter=' + ni_value
      ENDIF
      
      ;Minimum Wavlength Dependent Background Constant ..............................
      mw_value = getTextFieldValue(Event,'min_wave_dependent_back')
      IF (STRCOMPRESS(mw_value,/REMOVE_ALL) NE '0.0') THEN BEGIN
        cmd += ' --cwdb-min=' + mw_value
      ENDIF
      
      ;Maximum Wavlength Dependent Background Constant ..............................
      cmd += ' --cwdb-max='
      max_value = getTextFieldValue(Event,'max_wave_dependent_back')
      IF (max_value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Maximum Wavelength-Dependent ' + $
          'Background Constant Value'
        IF (tab5 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab5 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab5
      ENDIF ELSE BEGIN
        cmd += strcompress(max_value,/remove_all)
      ENDELSE
      
      ;Small Wavlength Dependent Background Constant ................................
      small_value = getTextFieldValue(Event,'small_wave_dependent_back')
      IF (STRCOMPRESS(small_value,/REMOVE_ALL) NE '1.0E-14') THEN BEGIN
        cmd += ' --cwdb-small=' + small_value
      ENDIF
      
      verbosity_value = getCWBgroupValue(Event, $
        'amorphous_reduction_verbosity_cw_bgroup')
      IF(verbosity_value) THEN BEGIN
        cmd += ' --amr-verbose'
      ENDIF
      
    ENDELSE
    
    ;*************TAB6*****************
    TabName = 'Tab#6 - SCALLING CONTROL'
    tab6    = 0
    
    ;get constant to scale the back. spectra for subtraction from the
    ;sample data spectra
    ;  IF (isButtonSelected(Event,'csbss_button')) THEN BEGIN
    ;   ENDIF ELSE BEGIN
    ;   ENDELSE
    IF (isButtonSelected(Event,'csbss_button')) THEN BEGIN
      cmd += ' --scale-bs='
      
      Value = getTextFieldValue(Event,'csbss_value_text')
      IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background' + $
          ' for Subtraction from the Sample Data Value'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all)
      ENDELSE
      
      Error = getTextFieldValue(Event,'csbss_error_text')
      IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background' + $
          ' for Subtraction from the Sample Data Error'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(Error,/remove_all)
      ENDELSE
    ENDIF
    
    ;get constant to scale the back. spectra for subtraction from the
    ;normalization data spectra
    ;  IF (isButtonSelected(Event,'csn_button')) THEN BEGIN
    ;  ENDIF ELSE BEGIN
    ;  ENDELSE
    IF (isButtonSelected(Event,'csn_button')) THEN BEGIN
      cmd += ' --scale-bn='
      
      Value = getTextFieldValue(Event,'csn_value_text')
      IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background' + $
          ' for Subtraction from the normalization Data Value'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all)
      ENDELSE
      
      Error = getTextFieldValue(Event,'csn_error_text')
      IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background' + $
          ' for Subtraction from the Normalization Data Error'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(Error,/remove_all)
      ENDELSE
    ENDIF
    
    
    ;get constant to scale the back. spectra for subtraction from the
    ;sample data associated empty container spectra
    IF (isButtonSelected(Event,'bcs_button')) THEN BEGIN
      cmd += ' --scale-bcs='
      
      Value = getTextFieldValue(Event,'bcs_value_text')
      IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background' + $
          ' for Subtraction from the Sample Data Associated Empty ' + $
          'Container Value'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all)
      ENDELSE
      
      Error = getTextFieldValue(Event,'bcs_error_text')
      IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background ' + $
          'for Subtraction from the Sample Data Associated Empty ' + $
          'Container Error'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(Error,/remove_all)
      ENDELSE
      
    ENDIF
    
    ;get constant to scale the back. spectra for subtraction from the
    ;normalization data associated empty container spectra
    IF (isButtonSelected(Event,'bcn_button')) THEN BEGIN
      cmd += ' --scale-bcn='
      
      Value = getTextFieldValue(Event,'bcn_value_text')
      IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background' + $
          ' for Subtraction from the Normalization Data Associated Empty ' + $
          'Container Value'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all)
      ENDELSE
      
      Error = getTextFieldValue(Event,'bcn_error_text')
      IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background ' + $
          'for Subtraction from the Normalization Data Associated Empty ' + $
          'Container Error'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(Error,/remove_all)
      ENDELSE
    ENDIF
    
    
    ;get constant to scale the Empty Container for subtraction from
    ;the sample data
    IF (isButtonSelected(Event,'cs_button')) THEN BEGIN
      cmd += ' --scale-cs='
      
      Value = getTextFieldValue(Event,'cs_value_text')
      IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale the Empty' + $
          ' Container for Subtraction from the Sample Data Value'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all)
      ENDELSE
      
      Error = getTextFieldValue(Event,'cs_error_text')
      IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale the Empty' + $
          ' Container for Subtraction from the Sample Data Error'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(Error,/remove_all)
      ENDELSE
    ENDIF
    
    
    ;get constant to scale the Empty Container for subtraction from
    ;the normalization data
    IF (isButtonSelected(Event,'cn_button')) THEN BEGIN
      cmd += ' --scale-cn='
      
      Value = getTextFieldValue(Event,'cn_value_text')
      IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale the Empty' + $
          ' Container for Subtraction from the Normalization Data Value'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += strcompress(Value,/remove_all)
      ENDELSE
      
      Error = getTextFieldValue(Event,'cn_error_text')
      IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale the Empty' + $
          ' Container for Subtraction from the Normalization Data Error'
        IF (tab6 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab6 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab6
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(Error,/remove_all)
      ENDELSE
    ENDIF
    
    ;*************TAB7*****************
    TabName = 'Tab#7 - DATA CONTROL'
    tab7    = 0
    
    ;check if use iterative background subtraction is active or not
    ibs_value = getCWBgroupValue(Event, $
      'use_iterative_background_subtraction_cw_bgroup')
      
    IF (ibs_value EQ 1) THEN BEGIN ;if Iterative Background Subtraction is OFF
      ;constant for scaling the final data spectrum
      IF (isButtonSelected(Event,'csfds_button')) THEN BEGIN
        cmd += ' --rescale-final='
        
        Value = getTextFieldValue(Event,'csfds_value_text')
        IF (Value EQ '') THEN BEGIN
          cmd += '?'
          status_text = '   -Please provide a Constant for Scaling' + $
            ' the Final' + $
            ' Data Spectrum'
          IF (tab7 EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, '', 1
            putInfoInCommandLineStatus, Event, '', 1
          ENDIF
          IF (tab7 EQ 0 AND $
            StatusMessage EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 0
          ENDIF
          IF (tab7 EQ 0 AND $
            StatusMessage NE 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 1
          ENDIF
          putInfoInCommandLineStatus, Event, status_text, 1
          StatusMessage += 1
          ++tab7
        ENDIF ELSE BEGIN
          cmd += strcompress(Value,/remove_all)
        ENDELSE
      ENDIF
    ENDIF
    
    ;get Time Zero Slope Parameter
    IF (isButtonSelected(Event,'tzsp_button')) THEN BEGIN
      cmd += ' --time-zero-slope='
      
      TIBCV = getTextFieldValue(Event,'tzsp_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Zero Slope Parameter Value'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'tzsp_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Zero Slope Parameter Error'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
      
    ENDIF
    
    ;get Time Zero Offset Parameter
    IF (isButtonSelected(Event,'tzop_button')) THEN BEGIN
      cmd += ' --time-zero-offset='
      
      TIBCV = getTextFieldValue(Event,'tzop_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Zero Offset Parameter Value'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'tzop_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Zero Offset Parameter Error'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
      
    ENDIF
    
    ;get Energy Histogram Axis
    cmd += ' --energy-bins='
    
    TIBCMin = getTextFieldValue(Event,'eha_min_text')
    IF (TIBCMin EQ '') THEN BEGIN
      cmd += '?'
      status_text = '   -Please provide a Energy Histogram Axis Min'
      IF (tab7 EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, '', 1
        putInfoInCommandLineStatus, Event, '', 1
      ENDIF
      IF (tab7 EQ 0 AND $
        StatusMessage EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 0
      ENDIF
      IF (tab7 EQ 0 AND $
        StatusMessage NE 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 1
      ENDIF
      putInfoInCommandLineStatus, Event, status_text, 1
      StatusMessage += 1
      ++tab7
    ENDIF ELSE BEGIN
      cmd += strcompress(TIBCMin,/remove_all)
    ENDELSE
    
    TIBCMax = getTextFieldValue(Event,'eha_max_text')
    IF (TIBCMax EQ '') THEN BEGIN
      cmd += ',?'
      status_text = '   -Please provide a Energy Histogram Axis Max'
      IF (tab7 EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, '', 1
        putInfoInCommandLineStatus, Event, '', 1
      ENDIF
      IF (tab7 EQ 0 AND $
        StatusMessage EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 0
      ENDIF
      IF (tab7 EQ 0 AND $
        StatusMessage NE 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 1
      ENDIF
      putInfoInCommandLineStatus, Event, status_text, 1
      StatusMessage += 1
      ++tab7
    ENDIF ELSE BEGIN
      cmd += ',' + strcompress(TIBCMax,/remove_all)
    ENDELSE
    
    TIBCBin = getTextFieldValue(Event,'eha_bin_text')
    IF (TIBCBin EQ '') THEN BEGIN
      cmd += ',?'
      status_text = '   -Please provide a Energy Histogram Axis Bin'
      IF (tab7 EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, '', 1
        putInfoInCommandLineStatus, Event, '', 1
      ENDIF
      IF (tab7 EQ 0 AND $
        StatusMessage EQ 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 0
      ENDIF
      IF (tab7 EQ 0 AND $
        StatusMessage NE 0) THEN BEGIN
        putInfoInCommandLineStatus, Event, TabName, 1
      ENDIF
      putInfoInCommandLineStatus, Event, status_text, 1
      StatusMessage += 1
      ++tab7
    ENDIF ELSE BEGIN
      cmd += ',' + strcompress(TIBCBin,/remove_all)
    ENDELSE
    
    ;get Global Instrument Final Wavelength
    IF (isButtonSelected(Event,'gifw_button')) THEN BEGIN
      cmd += ' --final-wavelength='
      
      TIBCV = getTextFieldValue(Event,'gifw_value_text')
      IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Global Instrument Final ' + $
          'Wavelength Value'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
      ENDELSE
      
      TIBCE = getTextFieldValue(Event,'gifw_error_text')
      IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Global Instrument Final ' + $
          'Wavelength Error'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
      ENDELSE
    ENDIF
    
    ;Momentum transfer Histogram Axis or Negative Cosine Polar Axis --------------
    
    ;check if use iterative background subtraction is active or not
    ibs_value = getCWBgroupValue(Event, $
      'use_iterative_background_subtraction_cw_bgroup')
      
    IF (ibs_value EQ 0) THEN BEGIN ;if Iterative Background Subtraction is ON
    
      Qmin = getTextFieldValue(Event,'mtha_min_text')
      Qmax = getTextFieldValue(Event,'mtha_max_text')
      Qbin = getTextFieldValue(Event,'mtha_bin_text')
      ;check that all three fields are not empty
      IF (Qmin NE '?' AND $
        Qmax NE '?' AND $
        Qbin NE '?') THEN BEGIN
        result = CreateQaxis(Qmin,Qmax,Qbin,Qaxis) ;_math
        IF (result EQ 1) THEN BEGIN ;success
          job_number = N_ELEMENTS(Qaxis)-1
        ENDIF ELSE BEGIN        ;failed to create the Qaxis
          status_text = '   -Please Check the format of the ' + $
            'Momentum Transfer Histogram Axis'
          IF (tab7 EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, '', 1
            putInfoInCommandLineStatus, Event, '', 1
          ENDIF
          IF (tab7 EQ 0 AND $
            StatusMessage EQ 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 0
          ENDIF
          IF (tab7 EQ 0 AND $
            StatusMessage NE 0) THEN BEGIN
            putInfoInCommandLineStatus, Event, TabName, 1
          ENDIF
          putInfoInCommandLineStatus, Event, status_text, 1
          StatusMessage += 1
          ++tab7
          cmd += ' --mom-trans-bin='
          job_number = 1
          cmd += Qmin
          cmd += ',' + Qmax
          cmd += ',' + Qbin
        ENDELSE
      ENDIF ELSE BEGIN
        cmd += ' --mom-trans-bin='
        job_number = 1
        cmd += Qmin
        cmd += ',' + Qmax
        cmd += ',' + Qbin
      ENDELSE
      
    ENDIF ELSE BEGIN
    
      ;check status of flag: Momentum Transfer Histogram or Negative Cosine Polar
      ButtonValue = getButtonValue(Event,'mtha_button')
      IF (ButtonValue EQ 0) THEN BEGIN ;Momentum Transfer Histogram Axis
        cmd += ' --mom-trans-bin='
        missing_info_title = 'Momentum Transfer Histogram'
      ENDIF ELSE BEGIN
        cmd += ' --ncos-polar-bins='
        missing_info_title = 'Negative Cosine Polar'
      ENDELSE
      
      TIBCMin = getTextFieldValue(Event,'mtha_min_text')
      IF (TIBCMin EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a ' + missing_info_title + $
          ' Axis Min'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += strcompress(TIBCMin,/remove_all)
      ENDELSE
      
      TIBCMax = getTextFieldValue(Event,'mtha_max_text')
      IF (TIBCMax EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a ' + missing_info_title + $
          ' Axis Max'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCMax,/remove_all)
      ENDELSE
      
      TIBCBin = getTextFieldValue(Event,'mtha_bin_text')
      IF (TIBCBin EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a ' + missing_info_title + $
          ' Axis Bin'
        IF (tab7 EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, '', 1
          putInfoInCommandLineStatus, Event, '', 1
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage EQ 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 0
        ENDIF
        IF (tab7 EQ 0 AND $
          StatusMessage NE 0) THEN BEGIN
          putInfoInCommandLineStatus, Event, TabName, 1
        ENDIF
        putInfoInCommandLineStatus, Event, status_text, 1
        StatusMessage += 1
        ++tab7
      ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCBin,/remove_all)
      ENDELSE
      
      job_number = 1
      
    ENDELSE
    
    ;get time of flight range -----------------------------------------------------
    IF (isButtonSelected(Event,'tof_cutting_button')) THEN BEGIN
    
      MinValue = getTextFieldValue(Event,'tof_cutting_min_text')
      IF (MinValue NE '') THEN BEGIN
        cmd += ' --tof-cut-min='
        cmd += STRCOMPRESS(MinValue,/REMOVE_ALL)
      ENDIF
      
      MaxValue = getTextFieldValue(Event,'tof_cutting_max_text')
      IF (MaxValue NE '') THEN BEGIN
        cmd += ' --tof-cut-max='
        cmd += STRCOMPRESS(MaxValue,/REMOVE_ALL)
      ENDIF
      
    ENDIF
    
    ;Scale S(Q,E) by the solid angle distribution
    IF (isButtonSelected(Event,'scale_sqe_by_solid_angle_group_uname') AND $
      isButtonEnabled(Event, 'scale_sqe_by_solid_angle_base_uname')) THEN BEGIN
      cmd += ' --scale-sqe'
    ENDIF
    
    ;add a white space
    putInfoInCommandLineStatus, Event, '', 1
    
    ;************TAB8******************
    
    ;check if use iterative background subtraction is active or not
    ibs_value = getCWBgroupValue(Event, $
      'use_iterative_background_subtraction_cw_bgroup')
      
    IF (ibs_value EQ 1) THEN BEGIN ;if Iterative Background Subtraction is OFF
      TabName = 'Tab#8 - INTERMEDIATE OUTPUT'
      tab8    = 0
      
      ;Write all Intermediate Output
      IF (isButtonSelected(Event,'waio_button')) THEN BEGIN
        cmd += ' --dump-all'
      ENDIF else begin
      
        ;Write out Calculated Time-Independent Background
        IF (isButtonSelected(Event,'woctib_button') AND $
          isButtonSelected(Event,'tib_tof_button')) THEN BEGIN
          cmd += ' --dump-tib'
        endif
        
        ;Write out Pixel Wavelength Spectra
        IF (isButtonSelected(Event,'wopws_button')) THEN BEGIN
          cmd += ' --dump-wave'
        endif
        
        ;Write out Monitor Wavelength Spectrum
        IF (isButtonSelected(Event,'womws_button') AND $
          isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
          cmd += ' --dump-mon-wave'
        endif
        
        ;Write out Monitor Efficiency Spectrum
        IF (isButtonSelected(Event,'womes_button') AND $
          isButtonUnselected(Event,'nmn_button') AND $
          isButtonUnselected(Event,'nmec_button')) THEN BEGIN
          cmd += ' --dump-mon-effc'
        endif
        
        ;Write out Rebinned Monitor Spectra
        IF (isButtonSelected(Event,'worms_button') AND $
          isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
          cmd += ' --dump-mon-rebin'
        endif
        
        ;Write out Combined Pixel Spectrum After Monitor Normalization
        IF (isButtonSelected(Event,'wocpsamn_button') AND $
          isButtonUnSelected(Event,'nmn_button'))  THEN BEGIN
        endif
      endelse
      
      IF (isButtonSelected(Event,'wocpsamn_button') AND $
        isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
        
        IF (~isButtonSelected(Event,'waio_button')) THEN BEGIN
          cmd += ' --dump-wave-mnorm'
        endif
        
        WAmin = getTextFieldValue(Event,'wa_min_text')
        WAmax = getTextFieldValue(Event,'wa_max_text')
        WABwidth = getTextFieldValue(Event,'wa_bin_width_text')
        
        IF (WAMIN NE '' OR $
          WAMAX NE '' OR $
          WABwidth NE '') THEN BEGIN
          
          cmd += ' --lambda-bins='
          
          IF (WAmin EQ '') THEN BEGIN
            cmd += '?'
            status_text = '   -Please provide a Wavelength Histogram' + $
              ' Min Value'
            IF (tab8 EQ 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, '', 1
            ENDIF
            IF (tab8 EQ 0 AND $
              StatusMessage EQ 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, TabName, 0
            ENDIF
            IF (tab8 EQ 0 AND $
              StatusMessage NE 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, TabName, 1
            ENDIF
            putInfoInCommandLineStatus, Event, status_text, 1
            StatusMessage += 1
            ++tab8
          ENDIF ELSE BEGIN
            cmd += strcompress(WAmin,/remove_all)
          ENDELSE
          
          
          IF (WAmax EQ '') THEN BEGIN
            cmd += ',?'
            status_text = '   -Please provide a Wavelength Histogram' + $
              ' Max Value'
            IF (tab8 EQ 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, '', 1
            ENDIF
            IF (tab8 EQ 0 AND $
              StatusMessage EQ 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, TabName, 0
            ENDIF
            IF (tab8 EQ 0 AND $
              StatusMessage NE 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, TabName, 1
            ENDIF
            putInfoInCommandLineStatus, Event, status_text, 1
            StatusMessage += 1
            ++tab8
          ENDIF ELSE BEGIN
            cmd += ',' + strcompress(WAmax,/remove_all)
          ENDELSE
          
          IF (WABwidth EQ '') THEN BEGIN
            cmd += ',?'
            status_text = '   -Please provide a Wavelength Histogram' + $
              ' Bin ' + $
              'Width Value'
            IF (tab8 EQ 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, '', 1
            ENDIF
            IF (tab8 EQ 0 AND $
              StatusMessage EQ 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, TabName, 0
            ENDIF
            IF (tab8 EQ 0 AND $
              StatusMessage NE 0) THEN BEGIN
              putInfoInCommandLineStatus, Event, TabName, 1
            ENDIF
            putInfoInCommandLineStatus, Event, status_text, 1
            StatusMessage += 1
            ++tab8
          ENDIF ELSE BEGIN
            cmd += ',' + strcompress(WABwidth,/remove_all)
          ENDELSE
        ENDIF
      ENDIF
      
      IF (~isButtonSelected(Event,'waio_button')) THEN BEGIN
      
        ;Write out Linearly Interpolated Direct Scattering Back. Info. Summed
        ;over all Pixels
        IF (isButtonSelected(Event,'wolidsb_button')) THEN BEGIN
          cmd += ' --dump-dslin'
        endif
        
      ENDIF
      
      IF (~isButtonSelected(Event,'waio_button')) THEN BEGIN
        ; Write out Pixel Wavelength Spectra After Vanadium Normalization -------------
        IF (isButtonSelected(Event,'pwsavn_button')) THEN BEGIN
          cmd += ' --dump-norm'
        endif
      ENDIF
      
      ;check if use iterative background subtraction is active or not
      ButtonValue = getButtonValue(Event,'mtha_button')
      
      IF (isButtonSelected(Event,'sad') AND $
        ButtonValue EQ 0) THEN BEGIN
        cmd += ' --dump-pix-contrib'
      endif
      
    ENDIF ;end of intermediate tab
    
    ;get Output File Name and folder
    ;  OFile =  getTextFieldValue(Event,'bdf_run_number_cw_field')
    ;  IF (nbr GE 1) THEN BEGIN
    ;    IF (array_split[0] EQ 1) THEN BEGIN ;remove first '/'
    ;      string_split = STRSPLIT(OFile,'/',/EXTRACT)
    ;      OFile = STRJOIN(string_split,'/')
    ;      putTextFieldValue, Event, 'of_list_of_runs_text', OFile, 0
    ;    ENDIF
    ;  ENDIF
    ;get output folder name
    output_folder = (*global).default_output_path
    _run_numbers = RSDFiles[index_run]
    ;replace ',' by '_' if any
    run_array = strsplit(_run_numbers,',',/extract)
    _run_numbers = strjoin(run_array,'_')
    oFile = 'BSS_' + _run_numbers
    ;add time stamp
    ts = GenerateIsoTimeStamp()
    oFile += '_' + ts
    
    ;check if we have only 1 job to launch or several ones
    IF (job_number GT 1) THEN BEGIN ;create the array of jobs
      new_cmd = CreateArrayOfJobs(Event,$
        cmd, $ ;_iterative_back
        Qaxis       = Qaxis, $
        output_path = output_folder,$
        output_name = OFile,$
        output_flag = ' --output=',$
        Qbin        = Qbin, $
        NBR_JOBS    = job_number, $
        FLAG        = ' --mom-trans-bin=')
      cmd = new_cmd
    ENDIF ELSE BEGIN
      cmd += ' --output=' + output_folder
      IF (OFile NE '') THEN BEGIN
        cmd += OFile + '.txt'
      ENDIF
    ENDELSE
    
    cmd_array = [cmd_array,cmd]
    
    index_run++
  endwhile
  
  ;display command line in Reduce text box
  putTextFieldValue, Event, 'command_line_generator_text', cmd_array, 0
  
  ;validate or not Go data reduction button
  IF (StatusMessage NE 0) THEN BEGIN ;do not activate button
    activate = 0
  ENDIF ELSE BEGIN
    activate = 1
  ENDELSE
  
  Activate_button, Event, 'submit_button', activate
  activate_button, event, 'submit_batch_button', activate
  
  ;generate new command line file name
  generate_command_line_file_name, Event
  
END
