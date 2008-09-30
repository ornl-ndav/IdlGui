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

PRO make_gui_scaling_step2, REDUCE_TAB, tab_size, TabTitles

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step4_step2_base',$
             title: TabTitles.scaling}
                         
;Main Draw of step 4 ----------------------------------------------------------
XYoff = [5,5]
sStep4Draw = { size: [XYoff[0],$
                      XYoff[1],$
                      700,700],$
               uname: 'draw_step4_step2'}

;tab of step4/step2 -----------------------------------------------------------
XYoff = [5,5]
sMainTab = { size: [sStep4Draw.size[0]+$
                          sStep4Draw.size[2]+$
                          XYoff[0],$
                          XYoff[1],$
                          555,800],$
                   uname: 'step4_step2_tab'}
                        
TabTitles = { critical_edge: 'Critical Edge',$
              other_files: 'Scaling of Other Files'}

;******************************************************************************
;            BUILD GUI
;******************************************************************************

BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab.uname,$
                      XOFFSET   = sBaseTab.size[0],$
                      YOFFSET   = sBaseTab.size[1],$
                      SCR_XSIZE = sBaseTab.size[2],$
                      SCR_YSIZE = sBaseTab.size[3],$
                      TITLE     = sBaseTab.title)

;Main Draw of step 4 ----------------------------------------------------------
wStep4Draw = WIDGET_DRAW(BaseTab,$
                         XOFFSET   = sStep4Draw.size[0],$
                         YOFFSET   = sStep4Draw.size[1],$
                         SCR_XSIZE = sStep4Draw.size[2],$
                         SCR_YSIZE = sStep4Draw.size[3],$
                         UNAME     = sStep4Draw.uname,$
                         /BUTTON_EVENTS,$
                         /MOTION_EVENTS)

;step4/step2 tab (CE and SF of all other files)                         
MAIN_TAB = WIDGET_TAB(BaseTab,$
                      UNAME     = sMainTab.uname,$
                      LOCATION  = 0,$
                      XOFFSET   = sMainTab.size[0],$
                      YOFFSET   = sMainTab.size[1],$
                      SCR_XSIZE = sMainTab.size[2],$
                      SCR_YSIZE = sMainTab.size[3],$
                      SENSITIVE = 1,$
                      /TRACKING_EVENTS)

;Critical Edge
make_gui_scaling_step2_step1, MAIN_TAB, sMainTab.size, TabTitles

;Other Files
make_gui_scaling_step2_step2, MAIN_TAB, sMainTab.size, TabTitles


END
