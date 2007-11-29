;internal class method to get the extension
FUNCTION IDLoutputFile::getExtension, file_title
CASE (file_title) OF
    'Calculated Time-Independent Background': return, '_data.tib'
    'Pixel Wavelength Spectrum': return, '_data.pxl'
    'Monitor Wavelngth Spectrum': return, '_data.mxl'
    'Monitor Efficiency Spectrum': return, '_data.mel'
    'Rebinned Monitor Spectrum': return, '_data.mrl'
    'Combined Pixel Spectrum After Monitor Normalization': return, '_data.pml'
    'Pixel Initial Energy Spectrum': return, '_data.ixl'
    'Pixel Energy Transfer Spectrum': return, '_data.exl'
    'linearly Interpolated Direct Scattering Back. Info. Summed over all Pixels': return, '_data.lin'
    'S(E)': return, '.etr'
    'sigma(E)': return, '.setr'
    else: 
ENDCASE
return, ''
END


FUNCTION IDLoutputFile::getOutputFileName, Event
FileExt = self.file_extension
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
output_file_name = getTextFieldValue(Event, 'of_list_of_runs_text')
IF (output_file_name EQ '') THEN BEGIN
;get run number used by Data Reduction
    run_number = getDRrunNumber(Event)
    output_file_name = 'BSS_' + strcompress(run_number,/remove_all)
    output_file_name += FileExt
;get path
    cd, CURRENT=current_path
    output_file_name = current_path + '/' + output_file_name
ENDIF ELSE BEGIN
;get path (if any)
    pathArray = strsplit(output_file_name,'/',/extract)
    sz = (size(pathArray))(1)
    if (sz GT 1) then begin     ;a path has been given
;if left part is '~' or '/' do not do anything
        IF (pathArray[0] EQ '~' OR $
            strmatch(output_file_name,'/*')) THEN BEGIN ;nothing to do here
        endif else begin
;get current path
            cd, CURRENT=current_path
            output_file_name = current_path + '/' + output_file_name
        endelse
    endif else begin            ;just a file name        
;get current path
        cd, CURRENT=current_path
        output_file_name = current_path + '/' + output_file_name
    endelse
    dotArray = strsplit(output_file_name,'.',/extract)
    output_file_name = dotArray[0] + '.' + FileExt
ENDELSE
RETURN, output_file_name
END


;This function retrieves the metadata 
FUNCTION IDLoutputFile::getMD
FullFileName = self.full_file_name
cmd = 'head -n 20 ' + FullFileName
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    return, ['']
ENDIF ELSE BEGIN
    spawn, cmd, listening
    EmptyLine = where(listening EQ '') 
    return, listening[0:EmptyLine-1]
ENDELSE
END


;This function retrieves the data
PRO IDLoutputFile::getD
FullFileName = self.full_file_name

error_plot_status = 0
;catch, error_plot_status
if (error_plot_status NE 0) then begin
;    CATCH,/cancel
endif else begin
    openr,u,FullFileName,/get
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
    while (NOT eof(u)) do begin
        readu,u,onebyte         ;,format='(a1)'
        fs = fstat(u)
        if fs.cur_ptr EQ 0 then begin 
            point_lun,u,0
        endif else begin
            point_lun,u,fs.cur_ptr - 1
        endelse
        
        true = 1
        case true of
            
            ((onebyte LT 48) OR (onebyte GT 57)): begin
                                ;case where we have non-numbers
                Nelines = Nelines + 1
                readf,u,tmp
            end
            
            else: begin
                                ;case where we (should) have data
                Ndlines = Ndlines + 1
                
                catch, Error_Status
                if Error_status NE 0 then begin
                    CATCH, /CANCEL
                endif else begin
                    readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                    flt0 = [flt0,float(tmp0)] ;x axis
                    flt1 = [flt1,float(tmp1)] ;y axis
                    flt2 = [flt2,float(tmp2)] ;y_error axis
                endelse
                
            end
        endcase
        
    endwhile
    
;strip -1 from beginning of each array
    flt0 = flt0[1:*]
    flt1 = flt1[1:*]
    flt2 = flt2[1:*]
    
    close,u
    free_lun,u
    
    self.x_axis = ptr_new(flt0)
    self.y_axis = ptr_new(flt1)
    self.error_axis = ptr_new(flt2)

ENDELSE
END


;***** Class Constructor *****
FUNCTION IDLoutputFile::init, Event, file_title
IF (n_elements(file_title) EQ 0) THEN RETURN, 0
self.file_title = file_title
self.file_extension = self->getExtension(file_title)
self.full_file_name = self->getOutputFileName(Event)

;check if file exists
spawn, 'ls ' + self.full_file_name, listening
if(strmatch(self.full_file_name,listening[0])) THEN BEGIN
    self.metadata = ptr_new(self->getMD())
    self->getD
endif else begin
    self.error = 1
endelse
RETURN, 1
END

;***** Class Destructor *****
PRO IDLoutputFile::cleanup
ptr_free, self.metadata
ptr_free, self.data
END

;***** Get Metadata *****
FUNCTION IDLoutputFile::getMetadata
END

;***** Get Data *****
FUNCTION IDLoutputFile::getData
END

;***** Get Extension *****
FUNCTION IDLoutputFile::getFileExtension
RETURN, self.file_extension
END

;***** Get FullFileName *****
FUNCTION IDLoutputFile::getFullFileName
RETURN, self.full_file_name
END

;***** Get Metadata *****
FUNCTION IDLoutputFile::getMetadata
RETURN, *self.metadata
END

;***** Get x-axis *****
FUNCTION IDLoutputFile::getX
RETURN, *self.x_axis
END

;***** Get y-axis *****
FUNCTION IDLoutputFile::getY
RETURN, *self.y_axis
END

;***** Get error-axis *****
FUNCTION IDLoutputFile::getError
RETURN, *self.error_axis
END

;***** Get error status *****
FUNCTION IDLoutputFile::getErrorStatus
RETURN, self.error
END


PRO IDLoutputFile__define
define = {IDLoutputFile,$
          error          : 0,$
          file_title     : '',$
          full_file_name : '',$
          file_extension : '',$
          metadata       : ptr_new(),$
          x_axis         : ptr_new(),$
          y_axis         : ptr_new(),$
          error_axis     : ptr_new()}
END
