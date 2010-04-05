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

PRO populate_data_geometry_info, Event, nexus_file_name

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
END

;------------------------------------------------------------------------------
PRO calculate_data_dirpix, Event

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    dirpix = 'N/A'
  ENDIF ELSE BEGIN
  
    ON_IOERROR, done_calculation
    
    ymin = getTextFieldValue(Event,'data_d_selection_roi_ymin_cw_field')
    ymax = getTextFieldValue(Event,'data_d_selection_roi_ymax_cw_field')
    
    IF (ymin NE 0 AND ymax NE 0) THEN BEGIN
    
      ymin = FLOAT(ymin)
      ymax = FLOAT(ymax)
      dirpix = MEAN([ymin,ymax])
      (*global).dirpix = dirpix
      
    ENDIF ELSE BEGIN
    
      dirpix = 'N/A'
      
    ENDELSE
    
    putTextFieldValue, event, 'data_geometry_dirpix_value_user', $
      STRCOMPRESS(dirpix,/REMOVE_ALL), 0
      
    RETURN
    
    done_calculation:
    dirpix = 'N/A'
    putTextFieldValue, event, 'data_geometry_dirpix_value_user', $
      STRCOMPRESS(dirpix,/REMOVE_ALL), 0
      
  ENDELSE
  
END
