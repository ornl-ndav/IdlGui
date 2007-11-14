PRO BSSselection_CommandLineGenerator, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;this function update all the reduce widgets (validate or not)
BSSselection_ReduceUpdateGui, Event

StatusMessage = 0 ;will increase by 1 each time a field is missing

cmd = 'amorphous_reduction ' ;name of function to call

;****TAB1****

TabName = 'Tab#1 - INPUT DATA SETUP (1)'
tab1    = 0
;get Raw Sample Data Files
RSDFiles = getTextFieldValue(Event, 'rsdf_list_of_runs_text')
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
IF (BDFiles NE '') THEN BEGIN
    cmd += ' --back=' + BDFiles
ENDIF

;get Normalization Data File
NDFiles = getTextFieldValue(Event,'ndf_list_of_runs_text')
IF (NDFiles NE '') THEN BEGIN
    cmd += ' --norm=' + NDFiles
ENDIF

;get Empty Can Data File
ECDFiles = getTextFieldValue(Event,'ecdf_list_of_runs_text')
IF (ECDFiles NE '') THEN BEGIN
    cmd += ' --ecan=' + ECDFiles
ENDIF

;get Direct Scattering Background
DSBFiles = getTextFieldValue(Event,'dsb_list_of_runs_text')
IF (DSBFiles NE '') THEN BEGIN
    cmd += ' --dsback=' + DSBFiles
ENDIF

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
    ++tab1
ENDELSE

;get Alternate Instrument Geometry
AIGFile = getTextFieldValue(Event,'aig_list_of_runs_text')
IF (AIGFile NE '') THEN BEGIN
    cmd += ' --inst_geom=' + AIGFile
ENDIF

;get Output File Name
OFile = getTextFieldValue(Event,'of_list_of_runs_text')
IF(OFile NE '') THEN BEGIN
    cmd += ' --output=' + OFile
ENDIF

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
    cmd += ' --no-mon-norm'
ENDIF

;get No Monitor Efficiency Correction
IF (isButtonSelected(Event,'nmec_button')) THEN BEGIN
    cmd += ' --no-mon-effc'
ENDIF

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

IF (isButtonSelected(Event,'te_button') AND $
    DSBFiles NE '') THEN BEGIN

;sample data file
    TEL = getTextFieldValue(Event,'te_low_field')
    TEH = getTextFieldValue(Event,'te_high_field')
    IF (TEL NE '' OR $
        TEH NE '') THEN BEGIN
        
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
ENDIF

;****TAB4****

TabName = 'Tab#4 - TIME-INDEPENDENT BACKGROUND'
tab4    = 0

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
    
ENDIF

;get Time-independent Background Constant for Sample Data
IF (isButtonSelected(Event,'tibc_for_sd_button')) THEN BEGIN
    cmd += ' --tib-data-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_sd_value_text')
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
    cmd += ' --tib-back-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_bd_value_text')
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
    cmd += ' --tib-norm-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_nd_value_text')
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
    cmd += ' --tib-ecan-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_ecd_value_text')
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
    cmd += ' --tib-dsback-const='

    TIBCV = getTextFieldValue(Event,'tibc_for_scatd_value_text')
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
    cmd += ' --scale-bs='

    Value = getTextFieldValue(Event,'csbss_value_text')
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








;*************TAB6*****************
TabName = 'Tab#6 - DATA CONTROL'
tab6    = 0

;get Time Zero Slope Parameter
IF (isButtonSelected(Event,'tzsp_button')) THEN BEGIN
    cmd += ' --time-zero-slope='

    TIBCV = getTextFieldValue(Event,'tzsp_value_text')
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
    cmd += ' --time-zero-offset='

    TIBCV = getTextFieldValue(Event,'tzop_value_text')
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
    cmd += ' --final-wavelength='

    TIBCV = getTextFieldValue(Event,'gifw_value_text')
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

;add a white space
putInfoInCommandLineStatus, Event, '', 1

;************TAB7******************

TabName = 'Tab#7 - INTERMEDIATE OUTPUT'
tab7    = 0

;Write all Intermediate Output
IF (isButtonSelected(Event,'waio_button')) THEN BEGIN
    cmd += ' --dump-all'
ENDIF

;Write out Calculated Time-Independent Background
IF (isButtonSelected(Event,'woctib_button')) THEN BEGIN
    cmd += ' --dump-tib'
ENDIF

;Write out Pixel Wavelenth Spectra
IF (isButtonSelected(Event,'wopws_button')) THEN BEGIN
    cmd += ' --dump-wave'
ENDIF

;Write out Monitor Wavelength Spectrum
IF (isButtonSelected(Event,'womws_button')) THEN BEGIN
    cmd += ' --dump-mon-wave'
ENDIF

;Write out Monitor Efficiency Spectrum
IF (isButtonSelected(Event,'womes_button')) THEN BEGIN
    cmd += ' --dump-mon-effc'
ENDIF

;Write out Rebinned Monitor Spectra
IF (isButtonSelected(Event,'worms_button')) THEN BEGIN
    cmd += ' --dump-mon-rebin'
ENDIF

;Write out Combined Pixel Spectrum After Monitor Normalization
IF (isButtonSelected(Event,'wocpsamn_button')) THEN BEGIN
    cmd += ' --dump-wave-mnorm'

    WAmin = getTextFieldValue(Event,'wa_min_text')
    WAmax = getTextFieldValue(Event,'wa_max_text')
    WABwidth = getTextFieldValue(Event,'wa_bin_width_text')

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
;Write out Pixel Initial Energy Spectra
IF (isButtonSelected(Event,'wopies_button')) THEN BEGIN
    cmd += ' --dump-ei'
ENDIF

;Write out Pixel Energy Transfer Spectra
IF (isButtonSelected(Event,'wopets_button')) THEN BEGIN
    cmd += ' --dump-energy'
ENDIF

;Write out Linearly Interpolated Direct Scattering Back. Info. summed
;over all Pixels
IF (isButtonSelected(Event,'wolidsb_button')) THEN BEGIN
    cmd += ' --dump-dslin'
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
