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

;+
; :Description:
;    this function will sort in ascending order all the pixels
;    ex: [[208,215],[195,202],[181,187]] -> [[181,187],[195,202],[208,215]]
;
;
;
; :Keywords:
;    pixel_range
;
; :Author: j35
;-
pro sort_pixel_range, pixel_range=pixel_range
  compile_opt idl2
  
  sz = size(pixel_range,/dim)
  nbr_rois = sz[1]
  
  list_of_min_pixels = pixel_range[0,*]
  sort_index = sort(list_of_min_pixels)
  
  new_pixel_range = intarr(2,nbr_rois)
  
  i=0
  while (i lt nbr_rois) do begin
  
    new_pixel_range[0,i] = pixel_range[0, sort_index[i]]
    new_pixel_range[1,i] = pixel_range[1, sort_index[i]]
    
    i++
  endwhile
  
  pixel_range = new_pixel_range
end

;+
; :Description:
;    This routine is going to create the rois for the discrete and broad
;    data peak selection
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro create_data_roi_for_broad_discrete_mode, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  catch, error
  if (error ne 0) then begin
    catch, /cancel
    return
  endif
  
  output_file_name = getTextFieldValue(Event, $
    'data_roi_selection_file_text_field')
    
  case ((*global).reduction_mode) of
    'one_per_pixel': begin
      pixel_min = fix(getValue(event=event, $
        uname='data_d_selection_roi_ymin_cw_field'))
      pixel_max = fix(getValue(event=event, $
        uname='data_d_selection_roi_ymax_cw_field'))
        
      ;stop right now if the user did not select a data peak ROI
      if (pixel_min eq 0 or $
        pixel_max eq 0) then begin
        return
      endif
      
      _pixel_min = min([pixel_min, pixel_max], max=_pixel_max)
      nbr_pixel = _pixel_max - _pixel_min + 1
      pixel_range = indgen(nbr_pixel) + _pixel_min
      
      create_data_roi_file, $
        event=event, $
        pixel_range=pixel_range, $
        output_file_name=output_file_name
        
    end
    'one_per_discrete': begin
    
      ;list of pixels
      pixel_range = fix(*(*global).pixel_range_discrete_mode)
      sz = size(pixel_range,/dim)
      
      ;sort the pixel in ascending order
      sort_pixel_range, pixel_range=pixel_range
      
      nbr_rois = sz[1]
      
      _index = 0
      while (_index lt nbr_rois) do begin
      
        pixel_min = pixel_range[0,_index]
        pixel_max = pixel_range[1,_index]
        _pixel_min = min([pixel_min, pixel_max], max=_pixel_max)
        nbr_pixel = _pixel_max - _pixel_min + 1
        _pixel_range = indgen(nbr_pixel) + _pixel_min
        
        if (_index eq 0) then begin
          create_data_roi_file, $
            event=event, $
            pixel_range=_pixel_range, $
            output_file_name=output_file_name
        endif else begin
          create_data_roi_file, $
            event=event, $
            pixel_range=_pixel_range, $
            output_file_name=output_file_name, $
            /append
        endelse
        
        _index++
      endwhile
      
    end
  endcase
  
  uname = 'reduce_data_region_of_interest_file_name'
  putTextFieldValue, Event, uname, output_file_name[0],0
  
end