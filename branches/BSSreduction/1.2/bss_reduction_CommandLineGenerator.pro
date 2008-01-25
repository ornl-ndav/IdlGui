PRO BSSreduction_CommandLineGenerator, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;this function update all the reduce widgets (validate or not)
BSSreduction_ReduceUpdateGui, Event

StatusMessage = 0 ;will increase by 1 each time a field is missing

cmd = (*global).DriverName + ' ' ;name of function to call

;****TAB1****

TabName = 'Tab#1 - INPUT DATA SETUP (1)'
tab1    = 0
;get Raw Sample Data Files
RSDFiles = getTextFieldValue(Event, 'rsdf_list_of_runs_text')
(*global).Configuration.Reduce.tab1.rsdf_list_of_runs_text = RSDFiles
IF (RSDFiles NE '') THEN BEGIN
    cmd += ' ' + strcompress(RSDFiles,/remove_all)
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
BDFiles = getTextFieldValue(Event,'bdf_list_of_runs_text')
(*global).Configuration.Reduce.tab1.bdf_list_of_runs_text = BDFiles
IF (BDFiles NE '') THEN BEGIN
    cmd += ' --back=' + BDFiles
ENDIF

;get Normalization Data File
NDFiles = getTextFieldValue(Event,'ndf_list_of_runs_text')
(*global).Configuration.Reduce.tab1.ndf_list_of_runs_text = NDFiles
IF (NDFiles NE '') THEN BEGIN
    cmd += ' --norm=' + NDFiles
ENDIF

;get Empty Can Data File
ECDFiles = getTextFieldValue(Event,'ecdf_list_of_runs_text')
(*global).Configuration.Reduce.tab1.ecdf_list_of_runs_text= ECDFiles
IF (ECDFiles NE '') THEN BEGIN
    cmd += ' --ecan=' + ECDFiles
ENDIF

;get Direct Scattering Background
DSBFiles = getTextFieldValue(Event,'dsb_list_of_runs_text')
(*global).Configuration.Reduce.tab1.dsb_list_of_runs_text= DSBFiles
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
(*global).Configuration.Reduce.tab2.proif_text= PRoIFIle
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
    ++tab1
ENDELSE

;get Alternate Instrument Geometry
AIGFile = getTextFieldValue(Event,'aig_list_of_runs_text')
(*global).Configuration.Reduce.tab2.aig_list_of_runs_text = AIGFile
IF (AIGFile NE '') THEN BEGIN
    cmd += ' --inst_geom=' + AIGFile
ENDIF

;get Output File Name
OFile = getTextFieldValue(Event,'of_list_of_runs_text')
(*global).Configuration.Reduce.tab2.of_list_of_runs_text = OFile
IF(OFile NE '') THEN BEGIN
    cmd += ' --output=' + OFile
ENDIF

;****TAB3****

TabName = 'Tab#3 - PROCESS SETUP'
tab3 = 0
;get Run McStas NeXus Files status
IF (isButtonSelected(Event,'rmcnf_button')) THEN BEGIN
    cmd += ' --mc'
    (*global).Configuration.Reduce.tab3.rmcnf_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab3.rmcnf_button= 0
ENDELSE

;get Verbose status
IF (isButtonSelected(Event,'verbose_button')) THEN BEGIN
    cmd += ' --verbose'
    (*global).Configuration.Reduce.tab3.verbose_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab3.verbose_button= 0
ENDELSE

;get Alternate Background Subtraction Method
IF (isButtonSelected(Event,'absm_button')) THEN BEGIN
    cmd += ' --hwfix'
    (*global).Configuration.Reduce.tab3.absm_button= 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab3.absm_button = 0
ENDELSE

;get No Monitor Normalization
IF (isButtonSelected(Event,'nmn_button')) THEN BEGIN
    na_base_status = 1
    cmd += ' --no-mon-norm'
    (*global).Configuration.Reduce.tab3.nmn_button = 1
ENDIF ELSE BEGIN
    na_base_status = 0
    (*global).Configuration.Reduce.tab3.nmn_button = 0
ENDELSE
activate_base, event, 'na_womwsbase', na_base_status
activate_base, event, 'na_wormsbase', na_base_status
activate_base, event, 'na_wocpsamnbase', na_base_status
activate_base, event, 'na_wodwsmbase', na_base_status

IF (na_base_status) then begin
    BSSreduction_EnableOrNotFields, Event, 'wocpsamn_button', 0
endif else begin
    BSSreduction_EnableOrNotFields, Event, 'wocpsamn_button'
endelse

;get No Monitor Efficiency Correction
IF (isButtonSelected(Event,'nmec_button')) THEN BEGIN
    cmd += ' --no-mon-effc'
    (*global).Configuration.Reduce.tab3.nmec_button= 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab3.nmec_button = 0
ENDELSE

;if --no-mon-norm is not set or
;   --no-mon-effc is not set then validate --mon-effc
IF (isButtonSelected(Event,'nmn_button') EQ 0 OR $
    isButtonSelected(Event,'nmec_button') EQ 0) THEN BEGIN
    na_base_status = 0
ENDIF ELSE BEGIN
    na_base_status = 1
ENDELSE
activate_base, event, 'na_womesbase', na_base_status

;get Normalization Integration Wavelength
IF (isButtonSelected(Event,'niw_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab3.niw_button= 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab3.niw_button= 0
ENDELSE

IF (isButtonSelected(Event,'niw_button') AND $
    NDFiles NE '') THEN BEGIN
    
;get Normalization Integration Start Wavelength
    NISW = getTextFieldValue(Event,'nisw_field')
    (*global).Configuration.Reduce.tab3.nisw_field = NISW
    IF(NISW NE '') THEN BEGIN
        cmd += ' --norm-start=' + strcompress(NISW,/remove_all)
    ENDIF
    
;get Normalization Integration End Wavelength
    NIEW = getTextFieldValue(Event,'niew_field')
    (*global).Configuration.Reduce.tab3.niew_field = NIEW
    IF(NIEW NE '') THEN BEGIN
        cmd += ' --norm-end=' + strcompress(NIEW,/remove_all)
    ENDIF
ENDIF

IF (isButtonSelected(Event,'te_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab3.te_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab3.te_button = 0
ENDELSE

IF (isButtonSelected(Event,'te_button') AND $
    DSBFiles NE '') THEN BEGIN

;sample data file
    TEL = getTextFieldValue(Event,'te_low_field')
    (*global).Configuration.Reduce.tab3.te_low_field = TEL
    TEH = getTextFieldValue(Event,'te_high_field')
    (*global).Configuration.Reduce.tab3.te_high_field = TEH
	        
    cmd += ' --tof-elastic='
    
    IF (TEL EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Low Value that Bracket the Elastic Peak'
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
        status_text = '   -Please provide a High Value that Bracket the Elastic Peak'
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

IF (isButtonSelected(Event,'tib_tof_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab4.tib_tof_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab4.tib_tof_button = 0
ENDELSE

;get Time-Independent Background TOF channels
IF (isButtonSelected(Event,'tib_tof_button')) THEN BEGIN
    
    TIBTOF1 = getTextFieldValue(Event,'tibtof_channel1_text')
    TIBTOF2 = getTextFieldValue(Event,'tibtof_channel2_text')
    TIBTOF3 = getTextFieldValue(Event,'tibtof_channel3_text')
    TIBTOF4 = getTextFieldValue(Event,'tibtof_channel4_text')

    (*global).Configuration.Reduce.tab4.tibtof_channel1_text = TIBTOF1
    (*global).Configuration.Reduce.tab4.tibtof_channel2_text = TIBTOF2
    (*global).Configuration.Reduce.tab4.tibtof_channel3_text = TIBTOF3
    (*global).Configuration.Reduce.tab4.tibtof_channel4_text = TIBTOF4

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
        putInfoInCommandLineStatus, Event, status_text, 1
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
IF (isButtonSelected(Event,'tibc_for_sd_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_sd_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_sd_button = 0
ENDELSE

IF (isButtonSelected(Event,'tibc_for_sd_button')) THEN BEGIN
    cmd += ' --tib-data-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_sd_value_text')
    (*global).Configuration.Reduce.tab4.tibc_for_sd_value_text = TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background Constant Value for' 
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
    (*global).Configuration.Reduce.tab4.tibc_for_sd_error_text = TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background Constant Error for' 
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
IF (isButtonSelected(Event,'tibc_for_bd_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_bd_button= 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_bd_button= 0
ENDELSE
IF (isButtonSelected(Event,'tibc_for_bd_button')) THEN BEGIN
    cmd += ' --tib-back-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_bd_value_text')
    (*global).Configuration.Reduce.tab4.tibc_for_bd_value_text= TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background Constant Value for' 
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
    (*global).Configuration.Reduce.tab4.tibc_for_bd_error_text= TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background Constant Error for' 
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
IF (isButtonSelected(Event,'tibc_for_nd_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_nd_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_nd_button = 0
ENDELSE
IF (isButtonSelected(Event,'tibc_for_nd_button')) THEN BEGIN
    cmd += ' --tib-norm-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_nd_value_text')
        (*global).Configuration.Reduce.tab4.tibc_for_nd_value_text = TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background Constant Value for'
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
        (*global).Configuration.Reduce.tab4.tibc_for_nd_error_text = TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background Constant Error for' 
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
IF (isButtonSelected(Event,'tibc_for_ecd_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_ecd_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_ecd_button = 0
ENDELSE
IF (isButtonSelected(Event,'tibc_for_ecd_button')) THEN BEGIN
    cmd += ' --tib-ecan-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_ecd_value_text')
    (*global).Configuration.Reduce.tab4.tibc_for_ecd_value_text= TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background Constant Value for'
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
    (*global).Configuration.Reduce.tab4.tibc_for_ecd_error_text = TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background Constant Error for' 
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
IF (isButtonSelected(Event,'tibc_for_scatd_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_scatd_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab4.tibc_for_scatd_button = 0
ENDELSE
IF (isButtonSelected(Event,'tibc_for_scatd_button')) THEN BEGIN
    cmd += ' --tib-dsback-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_scatd_value_text')
    (*global).Configuration.Reduce.tab4.tibc_for_scatd_value_text = TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Independent Background Constant Value for'
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
    (*global).Configuration.Reduce.tab4.tibc_for_scatd_error_text = TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Independent Background Constant Error for' 
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

;*************TAB5*****************
TabName = 'Tab#5 - SCALLING CONTROL'
tab5    = 0

;get constant to scale the back. spectra for subtraction from the
;sample data spectra
IF (isButtonSelected(Event,'csbss_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab5.csbss_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab5.csbss_button = 0
ENDELSE
IF (isButtonSelected(Event,'csbss_button')) THEN BEGIN
    cmd += ' --scale-bs='

    Value = getTextFieldValue(Event,'csbss_value_text')
    (*global).Configuration.Reduce.tab5.csbss_value_text = Value
    IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the Sample Data Value'
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
        cmd += strcompress(Value,/remove_all)
    ENDELSE

    Error = getTextFieldValue(Event,'csbss_error_text')
    (*global).Configuration.Reduce.tab5.csbss_error_text = Error
    IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the Sample Data Error'
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
        cmd += ',' + strcompress(Error,/remove_all)
    ENDELSE

ENDIF


;get constant to scale the back. spectra for subtraction from the
;normalization data spectra
IF (isButtonSelected(Event,'csn_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab5.csn_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab5.csn_button = 0
ENDELSE
IF (isButtonSelected(Event,'csn_button')) THEN BEGIN
    cmd += ' --scale-bn='

    Value = getTextFieldValue(Event,'csn_value_text')
    (*global).Configuration.Reduce.tab5.csn_value_text = Value
    IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the normalization Data Value'
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
        cmd += strcompress(Value,/remove_all)
    ENDELSE

    Error = getTextFieldValue(Event,'csn_error_text')
    (*global).Configuration.Reduce.tab5.csn_error_text = Error
    IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the Normalization Data Error'
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
        cmd += ',' + strcompress(Error,/remove_all)
    ENDELSE

ENDIF


;get constant to scale the back. spectra for subtraction from the
;sample data associated empty container spectra
IF (isButtonSelected(Event,'bcs_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab5.bcs_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab5.bcs_button = 0
ENDELSE
IF (isButtonSelected(Event,'bcs_button')) THEN BEGIN
    cmd += ' --scale-bcs='

    Value = getTextFieldValue(Event,'bcs_value_text')
    (*global).Configuration.Reduce.tab5.bcs_value_text = Value
    IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the Sample Data Associated Empty Container Value'
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
        cmd += strcompress(Value,/remove_all)
    ENDELSE

    Error = getTextFieldValue(Event,'bcs_error_text')
    (*global).Configuration.Reduce.tab5.bcs_error_text = Error
    IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the Sample Data Associated Empty Container Error'
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
        cmd += ',' + strcompress(Error,/remove_all)
    ENDELSE

ENDIF

;get constant to scale the back. spectra for subtraction from the
;normalization data associated empty container spectra
IF (isButtonSelected(Event,'bcn_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab5.bcn_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab5.bcn_button = 0
ENDELSE
IF (isButtonSelected(Event,'bcn_button')) THEN BEGIN
    cmd += ' --scale-bcn='

    Value = getTextFieldValue(Event,'bcn_value_text')
    (*global).Configuration.Reduce.tab5.bcn_value_text = Value
    IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the Normalization Data Associated Empty Container Value'
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
        cmd += strcompress(Value,/remove_all)
    ENDELSE

    Error = getTextFieldValue(Event,'bcn_error_text')
    (*global).Configuration.Reduce.tab5.bcn_error_text = Error
    IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale Background for Subtraction from the Normalization Data Associated Empty Container Error'
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
        cmd += ',' + strcompress(Error,/remove_all)
    ENDELSE

ENDIF


;get constant to scale the Empty Container for subtraction from
;the sample data
IF (isButtonSelected(Event,'cs_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab5.cs_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab5.cs_button = 0
ENDELSE
IF (isButtonSelected(Event,'cs_button')) THEN BEGIN
    cmd += ' --scale-cs='

    Value = getTextFieldValue(Event,'cs_value_text')
    (*global).Configuration.Reduce.tab5.cs_value_text = Value
    IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale the Empty Container for Subtraction from the Sample Data Value'
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
        cmd += strcompress(Value,/remove_all)
    ENDELSE

    Error = getTextFieldValue(Event,'cs_error_text')
    (*global).Configuration.Reduce.tab5.cs_error_text = Error
    IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale the Empty Container for Subtraction from the Sample Data Error'
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
        cmd += ',' + strcompress(Error,/remove_all)
    ENDELSE

ENDIF


;get constant to scale the Empty Container for subtraction from
;the normalization data
IF (isButtonSelected(Event,'cn_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab5.cn_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab5.cn_button = 0
ENDELSE
IF (isButtonSelected(Event,'cn_button')) THEN BEGIN
    cmd += ' --scale-cn='

    Value = getTextFieldValue(Event,'cn_value_text')
    (*global).Configuration.Reduce.tab5.cn_value_text = Value
    IF (Value EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Constant To Scale the Empty Container for Subtraction from the Normalization Data Value'
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
        cmd += strcompress(Value,/remove_all)
    ENDELSE

    Error = getTextFieldValue(Event,'cn_error_text')
    (*global).Configuration.Reduce.tab5.cn_error_text = Error
    IF (Error EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Constant To Scale the Empty Container for Subtraction from the Normalization Data Error'
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
        cmd += ',' + strcompress(Error,/remove_all)
    ENDELSE

ENDIF



;*************TAB6*****************
TabName = 'Tab#6 - DATA CONTROL'
tab6    = 0

;get Time Zero Slope Parameter
IF (isButtonSelected(Event,'tzsp_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab6.tzsp_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab6.tzsp_button = 0
ENDELSE
IF (isButtonSelected(Event,'tzsp_button')) THEN BEGIN
    cmd += ' --time-zero-slope='

    TIBCV = getTextFieldValue(Event,'tzsp_value_text')
    (*global).Configuration.Reduce.tab6.tzsp_value_text = TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Zero Slope Parameter Value'
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
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tzsp_error_text')
    (*global).Configuration.Reduce.tab6.tzsp_error_text = TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Zero Slope Parameter Error'
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
        cmd += ',' + strcompress(TIBCE,/remove_all)
    ENDELSE

ENDIF

;get Time Zero Offset Parameter
IF (isButtonSelected(Event,'tzop_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab6.tzop_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab6.tzop_button = 0
ENDELSE
IF (isButtonSelected(Event,'tzop_button')) THEN BEGIN
    cmd += ' --time-zero-offset='

    TIBCV = getTextFieldValue(Event,'tzop_value_text')
    (*global).Configuration.Reduce.tab6.tzop_value_text = TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Time Zero Offset Parameter Value'
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
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tzop_error_text')
    (*global).Configuration.Reduce.tab6.tzop_error_text = TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Time Zero Offset Parameter Error'
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
        cmd += ',' + strcompress(TIBCE,/remove_all)
    ENDELSE

ENDIF

;get Energy Histogram Axis
cmd += ' --energy-bins='

TIBCMin = getTextFieldValue(Event,'eha_min_text')
(*global).Configuration.Reduce.tab6.eha_min_text= TIBCMin
IF (TIBCMin EQ '') THEN BEGIN
    cmd += '?'
    status_text = '   -Please provide a Energy Histogram Axis Min'
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
    cmd += strcompress(TIBCMin,/remove_all)
ENDELSE

TIBCMax = getTextFieldValue(Event,'eha_max_text')
(*global).Configuration.Reduce.tab6.eha_max_text = TIBCMax
IF (TIBCMax EQ '') THEN BEGIN
    cmd += ',?'
    status_text = '   -Please provide a Energy Histogram Axis Max'
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
    cmd += ',' + strcompress(TIBCMax,/remove_all)
ENDELSE

TIBCBin = getTextFieldValue(Event,'eha_bin_text')
(*global).Configuration.Reduce.tab6.eha_bin_text = TIBCBin
IF (TIBCBin EQ '') THEN BEGIN
    cmd += ',?'
    status_text = '   -Please provide a Energy Histogram Axis Bin'
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
    cmd += ',' + strcompress(TIBCBin,/remove_all)
ENDELSE

;get Global Instrument Final Wavelength
IF (isButtonSelected(Event,'gifw_button')) THEN BEGIN
    (*global).Configuration.Reduce.tab6.gifw_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab6.gifw_button = 0
ENDELSE
IF (isButtonSelected(Event,'gifw_button')) THEN BEGIN
    cmd += ' --final-wavelength='

    TIBCV = getTextFieldValue(Event,'gifw_value_text')
    (*global).Configuration.Reduce.tab6.gifw_value_text = TIBCV
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '   -Please provide a Global Instrument Final Wavelength Value'
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
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'gifw_error_text')
    (*global).Configuration.Reduce.tab6.gifw_error_text = TIBCE
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '   -Please provide a Global Instrument Final Wavelength Error'
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
        cmd += ',' + strcompress(TIBCE,/remove_all)
    ENDELSE
ENDIF

;get Momentum Transfer Histogram Axis
cmd += ' --mom-trans-bin='

TIBCMin = getTextFieldValue(Event,'mtha_min_text')
(*global).Configuration.Reduce.tab6.mtha_min_text= TIBCMin
IF (TIBCMin EQ '') THEN BEGIN
    cmd += '?'
    status_text = '   -Please provide a Momentum Transfer Histogram Axis Min'
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
    cmd += strcompress(TIBCMin,/remove_all)
ENDELSE

TIBCMax = getTextFieldValue(Event,'mtha_max_text')
(*global).Configuration.Reduce.tab6.mtha_max_text = TIBCMax
IF (TIBCMax EQ '') THEN BEGIN
    cmd += ',?'
    status_text = '   -Please provide a Momentum Transfer Histogram Axis Max'
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
    cmd += ',' + strcompress(TIBCMax,/remove_all)
ENDELSE

TIBCBin = getTextFieldValue(Event,'mtha_bin_text')
(*global).Configuration.Reduce.tab6.mtha_bin_text = TIBCBin
IF (TIBCBin EQ '') THEN BEGIN
    cmd += ',?'
    status_text = '   -Please provide a Momentum Transfer Histogram Axis Bin'
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
    cmd += ',' + strcompress(TIBCBin,/remove_all)
ENDELSE

;add a white space
putInfoInCommandLineStatus, Event, '', 1

;************TAB7******************

TabName = 'Tab#7 - INTERMEDIATE OUTPUT'
tab7    = 0

;Write all Intermediate Output
IF (isButtonSelected(Event,'waio_button')) THEN BEGIN
    cmd += ' --dump-all'
    (*global).Configuration.Reduce.tab7.waio_button = 1
ENDIF ELSE BEGIN
    (*global).Configuration.Reduce.tab7.waio_button = 0
ENDELSE

IF ((*global).Configuration.Reduce.tab7.waio_button NE 1) THEN BEGIN

;Write out Calculated Time-Independent Background
    IF (isButtonSelected(Event,'woctib_button')) THEN BEGIN
        cmd += ' --dump-tib'
        (*global).Configuration.Reduce.tab7.woctib_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.woctib_button = 0
    ENDELSE
    
;Write out Pixel Wavelength Spectra
    IF (isButtonSelected(Event,'wopws_button')) THEN BEGIN
        cmd += ' --dump-wave'
        (*global).Configuration.Reduce.tab7.wopws_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.wopws_button = 0
    ENDELSE
    
;Write out Monitor Wavelength Spectrum
    IF (isButtonSelected(Event,'womws_button') AND $
        isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
        cmd += ' --dump-mon-wave'
        (*global).Configuration.Reduce.tab7.womws_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.womws_button = 0
    ENDELSE
    
;Write out Monitor Efficiency Spectrum
    IF (isButtonSelected(Event,'womes_button')) THEN BEGIN
        cmd += ' --dump-mon-effc'
        (*global).Configuration.Reduce.tab7.womes_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.womes_button = 0
    ENDELSE
    
;Write out Rebinned Monitor Spectra
    IF (isButtonSelected(Event,'worms_button') AND $
        isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
        cmd += ' --dump-mon-rebin'
        (*global).Configuration.Reduce.tab7.worms_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.worms_button = 0
    ENDELSE
    
;Write out Combined Pixel Spectrum After Monitor Normalization
    IF (isButtonSelected(Event,'wocpsamn_button') AND $
        isButtonUnSelected(Event,'nmn_button')  THEN BEGIN
        (*global).Configuration.Reduce.tab7.wocpsamn_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.wocpsamn_button = 0
    ENDELSE
ENDIF    

IF (isButtonSelected(Event,'wocpsamn_button') AND $
    isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
    
    IF ((*global).Configuration.Reduce.tab7.waio_button NE 1) THEN BEGIN
        cmd += ' --dump-wave-mnorm'
    ENDIF 

    WAmin = getTextFieldValue(Event,'wa_min_text')
    WAmax = getTextFieldValue(Event,'wa_max_text')
    WABwidth = getTextFieldValue(Event,'wa_bin_width_text')
    
    (*global).Configuration.Reduce.tab7.wa_min_text = WAmin
    (*global).Configuration.Reduce.tab7.wa_max_text = WAmax
    (*global).Configuration.Reduce.tab7.wa_bin_width_text = WABwidth
    
    IF (WAMIN NE '' OR $
        WAMAX NE '' OR $
        WABwidth NE '') THEN BEGIN
        
        cmd += ' --lambda-bins='
        
        IF (WAmin EQ '') THEN BEGIN
            cmd += '?'
            status_text = '   -Please provide a Wavelength Histogram Min Value'
            IF (tab7 EQ 0) THEN BEGIN
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
            cmd += strcompress(WAmin,/remove_all)
        ENDELSE
        
        
        IF (WAmax EQ '') THEN BEGIN
            cmd += ',?'
            status_text = '   -Please provide a Wavelength Histogram Max Value'
            IF (tab7 EQ 0) THEN BEGIN
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
            cmd += ',' + strcompress(WAmax,/remove_all)
        ENDELSE
        
        IF (WABwidth EQ '') THEN BEGIN
            cmd += ',?'
            status_text = '   -Please provide a Wavelength Histogram Bin Width Value'
            IF (tab7 EQ 0) THEN BEGIN
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
            cmd += ',' + strcompress(WABwidth,/remove_all)
        ENDELSE
        
    ENDIF

ENDIF

IF ((*global).Configuration.Reduce.tab7.waio_button NE 1) THEN BEGIN

;Write out Pixel Initial Energy Spectra
    IF (isButtonSelected(Event,'wopies_button')) THEN BEGIN
        cmd += ' --dump-ei'
        (*global).Configuration.Reduce.tab7.wopies_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.wopies_button = 0
    ENDELSE
    
;Write out Pixel Energy Transfer Spectra
    IF (isButtonSelected(Event,'wopets_button')) THEN BEGIN
        cmd += ' --dump-energy'
        (*global).Configuration.Reduce.tab7.wopets_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.wopets_button = 0
    ENDELSE
    
;Write out Linearly Interpolated Direct Scattering Back. Info. Summed
;over all Pixels
    IF (isButtonSelected(Event,'wolidsb_button')) THEN BEGIN
        cmd += ' --dump-dslin'
        (*global).Configuration.Reduce.tab7.wolidsb_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.wolidsb_button = 0
    ENDELSE
    
;Write out Dimensionless Wavelength Spectrum Momentum
    IF (isButtonSelected(Event,'wodwsm_button') AND $
        isButtonUnSelected(Event,'nmn_button')) THEN BEGIN
        cmd += ' --dump-mom-diml'
        (*global).Configuration.Reduce.tab7.wodwsm_button = 1
    ENDIF ELSE BEGIN
        (*global).Configuration.Reduce.tab7.wodwsm_button = 0
    ENDELSE
ENDIF

;display command line in Reduce text box
putTextFieldValue, Event, 'command_line_generator_text', cmd, 0

;validate or not Go data reduction button
if (StatusMessage NE 0) then begin ;do not activate button
    activate = 0
endif else begin
    activate = 1
endelse

Activate_button, Event,'submit_button',activate

END
