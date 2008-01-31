PRO REFreduction_CommandLineGenerator, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

StatusMessage = 0 ;will increase by 1 each time a field is missing

;cmd = '~/usr/bin/reflect_reduction' ;REMOVE_ME
cmd = 'reflect_reduction' ;name of function to call
;cd, (*global).working_path

;get Data run numbers text field
data_run_numbers = getTextFieldValue(Event, 'reduce_data_runs_text_field')
if (data_run_numbers NE '') then begin
    cmd += ' ' + strcompress(data_run_numbers,/remove_all)
endif else begin
    cmd += ' ?'
    status_text = '- Please provide at least one data run number'
    status_text += ' (Format example: 1345,1455-1458,1500)'
    putInfoInReductionStatus, Event, status_text, 0
    StatusMessage += 1
endelse

;get data roi file
data_roi_file = getTextFieldValue(Event,'reduce_data_region_of_interest_file_name')
cmd += ' --data-roi-file=' 
if (data_roi_file NE '') then begin
    cmd += data_roi_file
endif else begin
    cmd += '?'
    status_text = '- Please provide a data region of interest file. Go to DATA, '
    status_text += 'select a background ROI and save it.'
    if (StatusMessage GT 0) then begin
        append = 1
    endif else begin
        append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
endelse

;get data peak exclusion
data_peak_exclusion_min = $
  strcompress(getTextFieldValue(Event,'data_exclusion_low_bin_text'), $
              /remove_all)
data_peak_exclusion_max = $
  strcompress(getTextFieldValue(Event,'data_exclusion_high_bin_text'),$ $
              /remove_all)

cmd += ' --data-peak-excl='
if (data_peak_exclusion_min NE '') then begin
    cmd += strcompress(data_peak_exclusion_min,/remove_all)
endif else begin
    cmd += '?'
    status_text = '- Please provide a data low range Peak of Exclusion.'
    status_text += ' Go to DATA, and select a low value for the data peak exclusion.'
    if (StatusMessage GT 0) then begin
        append = 1
    endif else begin
        append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
endelse

if (data_peak_exclusion_max NE '') then begin
    cmd += ' ' + strcompress(data_peak_exclusion_max,/remove_all)
endif else begin
    cmd += ' ?'
    status_text = '- Please provide a data high range Peak of Exclusion.'
    status_text += ' Go to DATA, and select a high value for the data peak exclusion.'
    if (StatusMessage GT 0) then begin
        append = 1
    endif else begin
        append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append
    StatusMessage += 1
endelse

;Be sure that (Ymin_peak=Ymin_back && Ymax_peak=Ymax_back) is wrong
Ymin_peak = data_peak_exclusion_min
Ymax_peak = data_peak_exclusion_max
Ymin_back = $
  strcompress(getTextFieldValue(Event, $
                                'data_d_selection_background_ymin_cw_field'), $
              /remove_all)
Ymax_back = $
  strcompress(getTextFieldValue(Event, $
                                'data_d_selection_background_ymax_cw_field'), $
              /remove_all)
IF (Ymin_peak NE '' AND $
    Ymax_peak NE '' AND $
    Ymin_back NE '' AND $
    Ymax_back NE '') THEN BEGIN
    IF ((Ymin_peak EQ Ymin_back) AND (Ymax_peak EQ Ymax_back)) THEN BEGIN
        StatusMessage += 1
        status_text = '- Data Background and Peak have the same Ymin and Ymax values.'
        status_text += ' Please changes at least 1 of the data.'
        if (StatusMessage GT 0) then begin
            append = 1
        endif else begin
            append = 0
        endelse
        putInfoInReductionStatus, Event, status_text, append
    ENDIF
ENDIF

;check if user wants data background or not
if (isDataWithBackground(Event)) then begin ;yes, with background
;activate DATA Intermediate Plots
    MapBase, Event, 'reduce_plot2_base', 0
    MapBase, Event, 'reduce_plot3_base', 0
endif else begin
    cmd += ' --no-bkg'
;desactivate DATA Intermediate Plots
    MapBase, Event, 'reduce_plot2_base', 1
    MapBase, Event, 'reduce_plot3_base', 1
end

;check if user wants to use normalization or not
if (isReductionWithNormalization(Event)) then begin
    
;activate Normalization Intermediate Plots
    MapBase, Event, 'reduce_plot4_base', 0
    MapBase, Event, 'reduce_plot6_base', 0
    
;get normalization run numbers
    norm_run_numbers = getTextFieldValue(Event,'reduce_normalization_runs_text_field')
    cmd += ' --norm=' 
    if (norm_run_numbers NE '') then begin
        cmd += strcompress(norm_run_numbers,/remove_all)
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
    
;get normalization roi file
    norm_roi_file = getTextFieldValue(Event,'reduce_normalization_region_of_interest_file_name')
    cmd += '  --norm-roi-file='
    if (norm_roi_file NE '') then begin
        cmd += strcompress(norm_roi_file,/remove_all)
    endif else begin
        cmd += '?'
        status_text = '- Please provide a normalization region of interest file.'
        status_text += ' Go to NORMALIZATION, select a background ROI and save it.'
        if (StatusMessage GT 0) then begin
            append = 1
        endif else begin
            append = 0
        endelse
        putInfoInReductionStatus, Event, status_text, append
        StatusMessage += 1
    endelse
    
;get norm peak exclusion
    norm_peak_exclusion_min = $
      strcompress(getTextFieldValue(Event,'norm_exclusion_low_bin_text'),$
                  /remove_all)
    norm_peak_exclusion_max = $
      strcompress(getTextFieldValue(Event,'norm_exclusion_high_bin_text'),$
                  /remove_all)
    cmd += ' --norm-peak-excl='
    if (norm_peak_exclusion_min NE '') then begin
        cmd += strcompress(norm_peak_exclusion_min,/remove_all)
    endif else begin
        cmd += '?'
        status_text = '- Please provide a normalization low range Peak of Exclusion.'
        status_text += ' Go to NORMALIZATION, and select a low'
        status_text += ' value for the normalization peak exclusion.'
        if (StatusMessage GT 0) then begin
            append = 1
        endif else begin
            append = 0
        endelse
        putInfoInReductionStatus, Event, status_text, append
        StatusMessage += 1
    endelse

    if (norm_peak_exclusion_max NE '') then begin
        cmd += ' ' + strcompress(norm_peak_exclusion_max,/remove_all)
    endif else begin
        cmd += '?'
        status_text = '- Please provide a normalization high range Peak of Exclusion.'
        status_text += ' Go to NORMALIZATION, and select a high value'
        status_text += ' for the normalization peak exclusion.'
        if (StatusMessage GT 0) then begin
            append = 1
        endif else begin
            append = 0
        endelse
        putInfoInReductionStatus, Event, status_text, append
        StatusMessage += 1
     endelse
    
    if (StatusMessage GT 0) then begin
        append = 1
    endif else begin
        append = 0
    endelse
    putInfoInReductionStatus, Event, status_text, append

;Be sure that (Ymin_peak=Ymin_back && Ymax_peak=Ymax_back) is wrong
Ymin_peak = norm_peak_exclusion_min
Ymax_peak = norm_peak_exclusion_max
Ymin_back = $
  strcompress(getTextFieldValue(Event, $
                                'normalization_d_selection_background_ymin_cw_field'), $
              /remove_all)
Ymax_back = $
  strcompress(getTextFieldValue(Event, $
                                'normalization_d_selection_background_ymax_cw_field'),$
              /remove_all)

IF (Ymin_peak NE '' AND $
    Ymax_peak NE '' AND $
    Ymin_back NE '' AND $
    Ymax_back NE '') THEN BEGIN
    IF ((Ymin_peak EQ Ymin_back) AND (Ymax_peak EQ Ymax_back)) THEN BEGIN
        StatusMessage += 1
        status_text = '- Normalization Background and Peak have the same Ymin and Ymax values.'
        status_text += ' Please changes at least 1 of the data.'
        if (StatusMessage GT 0) then begin
            append = 1
        endif else begin
            append = 0
        endelse
        putInfoInReductionStatus, Event, status_text, append
    ENDIF
ENDIF

;check if user wants normalization background or not
     if (isNormWithBackground(Event)) then begin ;yes, with background
         MapBase, Event, 'reduce_plot5_base', 0 ;back. norm. plot is available
     endif else begin
         cmd += ' --no-norm-bkg'
         MapBase, Event, 'reduce_plot5_base', 1 ;back. norm. is not available
     endelse

 endif else begin ;no normalization file

;remove Normalization Intermediate Plots
     MapBase, Event, 'reduce_plot4_base', 1
     MapBase, Event, 'reduce_plot5_base', 1
     MapBase, Event, 'reduce_plot6_base', 1
     
 endelse                        ;end of (~isWithoutNormalization)

;get name of instrument
cmd += ' --inst=' + (*global).instrument

;get Q infos
Q_min = getTextFieldValue(Event, 'q_min_text_field')
Q_max = getTextFieldValue(Event, 'q_max_text_field')
Q_width = getTextfieldValue(Event, 'q_width_text_field')
Q_scale = getQSCale(Event)
cmd += ' --mom-trans-bins='

if (Q_min NE '') then begin     ;Q_min
    cmd += strcompress(Q_min,/remove_all)
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

if (Q_max NE '') then begin     ;Q_max
    cmd += ',' + strcompress(Q_max,/remove_all)
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
    cmd += ',' + strcompress(Q_width,/remove_all)
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
cmd += ',' + Q_scale            ;Q_scale (lin or log)

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
        cmd += strcompress(angle_value,/remove_all)
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
        cmd += ',' + strcompress(angle_err,/remove_all)
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
    
    cmd += ',units=' + strcompress(angle_units,/remove_all)
    
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
if (isWithDeltaToverT(Event)) then begin ;store deltaT over T
    cmd += ' --store-dtot'
endif

;overwrite data instrument geometry file
if (isWithDataInstrumentGeometryOverwrite(Event)) then begin ;with instrument geometry
    cmd += ' --data-inst-geom=' 
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
    setButtonValue, Event, 'overwrite_data_intrument_geometry_button', button_value
endif

;overwrite norm instrument geometry file
if (isWithNormInstrumentGeometryOverwrite(Event)) then begin ;with instrument geometry
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
    setButtonValue, Event, 'overwrite_norm_instrument_geometry_button', button_value

endif

;get name from output path and name
outputPath     = (*global).dr_output_path
outputFileName = getOutputFileName(Event)
NewOutputFileName = outputPath + outputFileName
cmd += ' --output=' + NewOutputFileName

;generate intermediate plots command line
IP_cmd = RefReduction_CommandLineIntermediatePlotsGenerator(Event)
cmd += IP_cmd

;display command line in Reduce text box
putTextFieldValue, Event, 'reduce_cmd_line_preview', cmd, 0

;validate or not Go data reduction button
if (StatusMessage NE 0) then begin ;do not activate button
    activate = 0
endif else begin
    activate = 1
    putInfoInReductionStatus, Event, '', 0 ;clear text field of Commnand line status
endelse

ActivateWidget, Event,'start_data_reduction_button',activate

END
