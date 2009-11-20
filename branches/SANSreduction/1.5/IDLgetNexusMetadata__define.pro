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

;******************************************************************************
FUNCTION getNumberOfBanks, fileID
bank_nbr = 1
no_more_banks = 0
WHILE (no_more_banks NE 1) DO BEGIN
    banks_path = '/entry/bank' + strcompress(bank_nbr,/remove_all) + '/data/'
    no_more_banks = 0
    CATCH, no_more_banks
    IF (no_more_banks NE 0) THEN BEGIN
        CATCH,/CANCEL
        RETURN, (bank_nbr-1)
    ENDIF ELSE BEGIN
        pathID = h5d_open(fileID, banks_path)
        h5d_close, pathID
        ++bank_nbr
    ENDELSE
ENDWHILE
END

;------------------------------------------------------------------------------
FUNCTION getBankData, fileID, BankNbr
banks_path = '/entry/' + BankNbr + '/data/'
pathID     = h5d_open(fileID, banks_path)
data       = h5d_read(pathID)
h5d_close,pathID
RETURN, data
END

;***** Class methods **********************************************************
FUNCTION IDLgetNexusMetadata::getNbrBank
RETURN, self.bank_number
END

;------------------------------------------------------------------------------
FUNCTION IDLgetNexusMetadata::getData
RETURN, self.data
END

;***** Class constructor ******************************************************
FUNCTION IDLgetNexusMetadata::init, $
                            nexus_full_path, $
                            NbrBank    = NbrBank,$
                            BankData   = BankData,$
                            Instrument = Instrument
;open hdf5 nexus file
file_error = 0
CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
ENDELSE

;IF (n_elements(Instrument) NE 0) THEN BEGIN
;    IF (Instrument EQ 'ARCS') THEN BEGIN
;        self.bank_number = 115
;    ENDIF ELSE BEGIN
;        self.bank_number = getNumberOfBanks(fileID)
;    ENDELSE
;ENDIF ELSE BEGIN
;    IF (n_elements(NbrBank) NE 0) THEN BEGIN
;;get NumberOfBanks
;        self.bank_number = getNumberOfBanks(fileID)
;    ENDIF
;ENDELSE

IF (n_elements(BankData) NE 0) THEN BEGIN
;get Bank data
    self.data = ptr_new(getBankData(fileID,STRCOMPRESS(BankData,/REMOVE_ALL)))
ENDIF

;close hdf5 nexus file
h5f_close, fileID

RETURN, 1
END

;******************************************************************************
PRO IDLgetNexusMetadata__define
struct = {IDLgetNexusMetadata,$
          RunNumber       : '',$
          nexus_full_path : '',$
          data            : ptr_new(),$
          bank_number     : 0}
END
