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

PRO make_gui_step4, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step4_tab_base',$
             title: TabTitles.step4}
                         
;TabTitles
  ; Code change RCW (Dec 30, 2009): get ScalingTabNames from XML config file (via ref_off_spec)
  ; and populate TabTitlesLocal

ScalingTabNames = (*global).ScalingTabNames
TabTitlesLocal = { range_selection: ScalingTabNames[0],$
                   scaling:         ScalingTabNames[1]}

;Inside Tab (range selection, scaling...)
XYoff = [0,0]
sMainTab = { size: [XYoff[0],$
                    XYoff[1],$
                    sBaseTab.size[2],$
                    sBaseTab.size[3]-XYoff[1]],$
             uname: 'scaling_main_tab'}

;******************************************************************************
;            BUILD GUI
;******************************************************************************
; Code Change (RC Ward, Mar 31, 2010): Add SCROLL capability to the WIDGET_BASE BaseTab
BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab.uname,$
                      XOFFSET   = sBaseTab.size[0],$
                      YOFFSET   = sBaseTab.size[1],$
                      SCR_XSIZE = sBaseTab.size[2],$
                      SCR_YSIZE = sBaseTab.size[3],$
                      TITLE     = sBaseTab.title, $
                      /SCROLL)

;Main Tab inside base ---------------------------------------------------------
MAIN_TAB = WIDGET_TAB(BaseTab,$
                      UNAME     = sMainTab.uname,$
                      LOCATION  = 0,$
                      XOFFSET   = sMainTab.size[0],$
                      YOFFSET   = sMainTab.size[1],$
                      SCR_XSIZE = sMainTab.size[2],$
                      SCR_YSIZE = sMainTab.size[3],$
                      SENSITIVE = 1,$
                      /TRACKING_EVENTS)

;Pixel Range Selection --------------------------------------------------------
;Change made: pass global to make_gui_scaling_step1 (RC Ward, Feb 11, 2010)
make_gui_scaling_step1, MAIN_TAB, sMainTab.size, TabTitlesLocal, global

;Scaling ----------------------------------------------------------------------
make_gui_scaling_step2, MAIN_TAB, sMainTab.size, TabTitlesLocal, global

END
