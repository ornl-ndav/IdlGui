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

;##############################################################################
;******************************************************************************

;This function displays the OPEN FILE from IDL
FUNCTION OpenFile, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  
  dMDAngleBaseId = widget_info(event.top,find_by_uname='dMD_angle_base')
  widget_control, dMDAngleBaseId, map=0
  
  title    = 'Select file:'
  filter   = (*global).file_filter
  pid_path = (*global).input_path
  
  ;open file
  dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
  FullFileName = dialog_pickfile(PATH = pid_path,$
    GET_PATH = path,$
    dialog_parent = dialog_id, $
    TITLE    = title,$
    /multiple_files,$
    /must_exist,$
    FILTER   = filter)

  IF (FullFileName[0] NE '') THEN BEGIN
    (*global).input_path = path
  
    ;;redefine the working path
    ;path = define_new_default_working_path(Event,FullFileName)
    
  ENDIF
  
  RETURN, FullFileName
END

;##############################################################################
;******************************************************************************

;This function is going to open and store the new fresh open files
FUNCTION StoreFlts, Event, LongFileName, index, spin_state_nbr=spin_state_nbr

  widget_control, event.top, get_uvalue=global

  IF (index EQ 0) THEN BEGIN
    global_metadata_CE_file = (*global).metadata_CE_file
    metadata_CE_file = strarr(1)
  ENDIF
  
  if (n_elements(spin_state_nbr) eq 0) then begin
    spin_state_nbr = 0
  endif
  
  error_plot_status = 0
  catch, error_plot_status
  IF (error_plot_status NE 0) THEN BEGIN
  
    catch, /cancel
    text = 'ERROR plotting data'
    displayErrorMessage, Event, text ;_Gui
    return, 0
    
  endif else begin
  
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
      
        ((onebyte LT 48) OR (onebyte GT 57)): BEGIN
          ;case where we have non-numbers
        
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
    
    ;check that flt1 is not empty
    sz = (size(flt1))(1)
    IF (sz LE 1) THEN BEGIN
      message_text = ['ERROR loading ' + LongFileName,$
        'File is probably empty !']
      title        = 'ERROR !'
      dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
      result = DIALOG_MESSAGE(message_text,$
        TITLE=title,$
        dialog_parent=dialog_id,$
        /center)
      RETURN, 0
    ENDIF
    
    ;check that flt1 is not only 0 or NAN
    real_data_array = WHERE(flt1 GT 0, nbr)
    IF (nbr EQ 0) THEN BEGIN
      message_text = ['ERROR loading ' + LongFileName,$
        'File is probably empty !']
      title        = 'ERROR !'
      dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
      result = DIALOG_MESSAGE(message_text,$
        TITLE=title,$
        /center,$
        dialog_parent=dialog_id)
      RETURN, 0
    ENDIF
    
    DEVICE, DECOMPOSED = 0
    loadct,5,/SILENT
    
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
      if (n_elements(spin_state_nbr) eq 0) then begin
      spin_state_nbr = 0
      endif
      size = (size(metadata_CE_file))(1)
      metadata_CE_file = metadata_CE_file[0:size-5]
      *global_metadata_CE_file[spin_state_nbr] = metadata_CE_file
      (*global).metadata_CE_file = global_metadata_CE_file
    ENDIF
    
    flt0_ptr = (*global).flt0_ptr
    flt0_rescale_ptr = (*global).flt0_rescale_ptr
    *flt0_ptr[index,spin_state_nbr] = flt0
    *flt0_rescale_ptr[index,spin_state_nbr] = flt0
    (*global).flt0_ptr = flt0_ptr
    (*global).flt0_rescale_ptr = flt0_rescale_ptr
    
    flt1_ptr = (*global).flt1_ptr
    flt1_rescale_ptr = (*global).flt1_rescale_ptr
    *flt1_ptr[index,spin_state_nbr] = flt1
    *flt1_rescale_ptr[index,spin_state_nbr] = flt1
    (*global).flt1_ptr = flt1_ptr
    (*global).flt1_rescale_ptr = flt1_rescale_ptr

    flt2_ptr = (*global).flt2_ptr
    flt2_rescale_ptr = (*global).flt2_rescale_ptr
    *flt2_ptr[index,spin_state_nbr] = flt2
    *flt2_rescale_ptr[index,spin_state_nbr] = flt2
    (*global).flt2_ptr = flt2_ptr
    (*global).flt2_rescale_ptr = flt2_rescale_ptr
    
  ENDELSE
  
  RETURN, 1
END
