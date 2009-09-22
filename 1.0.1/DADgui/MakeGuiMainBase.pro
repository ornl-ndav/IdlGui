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

PRO MakeGuiMainBase, MAIN_BASE, global

  id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  BASE = WIDGET_BASE(MAIN_BASE,$
    /COLUMN)
    
  vert_space = WIDGET_LABEL(BASE,$
    VALUE = '')
    
    
  ;INPUT DAVE ASCII FILES ************************************************
  row_a = WIDGET_BASE(base,$
    /COLUMN,$
    FRAME = 1)
    
  row_a_0 = WIDGET_BASE(row_a,$
    /ALIGN_CENTER,$
    /COLUMN,$
    FRAME = 0)
    
  ;label of first frame
  text = '*******************'
  label = WIDGET_LABEL(row_a_0,$
    SCR_XSIZE = main_base_geometry.xsize - 30,$
    VALUE = text + '  Input  Dave  Ascii  Files  (produced by regular' + $
    ' data reduction or by  step 1  of  CLoopES) ' + text)
    
  row_a_1 = WIDGET_BASE(row_a, $ ;------------------ row1
    /ROW)
    
  label = WIDGET_LABEL(row_a_1,$
    VALUE = 'Folder')
    
  button = WIDGET_BUTTON(row_a_1,$
    VALUE = '~/results/',$
    SCR_XSIZE = 330,$
    UNAME = 'browse_path_button')
    
  label = WIDGET_LABEL(row_a_1,$
    VALUE = 'File Name:')
    
  ;internal_base
  inter_base = WIDGET_BASE(row_a_1,$
    /ROW,$
    FRAME = 1)
    
  text = WIDGET_TEXT(inter_base,$
    VALUE = 'BASIS',$
    UNAME = 'input_suffix_name',$
    /EDITABLE,$
    XSIZE = 20)
    
  label = WIDGET_LABEL(inter_base,$
    VALUE = '_<User_Defined>.')
    
  text = WIDGET_TEXT(inter_base,$
    VALUE = 'dat',$
    UNAME = 'input_prefix_name',$
    /EDITABLE,$
    XSIZE = 10)
    
  row_a_2 = WIDGET_BASE(row_a, $ ;----------------row2
    /ROW)
    
  label = WIDGET_LABEL(row_a_2,$
    VALUE = '<User_Defined>')
    
  text = WIDGET_TEXT(row_a_2,$
    VALUE = '',$
    XSIZE = 107,$
    /EDITABLE,$
    UNAME = 'input_sequence')
    
  help = WIDGET_BUTTON(row_a_2,$
    VALUE = '?',$
    UNAME = 'input_sequence_help',$
    /PUSHBUTTON_EVENTS)
    
  ;***********************************************************************
    
  ;row2 (big table)
  row2 = WIDGET_BASE(Base,$
    /ROW)
    
;    big_table = [['~/results/BASIS_5768_1run.dat','','~/results/BASIS_5768_1run_divided.dat',''],$
;    ['~/results/BASIS_5769_1run.dat','','~/results/BASIS_5769_1run_divided.dat','']]
    
  Table = WIDGET_TABLE(row2,$
    UNAME = 'table_uname',$
    XSIZE = 4,$
    YSIZE = 200,$
    SCR_XSIZE = 785,$
    SCR_YSIZE = 320,$
    ;    /SCROLL,$
    EDITABLE = [1,0,1,0],$ ;output file  is editable
    COLUMN_WIDTHS = [300,70,300,90],$
;    VALUE = big_table, $ ;REMOVE_ME
    /NO_ROW_HEADERS,$
    COLUMN_LABELS = ['Input Files','Exist?','Output Files','Run Status'],$
    /RESIZEABLE_COLUMNS)
    
  ;row3
  row3 = WIDGET_BASE(Base,$
    /ROW)
    
  button1 = WIDGET_BUTTON(row3,$
    VALUE = 'REFRESH TABLE (check status of files)',$
    UNAME = 'refresh_table_uname',$
    XSIZE = 785,$
    SENSITIVE = 0)
    
    
  ;ELASTIC SCAN ASCII FILE ***************************************************
  row_a = WIDGET_BASE(base,$
    /COLUMN,$
    FRAME = 1)
    
  row_a_0 = WIDGET_BASE(row_a,$
    /ALIGN_CENTER,$
    /COLUMN,$
    FRAME = 0)
    
  ;label of first frame
  text = '*********************************'
  label = WIDGET_LABEL(row_a_0,$
    SCR_XSIZE = main_base_geometry.xsize - 30,$
    VALUE = text + '  Elastic  Scan  ASCII  File (produced by ' + $
    ' step 2  of  CLoopES) ' + text)
    
  row_a_1 = WIDGET_BASE(row_a, $ ;------------------ row1
    /ROW)
    
  button = WIDGET_BUTTON(row_a_1,$
    VALUE = 'BROWSE',$
    SCR_XSIZE = 100,$
    UNAME = 'browse_es_file_button')
    
  text = WIDGET_TEXT(row_a_1,$
    VALUE = '',$
    UNAME = 'es_input_file_name',$
    XSIZE = 110,$
    /EDITABLE)
    
  row_a_2 = WIDGET_BASE(row_a, $ ;----------------row2
    /ROW)
    
  label = WIDGET_LABEL(row_a_2,$
    VALUE = 'ES File Name:')
    
  label = WIDGET_LABEL(row_a_2,$
    VALUE = 'N/A',$
    ;VALUE = '/Users/j35/results/D2O_50_ElasticScan_1T.txt', $ 
    SCR_XSIZE = 580,$
    UNAME = 'es_file_name',$
    /ALIGN_LEFT)
    
  help = WIDGET_BUTTON(row_a_2,$
    VALUE = 'PREVIEW / EDIT',$
    SCR_XSIZE = 110,$
    SENSITIVE = 0,$
    UNAME = 'es_file_preview_button')
    
  ;**************************************************************************
    
  ;last base
  row3 = WIDGET_BASE(Base,$
    /ROW)
    
  quit = WIDGET_BUTTON(row3,$
    VALUE = 'Q U I T',$
    UNAME = 'quit_uname')
    
  text = '                                            '
  text = text + '                                             '
  space = WIDGET_LABEL(row3,$
    VALUE = text)
    
  run = WIDGET_BUTTON(row3,$
    VALUE = ' R U N   D I V I S I I O N S ',$
    UNAME = 'run_uname',$
    SENSITIVE = 1) ;remove_me 0
    
END