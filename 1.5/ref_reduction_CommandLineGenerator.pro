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
PRO REFreduction_CommandLineGenerator, Event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  StatusMessage = 0 ;will increase by 1 each time a field is missing
  
  ;add called to SLURM if hostname is not heater,lrac or mrac
  SPAWN, 'hostname', listening
  CASE (listening[0]) OF
    'lrac.sns.gov' : cmd = 'srun -Q -p lracq '
    'mrac.sns.gov' : cmd = 'srun -Q -p mracq '
  ELSE : BEGIN
    cmd = 'srun -Q -p heaterq '
  END
ENDCASE

cmd += (*global).driver_name ;name of function to call

;*****DATA*********************************************************************
;get Data run numbers text field
data_run_numbers = getTextFieldValue(Event, 'reduce_data_runs_text_field')
if (data_run_numbers NE '') then begin
  cmd += ' ' + data_run_numbers
endif else begin
  cmd += ' ?'
  status_text = '- Please provide at least one data run number'
  status_text += ' (Format example: 1345,1455-1458,1500)'
  putInfoInReductionStatus, Event, status_text, 0
  StatusMessage += 1
endelse

;data path
IF ((*global).data_path NE '') THEN BEGIN
  cmd += ' ' + (*global).data_path_flag
  cmd += '=' + (*global).data_path
  cmd += (*global).data_path_flag_suffix
ENDIF

;get data ROI file
data_roi_file = getTextFieldValue(Event, $
  'reduce_data_region_of_interest_file_name')
data_roi_file = data_roi_file[0]

cmd += ' --data-roi-file='
IF (data_roi_file NE '') THEN BEGIN
  cmd += data_roi_file
ENDIF ELSE BEGIN
  cmd        += '?'
  status_text = '- Please provide a data region of interest file. Go to ' + $
    'DATA, '
  status_text += 'select a ROI and save it.'
  IF (StatusMessage GT 0) THEN BEGIN
    append = 1
  ENDIF ELSE BEGIN
    append = 0
  ENDELSE
  putInfoInReductionStatus, Event, status_text, append
  StatusMessage += 1
ENDELSE

;direction of integration
cmd += " --int-dir='y'"

if (isDataWithBackground(Event)) then begin ;with background substraction

  ;bring values of ymin and ymax from data base
  ymin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
  ymax = getTextFieldValue(Event,'data_d_selection_peak_ymax_cw_field')
  putTextFieldValue, Event, $
    'data_exclusion_low_bin_text', $
    STRCOMPRESS(ymin[0],/REMOVE_ALL), 0
  putTextFieldValue, Event, $
    'data_exclusion_high_bin_text', $
    STRCOMPRESS(ymax[0],/REMOVE_ALL), 0
    
  cmd += ' --data-peak-excl='
  ;get data peak exclusion
  data_peak_exclusion_min = $
    STRCOMPRESS(getTextFieldValue(Event,'data_exclusion_low_bin_text'), $
    /remove_all)
  IF (data_peak_exclusion_min NE '') THEN BEGIN
    cmd += STRCOMPRESS(data_peak_exclusion_min,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    cmd         += '?'
    status_text  = '- Please provide a data low range ' + $
      'Peak of Exclusion.'
    status_text += ' Go to DATA, and select a low value for ' + $
      'the data peak exclusion.'
    IF (StatusMessage GT 0) THEN BEGIN
      append = 1
    ENDIF ELSE BEGIN
      append = 0
    ENDELSE
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  ENDELSE
  
  data_peak_exclusion_max = $
    STRCOMPRESS(getTextFieldValue(Event, $
    'data_exclusion_high_bin_text'),$ $
    /REMOVE_ALL)
  IF (data_peak_exclusion_max NE '') THEN BEGIN
    cmd += ' ' + STRCOMPRESS(data_peak_exclusion_max,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    cmd         += ' ?'
    status_text  = '- Please provide a data high ' + $
      'range Peak of Exclusion.'
    status_text += ' Go to DATA, and select a high value for ' + $
      'the data peak exclusion.'
    IF (StatusMessage GT 0) THEN BEGIN
      append = 1
    ENDIF ELSE BEGIN
      append = 0
    ENDELSE
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  ENDELSE
  
ENDIF

;check if user wants data background or not
IF (isDataWithBackground(Event)) THEN BEGIN ;yes, with background
  ;activate DATA Intermediate Plots
  MapBase, Event, 'reduce_plot2_base', 0
  MapBase, Event, 'reduce_plot3_base', 0
ENDIF ELSE BEGIN
  cmd += ' --no-bkg'
  ;  ;desactivate DATA Intermediate Plots
  ;  substrateValue = getCWBgroupValue(Event,'empty_cell_substrate_group')
  ;  IF (substrateValue EQ 0) THEN BEGIN
  ;    MapBase, Event, 'reduce_plot3_base', 0
  ;  ENDIF ELSE BEGIN
  MapBase, Event, 'reduce_plot3_base', 1
  ;  ENDELSE
  MapBase, Event, 'reduce_plot2_base', 1
END

;tof cutting
tof_min = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_min'),/REMOVE_ALL)
IF (tof_min NE '') THEN BEGIN

  IF (isTOFcuttingUnits_microS(Event)) THEN BEGIN ;microS
  
    ON_IOERROR, error_min1
    error_status = 1
    tof_min = FLOAT(tof_min)
    error_status = 0
    tof_min = STRCOMPRESS(tof_min,/REMOVE_ALL)
    error_min1:
    IF (error_status) THEN BEGIN
      tof_min = '?'
      status_text = '- Please check the TOF cut min value'
      IF (StatusMessage GT 0) THEN BEGIN
        append = 1
      ENDIF ELSE BEGIN
        append = 0
      ENDELSE
      putInfoInReductionStatus, Event, status_text, append
      StatusMessage += 1
    ENDIF
    
  ENDIF ELSE BEGIN
  
    ON_IOERROR, error_min
    error_status = 1
    tof_min = FLOAT(tof_min)
    error_status = 0
    tof_min *= 1000. ;to convert to microS
    tof_min = STRCOMPRESS(tof_min,/REMOVE_ALL)
    
    error_min:
    IF (error_status) THEN BEGIN
      tof_min = '?'
      status_text = '- Please check the TOF cut min value'
      IF (StatusMessage GT 0) THEN BEGIN
        append = 1
      ENDIF ELSE BEGIN
        append = 0
      ENDELSE
      putInfoInReductionStatus, Event, status_text, append
      StatusMessage += 1
    ENDIF
    
  ENDELSE
  
  cmd += ' --tof-cut-min=' + tof_min
  
ENDIF

tof_max = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_max'),/REMOVE_ALL)
IF (tof_max NE '') THEN BEGIN

  IF (isTOFcuttingUnits_microS(Event)) THEN BEGIN ;microS
  
    ON_IOERROR, error_max1
    error_status = 1
    tof_max = FLOAT(tof_max)
    error_status = 0
    tof_max = STRCOMPRESS(tof_max,/REMOVE_ALL)
    error_max1:
    IF (error_status) THEN BEGIN
      tof_max = '?'
      status_text = '- Please check the TOF cut max value'
      IF (StatusMessage GT 0) THEN BEGIN
        append = 1
      ENDIF ELSE BEGIN
        append = 0
      ENDELSE
      putInfoInReductionStatus, Event, status_text, append
      StatusMessage += 1
    ENDIF
    
  ENDIF ELSE BEGIN
  
    ON_IOERROR, error_max
    error_status = 1
    tof_max = FLOAT(tof_max)
    error_status = 0
    tof_max *= 1000. ;to convert to microS
    tof_max = STRCOMPRESS(tof_max,/REMOVE_ALL)
    
    error_max:
    IF (error_status) THEN BEGIN
      tof_max = '?'
      status_text = '- Please check the TOF cut max value'
      IF (StatusMessage GT 0) THEN BEGIN
        append = 1
      ENDIF ELSE BEGIN
        append = 0
      ENDELSE
      putInfoInReductionStatus, Event, status_text, append
      StatusMessage += 1
    ENDIF
    
  ENDELSE
  
  cmd += ' --tof-cut-max=' + tof_max
ENDIF

;*****NORMALIZATION************************************************************
;check if user wants to use normalization or not
if (isReductionWithNormalization(Event)) then begin

  ;activate Normalization Intermediate Plots
  MapBase, Event, 'reduce_plot4_base', 0
  MapBase, Event, 'reduce_plot6_base', 0
  
  ;get normalization run numbers
  norm_run_numbers = $
    getTextFieldValue(Event, $
    'reduce_normalization_runs_text_field')
  cmd += ' --norm='
  if (norm_run_numbers NE '') then begin
    cmd += norm_run_numbers
  endif else begin
    cmd += '?'
    status_text = '- Please provide at least one normalization run number'
    status_text += '(Format example: 1345,1455-1458,1500)'
    if (StatusMessage GT 0) then begin
      append = 1
    endif else begin
      append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  endelse
  
  ;normalization path
  IF ((*global).norm_path NE '') THEN BEGIN
    norm_pola_sensitive = 1
    pola_state = getCWBgroupValue(Event, 'normalization_pola_state')
    IF (pola_state EQ 1) THEN BEGIN
      cmd += ' ' + (*global).norm_path_flag
    ENDIF
  ENDIF ELSE BEGIN
    norm_pola_sensitive = 0
  ENDELSE
  ActivateWidget, Event, 'norm_pola_base', norm_pola_sensitive
  
  ;get normalization ROI file
  norm_roi_file = $
    getTextFieldValue(Event,$
    'reduce_normalization_region_of_interest_file_name')
  norm_roi_file = norm_roi_file[0]
  cmd += '  --norm-roi-file='
  IF (norm_roi_file NE '') THEN BEGIN
    cmd += STRCOMPRESS(norm_roi_file,/remove_all)
  ENDIF ELSE BEGIN
    cmd += '?'
    status_text = '- Please provide a normalization region of interest' + $
      ' file.'
    status_text += ' Go to NORMALIZATION, select a background ROI and' + $
      ' save it.'
    IF (StatusMessage GT 0) THEN BEGIN
      append = 1
    ENDIF ELSE BEGIN
      append = 0
    ENDELSE
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  ENDELSE
  
  if (isNormWithBackground(Event)) then begin ;without background
  
    ;bring values of ymin and ymax from norm base
    ymin = getTextFieldValue(Event,'norm_d_selection_peak_ymin_cw_field')
    ymax = getTextFieldValue(Event,'norm_d_selection_peak_ymax_cw_field')
    putTextFieldValue, Event, $
      'norm_exclusion_low_bin_text', $
      STRCOMPRESS(ymin[0],/REMOVE_ALL), 0
    putTextFieldValue, Event, $
      'norm_exclusion_high_bin_text', $
      STRCOMPRESS(ymax[0],/REMOVE_ALL), 0
      
    cmd += ' --norm-peak-excl='
    ;get norm peak exclusion
    norm_peak_exclusion_min = $
      STRCOMPRESS(getTextFieldValue(Event,'norm_exclusion_low_bin_text'), $
      /REMOVE_ALL)
    IF (norm_peak_exclusion_min NE '') THEN BEGIN
      cmd += STRCOMPRESS(norm_peak_exclusion_min,/REMOVE_ALL)
    ENDIF ELSE BEGIN
      cmd         += '?'
      status_text  = '- Please provide a normalization low range ' + $
        'Peak of Exclusion.'
      status_text += ' Go to NORMALIZATION, and select a low ' + $
        'value for the normalization peak exclusion.'
      IF (StatusMessage GT 0) THEN BEGIN
        append = 1
      ENDIF ELSE BEGIN
        append = 0
      ENDELSE
      putInfoInReductionStatus, Event, status_text, append
      StatusMessage += 1
    ENDELSE
    
    norm_peak_exclusion_max = $
      STRCOMPRESS(getTextFieldValue(Event, $
      'norm_exclusion_high_bin_text'),$ $
      /REMOVE_ALL)
    IF (norm_peak_exclusion_max NE '') THEN BEGIN
      cmd += ' ' + STRCOMPRESS(norm_peak_exclusion_max,/REMOVE_ALL)
    ENDIF ELSE BEGIN
      cmd         += ' ?'
      status_text  = '- Please provide a normalization high ' + $
        'range Peak of Exclusion.'
      status_text += ' Go to NORMALIZATION, and select a high ' + $
        'value for the normalization peak exclusion.'
      IF (StatusMessage GT 0) THEN BEGIN
        append = 1
      ENDIF ELSE BEGIN
        append = 0
      ENDELSE
      putInfoInReductionStatus, Event, status_text, append
      StatusMessage += 1
    ENDELSE
    
  endif
  
  ;check if user wants normalization background or not
  if (isNormWithBackground(Event)) then begin ;yes, with background
    MapBase, Event, 'reduce_plot5_base', 0 ;back. norm. plot is available
  endif else begin
    cmd += ' --no-norm-bkg'
    MapBase, Event, 'reduce_plot5_base', 1 ;back. norm. is not available
  endelse
  
endif else begin                ;no normalization file

  ;remove Normalization Intermediate Plots
  MapBase, Event, 'reduce_plot4_base', 1
  MapBase, Event, 'reduce_plot5_base', 1
  MapBase, Event, 'reduce_plot6_base', 1
  
endelse                         ;end of (~isWithoutNormalization)

;get name of instrument
cmd += ' --inst=' + (*global).instrument

;*****Q VALUES*****************************************************************

;Q values ---------------------------------------------------------------------
;check if Mode is auto or not
AutoModeStatus = getCWBgroupValue(Event,'q_mode_group')
IF (AutoModeStatus EQ 1) THEN BEGIN ;manual mode
  ;get Q infos
  Q_min = getTextFieldValue(Event, 'q_min_text_field')
  Q_max = getTextFieldValue(Event, 'q_max_text_field')
  Q_width = getTextfieldValue(Event, 'q_width_text_field')
  Q_scale = getQSCale(Event)
  cmd += ' --mom-trans-bins='
  
  if (Q_min NE '') then begin ;Q_min
    cmd += STRCOMPRESS(Q_min,/remove_all)
  endif else begin
    cmd += '?'
    status_text = '- Please provide a Q minimum value'
    if (StatusMessage GT 0) then begin
      append = 1
    endif else begin
      append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  endelse
  
  if (Q_max NE '') then begin ;Q_max
    cmd += ',' + STRCOMPRESS(Q_max,/remove_all)
  endif else begin
    cmd += ',?'
    status_text = '- Please provide a Q maximum value'
    if (StatusMessage GT 0) then begin
      append = 1
    endif else begin
      append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  endelse
  
  if (Q_width NE '') then begin ;Q_width
    cmd += ',' + STRCOMPRESS(Q_width,/remove_all)
  endif else begin
    cmd += ',?'
    status_text = '- Please provide a Q width value'
    if (StatusMessage GT 0) then begin
      append = 1
    endif else begin
      append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  endelse
  cmd += ',' + Q_scale        ;Q_scale (lin or log)
  
ENDIF

;get info about detector angle
angle_value = getTextFieldValue(Event,'detector_value_text_field')
angle_err   = getTextFieldValue(Event,'detector_error_text_field')
angle_units = getDetectorAngleUnits(Event)

if (angle_value NE '' OR $    ;user wants to input the angle value and err
  angle_err NE '') then begin
  
  ;    GuiLabelStatus   = 1
  ;    NexusLabelStatus = 0
  
  cmd += ' --angle-offset='
  
  if (angle_value NE '') then begin ;angle_value
    cmd += STRCOMPRESS(angle_value,/remove_all)
  endif else begin
    cmd += '?'
    status_text = '- Please provide a detector angle value'
    if (StatusMessage GT 0) then begin
      append = 1
    endif else begin
      append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  endelse
  
  if (angle_err NE '') then begin ;angle_err
    cmd += ',' + STRCOMPRESS(angle_err,/remove_all)
  endif else begin
    cmd += ',?'
    status_text = '- Please provide a detector angle error value'
    if (StatusMessage GT 0) then begin
      append = 1
    endif else begin
      append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
  endelse
  
  cmd += ',units=' + STRCOMPRESS(angle_units,/remove_all)
  
endif else begin

;    GuiLabelStatus   = 0
;    NexusLabelStatus = 1

endelse

;ActivateWidget, Event, 'nexus_data_used_label', NexusLabelStatus
;ActivateWidget, Event, 'gui_data_used_label', GuiLabelStatus

;get info about filter or not
if (~isWithFiltering(Event)) then begin ;no filtering
  cmd += ' --no-filter'
endif

;get info about deltaT/T
IF (isWithDToT(Event)) THEN BEGIN ;store deltaT over T
  cmd += ' --store-dtot'
ENDIF

if (isWithBeamDivergence(event)) then begin

cmd += ' --beamdiv-corr'

center_pixel = strcompress((*global).center_pixel,/remove_all)
if (center_pixel eq '') then begin
center_pixel = '?'
status_text = '- Specify a center pixel or select a data instrument ' + $
'geometry (beam divergence)'
if (statusMessage gt 0) then begin
append=1
endif else begin
append=0
endelse
putInfoInReductionStatus, event, status_text, append
StatusMessage += 1
endif
cmd += ' --center-pix=' + center_pixel

resolution = strcompress((*global).detector_resolution)
if (resolution eq '') then begin
resolution = '?'
status_text = '- Specify the detector resolution or select a data ' + $
'instrument(beam divergence)'
if (statusMessage gt 0) then begin
append = 1
endif else begin
append = 0
endelse
putInfoInReductionStatus, event, status_text, append
statusMessage += 1
endif
cmd += ' --det-spat-res=' + resolution

endif

;overwrite data instrument geometry file
if (isWithDataInstrumentGeometryOverwrite(Event)) then BEGIN
  cmd += ' --data-inst-geom='
  ;with instrument geometry
  IGFile = (*global).InstrumentDataGeometryFileName
  if (IGFile NE '') then begin ;instrument geometry file is not empty
    cmd += IGFile
    ;display last part of file name in button
    button_value = getFileNameOnly(IGFIle)
  endif else begin
    cmd += '?'
    status_text = '- Please select a Data instrument geometry'
    if (StatusMessage GT 0) then begin
      append = 1
    endif else begin
      append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
    if ((*global).miniVersion EQ 0) then begin
      button_value = 'Select a Data Instrument Geometry File'
    endif else begin
      button_value = 'Select a Data Instr. Geometry File'
    endelse
  endelse
  setButtonValue, Event, 'overwrite_data_intrument_geometry_button', $
    button_value
ENDIF

IF ((*global).instrument EQ 'REF_M') THEN BEGIN
  IF (~isWithDataInstrumentGeometryOverwrite(Event)) then BEGIN
    cmd += ' --data-inst-geom=' + (*global).tmp_geometry_file
  ENDIF
ENDIF

;overwrite norm instrument geometry file
if (isWithNormInstrumentGeometryOverwrite(Event)) then BEGIN $
  ;with instrument geometry
  cmd += ' --norm-inst-geom='
IGFile = (*global).InstrumentNormGeometryFileName
if (IGFile NE '') then begin ;instrument geometry file is not empty
  cmd += IGFile
  ;display last part of file name in button
  button_value = getFileNameOnly(IGFIle)
endif else begin
  cmd += '?'
  status_text = '- Please select a Normalization instrument geometry'
  if (StatusMessage GT 0) then begin
    append = 1
  endif else begin
    append = 0
  endelse
  putInfoInReductionStatus, Event, status_text, append
  StatusMessage += 1
  if ((*global).miniVersion EQ 0) then begin
    button_value = 'Select a Normalization Instrument Geometry File'
  endif else begin
    button_value = 'Select a Norm. Instr. Geometry File'
  endelse
endelse
setButtonValue, Event, 'overwrite_norm_instrument_geometry_button', $
  button_value
  
endif

;get name from output path and name
outputPath = (*global).dr_output_path     
;check that user have access to that folder
IF (FILE_TEST(outputPath,/WRITE) EQ 0) THEN BEGIN
  SPAWN, 'mkdir ' + outputPath, listening, err_listening
  IF (err_listening[0] NE '') THEN BEGIN
    status_text    = '- PERMISSION ERROR : you do not have ' + $
      'the permission to '
    status_text   += 'write in this folder. Please select another folder !'
    IF (StatusMessage GT 0) THEN BEGIN
      append = 1
    ENDIF ELSE BEGIN
      append = 0
    ENDELSE
    StatusMessage += 1
    putInfoInReductionStatus, Event, status_text, append
  ENDIF
ENDIF
outputFileName    = getOutputFileName(Event)
NewOutputFileName = outputPath + outputFileName
cmd              += ' --output=' + NewOutputFileName

;generate intermediate plots command line
IP_cmd = RefReduction_CommandLineIntermediatePlotsGenerator(Event)
cmd   += IP_cmd

;display command line in Reduce text box
putTextFieldValue, Event, 'reduce_cmd_line_preview', cmd, 0

;validate or not Go data reduction button
if (StatusMessage NE 0) then begin ;do not activate button
  activate = 0
;;display command line in batch tab of working row
;    PopulateBatchTableWithCMDinfo, Event, 'N/A'
endif else begin
  activate = 1
  putInfoInReductionStatus, Event, '', 0
;clear text field of Commnand line status
;;display command line in batch tab of working row
;    PopulateBatchTableWithCMDinfo, Event, cmd
endelse

(*global).PreviousRunReductionValidated = activate
ActivateWidget, Event,'start_data_reduction_button',activate

END
