;===============================================================================
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
;===============================================================================

PRO CheckCommandLine, Event
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

;default parameters
cmd_status               = 1      ;by default, cmd can be activated
missing_arguments_text   = ['']   ;list of missing arguments 
missing_argument_counter = 0

;Check first tab
cmd = (*global).ReducePara.driver_name ;driver to launch

;- LOAD FILES TAB --------------------------------------------------------------

;-Data File-
file_run = getTextFieldValue(Event,'data_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    cmd += ' ' + file_run
ENDIF ELSE BEGIN
    cmd += ' ?'
    missing_arguments_text = ['- Valid Data File (LOAD FILES)']
    cmd_status = 0
    ++missing_argument_counter
END

;-ROI File-
file_run = getTextFieldValue(Event,'roi_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    flag = (*global).CorrectPara.roi.flag
    cmd += ' ' + flag + '=' + file_run
ENDIF 

;-Solvant Buffer Only-
file_run = getTextFieldValue(Event,'solvant_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    flag = (*global).CorrectPara.solv_buffer.flag
    cmd += ' ' + flag + '=' + file_run
ENDIF 

;-Emtpy Can-
file_run = getTextFieldValue(Event,'empty_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    flag = (*global).CorrectPara.empty_can.flag
    cmd += ' ' + flag + '=' + file_run
ENDIF 

;-Open Beam-
file_run = getTextFieldValue(Event,'open_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    flag = (*global).CorrectPara.open_beam.flag
    cmd += ' ' + flag + '=' + file_run
ENDIF 

;-Dark Current-
file_run = getTextFieldValue(Event,'dark_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    flag = (*global).CorrectPara.dark_current.flag
    cmd += ' ' + flag + '=' + file_run
ENDIF 

;- PARAMETERS  -----------------------------------------------------------------

;-geometry file to overwrite
IF (getCWBgroupValue(Event,'overwrite_geometry_group') EQ 0) THEN BEGIN
    cmd += ' --inst-geom='
    IF ((*global).inst_geom NE '') THEN BEGIN
        cmd += (*global).inst_geom
    ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, '- Instrument' + $
                                  ' Geometry File (LOAD FILES)']
    ENDELSE
ENDIF

;-time offsets of detector and beam monitor
detectorTO = getTextFieldValue(Event,'time_zero_offset_detector_uname')
IF (detectorTO NE '') THEN BEGIN
    cmd += ' ' + (*global).ReducePara.detect_time_offset + '=' + detectorTO
ENDIF

beamTO = getTextFieldValue(Event,'time_zero_offset_beam_monitor_uname')
IF (beamTO NE '') THEN BEGIN
    cmd += ' ' + (*global).ReducePara.monitor_time_offset + '=' + beamTO
ENDIF

;-monitor efficiency
IF (getCWBgroupValue(Event, 'monitor_efficiency_group') EQ 0) THEN BEGIN
    cmd += ' ' + (*global).ReducePara.monitor_efficiency.flag
ENDIF

;-Q min, max, width and unit
Qmin   = getTextFieldValue(Event,'qmin_text_field')
Qmax   = getTextFieldValue(Event,'qmax_text_field')
Qwidth = getTextFieldValue(Event,'qwidth_text_field')
Qunits = getCWBgroupValue(Event,'q_scale_group')
cmd += ' ' + (*global).ReducePara.monitor_rebin + '='
IF (Qmin NE '') THEN BEGIN
    cmd += STRCOMPRESS(Qmin,/REMOVE_ALL)
ENDIF ELSE BEGIN
    cmd += '?'
    cmd_status = 0
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, '- Q minimum (PARAMETERS)']
ENDELSE
cmd += ','
IF (Qmax NE '') THEN BEGIN
    cmd += STRCOMPRESS(Qmax,/REMOVE_ALL)
ENDIF ELSE BEGIN
    cmd += '?'
    cmd_status = 0
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, '- Q maximum (PARAMETERS)']
ENDELSE
cmd += ','
IF (Qwidth NE '') THEN BEGIN
    cmd += STRCOMPRESS(Qwidth,/REMOVE_ALL)
ENDIF ELSE BEGIN
    cmd += '?'
    cmd_status = 0
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, '- Q width (PARAMETERS)']
ENDELSE
cmd += ','
IF (Qunits EQ 0) THEN BEGIN
    cmd += 'linear'
ENDIF ELSE BEGIN
    cmd += 'log'
ENDELSE

;- INTERMEDIATE ----------------------------------------------------------------
IntermPlots = getCWBgroupValue(Event,'intermediate_group_uname')
;beam monitor after conversion to Wavelength
IF (IntermPlots[0] EQ 1) THEN BEGIN 
    cmd += ' ' + (*global).IntermPara.bmon_wave.flag
ENDIF
;beam monitor in Wavelength after efficiency correction
IF (IntermPlots[1] EQ 1) THEN BEGIN
    cmd += ' ' + (*global).IntermPara.bmon_effc.flag
ENDIF
;data of each pixel after wavelength conversion
IF (IntermPlots[2] EQ 1) THEN BEGIN
    cmd += ' ' + (*global).IntermPara.wave.flag
ENDIF
;monitor spectrum after rebin to detector wavelength axis
IF (IntermPlots[3] EQ 1) THEN BEGIN
    cmd += ' ' + (*global).IntermPara.bmon_rebin.flag
ENDIF
;combined spectrum of data after beam monitor normalization
IF (IntermPlots[4] EQ 1) THEN BEGIN
    cmd += ' ' + (*global).IntermPara.bmnon_wave.flag
    map_status = 1
;-Q min, max, width and unit
    Lambdamin   = getTextFieldValue(Event,'lambda_min_text_field')
    Lambdamax   = getTextFieldValue(Event,'lambda_max_text_field')
    Lambdawidth = getTextFieldValue(Event,'lambda_width_text_field')
    Lambdaunits = getCWBgroupValue(Event,'lambda_scale_group')
    cmd += ' ' + (*global).ReducePara.monitor_rebin + '='
    IF (Lambdamin NE '') THEN BEGIN
        cmd += STRCOMPRESS(Lambdamin,/REMOVE_ALL)
    ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, '- Lambda minimum ' + $
                                  '(INTERMEDIATE FILES)']
    ENDELSE
    cmd += ','
    IF (Lambdamax NE '') THEN BEGIN
        cmd += STRCOMPRESS(Lambdamax,/REMOVE_ALL)
    ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, '- Lambda maximum ' + $
                                  '(INTERMEDIATE FILES)']
    ENDELSE
    cmd += ','
    IF (Lambdawidth NE '') THEN BEGIN
        cmd += STRCOMPRESS(Lambdawidth,/REMOVE_ALL)
    ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, '- Lambda width ' + $
                                  '(INTERMEDIATE FILES)']
    ENDELSE
    cmd += ','
    IF (Lambdaunits EQ 0) THEN BEGIN
        cmd += 'linear'
    ENDIF ELSE BEGIN
        cmd += 'log'
    ENDELSE
ENDIF ELSE BEGIN
    map_status = 0
ENDELSE
map_base, Event, 'lambda_base', map_status

;- Put cmd in the text box -
putCommandLine, Event, cmd

;- put list of  missing arguments
putMissingArguments, Event, missing_arguments_text
;- tells how may missing arguments were found
putMissingArgNumber, Event, missing_argument_counter

;- activate GO DATA REDUCTION BUTTON only if cmd_status is 1
activate_go_data_reduction, Event, cmd_status

END
