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

function retrieveDRfiles_ref_m, event, BatchTable
  compile_opt idl2
  
  ;Get Nbr of non-empty rows
  NbrRow         = getGlobalVariable('NbrRow')
  NbrRowNotEmpty = 0
  NbrDrFiles     = 0
  FOR i=0,(NbrRow-1) DO BEGIN
    IF (BatchTable[1,i] NE '') THEN BEGIN
      ++NbrRowNotEmpty
      IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
        ++NbrDrFiles
      ENDIF
    ENDIF
  ENDFOR
  
  ;check number of spin states to load
  widget_control, event.top, get_uvalue=global
  data_spin_states = (*(*global).data_spin_state)
  nbr_spin_states = get_number_of_spin_states_per_angle(data_spin_states)

  ;Create array of list of files
  DRfiles = STRARR(nbr_spin_states, NbrDrFiles)
  ;get for each row the path/output_file_name
  j=0
  FOR i=0,(NbrRowNotEmpty-1) DO BEGIN
    iRow = OBJ_NEW('idl_parse_command_line', BatchTable[9,i])
    IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
      outputPath     = iRow->getOutputPath()
      outputFileName = iRow->getOutputFileName()
      
      path_split = strsplit(outputPath,' ',/extract,count=nbr)
      file_split = strsplit(outputFileName,' ',/extract)
      index = 0
      
      while (index lt nbr) do begin
        DRfiles[index,j] = path_split[index] + file_split[index]
        index++
      endwhile
    ENDIF
    obj_destroy, iRow
    j++
  ENDFOR
  
  return, DRfiles
  
end