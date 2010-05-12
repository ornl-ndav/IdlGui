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

PRO REFreduction_DefineOutputPath, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  widget_control,id,get_uvalue=global
  path = DIALOG_PICKFILE(/DIRECTORY,$
    dialog_parent=id,$
    PATH = (*global).dr_output_path,$
    TITLE = 'Select a folder',$
    /MUST_EXIST)
  miniVersionLength = 10
  maxiVersionLength = 40
  IF (path NE '') THEN BEGIN
    (*global).dr_output_path = path
    length = strlen(path)
    IF ((*global).miniVersion EQ 1) THEN BEGIN
      IF (length GT miniVersionLength) THEN BEGIN
        path = '[...]' + strmid(path,length-miniVersionLength,miniVersionLength)
      ENDIF
    ENDIF ELSE BEGIN
      IF (length GT maxiVersionLength) THEN BEGIN
        path = '[...]' + strmid(path,length-maxiVersionLength,maxiVersionLength)
      ENDIF
    ENDELSE
    ;replace title of button
    SetButtonValue, Event, 'of_button', path
  ENDIF
END


PRO DefineDefaultOutputName, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;force name of output file according to time stamp
  IsoTimeStamp = RefReduction_GenerateIsoTimeStamp()
  if ((*global).instrument eq 'REF_M') then begin
    DataRunNUmber = (*global).data_run_number
  endif else begin
    DataRunNumber = (*global).DataRunNumber
  endelse
  (*global).IsoTimeStamp = IsoTimeStamp
  NewOutputFileName = (*global).instrument
  NewOutputFileName += '_' + strcompress(DataRunNumber,/remove_all)
  NewOutputFileName += '_' + strcompress(IsoTimeStamp,/remove_all)
  (*global).OutputFileName = NewOutputFileName
  ExtOfAllPlots = (*(*global).ExtOfAllPlots)
  NewOutputFileName += ExtOfAllPlots[0]
  putTextFieldValue, event, 'of_text', NewOutputFileName, 0
END


PRO REFreduction_DefineOutputFile, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  NewOutputFileName = getOutputFileName(Event)
  ;remove .txt if any
  StringArray = strsplit(NewOutputFileName,'.',/extract)
  newOutputFileName = StringArray[0]
  (*global).OutputFileName = NewOutputFileName
END
