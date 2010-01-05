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

PRO make_gui_step1, REDUCE_TAB, tab_size, TabTitles, global

  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************

  sBase = { size:  tab_size,$
    uname: 'step1_tab_base',$
    title: TabTitles.step1}
    
  ;Reduce Tab
  XYoff = [0,0]
  sTab = { size: [XYoff[0],$
    XYoff[1],$
    tab_size[2],$
    tab_size[3]],$
    uname: 'reduce_tab',$
    location: 0,$
    sensitive: 1 }
    
  ;Tab titles
  ; Code change RCW (Dec 30, 2009): get ReduceTabNames from XML config file (via ref_off_spec)
  ; and populate ReduceTabTitles

  ReduceTabNames = (*global).ReduceTabNames
  ReduceTabTitles = { step1: ReduceTabNames[0],$
                          step2: ReduceTabNames[1],$
                          step3: ReduceTabNames[2]} 
  
  ;******************************************************************************
  ;            BUILD GUI
  ;******************************************************************************
  
  Base1 = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBase.uname,$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = sBase.title)
    
  REDUCE_STEPS_TAB = WIDGET_TAB(Base1,$
    UNAME     = sTab.uname,$
    LOCATION  = sTab.location,$
    XOFFSET   = sTab.size[0],$
    YOFFSET   = sTab.size[1],$
    SCR_XSIZE = sTab.size[2],$
    SCR_YSIZE = sTab.size[3],$
    SENSITIVE = sTab.sensitive,$
    /TRACKING_EVENTS)
    
    
  ;reduce_step1
  make_gui_reduce_step1, REDUCE_STEPS_TAB, sTab, ReduceTabTitles, global
  
  ;reduce_step2
  make_gui_reduce_step2, REDUCE_STEPS_TAB, sTab, ReduceTabTitles, global
  
  ;reduce_step3
  make_gui_reduce_step3, REDUCE_STEPS_TAB, sTab, ReduceTabTitles, global
  
END
