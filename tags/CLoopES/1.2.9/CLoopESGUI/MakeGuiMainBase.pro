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

MainBaseSize = (*global).MainBaseSize

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

XYoff = [0,0]
sMainTabSize = {size : [XYoff[0], $
                        XYoff[1],$
                        MainBaseSize[2], $
                        MainBaseSize[3]],$
                uname : 'main_tab'}

;Tab titles
TabTitles = { tab1:  '   1/   L O O P E R   ',$
              tab2:  '   2/   E L A S T I C    S C A N   ',$
              tab3:  '   L O G  B O O K   '}

;******************************************************************************
;            BUILD GUI
;******************************************************************************

;build widgets

MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
                      UNAME     = sMainTabSize.uname,$
                      LOCATION  = 0,$
                      XOFFSET   = sMainTabSize.size[0],$
                      YOFFSET   = sMainTabSize.size[1],$
                      SCR_XSIZE = sMainTabSize.size[2],$
                      SCR_YSIZE = sMainTabSize.size[3],$
                      SENSITIVE = 1,$
                      /TRACKING_EVENTS)

;step1
make_gui_tab1, MAIN_TAB, sMainTabSize.size, TabTitles.tab1

;Elastic Scan
make_gui_tab2, MAIN_TAB, sMainTabSize.size, TabTitles.tab2

;Build LogBook
make_gui_tab3, MAIN_TAB, sMainTabSize.size, TabTitles.tab3

END