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

PRO miniMakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTabTitle, PlotsTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
ReduceTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]
IndividualBaseWidth = 580

;Build widgets
REDUCE_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME     = 'reduce_base',$
                          TITLE     = ReduceTabTitle,$
                          XOFFSET   = ReduceTabSize[0],$
                          YOFFSET   = ReduceTabSize[1],$
                          SCR_XSIZE = ReduceTabSize[2],$
                          SCR_YSIZE = ReduceTabSize[3])

;create data base
miniMakeGuiReduceDataBase, Event, REDUCE_BASE, IndividualBaseWidth

;create normalization base
miniMakeGuiReduceNormalizationBase, Event, REDUCE_BASE, IndividualBaseWidth

;create Q base
miniMakeGuiReduceQBase, Event, REDUCE_BASE, IndividualBaseWidth

;create detector angle
miniMakeGuiReduceDetectorBase, Event, REDUCE_BASE, IndividualBaseWidth

;create intermediate plot base
miniMakeGuiReduceIntermediatePlotBase, Event, REDUCE_BASE, IndividualBaseWidth, PlotsTitle

;create other component of base
miniMakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth

;create GeneralInfoTextField
miniMakeGuiReduceInfo, Event, REDUCE_BASE

END
