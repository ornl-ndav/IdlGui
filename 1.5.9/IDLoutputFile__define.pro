function DERIV_arr, INARR
;
;
N=N_ELEMENTS(INARR)
ss = lindgen(n-1)
outarr = inarr(ss+1) - inarr(ss)
;
if (n_elements(outarr) eq 1) then outarr = outarr(0)
RETURN, outarr
END




function str2arr, instring,  delim,  array=array, delimit=delimit, $
      nomult=nomult, list=list
;
list=keyword_set(list)
nomult=keyword_set(nomult)

if n_params() eq 2 then delimit=delim       ; slf, 25-feb-92
if not keyword_set(delimit) then delimit=','
delim_len=strlen(delimit)
if n_elements(array) eq 0 then array=''
text=instring(0)                     ; expect/make scaler
maxlen=strlen(text)

; slf, optimize case where delimiter is 1 character long      - BYTE operations
if delim_len eq 1 then begin
   bdelim=byte(delimit)
   btext=byte(text)
   wdelim=where(btext eq bdelim(0),dcount)
   if dcount gt 0 then begin
      wdelim=[0,wdelim+1]      
      sizewd=deriv_arr(wdelim)-1
      array=strarr(dcount+1)
      for i=0,dcount-1 do begin
         array(i)=strmid(text,wdelim(i),sizewd(i))
      endfor
      array(i)=strmid(text,wdelim(i),strlen(text)-wdelim(i) )      
   endif else array=text
endif else begin
   occur=strpos(text,delimit)
;
   while occur(0) ne -1 do begin
      substring=strmid(text,0,occur)
      array=[temporary(array),substring]
      text=strmid(text,occur+delim_len,maxlen)
      occur=strpos(text,delimit)
   endwhile
   array=[temporary(array),text]
   array=array(1:*)
endelse


if nomult then begin
   nnulls=where(array ne '',nncnt)
   if nncnt gt 0 then array=array(nnulls)   
endif
if list then more,array

;
return,array
end 





function BSSreduction_readAsciiFile, filename, $
                                     ncols, $
                                     skip, $
                                     hskip=hskip,$
                                     delim=delim, $
                                     nocomment=nocomment, $
                                     compress=compress, $
                                     quiet=quiet, $
                                     autocol=autocol, $
                                     convert=convert, $
                                     header=header, $
                                     first_char_comm=first_char_comm

; -----------  handle input parameter setup and assign defaults -------------
; set up defaults
if not keyword_set(delim) then delim=' '    ; blank/tab is default
if not keyword_set(ncols) then ncols=1      ; default is text list
if keyword_set(hskip) then skip=-1      ; skip header
if n_elements(skip) eq 0 then skip=0
if (keyword_set(first_char_comm)) and $
  (not keyword_set(nocomment)) then nocomment = first_char_comm

qtemp=!quiet                    ; avoid global effects
!quiet=keyword_set(quiet)

; if table data (ncols gt 1) then override nocomp flag to force proper
; table alignment....
convert=keyword_set(convert)        ; convert text to numeric
autocol=keyword_set(autocol)        ; auto-determine number columns
numeric= (skip eq -1) or convert        ; 
compress= ((keyword_set(compress)) or $
            (ncols ne 1) or autocol or numeric) and (delim ne string(9b))

; for table, force removal of comment lines (returning table)
if not keyword_set(nocomment) then $
   nocomment=ncols ne 1  or autocol or convert

; ----------------------------------------------------------------------------
;
data=''                     ; initialize return
; read file into text buffer
on_ioerror, openerror
filename=filename(0)                          ;  force scalar
if strupcase(!version.os) ne 'VMS' then begin
   openr,lun,/get_lun, filename
   on_ioerror, readerror
; ---------  slf, 5-Jan-1992 read into one byte buffer for speed -------
;        (replaced read line till eof which was too slow)
   fstatus=fstat(lun)               ; determine file size
   if (fstatus.size ne 0) then begin
      btext=bytarr(fstatus.size)        ; byte buffer for all
      readu,lun,btext               ; read into byte buffer
      wlfs=where(btext eq 10b,lfcount)      ; number of line feeds
      if lfcount eq 0 then begin
     text=string(btext)                     ; NO Line feed case
      endif else begin
         btext=0                ; release memory
         text=strarr(lfcount)           ; now use string arrary
         point_lun,lun,0            ; reset to beginning
         readf,lun,text             ; read into string array
         fstatus=fstat(lun)         ; re-check status
         remainder=fstatus.size - fstatus.cur_ptr
     if remainder gt 0 then begin
             lastline=bytarr(remainder)
             readu,lun,lastline
         text=[temporary(text),string(lastline)]
     endif     
      endelse
   end else begin
      text = ''
   end
   free_lun,lun
endif else begin
   ;message,/info,'VMS Temp Fix, may be slow...'
   ;spawn,'type/nopage ' + filename,text
   text=rd_ascii(filename)
endelse

; ------------------------------------------------------------------------
; ------------ optional non-numeric header skip function ----------------
; header has non-numeric (0,1,...9 or decimal point) first character
header=keyword_set(header) or (skip eq -1)
if numeric then begin           ; auto-skip non-numerical header
   ttext=strmid(strtrim(text,1),0,1)    ; first non-blank character
   firstbyte=byte(ttext)
;  slf 21-may-94 add negative (-) to valid numeric first character
   special=where(firstbyte eq 46b or firstbyte eq 45b,dcnt)
   if dcnt gt 0 then firstbyte(special)=48b ; force in range
   numerics=where(firstbyte ge 48b and firstbyte le 57b,ncnt)
   if ncnt eq 0 then skip=0 else  skip=numerics(0)
endif

header=''
if skip ge n_elements(text) then begin
   message,/info,'Skip lines greater than file lines!'
   header=text
   text=''
endif else begin
   if skip gt 0 then header = text(0:skip-1)
   text=text(skip:*)   
endelse
;

if numeric then if ncnt gt 0 then text=text(numerics-skip)

; ----------- optional compression and whitespace elimination -----------------
; eliminate excess whitespace, leading and trailing blanks, null lines
; unless otherwise indicated (ie, nocomp is set)
if compress then begin
   text=strtrim(strcompress(text),2)
   nonnulls = where(text ne '',nncount)
   if nncount eq 0 then begin
      message,/info,'Null file! (' + filename + ')'
      return,data
   endif else text=text(nonnulls)
endif
; ----------------------------------------------------------------------------
;
; -------------- optional comment elimination ---------------------------------
;
; ('wordy' to handle partial comment lines and retension of existing null lines)
;
gtext=text                  ; 'good' text
if keyword_set(nocomment) then begin        ; remove comment lines
   scomment=size(nocomment)
   comtype=scomment(n_elements(scomment)-2)
;  allow user-supplied delimiter or use default if nocomment use as switch
   case comtype of
      7:    comchar=nocomment           ; user supplied comment char
      else: case strupcase(!version.os) of 
           'VMS': comchar='!'           ; assume VMS command file
           else: comchar='#'        ; assume unix script 
        endcase
   endcase
   compos=strpos(gtext,comchar)
   if (keyword_set(first_char_comm)) then wherecom=where(compos eq 0, ccount) $
                else wherecom=where(compos + 1, ccount)
;   wherecom=where(compos + 1, ccount)
;  for each line containing a comment character
   for j=0L,ccount-1 do begin
         gtext(wherecom(j)) = $
        strmid(gtext(wherecom(j)),0,compos(wherecom(j)))
   endfor
;  
;  dont delete 
   if ccount gt 0 then begin
      newnulls=where(gtext(wherecom) eq '',nncount)
      if nncount gt 0 then begin
         delpat='rd_tfile_delete'
         gtext(wherecom(newnulls)) = delpat     ; mark for deletion
         keep = where(gtext ne delpat,kcount)
         if kcount gt 0 then gtext=gtext(keep) else begin
            message,/info,'Nothing left after removing comment lines!'
        return,data
     endelse
      endif
   endif
endif
; ----------------------------------------------------------------------------
;
; ------------- auto column determination function -------------------------
if autocol then begin           ; determine number columns from 1st
   testcol=str2arr(gtext(0),delim)
   ncols=n_elements(testcol)
endif
; ---------------------------------------------------------------------------
; ------------- matrix formation (table data) -------------------------------
; fill in matrix if ncols gt 1
if ncols eq 1 then data=gtext else begin
   data=strarr(ncols,n_elements(gtext))
   for i=0L,n_elements(gtext)-1 do begin
      array = str2arr(gtext(i),delim)
      array = array(0:min([ncols-1,n_elements(array)-1]) )      
      data(0,i) = array
   endfor
endelse

!quiet=qtemp
;
if compress then data=strtrim(data,2)   ; clean up substrings
; 
; ------------ optional numeric data type conversion -----------------------
; slf, 11-feb-1993
; add data type conversion code for convenience - assume user knows what 
; shes doing. Of course, user can do this outside of this routine:
; for example, data=fix(rd_tfile(file,/auto))

if convert then begin           ; auto convert
   data=strupcase(data)
   bdata=byte(data)         ; always ok
;  are these floating numbers?
   decimal=where(bdata eq 46b,dcnt)
   eexp=where(bdata eq 69b,ecnt)    
   on_ioerror,cnverror
   if (dcnt or ecnt) gt 0 then data=float(data) else begin
      data=long(data)
      case 1 of
;        max(data) lt 256:    data=byte(data)   ; do we want this?
         max(data) lt 32768l: data=fix(data)    ; fix it
     else:                  ; leave it long
      endcase
   endelse
endif
;
;-----------------------------------------------------------------------------
;
; normal completion, return the data
;
return, data
;
;
; i/o and type conversion errors
openerror:
message,/info,'No file: ' + filename
!quiet=qtemp
return,data
readerror:
free_lun,lun
message,/info,'Error reading file: ' + filename
!quiet=qtemp
return,data
cnverror:
free_lun,lun
message,/info,'Error converting text to numeric data in file: ' + filename
!quiet=qtemp
return,data
end








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
spawn, 'less ' + FullFileName,data

;remove comments and empty lines
RealData = where(~strmatch(data,'#*') OR ~strmatch(data,'')) 
sz=(size(Realdata))(1) ;size of data

flt0 = lonarr(sz)
flt1 = lonarr(sz)
flt2 = lonarr(sz)
FOR i=0,(sz-1) DO BEGIN
    split = strsplit(RealData,' ',/extract)
    flt0[i]=split[0]
    flt1[i]=split[1]
    flt2[i]=split[2]
ENDFOR
self.x_axis = ptr_new(flt0)
self.y_axis = ptr_new(flt1)
self.error_axis = ptr_new(flt2)
END



;This function retrieves the data and the header
PRO IDLoutputFile::getD_MD
FullFileName = self.full_file_name

data = BSSreduction_readAsciiFile(FullFileName, $
                                  3,$
                                  /nocomment, $
                                  /convert, $
                                  head=head)

self.x_axis     = ptr_new(data[0,*])
self.y_axis     = ptr_new(data[1,*])
self.error_axis = ptr_new(data[2,*])
self.metadata   = ptr_new(head)
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
    self->getD_MD
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
