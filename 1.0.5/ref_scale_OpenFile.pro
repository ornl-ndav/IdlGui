;###############################################################################
;*******************************************************************************

;This function displays the OPEN FILE from IDL
FUNCTION OpenFile, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
widget_control, dMDAngleBaseId, map=0

title    = 'Select file:'
filter   = '*' + (*global).file_extension
pid_path = (*global).input_path

;open file
FullFileName = dialog_pickfile(PATH     = pid_path,$
                               GET_PATH = path,$
                               TITLE    = title,$
                               FILTER   = filter)

;redefine the working path
path = define_new_default_working_path(Event,FullFileName)

RETURN, FullFileName
END

;###############################################################################
;*******************************************************************************

;This function is going to open and store the new fresh open files
FUNCTION StoreFlts, Event, LongFileName, index
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF (index EQ 0) THEN BEGIN
    metadata_CE_file = (*(*global).metadata_CE_file)
ENDIF

error_plot_status = 0
catch, error_plot_status
IF (error_plot_status NE 0) THEN BEGIN
    
    CATCH,/CANCEL
    text = 'ERROR plotting data'
    displayErrorMessage, Event, text
    RETURN, 0

ENDIF ELSE BEGIN
    
    openr,u,LongFileName,/get
    fs = fstat(u)
    
;define an empty string variable to hold results from reading the file
    tmp  = ''
    tmp0 = ''
    tmp1 = ''
    tmp2 = ''
    
    flt0 = -1.0
    flt1 = -1.
    flt2 = -1.0
    
    Nelines = 0L    ;number of lines that does not start with a number
    Nndlines = 0L
    Ndlines = 0L
    onebyte = 0b
    
    WHILE (NOT eof(u)) DO BEGIN
        
        readu,u,onebyte         ;,format='(a1)'
        fs = fstat(u)
                                ;print,'onebyte: ',onebyte
                                ;rewinded file pointer one character
        
        IF (fs.cur_ptr EQ 0) THEN BEGIN 
            point_lun,u,0
        ENDIF ELSE BEGIN
            point_lun,u,fs.cur_ptr - 1
        ENDELSE
        
        true = 1
        CASE true OF
            
            ((onebyte LT 48) OR (onebyte GT 57)): BEGIN ;case where we have non-numbers
                
                Nelines = Nelines + 1
                readf,u,tmp
                
                IF (index EQ 0) THEN BEGIN
                    metadata_CE_file = [metadata_CE_file,tmp]
                ENDIF
                
            END
            
            ELSE: BEGIN         ;case where we (should) have data
                
                Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
                
                catch, Error_Status
                IF Error_status NE 0 THEN BEGIN ;you're done now...
                    CATCH, /CANCEL
                ENDIF ELSE BEGIN
                    readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                    flt0 = [flt0,float(tmp0)] ;x axis
                    flt1 = [flt1,float(tmp1)] ;y axis
                    flt2 = [flt2,float(tmp2)] ;y_error axis
                ENDELSE
            END
            
        ENDCASE
        
    ENDWHILE
    
;strip -1 from beginning of each array
    flt0 = flt0[1:*]
    flt1 = flt1[1:*]
    flt2 = flt2[1:*]
    
    close,u
    free_lun,u
    
    ;CATCH,/CANCEL
    DEVICE, DECOMPOSED = 0
    loadct,5
    
;check if input is TOF or Q
    isTOFvalidated = getButtonValidated(Event,'InputFileFormat')
    
    IF(isTOFvalidated EQ '0') THEN BEGIN ;input file is in TOF
        
;Converts the data from TOF to Q
        (*(*global).flt0_xaxis) = flt0
        angleValue = (*global).angleValue
        convert_TOF_to_Q, Event, angleValue
        flt0 = (*(*global).flt0_xaxis)
        
    ENDIF
    
;remove last 4 lines of metadata_CE_only and
;store metadata_CE_file for index 0 only
    IF (index EQ 0) THEN BEGIN
        size = (size(metadata_CE_file))(1)
        metadata_CE_file = metadata_CE_file[0:size-5]
        (*(*global).metadata_CE_file) = metadata_CE_file
    ENDIF
    
;store flt0, ftl1 and flt2 in ptrarr
    flt0_ptr = (*global).flt0_ptr
    flt0_rescale_ptr = (*global).flt0_rescale_ptr
    *flt0_ptr[index] = flt0
    *flt0_rescale_ptr[index] = flt0
    (*global).flt0_ptr = flt0_ptr
    (*global).flt0_rescale_ptr = flt0_rescale_ptr
    
    flt1_ptr = (*global).flt1_ptr
    flt1_rescale_ptr = (*global).flt1_rescale_ptr
    *flt1_ptr[index] = flt1
    *flt1_rescale_ptr[index] = flt1
    (*global).flt1_ptr = flt1_ptr
    (*global).flt1_rescale_ptr = flt1_rescale_ptr
    
    flt2_ptr = (*global).flt2_ptr
    flt2_rescale_ptr = (*global).flt2_rescale_ptr
    *flt2_ptr[index] = flt2
    *flt2_rescale_ptr[index] = flt2
    (*global).flt2_ptr = flt2_ptr
    (*global).flt2_rescale_ptr = flt2_rescale_ptr
    
ENDELSE

RETURN, 1
END

;###############################################################################
;*******************************************************************************








