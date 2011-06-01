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
;This function checks the last x-axis value of each file and order the
;file starting with the maximum x-axis final value
FUNCTION order_files, Event, list_OF_files, stop_status
  sz = N_ELEMENTS(list_OF_files)
  IF (sz GT 1) THEN BEGIN
    ordered_list_OF_Files = STRARR(sz)
    x_final               = FLTARR(sz)
    FOR i=0,(sz-1) DO BEGIN
      SPAWN, 'tail -n 1 ' + list_OF_files[i], listening
      x_final[i] = FLOAT(listening)
    ENDFOR
    index_sorted_down = SORT(x_final) ;index des x_final sorted
    index_sorted_up   = REVERSE(index_sorted_down)
    ordered_list_OF_files = list_OF_files[index_sorted_up]
    
  ENDIF ELSE BEGIN
    ordered_list_OF_files = list_OF_files
  ENDELSE
  
  ;this also defined the default output file name
  CreateDefaultOutputFileName, Event, ordered_list_OF_files
  
  RETURN, ordered_list_OF_files
END

;------------------------------------------------------------------------------
PRO display_files_in_list, Event, ascii_file_name
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;get current list of files from widget_list
  current_list_OF_files = (*(*global).list_OF_ascii_files)
  ;add new ascii file if only they are not already there
  NbrFiles = N_ELEMENTS(ascii_file_name)
  index    = 0
  WHILE (index LT NbrFiles) DO BEGIN
    isThere = WHERE(ascii_file_name[index] EQ current_list_OF_files,nbr)
    IF (nbr EQ 0) THEN BEGIN
      sz = N_ELEMENTS(current_list_OF_files)
      IF (sz EQ 1 AND $
        current_list_OF_files[0] EQ '') THEN BEGIN
        current_list_OF_Files = [ascii_file_name[index]]
      ENDIF ELSE BEGIN
        current_list_OF_Files = $
          [current_list_OF_Files, ascii_file_name[index]]
      ENDELSE
    ENDIF
    ++index
  ENDWHILE
  ;order files
  order_current_list_OF_files = order_files(Event, current_list_OF_files)
  ;save ordered list of files
  (*(*global).list_OF_ascii_files) = order_current_list_OF_files
  putAsciiFileList, Event, order_current_list_OF_files ;update list of files
END

;------------------------------------------------------------------------------
PRO browse_ascii_file, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  extension = (*global).ascii_extension
  filter    = (*global).ascii_filter
  path      = (*global).ascii_path
;print, "path: ",path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title     = 'Select an ASCII file'
  ascii_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    dialog_parent     = id, $
    GET_PATH          = new_path,$
    TITLE             = title,$
    PATH              = path,$
    /MUST_EXIST,$
    /MULTIPLE_FILES)
    
  IF (ascii_file_name[0] NE '') THEN BEGIN
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/HOURGLASS
    (*global).ascii_path = new_path ;save new path
    ;check if current list is empty or not
    ;that will allow me to determine if this is the first load or not
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] EQ '') THEN BEGIN
      (*global).first_load = 1
    ENDIF ELSE BEGIN
      (*global).first_load = 0
    ENDELSE
    display_files_in_list, $    ;add the new files to the widget_list
      Event,$                   ;and order them
      ascii_file_name
    ;display first file in step3/reference file and all of them in the
    ;droplist of 'activet file' (step3
    updateStep3FileNames, Event;_shifting
    
    index = WHERE((*global).ucams EQ (*global).super_users)
    IF (index NE -1) THEN BEGIN ;for super users only
      ;;display list of ascii_file_name in transparency percentage button
      display_file_names_transparency, $
        Event, $
        (*(*global).list_OF_ascii_files) ;_gui
    ENDIF
    
    ;initialize various arrays
    initialize_arrays, Event ;_eventcb
    
    readAsciiData, Event ;read the ascii files and store value in a pointer
    plotAsciiData, Event        ;plot the ascii files (_plot.pro)
    activate_browse_gui, Event, 1 ;activate x-axis ticks base ;_gui
    ;turn off hourglass
    WIDGET_CONTROL,HOURGLASS=0
    ;loaded with success
    (*global).something_to_plot = 1
  ENDIF
END
;------------------------------------------------------------------------------

PRO load_step2_files_from_reduce_step3, Event, list_of_files

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;path = (*global).ascii_path
  ascii_file_name = list_of_files
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  ;check if current list is empty or not
  ;that will allow me to determine if this is the first load or not
  current_list_OF_files = (*(*global).list_OF_ascii_files)
  IF (current_list_OF_files[0] EQ '') THEN BEGIN
    (*global).first_load = 1
  ENDIF ELSE BEGIN
    (*global).first_load = 0
  ENDELSE
  display_files_in_list, $    ;add the new files to the widget_list
    Event,$                   ;and order them
    ascii_file_name
  ;display first file in step3/reference file and all of them in the
  ;droplist of 'activet file' (step3
  updateStep3FileNames, Event;_shifting
  
  index = WHERE((*global).ucams EQ (*global).super_users)
  IF (index NE -1) THEN BEGIN ;for super users only
    ;;display list of ascii_file_name in transparency percentage button
    display_file_names_transparency, $
      Event, $
      (*(*global).list_OF_ascii_files) ;_gui
  ENDIF
  
  ;initialize various arrays
  initialize_arrays, Event ;_eventcb
  
  readAsciiData, Event ;read the ascii files and store value in a pointer
  plotAsciiData, Event        ;plot the ascii files (_plot.pro)
  activate_browse_gui, Event, 1 ;activate x-axis ticks base ;_gui
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  ;loaded with success
  (*global).something_to_plot = 1
  
END
