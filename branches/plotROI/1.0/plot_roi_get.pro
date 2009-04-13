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

;Generic function that returns the contain of a text field
FUNCTION getTextFieldValue, Event, uname
id = widget_info(Event.top, find_by_uname=uname)
widget_control, id, get_value = value
RETURN, value
END

;------------------------------------------------------------------------------
;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
return, WIDGET_INFO(id, /DROPLIST_SELECT)
END

;------------------------------------------------------------------------------
;This function returns the number of row
FUNCTION getNbrLines, FileName
cmd = 'wc -l ' + FileName
SPAWN, cmd, result
Split = STRSPLIT(result[0],' ',/EXTRACT)
RETURN, Split[0]
END

;******************************************************************************
;******************************************************************************

;This function returns the contain of the run number text field
FUNCTION getRunNumber, Event
RunNumber = getTextFieldValue(Event,'nexus_run_number')
RETURN, STRCOMPRESS(RunNumber,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
;This function returns the instrument selected
FUNCTION getInstrument, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
InstrumentList = (*global).ListOFInstruments
IndexSelected  = getDropListSelectedIndex(Event,'list_of_instrument')
RETURN, InstrumentList[IndexSelected-1]
END

;------------------------------------------------------------------------------
;This function returns the full nexus file name
FUNCTION getFullNexusFileName, Event
FullNexusFileName = getTextFieldValue(Event, 'nexus_file_text_field')
RETURN, FullNexusFileName
END

;------------------------------------------------------------------------------
;This function returns the ROI file name
FUNCTION getRoiFileName, Event
RoiFileName = getTextFieldValue(Event,'roi_text_field')
RETURN, RoiFileName
END

;------------------------------------------------------------------------------
;This function returns the X and Y array of pixel to exclude
PRO getXYROI, NbrPixelExcluded, StringArray, Xarray, Yarray
NbrRow         = NbrPixelExcluded
FOR i=0,(NbrRow-1) DO BEGIN
    RoiStringArray = STRSPLIT(StringArray[i],'_',/EXTRACT)
    ON_IOERROR, L1
    Xarray[i] = Fix(RoiStringArray[1])
    Yarray[i] = Fix(RoiStringArray[2])
ENDFOR
L1: error_status = 1
END

;------------------------------------------------------------------------------
;this function gives from the droplist the value selected
FUNCTION getDropListSelectedValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
index = WIDGET_INFO(id, /DROPLIST_SELECT)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value[index]
END
