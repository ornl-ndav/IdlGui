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

;This function is reached by all the cw_field of the load tab (first
;tab of the REDUCE tab)
PRO LoadNeXus, Event, cw_field_uname, text_field_uname
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global
;retrieve global parameters
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
;retrieve run number
RunNumber = getTextFieldValue(Event,cw_field_uname)
CASE (cw_field_uname) OF
    'data_run_number_cw_field':    message = '-> Loading Data Run Number '
    'solvant_run_number_cw_field': BEGIN
        message = '-> Loading Solvant Buffer Only Run Number '
    END
    'empty_run_number_cw_field':   BEGIN
        message = '-> Loading Empty Can Run Number '
    END
    'open_run_number_cw_field':    BEGIN
        message = '-> Loading Open Beam (shutter open) Run Number '
    END
    'dark_run_number_cw_field':    BEGIN
        message = '-> Loading Dark Current (shutter closed) Run Number '
    END
    'sample_data_transmission_run_number_cw_field': BEGIN
        message = '-> Loading Sample Data Transmission Run Number '
    END
    'empty_can_transmission_run_number_cw_field': BEGIN
        message = '-> Loading Empty Can Transmission Run Number '
    END
    'solvent_transmission_run_number_cw_field': BEGIN
        message = '-> Loading Solvent Transmission Run Number '
    END
    ELSE: message = ''
ENDCASE
IF (RunNumber NE 0) THEN BEGIN
    message += STRCOMPRESS(RunNumber,/REMOVE_ALL)
    IDLsendToGeek_addLogBookText, Event, message
;look for NeXus file
    isNexusExist = 0
    proposal_index = getProposalIndex(Event)
    IF (proposal_index NE 0) THEN BEGIN
        proposal = getProposalSelected(Event)
    ENDIF ELSE BEGIN
        proposal = 0
    ENDELSE
    full_nexus_name = find_full_nexus_name(Event,$
                                           RunNumber,$
                                           'SANS',$
                                           isNexusExist,$
                                           proposal_index,$
                                           proposal)
    full_nexus_name = full_nexus_name[0]
    IF (isNexusExist EQ 1 AND $ 
        full_nexus_name NE '') THEN BEGIN ;success
        message = '--> NeXus File Name : ' + full_nexus_name
        IDLsendToGeek_addLogBookText, Event, message
;display full path in text_field
        putTextFieldValue, Event, text_field_uname, full_nexus_name
    ENDIF ELSE BEGIN ;failed
        message = '--> NeXus has not been found'
        IDLsendToGeek_addLogBookText, Event, message
    ENDELSE
ENDIF
END

;This function is reached by all the BROWSE buttons of the load tab (first
;tab of the REDUCE tab)
PRO BrowseNexus, Event, browse_button_uname, text_field_uname
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global
;retrieve global parameters
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
extension  = (*global).nexus_extension
filter     = (*global).nexus_filter
path       = (*global).nexus_path

title = 'Browse for a '
CASE (browse_button_uname) OF
    'data_browse_button':    title1 = 'Data NeXus file'
    'roi_browse_button':     BEGIN
        title1 = 'ROI file'
        extension = (*global).roi_extension
        filter    = (*global).roi_filter
        path      = (*global).roi_path
    END
    'solvant_browse_button': title1 = 'Solvant Buffer Only NeXus file'
    'empty_browse_button':   title1 = 'Empty Can NeXus file'
    'open_browse_button':    title1 = 'Open Beam (shutter open) NeXus file'
    'dark_browse_button':    title1 = 'Dark Current (shutter closed) ' + $
      'NeXus file'
    'sample_data_transmission_browse_button': title1 = $
      'Sample Data Transmission Nexus file'
    'empty_can_transmission_browse_button': title1 = $
      'Empty Can Transmission Nexus file'
    'solvent_transmission_browse_button': title1 = $
      'Solvent Transmission Nexus file'
    ELSE: title1 = ''
ENDCASE
title += title1
message = '-> Browsing for a ' + title1 + ' :'
IDLsendToGeek_addLogBookText, Event, message        
FullNexusName = BrowseRunNumber(Event, $ ;IDLloadNexus__define
                                extension, $
                                filter, $
                                title,$
                                GET_PATH=new_path,$
                                path)
IF (FullNexusName NE '') THEN BEGIN
;change default path
    (*global).nexus_path = new_path
;display full path in text_field
    putTextFieldValue, Event, text_field_uname, FullNexusName
;inform user in log book of file loaded
    message = '--> ' + title1 + ' is now ' + FullNexusName
    IDLsendToGeek_addLogBookText, Event, message        
ENDIF ELSE BEGIN
    message = '--> No New ' + title1 + ' has been loaded'
    IDLsendToGeek_addLogBookText, Event, message        
ENDELSE
END

;------------------------------------------------------------------------------
;This function is reached by all the BROWSE buttons of the load tab (first
;tab of the REDUCE tab)
PRO BrowseTxt, Event, browse_button_uname, text_field_uname
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global
;retrieve global parameters
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
extension  = (*global).txt_extension
filter     = (*global).txt_filter
path       = (*global).txt_path

title = 'Browse for a '
CASE (browse_button_uname) OF
    'sample_data_transmission_browse_button': title1 = $
      'Sample Data Transmission file'
    'empty_can_transmission_browse_button': title1 = $
      'Empty Can Transmission file'
    'solvent_transmission_browse_button': title1 = $
      'Solvent Transmission file'
    ELSE: title1 = ''
ENDCASE
title += title1
message = '-> Browsing for a ' + title1 + ' :'
IDLsendToGeek_addLogBookText, Event, message        
FullTxtName = BrowseRunNumber(Event, $ ;IDLloadNexus__define
                                extension, $
                                filter, $
                                title,$
                                GET_PATH=new_path,$
                                path)
IF (FullTxtName NE '') THEN BEGIN
;change default path
    (*global).txt_path = new_path
;display full path in text_field
    putTextFieldValue, Event, text_field_uname, FullTxtName
;inform user in log book of file loaded
    message = '--> ' + title1 + ' is now ' + FullTxtName
    IDLsendToGeek_addLogBookText, Event, message        
ENDIF ELSE BEGIN
    message = '--> No New ' + title1 + ' has been loaded'
    IDLsendToGeek_addLogBookText, Event, message        
ENDELSE
END
