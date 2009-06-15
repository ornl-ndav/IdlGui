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

FUNCTION retrieve_tof_array, NexusFileName
  path    = '/entry/bank1/time_of_flight/'
  fileID  = H5F_OPEN(NexusFileName)
  fieldID = H5D_OPEN(fileID, path)
  data    = H5D_READ(fieldID)
  RETURN, data
END

;------------------------------------------------------------------------------
PRO MakeCountsVsTofBase, wBase

  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(MAP = 1,$
    GROUP_LEADER = ourGroup,$
    UNAME = 'counts_vs_tof_main_base',$
    /COLUMN)
    
    ;lin/log cw_bgroup
  row1c = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE,$
    FRAME = 0)
    
  lin = WIDGET_BUTTON(row1c,$
    VALUE = 'Linear',$
    UNAME = 'main_plot_linear_plot',$
    /NO_RELEASE)
    
  log = WIDGET_BUTTON(row1c,$
    VALUE = 'Logarithmic',$
    UNAME = 'main_plot_log_plot',$
    /NO_RELEASE)
    
  WIDGET_CONTROL, lin, /SET_BUTTON

 ;--------------------------------------------------    
  draw = WIDGET_DRAW(wBase,$
    SCR_XSIZE = 1500,$
    SCR_YSIZE = 600,$
    UNAME = 'counts_vs_tof_main_base_draw')
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO Launch_counts_vs_tof_base, $
    counts_vs_tof_array, $
    nexus_file_name, $
    title=title
    
  ;build gui
  wBase = ''
  MakeCountsVsTofBase, wBase
  
  global1 = PTR_NEW({ $
    NexusFileName:       nexus_file_name,$
    counts_vs_tof_array: counts_vs_tof_array,$
    wbase:               wbase})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global1
  XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK
  
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
  ;retrieve TOF array
  IF (nexus_file_name NE '') THEN BEGIN
    tof_array = retrieve_tof_array(nexus_file_name)
  ENDIF
  
  ;integrated counts_vs_tof for all pixels
  counts_vs_tof_integrated_1 = TOTAL(counts_vs_tof_array,1)
  counts_vs_tof_integrated_2 = TOTAL(counts_vs_tof_integrated_1,1)
  
  ;determine position of maximum
  max = MAX(counts_vs_tof_integrated_2)
  max_index = WHERE(counts_vs_tof_integrated_2 EQ MAX)
  
  IF (nexus_file_name NE '') THEN BEGIN
    title += ' (TOF of maximum intensity is ' + $
      STRCOMPRESS(tof_array[max_index[0]],/REMOVE_ALL) + ' microS)'
  ENDIF ELSE BEGIN
    title += ' (TOF of maximum intensity is at binning #' + $
      STRCOMPRESS(max_index[0],/REMOVE_ALL) + ')'
  ENDELSE
  
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='counts_vs_tof_main_base')
  WIDGET_CONTROL, id, BASE_SET_TITLE=title
  
  id = WIDGET_INFO(wBase,find_by_uname='counts_vs_tof_main_base_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (nexus_file_name NE '') THEN BEGIN
  PLOT, tof_array, $
    counts_vs_tof_integrated_2, $
    XTITLE = 'TOF (microS)',$
    YTITLE = 'Counts'
    ENDIF ELSE BEGIN
  PLOT, counts_vs_tof_integrated_2, $
    XTITLE = 'Bins #',$
    YTITLE = 'Counts'
    ENDELSE
END