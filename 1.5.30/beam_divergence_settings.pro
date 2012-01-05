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

pro retrieve_beamdivergence_settings, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;retrieve geometry file for this run
  ;if there is no geometry file name used in the reduction, retrieve the
  ;name of the geometry file from the /entry/instrument/SNSgeometry_file_name
  ;tag
  
  text = 'Retrieving beam divergence settings:'
  putLogBookMessage, Event, text, Append=1
  
  if (isWithDataInstrumentGeometryOverwrite(Event)) then BEGIN
  
  FullGeoFile = (*global).InstrumentDataGeometryFileName
  text = ' -> using overwrite instrument geometry file: ' + FullGeoFile
  putLogBookMessage, Event, text, Append=1
    
  endif else begin
  
    data_nexus_full_path = (*global).data_nexus_full_path
  text = ' -> Retrieving name of geometry file from nexus ( ' + $
  data_nexus_full_path +  ')'
  putLogBookMessage, Event, text, Append=1
    iNexus = obj_new('IDLnexusUtilities', data_nexus_full_path)
    ShortGeoFile = iNexus.get_GeometryFileName()
    obj_destroy, iNexus
    text = ' --> geometry file: ' + ShortGeoFile
    putLogBookMessage, event, text, append=1
    
    ;retrieve date in name of geometry file
    stringParsed = strsplit(ShortGeoFile,'_',/extract)
    date_ext = strjoin(stringParsed[3:5],'-')
    dateParsed = strsplit(date_ext,'.',/extract)
    date = dateParsed[0]
    
    cmd = 'findcalib -g -i ' + (*global).instrument + ' --date=' + date
    spawn, cmd, listening, err_listening
    
    FullGeoFile = listening[0]
    text = ' --> Retrieved full name of geometry file: ' + FullGeoFile
    putLogBookMessage, event, text, append=1
    
  endelse
  
  if (~file_test(FullGeoFile)) then begin ;file can not be found
    (*global).center_pixel = 'N/A'
    (*global).detector_resolution = 'N/A'
    return
  endif
  
  file = OBJ_NEW('IDLxmlParserLight', FullGeoFile)
  spatial_resolution = file->getValue(tag=['instrumentgeometry',$
    'math','definitions','parameter'], attribute='detectorSpatialResolution')
  obj_destroy, file
  
  file = OBJ_NEW('IDLxmlParserLight', FullGeoFile)
  center_pixel = file->getValue(tag=['instrumentgeometry',$
    'math','definitions','parameter'], attribute='yCenterPixel')
  obj_destroy, file

  text = ' -> center pixel: ' + center_pixel
  putLogBookMessage, event, text, append=1
  text = ' -> spatial resolution: ' + spatial_resolution + ' mm'
  putLogBookMessage, event, text, append=1
  
  (*global).center_pixel = center_pixel
  (*global).detector_resolution = spatial_resolution
  (*global).current_center_pixel = center_pixel
  
end