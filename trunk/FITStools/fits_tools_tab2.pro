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

PRO define_path_of_tab2, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  ;retrieve infos
  path  = (*global).output_path
  title = 'Select where you want to create the ascii file!'
  folder = DIALOG_PICKFILE(GET_PATH = new_path,$
    DIALOG_PARENT = id, $
    PATH = path,$
    TITLE = title,$
    /DIRECTORY,$
    /READ,$
    /MUST_EXIST)
    
  IF (folder NE '') THEN BEGIN
    (*global).output_path = folder
    putNewButtonValue, Event, 'tab2_where_button', folder
  ENDIF
  
END


;------------------------------------------------------------------------------
PRO update_tab2_pvsc_ascii_file_name, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  list_fits_file = (*(*global).list_fits_file)
  
  ;get number of fits files loaded
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  
  ;retrieve first part of fits file name (bases on first fits file loaded)
  ;name should be 121609_1 -> 121609
  first_fits_file = list_fits_file[0]
  base_name = FILE_BASENAME(first_fits_file[0])
  name_array = STRSPLIT(base_name,'_',/EXTRACT)
  base_name = name_array[0]
  
  ;create default P vs C file name
  output_file_name = base_name + '_' + STRCOMPRESS(nbr_files_loaded,/REMOVE_ALL)
  IF (nbr_files_loaded EQ 1) THEN BEGIN
    file_prefix = 'file'
  ENDIF ELSE BEGIN
    file_prefix = 'files'
  ENDELSE
  output_file_name += file_prefix + '_PvsC.txt'
  
  putValue, Event, 'tab2_file_name', output_file_name
  
END

;------------------------------------------------------------------------------
PRO check_create_pvsc_button_status, Event

  status = is_create_PvsC_button_enabled(Event)
  activate_widget, Event, 'tab2_create_ascii_file_button', status
  
END