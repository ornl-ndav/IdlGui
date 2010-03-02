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

PRO debugging, MAIN_BASE, global

    ; Default Main Tab Shown
      id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
     WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1 ;REDUCE
  ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 2 ;PLOT
  ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 3 ;BATCH
  ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 4 ;LOG BOOK
  
  ;default path of Load Batch files
  ;    (*global).BatchDefaultPath = '/SNS/REF_L/shared/'
  
  ; default tabs shown
  ;   id1 = widget_info(MAIN_BASE, find_by_uname='roi_peak_background_tab')
  ;   widget_control, id1, set_tab_current = 1 ;peak/background
  
  ;   id2 = widget_info(MAIN_BASE, find_by_uname='data_normalization_tab')
  ;   widget_control, id2, set_tab_current = 0 ;DATA
  
  ;id2 = widget_info(MAIN_BASE, find_by_uname='data_normalization_tab')
  ;widget_control, id2, set_tab_current = 2 ;empty_cell
  
  ; id3 = widget_info(MAIN_BASE, find_by_uname='load_normalization_d_dd_tab')
  ; widget_control, id3, set_tab_current = 3 ;Y vs X (3D)
  
  ;  to get the manual mode
  ; id6 = widget_info(MAIN_BASE, find_by_uname=
  ; 'normalization2d_rescale_tab1_base')
  ; widget_control, id6, map=0
  
  ; id5 = widget_info(MAIN_BASE, find_by_uname=
  ; 'normalization2d_rescale_tab2_base')
  ; widget_control, id5, map=1
  
  ;id4 = widget_info(MAIN_BASE, find_by_uname='data_back_peak_rescale_tab')
  ;widget_control, id4, set_tab_current = 2 ;SCALE/RANGE
  
  ;BatchTable [*,0] = ['YES', $
  ;                    '5225,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; BatchTable[*,1] = ['NO', $
  ;                    '7545,5225,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; BatchTable[*,2] = ['NO', $
  ;                    '6000,7000,5225,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; BatchTable[*,3] = ['> YES <', $
  ;                    '5225,10000,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; (*(*global).BatchTable) = BatchTable
  
  ; id = widget_info(Main_base,find_by_uname='batch_table_widget')
  ; widget_control, id, set_value=BatchTable
  
  ; id = widget_info(Main_base,find_by_uname='save_as_file_name')
  ; widget_control, id, set_value='REF_L_Batch_Run4000_2008y_02m_26d.txt'
 
  END