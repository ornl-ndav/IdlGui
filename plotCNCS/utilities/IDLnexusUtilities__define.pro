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

;Returns the NXsummary of a full nexus file name
FUNCTION getNXsummary, Event, FileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
cmd = 'nxsummary ' + FileName + ' --verbose'
spawn, cmd, listening
RETURN, listening
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                           CLASS : IDLnexusUtilities                          +
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;***** Class Destructor ********************************************************
PRO IDLnexusUtilities::cleanup
ptr_free, self.full_list_nexus
ptr_free, self.nxsummary
END

;***** Get Instrument **********************************************************
FUNCTION IDLnexusUtilities::getInstrument
RETURN, self.instrument
END

;***** Get RunNumber ***********************************************************
FUNCTION IDLnexusUtilities::getRunNumber
RETURN, self.run_number
END

;***** Get Archived NeXus path *************************************************
FUNCTION IDLnexusUtilities::getArchivedNeXusPath
cmd = 'findnexus -i ' + self.instrument + ' ' + self.run_number 
cmd += ' --archive'
IF (self.proposal NE '') THEN BEGIN
    cmd += ' --proposal=' + self.proposal
ENDIF
spawn, cmd, listening
self.archived_nexus  = listening[0]
self.nexus_nxsummary = listening[0]
IF (STRMATCH(self.archived_nexus,'ERROR*') OR $
    listening[0] EQ '') THEN BEGIN
    self.nexus_found = 0
    RETURN, ''
ENDIF
self.nexus_found = 1
RETURN, listening[0]
END

;***** Get Full List of NeXus path *********************************************
FUNCTION IDLnexusUtilities::getFullListNeXusPath
cmd = 'findnexus -i ' + self.instrument + ' ' + self.run_number
cmd += ' --listall'
spawn, cmd, listening
self.full_list_nexus = ptr_new(listening)
self.nexus_nxsummary = listening[0]
IF (STRMATCH(listening[0],'ERROR*') OR $
    listening[0] EQ '') THEN BEGIN
    self.nexus_found = 0
    RETURN, ['']
ENDIF
self.nexus_found = 1
RETURN, listening
END

;***** Get bank data ***********************************************************
FUNCTION IDLnexusUtilties::getBankData, $
                         NEXUS_PATH = nexus_path, $
                         bank
IF (N_ELEMENTS(NEXUS_PATH) EQ 0) THEN BEGIN
    nexus_file_name = self.archived_nexus
ENDIF ELSE BEGIN
    nexus_file_name = nexus_path
ENDELSE
fileID  = H5F_OPEN(nexus_file_name)
bank_path = '/entry/' + bank + '/data'
fieldID = H5D_OPEN(fileID,bank_path)
RETURN, H5D_READ(fieldID)
END

;***** getNXsummary ************************************************************
FUNCTION IDLnexusUtilities::getNXsummary
cmd = 'nxsummary ' + self.nexus_nxsummary + ' --verbose'
spawn, cmd, text
self.nxsummary = ptr_new(text)
RETURN, text
END

;***** getHDF5field ************************************************************
FUNCTION IDLnexusUtilities::getHDF5field, $
                          NEXUS_PATH = nexus_path, $
                          field
IF (N_ELEMENTS(NEXUS_PATH) EQ 0) THEN BEGIN
    nexus_file_name = self.archived_nexus
ENDIF ELSE BEGIN
    nexus_file_name = nexus_path
ENDELSE
fileID  = H5F_OPEN(nexus_file_name)
fieldID = H5D_OPEN(fileID,field)
RETURN, H5D_READ(fieldID)
END

;***** Methods Used By the Class ***********************************************
FUNCTION IDLnexusUtilities::hostname
spawn, 'hostname',listening
CASE (listening) OF
    'arcs1'      : return, 'ARCS'
    'arcs2'      : return, 'ARCS'
    'bac.sns.gov': return, 'BSS'
    'bac2'       : return, 'BSS'
    'heater'     : return, ''
    'lrac'       : return, 'REF_L'
    'mrac'       : return, 'REF_M'
    ELSE         : return, ''
ENDCASE
END

;* Does NeXus exist ************************************************************
FUNCTION IDLnexusUtilities::isNexusExist
RETURN, self.nexus_found
END

;***** Class Constructor *******************************************************
FUNCTION IDLnexusUtilities::init, $
                          run_number,$
                          PROPOSAL   = proposal,$
                          INSTRUMENT = instrument

;store run number
IF (N_ELEMENTS(run_number) EQ 0) THEN RETURN, 0
self.run_number = STRCOMPRESS(run_number,/REMOVE_ALL)
;get instrument
IF (N_ELEMENTS(instrument) EQ 0) THEN BEGIN
    instrument = self->hostname()
    IF (instrument EQ '') THEN RETURN, 0
ENDIF
self.instrument = STRCOMPRESS(instrument,/REMOVE_ALL)
;proposal number
IF (N_ELEMENTS(proposal) NE 0) THEN BEGIN
    self.proposal = proposal
ENDIF
RETURN,1
END

;***** Class Define Method *****************************************************
PRO IDLnexusUtilities__define
define = {IDLnexusUtilities,$
          proposal          : '',$
          run_number        : '',$
          full_list_nexus   : ptr_new(),$
          archived_nexus    : '',$
          nexus_nxsummary   : '',$
          proposal_number   : '',$
          experiment_number : 0L,$
          instrument        : '',$
          nxsummary         : ptr_new(),$
          nexus_found       : 0}
END

          