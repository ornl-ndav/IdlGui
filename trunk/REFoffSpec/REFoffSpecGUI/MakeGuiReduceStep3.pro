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

  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************

  sBase = { size:  stab.size,$
    uname: 'reduce_step3_tab_base',$
    title: TabTitles.step3}
    
  ;******************************************************************************
  ;            BUILD GUI
  ;******************************************************************************
    
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
    VALUE = ' ')
    
  main_table = WIDGET_TABLE(column_base,$
    COLUMN_LABELS = ['DATA Run',$
    'DATA NeXus',$
    'D. Spin State',$
    'NORM. Run',$
    'NORM. NeXus',$
    'N. Spin State',$
    'ROI',$
    'Output Path',$
    'Output File'],$
    UNAME = 'reduce_tab2_main_spin_state_table_uname',$
    /NO_ROW_HEADERS,$
    /RESIZEABLE_COLUMNS,$
    ALIGNMENT = 0,$
    XSIZE = 9,$
    YSIZE = 40,$
    SCR_XSIZE = 1260,$
    SCR_YSIZE = 750,$
    COLUMN_WIDTHS = [55,300,90,70,300,90,300,200,240],$
    /SCROLL,$
    /EDITABLE,$
    /ALL_EVENTS)
    

END
