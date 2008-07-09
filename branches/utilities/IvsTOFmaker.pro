FUNCTION getListOfNexus, NeXusRuns
NexusArray = STRSPLIT(NeXusRuns,'-',/EXTRACT,COUNT=nbr)
IF (nbr GT 1) THEN BEGIN
    sz = FIX(NeXusArray[1])-FIX(NeXusArray[0])
    FOR i=0,sz DO BEGIN
        IF (i EQ 0) THEN BEGIN
            NeXusList = [NeXusArray[0]]
        ENDIF ELSE BEGIN
            NeXusList = [NexusList,FIX(NexusArray[0])+i]
        ENDELSE
    ENDFOR
ENDIF ELSE BEGIN
    NeXusList = [NexusArray[0]]
ENDELSE
RETURN, STRING(NeXusList)
END




FUNCTION find_full_nexus_name, run_number, proposal, instrument
cmd = "findnexus --archive -i" + instrument 
IF (proposal NE '') THEN BEGIN
    cmd += ' --proposal=' + proposal
ENDIF
cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name, err_listening
;check if nexus exists
sz = (size(full_nexus_name))(1)
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"ERROR*")
    IF (result GE 1) THEN BEGIN
        RETURN, ''
    ENDIF ELSE BEGIN
        return, full_nexus_name
    ENDELSE
endif else begin
    return, full_nexus_name[0]
endelse
end





FUNCTION getFullNexusList, ListNexus, proposal, instrument
sz = (size(listNexus))(1)
IF (sz EQ 1) THEN BEGIN
    return,[find_full_nexus_name(ListNexus[0],proposal,instrument)]
ENDIF ELSE BEGIN
    FOR i=0,(sz-1) DO BEGIN
        IF (i EQ 0) THEN BEGIN
            FullNexusList = [find_full_nexus_name(ListNexus[i], $
                                                  proposal, $
                                                  instrument)] 
        ENDIF ELSE BEGIN
            FullNexusList = [FullNexusList, $
                             find_full_nexus_name(ListNexus[i], $
                                                  proposal, $
                                                  instrument)]
        ENDELSE
    ENDFOR
    RETURN, FullNexusList
ENDELSE
END


;this function is going to retrive the tof array
FUNCTION retrieveTOF, FullNexusName
fileID  = h5f_open(FullNexusName)
;get tof
fieldID = h5d_open(fileID,'/entry/bank1/time_of_flight')
RETURN, h5d_read(fieldID)
END


FUNCTION retrieveBanksData, FullNexusName
fileID  = h5f_open(FullNexusName)
;get bank1 data
fieldID = h5d_open(fileID,'/entry/bank1/data')
bank1 = h5d_read(fieldID)
;get bank2 data
fieldID = h5d_open(fileID,'/entry/bank2/data')
bank2 = h5d_read(fieldID)
RETURN, bank1+bank2
END


FUNCTION retrieveStringArray, FileName, NbrElement
openr, u, FileName, /get
onebyte = 0b
tmp = ''
i = 0
NbrLine = getNbrLines(FileName)
FileArray = strarr(NbrLine)
while (NOT eof(u)) do begin
    readu,u,onebyte
    fs = fstat(u)
    if (fs.cur_ptr EQ 0) then begin
        point_lun,u,0
    endif else begin
        point_lun,u,fs.cur_ptr - 1
    endelse
    readf,u,tmp
    FileArray[i++] = tmp
endwhile
close, u
free_lun,u
NbrElement = i ;nbr of lines
RETURN, FileArray
END


FUNCTION getPixelIDfromRoiString, Event, RoiString, display_info, error_status

RoiStringArray = strsplit(RoiString,'_',/EXTRACT)

ON_IOERROR, L1

bank = RoiStringArray[0]
Y    = Fix(RoiStringArray[1])
X    = Fix(RoiStringArray[2])

END




FUNCTION retrievePixelExcludedArray, ROIFileName

;put each line of the file into a strarray
NbrElement = 0
FileArray = retrieveStringArray(ROIFileName, NbrElement)
;Create Excluded Array
PixelExcludedArray = MAKE_ARRAY(64L*64L*2,/INTEGER,VALUE=1)
;display_info = 1 if we want to see a sample
FOR i=0,(NbrElement-1) DO BEGIN
    IF (WHERE(i EQ RoiPreviewArray) NE -1) THEN BEGIN
        display_info = 1
    ENDIF
    pixelid = getPixelIDfromRoiString(Event, FileArray[i],display_info, error_status)
    
    IF (error_status EQ 1) THEN BEGIN
        break
    ENDIF
    
    PixelExcludedArray[pixelid] = 0
    
    IF (display_info EQ 1) THEN display_info = 0 

ENDFOR

(*global).ROI_error_status = error_status
(*(*global).pixel_excluded) = PixelExcludedArray
(*(*global).pixel_excluded_base) = PixelExcludedArray

END



















PRO IvsTOFmaker, ROIfilename=ROIfilename, $
                 PROPOSAL=proposal,$
                 INSTRUMENT=instrument,$
                 NeXusRuns=NeXusRuns

IF (N_ELEMENTS(NexusRuns) EQ 0) THEN BEGIN
    PRINT, "Please provide a set of runs: '1300-1310' or '1300')!"
    RETURN
ENDIF

;get list of NeXus
ListNexus = getListOfNexus(NeXusRuns)

IF (N_ELEMENTS(PROPOSAL) EQ 0) THEN PROPOSAL=''
IF (N_ELEMENTS(INSTRUMENT) EQ 0) THEN BEGIN
    PRINT, 'Please provide an instrument (BSS,REF_L,REF_M,ARCS....)!'
    RETURN
ENDIF

;get ROI array


;get list of full Nexus
FullNexusList = getFullNexusList(ListNexus,$
                                 proposal,$
                                 instrument)

sz = (size(FullNexusList))(1)
FOR i=0 DO BEGIN

    IF (FullNexusList[i] NE '') THEN BEGIN
        tof_array = retrieveTOF(FullNexusList[i])
        bank_array = retrieveBanksData(FullNexusList[i])
        



ENDFOR

END
