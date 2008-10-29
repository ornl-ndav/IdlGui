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

PRO BSSreduction_LoadNexus_step2, Event, NexusFullName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

;display full name of nexus in his label
PutNexusNameInLabel, Event, NexusFullName

message = '  -> NeXus file location: ' + NexusFullName
AppendLogBookMessage, Event, message

;retrieve bank1 and bank2
message = '  -> Retrieving bank1 and bank2 data ... ' + PROCESSING
AppendLogBookMessage, Event, message

;check if file is hdf5
nexus_file_name = strcompress(NeXusFullName,/remove_all)
IF (H5F_IS_HDF5(nexus_file_name)) THEN BEGIN
   
    retrieveBanksData, Event, strcompress(NexusFullName,/remove_all)
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
;plot bank1 and bank2
    message = '  -> Plot bank1 and bank2 ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    success = 0
    bss_reduction_PlotBanks, Event, success
ENDIF ELSE BEGIN
    success = 0
ENDELSE

IF (success EQ 0) THEN BEGIN

    putTextAtEndOfLogBookLastLine, Event, FAILED + $
      ' --> Wrong NeXus Format!', PROCESSING
    (*global).NeXusFound = 0
    (*global).NexusFormatWrong = 1 ;wrong format
;desactivate button
    activate_status = 0

    text = 'Loading Run Number ' + STRCOMPRESS((*global).RunNumber,/REMOVE_ALL)
    text += ' ... FAILED'
    putMessageBoxInfo, Event, text

ENDIF ELSE BEGIN

    (*global).NexusFormatWrong = 0 ;right format
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot counts vs TOF of full selection
    message = '  -> Plot Counts vs TOF of full selection ... ' + PROCESSING
    AppendLogBookMessage, Event, message

    IF ((*global).true_full_x_min EQ 0.0000001) THEN BEGIN
        BSSreduction_PlotCountsVsTofOfSelection, Event
    ENDIF ELSE BEGIN
        BSSreduction_PlotCountsVsTofOfSelection_Light, Event
        BSSreduction_DisplayLinLogFullCountsVsTof, Event
    ENDELSE

    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;populate ROI file name
    BSSreduction_CreateRoiFileName, Event

;plot ROI
    PlotIncludedPixels, Event

;activate button
    activate_status = 1
    
    text = 'Loading Run Number ' + STRCOMPRESS((*global).RunNumber,/REMOVE_ALL)
    text += ' ... OK'
    putMessageBoxInfo, Event, text

    (*global).lds_mode = 0

;define default output file name
    define_default_output_file_name, Event, TYPE='archive' ;_eventcb

ENDELSE

;activate or not 'save_roi_file_button', 'roi_path_button',
;'roi_file_name_generator', 'load_roi_file_button'
ActivateArray = (*(*global).WidgetsToActivate)
sz = (size(ActivateArray))(1)
FOR i=0,(sz-1) DO BEGIN
    activate_button, event, ActivateArray[i], activate_status
ENDFOR

END    
