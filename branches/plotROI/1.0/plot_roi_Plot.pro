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

PRO PlotData, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate initialization with hourglass icon
widget_control,/hourglass

;Display status message
PROCESSING = (*global).processing
message    = 'Plotting Data ... ' + PROCESSING
putStatusMessage, Event, message

;get Nexus File Name
NexusFileName = getFullNexusFileName(Event)
;get Bank#
BankNbr = getTextFieldValue(Event,'bank_text')

;Log Book text
text = 'Plot Bank: ' + BankNbr + ' of NeXus: ' + NexusFileName
IDLsendToGeek_addLogBookText, Event, text

;add information in log book
IDLsendToGeek_addLogBookText, Event, message

NexusDataInstance = obj_new('IDLgetNexusMetadata', $
                            NexusFileName, $
                            BankData = BankNbr)

IF (OBJ_VALID(NexusDataInstance)) THEN BEGIN
    BankData = NexusDataInstance->getData()
    Data     = (*BankData)
    sz_array = size(Data)
    Ntof     = (sz_array)(1)
    Y        = (sz_array)(2)
    X        = (sz_array)(3)
    
;get ROI file Name
    ROIfileName = getRoiFileName(Event)
    
;DisplayMainPlot and ROI
    instancePlot = OBJ_NEW('IDLplotData', $
                           XSIZE       = X, $
                           YSIZE       = Y, $
                           DATA        = data,$
                           RoiFileName = ROIfileName)
    
;Informs user that it's done
    message    = 'Plotting Data ... DONE'
    putStatusMessage, Event, message
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, (*global).OK
    
ENDIF ELSE BEGIN

;Informs user that it's done
    message    = 'Plotting Data ... ERROR !'
    putStatusMessage, Event, message
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, (*global).FAILED
    
ENDELSE

;turn off hourglass
widget_control,hourglass=0

END
