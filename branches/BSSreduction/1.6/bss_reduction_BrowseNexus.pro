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

PRO bss_reduction_BrowseNexus, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  
  DefaultPath = (*global).DefaultPath
  Filter = (*global).DefaultFilter
  Title = 'Select a NeXus file to load'
  
  ;open file
  FullNexusFileName = dialog_pickfile(path              = DefaultPath,$
    get_path          = path,$
    title             = Title,$
    filter            = filter,$
    default_extension ='.nxs',$
    /fix_filter)
    
  IF (FullNexusFileName NE '') THEN BEGIN
  
    message = 'Loading NeXus file selected:'
    PutLogBookMessage, Event, message
    
    (*global).NexusFullName = FullNexusFileName
    (*global).DefaultPath = path
    
    ;nexus has been found and can be opened
    BSSreduction_LoadNexus_step2, Event, FullNexusFileName
    (*global).NeXusFound = 1
    
    IF ((*global).NeXusFound) THEN BEGIN
      ;turn off the NO MONITOR NORMALIZATION switch
      SetButton, event, 'nmn_button', 0
    ENDIF
    
    ;get run number from NeXus file itself
    no_error = 0
    catch, no_error
    IF (no_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      RunNumber = 'N/A'
      
    ENDIF ELSE BEGIN
      iNexus = OBJ_NEW('IDLgetMetadata', FullNexusFileName)
      RunNumber = iNexus->getRunNumber()
      OBJ_DESTROY, iNexus
    ENDELSE
    
    ;save run number
    (*global).RunNumber = RunNumber
    
    ;reset NeXus run number cw_field
    putRunNumberValue, Event, RunNumber
    putValue, event, 'rsdf_run_number_cw_field', $
      strcompress(RunNumber,/remove_all)
      
  endif else begin
  
  ;left browse box without doing anything
  
  endelse
  
  ;turn off hourglass
  widget_control,hourglass=0
  
END
