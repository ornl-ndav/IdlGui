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
;    function returns the dangle value and its units in the 2 elements
;    string array
;
; :Author: j35
;-
function NeXusMetadata::getDangle
  compile_opt idl2
  path_value = '/entry-Off_Off/instrument/bank1/DANGLE/readback/'
  path_units = '/entry-Off_Off/instrument/bank1/DANGLE/units/'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, ['N/A','N/A']
  endif else begin
    pathID_value = h5d_open(self.fileID, path_value)
    dangle_value = strcompress(h5d_read(pathID_value),/remove_all)
    
    pathID_units = h5a_open_name(pathID_value,'units')
    dangle_units = strcompress(h5a_read(pathID_units),/remove_all)
    
    h5d_close, pathID_value
    return, [dangle_value,dangle_units]
  endelse
end

;+
; :Description:
;   function returns the DANGLE0 value
;
; :Author: j35
;-
function NeXusMetadata::getDangle0
  compile_opt idl2
  path_value = '/entry-Off_Off/instrument/bank1/DANGLE0/readback/'
  path_units = '/entry-Off_Off/instrument/bank1/DANGLE0/units/'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, ['N/A','N/A']
  endif else begin
    pathID_value = h5d_open(self.fileID, path_value)
    dangle_value = strcompress(h5d_read(pathID_value),/remove_all)
    
    pathID_units = h5a_open_name(pathID_value,'units')
    dangle_units = strcompress(h5a_read(pathID_units),/remove_all)
    
    h5d_close, pathID_value
    return, [dangle_value,dangle_units]
  endelse
end

;+
; :Description:
;   Returns the detector-sample distance with its units
;
; :Author: j35
;-
function NeXusMetadata::getSampleDetDistance
  compile_opt idl2
  path_value = '/entry-Off_Off/instrument/bank1/SampleDetDis/readback/'
  path_units = '/entry-Off_Off/instrument/bank1/SampleDetDis/units'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, ['N/A','N/A']
  endif else begin
    pathID_value = h5d_open(self.fileID, path_value)
    dis_value = strcompress(h5d_read(pathID_value),/remove_all)
    
    pathID_units = h5a_open_name(pathID_value,'units')
    dis_units = strcompress(h5a_read(pathID_units),/remove_all)
    
    h5d_close, pathID_value
    return, [dis_value,dis_units]
  endelse
end

;+
; :Description:
;    function returns the DIRPIX value
;
; :Author: j35
;-
function NeXusMetadata::getDirpix
  compile_opt idl2
  path = '/entry-Off_Off/instrument/bank1/DIRPIX/value/'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, 'N/A'
  endif else begin
    pathID = h5d_open(self.fileID, path)
    dirpix = h5d_read(pathID)
    h5d_close, pathID
    return, strcompress(dirpix,/remove_all)
  endelse
end

;+
; :Description:
;    function returns the proton charge in picoCoulomb
;
; :Author: j35
;-
function NeXusMetadata::getProtonCharge
  compile_opt idl2
  path = '/entry-Off_Off/proton_charge/'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, 'N/A'
  endif else begin
    pathID = h5d_open(self.fileID, path)
    proton_charge = h5d_read(pathID)
    h5d_close, pathID
    return, strcompress(proton_charge,/remove_all) + 'pC'
  endelse
end


;+
; :Description:
;    function returns the duration of the experiment in seconds
;
; :Author: j35
;-
function NeXusMetadata::getDuration
  compile_opt idl2
  path = '/entry-Off_Off/duration/'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, 'N/A'
  endif else begin
    pathID = h5d_open(self.fileID, path)
    duration = h5d_read(pathID)
    h5d_close, pathID
    return, strcompress(duration,/remove_all) + 's'
  endelse
end

;+
; :Description:
;    function returns the end time of the experiment with the following
;    format 20:35:46 (2009-11-25)
;
; :Author: j35
;-
function NeXusMetadata::getEnd
  compile_opt idl2
  path = '/entry-Off_Off/end_time/'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, 'N/A'
  endif else begin
    pathID = h5d_open(self.fileID, path)
    date = h5d_read(pathID)
    h5d_close, pathID
    date_split = strsplit(date,'T',/extract)
    time_split = strsplit(date_split[1],'-',/extract)
    end_time = time_split[0] + ' (' + date_split[0] + ')'
    return, end_time
  endelse
end

;+
; :Description:
;    function returns the start time of the experiment with the following
;    format 20:30:45 (2009-11-25)
;
; :Author: j35
;-
function NeXusMetadata::getStart
  compile_opt idl2
  path = '/entry-Off_Off/start_time/'
  catch, error_value
  if (error_value ne 0) then begin
    catch,cancel
    return, 'N/A'
  endif else begin
    pathID = h5d_open(self.fileID, path)
    date = h5d_read(pathID)
    h5d_close, pathID
    date_split = strsplit(date,'T',/extract)
    time_split = strsplit(date_split[1],'-',/extract)
    start = time_split[0] + ' (' + date_split[0] + ')'
    return, start
  endelse
end

;+
; :Description:
;    function that returns the date from the NeXus file.
;    It returns in fact the starting time (that has date and time)
;
; :Author: j35
;-
function NeXusMetadata::getDate
  compile_opt idl2
  path = '/entry-Off_Off/start_time/'
  catch, error_value
  if (error_value NE 0) then begin
    catch,/cancel
    return, 'N/A'
  endif else begin
    pathID = h5d_open(self.fileID, path)
    date   = h5d_read(pathID)
    h5d_close, pathID
    date_split = strsplit(date,'T',/extract)
    return, date_split[0]
  endelse
end

;+
; :Description:
;    class destructor that close the fileID opened in the constructor
;
; :Author: j35
;-
function NeXusMetadata::clear
  compile_opt idl2
  h5f_close, self.fileID
end

;+
; :Description:
;    class constructor that check if the NeXus file is valid
;    The various methods will only work with a REF_M NeXus file
;
; :Params:
;    nexus_full_path
;
; :Author: j35
;-
function NeXusMetadata::init, nexus_full_path
  compile_opt idl2
  
  ;open hdf5 nexus file
  error_file = 0
  catch, error_file
  if (error_file ne 0) then begin
    catch,/cancel
    return,0
  endif else begin
    self.fileID = h5f_open(nexus_full_path)
  endelse
  
  return, 1
end

;+
; :Description:
;    Class definition
;
; :Author: j35
;-
pro NeXusMetadata__define
  struct = {NeXusMetadata,$
    fileID: 0L}
end
