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

PRO make_gui_Reduce_step3, REDUCE_TAB, sTab, TabTitles, global

  ;****************************************************************************
  ;            DEFINE STRUCTURE
  ;****************************************************************************

  tab_title = TabTitles.step3 
  sBase = { size:  stab.size,$
    uname: 'reduce_step3_tab_base',$
    title: tab_title}
    
  instrument = (*global).instrument
  number_of_sangle = (*global).number_of_sangle
  
  ;****************************************************************************
  ;            BUILD GUI
  ;****************************************************************************
; Change code (RC Ward, Apr 6): Create scrollable wmain window  
  Base = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBase.uname,$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = sBase.title)
    
  column_base = WIDGET_BASE(Base,$
    /COLUMN,$
    /BASE_ALIGN_LEFT)
    
  space = WIDGET_LABEL(column_base,$
    VALUE = 'Table will refresh itself each time this Step 3 is reached.' + $
    ' You are free to edit this table but be aware that ' + $
    'your changes will be lost if you move out of this tab before '  + $
    'launching the jobs.')
    
  IF (instrument EQ 'REF_M') THEN BEGIN
    COLUMN_LABELS = ['DATA Run',$
      'DATA NeXus',$
      'Sangle [rad(deg)]',$
      'D. Spin State',$
      'NORM. Run',$
      'NORM. NeXus',$
      'N. Spin State',$
      'Norm. Peak ROI',$
      'Data Background ROI', $
      'Norm. Background ROI', $
      'Output File Name']
    xsize = 11
    column_widths = [55,300,140,90,70,300,90,300,300,300,300]
    scr_xsize = 1260
  ENDIF ELSE BEGIN
    COLUMN_LABELS = ['DATA Run',$
      'DATA NeXus',$
      'NORM. Run',$
      'NORM. NeXus',$
      'ROI',$
      'Output File Name']
    xsize = 6
    column_widths = [55,340,70,340,360,360]
    scr_xsize = 1260
  ENDELSE
  
  main_table = WIDGET_TABLE(column_base,$
    COLUMN_LABELS = column_labels,$
    UNAME = 'reduce_tab3_main_spin_state_table_uname',$
    /NO_ROW_HEADERS,$
    /RESIZEABLE_COLUMNS,$
    ALIGNMENT = 0,$
    XSIZE = xsize,$
; Change code (RC Ward, April 7, 2010): Varible number_of_sangle is passed in confguration file
;    YSIZE = 40,$
    YSIZE = 2*number_of_sangle,$
    SCR_XSIZE = scr_xsize,$
; Change code (RC Ward, April 7, 2010): Decrease vertical size of window
    SCR_YSIZE = 500,$
    COLUMN_WIDTHS = column_widths,$
    /SCROLL,$
    /EDITABLE,$
    SENSITIVE = 1,$
    /ALL_EVENTS)
    
  space = WIDGET_LABEL(column_base,$
    VALUE = ' ')
    
  row = WIDGET_BASE(column_base,$
    /ROW)
    
  base1 = WIDGET_BASE(row,$
    /ROW)
    
  ;output folder label
  label = WIDGET_LABEL(base1,$
;    VALUE = 'Output Folder:')
     VALUE = 'Reduce Folder:')    
  ;output folder button
  ascii_path = (*global).ascii_path
  output = WIDGET_BUTTON(base1,$
;    VALUE = '~/results/',$
     VALUE = ascii_path, $
    SCR_XSIZE = 400,$
    UNAME = 'reduce_tab3_output_folder_button')
    
  ;space
  space = WIDGET_LABEL(row,$
    VALUE = '                           ')
    
  jobs = WIDGET_BUTTON(row,$
    VALUE = 'RUN JOBS',$
    SCR_XSIZE = 200,$
    SENSITIVE = 0,$
    UNAME = 'reduce_tab3_run_jobs',$
    FRAME = 5)
    
  jobs_plot = WIDGET_BUTTON(row,$
    VALUE = 'RUN JOBS and PLOT',$
    SCR_XSIZE = 200,$
    SENSITIVE = 0,$
    uname = 'reduce_tab3_run_jobs_and_plot',$
    FRAME = 5)
    
  status = WIDGET_BUTTON(row,$
    VALUE = 'CHECK JOB MANAGER',$
    SCR_XSIZE = 150,$
    UNAME = 'reduce_tab3_check_jobs',$
    FRAME = 5)
    
    
END
