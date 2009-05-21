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

PRO make_gui_tab2, MAIN_TAB, MainTabSize, title

  Base = WIDGET_BASE(MAIN_TAB,$
    UNAME     = 'tab2_uname',$
    XOFFSET   = MainTabSize[0],$
    YOFFSET   = MainTabSize[1],$
    SCR_XSIZE = MainTabSize[2],$
    SCR_YSIZE = MainTabSize[3],$
    TITLE     = title,$
    /COLUMN,$
    map = 1)
    
  ;space
  ;space = WIDGET_LABEL(Base,$
  ;  VALUE = ' ')
    
  ;manual input list of files -------------------------------------------------
   row_aa = WIDGET_BASE(Base,$
   /ROW)
   
   row_a = WIDGET_BASE(row_aa,$
   /COLUMN,$
   FRAME = 1)
   
   row_a_1 = WIDGET_BASE(row_a, $ ;------------------ row1 
    /ROW)
    
    label = WIDGET_LABEL(row_a_1,$
    VALUE = 'Input File')
    
    button = WIDGET_BUTTON(row_a_1,$
    VALUE = '~/results/',$
    UNAME = 'tab2_manual_input_folder')
    
    label = WIDGET_LABEL(row_a_1,$
    VALUE = '     Base of File Name:')
    
    ;internal_base
    inter_base = WIDGET_BASE(row_a_1,$
    /ROW,$
    FRAME = 1)
        
    text = WIDGET_TEXT(inter_base,$
    VALUE = ' ',$
    UNAME = 'tab2_manual_input_suffix_name',$
    /EDITABLE,$
    XSIZE = 45)
    
    label = WIDGET_LABEL(inter_base,$
    VALUE = '_<User_Defined>.')
    
    text = WIDGET_TEXT(inter_base,$
    VALUE = 'txt',$
    UNAME = 'tab2_manual_input_prefix_name',$
    /EDITABLE,$
    XSIZE = 10)

   row_a_2 = WIDGET_BASE(row_a, $ ;----------------row2
   /ROW)
   
   label = WIDGET_LABEL(row_a_2,$
   VALUE = '<User_Defined>')
   
   text = WIDGET_TEXT(row_a_2,$
   VALUE = ' ',$
   XSIZE = 110,$
   /EDITABLE,$
   UNAME = 'tab2_manual_input_sequence')
    
    space = WIDGET_LABEL(row_aa,$
    VALUE =  '   ')
    
  ;-----------------------------------------------------------------------------
  ;first row (energy integration range: min and max)
  row1 = WIDGET_BASE(Base,$
    /ROW)
    
  label = WIDGET_LABEL(row1,$
    VALUE = '   Energy Integration Range:      ')
    
  ;min value
  label = WIDGET_LABEL(row1,$
    VALUE = 'min')
    
  txt = WIDGET_TEXT(row1,$
    VALUE = '',$
    XSIZE = 5,$
    UNAME = 'energy_integration_range_min_value',$
    /EDITABLE)
    
  label = WIDGET_LABEL(row1,$
    VALUE = 'ueV')
    
  ;space
  space = WIDGET_LABEL(row1,$
    VALUE = '         ')
    
  ;max value
  label = WIDGET_LABEL(row1,$
    VALUE = 'max')
    
  txt = WIDGET_TEXT(row1,$
    VALUE = '',$
    XSIZE = 5,$
    UNAME = 'energy_integration_range_max_value',$
    /EDITABLE)
    
  label = WIDGET_LABEL(row1,$
    VALUE = 'ueV')
    
  space = WIDGET_LABEL(row1,$
    value = '     ')
    
  ;---------------------------------------------------------------------------
  row11 = WIDGET_BASE(row1,$
    FRAME=1,$
    /EXCLUSIVE,$
    /ROW)
    
  b1 = WIDGET_BUTTON(row11,$
    VALUE = 'Use LOOPER input',$
    UNAME = 'tab2_use_looper_input',$
    /NO_RELEASE)
    
  b2 = WIDGET_BUTTON(row11,$
    VALUE = 'Use MANUAL input',$
    UNAME = 'tab2_use_manual_input',$
    /NO_RELEASE)
    
  widget_control, b1, /SET_BUTTON     
    
  ;----------------------------------------------------------------------------
  ;row2 (big table)
  row2 = WIDGET_BASE(Base,$
    /ROW)
    
  Table = WIDGET_TABLE(row2,$
    UNAME = 'tab2_table_uname',$
    XSIZE = 3,$
    YSIZE = 50,$
    SCR_XSIZE = 785,$
    SCR_YSIZE = 445,$
    ;    /SCROLL,$
    EDITABLE = [1,0,1],$ ;output file and temperature only are editable
    COLUMN_WIDTHS = [600,80,80],$
    /NO_ROW_HEADERS,$
    COLUMN_LABELS = ['Output File','Status','Temperature'],$
    /RESIZEABLE_COLUMNS)
    
  ;row3
  row3 = WIDGET_BASE(Base,$
    /ROW)
    
  button1 = WIDGET_BUTTON(row3,$
    VALUE = 'REFRESH TABLE (check status of files)',$
    UNAME = 'tab2_refresh_table_uname',$
    XSIZE = 785,$
    SENSITIVE = 0)
    
  space = WIDGET_LABEL(row3,$
    VALUE = '')
    
  ;row4 (output file)
  row4 = WIDGET_BASE(Base,$
    FRAME = 0,$
    /ROW)
    
  row44 = WIDGET_BASE(row4,$
    FRAME = 1,$
    /ROW)
    
  ;label
  label = WIDGET_LABEL(row44,$
    VALUE = 'Output File')
    
  ;output folder
  path = WIDGET_BUTTON(row44,$
    VALUE = '~/results/',$
    SCR_XSIZE = 350,$
    UNAME = 'tab2_output_folder_button_uname',$
    SENSITIVE = 1)
    
  ;text
  file_name = WIDGET_TEXT(row44,$
    VALUE = '',$
    UNAME = 'tab2_output_file_name_text_field_uname',$
    SCR_XSIZE = 350,$
    /EDITABLE)
    
  ;space
  space = WIDGET_LABEL(row4,$
    VALUE = '     ')
    
  ;row5 .....................................................................
  row5 = WIDGET_BASE(Base,$
    /ROW)
    
  button1 = WIDGET_BUTTON(row5,$
    VALUE = 'Check Jobs Status',$
    xSIZE = 200,$
    UNAME = 'tab2_check_job_status_uname',$
    SENSITIVE = 1)
    
  space = WIDGET_LABEL(row5,$
    VALUE = '  ')
    
  button2 = WIDGET_BUTTON(row5,$
    VALUE = 'RUN JOBS',$
    XSIZE = 565,$
    UNAME = 'tab2_run_jobs_uname',$
    SENSITIVE = 0)
    
END



