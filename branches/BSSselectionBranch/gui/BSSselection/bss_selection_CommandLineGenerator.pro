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




;display command line in Reduce text box
putTextFieldValue, Event, 'command_line_generator_text', cmd, 0



END
