;===============================================================================
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
;===============================================================================

;+
; :Description:
;    Create the metadata structure that will be used and displayed in the
;    final plot base
;
; :Params:
;    event
;
; :Keywords:
;    time_stamp
;    rtof_file
;    rtof_nexus_geometry_file
;    qzmax
;    qzmin
;    qxbins
;    qzbins
;    qxmin
;    qxmax
;    tofmin
;    tofmax
;    pixmin
;    pixmax
;    center_pixel
;    pixel_size
;    d_sd
;    d_md
;    qxwidth
;    tnum
;
; :Author: j35
;-
function produce_rtof_metadata_structure, event, $
    time_stamp = time_stamp, $
    rtof_file = rtof_file, $
    rtof_nexus_geometry_file = rtof_nexus_geometry_file, $
    qzmax = QZmax,$
    qzmin = QZmin, $
    qxbins = QXbins, $
    qzbins = QZbins, $
    qxmin = QXmin, $
    qxmax = QXmax, $
    tofmin = TOFmin, $
    tofmax = TOFmax, $
    pixmin = PIXmin, $
    pixmax = PIXmax, $
    center_pixel = center_pixel, $
    pixel_size = pixel_size, $
    d_sd = d_sd, $
    d_md = d_md, $
    qxwidth = qxwidth, $
    tnum = tnum
  compile_opt idl2
  
  metadata = { rtof_file: {label:'Name of rtof ascii file', $
    value:rtof_file}, $
    
    rtof_nexus_geometry_file: {label:'Name of NeXus geometry file used', $
    value: rtof_nexus_geometry_file}, $
    
    time_stamp: {label:'Date and time this plot was generated', $
    value: time_stamp}, $
    
    qzmax: {label:'Qz max range value (Angstroms)', $
    value: qzmax}, $
    
    qzmin: {label:'Qz min range value (Angstroms)', $
    value: qzmin}, $
    
    qxbins: {label:'Number of Qx bins value', $
    value: qxbins}, $
    
    qzbins: {label:'Number of Qz bins vlaue', $
    value: qzbins}, $
    
    qxmin: {label:'Qx min range value (Angstroms)', $
    value: qxmin}, $
    
    qxmax: {label:'Qx max range value (Angstroms)', $
    value: qxmax}, $
    
    tofmin: {label:'TOF min value (ms)', $
    value: tofmin}, $
    
    tofmax: {label:'TOF max value (ms)', $
    value: tofmax}, $
    
    pixmin: {label:'Pixel minimum range', $
    value: pixmin}, $
    
    pixmax: {label:'Pixel maximum range', $
    value: pixmax}, $
    
    center_pixel: {label:'Center pixel', $
    value: center_pixel}, $
    
    pixel_size: {label:'Pixel size (mm)', $
    value: pixel_size}, $
    
    d_sd: {label:'Distance sample detector (mm)', $
    value: d_sd}, $
    
    d_md: {label:'Distance moderator detector (mm)', $
    value: d_md}, $
    
    qxwidth: {label:'Qx width for calculatio of specular reflection', $
    value: qxwidth}, $
    
    tnum: {label:'Number of points to trim for specular reflection calculation', $
    value: tnum}}
    
  return, metadata
  
end