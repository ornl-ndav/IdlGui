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

PRO make_gui_Reduce_step1, REDUCE_TAB, sTab, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBase = { size:  stab.size,$
          uname: 'reduce_step1_tab_base',$
          title: TabTitles.step1}

;******************************************************************************
;            BUILD GUI
;******************************************************************************

TopBase = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = 'reduce_step1_top_base',$
                      XOFFSET   = sBase.size[0],$
                      YOFFSET   = sBase.size[1],$
                      SCR_XSIZE = sBase.size[2],$
                      SCR_YSIZE = sBase.size[3],$
                      TITLE     = sBase.title)

;list of polarization states --------------------------------------------------
wPolaBase = WIDGET_BASE(TopBase,$
                        XOFFSET   = 400,$
                        YOFFSET   = 130,$
                        SCR_XSIZE = 300,$
                        SCR_YSIZE = 180,$
                        UNAME     = 'reduce_tab1_polarization_base',$
                        FRAME     = 10,$
                        MAP       = 0,$
                        /COLUMN,$
                        /BASE_ALIGN_CENTER)

wLabel = WIDGET_LABEL(wPolaBase,$
                      VALUE = 'Select the Polarization State You Want to Use:')
                        
ColumnBase = WIDGET_BASE(wPolaBase,$
                         /COLUMN,$
                         /BASE_ALIGN_TOP,$
                         /EXCLUSIVE,$
                         UNAME = 'reduce_tab1_pola_base_list_of_pola_state')

button1 = WIDGET_BUTTON(ColumnBase,$
                        VALUE = 'Off-Off  ',$
                        UNAME = 'reduce_tab1_pola_base_pola_1',$
                        SENSITIVE = 1)
button2 = WIDGET_BUTTON(ColumnBase,$
                        VALUE = 'Off-On  ',$
                        UNAME = 'reduce_tab1_pola_base_pola_2',$
                        SENSITIVE = 1)
button3 = WIDGET_BUTTON(ColumnBase,$
                        VALUE = 'On-Off  ',$
                        UNAME = 'reduce_tab1_pola_base_pola_3',$
                        SENSITIVE = 1)
button4 = WIDGET_BUTTON(ColumnBase,$
                        VALUE = 'On-On  ',$
                        UNAME = 'reduce_tab1_pola_base_pola_4',$
                        SENSITIVE = 1)


okButton = WIDGET_BUTTON(wPolaBase,$
                         VALUE = 'OK',$
                         SCR_XSIZE = 250,$
                         UNAME = 'reduce_tab1_pola_base_valid_button')

;Main base --------------------------------------------------------------------
Base = WIDGET_BASE(TopBase,$
                   UNAME     = sBase.uname,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = sBase.size[2],$
                   SCR_YSIZE = sBase.size[3],$
                   /BASE_ALIGN_LEFT,$
                   /COLUMN)

;Vertical space
vSpace = Widget_label(Base,$
                      VALUE = '',$
                      YSIZE = 15)

;Load New Entry (row #1) ------------------------------------------------------
Row1 = WIDGET_BASE(Base,$
                   /ROW,$
                   SCR_XSIZE = 680,$
                   FRAME = 0)

lLoad = WIDGET_LABEL(Row1,$
                     VALUE = '     Load New Entry into Table   ')

bBrowse = WIDGET_BUTTON(Row1,$
                        VALUE = '  BROWSE...  ',$
                        UNAME = 'reduce_tab1_browse_button')

lOrRun = WIDGET_LABEL(Row1,$
                      VALUE = '  or   Run #:')

tRun = CW_FIELD(Row1,$
                XSIZE = 15,$
                UNAME = 'reduce_tab1_run_cw_field',$
                TITLE = '',$
                /INTEGER)
                
base_group = WIDGET_BASE(Row1,$
                         /ROW)

list_OR_archived = CW_BGROUP(base_group,$
                             ['Archived','Full List'],$
                             /EXCLUSIVE,$
                             /ROW,$
                             SET_VALUE = 0,$
                             uname = 'reduce_tab1_archived_cw_bgroup')


;Table (Row #2) ---------------------------------------------------------------
Row2 = WIDGET_BASE(Base,$
                   /ROW)
                   
space = WIDGET_LABEL(Row2,$
                     VALUE = '  ')

table = WIDGET_TABLE(Row2,$
                     COLUMN_LABELS = ['Run #',$
                                      'Full NeXus File Name',$
                                      'Polarization State'],$
                     UNAME = 'reduce_tab1_table_uname',$
                     /NO_ROW_HEADERS,$
                     /RESIZEABLE_COLUMNS,$
                     ALIGNMENT = 0,$
                     XSIZE = 3,$
                     YSIZE = 1,$
                     SCR_XSIZE = 1230,$
                     SCR_YSIZE = 400,$
                     COLUMN_WIDTHS = [100,955,150],$
                     /SCROLL,$
                     /ALL_EVENTS)

WIDGET_CONTROL, table, SET_TABLE_SELECT=[0,0,2,0]

;Button (Row #3) --------------------------------------------------------------
Row3 = WIDGET_BASE(Base,$
                   /ROW)

button1 = WIDGET_BUTTON(Row3,$
                        VALUE = 'Remove Selected Run',$
                        UNAME = 'reduce_step1_remove_selection_button',$
                        SENSITIVE = 0)

button2 = WIDGET_BUTTON(Row3,$
                        VALUE = 'Display Y vs TOF of Selected Run',$
                        UNAME = 'reduce_step1_display_y_vs_tof_button',$
                        SENSITIVE = 0)

button3 = WIDGET_BUTTON(Row3,$
                        VALUE = 'Display Y vs X of Selected Run',$
                        UNAME = 'reduce_step1_display_y_vs_x_button',$
                        SENSITIVE = 0)

;Repeat work for other polarization states (Row #4) ---------------------------
Row4 = WIDGET_BASE(Base,$
                   UNAME = 'reduce_tab1_row4_base',$
                   FRAME = 1,$
                   /ROW)

label = WIDGET_LABEL(Row4,$
                     VALUE = 'Working with Polarization State:')
label = WIDGET_LABEL(Row4,$
                     VALUE = 'N/A                     ',$
                     /ALIGN_LEFT,$
                     UNAME = 'reduce_tab1_working_polarization_state_label',$
                     FRAME = 0)
                    
label = WIDGET_LABEL(Row4,$
                     VALUE = 'Repeat work with Polarization States:  ')

Row4Base = WIDGET_BASE(Row4,$
                       /ROW,$
                       /BASE_ALIGN_TOP,$
                       /NONEXCLUSIVE)

button1 = WIDGET_BUTTON(Row4Base,$
                        VALUE = 'Off-Off  ',$
                        UNAME = 'reduce_tab1_pola_1',$
                        SENSITIVE = 1)
button2 = WIDGET_BUTTON(Row4Base,$
                        VALUE = 'Off-On  ',$
                        UNAME = 'reduce_tab1_pola_2',$
                        SENSITIVE = 1)
button3 = WIDGET_BUTTON(Row4Base,$
                        VALUE = 'On-Off  ',$
                        UNAME = 'reduce_tab1_pola_3',$
                        SENSITIVE = 1)
button4 = WIDGET_BUTTON(Row4Base,$
                        VALUE = 'On-On  ',$
                        UNAME = 'reduce_tab1_pola_4',$
                        SENSITIVE = 1)

    

END
