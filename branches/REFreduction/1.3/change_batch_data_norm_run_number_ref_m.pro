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

pro change_batch_data_norm_run_number_ref_m, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  RowSelected = (*global).PrevBatchRowSelected ;current row selected
  
  ;retrieve main table
  BatchTable = (*(*global).BatchTable_ref_m)
  ;cmd string is...
  cmd = BatchTable[8,RowSelected]
  
  ;work with each data spin state independently
  split_alpha = ';'
  cmd_split = strsplit(cmd, split_alpha,/extract)
  nbr_split = n_elements(cmd_split)
  new_main_cmd = strarr(nbr_split)
  
  index = 0
  while (index lt nbr_split) do begin
  
    ;WORK ON DATA runs
    ;get first part of cmd ex: srun -Q -p lracq reflect_reduction
    split1      = 'reflect_reduction'
    part1_array = strsplit(cmd_split[index],split1,/extract,/regex)
    part1       = part1_array[0]
    ;get second part (after data runs)
    split2                  = '--data-paths='
    (*global).batch_split2  = split2
    part2_array             = strsplit(cmd_split[index],split2,/extract,/regex)
    part2                   = part2_array[1]
    (*global).batch_part2   = part2
    new_cmd                 = STRTRIM(part1) + ' ' + split1
    (*global).batch_new_cmd = new_cmd
    
    ;get data run cw_field
    data_runs = getTextFieldValue(Event,'batch_data_run_field_status')
    if (data_runs[0] eq '') then return ;stop if not data runs
    
    DataNexusFullPathList = getNexusFromRunArray(event, data_runs, $
      (*global).instrument, source_file='data')
      
    sz = n_elements(DataNexusFullPathList)
    BatchTable[1,RowSelected] = strjoin(data_runs,',')
    if (sz gt 1) then begin
      for i=0,(sz-1) do begin
        new_cmd += ' ' + DataNexusFullPathList[i]
      endfor
    endif else begin
      new_cmd += ' ' + DataNexusFullPathList[0]
    endelse
    new_cmd += ' ' + split2 + part2
    
    ;change the --output flag in the cmd
    new_cmd = UpdateOutputFlag(Event, new_cmd, data_runs[0])
    
    new_main_cmd[index] = new_cmd
    
    ;WORK on NORM runs
    split1 = ' --norm='
    part1_array = strsplit(new_main_cmd[index], split1, /extract)
    part1 = part1_array[0]
    ;get second part (after norm run)
    split2 = 
    
    
    
    
    
    
    
    
    
    
    
    
    
    index++
  endwhile
  
  new_cmd = strjoin(new_main_cmd,' ; ')
  
  ;put new_cmd back in the BatchTable
  BatchTable[8,RowSelected] = new_cmd
  ;update command line
  putTextFieldValue, Event, 'cmd_status_preview', new_cmd, 0
  ;update DATE field with new date/time stamp
  NewDate = GenerateDateStamp2()
  BatchTable[6,RowSelected] = NewDate
  ;Save BatchTable back to Global
  (*(*global).BatchTable_ref_m) = BatchTable
  DisplayBatchTable_ref_m, Event, BatchTable
  SetBaseYSize, Event, 'processing_base', 50
  ;change top label
  value  = 'PROCESSING  NEW  NORMALIZATION  INPUT  . . .  '
  value += '( P L E A S E   W A I T ) '
  putLabelValue, Event, 'pro_top_label', value
  
  
  
  
  ;work on norm file now
  
  
  ;Hide processing base
  MapBase, Event, 'processing_base', 0
  SetBaseYSize, Event, 'processing_base', 50
  ;generate a new batch file name
  GenerateBatchFileName, Event
  ;turn off hourglass
  ;  widget_control,hourglass=0
  value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
  putLabelValue, Event, 'pro_top_label', value
  (*global).batch_process = 'data'
  BatchTab_WidgetTable_ref_m, Event
  
  
  
  
  
end