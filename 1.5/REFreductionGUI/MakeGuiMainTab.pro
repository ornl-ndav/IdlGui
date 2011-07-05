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
PRO MakeGuiMainTab, MAIN_BASE, $
                    MainBaseSize, $
                    instrument, $
                    PlotsTitle, $
                    structure
                    
;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

WIDGET_CONTROL,MAIN_BASE,GET_UVALUE=global

;Tab titles
LoadTabTitle     = '       LOAD       ' 
ReduceTabTitle   = '      REDUCE      ' 
PlotsTabTitle    = '       PLOTS      ' 
BatchTabTitle    = '    BATCH MODE    ' 
LogBookTabTitle  = '     LOG BOOK     ' 


;build widgets
MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
                      UNAME='main_tab',$
                      LOCATION=0,$
                      XOFFSET=MainTabSize[0],$
                      YOFFSET=MainTabSize[1],$
                      SCR_XSIZE=MainTabSize[2],$
                      SCR_YSIZE=MainTabSize[3],$
                      /TRACKING_EVENTS,$
                      sensitive=1)

;first tab selected
;widget_control, Main_Tab, set_tab_current = 0 ;LOAD

;build LOAD tab
MakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle, instrument, MAIN_BASE

;build REDUCE tab
MakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTabTitle, PlotsTitle, global

;build PLOTS tab
MakeGuiPlotsTab, MAIN_TAB, MainTabSize, PlotsTabTitle, PlotsTitle

;build BATCH MODE tab
MakeGuiBatchTab, MAIN_TAB, MainTabSize, BatchTabTitle, structure

;build LOG_BOOK tab
MakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle



END
