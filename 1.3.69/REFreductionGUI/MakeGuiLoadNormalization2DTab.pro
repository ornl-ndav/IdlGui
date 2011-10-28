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

PRO MakeGuiLoadNormalization2DTab, D_DD_Tab,$
                                   D_DD_BaseSize,$
                                   D_DD_TabTitle,$
                                   GlobalLoadGraphs

;Build 2D tab
load_normalization_DD_TAB_BASE = widget_base(D_DD_Tab,$
                                             uname='load_normalization_dd_tab_base',$
                                             title=D_DD_TabTitle[1],$
                                             xoffset=D_DD_BaseSize[0],$
                                             yoffset=D_DD_BaseSize[1],$
                                             scr_xsize=D_DD_BaseSize[2],$
                                             scr_ysize=D_DD_BaseSize[3])

load_normalization_DD_draw = widget_draw(load_normalization_DD_tab_base,$
                                         xoffset=GlobalLoadGraphs[4],$
                                         yoffset=GlobalLoadGraphs[5],$
                                         scr_xsize=GlobalLoadGraphs[6],$
                                         scr_ysize=GlobalLoadGraphs[7],$
                                         uname='load_normalization_DD_draw',$
                                         retain=2,$
                                         /button_events,$
                                         /motion_events)


END
