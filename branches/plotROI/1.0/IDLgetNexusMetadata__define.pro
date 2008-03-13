;*******************************************************************************
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
        pathID     = h5d_open(fileID, banks_path)
        h5d_close, pathID
        ++bank_nbr
    ENDELSE
ENDWHILE
END

;***** Class methods ***********************************************************
FUNCTION IDLgetNexusMetadata::getNbrBank
RETURN, self.bank_number
END

;***** Class constructor *******************************************************
FUNCTION IDLgetNexusMetadata::init, nexus_full_path
;open hdf5 nexus file
file_error = 0
CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
ENDELSE
;get NumberOfBanks
self.bank_number = getNumberOfBanks(fileID)
;IF (self.bank_number EQ 0) THEN RETURN, 0

;close hdf5 nexus file
h5f_close, fileID

RETURN, 1
END

;*******************************************************************************
PRO IDLgetNexusMetadata__define
struct = {IDLgetNexusMetadata,$
          RunNumber       : '',$
          nexus_full_path : '',$
          bank_number     : 0}
END
