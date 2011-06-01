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
;    This routine retrieves the sangle value and units for 3 different
;    architectures of the NeXus files. If all three fail, a empty 2 elements
;    array is returned.
;
; :Params:
;    fileID
;
; :Returns:
;   [strcompress(value),strcompress(units)]
;
; :Author: j35
;-
function get_sangle, fileID
  compile_opt idl2
  
  catch, error_try1
  if (error_try1 ne 0) then begin
    catch,/cancel
    
    catch, error_try2
    if (error_try2 ne 0) then begin
      catch,/cancel
      
      catch, error_try3
      if (error_try3 ne 0) then begin
        catch,/cancel
        
        return, ['','']
        
      endif else begin ;try3
      
        sangle_value_path = '/entry-Off_Off/sample/SANGLE/readback/'
        sangle_units_path = '/entry-Off_Off/sample/SANGLE/readback/units/'
        pathID = h5d_open(fileID, sangle_value_path)
        sangle = h5d_read(pathID)
        unitID = h5a_open_name(pathID,'units')
        units  = h5a_read(unitID)
        h5d_close, pathID
        RETURN, [STRCOMPRESS(sangle,/REMOVE_ALL), $
          STRCOMPRESS(units,/REMOVE_ALL)]
          
      endelse
      
    endif else begin ;try2
    
      sangle_value_path = '/entry-Off_Off/sample/SANGLE/value/'
      sangle_units_path = '/entry-Off_Off/sample/SANGLE/value/units/'
      pathID = h5d_open(fileID, sangle_value_path)
      sangle = h5d_read(pathID)
      unitID = h5a_open_name(pathID,'units')
      units  = h5a_read(unitID)
      h5d_close, pathID
      RETURN, [STRCOMPRESS(sangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
      
    endelse
    
  endif else begin ;try1
  
    ;new NeXus architecture
    sangle_value_path = '/entry-Off_Off/DASlogs/SANGLE/value/'
    sangle_units_path = '/entry-Off_Off/DASlogs/SANGLE/value/units/'
    pathID = h5d_open(fileID, sangle_value_path)
    sangle = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    RETURN, [STRCOMPRESS(sangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
    
  endelse
  
end

;+
; :Description:
;    This routine retrieves the dangle value and units for 3 different
;    architectures of the NeXus files. If all three fail, a empty 2 elements
;    array is returned.
;
; :Params:
;    fileID
;
; :Returns:
;   [strcompress(value),strcompress(units)]
;
; :Author: j35
;-
function get_dangle, fileID
  compile_opt idl2
  
  catch, error_try1
  if (error_try1 ne 0) then begin
    catch,/cancel
    
    catch, error_try2
    if (error_try2 ne 0) then begin
      catch,/cancel
      
      catch, error_try3
      if (error_try3 ne 0) then begin
        catch,/cancel
        
        return, ['','']
        
      endif else begin ;try3
      
        dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE/readback/'
        dangle_units_path = $
          '/entry-Off_Off/instrument/bank1/DANGLE/readback/units/'
        pathID = h5d_open(fileID, dangle_value_path)
        dangle = h5d_read(pathID)
        unitID = h5a_open_name(pathID,'units')
        units  = h5a_read(unitID)
        h5d_close, pathID
        return, [STRCOMPRESS(dangle,/REMOVE_ALL), $
          STRCOMPRESS(units,/REMOVE_ALL)]
          
      endelse
      
    endif else begin ;try2
    
      dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE/value/'
      dangle_units_path = '/entry-Off_Off/instrument/bank1/DANGLE/value/units/'
      pathID = h5d_open(fileID, dangle_value_path)
      dangle = h5d_read(pathID)
      unitID = h5a_open_name(pathID,'units')
      units  = h5a_read(unitID)
      h5d_close, pathID
      return, [STRCOMPRESS(dangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
      
    endelse
    
  endif else begin ;try1
  
    dangle_value_path = '/entry-Off_Off/DASlogs/DANGLE/value/'
    dangle_units_path = '/entry-Off_Off/DASlogs/DANGLE/value/units/'
    pathID = h5d_open(fileID, dangle_value_path)
    dangle = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    return, [STRCOMPRESS(dangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
    
  endelse
  
end

;+
; :Description:
;    This routine retrieves the dangle0 value and units for 3 different
;    architectures of the NeXus files. If all three fail, a empty 2 elements
;    array is returned.
;
; :Params:
;    fileID
;
; :Returns:
;   [strcompress(value),strcompress(units)]
;
; :Author: j35
;-
function get_dangle0, fileID
  compile_opt idl2
  
  catch, error_try1
  if (error_try1 ne 0) then begin
    catch,/cancel
    
    catch, error_try2
    if (error_try2 ne 0) then begin
      catch,/cancel
      
      catch, error_try3
      if (error_try3 ne 0) then begin
        catch,/cancel
        
        return, ['','']
        
      endif else begin
      
        dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE0/readback/'
        dangle_units_path = $
          '/entry-Off_Off/instrument/bank1/DANGLE0/readback/units/'
        pathID = h5d_open(fileID, dangle_value_path)
        dangle = h5d_read(pathID)
        unitID = h5a_open_name(pathID,'units')
        units  = h5a_read(unitID)
        h5d_close, pathID
        RETURN, [STRCOMPRESS(dangle,/REMOVE_ALL), $
          STRCOMPRESS(units,/REMOVE_ALL)]
          
      endelse
      
    endif else begin ;try2
    
      dangle_value_path = '/entry-Off_Off/instrument/bank1/DANGLE0/value/'
      dangle_units_path = '/entry-Off_Off/instrument/bank1/DANGLE0/value/units/'
      pathID = h5d_open(fileID, dangle_value_path)
      dangle = h5d_read(pathID)
      unitID = h5a_open_name(pathID,'units')
      units  = h5a_read(unitID)
      h5d_close, pathID
      RETURN, [STRCOMPRESS(dangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
      
    endelse
    
  endif else begin ;try1
  
    dangle_value_path = '/entry-Off_Off/DASlogs/DANGLE0/value/'
    dangle_units_path = '/entry-Off_Off/DASlogs/DANGLE0/value/units/'
    pathID = h5d_open(fileID, dangle_value_path)
    dangle = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    RETURN, [STRCOMPRESS(dangle,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
    
  endelse
  
end

;+
; :Description:
;    This routine retrieves the dirpix value for 3 differents
;    architectures of the NeXus files. If all three fail, a empty string
;    is returned.
;
; :Params:
;    fileID
;
; :Returns:
;   strcompress(value)
;
; :Author: j35
;-
function get_dirpix, fileID
  compile_opt idl2
  
  catch, error_try1
  if (error_try1 ne 0) then begin
    catch,/cancel
    
    catch, error_try2
    if (error_try2 ne 0) then begin
      catch,/cancel
      
      catch, error_try3
      if (error_try3 ne 0) then begin
        catch,/cancel
        
        return, ''
        
      endif else begin ;try3
      
        dirpix_path = '/entry-Off_Off/instrument/bank1/DIRPIX/value/'
        pathID = h5d_open(fileID, dirpix_path)
        dirpix = h5d_read(pathID)
        h5d_close, pathID
        RETURN, STRCOMPRESS(dirpix,/REMOVE_ALL)
        
      endelse
      
    endif else begin ;try2
    
      dirpix_path = '/entry-Off_Off/instrument/bank1/DIRPIX/readback/'
      pathID = h5d_open(fileID, dirpix_path)
      dirpix = h5d_read(pathID)
      h5d_close, pathID
      RETURN, STRCOMPRESS(dirpix,/REMOVE_ALL)
      
    endelse
    
  endif else begin ;try1
  
    dirpix_path = '/entry-Off_Off/DASlogs/DIRPIX/value/'
    pathID = h5d_open(fileID, dirpix_path)
    dirpix = h5d_read(pathID)
    h5d_close, pathID
    RETURN, STRCOMPRESS(dirpix,/REMOVE_ALL)
    
  endelse
  
end

;+
; :Description:
;    This routine retrieves the distance Sample-Detector value and units
;    for 3 differents architectures of the NeXus files.
;    If all three fail, a empty 2 elements array is returned.
;
; :Params:
;    fileID
;
; :Returns:
;   [strcompress(value),strcompress(units)]
;
; :Author: j35
;-
function get_sample_det_distance, fileID
  compile_opt idl2
  
  catch, error_try1
  if (error_try1 ne 0) then begin
    catch, /cancel
    
    catch, error_try2
    if (error_try2 ne 0) then begin
      catch, /cancel
      
      catch, error_try3
      if (error_try3 ne 0) then begin
        catch, /cancel
        
        return, ['','']
        
      endif else begin ;try3
      
        dist_value_path = '/entry-Off_Off/instrument/bank1/SampleDetDis/value/'
        dist_units_path = $
          '/entry-Off_Off/instrument/bank1/SampleDetDis/value/units/'
        pathID = h5d_open(fileID, dist_value_path)
        dist   = h5d_read(pathID)
        unitID = h5a_open_name(pathID,'units')
        units  = h5a_read(unitID)
        h5d_close, pathID
        return, [STRCOMPRESS(dist,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
        
      endelse
      
    endif else begin ;try2
    
      dist_value_path = '/entry-Off_Off/instrument/bank1/SampleDetDis/readback/'
      dist_units_path = $
        '/entry-Off_Off/instrument/bank1/SampleDetDis/readback/units/'
      pathID = h5d_open(fileID, dist_value_path)
      dist   = h5d_read(pathID)
      unitID = h5a_open_name(pathID,'units')
      units  = h5a_read(unitID)
      h5d_close, pathID
      return, [STRCOMPRESS(dist,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
      
    endelse
    
  endif else begin ;try1
  
    dist_value_path = '/entry-Off_Off/DASlogs/SampleDetDis/value/'
    dist_units_path = '/entry-Off_Off/DASlogs/SampleDetDis/value/units/'
    pathID = h5d_open(fileID, dist_value_path)
    dist   = h5d_read(pathID)
    unitID = h5a_open_name(pathID,'units')
    units  = h5a_read(unitID)
    h5d_close, pathID
    return, [STRCOMPRESS(dist,/REMOVE_ALL), STRCOMPRESS(units,/REMOVE_ALL)]
    
  endelse
  
end

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
FUNCTION IDLgetMetadata_REF_M::getSangle
  angle_units = get_sangle(self.fileID)
  units = angle_units[1]
  IF (units EQ '') THEN RETURN, ''
  angle = FLOAT(angle_units[0])
  IF (units EQ 'degree') THEN BEGIN
    angle = convert_to_rad(angle)
  ENDIF
  RETURN, angle
END

FUNCTION IDLgetMetadata_REF_M::getDangle
  angle_units = get_dangle(self.fileID)
  units = angle_units[1]
  IF (units EQ '') THEN RETURN, ''
  angle = FLOAT(angle_units[0])
  IF (units EQ 'degree') THEN BEGIN
    angle = convert_to_rad(angle)
  ENDIF
  RETURN, angle
END

FUNCTION IDLgetMetadata_REF_M::getDangle0
  angle_units = get_dangle0(self.fileID)
  units = angle_units[1]
  IF (units EQ '') THEN RETURN, ''
  angle = FLOAT(angle_units[0])
  IF (units EQ 'degree') THEN BEGIN
    angle = convert_to_rad(angle)
  ENDIF
  RETURN, angle
END

FUNCTION IDLgetMetadata_REF_M::getDirPix
  DirPix = get_dirpix(self.fileID)
  RETURN, DirPix[0]
END

FUNCTION IDLgetMetadata_REF_M::getSampleDetDist
  distance_units = get_sample_det_distance(self.fileID)
  units = distance_units[1]
  IF (units EQ '') THEN RETURN, ''
  distance = FLOAT(distance_units[0])
  IF (units NE 'metre') THEN BEGIN
    distance = convert_to_metre(distance, units)
  ENDIF
  RETURN, distance
END

;+
; :Description:
;    Cleanup routine of the class
;
; :Author: j35
;-
function IDLgetMetadata_REF_M::cleanup
  compile_opt idl2
  
  h5f_close, self.fileID
  
end

;+
; :Description:
;    init method of the class
;
; :Params:
;    nexus_full_path
;
;
;
; :Author: j35
;-
function IDLgetMetadata_REF_M::init, nexus_full_path
  compile_opt idl2
  
  ;open hdf5 nexus file
  error_file = 0
  CATCH, error_file
  IF (error_file NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN,0
  ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
    self.fileID = fileID
  ENDELSE
  
  RETURN, 1
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO IDLgetMetadata_REF_M__define
  struct = {IDLgetMetadata_REF_M,$
    fileID: 0L, $
    nexus_full_path : ''}
END
;******************************************************************************
;******************************************************************************

