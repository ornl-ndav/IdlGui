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

;-------------------------------------------------------------------------------
FUNCTION getBankData, fileID, BankNbr
banks_path = '/entry/bank' + strcompress(BankNbr,/remove_all) + '/data/'
pathID     = h5d_open(fileID, banks_path)
data       = h5d_read(pathID)
h5d_close,pathID
RETURN, data
END

;***** Class methods ***********************************************************
FUNCTION IDLgetNexusMetadata::getNbrBank
RETURN, self.bank_number
END

;-------------------------------------------------------------------------------
FUNCTION IDLgetNexusMetadata::getData
RETURN, self.data
END

;***** Class constructor *******************************************************
FUNCTION IDLgetNexusMetadata::init, nexus_full_path, $
                            NbrBank  = NbrBank,$
                            BankData = BankData
;open hdf5 nexus file
file_error = 0
CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
ENDELSE

IF (n_elements(NbrBank) NE 0) THEN BEGIN
;get NumberOfBanks
    self.bank_number = getNumberOfBanks(fileID)
ENDIF

IF (n_elements(BankData) NE 0) THEN BEGIN
;get Bank data
    self.data = ptr_new(getBankData(fileID,BankData))
ENDIF

;close hdf5 nexus file
h5f_close, fileID

RETURN, 1
END

;*******************************************************************************
PRO IDLgetNexusMetadata__define
struct = {IDLgetNexusMetadata,$
          RunNumber       : '',$
          nexus_full_path : '',$
          data            : ptr_new(),$
          bank_number     : 0}
END
