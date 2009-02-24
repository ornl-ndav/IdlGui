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

PRO MakeGuiLoadNormalization1D2DTab, LOAD_DATA_BASE,$
                                     D_DD_TabSize,$
                                     D_DD_BaseSize,$
                                     D_DD_TabTitle,$
                                     GlobalLoadGraphs,$
                                     loadctList

load_normalization_D_DD_Tab = WIDGET_TAB(LOAD_DATA_BASE,$
                                         UNAME='load_normalization_d_dd_tab',$
                                         LOCATION=1,$
                                         xoffset=D_DD_TabSize[0],$
                                         yoffset=D_DD_TabSize[1]+5,$
                                         scr_xsize=D_DD_TabSize[2],$
                                         scr_ysize=D_DD_TabSize[3],$
                                         /tracking_events)

;build Load_Data_1D tab
MakeGuiLoadNormalization1DTab,$
  load_normalization_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs,$
  loadctList

 MakeGuiLoadNormalization1D_3D_Tab,$
   load_normalization_D_DD_Tab,$
   D_DD_BaseSize,$
   D_DD_TabTitle,$
   GlobalLoadGraphs,$
   loadctList

;build Load_Data_2D tab
MakeGuiLoadNormalization2DTab,$
  load_normalization_D_DD_Tab,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadGraphs

 MakeGuiLoadNormalization2D_3D_Tab,$
   load_normalization_D_DD_Tab,$
   D_DD_BaseSize,$
   D_DD_TabTitle,$
   GlobalLoadGraphs,$
   loadctlist

END
