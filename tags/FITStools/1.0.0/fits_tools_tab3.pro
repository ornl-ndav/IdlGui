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

PRO create_fits_files_tab3, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  where     = getButtonValue(Event,'tab3_where_button')
  file_name = getTextFieldValue(Event,'tab3_file_name')
  ext       = 'fits'
  
  from_time_microS = FLOAT(getTextFieldValue(Event,'tab3_from_time_microS'))
  to_time_microS   = FLOAT(getTextFieldValue(Event,'tab3_to_time_microS'))
  bin_size_microS = FLOAT(getTextFieldValue(Event,'tab3_bin_size_value'))
  
  ;array -> number
  from_time_microS = from_time_microS[0]
  to_time_microS   = to_time_microS[0]
  bin_size_microS  = bin_size_microS[0]
  
  xarray    = (*(*global).pXArray)
  yarray    = (*(*global).pYArray)
  timearray = (*(*global).pTimeArray)
  
  xsize = FIX(getTextFieldValue(event,'tab1_x_pixels'))
  ysize = FIX(getTextFieldValue(event,'tab1_y_pixels'))
  
  time_resolution_microS = (*global).time_resolution_microS
  
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  
  local_f_from_time_microS = from_time_microS
  local_f_to_time_microS   = from_time_microS + bin_size_microS
  current_bin_array = LONARR(xsize,ysize) ;reset the array
  
  c=0
  d=0
  u=1
  cdu = '000'
  
  ;evaluate how many files we are going to create
  full_nbr_files = GetHowManyFileWillBeCreated(local_f_from_time_microS,$
    local_f_to_time_microS, $
    to_time_microS, $
    bin_size_microS)

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    
  progressBar = Obj_New("SHOWPROGRESS", id, Steps=full_nbr_files, /CANCELBUTTON)
  DEVICE, DECOMPOSED=1
  color = 50
  progressBar->SetColor, color
  progressBar->Start
  color_step = FIX(200./FLOAT(full_nbr_files))
  
  local_f_from_time_microS = from_time_microS
  local_f_to_time_microS   = from_time_microS + bin_size_microS
  progress_bar_index = 0
  WHILE (local_f_from_time_microS LT to_time_microS) DO BEGIN
  
    index_nbr_files = 0
    WHILE (index_nbr_files LT nbr_files_loaded) DO BEGIN
    
      local_timearray = *timearray[index_nbr_files] * time_resolution_microS
      local_xarray = *xarray[index_nbr_files]
      local_yarray = *yarray[index_nbr_files]
      
      where_timearray = WHERE(local_timearray GE local_f_from_time_microS AND $
        local_timearray LT local_f_to_time_microS, sz)
        
      IF (sz NE 0) THEN BEGIN ;not empty array found
      
        xarray_bin = local_xarray[where_timearray]
        yarray_bin = local_yarray[where_timearray]
        
        sz = N_ELEMENTS(xarray_bin)
        index = 0L
        WHILE (index LT sz) DO BEGIN
          x = xarray_bin[index]
          y = yarray_bin[index]
          ;make sure they are within the range specified in tab1
          IF (x LT xsize AND y LT ysize) THEN BEGIN
            current_bin_array[x,y]++
          ENDIF
          index++
        ENDWHILE
        
      ENDIF ;if where_timearray is not empty
      
      index_nbr_files++
    ENDWHILE
    
    cancelled = progressBar->CheckCancel()
    IF cancelled THEN BEGIN
      progressBar->Destroy
      Obj_Destroy, progressBar
      DEVICE, DECOMPOSED=0
      RETURN
    END
    
    color += color_step
    progressBar->setColor, color
    progressBar->Update, ((FLOAT(progress_bar_index)/FLOAT(full_nbr_files))*100.)
    
    ;create the file here
    full_file_name = where + file_name + '_' + cdu + '.' + ext
    fits_write, full_file_name, current_bin_array
    
    local_f_from_time_microS = local_f_to_time_microS
    local_f_to_time_microS   = local_f_from_time_microS + bin_size_microS
    cdu = increase_count(c, d, u)
    progress_bar_index++
    
  ENDWHILE
  
  progressBar->Destroy
  Obj_Destroy, progressBar
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO check_create_fits_button_status, Event, uname=uname
  status = is_create_fits_button_enabled(Event,uname=uname)
  activate_widget, Event, 'tab3_create_fits_files_button', status
END

;------------------------------------------------------------------------------
PRO check_tab3_plot_button_status, Event
  status = is_tab3_plot_button_enabled(Event)
  activate_widget, Event, 'tab3_bin_size_plot', status
END

;------------------------------------------------------------------------------
PRO update_tab3_fits_file_name, Event

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
  output_file_name += file_prefix
  
  putValue, Event, 'tab3_file_name', output_file_name
  
END
