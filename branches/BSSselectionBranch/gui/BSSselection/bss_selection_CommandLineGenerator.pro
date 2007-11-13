PRO BSSselection_CommandLineGenerator, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

StatusMessage = 0 ;will increase by 1 each time a field is missing

cmd = 'amorphous_reduction ' ;name of function to call

;****TAB1****

;get Raw Sample Data Files
RSDFiles = getTextFieldValue(Event, 'rsdf_list_of_runs_text')
IF (RSDFiles NE '') THEN BEGIN
    cmd += ' ' + strcompress(RSDFiles,/remove_all)
    IF (StatusMessage EQ 0) THEN BEGIN
    putInfoInCommandLineStatus, Event, '', 0
    ENDIF
ENDIF ELSE BEGIN
    cmd += ' ?'
    status_text = '- Please provide at least one Raw Sample Data File in -Input Data Setup-'
    status_text += ' (Format example: /SNS/BSS/2007_1_2_SCI/1/2454/NeXus/BSS_2454.nxs,/SNS/BSS/2007_1_2_SCI/1/2455/NeXus/BSS_2455.nxs)'
    putInfoInCommandLineStatus, Event, status_text, 0
    StatusMessage += 1
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
    status_text = '- Please provide a Pixel Region of Interest File in -Input Data Setup-'
    IF (StatusMessage GT 0) THEN BEGIN
        append = 1
    ENDIF ELSE BEGIN
        append = 0
    ENDELSE
    putInfoInCommandLineStatus, Event, status_text, append
    StatusMessage += 1
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

;****TAB2****

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

;get Normalization Integration Start Wavelength
NISW = getTextFieldValue(Event,'nisw_field')
IF(NISW NE '') THEN BEGIN
    cmd += ' --norm-start=' + strcompress(NISW,/remove_all)
ENDIF

;get Normalization Integration End Wavelength
NIEW = getTextFieldValue(Event,'nisE_field')
IF(NIEW NE '') THEN BEGIN
    cmd += ' --norm-end=' + strcompress(NIEW,/remove_all)
ENDIF

;****TAB3****

;get Time-Independent Background TOF channels
TIBTOF1 = getTextFieldValue(Event,'tibtof_channel1_text')
TIBTOF2 = getTextFieldValue(Event,'tibtof_channel2_text')
TIBTOF3 = getTextFieldValue(Event,'tibtof_channel3_text')
TIBTOF4 = getTextFieldValue(Event,'tibtof_channel4_text')
IF (TIBTOF1 NE '' OR $
    TIBTOF2 NE '' OR $
    TIBTOF3 NE '' OR $
    TIBTOF4 NE '') THEN BEGIN

    cmd += ' --tib-tofs='

    IF (TIBTOF1 EQ '') THEN BEGIN
        cmd += '?'
        status_text = '- Please provide a TOF Channel #1 in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBTOF1,/remove_all)
    ENDELSE

    IF (TIBTOF2 EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a TOF Channel #2 in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBTOF2,/remove_all)
    ENDELSE

    IF (TIBTOF3 EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a TOF Channel #3 in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBTOF3,/remove_all)
    ENDELSE

    IF (TIBTOF4 EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a TOF Channel #4 in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
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
        status_text = '- Please provide a Time Independent Background Constant value for' 
        status_text += ' Sample Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tibc_for_sd_error_text')
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a Time Independent Background Constant error for' 
        status_text += ' Sample Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
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
        status_text = '- Please provide a Time Independent Background Constant value for' 
        status_text += ' Background Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tibc_for_bd_error_text')
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a Time Independent Background Constant error for' 
        status_text += ' Background Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
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
        status_text = '- Please provide a Time Independent Background Constant value for'
        status_text += ' Normalization Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tibc_for_nd_error_text')
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a Time Independent Background Constant error for' 
        status_text += ' Normalization Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
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
        status_text = '- Please provide a Time Independent Background Constant value for'
        status_text += ' Empty Can Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tibc_for_ecd_error_text')
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a Time Independent Background Constant error for' 
        status_text += ' Empty Can Data in -Time Independent Background-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
    ENDELSE

ENDIF

;*************TAB4*****************

;get Time Zero Slope Parameter
IF (isButtonSelected(Event,'tzsp_button')) THEN BEGIN
    cmd += ' --time-zero-slope='

    TIBCV = getTextFieldValue(Event,'tzsp_value_text')
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '- Please provide a Time Zero Slope Parameter Value in' 
        status_text += ' -Data Control-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tzsp_error_text')
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a Time Zero Slope Parameter Error in' 
        status_text += ' -Data Control-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
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
        status_text = '- Please provide a Time Zero Offset Parameter Value in' 
        status_text += ' -Data Control-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'tzop_error_text')
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a Time Zero Offset Parameter Error in' 
        status_text += ' -Data Control-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
    ENDELSE

ENDIF

;get Energy Histogram Axis
cmd += ' --energy-bins='

TIBCMin = getTextFieldValue(Event,'eha_min_text')
IF (TIBCMin EQ '') THEN BEGIN
    cmd += '?'
    status_text = '- Please provide a Energy Histogram Axis Min in ' 
    status_text += ' -Data Control-'
    IF (StatusMessage GT 0) THEN BEGIN
        append = 1
    ENDIF ELSE BEGIN
        append = 0
    ENDELSE
    putInfoInCommandLineStatus, Event, status_text, append
    StatusMessage += 1
ENDIF ELSE BEGIN
    cmd += strcompress(TIBCMin,/remove_all)
ENDELSE

TIBCMax = getTextFieldValue(Event,'eha_max_text')
IF (TIBCMax EQ '') THEN BEGIN
    cmd += ',?'
    status_text = '- Please provide a Energy Histogram Axis Max in '
    status_text += ' -Data Control-'
    IF (StatusMessage GT 0) THEN BEGIN
        append = 1
    ENDIF ELSE BEGIN
        append = 0
    ENDELSE
    putInfoInCommandLineStatus, Event, status_text, append
    StatusMessage += 1
ENDIF ELSE BEGIN
    cmd += ',' + strcompress(TIBCMax,/remove_all)
ENDELSE

TIBCBin = getTextFieldValue(Event,'eha_bin_text')
IF (TIBCBin EQ '') THEN BEGIN
    cmd += ',?'
    status_text = '- Please provide a Energy Histogram Axis Bin in '
    status_text += ' -Data Control-'
    IF (StatusMessage GT 0) THEN BEGIN
        append = 1
    ENDIF ELSE BEGIN
        append = 0
    ENDELSE
    putInfoInCommandLineStatus, Event, status_text, append
    StatusMessage += 1
ENDIF ELSE BEGIN
    cmd += ',' + strcompress(TIBCBin,/remove_all)
ENDELSE

;get Global Instrument Final Wavelength
IF (isButtonSelected(Event,'gifw_button')) THEN BEGIN
    cmd += ' --final-wavelength='

    TIBCV = getTextFieldValue(Event,'gifw_value_text')
    IF (TIBCV EQ '') THEN BEGIN
        cmd += '?'
        status_text = '- Please provide a Global Instrument Final Wavelength Value in' 
        status_text += ' -Data Control-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += strcompress(TIBCV,/remove_all)
    ENDELSE
    
    TIBCE = getTextFieldValue(Event,'gifw_error_text')
    IF (TIBCE EQ '') THEN BEGIN
        cmd += ',?'
        status_text = '- Please provide a Global Instrument Final Wavelength Error in '
        status_text += ' -Data Control-'
        IF (StatusMessage GT 0) THEN BEGIN
            append = 1
        ENDIF ELSE BEGIN
            append = 0
        ENDELSE
        putInfoInCommandLineStatus, Event, status_text, append
        StatusMessage += 1
    ENDIF ELSE BEGIN
        cmd += ',' + strcompress(TIBCE,/remove_all)
    ENDELSE

ENDIF

;************TAB5******************

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
            status_text = '- Please provide a Wavelength Histogram Min Value in ' 
            status_text += ' -Intermediate Output-'
            IF (StatusMessage GT 0) THEN BEGIN
                append = 1
            ENDIF ELSE BEGIN
                append = 0
            ENDELSE
            putInfoInCommandLineStatus, Event, status_text, append
            StatusMessage += 1
        ENDIF ELSE BEGIN
            cmd += strcompress(WAmin,/remove_all)
        ENDELSE
        
        
        IF (WAmax EQ '') THEN BEGIN
            cmd += ',?'
            status_text = '- Please provide a Wavelength Histogram Max Value in '
            status_text += ' -Intermediate Output-'
            IF (StatusMessage GT 0) THEN BEGIN
                append = 1
            ENDIF ELSE BEGIN
                append = 0
            ENDELSE
            putInfoInCommandLineStatus, Event, status_text, append
            StatusMessage += 1
        ENDIF ELSE BEGIN
            cmd += ',' + strcompress(WAmax,/remove_all)
        ENDELSE
        
        IF (WABwidth EQ '') THEN BEGIN
            cmd += ',?'
            status_text = '- Please provide a Wavelength Histogram Bin Width Value in '
            status_text += ' -Intermediate Output-'
            IF (StatusMessage GT 0) THEN BEGIN
                append = 1
            ENDIF ELSE BEGIN
                append = 0
            ENDELSE
            putInfoInCommandLineStatus, Event, status_text, append
            StatusMessage += 1
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


;display command line in Reduce text box
putTextFieldValue, Event, 'command_line_generator_text', cmd, 0

END
