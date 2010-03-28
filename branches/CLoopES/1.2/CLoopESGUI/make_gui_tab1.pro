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

PRO make_gui_tab1, MAIN_TAB, MainTabSize, title

  Base = WIDGET_BASE(MAIN_TAB,$
    UNAME     = 'tab1_uname',$
    XOFFSET   = MainTabSize[0],$
    YOFFSET   = MainTabSize[1],$
    SCR_XSIZE = MainTabSize[2],$
    SCR_YSIZE = MainTabSize[3],$
    TITLE     = title,$
    MAP       = 1)
    
  ;input example
  ex = WIDGET_LABEL(Base,$
    XOFFSET = 540,$
    YOFFSET = 265,$
    VALUE   = '(Ex: 3741-3749,[3750,3760-3763],3800)')
    
  error_base = WIDGET_BASE(Base,$
  XOFFSET = 160,$
  YOFFSET = 300,$
  FRAME = 5,$
  /COLUMN,$
  MAP = 0,$
  UNAME = 'tab1_error_base')
  
  error = WIDGET_DRAW(error_base,$
  SCR_XSIZE = 419,$
  SCR_YSIZE = 316,$
  UNAME = 'error_draw')
  label = WIDGET_LABEL(error_base,$
  FRAME = 1,$
  VALUE = '>  > >> Make sure the new list of runs have the same size! << <  <')

  tab1 = WIDGET_BASE(Base,/COLUMN)
  
  row1 = WIDGET_BASE(tab1,/ROW)
  wLoad = WIDGET_BUTTON(row1,$ ;load button
    SCR_XSIZE = 150,$
    UNAME     = 'load_cl_file_button',$
    VALUE     = 'BROWSE CL FILE ...')
  wLabel1 = WIDGET_LABEL(row1,$ ;File Name Labels
    VALUE = 'CL File Loaded:')
  wLabel2 = WIDGET_LABEL(row1,$
    SCR_XSIZE = 530,$
    VALUE     = 'N/A',$
    UNAME     = 'cl_file_name_label',$
    /ALIGN_LEFT)
    
  row2 = WIDGET_LABEL(tab1,$
    VALUE = 'Preview of CL file loaded')
  row3 = WIDGET_TEXT(tab1,$ ;Preview of CL file text box
    SCR_XSIZE = 785,$
    SCR_YSIZE = 90,$
    UNAME     = 'preview_cl_file_text_field',$
    /SCROLL,$
    /ALL_EVENTS,$
    /tracking_events,$
    event_pro = 'input_text_tab1',$
    /WRAP)
    
  row4 = WIDGET_BASE(tab1,$
    /ROW)
  row4_col2_row1 = WIDGET_BASE(row4,$
    /ROW)
  button1 = WIDGET_BUTTON(row4,$
    VALUE = '>>>>>>>>',$
    UNAME = 'selection_1')
  text  = WIDGET_LABEL(row4,$
    VALUE = ' ',$
    SCR_XSIZE = 310,$
    FRAME=1,$
    UNAME = 'selection_1_to_replaced')
  button = WIDGET_BUTTON(row4,$
    VALUE= 'X',$
    UNAME = 'selection_1_to_replaced_clear',$
    SENSITIVE=0)
  label = WIDGET_LABEL(row4,$
    SENSITIVE = 0,$
    UNAME = 'selection_1_replaced_by_label',$
    VALUE = 'will be replaced by')
  text  = WIDGET_TEXT(row4,$
    VALUE = '',$
    XSIZE = 37,$
    /EDITABLE,$
    SENSITIVE = 0,$
    UNAME = 'selection_1_replaced_by')
  button = WIDGET_BUTTON(row4,$
    VALUE = 'X',$
    UNAME = 'selection_1_replaced_by_clear',$
    SENSITIVE=0)
    
  row5 = WIDGET_BASE(tab1,$
    /ROW)
  row5_col2_row1 = WIDGET_BASE(row5,$
    /ROW)
  button1 = WIDGET_BUTTON(row5,$
    VALUE = '        ',$
    UNAME = 'selection_2')
  text  = WIDGET_LABEL(row5,$
    VALUE = ' ',$
    SCR_XSIZE = 310,$
    FRAME=1,$
    UNAME = 'selection_2_to_replaced')
  button = WIDGET_BUTTON(row5,$
    VALUE= 'X',$
    UNAME = 'selection_2_to_replaced_clear',$
    SENSITIVE=0)
  label = WIDGET_LABEL(row5,$
    SENSITIVE = 0,$
    UNAME = 'selection_2_replaced_by_label',$
    VALUE = 'will be replaced by')
  text  = WIDGET_TEXT(row5,$
    VALUE = '',$
    XSIZE = 37,$
    /EDITABLE,$
    SENSITIVE = 0,$
    UNAME = 'selection_2_replaced_by')
  button = WIDGET_BUTTON(row5,$
    VALUE = 'X',$
    UNAME = 'selection_2_replaced_by_clear',$
    SENSITIVE=0)
    
  row6 = WIDGET_BASE(tab1,$
    /ROW)
  row6_col2_row1 = WIDGET_BASE(row6,$
    /ROW)
  button1 = WIDGET_BUTTON(row6,$
    VALUE = '        ',$
    UNAME = 'selection_3')
  text  = WIDGET_LABEL(row6,$
    VALUE = ' ',$
    SCR_XSIZE = 310,$
    FRAME=1,$
    UNAME = 'selection_3_to_replaced')
  button = WIDGET_BUTTON(row6,$
    VALUE= 'X',$
    UNAME = 'selection_3_to_replaced_clear',$
    SENSITIVE=0)
  label = WIDGET_LABEL(row6,$
    SENSITIVE = 0,$
    UNAME = 'selection_3_replaced_by_label',$
    VALUE = 'will be replaced by')
  text  = WIDGET_TEXT(row6,$
    VALUE = '',$
    XSIZE = 37,$
    /EDITABLE,$
    SENSITIVE = 0,$
    UNAME = 'selection_3_replaced_by')
  button = WIDGET_BUTTON(row6,$
    VALUE = 'X',$
    UNAME = 'selection_3_replaced_by_clear',$
    SENSITIVE=0)
    
  recap_label = WIDGET_LABEL(tab1,$
    /ALIGN_LEFT,$
    UNAME = 'runs_table_label',$
    SENSITIVE = 0,$
    VALUE = '                  R E C A P   T A B L E ')
    
  ;Table
  wTable = WIDGET_TABLE(tab1,$
    SCR_XSIZE = 780,$
    SCR_YSIZE = 410,$
    XSIZE     = 4,$
    YSIZE     = 1,$
    SENSITIVE = 0,$
    COLUMN_WIDTHS = [80,80,80,1500],$
    /NO_ROW_HEADERS,$
    COLUMN_LABELS = ['Selection 1','Selection 2','Selection 3',$
    'Command Line Preview                                               '+$
    '                                                                   '+$
    '                                                                   '],$
    /SCROLL,$
    /RESIZEABLE_COLUMNS,$
    UNAME = 'runs_table')
    
  row7 = WIDGET_BASE(tab1,$
    /ROW)
    
  button1 = WIDGET_BUTTON(row7,$
    VALUE = 'Check Status of Jobs Submitted ...',$
    UNAME = 'check_status_button',$
    SCR_XSIZE = 250)
    
  button2 = WIDGET_BUTTON(row7,$
    VALUE = 'Preview/Save as  Jobs ...',$
    UNAME = 'preview_jobs_button',$
    SENSITIVE = 0,$
    SCR_XSIZE = 200)
    
  button3 = WIDGET_BUTTON(row7,$
    VALUE = 'L A U N C H    J O B S    I N    B A C K G R O U N D',$
    UNAME = 'run_jobs_button',$
    SENSITIVE = 0,$
    SCR_XSIZE = 325)
    
END




