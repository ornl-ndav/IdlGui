;*******************************************************************************
;*******************************************************************************

;Start working with DATA field
PRO BatchTab_ChangeDataNormRunNumber, Event
;indicate initialization with hourglass icon
widget_control,/hourglass
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    message = 'Please check the DATA RUNS input (ex: 3004,3004,3005) '
    result = DIALOG_MESSAGE(message,$
                            /ERROR)
    ;Hide processing base
    MapBase, Event, 'processing_base', 0
    SetBaseYSize, Event, 'processing_base', 50
    value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
    putLabelValue, Event, 'pro_top_label', value
    (*global).batch_process = 'data'
;turn off hourglass
    widget_control,hourglass=0
ENDIF ELSE BEGIN
;Display processing base
    MapBase, Event, 'processing_base', 1
;current row selected
    RowSelected = (*global).PrevBatchRowSelected
;retrieve main table
    BatchTable = (*(*global).BatchTable)
;cmd string is
    cmd = BatchTable[7,RowSelected]
;get first part of cmd ex: srun -Q -p lracq reflect_reduction
    split1      = 'reflect_reduction'
    part1_array = strsplit(cmd,split1,/extract,/regex)
    part1       = part1_array[0]
;get second part (after data runs)
    split2                  = '--data-roi-file'
    (*global).batch_split2  = split2
    part2_array             = strsplit(cmd,split2,/extract,/regex)
    part2                   = part2_array[1]
    (*global).batch_part2   = part2
    new_cmd                 = STRTRIM(part1) + ' ' + split1
    (*global).batch_new_cmd = new_cmd
;get data run cw_field
    data_runs = getTextFieldValue(Event,'batch_data_run_field_status')
    IF (data_runs NE '') THEN BEGIN
        DataNexus = getNexusFromRunArray(Event, data_runs, (*global).instrument)
        (*(*global).batch_data_runs) = data_runs
        (*(*global).batch_DataNexus) = DataNexus
;check that the NeXus have the same angle, S1 and S2 values
        sz = (size(DataNeXus))(1)
        IF (sz GT 1) THEN BEGIN
            AngleArray = strarr(sz)
            S1Array    = strarr(sz)
            S2Array    = strarr(sz)
            FOR i=0,(sz-1) DO BEGIN
                entry = obj_new('IDLgetMetadata',DataNexus[i])
                AngleArray[i] = strcompress(entry->getAngle())
                S1Array[i]    = strcompress(entry->getS1())
                S2Array[i]    = strcompress(entry->getS2())
            ENDFOR
            
;Check if they are identical or not
            SameStatus = 1
;check Angle 
            AngleAreIdentical = areDataIdentical(Event, AngleArray)
            IF (AngleAreIdentical NE 1) THEN BEGIN
                SameStatus = 0
            ENDIF ELSE BEGIN
;check S1
                S1AreIdentical = areDataIdentical(Event, S1Array)
                IF (S1AreIdentical NE 1) THEN BEGIN
                    SameStatus = 0
                ENDIF ELSE BEGIN
;check S2
                    S2AreIdentical = areDataIdentical(Event, S2Array)
                    IF (S2AreIdentical NE 1) THEN BEGIN
                        SameStatus = 0
                    ENDIF
                ENDELSE
            ENDELSE
            
;inform user that the values do not match if SameStatus is not 1
            IF (SameStatus NE 1) THEN BEGIN
;Populate ProTable with angle, S1 and s2 values
                ProArray = strarr(4,10)
                FOR j=0,(sz-1) DO BEGIN
                    ProArray[0,j] = data_runs[j]
                    ProArray[1,j] = AngleArray[j]
                    ProArray[2,j] = S1Array[j]
                    ProArray[3,j] = S2Array[j]
                ENDFOR
                id = widget_info(Event.top,find_by_uname='pro_table')
                widget_control, id, set_value=ProArray
;change size of processing base
                SetBaseYSize, Event, 'processing_base', 365
;change top label
                value = 'PROCESSING  NEW  DATA  INPUT  . . .  CONTINUE OR NOT ? '
                putLabelValue, Event, 'pro_top_label', value
            ENDIF ELSE BEGIN
                Continue_ChangeDataRunNumber, Event, $
                  RowSelected,$
                  data_runs, $
                  DataNexus,$
                  split2,$
                  part2,$
                  BatchTable,$
                  new_cmd
            ENDELSE
        ENDIF ELSE BEGIN
            Continue_ChangeDataRunNumberForOneRun, Event, $
              RowSelected,$
              data_runs, $
              DataNexus,$
              split2,$
              part2,$
              BatchTable,$
              new_cmd
        ENDELSE
    ENDIF ELSE BEGIN
        value = 'PLEASE SPECIFY AT LEAST ONE DATA RUN NUMBER'
        putLabelValue, Event, 'pro_top_label', value
        WAIT, 3
;Hide processing base
        MapBase, Event, 'processing_base', 0
        SetBaseYSize, Event, 'processing_base', 50
;generate a new batch file name
        GenerateBatchFileName, Event
;turn off hourglass
        widget_control,hourglass=0
        value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
        putLabelValue, Event, 'pro_top_label', value
        (*global).batch_process = 'data'
    ENDELSE
ENDELSE ;end of CATCH statement
END

;*******************************************************************************

PRO  Continue_ChangeDataRunNumberForOneRun, Event, $
                                            RowSelected,$
                                            data_runs, $
                                            DataNexus,$
                                            split2,$
                                            part2,$
                                            BatchTable,$
                                            new_cmd

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;Update values of S1, S2 and AngleValue
DataNexus = getNexusFromRunArray(Event, data_runs, (*global).instrument)
entry = obj_new('IDLgetMetadata',DataNexus)
AngleValue = strcompress(entry->getAngle())
S1Value    = strcompress(entry->getS1())
S2Value    = strcompress(entry->getS2())

UpdateAngleField, Event, AngleValue
UpdateS1Field, Event, S1Value
UpdateS2Field, Event, S2Value

BatchTable[3,RowSelected] = AngleValue
BatchTable[4,RowSelected] = S1Value
BatchTable[5,RowSelected] = S2Value

DataRunsJoined = strjoin(data_runs,',')
BatchTable[1,RowSelected] = DatarunsJoined
IF (DataNexus[0] NE '') THEN BEGIN
    sz = (size(DataNexus))(1)
    FOR i=0,(sz-1) DO BEGIN
        new_cmd += ' ' + DataNexus[i]
    ENDFOR
ENDIF
new_cmd += ' ' + split2 + part2
;change the --output flag in the cmd
new_cmd = UpdateOutputFlag(Event, new_cmd, DataRunsJoined[0])
;put new_cmd back in the BatchTable
BatchTable[7,RowSelected] = new_cmd
;update command line
putTextFieldValue, Event, 'cmd_status_preview', new_cmd, 0
;update DATE field with new date/time stamp
NewDate = GenerateDateStamp2()
BatchTable[6,RowSelected] = NewDate
;Save BatchTable back to Global
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
SetBaseYSize, Event, 'processing_base', 50
;change top label
value  = 'PROCESSING  NEW  NORMALIZATION  INPUT  . . .  '
value += '( P L E A S E   W A I T ) '
putLabelValue, Event, 'pro_top_label', value

;continue with normalization
ChangeNormRunNumber, Event

END

;*******************************************************************************

PRO  Continue_ChangeDataRunNumber, Event, $
                                   RowSelected,$
                                   data_runs, $
                                   DataNexus,$
                                   split2,$
                                   part2,$
                                   BatchTable,$
                                   new_cmd

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DataRunsJoined = strjoin(data_runs,',')
BatchTable[1,RowSelected] = DatarunsJoined
IF (DataNexus[0] NE '') THEN BEGIN
    sz = (size(DataNexus))(1)
    FOR i=0,(sz-1) DO BEGIN
        new_cmd += ' ' + DataNexus[i]
    ENDFOR
ENDIF
new_cmd += ' ' + split2 + part2
;change the --output flag in the cmd
new_cmd = UpdateOutputFlag(Event, new_cmd, DataRunsJoined[0])
;put new_cmd back in the BatchTable
BatchTable[7,RowSelected] = new_cmd
;update command line
putTextFieldValue, Event, 'cmd_status_preview', new_cmd, 0
;update DATE field with new date/time stamp
NewDate = GenerateDateStamp2()
BatchTable[6,RowSelected] = NewDate
;Save BatchTable back to Global
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
SetBaseYSize, Event, 'processing_base', 50
;change top label
value  = 'PROCESSING  NEW  NORMALIZATION  INPUT  . . .  '
value += '( P L E A S E   W A I T ) '
putLabelValue, Event, 'pro_top_label', value

;continue with normalization
ChangeNormRunNumber, Event

END

;*******************************************************************************
pro ChangeNormRunNumber, Event

;indicate initialization with hourglass icon
widget_control,/hourglass
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;we are working with normalization file now
(*global).batch_process = 'norm'
;Display processing base
MapBase, Event, 'processing_base', 1
;current row selected
RowSelected = (*global).PrevBatchRowSelected
;retrieve main table
BatchTable = (*(*global).BatchTable)
;cmd string is
cmd = BatchTable[7,RowSelected]

;start working with the NORMALIZATION runs
;get first part of cmd, before --norm=
split1      = '--norm='
part1_array = strsplit(cmd,split1,/extract,/regex)
part1       = part1_array[0]
;get second part (after data runs)
split2      = '--norm-roi-file'
(*global).batch_split2 = split2
part2_array = strsplit(cmd,split2,/extract,/regex)
sz = (size(part2_array))(1)
IF (sz GT 1) THEN BEGIN
    part2       = part2_array[1]
    (*global).batch_part2 = part2
    new_cmd = part1 + STRTRIM(split1)
    (*global).batch_new_cmd = new_cmd
;get data run cw_field
    norm_runs = getTextFieldValue(Event,'batch_norm_run_field_status')
    NormNexus = getNexusFromRunArray(Event, norm_runs, (*global).instrument)
    (*(*global).batch_norm_runs)  = norm_runs
    (*(*global).batch_NormNexus)  = NormNexus
;check that the NeXus have the same angle, S1 and S2 values
    sz = (size(NormNexus))(1)
    IF (sz GT 1) THEN BEGIN
        AngleArray = strarr(sz)
        S1Array    = strarr(sz)
        S2Array    = strarr(sz)
        FOR i=0,(sz-1) DO BEGIN
            entry = obj_new('IDLgetMetadata',NormNexus[i])
            AngleArray[i] = strcompress(entry->getAngle())
            S1Array[i] = strcompress(entry->getS1())
            S2Array[i] = strcompress(entry->getS2())
        ENDFOR
        
;check if they are identical or not
        SameStatus = 1
;Check angle
        AngleAreIdentical = areDataIdentical(Event, AngleArray)
        IF (AngleAreIdentical NE 1) THEN BEGIN
            SameStatus = 0
        ENDIF ELSE BEGIN
;check S1
            S1AreIdentical = areDataIdentical(Event, S1Array)
            IF (S1AreIdentical NE 1) THEN BEGIN
                SameStatus = 0
            ENDIF ELSE BEGIN
;check S2
                S2AreIdentical = areDataIdentical(Event, S2Array)
                IF (S2AreIdentical NE 1) THEN BEGIN
                    SameStatus = 0
                ENDIF
            ENDELSE
        ENDELSE
        
;inform user that the values do not match if SameStatus is not 1
        IF (SameStatus NE 1) THEN BEGIN
;Populate ProTable with angle, S1 and s2 values
            ProArray = strarr(4,10)
            FOR j=0,(sz-1) DO BEGIN
                ProArray[0,j] = norm_runs[j]
                ProArray[1,j] = AngleArray[j]
                ProArray[2,j] = S1Array[j]
                ProArray[3,j] = S2Array[j]
            ENDFOR
            id = widget_info(Event.top,find_by_uname='pro_table')
            widget_control, id, set_value=ProArray
;change size of processing base
            SetBaseYSize, Event, 'processing_base', 365
;change top label
            value = 'PROCESSING  NEW  NORMALIZATION  INPUT  . . .  '
            value += 'CONTINUE OR NOT ? '
            putLabelValue, Event, 'pro_top_label', value
        ENDIF ELSE BEGIN
            Continue_ChangeNormRunNumber, Event, $
              RowSelected,$
              norm_runs, $
              NormNexus,$
              split2,$
              part2,$
              BatchTable,$
              new_cmd
        ENDELSE
    ENDIF ELSE BEGIN
        Continue_ChangeNormRunNumber, Event, $
          RowSelected,$
          norm_runs, $
          NormNexus,$
          split2,$
          part2,$
          BatchTable,$
          new_cmd
    ENDELSE
ENDIF ELSE BEGIN ;no normalization file
;Hide processing base
    MapBase, Event, 'processing_base', 0
    SetBaseYSize, Event, 'processing_base', 50
;generate a new batch file name
    GenerateBatchFileName, Event
;turn off hourglass
    widget_control,hourglass=0
    value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
    putLabelValue, Event, 'pro_top_label', value
    (*global).batch_process = 'data'
ENDELSE
END

;*******************************************************************************

PRO Continue_ChangeNormRunNumber, Event,$
                                  RowSelected,$
                                  norm_runs, $
                                  NormNexus,$
                                  split2,$
                                  part2,$
                                  BatchTable,$
                                  new_cmd
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

NormRunsJoined = strjoin(norm_runs,',')
BatchTable[2,RowSelected] = NormRunsJoined
IF (NormNexus[0] NE '') THEN BEGIN
    sz = (size(NormNexus))(1)
    FOR i=0,(sz-1) DO BEGIN
        IF (i EQ 0) THEN BEGIN
            new_cmd += NormNexus[i]
        ENDIF ELSE BEGIN
            new_cmd += ',' + NormNexus[i]
        ENDELSE
    ENDFOR
ENDIF

new_cmd += ' ' + split2 + part2
;change the --output flag in the cmd
;new_cmd = UpdateOutputFlag(Event, new_cmd, NormRunsJoined[0])
;put new_cmd back in the BatchTable
BatchTable[7,RowSelected] = new_cmd
;update DATE field with new date/time stamp
NewDate = GenerateDateStamp2()
BatchTable[6,RowSelected] = NewDate
;Save BatchTable back to Global
(*(*global).BatchTable) = BatchTable
DisplayBatchTable, Event, BatchTable
;Update info of selected row
DisplayInfoOfSelectedRow, Event, RowSelected
;Hide processing base
MapBase, Event, 'processing_base', 0
SetBaseYSize, Event, 'processing_base', 50
;generate a new batch file name
GenerateBatchFileName, Event
;turn off hourglass
widget_control,hourglass=0
value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
putLabelValue, Event, 'pro_top_label', value
(*global).batch_process = 'data'
END

;*******************************************************************************

PRO BatchTab_ContinueProcessing, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

CurrentProcess = (*global).batch_process 
IF (CurrentProcess eq 'data') THEN BEGIN
;reset value of top label
    SetBaseYSize, Event, 'processing_base', 50
    value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
    putLabelValue, Event, 'pro_top_label', value
;continue processing here
    RowSelected = (*global).PrevBatchRowSelected
    data_runs   = (*(*global).batch_data_runs)
    DataNexus   = (*(*global).batch_DataNexus)
    split2      = (*global).batch_split2
    part2       = (*global).batch_part2
    BatchTable  = (*(*global).BatchTable)
    new_cmd     = (*global).batch_new_cmd
    
    Continue_ChangeDataRunNumber, Event, $
      RowSelected,$
      data_runs, $
      DataNexus,$
      split2,$
      part2,$
      BatchTable,$
      new_cmd

ENDIF ELSE BEGIN
;reset value of top label
    SetBaseYSize, Event, 'processing_base', 50
    value  = 'PROCESSING  NEW  NORMALIZATION  INPUT  . . .'
    value += '( P L E A S E   W A I T ) '
    putLabelValue, Event, 'pro_top_label', value
;continue processing here
    RowSelected = (*global).PrevBatchRowSelected
    norm_runs   = (*(*global).batch_norm_runs)
    NormNexus   = (*(*global).batch_NormNexus)
    split2      = (*global).batch_split2
    part2       = (*global).batch_part2
    BatchTable  = (*(*global).BatchTable)
    new_cmd     = (*global).batch_new_cmd
    
    Continue_ChangeNormRunNumber, Event, $
      RowSelected,$
      norm_runs, $
      NormNexus,$
      split2,$
      part2,$
      BatchTable,$
      new_cmd
ENDELSE
END

;*******************************************************************************

PRO BatchTab_StopProcessing, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
CurrentProcess = (*global).batch_process 
IF (CurrentProcess eq 'data') THEN BEGIN
    SetBaseYSize, Event, 'processing_base', 50
;change top label
    value  = 'PROCESSING  NEW  NORMALIZATION  INPUT  . . .  '
    value += '( P L E A S E   W A I T ) '
    putLabelValue, Event, 'pro_top_label', value
    ChangeNormRunNumber, Event
ENDIF ELSE BEGIN
    MapBase, Event, 'processing_base', 0
;reset value of top label
    value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
    putLabelValue, Event, 'pro_top_label', value
    SetBaseYSize, Event, 'processing_base', 50
    (*global).batch_process = 'data'
ENDELSE
END

;*******************************************************************************
;*******************************************************************************
